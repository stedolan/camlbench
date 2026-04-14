[@@@ocaml.text " Process ID. "]

open! Import

type t [@@deriving bin_io, hash, sexp, quickcheck] [@@immediate]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
  include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Identifiable.S with type t := t

val of_int : int -> t
val to_int : t -> int

val init : t
[@@ocaml.doc " The pid of the \"init\" process, which is [1] by convention. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
       and type comparator_witness = comparator_witness
  end
end
