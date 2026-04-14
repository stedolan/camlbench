[@@@ocaml.text " This module extends {!Base.Container}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"container_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "container_intf.ml.before-ppx"
;;

open! Import
open Perms.Export
open Base.Container
module Continue_or_stop = Continue_or_stop

module type S0_permissions = sig
  type elt
  type -'permissions t

  val mem : [> read ] t -> elt -> bool
  [@@ocaml.doc " Checks whether the provided element is there. "]

  val length : [> read ] t -> int
  val is_empty : [> read ] t -> bool

  val iter : [> read ] t -> f:(elt -> unit) -> unit
  [@@ocaml.doc " [iter t ~f] calls [f] on each element of [t]. "]

  val fold : [> read ] t -> init:'acc -> f:('acc -> elt -> 'acc) -> 'acc
  [@@ocaml.doc
    " [fold t ~init ~f] returns [f (... f (f (f init e1) e2) e3 ...) en], where [e1..en]\n\
    \      are the elements of [t]  "]

  val fold_result
    :  [> read ] t
    -> init:'acc
    -> f:('acc -> elt -> ('acc, 'e) Result.t)
    -> ('acc, 'e) Result.t
  [@@ocaml.doc
    " [fold_result t ~init ~f] is a short-circuiting version of [fold] that runs in the\n\
    \      [Result] monad.  If [f] returns an [Error _], that value is returned without \
     any\n\
    \      additional invocations of [f]. "]

  val fold_until
    :  [> read ] t
    -> init:'acc
    -> f:('acc -> elt -> ('acc, 'final) Continue_or_stop.t)
    -> finish:('acc -> 'final)
    -> 'final
  [@@ocaml.doc
    " [fold_until t ~init ~f ~finish] is a short-circuiting version of [fold]. If [f]\n\
    \      returns [Stop _] the computation ceases and results in that value. If [f] \
     returns\n\
    \      [Continue _], the fold will proceed. If [f] never returns [Stop _], the final \
     result\n\
    \      is computed by [finish]. "]

  val exists : [> read ] t -> f:(elt -> bool) -> bool
  [@@ocaml.doc
    " Returns [true] if and only if there exists an element for which the provided\n\
    \      function evaluates to [true].  This is a short-circuiting operation. "]

  val for_all : [> read ] t -> f:(elt -> bool) -> bool
  [@@ocaml.doc
    " Returns [true] if and only if the provided function evaluates to [true] for all\n\
    \      elements.  This is a short-circuiting operation. "]

  val count : [> read ] t -> f:(elt -> bool) -> int
  [@@ocaml.doc
    " Returns the number of elements for which the provided function evaluates to true. "]

  val sum : (module Summable with type t = 'sum) -> [> read ] t -> f:(elt -> 'sum) -> 'sum
  [@@ocaml.doc " Returns the sum of [f i] for i in the container "]

  val find : [> read ] t -> f:(elt -> bool) -> elt option
  [@@ocaml.doc
    " Returns as an [option] the first element for which [f] evaluates to true. "]

  val find_map : [> read ] t -> f:(elt -> 'b option) -> 'b option
  [@@ocaml.doc
    " Returns the first evaluation of [f] that returns [Some], and returns [None] if there\n\
    \      is no such element.  "]

  val to_list : [> read ] t -> elt list
  val to_array : [> read ] t -> elt array

  val min_elt : [> read ] t -> compare:(elt -> elt -> int) -> elt option
  [@@ocaml.doc
    " Returns a min (resp max) element from the collection using the provided [compare]\n\
    \      function. In case of a tie, the first element encountered while traversing the\n\
    \      collection is returned. The implementation uses [fold] so it has the same \
     complexity\n\
    \      as [fold]. Returns [None] iff the collection is empty. "]

  val max_elt : [> read ] t -> compare:(elt -> elt -> int) -> elt option
end

module type S1_permissions = sig
  type ('a, -'permissions) t

  val mem : ('a, [> read ]) t -> 'a -> equal:('a -> 'a -> bool) -> bool
  [@@ocaml.doc " Checks whether the provided element is there. "]

  val length : (_, [> read ]) t -> int
  val is_empty : (_, [> read ]) t -> bool

  val iter : ('a, [> read ]) t -> f:('a -> unit) -> unit
  [@@ocaml.doc " [iter t ~f] calls [f] on each element of [t]. "]

  val fold : ('a, [> read ]) t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
  [@@ocaml.doc
    " [fold t ~init ~f] returns [f (... f (f (f init e1) e2) e3 ...) en], where [e1..en]\n\
    \      are the elements of [t]  "]

  val fold_result
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:('acc -> 'a -> ('acc, 'e) Result.t)
    -> ('acc, 'e) Result.t
  [@@ocaml.doc
    " [fold_result t ~init ~f] is a short-circuiting version of [fold] that runs in the\n\
    \      [Result] monad.  If [f] returns an [Error _], that value is returned without \
     any\n\
    \      additional invocations of [f]. "]

  val fold_until
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:('acc -> 'a -> ('acc, 'final) Continue_or_stop.t)
    -> finish:('acc -> 'final)
    -> 'final
  [@@ocaml.doc
    " [fold_until t ~init ~f ~finish] is a short-circuiting version of [fold]. If [f]\n\
    \      returns [Stop _] the computation ceases and results in that value. If [f] \
     returns\n\
    \      [Continue _], the fold will proceed. If [f] never returns [Stop _], the final \
     result\n\
    \      is computed by [finish]. "]

  val exists : ('a, [> read ]) t -> f:('a -> bool) -> bool
  [@@ocaml.doc
    " Returns [true] if and only if there exists an element for which the provided\n\
    \      function evaluates to [true].  This is a short-circuiting operation. "]

  val for_all : ('a, [> read ]) t -> f:('a -> bool) -> bool
  [@@ocaml.doc
    " Returns [true] if and only if the provided function evaluates to [true] for all\n\
    \      elements.  This is a short-circuiting operation. "]

  val count : ('a, [> read ]) t -> f:('a -> bool) -> int
  [@@ocaml.doc
    " Returns the number of elements for which the provided function evaluates to true. "]

  val sum
    :  (module Summable with type t = 'sum)
    -> ('a, [> read ]) t
    -> f:('a -> 'sum)
    -> 'sum
  [@@ocaml.doc " Returns the sum of [f i] for i in the container "]

  val find : ('a, [> read ]) t -> f:('a -> bool) -> 'a option
  [@@ocaml.doc
    " Returns as an [option] the first element for which [f] evaluates to true. "]

  val find_map : ('a, [> read ]) t -> f:('a -> 'b option) -> 'b option
  [@@ocaml.doc
    " Returns the first evaluation of [f] that returns [Some], and returns [None] if there\n\
    \      is no such element.  "]

  val to_list : ('a, [> read ]) t -> 'a list
  val to_array : ('a, [> read ]) t -> 'a array

  val min_elt : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> 'a option
  [@@ocaml.doc
    " Returns a min (resp max) element from the collection using the provided [compare]\n\
    \      function. In case of a tie, the first element encountered while traversing the\n\
    \      collection is returned. The implementation uses [fold] so it has the same \
     complexity\n\
    \      as [fold]. Returns [None] iff the collection is empty. "]

  val max_elt : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> 'a option
end

module type S1_with_creators_permissions = sig
  include S1_permissions

  val of_list : 'a list -> ('a, [< _ perms ]) t
  val of_array : 'a array -> ('a, [< _ perms ]) t
  val append : ('a, [> read ]) t -> ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val concat : (('a, [> read ]) t, [> read ]) t -> ('a, [< _ perms ]) t
  val map : ('a, [> read ]) t -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val filter : ('a, [> read ]) t -> f:('a -> bool) -> ('a, [< _ perms ]) t
  val filter_map : ('a, [> read ]) t -> f:('a -> 'b option) -> ('b, [< _ perms ]) t

  val concat_map
    :  ('a, [> read ]) t
    -> f:('a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t

  val partition_tf
    :  ('a, [> read ]) t
    -> f:('a -> bool)
    -> ('a, [< _ perms ]) t * ('a, [< _ perms ]) t

  val partition_map
    :  ('a, [> read ]) t
    -> f:('a -> ('b, 'c) Either.t)
    -> ('b, [< _ perms ]) t * ('c, [< _ perms ]) t
end

module type Container = sig
  include module type of struct
    include Base.Container
  end
  [@@ocaml.doc " @open "]

  module type S0_permissions = S0_permissions
  module type S1_permissions = S1_permissions
  module type S1_with_creators_permissions = S1_with_creators_permissions
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
