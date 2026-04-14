let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"float.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "float.ml.before-ppx"
;;

external format_float : string -> float -> string = "caml_format_float"

let valid_float_lexem s =
  let l = String.length s in
  let rec loop i =
    if i >= l
    then s ^ "."
    else (
      match s.[i] with
      | '0' .. '9' | '-' -> loop (i + 1)
      | _ -> s)
  in
  loop 0
;;

open! Import

module Stable = struct
  module V1 = struct
    module T1 = struct
      include Base.Float

      type t = float
      [@@deriving bin_io ~localize, hash, sexp, stable_witness, typerep, globalize]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "float.ml.before-ppx:27:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_float ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_float__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_float__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_float__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_float
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_float hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash_float in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (float_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_float : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_float
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "float.ml.before-ppx.Stable.V1.T1.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_float))
        ;;

        let _ = typerep_of_t
        let globalize : t -> t = (globalize_float : t -> t)
        let _ = globalize
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T1
    include Comparable.Stable.V1.With_stable_witness.Make (T1)
  end
end

module T = Stable.V1
include T
include Hashable.Make_binable (T)
include Comparable.Map_and_set_binable_using_comparator (T)
include Comparable.Validate_with_zero (T)
module Replace_polymorphic_compare : Comparisons.S with type t := t = T

let validate_ordinary t =
  Validate.of_error_opt
    (let module C = Class in
     match classify t with
     | C.Normal | C.Subnormal | C.Zero -> None
     | C.Infinite -> Some "value is infinite"
     | C.Nan -> Some "value is NaN")
;;

module V = struct
  module ZZ = Comparable.Validate (T)

  let validate_bound ~min ~max t =
    Validate.first_failure (validate_ordinary t) (ZZ.validate_bound t ~min ~max)
  ;;

  let validate_lbound ~min t =
    Validate.first_failure (validate_ordinary t) (ZZ.validate_lbound t ~min)
  ;;

  let validate_ubound ~max t =
    Validate.first_failure (validate_ordinary t) (ZZ.validate_ubound t ~max)
  ;;
end

include V

module Robust_compare = struct
  module type S = sig
    val robust_comparison_tolerance : float

    include Robustly_comparable.S with type t := float
  end

  module Make (T : sig
      val robust_comparison_tolerance : float
    end) : S = struct
    open Poly

    let robust_comparison_tolerance = T.robust_comparison_tolerance
    let ( >=. ) x y = x >= Stdlib.( -. ) y robust_comparison_tolerance
    let ( <=. ) x y = y >=. x
    let ( =. ) x y = x >=. y && y >=. x
    let ( >. ) x y = x > Stdlib.( +. ) y robust_comparison_tolerance
    let ( <. ) x y = y >. x
    let ( <>. ) x y = not (x =. y)

    let robustly_compare x y =
      let d = Stdlib.( -. ) x y in
      if d < Stdlib.( ~-. ) robust_comparison_tolerance
      then -1
      else if d > robust_comparison_tolerance
      then 1
      else 0
    ;;
  end
end

module Robustly_comparable = Robust_compare.Make (struct
    let robust_comparison_tolerance = 1E-7
  end)

include Robustly_comparable

module O = struct
  include Base.Float.O
  include Robustly_comparable
end

module Terse = struct
  type nonrec t = t [@@deriving bin_io ~localize]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "float.ml.before-ppx:120:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_t__local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_t__local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include (
    Base.Float.Terse :
      module type of struct
        include Base.Float.Terse
      end
      with type t := t)
end

let robust_sign t : Sign.t = if t >. 0. then Pos else if t <. 0. then Neg else Zero
let sign = robust_sign
let to_string_12 x = valid_float_lexem (format_float "%.12g" x)
let quickcheck_generator = Base_quickcheck.Generator.float
let quickcheck_observer = Base_quickcheck.Observer.float
let quickcheck_shrinker = Base_quickcheck.Shrinker.float
let gen_uniform_excl = Base_quickcheck.Generator.float_uniform_exclusive
let gen_incl = Base_quickcheck.Generator.float_inclusive
let gen_without_nan = Base_quickcheck.Generator.float_without_nan
let gen_finite = Base_quickcheck.Generator.float_finite
let gen_positive = Base_quickcheck.Generator.float_strictly_positive
let gen_negative = Base_quickcheck.Generator.float_strictly_negative
let gen_zero = Base_quickcheck.Generator.float_of_class Zero
let gen_nan = Base_quickcheck.Generator.float_of_class Nan
let gen_subnormal = Base_quickcheck.Generator.float_of_class Subnormal
let gen_normal = Base_quickcheck.Generator.float_of_class Normal
let gen_infinite = Base_quickcheck.Generator.float_of_class Infinite
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
