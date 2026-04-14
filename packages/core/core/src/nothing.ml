let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"nothing.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "nothing.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    type t = Base.Nothing.t = | [@@deriving sexp_grammar]

    include struct
      let _ = fun (_ : t) -> ()
      let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = { untyped = Union [] }
      let _ = t_sexp_grammar
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Shape = struct
      type t [@@deriving bin_shape]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "nothing.ml.before-ppx:8:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], Bin_prot.Shape.variant [] ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    let unreachable_code = Base.Nothing.unreachable_code
    let bin_shape_t = Shape.bin_shape_t

    let tp_loc =
      { Ppx_here_lib.pos_fname = "nothing.ml.before-ppx"
      ; pos_lnum = 13
      ; pos_cnum = 302
      ; pos_bol = 285
      }
        .pos_fname
      ^ ".Stable.V1.t"
    ;;

    let all = []
    let hash_fold_t _ t = unreachable_code t
    let hash = unreachable_code
    let compare a _ = unreachable_code a
    let equal a _ = unreachable_code a
    let bin_size_t = unreachable_code
    let bin_write_t _buf ~pos:_ t = unreachable_code t
    let bin_writer_t = { Bin_prot.Type_class.size = bin_size_t; write = bin_write_t }

    let __bin_read_t__ _buf ~pos_ref _ =
      Bin_prot.Common.raise_variant_wrong_type tp_loc !pos_ref
    ;;

    let bin_read_t _buf ~pos_ref =
      Bin_prot.Common.raise_read_error (Empty_type tp_loc) !pos_ref
    ;;

    let bin_reader_t =
      { Bin_prot.Type_class.read = bin_read_t; vtag_read = __bin_read_t__ }
    ;;

    let bin_t =
      { Bin_prot.Type_class.writer = bin_writer_t
      ; reader = bin_reader_t
      ; shape = bin_shape_t
      }
    ;;

    let sexp_of_t = unreachable_code
    let t_of_sexp sexp = Sexplib.Conv_error.empty_type tp_loc sexp
    let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
  end
end

include Stable.V1
include Base.Nothing
include Identifiable.Extend (Base.Nothing) (Stable.V1)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
