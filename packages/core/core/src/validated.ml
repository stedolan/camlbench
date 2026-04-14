let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"validated.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "validated.ml.before-ppx"
;;

open! Import
open Std_internal
open Validated_intf

module type Raw = Raw

type ('raw, 'witness) t = 'raw

module type S = S with type ('a, 'b) validated := ('a, 'b) t

module type S_allowing_substitution =
  S_allowing_substitution with type ('a, 'b) validated := ('a, 'b) t

module type S_bin_io = S_bin_io with type ('a, 'b) validated := ('a, 'b) t

module type S_bin_io_compare_hash_sexp =
  S_bin_io_compare_hash_sexp with type ('a, 'b) validated := ('a, 'b) t

module type S_bin_io_compare_globalize_hash_sexp =
  S_bin_io_compare_globalize_hash_sexp with type ('a, 'b) validated := ('a, 'b) t

let raw t = t
let raw_local t = t

module Make (Raw : Raw) = struct
  type witness
  type t = Raw.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (Raw.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let validation_failed t error =
    Error.create
      "validation failed"
      (t, error, Raw.here)
      ((fun (arg0__001_, arg1__002_, arg2__003_) ->
         let res0__004_ = Raw.sexp_of_t arg0__001_
         and res1__005_ = Error.sexp_of_t arg1__002_
         and res2__006_ = Source_code_position.sexp_of_t arg2__003_ in
         Sexplib0.Sexp.List [ res0__004_; res1__005_; res2__006_ ]) [@merlin.hide])
  ;;

  let create_exn t =
    match Validate.result (Raw.validate t) with
    | Ok () -> t
    | Error error -> Error.raise (validation_failed t error)
  ;;

  let create t =
    match Validate.result (Raw.validate t) with
    | Ok () -> Ok t
    | Error error -> Error (validation_failed t error)
  ;;

  let t_of_sexp sexp = create_exn (Raw.t_of_sexp sexp)
  let raw t = t
  let raw_local t = t

  let create_stable_witness raw_stable_witness =
    Stable_witness.of_serializable raw_stable_witness create_exn raw
  ;;

  let type_equal = Type_equal.T
end

module Add_bin_io
    (Raw : sig
       type t [@@deriving bin_io]

       include sig
         [@@@ocaml.warning "-32"]

         include Bin_prot.Binable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Raw_bin_io with type t := t
     end)
    (Validated : S with type raw := Raw.t) =
struct
  include
    Binable.Of_binable_without_uuid [@alert "-legacy"]
      (Raw)
      (struct
        type t = Raw.t

        let of_binable raw =
          if Raw.validate_binio_deserialization then Validated.create_exn raw else raw
        ;;

        let to_binable = Fn.id
      end)
end

module Add_compare
    (Raw : sig
       type t [@@deriving compare]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Comparable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Raw with type t := t
     end)
    (_ : S with type raw := Raw.t) =
struct
  let compare t1 t2 =
    (fun (a__007_ : Raw.t) ((b__008_ : Raw.t) [@merlin.hide]) ->
       (Raw.compare a__007_ b__008_ [@merlin.hide]))
      (raw t1)
      (raw t2)
  ;;
end

module Add_globalize
    (Raw : sig
       type t [@@deriving globalize]

       include sig
         [@@@ocaml.warning "-32"]

         val globalize : t -> t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Raw with type t := t
     end)
    (_ : S with type raw := Raw.t) =
struct
  let globalize t = Raw.globalize t
end

module Add_hash
    (Raw : sig
       type t [@@deriving hash]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_hash_lib.Hashable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Raw with type t := t
     end)
    (Validated : S with type raw := Raw.t) =
struct
  let hash_fold_t state t = Raw.hash_fold_t state (Validated.raw t)
  let hash t = Raw.hash (Validated.raw t)
end

module Add_typerep
    (Raw : sig
       type t [@@deriving typerep]

       include sig
         [@@@ocaml.warning "-32"]

         include Typerep_lib.Typerepable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       include Raw with type t := t
     end)
    (_ : S with type raw := Raw.t) =
struct
  type t = Raw.t [@@deriving typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "validated.ml.before-ppx.Add_typerep.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Raw.typerep_of_t))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Make_binable (Raw : Raw_bin_io) = struct
  module T0 = Make (Raw)
  include T0
  include Add_bin_io (Raw) (T0)
end

module Make_bin_io_compare_hash_sexp (Raw : sig
    type t [@@deriving compare, hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Raw_bin_io with type t := t
  end) =
struct
  module T = Make_binable (Raw)
  include T
  include Add_compare (Raw) (T)

  include (
    Add_hash (Raw) (T) :
        sig
          type t [@@deriving hash]

          include sig
            [@@@ocaml.warning "-32"]

            include Ppx_hash_lib.Hashable.S with type t := t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end
        with type t := t)
end

module Make_bin_io_compare_globalize_hash_sexp
    (Raw : Raw_bin_io_compare_globalize_hash_sexp) =
struct
  module T1 = Make_bin_io_compare_hash_sexp (Raw)
  include T1
  include Add_globalize (Raw) (T1)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
