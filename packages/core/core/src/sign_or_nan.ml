let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"sign_or_nan.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "sign_or_nan.ml.before-ppx"
;;

open! Import
module Sign_or_nan = Base.Sign_or_nan

module Stable = struct
  module V1 = struct
    type t = Sign_or_nan.t =
      | Neg
      | Zero
      | Pos
      | Nan
    [@@deriving sexp, bin_io, compare, hash, typerep, enumerate]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__003_ = "sign_or_nan.ml.before-ppx.Stable.V1.t" in
         function
         | Sexplib0.Sexp.Atom ("neg" | "Neg") -> Neg
         | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
         | Sexplib0.Sexp.Atom ("pos" | "Pos") -> Pos
         | Sexplib0.Sexp.Atom ("nan" | "Nan") -> Nan
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("neg" | "Neg") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("zero" | "Zero") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pos" | "Pos") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nan" | "Nan") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
         | Sexplib0.Sexp.List [] as sexp__002_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
         | sexp__002_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Neg -> Sexplib0.Sexp.Atom "Neg"
         | Zero -> Sexplib0.Sexp.Atom "Zero"
         | Pos -> Sexplib0.Sexp.Atom "Pos"
         | Nan -> Sexplib0.Sexp.Atom "Nan"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "sign_or_nan.ml.before-ppx:6:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.variant [ "Neg", []; "Zero", []; "Pos", []; "Nan", [] ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | Neg | Zero | Pos | Nan -> 1
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Neg -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
        | Zero -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
        | Pos -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
        | Nan -> Bin_prot.Write.bin_write_int_8bit buf ~pos 3
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "sign_or_nan.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 -> Neg
        | 1 -> Zero
        | 2 -> Pos
        | 3 -> Nan
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "sign_or_nan.ml.before-ppx.Stable.V1.t")
            !pos_ref
      ;;

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

      let compare =
        (fun a__005_ b__006_ -> Stdlib.compare a__005_ b__006_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        (fun hsv arg ->
           Ppx_hash_lib.Std.Hash.fold_int
             hsv
             (match arg with
              | Neg -> 0
              | Zero -> 1
              | Pos -> 2
              | Nan -> 3)
         : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
      ;;

      let _ = hash_fold_t

      let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func arg =
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg)
        in
        fun x -> func x
      ;;

      let _ = hash

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "sign_or_nan.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named
          ( name_of_t
          , Some
              (lazy
                (let tag0 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Neg"
                     ; rep = typerep_of_tuple0
                     ; arity = 0
                     ; args_labels = []
                     ; index = 0
                     ; ocaml_repr = 0
                     ; tyid = typename_of_tuple0
                     ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Neg
                     }
                 in
                 let tag1 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Zero"
                     ; rep = typerep_of_tuple0
                     ; arity = 0
                     ; args_labels = []
                     ; index = 1
                     ; ocaml_repr = 1
                     ; tyid = typename_of_tuple0
                     ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Zero
                     }
                 in
                 let tag2 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Pos"
                     ; rep = typerep_of_tuple0
                     ; arity = 0
                     ; args_labels = []
                     ; index = 2
                     ; ocaml_repr = 2
                     ; tyid = typename_of_tuple0
                     ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Pos
                     }
                 in
                 let tag3 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Nan"
                     ; rep = typerep_of_tuple0
                     ; arity = 0
                     ; args_labels = []
                     ; index = 3
                     ; ocaml_repr = 3
                     ; tyid = typename_of_tuple0
                     ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Nan
                     }
                 in
                 let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
                 let tags =
                   [| Typerep_lib.Std.Typerep.Variant_internal.Tag tag0
                    ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag1
                    ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag2
                    ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag3
                   |]
                 in
                 let polymorphic = false in
                 let value = function
                   | Neg ->
                     Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, value_tuple0)
                   | Zero ->
                     Typerep_lib.Std.Typerep.Variant_internal.Value (tag1, value_tuple0)
                   | Pos ->
                     Typerep_lib.Std.Typerep.Variant_internal.Value (tag2, value_tuple0)
                   | Nan ->
                     Typerep_lib.Std.Typerep.Variant_internal.Value (tag3, value_tuple0)
                 in
                 Typerep_lib.Std.Typerep.Variant
                   (Typerep_lib.Std.Typerep.Variant.internal_use_only
                      { Typerep_lib.Std.Typerep.Variant_internal.typename
                      ; Typerep_lib.Std.Typerep.Variant_internal.tags
                      ; Typerep_lib.Std.Typerep.Variant_internal.polymorphic
                      ; Typerep_lib.Std.Typerep.Variant_internal.value
                      }))) )
      ;;

      let _ = typerep_of_t
      let all = ([ Neg; Zero; Pos; Nan ] : t list)
      let _ = all
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

include Stable.V1
include Sign_or_nan
include Identifiable.Extend (Sign_or_nan) (Stable.V1)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
