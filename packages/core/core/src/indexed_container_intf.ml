[@@@ocaml.text " This module extends {!Base.Indexed_container}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"indexed_container_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "indexed_container_intf.ml.before-ppx"
;;

open! Import
open Perms.Export

module type S1_permissions = sig
  include Container.S1_permissions

  val foldi : ('a, [> read ]) t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc
  val iteri : ('a, [> read ]) t -> f:(int -> 'a -> unit) -> unit
  val existsi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val for_alli : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val counti : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> int
  val findi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> (int * 'a) option
  val find_mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b option) -> 'b option
end

module type S1_with_creators_permissions = sig
  include Container.S1_with_creators_permissions
  include S1_permissions with type ('a, 'perms) t := ('a, 'perms) t

  val init : int -> f:(int -> 'a) -> ('a, [< _ perms ]) t
  val mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val filteri : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> ('a, [< _ perms ]) t

  val filter_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> 'b option)
    -> ('b, [< _ perms ]) t

  val concat_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t
end

module type Indexed_container = sig
  include module type of struct
    include Base.Indexed_container
  end
  [@@ocaml.doc " @open "]

  module type S1_permissions = S1_permissions
  module type S1_with_creators_permissions = S1_with_creators_permissions
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
