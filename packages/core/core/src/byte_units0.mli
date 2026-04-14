open! Import
module Repr = Int63

type t [@@deriving compare, hash, sexp_of, typerep] [@@immediate64]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t

  val sexp_of_t : t -> Sexplib0.Sexp.t

  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val to_string : t -> string
val to_string_hum : t -> string
val of_repr : Repr.t -> t
val to_repr : t -> Repr.t
val bytes_int_exn : t -> int
