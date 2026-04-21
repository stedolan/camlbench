let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"uopt_core.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "uopt_core.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V1 = struct
    type 'a t = 'a Uopt.t [@@deriving sexp]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__001_ x__003_ -> Uopt.t_of_sexp _of_a__001_ x__003_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__004_ x__005_ -> Uopt.sexp_of_t _of_a__004_ x__005_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let stable_witness value_witness =
      Stable_witness.of_serializable
        (stable_witness_option value_witness)
        Uopt.of_option
        Uopt.to_option
    ;;

    module Minimal_bin_io = struct
      type nonrec 'a t = 'a t

      let bin_shape_t bin_shape_a =
        Bin_prot.Shape.basetype (Bin_prot.Shape.Uuid.of_string "option") [ bin_shape_a ]
      ;;

      let bin_size_t bin_size_a t =
        let __ppx_optional_e_0 = t in
        if false
        then (
          (match
             if Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some (Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
           with
           | None -> bin_size_bool false
           | Some a -> bin_size_bool true + bin_size_a a)
          [@merlin.focus])
        else (
          (match Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
           | (true [@merlin.hide]) -> bin_size_bool false
           | (false [@merlin.hide]) ->
             let a : _ =
               Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
             in
             bin_size_bool true + bin_size_a a)
          [@merlin.hide] [@ocaml.warning "-a"])
      ;;

      let bin_write_t bin_write_a buf ~pos t =
        let __ppx_optional_e_0 = t in
        if false
        then (
          (match
             if Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some (Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
           with
           | None -> bin_write_bool buf ~pos false
           | Some a ->
             let pos = bin_write_bool buf ~pos true in
             bin_write_a buf ~pos a)
          [@merlin.focus])
        else (
          (match Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
           | (true [@merlin.hide]) -> bin_write_bool buf ~pos false
           | (false [@merlin.hide]) ->
             let a : _ =
               Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
             in
             let pos = bin_write_bool buf ~pos true in
             bin_write_a buf ~pos a)
          [@merlin.hide] [@ocaml.warning "-a"])
      ;;

      let bin_read_t bin_read_a buf ~pos_ref =
        match bin_read_bool buf ~pos_ref with
        | false -> Uopt.none
        | true -> Uopt.some (bin_read_a buf ~pos_ref)
      ;;

      let __bin_read_t__
            (_ : _ Bin_prot.Read.reader)
            (_ : Bigstring.V1.t)
            ~pos_ref
            (_ : int)
        =
        Bin_prot.Common.raise_variant_wrong_type "Uopt" !pos_ref
      ;;
    end

    include Bin_prot.Utils.Of_minimal1 (Minimal_bin_io)
  end
end

open! Core
include Stable.V1
include Uopt

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
