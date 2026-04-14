let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ofday_ns.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ofday_ns.ml.before-ppx"
;;

open! Import
module Span = Span_ns

type underlying = Int63.t
type t = Span.t [@@deriving typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "ofday_ns.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Span.typerep_of_t))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

include (Span : Robustly_comparable.S with type t := t)

let to_parts t = Span.to_parts t
let start_of_day : t = Span.zero
let start_of_next_day : t = Span.day
let approximate_end_of_day = Span.( - ) start_of_next_day Span.nanosecond
let to_span_since_start_of_day t = t

let input_out_of_bounds span =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Time_ns.Ofday.of_span_since_start_of_day_exn: input out of bounds"
         ; (Span.sexp_of_t [@merlin.hide]) span
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let is_invalid span = Span.( < ) span start_of_day || Span.( > ) span start_of_next_day
[@@inline always]
;;

let span_since_start_of_day_is_valid span = not (is_invalid span)
let of_span_since_start_of_day_unchecked span = span

let of_span_since_start_of_day_exn span =
  if is_invalid span then input_out_of_bounds span else span
;;

let of_span_since_start_of_day_opt span = if is_invalid span then None else Some span
let add_exn t span = of_span_since_start_of_day_exn (Span.( + ) t span)
let sub_exn t span = of_span_since_start_of_day_exn (Span.( - ) t span)
let add t span = of_span_since_start_of_day_opt (Span.( + ) t span)
let sub t span = of_span_since_start_of_day_opt (Span.( - ) t span)
let next t = of_span_since_start_of_day_opt (Span.next t)
let prev t = of_span_since_start_of_day_opt (Span.prev t)
let diff t u = Span.( - ) t u

let create ?hr ?min ?sec ?ms ?us ?ns () =
  let ms, us, ns =
    match sec with
    | Some 60 -> Some 0, Some 0, Some 0
    | _ -> ms, us, ns
  in
  of_span_since_start_of_day_exn (Span.create ?hr ?min ?sec ?ms ?us ?ns ())
;;

module Stable = struct
  module Option = struct end
  module Zoned = struct end

  module V1 = struct
    type t = Span.Stable.V2.t [@@deriving bin_io, compare, equal, hash, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "ofday_ns.ml.before-ppx:63:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], Span.Stable.V2.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = Span.Stable.V2.bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = Span.Stable.V2.bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Span.Stable.V2.__bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = Span.Stable.V2.bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__001_ b__002_ -> Span.Stable.V2.compare a__001_ b__002_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__003_ b__004_ -> Span.Stable.V2.equal a__003_ b__004_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> Span.Stable.V2.hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Span.Stable.V2.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : Span.Stable.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
          Span.Stable.V2.stable_witness
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    include (
      Span.Stable.V2 :
        Comparator.S
        with type t := t
         and type comparator_witness = Span.Stable.V2.comparator_witness)

    let to_string_with_unit =
      let ( / ) = Int63.( / ) in
      let ( mod ) = Int63.rem in
      let ( ! ) = Int63.of_int in
      let i = Int63.to_int_exn in
      fun t ~unit ->
        if Span.( < ) t start_of_day || Span.( < ) start_of_next_day t
        then "Incorrect day"
        else (
          let sixty = !60 in
          let thousand = !1000 in
          let ns = Span.to_int63_ns t in
          let us = ns / thousand in
          let ns = i (ns mod thousand) in
          let ms = us / thousand in
          let us = i (us mod thousand) in
          let s = ms / thousand in
          let ms = i (ms mod thousand) in
          let m = s / sixty in
          let s = i (s mod sixty) in
          let h = i (m / sixty) in
          let m = i (m mod sixty) in
          let unit =
            match unit with
            | (`Nanosecond | `Microsecond | `Millisecond | `Second) as unit -> unit
            | `Minute_or_less ->
              if ns <> 0
              then `Nanosecond
              else if us <> 0
              then `Microsecond
              else if ms <> 0
              then `Millisecond
              else if s <> 0
              then `Second
              else `Minute
          in
          let len =
            match unit with
            | `Minute -> 5
            | `Second -> 8
            | `Millisecond -> 12
            | `Microsecond -> 15
            | `Nanosecond -> 18
          in
          let str = Bytes.create len in
          Digit_string_helpers.write_2_digit_int str ~pos:0 h;
          Bytes.set str 2 ':';
          Digit_string_helpers.write_2_digit_int str ~pos:3 m;
          (match unit with
           | `Minute -> ()
           | (`Second | `Millisecond | `Microsecond | `Nanosecond) as unit ->
             Bytes.set str 5 ':';
             Digit_string_helpers.write_2_digit_int str ~pos:6 s;
             (match unit with
              | `Second -> ()
              | (`Millisecond | `Microsecond | `Nanosecond) as unit ->
                Bytes.set str 8 '.';
                Digit_string_helpers.write_3_digit_int str ~pos:9 ms;
                (match unit with
                 | `Millisecond -> ()
                 | (`Microsecond | `Nanosecond) as unit ->
                   Digit_string_helpers.write_3_digit_int str ~pos:12 us;
                   (match unit with
                    | `Microsecond -> ()
                    | `Nanosecond -> Digit_string_helpers.write_3_digit_int str ~pos:15 ns))));
          Bytes.unsafe_to_string ~no_mutation_while_string_reachable:str)
    ;;

    let parse_nanoseconds string ~pos ~until =
      let open Int.O in
      let digits = ref 0 in
      let num_digits = ref 0 in
      let pos = ref pos in
      while !pos < until && !num_digits < 10 do
        let c = string.[!pos] in
        if Char.is_digit c
        then (
          incr num_digits;
          if !num_digits < 10
          then digits := (!digits * 10) + Char.get_digit_exn c
          else if Char.get_digit_exn c >= 5
          then incr digits
          else ());
        incr pos
      done;
      if !num_digits < 9 then digits := !digits * Int.pow 10 (9 - !num_digits);
      !digits
    ;;

    let create_from_parsed string ~hr ~min ~sec ~subsec_pos ~subsec_len =
      let nanoseconds =
        if Int.equal subsec_len 0
        then 0
        else
          parse_nanoseconds string ~pos:(subsec_pos + 1) ~until:(subsec_pos + subsec_len)
      in
      of_span_since_start_of_day_exn
        (Span.( + )
           (Span.scale_int Span.hour hr)
           (Span.( + )
              (Span.scale_int Span.minute min)
              (Span.( + )
                 (Span.scale_int Span.second sec)
                 (Span.of_int63_ns (Int63.of_int nanoseconds)))))
    ;;

    let of_string string = Ofday_helpers.parse string ~f:create_from_parsed

    let t_of_sexp sexp : t =
      match sexp with
      | Sexp.List _ -> of_sexp_error "expected an atom" sexp
      | Sexp.Atom s ->
        (try of_string s with
         | exn -> of_sexp_error_exn exn sexp)
    ;;

    let t_sexp_grammar =
      let open Sexplib in
      Sexp_grammar.tag
        (Sexp_grammar.coerce String.t_sexp_grammar : t Sexp_grammar.t)
        ~key:Sexp_grammar.type_name_tag
        ~value:(Atom "Core.Time_ns.Ofday.t")
    ;;

    let to_string (t : t) = to_string_with_unit t ~unit:`Nanosecond
    let sexp_of_t (t : t) = Sexp.Atom (to_string t)
    let to_int63 t = Span_ns.Stable.V2.to_int63 t
    let of_int63_exn t = of_span_since_start_of_day_exn (Span_ns.Stable.V2.of_int63_exn t)

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving bin_io, equal, sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "ofday_ns.ml.before-ppx:200:6")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t
          let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
          let _ = bin_size_t
          let bin_write_t : t Bin_prot.Write.writer = bin_write_t
          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t
          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
          let _ = __bin_read_t__
          let bin_read_t : t Bin_prot.Read.reader = bin_read_t
          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let equal =
            (fun a__005_ b__006_ -> equal a__005_ b__006_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)
  end
end

include (
  Stable.V1 :
    Comparator.S
    with type t := t
     and type comparator_witness = Stable.V1.comparator_witness)

include Identifiable.Make_using_comparator (struct
    type t = Stable.V1.t [@@deriving bin_io, compare, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "ofday_ns.ml.before-ppx:212:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], Stable.V1.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = Stable.V1.bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = Stable.V1.bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Stable.V1.__bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = Stable.V1.bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__008_ b__009_ -> Stable.V1.compare a__008_ b__009_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> Stable.V1.hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Stable.V1.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let t_of_sexp = (Stable.V1.t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (Stable.V1.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    include (
      Stable.V1 :
        Comparator.S
        with type t := t
         and type comparator_witness = Stable.V1.comparator_witness)

    include (Stable.V1 : Stringable.S with type t := t)

    let module_name = "Core.Time_ns.Ofday"
  end)

include Diffable.Atomic.Make (Stable.V1)

let t_sexp_grammar = Sexplib.Sexp_grammar.coerce Stable.V1.t_sexp_grammar
let to_microsecond_string t = Stable.V1.to_string_with_unit t ~unit:`Microsecond
let to_millisecond_string t = Stable.V1.to_string_with_unit t ~unit:`Millisecond
let to_sec_string t = Stable.V1.to_string_with_unit t ~unit:`Second
let to_string_trimmed t = Stable.V1.to_string_with_unit t ~unit:`Minute_or_less

let of_string_iso8601_extended ?pos ?len str =
  try
    Ofday_helpers.parse_iso8601_extended ?pos ?len str ~f:Stable.V1.create_from_parsed
  with
  | exn ->
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Time_ns.Ofday.of_string_iso8601_extended: cannot parse string"
           ; (sexp_of_string [@merlin.hide]) (String.subo str ?pos ?len)
           ; (sexp_of_exn [@merlin.hide]) exn
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let every =
  let rec every_valid_ofday_span span ~start ~stop ~acc =
    let acc = start :: acc in
    let start = Span.( + ) start span in
    if Span.( > ) start stop
    then List.rev acc
    else every_valid_ofday_span span ~start ~stop ~acc
  in
  let every span ~start ~stop =
    if Span.( > ) start stop
    then
      Or_error.error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "[Time_ns.Ofday.every] called with [start] > [stop]"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "start"; (sexp_of_t [@merlin.hide]) start ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "stop"; (sexp_of_t [@merlin.hide]) stop ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    else if Span.( <= ) span Span.zero
    then
      Or_error.error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "[Time_ns.Ofday.every] called with negative span"
             ; (Span.sexp_of_t [@merlin.hide]) span
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    else if is_invalid span
    then Ok [ start ]
    else Ok (every_valid_ofday_span span ~start ~stop ~acc:[])
  in
  every
;;

let small_diff =
  let hour = Span.to_int63_ns Span.hour in
  fun ofday1 ofday2 ->
    let open Int63.O in
    let ofday1 = Span.to_int63_ns (to_span_since_start_of_day ofday1) in
    let ofday2 = Span.to_int63_ns (to_span_since_start_of_day ofday2) in
    let diff = ofday1 - ofday2 in
    let d1 = Int63.rem diff hour in
    let d2 = Int63.rem (d1 + hour) hour in
    let d = if d2 > hour / Int63.of_int 2 then d2 - hour else d2 in
    Span.of_int63_ns d
;;

let () =
  match Ppx_inline_test_lib.testing with
  | `Not_testing -> ()
  | `Testing _ ->
    let module Ppx_expect_test_block =
      Ppx_expect_runtime.Make_test_block (Expect_test_config)
    in
    Ppx_expect_test_block.run_suite
      ~filename_rel_to_project_root:"ofday_ns.ml.before-ppx"
      ~line_number:288
      ~location:{ start_bol = 9919; start_pos = 9919; end_pos = 10821 }
      ~trailing_loc:{ start_bol = 10814; start_pos = 10821; end_pos = 10821 }
      ~body_loc:{ start_bol = 9919; start_pos = 9919; end_pos = 10821 }
      ~formatting_flexibility:
        (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
           Ppx_expect_runtime.Expect_node_formatting.default)
      ~expected_exn:None
      ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
      ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
      ~description:(Some "small_diff")
      ~tags:[]
      ~inline_test_config:(module Inline_test_config)
      ~expectations:
        ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 0
           , Ppx_expect_runtime.Test_node.Create.expect
               ~formatting_flexibility:
                 (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                    Ppx_expect_runtime.Expect_node_formatting.default)
               ~located_payload:
                 (Some
                    ( { contents =
                          "\n\
                          \    small_diff 12:00:00.000000000 12:05:00.000000000 = -5m\n\
                          \    small_diff 12:05:00.000000000 12:00:00.000000000 = 5m\n\
                          \    small_diff 12:58:00.000000000 13:02:00.000000000 = -4m\n\
                          \    small_diff 13:02:00.000000000 12:58:00.000000000 = 4m\n\
                          \    small_diff 00:52:00.000000000 23:19:00.000000000 = -27m\n\
                          \    small_diff 23:19:00.000000000 00:52:00.000000000 = 27m\n\
                          \    small_diff 00:00:00.000000000 24:00:00.000000000 = 0s\n\
                          \    small_diff 24:00:00.000000000 00:00:00.000000000 = 0s\n\
                          \    "
                      ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                      }
                    , { start_bol = 10338; start_pos = 10342; end_pos = 10820 } ))
               ~node_loc:{ start_bol = 10327; start_pos = 10329; end_pos = 10821 } )
         ]
        [@merlin.hide])
      (fun () ->
         let test x y =
           let diff = small_diff x y in
           printf
             ((Format
                 ( String_literal
                     ( "small_diff "
                     , String
                         ( No_padding
                         , Char_literal
                             ( ' '
                             , String
                                 ( No_padding
                                 , String_literal
                                     ( " = "
                                     , String
                                         (No_padding, Char_literal ('\n', End_of_format))
                                     ) ) ) ) )
                 , "small_diff %s %s = %s\n" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (to_string x)
             (to_string y)
             (Span.to_string diff)
         in
         let examples =
           List.map
             ~f:(fun (x, y) -> of_string x, of_string y)
             [ "12:00", "12:05"; "12:58", "13:02"; "00:52", "23:19"; "00:00", "24:00" ]
         in
         List.iter examples ~f:(fun (x, y) ->
           test x y;
           test y x);
         Ppx_expect_test_block.run_test
           ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
;;

let gen_incl = Span.gen_incl
let gen_uniform_incl = Span.gen_uniform_incl
let quickcheck_generator = gen_incl start_of_day start_of_next_day
let quickcheck_observer = Span.quickcheck_observer
let quickcheck_shrinker = Quickcheck.Shrinker.empty ()

include (Span : Comparisons.S with type t := t)

let of_span_since_start_of_day = of_span_since_start_of_day_exn
let to_millisec_string = to_millisecond_string
let arg_type = `Use_Time_ns_unix
let now = `Use_Time_ns_unix
let of_ofday_float_round_nearest = `Use_Time_ns_unix
let of_ofday_float_round_nearest_microsecond = `Use_Time_ns_unix
let to_ofday_float_round_nearest = `Use_Time_ns_unix
let to_ofday_float_round_nearest_microsecond = `Use_Time_ns_unix

module Option = struct end
module Zoned = struct end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
