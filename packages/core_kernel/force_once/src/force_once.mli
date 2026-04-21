[@@@ocaml.text
  " A \"force_once\" is a thunk that can only be forced once.  Subsequent forces\n\
  \    will raise an exception. "]

open! Core
open! Import

type 'a t

val create : (unit -> 'a) -> 'a t [@@ocaml.doc " [create f] creates a new [force_once]. "]

val force : 'a t -> 'a
[@@ocaml.doc
  " [force t] runs the thunk if it hadn't already been forced, else it raises an\n\
  \    exception. "]

val ignore : unit -> unit t [@@ocaml.doc " [ignore ()] = [create (fun () -> ())] "]

val sexp_of_t : ('a -> Sexp.t) -> 'a t -> Sexp.t
