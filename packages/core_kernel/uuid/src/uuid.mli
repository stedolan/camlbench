[@@@ocaml.text
  " Thread-safe generation of random identifiers in the UUID format.\n\n\
  \    This library is not RFC 4122 compliant: the version is set in the output, but the\n\
  \    variant is not.\n"]

open! Core

type t
[@@ocaml.doc
  " When [am_running_test], [sexp_of_t] masks the UUID, showing only\n\
  \    \"<uuid-omitted-in-test>\". You can use [Unstable.sexp_of_t] if you definitely \
   want to\n\
  \    see it within your tests. "]
[@@deriving hash, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_hash_lib.Hashable.S with type t := t

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Identifiable.S with type t := t
include Invariant.S with type t := t
include Quickcheckable.S with type t := t

val t_of_sexp : Sexp.t -> t
[@@deprecated "[since 2017-11] Use a [Stable] or [Unstable] [t_of_sexp]."]

val create_random : Random.State.t -> t
val arg_type : t Command.Arg_type.t

module Unstable : sig
  type nonrec t = t
  [@@ocaml.doc
    " Unlike the toplevel [sexp_of_t], [Unstable.sexp_of_t] shows the uuid even when\n\
    \      [am_running_test]. Unlike [Stable] deserializers, [Unstable.t_of_sexp] \
     validates the\n\
    \      input. "]
  [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparator.S with type t := t with type comparator_witness = comparator_witness
end

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
      with type comparator_witness = comparator_witness

    include Stringable.S with type t := t

    val for_testing : t
  end
end

[@@@ocaml.text "/*"]

module Private : sig
  val is_valid_exn : t -> unit
  val nil : t
  val create : hostname:string -> pid:int -> t
  val bottom_4_bits_to_hex_char : int -> char
end
