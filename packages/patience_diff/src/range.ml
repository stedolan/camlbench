let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"range.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "range.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V2 = struct
    type 'a t =
      | Same of ('a * 'a) array
      | Prev of 'a array * Move_kind.Stable.V1.t option
      | Next of 'a array * Move_kind.Stable.V1.t option
      | Replace of 'a array * 'a array * Move_id.Stable.V1.t option
      | Unified of 'a array * Move_id.Stable.V1.t option
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun (type a__046_) ->
        (let error_source__004_ = "range.ml.before-ppx.Stable.V2.t" in
         fun _of_a__001_ -> function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("same" | "Same") as _tag__007_) :: sexp_args__008_)
             as _sexp__006_ ->
             (match sexp_args__008_ with
              | arg0__014_ :: [] ->
                let res0__015_ =
                  array_of_sexp
                    (function
                      | Sexplib0.Sexp.List [ arg0__009_; arg1__010_ ] ->
                        let res0__011_ = _of_a__001_ arg0__009_
                        and res1__012_ = _of_a__001_ arg1__010_ in
                        res0__011_, res1__012_
                      | sexp__013_ ->
                        Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                          error_source__004_
                          2
                          sexp__013_)
                    arg0__014_
                in
                Same res0__015_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__007_
                  _sexp__006_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("prev" | "Prev") as _tag__017_) :: sexp_args__018_)
             as _sexp__016_ ->
             (match sexp_args__018_ with
              | [ arg0__019_; arg1__020_ ] ->
                let res0__021_ = array_of_sexp _of_a__001_ arg0__019_
                and res1__022_ =
                  option_of_sexp Move_kind.Stable.V1.t_of_sexp arg1__020_
                in
                Prev (res0__021_, res1__022_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__017_
                  _sexp__016_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("next" | "Next") as _tag__024_) :: sexp_args__025_)
             as _sexp__023_ ->
             (match sexp_args__025_ with
              | [ arg0__026_; arg1__027_ ] ->
                let res0__028_ = array_of_sexp _of_a__001_ arg0__026_
                and res1__029_ =
                  option_of_sexp Move_kind.Stable.V1.t_of_sexp arg1__027_
                in
                Next (res0__028_, res1__029_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__024_
                  _sexp__023_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("replace" | "Replace") as _tag__031_)
               :: sexp_args__032_) as _sexp__030_ ->
             (match sexp_args__032_ with
              | [ arg0__033_; arg1__034_; arg2__035_ ] ->
                let res0__036_ = array_of_sexp _of_a__001_ arg0__033_
                and res1__037_ = array_of_sexp _of_a__001_ arg1__034_
                and res2__038_ = option_of_sexp Move_id.Stable.V1.t_of_sexp arg2__035_ in
                Replace (res0__036_, res1__037_, res2__038_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__031_
                  _sexp__030_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("unified" | "Unified") as _tag__040_)
               :: sexp_args__041_) as _sexp__039_ ->
             (match sexp_args__041_ with
              | [ arg0__042_; arg1__043_ ] ->
                let res0__044_ = array_of_sexp _of_a__001_ arg0__042_
                and res1__045_ = option_of_sexp Move_id.Stable.V1.t_of_sexp arg1__043_ in
                Unified (res0__044_, res1__045_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__040_
                  _sexp__039_)
           | Sexplib0.Sexp.Atom ("same" | "Same") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.Atom ("prev" | "Prev") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.Atom ("next" | "Next") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.Atom ("replace" | "Replace") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.Atom ("unified" | "Unified") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__004_
               sexp__003_
           | Sexplib0.Sexp.List [] as sexp__003_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__004_ sexp__003_
           | sexp__003_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__004_ sexp__003_
         : (Sexplib0.Sexp.t -> a__046_) -> Sexplib0.Sexp.t -> a__046_ t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun (type a__072_) ->
        (fun _of_a__047_ -> function
           | Same arg0__052_ ->
             let res0__053_ =
               sexp_of_array
                 (fun (arg0__048_, arg1__049_) ->
                    let res0__050_ = _of_a__047_ arg0__048_
                    and res1__051_ = _of_a__047_ arg1__049_ in
                    Sexplib0.Sexp.List [ res0__050_; res1__051_ ])
                 arg0__052_
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Same"; res0__053_ ]
           | Prev (arg0__054_, arg1__055_) ->
             let res0__056_ = sexp_of_array _of_a__047_ arg0__054_
             and res1__057_ = sexp_of_option Move_kind.Stable.V1.sexp_of_t arg1__055_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Prev"; res0__056_; res1__057_ ]
           | Next (arg0__058_, arg1__059_) ->
             let res0__060_ = sexp_of_array _of_a__047_ arg0__058_
             and res1__061_ = sexp_of_option Move_kind.Stable.V1.sexp_of_t arg1__059_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Next"; res0__060_; res1__061_ ]
           | Replace (arg0__062_, arg1__063_, arg2__064_) ->
             let res0__065_ = sexp_of_array _of_a__047_ arg0__062_
             and res1__066_ = sexp_of_array _of_a__047_ arg1__063_
             and res2__067_ = sexp_of_option Move_id.Stable.V1.sexp_of_t arg2__064_ in
             Sexplib0.Sexp.List
               [ Sexplib0.Sexp.Atom "Replace"; res0__065_; res1__066_; res2__067_ ]
           | Unified (arg0__068_, arg1__069_) ->
             let res0__070_ = sexp_of_array _of_a__047_ arg0__068_
             and res1__071_ = sexp_of_option Move_id.Stable.V1.sexp_of_t arg1__069_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Unified"; res0__070_; res1__071_ ]
         : (a__072_ -> Sexplib0.Sexp.t) -> a__072_ t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "range.ml.before-ppx:5:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.variant
                  [ ( "Same"
                    , [ bin_shape_array
                          (Bin_prot.Shape.tuple
                             [ Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "range.ml.before-ppx:6:17")
                                 (Bin_prot.Shape.Vid.of_string "a")
                             ; Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "range.ml.before-ppx:6:22")
                                 (Bin_prot.Shape.Vid.of_string "a")
                             ])
                      ] )
                  ; ( "Prev"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:7:16")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_option Move_kind.Stable.V1.bin_shape_t
                      ] )
                  ; ( "Next"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:8:16")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_option Move_kind.Stable.V1.bin_shape_t
                      ] )
                  ; ( "Replace"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:9:19")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:9:30")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_option Move_id.Stable.V1.bin_shape_t
                      ] )
                  ; ( "Unified"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:10:19")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_option Move_id.Stable.V1.bin_shape_t
                      ] )
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | Same v1 ->
          let size = 1 in
          Bin_prot.Common.( + )
            size
            (bin_size_array
               (function
                 | v1, v2 ->
                   let size = 0 in
                   let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
                   Bin_prot.Common.( + ) size (_size_of_a v2))
               v1)
        | Prev (v1, v2) ->
          let size = 1 in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1) in
          Bin_prot.Common.( + ) size (bin_size_option Move_kind.Stable.V1.bin_size_t v2)
        | Next (v1, v2) ->
          let size = 1 in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1) in
          Bin_prot.Common.( + ) size (bin_size_option Move_kind.Stable.V1.bin_size_t v2)
        | Replace (v1, v2, v3) ->
          let size = 1 in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v2) in
          Bin_prot.Common.( + ) size (bin_size_option Move_id.Stable.V1.bin_size_t v3)
        | Unified (v1, v2) ->
          let size = 1 in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1) in
          Bin_prot.Common.( + ) size (bin_size_option Move_id.Stable.V1.bin_size_t v2)
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | Same v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          bin_write_array
            (fun buf ~pos -> function
               | v1, v2 ->
                 let pos = _write_a buf ~pos v1 in
                 _write_a buf ~pos v2)
            buf
            ~pos
            v1
        | Prev (v1, v2) ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          let pos = bin_write_array _write_a buf ~pos v1 in
          bin_write_option Move_kind.Stable.V1.bin_write_t buf ~pos v2
        | Next (v1, v2) ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
          let pos = bin_write_array _write_a buf ~pos v1 in
          bin_write_option Move_kind.Stable.V1.bin_write_t buf ~pos v2
        | Replace (v1, v2, v3) ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
          let pos = bin_write_array _write_a buf ~pos v1 in
          let pos = bin_write_array _write_a buf ~pos v2 in
          bin_write_option Move_id.Stable.V1.bin_write_t buf ~pos v3
        | Unified (v1, v2) ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
          let pos = bin_write_array _write_a buf ~pos v1 in
          bin_write_option Move_id.Stable.V1.bin_write_t buf ~pos v2
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
        Bin_prot.Common.raise_variant_wrong_type
          "range.ml.before-ppx.Stable.V2.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 =
            (bin_read_array (fun buf ~pos_ref ->
               let v1 = _of__a buf ~pos_ref in
               let v2 = _of__a buf ~pos_ref in
               v1, v2))
              buf
              ~pos_ref
          in
          Same arg_1
        | 1 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_2 = (bin_read_option Move_kind.Stable.V1.bin_read_t) buf ~pos_ref in
          Prev (arg_1, arg_2)
        | 2 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_2 = (bin_read_option Move_kind.Stable.V1.bin_read_t) buf ~pos_ref in
          Next (arg_1, arg_2)
        | 3 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_2 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_3 = (bin_read_option Move_id.Stable.V1.bin_read_t) buf ~pos_ref in
          Replace (arg_1, arg_2, arg_3)
        | 4 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_2 = (bin_read_option Move_id.Stable.V1.bin_read_t) buf ~pos_ref in
          Unified (arg_1, arg_2)
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "range.ml.before-ppx.Stable.V2.t")
            !pos_ref
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
  end

  module V1 = struct
    type 'a t =
      | Same of ('a * 'a) array
      | Prev of 'a array
      | Next of 'a array
      | Replace of 'a array * 'a array
      | Unified of 'a array
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun (type a__110_) ->
        (let error_source__076_ = "range.ml.before-ppx.Stable.V1.t" in
         fun _of_a__073_ -> function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("same" | "Same") as _tag__079_) :: sexp_args__080_)
             as _sexp__078_ ->
             (match sexp_args__080_ with
              | arg0__086_ :: [] ->
                let res0__087_ =
                  array_of_sexp
                    (function
                      | Sexplib0.Sexp.List [ arg0__081_; arg1__082_ ] ->
                        let res0__083_ = _of_a__073_ arg0__081_
                        and res1__084_ = _of_a__073_ arg1__082_ in
                        res0__083_, res1__084_
                      | sexp__085_ ->
                        Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                          error_source__076_
                          2
                          sexp__085_)
                    arg0__086_
                in
                Same res0__087_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__076_
                  _tag__079_
                  _sexp__078_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("prev" | "Prev") as _tag__089_) :: sexp_args__090_)
             as _sexp__088_ ->
             (match sexp_args__090_ with
              | arg0__091_ :: [] ->
                let res0__092_ = array_of_sexp _of_a__073_ arg0__091_ in
                Prev res0__092_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__076_
                  _tag__089_
                  _sexp__088_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("next" | "Next") as _tag__094_) :: sexp_args__095_)
             as _sexp__093_ ->
             (match sexp_args__095_ with
              | arg0__096_ :: [] ->
                let res0__097_ = array_of_sexp _of_a__073_ arg0__096_ in
                Next res0__097_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__076_
                  _tag__094_
                  _sexp__093_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("replace" | "Replace") as _tag__099_)
               :: sexp_args__100_) as _sexp__098_ ->
             (match sexp_args__100_ with
              | [ arg0__101_; arg1__102_ ] ->
                let res0__103_ = array_of_sexp _of_a__073_ arg0__101_
                and res1__104_ = array_of_sexp _of_a__073_ arg1__102_ in
                Replace (res0__103_, res1__104_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__076_
                  _tag__099_
                  _sexp__098_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("unified" | "Unified") as _tag__106_)
               :: sexp_args__107_) as _sexp__105_ ->
             (match sexp_args__107_ with
              | arg0__108_ :: [] ->
                let res0__109_ = array_of_sexp _of_a__073_ arg0__108_ in
                Unified res0__109_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__076_
                  _tag__106_
                  _sexp__105_)
           | Sexplib0.Sexp.Atom ("same" | "Same") as sexp__077_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__076_ sexp__077_
           | Sexplib0.Sexp.Atom ("prev" | "Prev") as sexp__077_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__076_ sexp__077_
           | Sexplib0.Sexp.Atom ("next" | "Next") as sexp__077_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__076_ sexp__077_
           | Sexplib0.Sexp.Atom ("replace" | "Replace") as sexp__077_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__076_ sexp__077_
           | Sexplib0.Sexp.Atom ("unified" | "Unified") as sexp__077_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__076_ sexp__077_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__075_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__076_
               sexp__075_
           | Sexplib0.Sexp.List [] as sexp__075_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__076_ sexp__075_
           | sexp__075_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__076_ sexp__075_
         : (Sexplib0.Sexp.t -> a__110_) -> Sexplib0.Sexp.t -> a__110_ t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun (type a__128_) ->
        (fun _of_a__111_ -> function
           | Same arg0__116_ ->
             let res0__117_ =
               sexp_of_array
                 (fun (arg0__112_, arg1__113_) ->
                    let res0__114_ = _of_a__111_ arg0__112_
                    and res1__115_ = _of_a__111_ arg1__113_ in
                    Sexplib0.Sexp.List [ res0__114_; res1__115_ ])
                 arg0__116_
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Same"; res0__117_ ]
           | Prev arg0__118_ ->
             let res0__119_ = sexp_of_array _of_a__111_ arg0__118_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Prev"; res0__119_ ]
           | Next arg0__120_ ->
             let res0__121_ = sexp_of_array _of_a__111_ arg0__120_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Next"; res0__121_ ]
           | Replace (arg0__122_, arg1__123_) ->
             let res0__124_ = sexp_of_array _of_a__111_ arg0__122_
             and res1__125_ = sexp_of_array _of_a__111_ arg1__123_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Replace"; res0__124_; res1__125_ ]
           | Unified arg0__126_ ->
             let res0__127_ = sexp_of_array _of_a__111_ arg0__126_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Unified"; res0__127_ ]
         : (a__128_ -> Sexplib0.Sexp.t) -> a__128_ t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "range.ml.before-ppx:15:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.variant
                  [ ( "Same"
                    , [ bin_shape_array
                          (Bin_prot.Shape.tuple
                             [ Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "range.ml.before-ppx:16:17")
                                 (Bin_prot.Shape.Vid.of_string "a")
                             ; Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "range.ml.before-ppx:16:22")
                                 (Bin_prot.Shape.Vid.of_string "a")
                             ])
                      ] )
                  ; ( "Prev"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:17:16")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ] )
                  ; ( "Next"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:18:16")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ] )
                  ; ( "Replace"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:19:19")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ; bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:19:30")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ] )
                  ; ( "Unified"
                    , [ bin_shape_array
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "range.ml.before-ppx:20:19")
                             (Bin_prot.Shape.Vid.of_string "a"))
                      ] )
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | Same v1 ->
          let size = 1 in
          Bin_prot.Common.( + )
            size
            (bin_size_array
               (function
                 | v1, v2 ->
                   let size = 0 in
                   let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
                   Bin_prot.Common.( + ) size (_size_of_a v2))
               v1)
        | Prev v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1)
        | Next v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1)
        | Replace (v1, v2) ->
          let size = 1 in
          let size = Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1) in
          Bin_prot.Common.( + ) size (bin_size_array _size_of_a v2)
        | Unified v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_array _size_of_a v1)
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | Same v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          bin_write_array
            (fun buf ~pos -> function
               | v1, v2 ->
                 let pos = _write_a buf ~pos v1 in
                 _write_a buf ~pos v2)
            buf
            ~pos
            v1
        | Prev v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          bin_write_array _write_a buf ~pos v1
        | Next v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
          bin_write_array _write_a buf ~pos v1
        | Replace (v1, v2) ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
          let pos = bin_write_array _write_a buf ~pos v1 in
          bin_write_array _write_a buf ~pos v2
        | Unified v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
          bin_write_array _write_a buf ~pos v1
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
        Bin_prot.Common.raise_variant_wrong_type
          "range.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 =
            (bin_read_array (fun buf ~pos_ref ->
               let v1 = _of__a buf ~pos_ref in
               let v2 = _of__a buf ~pos_ref in
               v1, v2))
              buf
              ~pos_ref
          in
          Same arg_1
        | 1 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          Prev arg_1
        | 2 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          Next arg_1
        | 3 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          let arg_2 = (bin_read_array _of__a) buf ~pos_ref in
          Replace (arg_1, arg_2)
        | 4 ->
          let arg_1 = (bin_read_array _of__a) buf ~pos_ref in
          Unified arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "range.ml.before-ppx.Stable.V1.t")
            !pos_ref
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

    let to_v2 : 'a t -> 'a V2.t = function
      | Same lines -> Same lines
      | Prev lines -> Prev (lines, None)
      | Next lines -> Next (lines, None)
      | Replace (lines_prev, lines_next) -> Replace (lines_prev, lines_next, None)
      | Unified lines -> Unified (lines, None)
    ;;

    let of_v2_no_moves_exn : 'a V2.t -> 'a t = function
      | Prev (_, Some _) | Next (_, Some _) | Replace (_, _, Some _) | Unified (_, Some _)
        ->
        Core.raise_s
          (Ppx_sexp_conv_lib.Conv.sexp_of_string
             "cannot convert to old patdiff version with a move")
      | Same lines -> Same lines
      | Prev (lines, None) -> Prev lines
      | Next (lines, None) -> Next lines
      | Replace (lines_prev, lines_next, None) -> Replace (lines_prev, lines_next)
      | Unified (lines, None) -> Unified lines
    ;;
  end
