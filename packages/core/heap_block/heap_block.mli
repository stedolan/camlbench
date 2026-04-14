[@@@ocaml.text
  " A heap block is a value that is guaranteed to live on the OCaml heap, and is hence\n\
  \    guaranteed to be usable with finalization or in a weak pointer.\n\n\
  \    It is an abstract type so we can use the type system to guarantee that the values \
   we\n\
  \    put in weak pointers and use with finalizers are heap blocks.\n\n\
  \    Some examples of values that are not heap-allocated are integers, constant\n\
  \    constructors, booleans, the empty array, the empty list, the unit value.  The exact\n\
  \    list of what is heap-allocated or not is implementation-dependent.  Some constant\n\
  \    values can be heap-allocated but never deallocated during the lifetime of the \
   program,\n\
  \    for example a list of integer constants; this is also implementation-dependent.  \
   You\n\
  \    should also be aware that compiler optimizations may duplicate some immutable \
   values,\n\
  \    for example floating-point numbers when stored into arrays; thus they can be \
   finalized\n\
  \    and collected while another copy is still in use by the program.\n\n\
  \    The results of calling {!String.make}, {!Bytes.create}, {!Bytes.make}, \
   {!Array.make},\n\
  \    and {!Pervasives.ref} are guaranteed to be heap-allocated and non-constant except \
   when\n\
  \    the length argument is [0]. "]

open! Base

type +'a t = private 'a [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : 'a -> 'a t option
[@@ocaml.doc
  " [create v] returns [Some t] if [v] is a heap block, where [t] is physically equal\n\
  \    to [v]. "]

val create_exn : 'a -> 'a t

val value : 'a t -> 'a
[@@ocaml.doc " [value t] returns the value that is physically equal to [t]. "]

val bytes : _ t -> int
[@@ocaml.doc
  " [bytes t] returns the number of bytes on the heap taken by heap block [t], including\n\
  \    the header.  This is just the space for the single block, not anything it points\n\
  \    to. "]
