type 'a t =
  | []
  | ( :: ) of 'a * 'a t
[@@ocaml.doc
  " [Reversed_list] is constructed the same way as a list, but it needs to be reversed\n\
  \    before it can be used. This is helpful when building up a list in reverse order to\n\
  \    force reversal before use. "]
[@@deriving equal]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text
  " The API of [Reversed_list] is purposely minimal to encourage destructing the list near\n\
  \    the point of construction. Callers that are motivated to extend this API to avoid \
   the\n\
  \    overhead of reversal may be better off using a queue. "]

val of_list_rev : 'a list -> 'a t [@@ocaml.doc " [of_list_rev] reverses the input list. "]

val rev : 'a t -> 'a list
val rev_append : 'a t -> 'a list -> 'a list
val rev_map : 'a t -> f:('a -> 'b) -> 'b list
val rev_filter_map : 'a t -> f:('a -> 'b option) -> 'b list
val is_empty : 'a t -> bool
val length : 'a t -> int

module With_sexp_of : sig
  type nonrec 'a t = 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Renders sexps without reversing the list. E.g. [1::2] is represented as [(1 2)].\n\
  \    [of_sexp] and other derivations are not supported because [Reversed_list] is \
   meant to\n\
  \    be a more ephemeral type and [of_sexp] is only provided for printing convenience,\n\
  \    e.g., for expect tests. Callers that are motivated to add derivations because they\n\
  \    want to use [Reversed_list] as part of a type may be better off defining a custom \
   type\n\
  \    with a more meaningful name that conveys what the ordering represents instead of a\n\
  \    generic \"reversed list.\"  "]

module With_rev_sexp_of : sig
  type nonrec 'a t = 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Renders sexps after reversing the list. E.g. [1::2] is represented as [(2 1)]. See\n\
  \    [With_sexp_of] for why only [sexp_of] is provided. "]
