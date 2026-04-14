[@@@ocaml.text " This module extends {{!Base.Int32}[Base.Int32]}. "]

[@@@ocaml.text " {2 Interface from Base} "]

include module type of struct
  include Base.Int32
end
[@@ocaml.doc " @inline "]

[@@@ocaml.text " {2 Extensions} "]

include
  Int_intf.Extension with type t := t and type comparator_witness := comparator_witness
[@@ocaml.doc " @inline "]

include sig
  type nonrec t = t [@@deriving bin_io ~localize]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
