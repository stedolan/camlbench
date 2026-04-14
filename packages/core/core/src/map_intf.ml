[@@@ocaml.text
  " This module defines interfaces used in {{!Map}[Map]}. See those docs for a description\n\
  \    of the design.\n\n\
  \    This module defines module types\n\
  \    [{Creators,Accessors}{1,2,3,_generic,_with_comparator}]. It uses check functors to\n\
  \    ensure that each module type is an instance of the corresponding [_generic] one.\n\n\
  \    We must treat [Creators] and [Accessors] separately, because we sometimes need to\n\
  \    choose different instantiations of their [options]. In particular, [Map] itself\n\
  \    matches [Creators3_with_comparator] but [Accessors3] (without comparator).\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"map_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "map_intf.ml.before-ppx"
;;

open! Import
module Binable = Binable0
module Map = Base.Map
module Or_duplicate = Map.Or_duplicate
module With_comparator = Map.With_comparator
module With_first_class_module = Map.With_first_class_module
module Without_comparator = Map.Without_comparator
module Tree = Map.Using_comparator.Tree

module type Key_plain = sig
  type t [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Key = sig
  type t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Key_binable = sig
  type t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Key_hashable = sig
  type t [@@deriving compare, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Key_binable_hashable = sig
  type t [@@deriving bin_io, compare, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Key_bin_io = struct
  module type S = sig
    type t [@@deriving bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type comparator_witness

    val comparator : (t, comparator_witness) Comparator.t
  end

  type ('t, 'c) t = (module S with type t = 't and type comparator_witness = 'c)
end

module type Accessors_generic = sig
  include Map.Accessors_generic

  val key_set
    : ('k, 'cmp, ('k, _, 'cmp) t -> ('k key, 'cmp cmp) Base.Set.t) access_options

  val validate
    :  name:('k key -> string)
    -> 'v Validate.check
    -> ('k, 'v, _) t Validate.check

  val validatei
    :  name:('k key -> string)
    -> ('k key * 'v) Validate.check
    -> ('k, 'v, _) t Validate.check

  val quickcheck_observer
    :  'k key Quickcheck.Observer.t
    -> 'v Quickcheck.Observer.t
    -> ('k, 'v, 'cmp) t Quickcheck.Observer.t

  val quickcheck_shrinker
    : ( 'k
        , 'cmp
        , 'k key Quickcheck.Shrinker.t
          -> 'v Quickcheck.Shrinker.t
          -> ('k, 'v, 'cmp) t Quickcheck.Shrinker.t )
        access_options
end

module type Creators_generic = sig
  include Map.Creators_generic

  val of_hashtbl_exn
    : ('k, 'cmp, ('k key, 'v) Hashtbl.t -> ('k, 'v, 'cmp) t) create_options

  val of_key_set : ('k key, 'cmp cmp) Base.Set.t -> f:('k key -> 'v) -> ('k, 'v, 'cmp) t
  [@@ocaml.doc
    " Never requires a comparator because it can get one from the input [Set.t]. "]

  val quickcheck_generator
    : ( 'k
        , 'cmp
        , 'k key Quickcheck.Generator.t
          -> 'v Quickcheck.Generator.t
          -> ('k, 'v, 'cmp) t Quickcheck.Generator.t )
        create_options
end

module type Creators_and_accessors_generic = sig
  type ('a, 'b, 'c) t
  type ('a, 'b, 'c) tree
  type 'a key
  type 'a cmp
  type ('a, 'b, 'c) create_options
  type ('a, 'b, 'c) access_options

  include
    Creators_generic
    with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
    with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
    with type 'a key := 'a key
    with type 'a cmp := 'a cmp
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) create_options
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options

  include
    Accessors_generic
    with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
    with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
    with type 'a key := 'a key
    with type 'a cmp := 'a cmp
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options
end

module Make_S_plain_tree (Key : Comparator.S) = struct
  module type S = sig
    type 'a t = (Key.t, 'a, Key.comparator_witness) Tree.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Creators_and_accessors_generic
      with type ('a, 'b, 'c) t := 'b t
      with type ('a, 'b, 'c) tree := 'b t
      with type 'a key := Key.t
      with type 'a cmp := Key.comparator_witness
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t

    module Provide_of_sexp : functor
        (K : sig
               type t [@@deriving of_sexp]

               include sig
                 [@@@ocaml.warning "-32"]

                 val t_of_sexp : Sexplib0.Sexp.t -> t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := Key.t)
        -> sig
        type _ t [@@deriving of_sexp]

        include sig
          [@@@ocaml.warning "-32"]

          val t_of_sexp : (Sexplib0.Sexp.t -> 'a__001_) -> Sexplib0.Sexp.t -> 'a__001_ t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end
      with type 'a t := 'a t
  end
end

module type S_plain = sig
  module Key : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end

  type +'a t = (Key.t, 'a, Key.comparator_witness) Map.t
  [@@deriving compare, equal, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type +'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type +'a t := 'a t

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    Creators_generic
    with type ('a, 'b, 'c) t := 'b t
    with type ('a, 'b, 'c) tree := (Key.t, 'b, Key.comparator_witness) Tree.t
    with type 'k key := Key.t
    with type 'c cmp := Key.comparator_witness
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t

  module Diff : sig
    type ('a, 'a_diff) t = (Key.t, 'a, 'a_diff) Diffable.Map_diff.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('a_diff -> Sexplib0.Sexp.t)
        -> ('a, 'a_diff) t
        -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Diffable.Diff.S1_plain
      with type 'a derived_on = (Key.t, 'a, Key.comparator_witness) Map.t
       and type ('a, 'a_diff) t := ('a, 'a_diff) t
  end

  include Diffable.S1_plain with type 'a t := 'a t and module Diff := Diff

  val map : 'a t -> f:('a -> 'b) -> 'b t

  module Provide_of_sexp : functor
      (Key : sig
               type t [@@deriving of_sexp]

               include sig
                 [@@@ocaml.warning "-32"]

                 val t_of_sexp : Sexplib0.Sexp.t -> t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := Key.t)
      -> sig
      type _ t [@@deriving of_sexp]

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : (Sexplib0.Sexp.t -> 'a__002_) -> Sexplib0.Sexp.t -> 'a__002_ t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a t := 'a t

  module Provide_bin_io : functor
      (Key : sig
               type t [@@deriving bin_io]

               include sig
                 [@@@ocaml.warning "-32"]

                 include Bin_prot.Binable.S with type t := t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := Key.t)
      -> Binable.S1 with type 'a t := 'a t

  module Provide_hash : functor
      (Key : Hasher.S with type t := Key.t)
      -> sig
      type 'a t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a t := 'a t

  val quickcheck_observer
    :  Key.t Quickcheck.Observer.t
    -> 'v Quickcheck.Observer.t
    -> 'v t Quickcheck.Observer.t

  val quickcheck_shrinker
    : ( 'k
        , 'cmp
        , Key.t Quickcheck.Shrinker.t
          -> 'v Quickcheck.Shrinker.t
          -> 'v t Quickcheck.Shrinker.t )
        Without_comparator.t
end

module type S = sig
  module Key : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end

  module Diff : sig
    type ('a, 'a_diff) t = (Key.t, 'a, 'a_diff) Diffable.Map_diff.t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Diffable.Diff.S1_plain
      with type ('a, 'a_diff) t := ('a, 'a_diff) t
       and type 'a derived_on = (Key.t, 'a, Key.comparator_witness) Map.t
  end

  include S_plain with module Key := Key and module Diff := Diff
  include Sexpable.S1 with type 'a t := 'a t
end

module type S_binable = sig
  module Key : sig
    type t [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end

  module Diff : sig
    type ('a, 'a_diff) t = (Key.t, 'a, 'a_diff) Diffable.Map_diff.t
    [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
      include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Diffable.Diff.S1_plain
      with type ('a, 'a_diff) t := ('a, 'a_diff) t
       and type 'a derived_on = (Key.t, 'a, Key.comparator_witness) Map.t
  end

  include S with module Key := Key and module Diff := Diff
  include Binable.S1 with type 'a t := 'a t
end

module type For_deriving = sig
  include Base.Map.For_deriving
  module M = Base.Map.M

  [@@@ocaml.text
    " The following [*bin*] functions support bin-io on base-style maps,\n\
    \      e.g.:\n\n\
    \      {[ type t = int Map.M(String).t [@@deriving bin_io] ]} "]

  val bin_shape_m__t : ('a, 'c) Key_bin_io.t -> Bin_prot.Shape.t -> Bin_prot.Shape.t

  val bin_size_m__t
    :  ('a, 'c) Key_bin_io.t
    -> 'b Bin_prot.Size.sizer
    -> ('a, 'b, 'c) t Bin_prot.Size.sizer

  val bin_write_m__t
    :  ('a, 'c) Key_bin_io.t
    -> 'b Bin_prot.Write.writer
    -> ('a, 'b, 'c) t Bin_prot.Write.writer

  val bin_read_m__t
    :  ('a, 'c) Key_bin_io.t
    -> 'b Bin_prot.Read.reader
    -> ('a, 'b, 'c) t Bin_prot.Read.reader

  val __bin_read_m__t__
    :  ('a, 'c) Key_bin_io.t
    -> 'b Bin_prot.Read.reader
    -> (int -> ('a, 'b, 'c) t) Bin_prot.Read.reader

  [@@@ocaml.text
    " The following [quickcheck*] functions support deriving quickcheck on base-style \
     maps,\n\
    \      e.g.:\n\n\
    \      {[ type t = int Map.M(String).t [@@deriving quickcheck] ]} "]

  module type Quickcheck_generator_m = sig
    include Comparator.S

    val quickcheck_generator : t Quickcheck.Generator.t
  end

  module type Quickcheck_observer_m = sig
    include Comparator.S

    val quickcheck_observer : t Quickcheck.Observer.t
  end

  module type Quickcheck_shrinker_m = sig
    include Comparator.S

    val quickcheck_shrinker : t Quickcheck.Shrinker.t
  end

  val quickcheck_generator_m__t
    :  (module Quickcheck_generator_m with type t = 'k and type comparator_witness = 'cmp)
    -> 'v Quickcheck.Generator.t
    -> ('k, 'v, 'cmp) t Quickcheck.Generator.t

  val quickcheck_observer_m__t
    :  (module Quickcheck_observer_m with type t = 'k and type comparator_witness = 'cmp)
    -> 'v Quickcheck.Observer.t
    -> ('k, 'v, 'cmp) t Quickcheck.Observer.t

  val quickcheck_shrinker_m__t
    :  (module Quickcheck_shrinker_m with type t = 'k and type comparator_witness = 'cmp)
    -> 'v Quickcheck.Shrinker.t
    -> ('k, 'v, 'cmp) t Quickcheck.Shrinker.t
end

module type For_deriving_stable = sig
  type ('a, 'b, 'c) t

  module type Stable_witness_m = sig
    include Comparator.S

    val stable_witness : t Stable_witness.t
  end

  val stable_witness_m__t
    :  (module Stable_witness_m with type t = 'k and type comparator_witness = 'cmp)
    -> 'v Stable_witness.t
    -> ('k, 'v, 'cmp) t Stable_witness.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
