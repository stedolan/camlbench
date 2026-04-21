open! Core

val create : unit -> Uuid.t
[@@ocaml.doc
  " [create ()] returns a new [t] guaranteed to not be equal to any other UUID generated\n\
  \    by any process anywhere. "]
