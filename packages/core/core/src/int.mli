[@@@ocaml.text " This module extends {{!Base.Int}[Base.Int]}. "]

include
  Base.Int.Int_without_module_types
  with type comparator_witness = Base.Int.comparator_witness
[@@ocaml.doc " @inline "]

[@@@ocaml.text
  " Note that [int] is already stable by itself, since as a primitive type it is an\n\
  \    integral part of the sexp / bin_io protocol.  [Int.Stable] exists only to introduce\n\
  \    [Int.Stable.Set] and [Int.Stable.Map], and provide interface uniformity with other\n\
  \    stable types. "]

include
  Int_intf.Extension_with_stable
  with type t := t
   and type comparator_witness := comparator_witness

include sig
  type nonrec t = t [@@deriving bin_io ~localize]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
