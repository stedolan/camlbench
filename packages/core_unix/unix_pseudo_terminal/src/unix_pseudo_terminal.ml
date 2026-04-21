let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unix_pseudo_terminal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unix_pseudo_terminal.ml.before-ppx"
;;

open Core
module Unix = Caml_unix

type openpt_flag =
  | O_RDWR [@ocaml.doc " Open for reading and writing "]
  | O_NOCTTY [@ocaml.doc " Don't make this dev a controlling tty "]

let posix_openpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_posix_openpt"
let grantpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_grantpt"
let unlockpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_unlockpt"
let ptsname = Or_error.unimplemented "Unix_pseudo_terminal.unix_ptsname"
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
