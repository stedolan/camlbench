open! Core

include module type of Uopt with type 'a t = 'a Uopt.t [@@ocaml.doc " @@inline "]

include Binable.S1 with type 'a t := 'a t

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving bin_io, sexp, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
