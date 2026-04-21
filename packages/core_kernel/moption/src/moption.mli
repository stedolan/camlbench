[@@@ocaml.text
  " A [Moption] is a mutable option, like ['a option ref], but with a more efficient\n\
  \    implementation; in particular, [set_some] does not allocate. "]

open! Core
open! Import

type !'a t [@@deriving bin_io, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type !'a t := 'a t
  include Sexplib0.Sexpable.S1 with type !'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t

module Optional_syntax :
  Optional_syntax.S1 with type 'a t := 'a t with type 'a value := 'a

val create : unit -> _ t
val is_none : _ t -> bool
val is_some : _ t -> bool
val get : 'a t -> 'a option
val get_some_exn : 'a t -> 'a

val unsafe_get : 'a t -> 'a
[@@ocaml.doc " Does not check that [is_some] before unsafely accessing the stored value "]

val set : 'a t -> 'a option -> unit
val set_none : _ t -> unit
val set_some : 'a t -> 'a -> unit

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
