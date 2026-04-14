let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ordering.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ordering.ml.before-ppx"
;;

open! Import

type t = Base.Ordering.t =
  | Less
  | Equal
  | Greater
[@@deriving bin_io, compare, hash, sexp]

include struct
  let _ = fun (_ : t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "ordering.ml.before-ppx:3:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , []
          , Bin_prot.Shape.variant [ "Less", []; "Equal", []; "Greater", [] ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
  ;;

  let _ = bin_shape_t

  let bin_size_t : t Bin_prot.Size.sizer = function
    | Less | Equal | Greater -> 1
  ;;

  let _ = bin_size_t

  let bin_write_t : t Bin_prot.Write.writer =
    fun buf ~pos -> function
    | Less -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
    | Equal -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
    | Greater -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
  ;;

  let _ = bin_write_t

  let bin_writer_t =
    ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_t

  let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type "ordering.ml.before-ppx.t" !pos_ref
  ;;

  let _ = __bin_read_t__

  let bin_read_t : t Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 -> Less
    | 1 -> Equal
    | 2 -> Greater
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "ordering.ml.before-ppx.t")
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
    (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    (fun hsv arg ->
       Ppx_hash_lib.Std.Hash.fold_int
         hsv
         (match arg with
          | Less -> 0
          | Equal -> 1
          | Greater -> 2)
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

  let t_of_sexp =
    (let error_source__005_ = "ordering.ml.before-ppx.t" in
     function
     | Sexplib0.Sexp.Atom ("less" | "Less") -> Less
     | Sexplib0.Sexp.Atom ("equal" | "Equal") -> Equal
     | Sexplib0.Sexp.Atom ("greater" | "Greater") -> Greater
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("less" | "Less") :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("equal" | "Equal") :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("greater" | "Greater") :: _) as sexp__006_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__005_ sexp__004_
     | Sexplib0.Sexp.List [] as sexp__004_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__005_ sexp__004_
     | sexp__004_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__005_ sexp__004_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (function
     | Less -> Sexplib0.Sexp.Atom "Less"
     | Equal -> Sexplib0.Sexp.Atom "Equal"
     | Greater -> Sexplib0.Sexp.Atom "Greater"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module type Base_mask = module type of Base.Ordering with type t := t

include (Base.Ordering : Base_mask)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
