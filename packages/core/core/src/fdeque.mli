[@@@ocaml.text
  " A simple polymorphic functional double-ended queue. Use this if you need a queue-like\n\
  \    data structure that provides enqueue and dequeue accessors on both ends. For\n\
  \    strictly first-in, first-out access, see [Fqueue].\n\n\
  \    Amortized running times assume that [enqueue]/[dequeue] are used sequentially,\n\
  \    threading the changing deque through the calls. "]

open! Import

type 'a t [@@deriving bin_io, compare, equal, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Container.S1 with type 'a t := 'a t
[@@ocaml.doc
  " [Container] operations traverse deque elements front-to-back, like [Front_to_back]\n\
  \    below. If you need faster traversal and don't care about the order, use\n\
  \    [Arbitrary_order] below.\n\n\
  \    [is_empty] and [length] have worst-case complexity O(1). "]

include Invariant.S1 with type 'a t := 'a t
include Monad.S with type 'a t := 'a t

module Arbitrary_order : sig
  include Container.S1 with type 'a t := 'a t

  val to_sequence : 'a t -> 'a Sequence.t
  [@@ocaml.doc " This does not match the ordering of [to_list] "]
end
[@@ocaml.doc " Traverse deque elements in arbitrary order. "]

module Front_to_back : sig
  val of_list : 'a list -> 'a t

  include Container.S1 with type 'a t := 'a t

  val to_sequence : 'a t -> 'a Sequence.t
  val of_sequence : 'a Sequence.t -> 'a t
end
[@@ocaml.doc
  " Traverse deque elements front-to-back. Incurs up to O(n) additional time and space\n\
  \    cost over [Arbitrary_order]. "]

module Back_to_front : sig
  val of_list : 'a list -> 'a t

  include Container.S1 with type 'a t := 'a t

  val to_sequence : 'a t -> 'a Sequence.t
  val of_sequence : 'a Sequence.t -> 'a t
end
[@@ocaml.doc
  " Traverse deque elements back-to-front. Incurs up to O(n) additional time and space\n\
  \    cost over [Arbitrary_order]. "]

val empty : _ t [@@ocaml.doc " The empty deque. "]

val singleton : 'a -> 'a t [@@ocaml.doc " A one-element deque. "]

val of_list : 'a list -> 'a t
[@@ocaml.doc
  " [of_list] returns a deque with elements in the same front-to-back order as the\n\
  \    list. "]

val rev : 'a t -> 'a t
[@@ocaml.doc " [rev t] returns [t], reversed.\n\n    Complexity: worst-case O(1). "]

val enqueue : 'a t -> [ `back | `front ] -> 'a -> 'a t
[@@ocaml.doc
  " [enqueue t side x] produces [t] updated with [x] added to its [side].\n\n\
  \    Complexity: worst-case O(1). "]

val enqueue_front : 'a t -> 'a -> 'a t
val enqueue_back : 'a t -> 'a -> 'a t

val peek : 'a t -> [ `back | `front ] -> 'a option
[@@ocaml.doc
  " [peek t side] produces [Some] of the element at the [side] of [t], or [None] if [t] is\n\
  \    empty.\n\n\
  \    Complexity: worst-case O(1). "]

val peek_exn : 'a t -> [ `back | `front ] -> 'a
val peek_front : 'a t -> 'a option
val peek_front_exn : 'a t -> 'a
val peek_back : 'a t -> 'a option
val peek_back_exn : 'a t -> 'a

val drop : 'a t -> [ `back | `front ] -> 'a t option
[@@ocaml.doc
  " [drop t side] produces [Some] of [t] with the element at its [side] removed, or\n\
  \    [None] if [t] is empty.\n\n\
  \    Complexity: amortized O(1), worst-case O(length t). "]

val drop_exn : 'a t -> [ `back | `front ] -> 'a t
val drop_front : 'a t -> 'a t option
val drop_front_exn : 'a t -> 'a t
val drop_back : 'a t -> 'a t option
val drop_back_exn : 'a t -> 'a t

val dequeue : 'a t -> [ `back | `front ] -> ('a * 'a t) option
[@@ocaml.doc
  " [dequeue t side] produces [Option.both (peek t side) (drop t side)].\n\n\
  \    Complexity: amortized O(1), worst-case O(length t). "]

val dequeue_exn : 'a t -> [ `back | `front ] -> 'a * 'a t
val dequeue_front : 'a t -> ('a * 'a t) option
val dequeue_front_exn : 'a t -> 'a * 'a t
val dequeue_back : 'a t -> ('a * 'a t) option
val dequeue_back_exn : 'a t -> 'a * 'a t

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S1 with type 'a t := 'a t
  end
end

module Private : sig
  val build : front:'a list -> back:'a list -> 'a t
end
