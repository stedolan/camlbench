[@@@ocaml.text
  " Module for dealing with weak pointers, i.e., pointers that don't prevent garbage\n\
  \    collection of what they point to.\n\n\
  \    This module is like the OCaml standard library module of the same name, except \
   that it\n\
  \    requires that the values in the weak set are heap blocks. "]

open! Base

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : len:int -> _ t
val length : _ t -> int
val set : 'a t -> int -> 'a Heap_block.t option -> unit

val set_exn : 'a t -> int -> 'a option -> unit
[@@ocaml.doc
  " [set_exn] raises an exception if given [Some x] with [x] not being\n\
  \    a heap block. This is in addition to raising exceptions on bounds violation as \
   [set]\n\
  \    does. "]

val get : 'a t -> int -> 'a Heap_block.t option
val is_some : _ t -> int -> bool
val is_none : _ t -> int -> bool
val iter : 'a t -> f:('a -> unit) -> unit
val iteri : 'a t -> f:(int -> 'a -> unit) -> unit

val blit : src:'a t -> src_pos:int -> dst:'a t -> dst_pos:int -> len:int -> unit
[@@ocaml.doc
  " [blit] is generally preferred over [get] followed by [set] because, unlike\n\
  \    [get], it doesn't have to make the value strongly-referenced.\n\
  \    Making a value strongly-referenced, even temporarily, may result in delaying\n\
  \    its garbage collection by a whole GC cycle.  "]
