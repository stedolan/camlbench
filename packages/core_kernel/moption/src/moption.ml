let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"moption.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "moption.ml.before-ppx"
;;

module Exposed_for_use_in_stable = struct
  open! Core
  open! Import

  let none = Obj.obj (Obj.new_block Obj.abstract_tag 1)
  let create () = ref none
  let is_none x = phys_equal !x none
  let get t = if is_none t then None else Some !t
  let unsafe_get t = !t

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unsafe_get
    end
  end
end

module Stable = struct
  open! Core.Core_stable
  open Exposed_for_use_in_stable

  module V1 = struct
    type 'a t = 'a ref [@@deriving stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let stable_witness
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a ref Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_ref
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Sexpable.Of_sexpable1.V1
        (Option.V1)
        (struct
          type nonrec 'a t = 'a t

          let to_sexpable = get

          let of_sexpable = function
            | None -> create ()
            | Some v -> ref v
          ;;
        end)

    module Minimal_bin_io = struct
      type nonrec 'a t = 'a t

      let bin_shape_t bin_shape_a =
        Bin_prot.Shape.basetype
          (Bin_prot.Shape.Uuid.of_string "afef8a9c-daba-11ed-a4e5-aa777790ac98")
          [ bin_shape_a ]
      ;;

      let bin_size_t bin_size_a t =
        let __ppx_optional_e_0 = (t : _ t) in
        if false
        then (
          (match
             if Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else Some (Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
           with
           | None -> bin_size_bool false
           | Some a -> bin_size_bool true + bin_size_a a)
          [@merlin.focus])
        else (
          (match Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
           | (true [@merlin.hide]) -> bin_size_bool false
           | (false [@merlin.hide]) ->
             let a : _ =
               Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
             in
             bin_size_bool true + bin_size_a a)
          [@merlin.hide] [@ocaml.warning "-a"])
      ;;

      let bin_write_t bin_write_a buf ~pos t =
        let __ppx_optional_e_0 = (t : _ t) in
        if false
        then (
          (match
             if Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else Some (Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
           with
           | None -> bin_write_bool buf ~pos false
           | Some a ->
             let pos = bin_write_bool buf ~pos true in
             bin_write_a buf ~pos a)
          [@merlin.focus])
        else (
          (match Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
           | (true [@merlin.hide]) -> bin_write_bool buf ~pos false
           | (false [@merlin.hide]) ->
             let a : _ =
               Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
             in
             let pos = bin_write_bool buf ~pos true in
             bin_write_a buf ~pos a)
          [@merlin.hide] [@ocaml.warning "-a"])
      ;;

      let bin_read_t bin_read_a buf ~pos_ref =
        match bin_read_bool buf ~pos_ref with
        | false -> create ()
        | true -> ref (bin_read_a buf ~pos_ref)
      ;;

      let __bin_read_t__
            (_ : _ Bin_prot.Read.reader)
            (_ : Bigstring.V1.t)
            ~pos_ref
            (_ : int)
        =
        Bin_prot.Common.raise_variant_wrong_type "Moption" !pos_ref
      ;;
    end

    include Bin_prot.Utils.Of_minimal1 (Minimal_bin_io)
  end
end

open! Core
open! Import
include Stable.V1
include Exposed_for_use_in_stable

let is_some x = not (is_none x)

let get_some_exn x =
  if is_none x
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Conv.sexp_of_string "Moption.get_some_exn"
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  else !x
;;

let set_some t v = t := v
let set_none t = t := none

let set t v =
  match v with
  | None -> set_none t
  | Some v -> set_some t v
;;

let invariant invariant_a t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "moption.ml.before-ppx"
    ; pos_lnum = 107
    ; pos_cnum = 2811
    ; pos_bol = 2789
    }
    t
    ((fun x__001_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__001_) [@merlin.hide])
    (fun () -> Option.iter (get t) ~f:invariant_a)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
