[@@@ocaml.text
  " A ['a Set_once.t] is like an ['a option ref] that can only be set once.  A\n\
  \    [Set_once.t] starts out as [None], the first [set] transitions it to [Some], and\n\
  \    subsequent [set]s fail.\n\n\
  \    Equality is determined only by the internal value and not the source code position\n\
  \    of where the value was set. "]

open! Import

type 'a t [@@deriving compare, equal, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t [@@ocaml.doc " Passes when unset. "]

val create : unit -> _ t
val set : 'a t -> Source_code_position.t -> 'a -> unit Or_error.t
val set_exn : 'a t -> Source_code_position.t -> 'a -> unit

val set_if_none : 'a t -> Source_code_position.t -> 'a -> unit
[@@ocaml.doc
  " [set_if_none t here a] will do nothing if [is_some t], otherwise it will [set_exn t\n\
  \    here a]. "]

val get : 'a t -> 'a option
val get_exn : 'a t -> Source_code_position.t -> 'a
val is_none : _ t -> bool
val is_some : _ t -> bool
val iter : 'a t -> f:('a -> unit) -> unit

module Optional_syntax :
  Optional_syntax.S1 with type 'a t := 'a t with type 'a value := 'a identity

module Unstable : sig
  type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
