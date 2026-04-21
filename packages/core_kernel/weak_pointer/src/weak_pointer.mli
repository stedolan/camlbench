[@@@ocaml.text
  " A weak pointer is a pointer to a heap block that does not cause the heap block to\n\
  \    remain live during garbage collection.\n\n\
  \    If the block would otherwise remain live, then the weak pointer remains pointed\n\
  \    to the block.  If the block is collected, then the weak pointer is cleared. "]

open! Base

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : unit -> _ t
[@@ocaml.doc
  " [create] creates an empty weak pointer.  One must [set] it to point it to\n\
  \    something. "]

val create_full : 'a Heap_block.t -> 'a t
[@@ocaml.doc
  " [create_full] is similar to [create], but [set]s the pointer at creation time. "]

val get : 'a t -> 'a Heap_block.t option

val is_some : _ t -> bool [@@ocaml.doc " [is_some t = Option.is_some (get t)]. "]

val is_none : _ t -> bool [@@ocaml.doc " [is_none t = Option.is_none (get t)]. "]

val set : 'a t -> 'a Heap_block.t -> unit