end

open! Core
include Stable.V2

let all_same ranges =
  List.for_all ranges ~f:(fun range ->
    match range with
    | Same _ -> true
    | _ -> false)
;;

let prev_and_next range =
  match range with
  | Same _ -> [ range ], [ range ]
  | Prev (_, (None | Some (Move _))) -> [ range ], []
  | Prev (_, Some (Within_move _)) -> [], []
  | Next (_, _) -> [], [ range ]
  | Replace (l_range, r_range, None) -> [ Prev (l_range, None) ], [ Next (r_range, None) ]
  | Replace (_, r_range, Some move_id) ->
    [], [ Next (r_range, Some (Within_move move_id)) ]
  | Unified (_, Some _) -> [], [ range ]
  | Unified (_, None) -> [ range ], [ range ]
;;

let prev_only ranges = List.concat_map ranges ~f:(fun range -> fst (prev_and_next range))
let next_only ranges = List.concat_map ranges ~f:(fun range -> snd (prev_and_next range))

let prev_size = function
  | Unified (lines, None)
  | Replace (lines, _, None)
  | Prev (lines, None)
  | Prev (lines, Some (Move _)) -> Array.length lines
  | Same lines -> Array.length lines
  | Replace (_, _, Some _) | Prev (_, Some (Within_move _)) | Next _ | Unified (_, Some _)
    -> 0
;;

let next_size = function
  | Unified (lines, _) | Replace (_, lines, _) | Next (lines, _) -> Array.length lines
  | Same lines -> Array.length lines
  | Prev _ -> 0
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
