let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"move_id.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "move_id.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V1 = struct
    type t = int [@@deriving sexp, bin_io, compare]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "move_id.ml.before-ppx:5:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_int
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_int
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_int
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
        (fun a__002_ b__003_ -> compare_int a__002_ b__003_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

open! Core
include Stable.V1

let zero = 0
let succ = Int.succ
let to_string = Int.to_string
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
