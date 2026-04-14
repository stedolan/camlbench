let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"float_with_finite_only_serialization.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "float_with_finite_only_serialization.ml.before-ppx"
;;

open Ppx_compare_lib.Builtin

module Stable = struct
  open Stable_internal
  module Binable = Binable.Stable

  module V1 = struct
    exception Nan_or_inf [@@deriving sexp]

    include struct
      let () =
        Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Nan_or_inf] (function
          | Nan_or_inf ->
            Sexplib0.Sexp.Atom
              "float_with_finite_only_serialization.ml.before-ppx.Stable.V1.Nan_or_inf"
          | _ -> assert false)
      ;;
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type t = float [@@deriving compare, hash, equal, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__001_ b__002_ -> compare_float a__001_ b__002_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> hash_fold_float hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = hash_float in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let equal =
        (fun a__003_ b__004_ -> equal_float a__003_ b__004_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let verify t =
      match Stdlib.classify_float t with
      | FP_normal | FP_subnormal | FP_zero -> ()
      | FP_infinite | FP_nan -> raise Nan_or_inf
    ;;

    include
      Binable.Of_binable.V1 [@alert "-legacy"]
        (Float)
        (struct
          type nonrec t = t

          let of_binable t =
            verify t;
            t
          ;;

          let to_binable t =
            verify t;
            t
          ;;
        end)

    let sexp_of_t = Float.sexp_of_t

    let t_of_sexp = function
      | Sexp.Atom _ as sexp ->
        let t = Float.t_of_sexp sexp in
        (try verify t with
         | e -> Import.of_sexp_error (Import.Exn.to_string e) sexp);
        t
      | s -> Import.of_sexp_error "Decimal.t_of_sexp: Expected Atom, found List" s
    ;;

    let t_sexp_grammar = Float.t_sexp_grammar
  end
end

include Stable.V1

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
