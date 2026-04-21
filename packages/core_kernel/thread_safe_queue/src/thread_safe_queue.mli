[@@@ocaml.text
  " A thread-safe non-blocking queue of unbounded size.\n\n\
  \    The implementation does not use mutexes, and so is safe to use in situations when \
   one\n\
  \    doesn't want to block, e.g., a finalizer or an async job.\n"]

open! Core
open! Import

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t

val create : unit -> 'a t [@@ocaml.doc " [create ()] returns an empty queue. "]

val length : _ t -> int
val enqueue : 'a t -> 'a -> unit

val dequeue_exn : 'a t -> 'a
[@@ocaml.doc
  " [dequeue_exn t] raises if [length t = 0].  The idiom for dequeueing a single element\n\
  \    is:\n\n\
  \    {[\n\
  \      if length t > 0 then dequeue_exn t else ...\n\
  \    ]}\n\n\
  \    The idiom for dequeueing until empty is:\n\n\
  \    {[\n\
  \      while length t > 0 do\n\
  \        let a = dequeue_exn t in\n\
  \        ...\n\
  \      done\n\
  \    ]}\n\n\
  \    These idioms work in the presence of threads because OCaml will not context switch\n\
  \    between the [length t > 0] test and the call to [dequeue_exn].  Also, if one has \
   only\n\
  \    a single thread calling [dequeue_exn], then the idiom is obviously OK even in the\n\
  \    presence of a context switch. "]

val clear_internal_pool : _ t -> unit
[@@ocaml.doc
  " The queue maintains an internal pool of unused elements, which are used by [enqueue]\n\
  \    and returned to the pool by [dequeue_exn].  [enqueue] creates a new element if the\n\
  \    pool is empty.  Nothing shrinks the pool automatically.  One can call\n\
  \    [clear_internal_pool] to clear the pool, so that all unused elements will be \
   reclaimed\n\
  \    by the garbage collector. "]

module Private : sig
  module Uopt : sig
    type 'a t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val none : _ t
    val some : 'a -> 'a t
    val is_none : _ t -> bool
    val is_some : _ t -> bool
  end
end
