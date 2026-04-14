let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"fqueue.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "fqueue.ml.before-ppx"
;;

open! Import
include Fdeque

let enqueue = enqueue_back
let peek_exn = peek_front_exn
let peek = peek_front
let dequeue_exn = dequeue_front_exn
let dequeue = dequeue_front
let drop_exn = drop_front_exn
let to_sequence = Front_to_back.to_sequence
let of_sequence = Front_to_back.of_sequence
let top = peek
let top_exn = peek_exn
let discard_exn = drop_exn
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
