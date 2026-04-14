let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"perms.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "perms.ml.before-ppx"
;;

open! Import
module Binable = Binable0

module Types = struct
  module Nobody = struct
    type t [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:9:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], Bin_prot.Shape.variant [] ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer =
        fun _v -> raise (Bin_prot.Common.Empty_type "perms.ml.before-ppx.Types.Nobody.t")
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun _buf ~pos:_ _v ->
        raise (Bin_prot.Common.Empty_type "perms.ml.before-ppx.Types.Nobody.t")
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "perms.ml.before-ppx.Types.Nobody.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        (fun _buf ~pos_ref ->
           Bin_prot.Common.raise_read_error
             (Bin_prot.Common.ReadError.Empty_type "perms.ml.before-ppx.Types.Nobody.t")
             !pos_ref)
          buf
          ~pos_ref
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
        (fun a__001_ b__002_ ->
           Ppx_compare_lib.compare_abstract ~type_name:"t" a__001_ b__002_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__003_ b__004_ ->
           Ppx_compare_lib.equal_abstract ~type_name:"t" a__003_ b__004_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let _ = hsv in
        let _ = arg in
        failwith "hash called on the type t, which is abstract in an implementation."
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
        (let error_source__006_ = "perms.ml.before-ppx.Types.Nobody.t" in
         fun x__007_ -> Sexplib0.Sexp_conv_error.empty_type error_source__006_ x__007_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp
      let sexp_of_t = (fun _ -> assert false : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Nobody"
  end

  module Me = struct
    type t [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:15:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], Bin_prot.Shape.variant [] ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer =
        fun _v -> raise (Bin_prot.Common.Empty_type "perms.ml.before-ppx.Types.Me.t")
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun _buf ~pos:_ _v ->
        raise (Bin_prot.Common.Empty_type "perms.ml.before-ppx.Types.Me.t")
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type "perms.ml.before-ppx.Types.Me.t" !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        (fun _buf ~pos_ref ->
           Bin_prot.Common.raise_read_error
             (Bin_prot.Common.ReadError.Empty_type "perms.ml.before-ppx.Types.Me.t")
             !pos_ref)
          buf
          ~pos_ref
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
        (fun a__008_ b__009_ ->
           Ppx_compare_lib.compare_abstract ~type_name:"t" a__008_ b__009_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__010_ b__011_ ->
           Ppx_compare_lib.equal_abstract ~type_name:"t" a__010_ b__011_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let _ = hsv in
        let _ = arg in
        failwith "hash called on the type t, which is abstract in an implementation."
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
        (let error_source__013_ = "perms.ml.before-ppx.Types.Me.t" in
         fun x__014_ -> Sexplib0.Sexp_conv_error.empty_type error_source__013_ x__014_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp
      let sexp_of_t = (fun _ -> assert false : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Me"
  end

  module Read = struct
    type t = [ `Read ] [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:21:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.poly_variant
                  (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:21:13")
                  [ Bin_prot.Shape.constr "Read" None ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t =
        (function
         | _ -> 4
         : _ Bin_prot.Size.sizer)
      ;;

      let _ = bin_size_t

      let bin_write_t =
        (fun buf ~pos -> function
           | `Read -> Bin_prot.Write.bin_write_variant_int buf ~pos 914388854
         : _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ _buf ~pos_ref:_ vint =
        match vint with
        | 914388854 -> `Read
        | _ -> raise Bin_prot.Common.No_variant_match
      ;;

      let _ = __bin_read_t__

      let bin_read_t buf ~pos_ref =
        let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
        try __bin_read_t__ buf ~pos_ref vint with
        | Bin_prot.Common.No_variant_match ->
          let err =
            Bin_prot.Common.ReadError.Variant "perms.ml.before-ppx.Types.Read.t"
          in
          Bin_prot.Common.raise_read_error err !pos_ref
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
        (fun a__015_ b__016_ ->
           if Stdlib.( == ) a__015_ b__016_
           then 0
           else (
             match a__015_, b__016_ with
             | `Read, `Read -> 0)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__017_ b__018_ ->
           if Stdlib.( == ) a__017_ b__018_
           then true
           else (
             match a__017_, b__018_ with
             | `Read, `Read -> true)
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        match arg with
        | `Read -> Ppx_hash_lib.Std.Hash.fold_int hsv 914388854
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

      let __t_of_sexp__ =
        (let error_source__024_ = "perms.ml.before-ppx.Types.Read.t" in
         function
         | Sexplib0.Sexp.Atom atom__020_ as _sexp__022_ ->
           (match atom__020_ with
            | "Read" -> `Read
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__020_ :: _) as _sexp__022_ ->
           (match atom__020_ with
            | "Read" ->
              Sexplib0.Sexp_conv_error.ptag_no_args error_source__024_ _sexp__022_
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__021_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
             error_source__024_
             sexp__021_
         | Sexplib0.Sexp.List [] as sexp__021_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
             error_source__024_
             sexp__021_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp =
        (let error_source__026_ = "perms.ml.before-ppx.Types.Read.t" in
         fun sexp__025_ ->
           try __t_of_sexp__ sexp__025_ with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__026_
               sexp__025_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp
      let sexp_of_t = (fun `Read -> Sexplib0.Sexp.Atom "Read" : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Read"
  end

  module Write = struct
    type t = [ `Who_can_write of Me.t ] [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:27:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.poly_variant
                  (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:27:13")
                  [ Bin_prot.Shape.constr "Who_can_write" (Some Me.bin_shape_t) ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t =
        (function
         | `Who_can_write args ->
           let size_args = Me.bin_size_t args in
           Bin_prot.Common.( + ) size_args 4
         : _ Bin_prot.Size.sizer)
      ;;

      let _ = bin_size_t

      let bin_write_t =
        (fun buf ~pos -> function
           | `Who_can_write args ->
             let pos = Bin_prot.Write.bin_write_variant_int buf ~pos 271892623 in
             Me.bin_write_t buf ~pos args
         : _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ buf ~pos_ref vint =
        match vint with
        | 271892623 ->
          let arg_1 = Me.bin_read_t buf ~pos_ref in
          `Who_can_write arg_1
        | _ -> raise Bin_prot.Common.No_variant_match
      ;;

      let _ = __bin_read_t__

      let bin_read_t buf ~pos_ref =
        let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
        try __bin_read_t__ buf ~pos_ref vint with
        | Bin_prot.Common.No_variant_match ->
          let err =
            Bin_prot.Common.ReadError.Variant "perms.ml.before-ppx.Types.Write.t"
          in
          Bin_prot.Common.raise_read_error err !pos_ref
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
        (fun a__027_ b__028_ ->
           if Stdlib.( == ) a__027_ b__028_
           then 0
           else (
             match a__027_, b__028_ with
             | `Who_can_write _left__029_, `Who_can_write _right__030_ ->
               Me.compare _left__029_ _right__030_)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__031_ b__032_ ->
           if Stdlib.( == ) a__031_ b__032_
           then true
           else (
             match a__031_, b__032_ with
             | `Who_can_write _left__033_, `Who_can_write _right__034_ ->
               Me.equal _left__033_ _right__034_)
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        match arg with
        | `Who_can_write _v ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 271892623 in
          Me.hash_fold_t hsv _v
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

      let __t_of_sexp__ =
        (let error_source__043_ = "perms.ml.before-ppx.Types.Write.t" in
         function
         | Sexplib0.Sexp.Atom atom__036_ as _sexp__038_ ->
           (match atom__036_ with
            | "Who_can_write" ->
              Sexplib0.Sexp_conv_error.ptag_takes_args error_source__043_ _sexp__038_
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__036_ :: sexp_args__039_) as
           _sexp__038_ ->
           (match atom__036_ with
            | "Who_can_write" as _tag__040_ ->
              (match sexp_args__039_ with
               | arg0__041_ :: [] ->
                 let res0__042_ = Me.t_of_sexp arg0__041_ in
                 `Who_can_write res0__042_
               | _ ->
                 Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                   error_source__043_
                   _tag__040_
                   _sexp__038_)
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__037_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
             error_source__043_
             sexp__037_
         | Sexplib0.Sexp.List [] as sexp__037_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
             error_source__043_
             sexp__037_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp =
        (let error_source__045_ = "perms.ml.before-ppx.Types.Write.t" in
         fun sexp__044_ ->
           try __t_of_sexp__ sexp__044_ with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__045_
               sexp__044_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun (`Who_can_write v__046_) ->
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Who_can_write"; Me.sexp_of_t v__046_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Write"
  end

  module Immutable = struct
    type t =
      [ Read.t
      | `Who_can_write of Nobody.t
      ]
    [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:33:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.poly_variant
                  (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:34:6")
                  [ Bin_prot.Shape.inherit_
                      (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:34:8")
                      Read.bin_shape_t
                  ; Bin_prot.Shape.constr "Who_can_write" (Some Nobody.bin_shape_t)
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t =
        (function
         | #Read.t as v -> Read.bin_size_t v
         | `Who_can_write args ->
           let size_args = Nobody.bin_size_t args in
           Bin_prot.Common.( + ) size_args 4
         : _ Bin_prot.Size.sizer)
      ;;

      let _ = bin_size_t

      let bin_write_t =
        (fun buf ~pos -> function
           | #Read.t as v -> Read.bin_write_t buf ~pos v
           | `Who_can_write args ->
             let pos = Bin_prot.Write.bin_write_variant_int buf ~pos 271892623 in
             Nobody.bin_write_t buf ~pos args
         : _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ buf ~pos_ref vint =
        try (Read.__bin_read_t__ buf ~pos_ref vint :> t) with
        | Bin_prot.Common.No_variant_match ->
          (match vint with
           | 271892623 ->
             let arg_1 = Nobody.bin_read_t buf ~pos_ref in
             `Who_can_write arg_1
           | _ -> raise Bin_prot.Common.No_variant_match)
      ;;

      let _ = __bin_read_t__

      let bin_read_t buf ~pos_ref =
        let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
        try __bin_read_t__ buf ~pos_ref vint with
        | Bin_prot.Common.No_variant_match ->
          let err =
            Bin_prot.Common.ReadError.Variant "perms.ml.before-ppx.Types.Immutable.t"
          in
          Bin_prot.Common.raise_read_error err !pos_ref
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
        (fun a__047_ b__048_ ->
           if Stdlib.( == ) a__047_ b__048_
           then 0
           else (
             match a__047_, b__048_ with
             | (#Read.t as _left__049_), (#Read.t as _right__050_) ->
               Read.compare _left__049_ _right__050_
             | `Who_can_write _left__051_, `Who_can_write _right__052_ ->
               Nobody.compare _left__051_ _right__052_
             | x, y -> Stdlib.compare x y)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__053_ b__054_ ->
           if Stdlib.( == ) a__053_ b__054_
           then true
           else (
             match a__053_, b__054_ with
             | (#Read.t as _left__055_), (#Read.t as _right__056_) ->
               Read.equal _left__055_ _right__056_
             | `Who_can_write _left__057_, `Who_can_write _right__058_ ->
               Nobody.equal _left__057_ _right__058_
             | x, y -> Stdlib.( = ) x y)
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        match arg with
        | #Read.t as _v -> Read.hash_fold_t hsv _v
        | `Who_can_write _v ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 271892623 in
          Nobody.hash_fold_t hsv _v
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

      let __t_of_sexp__ =
        (let error_source__067_ = "perms.ml.before-ppx.Types.Immutable.t" in
         fun sexp__059_ ->
           try (Read.__t_of_sexp__ sexp__059_ :> t) with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             (match sexp__059_ with
              | Sexplib0.Sexp.Atom atom__060_ as _sexp__062_ ->
                (match atom__060_ with
                 | "Who_can_write" ->
                   Sexplib0.Sexp_conv_error.ptag_takes_args error_source__067_ _sexp__062_
                 | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
              | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__060_ :: sexp_args__063_) as
                _sexp__062_ ->
                (match atom__060_ with
                 | "Who_can_write" as _tag__064_ ->
                   (match sexp_args__063_ with
                    | arg0__065_ :: [] ->
                      let res0__066_ = Nobody.t_of_sexp arg0__065_ in
                      `Who_can_write res0__066_
                    | _ ->
                      Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                        error_source__067_
                        _tag__064_
                        _sexp__062_)
                 | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
              | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__061_ ->
                Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                  error_source__067_
                  sexp__061_
              | Sexplib0.Sexp.List [] as sexp__061_ ->
                Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                  error_source__067_
                  sexp__061_)
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp =
        (let error_source__069_ = "perms.ml.before-ppx.Types.Immutable.t" in
         fun sexp__068_ ->
           try __t_of_sexp__ sexp__068_ with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__069_
               sexp__068_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | #Read.t as v__070_ -> Read.sexp_of_t v__070_
         | `Who_can_write v__071_ ->
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "Who_can_write"; Nobody.sexp_of_t v__071_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Immutable"
  end

  module Read_write = struct
    type t =
      [ Read.t
      | Write.t
      ]
    [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:43:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.poly_variant
                  (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:44:6")
                  [ Bin_prot.Shape.inherit_
                      (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:44:8")
                      Read.bin_shape_t
                  ; Bin_prot.Shape.inherit_
                      (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:45:8")
                      Write.bin_shape_t
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t =
        (function
         | #Read.t as v -> Read.bin_size_t v
         | #Write.t as v -> Write.bin_size_t v
         : _ Bin_prot.Size.sizer)
      ;;

      let _ = bin_size_t

      let bin_write_t =
        (fun buf ~pos -> function
           | #Read.t as v -> Read.bin_write_t buf ~pos v
           | #Write.t as v -> Write.bin_write_t buf ~pos v
         : _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ buf ~pos_ref vint =
        try (Read.__bin_read_t__ buf ~pos_ref vint :> t) with
        | Bin_prot.Common.No_variant_match ->
          (Write.__bin_read_t__ buf ~pos_ref vint :> t)
      ;;

      let _ = __bin_read_t__

      let bin_read_t buf ~pos_ref =
        let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
        try __bin_read_t__ buf ~pos_ref vint with
        | Bin_prot.Common.No_variant_match ->
          let err =
            Bin_prot.Common.ReadError.Variant "perms.ml.before-ppx.Types.Read_write.t"
          in
          Bin_prot.Common.raise_read_error err !pos_ref
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
        (fun a__072_ b__073_ ->
           if Stdlib.( == ) a__072_ b__073_
           then 0
           else (
             match a__072_, b__073_ with
             | (#Read.t as _left__074_), (#Read.t as _right__075_) ->
               Read.compare _left__074_ _right__075_
             | (#Write.t as _left__076_), (#Write.t as _right__077_) ->
               Write.compare _left__076_ _right__077_
             | x, y -> Stdlib.compare x y)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__078_ b__079_ ->
           if Stdlib.( == ) a__078_ b__079_
           then true
           else (
             match a__078_, b__079_ with
             | (#Read.t as _left__080_), (#Read.t as _right__081_) ->
               Read.equal _left__080_ _right__081_
             | (#Write.t as _left__082_), (#Write.t as _right__083_) ->
               Write.equal _left__082_ _right__083_
             | x, y -> Stdlib.( = ) x y)
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        match arg with
        | #Read.t as _v -> Read.hash_fold_t hsv _v
        | #Write.t as _v -> Write.hash_fold_t hsv _v
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

      let __t_of_sexp__ =
        (fun sexp__084_ ->
           try (Read.__t_of_sexp__ sexp__084_ :> t) with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             (Write.__t_of_sexp__ sexp__084_ :> t)
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp =
        (let error_source__086_ = "perms.ml.before-ppx.Types.Read_write.t" in
         fun sexp__085_ ->
           try __t_of_sexp__ sexp__085_ with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__086_
               sexp__085_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | #Read.t as v__087_ -> Read.sexp_of_t v__087_
         | #Write.t as v__088_ -> Write.sexp_of_t v__088_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Read_write"
  end

  module Upper_bound = struct
    type 'a t =
      [ Read.t
      | `Who_can_write of 'a
      ]
    [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:53:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.poly_variant
                  (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:54:6")
                  [ Bin_prot.Shape.inherit_
                      (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:54:8")
                      Read.bin_shape_t
                  ; Bin_prot.Shape.constr
                      "Who_can_write"
                      (Some
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "perms.ml.before-ppx:55:26")
                            (Bin_prot.Shape.Vid.of_string "a")))
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t =
        (fun _size_of_a -> function
           | #Read.t as v -> Read.bin_size_t v
           | `Who_can_write args ->
             let size_args = _size_of_a args in
             Bin_prot.Common.( + ) size_args 4
         : _ Bin_prot.Size.sizer -> _ Bin_prot.Size.sizer)
      ;;

      let _ = bin_size_t

      let bin_write_t =
        (fun _write_a buf ~pos -> function
           | #Read.t as v -> Read.bin_write_t buf ~pos v
           | `Who_can_write args ->
             let pos = Bin_prot.Write.bin_write_variant_int buf ~pos 271892623 in
             _write_a buf ~pos args
         : _ Bin_prot.Write.writer -> _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a ->
           { size = (fun v -> bin_size_t bin_writer_a.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ _of__a buf ~pos_ref vint =
        try (Read.__bin_read_t__ buf ~pos_ref vint :> 'a t) with
        | Bin_prot.Common.No_variant_match ->
          (match vint with
           | 271892623 ->
             let arg_1 = _of__a buf ~pos_ref in
             `Who_can_write arg_1
           | _ -> raise Bin_prot.Common.No_variant_match)
      ;;

      let _ = __bin_read_t__

      let bin_read_t _of__a buf ~pos_ref =
        let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
        try (__bin_read_t__ _of__a) buf ~pos_ref vint with
        | Bin_prot.Common.No_variant_match ->
          let err =
            Bin_prot.Common.ReadError.Variant "perms.ml.before-ppx.Types.Upper_bound.t"
          in
          Bin_prot.Common.raise_read_error err !pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a ->
           { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a ->
           { writer = bin_writer_t bin_a.writer
           ; reader = bin_reader_t bin_a.reader
           ; shape = bin_shape_t bin_a.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__089_ b__090_ ->
        if Stdlib.( == ) a__089_ b__090_
        then 0
        else (
          match a__089_, b__090_ with
          | (#Read.t as _left__091_), (#Read.t as _right__092_) ->
            Read.compare _left__091_ _right__092_
          | `Who_can_write _left__093_, `Who_can_write _right__094_ ->
            _cmp__a _left__093_ _right__094_
          | x, y -> Stdlib.compare x y)
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__095_ b__096_ ->
        if Stdlib.( == ) a__095_ b__096_
        then true
        else (
          match a__095_, b__096_ with
          | (#Read.t as _left__097_), (#Read.t as _right__098_) ->
            Read.equal _left__097_ _right__098_
          | `Who_can_write _left__099_, `Who_can_write _right__100_ ->
            _cmp__a _left__099_ _right__100_
          | x, y -> Stdlib.( = ) x y)
      ;;

      let _ = equal

      let hash_fold_t
        :  'a.
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        match arg with
        | #Read.t as _v -> Read.hash_fold_t hsv _v
        | `Who_can_write _v ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 271892623 in
          _hash_fold_a hsv _v
      ;;

      let _ = hash_fold_t

      let __t_of_sexp__ : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        let error_source__110_ = "perms.ml.before-ppx.Types.Upper_bound.t" in
        fun _of_a__101_ sexp__102_ ->
          try (Read.__t_of_sexp__ sexp__102_ :> _ t) with
          | Sexplib0.Sexp_conv_error.No_variant_match ->
            (match sexp__102_ with
             | Sexplib0.Sexp.Atom atom__103_ as _sexp__105_ ->
               (match atom__103_ with
                | "Who_can_write" ->
                  Sexplib0.Sexp_conv_error.ptag_takes_args error_source__110_ _sexp__105_
                | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
             | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__103_ :: sexp_args__106_) as
               _sexp__105_ ->
               (match atom__103_ with
                | "Who_can_write" as _tag__107_ ->
                  (match sexp_args__106_ with
                   | arg0__108_ :: [] ->
                     let res0__109_ = _of_a__101_ arg0__108_ in
                     `Who_can_write res0__109_
                   | _ ->
                     Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                       error_source__110_
                       _tag__107_
                       _sexp__105_)
                | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__104_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                 error_source__110_
                 sexp__104_
             | Sexplib0.Sexp.List [] as sexp__104_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                 error_source__110_
                 sexp__104_)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        let error_source__112_ = "perms.ml.before-ppx.Types.Upper_bound.t" in
        fun _of_a__101_ sexp__111_ ->
          try __t_of_sexp__ _of_a__101_ sexp__111_ with
          | Sexplib0.Sexp_conv_error.No_variant_match ->
            Sexplib0.Sexp_conv_error.no_matching_variant_found
              error_source__112_
              sexp__111_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__113_ -> function
        | #Read.t as v__114_ -> Read.sexp_of_t v__114_
        | `Who_can_write v__115_ ->
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Who_can_write"; _of_a__113_ v__115_ ]
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let name = "Upper_bound"
  end
end

let failwithf = Printf.failwithf

module type Sexpable_binable_comparable = sig
  type 'a t = 'a
  [@@deriving bin_io, compare, equal, globalize, hash, sexp, sexp_grammar, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

    val globalize : ('a -> 'a) -> 'a t -> 'a t

    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

    val stable_witness
      :  'a Ppx_stable_witness_runtime.Stable_witness.t
      -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Only_used_as_phantom_type1 (Name : sig
    val name : string
  end) : Sexpable_binable_comparable = struct
  type 'a t = 'a

  let sexp_of_t _ _ = failwithf "Unexpectedly called [%s.sexp_of_t]" Name.name ()
  let t_of_sexp _ _ = failwithf "Unexpectedly called [%s.t_of_sexp]" Name.name ()
  let compare _ _ _ = failwithf "Unexpectedly called [%s.compare]" Name.name ()
  let equal _ _ _ = failwithf "Unexpectedly called [%s.equal]" Name.name ()
  let hash_fold_t _ _ _ = failwithf "Unexpectedly called [%s.hash_fold_t]" Name.name ()
  let t_sexp_grammar _ = Sexplib.Sexp_grammar.coerce Base.Nothing.t_sexp_grammar
  let stable_witness _ = Stable_witness.assert_stable
  let globalize _ = failwithf "Unexpectedly called [%s.globalize]" Name.name ()

  include
    Binable.Of_binable1_without_uuid [@alert "-legacy"]
      (struct
        type 'a t = 'a [@@deriving bin_io]

        include struct
          let _ = fun (_ : 'a t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:90:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , [ Bin_prot.Shape.Vid.of_string "a" ]
                  , Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:90:20")
                      (Bin_prot.Shape.Vid.of_string "a") )
                ]
            in
            fun a ->
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
          ;;

          let _ = bin_shape_t

          let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
            fun _size_of_a -> _size_of_a
          ;;

          let _ = bin_size_t

          let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
            fun _write_a -> _write_a
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            (fun bin_writer_a ->
               { size = (fun v -> bin_size_t bin_writer_a.size v)
               ; write = (fun v -> bin_write_t bin_writer_a.write v)
               }
             : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__
            : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
            =
            fun _of__a _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Silly_type
                 "perms.ml.before-ppx.Only_used_as_phantom_type1.t")
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
            fun _of__a -> _of__a
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            (fun bin_reader_a ->
               { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
               ; vtag_read =
                   (fun buf ~pos_ref vtag ->
                     (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
               }
             : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            (fun bin_a ->
               { writer = bin_writer_t bin_a.writer
               ; reader = bin_reader_t bin_a.reader
               ; shape = bin_shape_t bin_a.shape
               }
             : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)
      (struct
        type nonrec 'a t = 'a t

        let to_binable _ =
          failwithf "Unexpectedly used %s bin_io serialization" Name.name ()
        ;;

        let of_binable _ =
          failwithf "Unexpectedly used %s bin_io deserialization" Name.name ()
        ;;
      end)
end

module Only_used_as_phantom_type0 (T : sig
    type t [@@deriving bin_io, compare, equal, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val name : string
  end) : sig
  type t = T.t
  [@@deriving bin_io, compare, equal, globalize, hash, sexp_poly, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t

    val globalize : t -> t

    include Ppx_hash_lib.Hashable.S with type t := t

    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
    val sexp_of_t : t -> Sexplib0.Sexp.t
    val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end = struct
  module M = Only_used_as_phantom_type1 (T)

  type t = T.t M.t [@@deriving bin_io, equal, compare, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:115:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], M.bin_shape_t T.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = fun v -> M.bin_size_t T.bin_size_t v
    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos v -> M.bin_write_t T.bin_write_t buf ~pos v
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun buf ~pos_ref vint -> (M.__bin_read_t__ T.bin_read_t) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref -> (M.bin_read_t T.bin_read_t) buf ~pos_ref
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

    let equal =
      (fun a__116_ b__117_ ->
         M.equal
           (fun a__118_ (b__119_ [@merlin.hide]) ->
              (T.equal a__118_ b__119_ [@merlin.hide]))
           a__116_
           b__117_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal

    let compare =
      (fun a__120_ b__121_ ->
         M.compare
           (fun a__122_ (b__123_ [@merlin.hide]) ->
              (T.compare a__122_ b__123_ [@merlin.hide]))
           a__120_
           b__121_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> M.hash_fold_t (fun hsv arg -> T.hash_fold_t hsv arg) hsv arg
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
      (fun x__125_ -> M.t_of_sexp T.t_of_sexp x__125_ : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__126_ -> M.sexp_of_t T.sexp_of_t x__126_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let __t_of_sexp__ = t_of_sexp
  let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
  let globalize _ = failwithf "Unexpectedly called [%s.globalize]" T.name ()
end

module Stable = struct
  module V1 = struct
    module Nobody = Only_used_as_phantom_type0 (Types.Nobody)
    module Me = Only_used_as_phantom_type0 (Types.Me)
    module Read = Only_used_as_phantom_type0 (Types.Read)
    module Write = Only_used_as_phantom_type0 (Types.Write)
    module Read_write = Only_used_as_phantom_type0 (Types.Read_write)
    module Immutable = Only_used_as_phantom_type0 (Types.Immutable)

    type nobody = Nobody.t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : nobody) -> ()

      let bin_shape_nobody =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:131:4")
            [ Bin_prot.Shape.Tid.of_string "nobody", [], Nobody.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "nobody")) []
      ;;

      let _ = bin_shape_nobody
      let bin_size_nobody : nobody Bin_prot.Size.sizer = Nobody.bin_size_t
      let _ = bin_size_nobody
      let bin_write_nobody : nobody Bin_prot.Write.writer = Nobody.bin_write_t
      let _ = bin_write_nobody

      let bin_writer_nobody =
        ({ size = bin_size_nobody; write = bin_write_nobody }
         : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_nobody

      let __bin_read_nobody__ : (int -> nobody) Bin_prot.Read.reader =
        Nobody.__bin_read_t__
      ;;

      let _ = __bin_read_nobody__
      let bin_read_nobody : nobody Bin_prot.Read.reader = Nobody.bin_read_t
      let _ = bin_read_nobody

      let bin_reader_nobody =
        ({ read = bin_read_nobody; vtag_read = __bin_read_nobody__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_nobody

      let bin_nobody =
        ({ writer = bin_writer_nobody
         ; reader = bin_reader_nobody
         ; shape = bin_shape_nobody
         }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_nobody

      let compare_nobody =
        (fun a__127_ b__128_ -> Nobody.compare a__127_ b__128_
         : nobody -> (nobody[@merlin.hide]) -> int)
      ;;

      let _ = compare_nobody

      let equal_nobody =
        (fun a__129_ b__130_ -> Nobody.equal a__129_ b__130_
         : nobody -> (nobody[@merlin.hide]) -> bool)
      ;;

      let _ = equal_nobody

      let hash_fold_nobody
        : Ppx_hash_lib.Std.Hash.state -> nobody -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg -> Nobody.hash_fold_t hsv arg

      and hash_nobody : nobody -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Nobody.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_nobody
      and _ = hash_nobody

      let nobody_of_sexp = (Nobody.t_of_sexp : Sexplib0.Sexp.t -> nobody)
      let _ = nobody_of_sexp
      let sexp_of_nobody = (Nobody.sexp_of_t : nobody -> Sexplib0.Sexp.t)
      let _ = sexp_of_nobody

      let stable_witness_nobody =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : nobody Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_nobody__ () =
        let _ : Nobody.t Ppx_stable_witness_runtime.Stable_witness.t =
          Nobody.stable_witness
        in
        ()
      ;;

      let _ = stable_witness_nobody
      and _ = __stable_witness_checks_for_nobody__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type me = Me.t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : me) -> ()

      let bin_shape_me =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:132:4")
            [ Bin_prot.Shape.Tid.of_string "me", [], Me.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "me")) []
      ;;

      let _ = bin_shape_me
      let bin_size_me : me Bin_prot.Size.sizer = Me.bin_size_t
      let _ = bin_size_me
      let bin_write_me : me Bin_prot.Write.writer = Me.bin_write_t
      let _ = bin_write_me

      let bin_writer_me =
        ({ size = bin_size_me; write = bin_write_me } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_me
      let __bin_read_me__ : (int -> me) Bin_prot.Read.reader = Me.__bin_read_t__
      let _ = __bin_read_me__
      let bin_read_me : me Bin_prot.Read.reader = Me.bin_read_t
      let _ = bin_read_me

      let bin_reader_me =
        ({ read = bin_read_me; vtag_read = __bin_read_me__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_me

      let bin_me =
        ({ writer = bin_writer_me; reader = bin_reader_me; shape = bin_shape_me }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_me

      let compare_me =
        (fun a__132_ b__133_ -> Me.compare a__132_ b__133_
         : me -> (me[@merlin.hide]) -> int)
      ;;

      let _ = compare_me

      let equal_me =
        (fun a__134_ b__135_ -> Me.equal a__134_ b__135_
         : me -> (me[@merlin.hide]) -> bool)
      ;;

      let _ = equal_me

      let hash_fold_me : Ppx_hash_lib.Std.Hash.state -> me -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> Me.hash_fold_t hsv arg

      and hash_me : me -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Me.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_me
      and _ = hash_me

      let me_of_sexp = (Me.t_of_sexp : Sexplib0.Sexp.t -> me)
      let _ = me_of_sexp
      let sexp_of_me = (Me.sexp_of_t : me -> Sexplib0.Sexp.t)
      let _ = sexp_of_me

      let stable_witness_me =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : me Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_me__ () =
        let _ : Me.t Ppx_stable_witness_runtime.Stable_witness.t = Me.stable_witness in
        ()
      ;;

      let _ = stable_witness_me
      and _ = __stable_witness_checks_for_me__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Upper_bound = struct
      module M = Only_used_as_phantom_type1 (Types.Upper_bound)

      type 'a t = 'a Types.Upper_bound.t M.t
      [@@deriving bin_io, compare, equal, hash, sexp]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:137:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , M.bin_shape_t
                    (Types.Upper_bound.bin_shape_t
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:137:18")
                          (Bin_prot.Shape.Vid.of_string "a"))) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> M.bin_size_t (Types.Upper_bound.bin_size_t _size_of_a) v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v ->
          M.bin_write_t (Types.Upper_bound.bin_write_t _write_a) buf ~pos v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a ->
             { size = (fun v -> bin_size_t bin_writer_a.size v)
             ; write = (fun v -> bin_write_t bin_writer_a.write v)
             }
           : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
          =
          fun _of__a buf ~pos_ref vint ->
          (M.__bin_read_t__ (Types.Upper_bound.bin_read_t _of__a)) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          (M.bin_read_t (Types.Upper_bound.bin_read_t _of__a)) buf ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a ->
             { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a ->
             { writer = bin_writer_t bin_a.writer
             ; reader = bin_reader_t bin_a.reader
             ; shape = bin_shape_t bin_a.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__137_ b__138_ ->
          M.compare
            (fun a__139_ (b__140_ [@merlin.hide]) ->
               (Types.Upper_bound.compare
                  (fun a__141_ (b__142_ [@merlin.hide]) ->
                     (_cmp__a a__141_ b__142_ [@merlin.hide]))
                  a__139_
                  b__140_ [@merlin.hide]))
            a__137_
            b__138_
        ;;

        let _ = compare

        let equal
          : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
          =
          fun _cmp__a a__143_ b__144_ ->
          M.equal
            (fun a__145_ (b__146_ [@merlin.hide]) ->
               (Types.Upper_bound.equal
                  (fun a__147_ (b__148_ [@merlin.hide]) ->
                     (_cmp__a a__147_ b__148_ [@merlin.hide]))
                  a__145_
                  b__146_ [@merlin.hide]))
            a__143_
            b__144_
        ;;

        let _ = equal

        let hash_fold_t
          :  'a.
             (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> 'a t
          -> Ppx_hash_lib.Std.Hash.state
          =
          fun _hash_fold_a hsv arg ->
          M.hash_fold_t
            (fun hsv arg ->
               Types.Upper_bound.hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg)
            hsv
            arg
        ;;

        let _ = hash_fold_t

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun _of_a__149_ x__151_ ->
          M.t_of_sexp (Types.Upper_bound.t_of_sexp _of_a__149_) x__151_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__152_ x__153_ ->
          M.sexp_of_t (Types.Upper_bound.sexp_of_t _of_a__152_) x__153_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let stable_witness _ = Stable_witness.assert_stable
      let __t_of_sexp__ = t_of_sexp

      let globalize _ =
        failwithf "Unexpectedly called [%s.globalize]" Types.Upper_bound.name ()
      ;;
    end
  end

  module Export = struct
    type read = V1.Read.t
    [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : read) -> ()

      let bin_shape_read =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:150:4")
            [ Bin_prot.Shape.Tid.of_string "read", [], V1.Read.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "read")) []
      ;;

      let _ = bin_shape_read
      let bin_size_read : read Bin_prot.Size.sizer = V1.Read.bin_size_t
      let _ = bin_size_read
      let bin_write_read : read Bin_prot.Write.writer = V1.Read.bin_write_t
      let _ = bin_write_read

      let bin_writer_read =
        ({ size = bin_size_read; write = bin_write_read } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_read
      let __bin_read_read__ : (int -> read) Bin_prot.Read.reader = V1.Read.__bin_read_t__
      let _ = __bin_read_read__
      let bin_read_read : read Bin_prot.Read.reader = V1.Read.bin_read_t
      let _ = bin_read_read

      let bin_reader_read =
        ({ read = bin_read_read; vtag_read = __bin_read_read__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_read

      let bin_read =
        ({ writer = bin_writer_read; reader = bin_reader_read; shape = bin_shape_read }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_read

      let compare_read =
        (fun a__154_ b__155_ -> V1.Read.compare a__154_ b__155_
         : read -> (read[@merlin.hide]) -> int)
      ;;

      let _ = compare_read

      let equal_read =
        (fun a__156_ b__157_ -> V1.Read.equal a__156_ b__157_
         : read -> (read[@merlin.hide]) -> bool)
      ;;

      let _ = equal_read
      let globalize_read : read -> read = (V1.Read.globalize : read -> read)
      let _ = globalize_read

      let hash_fold_read
        : Ppx_hash_lib.Std.Hash.state -> read -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg -> V1.Read.hash_fold_t hsv arg

      and hash_read : read -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = V1.Read.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_read
      and _ = hash_read

      let read_of_sexp = (V1.Read.t_of_sexp : Sexplib0.Sexp.t -> read)
      let _ = read_of_sexp
      let sexp_of_read = (V1.Read.sexp_of_t : read -> Sexplib0.Sexp.t)
      let _ = sexp_of_read

      let stable_witness_read =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : read Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_read__ () =
        let _ : V1.Read.t Ppx_stable_witness_runtime.Stable_witness.t =
          V1.Read.stable_witness
        in
        ()
      ;;

      let _ = stable_witness_read
      and _ = __stable_witness_checks_for_read__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type write = V1.Write.t
    [@@deriving compare, equal, hash, globalize, sexp, stable_witness]

    include struct
      let _ = fun (_ : write) -> ()

      let compare_write =
        (fun a__160_ b__161_ -> V1.Write.compare a__160_ b__161_
         : write -> (write[@merlin.hide]) -> int)
      ;;

      let _ = compare_write

      let equal_write =
        (fun a__162_ b__163_ -> V1.Write.equal a__162_ b__163_
         : write -> (write[@merlin.hide]) -> bool)
      ;;

      let _ = equal_write

      let hash_fold_write
        : Ppx_hash_lib.Std.Hash.state -> write -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg -> V1.Write.hash_fold_t hsv arg

      and hash_write : write -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = V1.Write.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_write
      and _ = hash_write

      let globalize_write : write -> write = (V1.Write.globalize : write -> write)
      let _ = globalize_write
      let write_of_sexp = (V1.Write.t_of_sexp : Sexplib0.Sexp.t -> write)
      let _ = write_of_sexp
      let sexp_of_write = (V1.Write.sexp_of_t : write -> Sexplib0.Sexp.t)
      let _ = sexp_of_write

      let stable_witness_write =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : write Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_write__ () =
        let _ : V1.Write.t Ppx_stable_witness_runtime.Stable_witness.t =
          V1.Write.stable_witness
        in
        ()
      ;;

      let _ = stable_witness_write
      and _ = __stable_witness_checks_for_write__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type immutable = V1.Immutable.t
    [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : immutable) -> ()

      let bin_shape_immutable =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:156:4")
            [ Bin_prot.Shape.Tid.of_string "immutable", [], V1.Immutable.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "immutable")) []
      ;;

      let _ = bin_shape_immutable
      let bin_size_immutable : immutable Bin_prot.Size.sizer = V1.Immutable.bin_size_t
      let _ = bin_size_immutable
      let bin_write_immutable : immutable Bin_prot.Write.writer = V1.Immutable.bin_write_t
      let _ = bin_write_immutable

      let bin_writer_immutable =
        ({ size = bin_size_immutable; write = bin_write_immutable }
         : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_immutable

      let __bin_read_immutable__ : (int -> immutable) Bin_prot.Read.reader =
        V1.Immutable.__bin_read_t__
      ;;

      let _ = __bin_read_immutable__
      let bin_read_immutable : immutable Bin_prot.Read.reader = V1.Immutable.bin_read_t
      let _ = bin_read_immutable

      let bin_reader_immutable =
        ({ read = bin_read_immutable; vtag_read = __bin_read_immutable__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_immutable

      let bin_immutable =
        ({ writer = bin_writer_immutable
         ; reader = bin_reader_immutable
         ; shape = bin_shape_immutable
         }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_immutable

      let compare_immutable =
        (fun a__166_ b__167_ -> V1.Immutable.compare a__166_ b__167_
         : immutable -> (immutable[@merlin.hide]) -> int)
      ;;

      let _ = compare_immutable

      let equal_immutable =
        (fun a__168_ b__169_ -> V1.Immutable.equal a__168_ b__169_
         : immutable -> (immutable[@merlin.hide]) -> bool)
      ;;

      let _ = equal_immutable

      let globalize_immutable : immutable -> immutable =
        (V1.Immutable.globalize : immutable -> immutable)
      ;;

      let _ = globalize_immutable

      let hash_fold_immutable
        : Ppx_hash_lib.Std.Hash.state -> immutable -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg -> V1.Immutable.hash_fold_t hsv arg

      and hash_immutable : immutable -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = V1.Immutable.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_immutable
      and _ = hash_immutable

      let immutable_of_sexp = (V1.Immutable.t_of_sexp : Sexplib0.Sexp.t -> immutable)
      let _ = immutable_of_sexp
      let sexp_of_immutable = (V1.Immutable.sexp_of_t : immutable -> Sexplib0.Sexp.t)
      let _ = sexp_of_immutable

      let stable_witness_immutable =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : immutable Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_immutable__ () =
        let _ : V1.Immutable.t Ppx_stable_witness_runtime.Stable_witness.t =
          V1.Immutable.stable_witness
        in
        ()
      ;;

      let _ = stable_witness_immutable
      and _ = __stable_witness_checks_for_immutable__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type read_write = V1.Read_write.t
    [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : read_write) -> ()

      let bin_shape_read_write =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:159:4")
            [ Bin_prot.Shape.Tid.of_string "read_write", [], V1.Read_write.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "read_write")) []
      ;;

      let _ = bin_shape_read_write
      let bin_size_read_write : read_write Bin_prot.Size.sizer = V1.Read_write.bin_size_t
      let _ = bin_size_read_write

      let bin_write_read_write : read_write Bin_prot.Write.writer =
        V1.Read_write.bin_write_t
      ;;

      let _ = bin_write_read_write

      let bin_writer_read_write =
        ({ size = bin_size_read_write; write = bin_write_read_write }
         : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_read_write

      let __bin_read_read_write__ : (int -> read_write) Bin_prot.Read.reader =
        V1.Read_write.__bin_read_t__
      ;;

      let _ = __bin_read_read_write__
      let bin_read_read_write : read_write Bin_prot.Read.reader = V1.Read_write.bin_read_t
      let _ = bin_read_read_write

      let bin_reader_read_write =
        ({ read = bin_read_read_write; vtag_read = __bin_read_read_write__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_read_write

      let bin_read_write =
        ({ writer = bin_writer_read_write
         ; reader = bin_reader_read_write
         ; shape = bin_shape_read_write
         }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_read_write

      let compare_read_write =
        (fun a__172_ b__173_ -> V1.Read_write.compare a__172_ b__173_
         : read_write -> (read_write[@merlin.hide]) -> int)
      ;;

      let _ = compare_read_write

      let equal_read_write =
        (fun a__174_ b__175_ -> V1.Read_write.equal a__174_ b__175_
         : read_write -> (read_write[@merlin.hide]) -> bool)
      ;;

      let _ = equal_read_write

      let globalize_read_write : read_write -> read_write =
        (V1.Read_write.globalize : read_write -> read_write)
      ;;

      let _ = globalize_read_write

      let hash_fold_read_write
        : Ppx_hash_lib.Std.Hash.state -> read_write -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg -> V1.Read_write.hash_fold_t hsv arg

      and hash_read_write : read_write -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = V1.Read_write.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_read_write
      and _ = hash_read_write

      let read_write_of_sexp = (V1.Read_write.t_of_sexp : Sexplib0.Sexp.t -> read_write)
      let _ = read_write_of_sexp
      let sexp_of_read_write = (V1.Read_write.sexp_of_t : read_write -> Sexplib0.Sexp.t)
      let _ = sexp_of_read_write

      let stable_witness_read_write =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : read_write Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_read_write__ () =
        let _ : V1.Read_write.t Ppx_stable_witness_runtime.Stable_witness.t =
          V1.Read_write.stable_witness
        in
        ()
      ;;

      let _ = stable_witness_read_write
      and _ = __stable_witness_checks_for_read_write__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a perms = 'a V1.Upper_bound.t
    [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : 'a perms) -> ()

      let bin_shape_perms =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:162:4")
            [ ( Bin_prot.Shape.Tid.of_string "perms"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , V1.Upper_bound.bin_shape_t
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "perms.ml.before-ppx:162:20")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "perms")) [ a ]
      ;;

      let _ = bin_shape_perms

      let bin_size_perms : 'a. 'a Bin_prot.Size.sizer -> 'a perms Bin_prot.Size.sizer =
        fun _size_of_a v -> V1.Upper_bound.bin_size_t _size_of_a v
      ;;

      let _ = bin_size_perms

      let bin_write_perms : 'a. 'a Bin_prot.Write.writer -> 'a perms Bin_prot.Write.writer
        =
        fun _write_a buf ~pos v -> V1.Upper_bound.bin_write_t _write_a buf ~pos v
      ;;

      let _ = bin_write_perms

      let bin_writer_perms =
        (fun bin_writer_a ->
           { size = (fun v -> bin_size_perms bin_writer_a.size v)
           ; write = (fun v -> bin_write_perms bin_writer_a.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_perms

      let __bin_read_perms__
        : 'a. 'a Bin_prot.Read.reader -> (int -> 'a perms) Bin_prot.Read.reader
        =
        fun _of__a buf ~pos_ref vint ->
        (V1.Upper_bound.__bin_read_t__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_perms__

      let bin_read_perms : 'a. 'a Bin_prot.Read.reader -> 'a perms Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (V1.Upper_bound.bin_read_t _of__a) buf ~pos_ref
      ;;

      let _ = bin_read_perms

      let bin_reader_perms =
        (fun bin_reader_a ->
           { read = (fun buf ~pos_ref -> (bin_read_perms bin_reader_a.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_perms__ bin_reader_a.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_perms

      let bin_perms =
        (fun bin_a ->
           { writer = bin_writer_perms bin_a.writer
           ; reader = bin_reader_perms bin_a.reader
           ; shape = bin_shape_perms bin_a.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_perms

      let compare_perms
        :  'a.
           ('a -> ('a[@merlin.hide]) -> int)
        -> 'a perms
        -> ('a perms[@merlin.hide])
        -> int
        =
        fun _cmp__a a__178_ b__179_ ->
        V1.Upper_bound.compare
          (fun a__180_ (b__181_ [@merlin.hide]) ->
             (_cmp__a a__180_ b__181_ [@merlin.hide]))
          a__178_
          b__179_
      ;;

      let _ = compare_perms

      let equal_perms
        :  'a.
           ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a perms
        -> ('a perms[@merlin.hide])
        -> bool
        =
        fun _cmp__a a__182_ b__183_ ->
        V1.Upper_bound.equal
          (fun a__184_ (b__185_ [@merlin.hide]) ->
             (_cmp__a a__184_ b__185_ [@merlin.hide]))
          a__182_
          b__183_
      ;;

      let _ = equal_perms

      let globalize_perms : 'a. ('a -> 'a) -> 'a perms -> 'a perms =
        fun (type a__186_) ->
        (fun _globalize_a__187_ x__188_ ->
           V1.Upper_bound.globalize _globalize_a__187_ x__188_
         : (a__186_ -> a__186_) -> a__186_ perms -> a__186_ perms)
      ;;

      let _ = globalize_perms

      let hash_fold_perms
        :  'a.
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a perms
        -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        V1.Upper_bound.hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
      ;;

      let _ = hash_fold_perms

      let perms_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a perms =
        fun _of_a__190_ x__192_ -> V1.Upper_bound.t_of_sexp _of_a__190_ x__192_
      ;;

      let _ = perms_of_sexp

      let sexp_of_perms : 'a. ('a -> Sexplib0.Sexp.t) -> 'a perms -> Sexplib0.Sexp.t =
        fun _of_a__193_ x__194_ -> V1.Upper_bound.sexp_of_t _of_a__193_ x__194_
      ;;

      let _ = sexp_of_perms

      let stable_witness_perms
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : 'a perms Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_perms__
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a V1.Upper_bound.t Ppx_stable_witness_runtime.Stable_witness.t
          =
          V1.Upper_bound.stable_witness
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness_perms
      and _ = __stable_witness_checks_for_perms__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

include Stable.V1
module Export = Stable.Export

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
