[@@@ocaml.text
  " Extends {{!Base.Ordering}[Base.Ordering]}, intended to make code that matches on the\n\
  \    result of a comparison more concise and easier to read.\n"]

open! Import

type t = Base.Ordering.t =
  | Less
  | Equal
  | Greater
[@@deriving bin_io, compare, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of Base.Ordering with type t := t [@@ocaml.doc " @inline "]
