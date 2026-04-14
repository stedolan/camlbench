[@@@ocaml.text
  " Shrinkers produce small values from large values. When a random test case fails, a\n\
  \    shrinker finds the simplest version of the problem. "]

open! Base

type 'a t

[@@@ocaml.text " {2 Basic Shrinkers} "]

val atomic : _ t
[@@ocaml.doc
  " This shrinker treats a type as atomic, never attempting to produce smaller values. "]

include With_basic_types.S with type 'a t := 'a t [@@ocaml.doc " @inline "]

val map_t : 'key t -> 'data t -> ('key, 'data, 'cmp) Map.t t
val set_t : 'elt t -> ('elt, 'cmp) Set.t t

val map_tree_using_comparator
  :  comparator:('key, 'cmp) Comparator.t
  -> 'key t
  -> 'data t
  -> ('key, 'data, 'cmp) Map.Using_comparator.Tree.t t

val set_tree_using_comparator
  :  comparator:('elt, 'cmp) Comparator.t
  -> 'elt t
  -> ('elt, 'cmp) Set.Using_comparator.Tree.t t

[@@@ocaml.text " {2 Modifying Shrinkers} "]

val map : 'a t -> f:('a -> 'b) -> f_inverse:('b -> 'a) -> 'b t
val filter : 'a t -> f:('a -> bool) -> 'a t

val filter_map : 'a t -> f:('a -> 'b option) -> f_inverse:('b -> 'a) -> 'b t
[@@ocaml.doc
  " Filters and maps according to [f], and provides input to [t] via [f_inverse]. Only the\n\
  \    [f] direction produces options, intentionally. "]

[@@@ocaml.text " {2 Shrinkers for Recursive Types} "]

val fixed_point : ('a t -> 'a t) -> 'a t
[@@ocaml.doc
  " Ties the recursive knot to shrink recursive types.\n\n\
  \    For example, here is an shrinker for binary trees:\n\n\
  \    {[\n\
  \      let tree_shrinker leaf_shrinker =\n\
  \        fixed_point (fun self ->\n\
  \          either leaf_shrinker (both self self)\n\
  \          |> map\n\
  \               ~f:(function\n\
  \                 | First leaf -> `Leaf leaf\n\
  \                 | Second (l, r) -> `Node (l, r))\n\
  \               ~f_inverse:(function\n\
  \                 | `Leaf leaf -> First leaf\n\
  \                 | `Node (l, r) -> Second (l, r)))\n\
  \    ]}\n"]

val of_lazy : 'a t Lazy.t -> 'a t
[@@ocaml.doc
  " Creates a [t] that forces the lazy argument as necessary. Can be used to tie\n\
  \    (mutually) recursive knots. "]

[@@@ocaml.text
  " {2 Low-level functions}\n\n    Most users will not need to call these.\n"]

val create : ('a -> 'a Sequence.t) -> 'a t
val shrink : 'a t -> 'a -> 'a Sequence.t
