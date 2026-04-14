let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bounded_index_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bounded_index_intf.ml.before-ppx"
;;

open! Import
open! Std_internal

module type S = sig
  type t [@@deriving hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Identifiable with type t := t

  val create : int -> min:int -> max:int -> t
  [@@ocaml.doc
    " [create index ~min ~max] raises if [index < min || index > max].  The resulting [t]\n\
    \      is only equal to other [t] if all three fields are the same. "]

  val create_all : min:int -> max:int -> t list
  [@@ocaml.doc " all indices in ascending order "]

  [@@@ocaml.text " Accessors. "]

  val zero_based_index : t -> int
  [@@ocaml.doc
    " [zero_based_index t] is the function that code consuming a [t] most likely wants to\n\
    \      call. It is simply [index t - min_index t], meaning it returns an index [i] \
     such\n\
    \      that [0 <= i <= (max_index t - min_index t)]. "]

  val index : t -> int
  [@@ocaml.doc
    " [index t] returns the index [t] was created with, i.e. a number between\n\
    \      [min_index t] and [max_index t]. "]

  val min_index : t -> int
  val max_index : t -> int

  val num_indexes : t -> int
  [@@ocaml.doc
    " [num_indexes t] returns the number of valid indexes in the range. Equal to\n\
    \      [max_index t - min_index t + 1]"]

  module Stable : sig
    module V1 :
      Stable_comparable.With_stable_witness.V1
      with type t = t
      with type comparator_witness = comparator_witness
  end
end

module type Bounded_index = sig
  [@@@ocaml.text
    " [Bounded_index] creates unique index types with explicit bounds and human-readable\n\
    \      labels. \"(thing 2 of 0 to 4)\" refers to a 0-based index for the third \
     element of\n\
    \      five with the label \"thing\", whereas a 1-based index for the second element \
     of\n\
    \      twelve with the label \"item\" renders as \"(item 2 of 1 to 12)\", even \
     though both\n\
    \      represent the index 2.\n\n\
    \      Use [Bounded_index] to help distinguish between different index types when \
     reading\n\
    \      rendered values, deserializing sexps, and typechecking. Consider using\n\
    \      [Bounded_index] to label fixed pools of resources such as cores in a cpu, \
     worker\n\
    \      processes in a parallel application, or machines in a cluster. "]

  module type S = S

  module Make : functor
      (M : sig
         val label : string
         val module_name : string
       end)
      -> S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
