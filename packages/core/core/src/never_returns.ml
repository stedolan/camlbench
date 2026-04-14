let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"never_returns.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "never_returns.ml.before-ppx"
;;

open! Import

type never_returns = Nothing.t [@@deriving sexp_of]

include struct
  let _ = fun (_ : never_returns) -> ()
  let sexp_of_never_returns = (Nothing.sexp_of_t : never_returns -> Sexplib0.Sexp.t)
  let _ = sexp_of_never_returns
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let never_returns = Nothing.unreachable_code
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
