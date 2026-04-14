[@@@ocaml.text " This module extends {{!Base.Bool}[Base.Bool]}. "]

type t = bool [@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local with type t := t
  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of Base.Bool with type t := t

include
  Identifiable.S
  with type t := t
   and type comparator_witness := Base.Bool.comparator_witness

val of_string_hum : string -> t
[@@ocaml.doc
  "\n\
  \   Human readable parsing. Accepted inputs are (case insensitive):\n\
  \   - true/false\n\
  \   - yes/no\n\
  \   - 1/0\n\
  \   - t/f\n\
  \   - y/n\n"]

include Quickcheckable.S with type t := t

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize, compare, equal, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
      with type comparator_witness = comparator_witness
  end
end
