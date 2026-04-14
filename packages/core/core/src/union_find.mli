[@@@ocaml.text
  " Imperative data structure for representing disjoint sets.\n\n\
  \    Union find is used to implement an equivalence relation on objects, where\n\
  \    the equivalence relation can dynamically be coarsened by \"union\"ing two\n\
  \    equivalence classes together.\n\n\
  \    All of the operations are effectively (amortized) constant time.\n\n\
  \    See {{: https://en.wikipedia.org/wiki/Disjoint-set_data_structure} Wikipedia}.\n\n\
  \    This implementation is not thread-safe.\n"]

open! Import

type 'a t
[@@ocaml.doc
  " [type 'a t] is the type of objects, where each object is part of an\n\
  \    equivalence class that is associated with a single value of type ['a]. "]

include Invariant.S1 with type 'a t := 'a t

val create : 'a -> 'a t
[@@ocaml.doc
  " [create v] returns a new object in its own equivalence class that has value [v]. "]

val get : 'a t -> 'a [@@ocaml.doc " [get t] returns the value of the class of [t]. "]

val set : 'a t -> 'a -> unit
[@@ocaml.doc " [set t v] sets the value of the class of [t] to [v]. "]

val same_class : 'a t -> 'a t -> bool
[@@ocaml.doc
  " [same_class t1 t2] returns true iff [t1] and [t2] are in the same equivalence class.\n"]

val union : 'a t -> 'a t -> unit
[@@ocaml.doc
  " [union t1 t2] makes the class of [t1] and the class of [t2] be the same (if they are\n\
  \    already equal, then nothing changes).  The value of the combined class is the \
   value of\n\
  \    [t1] or [t2]; it is unspecified which.  After [union t1 t2], it will always be the\n\
  \    case that [same_class t1 t2]. "]

module Private : sig
  val is_compressed : _ t -> bool
  val rank : _ t -> int
end
