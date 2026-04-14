type t
[@@ocaml.doc
  " [Shape.t] are constructed by the [bin_shape] syntax extension from OCaml type\n\
  \    definitions & expressions.\n\n\
  \    There is a direct mapping from ocaml type definition syntax to the corresponding\n\
  \    [Shape.group] and from ocaml type expression syntax to the corresponding [Shape.t].\n"]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text
  " [Tid.t] & [Vid.t] are identifiers for type-constructors & type-vars.\n\
  \    i.e. Given [type 'a t = ... ] "]

module Tid : sig
  type t

  val of_string : string -> t
end

module Vid : sig
  type t

  val of_string : string -> t
end

module Location : sig
  type t

  val of_string : string -> t
end
[@@ocaml.doc
  " [Location.t] is required when constructing shapes for which evaluation might fail. "]

module Uuid : sig
  type t

  val of_string : string -> t
  [@@ocaml.doc
    " [of_string s] returns a [Uuid.t] wrapping [s].\n\
    \      There are currently no requirements of the format of [s] although it is \
     common to\n\
    \      use string in `uuid' format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX\n\
    \      There is also no attempt to detect & reject duplicates "]

  val to_string : t -> string
end
[@@ocaml.doc " [Uuid.t] is used by [basetype] and [annotate]. "]

type group [@@ocaml.doc " group of mutually recursive type definitions "]

val group : Location.t -> (Tid.t * Vid.t list * t) list -> group
[@@ocaml.doc " This function is generative; repeated calls create distinct groups "]

val tuple : t list -> t
val record : (string * t) list -> t
val variant : (string * t list) list -> t

type poly_variant_row

val constr : string -> t option -> poly_variant_row
val inherit_ : Location.t -> t -> poly_variant_row
val poly_variant : Location.t -> poly_variant_row list -> t

val rec_app : Tid.t -> t list -> t
[@@ocaml.doc " recursive apps within the current group "]

val top_app : group -> Tid.t -> t list -> t [@@ocaml.doc " apps from outside the group "]

val var : Location.t -> Vid.t -> t

val basetype : Uuid.t -> t list -> t
[@@ocaml.doc
  " Built-in types and types with custom serialization: i.e. int,list,...  To avoid\n\
  \    accidental protocol compatibility, pass a UUID as the [string] argument "]

val annotate : Uuid.t -> t -> t
[@@ocaml.doc
  " [a = annotate s t] creates a shape [a] distinguished, but dependent on shape [t].\n\
  \    Very much as [record [(s,t)]] does.\n\
  \    But with [annotate] the ocaml record type does not exist. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

[@@@ocaml.text
  " [Shape.Canonical.t] is the result of [eval]uating a shape to a canonical form, and\n\
  \    represents the shape of OCaml types w.r.t. bin_io serialization.\n\n\
  \    The idea is that de-serialization is safe if the canonical-shape for the type \
   produced\n\
  \    by de-serialization is equivalent to the canonical-shape of the serialized type.\n\n\
  \    The representation is canonical, so equivalence is structural equality.\n\n\
  \    [Canonical.t] also provides a useful human level description of a type.\n\n\
  \    A [Canonical.t] can be `digested' to a [Digest.t], and except for nearly impossible\n\
  \    hash collisions, equality of the digests implies equality of canonical-shapes and\n\
  \    hence equivalence at the Shape.t level.\n\n\
  \    [Canonical.t] may also be constructed with various functions:\n\
  \    [annotate, basetype, tuple, record, variant, poly_variant, fix, recurse, ..]\n\
  \    which might be used when setting up unit tests or expected shapes. "]

module Digest : sig
  type t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_hex : t -> string
  val to_md5 : t -> Md5_lib.t
  val of_md5 : Md5_lib.t -> t
end

module Expert : sig
  module Sorted_table : sig
    type 'a t [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val expose : 'a t -> (string * 'a) list
  end

  module Canonical_exp_constructor : sig
    type 'a t =
      | Annotate of Uuid.t * 'a
      | Base of Uuid.t * 'a list
      | Tuple of 'a list
      | Record of (string * 'a) list
      | Variant of (string * 'a list) list
      | Poly_variant of 'a option Sorted_table.t
      | Application of 'a * 'a list
      | Rec_app of int * 'a list
      | Var of int
    [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Canonical : sig
    module Exp1 : sig
      type t0 = Exp of t0 Canonical_exp_constructor.t [@@deriving compare, sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val compare_t0 : t0 -> (t0[@merlin.hide]) -> int
        val sexp_of_t0 : t0 -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type t = Exp1.t0 [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Canonical : sig
  type t = Expert.Canonical.t [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string_hum : t -> string
  val to_digest : t -> Digest.t

  module Exp : sig
    type t
  end

  module Def : sig
    type t
  end

  module Create : sig
    val annotate : Uuid.t -> Exp.t -> Exp.t
    [@@ocaml.doc
      " [Create.create defs exp] constructs a canonical-shape. The [defs] give context for\n\
      \        sub-expressions of the form: [apply n exps]; [n] being a reference to the \
       n'th\n\
      \        definition in [defs].\n\n\
      \        Definition are required for [record]s and [variant]s, but may also occurs \
       for any\n\
      \        cyclic expression: in this case being constructed using [define].\n\n\
      \        Within a definition body, [var i] refers to the i'th formal type-var, and\n\
      \        corresponds to the i'the argument of an application [args]. "]

    val basetype : Uuid.t -> Exp.t list -> Exp.t
    val tuple : Exp.t list -> Exp.t
    val poly_variant : Location.t -> (string * Exp.t option) list -> Exp.t
    val var : int -> Exp.t
    val apply : Def.t -> Exp.t list -> Exp.t
    val recurse : int -> Exp.t list -> Exp.t
    val define : Exp.t -> Def.t
    val record : (string * Exp.t) list -> Exp.t
    val variant : (string * Exp.t list) list -> Exp.t
    val create : Exp.t -> t
  end
end

val eval : t -> Canonical.t
[@@ocaml.doc
  " [eval t] returns the canonical-shape for a shape-expression [Shape.t]. Type aliases\n\
  \    are expanded, so that no [Tid.t] or [Vid.t] have significance in the resulting\n\
  \    canonical-shape. Type-recursion, including non-regular recursion, is translated \
   to the\n\
  \    de-bruijn representation used in canonical-shapes. "]

val eval_to_digest : t -> Digest.t
[@@ocaml.doc
  " [eval_to_digest t] returns a hash-value direct from the [Shape.t], potentially\n\
  \    avoiding the intermediate [Canonical.t] from being constructed. This is important \
   as\n\
  \    the size of a canonical-shape might be exponential in terms of the size of the \
   shape\n\
  \    expression.  The following holds:\n\
  \    [ Digest.(eval_to_digest exp = Canonical.to_digest (eval exp)) ] "]

val eval_to_digest_string : t -> string
[@@ocaml.doc
  " [eval_to_digest_string t] ==  [Digest.to_hex (eval_to_digest t)]\n\
  \    Convenience function useful for writing unit tests. "]

module For_typerep : sig
  val deconstruct_tuple_exn : t -> t list
end
