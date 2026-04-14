let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"basic_diffs.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "basic_diffs.ml.before-ppx"
;;

open Base
open Base_quickcheck.Export
open Bin_prot.Std

module type S_with_quickcheck = sig
  type t [@@deriving quickcheck]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Diff_intf.S with type t := t
end

module Make_atomic_with_quickcheck (M : sig
    type t [@@deriving sexp, bin_io, equal, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  include Atomic.Make_diff (M)

  type t = M.t [@@deriving quickcheck]

  include struct
    let _ = fun (_ : t) -> ()
    let quickcheck_generator = M.quickcheck_generator
    let _ = quickcheck_generator
    let quickcheck_observer = M.quickcheck_observer
    let _ = quickcheck_observer
    let quickcheck_shrinker = M.quickcheck_shrinker
    let _ = quickcheck_shrinker
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Diff_of_bool = Make_atomic_with_quickcheck (struct
    type t = bool [@@deriving sexp, bin_io, equal, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (bool_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_bool : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:21:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_bool ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_bool
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_bool
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_bool__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_bool
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
        (fun a__002_ b__003_ -> equal_bool a__002_ b__003_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let quickcheck_generator = quickcheck_generator_bool
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_bool
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_bool
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Diff_of_char = Make_atomic_with_quickcheck (struct
    type t = char [@@deriving sexp, bin_io, equal, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (char_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_char : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:25:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_char ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_char
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_char
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_char__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_char
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
        (fun a__005_ b__006_ -> equal_char a__005_ b__006_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let quickcheck_generator = quickcheck_generator_char
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_char
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_char
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Diff_of_float = Make_atomic_with_quickcheck (struct
    type t = float [@@deriving sexp, bin_io, compare, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (float_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_float : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:29:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_float ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_float
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_float
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__008_ b__009_ -> compare_float a__008_ b__009_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let quickcheck_generator = quickcheck_generator_float
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_float
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_float
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let equal (_x__010_ : t) _x__011_ =
      (match
         (fun (a__012_ : t) ((b__013_ : t) [@merlin.hide]) ->
            (compare a__012_ b__013_ [@merlin.hide]))
           _x__010_
           _x__011_
       with
       | 0 -> true
       | _ -> false)
      [@merlin.hide]
    ;;
  end)

module Diff_of_int = Make_atomic_with_quickcheck (struct
    type t = int [@@deriving sexp, bin_io, equal, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:40:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_int
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_int
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_int
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
        (fun a__015_ b__016_ -> equal_int a__015_ b__016_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let quickcheck_generator = quickcheck_generator_int
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_int
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_int
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Diff_of_string = Make_atomic_with_quickcheck (struct
    type t = string [@@deriving sexp, bin_io, equal, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (string_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_string : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:44:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_string
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_string
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_string__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_string
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
        (fun a__018_ b__019_ -> equal_string a__018_ b__019_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let quickcheck_generator = quickcheck_generator_string
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_string
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_string
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Diff_of_unit = Make_atomic_with_quickcheck (struct
    type t = unit [@@deriving sexp, bin_io, equal, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (unit_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:48:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_unit ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_unit
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_unit
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_unit__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_unit
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
        (fun a__021_ b__022_ -> equal_unit a__021_ b__022_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let quickcheck_generator = quickcheck_generator_unit
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_unit
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_unit
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Diff_of_option = struct
  type 'a derived_on = 'a option [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : 'a derived_on) -> ()

    let derived_on_of_sexp
      : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a derived_on
      =
      fun _of_a__023_ x__025_ -> option_of_sexp _of_a__023_ x__025_
    ;;

    let _ = derived_on_of_sexp

    let sexp_of_derived_on
      : 'a. ('a -> Sexplib0.Sexp.t) -> 'a derived_on -> Sexplib0.Sexp.t
      =
      fun _of_a__026_ x__027_ -> sexp_of_option _of_a__026_ x__027_
    ;;

    let _ = sexp_of_derived_on

    let bin_shape_derived_on =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:52:2")
          [ ( Bin_prot.Shape.Tid.of_string "derived_on"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , bin_shape_option
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:52:23")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "derived_on")) [ a ]
    ;;

    let _ = bin_shape_derived_on

    let bin_size_derived_on
      : 'a. 'a Bin_prot.Size.sizer -> 'a derived_on Bin_prot.Size.sizer
      =
      fun _size_of_a v -> bin_size_option _size_of_a v
    ;;

    let _ = bin_size_derived_on

    let bin_write_derived_on
      : 'a. 'a Bin_prot.Write.writer -> 'a derived_on Bin_prot.Write.writer
      =
      fun _write_a buf ~pos v -> bin_write_option _write_a buf ~pos v
    ;;

    let _ = bin_write_derived_on

    let bin_writer_derived_on =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_derived_on bin_writer_a.size v)
         ; write = (fun v -> bin_write_derived_on bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_derived_on

    let __bin_read_derived_on__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a derived_on) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (__bin_read_option__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_derived_on__

    let bin_read_derived_on
      : 'a. 'a Bin_prot.Read.reader -> 'a derived_on Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref -> (bin_read_option _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_derived_on

    let bin_reader_derived_on =
      (fun bin_reader_a ->
         { read =
             (fun buf ~pos_ref -> (bin_read_derived_on bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_derived_on__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_derived_on

    let bin_derived_on =
      (fun bin_a ->
         { writer = bin_writer_derived_on bin_a.writer
         ; reader = bin_reader_derived_on bin_a.reader
         ; shape = bin_shape_derived_on bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_derived_on
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'a_diff) t =
    | Set_to_none
    | Set_to_some of 'a
    | Diff_some of 'a_diff
  [@@deriving sexp, bin_io, quickcheck]

  include struct
    let _ = fun (_ : ('a, 'a_diff) t) -> ()

    let t_of_sexp
      :  'a 'a_diff.
         (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'a_diff)
      -> Sexplib0.Sexp.t
      -> ('a, 'a_diff) t
      =
      fun (type a__044_) ->
      fun (type a_diff__045_) ->
      (let error_source__032_ = "basic_diffs.ml.before-ppx.Diff_of_option.t" in
       fun _of_a__028_ _of_a_diff__029_ -> function
         | Sexplib0.Sexp.Atom ("set_to_none" | "Set_to_none") -> Set_to_none
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("set_to_some" | "Set_to_some") as _tag__035_)
             :: sexp_args__036_) as _sexp__034_ ->
           (match sexp_args__036_ with
            | arg0__037_ :: [] ->
              let res0__038_ = _of_a__028_ arg0__037_ in
              Set_to_some res0__038_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__032_
                _tag__035_
                _sexp__034_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("diff_some" | "Diff_some") as _tag__040_)
             :: sexp_args__041_) as _sexp__039_ ->
           (match sexp_args__041_ with
            | arg0__042_ :: [] ->
              let res0__043_ = _of_a_diff__029_ arg0__042_ in
              Diff_some res0__043_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__032_
                _tag__040_
                _sexp__039_)
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("set_to_none" | "Set_to_none") :: _) as
           sexp__033_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__032_ sexp__033_
         | Sexplib0.Sexp.Atom ("set_to_some" | "Set_to_some") as sexp__033_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__032_ sexp__033_
         | Sexplib0.Sexp.Atom ("diff_some" | "Diff_some") as sexp__033_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__032_ sexp__033_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__031_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__032_ sexp__031_
         | Sexplib0.Sexp.List [] as sexp__031_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__032_ sexp__031_
         | sexp__031_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__032_ sexp__031_
       : (Sexplib0.Sexp.t -> a__044_)
         -> (Sexplib0.Sexp.t -> a_diff__045_)
         -> Sexplib0.Sexp.t
         -> (a__044_, a_diff__045_) t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a 'a_diff.
         ('a -> Sexplib0.Sexp.t)
      -> ('a_diff -> Sexplib0.Sexp.t)
      -> ('a, 'a_diff) t
      -> Sexplib0.Sexp.t
      =
      fun (type a__052_) ->
      fun (type a_diff__053_) ->
      (fun _of_a__046_ _of_a_diff__047_ -> function
         | Set_to_none -> Sexplib0.Sexp.Atom "Set_to_none"
         | Set_to_some arg0__048_ ->
           let res0__049_ = _of_a__046_ arg0__048_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Set_to_some"; res0__049_ ]
         | Diff_some arg0__050_ ->
           let res0__051_ = _of_a_diff__047_ arg0__050_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Diff_some"; res0__051_ ]
       : (a__052_ -> Sexplib0.Sexp.t)
         -> (a_diff__053_ -> Sexplib0.Sexp.t)
         -> (a__052_, a_diff__053_) t
         -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "basic_diffs.ml.before-ppx:54:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "a_diff" ]
            , Bin_prot.Shape.variant
                [ "Set_to_none", []
                ; ( "Set_to_some"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string
                           "basic_diffs.ml.before-ppx:56:21")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ] )
                ; ( "Diff_some"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string
                           "basic_diffs.ml.before-ppx:57:19")
                        (Bin_prot.Shape.Vid.of_string "a_diff")
                    ] )
                ] )
          ]
      in
      fun a a_diff ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; a_diff ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a 'a_diff.
         'a Bin_prot.Size.sizer
      -> 'a_diff Bin_prot.Size.sizer
      -> ('a, 'a_diff) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_a_diff -> function
      | Set_to_some v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_a v1)
      | Diff_some v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_a_diff v1)
      | Set_to_none -> 1
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a 'a_diff.
         'a Bin_prot.Write.writer
      -> 'a_diff Bin_prot.Write.writer
      -> ('a, 'a_diff) t Bin_prot.Write.writer
      =
      fun _write_a _write_a_diff buf ~pos -> function
      | Set_to_none -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | Set_to_some v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
        _write_a buf ~pos v1
      | Diff_some v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
        _write_a_diff buf ~pos v1
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a bin_writer_a_diff ->
         { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_a_diff.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_a_diff.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a 'a_diff.
         'a Bin_prot.Read.reader
      -> 'a_diff Bin_prot.Read.reader
      -> (int -> ('a, 'a_diff) t) Bin_prot.Read.reader
      =
      fun _of__a _of__a_diff _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "basic_diffs.ml.before-ppx.Diff_of_option.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 'a_diff.
         'a Bin_prot.Read.reader
      -> 'a_diff Bin_prot.Read.reader
      -> ('a, 'a_diff) t Bin_prot.Read.reader
      =
      fun _of__a _of__a_diff buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> Set_to_none
      | 1 ->
        let arg_1 = _of__a buf ~pos_ref in
        Set_to_some arg_1
      | 2 ->
        let arg_1 = _of__a_diff buf ~pos_ref in
        Diff_some arg_1
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag "basic_diffs.ml.before-ppx.Diff_of_option.t")
          !pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a bin_reader_a_diff ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a.read bin_reader_a_diff.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read bin_reader_a_diff.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a bin_a_diff ->
         { writer = bin_writer_t bin_a.writer bin_a_diff.writer
         ; reader = bin_reader_t bin_a.reader bin_a_diff.reader
         ; shape = bin_shape_t bin_a.shape bin_a_diff.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let quickcheck_generator _generator__065_ _generator__066_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__067_ ~random:_random__068_ -> Set_to_none) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__069_ ~random:_random__070_ ->
                 Set_to_some
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__065_
                      ~size:_size__069_
                      ~random:_random__070_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__071_ ~random:_random__072_ ->
                 Diff_some
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__066_
                      ~size:_size__071_
                      ~random:_random__072_)) )
        ]
    ;;

    let _ = quickcheck_generator

    let quickcheck_observer _observer__058_ _observer__059_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__060_ ~size:_size__061_ ~hash:_hash__062_ ->
           match _x__060_ with
           | Set_to_none ->
             let _hash__062_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__062_ 0 in
             _hash__062_
           | Set_to_some _x__063_ ->
             let _hash__062_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__062_ 1 in
             let _hash__062_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__058_
                 _x__063_
                 ~size:_size__061_
                 ~hash:_hash__062_
             in
             _hash__062_
           | Diff_some _x__064_ ->
             let _hash__062_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__062_ 2 in
             let _hash__062_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__059_
                 _x__064_
                 ~size:_size__061_
                 ~hash:_hash__062_
             in
             _hash__062_)
    ;;

    let _ = quickcheck_observer

    let quickcheck_shrinker _shrinker__054_ _shrinker__055_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | Set_to_none -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
        | Set_to_some _x__056_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__054_
                   _x__056_)
                ~f:(fun _x__056_ -> Set_to_some _x__056_)
            ]
        | Diff_some _x__057_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__055_
                   _x__057_)
                ~f:(fun _x__057_ -> Diff_some _x__057_)
            ])
    ;;

    let _ = quickcheck_shrinker
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let get get_a ~from ~to_ =
    if phys_equal from to_
    then Optional_diff.none
    else (
      match from, to_ with
      | None, None -> Optional_diff.none
      | Some from, Some to_ ->
        Optional_diff.map (get_a ~from ~to_) ~f:(fun d -> Diff_some d)
      | None, Some x -> Optional_diff.return (Set_to_some x)
      | Some _, None -> Optional_diff.return Set_to_none)
  ;;

  let apply_exn apply_a_exn derived_on diff =
    match derived_on, diff with
    | _, Set_to_some x -> Some x
    | _, Set_to_none -> None
    | Some derived_on, Diff_some diff -> Some (apply_a_exn derived_on diff)
    | None, Diff_some _ ->
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Could not apply diff. Variant mismatch."
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "derived_on"
                 ; Ppx_sexp_conv_lib.Conv.sexp_of_string "None"
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "diff"
                 ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Diff_some"
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  ;;

  let of_list_exn of_list_exn_a apply_a_exn diffs =
    match diffs with
    | [] -> Optional_diff.none
    | hd :: [] -> Optional_diff.return hd
    | l ->
      let trailing_diffs_rev, rest_rev =
        List.split_while
          ~f:(function
            | Diff_some _ -> true
            | Set_to_some _ | Set_to_none -> false)
          (List.rev l)
      in
      let a_diffs =
        List.rev_map trailing_diffs_rev ~f:(function
          | Diff_some a_diff -> a_diff
          | Set_to_none | Set_to_some _ -> assert false)
      in
      (match rest_rev, a_diffs with
       | [], [] | Diff_some _ :: _, _ -> assert false
       | ((Set_to_none | Set_to_some _) as t) :: _, [] -> Optional_diff.return t
       | [], a_diffs ->
         Optional_diff.Let_syntax.Let_syntax.map (of_list_exn_a a_diffs) ~f:(fun a_diff ->
           Diff_some a_diff)
       | Set_to_some a :: _, a_diffs ->
         Optional_diff.return (Set_to_some (List.fold a_diffs ~init:a ~f:apply_a_exn))
       | Set_to_none :: _, _ :: _ ->
         raise_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Could not combine diffs. Variant mismatch."
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "first_diff"
                    ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Set_to_none"
                    ]
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "second_diff"
                    ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Diff_some"
                    ]
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
