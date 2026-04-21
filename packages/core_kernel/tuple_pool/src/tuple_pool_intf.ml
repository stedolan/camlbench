[@@@ocaml.text
  " A manual memory manager for a set of mutable tuples.  The point of [Tuple_pool] is to\n\
  \    allocate a single long-lived block of memory (the pool) that lives in the OCaml \
   major\n\
  \    heap, and then to reuse the block, rather than continually allocating blocks on the\n\
  \    minor heap.\n\n\
  \    A pool stores a bounded-size set of tuples, where client code is responsible for\n\
  \    explicitly controlling when the pool allocates and frees tuples.  One [create]s a\n\
  \    pool of a certain capacity, which returns an empty pool that can hold that many\n\
  \    tuples.  One then uses [new] to allocate a tuple, which returns a [Pointer.t] to \
   the\n\
  \    tuple.  One then uses [get] and [set] along with the pointer to get and set slots \
   of\n\
  \    the tuple.  Finally, one [free]'s a pointer to the pool's memory for a tuple, \
   making\n\
  \    the memory available for subsequent reuse.\n\n\
  \    In typical usage, one wraps up a pool with an abstract interface, giving nice names\n\
  \    to the tuple slots, and only exposing mutation where desired.\n\n\
  \    All the usual problems with manual memory allocation are present with pools:\n\n\
  \    - one can mistakenly use a pointer after it is freed\n\
  \    - one can mistakenly free a pointer multiple times\n\
  \    - one can forget to free a pointer\n\n\
  \    There is a debugging functor, [Tuple_pool.Error_check], that is useful for building\n\
  \    pools to help debug incorrect pointer usage. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"tuple_pool_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "tuple_pool_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  module Slots : Tuple_type.Slots
  module Slot : Tuple_type.Slot

  module Pointer : sig
    type 'slots t
    [@@ocaml.doc
      " A pointer to a tuple in a pool.  ['slots] will look like [('a1, ..., 'an)\n\
      \        Slots.tn], and the tuples have type ['a1 * ... * 'an]. "]
    [@@deriving sexp_of, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t

      include Typerep_lib.Typerepable.S1 with type 'slots t := 'slots t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val null : unit -> _ t
    [@@ocaml.doc
      " The [null] pointer is a distinct pointer that does not correspond to a tuple in\n\
      \        the pool.  It is a function to prevent problems due to the value \
       restriction. "]

    val is_null : _ t -> bool
    val phys_compare : 'a t -> 'a t -> int
    val phys_equal : 'a t -> 'a t -> bool

    module Id : sig
      type t [@@deriving bin_io, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_int63 : t -> Int63.t
      val of_int63 : Int63.t -> t
    end
  end

  type 'slots t
  [@@ocaml.doc
    " A pool.  ['slots] will look like [('a1, ..., 'an) Slots.tn], and the pool holds\n\
    \      tuples of type ['a1 * ... * 'an]. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Invariant.S1 with type 'a t := 'a t

  val pointer_is_valid : 'slots t -> 'slots Pointer.t -> bool
  [@@ocaml.doc
    " [pointer_is_valid t pointer] returns [true] iff [pointer] points to a live tuple in\n\
    \      [t], i.e. [pointer] is not null, not free, and is in the range of [t].\n\n\
    \      A pointer might not be in the range of a pool if it comes from another pool for\n\
    \      example.  In this case unsafe_get/set functions would cause a segfault. "]

  val id_of_pointer : 'slots t -> 'slots Pointer.t -> Pointer.Id.t
  [@@ocaml.doc
    " [id_of_pointer t pointer] returns an id that is unique for the lifetime of\n\
    \      [pointer]'s tuple.  When the tuple is freed, the id is no longer valid, and\n\
    \      [pointer_of_id_exn] will fail on it.  [Pointer.null ()] has a distinct id \
     from all\n\
    \      non-null pointers. "]

  val pointer_of_id_exn : 'slots t -> Pointer.Id.t -> 'slots Pointer.t
  [@@ocaml.doc
    " [pointer_of_id_exn t id] returns the pointer corresponding to [id].  It fails if the\n\
    \      tuple corresponding to [id] was already [free]d. "]

  val create : (('tuple, _) Slots.t as 'slots) -> capacity:int -> dummy:'tuple -> 'slots t
  [@@ocaml.doc
    " [create slots ~capacity ~dummy] creates an empty pool that can hold up to [capacity]\n\
    \      N-tuples.  The slots of [dummy] are stored in free tuples.  [create] raises if\n\
    \      [capacity < 0 || capacity > max_capacity ~slots_per_tuple]. "]

  val max_capacity : slots_per_tuple:int -> int
  [@@ocaml.doc
    " [max_capacity] returns the maximum capacity allowed when creating a pool. "]

  val capacity : _ t -> int
  [@@ocaml.doc
    " [capacity] returns the maximum number of tuples that the pool can hold. "]

  val length : _ t -> int
  [@@ocaml.doc
    " [length] returns the number of tuples currently in the pool.\n\n\
    \      {[\n\
    \        0 <= length t <= capacity t\n\
    \      ]}\n\
    \  "]

  val grow : ?capacity:(int[@ocaml.doc " default is [2 * capacity t] "]) -> 'a t -> 'a t
  [@@ocaml.doc
    " [grow t ~capacity] returns a new pool [t'] with the supplied capacity.  The new pool\n\
    \      is to be used as a replacement for [t].  All live tuples in [t] are now live in\n\
    \      [t'], and valid pointers to tuples in [t] are now valid pointers to the \
     identical\n\
    \      tuple in [t'].  It is an error to use [t] after calling [grow t].\n\n\
    \      [grow] raises if the supplied capacity isn't larger than [capacity t]. "]

  val is_full : _ t -> bool
  [@@ocaml.doc " [is_full t] returns [true] if no more tuples can be allocated in [t]. "]

  val free : 'slots t -> 'slots Pointer.t -> unit
  [@@ocaml.doc " [free t pointer] frees the tuple pointed to by [pointer] from [t]. "]

  val unsafe_free : 'slots t -> 'slots Pointer.t -> unit
  [@@ocaml.doc
    " [unsafe_free t pointer] frees the tuple pointed to by [pointer] without checking\n\
    \      [pointer_is_valid] "]

  val new1 : ('a0 Slots.t1 as 'slots) t -> 'a0 -> 'slots Pointer.t
  [@@ocaml.doc
    " [new<N> t a0 ... a<N-1>] returns a new tuple from the pool, with the tuple's\n\
    \      slots initialized to [a0] ... [a<N-1>].  [new] raises if [is_full t]. "]

  val new2 : (('a0, 'a1) Slots.t2 as 'slots) t -> 'a0 -> 'a1 -> 'slots Pointer.t

  val new3
    :  (('a0, 'a1, 'a2) Slots.t3 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'slots Pointer.t

  val new4
    :  (('a0, 'a1, 'a2, 'a3) Slots.t4 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'slots Pointer.t

  val new5
    :  (('a0, 'a1, 'a2, 'a3, 'a4) Slots.t5 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'slots Pointer.t

  val new6
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5) Slots.t6 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'slots Pointer.t

  val new7
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) Slots.t7 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'slots Pointer.t

  val new8
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) Slots.t8 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'slots Pointer.t

  val new9
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8) Slots.t9 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'slots Pointer.t

  val new10
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9) Slots.t10 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'a9
    -> 'slots Pointer.t

  val new11
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10) Slots.t11 as 'slots) t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'a9
    -> 'a10
    -> 'slots Pointer.t

  val new12
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11) Slots.t12 as 'slots)
         t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'a9
    -> 'a10
    -> 'a11
    -> 'slots Pointer.t

  val new13
    :  (('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12) Slots.t13
        as
        'slots)
         t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'a9
    -> 'a10
    -> 'a11
    -> 'a12
    -> 'slots Pointer.t

  val new14
    :  (( 'a0
          , 'a1
          , 'a2
          , 'a3
          , 'a4
          , 'a5
          , 'a6
          , 'a7
          , 'a8
          , 'a9
          , 'a10
          , 'a11
          , 'a12
          , 'a13 )
          Slots.t14
        as
        'slots)
         t
    -> 'a0
    -> 'a1
    -> 'a2
    -> 'a3
    -> 'a4
    -> 'a5
    -> 'a6
    -> 'a7
    -> 'a8
    -> 'a9
    -> 'a10
    -> 'a11
    -> 'a12
    -> 'a13
    -> 'slots Pointer.t

  val get_tuple : (('tuple, _) Slots.t as 'slots) t -> 'slots Pointer.t -> 'tuple
  [@@ocaml.doc
    " [get_tuple t pointer] allocates an OCaml tuple isomorphic to the pool [t]'s tuple\n\
    \      pointed to by [pointer]. The tuple gets copied, but its slots do not. "]

  val get
    :  ((_, 'variant) Slots.t as 'slots) t
    -> 'slots Pointer.t
    -> ('variant, 'slot) Slot.t
    -> 'slot
  [@@ocaml.doc
    " [get t pointer slot] gets [slot] of the tuple pointed to by [pointer] in\n\
    \      pool [t].\n\n\
    \      [set t pointer slot a] sets to [a] the [slot] of the tuple pointed to by \
     [pointer]\n\
    \      in pool [t].\n\n\
    \      In [get] and [set], it is an error to refer to a pointer that has been \
     [free]d.  It\n\
    \      is also an error to use a pointer with any pool other than the one the \
     pointer was\n\
    \      [new]'d from or [grow]n to.  These errors will lead to undefined behavior, \
     but will\n\
    \      not segfault.\n\n\
    \      [unsafe_get] is comparable in speed to [get] for immediate values, and 5%-10% \
     faster\n\
    \      for pointers.\n\n\
    \      [unsafe_get] and [unsafe_set] skip bounds checking, and can thus segfault. "]

  val unsafe_get
    :  ((_, 'variant) Slots.t as 'slots) t
    -> 'slots Pointer.t
    -> ('variant, 'slot) Slot.t
    -> 'slot

  val set
    :  ((_, 'variant) Slots.t as 'slots) t
    -> 'slots Pointer.t
    -> ('variant, 'slot) Slot.t
    -> 'slot
    -> unit

  val unsafe_set
    :  ((_, 'variant) Slots.t as 'slots) t
    -> 'slots Pointer.t
    -> ('variant, 'slot) Slot.t
    -> 'slot
    -> unit
end
[@@ocaml.doc " [S] is the module type for a pool. "]

module type Tuple_pool = sig
  module Tuple_type = Tuple_type

  module type S = S

  include
    S with type 'a Pointer.t = private int
  [@@ocaml.doc
    " This uses a [Uniform_array.t] to implement the pool.  We expose that [Pointer.t] is\n\
    \      an [int] so that OCaml can avoid the write barrier, due to knowing that \
     [Pointer.t]\n\
    \      isn't an OCaml pointer. "]
  [@@ocaml.doc " @inline "]

  module Unsafe : sig
    include S with type 'a Pointer.t = private int

    val create : ((_, _) Slots.t as 'slots) -> capacity:int -> 'slots t
    [@@ocaml.doc
      " [create slots ~capacity] creates an empty pool that can hold up to [capacity]\n\
      \        N-tuples.  The elements of a [free] tuple may contain stale and/or \
       invalid values\n\
      \        for their types, and as such any access to a [free] tuple from this pool is\n\
      \        unsafe. "]
  end
  [@@ocaml.doc
    " An [Unsafe] pool is like an ordinary pool, except that the [create] function does\n\
    \      not require an initial element.  The pool stores a dummy value for each slot.\n\
    \      Such a pool is only safe if one never accesses a slot from a [free]d tuple.\n\n\
    \      It makes sense to use [Unsafe] if one has a small constrained chunk of code \
     where\n\
    \      one can prove that one never accesses a [free]d tuple, and one needs a pool \
     where\n\
    \      it is difficult to construct a dummy value.\n\n\
    \      Some [Unsafe] functions are faster than the corresponding safe version \
     because they\n\
    \      do not have to maintain values with the correct represention in the \
     [Uniform_array]\n\
    \      backing the pool: [free], [create], [grow].\n\
    \  "]

  module Debug : functor (Tuple_pool : S) -> sig
    include
      S
      with type 'a Pointer.t = 'a Tuple_pool.Pointer.t
      with type Pointer.Id.t = Tuple_pool.Pointer.Id.t
      with type 'a t = 'a Tuple_pool.t

    val check_invariant : bool ref
    val show_messages : bool ref
  end
  [@@ocaml.doc
    " [Debug] builds a pool in which every function can run [invariant] on its pool\n\
    \      argument(s) and/or print a debug message to stderr, as determined by\n\
    \      [!check_invariant] and [!show_messages], which are initially both [true].\n\n\
    \      The performance of the pool resulting from [Debug] is much worse than that of \
     the\n\
    \      input [Tuple_pool], even with all the controls set to [false]. "]

  module Error_check : functor (Tuple_pool : S) -> S
  [@@ocaml.doc
    " [Error_check] builds a pool that has additional error checking for pointers, in\n\
    \      particular to detect using a [free]d pointer or multiply [free]ing a pointer.\n\n\
    \      [Error_check] has a significant performance cost, but less than that of \
     [Debug].\n\n\
    \      One can compose [Debug] and [Error_check], e.g:\n\n\
    \      {[\n\
    \        module M = Debug (Error_check (Tuple_pool))\n\
    \      ]}\n\
    \  "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
