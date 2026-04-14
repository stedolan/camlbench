[@@@ocaml.text " This module extends {{!Base.Nativeint}[Base.Nativeint]}. "]

include module type of struct
  include Base.Nativeint
end
[@@ocaml.doc " @inline "]

include
  Int_intf.Extension with type t := t and type comparator_witness := comparator_witness

include sig
    type t [@@deriving bin_io ~localize]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  with type t := t
