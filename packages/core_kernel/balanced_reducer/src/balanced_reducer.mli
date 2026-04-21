[@@@ocaml.text
  " A [Balanced_reducer.t] stores a mutable fixed-length sequence of optional values, and\n\
  \    incrementally maintains the result of folding an associative operation ([reduce]) \
   over\n\
  \    the sequence as its elements change. "]

open! Base

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t

val create_exn
  :  ?sexp_of_a:(('a -> Sexp.t)[@ocaml.doc " for improved error messages "])
  -> unit
  -> len:int
  -> reduce:('a -> 'a -> 'a)
  -> 'a t
[@@ocaml.doc
  " [create_exn ~len ~reduce] creates a balanced reducer of length [len], all of whose\n\
  \    elements are [None].  It raises if [len < 1]. "]

val set_exn : 'a t -> int -> 'a -> unit
[@@ocaml.doc
  " [set_exn t i a] updates the value at index [i] to [Some a].  It raises if [i] is out\n\
  \    of bounds. "]

val get_exn : 'a t -> int -> 'a
[@@ocaml.doc
  " [get_exn t i] gets the value at index [i].  It raises if [i] is out of bounds, or\n\
  \    [set_exn t i] has never been called. "]

val compute_exn : 'a t -> 'a
[@@ocaml.doc
  " [compute_exn t] computes the value of the fold.  It raises if any values of the array\n\
  \    are [None]. "]
