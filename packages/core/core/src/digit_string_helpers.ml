let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"digit_string_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "digit_string_helpers.ml.before-ppx"
;;

open! Import
open Std_internal
open Int.Replace_polymorphic_compare

module Round = struct
  type t =
    | Toward_positive_infinity
    | Toward_negative_infinity
  [@@deriving compare, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let sexp_of_t =
      (function
       | Toward_positive_infinity -> Sexplib0.Sexp.Atom "Toward_positive_infinity"
       | Toward_negative_infinity -> Sexplib0.Sexp.Atom "Toward_negative_infinity"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let module_name = "Digit_string_helpers"
let int63_two = Int63.of_int 2
let int63_ten = Int63.of_int 10
let int63_twenty = Int63.of_int 20
let int63_billion = Int63.of_int 1_000_000_000
let max_billions = Int63.( / ) Int63.max_value int63_billion

let rec digits_of_positive_int63 n =
  if Int63.( < ) n int63_ten
  then 1
  else Int.succ (digits_of_positive_int63 (Int63.( / ) n int63_ten))
;;

let digits_of_int63_max_value = digits_of_positive_int63 Int63.max_value

let rec max_int63_with ~digits =
  match digits with
  | 1 -> Int63.of_int 9
  | 2 -> Int63.of_int 99
  | 3 -> Int63.of_int 999
  | 4 -> Int63.of_int 9_999
  | 5 -> Int63.of_int 99_999
  | 6 -> Int63.of_int 999_999
  | 7 -> Int63.of_int 9_999_999
  | 8 -> Int63.of_int 99_999_999
  | 9 -> Int63.of_int 999_999_999
  | _ ->
    if digits >= digits_of_int63_max_value
    then Int63.max_value
    else (
      let billions = Int63.succ (max_int63_with ~digits:(digits - 9)) in
      Int63.pred (Int63.( * ) int63_billion billions))
;;

module Unsafe = struct
  let unsafe_char_of_digit n = Char.unsafe_of_int (Char.to_int '0' + n)
  let digit_of_char char = Char.get_digit_exn char

  let write_1_digit_int bytes ~pos int =
    Bytes.unsafe_set bytes pos (unsafe_char_of_digit int)
  ;;

  let return_tens_and_write_ones bytes ~pos int =
    let tens = int / 10 in
    let ones = int - (tens * 10) in
    write_1_digit_int bytes ~pos ones;
    tens
  ;;

  let write_2_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 1) int in
    write_1_digit_int bytes ~pos tens
  ;;

  let write_3_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 2) int in
    write_2_digit_int bytes ~pos tens
  ;;

  let write_4_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 3) int in
    write_3_digit_int bytes ~pos tens
  ;;

  let write_5_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 4) int in
    write_4_digit_int bytes ~pos tens
  ;;

  let write_6_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 5) int in
    write_5_digit_int bytes ~pos tens
  ;;

  let write_7_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 6) int in
    write_6_digit_int bytes ~pos tens
  ;;

  let write_8_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 7) int in
    write_7_digit_int bytes ~pos tens
  ;;

  let write_9_digit_int bytes ~pos int =
    let tens = return_tens_and_write_ones bytes ~pos:(pos + 8) int in
    write_8_digit_int bytes ~pos tens
  ;;

  let return_billions_and_write_remainder bytes ~pos int63 =
    let billions = Int63.( / ) int63 int63_billion in
    let remainder = Int63.( - ) int63 (Int63.( * ) billions int63_billion) in
    write_9_digit_int bytes ~pos (Int63.to_int_exn remainder);
    billions
  ;;

  let rec write_int63 bytes ~pos ~digits int63 =
    match digits with
    | 1 -> write_1_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 2 -> write_2_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 3 -> write_3_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 4 -> write_4_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 5 -> write_5_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 6 -> write_6_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 7 -> write_7_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 8 -> write_8_digit_int bytes ~pos (Int63.to_int_exn int63)
    | 9 -> write_9_digit_int bytes ~pos (Int63.to_int_exn int63)
    | _ ->
      let digits_of_billions = digits - 9 in
      let billions =
        return_billions_and_write_remainder bytes ~pos:(pos + digits_of_billions) int63
      in
      write_int63 bytes ~pos ~digits:digits_of_billions billions
  ;;

  let read_1_digit_int string ~pos = digit_of_char (String.unsafe_get string pos)

  let read_2_digit_int string ~pos =
    (read_1_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 1)
  ;;

  let read_3_digit_int string ~pos =
    (read_2_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 2)
  ;;

  let read_4_digit_int string ~pos =
    (read_3_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 3)
  ;;

  let read_5_digit_int string ~pos =
    (read_4_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 4)
  ;;

  let read_6_digit_int string ~pos =
    (read_5_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 5)
  ;;

  let read_7_digit_int string ~pos =
    (read_6_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 6)
  ;;

  let read_8_digit_int string ~pos =
    (read_7_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 7)
  ;;

  let read_9_digit_int string ~pos =
    (read_8_digit_int string ~pos * 10) + read_1_digit_int string ~pos:(pos + 8)
  ;;

  let raise_int63_overflow name =
    invalid_argf "%s.%s: overflow reading int63" module_name name ()
  ;;

  let rec read_int63 string ~pos ~digits =
    match digits with
    | 1 -> Int63.of_int (read_1_digit_int string ~pos)
    | 2 -> Int63.of_int (read_2_digit_int string ~pos)
    | 3 -> Int63.of_int (read_3_digit_int string ~pos)
    | 4 -> Int63.of_int (read_4_digit_int string ~pos)
    | 5 -> Int63.of_int (read_5_digit_int string ~pos)
    | 6 -> Int63.of_int (read_6_digit_int string ~pos)
    | 7 -> Int63.of_int (read_7_digit_int string ~pos)
    | 8 -> Int63.of_int (read_8_digit_int string ~pos)
    | 9 -> Int63.of_int (read_9_digit_int string ~pos)
    | _ ->
      let digits_of_billions = digits - 9 in
      let billions = read_int63 string ~pos ~digits:digits_of_billions in
      let remainder =
        Int63.of_int (read_9_digit_int string ~pos:(pos + digits_of_billions))
      in
      if Int63.( > ) billions max_billions then raise_int63_overflow "read_int63";
      let sum = Int63.( + ) (Int63.( * ) billions int63_billion) remainder in
      if Int63.( < ) sum Int63.zero then raise_int63_overflow "read_int63";
      sum
  ;;

  let divide_and_round_up ~numerator ~denominator =
    let open Int63.O in
    (numerator + denominator - Int63.one) /% denominator
  ;;

  let raise_invalid_decimal name =
    invalid_argf "%s.%s: invalid decimal character" module_name name ()
  ;;

  let read_int63_decimal_rounded
        string
        ~pos:start
        ~decimals
        ~scale
        ~divisor
        ~round_at
        ~round_exact
        ~allow_underscore
    =
    let open Int63.O in
    let until = Int.( + ) start decimals in
    let divisor = ref divisor in
    let round_at = ref round_at in
    let sum = ref Int63.zero in
    let pos = ref start in
    while Int.( <> ) !pos until && !round_at < scale do
      (match String.unsafe_get string !pos with
       | '0' .. '9' as char ->
         let digit = Int63.of_int (digit_of_char char) in
         divisor := !divisor * int63_ten;
         round_at := !round_at * int63_ten;
         let numerator = (digit * scale) - !round_at in
         let denominator = !divisor in
         let increment = divide_and_round_up ~numerator ~denominator in
         let remainder = numerator - (increment * denominator) in
         round_at := -remainder;
         sum := !sum + increment;
         divisor := Int63.min denominator scale
       | '_' when allow_underscore -> ()
       | _ -> raise_invalid_decimal "read_int63_decimal");
      pos := Int.succ !pos
    done;
    if !round_at = zero
    then (
      match round_exact with
      | Round.Toward_negative_infinity -> ()
      | Round.Toward_positive_infinity -> sum := !sum + Int63.one);
    !sum
  ;;

  let read_int63_decimal string ~pos ~decimals ~scale ~round_ties ~allow_underscore =
    read_int63_decimal_rounded
      string
      ~pos
      ~decimals
      ~scale:(Int63.( * ) scale int63_two)
      ~divisor:int63_two
      ~round_at:Int63.one
      ~round_exact:round_ties
      ~allow_underscore
  ;;
