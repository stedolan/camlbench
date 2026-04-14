[@@@ocaml.text
  " Imperative set-like data structure.\n\n\
  \    There are a few differences from simple sets:\n\n\
  \    - Duplicates are allowed.\n\
  \    - It doesn't require anything (hashable, comparable) of elements in the bag.\n\
  \    - Addition and removal are constant time operations.\n\n\
  \    It is an error to modify a bag ([add], [remove], [remove_one], ...) during \
   iteration\n\
  \    ([fold], [iter], ...).  "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bag_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bag_intf.ml.before-ppx"
;;

open! Import

module type S = sig
  module Elt : sig
    type 'a t

    val equal : 'a t -> 'a t -> bool
    val sexp_of_t : ('a -> Sexp.t) -> 'a t -> Sexp.t
    val value : 'a t -> 'a
  end

  type 'a t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    Container.S1 with type 'a t := 'a t
  [@@ocaml.doc
    " Much of a bag's interface comes from the generic {!Base.Container} module. "]

  include Invariant.S1 with type 'a t := 'a t

  val create : unit -> 'a t [@@ocaml.doc " [create ()] returns an empty bag. "]

  val add : 'a t -> 'a -> 'a Elt.t
  [@@ocaml.doc
    " [add t v] adds [v] to the bag [t], returning an element that can\n\
    \      later be removed from the bag.  [add] runs in constant time. "]

  val add_unit : 'a t -> 'a -> unit

  val mem_elt : 'a t -> 'a Elt.t -> bool
  [@@ocaml.doc
    " [mem_elt t elt] returns whether or not [elt] is in [t].  It is like [mem] (included\n\
    \      from [Container]), but it takes an ['a Elt.t] instead of an ['a] and runs in \
     constant\n\
    \      time instead of linear time. "]

  val remove : 'a t -> 'a Elt.t -> unit
  [@@ocaml.doc
    " [remove t elt] removes [elt] from the bag [t], raising an exception if [elt]\n\
    \      is not in the bag.  [remove] runs in constant time. "]

  val choose : 'a t -> 'a Elt.t option
  [@@ocaml.doc " [choose t] returns some element in the bag. "]

  val remove_one : 'a t -> 'a option
  [@@ocaml.doc
    " [remove_one t] removes some element from the bag, and returns its value.\n\
    \      [remove_one] runs in constant time. "]

  val clear : 'a t -> unit
  [@@ocaml.doc
    " [clear t] removes all elements from the bag.  [clear] runs in constant time. "]

  val filter_inplace : 'a t -> f:('a -> bool) -> unit
  [@@ocaml.doc
    " [filter_inplace t ~f] removes all the elements from [t] that don't satisfy [f]. "]

  val iter_elt : 'a t -> f:('a Elt.t -> unit) -> unit
  [@@ocaml.doc " [iter_elt t ~f] calls [f] on each element of the bag. "]

  val find_elt : 'a t -> f:('a -> bool) -> 'a Elt.t option
  [@@ocaml.doc
    " [find_elt t ~f] returns the first element in the bag satisfying [f], returning \
     [None]\n\
    \      if none is found. "]

  val until_empty : 'a t -> ('a -> unit) -> unit
  [@@ocaml.doc
    " [until_empty t f] repeatedly removes values [v] from [t], running [f v] on each one,\n\
    \      until [t] is empty.  Running [f] may add elements to [t] if it wants. "]

  val transfer : src:'a t -> dst:'a t -> unit
  [@@ocaml.doc
    " [transfer ~src ~dst] moves all of the elements from [src] to [dst] in constant\n\
    \      time. "]

  val of_list : 'a list -> 'a t
  val elts : 'a t -> 'a Elt.t list

  val unchecked_iter : 'a t -> f:('a -> unit) -> unit
  [@@ocaml.doc
    " [unchecked_iter t ~f] behaves like [iter t ~f] except that [f] is allowed to modify\n\
    \      [t]. Elements added by [f] may or may not be visited; elements removed by [f] \
     that\n\
    \      have not been visited will not be visited. It is an (undetected) error to \
     delete the\n\
    \      current element. "]
end

module type Bag = sig
  module type S = S
  [@@ocaml.doc
    " The module type of the Bag module.\n\n\
    \      Example usage:\n\
    \      {[\n\
    \        module My_bag : Bag.S = Bag\n\
    \      ]}\n\n\
    \      Now [My_bag.Elt.t] can't be used with any other [Bag.t] type.\n\
    \  "]

  include S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
