[@@@ocaml.text " This module extends {!Base.Binary_searchable}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"binary_searchable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "binary_searchable_intf.ml.before-ppx"
;;

open Base.Binary_searchable

module type S0_permissions = sig
  open Perms.Export

  type elt
  type -'perms t

  val binary_search : ([> read ] t, elt, 'key) binary_search
  val binary_search_segmented : ([> read ] t, elt) binary_search_segmented
end

module type S1_permissions = sig
  open Perms.Export

  type ('a, -'perms) t

  val binary_search : (('a, [> read ]) t, 'a, 'key) binary_search
  val binary_search_segmented : (('a, [> read ]) t, 'a) binary_search_segmented
end

module type Binary_searchable = sig
  include module type of struct
    include Base.Binary_searchable
  end

  module type S0_permissions = S0_permissions
  module type S1_permissions = S1_permissions
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
