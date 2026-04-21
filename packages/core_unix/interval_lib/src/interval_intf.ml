let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"interval_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "interval_intf.ml.before-ppx"
;;

open! Core

module type Gen = sig
  type 'a t

  type 'a bound
  [@@ocaml.doc
    " [bound] is the type of points in the interval (and therefore of the bounds).\n\
    \      [bound] is instantiated in two different ways below: in [module type S] as a\n\
    \      monotype and in [module type S1] as ['a]. "]

  val create : 'a bound -> 'a bound -> 'a t
  [@@ocaml.doc
    " [create l u] returns the interval with lower bound [l] and upper bound [u], unless\n\
    \      [l > u], in which case it returns the empty interval. "]

  val empty : 'a t
  val intersect : 'a t -> 'a t -> 'a t
  val is_empty : 'a t -> bool
  val is_empty_or_singleton : 'a t -> bool
  val bounds : 'a t -> ('a bound * 'a bound) option
  val lbound : 'a t -> 'a bound option
  val ubound : 'a t -> 'a bound option
  val bounds_exn : 'a t -> 'a bound * 'a bound
  val lbound_exn : 'a t -> 'a bound
  val ubound_exn : 'a t -> 'a bound

  val convex_hull : 'a t list -> 'a t
  [@@ocaml.doc
    " [convex_hull ts] returns an interval whose upper bound is the greatest upper bound\n\
    \      of the intervals in the list, and whose lower bound is the least lower bound \
     of the\n\
    \      list.\n\n\
    \      Suppose you had three intervals [a], [b], and [c]:\n\n\
    \      {v\n\
    \             a:  (   )\n\
    \             b:    (     )\n\
    \             c:            ( )\n\n\
    \          hull:  (           )\n\
    \      v}\n\n\
    \      In this case the hull goes from [lbound_exn a] to [ubound_exn c].\n\
    \  "]

  val contains : 'a t -> 'a bound -> bool

  val compare_value
    :  'a t
    -> 'a bound
    -> [ `Below | `Within | `Above | `Interval_is_empty ]

  val bound : 'a t -> 'a bound -> 'a bound option
  [@@ocaml.doc
    " [bound t x] returns [None] iff [is_empty t].  If [bounds t = Some (a, b)], then\n\
    \      [bound] returns [Some y] where [y] is the element of [t] closest to [x].  \
     I.e.:\n\n\
    \      {v\n\
    \        y = a  if x < a\n\
    \        y = x  if a <= x <= b\n\
    \        y = b  if x > b\n\
    \      v}\n\
    \  "]

  val is_superset : 'a t -> of_:'a t -> bool
  [@@ocaml.doc
    " [is_superset i1 of_:i2] is whether i1 contains i2. The empty interval is\n\
    \      contained in every interval. "]

  val is_subset : 'a t -> of_:'a t -> bool

  val map : 'a t -> f:('a bound -> 'b bound) -> 'b t
  [@@ocaml.doc
    " [map t ~f] returns [create (f l) (f u)] if [bounds t = Some (l, u)], and [empty] if\n\
    \      [t] is empty.  Note that if [f l > f u], the result of [map] is [empty], by the\n\
    \      definition of [create].\n\n\
    \      If you think of an interval as a set of points, rather than a pair of its \
     bounds,\n\
    \      then [map] is not the same as the usual mathematical notion of mapping [f] \
     over that\n\
    \      set. For example, [map ~f:(fun x -> x * x)] maps the interval [[-1,1]] to \
     [[1,1]],\n\
    \      not to [[0,1]]. "]

  val are_disjoint : 'a t list -> bool
  [@@ocaml.doc
    " [are_disjoint ts] returns [true] iff the intervals in [ts] are pairwise disjoint. "]

  val are_disjoint_as_open_intervals : 'a t list -> bool
  [@@ocaml.doc
    " Returns true iff a given set of intervals would be disjoint if considered as open\n\
    \      intervals, e.g., [(3,4)] and [(4,5)] would count as disjoint according to this\n\
    \      function. "]

  val list_intersect : 'a t list -> 'a t list -> 'a t list
  [@@ocaml.doc
    " Assuming that [ilist1] and [ilist2] are lists of disjoint intervals, [list_intersect\n\
    \      ilist1 ilist2] considers the intersection [(intersect i1 i2)] of every pair of\n\
    \      intervals [(i1, i2)], with [i1] drawn from [ilist1] and [i2] from [ilist2],\n\
    \      returning just the non-empty intersections. By construction these intervals \
     will be\n\
    \      disjoint, too. For example:\n\n\
    \      {[\n\
    \        let i = Interval.create;;\n\
    \        list_intersect [i 4 7; i 9 15] [i 2 4; i 5 10; i 14 20];;\n\
    \        [(4, 4), (5, 7), (9, 10), (14, 15)]\n\
    \      ]}\n\n\
    \      Raises an exception if either input list is non-disjoint.\n\
    \  "]

  val half_open_intervals_are_a_partition : 'a t list -> bool
  [@@ocaml.doc
    " Returns true if the intervals, when considered as half-open intervals, nestle up\n\
    \      cleanly one to the next. I.e., if you sort the intervals by the lower bound,\n\
    \      then the upper bound of the [n]th interval is equal to the lower bound of the\n\
    \      [n+1]th interval. The intervals do not need to partition the entire space, \
     they just\n\
    \      need to partition their union.\n\
    \  "]
