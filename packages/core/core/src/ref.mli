[@@@ocaml.text " This module extends {{!Base.Ref}[Base.Ref]}. "]

open! Import
open Perms.Export

type 'a t = 'a Base.Ref.t = { mutable contents : 'a }
[@@deriving bin_io ~localize, quickcheck, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Ref
  end
  with type 'a t := 'a t
[@@ocaml.doc " @inline "]

module Permissioned : sig
  type (!'a, -'perms) t [@@deriving sexp, bin_io ~localize]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S2 with type (!'a, -'perms) t := ('a, 'perms) t
    include Bin_prot.Binable.S_local2 with type (!'a, -'perms) t := ('a, 'perms) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : 'a -> ('a, [< _ perms ]) t
  val read_only : ('a, [> read ]) t -> ('a, read) t

  val ( ! ) : ('a, [> read ]) t -> 'a
  [@@ocaml.doc " [get] and [(!)] are two names for the same function. "]

  val get : ('a, [> read ]) t -> 'a

  val set : ('a, [> write ]) t -> 'a -> unit
  [@@ocaml.doc " [set] and [(:=)] are two names for the same function. "]

  val ( := ) : ('a, [> write ]) t -> 'a -> unit
  val of_ref : 'a ref -> ('a, [< read_write ]) t
  val to_ref : ('a, [> read_write ]) t -> 'a ref
  val swap : ('a, [> read_write ]) t -> ('a, [> read_write ]) t -> unit
  val replace : ('a, [> read_write ]) t -> ('a -> 'a) -> unit
  val set_temporarily : ('a, [> read_write ]) t -> 'a -> f:(unit -> 'b) -> 'b
end
