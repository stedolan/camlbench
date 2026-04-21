open! Core
open! Import

module Cpuset : sig
  include Validated.S with type raw := Int.Set.t
  include Equal.S with type t := t
end

type t =
  | Inherit
  | Cpuset of Cpuset.t
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]
