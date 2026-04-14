[@@@ocaml.text " A mutable set of elements. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hash_set_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hash_set_intf.ml.before-ppx"
;;

open! Import
module Binable = Binable0
open Base.Hash_set

module type M_quickcheck = sig
  type t [@@deriving compare, hash, quickcheck, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type For_deriving = sig
  include For_deriving

  module type M_quickcheck = M_quickcheck

  val quickcheck_generator_m__t
    :  (module M_quickcheck with type t = 'key)
    -> 'key t Base_quickcheck.Generator.t

  val quickcheck_observer_m__t
    :  (module M_quickcheck with type t = 'key)
    -> 'key t Base_quickcheck.Observer.t

  val quickcheck_shrinker_m__t
    :  (module M_quickcheck with type t = 'key)
    -> 'key t Base_quickcheck.Shrinker.t
end

module type S_plain = sig
  type elt
  type 'a hash_set
  type t = elt hash_set [@@deriving equal, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Equal.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    Creators_generic
    with type 'a t := t
    with type 'a elt := elt
    with type ('a, 'z) create_options :=
      ('a, 'z) create_options_without_first_class_module

  module Provide_of_sexp : functor
      (X : sig
             type t [@@deriving of_sexp]

             include sig
               [@@@ocaml.warning "-32"]

               val t_of_sexp : Sexplib0.Sexp.t -> t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := elt)
      -> sig
      type t [@@deriving of_sexp]

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : Sexplib0.Sexp.t -> t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t

  module Provide_bin_io : functor
      (X : sig
             type t [@@deriving bin_io]

             include sig
               [@@@ocaml.warning "-32"]

               include Bin_prot.Binable.S with type t := t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := elt)
      -> sig
      type t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t
end

module type S = sig
  include S_plain

  include sig
      type t [@@deriving of_sexp]

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : Sexplib0.Sexp.t -> t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t
end

module type S_binable = sig
  include S
  include Binable.S with type t := t
end

module type S_stable = sig
  include S_binable

  val stable_witness : t Stable_witness.t
end

type ('key, 'z) create_options_with_hashable_required =
  ('key, unit, 'z) Hashtbl_intf.create_options_with_hashable

module type Hash_set = sig
  type 'a t = 'a Base.Hash_set.t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  [@@@ocaml.text
    " We use [[@@deriving sexp_of]] but not [[@@deriving sexp]] because we want people \
     to be\n\
    \      explicit about the hash and comparison functions used when creating \
     hashtables.  One\n\
    \      can use [Hash_set.Poly.t], which does have [[@@deriving sexp]], to use \
     polymorphic\n\
    \      comparison and hashing. "]

  include Creators with type 'a t := 'a t
  include Accessors with type 'a t := 'a t with type 'a elt := 'a elt

  val hashable : 'key t -> 'key Hashtbl.Hashable.t

  module type Elt_plain = Hashtbl.Key_plain
  module type Elt = Hashtbl.Key
  module type Elt_binable = Hashtbl.Key_binable
  module type Elt_stable = Hashtbl.Key_stable
  module type S_plain = S_plain with type 'a hash_set := 'a t
  module type S = S with type 'a hash_set := 'a t
  module type S_binable = S_binable with type 'a hash_set := 'a t
  module type S_stable = S_stable with type 'a hash_set := 'a t

  module Using_hashable : sig
    include
      Creators_generic
      with type 'a t := 'a t
      with type 'a elt = 'a
      with type ('key, 'z) create_options :=
        ('key, 'z) create_options_with_hashable_required
  end

  module Poly : sig
    type nonrec 'a t = 'a t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Creators_generic
      with type 'a t := 'a t
      with type 'a elt = 'a
      with type ('key, 'z) create_options :=
        ('key, 'z) create_options_without_first_class_module

    include Accessors with type 'a t := 'a t with type 'a elt := 'a elt
  end
  [@@ocaml.doc " A hash set that uses polymorphic comparison. "]

  module Make_plain : functor (Elt : Elt_plain) -> S_plain with type elt = Elt.t
  module Make : functor (Elt : Elt) -> S with type elt = Elt.t
  module Make_binable : functor (Elt : Elt_binable) -> S_binable with type elt = Elt.t
  module Make_stable : functor (Elt : Elt_stable) -> S_stable with type elt = Elt.t

  module Make_plain_with_hashable : functor
      (T : sig
         module Elt : Elt_plain

         val hashable : Elt.t Hashtbl.Hashable.t
       end)
      -> S_plain with type elt = T.Elt.t

  module Make_with_hashable : functor
      (T : sig
         module Elt : Elt

         val hashable : Elt.t Hashtbl.Hashable.t
       end)
      -> S with type elt = T.Elt.t

  module Make_binable_with_hashable : functor
      (T : sig
         module Elt : Elt_binable

         val hashable : Elt.t Hashtbl.Hashable.t
       end)
      -> S_binable with type elt = T.Elt.t

  module Make_stable_with_hashable : functor
      (T : sig
         module Elt : Elt_stable

         val hashable : Elt.t Hashtbl.Hashable.t
       end)
      -> S_stable with type elt = T.Elt.t

  include For_deriving with type 'a t := 'a t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
