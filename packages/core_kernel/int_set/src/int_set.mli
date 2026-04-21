[@@@ocaml.text
  " An implementation of compressed integer sets using lists of integer ranges. Operations\n\
  \    such as adding and membership are O(n) where n is the number of contiguous ranges \
   in\n\
  \    the set. For data that is mostly serial, n should remain very small.\n\n\
  \    Note that when n gets very large, in addition to poor performance, these operations\n\
  \    may throw exceptions since some of the code is not tail-recursive.\n"]

open! Core
open! Import

type t

val empty : t
val to_string : t -> string

val add_range : t -> int -> int -> t
[@@ocaml.doc
  " [add_range t i j] adds all the numbers between [i] and [j] (inclusive) to the set.\n\
  \    Note that it doesn't matter which order [i] and [j] are specified in; either way \
   the\n\
  \    effect is the same. "]

val add : t -> int -> t [@@ocaml.doc " [add t i] adds [i] to the set. "]

val mem : t -> int -> bool
[@@ocaml.doc " [mem t i] tests whether [i] is a member of the set. "]

val ranges : t -> (int * int) list
[@@ocaml.doc " [ranges t] returns a list of all ranges that make up the set. "]

val max : t -> int option
val min : t -> int option
