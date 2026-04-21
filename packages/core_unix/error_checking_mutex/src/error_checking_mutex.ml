let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"error_checking_mutex.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "error_checking_mutex.ml.before-ppx"
;;

open! Core
open! Import
include Mutex

[@@@ocaml.text
  " [create] like {!Mutex.create}, but creates an error-checking mutex.\n\
  \    Locking a mutex twice from the same thread, unlocking an unlocked mutex,\n\
  \    or unlocking a mutex not held by the thread will result in a [Sys_error]\n\
  \    exception. "]

external create : unit -> Mutex.t = "unix_create_error_checking_mutex"

let create = create
let phys_equal = Stdlib.( == )
let equal (t : t) t' = phys_equal t t'

let critical_section l ~f =
  lock l;
  Exn.protect ~f ~finally:(fun () -> unlock l) [@nontail]
;;

let synchronize f =
  let mtx = create () in
  let f' x = critical_section mtx ~f:(fun () -> f x) in
  f'
;;

let update_signal mtx cnd ~f =
  critical_section mtx ~f:(fun () ->
    let res = f () in
    Condition.signal cnd;
    res)
;;

let update_broadcast mtx cnd ~f =
  critical_section mtx ~f:(fun () ->
    let res = f () in
    Condition.broadcast cnd;
    res)
;;

let try_lock m = if try_lock m then `Acquired else `Already_held_by_me_or_other
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
