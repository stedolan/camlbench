let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"weak_pointer.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "weak_pointer.ml.before-ppx"
;;

open! Base

type 'a t = 'a Weak_array.t

let create () = Weak_array.create ~len:1
let index = 0
let get t = Weak_array.get t index

let sexp_of_t sexp_of_a t =
  ((fun x__001_ -> sexp_of_option (Heap_block.sexp_of_t sexp_of_a) x__001_)
     [@merlin.hide])
    (get t)
;;

let is_none t = Weak_array.is_none t index
let is_some t = Weak_array.is_some t index
let set t block = Weak_array.set t index (Some block)

let create_full block =
  let t = create () in
  set t block;
  t
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
