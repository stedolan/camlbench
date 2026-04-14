[@@@ocaml.text " Functors and signatures for dealing with modules for tuples.  "]

open! Import

module T2 : sig
  type ('a, 'b) t = 'a * 'b [@@deriving sexp, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S2 with type ('a, 'b) t := ('a, 'b) t
    include Typerep_lib.Typerepable.S2 with type ('a, 'b) t := ('a, 'b) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparator.Derived2 with type ('a, 'b) t := ('a, 'b) t

  val create : 'a -> 'b -> ('a, 'b) t
  val curry : (('a, 'b) t -> 'c) -> 'a -> 'b -> 'c
  val uncurry : ('a -> 'b -> 'c) -> ('a, 'b) t -> 'c

  val compare
    :  cmp1:('a -> 'a -> int)
    -> cmp2:('b -> 'b -> int)
    -> ('a, 'b) t
    -> ('a, 'b) t
    -> int

  val equal
    :  eq1:('a -> 'a -> bool)
    -> eq2:('b -> 'b -> bool)
    -> ('a, 'b) t
    -> ('a, 'b) t
    -> bool

  val get1 : ('a, _) t -> 'a
  val get2 : (_, 'a) t -> 'a

  val map : ('a, 'a) t -> f:('a -> 'b) -> ('b, 'b) t
  val map_fst : ('a, 'b) t -> f:('a -> 'c) -> ('c, 'b) t
  val map_snd : ('a, 'b) t -> f:('b -> 'c) -> ('a, 'c) t
  val map_both : ('a, 'b) t -> f1:('a -> 'c) -> f2:('b -> 'd) -> ('c, 'd) t
  val map2 : ('a, 'a) t -> ('b, 'b) t -> f:('a -> 'b -> 'c) -> ('c, 'c) t
  val swap : ('a, 'b) t -> ('b, 'a) t
end
[@@ocaml.doc " Signature for a 2-tuple module "]

module T3 : sig
  type ('a, 'b, 'c) t = 'a * 'b * 'c [@@deriving sexp, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
    include Typerep_lib.Typerepable.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : 'a -> 'b -> 'c -> ('a, 'b, 'c) t
  val curry : (('a, 'b, 'c) t -> 'd) -> 'a -> 'b -> 'c -> 'd
  val uncurry : ('a -> 'b -> 'c -> 'd) -> ('a, 'b, 'c) t -> 'd

  val equal
    :  eq1:('a -> 'a -> bool)
    -> eq2:('b -> 'b -> bool)
    -> eq3:('c -> 'c -> bool)
    -> ('a, 'b, 'c) t
    -> ('a, 'b, 'c) t
    -> bool

  val compare
    :  cmp1:('a -> 'a -> int)
    -> cmp2:('b -> 'b -> int)
    -> cmp3:('c -> 'c -> int)
    -> ('a, 'b, 'c) t
    -> ('a, 'b, 'c) t
    -> int

  val get1 : ('a, _, _) t -> 'a
  val get2 : (_, 'a, _) t -> 'a
  val get3 : (_, _, 'a) t -> 'a
  val map : ('a, 'a, 'a) t -> f:('a -> 'b) -> ('b, 'b, 'b) t
  val map_fst : ('a, 'b, 'c) t -> f:('a -> 'd) -> ('d, 'b, 'c) t
  val map_snd : ('a, 'b, 'c) t -> f:('b -> 'd) -> ('a, 'd, 'c) t
  val map_trd : ('a, 'b, 'c) t -> f:('c -> 'd) -> ('a, 'b, 'd) t

  val map_all
    :  ('a, 'b, 'c) t
    -> f1:('a -> 'd)
    -> f2:('b -> 'e)
    -> f3:('c -> 'f)
    -> ('d, 'e, 'f) t

  val map2 : ('a, 'a, 'a) t -> ('b, 'b, 'b) t -> f:('a -> 'b -> 'c) -> ('c, 'c, 'c) t
end
[@@ocaml.doc " Signature for a 3-tuple module "]

[@@@ocaml.text
  " These functors allow users to write:\n\
  \    {[\n\
  \      module Foo = struct\n\
  \        include Tuple.Make       (String) (Int)\n\
  \        include Tuple.Comparator (String) (Int)\n\
  \        include Tuple.Comparable (String) (Int)\n\
  \        include Tuple.Hashable   (String) (Int)\n\
  \        include Tuple.Binable    (String) (Int)\n\
  \      end\n\
  \    ]}\n"]

module Make : functor
    (T1 : sig
       type t
     end)
    -> functor
    (T2 : sig
       type t
     end)
    -> sig
  type t = T1.t * T2.t
end

module Comparator : functor (S1 : Comparator.S) -> functor (S2 : Comparator.S) ->
  Comparator.S with type t = Make(S1)(S2).t

module type Comparable_sexpable = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t
end

module Comparable_plain : functor
    (S1 : Comparable.S_plain)
    -> functor
    (S2 : Comparable.S_plain)
    -> sig
  type comparator_witness =
    (S1.comparator_witness, S2.comparator_witness) T2.comparator_witness

  include
    Comparable.S_plain
    with type t := Make(S1)(S2).t
    with type comparator_witness := comparator_witness
end

module Comparable : functor
    (S1 : Comparable_sexpable)
    -> functor
    (S2 : Comparable_sexpable)
    -> Comparable_sexpable with type t := Make(S1)(S2).t

module type Hashable_sexpable = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Hashable.S with type t := t
end

module Hashable : functor (S1 : Hashable_sexpable) -> functor (S2 : Hashable_sexpable) ->
  Hashable_sexpable with type t := Make(S1)(S2).t
[@@ocaml.doc
  " The difference between [Hashable] and [Hashable_t] functors is that the former's\n\
  \    result type doesn't contain type [t] and the latter does. Therefore, [Hashable] \
   can't\n\
  \    be used to combine two pairs into 4-tuple. but [Hashable_t] can. On the other hand\n\
  \    result of [Hashable_t] cannot be combined with [Comparable].\n\n\
  \    example:\n\
  \    module Four_ints = Tuple.Hashable_t (Tuple.Hashable_t (Int)(Int))\n\
  \    (Tuple.Hashable_t (Int)(Int))\n\n\
  \    If instead we used [Hashable] compiler would complain that the input to outer \
   functor\n\
  \    doesn't have type [t].\n\n\
  \    On the other hand:\n\
  \    module Foo = struct\n\
  \    type t = String.t * Int.t\n\
  \    include Tuple.Comparable (String) (Int)\n\
  \    include Tuple.Hashable (String) (Int)\n\
  \    end\n\n\
  \    If we used [Hashable_t] above, the compiler would complain that we have two types \
   [t]\n\
  \    defined.\n\n\
  \    Unfortunately, it is not possible to define just one functor that could be used in\n\
  \    both cases.\n"]

module Hashable_t : functor
    (S1 : Hashable_sexpable)
    -> functor
    (S2 : Hashable_sexpable)
    -> Hashable_sexpable with type t = Make(S1)(S2).t

module Sexpable : functor (S1 : Sexpable.S) -> functor (S2 : Sexpable.S) ->
  Sexpable.S with type t := Make(S1)(S2).t

module Binable : functor (B1 : Binable.S) -> functor (B2 : Binable.S) ->
  Binable.S with type t := Make(B1)(B2).t

module Hasher : functor
    (H1 : sig
       type t [@@deriving compare, hash, sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Comparable.S with type t := t
         include Ppx_hash_lib.Hashable.S with type t := t
         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> functor
    (H2 : sig
       type t [@@deriving compare, hash, sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Comparable.S with type t := t
         include Ppx_hash_lib.Hashable.S with type t := t
         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> Hashable_sexpable with type t := Make(H1)(H2).t
