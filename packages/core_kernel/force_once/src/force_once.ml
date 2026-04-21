let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"force_once.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "force_once.ml.before-ppx"
;;

open! Core
open! Import

type 'a z =
  | Forced
  | Not_forced of (unit -> 'a)

type 'a t = 'a z ref

let create f = ref (Not_forced f)
let ignore () = create (fun () -> ())

let force t =
  match !t with
  | Forced -> failwith "Force_once.force"
  | Not_forced f ->
    t := Forced;
    f ()
;;

let sexp_of_t _ t =
  match !t with
  | Forced -> Sexp.Atom "<Forced>"
  | Not_forced _ -> Sexp.Atom "<Not_forced>"
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
