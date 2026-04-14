let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ofday_float.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ofday_float.ml.before-ppx"
;;

open! Import
open Std_internal
open Digit_string_helpers
open! Int.Replace_polymorphic_compare
module Span = Span_float

module Stable = struct
  module V1 = struct
    module T : sig
      type underlying = float
      type t = private underlying [@@deriving bin_io, hash, typerep, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Typerep_lib.Typerepable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Comparable.S_common with type t := t
      include Robustly_comparable with type t := t
      include Floatable with type t := t

      val add : t -> Span.t -> t option
      val sub : t -> Span.t -> t option
      val next : t -> t option
      val prev : t -> t option
      val diff : t -> t -> Span.t
      val of_span_since_start_of_day_exn : Span.t -> t
      val of_span_since_start_of_day_unchecked : Span.t -> t
      val span_since_start_of_day_is_valid : Span.t -> bool
      val to_span_since_start_of_day : t -> Span.t
      val start_of_day : t
      val start_of_next_day : t
    end = struct
      type underlying = Float.t

      include (
      struct
        include Float

        let sign = sign_exn

        let stable_witness : t Stable_witness.t =
          Stable_witness.Export.stable_witness_float
        ;;
      end :
      sig
        type t = underlying [@@deriving bin_io, hash, typerep, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
          include Typerep_lib.Typerepable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        include Comparable.S_common with type t := t
        include Comparable.With_zero with type t := t
        include Robustly_comparable with type t := t
        include Floatable with type t := t
      end)

      include Float.Robust_compare.Make (struct
          let robust_comparison_tolerance = 1E-6
        end)

      let to_span_since_start_of_day t = Span.of_sec t

      let is_valid (t : t) =
        let t = to_span_since_start_of_day t in
        Span.( <= ) Span.zero t && Span.( <= ) t Span.day
      ;;

      let of_span_since_start_of_day_unchecked span = Span.to_sec span

      let span_since_start_of_day_is_valid span =
        is_valid (of_span_since_start_of_day_unchecked span)
      ;;

      let of_span_since_start_of_day_exn span =
        let module C = Float.Class in
        let s = Span.to_sec span in
        match Float.classify s with
        | C.Infinite -> invalid_arg "Ofday.of_span_since_start_of_day_exn: infinite value"
        | C.Nan -> invalid_arg "Ofday.of_span_since_start_of_day_exn: NaN value"
        | C.Normal | C.Subnormal | C.Zero ->
          if not (is_valid s)
          then
            invalid_argf
              ((Format
                  ( String_literal
                      ( "Ofday out of range: "
                      , Custom
                          ( Custom_succ Custom_zero
                          , (fun () _custom_printf__001_ ->
                              Span.to_string _custom_printf__001_)
                          , End_of_format ) )
                  , "Ofday out of range: %{Span}" )
               : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
               [@merlin.hide])
              span
              ()
          else s
      ;;

      let start_of_day = 0.
      let start_of_next_day = of_span_since_start_of_day_exn Span.day

      let add (t : t) (span : Span.t) =
        let t = t +. Span.to_sec span in
        if is_valid t then Some t else None
      ;;

      let sub (t : t) (span : Span.t) =
        let t = t -. Span.to_sec span in
        if is_valid t then Some t else None
      ;;

      let next t =
        let candidate = Float.one_ulp `Up t in
        if is_valid candidate then Some candidate else None
      ;;

      let prev t =
        let candidate = Float.one_ulp `Down t in
        if is_valid candidate then Some candidate else None
      ;;

      let diff t1 t2 =
        Span.( - ) (to_span_since_start_of_day t1) (to_span_since_start_of_day t2)
      ;;
    end

    let approximate_end_of_day =
      Option.value_exn (T.sub T.start_of_next_day Span.microsecond)
    ;;

    let create ?hr ?min ?sec ?ms ?us ?ns () =
      let ms, us, ns =
        match sec with
        | Some 60 -> Some 0, Some 0, Some 0
        | _ -> ms, us, ns
      in
      T.of_span_since_start_of_day_exn (Span.create ?hr ?min ?sec ?ms ?us ?ns ())
    ;;

    let to_parts t = Span.to_parts (T.to_span_since_start_of_day t)

    let to_string_gen ~drop_ms ~drop_us ~trim t =
      let ( / ) = Int63.( / ) in
      let ( ! ) = Int63.of_int in
      let ( mod ) = Int63.rem in
      let i = Int63.to_int_exn in
      assert (if drop_ms then drop_us else true);
      let float_sec = Span.to_sec (T.to_span_since_start_of_day t) in
      let us = Float.int63_round_nearest_exn (float_sec *. 1e6) in
      let ms, us = us / !1000, i (us mod !1000) in
      let sec, ms = ms / !1000, i (ms mod !1000) in
      let min, sec = sec / !60, i (sec mod !60) in
      let hr, min = min / !60, i (min mod !60) in
      let hr = i hr in
      let dont_print_us = drop_us || (trim && us = 0) in
      let dont_print_ms = drop_ms || (trim && ms = 0 && dont_print_us) in
      let dont_print_s = trim && sec = 0 && dont_print_ms in
      let len =
        if dont_print_s
        then 5
        else if dont_print_ms
        then 8
        else if dont_print_us
        then 12
        else 15
      in
      let buf = Bytes.create len in
      write_2_digit_int buf ~pos:0 hr;
      Bytes.set buf 2 ':';
      write_2_digit_int buf ~pos:3 min;
      if dont_print_s
      then ()
      else (
        Bytes.set buf 5 ':';
        write_2_digit_int buf ~pos:6 sec;
        if dont_print_ms
        then ()
        else (
          Bytes.set buf 8 '.';
          write_3_digit_int buf ~pos:9 ms;
          if dont_print_us then () else write_3_digit_int buf ~pos:12 us));
      Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf
    ;;

    let to_string_trimmed t = to_string_gen ~drop_ms:false ~drop_us:false ~trim:true t
    let to_sec_string t = to_string_gen ~drop_ms:true ~drop_us:true ~trim:false t
    let to_millisecond_string t = to_string_gen ~drop_ms:false ~drop_us:true ~trim:false t

    let small_diff =
      let hour = 3600. in
      fun ofday1 ofday2 ->
        let ofday1 = Span.to_sec (T.to_span_since_start_of_day ofday1) in
        let ofday2 = Span.to_sec (T.to_span_since_start_of_day ofday2) in
        let diff = ofday1 -. ofday2 in
        let d1 = Float.mod_float diff hour in
        let d2 = Float.mod_float (d1 +. hour) hour in
        let d = if Float.( > ) d2 (hour /. 2.) then d2 -. hour else d2 in
        Span.of_sec d
    ;;

    include T

    let to_string t = to_string_gen ~drop_ms:false ~drop_us:false ~trim:false t

    include Pretty_printer.Register (struct
        type nonrec t = t

        let to_string = to_string
        let module_name = "Core.Time.Ofday"
      end)

    let create_from_parsed string ~hr ~min ~sec ~subsec_pos ~subsec_len =
      let subsec =
        if Int.equal subsec_len 0
        then 0.
        else Float.of_string (String.sub string ~pos:subsec_pos ~len:subsec_len)
      in
      T.of_span_since_start_of_day_exn
        (Span.of_sec (Float.of_int ((hr * 3600) + (min * 60) + sec) +. subsec))
    ;;

    let of_string s = Ofday_helpers.parse s ~f:create_from_parsed

    let t_of_sexp sexp =
      match sexp with
      | Sexp.Atom s ->
        (try of_string s with
         | Invalid_argument s -> of_sexp_error ("Ofday.t_of_sexp: " ^ s) sexp)
      | _ -> of_sexp_error "Ofday.t_of_sexp" sexp
    ;;

    let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar
    let sexp_of_t span = Sexp.Atom (to_string span)

    let of_string_iso8601_extended ?pos ?len str =
      try Ofday_helpers.parse_iso8601_extended ?pos ?len str ~f:create_from_parsed with
      | exn ->
        invalid_argf
          "Ofday.of_string_iso8601_extended(%s): %s"
          (String.subo str ?pos ?len)
          (Exn.to_string exn)
          ()
    ;;

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving bin_io, equal, sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "ofday_float.ml.before-ppx:257:6")
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
            (fun a__002_ b__003_ -> equal a__002_ b__003_
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

include Stable.V1

let gen_incl lo hi =
  Quickcheck.Generator.map
    ~f:of_span_since_start_of_day_exn
    (Span.gen_incl (to_span_since_start_of_day lo) (to_span_since_start_of_day hi))
;;

let gen_uniform_incl lo hi =
  Quickcheck.Generator.map
    ~f:of_span_since_start_of_day_exn
    (Span.gen_uniform_incl
       (to_span_since_start_of_day lo)
       (to_span_since_start_of_day hi))
;;

let quickcheck_generator = gen_incl start_of_day start_of_next_day

let quickcheck_observer =
  Quickcheck.Observer.unmap Span.quickcheck_observer ~f:to_span_since_start_of_day
;;

let quickcheck_shrinker = Quickcheck.Shrinker.empty ()

include Hashable.Make_binable (struct
    type nonrec t = t [@@deriving bin_io, compare, hash, sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "ofday_float.ml.before-ppx:283:2")
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__005_ b__006_ -> compare a__005_ b__006_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let t_of_sexp sexp =
      match Float.t_of_sexp sexp with
      | float -> of_float float
      | exception _ -> t_of_sexp sexp
    ;;
  end)

module C = struct
  type t = T.t [@@deriving bin_io]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "ofday_float.ml.before-ppx:296:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], T.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = T.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = T.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = T.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = T.bin_read_t
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type comparator_witness = T.comparator_witness

  let comparator = T.comparator
  let compare = T.comparator.compare
  let sexp_of_t = sexp_of_t

  let t_of_sexp sexp =
    match Option.try_with (fun () -> T.of_float (Float.t_of_sexp sexp)) with
    | Some t -> t
    | None -> t_of_sexp sexp
  ;;
end

module Map = Map.Make_binable_using_comparator (C)
module Set = Set.Make_binable_using_comparator (C)
include Comparable.Validate (C)

let of_span_since_start_of_day = of_span_since_start_of_day_exn
let to_millisec_string = to_millisecond_string
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
