[@@@ocaml.text
  " This module extends {{!Base.Option_array}[Base.Option_array]} with\n    bin_io. "]

open! Import

type 'a t = 'a Base.Option_array.t [@@deriving bin_io, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Option_array
  end
  with type 'a t := 'a t
