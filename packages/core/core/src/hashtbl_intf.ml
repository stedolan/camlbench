[@@@ocaml.text
  " Hashtbl is a reimplementation of the standard {{:\n\
  \    \
   https://caml.inria.fr/pub/docs/manual-ocaml/libref/MoreLabels.Hashtbl.html}[MoreLabels.Hashtbl]}. \
   Its\n\
  \    worst case time complexity is O(log(N)) for lookups and additions, unlike the \
   standard\n\
  \    [MoreLabels.Hashtbl], which is O(N).\n\n\
  \    A hash table is implemented as an array of AVL trees (see [Avltree]). If\n\
  \    [growth_allowed] (default true) is false then [size] is the final size of the \
   array;\n\
  \    the table can always hold more elements than [size], but they will all go into\n\
  \    tree nodes. If it is true (default) then the array will double in size when the \
   number\n\
  \    of elements in the table reaches twice the size of the array. When this happens, \
   all\n\
  \    existing elements will be reinserted, which can take a long time. If you care about\n\
  \    latency, set [size] and [growth_allowed=false] if possible.\n\n\
  \    In most cases, functions passed as arguments to hash table accessors must not \
   mutate\n\
  \    the hash table while it is being accessed, as this will result in an exception. For\n\
  \    example, [iter] and [change] take a function [f] which must not modify [t]. In a \
   few\n\
  \    cases, mutation is allowed, such as in [Hashtbl.find_and_call], where all access to\n\
  \    [t] is finished before the [~if_found] and [~if_not_found] arguments are invoked.\n\n\
  \    We have three kinds of hash table modules:\n\
  \    - [Hashtbl]\n\
  \    - [Hashtbl.Poly]\n\
  \    - [Key.Table] (a class of similar modules)\n\n\
  \    There are three kinds of hash-table functions:\n\
  \    - creation from nothing ([create], [of_alist])\n\
  \    - sexp converters ([t_of_sexp], [sexp_of_t], and [bin_io] too)\n\
  \    - accessors and mappers ([fold], [mem], [find], [map], [filter_map], ...)\n\n\
  \    Here is a table showing what classes of functions are available in each kind\n\
  \    of hash-table module:\n\
  \    {v\n\
  \                   creation     sexp-conv   accessors\n\
  \    Hashtbl                                   X\n\
  \    Hashtbl.Poly      X           X\n\
  \    Key.Table         X           X           X'\n\
  \    v}\n\n\
  \    The entry marked with [X'] is there for historical reasons, and may be eliminated \
   at\n\
  \    some point. The upshot is that one should use [Hashtbl] for accessors, \
   [Hashtbl.Poly]\n\
  \    for hash-table creation and sexp conversion using polymorphic compare/hash, and\n\
  \    [Key.Table] for hash-table creation and sexp conversion using [Key.compare] and\n\
  \    [Key.hash].\n\n\
  \    {2:usage Usage}\n\n\
  \    For many students of OCaml, using hashtables is complicated by the\n\
  \    functors.  Here are a few tips:\n\n\
  \    {ol\n\
  \    {- For a list of hashtable functions see {!Core.Hashtbl_intf.S}.}\n\n\
  \    {- To create a hashtable with string keys use [String.Table]:\n\
  \    {[\n\
  \      let table = String.Table.create () ~size:4 in\n\
  \      List.iter ~f:(fun (key, data) -> Hashtbl.set table ~key ~data)\n\
  \        [ (\"A\", 1); (\"B\", 2); (\"C\", 3); ];\n\
  \      Hashtbl.find table \"C\"\n\
  \    ]}\n\n\
  \    Here 4 need only be a guess at the hashtable's future size. There are other similar\n\
  \    pre-made hashtables, e.g., [Int63.Table] or [Host_and_port.Table].\n\
  \    }\n\n\
  \    {- To create a hashtable with a custom key type use Hashable:\n\
  \    {[\n\
  \      module Key = struct\n\
  \        module T = struct\n\
  \          type t = String.t * Int63.t [@@deriving compare, hash, sexp]\n\
  \        end\n\
  \        include T\n\
  \        include Hashable.Make (T)\n\
  \      end\n\
  \      let table = Key.Table.create () ~size:4 in\n\
  \      List.iter ~f:(fun (key, data) -> Hashtbl.set table ~key ~data)\n\
  \        [ ((\"pi\", Int63.zero), 3.14159);\n\
  \          ((\"e\", Int63.minus_one), 2.71828);\n\
  \          ((\"Euler\", Int63.one), 0.577215);\n\
  \        ];\n\
  \      Hashtbl.find table (\"pi\", Int63.zero)\n\
  \    ]}\n\n\
  \    Performance {i may} improve if you define [equal] and [hash] explicitly, e.g.:\n\n\
  \    {[\n\
  \      let equal (x, y) (x', y') = String.(=) x x' && Int63.(=) y y'\n\
  \      let hash (x, y) = String.hash x + Int63.hash y * 65599\n\
  \    ]}\n\
  \    }\n\
  \    }\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hashtbl_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hashtbl_intf.ml.before-ppx"
;;

open! Import
module Binable = Binable0
module Hashtbl = Base.Hashtbl

module type Key_plain = Hashtbl.Key.S

module Hashable = Base.Hashable
module Merge_into_action = Base.Hashtbl.Merge_into_action

module type Hashable = Base.Hashable.Hashable

module type Key = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Key_plain with type t := t
end

module type Key_binable = sig
  type t [@@deriving bin_io, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Key with type t := t
end

module type Key_stable = sig
  type t [@@deriving bin_io, sexp, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Key_binable with type t := t
end

module type Creators = Hashtbl.Private.Creators_generic

module type Accessors = sig
  include Hashtbl.Accessors

  val validate : name:('a key -> string) -> 'b Validate.check -> ('a, 'b) t Validate.check
end

module type Multi = Hashtbl.Multi

type ('key, 'data, 'z) create_options_with_first_class_module =
  ('key, 'data, 'z) Hashtbl.create_options

type ('key, 'data, 'z) create_options_without_hashable =
  ('key, 'data, 'z) Hashtbl.Private.create_options_without_first_class_module

type ('key, 'data, 'z) create_options_with_hashable =
  ?growth_allowed:(bool[@ocaml.doc " defaults to [true] "])
  -> ?size:(int[@ocaml.doc " initial size -- default 0 "])
  -> hashable:'key Hashable.t
  -> 'z

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
  include Base.Hashtbl.For_deriving

  module type M_quickcheck = M_quickcheck

  val quickcheck_generator_m__t
    :  (module M_quickcheck with type t = 'k)
    -> 'v Base_quickcheck.Generator.t
    -> ('k, 'v) t Quickcheck.Generator.t

  val quickcheck_observer_m__t
    :  (module M_quickcheck with type t = 'k)
    -> 'v Quickcheck.Observer.t
    -> ('k, 'v) t Quickcheck.Observer.t

  val quickcheck_shrinker_m__t
    :  (module M_quickcheck with type t = 'k)
    -> 'v Quickcheck.Shrinker.t
    -> ('k, 'v) t Quickcheck.Shrinker.t
end

module type S_plain = sig
  type key
  type ('a, 'b) hashtbl
  type 'b t = (key, 'b) hashtbl [@@deriving equal, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Equal.S1 with type 'b t := 'b t

    val sexp_of_t : ('b -> Sexplib0.Sexp.t) -> 'b t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b) t_ = 'b t
  type 'a key_ = key

  val hashable : key Hashable.t

  include Invariant.S1 with type 'b t := 'b t

  include
    Creators
    with type ('a, 'b) t := ('a, 'b) t_
    with type 'a key := 'a key_
    with type ('key, 'data, 'z) create_options :=
      ('key, 'data, 'z) create_options_without_hashable

  module Provide_of_sexp : functor
      (Key : sig
               type t [@@deriving of_sexp]

               include sig
                 [@@@ocaml.warning "-32"]

                 val t_of_sexp : Sexplib0.Sexp.t -> t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := key)
      -> sig
      type _ t [@@deriving of_sexp]

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : (Sexplib0.Sexp.t -> 'a__001_) -> Sexplib0.Sexp.t -> 'a__001_ t
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
             with type t := key)
      -> sig
      type 'a t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S1 with type 'a t := 'a t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a t := 'a t
end

module type S = sig
  include S_plain

  include sig
      type _ t [@@deriving of_sexp]

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : (Sexplib0.Sexp.t -> 'a__002_) -> Sexplib0.Sexp.t -> 'a__002_ t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a t := 'a t
end

module type S_binable = sig
  include S
  include Binable.S1 with type 'v t := 'v t
end

module type S_stable = sig
  include S_binable

  type nonrec 'a t = 'a t [@@deriving stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    val stable_witness
      :  'a Ppx_stable_witness_runtime.Stable_witness.t
      -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Hashtbl = sig
  include Hashtbl.S_without_submodules [@@ocaml.doc " @inline "]

  val validate : name:('a key -> string) -> 'b Validate.check -> ('a, 'b) t Validate.check

  module Using_hashable : sig
    include
      Creators
      with type ('a, 'b) t := ('a, 'b) t
      with type 'a key := 'a key
      with type ('a, 'b, 'z) create_options := ('a, 'b, 'z) create_options_with_hashable
  end

  module Poly : sig
    type nonrec ('a, 'b) t = ('a, 'b) t [@@deriving bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S2 with type ('a, 'b) t := ('a, 'b) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Hashtbl.S_poly with type ('a, 'b) t := ('a, 'b) t

    val validate
      :  name:('a key -> string)
      -> 'b Validate.check
      -> ('a, 'b) t Validate.check
  end

  module type Key_plain = Key_plain
  module type Key = Key
  module type Key_binable = Key_binable
  module type Key_stable = Key_stable
  module type S_plain = S_plain with type ('a, 'b) hashtbl = ('a, 'b) t
  module type S = S with type ('a, 'b) hashtbl = ('a, 'b) t
  module type S_binable = S_binable with type ('a, 'b) hashtbl = ('a, 'b) t
  module type S_stable = S_stable with type ('a, 'b) hashtbl = ('a, 'b) t

  module Make_plain : functor (Key : Key_plain) -> S_plain with type key = Key.t
  module Make : functor (Key : Key) -> S with type key = Key.t
  module Make_binable : functor (Key : Key_binable) -> S_binable with type key = Key.t
  module Make_stable : functor (Key : Key_stable) -> S_stable with type key = Key.t

  module Make_plain_with_hashable : functor
      (T : sig
         module Key : Key_plain

         val hashable : Key.t Hashable.t
       end)
      -> S_plain with type key = T.Key.t

  module Make_with_hashable : functor
      (T : sig
         module Key : Key

         val hashable : Key.t Hashable.t
       end)
      -> S with type key = T.Key.t

  module Make_binable_with_hashable : functor
      (T : sig
         module Key : Key_binable

         val hashable : Key.t Hashable.t
       end)
      -> S_binable with type key = T.Key.t

  module Make_stable_with_hashable : functor
      (T : sig
         module Key : Key_stable

         val hashable : Key.t Hashable.t
       end)
      -> S_stable with type key = T.Key.t

  module M : functor (K : T.T) -> sig
    type nonrec 'v t = (K.t, 'v) t
  end

  module Hashable = Hashable
  module Merge_into_action = Merge_into_action

  val hashable : ('key, _) t -> 'key Hashable.t

  module type For_deriving = For_deriving

  include For_deriving with type ('a, 'b) t := ('a, 'b) t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
