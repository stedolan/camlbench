[@@@ocaml.text
  " INRIA's original command-line parsing library.\n\n\
  \    The [Command] module is generally recommended over direct use of this library. "]

open! Import

include module type of Stdlib.Arg [@@ocaml.doc " @inline "]

type t = key * spec * doc

val sort_and_align : (key * spec * doc) list -> (key * spec * doc) list
[@@ocaml.doc " Like [align], except that the specification list is also sorted by key "]
