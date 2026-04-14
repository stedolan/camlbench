[@@@ocaml.text " This module extends {{!Base.Bytes}[Base.Bytes]}. "]

open! Import

type t = bytes [@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local with type t := t
  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Bytes
  end
  with type t := t
[@@ocaml.doc " @inline "]

include Hexdump.S with type t := t
include Quickcheckable.S with type t := t

val gen' : char Quickcheck.Generator.t -> t Quickcheck.Generator.t
[@@ocaml.doc
  " Like [gen], but generate bytes with the given distribution of characters. "]

val gen_with_length : int -> char Quickcheck.Generator.t -> t Quickcheck.Generator.t
[@@ocaml.doc " Like [gen'], but generate bytes with the given length. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize, equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nonrec comparator_witness = comparator_witness

    include
      Stable_module_types.With_stable_witness.S0
      with type t := t
      with type comparator_witness := comparator_witness
  end
end
[@@ocaml.doc
  " Note that [bytes] is already stable by itself, since as a primitive type it is an\n\
  \    integral part of the sexp / bin_io protocol. [Bytes.Stable] exists only to provide\n\
  \    interface uniformity with other stable types. "]
