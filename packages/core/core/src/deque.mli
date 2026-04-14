[@@@ocaml.text
  " A double-ended queue that can shrink and expand on both ends.\n\n\
  \    An index is assigned to an element when it enters the queue, and the index of an\n\
  \    element is static (i.e., an index refers to a distinct element until that element \
   is\n\
  \    removed from the queue, no matter how many intervening push/pop operations \
   occur).\n\n\
  \    One consequence of this is that the minimum index may be less than zero.\n\n\
  \    The \"front\" is the smallest valid index, while the \"back\" is the largest.\n\n\
  \    All operations are amortized O(1) with a small constant. "]

open! Import

type 'a t [@@deriving bin_io, sexp, sexp_grammar]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t

  val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Binary_searchable.S1 with type 'a t := 'a t
include Container.S1 with type 'a t := 'a t

val create
  :  ?initial_length:(int[@ocaml.doc " defaults to [7]. "])
  -> ?never_shrink:bool
  -> unit
  -> _ t
[@@ocaml.doc
  " [create ?initial_length ?never_shrink ()] creates a new [t]. [initial_length] is the\n\
  \    initial length of the dequeue; it will be able to hold [initial_length] elements\n\
  \    without resizing. It must be positive. If [never_shrink] is true, the physical \
   array\n\
  \    will never shrink, only expand. If [initial_length] is given without \
   [never_shrink],\n\
  \    then [never_shrink] is presumed to be [true], otherwise [never_shrink] defaults to\n\
  \    [false].\n\n\
  \    @param initial_length defaults to 7\n"]

val of_array : 'a array -> 'a t
[@@ocaml.doc
  " [of_array arr] creates a dequeue containing the elements of [arr].  The first element\n\
  \    of the array will be at the front of the dequeue. "]

val front_index : _ t -> int option
[@@ocaml.doc " [front_index t] return the index of the front item in [t]. "]

val front_index_exn : _ t -> int
[@@ocaml.doc
  " [front_index_exn t] throws an exception if [t] is empty, otherwise returns the index\n\
  \    of the front item in [t]. "]

val back_index : _ t -> int option
[@@ocaml.doc " [back_index t] return the index of the back item in [t]. "]

val back_index_exn : _ t -> int
[@@ocaml.doc
  " [back_index_exn t] throws an exception if [t] is empty, otherwise returns the index\n\
  \    of the back item in [t]. "]

val get_opt : 'a t -> int -> 'a option
[@@ocaml.doc
  " [get_opt t i] returns the element at index [i]. Return [None] if [i] is invalid. "]

val get : 'a t -> int -> 'a
[@@ocaml.doc
  " [get t i] returns the element at index [i]. Raise an exception if [i] is\n\
  \    invalid. "]

val peek : 'a t -> [ `back | `front ] -> 'a option
[@@ocaml.doc
  " [peek t back_or_front] returns the value at the back or front of the dequeue without\n\
  \    removing it. "]

val peek_front : 'a t -> 'a option
val peek_front_exn : 'a t -> 'a
val peek_back : 'a t -> 'a option
val peek_back_exn : 'a t -> 'a

val set_exn : 'a t -> int -> 'a -> unit
[@@ocaml.doc " [set_exn t i v] mutates the element at [i]. "]

val iter' : 'a t -> [ `front_to_back | `back_to_front ] -> f:('a -> unit) -> unit
[@@ocaml.doc " [iter' t ~f] iterates over the elements of [t]. "]

val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
[@@ocaml.doc
  " [iteri t ~f] iterates over the elements of [t] [`front_to_back] passing in the\n\
  \    index. "]

val iteri' : 'a t -> [ `front_to_back | `back_to_front ] -> f:(int -> 'a -> unit) -> unit
[@@ocaml.doc
  " [iteri' t ~f] is the same as [iter'], but also passes in the index of the current\n\
  \    element. "]

val fold'
  :  'a t
  -> [ `front_to_back | `back_to_front ]
  -> init:'b
  -> f:('b -> 'a -> 'b)
  -> 'b
[@@ocaml.doc " [fold' t ~init ~f] folds over the elements of [t]. "]

val foldi : 'a t -> init:'b -> f:(int -> 'b -> 'a -> 'b) -> 'b
[@@ocaml.doc
  " [foldi t ~init ~f] is the same as [fold], but also passes in the index of the current\n\
  \    element to [f]. "]

val foldi'
  :  'a t
  -> [ `front_to_back | `back_to_front ]
  -> init:'b
  -> f:(int -> 'b -> 'a -> 'b)
  -> 'b
[@@ocaml.doc
  " [foldi' t ~init ~f] is the same as [fold'], but also passes in the index of the\n\
  \    current element to [f]. "]

val enqueue : 'a t -> [ `back | `front ] -> 'a -> unit
[@@ocaml.doc " [enqueue t back_or_front v] pushes [v] onto the [back_or_front] of [t]. "]

val enqueue_front : 'a t -> 'a -> unit
val enqueue_back : 'a t -> 'a -> unit

val clear : _ t -> unit [@@ocaml.doc " [clear t] removes all elements from [t]. "]

val drop : ?n:int -> _ t -> [ `back | `front ] -> unit
[@@ocaml.doc
  " [drop ?n t back_or_front] drops [n] elements (default 1) from the [back_or_front] of\n\
  \    [t]. If [t] has fewer than [n] elements then it is cleared. "]

val drop_front : ?n:int -> _ t -> unit
val drop_back : ?n:int -> _ t -> unit

val dequeue : 'a t -> [ `back | `front ] -> 'a option
[@@ocaml.doc
  " [dequeue t back_or_front] removes and returns the [back_or_front] of [t]. "]

val dequeue_exn : 'a t -> [ `back | `front ] -> 'a
val dequeue_front : 'a t -> 'a option
val dequeue_front_exn : 'a t -> 'a
val dequeue_back : 'a t -> 'a option
val dequeue_back_exn : 'a t -> 'a
