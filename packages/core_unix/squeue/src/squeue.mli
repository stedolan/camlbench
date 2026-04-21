[@@@ocaml.text " Thread-safe queue module, using locks. "]

open! Core
open! Import

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : int -> 'a t
[@@ocaml.doc
  " [create maxsize] returns a synchronized queue bounded to have no more than [maxsize]\n\
  \    elements. "]

val push : 'a t -> 'a -> unit
[@@ocaml.doc " Blocks until there's room on the queue, then pushes. "]

val push_uncond : 'a t -> 'a -> unit
[@@ocaml.doc " Does not block, may grow the queue past maxsize. "]

val push_or_drop : 'a t -> 'a -> bool
[@@ocaml.doc
  " Pushes an event on the queue if the queue is less than maxsize, otherwise drops it.\n\
  \    Returns true if the push was successful "]

val length : 'a t -> int [@@ocaml.doc " Returns the number of elements in the queue. "]

val pop : 'a t -> 'a
[@@ocaml.doc " Pops an element off the queue, blocking until something is available "]

val lpop : 'a t -> 'a * int
[@@ocaml.doc
  " Returns the element popped and the length of the queue this element was popped. "]

val transfer_queue_in : 'a t -> 'a Linked_queue.t -> unit
[@@ocaml.doc
  " Transfers all the elements from an ordinary queue into the squeue. Blocks until\n\
  \    there's room on the queue, then pushes. May grow queue past maxsize. "]

val transfer_queue_in_uncond : 'a t -> 'a Linked_queue.t -> unit

val transfer_queue : 'a t -> 'a Linked_queue.t -> unit
[@@ocaml.doc
  " Transfers all elements from the squeue to an ordinary queue. The elements remain in\n\
  \    order. Waits until at least one element can be transferred. "]

val transfer_queue_nowait : 'a t -> 'a Linked_queue.t -> unit
[@@ocaml.doc
  " Transfers all elements from the squeue to an ordinary queue. The elements remain in\n\
  \    order. Does not wait for elements to arrive. "]

val clear : 'a t -> unit [@@ocaml.doc " Clears the queue "]

val wait_not_empty : 'a t -> unit
[@@ocaml.doc
  " [wait_not_empty sq] waits for something to be available. This is useful if you want to\n\
  \    wait, but not take something out. This function is not useful in most cases, but in\n\
  \    some complex cases it is essential. For example, if you need to take another lock\n\
  \    before you remove something from the queue for processing, you might want to try to\n\
  \    take that other lock, and if it fails do something else.\n\n\
  \    This function is not dangerous, there is just {e one} thing you {e have} to \
   remember\n\
  \    if you use it: Just because this function returns doesn't mean that [pop] will\n\
  \    succeed; someone might have gotten there first, so you have to use\n\
  \    [transfer_queue_nowait] if you don't want to block. "]
