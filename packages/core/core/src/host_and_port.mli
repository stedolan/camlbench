[@@@ocaml.text " Type for the commonly-used notion of host and port in networking. "]

open Std_internal

type t =
  { host : string
  ; port : int
  }
[@@deriving hash]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_hash_lib.Hashable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : host:string -> port:int -> t
val host : t -> string
val port : t -> int
val tuple : t -> string * int

include Identifiable with type t := t
include Sexplib.Sexp_grammar.S with type t := t

module Hide_port_in_test : sig
  include Identifiable with type t := t and type comparator_witness = comparator_witness
end

module Stable : sig
  module V1 : sig
    type nonrec t = t
    [@@deriving sexp, sexp_grammar, bin_io, compare, equal, hash, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Base.Stringable.S with type t := t

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
       and type comparator_witness = comparator_witness
  end
end

val type_id : t Type_equal.Id.t
