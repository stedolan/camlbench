[@@@ocaml.text
  " Functional heaps (implemented as\n\
  \    {{: http://en.wikipedia.org/wiki/Pairing_heap} pairing heaps}). "]

open! Core

type 'a t
[@@ocaml.doc
  " [t_of_sexp] is not supported, because of the difficulty involved in recreating the\n\
  \    comparison function. "]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Container.S1 with type 'a t := 'a t
[@@ocaml.doc
  " Even though [min_elt], [max_elt], and [to_list] are in [Container.S1], they are\n\
  \    documented separately to make sure there is no confusion. "]

include
  Sequence.Heap with type 'a t := 'a t
[@@ocaml.doc " [Fheap] may be used as the module argument to [Sequence.merge_all]. "]

val min_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
[@@ocaml.doc
  " The comparison functions in [min_elt] and [max_elt] are independent of the one used to\n\
  \    order the heap. Since the provided [compare] may be different from the one used to\n\
  \    create the heap, it is necessary for these functions to traverse the entire heap. \
   If\n\
  \    you want to access the smallest element of the heap according to the heap's \
   comparison\n\
  \    function, you should use [top]. "]

val max_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option

val to_list : 'a t -> 'a list
[@@ocaml.doc
  " The elements of [to_list t] are not in any particular order.  You need to sort the\n\
  \    list afterwards if you want to get a sorted list. "]

val create : compare:('a -> 'a -> int) -> 'a t
[@@ocaml.doc
  " [create ~compare] returns a new min-heap that uses ordering function [compare].\n\n\
  \    The top of the heap is the smallest element as determined by the provided \
   comparison\n\
  \    function. "]

val of_array : 'a array -> compare:('a -> 'a -> int) -> 'a t
val of_list : 'a list -> compare:('a -> 'a -> int) -> 'a t

val add : 'a t -> 'a -> 'a t
[@@ocaml.doc " [add t v] returns the new heap after addition.  Complexity O(1). "]

val top : 'a t -> 'a option
[@@ocaml.doc
  " This returns the top (i.e., smallest) element of the heap.  Complexity O(1). "]

val top_exn : 'a t -> 'a

val remove_top : 'a t -> 'a t option
[@@ocaml.doc
  " [remove_top t] returns the new heap after a remove.  It does nothing if [t]\n\
  \    is empty.\n\n\
  \    The amortized time per [remove_top t] (or [pop t], [pop_exn t], [pop_if t]) is O(lg\n\
  \    n).  The complexity of the worst case is O(n). "]

val pop : 'a t -> ('a * 'a t) option
[@@ocaml.doc
  " This removes and returns the top (i.e., least) element and the modified heap. "]

val pop_min : 'a t -> ('a * 'a t) option
[@@ocaml.doc " [pop_min] is a more descriptive name for [pop]. "]

val pop_exn : 'a t -> 'a * 'a t

val pop_min_exn : 'a t -> 'a * 'a t
[@@ocaml.doc " [pop_min_exn] is a more descriptive name for [pop_exn]. "]

val pop_if : 'a t -> ('a -> bool) -> ('a * 'a t) option
[@@ocaml.doc
  " [pop_if t cond] returns [Some (top_element, rest_of_heap)] if [t] is not empty and its\n\
  \    top element satisfies condition [cond], or [None] in any other case. "]

val to_sequence : 'a t -> 'a Base.Sequence.t
[@@ocaml.doc " [to_sequence t] is a sequence of the elements of [t] in ascending order. "]
