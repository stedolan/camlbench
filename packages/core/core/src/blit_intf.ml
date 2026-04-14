[@@@ocaml.text " This module extends the Base [Blit] module "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"blit_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "blit_intf.ml.before-ppx"
;;

open Base.Blit

module type S_permissions = sig
  open Perms.Export

  type -'perms t

  val blit : ([> read ] t, [> write ] t) blit
  val blito : ([> read ] t, [> write ] t) blito
  val unsafe_blit : ([> read ] t, [> write ] t) blit
  val sub : ([> read ] t, [< _ perms ] t) sub
  val subo : ([> read ] t, [< _ perms ] t) subo
end

module type S1_permissions = sig
  open Perms.Export

  type ('a, -'perms) t

  val blit : (('a, [> read ]) t, ('a, [> write ]) t) blit
  val blito : (('a, [> read ]) t, ('a, [> write ]) t) blito
  val unsafe_blit : (('a, [> read ]) t, ('a, [> write ]) t) blit
  val sub : (('a, [> read ]) t, ('a, [< _ perms ]) t) sub
  val subo : (('a, [> read ]) t, ('a, [< _ perms ]) t) subo
end

module type Blit = sig
  include module type of struct
    include Base.Blit
  end
  [@@ocaml.doc " @inline "]

  module type S_permissions = S_permissions
  module type S1_permissions = S1_permissions
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
