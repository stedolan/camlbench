let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_stamp_counter.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_stamp_counter.ml.before-ppx"
;;

open! Core
open Poly
open! Import

let max_percent_change_from_real_slope = 0.20

let () =
  assert (0. <= max_percent_change_from_real_slope);
  assert (max_percent_change_from_real_slope <= 1.)
;;

let ewma ~alpha ~old ~add = ((1. -. alpha) *. old) +. (alpha *. add)

type t = Int63.t [@@deriving bin_io, compare, sexp, typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "time_stamp_counter.ml.before-ppx:85:0")
        [ Bin_prot.Shape.Tid.of_string "t", [], Int63.bin_shape_t ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
  ;;

  let _ = bin_shape_t
  let bin_size_t : t Bin_prot.Size.sizer = Int63.bin_size_t
  let _ = bin_size_t
  let bin_write_t : t Bin_prot.Write.writer = Int63.bin_write_t
  let _ = bin_write_t

  let bin_writer_t =
    ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_t
  let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Int63.__bin_read_t__
  let _ = __bin_read_t__
  let bin_read_t : t Bin_prot.Read.reader = Int63.bin_read_t
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
    (fun a__001_ b__002_ -> Int63.compare a__001_ b__002_ : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare
  let t_of_sexp = (Int63.t_of_sexp : Sexplib0.Sexp.t -> t)
  let _ = t_of_sexp
  let sexp_of_t = (Int63.sexp_of_t : t -> Sexplib0.Sexp.t)
  let _ = sexp_of_t

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "time_stamp_counter.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Int63.typerep_of_t))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type tsc = t [@@deriving bin_io, compare, sexp]

include struct
  let _ = fun (_ : tsc) -> ()

  let bin_shape_tsc =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "time_stamp_counter.ml.before-ppx:86:0")
        [ Bin_prot.Shape.Tid.of_string "tsc", [], bin_shape_t ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "tsc")) []
  ;;

  let _ = bin_shape_tsc
  let bin_size_tsc : tsc Bin_prot.Size.sizer = bin_size_t
  let _ = bin_size_tsc
  let bin_write_tsc : tsc Bin_prot.Write.writer = bin_write_t
  let _ = bin_write_tsc

  let bin_writer_tsc =
    ({ size = bin_size_tsc; write = bin_write_tsc } : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_tsc
  let __bin_read_tsc__ : (int -> tsc) Bin_prot.Read.reader = __bin_read_t__
  let _ = __bin_read_tsc__
  let bin_read_tsc : tsc Bin_prot.Read.reader = bin_read_t
  let _ = bin_read_tsc

  let bin_reader_tsc =
    ({ read = bin_read_tsc; vtag_read = __bin_read_tsc__ } : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_tsc

  let bin_tsc =
    ({ writer = bin_writer_tsc; reader = bin_reader_tsc; shape = bin_shape_tsc }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_tsc

  let compare_tsc =
    (fun a__004_ b__005_ -> compare a__004_ b__005_ : tsc -> (tsc[@merlin.hide]) -> int)
  ;;

  let _ = compare_tsc
  let tsc_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> tsc)
  let _ = tsc_of_sexp
  let sexp_of_tsc = (sexp_of_t : tsc -> Sexplib0.Sexp.t)
  let _ = sexp_of_tsc
end [@@ocaml.doc "@inline"] [@@merlin.hide]

include (Int63 : Comparisons.S with type t := t)

let diff t1 t2 = Int63.( - ) t1 t2
let add t s = Int63.( + ) t s
let of_int63 t = t
let to_int63 t = t
let zero = Int63.zero

external rdtsc : unit -> (int64[@unboxed]) = "caml_rdtsc" "caml_rdtsc_unboxed"
[@@noalloc] [@@builtin]

let now () =
  let tsc64 = rdtsc () in
  match Sys.backend_type with
  | Native -> Int63.of_int (Stdlib.Int64.to_int tsc64)
  | Bytecode | Other _ -> Int63.of_int64_trunc tsc64
[@@inline]
;;

external nanosleep : float -> float = "tsc_nanosleep"

module Calibrator = struct
  type float_fields =
    { mutable time : float
    ; mutable sec_per_cycle : float
    ; mutable monotonic_time : float
    ; mutable monotonic_sec_per_cycle : float
    ; mutable ewma_time_tsc : float
    ; mutable ewma_tsc_square : float
    ; mutable ewma_time : float
    ; mutable ewma_tsc : float
    ; mutable nanos_per_cycle : float
    ; mutable monotonic_nanos_per_cycle : float
    }
  [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : float_fields) -> ()

    let bin_shape_float_fields =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "time_stamp_counter.ml.before-ppx:115:2")
          [ ( Bin_prot.Shape.Tid.of_string "float_fields"
            , []
            , Bin_prot.Shape.record
                [ "time", bin_shape_float
                ; "sec_per_cycle", bin_shape_float
                ; "monotonic_time", bin_shape_float
                ; "monotonic_sec_per_cycle", bin_shape_float
                ; "ewma_time_tsc", bin_shape_float
                ; "ewma_tsc_square", bin_shape_float
                ; "ewma_time", bin_shape_float
                ; "ewma_tsc", bin_shape_float
                ; "nanos_per_cycle", bin_shape_float
                ; "monotonic_nanos_per_cycle", bin_shape_float
                ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "float_fields")) []
    ;;

    let _ = bin_shape_float_fields

    let bin_size_float_fields : float_fields Bin_prot.Size.sizer = function
      | { time = v1
        ; sec_per_cycle = v2
        ; monotonic_time = v3
        ; monotonic_sec_per_cycle = v4
        ; ewma_time_tsc = v5
        ; ewma_tsc_square = v6
        ; ewma_time = v7
        ; ewma_tsc = v8
        ; nanos_per_cycle = v9
        ; monotonic_nanos_per_cycle = v10
        } ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v4) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v5) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v6) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v7) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v8) in
        let size = Bin_prot.Common.( + ) size (bin_size_float v9) in
        Bin_prot.Common.( + ) size (bin_size_float v10)
    ;;

    let _ = bin_size_float_fields

    let bin_write_float_fields : float_fields Bin_prot.Write.writer =
      fun buf ~pos -> function
      | { time = v1
        ; sec_per_cycle = v2
        ; monotonic_time = v3
        ; monotonic_sec_per_cycle = v4
        ; ewma_time_tsc = v5
        ; ewma_tsc_square = v6
        ; ewma_time = v7
        ; ewma_tsc = v8
        ; nanos_per_cycle = v9
        ; monotonic_nanos_per_cycle = v10
        } ->
        let pos = bin_write_float buf ~pos v1 in
        let pos = bin_write_float buf ~pos v2 in
        let pos = bin_write_float buf ~pos v3 in
        let pos = bin_write_float buf ~pos v4 in
        let pos = bin_write_float buf ~pos v5 in
        let pos = bin_write_float buf ~pos v6 in
        let pos = bin_write_float buf ~pos v7 in
        let pos = bin_write_float buf ~pos v8 in
        let pos = bin_write_float buf ~pos v9 in
        bin_write_float buf ~pos v10
    ;;

    let _ = bin_write_float_fields

    let bin_writer_float_fields =
      ({ size = bin_size_float_fields; write = bin_write_float_fields }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_float_fields

    let __bin_read_float_fields__ : (int -> float_fields) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "time_stamp_counter.ml.before-ppx.Calibrator.float_fields"
        !pos_ref
    ;;

    let _ = __bin_read_float_fields__

    let bin_read_float_fields : float_fields Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      let v_time = bin_read_float buf ~pos_ref in
      let v_sec_per_cycle = bin_read_float buf ~pos_ref in
      let v_monotonic_time = bin_read_float buf ~pos_ref in
      let v_monotonic_sec_per_cycle = bin_read_float buf ~pos_ref in
      let v_ewma_time_tsc = bin_read_float buf ~pos_ref in
      let v_ewma_tsc_square = bin_read_float buf ~pos_ref in
      let v_ewma_time = bin_read_float buf ~pos_ref in
      let v_ewma_tsc = bin_read_float buf ~pos_ref in
      let v_nanos_per_cycle = bin_read_float buf ~pos_ref in
      let v_monotonic_nanos_per_cycle = bin_read_float buf ~pos_ref in
      { time = v_time
      ; sec_per_cycle = v_sec_per_cycle
      ; monotonic_time = v_monotonic_time
      ; monotonic_sec_per_cycle = v_monotonic_sec_per_cycle
      ; ewma_time_tsc = v_ewma_time_tsc
      ; ewma_tsc_square = v_ewma_tsc_square
      ; ewma_time = v_ewma_time
      ; ewma_tsc = v_ewma_tsc
      ; nanos_per_cycle = v_nanos_per_cycle
      ; monotonic_nanos_per_cycle = v_monotonic_nanos_per_cycle
      }
    ;;

    let _ = bin_read_float_fields

    let bin_reader_float_fields =
      ({ read = bin_read_float_fields; vtag_read = __bin_read_float_fields__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_float_fields

    let bin_float_fields =
      ({ writer = bin_writer_float_fields
       ; reader = bin_reader_float_fields
       ; shape = bin_shape_float_fields
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_float_fields

    let float_fields_of_sexp =
      (let error_source__008_ =
         "time_stamp_counter.ml.before-ppx.Calibrator.float_fields"
       in
       fun x__009_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__008_
           ~fields:
             (Field
                { name = "time"
                ; kind = Required
                ; conv = float_of_sexp
                ; rest =
                    Field
                      { name = "sec_per_cycle"
                      ; kind = Required
                      ; conv = float_of_sexp
                      ; rest =
                          Field
                            { name = "monotonic_time"
                            ; kind = Required
                            ; conv = float_of_sexp
                            ; rest =
                                Field
                                  { name = "monotonic_sec_per_cycle"
                                  ; kind = Required
                                  ; conv = float_of_sexp
                                  ; rest =
                                      Field
                                        { name = "ewma_time_tsc"
                                        ; kind = Required
                                        ; conv = float_of_sexp
                                        ; rest =
                                            Field
                                              { name = "ewma_tsc_square"
                                              ; kind = Required
                                              ; conv = float_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "ewma_time"
                                                    ; kind = Required
                                                    ; conv = float_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "ewma_tsc"
                                                          ; kind = Required
                                                          ; conv = float_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "nanos_per_cycle"
                                                                ; kind = Required
                                                                ; conv = float_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name =
                                                                          "monotonic_nanos_per_cycle"
                                                                      ; kind = Required
                                                                      ; conv =
                                                                          float_of_sexp
                                                                      ; rest = Empty
                                                                      }
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "time" -> 0
             | "sec_per_cycle" -> 1
             | "monotonic_time" -> 2
             | "monotonic_sec_per_cycle" -> 3
             | "ewma_time_tsc" -> 4
             | "ewma_tsc_square" -> 5
             | "ewma_time" -> 6
             | "ewma_tsc" -> 7
             | "nanos_per_cycle" -> 8
             | "monotonic_nanos_per_cycle" -> 9
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( time
               , ( sec_per_cycle
                 , ( monotonic_time
                   , ( monotonic_sec_per_cycle
                     , ( ewma_time_tsc
                       , ( ewma_tsc_square
                         , ( ewma_time
                           , (ewma_tsc, (nanos_per_cycle, (monotonic_nanos_per_cycle, ())))
                           ) ) ) ) ) ) ) ->
             ({ time
              ; sec_per_cycle
              ; monotonic_time
              ; monotonic_sec_per_cycle
              ; ewma_time_tsc
              ; ewma_tsc_square
              ; ewma_time
              ; ewma_tsc
              ; nanos_per_cycle
              ; monotonic_nanos_per_cycle
              }
              : float_fields))
           x__009_
       : Sexplib0.Sexp.t -> float_fields)
    ;;

    let _ = float_fields_of_sexp

    let sexp_of_float_fields =
      (fun { time = time__011_
           ; sec_per_cycle = sec_per_cycle__013_
           ; monotonic_time = monotonic_time__015_
           ; monotonic_sec_per_cycle = monotonic_sec_per_cycle__017_
           ; ewma_time_tsc = ewma_time_tsc__019_
           ; ewma_tsc_square = ewma_tsc_square__021_
           ; ewma_time = ewma_time__023_
           ; ewma_tsc = ewma_tsc__025_
           ; nanos_per_cycle = nanos_per_cycle__027_
           ; monotonic_nanos_per_cycle = monotonic_nanos_per_cycle__029_
           } ->
         let bnds__010_ = ([] : _ Stdlib.List.t) in
         let bnds__010_ =
           let arg__030_ = sexp_of_float monotonic_nanos_per_cycle__029_ in
           (Sexplib0.Sexp.List
              [ Sexplib0.Sexp.Atom "monotonic_nanos_per_cycle"; arg__030_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__028_ = sexp_of_float nanos_per_cycle__027_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nanos_per_cycle"; arg__028_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__026_ = sexp_of_float ewma_tsc__025_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ewma_tsc"; arg__026_ ] :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__024_ = sexp_of_float ewma_time__023_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ewma_time"; arg__024_ ] :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__022_ = sexp_of_float ewma_tsc_square__021_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ewma_tsc_square"; arg__022_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__020_ = sexp_of_float ewma_time_tsc__019_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ewma_time_tsc"; arg__020_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__018_ = sexp_of_float monotonic_sec_per_cycle__017_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "monotonic_sec_per_cycle"; arg__018_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__016_ = sexp_of_float monotonic_time__015_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "monotonic_time"; arg__016_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__014_ = sexp_of_float sec_per_cycle__013_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sec_per_cycle"; arg__014_ ]
            :: bnds__010_
            : _ Stdlib.List.t)
         in
         let bnds__010_ =
           let arg__012_ = sexp_of_float time__011_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "time"; arg__012_ ] :: bnds__010_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__010_
       : float_fields -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_float_fields
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t =
    { mutable tsc : tsc
    ; mutable monotonic_until_tsc : tsc
    ; mutable time_nanos : Int63.t
    ; mutable monotonic_time_nanos : Int63.t
    ; floats : float_fields
    }
  [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "time_stamp_counter.ml.before-ppx:133:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , []
            , Bin_prot.Shape.record
                [ "tsc", bin_shape_tsc
                ; "monotonic_until_tsc", bin_shape_tsc
                ; "time_nanos", Int63.bin_shape_t
                ; "monotonic_time_nanos", Int63.bin_shape_t
                ; "floats", bin_shape_float_fields
                ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t

    let bin_size_t : t Bin_prot.Size.sizer = function
      | { tsc = v1
        ; monotonic_until_tsc = v2
        ; time_nanos = v3
        ; monotonic_time_nanos = v4
        ; floats = v5
        } ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (bin_size_tsc v1) in
        let size = Bin_prot.Common.( + ) size (bin_size_tsc v2) in
        let size = Bin_prot.Common.( + ) size (Int63.bin_size_t v3) in
        let size = Bin_prot.Common.( + ) size (Int63.bin_size_t v4) in
        Bin_prot.Common.( + ) size (bin_size_float_fields v5)
    ;;

    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos -> function
      | { tsc = v1
        ; monotonic_until_tsc = v2
        ; time_nanos = v3
        ; monotonic_time_nanos = v4
        ; floats = v5
        } ->
        let pos = bin_write_tsc buf ~pos v1 in
        let pos = bin_write_tsc buf ~pos v2 in
        let pos = Int63.bin_write_t buf ~pos v3 in
        let pos = Int63.bin_write_t buf ~pos v4 in
        bin_write_float_fields buf ~pos v5
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "time_stamp_counter.ml.before-ppx.Calibrator.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      let v_tsc = bin_read_tsc buf ~pos_ref in
      let v_monotonic_until_tsc = bin_read_tsc buf ~pos_ref in
      let v_time_nanos = Int63.bin_read_t buf ~pos_ref in
      let v_monotonic_time_nanos = Int63.bin_read_t buf ~pos_ref in
      let v_floats = bin_read_float_fields buf ~pos_ref in
      { tsc = v_tsc
      ; monotonic_until_tsc = v_monotonic_until_tsc
      ; time_nanos = v_time_nanos
      ; monotonic_time_nanos = v_monotonic_time_nanos
      ; floats = v_floats
      }
    ;;

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

    let t_of_sexp =
      (let error_source__032_ = "time_stamp_counter.ml.before-ppx.Calibrator.t" in
       fun x__033_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__032_
           ~fields:
             (Field
                { name = "tsc"
                ; kind = Required
                ; conv = tsc_of_sexp
                ; rest =
                    Field
                      { name = "monotonic_until_tsc"
                      ; kind = Required
                      ; conv = tsc_of_sexp
                      ; rest =
                          Field
                            { name = "time_nanos"
                            ; kind = Required
                            ; conv = Int63.t_of_sexp
                            ; rest =
                                Field
                                  { name = "monotonic_time_nanos"
                                  ; kind = Required
                                  ; conv = Int63.t_of_sexp
                                  ; rest =
                                      Field
                                        { name = "floats"
                                        ; kind = Required
                                        ; conv = float_fields_of_sexp
                                        ; rest = Empty
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "tsc" -> 0
             | "monotonic_until_tsc" -> 1
             | "time_nanos" -> 2
             | "monotonic_time_nanos" -> 3
             | "floats" -> 4
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( tsc
               , (monotonic_until_tsc, (time_nanos, (monotonic_time_nanos, (floats, ()))))
               ) ->
             ({ tsc; monotonic_until_tsc; time_nanos; monotonic_time_nanos; floats } : t))
           x__033_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { tsc = tsc__035_
           ; monotonic_until_tsc = monotonic_until_tsc__037_
           ; time_nanos = time_nanos__039_
           ; monotonic_time_nanos = monotonic_time_nanos__041_
           ; floats = floats__043_
           } ->
         let bnds__034_ = ([] : _ Stdlib.List.t) in
         let bnds__034_ =
           let arg__044_ = sexp_of_float_fields floats__043_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "floats"; arg__044_ ] :: bnds__034_
            : _ Stdlib.List.t)
         in
         let bnds__034_ =
           let arg__042_ = Int63.sexp_of_t monotonic_time_nanos__041_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "monotonic_time_nanos"; arg__042_ ]
            :: bnds__034_
            : _ Stdlib.List.t)
         in
         let bnds__034_ =
           let arg__040_ = Int63.sexp_of_t time_nanos__039_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "time_nanos"; arg__040_ ]
            :: bnds__034_
            : _ Stdlib.List.t)
         in
         let bnds__034_ =
           let arg__038_ = sexp_of_tsc monotonic_until_tsc__037_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "monotonic_until_tsc"; arg__038_ ]
            :: bnds__034_
            : _ Stdlib.List.t)
         in
         let bnds__034_ =
           let arg__036_ = sexp_of_tsc tsc__035_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tsc"; arg__036_ ] :: bnds__034_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__034_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let tsc_to_seconds_since_epoch =
    let convert t tsc base mul =
      base +. (mul *. Int63.to_float (diff tsc t.tsc))
        [@@inline]
    in
    (fun t tsc ->
      0.
      +.
      if tsc < t.monotonic_until_tsc
      then 0. +. convert t tsc t.floats.monotonic_time t.floats.monotonic_sec_per_cycle
      else 0. +. convert t tsc t.floats.time t.floats.sec_per_cycle) [@inline]
  ;;

  let tsc_to_nanos_since_epoch =
    let convert t tsc base mul =
      (Int63.( + ) [@inlined hint])
        base
        ((Float.int63_round_nearest_exn [@inlined hint])
           (mul *. (Int63.to_float [@inlined hint]) (diff tsc t.tsc)))
        [@@inline]
    in
    (fun t tsc ->
      if tsc < t.monotonic_until_tsc
      then convert t tsc t.monotonic_time_nanos t.floats.monotonic_nanos_per_cycle
      else convert t tsc t.time_nanos t.floats.nanos_per_cycle) [@inline]
  ;;

  let alpha_for_interval time_diff = 0. +. Float.max 0. (1. -. exp (-0.5 *. time_diff))
  [@@inline]
  ;;

  let catchup_cycles = 1E9
  let initial_alpha = 1.

  let iround_up_and_add int ~if_iround_up_fails float =
    if Float.( > ) float 0.0
    then (
      let float' = Stdlib.ceil float in
      if Float.( <= ) float' Float.iround_ubound
      then Int63.( + ) int (Int63.of_float_unchecked float')
      else if_iround_up_fails)
    else if Float.( >= ) float Float.iround_lbound
    then Int63.( + ) int (Int63.of_float_unchecked float)
    else if_iround_up_fails
  ;;

  let calibrate_using t ~tsc ~time ~am_initializing =
    let estimated_time = 0. +. tsc_to_seconds_since_epoch t tsc in
    let time_diff_est = time -. estimated_time in
    let time_diff = time -. t.floats.time in
    let tsc_diff = Int63.to_float (diff tsc t.tsc) in
    let alpha = if am_initializing then initial_alpha else alpha_for_interval time_diff in
    t.floats.time <- time;
    t.tsc <- tsc;
    t.floats.ewma_time_tsc
    <- ewma ~alpha ~old:t.floats.ewma_time_tsc ~add:(tsc_diff *. time_diff);
    t.floats.ewma_tsc_square
    <- ewma ~alpha ~old:t.floats.ewma_tsc_square ~add:(tsc_diff *. tsc_diff);
    t.floats.ewma_tsc <- ewma ~alpha ~old:t.floats.ewma_tsc ~add:tsc_diff;
    t.floats.ewma_time <- ewma ~alpha ~old:t.floats.ewma_time ~add:time_diff;
    t.floats.sec_per_cycle <- t.floats.ewma_time_tsc /. t.floats.ewma_tsc_square;
    t.floats.monotonic_time <- estimated_time;
    if not am_initializing
    then (
      let catchup_sec_per_cycle =
        t.floats.sec_per_cycle +. (time_diff_est /. catchup_cycles)
      in
      t.floats.monotonic_sec_per_cycle
      <- (if Float.is_positive time_diff_est
          then
            0.
            +. Float.min
                 catchup_sec_per_cycle
                 (t.floats.sec_per_cycle *. (1. +. max_percent_change_from_real_slope))
          else
            0.
            +. Float.max
                 catchup_sec_per_cycle
                 (t.floats.sec_per_cycle *. (1. -. max_percent_change_from_real_slope)));
      t.monotonic_until_tsc
      <- iround_up_and_add
           tsc
           ~if_iround_up_fails:Int63.zero
           (time_diff_est /. (t.floats.monotonic_sec_per_cycle -. t.floats.sec_per_cycle)));
    t.time_nanos <- Float.int63_round_nearest_exn (t.floats.time *. 1E9);
    t.floats.nanos_per_cycle <- t.floats.sec_per_cycle *. 1E9;
    t.monotonic_time_nanos
    <- Float.int63_round_nearest_exn (t.floats.monotonic_time *. 1E9);
    t.floats.monotonic_nanos_per_cycle <- t.floats.monotonic_sec_per_cycle *. 1E9
  [@@inline]
  ;;

  let now_float () =
    1E-9 *. Int63.to_float (Time_ns.to_int63_ns_since_epoch (Time_ns.now ()))
  ;;

  let initialize t samples =
    List.iter samples ~f:(fun (tsc, time) ->
      calibrate_using t ~tsc ~time ~am_initializing:true)
  ;;

  let collect_samples ~num_samples ~interval =
    assert (Int.( >= ) num_samples 1);
    let rec loop n sleep =
      let sample = now (), now_float () in
      if Int.( = ) n 1
      then [ sample ]
      else (
        ignore (nanosleep sleep);
        sample :: loop (n - 1) (sleep +. interval))
    in
    loop num_samples interval
  ;;

  let create_using ~tsc ~time ~samples =
    let t =
      { monotonic_until_tsc = Int63.zero
      ; tsc
      ; time_nanos = Int63.zero
      ; monotonic_time_nanos = Int63.zero
      ; floats =
          { monotonic_time = time
          ; sec_per_cycle = 0.
          ; monotonic_sec_per_cycle = 0.
          ; time
          ; ewma_time_tsc = 0.
          ; ewma_tsc_square = 0.
          ; ewma_time = 0.
          ; ewma_tsc = 0.
          ; nanos_per_cycle = 0.
          ; monotonic_nanos_per_cycle = 0.
          }
      }
    in
    initialize t samples;
    t
  ;;

  let create_nanos ~tsc ~time =
    let t =
      { monotonic_until_tsc = Int63.max_value
      ; tsc
      ; time_nanos = tsc
      ; monotonic_time_nanos = tsc
      ; floats =
          { monotonic_time = time
          ; sec_per_cycle = 1e-9
          ; monotonic_sec_per_cycle = 1e-9
          ; time
          ; ewma_time_tsc = 0.
          ; ewma_tsc_square = 0.
          ; ewma_time = 0.
          ; ewma_tsc = 0.
          ; nanos_per_cycle = 1.
          ; monotonic_nanos_per_cycle = 1.
          }
      }
    in
    t
  ;;

  let create () =
    let time = now_float () in
    let tsc = now () in
    match Sys.backend_type with
    | Native ->
      let samples = collect_samples ~num_samples:3 ~interval:0.0005 in
      create_using ~tsc ~time ~samples
    | Bytecode | Other _ -> create_nanos ~tsc ~time
  ;;

  let t = lazy (create ())
  let cpu_mhz = Ok (fun t -> 1. /. (t.floats.sec_per_cycle *. 1E6))

  let calibrate t =
    calibrate_using t ~tsc:(now ()) ~time:(now_float ()) ~am_initializing:false
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  module Private = struct
    let create_using = create_using
    let calibrate_using = calibrate_using
    let initialize = initialize
    let nanos_per_cycle t = t.floats.nanos_per_cycle
  end
end

module Span = struct
  include Int63

  module Private = struct
    let of_int63 t = t
    let to_int63 t = t
  end

  let to_ns t ~(calibrator : Calibrator.t) =
    (Float.int63_round_nearest_exn [@inlined hint])
      (Int63.to_float t *. calibrator.floats.nanos_per_cycle)
  ;;

  let of_ns ns ~(calibrator : Calibrator.t) =
    try
      Float.int63_round_nearest_exn
        (Int63.to_float ns /. calibrator.floats.nanos_per_cycle)
    with
    | exn ->
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ (Exn.sexp_of_t [@merlin.hide]) exn
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "calibrator"
                 ; (Calibrator.sexp_of_t [@merlin.hide]) calibrator
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  ;;

  let to_time_ns_span t ~calibrator = Time_ns.Span.of_int63_ns (to_ns t ~calibrator)
  let of_time_ns_span span ~calibrator = of_ns (Time_ns.Span.to_int63_ns span) ~calibrator
end

let calibrator = Calibrator.t

let to_time t ~calibrator =
  Time_float.of_span_since_epoch
    (Time_float.Span.of_sec (Calibrator.tsc_to_seconds_since_epoch calibrator t))
;;

let to_nanos_since_epoch t ~calibrator = Calibrator.tsc_to_nanos_since_epoch calibrator t
[@@inline]
;;

let to_time_ns t ~calibrator =
  Time_ns.of_int63_ns_since_epoch (to_nanos_since_epoch ~calibrator t)
[@@inline]
;;

module Private = struct
  let ewma = ewma
  let of_int63 = of_int63
  let max_percent_change_from_real_slope = max_percent_change_from_real_slope
  let to_nanos_since_epoch = to_nanos_since_epoch
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
