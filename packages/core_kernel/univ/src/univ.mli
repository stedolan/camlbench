[@@@ocaml.text
  " An extensible \"universal\" variant type.\n\n\
  \    Every type id ([Type_equal.Id.t]) corresponds to one branch of the variant type.\n"]

open! Core
open! Import

type t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val type_id_name : t -> string
val type_id_uid : t -> Type_equal.Id.Uid.t
val create : 'a Type_equal.Id.t -> 'a -> t

val does_match : t -> _ Type_equal.Id.t -> bool
[@@ocaml.doc " [does_match t id] returns [true] iff [t] was created by [create id v]. "]

val match_ : t -> 'a Type_equal.Id.t -> 'a option
[@@ocaml.doc
  " [match_ t id] returns [Some v] if [t] was created by [create id v], and returns [None]\n\
  \    otherwise.\n\n\
  \    [match_exn t id] returns [v] if [t] was created by [create id v], and raises\n\
  \    otherwise. "]

val match_exn : t -> 'a Type_equal.Id.t -> 'a

module View : sig
  type t = T : 'a Type_equal.Id.t * 'a -> t
end

val view : t -> View.t
[@@ocaml.doc
  " [view t] provides access to the GADT representation of [t].  This is currently the\n\
  \    same as the underlying representation, but is put in the [View] module to make \
   later\n\
  \    changes to the underlying representation easier. "]
