let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ofday_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ofday_helpers.ml.before-ppx"
;;

open! Import
open Std_internal
open Digit_string_helpers

let suffixes char =
  let sprintf = Printf.sprintf in
  List.concat_map
    ~f:(fun suffix -> [ String.lowercase suffix; String.uppercase suffix ])
    [ sprintf "%c" char; sprintf "%cM" char; sprintf "%c.M" char; sprintf "%c.M." char ]
;;

let am_suffixes = lazy (suffixes 'A')
let pm_suffixes = lazy (suffixes 'P')

let rec find_suffix string suffixes =
  match suffixes with
  | suffix :: suffixes ->
    if String.is_suffix string ~suffix then suffix else find_suffix string suffixes
  | [] -> ""
;;

let has_colon string pos ~until = pos < until && Char.equal ':' string.[pos]
let char_is_decimal_point string pos = Char.equal '.' string.[pos]

let decrement_length_if_ends_in_space string len =
  if len > 0 && Char.equal ' ' string.[len - 1] then len - 1 else len
;;

let invalid_string string ~reason =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Time.Ofday: invalid string"
         ; Ppx_sexp_conv_lib.Conv.sexp_of_string string
         ; Ppx_sexp_conv_lib.Conv.sexp_of_string reason
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let check_digits_with_underscore_and_return_if_nonzero string pos ~until =
  let nonzero = ref false in
  for pos = pos to until - 1 do
    match string.[pos] with
    | '0' | '_' -> ()
    | '1' .. '9' -> nonzero := true
    | _ ->
      invalid_string
        string
        ~reason:"expected digits and/or underscores after decimal point"
  done;
  !nonzero
;;

let check_digits_without_underscore_and_return_if_nonzero string pos ~until =
  let nonzero = ref false in
  for pos = pos to until - 1 do
    match string.[pos] with
    | '0' -> ()
    | '1' .. '9' -> nonzero := true
    | _ -> invalid_string string ~reason:"expected digits after decimal point"
  done;
  !nonzero
;;

let parse string ~f =
  let len = String.length string in
  let am_or_pm, until =
    match
      ( find_suffix string (Lazy.force am_suffixes)
      , find_suffix string (Lazy.force pm_suffixes) )
    with
    | "", "" -> `hr_24, len
    | am, "" -> `hr_AM, decrement_length_if_ends_in_space string (len - String.length am)
    | "", pm -> `hr_PM, decrement_length_if_ends_in_space string (len - String.length pm)
    | _, _ -> `hr_24, assert false
  in
  let pos = 0 in
  let pos, hr, expect_minutes_and_seconds =
    if has_colon string (pos + 1) ~until
    then pos + 2, read_1_digit_int string ~pos, `Minutes_and_maybe_seconds
    else if has_colon string (pos + 2) ~until
    then pos + 3, read_2_digit_int string ~pos, `Minutes_and_maybe_seconds
    else if pos + 1 = until
    then pos + 1, read_1_digit_int string ~pos, `Neither_minutes_nor_seconds
    else if pos + 2 = until
    then pos + 2, read_2_digit_int string ~pos, `Neither_minutes_nor_seconds
    else pos + 2, read_2_digit_int string ~pos, `Minutes_but_not_seconds
  in
  let pos, min, expect_seconds =
    match expect_minutes_and_seconds with
    | `Neither_minutes_nor_seconds -> pos, 0, false
    | (`Minutes_and_maybe_seconds | `Minutes_but_not_seconds) as maybe_seconds ->
      if has_colon string (pos + 2) ~until
      then
        ( pos + 3
        , read_2_digit_int string ~pos
        , match maybe_seconds with
          | `Minutes_and_maybe_seconds -> true
          | `Minutes_but_not_seconds ->
            invalid_string string ~reason:"expected end of string after minutes" )
      else if pos + 2 = until
      then pos + 2, read_2_digit_int string ~pos, false
      else
        invalid_string
          string
          ~reason:"expected colon or am/pm suffix with optional space after minutes"
  in
  let sec, subsec_pos, subsec_len, subsec_nonzero =
    match expect_seconds with
    | false ->
      if pos = until
      then 0, pos, 0, false
      else invalid_string string ~reason:"BUG: did not expect seconds, but found them"
    | true ->
      if pos + 2 > until
      then invalid_string string ~reason:"expected two digits of seconds"
      else (
        let sec = read_2_digit_int string ~pos in
        let pos = pos + 2 in
        if pos = until
        then sec, pos, 0, false
        else if pos < until && char_is_decimal_point string pos
        then
          ( sec
          , pos
          , until - pos
          , check_digits_with_underscore_and_return_if_nonzero string (pos + 1) ~until )
        else
          invalid_string
            string
            ~reason:"expected decimal point or am/pm suffix after seconds")
  in
  let hr =
    match am_or_pm with
    | `hr_AM ->
      if hr < 1 || hr > 12
      then invalid_string string ~reason:"hours out of bounds"
      else if hr = 12
      then 0
      else hr
    | `hr_PM ->
      if hr < 1 || hr > 12
      then invalid_string string ~reason:"hours out of bounds"
      else if hr = 12
      then 12
      else hr + 12
    | `hr_24 ->
      (match expect_minutes_and_seconds with
       | `Neither_minutes_nor_seconds ->
         invalid_string string ~reason:"hours without minutes or AM/PM"
       | `Minutes_but_not_seconds | `Minutes_and_maybe_seconds ->
         if hr > 24
         then invalid_string string ~reason:"hours out of bounds"
         else if hr = 24 && (min > 0 || sec > 0 || subsec_nonzero)
         then invalid_string string ~reason:"time is past 24:00:00"
         else hr)
  in
  let min =
    if min > 59 then invalid_string string ~reason:"minutes out of bounds" else min
  in
  let sec =
    if sec > 60 then invalid_string string ~reason:"seconds out of bounds" else sec
  in
  let subsec_len = if sec = 60 || not subsec_nonzero then 0 else subsec_len in
  f string ~hr ~min ~sec ~subsec_pos ~subsec_len
