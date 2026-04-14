[@@@ocaml.text " This module extends {{!Base.Either}[Base.Either]}. "]

type ('f, 's) t = ('f, 's) Base.Either.t =
  | First of 'f
  | Second of 's
[@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local2 with type ('f, 's) t := ('f, 's) t
  include Typerep_lib.Typerepable.S2 with type ('f, 's) t := ('f, 's) t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Either
  end
  with type ('f, 's) t := ('f, 's) t
[@@ocaml.doc " @inline "]

include Comparator.Derived2 with type ('a, 'b) t := ('a, 'b) t
include Quickcheckable.S2 with type ('a, 'b) t := ('a, 'b) t

module Stable : sig
  module V1 : sig
    type nonrec ('f, 's) t = ('f, 's) t =
      | First of 'f
      | Second of 's
    [@@deriving bin_io ~localize, equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local2 with type ('f, 's) t := ('f, 's) t
      include Ppx_compare_lib.Equal.S2 with type ('f, 's) t := ('f, 's) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S2 with type ('f, 's) t := ('f, 's) t
  end
end
