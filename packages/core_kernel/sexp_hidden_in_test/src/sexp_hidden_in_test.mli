open! Core

type 'a t = 'a
[@@ocaml.doc
  " ['a t] is a type that uses [Core.am_running_test] to determine if it should\n\
  \    use the ['a] sexp serializer, or serialize the type as '<hidden_in_test>'.\n\
  \    It can be thought of as a form of [@sexp.opaque] that is conditional upon if \
   tests are\n\
  \    running. "]
[@@deriving bin_io, compare, equal, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module With_non_roundtripping_in_test_of_sexp : sig
  type 'a t = 'a [@@deriving bin_io, compare, equal, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " This type also derives [sexp]. This will not allow you to roundtrip values you create\n\
  \    in tests and should be used carefully. "]
