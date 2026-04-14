[@@@ocaml.text
  " Derived from [Base.T]. Used for matching bare signatures with just a type. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"t.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "t.ml.before-ppx"
;;

open! Import
include Base.T

module type T_bin = sig
  type t [@@deriving bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
