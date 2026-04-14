open! Base

[@@@ocaml.text
  " Helpers for working with Bigarrays.\n\n\
  \    These are not in [Base] because it's rare to work with bigarrays other than \
   bigstring.\n\
  \    We can move them into a separate library if there is demand. "]

module Layout : sig
  type 'a t = 'a Bigarray.layout

  val offset : _ t -> int
  [@@ocaml.doc " [offset t] is the index of the lowest-numbered element. "]
end

module Array1 : sig
  type ('elt, 'pack, 'layout) t = ('elt, 'pack, 'layout) Bigarray.Array1.t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('elt -> Sexplib0.Sexp.t)
      -> ('pack -> Sexplib0.Sexp.t)
      -> ('layout -> Sexplib0.Sexp.t)
      -> ('elt, 'pack, 'layout) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val init
    :  ('elt, 'pack) Bigarray.kind
    -> 'layout Bigarray.layout
    -> int
    -> f:(int -> 'elt)
    -> ('elt, 'pack, 'layout) t

  val iteri : ('elt, _, _) t -> f:(int -> 'elt -> unit) -> unit
  val fold : ('elt, _, _) t -> init:'a -> f:('a -> 'elt -> 'a) -> 'a
  val to_array : ('elt, _, _) t -> 'elt array

  val hash_fold
    :  (Hash.state -> 'elt -> Hash.state)
    -> Hash.state
    -> ('elt, _, _) t
    -> Hash.state
end

module Array2 : sig
  type ('elt, 'pack, 'layout) t = ('elt, 'pack, 'layout) Bigarray.Array2.t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('elt -> Sexplib0.Sexp.t)
      -> ('pack -> Sexplib0.Sexp.t)
      -> ('layout -> Sexplib0.Sexp.t)
      -> ('elt, 'pack, 'layout) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val init
    :  ('elt, 'pack) Bigarray.kind
    -> 'layout Bigarray.layout
    -> int
    -> int
    -> f:(int -> int -> 'elt)
    -> ('elt, 'pack, 'layout) t

  val iteri : ('elt, _, _) t -> f:(int -> int -> 'elt -> unit) -> unit
  val fold : ('elt, _, _) t -> init:'a -> f:('a -> 'elt -> 'a) -> 'a

  val to_array : ('elt, _, _) t -> 'elt array array
  [@@ocaml.doc " The output matches the layout of the input. "]

  val hash_fold
    :  (Hash.state -> 'elt -> Hash.state)
    -> Hash.state
    -> ('elt, _, _) t
    -> Hash.state
end
