let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"string_id.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "string_id.ml.before-ppx"
;;

open! Import
open Std_internal
include String_id_intf

module Make_with_validate_without_pretty_printer_with_bin_shape
    (M : sig
       val module_name : string
       val validate : string -> unit Or_error.t
       val include_default_validation : bool
       val caller_identity : Bin_prot.Shape.Uuid.t option
     end)
    () =
struct
  module Stable = struct
    module V1 = struct
      module T = struct
        type t = string
        [@@deriving
          compare, equal, globalize, hash, sexp, sexp_grammar, typerep, stable_witness]

        include struct
          [@@@ocaml.warning "-60"]

          let _ = fun (_ : t) -> ()

          let compare =
            (fun a__001_ b__002_ -> compare_string a__001_ b__002_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__003_ b__004_ -> equal_string a__003_ b__004_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
          let globalize : t -> t = (globalize_string : t -> t)
          let _ = globalize

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_string hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash_string in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash

          let t_of_sexp = (string_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_string : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = string_sexp_grammar
          let _ = t_sexp_grammar

          module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
              type nonrec t = t

              let name =
                "string_id.ml.before-ppx.Make_with_validate_without_pretty_printer_with_bin_shape.Stable.V1.T.t"
              ;;

              let _ = name
            end)

          let typename_of_t = Typename_of_t.typename_of_t
          let _ = typename_of_t

          let typerep_of_t =
            let name_of_t = Typename_of_t.named in
            Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_string))
          ;;

          let _ = typerep_of_t

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_string
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let check_for_whitespace =
          let invalid s reason =
            Error (sprintf "'%s' is not a valid %s because %s" s M.module_name reason)
          in
          fun s ->
            let len = String.length s in
            if Int.( = ) len 0
            then invalid s "it is empty"
            else if Char.is_whitespace s.[0] || Char.is_whitespace s.[len - 1]
            then invalid s "it has whitespace on the edge"
            else Ok ()
        ;;

        let validate s = Result.map_error (M.validate s) ~f:Error.to_string_mach

        let check s =
          if M.include_default_validation
          then (
            match check_for_whitespace s with
            | Ok () -> validate s
            | Error error -> Error error)
          else validate s
        ;;

        let to_string = Fn.id
        let pp = String.pp

        let of_string s =
          match check s with
          | Ok () -> s
          | Error err -> invalid_arg err
        ;;

        let t_of_sexp sexp =
          let s = String.Stable.V1.t_of_sexp sexp in
          match check s with
          | Ok () -> s
          | Error err -> of_sexp_error err sexp
        ;;

        include
          Binable.Of_binable_without_uuid [@alert "-legacy"]
            (String)
            (struct
              type nonrec t = t

              let to_binable = Fn.id
              let of_binable = of_string
            end)

        let bin_shape_t =
          let open Bin_prot.Shape in
          match M.caller_identity with
          | None -> bin_shape_t
          | Some uuid -> annotate uuid bin_shape_t
        ;;
      end

      module T_with_comparator = struct
        include T
        include Comparator.Stable.V1.Make (T)
      end

      include T_with_comparator
      include Comparable.Stable.V1.With_stable_witness.Make (T_with_comparator)
      include Hashable.Stable.V1.With_stable_witness.Make (T_with_comparator)
      include Diffable.Atomic.Make (T_with_comparator)
    end
  end

  module Stable_latest = Stable.V1
  include Stable_latest.T_with_comparator
  include Comparable.Make_binable_using_comparator (Stable_latest.T_with_comparator)
  include Hashable.Make_binable (Stable_latest.T_with_comparator)
  include Diffable.Atomic.Make (Stable_latest)

  let quickcheck_shrinker = Quickcheck.Shrinker.empty ()
  let quickcheck_observer = String.quickcheck_observer

  let quickcheck_generator =
    Quickcheck.Generator.filter
      ~f:(fun string -> Result.is_ok (check string))
      (String.gen_nonempty' Char.gen_print)
  ;;

  let arg_type = Command.Arg_type.create of_string
end

module Make_with_validate_without_pretty_printer
    (M : sig
       val module_name : string
       val validate : string -> unit Or_error.t
       val include_default_validation : bool
     end)
    () =
struct
  include
    Make_with_validate_without_pretty_printer_with_bin_shape
      (struct
        include M

        let caller_identity = None
      end)
      ()
end

module Make_without_pretty_printer
    (M : sig
       val module_name : string
     end)
    () =
struct
  include
    Make_with_validate_without_pretty_printer
      (struct
        let module_name = M.module_name
        let validate = Fn.const (Ok ())
        let include_default_validation = true
      end)
      ()
end

module Make_with_validate
    (M : sig
       val module_name : string
       val validate : string -> unit Or_error.t
       val include_default_validation : bool
     end)
    () =
struct
  include Make_with_validate_without_pretty_printer (M) ()

  include Pretty_printer.Register (struct
      type nonrec t = t

      let module_name = M.module_name
      let to_string = to_string
    end)
end

module Make
    (M : sig
       val module_name : string
     end)
    () =
struct
  include Make_without_pretty_printer (M) ()

  include Pretty_printer.Register (struct
      type nonrec t = t

      let module_name = M.module_name
      let to_string = to_string
    end)
end

module Make_with_distinct_bin_shape
    (M : sig
       val module_name : string
       val caller_identity : Bin_prot.Shape.Uuid.t
     end)
    () =
struct
  include
    Make_with_validate_without_pretty_printer_with_bin_shape
      (struct
        let module_name = M.module_name
        let validate = Fn.const (Ok ())
        let include_default_validation = true
        let caller_identity = Some M.caller_identity
      end)
      ()

  include Pretty_printer.Register (struct
      type nonrec t = t

      let module_name = M.module_name
      let to_string = to_string
    end)
end

include
  Make
    (struct
      let module_name = "Core.String_id"
    end)
    ()

module String_without_validation_without_pretty_printer = struct
  include String

  let globalize = globalize_string
  let arg_type = Command.Arg_type.create Fn.id
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
