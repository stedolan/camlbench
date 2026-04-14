let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"bag.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "bag.ml.before-ppx"
;;

open! Import
include Bag_intf
include (Doubly_linked : Doubly_linked.S)

let add = insert_first
let add_unit t v = (ignore : _ Elt.t -> unit) (add t v)
let elts t = fold_elt t ~init:[] ~f:(fun acc elt -> elt :: acc)
let remove_one = remove_first
let choose = first_elt

let until_empty t f =
  let rec loop () =
    Option.iter (remove_one t) ~f:(fun v ->
      f v;
      loop ())
  in
  loop ()
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
