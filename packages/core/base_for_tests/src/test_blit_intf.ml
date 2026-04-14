[@@@ocaml.text " Produce unit tests for blittable values. "]

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "test_blit_intf.ml.before-ppx"
;;

open! Base
open! Blit

module type Elt = sig
  type t

  val equal : t -> t -> bool

  val of_bool : bool -> t
  [@@ocaml.doc
    " [of_bool] is used to generate two distinct values of type [t], used in unit tests.\n\
    \      It is required that [of_bool false <> of_bool true]. "]
end

module type Elt1 = sig
  type 'a t

  val equal : bool t -> bool t -> bool
  val of_bool : bool -> bool t
end

module type Sequence = sig
  type t
  type elt

  val create : len:int -> t
  val length : t -> int
  val get : t -> int -> elt
  val set : t -> int -> elt -> unit
end

type 'a poly = 'a

module type Sequence1 = sig
  type 'a t

  val length : _ t -> int
  [@@ocaml.doc
    " [Make1*] guarantees to only call [create_like ~len t] with [len > 0] if [length t >\n\
    \      0]. "]

  type 'a z
  [@@ocaml.doc
    " [create_bool], [get], and [set] are just used for unit tests.  [z] is needed for\n\
    \      [Flat_tuple_array], [elt] is needed for [Option_array]. "]

  type 'a elt

  val create_bool : len:int -> bool z t
  val get : 'a z t -> int -> 'a elt
  val set : 'a z t -> int -> 'a elt -> unit
end

module type Test_blit = sig
  module type Elt = Elt
  module type Elt1 = Elt1
  module type Sequence = Sequence
  module type Sequence1 = Sequence1

  module Test : functor
      (Elt : Elt)
      -> functor
      (Sequence : Sequence with type elt := Elt.t)
      -> functor
      (Tested : S with type t := Sequence.t)
      -> sig end

  module Test_distinct : functor
      (Elt : Elt)
      -> functor
      (Src : Sequence with type elt := Elt.t)
      -> functor
      (Dst : Sequence with type elt := Elt.t)
      -> functor
      (Tested : S_distinct with type src := Src.t with type dst := Dst.t)
      -> sig end

  module Test1 : functor
      (Sequence : Sequence1 with type 'a elt := 'a poly)
      -> functor
      (Tested : S1 with type 'a t := 'a Sequence.t)
      -> sig end

  module Test1_generic : functor
      (Elt : Elt1)
      -> functor
      (Sequence : Sequence1 with type 'a elt := 'a Elt.t)
      -> functor
      (Tested : S1 with type 'a t := 'a Sequence.t)
      -> sig end

  module Make_and_test : functor
      (Elt : Elt)
      -> functor
      (Sequence : sig
         include Sequence with type elt := Elt.t

         val unsafe_blit : (t, t) blit
       end)
      -> S with type t := Sequence.t
  [@@ocaml.doc " [Make_and_test] uses the [Blit.Make] functor and the [Test] functor. "]

  module Make_distinct_and_test : functor
      (Elt : Elt)
      -> functor
      (Src : Sequence with type elt := Elt.t)
      -> functor
      (Dst : sig
         include Sequence with type elt := Elt.t

         val unsafe_blit : (Src.t, t) blit
       end)
      -> S_distinct with type src := Src.t with type dst := Dst.t

  module Make1_and_test : functor
      (Sequence : sig
         include Blit.Sequence1
         include Sequence1 with type 'a t := 'a t with type 'a elt := 'a poly
       end)
      -> S1 with type 'a t := 'a Sequence.t

  module Make1_generic_and_test : functor
      (Elt : Elt1)
      -> functor
      (Sequence : sig
         include Blit.Sequence1
         include Sequence1 with type 'a t := 'a t with type 'a elt := 'a Elt.t
       end)
      -> S1 with type 'a t := 'a Sequence.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
