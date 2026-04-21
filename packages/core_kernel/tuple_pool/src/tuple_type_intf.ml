let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"tuple_type_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "tuple_type_intf.ml.before-ppx"
;;

open! Core
open! Import

module type Slots = sig
  [@@@ocaml.text
    " [Slots] has types [t1], ..., [t12] of arities 1 to 12 that are isomorphic to tuple\n\
    \      types of the corresponding arities.  Type [('a0, ..., 'a<N-1>) t<N>] \
     corresponds to\n\
    \      ['a0 * ... * 'a<N-1>].\n\n\
    \      Each type [ti] is an instance of type [('tuple, 'variant) t], in which \
     ['tuple] is\n\
    \      the tuple type ['a0 * ... * 'a<N-1>] and ['variant] is an encoding of the \
     tuple type\n\
    \      in the form: [[ `S0 of `a0 | `S1 of `a1 | ... | `S<N-1> of `a<N-1> ]].\n\n\
    \      The encoding of the slots using a polymorphic variant allows one to write \
     functions\n\
    \      that are polymorphic in the tuple type, and require that a tuple have a certain\n\
    \      slot, but allow more slots.\n\n\
    \      We make [t] itself a polymorphic variant type so that one can easily encode \
     cyclic\n\
    \      types, e.g. lists, like:\n\n\
    \      {[\n\
    \        type 'a slots = ('a, 'a slots Pointer.t) Slots.t2\n\
    \      ]}\n\n\
    \      Observe that [slots] in the above is cyclic, but that OCaml allows it because \
     the\n\
    \      definition expands to:\n\n\
    \      {[\n\
    \        type 'a slots = [ `Slots of ('a * 'a slots Pointer.t,\n\
    \                                     [ `S0 of 'a\n\
    \                                     | `S1 of 'a slots Pointer.t\n\
    \                                     ]\n\
    \                                    ) u\n\
    \                        ]\n\
    \      ]}\n\n\
    \      Ultimately, a [Slots.t] is used as a phantom type that ensures consistent \
     usage of\n\
    \      the tuples in the data structure containing them. "]

  type ('tuple, 'variant) u
  type ('tuple, 'variant) t = [ `Slots of ('tuple, 'variant) u ] [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('tuple -> Sexplib0.Sexp.t)
      -> ('variant -> Sexplib0.Sexp.t)
      -> ('tuple, 'variant) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val slots_per_tuple : (_, _) t -> int

  type 'a0 t1 = ('a0, [ `S0 of 'a0 ]) t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t1 : ('a0 -> Sexplib0.Sexp.t) -> 'a0 t1 -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1) t2 = ('a0 * 'a1, [ `S0 of 'a0 | `S1 of 'a1 ]) t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t2
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1) t2
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2) t3 = ('a0 * 'a1 * 'a2, [ `S0 of 'a0 | `S1 of 'a1 | `S2 of 'a2 ]) t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t3
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2) t3
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3) t4 =
    ('a0 * 'a1 * 'a2 * 'a3, [ `S0 of 'a0 | `S1 of 'a1 | `S2 of 'a2 | `S3 of 'a3 ]) t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t4
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3) t4
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4) t5 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4
      , [ `S0 of 'a0 | `S1 of 'a1 | `S2 of 'a2 | `S3 of 'a3 | `S4 of 'a4 ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t5
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4) t5
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5) t6 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5
      , [ `S0 of 'a0 | `S1 of 'a1 | `S2 of 'a2 | `S3 of 'a3 | `S4 of 'a4 | `S5 of 'a5 ]
      )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t6
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5) t6
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) t7 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t7
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) t7
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) t8 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t8
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) t8
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8) t9 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t9
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8) t9
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9) t10 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8 * 'a9
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        | `S9 of 'a9
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t10
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a9 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9) t10
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10) t11 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8 * 'a9 * 'a10
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        | `S9 of 'a9
        | `S10 of 'a10
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t11
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a9 -> Sexplib0.Sexp.t)
      -> ('a10 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10) t11
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11) t12 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8 * 'a9 * 'a10 * 'a11
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        | `S9 of 'a9
        | `S10 of 'a10
        | `S11 of 'a11
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t12
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a9 -> Sexplib0.Sexp.t)
      -> ('a10 -> Sexplib0.Sexp.t)
      -> ('a11 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11) t12
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12) t13 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8 * 'a9 * 'a10 * 'a11 * 'a12
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        | `S9 of 'a9
        | `S10 of 'a10
        | `S11 of 'a11
        | `S12 of 'a12
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t13
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a9 -> Sexplib0.Sexp.t)
      -> ('a10 -> Sexplib0.Sexp.t)
      -> ('a11 -> Sexplib0.Sexp.t)
      -> ('a12 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12) t13
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12, 'a13) t14 =
    ( 'a0 * 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6 * 'a7 * 'a8 * 'a9 * 'a10 * 'a11 * 'a12 * 'a13
      , [ `S0 of 'a0
        | `S1 of 'a1
        | `S2 of 'a2
        | `S3 of 'a3
        | `S4 of 'a4
        | `S5 of 'a5
        | `S6 of 'a6
        | `S7 of 'a7
        | `S8 of 'a8
        | `S9 of 'a9
        | `S10 of 'a10
        | `S11 of 'a11
        | `S12 of 'a12
        | `S13 of 'a13
        ] )
      t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t14
      :  ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a8 -> Sexplib0.Sexp.t)
      -> ('a9 -> Sexplib0.Sexp.t)
      -> ('a10 -> Sexplib0.Sexp.t)
      -> ('a11 -> Sexplib0.Sexp.t)
      -> ('a12 -> Sexplib0.Sexp.t)
      -> ('a13 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12, 'a13) t14
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val t1 : _ t1
  val t2 : (_, _) t2
  val t3 : (_, _, _) t3
  val t4 : (_, _, _, _) t4
  val t5 : (_, _, _, _, _) t5
  val t6 : (_, _, _, _, _, _) t6
  val t7 : (_, _, _, _, _, _, _) t7
  val t8 : (_, _, _, _, _, _, _, _) t8
  val t9 : (_, _, _, _, _, _, _, _, _) t9
  val t10 : (_, _, _, _, _, _, _, _, _, _) t10
  val t11 : (_, _, _, _, _, _, _, _, _, _, _) t11
  val t12 : (_, _, _, _, _, _, _, _, _, _, _, _) t12
  val t13 : (_, _, _, _, _, _, _, _, _, _, _, _, _) t13
  val t14 : (_, _, _, _, _, _, _, _, _, _, _, _, _, _) t14
end

module type Slot = sig
  type ('variant, 'a) t
  [@@ocaml.doc " A [Slot.t] represents a slot in a tuple type. "] [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('variant -> Sexplib0.Sexp.t)
      -> ('a -> Sexplib0.Sexp.t)
      -> ('variant, 'a) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val equal : ('v, 'a) t -> ('v, 'a) t -> bool

  [@@@ocaml.text " [ti] is the [i]'th slot. "]

  val t0 : ([> `S0 of 'a ], 'a) t
  val t1 : ([> `S1 of 'a ], 'a) t
  val t2 : ([> `S2 of 'a ], 'a) t
  val t3 : ([> `S3 of 'a ], 'a) t
  val t4 : ([> `S4 of 'a ], 'a) t
  val t5 : ([> `S5 of 'a ], 'a) t
  val t6 : ([> `S6 of 'a ], 'a) t
  val t7 : ([> `S7 of 'a ], 'a) t
  val t8 : ([> `S8 of 'a ], 'a) t
  val t9 : ([> `S9 of 'a ], 'a) t
  val t10 : ([> `S10 of 'a ], 'a) t
  val t11 : ([> `S11 of 'a ], 'a) t
  val t12 : ([> `S12 of 'a ], 'a) t
  val t13 : ([> `S13 of 'a ], 'a) t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
