let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unique_id.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unique_id.ml.before-ppx"
;;

open! Import
open Std_internal
open Unique_id_intf

module type Id = Id

let rec race_free_create_loop cell make =
  let x = !cell in
  let new_x = make x in
  if phys_equal !cell x
  then (
    cell := new_x;
    x)
  else race_free_create_loop cell make
;;

module Int () = struct
  include Int

  let current = ref zero
  let create () = race_free_create_loop current succ

  module For_testing = struct
    let reset_counter () = current := zero
  end
end

module Int63 () = struct
  include Int63

  let current = ref zero
  let create () = race_free_create_loop current succ

  module For_testing = struct
    let reset_counter () = current := zero
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
