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

[%%import "config_ext.h"]
[%%ifdef JSC_UNIX_PTY]

external unix_posix_openpt : openpt_flag list -> Unix.file_descr = "unix_posix_openpt"
external unix_grantpt : Unix.file_descr -> unit = "unix_grantpt"
external unix_unlockpt : Unix.file_descr -> unit = "unix_unlockpt"
external unix_ptsname : Unix.file_descr -> string = "unix_ptsname"

let posix_openpt = Ok unix_posix_openpt
let grantpt = Ok unix_grantpt
let unlockpt = Ok unix_unlockpt
let ptsname = Ok unix_ptsname

[%%else]

let posix_openpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_posix_openpt"
let grantpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_grantpt"
let unlockpt = Or_error.unimplemented "Unix_pseudo_terminal.unix_unlockpt"
let ptsname = Or_error.unimplemented "Unix_pseudo_terminal.unix_ptsname"

[%%endif]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
