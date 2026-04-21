let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"move_kind.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "move_kind.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V1 = struct
    type t =
      | Move of Move_id.Stable.V1.t
      | Within_move of Move_id.Stable.V1.t
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__003_ = "move_kind.ml.before-ppx.Stable.V1.t" in
         function
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("move" | "Move") as _tag__006_) :: sexp_args__007_) as
           _sexp__005_ ->
           (match sexp_args__007_ with
            | arg0__008_ :: [] ->
              let res0__009_ = Move_id.Stable.V1.t_of_sexp arg0__008_ in
              Move res0__009_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__003_
                _tag__006_
                _sexp__005_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("within_move" | "Within_move") as _tag__011_)
             :: sexp_args__012_) as _sexp__010_ ->
           (match sexp_args__012_ with
            | arg0__013_ :: [] ->
              let res0__014_ = Move_id.Stable.V1.t_of_sexp arg0__013_ in
              Within_move res0__014_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__003_
                _tag__011_
                _sexp__010_)
         | Sexplib0.Sexp.Atom ("move" | "Move") as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.Atom ("within_move" | "Within_move") as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
         | Sexplib0.Sexp.List [] as sexp__002_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
         | sexp__002_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Move arg0__015_ ->
           let res0__016_ = Move_id.Stable.V1.sexp_of_t arg0__015_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Move"; res0__016_ ]
         | Within_move arg0__017_ ->
           let res0__018_ = Move_id.Stable.V1.sexp_of_t arg0__017_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Within_move"; res0__018_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "move_kind.ml.before-ppx:5:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.variant
                  [ "Move", [ Move_id.Stable.V1.bin_shape_t ]
                  ; "Within_move", [ Move_id.Stable.V1.bin_shape_t ]
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | Move v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (Move_id.Stable.V1.bin_size_t v1)
        | Within_move v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (Move_id.Stable.V1.bin_size_t v1)
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Move v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          Move_id.Stable.V1.bin_write_t buf ~pos v1
        | Within_move v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          Move_id.Stable.V1.bin_write_t buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "move_kind.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = Move_id.Stable.V1.bin_read_t buf ~pos_ref in
          Move arg_1
        | 1 ->
          let arg_1 = Move_id.Stable.V1.bin_read_t buf ~pos_ref in
          Within_move arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "move_kind.ml.before-ppx.Stable.V1.t")
            !pos_ref
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
