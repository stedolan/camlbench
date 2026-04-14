[@@@ocaml.text
  " Module for the type [unit], extended from {{!Base.Unit}[Base.Unit]}.  This is mostly\n\
  \    useful for building functor arguments. "]

open! Import

type t = unit [@@deriving typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Unit
  end
  with type t := t
[@@ocaml.doc " @inline "]

include Identifiable.S with type t := t and type comparator_witness := comparator_witness
include Quickcheckable.S with type t := t

include sig
    type t [@@deriving bin_io ~localize]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  with type t := t

module type S = sig end

type m = (module S)

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S0 with type t := t
  end

  module V2 : sig
    type nonrec t = t [@@deriving bin_io ~localize, equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S0 with type t := t
  end
  [@@ocaml.doc
    " Zero-length bin_prot format.\n\n\
    \      The default converter for the type [unit] is the V1 converter, not the V2.  \
     That's\n\
    \      because there's an assumption that primitive types, which include [unit], are \
     stable\n\
    \      whether or not they say so, so we can't change the [unit] bin-io converter \
     without\n\
    \      breaking many stable types.  "]
end
