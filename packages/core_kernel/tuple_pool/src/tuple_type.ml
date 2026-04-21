let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"tuple_type.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "tuple_type.ml.before-ppx"
;;

open! Core
open! Import
include Tuple_type_intf

module Slots = struct
  type u_ = { slots_per_tuple : int } [@@deriving sexp_of]

  include struct
    let _ = fun (_ : u_) -> ()

    let sexp_of_u_ =
      (fun { slots_per_tuple = slots_per_tuple__002_ } ->
         let bnds__001_ = ([] : _ Stdlib.List.t) in
         let bnds__001_ =
           let arg__003_ = sexp_of_int slots_per_tuple__002_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "slots_per_tuple"; arg__003_ ]
            :: bnds__001_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__001_
       : u_ -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_u_
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('tuple, 'variant) u = u_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('tuple, 'variant) u) -> ()

    let sexp_of_u
      :  'tuple 'variant.
         ('tuple -> Sexplib0.Sexp.t)
      -> ('variant -> Sexplib0.Sexp.t)
      -> ('tuple, 'variant) u
      -> Sexplib0.Sexp.t
      =
      fun _of_tuple__004_ _of_variant__005_ -> sexp_of_u_
    ;;

    let _ = sexp_of_u
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t_ = [ `Slots of u_ ] [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t_) -> ()

    let sexp_of_t_ =
      (fun (`Slots v__006_) ->
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Slots"; sexp_of_u_ v__006_ ]
       : t_ -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t_
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('tuple, 'variant) t = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('tuple, 'variant) t) -> ()

    let sexp_of_t
      :  'tuple 'variant.
         ('tuple -> Sexplib0.Sexp.t)
      -> ('variant -> Sexplib0.Sexp.t)
      -> ('tuple, 'variant) t
      -> Sexplib0.Sexp.t
      =
      fun _of_tuple__007_ _of_variant__008_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let slots_per_tuple (`Slots { slots_per_tuple = n }) = n

  type 'a0 t1 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a0 t1) -> ()

    let sexp_of_t1 : 'a0. ('a0 -> Sexplib0.Sexp.t) -> 'a0 t1 -> Sexplib0.Sexp.t =
      fun _of_a0__009_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t1
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1) t2 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1) t2) -> ()

    let sexp_of_t2
      :  'a0 'a1.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1) t2
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__010_ _of_a1__011_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t2
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2) t3 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2) t3) -> ()

    let sexp_of_t3
      :  'a0 'a1 'a2.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2) t3
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__012_ _of_a1__013_ _of_a2__014_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t3
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3) t4 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3) t4) -> ()

    let sexp_of_t4
      :  'a0 'a1 'a2 'a3.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3) t4
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__015_ _of_a1__016_ _of_a2__017_ _of_a3__018_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t4
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4) t5 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4) t5) -> ()

    let sexp_of_t5
      :  'a0 'a1 'a2 'a3 'a4.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4) t5
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__019_ _of_a1__020_ _of_a2__021_ _of_a3__022_ _of_a4__023_ -> sexp_of_t_
    ;;

    let _ = sexp_of_t5
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5) t6 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5) t6) -> ()

    let sexp_of_t6
      :  'a0 'a1 'a2 'a3 'a4 'a5.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5) t6
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__024_ _of_a1__025_ _of_a2__026_ _of_a3__027_ _of_a4__028_ _of_a5__029_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t6
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) t7 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) t7) -> ()

    let sexp_of_t7
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6) t7
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__030_
        _of_a1__031_
        _of_a2__032_
        _of_a3__033_
        _of_a4__034_
        _of_a5__035_
        _of_a6__036_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t7
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) t8 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) t8) -> ()

    let sexp_of_t8
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7.
         ('a0 -> Sexplib0.Sexp.t)
      -> ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a7 -> Sexplib0.Sexp.t)
      -> ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7) t8
      -> Sexplib0.Sexp.t
      =
      fun _of_a0__037_
        _of_a1__038_
        _of_a2__039_
        _of_a3__040_
        _of_a4__041_
        _of_a5__042_
        _of_a6__043_
        _of_a7__044_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t8
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8) t9 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8) t9) -> ()

    let sexp_of_t9
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__045_
        _of_a1__046_
        _of_a2__047_
        _of_a3__048_
        _of_a4__049_
        _of_a5__050_
        _of_a6__051_
        _of_a7__052_
        _of_a8__053_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t9
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9) t10 = t_ [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9) t10) -> ()

    let sexp_of_t10
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8 'a9.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__054_
        _of_a1__055_
        _of_a2__056_
        _of_a3__057_
        _of_a4__058_
        _of_a5__059_
        _of_a6__060_
        _of_a7__061_
        _of_a8__062_
        _of_a9__063_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t10
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10) t11 = t_
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10) t11) -> ()

    let sexp_of_t11
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8 'a9 'a10.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__064_
        _of_a1__065_
        _of_a2__066_
        _of_a3__067_
        _of_a4__068_
        _of_a5__069_
        _of_a6__070_
        _of_a7__071_
        _of_a8__072_
        _of_a9__073_
        _of_a10__074_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t11
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11) t12 = t_
  [@@deriving sexp_of]

  include struct
    let _ =
      fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11) t12) -> ()
    ;;

    let sexp_of_t12
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8 'a9 'a10 'a11.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__075_
        _of_a1__076_
        _of_a2__077_
        _of_a3__078_
        _of_a4__079_
        _of_a5__080_
        _of_a6__081_
        _of_a7__082_
        _of_a8__083_
        _of_a9__084_
        _of_a10__085_
        _of_a11__086_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t12
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12) t13 = t_
  [@@deriving sexp_of]

  include struct
    let _ =
      fun (_ : ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12) t13) ->
      ()
    ;;

    let sexp_of_t13
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8 'a9 'a10 'a11 'a12.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__087_
        _of_a1__088_
        _of_a2__089_
        _of_a3__090_
        _of_a4__091_
        _of_a5__092_
        _of_a6__093_
        _of_a7__094_
        _of_a8__095_
        _of_a9__096_
        _of_a10__097_
        _of_a11__098_
        _of_a12__099_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t13
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12, 'a13) t14 = t_
  [@@deriving sexp_of]

  include struct
    let _ =
      fun (_ :
            ('a0, 'a1, 'a2, 'a3, 'a4, 'a5, 'a6, 'a7, 'a8, 'a9, 'a10, 'a11, 'a12, 'a13) t14) ->
      ()
    ;;

    let sexp_of_t14
      :  'a0 'a1 'a2 'a3 'a4 'a5 'a6 'a7 'a8 'a9 'a10 'a11 'a12 'a13.
         ('a0 -> Sexplib0.Sexp.t)
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
      =
      fun _of_a0__100_
        _of_a1__101_
        _of_a2__102_
        _of_a3__103_
        _of_a4__104_
        _of_a5__105_
        _of_a6__106_
        _of_a7__107_
        _of_a8__108_
        _of_a9__109_
        _of_a10__110_
        _of_a11__111_
        _of_a12__112_
        _of_a13__113_ ->
      sexp_of_t_
    ;;

    let _ = sexp_of_t14
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let t1 = `Slots { slots_per_tuple = 1 }
  let t2 = `Slots { slots_per_tuple = 2 }
  let t3 = `Slots { slots_per_tuple = 3 }
  let t4 = `Slots { slots_per_tuple = 4 }
  let t5 = `Slots { slots_per_tuple = 5 }
  let t6 = `Slots { slots_per_tuple = 6 }
  let t7 = `Slots { slots_per_tuple = 7 }
  let t8 = `Slots { slots_per_tuple = 8 }
  let t9 = `Slots { slots_per_tuple = 9 }
  let t10 = `Slots { slots_per_tuple = 10 }
  let t11 = `Slots { slots_per_tuple = 11 }
  let t12 = `Slots { slots_per_tuple = 12 }
  let t13 = `Slots { slots_per_tuple = 13 }
  let t14 = `Slots { slots_per_tuple = 14 }
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
