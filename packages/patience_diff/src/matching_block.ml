let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"matching_block.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "matching_block.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V1 = struct
    type t =
      { prev_start : int
      ; next_start : int
      ; length : int
      }
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__002_ = "matching_block.ml.before-ppx.Stable.V1.t" in
         fun x__003_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__002_
             ~fields:
               (Field
                  { name = "prev_start"
                  ; kind = Required
                  ; conv = int_of_sexp
                  ; rest =
                      Field
                        { name = "next_start"
                        ; kind = Required
                        ; conv = int_of_sexp
                        ; rest =
                            Field
                              { name = "length"
                              ; kind = Required
                              ; conv = int_of_sexp
                              ; rest = Empty
                              }
                        }
                  })
             ~index_of_field:(function
               | "prev_start" -> 0
               | "next_start" -> 1
               | "length" -> 2
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (prev_start, (next_start, (length, ()))) ->
               ({ prev_start; next_start; length } : t))
             x__003_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { prev_start = prev_start__005_
             ; next_start = next_start__007_
             ; length = length__009_
             } ->
           let bnds__004_ = ([] : _ Stdlib.List.t) in
           let bnds__004_ =
             let arg__010_ = sexp_of_int length__009_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__010_ ] :: bnds__004_
              : _ Stdlib.List.t)
           in
           let bnds__004_ =
             let arg__008_ = sexp_of_int next_start__007_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_start"; arg__008_ ]
              :: bnds__004_
              : _ Stdlib.List.t)
           in
           let bnds__004_ =
             let arg__006_ = sexp_of_int prev_start__005_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_start"; arg__006_ ]
              :: bnds__004_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__004_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "matching_block.ml.before-ppx:5:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.record
                  [ "prev_start", bin_shape_int
                  ; "next_start", bin_shape_int
                  ; "length", bin_shape_int
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | { prev_start = v1; next_start = v2; length = v3 } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
          Bin_prot.Common.( + ) size (bin_size_int v3)
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | { prev_start = v1; next_start = v2; length = v3 } ->
          let pos = bin_write_int buf ~pos v1 in
          let pos = bin_write_int buf ~pos v2 in
          bin_write_int buf ~pos v3
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "matching_block.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        let v_prev_start = bin_read_int buf ~pos_ref in
        let v_next_start = bin_read_int buf ~pos_ref in
        let v_length = bin_read_int buf ~pos_ref in
        { prev_start = v_prev_start; next_start = v_next_start; length = v_length }
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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

open! Core
include Stable.V1

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
