[@@@ocaml.text
  " This module defines the [Set] module for [Core]. Functions that construct a set take\n\
  \    as an argument the comparator for the element type.\n\n\
  \    This module uses the same organizational approach as {{!Map}[Map]}.\n"]

open! Import
open Set_intf

type ('elt, 'cmp) t = ('elt, 'cmp) Base.Set.t
[@@ocaml.doc
  " The type of a set.  The first type parameter identifies the type of the element, and\n\
  \    the second identifies the comparator, which determines the comparison function \
   that is\n\
  \    used for ordering elements in this set.  Many operations (e.g., {!union}), require\n\
  \    that they be passed sets with the same element type and the same comparator type. "]
[@@deriving compare]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S2 with type ('elt, 'cmp) t := ('elt, 'cmp) t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Tree : sig
  type ('elt, 'cmp) t = ('elt, 'cmp) Tree.t
  [@@ocaml.doc
    " A [Tree.t] contains just the tree data structure that a set is based on, without\n\
    \      including the comparator.  Accordingly, any operation on a [Tree.t] must also \
     take\n\
    \      as an argument the corresponding comparator. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('elt -> Sexplib0.Sexp.t)
      -> ('cmp -> Sexplib0.Sexp.t)
      -> ('elt, 'cmp) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Named = Tree.Named

  include
    Creators_and_accessors_generic
    with type ('a, 'b) set := ('a, 'b) t
    with type ('a, 'b) t := ('a, 'b) t
    with type ('a, 'b) tree := ('a, 'b) t
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) With_comparator.t
    with type 'a elt := 'a
    with type 'c cmp := 'c
    with module Named := Named
end

module Using_comparator : sig
  include
    Creators_generic
    with type ('a, 'b) set := ('a, 'b) t
    with type ('a, 'b) t := ('a, 'b) t
    with type ('a, 'b) tree := ('a, 'b) Tree.t
    with type 'a elt := 'a
    with type 'c cmp := 'c
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t
end

val invariants : (_, _) t -> bool
[@@ocaml.doc
  " Tests internal invariants of the set data structure.  Returns true on success. "]

val comparator_s : ('a, 'cmp) t -> ('a, 'cmp) Comparator.Module.t
[@@ocaml.doc
  " Returns a first-class module that can be used to build other map/set/etc\n\
  \    with the same notion of comparison. "]

val comparator : ('a, 'cmp) t -> ('a, 'cmp) Comparator.t

val empty : ('a, 'cmp) Comparator.Module.t -> ('a, 'cmp) t
[@@ocaml.doc " Creates an empty set based on the provided comparator. "]

val singleton : ('a, 'cmp) Comparator.Module.t -> 'a -> ('a, 'cmp) t
[@@ocaml.doc
  " Creates a set based on the provided comparator that contains only the provided\n\
  \    element. "]

val length : (_, _) t -> int [@@ocaml.doc " Returns the cardinality of the set. [O(1)]. "]

val is_empty : (_, _) t -> bool
[@@ocaml.doc " [is_empty t] is [true] iff [t] is empty.  [O(1)]. "]

val mem : ('a, _) t -> 'a -> bool
[@@ocaml.doc " [mem t a] returns [true] iff [a] is in [t].  [O(log n)]. "]

val add : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t
[@@ocaml.doc
  " [add t a] returns a new set with [a] added to [t], or returns [t] if [mem t a].\n\
  \    [O(log n)]. "]

val remove : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t
[@@ocaml.doc
  " [remove t a] returns a new set with [a] removed from [t] if [mem t a], or returns [t]\n\
  \    otherwise.  [O(log n)]. "]

val union : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
[@@ocaml.doc
  " [union t1 t2] returns the union of the two sets.  [O(length t1 + length t2)]. "]

val union_list : ('a, 'cmp) Comparator.Module.t -> ('a, 'cmp) t list -> ('a, 'cmp) t
[@@ocaml.doc
  " [union c list] returns the union of all the sets in [list]. The [c] argument is\n\
  \    required for the case where [list] is empty. [O(max(List.length list, n log n))],\n\
  \    where [n] is the sum of sizes of the input sets.\n"]

val inter : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
[@@ocaml.doc
  " [inter t1 t2] computes the intersection of sets [t1] and [t2].  [O(length t1 +\n\
  \    length t2)]. "]

val diff : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
[@@ocaml.doc
  " [diff t1 t2] computes the set difference [t1 - t2], i.e., the set containing all\n\
  \    elements in [t1] that are not in [t2].  [O(length t1 + length t2)]. "]

val symmetric_diff : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'a) Either.t Sequence.t
[@@ocaml.doc
  " [symmetric_diff t1 t2] returns a sequence of changes between [t1] and [t2]. It is\n\
  \    intended to be efficient in the case where [t1] and [t2] share a large amount of\n\
  \    structure. In the case where [t2] (resp. [t1]) is obtained by applying k additions\n\
  \    and/or removals to [t1] (resp. [t2]), this runs in [min(O(k log n), O(n))], where \
   [n]\n\
  \    is [length t1 + length t2]. "]

val compare_direct : ('a, 'cmp) t -> ('a, 'cmp) t -> int
[@@ocaml.doc
  " [compare_direct t1 t2] compares the sets [t1] and [t2].  It returns the same result\n\
  \    as [compare], but unlike compare, doesn't require arguments to be passed in for the\n\
  \    type parameters of the set.  [O(length t1 + length t2)]. "]

val hash_fold_direct : 'a Hash.folder -> ('a, 'cmp) t Hash.folder
[@@ocaml.doc
  " Hash function: a building block to use when hashing data structures containing sets in\n\
  \    them. [hash_fold_direct hash_fold_key] is compatible with [compare_direct] iff\n\
  \    [hash_fold_key] is compatible with [(comparator s).compare] of the set [s] being\n\
  \    hashed. "]

val equal : ('a, 'cmp) t -> ('a, 'cmp) t -> bool
[@@ocaml.doc
  " [equal t1 t2] returns [true] iff the two sets have the same elements.  [O(length t1 +\n\
  \    length t2)] "]

val exists : ('a, _) t -> f:('a -> bool) -> bool
[@@ocaml.doc
  " [exists t ~f] returns [true] iff there exists an [a] in [t] for which [f a].  [O(n)],\n\
  \    but returns as soon as it finds an [a] for which [f a]. "]

val for_all : ('a, _) t -> f:('a -> bool) -> bool
[@@ocaml.doc
  " [for_all t ~f] returns [true] iff for all [a] in [t], [f a].  [O(n)], but returns as\n\
  \    soon as it finds an [a] for which [not (f a)]. "]

val count : ('a, _) t -> f:('a -> bool) -> int
[@@ocaml.doc
  " [count t] returns the number of elements of [t] for which [f] returns [true].\n\
  \    [O(n)]. "]

val sum
  :  (module Container.Summable with type t = 'sum)
  -> ('a, _) t
  -> f:('a -> 'sum)
  -> 'sum
[@@ocaml.doc " [sum t] returns the sum of [f t] for each [t] in the set.\n    [O(n)]. "]

val find : ('a, _) t -> f:('a -> bool) -> 'a option
[@@ocaml.doc
  " [find t f] returns an element of [t] for which [f] returns true, with no guarantee as\n\
  \    to which element is returned.  [O(n)], but returns as soon as a suitable element is\n\
  \    found. "]

val find_map : ('a, _) t -> f:('a -> 'b option) -> 'b option
[@@ocaml.doc
  " [find_map t f] returns [b] for some [a] in [t] for which [f a = Some b].  If no such\n\
  \    [a] exists, then [find] returns [None].  [O(n)], but returns as soon as a suitable\n\
  \    element is found. "]

val find_exn : ('a, _) t -> f:('a -> bool) -> 'a
[@@ocaml.doc " Like [find], but throws an exception on failure. "]

val nth : ('a, _) t -> int -> 'a option
[@@ocaml.doc
  " [nth t i] returns the [i]th smallest element of [t], in [O(log n)] time.  The\n\
  \    smallest element has [i = 0].  Returns [None] if [i < 0] or [i >= length t]. "]

val remove_index : ('a, 'cmp) t -> int -> ('a, 'cmp) t
[@@ocaml.doc
  " [remove_index t i] returns a version of [t] with the [i]th smallest element removed,\n\
  \    in [O(log n)] time.  The smallest element has [i = 0].  Returns [t] if [i < 0] or\n\
  \    [i >= length t]. "]

val is_subset : ('a, 'cmp) t -> of_:('a, 'cmp) t -> bool
[@@ocaml.doc " [is_subset t1 ~of_:t2] returns true iff [t1] is a subset of [t2]. "]

val are_disjoint : ('a, 'cmp) t -> ('a, 'cmp) t -> bool
[@@ocaml.doc
  " [are_disjoint t1 t2] returns [true] iff [is_empty (inter t1 t2)], but is more\n\
  \    efficient. "]

module Named : sig
  type ('a, 'cmp) set := ('a, 'cmp) t

  type 'a t = 'a Set.Named.t =
    { set : 'a
    ; name : string
    }

  val is_subset : ('a, 'cmp) set t -> of_:('a, 'cmp) set t -> unit Or_error.t
  [@@ocaml.doc
    " [is_subset t1 ~of_:t2] returns [Ok ()] if [t1] is a subset of [t2] and a\n\
    \      human-readable error otherwise.  "]

  val equal : ('a, 'cmp) set t -> ('a, 'cmp) set t -> unit Or_error.t
  [@@ocaml.doc
    " [equal t1 t2] returns [Ok ()] if [t1] is equal to [t2] and a human-readable\n\
    \      error otherwise.  "]
end
[@@ocaml.doc
  " [Named] allows the validation of subset and equality relationships between sets.  A\n\
  \    [Named.t] is a record of a set and a name, where the name is used in error \
   messages,\n\
  \    and [Named.is_subset] and [Named.equal] validate subset and equality relationships\n\
  \    respectively.\n\n\
  \    The error message for, e.g.,\n\
  \    {[\n\
  \      Named.is_subset { set = set1; name = \"set1\" } ~of_:{set = set2; name = \
   \"set2\" }\n\
  \    ]}\n\n\
  \    looks like\n\
  \    {v\n\
  \       (\"set1 is not a subset of set2\" (invalid_elements (...elements of set1 - \
   set2...)))\n\
  \    v}\n\n\
  \    so [name] should be a noun phrase that doesn't sound awkward in the above error\n\
  \    message.  Even though it adds verbosity, choosing [name]s that start with the \
   phrase\n\
  \    \"the set of\" often makes the error message sound more natural.\n"]

val of_list : ('a, 'cmp) Comparator.Module.t -> 'a list -> ('a, 'cmp) t
[@@ocaml.doc " The list or array given to [of_list] and [of_array] need not be sorted. "]

val of_sequence : ('a, 'cmp) Comparator.Module.t -> 'a Sequence.t -> ('a, 'cmp) t
val of_array : ('a, 'cmp) Comparator.Module.t -> 'a array -> ('a, 'cmp) t
val of_hash_set : ('a, 'cmp) Comparator.Module.t -> 'a Hash_set.t -> ('a, 'cmp) t
val of_hashtbl_keys : ('a, 'cmp) Comparator.Module.t -> ('a, _) Hashtbl.t -> ('a, 'cmp) t

val to_list : ('a, _) t -> 'a list
[@@ocaml.doc
  " [to_list] and [to_array] produce sequences sorted in ascending order according to the\n\
  \    comparator. "]

val to_array : ('a, _) t -> 'a array
val to_tree : ('a, 'cmp) t -> ('a, 'cmp) Tree.t
val of_tree : ('a, 'cmp) Comparator.Module.t -> ('a, 'cmp) Tree.t -> ('a, 'cmp) t

val of_sorted_array
  :  ('a, 'cmp) Comparator.Module.t
  -> 'a array
  -> ('a, 'cmp) t Or_error.t
[@@ocaml.doc
  " Create set from sorted array.  The input must be sorted (either in ascending or\n\
  \    descending order as given by the comparator) and contain no duplicates, otherwise \
   the\n\
  \    result is an error.  The complexity of this function is [O(n)]. "]

val of_sorted_array_unchecked : ('a, 'cmp) Comparator.Module.t -> 'a array -> ('a, 'cmp) t
[@@ocaml.doc " Similar to [of_sorted_array], but without checking the input array. "]

val of_increasing_iterator_unchecked
  :  ('a, 'cmp) Comparator.Module.t
  -> len:int
  -> f:(int -> 'a)
  -> ('a, 'cmp) t
[@@ocaml.doc
  " [of_increasing_iterator_unchecked c ~len ~f] behaves like\n\
  \    [of_sorted_array_unchecked c (Array.init len ~f)], with the additional\n\
  \    restriction that a decreasing order is not supported.  The advantage is not \
   requiring\n\
  \    you to allocate an intermediate array.  [f] will be called with 0, 1, ... [len - \
   1],\n\
  \    in order. "]

val stable_dedup_list : ('a, _) Comparator.Module.t -> 'a list -> 'a list
[@@ocaml.doc
  " [stable_dedup_list] is here rather than in the [List] module because the\n\
  \    implementation relies crucially on sets, and because doing so allows one to avoid \
   uses\n\
  \    of polymorphic comparison by instantiating the functor at a different \
   implementation\n\
  \    of [Comparator] and using the resulting [stable_dedup_list]. "]
[@@deprecated "[since 2023-04] Use [List.stable_dedup] instead."]

val map : ('b, 'cmp) Comparator.Module.t -> ('a, _) t -> f:('a -> 'b) -> ('b, 'cmp) t
[@@ocaml.doc
  " [map c t ~f] returns a new set created by applying [f] to every element in [t]. The\n\
  \    returned set is based on the provided [c]. [O(n log n)]. "]

val filter_map
  :  ('b, 'cmp) Comparator.Module.t
  -> ('a, _) t
  -> f:('a -> 'b option)
  -> ('b, 'cmp) t
[@@ocaml.doc
  " Like {!map}, except elements for which [f] returns [None] will be dropped.  "]

val filter : ('a, 'cmp) t -> f:('a -> bool) -> ('a, 'cmp) t
[@@ocaml.doc
  " [filter t ~f] returns the subset of [t] for which [f] evaluates to true.  [O(n log\n\
  \    n)]. "]

val fold : ('a, _) t -> init:'accum -> f:('accum -> 'a -> 'accum) -> 'accum
[@@ocaml.doc
  " [fold t ~init ~f] folds over the elements of the set from smallest to largest. "]

val fold_result
  :  ('a, _) t
  -> init:'accum
  -> f:('accum -> 'a -> ('accum, 'e) Result.t)
  -> ('accum, 'e) Result.t
[@@ocaml.doc
  " [fold_result ~init ~f] folds over the elements of the set from smallest to\n\
  \    largest, short circuiting the fold if [f accum x] is an [Error _] "]

val fold_until
  :  ('a, _) t
  -> init:'accum
  -> f:('accum -> 'a -> ('accum, 'final) Continue_or_stop.t)
  -> finish:('accum -> 'final)
  -> 'final
[@@ocaml.doc
  " [fold_until t ~init ~f] is a short-circuiting version of [fold]. If [f]\n\
  \    returns [Stop _] the computation ceases and results in that value. If [f] returns\n\
  \    [Continue _], the fold will proceed. "]

val fold_right : ('a, _) t -> init:'accum -> f:('a -> 'accum -> 'accum) -> 'accum
[@@ocaml.doc
  " Like {!fold}, except that it goes from the largest to the smallest element. "]

val iter : ('a, _) t -> f:('a -> unit) -> unit
[@@ocaml.doc
  " [iter t ~f] calls [f] on every element of [t], going in order from the smallest to\n\
  \    largest.  "]

val iter2
  :  ('a, 'cmp) t
  -> ('a, 'cmp) t
  -> f:([ `Left of 'a | `Right of 'a | `Both of 'a * 'a ] -> unit)
  -> unit
[@@ocaml.doc
  " Iterate two sets side by side.  Complexity is [O(m+n)] where [m] and [n] are the sizes\n\
  \    of the two input sets.  As an example, with the inputs [0; 1] and [1; 2], [f] \
   will be\n\
  \    called with [`Left 0]; [`Both (1, 1)]; and [`Right 2]. "]

val partition_tf : ('a, 'cmp) t -> f:('a -> bool) -> ('a, 'cmp) t * ('a, 'cmp) t
[@@ocaml.doc
  " If [a, b = partition_tf set ~f] then [a] is the elements on which [f] produced [true],\n\
  \    and [b] is the elements on which [f] produces [false]. "]

val elements : ('a, _) t -> 'a list [@@ocaml.doc " Same as {!to_list}. "]

val min_elt : ('a, _) t -> 'a option
[@@ocaml.doc " Returns the smallest element of the set.  [O(log n)]. "]

val min_elt_exn : ('a, _) t -> 'a
[@@ocaml.doc " Like {!min_elt}, but throws an exception when given an empty set. "]

val max_elt : ('a, _) t -> 'a option
[@@ocaml.doc " Returns the largest element of the set.  [O(log n)].  "]

val max_elt_exn : ('a, _) t -> 'a
[@@ocaml.doc " Like {!max_elt}, but throws an exception when given an empty set. "]

val choose : ('a, _) t -> 'a option
[@@ocaml.doc " returns an arbitrary element, or [None] if the set is empty. "]

val choose_exn : ('a, _) t -> 'a
[@@ocaml.doc " Like {!choose}, but throws an exception on an empty set. "]

val split : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * 'a option * ('a, 'cmp) t
[@@ocaml.doc
  " [split t x] produces a triple [(t1, maybe_x, t2)].\n\n\
  \    [t1] is the set of elements strictly less than [x],\n\
  \    [maybe_x] is the member (if any) of [t] which compares equal to [x],\n\
  \    [t2] is the set of elements strictly larger than [x]. "]

val split_le_gt : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * ('a, 'cmp) t
[@@ocaml.doc
  " [split_le_gt t x] produces a pair [(t1, t2)].\n\n\
  \    [t1] is the set of elements less than or equal to [x],\n\
  \    [t2] is the set of elements strictly larger than [x]. "]

val split_lt_ge : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * ('a, 'cmp) t
[@@ocaml.doc
  " [split_lt_ge t x] produces a pair [(t1, t2)].\n\n\
  \    [t1] is the set of elements strictly less than [x],\n\
  \    [t2] is the set of elements larger or equal to [x]. "]

val group_by : ('a, 'cmp) t -> equiv:('a -> 'a -> bool) -> ('a, 'cmp) t list
[@@ocaml.doc
  " If [equiv] is an equivalence predicate, then [group_by set ~equiv] produces a list\n\
  \    of equivalence classes (i.e., a set-theoretic quotient).  E.g.,\n\n\
  \    {[\n\
  \      let chars = Set.of_list ['A'; 'a'; 'b'; 'c'] in\n\
  \      let equiv c c' = Char.equal (Char.uppercase c) (Char.uppercase c') in\n\
  \      group_by chars ~equiv\n\
  \    ]}\n\n\
  \    produces:\n\n\
  \    {[\n\
  \      [Set.of_list ['A';'a']; Set.singleton 'b'; Set.singleton 'c']\n\
  \    ]}\n\n\
  \    [group_by] runs in O(n^2) time, so if you have a comparison function, it's usually\n\
  \    much faster to use [Set.of_list]. "]

val to_sequence
  :  ?order:[ `Increasing [@ocaml.doc " default "] | `Decreasing ]
  -> ?greater_or_equal_to:'a
  -> ?less_or_equal_to:'a
  -> ('a, 'cmp) t
  -> 'a Sequence.t
[@@ocaml.doc
  " [to_sequence t] converts the set [t] to a sequence of the elements between\n\
  \    [greater_or_equal_to] and [less_or_equal_to] inclusive in the order indicated by\n\
  \    [order].  If [greater_or_equal_to > less_or_equal_to] the sequence is empty.  \
   Cost is\n\
  \    O(log n) up front and amortized O(1) for each element produced. "]

val binary_search
  :  ('a, 'cmp) t
  -> compare:('a -> 'key -> int)
  -> [ `Last_strictly_less_than
       [@ocaml.doc "        {v | < elt X |                       v} "]
     | `Last_less_than_or_equal_to
       [@ocaml.doc "     {v |      <= elt       X |           v} "]
     | `Last_equal_to
       [@ocaml.doc "                  {v           |   = elt X |           v} "]
     | `First_equal_to
       [@ocaml.doc "                 {v           | X = elt   |           v} "]
     | `First_greater_than_or_equal_to
       [@ocaml.doc " {v           | X       >= elt      | v} "]
     | `First_strictly_greater_than
       [@ocaml.doc "    {v                       | X > elt | v} "]
     ]
  -> 'key
  -> 'a option
[@@ocaml.doc
  " [binary_search t ~compare which elt] returns the element in [t] specified by\n\
  \    [compare] and [which], if one exists.\n\n\
  \    [t] must be sorted in increasing order according to [compare], where [compare] and\n\
  \    [elt] divide [t] into three (possibly empty) segments:\n\n\
  \    {v\n\
  \      |  < elt  |  = elt  |  > elt  |\n\
  \    v}\n\n\
  \    [binary_search] returns an element on the boundary of segments as specified by\n\
  \    [which].  See the diagram below next to the [which] variants.\n\n\
  \    [binary_search] does not check that [compare] orders [t], and behavior is\n\
  \    unspecified if [compare] doesn't order [t].  Behavior is also unspecified if\n\
  \    [compare] mutates [t]. "]

val binary_search_segmented
  :  ('a, 'cmp) t
  -> segment_of:('a -> [ `Left | `Right ])
  -> [ `Last_on_left | `First_on_right ]
  -> 'a option
[@@ocaml.doc
  " [binary_search_segmented t ~segment_of which] takes a [segment_of] function that\n\
  \    divides [t] into two (possibly empty) segments:\n\n\
  \    {v\n\
  \      | segment_of elt = `Left | segment_of elt = `Right |\n\
  \    v}\n\n\
  \    [binary_search_segmented] returns the element on the boundary of the segments as\n\
  \    specified by [which]: [`Last_on_left] yields the last element of the left segment,\n\
  \    while [`First_on_right] yields the first element of the right segment.  It returns\n\
  \    [None] if the segment is empty.\n\n\
  \    [binary_search_segmented] does not check that [segment_of] segments [t] as in the\n\
  \    diagram, and behavior is unspecified if [segment_of] doesn't segment [t].  Behavior\n\
  \    is also unspecified if [segment_of] mutates [t]. "]

module Merge_to_sequence_element : sig
  type ('a, 'b) t = ('a, 'b) Sequence.Merge_with_duplicates_element.t =
    | Left of 'a
    | Right of 'b
    | Both of 'a * 'b
  [@@deriving bin_io, compare, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S2 with type ('a, 'b) t := ('a, 'b) t
    include Ppx_compare_lib.Comparable.S2 with type ('a, 'b) t := ('a, 'b) t
    include Sexplib0.Sexpable.S2 with type ('a, 'b) t := ('a, 'b) t

    val t_sexp_grammar
      :  'a Sexplib0.Sexp_grammar.t
      -> 'b Sexplib0.Sexp_grammar.t
      -> ('a, 'b) t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Produces the elements of the two sets between [greater_or_equal_to] and\n\
  \    [less_or_equal_to] in [order], noting whether each element appears in the left set,\n\
  \    the right set, or both.  In the both case, both elements are returned, in case the\n\
  \    caller can distinguish between elements that are equal to the sets' comparator.  \
   Runs\n\
  \    in O(length t + length t'). "]

val merge_to_sequence
  :  ?order:[ `Increasing [@ocaml.doc " default "] | `Decreasing ]
  -> ?greater_or_equal_to:'a
  -> ?less_or_equal_to:'a
  -> ('a, 'cmp) t
  -> ('a, 'cmp) t
  -> ('a, 'a) Merge_to_sequence_element.t Sequence.t

val to_map : ('key, 'cmp) t -> f:('key -> 'data) -> ('key, 'data, 'cmp) Base.Map.t
[@@ocaml.doc
  " Convert a set to or from a map.  [to_map] takes a function to produce data for each\n\
  \    key.  Both functions run in O(n) time (assuming the function passed to [to_map] \
   runs\n\
  \    in constant time). "]

val of_map_keys : ('key, _, 'cmp) Base.Map.t -> ('key, 'cmp) t

val quickcheck_generator
  :  ('key, 'cmp) Comparator.Module.t
  -> 'key Quickcheck.Generator.t
  -> ('key, 'cmp) t Quickcheck.Generator.t

val quickcheck_observer
  :  'key Quickcheck.Observer.t
  -> ('key, 'cmp) t Quickcheck.Observer.t

val quickcheck_shrinker
  :  'key Quickcheck.Shrinker.t
  -> ('key, 'cmp) t Quickcheck.Shrinker.t

[@@@ocaml.text
  " {2 Polymorphic sets}\n\n\
  \    Module {!Poly} deals with sets that use OCaml's polymorphic comparison to compare\n\
  \    elements.\n"]

module Poly : sig
    type ('a, 'b) set

    module Tree : sig
      type 'elt t = ('elt, Comparator.Poly.comparator_witness) Tree.t
      [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S1 with type 'elt t := 'elt t

        val t_sexp_grammar
          :  'elt Sexplib0.Sexp_grammar.t
          -> 'elt t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Creators_generic
        with type ('a, 'b) set := ('a, 'b) Tree.t
        with type ('elt, 'cmp) t := 'elt t
        with type ('elt, 'cmp) tree := 'elt t
        with type 'c cmp := Comparator.Poly.comparator_witness
        with type 'a elt := 'a
        with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
    end

    type 'elt t = ('elt, Comparator.Poly.comparator_witness) set
    [@@deriving bin_io, compare, sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'elt t := 'elt t
      include Ppx_compare_lib.Comparable.S1 with type 'elt t := 'elt t
      include Sexplib0.Sexpable.S1 with type 'elt t := 'elt t

      val t_sexp_grammar : 'elt Sexplib0.Sexp_grammar.t -> 'elt t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Creators_generic
      with type ('a, 'b) set := ('a, 'b) set
      with type ('elt, 'cmp) t := 'elt t
      with type ('elt, 'cmp) tree := 'elt Tree.t
      with type 'c cmp := Comparator.Poly.comparator_witness
      with type 'a elt := 'a
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
  end
  with type ('a, 'b) set := ('a, 'b) t

[@@@ocaml.text " {2 Signatures and functors for building [Set] modules}  "]

module type Elt_plain = Elt_plain

module type Elt = Elt
[@@ocaml.doc
  " The signature that something needs to match in order to be used as a set element. "]

module type Elt_binable = Elt_binable
[@@ocaml.doc
  " The signature that something needs to match in order to be used as a set element if\n\
  \    the resulting set is going to support [bin_io]. "]

module type S_plain = S_plain
[@@ocaml.doc " Module signature for a Set that doesn't support [of_sexp]. "]

module type S = S [@@ocaml.doc " Module signature for a Set. "]

module type S_binable = S_binable
[@@ocaml.doc " Module signature for a Set that supports [bin_io]. "]

module Make_plain : functor (Elt : Elt_plain) -> S_plain with type Elt.t = Elt.t
[@@ocaml.doc
  " [Make] builds a set from an element type that has a [compare] function but doesn't\n\
  \    have a comparator.  This generates a new comparator.\n\n\
  \    [Make_binable] is similar, except the element and set types support [bin_io]. "]

module Make : functor (Elt : Elt) -> S with type Elt.t = Elt.t
module Make_binable : functor (Elt : Elt_binable) -> S_binable with type Elt.t = Elt.t

module Make_plain_using_comparator : functor
    (Elt : sig
       type t [@@deriving sexp_of]

       include sig
         [@@@ocaml.warning "-32"]

         val sexp_of_t : t -> Sexplib0.Sexp.t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Comparator.S with type t := t
     end)
    ->
  S_plain
  with type Elt.t = Elt.t
  with type Elt.comparator_witness = Elt.comparator_witness

module Make_using_comparator : functor
    (Elt : sig
       type t [@@deriving sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Comparator.S with type t := t
     end)
    ->
  S with type Elt.t = Elt.t with type Elt.comparator_witness = Elt.comparator_witness
[@@ocaml.doc
  " [Make_using_comparator] builds a set from an element type that has a comparator.\n\n\
  \    [Make_binable_using_comparator] is similar, except the element and set types \
   support\n\
  \    [bin_io]. "]

module Make_binable_using_comparator : functor
    (Elt : sig
       type t [@@deriving bin_io, sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Bin_prot.Binable.S with type t := t
         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Comparator.S with type t := t
     end)
    ->
  S_binable
  with type Elt.t = Elt.t
  with type Elt.comparator_witness = Elt.comparator_witness

module Elt_bin_io = Elt_bin_io
include For_deriving with type ('a, 'b) t := ('a, 'b) t

module Make_tree_plain : functor
    (Elt : sig
       type t [@@deriving sexp_of]

       include sig
         [@@@ocaml.warning "-32"]

         val sexp_of_t : t -> Sexplib0.Sexp.t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Comparator.S with type t := t
     end)
    -> Make_S_plain_tree(Elt).S

module Make_tree : functor
    (Elt : sig
       type t [@@deriving sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Comparator.S with type t := t
     end)
    -> sig
  include Make_S_plain_tree(Elt).S
  include Sexpable.S with type t := t
end

module Stable : sig
  module V1 : sig
    type nonrec ('a, 'b) t = ('a, 'b) t

    module type S = sig
      type elt
      type elt_comparator_witness
      type nonrec t = (elt, elt_comparator_witness) t

      include Stable_module_types.S0_without_comparator with type t := t

      include
        Diffable.S with type t := t and type Diff.t = elt Diffable.Set_diff.Stable.V1.t
    end

    include For_deriving with type ('a, 'b) t := ('a, 'b) t
    include For_deriving_stable with type ('a, 'b) t := ('a, 'b) t

    module Make : functor (Elt : Stable_module_types.S0) ->
      S with type elt := Elt.t with type elt_comparator_witness := Elt.comparator_witness

    module With_stable_witness : sig
      module type S = sig
        include S

        val stable_witness : t Stable_witness.t
      end

      module Make : functor (Elt : Stable_module_types.With_stable_witness.S0) ->
        S
        with type elt := Elt.t
        with type elt_comparator_witness := Elt.comparator_witness
    end
  end
end
[@@ocaml.doc " The following types and functors may be used to define stable modules. "]
