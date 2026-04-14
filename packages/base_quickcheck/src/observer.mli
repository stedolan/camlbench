[@@@ocaml.text
  " Observers create random functions. {!Generator.fn} creates a random function\n\
  \    using an observer for the input type and a generator for the output type. "]

open! Base

type -'a t = 'a Observer0.t

[@@@ocaml.text " {2 Basic Observers} "]

val opaque : _ t
[@@ocaml.doc
  " Produces an observer that treats all values as equivalent. Random functions generated\n\
  \    using this observer will be constant with respect to the value(s) it observes. "]

include With_basic_types.S with type 'a t := 'a t [@@ocaml.doc " @inline "]

val fn : 'a Generator.t -> 'b t -> ('a -> 'b) t
[@@ocaml.doc
  " Produces an observer that generates random inputs for a given function, calls the\n\
  \    function on them, then observes the corresponding outputs. "]

val map_t : 'key t -> 'data t -> ('key, 'data, 'cmp) Map.t t
val set_t : 'elt t -> ('elt, 'cmp) Set.t t
val map_tree : 'key t -> 'data t -> ('key, 'data, 'cmp) Map.Using_comparator.Tree.t t
val set_tree : 'elt t -> ('elt, 'cmp) Set.Using_comparator.Tree.t t

[@@@ocaml.text " {2 Observers Based on Hash Functions} "]

val of_hash_fold : (Hash.state -> 'a -> Hash.state) -> 'a t
[@@ocaml.doc
  " Creates an observer that just calls a hash function. This is a good default for most\n\
  \    hashable types not covered by the basic observers above. "]

[@@@ocaml.text " {2 Modifying Observers} "]

val unmap : 'a t -> f:('b -> 'a) -> 'b t

[@@@ocaml.text " {2 Observers for Recursive Types} "]

val fixed_point : ('a t -> 'a t) -> 'a t
[@@ocaml.doc
  " Ties the recursive knot to observe recursive types.\n\n\
  \    For example, here is an observer for binary trees:\n\n\
  \    {[\n\
  \      let tree_observer leaf_observer =\n\
  \        fixed_point (fun self ->\n\
  \          either leaf_observer (both self self)\n\
  \          |> unmap ~f:(function\n\
  \            | `Leaf leaf -> First leaf\n\
  \            | `Node (l, r) -> Second (l, r)))\n\
  \    ]}\n"]

val of_lazy : 'a t Lazy.t -> 'a t
[@@ocaml.doc
  " Creates a [t] that forces the lazy argument as necessary. Can be used to tie\n\
  \    (mutually) recursive knots. "]

[@@@ocaml.text
  " {2 Low-Level functions}\n\n    Most users do not need to call these functions.\n"]

val create : ('a -> size:int -> hash:Hash.state -> Hash.state) -> 'a t
val observe : 'a t -> 'a -> size:int -> hash:Hash.state -> Hash.state
