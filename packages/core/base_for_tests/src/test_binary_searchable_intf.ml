[@@@ocaml.text " Produce unit tests for binary searchable containers "]

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "test_binary_searchable_intf.ml.before-ppx"
;;

open! Base
open! Binary_searchable

module type For_test = sig
  [@@@ocaml.text
    " To implement the tests, we need two different [elt] values [small < big], to be able\n\
    \      to compare those values, and to be able to construct a [t] containing those\n\
    \      values. "]

  type t
  type elt

  val compare : elt -> elt -> int
  val small : elt
  val big : elt
  val of_array : elt array -> t
end

module type For_test1 = sig
  type 'a t

  val of_array : bool array -> bool t
end

module type Indexable_and_for_test = sig
  include Indexable
  module For_test : For_test with type elt := elt with type t := t
end

module type Indexable1_and_for_test = sig
  include Indexable1
  module For_test : For_test1 with type 'a t := 'a t
end

module type Binary_searchable_and_for_test = sig
  include Binary_searchable.S
  module For_test : For_test with type elt := elt with type t := t
end

module type Binary_searchable1_and_for_test = sig
  include Binary_searchable.S1
  module For_test : For_test1 with type 'a t := 'a t
end

module type Test_binary_searchable = sig
  module type For_test = For_test
  module type For_test1 = For_test1

  module Test : functor (M : Binary_searchable_and_for_test) -> sig end
  module Test1 : functor (M : Binary_searchable1_and_for_test) -> sig end

  module Make_and_test : functor (T : Indexable_and_for_test) ->
    S with type t := T.t with type elt := T.elt
  [@@ocaml.doc " [Make_and_test] does [Binary_searchable.Make] and [Test]. "]

  module Make1_and_test : functor (T : Indexable1_and_for_test) ->
    S1 with type 'a t := 'a T.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
