let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"filename.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "filename.ml.before-ppx"
;;

module Stable = struct
  module V1 = struct
    include (
      String.Stable.V1 :
      sig
        type t = string
        [@@deriving
          bin_io ~localize, compare, equal, hash, sexp, sexp_grammar, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S_local with type t := t
          include Ppx_compare_lib.Comparable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t

          val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        include
          Comparable.Stable.V1.With_stable_witness.S
          with type comparable := t
          with type comparator_witness = String.Stable.V1.comparator_witness

        val comparator : (t, comparator_witness) Comparator.t

        include Hashable.Stable.V1.With_stable_witness.S with type key := t
      end)
  end
end

open! Import
open! Std_internal
include Filename_base

include (
  String :
  sig
    type t = string [@@deriving bin_io ~localize]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Comparable.S with type t := t and type comparator_witness := comparator_witness

    include Hashable.S with type t := t
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
