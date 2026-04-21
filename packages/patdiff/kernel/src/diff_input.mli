open! Core
open! Import

type t =
  { name : string
  ; text : string
  }
[@@deriving fields ~getters ~iterators:create]

include sig
  [@@@ocaml.warning "-32-60"]

  val text : t -> string
  val name : t -> string

  module Fields : sig
    val create : name:string -> text:string -> t
  end
end
[@@ocaml.doc "@inline"] [@@merlin.hide]