end

module type Gen_set = sig
  type 'a t
  type 'a bound

  type 'a interval
  [@@ocaml.doc " An interval set is a set of nonempty disjoint intervals. "]

  val create_exn : ('a bound * 'a bound) list -> 'a t
  [@@ocaml.doc
    " [create_exn] creates an interval set containing intervals whose lower and upper \
     bounds\n\
    \      are given by the pairs passed to the function. Raises if the pairs overlap.\n\
    \  "]

  val create_from_intervals_exn : 'a interval list -> 'a t
  [@@ocaml.doc
    " [create_from_intervals_exn] creates an interval set. Empty intervals are\n\
    \      dropped. Raises if the nonempty intervals are not disjoint. "]

  val contains : 'a t -> 'a bound -> bool

  val contains_set : container:'a t -> contained:'a t -> bool
  [@@ocaml.doc
    " [contains_set] returns true iff for every interval in the contained set, there\n\
    \      exists an interval in the container set that is its superset.\n\
    \  "]

  val ubound_exn : 'a t -> 'a bound
  [@@ocaml.doc
    " The largest and smallest element of the interval set, respectively.  Raises\n\
    \      Invalid_argument on empty sets. "]

  val lbound_exn : 'a t -> 'a bound
  val ubound : 'a t -> 'a bound option
  val lbound : 'a t -> 'a bound option

  val inter : 'a t -> 'a t -> 'a t
  [@@ocaml.doc
    " [inter t1 t2] computes the intersection of sets [t1] and [t2].\n\
    \      [O(length t1 * length t2)]. "]

  val union : 'a t -> 'a t -> 'a t
  [@@ocaml.doc
    " [union t1 t2] computes the union of sets [t1] and [t2].\n\
    \      [O((length t1 + length t2) * log(length t1 + length t2))]. "]

  val union_list : 'a t list -> 'a t
  [@@ocaml.doc
    " [union_list l] computes the union of a list of sets.\n\
    \      [O(sum length * log(sum length))]. "]
end