end

let min_scale = Int63.one
let max_scale = Int63.( / ) Int63.max_value int63_twenty

let raise_negative_decimals name ~decimals =
  invalid_argf "%s.%s: decimals=%d is negative" module_name name decimals ()
;;

let raise_non_positive_digits name ~digits =
  invalid_argf "%s.%s: digits=%d is not a positive number" module_name name digits ()
;;

let raise_scale_out_of_bounds name ~scale =
  invalid_argf
    "%s.%s: scale=%Ld out of range [%Ld, %Ld]"
    module_name
    name
    (Int63.to_int64 scale)
    (Int63.to_int64 min_scale)
    (Int63.to_int64 max_scale)
    ()
;;

let raise_pos_out_of_bounds name ~len ~pos ~digits =
  if pos < 0 || pos >= len
  then
    invalid_argf
      "%s.%s: pos=%d out of range for string of length %d"
      module_name
      name
      pos
      len
      ()
  else
    invalid_argf
      "%s.%s: %d digits do not fit at pos %d in string of length %d"
      module_name
      name
      digits
      pos
      len
      ()
;;

let raise_int_out_of_bounds name ~max int =
  invalid_argf "%s.%s: %d out of range [0, %d]" module_name name int max ()
;;

let raise_int63_out_of_bounds name ~max int63 =
  invalid_argf
    ((Format
        ( String
            ( No_padding
            , Char_literal
                ( '.'
                , String
                    ( No_padding
                    , String_literal
                        ( ": "
                        , Custom
                            ( Custom_succ Custom_zero
                            , (fun () _custom_printf__004_ ->
                                Int63.to_string _custom_printf__004_)
                            , String_literal
                                ( " out of range [0, "
                                , Custom
                                    ( Custom_succ Custom_zero
                                    , (fun () _custom_printf__003_ ->
                                        Int63.to_string _custom_printf__003_)
                                    , Char_literal (']', End_of_format) ) ) ) ) ) ) )
        , "%s.%s: %{Int63} out of range [0, %{Int63}]" )
     : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
     [@merlin.hide])
    module_name
    name
    int63
    max
    ()
;;

let check_decimals name ~decimals =
  if decimals < 0 then raise_negative_decimals name ~decimals
;;

let check_digits name ~digits = if digits < 1 then raise_non_positive_digits name ~digits

let check_pos name ~len ~pos ~digits =
  if pos < 0 || pos + digits > len then raise_pos_out_of_bounds name ~len ~pos ~digits
;;

let check_int name ~max int =
  if int < 0 || int > max then raise_int_out_of_bounds name ~max int
;;

let check_int63 name ~max int63 =
  if Int63.( < ) int63 Int63.zero || Int63.( > ) int63 max
  then raise_int63_out_of_bounds name ~max int63
;;

let check_scale name ~scale =
  if Int63.( < ) scale min_scale || Int63.( > ) scale max_scale
  then raise_scale_out_of_bounds name ~scale
;;

let check_write name ~bytes ~pos ~digits ~max int =
  let len = Bytes.length bytes in
  check_pos name ~digits ~len ~pos;
  check_int name ~max int
;;

let check_write63 name ~bytes ~pos ~digits int63 =
  check_digits name ~digits;
  let max = max_int63_with ~digits in
  let len = Bytes.length bytes in
  check_pos name ~digits ~len ~pos;
  check_int63 name ~max int63
;;

let write_1_digit_int bytes ~pos int =
  check_write "write_1_digit_int" ~bytes ~pos ~digits:1 ~max:9 int;
  Unsafe.write_1_digit_int bytes ~pos int
;;

let write_2_digit_int bytes ~pos int =
  check_write "write_2_digit_int" ~bytes ~pos ~digits:2 ~max:99 int;
  Unsafe.write_2_digit_int bytes ~pos int
;;

let write_3_digit_int bytes ~pos int =
  check_write "write_3_digit_int" ~bytes ~pos ~digits:3 ~max:999 int;
  Unsafe.write_3_digit_int bytes ~pos int
;;

let write_4_digit_int bytes ~pos int =
  check_write "write_4_digit_int" ~bytes ~pos ~digits:4 ~max:9_999 int;
  Unsafe.write_4_digit_int bytes ~pos int
;;

let write_5_digit_int bytes ~pos int =
  check_write "write_5_digit_int" ~bytes ~pos ~digits:5 ~max:99_999 int;
  Unsafe.write_5_digit_int bytes ~pos int
;;

let write_6_digit_int bytes ~pos int =
  check_write "write_6_digit_int" ~bytes ~pos ~digits:6 ~max:999_999 int;
  Unsafe.write_6_digit_int bytes ~pos int
;;

let write_7_digit_int bytes ~pos int =
  check_write "write_7_digit_int" ~bytes ~pos ~digits:7 ~max:9_999_999 int;
  Unsafe.write_7_digit_int bytes ~pos int
;;

let write_8_digit_int bytes ~pos int =
  check_write "write_8_digit_int" ~bytes ~pos ~digits:8 ~max:99_999_999 int;
  Unsafe.write_8_digit_int bytes ~pos int
;;

let write_9_digit_int bytes ~pos int =
  check_write "write_9_digit_int" ~bytes ~pos ~digits:9 ~max:999_999_999 int;
  Unsafe.write_9_digit_int bytes ~pos int
;;

let write_int63 bytes ~pos ~digits int63 =
  check_write63 "write_int63" ~bytes ~pos ~digits int63;
  Unsafe.write_int63 bytes ~pos ~digits int63
;;

let check_read name ~string ~pos ~digits =
  let len = String.length string in
  check_pos name ~digits ~len ~pos
;;

let check_read63 name ~string ~pos ~digits =
  check_digits name ~digits;
  let len = String.length string in
  check_pos name ~digits ~len ~pos
;;

let check_read63_decimal name ~string ~pos ~decimals ~scale =
  let len = String.length string in
  check_decimals name ~decimals;
  check_scale name ~scale;
  check_pos name ~digits:decimals ~len ~pos
;;

let read_1_digit_int string ~pos =
  check_read "read_1_digit_int" ~string ~pos ~digits:1;
  Unsafe.read_1_digit_int string ~pos
;;

let read_2_digit_int string ~pos =
  check_read "read_2_digit_int" ~string ~pos ~digits:2;
  Unsafe.read_2_digit_int string ~pos
;;

let read_3_digit_int string ~pos =
  check_read "read_3_digit_int" ~string ~pos ~digits:3;
  Unsafe.read_3_digit_int string ~pos
;;

let read_4_digit_int string ~pos =
  check_read "read_4_digit_int" ~string ~pos ~digits:4;
  Unsafe.read_4_digit_int string ~pos
;;

let read_5_digit_int string ~pos =
  check_read "read_5_digit_int" ~string ~pos ~digits:5;
  Unsafe.read_5_digit_int string ~pos
;;

let read_6_digit_int string ~pos =
  check_read "read_6_digit_int" ~string ~pos ~digits:6;
  Unsafe.read_6_digit_int string ~pos
;;

let read_7_digit_int string ~pos =
  check_read "read_7_digit_int" ~string ~pos ~digits:7;
  Unsafe.read_7_digit_int string ~pos
;;

let read_8_digit_int string ~pos =
  check_read "read_8_digit_int" ~string ~pos ~digits:8;
  Unsafe.read_8_digit_int string ~pos
;;

let read_9_digit_int string ~pos =
  check_read "read_9_digit_int" ~string ~pos ~digits:9;
  Unsafe.read_9_digit_int string ~pos
;;

let read_int63 string ~pos ~digits =
  check_read63 "read_int63" ~string ~pos ~digits;
  Unsafe.read_int63 string ~pos ~digits
;;

let read_int63_decimal string ~pos ~decimals ~scale ~round_ties ~allow_underscore =
  check_read63_decimal "read_int63_decimal" ~string ~pos ~decimals ~scale;
  Unsafe.read_int63_decimal string ~pos ~decimals ~scale ~round_ties ~allow_underscore
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