;;

let parse_iso8601_extended ?pos ?len str ~f =
  let pos, len =
    match
      Ordered_collection_common.get_pos_len () ?pos ?len ~total_length:(String.length str)
    with
    | Result.Ok z -> z
    | Result.Error s ->
      failwithf
        "Ofday.of_string_iso8601_extended: %s"
        (Error.to_string_mach (Error.globalize s))
        ()
  in
  if len < 2
  then failwith "len < 2"
  else (
    let hr = read_2_digit_int str ~pos in
    if hr > 24 then failwith "hour > 24";
    if len = 2
    then f str ~hr ~min:0 ~sec:0 ~subsec_pos:(pos + len) ~subsec_len:0
    else if len < 5
    then failwith "2 < len < 5"
    else if not (Char.equal str.[pos + 2] ':')
    then failwith "first colon missing"
    else (
      let min = read_2_digit_int str ~pos:(pos + 3) in
      if min >= 60 then failwith "minute > 60";
      if hr = 24 && min <> 0 then failwith "24 hours and non-zero minute";
      if len = 5
      then f str ~hr ~min ~sec:0 ~subsec_pos:(pos + len) ~subsec_len:0
      else if len < 8
      then failwith "5 < len < 8"
      else if not (Char.equal str.[pos + 5] ':')
      then failwith "second colon missing"
      else (
        let sec = read_2_digit_int str ~pos:(pos + 6) in
        if sec > 60 then failwithf "invalid second: %i" sec ();
        if hr = 24 && sec <> 0 then failwith "24 hours and non-zero seconds";
        if len = 8
        then f str ~hr ~min ~sec ~subsec_pos:(pos + len) ~subsec_len:0
        else if len = 9
        then failwith "length = 9"
        else (
          match str.[pos + 8] with
          | '.' | ',' ->
            let subsec_pos = pos + 8 in
            let subsec_len =
              match
                check_digits_without_underscore_and_return_if_nonzero
                  str
                  (subsec_pos + 1)
                  ~until:(pos + len)
              with
              | true when sec = 60 -> 0
              | true when hr = 24 -> failwith "24 hours and non-zero subseconds"
              | _ -> len - 8
            in
            f str ~hr ~min ~sec ~subsec_pos ~subsec_len
          | _ -> failwith "missing subsecond separator"))))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
