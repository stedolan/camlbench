[@@@ocaml.text " Nat0: natural numbers (including zero) "]

type t = private int

val of_int : int -> t
[@@ocaml.doc
  " [of_int n] converts integer [n] to a natural number.  @raise Failure\n\
  \    if [n] is negative. "]

external unsafe_of_int : int -> t = "%identity"
