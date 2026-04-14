[@@@ocaml.text
  " This module extends {{!Base.Option}[Base.Option]} with bin_io, quickcheck, and support\n\
  \    for ppx_optional. "]

type 'a t = 'a Base.Option.t [@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Option
  end
  with type 'a t := 'a option
[@@ocaml.doc " @inline "]

include Comparator.Derived with type 'a t := 'a t
include Quickcheckable.S1 with type 'a t := 'a t

val validate : none:unit Validate.check -> some:'a Validate.check -> 'a t Validate.check

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t
    [@@deriving
      bin_io ~localize, compare, equal, hash, sexp, sexp_grammar, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Optional_syntax : Optional_syntax.S1 with type 'a t := 'a t and type 'a value := 'a
[@@ocaml.doc
  " You might think that it's pointless to have [Optional_syntax] on options because OCaml\n\
  \    already has nice syntax for matching on options.  The reason to have this here is \
   that\n\
  \    you might have, for example, a tuple of an option and some other type that supports\n\
  \    [Optional_syntax].  Since [Optional_syntax] can only be opted into at the \
   granularity\n\
  \    of the whole match expression, we need this [Optional_syntax] support for options \
   in\n\
  \    order to use it for the other half of the tuple. "]
