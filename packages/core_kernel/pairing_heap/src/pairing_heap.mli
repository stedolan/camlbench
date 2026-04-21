[@@@ocaml.text
  " Heap implementation based on a pairing-heap.\n\n\
  \    This heap implementations supports an arbitrary element type via a comparison\n\
  \    function. "]

open! Core

type 'a t
[@@ocaml.doc
  " of_sexp and bin_io functions aren't supplied for heaps due to the difficulties in\n\
  \    reconstructing the correct comparison function when de-serializing. "]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Container.S1 with type 'a t := 'a t
[@@ocaml.doc
  " Mutation of the heap during iteration is not supported, but there is no check to\n\
  \    prevent it.  The behavior of a heap that is mutated during iteration is\n\
  \    undefined. "]

include Invariant.S1 with type 'a t := 'a t

[@@@ocaml.text
  " Even though these two functions [min_elt] and [max_elt] are part of Container.S1, they\n\
  \    are documented separately to make sure there is no confusion. They are \
   independent of\n\
  \    the comparison function used to order the heap. Instead, a traversal of the entire\n\
  \    structure is done using the provided [compare] function to find a min or max.\n\n\
  \    If you want to access the smallest element of the heap according to the heap's\n\
  \    comparison function in constant time, you should use [top]. "]

val min_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
val max_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option

val create : ?min_size:int -> cmp:('a -> 'a -> int) -> unit -> 'a t
[@@ocaml.doc
  " [create ?min_size ~cmp] returns a new min-heap that can store [min_size] elements\n\
  \    without reallocations, using ordering function [cmp].\n\n\
  \    The top of the heap is the smallest element as determined by the provided \
   comparison\n\
  \    function.  In particular, if [cmp x y < 0] then [x] will be \"on top of\" [y] in \
   the\n\
  \    heap.\n\n\
  \    Memory use can be surprising in that the underlying pool never shrinks, so current\n\
  \    memory use will at least be proportional to the largest number of elements that the\n\
  \    heap has ever held.\n"]

val of_array : 'a array -> cmp:('a -> 'a -> int) -> 'a t
[@@ocaml.doc
  " [min_size] (see [create]) will be set to the size of the input array or list. "]

val of_list : 'a list -> cmp:('a -> 'a -> int) -> 'a t

val top : 'a t -> 'a option
[@@ocaml.doc " Returns the top (i.e., smallest) element of the heap. "]

val top_exn : 'a t -> 'a
val add : 'a t -> 'a -> unit

val remove_top : _ t -> unit
[@@ocaml.doc " [remove_top t] does nothing if [t] is empty. "]

val clear : _ t -> unit
[@@ocaml.doc
  " Removes all elements, leaving an empty heap. This operation is O(n) where n is the\n\
  \    size of the heap. "]

val pop : 'a t -> 'a option
[@@ocaml.doc " [pop] removes and returns the top (i.e. least) element. "]

val pop_exn : 'a t -> 'a

val pop_if : 'a t -> ('a -> bool) -> 'a option
[@@ocaml.doc
  " [pop_if t cond] returns [Some top_element] of [t] if it satisfies condition\n\
  \    [cond], removing it, or [None] in any other case. "]

val pop_while : 'a t -> ('a -> bool) -> 'a list
[@@ocaml.doc
  " [pop_while t cond] returns a list of top elements from [t] while they satisfy\n\
  \    condition [cond], removing each of them, or an empty list if none of the elements\n\
  \    satisfy the condition. The returned list is in order of removal. "]

val copy : 'a t -> 'a t [@@ocaml.doc " [copy t] returns a shallow copy. "]

module Elt : sig
  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val value_exn : 'a t -> 'a
  [@@ocaml.doc
    " [value_exn t] returns the value in the heap controlled by this token if the\n\
    \      value is still in the heap, and raises otherwise. "]
end

val add_removable : 'a t -> 'a -> 'a Elt.t
[@@ocaml.doc
  " [add_removable t v] adds [v] to [t], returning a token that can be used to delete\n\
  \    [v] from [t] in lg(n) amortized time.\n\n\
  \    Note that while [add] doesn't allocate unless the underlying pool needs to be \
   resized,\n\
  \    [add_removable] always allocates. The [Unsafe] module has a non-allocating\n\
  \    alternative.\n"]

val remove : 'a t -> 'a Elt.t -> unit
[@@ocaml.doc
  " If [t] and [token] are mismatched then behavior is undefined. Trying to\n\
  \    [remove] an already removed token (by an earlier call to [remove] or [pop] for\n\
  \    instance) is a no-op, but keeping [token] around after it has been removed may lead\n\
  \    to memory leaks since it has a reference to the heap. "]

val update : 'a t -> 'a Elt.t -> 'a -> 'a Elt.t
[@@ocaml.doc " [update t token v] is shorthand for [remove t token; add_removable t v]. "]

val find_elt : 'a t -> f:('a -> bool) -> 'a Elt.t option
[@@ocaml.doc
  " [find_elt t ~f].  If [f] is true for some element in [t], return an [Elt.t] for\n\
  \    that element.  This operation is O(n). "]

module Unsafe : sig
  [@@@ocaml.text
    " [Unsafe] functions provide faster alternatives to regular functions with the same\n\
    \      name. They don't allocate but the behavior is unspecified and could be memory \
     unsafe\n\
    \      in certain cases where regular functions would fail with informative \
     exceptions. "]

  module Elt : sig
    type 'a heap = 'a t
    type 'a t

    val value : 'a t -> 'a heap -> 'a
    [@@ocaml.doc
      " [value t heap] returns the value in the [heap] controlled by this token if the\n\
      \        value is still in the [heap] and [heap] and [t] match. Otherwise the \
       behavior is\n\
      \        unspecified and could lead to segfaults. "]
  end

  val add_removable : 'a t -> 'a -> 'a Elt.t
  [@@ocaml.doc
    " [add_removable t v] returns a token that can be later used to remove [v]. Unlike\n\
    \      the regular function, this unsafe version doesn't allocate. "]

  val remove : 'a t -> 'a Elt.t -> unit
  [@@ocaml.doc
    " [remove t elt] removes [elt] from [t]. Behavior is undefined and could lead to\n\
    \      segfaults if [t] and [elt] don't match, if [elt] was already removed, or if the\n\
    \      underlying value has already been removed (e.g., via [pop]). "]

  val update : 'a t -> 'a Elt.t -> 'a -> 'a Elt.t
  [@@ocaml.doc
    " [update t token v] is shorthand for [remove t token; add_removable t v]. "]
end
