[@@@ocaml.text
  " A simple polymorphic functional queue.  Use this data structure for strictly first-in,\n\
  \    first-out access to a sequence of values.  For a similar data structure with \
   enqueue\n\
  \    and dequeue accessors on both ends of a sequence, see\n\
  \    {{!Core.Fdeque}[Core.Fdeque]}.\n\n\
  \    Amortized running times assume that [enqueue]/[dequeue] are used sequentially,\n\
  \    threading the changing Fqueue through the calls. "]

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

include Container.S1 with type 'a t := 'a t
include Invariant.S1 with type 'a t := 'a t
include Monad.S with type 'a t := 'a t

val empty : 'a t [@@ocaml.doc " The empty queue. "]

val enqueue : 'a t -> 'a -> 'a t
[@@ocaml.doc
  " [enqueue t x] returns a queue with adds [x] to the end of [t].  Complexity: O(1). "]

val peek_exn : 'a t -> 'a
[@@ocaml.doc
  " Returns the front (least recently enqueued) element.  Raises [Empty] if no element is\n\
  \    found.  Complexity: O(1). "]

val top_exn : 'a t -> 'a [@@deprecated "[since 2019-11] Use [peek_exn] instead."]

val peek : 'a t -> 'a option
[@@ocaml.doc
  " Like [peek_exn], but returns its result optionally, without exception.  Complexity:\n\
  \    O(1). "]

val top : 'a t -> 'a option [@@deprecated "[since 2019-11] Use [peek] instead."]

val dequeue_exn : 'a t -> 'a * 'a t
[@@ocaml.doc
  " [dequeue_exn t] removes and returns the front of [t], raising [Empty] if [t] is empty.\n\
  \    Complexity: amortized O(1). "]

val dequeue : 'a t -> ('a * 'a t) option
[@@ocaml.doc
  " Like [dequeue_exn], but returns result optionally, without exception.  Complexity:\n\
  \    amortized O(1). "]

val drop_exn : 'a t -> 'a t
[@@ocaml.doc
  " Returns version of queue with front element removed.  Complexity: amortized O(1). "]

val discard_exn : 'a t -> 'a t [@@deprecated "[since 2019-11] Use [drop_exn] instead."]

val to_list : 'a t -> 'a list
[@@ocaml.doc
  " [to_list t] returns a list of the elements in [t] in order from least-recently-added\n\
  \    (at the head) to most-recently-added (at the tail).  Complexity: O(n). "]

val of_list : 'a list -> 'a t
[@@ocaml.doc " [of_list] is the inverse of [to_list].  Complexity: O(n). "]

val to_sequence : 'a t -> 'a Sequence.t
[@@ocaml.doc
  " [to_sequence] returns a [Sequence.t] of the elements in [t] in order from\n\
  \    from least-recently-added (at the head) to most-recently-added (at the\n\
  \    tail). Complexity (if the sequence is fully traversed): O(n).\n\n\
  \    {[to_list t = Sequence.to_list (to_sequence t)]}\n"]

val of_sequence : 'a Sequence.t -> 'a t
[@@ocaml.doc
  " [of_sequence] is the inverse of [to_sequence]. Complexity (if the sequence\n\
  \    is fully traversed): O(n). "]

val length : 'a t -> int [@@ocaml.doc " Complexity: O(1). "]

val is_empty : 'a t -> bool [@@ocaml.doc " Complexity: O(1). "]

val singleton : 'a -> 'a t

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