module type S = sig
  type t [@@deriving bin_io, sexp, compare, hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type bound

  include Gen with type 'a t := t with type 'a bound := bound [@@ocaml.doc " @inline "]

  val create : bound -> bound -> t
  [@@ocaml.doc
    " [create] has the same type as in [Gen], but adding it here prevents a type-checker\n\
    \      issue with nongeneralizable type variables. "]

  type 'a poly_t

  val to_poly : t -> bound poly_t

  type 'a poly_set

  module Set : sig
      type t [@@deriving bin_io, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Gen_set with type 'a t := t with type 'a bound := bound
      [@@ocaml.doc " @inline "]

      val to_poly : t -> bound poly_set

      val to_list : t -> bound interval list
      [@@ocaml.doc
        " [to_list] will return a list of non-overlapping intervals defining the set, in\n\
        \        ascending order.  "]
    end
    with type 'a interval := t
end

module type S1 = sig
  type 'a t
  [@@ocaml.doc
    " This type [t] supports bin-io and sexp conversion by way of the\n\
    \      [[@@deriving bin_io, sexp]] extensions, which inline the relevant function\n\
    \      signatures (like [bin_read_t] and [t_of_sexp]). "]
  [@@deriving bin_io, sexp, compare, hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Gen with type 'a t := 'a t with type 'a bound := 'a [@@ocaml.doc " @inline "]

  module Set : sig
      type 'a t [@@deriving bin_io, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Gen_set with type 'a t := 'a t with type 'a bound := 'a
      [@@ocaml.doc " @inline "]
    end
    with type 'a interval := 'a t
end

module type S_stable = sig
  type t [@@deriving sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Stable_with_witness with type t := t
end

module type Interval = sig
  include
    S1
  [@@ocaml.doc
    "\n\
    \     {2 Intervals using polymorphic compare}\n\n\
    \     This part of the interface is for polymorphic intervals, which are well \
     ordered by\n\
    \     polymorphic compare. Using this with types that are not (like sets) will lead \
     to crazy\n\
    \     results.\n\
    \  "]
  [@@ocaml.doc " @inline "]

  [@@@ocaml.text
    " {2 Type-specialized intervals}\n\n\
    \      The module type [S] is used to define signatures for intervals over a \
     specific type,\n\
    \      like [Interval.Ofday] (whose bounds are [Time.Ofday.t]) or [Interval.Float], \
     whose\n\
    \      bounds are floats.\n\n\
    \      Note the heavy use of destructive substitution, which removes the redefined \
     type or\n\
    \      module from the signature. This allows for clean type constraints in \
     codebases, like\n\
    \      Core's, where there are lots of types going by the same name (e.g., \"t\").\n\
    \  "]

  [@@@ocaml.text
    " {3 Signatures }\n\n\
    \      The following signatures are used for specifying the types of the \
     type-specialized\n\
    \      intervals.\n\n\
    \  "]

  module type S1 = S1
  module type S = S with type 'a poly_t := 'a t with type 'a poly_set := 'a Set.t
  module type S_time = sig end [@@deprecated "[since 2021-08] Use [Interval_unix]"]

  [@@@ocaml.text " {3 Specialized interval types} "]

  module Ofday : S with type bound = Time_float.Ofday.t and type t = Time_float.Ofday.t t
  module Ofday_ns : S with type bound = Time_ns.Ofday.t and type t = Time_ns.Ofday.t t
  module Time : sig end [@@deprecated "[since 2021-08] Use [Interval_unix]"]
  module Time_ns : sig end [@@deprecated "[since 2021-08] Use [Interval_unix]"]
  module Float : S with type bound = Float.t and type t = Float.t t

  module Int : sig
    include S with type bound = Int.t [@@ocaml.doc " @open "]

    include Container.S0 with type t := t with type elt := bound
    include Binary_searchable.S with type t := t with type elt := bound

    [@@@ocaml.text "/*"]

    module Private : sig
      val get : t -> int -> int
    end
  end

  module Make : functor
      (Bound : sig
         type t [@@deriving bin_io, sexp, hash]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparable.S with type t := t
       end)
      -> S with type bound = Bound.t and type t = Bound.t t
  [@@ocaml.doc
    " [Interval.Make] is a functor that takes a type that you'd like to create intervals \
     for\n\
    \      and returns a module with functions over intervals of that type.\n\n\
    \      For example, suppose you had a [Percent.t] type and wanted to work with \
     intervals over\n\
    \      it, i.e., inclusive ranges like 40-50% or 0-100%. You would create your\n\
    \      [Percent_interval] module by calling:\n\n\
    \      {[module Percent_interval = Interval.Make(Percent)]}\n\n\
    \      You now have a module with lots of functionality ready to use. For instance \
     you could\n\
    \      call [Percent_interval.empty] to create an empty interval, or:\n\n\
    \      {[Percent_interval.create (Percent.of_percentage 3) (Percent.of_percentage \
     30)]}\n\n\
    \      to get an actual interval that ranges from [3%] to [30%]. You can then ask \
     questions\n\
    \      of this interval, like whether it's a {{!val:is_subset} subset} of another \
     interval or\n\
    \      whether it {!val:contains} a particular value.\n\n\
    \      NB. In order to use the [Interval.Make] functor, your type must satisfy\n\
    \      Comparable and support bin-io and s-expression conversion. At a minimum, then,\n\
    \      [Percent] must look like this:\n\n\
    \      {[\n\
    \        module Percent = struct\n\
    \          module T = struct\n\
    \            type t = float [@@deriving bin_io, compare, sexp]\n\
    \          end\n\
    \          include T\n\
    \          include Comparable.Make_binable(T)\n\
    \        end\n\
    \      ]}\n\
    \  "]

  module Stable : sig
    module V1 : sig
      type nonrec 'a t = 'a t
      [@@deriving bin_io, compare, hash, sexp, sexp_grammar, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t

        val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

        val stable_witness
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      module Float : S_stable with type t = Float.t
      module Int : S_stable with type t = Int.t
      module Time : sig end [@@deprecated "[since 2021-08] Use [Interval_unix]"]
      module Time_ns : sig end [@@deprecated "[since 2021-08] Use [Interval_unix]"]
      module Ofday : S_stable with type t = Ofday.t
      module Ofday_ns : S_stable with type t = Ofday_ns.t

      [@@@ocaml.text "/*"]

      module Private : sig
        type 'a interval := 'a t

        type 'a t =
          | Interval of 'a * 'a
          | Empty
        [@@deriving compare, variants]

        include sig
          [@@@ocaml.warning "-32-60"]

          include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

          val interval : 'a -> 'a -> 'a t
          val empty : 'a t
          val is_interval : 'a t -> bool
          val is_empty : 'a t -> bool
          val interval_val : 'a t -> ('a * 'a) option
          val empty_val : 'a t -> unit option

          module Variants : sig
            val interval : ('a -> 'a -> 'a t) Variantslib.Variant.t
            val empty : 'a t Variantslib.Variant.t

            val fold
              :  init:'acc__0
              -> interval:('acc__0 -> ('a -> 'a -> 'a t) Variantslib.Variant.t -> 'acc__1)
              -> empty:('acc__1 -> 'a t Variantslib.Variant.t -> 'acc__2)
              -> 'acc__2

            val iter
              :  interval:(('a -> 'a -> 'a t) Variantslib.Variant.t -> unit)
              -> empty:('a t Variantslib.Variant.t -> unit)
              -> unit

            val map
              :  'a t
              -> interval:
                   (('a -> 'a -> 'a t) Variantslib.Variant.t -> 'a -> 'a -> 'result__)
              -> empty:('a t Variantslib.Variant.t -> 'result__)
              -> 'result__

            val make_matcher
              :  interval:
                   (('a -> 'a -> 'a t) Variantslib.Variant.t
                    -> 'acc__0
                    -> ('a -> 'a -> 'result__) * 'acc__1)
              -> empty:
                   ('a t Variantslib.Variant.t
                    -> 'acc__1
                    -> (unit -> 'result__) * 'acc__2)
              -> 'acc__0
              -> ('a t -> 'result__) * 'acc__2

            val to_rank : 'a t -> int
            val to_name : 'a t -> string
            val descriptions : (string * int) list
          end
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val to_float : float t -> Float.t
        val to_int : int t -> Int.t
        val to_ofday : Core.Time_float.Ofday.t t -> Ofday.t

        val to_time : Core.Time_float.t t -> Core.Time_float.t interval
        [@@ocaml.doc
          " Used in testing Interval_unix.Time.t. Using Core.Time.t interval is\n\
          \            fine because it is equal to Interval_unix.Time.t. "]
      end
    end
  end
  [@@ocaml.doc
    "\n\
    \     [Stable] is used to build stable protocols. It ensures backwards compatibility \
     by\n\
    \     checking the sexp and bin-io representations of a given module. Here it's also \
     applied\n\
    \     to the [Float], [Int], [Time], [Time_ns], and [Ofday] intervals.\n\
    \  "]

  [@@@ocaml.text "/*"]

  module Private : sig
    module Make : functor
        (Bound : sig
           type t [@@deriving bin_io, sexp, hash]

           include sig
             [@@@ocaml.warning "-32"]

             include Bin_prot.Binable.S with type t := t
             include Sexplib0.Sexpable.S with type t := t
             include Ppx_hash_lib.Hashable.S with type t := t
           end
           [@@ocaml.doc "@inline"] [@@merlin.hide]

           include Comparable.S with type t := t
         end)
        -> S with type bound = Bound.t and type t = Bound.t t
  end
end
[@@ocaml.doc
  " Module for simple closed intervals over arbitrary types. Used by calling the\n\
  \    {{!module:Core.Interval.Make}[Make]} functor with a type that satisfies\n\
  \    {{!module:Base.Comparable}[Comparable]} (for correctly ordering elements).\n\n\
  \    Note that the actual interface for intervals is in\n\
  \    {{!modtype:Core__.Interval_intf.Gen}[Interval_intf.Gen]}, following a Core \
   pattern of\n\
  \    defining an interface once in a [Gen] module, then reusing it across monomorphic \
   ([S])\n\
  \    and polymorphic ([S1], [S2], ... [SN]) variants, where [SN] denotes a signature \
   of N\n\
  \    parameters. Here, [S1] is included in this module because the signature of one ['a]\n\
  \    parameter is the default.\n\n\
  \    See the documentation of {{!module:Core.Interval.Make}[Interval.Make]} for a more\n\
  \    detailed usage example. "]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
