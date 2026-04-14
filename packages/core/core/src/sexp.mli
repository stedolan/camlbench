[@@@ocaml.text " Code for managing s-expressions. "]

open! Import

type t = Base.Sexp.t =
  | Atom of string
  | List of t list
[@@deriving
  bin_io, compare ~localize, equal ~localize, globalize, hash, sexp, sexp_grammar]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_compare_lib.Comparable.S_local with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
  include Ppx_compare_lib.Equal.S_local with type t := t

  val globalize : t -> t

  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module O : sig
  type sexp = Base.Sexp.t =
    | Atom of string
    | List of t list
end

include Comparable.S with type t := t
include Stringable.S with type t := t
include Quickcheckable.S with type t := t

include module type of struct
    include Sexplib.Sexp
  end
  with type t := t

exception Of_sexp_error of exn * t

val of_float_style : [ `Underscores | `No_underscores ] ref
val of_int_style : [ `Underscores | `No_underscores ] ref

type 'a no_raise = 'a
[@@ocaml.doc
  " [no_raise] is the identity, but by using ['a no_raise] in a sexpable type, the\n\
  \    resulting use [sexp_of_no_raise] protects the conversion of ['a] to a sexp so \
   that if\n\
  \    it fails, one gets a sexp with an error message about the failure, rather than an\n\
  \    exception being raised.\n\n\
  \    WARNING: The resulting [no_raise_of_sexp] can still raise. "]
[@@deriving bin_io, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val bin_shape_no_raise : Bin_prot.Shape.t -> Bin_prot.Shape.t
  val bin_size_no_raise : 'a Bin_prot.Size.sizer -> 'a no_raise Bin_prot.Size.sizer
  val bin_write_no_raise : 'a Bin_prot.Write.writer -> 'a no_raise Bin_prot.Write.writer

  val bin_writer_no_raise
    :  'a Bin_prot.Type_class.writer
    -> 'a no_raise Bin_prot.Type_class.writer

  val bin_read_no_raise : 'a Bin_prot.Read.reader -> 'a no_raise Bin_prot.Read.reader

  val __bin_read_no_raise__
    :  'a Bin_prot.Read.reader
    -> (int -> 'a no_raise) Bin_prot.Read.reader

  val bin_reader_no_raise
    :  'a Bin_prot.Type_class.reader
    -> 'a no_raise Bin_prot.Type_class.reader

  val bin_no_raise : 'a Bin_prot.Type_class.t -> 'a no_raise Bin_prot.Type_class.t
  val sexp_of_no_raise : ('a -> Sexplib0.Sexp.t) -> 'a no_raise -> Sexplib0.Sexp.t
  val no_raise_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a no_raise
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Sexp_maybe : sig
  type 'a t = ('a, Base.Sexp.t * Error.t) Result.t
  [@@deriving bin_io, compare, hash, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " If [sexp_of_t fails], it returns [Error] rather than raising. You can convert values\n\
  \    of this type to and from sexp in processes that can or cannot parse the underlying\n\
  \    sexp in any combination and still recover the original value. Also, the [Error] \
   case\n\
  \    contains a human-readable description of the error.\n\n\
  \    A common use case is to parse most of a sexp even when some small part fails to \
   parse,\n\
  \    e.g.:\n\n\
  \    {[\n\
  \      type query =\n\
  \        | Start of Initial_config.t Sexp_maybe.t\n\
  \        | Stop of  Reason_to_stop.t Sexp_maybe.t\n\
  \      [@@deriving sexp]\n\
  \    ]}\n\n\
  \    If [Reason_to_stop.t_of_sexp] fails, you can still tell it was a [Stop] query.\n"]

module With_text : sig
  type 'a t [@@deriving sexp, sexp_grammar, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

    include Bin_prot.Binable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val of_value : ('a -> Base.Sexp.t) -> 'a -> 'a t
  [@@ocaml.doc
    " Generates a [t] from the value by creating the text automatically using the provided\n\
    \      s-expression converter. "]

  val of_text
    :  (Base.Sexp.t -> 'a)
    -> ?filename:(string[@ocaml.doc " used for error reporting "])
    -> string
    -> 'a t Or_error.t
  [@@ocaml.doc
    " Creates a [t] from the text, by first converting the text to an s-expression, and\n\
    \      then parsing the s-expression with the provided converter. "]

  val value : 'a t -> 'a
  val text : 'a t -> string
end
[@@ocaml.doc
  " A [With_text.t] is a value paired with the full textual representation of its sexp.\n\
  \    This is useful for dealing with the case where you want to keep track of a value \
   along\n\
  \    with the format of the s-expression it was generated from, which allows you to\n\
  \    maintain formatting details, comments, etc.\n\n\
  \    The s-expression representation of a [With_text.t] is the raw text, stored as an \
   atom.\n\
  \    The bin_io representation contains both the bin_io of the underlying value and the\n\
  \    bin_io'd version of the raw text.\n\n\
  \    This is similar to but simpler than the [With_layout] module included above (via\n\
  \    [Sexp_intf.S]), which gives you access to a fully parsed version of the \
   s-expression,\n\
  \    with attached comments and layout information, to allow you to build \
   layout-preserving\n\
  \    s-expression transformations.\n\n\
  \    The invariants of a [x With_text.t] are broken if the [x] value is mutated. "]

val of_sexp_allow_extra_fields_recursively : (Base.Sexp.t -> 'a) -> Base.Sexp.t -> 'a
[@@ocaml.doc
  " [of_sexp_allow_extra_fields_recursively of_sexp sexp] uses [of_sexp] to convert \
   [sexp] to a\n\
  \    value, but will not fail if there are any extra fields in a record (even deeply\n\
  \    nested records).\n\n\
  \    The implementation uses global state, so it is not thread safe. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t =
      | Atom of string
      | List of t list
    [@@deriving
      sexp, bin_io, hash, compare ~localize, equal ~localize, sexp_grammar, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Comparable.S_local with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_compare_lib.Equal.S_local with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
