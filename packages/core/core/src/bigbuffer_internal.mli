open! Import

type t =
  { mutable bstr : Bigstring.t
  ; mutable pos : int
  ; mutable len : int
  ; init : Bigstring.t
  }
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val resize : t -> int -> unit
