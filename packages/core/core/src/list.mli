[@@@ocaml.text
  " This module extends {{!Base.List}[Base.List]} with bin_io and quickcheck. "]

open! Import

[@@@ocaml.text " {2 The interface from Base} "]

include module type of struct
  include Base.List
end
[@@ocaml.doc " @inline "]

type 'a t = 'a list [@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Assoc : sig
  type ('a, 'b) t = ('a, 'b) Base.List.Assoc.t [@@deriving bin_io ~localize]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local2 with type ('a, 'b) t := ('a, 'b) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val compare
    :  ('a -> ('a[@merlin.hide]) -> int)
    -> ('b -> ('b[@merlin.hide]) -> int)
    -> ('a, 'b) t
    -> (('a, 'b) t[@merlin.hide])
    -> int
  [@@deprecated
    "[since 2016-06] This does not respect the equivalence class promised by List.Assoc.\n\
     Use List.compare directly if that's what you want."]

  include module type of struct
      include Base.List.Assoc
    end
    with type ('a, 'b) t := ('a, 'b) t
end

[@@@ocaml.text " {2 Extensions} "]

val stable_dedup_staged : compare:('a -> 'a -> int) -> ('a list -> 'a list) Staged.t
[@@ocaml.doc
  " [stable_dedup_staged] is the same as [dedup_and_sort] but maintains the order of the\n\
  \    list.  This function is staged because it instantiates a functor when [compare] is\n\
  \    passed.\n\n\
  \    See also [Set.stable_dedup_list], which is the underlying implementation of this\n\
  \    function and lets you avoid the functor instantiation when you already have such a\n\
  \    module on hand. "]
[@@deprecated "[since 2023-04] Use [List.stable_dedup] instead."]

exception
  Duplicate_found of (unit -> Base.Sexp.t) * string
      [@ocaml.doc " Only raised in [exn_if_dup] below. "]
      [@deprecated
        "[since 2018-03] stop matching on Duplicate_found. [exn_if_dup] will eventually \
         raise a different and unspecified exception"]

val exn_if_dup
  :  compare:('a -> 'a -> int)
  -> ?context:string
  -> 'a t
  -> to_sexp:('a -> Base.Sexp.t)
  -> unit
[@@ocaml.doc
  " [exn_if_dup ~compare ?context t ~to_sexp] raises if [t] contains a duplicate. It will\n\
  \    specifically raise a [Duplicate_found] exception and use [context] as its second\n\
  \    argument. O(n log n) time complexity. "]

val slice : 'a t -> int -> int -> 'a t
[@@ocaml.doc
  " [slice t start stop] returns a new list including elements [t.(start)] through\n\
  \    [t.(stop-1)], normalized Python-style with the exception that [stop = 0] is \
   treated as\n\
  \    [stop = length t]. "]

include Comparator.Derived with type 'a t := 'a t
include Quickcheckable.S1 with type 'a t := 'a t

val to_string : f:('a -> string) -> 'a t -> string

val gen_non_empty : 'a Quickcheck.Generator.t -> 'a t Quickcheck.Generator.t
[@@ocaml.doc " Like [gen], but never generates the empty list. "]

val gen_with_length : int -> 'a Quickcheck.Generator.t -> 'a t Quickcheck.Generator.t
[@@ocaml.doc " Like [gen], but generates lists with the given length. "]

val gen_filtered : 'a t -> 'a t Quickcheck.Generator.t
[@@ocaml.doc
  " Randomly drops elements from the input list. Length is chosen uniformly between 0 and\n\
  \    the length of the input, inclusive. "]

val gen_permutations : 'a t -> 'a t Quickcheck.Generator.t
[@@ocaml.doc
  " [gen_permutations t] generates all permutations of [list].  If [t] contains duplicate\n\
  \    values, then [gen_permutations t] will produce duplicate lists. "]

val zip_with_remainder
  :  'a list
  -> 'b list
  -> ('a * 'b) list * ('a list, 'b list) Either.t option
[@@ocaml.doc
  " [zip_with_remainder xs ys] zips as many elements as possible of [xs] and [ys] together\n\
  \    and also returns the un-zipped remainder of the longer input, if the inputs have\n\
  \    different lengths.\n\n\
  \    If [xs] and [ys] have the same length, [zip_with_remainder xs ys] returns the same\n\
  \    thing as [(zip_exn xs ys, None)] "]

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t
    [@@deriving
      sexp, sexp_grammar, bin_io ~localize, compare, equal, hash, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S_local1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
