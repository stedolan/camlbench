type t
[@@ocaml.doc
  " Each move identified in the code is given a unique move ID which can be used to\n\
  \    distinguish it from other moves.\n"]
[@@deriving sexp, compare]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val to_string : t -> string

val zero : t [@@ocaml.doc " Return the 0th move index "]

val succ : t -> t [@@ocaml.doc " Get the next move index "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
