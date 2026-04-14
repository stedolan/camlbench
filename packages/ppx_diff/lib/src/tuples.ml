let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"tuples.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "tuples.ml.before-ppx"
;;

open Base
open Base_quickcheck.Export
open Bin_prot.Std

module Tuple2 = struct
  type ('a1, 'a2) t = 'a1 * 'a2 [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : ('a1, 'a2) t) -> ()

    let t_of_sexp
      :  'a1 'a2.
         (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2) t
      =
      let error_source__009_ = "tuples.ml.before-ppx.Tuple2.t" in
      fun _of_a1__001_ _of_a2__002_ -> function
        | Sexplib0.Sexp.List [ arg0__004_; arg1__005_ ] ->
          let res0__006_ = _of_a1__001_ arg0__004_
          and res1__007_ = _of_a2__002_ arg1__005_ in
          res0__006_, res1__007_
        | sexp__008_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__009_
            2
            sexp__008_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a1 'a2.
         ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a1__010_ _of_a2__011_ (arg0__012_, arg1__013_) ->
      let res0__014_ = _of_a1__010_ arg0__012_
      and res1__015_ = _of_a2__011_ arg1__013_ in
      Sexplib0.Sexp.List [ res0__014_; res1__015_ ]
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:12:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a1"; Bin_prot.Shape.Vid.of_string "a2" ]
            , Bin_prot.Shape.tuple
                [ Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:12:22")
                    (Bin_prot.Shape.Vid.of_string "a1")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:12:28")
                    (Bin_prot.Shape.Vid.of_string "a2")
                ] )
          ]
      in
      fun a1 a2 ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a1; a2 ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a1 'a2.
         'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> ('a1, 'a2) t Bin_prot.Size.sizer
      =
      fun _size_of_a1 _size_of_a2 -> function
      | v1, v2 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a1 v1) in
        Bin_prot.Common.( + ) size (_size_of_a2 v2)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a1 'a2.
         'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> ('a1, 'a2) t Bin_prot.Write.writer
      =
      fun _write_a1 _write_a2 buf ~pos -> function
      | v1, v2 ->
        let pos = _write_a1 buf ~pos v1 in
        _write_a2 buf ~pos v2
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a1 bin_writer_a2 ->
         { size = (fun v -> bin_size_t bin_writer_a1.size bin_writer_a2.size v)
         ; write = (fun v -> bin_write_t bin_writer_a1.write bin_writer_a2.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a1 'a2.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2) t) Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuples.ml.before-ppx.Tuple2.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a1 'a2.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> ('a1, 'a2) t Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 buf ~pos_ref ->
      let v1 = _of__a1 buf ~pos_ref in
      let v2 = _of__a2 buf ~pos_ref in
      v1, v2
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a1 bin_reader_a2 ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a1.read bin_reader_a2.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a1.read bin_reader_a2.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a1 bin_a2 ->
         { writer = bin_writer_t bin_a1.writer bin_a2.writer
         ; reader = bin_reader_t bin_a1.reader bin_a2.reader
         ; shape = bin_shape_t bin_a1.shape bin_a2.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = struct
    type ('a1, 'a2) derived_on = ('a1, 'a2) t

    module Entry_diff = struct
      type ('a1, 'a2, 'a1_diff, 'a2_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : ('a1, 'a2, 'a1_diff, 'a2_diff) t) -> ()
        let t1 v0 = T1 v0
        let _ = t1
        let t2 v0 = T2 v0
        let _ = t2

        let is_t1 = function
          | T1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t1

        let is_t2 = function
          | T2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t2

        let t1_val = function
          | T1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t1_val

        let t2_val = function
          | T2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t2_val

        module Variants = struct
          let t1 = { Variantslib.Variant.name = "T1"; rank = 0; constructor = t1 }
          let _ = t1
          let t2 = { Variantslib.Variant.name = "T2"; rank = 1; constructor = t2 }
          let _ = t2

          let fold ~init:init__ ~t1:t1_fun__ ~t2:t2_fun__ =
            t2_fun__ (t1_fun__ init__ t1) t2
          ;;

          let _ = fold

          let iter ~t1:t1_fun__ ~t2:t2_fun__ =
            (t1_fun__ t1 : unit);
            (t2_fun__ t2 : unit)
          ;;

          let _ = iter

          let map t__ ~t1:t1_fun__ ~t2:t2_fun__ =
            match t__ with
            | T1 v0 -> t1_fun__ t1 v0
            | T2 v0 -> t2_fun__ t2 v0
          ;;

          let _ = map

          let make_matcher ~t1:t1_fun__ ~t2:t2_fun__ compile_acc__ =
            let t1_gen__, compile_acc__ = t1_fun__ t1 compile_acc__ in
            let t2_gen__, compile_acc__ = t2_fun__ t2 compile_acc__ in
            map ~t1:(fun _ -> t1_gen__) ~t2:(fun _ -> t2_gen__), compile_acc__
          ;;

          let _ = make_matcher

          let to_rank = function
            | T1 _ -> 0
            | T2 _ -> 1
          ;;

          let _ = to_rank

          let to_name = function
            | T1 _ -> "T1"
            | T2 _ -> "T2"
          ;;

          let _ = to_name
          let descriptions = [ "T1", 1; "T2", 1 ]
          let _ = descriptions
        end

        let t_of_sexp
          :  'a1 'a2 'a1_diff 'a2_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          =
          fun (type a1__034_) ->
          fun (type a2__035_) ->
          fun (type a1_diff__036_) ->
          fun (type a2_diff__037_) ->
          (let error_source__022_ = "tuples.ml.before-ppx.Tuple2.Diff.Entry_diff.t" in
           fun _of_a1__016_ _of_a2__017_ _of_a1_diff__018_ _of_a2_diff__019_ -> function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t1" | "T1") as _tag__025_) :: sexp_args__026_) as
               _sexp__024_ ->
               (match sexp_args__026_ with
                | arg0__027_ :: [] ->
                  let res0__028_ = _of_a1_diff__018_ arg0__027_ in
                  T1 res0__028_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__025_
                    _sexp__024_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t2" | "T2") as _tag__030_) :: sexp_args__031_) as
               _sexp__029_ ->
               (match sexp_args__031_ with
                | arg0__032_ :: [] ->
                  let res0__033_ = _of_a2_diff__019_ arg0__032_ in
                  T2 res0__033_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__030_
                    _sexp__029_)
             | Sexplib0.Sexp.Atom ("t1" | "T1") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("t2" | "T2") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__021_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__022_
                 sexp__021_
             | Sexplib0.Sexp.List [] as sexp__021_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__022_
                 sexp__021_
             | sexp__021_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__022_ sexp__021_
           : (Sexplib0.Sexp.t -> a1__034_)
             -> (Sexplib0.Sexp.t -> a2__035_)
             -> (Sexplib0.Sexp.t -> a1_diff__036_)
             -> (Sexplib0.Sexp.t -> a2_diff__037_)
             -> Sexplib0.Sexp.t
             -> (a1__034_, a2__035_, a1_diff__036_, a2_diff__037_) t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          -> Sexplib0.Sexp.t
          =
          fun (type a1__046_) ->
          fun (type a2__047_) ->
          fun (type a1_diff__048_) ->
          fun (type a2_diff__049_) ->
          (fun _of_a1__038_ _of_a2__039_ _of_a1_diff__040_ _of_a2_diff__041_ -> function
             | T1 arg0__042_ ->
               let res0__043_ = _of_a1_diff__040_ arg0__042_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T1"; res0__043_ ]
             | T2 arg0__044_ ->
               let res0__045_ = _of_a2_diff__041_ arg0__044_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T2"; res0__045_ ]
           : (a1__046_ -> Sexplib0.Sexp.t)
             -> (a2__047_ -> Sexplib0.Sexp.t)
             -> (a1_diff__048_ -> Sexplib0.Sexp.t)
             -> (a2_diff__049_ -> Sexplib0.Sexp.t)
             -> (a1__046_, a2__047_, a1_diff__048_, a2_diff__049_) t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:18:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "T1"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:19:16")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")
                        ] )
                    ; ( "T2"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:20:16")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")
                        ] )
                    ] )
              ]
          in
          fun a1 a2 a1_diff a2_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a1_diff; a2_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer
          =
          fun _size_of_a1 _size_of_a2 _size_of_a1_diff _size_of_a2_diff -> function
          | T1 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a1_diff v1)
          | T2 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a2_diff v1)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer
          =
          fun _write_a1 _write_a2 _write_a1_diff _write_a2_diff buf ~pos -> function
          | T1 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a1_diff buf ~pos v1
          | T2 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            _write_a2_diff buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1 bin_writer_a2 bin_writer_a1_diff bin_writer_a2_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader
          =
          fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "tuples.ml.before-ppx.Tuple2.Diff.Entry_diff.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader
          =
          fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a1_diff buf ~pos_ref in
            T1 arg_1
          | 1 ->
            let arg_1 = _of__a2_diff buf ~pos_ref in
            T2 arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "tuples.ml.before-ppx.Tuple2.Diff.Entry_diff.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1 bin_reader_a2 bin_reader_a1_diff bin_reader_a2_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1 bin_a2 bin_a1_diff bin_a2_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
             ; shape =
                 bin_shape_t bin_a1.shape bin_a2.shape bin_a1_diff.shape bin_a2_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__065_
              _generator__066_
              _generator__067_
              _generator__068_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__069_ ~random:_random__070_ ->
                     T1
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__067_
                          ~size:_size__069_
                          ~random:_random__070_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__071_ ~random:_random__072_ ->
                     T2
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__068_
                          ~size:_size__071_
                          ~random:_random__072_)) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__056_
              _observer__057_
              _observer__058_
              _observer__059_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__060_ ~size:_size__061_ ~hash:_hash__062_ ->
               match _x__060_ with
               | T1 _x__063_ ->
                 let _hash__062_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__062_ 0
                 in
                 let _hash__062_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__058_
                     _x__063_
                     ~size:_size__061_
                     ~hash:_hash__062_
                 in
                 _hash__062_
               | T2 _x__064_ ->
                 let _hash__062_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__062_ 1
                 in
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

        let quickcheck_shrinker
              _shrinker__050_
              _shrinker__051_
              _shrinker__052_
              _shrinker__053_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | T1 _x__054_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__052_
                       _x__054_)
                    ~f:(fun _x__054_ -> T1 _x__054_)
                ]
            | T2 _x__055_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__053_
                       _x__055_)
                    ~f:(fun _x__055_ -> T2 _x__055_)
                ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Entry_diff

    type ('a1, 'a2, 'a1_diff, 'a2_diff) t =
      ('a1, 'a2, 'a1_diff, 'a2_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a1_diff, 'a2_diff) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a1_diff 'a2_diff.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        =
        fun _of_a1__073_ _of_a2__074_ _of_a1_diff__075_ _of_a2_diff__076_ x__078_ ->
        list_of_sexp
          (Entry_diff.t_of_sexp
             _of_a1__073_
             _of_a2__074_
             _of_a1_diff__075_
             _of_a2_diff__076_)
          x__078_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a1_diff 'a2_diff.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__079_ _of_a2__080_ _of_a1_diff__081_ _of_a2_diff__082_ x__083_ ->
        sexp_of_list
          (Entry_diff.sexp_of_t
             _of_a1__079_
             _of_a2__080_
             _of_a1_diff__081_
             _of_a2_diff__082_)
          x__083_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:26:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a1_diff"
                ; Bin_prot.Shape.Vid.of_string "a2_diff"
                ]
              , bin_shape_list
                  ((((Entry_diff.bin_shape_t
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:27:7")
                           (Bin_prot.Shape.Vid.of_string "a1")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:27:12")
                          (Bin_prot.Shape.Vid.of_string "a2")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:27:17")
                         (Bin_prot.Shape.Vid.of_string "a1_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:27:27")
                        (Bin_prot.Shape.Vid.of_string "a2_diff"))) )
            ]
        in
        fun a1 a2 a1_diff a2_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a1_diff; a2_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a1_diff 'a2_diff.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 _size_of_a1_diff _size_of_a2_diff v ->
        bin_size_list
          (Entry_diff.bin_size_t
             _size_of_a1
             _size_of_a2
             _size_of_a1_diff
             _size_of_a2_diff)
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a1_diff 'a2_diff.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 _write_a1_diff _write_a2_diff buf ~pos v ->
        bin_write_list
          (Entry_diff.bin_write_t _write_a1 _write_a2 _write_a1_diff _write_a2_diff)
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1 bin_writer_a2 bin_writer_a1_diff bin_writer_a2_diff ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a1_diff.size
                   bin_writer_a2_diff.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a1_diff.write
                   bin_writer_a2_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a1_diff 'a2_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff buf ~pos_ref vint ->
        (__bin_read_list__
           (Entry_diff.bin_read_t _of__a1 _of__a2 _of__a1_diff _of__a2_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a1_diff 'a2_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff buf ~pos_ref ->
        (bin_read_list (Entry_diff.bin_read_t _of__a1 _of__a2 _of__a1_diff _of__a2_diff))
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1 bin_reader_a2 bin_reader_a1_diff bin_reader_a2_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a1_diff bin_a2_diff ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a1_diff.writer
                 bin_a2_diff.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a1_diff.reader
                 bin_a2_diff.reader
           ; shape =
               bin_shape_t bin_a1.shape bin_a2.shape bin_a1_diff.shape bin_a2_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let quickcheck_generator
            _generator__092_
            _generator__093_
            _generator__094_
            _generator__095_
        =
        quickcheck_generator_list
          (Entry_diff.quickcheck_generator
             _generator__092_
             _generator__093_
             _generator__094_
             _generator__095_)
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer
            _observer__088_
            _observer__089_
            _observer__090_
            _observer__091_
        =
        quickcheck_observer_list
          (Entry_diff.quickcheck_observer
             _observer__088_
             _observer__089_
             _observer__090_
             _observer__091_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker
            _shrinker__084_
            _shrinker__085_
            _shrinker__086_
            _shrinker__087_
        =
        quickcheck_shrinker_list
          (Entry_diff.quickcheck_shrinker
             _shrinker__084_
             _shrinker__085_
             _shrinker__086_
             _shrinker__087_)
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare_rank t1 t2 =
      Int.compare (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let equal_rank t1 t2 =
      Int.equal (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let get get1 get2 ~from ~to_ =
      if Base.phys_equal from to_
      then Optional_diff.none
      else (
        let from_1, from_2 = from in
        let to_1, to_2 = to_ in
        let diff = [] in
        let diff =
          let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T2 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T2 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T1 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T1 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        match diff with
        | [] -> Optional_diff.none
        | _ :: _ -> Optional_diff.return diff)
    ;;

    let apply_exn apply1_exn apply2_exn derived_on diff =
      let derived_on1, derived_on2 = derived_on in
      let t1, diff =
        match diff with
        | T1 d :: tl -> apply1_exn derived_on1 d, tl
        | _ -> derived_on1, diff
      in
      let t2, diff =
        match diff with
        | T2 d :: tl -> apply2_exn derived_on2 d, tl
        | _ -> derived_on2, diff
      in
      match diff with
      | [] -> t1, t2
      | _ :: _ -> failwith "BUG: non-empty diff after apply"
    ;;

    let of_list_exn of_list1_exn _apply1_exn of_list2_exn _apply2_exn ts =
      match ts with
      | [] -> Optional_diff.none
      | _ :: _ ->
        (match List.stable_sort ~compare:compare_rank (List.concat ts) with
         | [] -> Optional_diff.return []
         | _ :: _ as diff ->
           let rec loop acc = function
             | [] -> List.rev acc
             | T1 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T1 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T1 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list1_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T1 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T1 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T2 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T2 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T2 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list2_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T2 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T2 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
           in
           Optional_diff.return (loop [] diff))
    ;;

    let singleton entry_diff = [ entry_diff ]

    let t_of_sexp a1_of_sexp a2_of_sexp a1_diff_of_sexp a2_diff_of_sexp sexp =
      let l =
        List.sort
          ~compare:compare_rank
          (t_of_sexp a1_of_sexp a2_of_sexp a1_diff_of_sexp a2_diff_of_sexp sexp)
      in
      match List.find_consecutive_duplicate l ~equal:equal_rank with
      | None -> l
      | Some (dup, _) ->
        failwith ("Duplicate entry in tuple diff: " ^ Entry_diff.Variants.to_name dup)
    ;;

    let create ?t1 ?t2 () =
      let diff = [] in
      let diff =
        match t2 with
        | None -> diff
        | Some d -> T2 d :: diff
      in
      let diff =
        match t1 with
        | None -> diff
        | Some d -> T1 d :: diff
      in
      diff
    ;;

    let create_of_variants ~t1 ~t2 =
      let diff = [] in
      let diff =
        let __ppx_optional_e_0 = t2 Entry_diff.Variants.t2 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T2 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T2 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t1 Entry_diff.Variants.t1 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T1 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T1 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      diff
    ;;
  end

  module For_inlined_tuple = struct
    type ('a1, 'a2) t = 'a1 Gel.t * 'a2 Gel.t [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : ('a1, 'a2) t) -> ()

      let t_of_sexp
        :  'a1 'a2.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2) t
        =
        let error_source__104_ = "tuples.ml.before-ppx.Tuple2.For_inlined_tuple.t" in
        fun _of_a1__096_ _of_a2__097_ -> function
          | Sexplib0.Sexp.List [ arg0__099_; arg1__100_ ] ->
            let res0__101_ = Gel.t_of_sexp _of_a1__096_ arg0__099_
            and res1__102_ = Gel.t_of_sexp _of_a2__097_ arg1__100_ in
            res0__101_, res1__102_
          | sexp__103_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__104_
              2
              sexp__103_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__105_ _of_a2__106_ (arg0__107_, arg1__108_) ->
        let res0__109_ = Gel.sexp_of_t _of_a1__105_ arg0__107_
        and res1__110_ = Gel.sexp_of_t _of_a2__106_ arg1__108_ in
        Sexplib0.Sexp.List [ res0__109_; res1__110_ ]
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:163:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"; Bin_prot.Shape.Vid.of_string "a2" ]
              , Bin_prot.Shape.tuple
                  [ Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:163:24")
                         (Bin_prot.Shape.Vid.of_string "a1"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:163:36")
                         (Bin_prot.Shape.Vid.of_string "a2"))
                  ] )
            ]
        in
        fun a1 a2 ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a1; a2 ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> ('a1, 'a2) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 -> function
        | v1, v2 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a1 v1) in
          Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a2 v2)
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> ('a1, 'a2) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 buf ~pos -> function
        | v1, v2 ->
          let pos = Gel.bin_write_t _write_a1 buf ~pos v1 in
          Gel.bin_write_t _write_a2 buf ~pos v2
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1 bin_writer_a2 ->
           { size = (fun v -> bin_size_t bin_writer_a1.size bin_writer_a2.size v)
           ; write = (fun v -> bin_write_t bin_writer_a1.write bin_writer_a2.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "tuples.ml.before-ppx.Tuple2.For_inlined_tuple.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> ('a1, 'a2) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 buf ~pos_ref ->
        let v1 = (Gel.bin_read_t _of__a1) buf ~pos_ref in
        let v2 = (Gel.bin_read_t _of__a2) buf ~pos_ref in
        v1, v2
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1 bin_reader_a2 ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_a1.read bin_reader_a2.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a1.read bin_reader_a2.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 ->
           { writer = bin_writer_t bin_a1.writer bin_a2.writer
           ; reader = bin_reader_t bin_a1.reader bin_a2.reader
           ; shape = bin_shape_t bin_a1.shape bin_a2.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff = struct
      type ('a1, 'a2) derived_on = ('a1, 'a2) t

      type ('a1, 'a2, 'a1_diff, 'a2_diff) t = ('a1, 'a2, 'a1_diff, 'a2_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include struct
        let _ = fun (_ : ('a1, 'a2, 'a1_diff, 'a2_diff) t) -> ()

        let t_of_sexp
          :  'a1 'a2 'a1_diff 'a2_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          =
          fun _of_a1__111_ _of_a2__112_ _of_a1_diff__113_ _of_a2_diff__114_ x__116_ ->
          Diff.t_of_sexp
            _of_a1__111_
            _of_a2__112_
            _of_a1_diff__113_
            _of_a2_diff__114_
            x__116_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          -> Sexplib0.Sexp.t
          =
          fun _of_a1__117_ _of_a2__118_ _of_a1_diff__119_ _of_a2_diff__120_ x__121_ ->
          Diff.sexp_of_t
            _of_a1__117_
            _of_a2__118_
            _of_a1_diff__119_
            _of_a2_diff__120_
            x__121_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:168:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ]
                , (((Diff.bin_shape_t
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:168:47")
                          (Bin_prot.Shape.Vid.of_string "a1")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:168:52")
                         (Bin_prot.Shape.Vid.of_string "a2")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:168:57")
                        (Bin_prot.Shape.Vid.of_string "a1_diff")))
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:168:67")
                       (Bin_prot.Shape.Vid.of_string "a2_diff")) )
              ]
          in
          fun a1 a2 a1_diff a2_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a1_diff; a2_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer
          =
          fun _size_of_a1 _size_of_a2 _size_of_a1_diff _size_of_a2_diff v ->
          Diff.bin_size_t _size_of_a1 _size_of_a2 _size_of_a1_diff _size_of_a2_diff v
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer
          =
          fun _write_a1 _write_a2 _write_a1_diff _write_a2_diff buf ~pos v ->
          Diff.bin_write_t _write_a1 _write_a2 _write_a1_diff _write_a2_diff buf ~pos v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1 bin_writer_a2 bin_writer_a1_diff bin_writer_a2_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader
          =
          fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff buf ~pos_ref vint ->
          (Diff.__bin_read_t__ _of__a1 _of__a2 _of__a1_diff _of__a2_diff)
            buf
            ~pos_ref
            vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a1_diff 'a2_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader
          =
          fun _of__a1 _of__a2 _of__a1_diff _of__a2_diff buf ~pos_ref ->
          (Diff.bin_read_t _of__a1 _of__a2 _of__a1_diff _of__a2_diff) buf ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1 bin_reader_a2 bin_reader_a1_diff bin_reader_a2_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1 bin_a2 bin_a1_diff bin_a2_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
             ; shape =
                 bin_shape_t bin_a1.shape bin_a2.shape bin_a1_diff.shape bin_a2_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__130_
              _generator__131_
              _generator__132_
              _generator__133_
          =
          Diff.quickcheck_generator
            _generator__130_
            _generator__131_
            _generator__132_
            _generator__133_
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__126_
              _observer__127_
              _observer__128_
              _observer__129_
          =
          Diff.quickcheck_observer
            _observer__126_
            _observer__127_
            _observer__128_
            _observer__129_
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__122_
              _shrinker__123_
              _shrinker__124_
              _shrinker__125_
          =
          Diff.quickcheck_shrinker
            _shrinker__122_
            _shrinker__123_
            _shrinker__124_
            _shrinker__125_
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open Diff
      open Entry_diff

      let get get1 get2 ~from ~to_ =
        if Base.phys_equal from to_
        then Optional_diff.none
        else (
          let { Gel.g = from_1 }, { Gel.g = from_2 } = from in
          let { Gel.g = to_1 }, { Gel.g = to_2 } = to_ in
          let diff = [] in
          let diff =
            let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T2 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T2 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T1 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T1 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          match diff with
          | [] -> Optional_diff.none
          | _ :: _ -> Optional_diff.return diff)
      ;;

      let apply_exn apply1_exn apply2_exn derived_on diff =
        let { Gel.g = derived_on1 }, { Gel.g = derived_on2 } = derived_on in
        let t1, diff =
          match diff with
          | T1 d :: tl -> apply1_exn derived_on1 d, tl
          | _ -> derived_on1, diff
        in
        let t2, diff =
          match diff with
          | T2 d :: tl -> apply2_exn derived_on2 d, tl
          | _ -> derived_on2, diff
        in
        match diff with
        | [] -> { Gel.g = t1 }, { Gel.g = t2 }
        | _ :: _ -> failwith "BUG: non-empty diff after apply"
      ;;

      let of_list_exn = of_list_exn
    end
  end
end

module Tuple3 = struct
  type ('a1, 'a2, 'a3) t = 'a1 * 'a2 * 'a3 [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : ('a1, 'a2, 'a3) t) -> ()

    let t_of_sexp
      :  'a1 'a2 'a3.
         (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3) t
      =
      let error_source__145_ = "tuples.ml.before-ppx.Tuple3.t" in
      fun _of_a1__134_ _of_a2__135_ _of_a3__136_ -> function
        | Sexplib0.Sexp.List [ arg0__138_; arg1__139_; arg2__140_ ] ->
          let res0__141_ = _of_a1__134_ arg0__138_
          and res1__142_ = _of_a2__135_ arg1__139_
          and res2__143_ = _of_a3__136_ arg2__140_ in
          res0__141_, res1__142_, res2__143_
        | sexp__144_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__145_
            3
            sexp__144_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a1 'a2 'a3.
         ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a1__146_ _of_a2__147_ _of_a3__148_ (arg0__149_, arg1__150_, arg2__151_) ->
      let res0__152_ = _of_a1__146_ arg0__149_
      and res1__153_ = _of_a2__147_ arg1__150_
      and res2__154_ = _of_a3__148_ arg2__151_ in
      Sexplib0.Sexp.List [ res0__152_; res1__153_; res2__154_ ]
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:219:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a1"
              ; Bin_prot.Shape.Vid.of_string "a2"
              ; Bin_prot.Shape.Vid.of_string "a3"
              ]
            , Bin_prot.Shape.tuple
                [ Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:219:27")
                    (Bin_prot.Shape.Vid.of_string "a1")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:219:33")
                    (Bin_prot.Shape.Vid.of_string "a2")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:219:39")
                    (Bin_prot.Shape.Vid.of_string "a3")
                ] )
          ]
      in
      fun a1 a2 a3 ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a1; a2; a3 ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a1 'a2 'a3.
         'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3) t Bin_prot.Size.sizer
      =
      fun _size_of_a1 _size_of_a2 _size_of_a3 -> function
      | v1, v2, v3 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a1 v1) in
        let size = Bin_prot.Common.( + ) size (_size_of_a2 v2) in
        Bin_prot.Common.( + ) size (_size_of_a3 v3)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a1 'a2 'a3.
         'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3) t Bin_prot.Write.writer
      =
      fun _write_a1 _write_a2 _write_a3 buf ~pos -> function
      | v1, v2, v3 ->
        let pos = _write_a1 buf ~pos v1 in
        let pos = _write_a2 buf ~pos v2 in
        _write_a3 buf ~pos v3
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 ->
         { size =
             (fun v ->
               bin_size_t bin_writer_a1.size bin_writer_a2.size bin_writer_a3.size v)
         ; write =
             (fun v ->
               bin_write_t bin_writer_a1.write bin_writer_a2.write bin_writer_a3.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a1 'a2 'a3.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3) t) Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuples.ml.before-ppx.Tuple3.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a1 'a2 'a3.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3) t Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 buf ~pos_ref ->
      let v1 = _of__a1 buf ~pos_ref in
      let v2 = _of__a2 buf ~pos_ref in
      let v3 = _of__a3 buf ~pos_ref in
      v1, v2, v3
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a1.read bin_reader_a2.read bin_reader_a3.read)
                 buf
                 ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a1.read bin_reader_a2.read bin_reader_a3.read)
                 buf
                 ~pos_ref
                 vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a1 bin_a2 bin_a3 ->
         { writer = bin_writer_t bin_a1.writer bin_a2.writer bin_a3.writer
         ; reader = bin_reader_t bin_a1.reader bin_a2.reader bin_a3.reader
         ; shape = bin_shape_t bin_a1.shape bin_a2.shape bin_a3.shape
         }
       : _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = struct
    type ('a1, 'a2, 'a3) derived_on = ('a1, 'a2, 'a3) t

    module Entry_diff = struct
      type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) -> ()
        let t1 v0 = T1 v0
        let _ = t1
        let t2 v0 = T2 v0
        let _ = t2
        let t3 v0 = T3 v0
        let _ = t3

        let is_t1 = function
          | T1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t1

        let is_t2 = function
          | T2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t2

        let is_t3 = function
          | T3 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t3

        let t1_val = function
          | T1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t1_val

        let t2_val = function
          | T2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t2_val

        let t3_val = function
          | T3 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t3_val

        module Variants = struct
          let t1 = { Variantslib.Variant.name = "T1"; rank = 0; constructor = t1 }
          let _ = t1
          let t2 = { Variantslib.Variant.name = "T2"; rank = 1; constructor = t2 }
          let _ = t2
          let t3 = { Variantslib.Variant.name = "T3"; rank = 2; constructor = t3 }
          let _ = t3

          let fold ~init:init__ ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ =
            t3_fun__ (t2_fun__ (t1_fun__ init__ t1) t2) t3
          ;;

          let _ = fold

          let iter ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ =
            (t1_fun__ t1 : unit);
            (t2_fun__ t2 : unit);
            (t3_fun__ t3 : unit)
          ;;

          let _ = iter

          let map t__ ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ =
            match t__ with
            | T1 v0 -> t1_fun__ t1 v0
            | T2 v0 -> t2_fun__ t2 v0
            | T3 v0 -> t3_fun__ t3 v0
          ;;

          let _ = map

          let make_matcher ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ compile_acc__ =
            let t1_gen__, compile_acc__ = t1_fun__ t1 compile_acc__ in
            let t2_gen__, compile_acc__ = t2_fun__ t2 compile_acc__ in
            let t3_gen__, compile_acc__ = t3_fun__ t3 compile_acc__ in
            ( map ~t1:(fun _ -> t1_gen__) ~t2:(fun _ -> t2_gen__) ~t3:(fun _ -> t3_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | T1 _ -> 0
            | T2 _ -> 1
            | T3 _ -> 2
          ;;

          let _ = to_rank

          let to_name = function
            | T1 _ -> "T1"
            | T2 _ -> "T2"
            | T3 _ -> "T3"
          ;;

          let _ = to_name
          let descriptions = [ "T1", 1; "T2", 1; "T3", 1 ]
          let _ = descriptions
        end

        let t_of_sexp
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          =
          fun (type a1__180_) ->
          fun (type a2__181_) ->
          fun (type a3__182_) ->
          fun (type a1_diff__183_) ->
          fun (type a2_diff__184_) ->
          fun (type a3_diff__185_) ->
          (let error_source__163_ = "tuples.ml.before-ppx.Tuple3.Diff.Entry_diff.t" in
           fun _of_a1__155_
             _of_a2__156_
             _of_a3__157_
             _of_a1_diff__158_
             _of_a2_diff__159_
             _of_a3_diff__160_ ->
             function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t1" | "T1") as _tag__166_) :: sexp_args__167_) as
               _sexp__165_ ->
               (match sexp_args__167_ with
                | arg0__168_ :: [] ->
                  let res0__169_ = _of_a1_diff__158_ arg0__168_ in
                  T1 res0__169_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__163_
                    _tag__166_
                    _sexp__165_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t2" | "T2") as _tag__171_) :: sexp_args__172_) as
               _sexp__170_ ->
               (match sexp_args__172_ with
                | arg0__173_ :: [] ->
                  let res0__174_ = _of_a2_diff__159_ arg0__173_ in
                  T2 res0__174_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__163_
                    _tag__171_
                    _sexp__170_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t3" | "T3") as _tag__176_) :: sexp_args__177_) as
               _sexp__175_ ->
               (match sexp_args__177_ with
                | arg0__178_ :: [] ->
                  let res0__179_ = _of_a3_diff__160_ arg0__178_ in
                  T3 res0__179_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__163_
                    _tag__176_
                    _sexp__175_)
             | Sexplib0.Sexp.Atom ("t1" | "T1") as sexp__164_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__163_ sexp__164_
             | Sexplib0.Sexp.Atom ("t2" | "T2") as sexp__164_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__163_ sexp__164_
             | Sexplib0.Sexp.Atom ("t3" | "T3") as sexp__164_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__163_ sexp__164_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__162_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__163_
                 sexp__162_
             | Sexplib0.Sexp.List [] as sexp__162_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__163_
                 sexp__162_
             | sexp__162_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__163_ sexp__162_
           : (Sexplib0.Sexp.t -> a1__180_)
             -> (Sexplib0.Sexp.t -> a2__181_)
             -> (Sexplib0.Sexp.t -> a3__182_)
             -> (Sexplib0.Sexp.t -> a1_diff__183_)
             -> (Sexplib0.Sexp.t -> a2_diff__184_)
             -> (Sexplib0.Sexp.t -> a3_diff__185_)
             -> Sexplib0.Sexp.t
             -> ( a1__180_
                  , a2__181_
                  , a3__182_
                  , a1_diff__183_
                  , a2_diff__184_
                  , a3_diff__185_ )
                  t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          -> Sexplib0.Sexp.t
          =
          fun (type a1__198_) ->
          fun (type a2__199_) ->
          fun (type a3__200_) ->
          fun (type a1_diff__201_) ->
          fun (type a2_diff__202_) ->
          fun (type a3_diff__203_) ->
          (fun _of_a1__186_
             _of_a2__187_
             _of_a3__188_
             _of_a1_diff__189_
             _of_a2_diff__190_
             _of_a3_diff__191_ ->
             function
             | T1 arg0__192_ ->
               let res0__193_ = _of_a1_diff__189_ arg0__192_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T1"; res0__193_ ]
             | T2 arg0__194_ ->
               let res0__195_ = _of_a2_diff__190_ arg0__194_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T2"; res0__195_ ]
             | T3 arg0__196_ ->
               let res0__197_ = _of_a3_diff__191_ arg0__196_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T3"; res0__197_ ]
           : (a1__198_ -> Sexplib0.Sexp.t)
             -> (a2__199_ -> Sexplib0.Sexp.t)
             -> (a3__200_ -> Sexplib0.Sexp.t)
             -> (a1_diff__201_ -> Sexplib0.Sexp.t)
             -> (a2_diff__202_ -> Sexplib0.Sexp.t)
             -> (a3_diff__203_ -> Sexplib0.Sexp.t)
             -> ( a1__198_
                  , a2__199_
                  , a3__200_
                  , a1_diff__201_
                  , a2_diff__202_
                  , a3_diff__203_ )
                  t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:225:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "T1"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:226:16")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")
                        ] )
                    ; ( "T2"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:227:16")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")
                        ] )
                    ; ( "T3"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:228:16")
                            (Bin_prot.Shape.Vid.of_string "a3_diff")
                        ] )
                    ] )
              ]
          in
          fun a1 a2 a3 a1_diff a2_diff a3_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a1_diff; a2_diff; a3_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff ->
            function
          | T1 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a1_diff v1)
          | T2 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a2_diff v1)
          | T3 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a3_diff v1)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            buf
            ~pos ->
            function
          | T1 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a1_diff buf ~pos v1
          | T2 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            _write_a2_diff buf ~pos v1
          | T3 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            _write_a3_diff buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _buf
            ~pos_ref
            _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "tuples.ml.before-ppx.Tuple3.Diff.Entry_diff.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            buf
            ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a1_diff buf ~pos_ref in
            T1 arg_1
          | 1 ->
            let arg_1 = _of__a2_diff buf ~pos_ref in
            T2 arg_1
          | 2 ->
            let arg_1 = _of__a3_diff buf ~pos_ref in
            T3 arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "tuples.ml.before-ppx.Tuple3.Diff.Entry_diff.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1 bin_a2 bin_a3 bin_a1_diff bin_a2_diff bin_a3_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__225_
              _generator__226_
              _generator__227_
              _generator__228_
              _generator__229_
              _generator__230_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__231_ ~random:_random__232_ ->
                     T1
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__228_
                          ~size:_size__231_
                          ~random:_random__232_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__233_ ~random:_random__234_ ->
                     T2
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__229_
                          ~size:_size__233_
                          ~random:_random__234_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__235_ ~random:_random__236_ ->
                     T3
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__230_
                          ~size:_size__235_
                          ~random:_random__236_)) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__213_
              _observer__214_
              _observer__215_
              _observer__216_
              _observer__217_
              _observer__218_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__219_ ~size:_size__220_ ~hash:_hash__221_ ->
               match _x__219_ with
               | T1 _x__222_ ->
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__221_ 0
                 in
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__216_
                     _x__222_
                     ~size:_size__220_
                     ~hash:_hash__221_
                 in
                 _hash__221_
               | T2 _x__223_ ->
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__221_ 1
                 in
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__217_
                     _x__223_
                     ~size:_size__220_
                     ~hash:_hash__221_
                 in
                 _hash__221_
               | T3 _x__224_ ->
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__221_ 2
                 in
                 let _hash__221_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__218_
                     _x__224_
                     ~size:_size__220_
                     ~hash:_hash__221_
                 in
                 _hash__221_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__204_
              _shrinker__205_
              _shrinker__206_
              _shrinker__207_
              _shrinker__208_
              _shrinker__209_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | T1 _x__210_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__207_
                       _x__210_)
                    ~f:(fun _x__210_ -> T1 _x__210_)
                ]
            | T2 _x__211_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__208_
                       _x__211_)
                    ~f:(fun _x__211_ -> T2 _x__211_)
                ]
            | T3 _x__212_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__209_
                       _x__212_)
                    ~f:(fun _x__212_ -> T3 _x__212_)
                ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Entry_diff

    type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
      ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        =
        fun _of_a1__237_
          _of_a2__238_
          _of_a3__239_
          _of_a1_diff__240_
          _of_a2_diff__241_
          _of_a3_diff__242_
          x__244_ ->
        list_of_sexp
          (Entry_diff.t_of_sexp
             _of_a1__237_
             _of_a2__238_
             _of_a3__239_
             _of_a1_diff__240_
             _of_a2_diff__241_
             _of_a3_diff__242_)
          x__244_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__245_
          _of_a2__246_
          _of_a3__247_
          _of_a1_diff__248_
          _of_a2_diff__249_
          _of_a3_diff__250_
          x__251_ ->
        sexp_of_list
          (Entry_diff.sexp_of_t
             _of_a1__245_
             _of_a2__246_
             _of_a3__247_
             _of_a1_diff__248_
             _of_a2_diff__249_
             _of_a3_diff__250_)
          x__251_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:234:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a1_diff"
                ; Bin_prot.Shape.Vid.of_string "a2_diff"
                ; Bin_prot.Shape.Vid.of_string "a3_diff"
                ]
              , bin_shape_list
                  ((((((Entry_diff.bin_shape_t
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:235:7")
                             (Bin_prot.Shape.Vid.of_string "a1")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:235:12")
                            (Bin_prot.Shape.Vid.of_string "a2")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:235:17")
                           (Bin_prot.Shape.Vid.of_string "a3")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:235:22")
                          (Bin_prot.Shape.Vid.of_string "a1_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:235:32")
                         (Bin_prot.Shape.Vid.of_string "a2_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:235:42")
                        (Bin_prot.Shape.Vid.of_string "a3_diff"))) )
            ]
        in
        fun a1 a2 a3 a1_diff a2_diff a3_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a1_diff; a2_diff; a3_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer
        =
        fun _size_of_a1
          _size_of_a2
          _size_of_a3
          _size_of_a1_diff
          _size_of_a2_diff
          _size_of_a3_diff
          v ->
        bin_size_list
          (Entry_diff.bin_size_t
             _size_of_a1
             _size_of_a2
             _size_of_a3
             _size_of_a1_diff
             _size_of_a2_diff
             _size_of_a3_diff)
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer
        =
        fun _write_a1
          _write_a2
          _write_a3
          _write_a1_diff
          _write_a2_diff
          _write_a3_diff
          buf
          ~pos
          v ->
        bin_write_list
          (Entry_diff.bin_write_t
             _write_a1
             _write_a2
             _write_a3
             _write_a1_diff
             _write_a2_diff
             _write_a3_diff)
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1
           bin_writer_a2
           bin_writer_a3
           bin_writer_a1_diff
           bin_writer_a2_diff
           bin_writer_a3_diff ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a1_diff.size
                   bin_writer_a2_diff.size
                   bin_writer_a3_diff.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a1_diff.write
                   bin_writer_a2_diff.write
                   bin_writer_a3_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          buf
          ~pos_ref
          vint ->
        (__bin_read_list__
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a1_diff _of__a2_diff _of__a3_diff buf ~pos_ref ->
        (bin_read_list
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff))
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1
           bin_reader_a2
           bin_reader_a3
           bin_reader_a1_diff
           bin_reader_a2_diff
           bin_reader_a3_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a3 bin_a1_diff bin_a2_diff bin_a3_diff ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a1_diff.writer
                 bin_a2_diff.writer
                 bin_a3_diff.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a1_diff.reader
                 bin_a2_diff.reader
                 bin_a3_diff.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a1_diff.shape
                 bin_a2_diff.shape
                 bin_a3_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let quickcheck_generator
            _generator__264_
            _generator__265_
            _generator__266_
            _generator__267_
            _generator__268_
            _generator__269_
        =
        quickcheck_generator_list
          (Entry_diff.quickcheck_generator
             _generator__264_
             _generator__265_
             _generator__266_
             _generator__267_
             _generator__268_
             _generator__269_)
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer
            _observer__258_
            _observer__259_
            _observer__260_
            _observer__261_
            _observer__262_
            _observer__263_
        =
        quickcheck_observer_list
          (Entry_diff.quickcheck_observer
             _observer__258_
             _observer__259_
             _observer__260_
             _observer__261_
             _observer__262_
             _observer__263_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker
            _shrinker__252_
            _shrinker__253_
            _shrinker__254_
            _shrinker__255_
            _shrinker__256_
            _shrinker__257_
        =
        quickcheck_shrinker_list
          (Entry_diff.quickcheck_shrinker
             _shrinker__252_
             _shrinker__253_
             _shrinker__254_
             _shrinker__255_
             _shrinker__256_
             _shrinker__257_)
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare_rank t1 t2 =
      Int.compare (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let equal_rank t1 t2 =
      Int.equal (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let get get1 get2 get3 ~from ~to_ =
      if Base.phys_equal from to_
      then Optional_diff.none
      else (
        let from_1, from_2, from_3 = from in
        let to_1, to_2, to_3 = to_ in
        let diff = [] in
        let diff =
          let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T3 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T3 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T2 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T2 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T1 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T1 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        match diff with
        | [] -> Optional_diff.none
        | _ :: _ -> Optional_diff.return diff)
    ;;

    let apply_exn apply1_exn apply2_exn apply3_exn derived_on diff =
      let derived_on1, derived_on2, derived_on3 = derived_on in
      let t1, diff =
        match diff with
        | T1 d :: tl -> apply1_exn derived_on1 d, tl
        | _ -> derived_on1, diff
      in
      let t2, diff =
        match diff with
        | T2 d :: tl -> apply2_exn derived_on2 d, tl
        | _ -> derived_on2, diff
      in
      let t3, diff =
        match diff with
        | T3 d :: tl -> apply3_exn derived_on3 d, tl
        | _ -> derived_on3, diff
      in
      match diff with
      | [] -> t1, t2, t3
      | _ :: _ -> failwith "BUG: non-empty diff after apply"
    ;;

    let of_list_exn
          of_list1_exn
          _apply1_exn
          of_list2_exn
          _apply2_exn
          of_list3_exn
          _apply3_exn
          ts
      =
      match ts with
      | [] -> Optional_diff.none
      | _ :: _ ->
        (match List.stable_sort ~compare:compare_rank (List.concat ts) with
         | [] -> Optional_diff.return []
         | _ :: _ as diff ->
           let rec loop acc = function
             | [] -> List.rev acc
             | T1 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T1 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T1 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list1_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T1 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T1 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T2 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T2 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T2 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list2_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T2 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T2 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T3 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T3 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T3 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list3_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T3 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T3 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
           in
           Optional_diff.return (loop [] diff))
    ;;

    let singleton entry_diff = [ entry_diff ]

    let t_of_sexp
          a1_of_sexp
          a2_of_sexp
          a3_of_sexp
          a1_diff_of_sexp
          a2_diff_of_sexp
          a3_diff_of_sexp
          sexp
      =
      let l =
        List.sort
          ~compare:compare_rank
          (t_of_sexp
             a1_of_sexp
             a2_of_sexp
             a3_of_sexp
             a1_diff_of_sexp
             a2_diff_of_sexp
             a3_diff_of_sexp
             sexp)
      in
      match List.find_consecutive_duplicate l ~equal:equal_rank with
      | None -> l
      | Some (dup, _) ->
        failwith ("Duplicate entry in tuple diff: " ^ Entry_diff.Variants.to_name dup)
    ;;

    let create ?t1 ?t2 ?t3 () =
      let diff = [] in
      let diff =
        match t3 with
        | None -> diff
        | Some d -> T3 d :: diff
      in
      let diff =
        match t2 with
        | None -> diff
        | Some d -> T2 d :: diff
      in
      let diff =
        match t1 with
        | None -> diff
        | Some d -> T1 d :: diff
      in
      diff
    ;;

    let create_of_variants ~t1 ~t2 ~t3 =
      let diff = [] in
      let diff =
        let __ppx_optional_e_0 = t3 Entry_diff.Variants.t3 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T3 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T3 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t2 Entry_diff.Variants.t2 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T2 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T2 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t1 Entry_diff.Variants.t1 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T1 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T1 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      diff
    ;;
  end

  module For_inlined_tuple = struct
    type ('a1, 'a2, 'a3) t = 'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a3) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a3.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3) t
        =
        let error_source__281_ = "tuples.ml.before-ppx.Tuple3.For_inlined_tuple.t" in
        fun _of_a1__270_ _of_a2__271_ _of_a3__272_ -> function
          | Sexplib0.Sexp.List [ arg0__274_; arg1__275_; arg2__276_ ] ->
            let res0__277_ = Gel.t_of_sexp _of_a1__270_ arg0__274_
            and res1__278_ = Gel.t_of_sexp _of_a2__271_ arg1__275_
            and res2__279_ = Gel.t_of_sexp _of_a3__272_ arg2__276_ in
            res0__277_, res1__278_, res2__279_
          | sexp__280_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__281_
              3
              sexp__280_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__282_ _of_a2__283_ _of_a3__284_ (arg0__285_, arg1__286_, arg2__287_) ->
        let res0__288_ = Gel.sexp_of_t _of_a1__282_ arg0__285_
        and res1__289_ = Gel.sexp_of_t _of_a2__283_ arg1__286_
        and res2__290_ = Gel.sexp_of_t _of_a3__284_ arg2__287_ in
        Sexplib0.Sexp.List [ res0__288_; res1__289_; res2__290_ ]
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:428:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ]
              , Bin_prot.Shape.tuple
                  [ Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:428:29")
                         (Bin_prot.Shape.Vid.of_string "a1"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:428:41")
                         (Bin_prot.Shape.Vid.of_string "a2"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:428:53")
                         (Bin_prot.Shape.Vid.of_string "a3"))
                  ] )
            ]
        in
        fun a1 a2 a3 ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3 ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 _size_of_a3 -> function
        | v1, v2, v3 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a1 v1) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a2 v2) in
          Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a3 v3)
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 _write_a3 buf ~pos -> function
        | v1, v2, v3 ->
          let pos = Gel.bin_write_t _write_a1 buf ~pos v1 in
          let pos = Gel.bin_write_t _write_a2 buf ~pos v2 in
          Gel.bin_write_t _write_a3 buf ~pos v3
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 ->
           { size =
               (fun v ->
                 bin_size_t bin_writer_a1.size bin_writer_a2.size bin_writer_a3.size v)
           ; write =
               (fun v ->
                 bin_write_t bin_writer_a1.write bin_writer_a2.write bin_writer_a3.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "tuples.ml.before-ppx.Tuple3.For_inlined_tuple.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 buf ~pos_ref ->
        let v1 = (Gel.bin_read_t _of__a1) buf ~pos_ref in
        let v2 = (Gel.bin_read_t _of__a2) buf ~pos_ref in
        let v3 = (Gel.bin_read_t _of__a3) buf ~pos_ref in
        v1, v2, v3
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_a1.read bin_reader_a2.read bin_reader_a3.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a1.read bin_reader_a2.read bin_reader_a3.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a3 ->
           { writer = bin_writer_t bin_a1.writer bin_a2.writer bin_a3.writer
           ; reader = bin_reader_t bin_a1.reader bin_a2.reader bin_a3.reader
           ; shape = bin_shape_t bin_a1.shape bin_a2.shape bin_a3.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff = struct
      type ('a1, 'a2, 'a3) derived_on = ('a1, 'a2, 'a3) t

      type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
        ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include struct
        let _ = fun (_ : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) -> ()

        let t_of_sexp
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          =
          fun _of_a1__291_
            _of_a2__292_
            _of_a3__293_
            _of_a1_diff__294_
            _of_a2_diff__295_
            _of_a3_diff__296_
            x__298_ ->
          Diff.t_of_sexp
            _of_a1__291_
            _of_a2__292_
            _of_a3__293_
            _of_a1_diff__294_
            _of_a2_diff__295_
            _of_a3_diff__296_
            x__298_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          -> Sexplib0.Sexp.t
          =
          fun _of_a1__299_
            _of_a2__300_
            _of_a3__301_
            _of_a1_diff__302_
            _of_a2_diff__303_
            _of_a3_diff__304_
            x__305_ ->
          Diff.sexp_of_t
            _of_a1__299_
            _of_a2__300_
            _of_a3__301_
            _of_a1_diff__302_
            _of_a2_diff__303_
            _of_a3_diff__304_
            x__305_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:433:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ]
                , (((((Diff.bin_shape_t
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:434:9")
                            (Bin_prot.Shape.Vid.of_string "a1")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:434:14")
                           (Bin_prot.Shape.Vid.of_string "a2")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:434:19")
                          (Bin_prot.Shape.Vid.of_string "a3")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:434:24")
                         (Bin_prot.Shape.Vid.of_string "a1_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:434:34")
                        (Bin_prot.Shape.Vid.of_string "a2_diff")))
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:434:44")
                       (Bin_prot.Shape.Vid.of_string "a3_diff")) )
              ]
          in
          fun a1 a2 a3 a1_diff a2_diff a3_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a1_diff; a2_diff; a3_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            v ->
          Diff.bin_size_t
            _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            v
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            buf
            ~pos
            v ->
          Diff.bin_write_t
            _write_a1
            _write_a2
            _write_a3
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            buf
            ~pos
            v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            buf
            ~pos_ref
            vint ->
          (Diff.__bin_read_t__
             _of__a1
             _of__a2
             _of__a3
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff)
            buf
            ~pos_ref
            vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a1_diff 'a2_diff 'a3_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            buf
            ~pos_ref ->
          (Diff.bin_read_t _of__a1 _of__a2 _of__a3 _of__a1_diff _of__a2_diff _of__a3_diff)
            buf
            ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1 bin_a2 bin_a3 bin_a1_diff bin_a2_diff bin_a3_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__318_
              _generator__319_
              _generator__320_
              _generator__321_
              _generator__322_
              _generator__323_
          =
          Diff.quickcheck_generator
            _generator__318_
            _generator__319_
            _generator__320_
            _generator__321_
            _generator__322_
            _generator__323_
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__312_
              _observer__313_
              _observer__314_
              _observer__315_
              _observer__316_
              _observer__317_
          =
          Diff.quickcheck_observer
            _observer__312_
            _observer__313_
            _observer__314_
            _observer__315_
            _observer__316_
            _observer__317_
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__306_
              _shrinker__307_
              _shrinker__308_
              _shrinker__309_
              _shrinker__310_
              _shrinker__311_
          =
          Diff.quickcheck_shrinker
            _shrinker__306_
            _shrinker__307_
            _shrinker__308_
            _shrinker__309_
            _shrinker__310_
            _shrinker__311_
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open Diff
      open Entry_diff

      let get get1 get2 get3 ~from ~to_ =
        if Base.phys_equal from to_
        then Optional_diff.none
        else (
          let { Gel.g = from_1 }, { Gel.g = from_2 }, { Gel.g = from_3 } = from in
          let { Gel.g = to_1 }, { Gel.g = to_2 }, { Gel.g = to_3 } = to_ in
          let diff = [] in
          let diff =
            let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T3 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T3 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T2 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T2 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T1 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T1 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          match diff with
          | [] -> Optional_diff.none
          | _ :: _ -> Optional_diff.return diff)
      ;;

      let apply_exn apply1_exn apply2_exn apply3_exn derived_on diff =
        let { Gel.g = derived_on1 }, { Gel.g = derived_on2 }, { Gel.g = derived_on3 } =
          derived_on
        in
        let t1, diff =
          match diff with
          | T1 d :: tl -> apply1_exn derived_on1 d, tl
          | _ -> derived_on1, diff
        in
        let t2, diff =
          match diff with
          | T2 d :: tl -> apply2_exn derived_on2 d, tl
          | _ -> derived_on2, diff
        in
        let t3, diff =
          match diff with
          | T3 d :: tl -> apply3_exn derived_on3 d, tl
          | _ -> derived_on3, diff
        in
        match diff with
        | [] -> { Gel.g = t1 }, { Gel.g = t2 }, { Gel.g = t3 }
        | _ :: _ -> failwith "BUG: non-empty diff after apply"
      ;;

      let of_list_exn = of_list_exn
    end
  end
end

module Tuple4 = struct
  type ('a1, 'a2, 'a3, 'a4) t = 'a1 * 'a2 * 'a3 * 'a4 [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : ('a1, 'a2, 'a3, 'a4) t) -> ()

    let t_of_sexp
      :  'a1 'a2 'a3 'a4.
         (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4) t
      =
      let error_source__338_ = "tuples.ml.before-ppx.Tuple4.t" in
      fun _of_a1__324_ _of_a2__325_ _of_a3__326_ _of_a4__327_ -> function
        | Sexplib0.Sexp.List [ arg0__329_; arg1__330_; arg2__331_; arg3__332_ ] ->
          let res0__333_ = _of_a1__324_ arg0__329_
          and res1__334_ = _of_a2__325_ arg1__330_
          and res2__335_ = _of_a3__326_ arg2__331_
          and res3__336_ = _of_a4__327_ arg3__332_ in
          res0__333_, res1__334_, res2__335_, res3__336_
        | sexp__337_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__338_
            4
            sexp__337_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a1 'a2 'a3 'a4.
         ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a1__339_
        _of_a2__340_
        _of_a3__341_
        _of_a4__342_
        (arg0__343_, arg1__344_, arg2__345_, arg3__346_) ->
      let res0__347_ = _of_a1__339_ arg0__343_
      and res1__348_ = _of_a2__340_ arg1__344_
      and res2__349_ = _of_a3__341_ arg2__345_
      and res3__350_ = _of_a4__342_ arg3__346_ in
      Sexplib0.Sexp.List [ res0__347_; res1__348_; res2__349_; res3__350_ ]
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:497:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a1"
              ; Bin_prot.Shape.Vid.of_string "a2"
              ; Bin_prot.Shape.Vid.of_string "a3"
              ; Bin_prot.Shape.Vid.of_string "a4"
              ]
            , Bin_prot.Shape.tuple
                [ Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:497:32")
                    (Bin_prot.Shape.Vid.of_string "a1")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:497:38")
                    (Bin_prot.Shape.Vid.of_string "a2")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:497:44")
                    (Bin_prot.Shape.Vid.of_string "a3")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:497:50")
                    (Bin_prot.Shape.Vid.of_string "a4")
                ] )
          ]
      in
      fun a1 a2 a3 a4 ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
          [ a1; a2; a3; a4 ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a1 'a2 'a3 'a4.
         'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Size.sizer
      =
      fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 -> function
      | v1, v2, v3, v4 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a1 v1) in
        let size = Bin_prot.Common.( + ) size (_size_of_a2 v2) in
        let size = Bin_prot.Common.( + ) size (_size_of_a3 v3) in
        Bin_prot.Common.( + ) size (_size_of_a4 v4)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a1 'a2 'a3 'a4.
         'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Write.writer
      =
      fun _write_a1 _write_a2 _write_a3 _write_a4 buf ~pos -> function
      | v1, v2, v3, v4 ->
        let pos = _write_a1 buf ~pos v1 in
        let pos = _write_a2 buf ~pos v2 in
        let pos = _write_a3 buf ~pos v3 in
        _write_a4 buf ~pos v4
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 bin_writer_a4 ->
         { size =
             (fun v ->
               bin_size_t
                 bin_writer_a1.size
                 bin_writer_a2.size
                 bin_writer_a3.size
                 bin_writer_a4.size
                 v)
         ; write =
             (fun v ->
               bin_write_t
                 bin_writer_a1.write
                 bin_writer_a2.write
                 bin_writer_a3.write
                 bin_writer_a4.write
                 v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a1 'a2 'a3 'a4.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4) t) Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuples.ml.before-ppx.Tuple4.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a1 'a2 'a3 'a4.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 buf ~pos_ref ->
      let v1 = _of__a1 buf ~pos_ref in
      let v2 = _of__a2 buf ~pos_ref in
      let v3 = _of__a3 buf ~pos_ref in
      let v4 = _of__a4 buf ~pos_ref in
      v1, v2, v3, v4
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 bin_reader_a4 ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read)
                 buf
                 ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read)
                 buf
                 ~pos_ref
                 vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a1 bin_a2 bin_a3 bin_a4 ->
         { writer = bin_writer_t bin_a1.writer bin_a2.writer bin_a3.writer bin_a4.writer
         ; reader = bin_reader_t bin_a1.reader bin_a2.reader bin_a3.reader bin_a4.reader
         ; shape = bin_shape_t bin_a1.shape bin_a2.shape bin_a3.shape bin_a4.shape
         }
       : _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = struct
    type ('a1, 'a2, 'a3, 'a4) derived_on = ('a1, 'a2, 'a3, 'a4) t

    module Entry_diff = struct
      type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include struct
        [@@@ocaml.warning "-60"]

        let _ =
          fun (_ : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t) -> ()
        ;;

        let t1 v0 = T1 v0
        let _ = t1
        let t2 v0 = T2 v0
        let _ = t2
        let t3 v0 = T3 v0
        let _ = t3
        let t4 v0 = T4 v0
        let _ = t4

        let is_t1 = function
          | T1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t1

        let is_t2 = function
          | T2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t2

        let is_t3 = function
          | T3 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t3

        let is_t4 = function
          | T4 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t4

        let t1_val = function
          | T1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t1_val

        let t2_val = function
          | T2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t2_val

        let t3_val = function
          | T3 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t3_val

        let t4_val = function
          | T4 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t4_val

        module Variants = struct
          let t1 = { Variantslib.Variant.name = "T1"; rank = 0; constructor = t1 }
          let _ = t1
          let t2 = { Variantslib.Variant.name = "T2"; rank = 1; constructor = t2 }
          let _ = t2
          let t3 = { Variantslib.Variant.name = "T3"; rank = 2; constructor = t3 }
          let _ = t3
          let t4 = { Variantslib.Variant.name = "T4"; rank = 3; constructor = t4 }
          let _ = t4

          let fold ~init:init__ ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ ~t4:t4_fun__ =
            t4_fun__ (t3_fun__ (t2_fun__ (t1_fun__ init__ t1) t2) t3) t4
          ;;

          let _ = fold

          let iter ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ ~t4:t4_fun__ =
            (t1_fun__ t1 : unit);
            (t2_fun__ t2 : unit);
            (t3_fun__ t3 : unit);
            (t4_fun__ t4 : unit)
          ;;

          let _ = iter

          let map t__ ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ ~t4:t4_fun__ =
            match t__ with
            | T1 v0 -> t1_fun__ t1 v0
            | T2 v0 -> t2_fun__ t2 v0
            | T3 v0 -> t3_fun__ t3 v0
            | T4 v0 -> t4_fun__ t4 v0
          ;;

          let _ = map

          let make_matcher
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                compile_acc__
            =
            let t1_gen__, compile_acc__ = t1_fun__ t1 compile_acc__ in
            let t2_gen__, compile_acc__ = t2_fun__ t2 compile_acc__ in
            let t3_gen__, compile_acc__ = t3_fun__ t3 compile_acc__ in
            let t4_gen__, compile_acc__ = t4_fun__ t4 compile_acc__ in
            ( map
                ~t1:(fun _ -> t1_gen__)
                ~t2:(fun _ -> t2_gen__)
                ~t3:(fun _ -> t3_gen__)
                ~t4:(fun _ -> t4_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | T1 _ -> 0
            | T2 _ -> 1
            | T3 _ -> 2
            | T4 _ -> 3
          ;;

          let _ = to_rank

          let to_name = function
            | T1 _ -> "T1"
            | T2 _ -> "T2"
            | T3 _ -> "T3"
            | T4 _ -> "T4"
          ;;

          let _ = to_name
          let descriptions = [ "T1", 1; "T2", 1; "T3", 1; "T4", 1 ]
          let _ = descriptions
        end

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          =
          fun (type a1__383_) ->
          fun (type a2__384_) ->
          fun (type a3__385_) ->
          fun (type a4__386_) ->
          fun (type a1_diff__387_) ->
          fun (type a2_diff__388_) ->
          fun (type a3_diff__389_) ->
          fun (type a4_diff__390_) ->
          (let error_source__361_ = "tuples.ml.before-ppx.Tuple4.Diff.Entry_diff.t" in
           fun _of_a1__351_
             _of_a2__352_
             _of_a3__353_
             _of_a4__354_
             _of_a1_diff__355_
             _of_a2_diff__356_
             _of_a3_diff__357_
             _of_a4_diff__358_ ->
             function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t1" | "T1") as _tag__364_) :: sexp_args__365_) as
               _sexp__363_ ->
               (match sexp_args__365_ with
                | arg0__366_ :: [] ->
                  let res0__367_ = _of_a1_diff__355_ arg0__366_ in
                  T1 res0__367_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__361_
                    _tag__364_
                    _sexp__363_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t2" | "T2") as _tag__369_) :: sexp_args__370_) as
               _sexp__368_ ->
               (match sexp_args__370_ with
                | arg0__371_ :: [] ->
                  let res0__372_ = _of_a2_diff__356_ arg0__371_ in
                  T2 res0__372_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__361_
                    _tag__369_
                    _sexp__368_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t3" | "T3") as _tag__374_) :: sexp_args__375_) as
               _sexp__373_ ->
               (match sexp_args__375_ with
                | arg0__376_ :: [] ->
                  let res0__377_ = _of_a3_diff__357_ arg0__376_ in
                  T3 res0__377_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__361_
                    _tag__374_
                    _sexp__373_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t4" | "T4") as _tag__379_) :: sexp_args__380_) as
               _sexp__378_ ->
               (match sexp_args__380_ with
                | arg0__381_ :: [] ->
                  let res0__382_ = _of_a4_diff__358_ arg0__381_ in
                  T4 res0__382_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__361_
                    _tag__379_
                    _sexp__378_)
             | Sexplib0.Sexp.Atom ("t1" | "T1") as sexp__362_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__361_ sexp__362_
             | Sexplib0.Sexp.Atom ("t2" | "T2") as sexp__362_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__361_ sexp__362_
             | Sexplib0.Sexp.Atom ("t3" | "T3") as sexp__362_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__361_ sexp__362_
             | Sexplib0.Sexp.Atom ("t4" | "T4") as sexp__362_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__361_ sexp__362_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__360_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__361_
                 sexp__360_
             | Sexplib0.Sexp.List [] as sexp__360_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__361_
                 sexp__360_
             | sexp__360_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__361_ sexp__360_
           : (Sexplib0.Sexp.t -> a1__383_)
             -> (Sexplib0.Sexp.t -> a2__384_)
             -> (Sexplib0.Sexp.t -> a3__385_)
             -> (Sexplib0.Sexp.t -> a4__386_)
             -> (Sexplib0.Sexp.t -> a1_diff__387_)
             -> (Sexplib0.Sexp.t -> a2_diff__388_)
             -> (Sexplib0.Sexp.t -> a3_diff__389_)
             -> (Sexplib0.Sexp.t -> a4_diff__390_)
             -> Sexplib0.Sexp.t
             -> ( a1__383_
                  , a2__384_
                  , a3__385_
                  , a4__386_
                  , a1_diff__387_
                  , a2_diff__388_
                  , a3_diff__389_
                  , a4_diff__390_ )
                  t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> Sexplib0.Sexp.t
          =
          fun (type a1__407_) ->
          fun (type a2__408_) ->
          fun (type a3__409_) ->
          fun (type a4__410_) ->
          fun (type a1_diff__411_) ->
          fun (type a2_diff__412_) ->
          fun (type a3_diff__413_) ->
          fun (type a4_diff__414_) ->
          (fun _of_a1__391_
             _of_a2__392_
             _of_a3__393_
             _of_a4__394_
             _of_a1_diff__395_
             _of_a2_diff__396_
             _of_a3_diff__397_
             _of_a4_diff__398_ ->
             function
             | T1 arg0__399_ ->
               let res0__400_ = _of_a1_diff__395_ arg0__399_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T1"; res0__400_ ]
             | T2 arg0__401_ ->
               let res0__402_ = _of_a2_diff__396_ arg0__401_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T2"; res0__402_ ]
             | T3 arg0__403_ ->
               let res0__404_ = _of_a3_diff__397_ arg0__403_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T3"; res0__404_ ]
             | T4 arg0__405_ ->
               let res0__406_ = _of_a4_diff__398_ arg0__405_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T4"; res0__406_ ]
           : (a1__407_ -> Sexplib0.Sexp.t)
             -> (a2__408_ -> Sexplib0.Sexp.t)
             -> (a3__409_ -> Sexplib0.Sexp.t)
             -> (a4__410_ -> Sexplib0.Sexp.t)
             -> (a1_diff__411_ -> Sexplib0.Sexp.t)
             -> (a2_diff__412_ -> Sexplib0.Sexp.t)
             -> (a3_diff__413_ -> Sexplib0.Sexp.t)
             -> (a4_diff__414_ -> Sexplib0.Sexp.t)
             -> ( a1__407_
                  , a2__408_
                  , a3__409_
                  , a4__410_
                  , a1_diff__411_
                  , a2_diff__412_
                  , a3_diff__413_
                  , a4_diff__414_ )
                  t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:503:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "T1"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:504:16")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")
                        ] )
                    ; ( "T2"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:505:16")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")
                        ] )
                    ; ( "T3"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:506:16")
                            (Bin_prot.Shape.Vid.of_string "a3_diff")
                        ] )
                    ; ( "T4"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:507:16")
                            (Bin_prot.Shape.Vid.of_string "a4_diff")
                        ] )
                    ] )
              ]
          in
          fun a1 a2 a3 a4 a1_diff a2_diff a3_diff a4_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a4; a1_diff; a2_diff; a3_diff; a4_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff ->
            function
          | T1 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a1_diff v1)
          | T2 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a2_diff v1)
          | T3 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a3_diff v1)
          | T4 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a4_diff v1)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            buf
            ~pos ->
            function
          | T1 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a1_diff buf ~pos v1
          | T2 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            _write_a2_diff buf ~pos v1
          | T3 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            _write_a3_diff buf ~pos v1
          | T4 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
            _write_a4_diff buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _buf
            ~pos_ref
            _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "tuples.ml.before-ppx.Tuple4.Diff.Entry_diff.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            buf
            ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a1_diff buf ~pos_ref in
            T1 arg_1
          | 1 ->
            let arg_1 = _of__a2_diff buf ~pos_ref in
            T2 arg_1
          | 2 ->
            let arg_1 = _of__a3_diff buf ~pos_ref in
            T3 arg_1
          | 3 ->
            let arg_1 = _of__a4_diff buf ~pos_ref in
            T4 arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "tuples.ml.before-ppx.Tuple4.Diff.Entry_diff.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__442_
              _generator__443_
              _generator__444_
              _generator__445_
              _generator__446_
              _generator__447_
              _generator__448_
              _generator__449_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__450_ ~random:_random__451_ ->
                     T1
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__446_
                          ~size:_size__450_
                          ~random:_random__451_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__452_ ~random:_random__453_ ->
                     T2
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__447_
                          ~size:_size__452_
                          ~random:_random__453_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__454_ ~random:_random__455_ ->
                     T3
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__448_
                          ~size:_size__454_
                          ~random:_random__455_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__456_ ~random:_random__457_ ->
                     T4
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__449_
                          ~size:_size__456_
                          ~random:_random__457_)) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__427_
              _observer__428_
              _observer__429_
              _observer__430_
              _observer__431_
              _observer__432_
              _observer__433_
              _observer__434_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__435_ ~size:_size__436_ ~hash:_hash__437_ ->
               match _x__435_ with
               | T1 _x__438_ ->
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__437_ 0
                 in
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__431_
                     _x__438_
                     ~size:_size__436_
                     ~hash:_hash__437_
                 in
                 _hash__437_
               | T2 _x__439_ ->
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__437_ 1
                 in
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__432_
                     _x__439_
                     ~size:_size__436_
                     ~hash:_hash__437_
                 in
                 _hash__437_
               | T3 _x__440_ ->
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__437_ 2
                 in
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__433_
                     _x__440_
                     ~size:_size__436_
                     ~hash:_hash__437_
                 in
                 _hash__437_
               | T4 _x__441_ ->
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__437_ 3
                 in
                 let _hash__437_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__434_
                     _x__441_
                     ~size:_size__436_
                     ~hash:_hash__437_
                 in
                 _hash__437_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__415_
              _shrinker__416_
              _shrinker__417_
              _shrinker__418_
              _shrinker__419_
              _shrinker__420_
              _shrinker__421_
              _shrinker__422_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | T1 _x__423_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__419_
                       _x__423_)
                    ~f:(fun _x__423_ -> T1 _x__423_)
                ]
            | T2 _x__424_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__420_
                       _x__424_)
                    ~f:(fun _x__424_ -> T2 _x__424_)
                ]
            | T3 _x__425_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__421_
                       _x__425_)
                    ~f:(fun _x__425_ -> T3 _x__425_)
                ]
            | T4 _x__426_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__422_
                       _x__426_)
                    ~f:(fun _x__426_ -> T4 _x__426_)
                ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Entry_diff

    type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
      ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include struct
      let _ =
        fun (_ : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t) -> ()
      ;;

      let t_of_sexp
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
        =
        fun _of_a1__458_
          _of_a2__459_
          _of_a3__460_
          _of_a4__461_
          _of_a1_diff__462_
          _of_a2_diff__463_
          _of_a3_diff__464_
          _of_a4_diff__465_
          x__467_ ->
        list_of_sexp
          (Entry_diff.t_of_sexp
             _of_a1__458_
             _of_a2__459_
             _of_a3__460_
             _of_a4__461_
             _of_a1_diff__462_
             _of_a2_diff__463_
             _of_a3_diff__464_
             _of_a4_diff__465_)
          x__467_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__468_
          _of_a2__469_
          _of_a3__470_
          _of_a4__471_
          _of_a1_diff__472_
          _of_a2_diff__473_
          _of_a3_diff__474_
          _of_a4_diff__475_
          x__476_ ->
        sexp_of_list
          (Entry_diff.sexp_of_t
             _of_a1__468_
             _of_a2__469_
             _of_a3__470_
             _of_a4__471_
             _of_a1_diff__472_
             _of_a2_diff__473_
             _of_a3_diff__474_
             _of_a4_diff__475_)
          x__476_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:513:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ; Bin_prot.Shape.Vid.of_string "a1_diff"
                ; Bin_prot.Shape.Vid.of_string "a2_diff"
                ; Bin_prot.Shape.Vid.of_string "a3_diff"
                ; Bin_prot.Shape.Vid.of_string "a4_diff"
                ]
              , bin_shape_list
                  ((((((((Entry_diff.bin_shape_t
                            (Bin_prot.Shape.var
                               (Bin_prot.Shape.Location.of_string
                                  "tuples.ml.before-ppx:514:7")
                               (Bin_prot.Shape.Vid.of_string "a1")))
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:514:12")
                              (Bin_prot.Shape.Vid.of_string "a2")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:514:17")
                             (Bin_prot.Shape.Vid.of_string "a3")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:514:22")
                            (Bin_prot.Shape.Vid.of_string "a4")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:514:27")
                           (Bin_prot.Shape.Vid.of_string "a1_diff")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:514:37")
                          (Bin_prot.Shape.Vid.of_string "a2_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:514:47")
                         (Bin_prot.Shape.Vid.of_string "a3_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:514:57")
                        (Bin_prot.Shape.Vid.of_string "a4_diff"))) )
            ]
        in
        fun a1 a2 a3 a4 a1_diff a2_diff a3_diff a4_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a4; a1_diff; a2_diff; a3_diff; a4_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Size.sizer
        =
        fun _size_of_a1
          _size_of_a2
          _size_of_a3
          _size_of_a4
          _size_of_a1_diff
          _size_of_a2_diff
          _size_of_a3_diff
          _size_of_a4_diff
          v ->
        bin_size_list
          (Entry_diff.bin_size_t
             _size_of_a1
             _size_of_a2
             _size_of_a3
             _size_of_a4
             _size_of_a1_diff
             _size_of_a2_diff
             _size_of_a3_diff
             _size_of_a4_diff)
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Write.writer
        =
        fun _write_a1
          _write_a2
          _write_a3
          _write_a4
          _write_a1_diff
          _write_a2_diff
          _write_a3_diff
          _write_a4_diff
          buf
          ~pos
          v ->
        bin_write_list
          (Entry_diff.bin_write_t
             _write_a1
             _write_a2
             _write_a3
             _write_a4
             _write_a1_diff
             _write_a2_diff
             _write_a3_diff
             _write_a4_diff)
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1
           bin_writer_a2
           bin_writer_a3
           bin_writer_a4
           bin_writer_a1_diff
           bin_writer_a2_diff
           bin_writer_a3_diff
           bin_writer_a4_diff ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   bin_writer_a1_diff.size
                   bin_writer_a2_diff.size
                   bin_writer_a3_diff.size
                   bin_writer_a4_diff.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   bin_writer_a1_diff.write
                   bin_writer_a2_diff.write
                   bin_writer_a3_diff.write
                   bin_writer_a4_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          buf
          ~pos_ref
          vint ->
        (__bin_read_list__
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          buf
          ~pos_ref ->
        (bin_read_list
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff))
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1
           bin_reader_a2
           bin_reader_a3
           bin_reader_a4
           bin_reader_a1_diff
           bin_reader_a2_diff
           bin_reader_a3_diff
           bin_reader_a4_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1
           bin_a2
           bin_a3
           bin_a4
           bin_a1_diff
           bin_a2_diff
           bin_a3_diff
           bin_a4_diff ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a4.writer
                 bin_a1_diff.writer
                 bin_a2_diff.writer
                 bin_a3_diff.writer
                 bin_a4_diff.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a4.reader
                 bin_a1_diff.reader
                 bin_a2_diff.reader
                 bin_a3_diff.reader
                 bin_a4_diff.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a4.shape
                 bin_a1_diff.shape
                 bin_a2_diff.shape
                 bin_a3_diff.shape
                 bin_a4_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let quickcheck_generator
            _generator__493_
            _generator__494_
            _generator__495_
            _generator__496_
            _generator__497_
            _generator__498_
            _generator__499_
            _generator__500_
        =
        quickcheck_generator_list
          (Entry_diff.quickcheck_generator
             _generator__493_
             _generator__494_
             _generator__495_
             _generator__496_
             _generator__497_
             _generator__498_
             _generator__499_
             _generator__500_)
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer
            _observer__485_
            _observer__486_
            _observer__487_
            _observer__488_
            _observer__489_
            _observer__490_
            _observer__491_
            _observer__492_
        =
        quickcheck_observer_list
          (Entry_diff.quickcheck_observer
             _observer__485_
             _observer__486_
             _observer__487_
             _observer__488_
             _observer__489_
             _observer__490_
             _observer__491_
             _observer__492_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker
            _shrinker__477_
            _shrinker__478_
            _shrinker__479_
            _shrinker__480_
            _shrinker__481_
            _shrinker__482_
            _shrinker__483_
            _shrinker__484_
        =
        quickcheck_shrinker_list
          (Entry_diff.quickcheck_shrinker
             _shrinker__477_
             _shrinker__478_
             _shrinker__479_
             _shrinker__480_
             _shrinker__481_
             _shrinker__482_
             _shrinker__483_
             _shrinker__484_)
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare_rank t1 t2 =
      Int.compare (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let equal_rank t1 t2 =
      Int.equal (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let get get1 get2 get3 get4 ~from ~to_ =
      if Base.phys_equal from to_
      then Optional_diff.none
      else (
        let from_1, from_2, from_3, from_4 = from in
        let to_1, to_2, to_3, to_4 = to_ in
        let diff = [] in
        let diff =
          let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T4 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T4 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T3 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T3 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T2 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T2 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T1 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T1 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        match diff with
        | [] -> Optional_diff.none
        | _ :: _ -> Optional_diff.return diff)
    ;;

    let apply_exn apply1_exn apply2_exn apply3_exn apply4_exn derived_on diff =
      let derived_on1, derived_on2, derived_on3, derived_on4 = derived_on in
      let t1, diff =
        match diff with
        | T1 d :: tl -> apply1_exn derived_on1 d, tl
        | _ -> derived_on1, diff
      in
      let t2, diff =
        match diff with
        | T2 d :: tl -> apply2_exn derived_on2 d, tl
        | _ -> derived_on2, diff
      in
      let t3, diff =
        match diff with
        | T3 d :: tl -> apply3_exn derived_on3 d, tl
        | _ -> derived_on3, diff
      in
      let t4, diff =
        match diff with
        | T4 d :: tl -> apply4_exn derived_on4 d, tl
        | _ -> derived_on4, diff
      in
      match diff with
      | [] -> t1, t2, t3, t4
      | _ :: _ -> failwith "BUG: non-empty diff after apply"
    ;;

    let of_list_exn
          of_list1_exn
          _apply1_exn
          of_list2_exn
          _apply2_exn
          of_list3_exn
          _apply3_exn
          of_list4_exn
          _apply4_exn
          ts
      =
      match ts with
      | [] -> Optional_diff.none
      | _ :: _ ->
        (match List.stable_sort ~compare:compare_rank (List.concat ts) with
         | [] -> Optional_diff.return []
         | _ :: _ as diff ->
           let rec loop acc = function
             | [] -> List.rev acc
             | T1 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T1 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T1 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list1_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T1 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T1 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T2 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T2 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T2 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list2_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T2 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T2 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T3 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T3 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T3 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list3_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T3 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T3 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T4 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T4 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T4 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list4_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T4 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T4 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
           in
           Optional_diff.return (loop [] diff))
    ;;

    let singleton entry_diff = [ entry_diff ]

    let t_of_sexp
          a1_of_sexp
          a2_of_sexp
          a3_of_sexp
          a4_of_sexp
          a1_diff_of_sexp
          a2_diff_of_sexp
          a3_diff_of_sexp
          a4_diff_of_sexp
          sexp
      =
      let l =
        List.sort
          ~compare:compare_rank
          (t_of_sexp
             a1_of_sexp
             a2_of_sexp
             a3_of_sexp
             a4_of_sexp
             a1_diff_of_sexp
             a2_diff_of_sexp
             a3_diff_of_sexp
             a4_diff_of_sexp
             sexp)
      in
      match List.find_consecutive_duplicate l ~equal:equal_rank with
      | None -> l
      | Some (dup, _) ->
        failwith ("Duplicate entry in tuple diff: " ^ Entry_diff.Variants.to_name dup)
    ;;

    let create ?t1 ?t2 ?t3 ?t4 () =
      let diff = [] in
      let diff =
        match t4 with
        | None -> diff
        | Some d -> T4 d :: diff
      in
      let diff =
        match t3 with
        | None -> diff
        | Some d -> T3 d :: diff
      in
      let diff =
        match t2 with
        | None -> diff
        | Some d -> T2 d :: diff
      in
      let diff =
        match t1 with
        | None -> diff
        | Some d -> T1 d :: diff
      in
      diff
    ;;

    let create_of_variants ~t1 ~t2 ~t3 ~t4 =
      let diff = [] in
      let diff =
        let __ppx_optional_e_0 = t4 Entry_diff.Variants.t4 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T4 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T4 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t3 Entry_diff.Variants.t3 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T3 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T3 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t2 Entry_diff.Variants.t2 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T2 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T2 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t1 Entry_diff.Variants.t1 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T1 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T1 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      diff
    ;;
  end

  module For_inlined_tuple = struct
    type ('a1, 'a2, 'a3, 'a4) t = 'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a3, 'a4) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a3 'a4.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4) t
        =
        let error_source__515_ = "tuples.ml.before-ppx.Tuple4.For_inlined_tuple.t" in
        fun _of_a1__501_ _of_a2__502_ _of_a3__503_ _of_a4__504_ -> function
          | Sexplib0.Sexp.List [ arg0__506_; arg1__507_; arg2__508_; arg3__509_ ] ->
            let res0__510_ = Gel.t_of_sexp _of_a1__501_ arg0__506_
            and res1__511_ = Gel.t_of_sexp _of_a2__502_ arg1__507_
            and res2__512_ = Gel.t_of_sexp _of_a3__503_ arg2__508_
            and res3__513_ = Gel.t_of_sexp _of_a4__504_ arg3__509_ in
            res0__510_, res1__511_, res2__512_, res3__513_
          | sexp__514_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__515_
              4
              sexp__514_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__516_
          _of_a2__517_
          _of_a3__518_
          _of_a4__519_
          (arg0__520_, arg1__521_, arg2__522_, arg3__523_) ->
        let res0__524_ = Gel.sexp_of_t _of_a1__516_ arg0__520_
        and res1__525_ = Gel.sexp_of_t _of_a2__517_ arg1__521_
        and res2__526_ = Gel.sexp_of_t _of_a3__518_ arg2__522_
        and res3__527_ = Gel.sexp_of_t _of_a4__519_ arg3__523_ in
        Sexplib0.Sexp.List [ res0__524_; res1__525_; res2__526_; res3__527_ ]
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:747:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ]
              , Bin_prot.Shape.tuple
                  [ Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:747:34")
                         (Bin_prot.Shape.Vid.of_string "a1"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:747:46")
                         (Bin_prot.Shape.Vid.of_string "a2"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:747:58")
                         (Bin_prot.Shape.Vid.of_string "a3"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:747:70")
                         (Bin_prot.Shape.Vid.of_string "a4"))
                  ] )
            ]
        in
        fun a1 a2 a3 a4 ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a4 ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 -> function
        | v1, v2, v3, v4 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a1 v1) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a2 v2) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a3 v3) in
          Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a4 v4)
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 _write_a3 _write_a4 buf ~pos -> function
        | v1, v2, v3, v4 ->
          let pos = Gel.bin_write_t _write_a1 buf ~pos v1 in
          let pos = Gel.bin_write_t _write_a2 buf ~pos v2 in
          let pos = Gel.bin_write_t _write_a3 buf ~pos v3 in
          Gel.bin_write_t _write_a4 buf ~pos v4
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 bin_writer_a4 ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "tuples.ml.before-ppx.Tuple4.For_inlined_tuple.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 buf ~pos_ref ->
        let v1 = (Gel.bin_read_t _of__a1) buf ~pos_ref in
        let v2 = (Gel.bin_read_t _of__a2) buf ~pos_ref in
        let v3 = (Gel.bin_read_t _of__a3) buf ~pos_ref in
        let v4 = (Gel.bin_read_t _of__a4) buf ~pos_ref in
        v1, v2, v3, v4
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 bin_reader_a4 ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a3 bin_a4 ->
           { writer = bin_writer_t bin_a1.writer bin_a2.writer bin_a3.writer bin_a4.writer
           ; reader = bin_reader_t bin_a1.reader bin_a2.reader bin_a3.reader bin_a4.reader
           ; shape = bin_shape_t bin_a1.shape bin_a2.shape bin_a3.shape bin_a4.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff = struct
      type ('a1, 'a2, 'a3, 'a4) derived_on = ('a1, 'a2, 'a3, 'a4) t

      type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
        ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include struct
        let _ =
          fun (_ : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t) -> ()
        ;;

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          =
          fun _of_a1__528_
            _of_a2__529_
            _of_a3__530_
            _of_a4__531_
            _of_a1_diff__532_
            _of_a2_diff__533_
            _of_a3_diff__534_
            _of_a4_diff__535_
            x__537_ ->
          Diff.t_of_sexp
            _of_a1__528_
            _of_a2__529_
            _of_a3__530_
            _of_a4__531_
            _of_a1_diff__532_
            _of_a2_diff__533_
            _of_a3_diff__534_
            _of_a4_diff__535_
            x__537_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> Sexplib0.Sexp.t
          =
          fun _of_a1__538_
            _of_a2__539_
            _of_a3__540_
            _of_a4__541_
            _of_a1_diff__542_
            _of_a2_diff__543_
            _of_a3_diff__544_
            _of_a4_diff__545_
            x__546_ ->
          Diff.sexp_of_t
            _of_a1__538_
            _of_a2__539_
            _of_a3__540_
            _of_a4__541_
            _of_a1_diff__542_
            _of_a2_diff__543_
            _of_a3_diff__544_
            _of_a4_diff__545_
            x__546_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:753:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ]
                , (((((((Diff.bin_shape_t
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:754:9")
                              (Bin_prot.Shape.Vid.of_string "a1")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:754:14")
                             (Bin_prot.Shape.Vid.of_string "a2")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:754:19")
                            (Bin_prot.Shape.Vid.of_string "a3")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:754:24")
                           (Bin_prot.Shape.Vid.of_string "a4")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:754:29")
                          (Bin_prot.Shape.Vid.of_string "a1_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:754:39")
                         (Bin_prot.Shape.Vid.of_string "a2_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:754:49")
                        (Bin_prot.Shape.Vid.of_string "a3_diff")))
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:754:59")
                       (Bin_prot.Shape.Vid.of_string "a4_diff")) )
              ]
          in
          fun a1 a2 a3 a4 a1_diff a2_diff a3_diff a4_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a4; a1_diff; a2_diff; a3_diff; a4_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            v ->
          Diff.bin_size_t
            _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            v
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            buf
            ~pos
            v ->
          Diff.bin_write_t
            _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            buf
            ~pos
            v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            buf
            ~pos_ref
            vint ->
          (Diff.__bin_read_t__
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff)
            buf
            ~pos_ref
            vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a1_diff 'a2_diff 'a3_diff 'a4_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            buf
            ~pos_ref ->
          (Diff.bin_read_t
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff)
            buf
            ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__563_
              _generator__564_
              _generator__565_
              _generator__566_
              _generator__567_
              _generator__568_
              _generator__569_
              _generator__570_
          =
          Diff.quickcheck_generator
            _generator__563_
            _generator__564_
            _generator__565_
            _generator__566_
            _generator__567_
            _generator__568_
            _generator__569_
            _generator__570_
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__555_
              _observer__556_
              _observer__557_
              _observer__558_
              _observer__559_
              _observer__560_
              _observer__561_
              _observer__562_
          =
          Diff.quickcheck_observer
            _observer__555_
            _observer__556_
            _observer__557_
            _observer__558_
            _observer__559_
            _observer__560_
            _observer__561_
            _observer__562_
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__547_
              _shrinker__548_
              _shrinker__549_
              _shrinker__550_
              _shrinker__551_
              _shrinker__552_
              _shrinker__553_
              _shrinker__554_
          =
          Diff.quickcheck_shrinker
            _shrinker__547_
            _shrinker__548_
            _shrinker__549_
            _shrinker__550_
            _shrinker__551_
            _shrinker__552_
            _shrinker__553_
            _shrinker__554_
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open Diff
      open Entry_diff

      let get get1 get2 get3 get4 ~from ~to_ =
        if Base.phys_equal from to_
        then Optional_diff.none
        else (
          let ( { Gel.g = from_1 }
              , { Gel.g = from_2 }
              , { Gel.g = from_3 }
              , { Gel.g = from_4 } )
            =
            from
          in
          let { Gel.g = to_1 }, { Gel.g = to_2 }, { Gel.g = to_3 }, { Gel.g = to_4 } =
            to_
          in
          let diff = [] in
          let diff =
            let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T4 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T4 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T3 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T3 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T2 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T2 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T1 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T1 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          match diff with
          | [] -> Optional_diff.none
          | _ :: _ -> Optional_diff.return diff)
      ;;

      let apply_exn apply1_exn apply2_exn apply3_exn apply4_exn derived_on diff =
        let ( { Gel.g = derived_on1 }
            , { Gel.g = derived_on2 }
            , { Gel.g = derived_on3 }
            , { Gel.g = derived_on4 } )
          =
          derived_on
        in
        let t1, diff =
          match diff with
          | T1 d :: tl -> apply1_exn derived_on1 d, tl
          | _ -> derived_on1, diff
        in
        let t2, diff =
          match diff with
          | T2 d :: tl -> apply2_exn derived_on2 d, tl
          | _ -> derived_on2, diff
        in
        let t3, diff =
          match diff with
          | T3 d :: tl -> apply3_exn derived_on3 d, tl
          | _ -> derived_on3, diff
        in
        let t4, diff =
          match diff with
          | T4 d :: tl -> apply4_exn derived_on4 d, tl
          | _ -> derived_on4, diff
        in
        match diff with
        | [] -> { Gel.g = t1 }, { Gel.g = t2 }, { Gel.g = t3 }, { Gel.g = t4 }
        | _ :: _ -> failwith "BUG: non-empty diff after apply"
      ;;

      let of_list_exn = of_list_exn
    end
  end
end

module Tuple5 = struct
  type ('a1, 'a2, 'a3, 'a4, 'a5) t = 'a1 * 'a2 * 'a3 * 'a4 * 'a5 [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : ('a1, 'a2, 'a3, 'a4, 'a5) t) -> ()

    let t_of_sexp
      :  'a1 'a2 'a3 'a4 'a5.
         (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> (Sexplib0.Sexp.t -> 'a5)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t
      =
      let error_source__588_ = "tuples.ml.before-ppx.Tuple5.t" in
      fun _of_a1__571_ _of_a2__572_ _of_a3__573_ _of_a4__574_ _of_a5__575_ -> function
        | Sexplib0.Sexp.List
            [ arg0__577_; arg1__578_; arg2__579_; arg3__580_; arg4__581_ ] ->
          let res0__582_ = _of_a1__571_ arg0__577_
          and res1__583_ = _of_a2__572_ arg1__578_
          and res2__584_ = _of_a3__573_ arg2__579_
          and res3__585_ = _of_a4__574_ arg3__580_
          and res4__586_ = _of_a5__575_ arg4__581_ in
          res0__582_, res1__583_, res2__584_, res3__585_, res4__586_
        | sexp__587_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__588_
            5
            sexp__587_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a1 'a2 'a3 'a4 'a5.
         ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a1__589_
        _of_a2__590_
        _of_a3__591_
        _of_a4__592_
        _of_a5__593_
        (arg0__594_, arg1__595_, arg2__596_, arg3__597_, arg4__598_) ->
      let res0__599_ = _of_a1__589_ arg0__594_
      and res1__600_ = _of_a2__590_ arg1__595_
      and res2__601_ = _of_a3__591_ arg2__596_
      and res3__602_ = _of_a4__592_ arg3__597_
      and res4__603_ = _of_a5__593_ arg4__598_ in
      Sexplib0.Sexp.List [ res0__599_; res1__600_; res2__601_; res3__602_; res4__603_ ]
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a1"
              ; Bin_prot.Shape.Vid.of_string "a2"
              ; Bin_prot.Shape.Vid.of_string "a3"
              ; Bin_prot.Shape.Vid.of_string "a4"
              ; Bin_prot.Shape.Vid.of_string "a5"
              ]
            , Bin_prot.Shape.tuple
                [ Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:37")
                    (Bin_prot.Shape.Vid.of_string "a1")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:43")
                    (Bin_prot.Shape.Vid.of_string "a2")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:49")
                    (Bin_prot.Shape.Vid.of_string "a3")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:55")
                    (Bin_prot.Shape.Vid.of_string "a4")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:839:61")
                    (Bin_prot.Shape.Vid.of_string "a5")
                ] )
          ]
      in
      fun a1 a2 a3 a4 a5 ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
          [ a1; a2; a3; a4; a5 ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a1 'a2 'a3 'a4 'a5.
         'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> 'a5 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Size.sizer
      =
      fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 _size_of_a5 -> function
      | v1, v2, v3, v4, v5 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a1 v1) in
        let size = Bin_prot.Common.( + ) size (_size_of_a2 v2) in
        let size = Bin_prot.Common.( + ) size (_size_of_a3 v3) in
        let size = Bin_prot.Common.( + ) size (_size_of_a4 v4) in
        Bin_prot.Common.( + ) size (_size_of_a5 v5)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a1 'a2 'a3 'a4 'a5.
         'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> 'a5 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Write.writer
      =
      fun _write_a1 _write_a2 _write_a3 _write_a4 _write_a5 buf ~pos -> function
      | v1, v2, v3, v4, v5 ->
        let pos = _write_a1 buf ~pos v1 in
        let pos = _write_a2 buf ~pos v2 in
        let pos = _write_a3 buf ~pos v3 in
        let pos = _write_a4 buf ~pos v4 in
        _write_a5 buf ~pos v5
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 bin_writer_a4 bin_writer_a5 ->
         { size =
             (fun v ->
               bin_size_t
                 bin_writer_a1.size
                 bin_writer_a2.size
                 bin_writer_a3.size
                 bin_writer_a4.size
                 bin_writer_a5.size
                 v)
         ; write =
             (fun v ->
               bin_write_t
                 bin_writer_a1.write
                 bin_writer_a2.write
                 bin_writer_a3.write
                 bin_writer_a4.write
                 bin_writer_a5.write
                 v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a1 'a2 'a3 'a4 'a5.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5) t) Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuples.ml.before-ppx.Tuple5.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a1 'a2 'a3 'a4 'a5.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 buf ~pos_ref ->
      let v1 = _of__a1 buf ~pos_ref in
      let v2 = _of__a2 buf ~pos_ref in
      let v3 = _of__a3 buf ~pos_ref in
      let v4 = _of__a4 buf ~pos_ref in
      let v5 = _of__a5 buf ~pos_ref in
      v1, v2, v3, v4, v5
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 bin_reader_a4 bin_reader_a5 ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read
                  bin_reader_a5.read)
                 buf
                 ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read
                  bin_reader_a5.read)
                 buf
                 ~pos_ref
                 vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a1 bin_a2 bin_a3 bin_a4 bin_a5 ->
         { writer =
             bin_writer_t
               bin_a1.writer
               bin_a2.writer
               bin_a3.writer
               bin_a4.writer
               bin_a5.writer
         ; reader =
             bin_reader_t
               bin_a1.reader
               bin_a2.reader
               bin_a3.reader
               bin_a4.reader
               bin_a5.reader
         ; shape =
             bin_shape_t bin_a1.shape bin_a2.shape bin_a3.shape bin_a4.shape bin_a5.shape
         }
       : _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = struct
    type ('a1, 'a2, 'a3, 'a4, 'a5) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5) t

    module Entry_diff = struct
      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
        | T5 of 'a5_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include struct
        [@@@ocaml.warning "-60"]

        let _ =
          fun (_ :
                ( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff )
                  t) ->
          ()
        ;;

        let t1 v0 = T1 v0
        let _ = t1
        let t2 v0 = T2 v0
        let _ = t2
        let t3 v0 = T3 v0
        let _ = t3
        let t4 v0 = T4 v0
        let _ = t4
        let t5 v0 = T5 v0
        let _ = t5

        let is_t1 = function
          | T1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t1

        let is_t2 = function
          | T2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t2

        let is_t3 = function
          | T3 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t3

        let is_t4 = function
          | T4 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t4

        let is_t5 = function
          | T5 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t5

        let t1_val = function
          | T1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t1_val

        let t2_val = function
          | T2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t2_val

        let t3_val = function
          | T3 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t3_val

        let t4_val = function
          | T4 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t4_val

        let t5_val = function
          | T5 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t5_val

        module Variants = struct
          let t1 = { Variantslib.Variant.name = "T1"; rank = 0; constructor = t1 }
          let _ = t1
          let t2 = { Variantslib.Variant.name = "T2"; rank = 1; constructor = t2 }
          let _ = t2
          let t3 = { Variantslib.Variant.name = "T3"; rank = 2; constructor = t3 }
          let _ = t3
          let t4 = { Variantslib.Variant.name = "T4"; rank = 3; constructor = t4 }
          let _ = t4
          let t5 = { Variantslib.Variant.name = "T5"; rank = 4; constructor = t5 }
          let _ = t5

          let fold
                ~init:init__
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
            =
            t5_fun__ (t4_fun__ (t3_fun__ (t2_fun__ (t1_fun__ init__ t1) t2) t3) t4) t5
          ;;

          let _ = fold

          let iter ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ ~t4:t4_fun__ ~t5:t5_fun__ =
            (t1_fun__ t1 : unit);
            (t2_fun__ t2 : unit);
            (t3_fun__ t3 : unit);
            (t4_fun__ t4 : unit);
            (t5_fun__ t5 : unit)
          ;;

          let _ = iter

          let map t__ ~t1:t1_fun__ ~t2:t2_fun__ ~t3:t3_fun__ ~t4:t4_fun__ ~t5:t5_fun__ =
            match t__ with
            | T1 v0 -> t1_fun__ t1 v0
            | T2 v0 -> t2_fun__ t2 v0
            | T3 v0 -> t3_fun__ t3 v0
            | T4 v0 -> t4_fun__ t4 v0
            | T5 v0 -> t5_fun__ t5 v0
          ;;

          let _ = map

          let make_matcher
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
                compile_acc__
            =
            let t1_gen__, compile_acc__ = t1_fun__ t1 compile_acc__ in
            let t2_gen__, compile_acc__ = t2_fun__ t2 compile_acc__ in
            let t3_gen__, compile_acc__ = t3_fun__ t3 compile_acc__ in
            let t4_gen__, compile_acc__ = t4_fun__ t4 compile_acc__ in
            let t5_gen__, compile_acc__ = t5_fun__ t5 compile_acc__ in
            ( map
                ~t1:(fun _ -> t1_gen__)
                ~t2:(fun _ -> t2_gen__)
                ~t3:(fun _ -> t3_gen__)
                ~t4:(fun _ -> t4_gen__)
                ~t5:(fun _ -> t5_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | T1 _ -> 0
            | T2 _ -> 1
            | T3 _ -> 2
            | T4 _ -> 3
            | T5 _ -> 4
          ;;

          let _ = to_rank

          let to_name = function
            | T1 _ -> "T1"
            | T2 _ -> "T2"
            | T3 _ -> "T3"
            | T4 _ -> "T4"
            | T5 _ -> "T5"
          ;;

          let _ = to_name
          let descriptions = [ "T1", 1; "T2", 1; "T3", 1; "T4", 1; "T5", 1 ]
          let _ = descriptions
        end

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          =
          fun (type a1__643_) ->
          fun (type a2__644_) ->
          fun (type a3__645_) ->
          fun (type a4__646_) ->
          fun (type a5__647_) ->
          fun (type a1_diff__648_) ->
          fun (type a2_diff__649_) ->
          fun (type a3_diff__650_) ->
          fun (type a4_diff__651_) ->
          fun (type a5_diff__652_) ->
          (let error_source__616_ = "tuples.ml.before-ppx.Tuple5.Diff.Entry_diff.t" in
           fun _of_a1__604_
             _of_a2__605_
             _of_a3__606_
             _of_a4__607_
             _of_a5__608_
             _of_a1_diff__609_
             _of_a2_diff__610_
             _of_a3_diff__611_
             _of_a4_diff__612_
             _of_a5_diff__613_ ->
             function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t1" | "T1") as _tag__619_) :: sexp_args__620_) as
               _sexp__618_ ->
               (match sexp_args__620_ with
                | arg0__621_ :: [] ->
                  let res0__622_ = _of_a1_diff__609_ arg0__621_ in
                  T1 res0__622_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__616_
                    _tag__619_
                    _sexp__618_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t2" | "T2") as _tag__624_) :: sexp_args__625_) as
               _sexp__623_ ->
               (match sexp_args__625_ with
                | arg0__626_ :: [] ->
                  let res0__627_ = _of_a2_diff__610_ arg0__626_ in
                  T2 res0__627_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__616_
                    _tag__624_
                    _sexp__623_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t3" | "T3") as _tag__629_) :: sexp_args__630_) as
               _sexp__628_ ->
               (match sexp_args__630_ with
                | arg0__631_ :: [] ->
                  let res0__632_ = _of_a3_diff__611_ arg0__631_ in
                  T3 res0__632_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__616_
                    _tag__629_
                    _sexp__628_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t4" | "T4") as _tag__634_) :: sexp_args__635_) as
               _sexp__633_ ->
               (match sexp_args__635_ with
                | arg0__636_ :: [] ->
                  let res0__637_ = _of_a4_diff__612_ arg0__636_ in
                  T4 res0__637_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__616_
                    _tag__634_
                    _sexp__633_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t5" | "T5") as _tag__639_) :: sexp_args__640_) as
               _sexp__638_ ->
               (match sexp_args__640_ with
                | arg0__641_ :: [] ->
                  let res0__642_ = _of_a5_diff__613_ arg0__641_ in
                  T5 res0__642_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__616_
                    _tag__639_
                    _sexp__638_)
             | Sexplib0.Sexp.Atom ("t1" | "T1") as sexp__617_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__616_ sexp__617_
             | Sexplib0.Sexp.Atom ("t2" | "T2") as sexp__617_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__616_ sexp__617_
             | Sexplib0.Sexp.Atom ("t3" | "T3") as sexp__617_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__616_ sexp__617_
             | Sexplib0.Sexp.Atom ("t4" | "T4") as sexp__617_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__616_ sexp__617_
             | Sexplib0.Sexp.Atom ("t5" | "T5") as sexp__617_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__616_ sexp__617_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__615_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__616_
                 sexp__615_
             | Sexplib0.Sexp.List [] as sexp__615_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__616_
                 sexp__615_
             | sexp__615_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__616_ sexp__615_
           : (Sexplib0.Sexp.t -> a1__643_)
             -> (Sexplib0.Sexp.t -> a2__644_)
             -> (Sexplib0.Sexp.t -> a3__645_)
             -> (Sexplib0.Sexp.t -> a4__646_)
             -> (Sexplib0.Sexp.t -> a5__647_)
             -> (Sexplib0.Sexp.t -> a1_diff__648_)
             -> (Sexplib0.Sexp.t -> a2_diff__649_)
             -> (Sexplib0.Sexp.t -> a3_diff__650_)
             -> (Sexplib0.Sexp.t -> a4_diff__651_)
             -> (Sexplib0.Sexp.t -> a5_diff__652_)
             -> Sexplib0.Sexp.t
             -> ( a1__643_
                  , a2__644_
                  , a3__645_
                  , a4__646_
                  , a5__647_
                  , a1_diff__648_
                  , a2_diff__649_
                  , a3_diff__650_
                  , a4_diff__651_
                  , a5_diff__652_ )
                  t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> Sexplib0.Sexp.t
          =
          fun (type a1__673_) ->
          fun (type a2__674_) ->
          fun (type a3__675_) ->
          fun (type a4__676_) ->
          fun (type a5__677_) ->
          fun (type a1_diff__678_) ->
          fun (type a2_diff__679_) ->
          fun (type a3_diff__680_) ->
          fun (type a4_diff__681_) ->
          fun (type a5_diff__682_) ->
          (fun _of_a1__653_
             _of_a2__654_
             _of_a3__655_
             _of_a4__656_
             _of_a5__657_
             _of_a1_diff__658_
             _of_a2_diff__659_
             _of_a3_diff__660_
             _of_a4_diff__661_
             _of_a5_diff__662_ ->
             function
             | T1 arg0__663_ ->
               let res0__664_ = _of_a1_diff__658_ arg0__663_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T1"; res0__664_ ]
             | T2 arg0__665_ ->
               let res0__666_ = _of_a2_diff__659_ arg0__665_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T2"; res0__666_ ]
             | T3 arg0__667_ ->
               let res0__668_ = _of_a3_diff__660_ arg0__667_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T3"; res0__668_ ]
             | T4 arg0__669_ ->
               let res0__670_ = _of_a4_diff__661_ arg0__669_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T4"; res0__670_ ]
             | T5 arg0__671_ ->
               let res0__672_ = _of_a5_diff__662_ arg0__671_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T5"; res0__672_ ]
           : (a1__673_ -> Sexplib0.Sexp.t)
             -> (a2__674_ -> Sexplib0.Sexp.t)
             -> (a3__675_ -> Sexplib0.Sexp.t)
             -> (a4__676_ -> Sexplib0.Sexp.t)
             -> (a5__677_ -> Sexplib0.Sexp.t)
             -> (a1_diff__678_ -> Sexplib0.Sexp.t)
             -> (a2_diff__679_ -> Sexplib0.Sexp.t)
             -> (a3_diff__680_ -> Sexplib0.Sexp.t)
             -> (a4_diff__681_ -> Sexplib0.Sexp.t)
             -> (a5_diff__682_ -> Sexplib0.Sexp.t)
             -> ( a1__673_
                  , a2__674_
                  , a3__675_
                  , a4__676_
                  , a5__677_
                  , a1_diff__678_
                  , a2_diff__679_
                  , a3_diff__680_
                  , a4_diff__681_
                  , a5_diff__682_ )
                  t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:845:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a5"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ; Bin_prot.Shape.Vid.of_string "a5_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "T1"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:846:16")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")
                        ] )
                    ; ( "T2"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:847:16")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")
                        ] )
                    ; ( "T3"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:848:16")
                            (Bin_prot.Shape.Vid.of_string "a3_diff")
                        ] )
                    ; ( "T4"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:849:16")
                            (Bin_prot.Shape.Vid.of_string "a4_diff")
                        ] )
                    ; ( "T5"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:850:16")
                            (Bin_prot.Shape.Vid.of_string "a5_diff")
                        ] )
                    ] )
              ]
          in
          fun a1 a2 a3 a4 a5 a1_diff a2_diff a3_diff a4_diff a5_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a4; a5; a1_diff; a2_diff; a3_diff; a4_diff; a5_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff ->
            function
          | T1 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a1_diff v1)
          | T2 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a2_diff v1)
          | T3 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a3_diff v1)
          | T4 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a4_diff v1)
          | T5 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a5_diff v1)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            buf
            ~pos ->
            function
          | T1 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a1_diff buf ~pos v1
          | T2 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            _write_a2_diff buf ~pos v1
          | T3 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            _write_a3_diff buf ~pos v1
          | T4 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
            _write_a4_diff buf ~pos v1
          | T5 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
            _write_a5_diff buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a5
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff
             bin_writer_a5_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a5.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     bin_writer_a5_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a5.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     bin_writer_a5_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff )
                   t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            _buf
            ~pos_ref
            _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "tuples.ml.before-ppx.Tuple5.Diff.Entry_diff.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            buf
            ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a1_diff buf ~pos_ref in
            T1 arg_1
          | 1 ->
            let arg_1 = _of__a2_diff buf ~pos_ref in
            T2 arg_1
          | 2 ->
            let arg_1 = _of__a3_diff buf ~pos_ref in
            T3 arg_1
          | 3 ->
            let arg_1 = _of__a4_diff buf ~pos_ref in
            T4 arg_1
          | 4 ->
            let arg_1 = _of__a5_diff buf ~pos_ref in
            T5 arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "tuples.ml.before-ppx.Tuple5.Diff.Entry_diff.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a5
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff
             bin_reader_a5_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a5
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff
             bin_a5_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a5.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
                   bin_a5_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a5.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
                   bin_a5_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a5.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
                   bin_a5_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__716_
              _generator__717_
              _generator__718_
              _generator__719_
              _generator__720_
              _generator__721_
              _generator__722_
              _generator__723_
              _generator__724_
              _generator__725_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__726_ ~random:_random__727_ ->
                     T1
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__721_
                          ~size:_size__726_
                          ~random:_random__727_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__728_ ~random:_random__729_ ->
                     T2
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__722_
                          ~size:_size__728_
                          ~random:_random__729_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__730_ ~random:_random__731_ ->
                     T3
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__723_
                          ~size:_size__730_
                          ~random:_random__731_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__732_ ~random:_random__733_ ->
                     T4
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__724_
                          ~size:_size__732_
                          ~random:_random__733_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__734_ ~random:_random__735_ ->
                     T5
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__725_
                          ~size:_size__734_
                          ~random:_random__735_)) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__698_
              _observer__699_
              _observer__700_
              _observer__701_
              _observer__702_
              _observer__703_
              _observer__704_
              _observer__705_
              _observer__706_
              _observer__707_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__708_ ~size:_size__709_ ~hash:_hash__710_ ->
               match _x__708_ with
               | T1 _x__711_ ->
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__710_ 0
                 in
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__703_
                     _x__711_
                     ~size:_size__709_
                     ~hash:_hash__710_
                 in
                 _hash__710_
               | T2 _x__712_ ->
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__710_ 1
                 in
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__704_
                     _x__712_
                     ~size:_size__709_
                     ~hash:_hash__710_
                 in
                 _hash__710_
               | T3 _x__713_ ->
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__710_ 2
                 in
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__705_
                     _x__713_
                     ~size:_size__709_
                     ~hash:_hash__710_
                 in
                 _hash__710_
               | T4 _x__714_ ->
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__710_ 3
                 in
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__706_
                     _x__714_
                     ~size:_size__709_
                     ~hash:_hash__710_
                 in
                 _hash__710_
               | T5 _x__715_ ->
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__710_ 4
                 in
                 let _hash__710_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__707_
                     _x__715_
                     ~size:_size__709_
                     ~hash:_hash__710_
                 in
                 _hash__710_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__683_
              _shrinker__684_
              _shrinker__685_
              _shrinker__686_
              _shrinker__687_
              _shrinker__688_
              _shrinker__689_
              _shrinker__690_
              _shrinker__691_
              _shrinker__692_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | T1 _x__693_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__688_
                       _x__693_)
                    ~f:(fun _x__693_ -> T1 _x__693_)
                ]
            | T2 _x__694_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__689_
                       _x__694_)
                    ~f:(fun _x__694_ -> T2 _x__694_)
                ]
            | T3 _x__695_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__690_
                       _x__695_)
                    ~f:(fun _x__695_ -> T3 _x__695_)
                ]
            | T4 _x__696_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__691_
                       _x__696_)
                    ~f:(fun _x__696_ -> T4 _x__696_)
                ]
            | T5 _x__697_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__692_
                       _x__697_)
                    ~f:(fun _x__697_ -> T5 _x__697_)
                ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Entry_diff

    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
      ( 'a1
        , 'a2
        , 'a3
        , 'a4
        , 'a5
        , 'a1_diff
        , 'a2_diff
        , 'a3_diff
        , 'a4_diff
        , 'a5_diff )
        Entry_diff.t
        list
    [@@deriving sexp, bin_io, quickcheck]

    include struct
      let _ =
        fun (_ :
              ( 'a1
                , 'a2
                , 'a3
                , 'a4
                , 'a5
                , 'a1_diff
                , 'a2_diff
                , 'a3_diff
                , 'a4_diff
                , 'a5_diff )
                t) ->
        ()
      ;;

      let t_of_sexp
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> (Sexplib0.Sexp.t -> 'a5_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
        =
        fun _of_a1__736_
          _of_a2__737_
          _of_a3__738_
          _of_a4__739_
          _of_a5__740_
          _of_a1_diff__741_
          _of_a2_diff__742_
          _of_a3_diff__743_
          _of_a4_diff__744_
          _of_a5_diff__745_
          x__747_ ->
        list_of_sexp
          (Entry_diff.t_of_sexp
             _of_a1__736_
             _of_a2__737_
             _of_a3__738_
             _of_a4__739_
             _of_a5__740_
             _of_a1_diff__741_
             _of_a2_diff__742_
             _of_a3_diff__743_
             _of_a4_diff__744_
             _of_a5_diff__745_)
          x__747_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a5_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__748_
          _of_a2__749_
          _of_a3__750_
          _of_a4__751_
          _of_a5__752_
          _of_a1_diff__753_
          _of_a2_diff__754_
          _of_a3_diff__755_
          _of_a4_diff__756_
          _of_a5_diff__757_
          x__758_ ->
        sexp_of_list
          (Entry_diff.sexp_of_t
             _of_a1__748_
             _of_a2__749_
             _of_a3__750_
             _of_a4__751_
             _of_a5__752_
             _of_a1_diff__753_
             _of_a2_diff__754_
             _of_a3_diff__755_
             _of_a4_diff__756_
             _of_a5_diff__757_)
          x__758_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:856:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ; Bin_prot.Shape.Vid.of_string "a5"
                ; Bin_prot.Shape.Vid.of_string "a1_diff"
                ; Bin_prot.Shape.Vid.of_string "a2_diff"
                ; Bin_prot.Shape.Vid.of_string "a3_diff"
                ; Bin_prot.Shape.Vid.of_string "a4_diff"
                ; Bin_prot.Shape.Vid.of_string "a5_diff"
                ]
              , bin_shape_list
                  ((((((((((Entry_diff.bin_shape_t
                              (Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "tuples.ml.before-ppx:857:8")
                                 (Bin_prot.Shape.Vid.of_string "a1")))
                             (Bin_prot.Shape.var
                                (Bin_prot.Shape.Location.of_string
                                   "tuples.ml.before-ppx:858:8")
                                (Bin_prot.Shape.Vid.of_string "a2")))
                            (Bin_prot.Shape.var
                               (Bin_prot.Shape.Location.of_string
                                  "tuples.ml.before-ppx:859:8")
                               (Bin_prot.Shape.Vid.of_string "a3")))
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:860:8")
                              (Bin_prot.Shape.Vid.of_string "a4")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:861:8")
                             (Bin_prot.Shape.Vid.of_string "a5")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:862:8")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:863:8")
                           (Bin_prot.Shape.Vid.of_string "a2_diff")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:864:8")
                          (Bin_prot.Shape.Vid.of_string "a3_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:865:8")
                         (Bin_prot.Shape.Vid.of_string "a4_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:866:8")
                        (Bin_prot.Shape.Vid.of_string "a5_diff"))) )
            ]
        in
        fun a1 a2 a3 a4 a5 a1_diff a2_diff a3_diff a4_diff a5_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a4; a5; a1_diff; a2_diff; a3_diff; a4_diff; a5_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> 'a5_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Size.sizer
        =
        fun _size_of_a1
          _size_of_a2
          _size_of_a3
          _size_of_a4
          _size_of_a5
          _size_of_a1_diff
          _size_of_a2_diff
          _size_of_a3_diff
          _size_of_a4_diff
          _size_of_a5_diff
          v ->
        bin_size_list
          (Entry_diff.bin_size_t
             _size_of_a1
             _size_of_a2
             _size_of_a3
             _size_of_a4
             _size_of_a5
             _size_of_a1_diff
             _size_of_a2_diff
             _size_of_a3_diff
             _size_of_a4_diff
             _size_of_a5_diff)
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> 'a5_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Write.writer
        =
        fun _write_a1
          _write_a2
          _write_a3
          _write_a4
          _write_a5
          _write_a1_diff
          _write_a2_diff
          _write_a3_diff
          _write_a4_diff
          _write_a5_diff
          buf
          ~pos
          v ->
        bin_write_list
          (Entry_diff.bin_write_t
             _write_a1
             _write_a2
             _write_a3
             _write_a4
             _write_a5
             _write_a1_diff
             _write_a2_diff
             _write_a3_diff
             _write_a4_diff
             _write_a5_diff)
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1
           bin_writer_a2
           bin_writer_a3
           bin_writer_a4
           bin_writer_a5
           bin_writer_a1_diff
           bin_writer_a2_diff
           bin_writer_a3_diff
           bin_writer_a4_diff
           bin_writer_a5_diff ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   bin_writer_a5.size
                   bin_writer_a1_diff.size
                   bin_writer_a2_diff.size
                   bin_writer_a3_diff.size
                   bin_writer_a4_diff.size
                   bin_writer_a5_diff.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   bin_writer_a5.write
                   bin_writer_a1_diff.write
                   bin_writer_a2_diff.write
                   bin_writer_a3_diff.write
                   bin_writer_a4_diff.write
                   bin_writer_a5_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> (int
            -> ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 t)
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a5
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          _of__a5_diff
          buf
          ~pos_ref
          vint ->
        (__bin_read_list__
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a5
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff
              _of__a5_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a5
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          _of__a5_diff
          buf
          ~pos_ref ->
        (bin_read_list
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a5
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff
              _of__a5_diff))
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1
           bin_reader_a2
           bin_reader_a3
           bin_reader_a4
           bin_reader_a5
           bin_reader_a1_diff
           bin_reader_a2_diff
           bin_reader_a3_diff
           bin_reader_a4_diff
           bin_reader_a5_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read
                    bin_reader_a5_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read
                    bin_reader_a5_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1
           bin_a2
           bin_a3
           bin_a4
           bin_a5
           bin_a1_diff
           bin_a2_diff
           bin_a3_diff
           bin_a4_diff
           bin_a5_diff ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a4.writer
                 bin_a5.writer
                 bin_a1_diff.writer
                 bin_a2_diff.writer
                 bin_a3_diff.writer
                 bin_a4_diff.writer
                 bin_a5_diff.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a4.reader
                 bin_a5.reader
                 bin_a1_diff.reader
                 bin_a2_diff.reader
                 bin_a3_diff.reader
                 bin_a4_diff.reader
                 bin_a5_diff.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a4.shape
                 bin_a5.shape
                 bin_a1_diff.shape
                 bin_a2_diff.shape
                 bin_a3_diff.shape
                 bin_a4_diff.shape
                 bin_a5_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let quickcheck_generator
            _generator__779_
            _generator__780_
            _generator__781_
            _generator__782_
            _generator__783_
            _generator__784_
            _generator__785_
            _generator__786_
            _generator__787_
            _generator__788_
        =
        quickcheck_generator_list
          (Entry_diff.quickcheck_generator
             _generator__779_
             _generator__780_
             _generator__781_
             _generator__782_
             _generator__783_
             _generator__784_
             _generator__785_
             _generator__786_
             _generator__787_
             _generator__788_)
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer
            _observer__769_
            _observer__770_
            _observer__771_
            _observer__772_
            _observer__773_
            _observer__774_
            _observer__775_
            _observer__776_
            _observer__777_
            _observer__778_
        =
        quickcheck_observer_list
          (Entry_diff.quickcheck_observer
             _observer__769_
             _observer__770_
             _observer__771_
             _observer__772_
             _observer__773_
             _observer__774_
             _observer__775_
             _observer__776_
             _observer__777_
             _observer__778_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker
            _shrinker__759_
            _shrinker__760_
            _shrinker__761_
            _shrinker__762_
            _shrinker__763_
            _shrinker__764_
            _shrinker__765_
            _shrinker__766_
            _shrinker__767_
            _shrinker__768_
        =
        quickcheck_shrinker_list
          (Entry_diff.quickcheck_shrinker
             _shrinker__759_
             _shrinker__760_
             _shrinker__761_
             _shrinker__762_
             _shrinker__763_
             _shrinker__764_
             _shrinker__765_
             _shrinker__766_
             _shrinker__767_
             _shrinker__768_)
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare_rank t1 t2 =
      Int.compare (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let equal_rank t1 t2 =
      Int.equal (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let get get1 get2 get3 get4 get5 ~from ~to_ =
      if Base.phys_equal from to_
      then Optional_diff.none
      else (
        let from_1, from_2, from_3, from_4, from_5 = from in
        let to_1, to_2, to_3, to_4, to_5 = to_ in
        let diff = [] in
        let diff =
          let __ppx_optional_e_0 = get5 ~from:from_5 ~to_:to_5 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T5 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T5 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T4 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T4 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T3 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T3 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T2 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T2 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T1 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T1 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        match diff with
        | [] -> Optional_diff.none
        | _ :: _ -> Optional_diff.return diff)
    ;;

    let apply_exn apply1_exn apply2_exn apply3_exn apply4_exn apply5_exn derived_on diff =
      let derived_on1, derived_on2, derived_on3, derived_on4, derived_on5 = derived_on in
      let t1, diff =
        match diff with
        | T1 d :: tl -> apply1_exn derived_on1 d, tl
        | _ -> derived_on1, diff
      in
      let t2, diff =
        match diff with
        | T2 d :: tl -> apply2_exn derived_on2 d, tl
        | _ -> derived_on2, diff
      in
      let t3, diff =
        match diff with
        | T3 d :: tl -> apply3_exn derived_on3 d, tl
        | _ -> derived_on3, diff
      in
      let t4, diff =
        match diff with
        | T4 d :: tl -> apply4_exn derived_on4 d, tl
        | _ -> derived_on4, diff
      in
      let t5, diff =
        match diff with
        | T5 d :: tl -> apply5_exn derived_on5 d, tl
        | _ -> derived_on5, diff
      in
      match diff with
      | [] -> t1, t2, t3, t4, t5
      | _ :: _ -> failwith "BUG: non-empty diff after apply"
    ;;

    let of_list_exn
          of_list1_exn
          _apply1_exn
          of_list2_exn
          _apply2_exn
          of_list3_exn
          _apply3_exn
          of_list4_exn
          _apply4_exn
          of_list5_exn
          _apply5_exn
          ts
      =
      match ts with
      | [] -> Optional_diff.none
      | _ :: _ ->
        (match List.stable_sort ~compare:compare_rank (List.concat ts) with
         | [] -> Optional_diff.return []
         | _ :: _ as diff ->
           let rec loop acc = function
             | [] -> List.rev acc
             | T1 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T1 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T1 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list1_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T1 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T1 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T2 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T2 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T2 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list2_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T2 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T2 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T3 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T3 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T3 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list3_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T3 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T3 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T4 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T4 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T4 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list4_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T4 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T4 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T5 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T5 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T5 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list5_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T5 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T5 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
           in
           Optional_diff.return (loop [] diff))
    ;;

    let singleton entry_diff = [ entry_diff ]

    let t_of_sexp
          a1_of_sexp
          a2_of_sexp
          a3_of_sexp
          a4_of_sexp
          a5_of_sexp
          a1_diff_of_sexp
          a2_diff_of_sexp
          a3_diff_of_sexp
          a4_diff_of_sexp
          a5_diff_of_sexp
          sexp
      =
      let l =
        List.sort
          ~compare:compare_rank
          (t_of_sexp
             a1_of_sexp
             a2_of_sexp
             a3_of_sexp
             a4_of_sexp
             a5_of_sexp
             a1_diff_of_sexp
             a2_diff_of_sexp
             a3_diff_of_sexp
             a4_diff_of_sexp
             a5_diff_of_sexp
             sexp)
      in
      match List.find_consecutive_duplicate l ~equal:equal_rank with
      | None -> l
      | Some (dup, _) ->
        failwith ("Duplicate entry in tuple diff: " ^ Entry_diff.Variants.to_name dup)
    ;;

    let create ?t1 ?t2 ?t3 ?t4 ?t5 () =
      let diff = [] in
      let diff =
        match t5 with
        | None -> diff
        | Some d -> T5 d :: diff
      in
      let diff =
        match t4 with
        | None -> diff
        | Some d -> T4 d :: diff
      in
      let diff =
        match t3 with
        | None -> diff
        | Some d -> T3 d :: diff
      in
      let diff =
        match t2 with
        | None -> diff
        | Some d -> T2 d :: diff
      in
      let diff =
        match t1 with
        | None -> diff
        | Some d -> T1 d :: diff
      in
      diff
    ;;

    let create_of_variants ~t1 ~t2 ~t3 ~t4 ~t5 =
      let diff = [] in
      let diff =
        let __ppx_optional_e_0 = t5 Entry_diff.Variants.t5 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T5 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T5 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t4 Entry_diff.Variants.t4 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T4 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T4 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t3 Entry_diff.Variants.t3 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T3 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T3 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t2 Entry_diff.Variants.t2 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T2 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T2 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t1 Entry_diff.Variants.t1 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T1 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T1 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      diff
    ;;
  end

  module For_inlined_tuple = struct
    type ('a1, 'a2, 'a3, 'a4, 'a5) t =
      'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t * 'a5 Gel.t
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a3, 'a4, 'a5) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a3 'a4 'a5.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t
        =
        let error_source__806_ = "tuples.ml.before-ppx.Tuple5.For_inlined_tuple.t" in
        fun _of_a1__789_ _of_a2__790_ _of_a3__791_ _of_a4__792_ _of_a5__793_ -> function
          | Sexplib0.Sexp.List
              [ arg0__795_; arg1__796_; arg2__797_; arg3__798_; arg4__799_ ] ->
            let res0__800_ = Gel.t_of_sexp _of_a1__789_ arg0__795_
            and res1__801_ = Gel.t_of_sexp _of_a2__790_ arg1__796_
            and res2__802_ = Gel.t_of_sexp _of_a3__791_ arg2__797_
            and res3__803_ = Gel.t_of_sexp _of_a4__792_ arg3__798_
            and res4__804_ = Gel.t_of_sexp _of_a5__793_ arg4__799_ in
            res0__800_, res1__801_, res2__802_, res3__803_, res4__804_
          | sexp__805_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__806_
              5
              sexp__805_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4 'a5.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__807_
          _of_a2__808_
          _of_a3__809_
          _of_a4__810_
          _of_a5__811_
          (arg0__812_, arg1__813_, arg2__814_, arg3__815_, arg4__816_) ->
        let res0__817_ = Gel.sexp_of_t _of_a1__807_ arg0__812_
        and res1__818_ = Gel.sexp_of_t _of_a2__808_ arg1__813_
        and res2__819_ = Gel.sexp_of_t _of_a3__809_ arg2__814_
        and res3__820_ = Gel.sexp_of_t _of_a4__810_ arg3__815_
        and res4__821_ = Gel.sexp_of_t _of_a5__811_ arg4__816_ in
        Sexplib0.Sexp.List [ res0__817_; res1__818_; res2__819_; res3__820_; res4__821_ ]
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1141:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ; Bin_prot.Shape.Vid.of_string "a5"
                ]
              , Bin_prot.Shape.tuple
                  [ Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1142:6")
                         (Bin_prot.Shape.Vid.of_string "a1"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1142:18")
                         (Bin_prot.Shape.Vid.of_string "a2"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1142:30")
                         (Bin_prot.Shape.Vid.of_string "a3"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1142:42")
                         (Bin_prot.Shape.Vid.of_string "a4"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1142:54")
                         (Bin_prot.Shape.Vid.of_string "a5"))
                  ] )
            ]
        in
        fun a1 a2 a3 a4 a5 ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a4; a5 ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4 'a5.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 _size_of_a5 -> function
        | v1, v2, v3, v4, v5 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a1 v1) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a2 v2) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a3 v3) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a4 v4) in
          Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a5 v5)
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4 'a5.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 _write_a3 _write_a4 _write_a5 buf ~pos -> function
        | v1, v2, v3, v4, v5 ->
          let pos = Gel.bin_write_t _write_a1 buf ~pos v1 in
          let pos = Gel.bin_write_t _write_a2 buf ~pos v2 in
          let pos = Gel.bin_write_t _write_a3 buf ~pos v3 in
          let pos = Gel.bin_write_t _write_a4 buf ~pos v4 in
          Gel.bin_write_t _write_a5 buf ~pos v5
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1 bin_writer_a2 bin_writer_a3 bin_writer_a4 bin_writer_a5 ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   bin_writer_a5.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   bin_writer_a5.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4 'a5.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "tuples.ml.before-ppx.Tuple5.For_inlined_tuple.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4 'a5.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 buf ~pos_ref ->
        let v1 = (Gel.bin_read_t _of__a1) buf ~pos_ref in
        let v2 = (Gel.bin_read_t _of__a2) buf ~pos_ref in
        let v3 = (Gel.bin_read_t _of__a3) buf ~pos_ref in
        let v4 = (Gel.bin_read_t _of__a4) buf ~pos_ref in
        let v5 = (Gel.bin_read_t _of__a5) buf ~pos_ref in
        v1, v2, v3, v4, v5
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1 bin_reader_a2 bin_reader_a3 bin_reader_a4 bin_reader_a5 ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a3 bin_a4 bin_a5 ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a4.writer
                 bin_a5.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a4.reader
                 bin_a5.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a4.shape
                 bin_a5.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff = struct
      type ('a1, 'a2, 'a3, 'a4, 'a5) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5) t

      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
        ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include struct
        let _ =
          fun (_ :
                ( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff )
                  t) ->
          ()
        ;;

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          =
          fun _of_a1__822_
            _of_a2__823_
            _of_a3__824_
            _of_a4__825_
            _of_a5__826_
            _of_a1_diff__827_
            _of_a2_diff__828_
            _of_a3_diff__829_
            _of_a4_diff__830_
            _of_a5_diff__831_
            x__833_ ->
          Diff.t_of_sexp
            _of_a1__822_
            _of_a2__823_
            _of_a3__824_
            _of_a4__825_
            _of_a5__826_
            _of_a1_diff__827_
            _of_a2_diff__828_
            _of_a3_diff__829_
            _of_a4_diff__830_
            _of_a5_diff__831_
            x__833_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> Sexplib0.Sexp.t
          =
          fun _of_a1__834_
            _of_a2__835_
            _of_a3__836_
            _of_a4__837_
            _of_a5__838_
            _of_a1_diff__839_
            _of_a2_diff__840_
            _of_a3_diff__841_
            _of_a4_diff__842_
            _of_a5_diff__843_
            x__844_ ->
          Diff.sexp_of_t
            _of_a1__834_
            _of_a2__835_
            _of_a3__836_
            _of_a4__837_
            _of_a5__838_
            _of_a1_diff__839_
            _of_a2_diff__840_
            _of_a3_diff__841_
            _of_a4_diff__842_
            _of_a5_diff__843_
            x__844_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1148:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a5"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ; Bin_prot.Shape.Vid.of_string "a5_diff"
                  ]
                , (((((((((Diff.bin_shape_t
                             (Bin_prot.Shape.var
                                (Bin_prot.Shape.Location.of_string
                                   "tuples.ml.before-ppx:1149:9")
                                (Bin_prot.Shape.Vid.of_string "a1")))
                            (Bin_prot.Shape.var
                               (Bin_prot.Shape.Location.of_string
                                  "tuples.ml.before-ppx:1149:14")
                               (Bin_prot.Shape.Vid.of_string "a2")))
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:1149:19")
                              (Bin_prot.Shape.Vid.of_string "a3")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:1149:24")
                             (Bin_prot.Shape.Vid.of_string "a4")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1149:29")
                            (Bin_prot.Shape.Vid.of_string "a5")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:1149:34")
                           (Bin_prot.Shape.Vid.of_string "a1_diff")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:1149:44")
                          (Bin_prot.Shape.Vid.of_string "a2_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1149:54")
                         (Bin_prot.Shape.Vid.of_string "a3_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1149:64")
                        (Bin_prot.Shape.Vid.of_string "a4_diff")))
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1149:74")
                       (Bin_prot.Shape.Vid.of_string "a5_diff")) )
              ]
          in
          fun a1 a2 a3 a4 a5 a1_diff a2_diff a3_diff a4_diff a5_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1; a2; a3; a4; a5; a1_diff; a2_diff; a3_diff; a4_diff; a5_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff
            v ->
          Diff.bin_size_t
            _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff
            v
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            buf
            ~pos
            v ->
          Diff.bin_write_t
            _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            buf
            ~pos
            v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a5
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff
             bin_writer_a5_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a5.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     bin_writer_a5_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a5.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     bin_writer_a5_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff )
                   t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            buf
            ~pos_ref
            vint ->
          (Diff.__bin_read_t__
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a5
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff
             _of__a5_diff)
            buf
            ~pos_ref
            vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a5 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            buf
            ~pos_ref ->
          (Diff.bin_read_t
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a5
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff
             _of__a5_diff)
            buf
            ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a5
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff
             bin_reader_a5_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a5
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff
             bin_a5_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a5.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
                   bin_a5_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a5.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
                   bin_a5_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a5.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
                   bin_a5_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__865_
              _generator__866_
              _generator__867_
              _generator__868_
              _generator__869_
              _generator__870_
              _generator__871_
              _generator__872_
              _generator__873_
              _generator__874_
          =
          Diff.quickcheck_generator
            _generator__865_
            _generator__866_
            _generator__867_
            _generator__868_
            _generator__869_
            _generator__870_
            _generator__871_
            _generator__872_
            _generator__873_
            _generator__874_
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__855_
              _observer__856_
              _observer__857_
              _observer__858_
              _observer__859_
              _observer__860_
              _observer__861_
              _observer__862_
              _observer__863_
              _observer__864_
          =
          Diff.quickcheck_observer
            _observer__855_
            _observer__856_
            _observer__857_
            _observer__858_
            _observer__859_
            _observer__860_
            _observer__861_
            _observer__862_
            _observer__863_
            _observer__864_
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__845_
              _shrinker__846_
              _shrinker__847_
              _shrinker__848_
              _shrinker__849_
              _shrinker__850_
              _shrinker__851_
              _shrinker__852_
              _shrinker__853_
              _shrinker__854_
          =
          Diff.quickcheck_shrinker
            _shrinker__845_
            _shrinker__846_
            _shrinker__847_
            _shrinker__848_
            _shrinker__849_
            _shrinker__850_
            _shrinker__851_
            _shrinker__852_
            _shrinker__853_
            _shrinker__854_
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open Diff
      open Entry_diff

      let get get1 get2 get3 get4 get5 ~from ~to_ =
        if Base.phys_equal from to_
        then Optional_diff.none
        else (
          let ( { Gel.g = from_1 }
              , { Gel.g = from_2 }
              , { Gel.g = from_3 }
              , { Gel.g = from_4 }
              , { Gel.g = from_5 } )
            =
            from
          in
          let ( { Gel.g = to_1 }
              , { Gel.g = to_2 }
              , { Gel.g = to_3 }
              , { Gel.g = to_4 }
              , { Gel.g = to_5 } )
            =
            to_
          in
          let diff = [] in
          let diff =
            let __ppx_optional_e_0 = get5 ~from:from_5 ~to_:to_5 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T5 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T5 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T4 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T4 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T3 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T3 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T2 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T2 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T1 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T1 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          match diff with
          | [] -> Optional_diff.none
          | _ :: _ -> Optional_diff.return diff)
      ;;

      let apply_exn apply1_exn apply2_exn apply3_exn apply4_exn apply5_exn derived_on diff
        =
        let ( { Gel.g = derived_on1 }
            , { Gel.g = derived_on2 }
            , { Gel.g = derived_on3 }
            , { Gel.g = derived_on4 }
            , { Gel.g = derived_on5 } )
          =
          derived_on
        in
        let t1, diff =
          match diff with
          | T1 d :: tl -> apply1_exn derived_on1 d, tl
          | _ -> derived_on1, diff
        in
        let t2, diff =
          match diff with
          | T2 d :: tl -> apply2_exn derived_on2 d, tl
          | _ -> derived_on2, diff
        in
        let t3, diff =
          match diff with
          | T3 d :: tl -> apply3_exn derived_on3 d, tl
          | _ -> derived_on3, diff
        in
        let t4, diff =
          match diff with
          | T4 d :: tl -> apply4_exn derived_on4 d, tl
          | _ -> derived_on4, diff
        in
        let t5, diff =
          match diff with
          | T5 d :: tl -> apply5_exn derived_on5 d, tl
          | _ -> derived_on5, diff
        in
        match diff with
        | [] ->
          { Gel.g = t1 }, { Gel.g = t2 }, { Gel.g = t3 }, { Gel.g = t4 }, { Gel.g = t5 }
        | _ :: _ -> failwith "BUG: non-empty diff after apply"
      ;;

      let of_list_exn = of_list_exn
    end
  end
end

module Tuple6 = struct
  type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t = 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6
  [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) -> ()

    let t_of_sexp
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> (Sexplib0.Sexp.t -> 'a5)
      -> (Sexplib0.Sexp.t -> 'a6)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
      =
      let error_source__895_ = "tuples.ml.before-ppx.Tuple6.t" in
      fun _of_a1__875_ _of_a2__876_ _of_a3__877_ _of_a4__878_ _of_a5__879_ _of_a6__880_ ->
        function
        | Sexplib0.Sexp.List
            [ arg0__882_; arg1__883_; arg2__884_; arg3__885_; arg4__886_; arg5__887_ ] ->
          let res0__888_ = _of_a1__875_ arg0__882_
          and res1__889_ = _of_a2__876_ arg1__883_
          and res2__890_ = _of_a3__877_ arg2__884_
          and res3__891_ = _of_a4__878_ arg3__885_
          and res4__892_ = _of_a5__879_ arg4__886_
          and res5__893_ = _of_a6__880_ arg5__887_ in
          res0__888_, res1__889_, res2__890_, res3__891_, res4__892_, res5__893_
        | sexp__894_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__895_
            6
            sexp__894_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a1__896_
        _of_a2__897_
        _of_a3__898_
        _of_a4__899_
        _of_a5__900_
        _of_a6__901_
        (arg0__902_, arg1__903_, arg2__904_, arg3__905_, arg4__906_, arg5__907_) ->
      let res0__908_ = _of_a1__896_ arg0__902_
      and res1__909_ = _of_a2__897_ arg1__903_
      and res2__910_ = _of_a3__898_ arg2__904_
      and res3__911_ = _of_a4__899_ arg3__905_
      and res4__912_ = _of_a5__900_ arg4__906_
      and res5__913_ = _of_a6__901_ arg5__907_ in
      Sexplib0.Sexp.List
        [ res0__908_; res1__909_; res2__910_; res3__911_; res4__912_; res5__913_ ]
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a1"
              ; Bin_prot.Shape.Vid.of_string "a2"
              ; Bin_prot.Shape.Vid.of_string "a3"
              ; Bin_prot.Shape.Vid.of_string "a4"
              ; Bin_prot.Shape.Vid.of_string "a5"
              ; Bin_prot.Shape.Vid.of_string "a6"
              ]
            , Bin_prot.Shape.tuple
                [ Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:42")
                    (Bin_prot.Shape.Vid.of_string "a1")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:48")
                    (Bin_prot.Shape.Vid.of_string "a2")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:54")
                    (Bin_prot.Shape.Vid.of_string "a3")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:60")
                    (Bin_prot.Shape.Vid.of_string "a4")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:66")
                    (Bin_prot.Shape.Vid.of_string "a5")
                ; Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1253:72")
                    (Bin_prot.Shape.Vid.of_string "a6")
                ] )
          ]
      in
      fun a1 a2 a3 a4 a5 a6 ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
          [ a1; a2; a3; a4; a5; a6 ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> 'a5 Bin_prot.Size.sizer
      -> 'a6 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Size.sizer
      =
      fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 _size_of_a5 _size_of_a6 ->
        function
      | v1, v2, v3, v4, v5, v6 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a1 v1) in
        let size = Bin_prot.Common.( + ) size (_size_of_a2 v2) in
        let size = Bin_prot.Common.( + ) size (_size_of_a3 v3) in
        let size = Bin_prot.Common.( + ) size (_size_of_a4 v4) in
        let size = Bin_prot.Common.( + ) size (_size_of_a5 v5) in
        Bin_prot.Common.( + ) size (_size_of_a6 v6)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> 'a5 Bin_prot.Write.writer
      -> 'a6 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Write.writer
      =
      fun _write_a1 _write_a2 _write_a3 _write_a4 _write_a5 _write_a6 buf ~pos -> function
      | v1, v2, v3, v4, v5, v6 ->
        let pos = _write_a1 buf ~pos v1 in
        let pos = _write_a2 buf ~pos v2 in
        let pos = _write_a3 buf ~pos v3 in
        let pos = _write_a4 buf ~pos v4 in
        let pos = _write_a5 buf ~pos v5 in
        _write_a6 buf ~pos v6
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a1
         bin_writer_a2
         bin_writer_a3
         bin_writer_a4
         bin_writer_a5
         bin_writer_a6 ->
         { size =
             (fun v ->
               bin_size_t
                 bin_writer_a1.size
                 bin_writer_a2.size
                 bin_writer_a3.size
                 bin_writer_a4.size
                 bin_writer_a5.size
                 bin_writer_a6.size
                 v)
         ; write =
             (fun v ->
               bin_write_t
                 bin_writer_a1.write
                 bin_writer_a2.write
                 bin_writer_a3.write
                 bin_writer_a4.write
                 bin_writer_a5.write
                 bin_writer_a6.write
                 v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> 'a6 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _of__a6 _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuples.ml.before-ppx.Tuple6.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a1 'a2 'a3 'a4 'a5 'a6.
         'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> 'a6 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Read.reader
      =
      fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _of__a6 buf ~pos_ref ->
      let v1 = _of__a1 buf ~pos_ref in
      let v2 = _of__a2 buf ~pos_ref in
      let v3 = _of__a3 buf ~pos_ref in
      let v4 = _of__a4 buf ~pos_ref in
      let v5 = _of__a5 buf ~pos_ref in
      let v6 = _of__a6 buf ~pos_ref in
      v1, v2, v3, v4, v5, v6
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a1
         bin_reader_a2
         bin_reader_a3
         bin_reader_a4
         bin_reader_a5
         bin_reader_a6 ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read
                  bin_reader_a5.read
                  bin_reader_a6.read)
                 buf
                 ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__
                  bin_reader_a1.read
                  bin_reader_a2.read
                  bin_reader_a3.read
                  bin_reader_a4.read
                  bin_reader_a5.read
                  bin_reader_a6.read)
                 buf
                 ~pos_ref
                 vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a1 bin_a2 bin_a3 bin_a4 bin_a5 bin_a6 ->
         { writer =
             bin_writer_t
               bin_a1.writer
               bin_a2.writer
               bin_a3.writer
               bin_a4.writer
               bin_a5.writer
               bin_a6.writer
         ; reader =
             bin_reader_t
               bin_a1.reader
               bin_a2.reader
               bin_a3.reader
               bin_a4.reader
               bin_a5.reader
               bin_a6.reader
         ; shape =
             bin_shape_t
               bin_a1.shape
               bin_a2.shape
               bin_a3.shape
               bin_a4.shape
               bin_a5.shape
               bin_a6.shape
         }
       : _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t
         -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = struct
    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

    module Entry_diff = struct
      type ('a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff)
           t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
        | T5 of 'a5_diff
        | T6 of 'a6_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include struct
        [@@@ocaml.warning "-60"]

        let _ =
          fun (_ :
                ( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a6
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff
                  , 'a6_diff )
                  t) ->
          ()
        ;;

        let t1 v0 = T1 v0
        let _ = t1
        let t2 v0 = T2 v0
        let _ = t2
        let t3 v0 = T3 v0
        let _ = t3
        let t4 v0 = T4 v0
        let _ = t4
        let t5 v0 = T5 v0
        let _ = t5
        let t6 v0 = T6 v0
        let _ = t6

        let is_t1 = function
          | T1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t1

        let is_t2 = function
          | T2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t2

        let is_t3 = function
          | T3 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t3

        let is_t4 = function
          | T4 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t4

        let is_t5 = function
          | T5 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t5

        let is_t6 = function
          | T6 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_t6

        let t1_val = function
          | T1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t1_val

        let t2_val = function
          | T2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t2_val

        let t3_val = function
          | T3 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t3_val

        let t4_val = function
          | T4 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t4_val

        let t5_val = function
          | T5 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t5_val

        let t6_val = function
          | T6 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = t6_val

        module Variants = struct
          let t1 = { Variantslib.Variant.name = "T1"; rank = 0; constructor = t1 }
          let _ = t1
          let t2 = { Variantslib.Variant.name = "T2"; rank = 1; constructor = t2 }
          let _ = t2
          let t3 = { Variantslib.Variant.name = "T3"; rank = 2; constructor = t3 }
          let _ = t3
          let t4 = { Variantslib.Variant.name = "T4"; rank = 3; constructor = t4 }
          let _ = t4
          let t5 = { Variantslib.Variant.name = "T5"; rank = 4; constructor = t5 }
          let _ = t5
          let t6 = { Variantslib.Variant.name = "T6"; rank = 5; constructor = t6 }
          let _ = t6

          let fold
                ~init:init__
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
                ~t6:t6_fun__
            =
            t6_fun__
              (t5_fun__ (t4_fun__ (t3_fun__ (t2_fun__ (t1_fun__ init__ t1) t2) t3) t4) t5)
              t6
          ;;

          let _ = fold

          let iter
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
                ~t6:t6_fun__
            =
            (t1_fun__ t1 : unit);
            (t2_fun__ t2 : unit);
            (t3_fun__ t3 : unit);
            (t4_fun__ t4 : unit);
            (t5_fun__ t5 : unit);
            (t6_fun__ t6 : unit)
          ;;

          let _ = iter

          let map
                t__
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
                ~t6:t6_fun__
            =
            match t__ with
            | T1 v0 -> t1_fun__ t1 v0
            | T2 v0 -> t2_fun__ t2 v0
            | T3 v0 -> t3_fun__ t3 v0
            | T4 v0 -> t4_fun__ t4 v0
            | T5 v0 -> t5_fun__ t5 v0
            | T6 v0 -> t6_fun__ t6 v0
          ;;

          let _ = map

          let make_matcher
                ~t1:t1_fun__
                ~t2:t2_fun__
                ~t3:t3_fun__
                ~t4:t4_fun__
                ~t5:t5_fun__
                ~t6:t6_fun__
                compile_acc__
            =
            let t1_gen__, compile_acc__ = t1_fun__ t1 compile_acc__ in
            let t2_gen__, compile_acc__ = t2_fun__ t2 compile_acc__ in
            let t3_gen__, compile_acc__ = t3_fun__ t3 compile_acc__ in
            let t4_gen__, compile_acc__ = t4_fun__ t4 compile_acc__ in
            let t5_gen__, compile_acc__ = t5_fun__ t5 compile_acc__ in
            let t6_gen__, compile_acc__ = t6_fun__ t6 compile_acc__ in
            ( map
                ~t1:(fun _ -> t1_gen__)
                ~t2:(fun _ -> t2_gen__)
                ~t3:(fun _ -> t3_gen__)
                ~t4:(fun _ -> t4_gen__)
                ~t5:(fun _ -> t5_gen__)
                ~t6:(fun _ -> t6_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | T1 _ -> 0
            | T2 _ -> 1
            | T3 _ -> 2
            | T4 _ -> 3
            | T5 _ -> 4
            | T6 _ -> 5
          ;;

          let _ = to_rank

          let to_name = function
            | T1 _ -> "T1"
            | T2 _ -> "T2"
            | T3 _ -> "T3"
            | T4 _ -> "T4"
            | T5 _ -> "T5"
            | T6 _ -> "T6"
          ;;

          let _ = to_name
          let descriptions = [ "T1", 1; "T2", 1; "T3", 1; "T4", 1; "T5", 1; "T6", 1 ]
          let _ = descriptions
        end

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a6)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> (Sexplib0.Sexp.t -> 'a6_diff)
          -> Sexplib0.Sexp.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          =
          fun (type a1__960_) ->
          fun (type a2__961_) ->
          fun (type a3__962_) ->
          fun (type a4__963_) ->
          fun (type a5__964_) ->
          fun (type a6__965_) ->
          fun (type a1_diff__966_) ->
          fun (type a2_diff__967_) ->
          fun (type a3_diff__968_) ->
          fun (type a4_diff__969_) ->
          fun (type a5_diff__970_) ->
          fun (type a6_diff__971_) ->
          (let error_source__928_ = "tuples.ml.before-ppx.Tuple6.Diff.Entry_diff.t" in
           fun _of_a1__914_
             _of_a2__915_
             _of_a3__916_
             _of_a4__917_
             _of_a5__918_
             _of_a6__919_
             _of_a1_diff__920_
             _of_a2_diff__921_
             _of_a3_diff__922_
             _of_a4_diff__923_
             _of_a5_diff__924_
             _of_a6_diff__925_ ->
             function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t1" | "T1") as _tag__931_) :: sexp_args__932_) as
               _sexp__930_ ->
               (match sexp_args__932_ with
                | arg0__933_ :: [] ->
                  let res0__934_ = _of_a1_diff__920_ arg0__933_ in
                  T1 res0__934_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__931_
                    _sexp__930_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t2" | "T2") as _tag__936_) :: sexp_args__937_) as
               _sexp__935_ ->
               (match sexp_args__937_ with
                | arg0__938_ :: [] ->
                  let res0__939_ = _of_a2_diff__921_ arg0__938_ in
                  T2 res0__939_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__936_
                    _sexp__935_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t3" | "T3") as _tag__941_) :: sexp_args__942_) as
               _sexp__940_ ->
               (match sexp_args__942_ with
                | arg0__943_ :: [] ->
                  let res0__944_ = _of_a3_diff__922_ arg0__943_ in
                  T3 res0__944_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__941_
                    _sexp__940_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t4" | "T4") as _tag__946_) :: sexp_args__947_) as
               _sexp__945_ ->
               (match sexp_args__947_ with
                | arg0__948_ :: [] ->
                  let res0__949_ = _of_a4_diff__923_ arg0__948_ in
                  T4 res0__949_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__946_
                    _sexp__945_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t5" | "T5") as _tag__951_) :: sexp_args__952_) as
               _sexp__950_ ->
               (match sexp_args__952_ with
                | arg0__953_ :: [] ->
                  let res0__954_ = _of_a5_diff__924_ arg0__953_ in
                  T5 res0__954_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__951_
                    _sexp__950_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("t6" | "T6") as _tag__956_) :: sexp_args__957_) as
               _sexp__955_ ->
               (match sexp_args__957_ with
                | arg0__958_ :: [] ->
                  let res0__959_ = _of_a6_diff__925_ arg0__958_ in
                  T6 res0__959_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__928_
                    _tag__956_
                    _sexp__955_)
             | Sexplib0.Sexp.Atom ("t1" | "T1") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.Atom ("t2" | "T2") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.Atom ("t3" | "T3") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.Atom ("t4" | "T4") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.Atom ("t5" | "T5") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.Atom ("t6" | "T6") as sexp__929_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__928_ sexp__929_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__927_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__928_
                 sexp__927_
             | Sexplib0.Sexp.List [] as sexp__927_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__928_
                 sexp__927_
             | sexp__927_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__928_ sexp__927_
           : (Sexplib0.Sexp.t -> a1__960_)
             -> (Sexplib0.Sexp.t -> a2__961_)
             -> (Sexplib0.Sexp.t -> a3__962_)
             -> (Sexplib0.Sexp.t -> a4__963_)
             -> (Sexplib0.Sexp.t -> a5__964_)
             -> (Sexplib0.Sexp.t -> a6__965_)
             -> (Sexplib0.Sexp.t -> a1_diff__966_)
             -> (Sexplib0.Sexp.t -> a2_diff__967_)
             -> (Sexplib0.Sexp.t -> a3_diff__968_)
             -> (Sexplib0.Sexp.t -> a4_diff__969_)
             -> (Sexplib0.Sexp.t -> a5_diff__970_)
             -> (Sexplib0.Sexp.t -> a6_diff__971_)
             -> Sexplib0.Sexp.t
             -> ( a1__960_
                  , a2__961_
                  , a3__962_
                  , a4__963_
                  , a5__964_
                  , a6__965_
                  , a1_diff__966_
                  , a2_diff__967_
                  , a3_diff__968_
                  , a4_diff__969_
                  , a5_diff__970_
                  , a6_diff__971_ )
                  t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a6 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a6_diff -> Sexplib0.Sexp.t)
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> Sexplib0.Sexp.t
          =
          fun (type a1__996_) ->
          fun (type a2__997_) ->
          fun (type a3__998_) ->
          fun (type a4__999_) ->
          fun (type a5__1000_) ->
          fun (type a6__1001_) ->
          fun (type a1_diff__1002_) ->
          fun (type a2_diff__1003_) ->
          fun (type a3_diff__1004_) ->
          fun (type a4_diff__1005_) ->
          fun (type a5_diff__1006_) ->
          fun (type a6_diff__1007_) ->
          (fun _of_a1__972_
             _of_a2__973_
             _of_a3__974_
             _of_a4__975_
             _of_a5__976_
             _of_a6__977_
             _of_a1_diff__978_
             _of_a2_diff__979_
             _of_a3_diff__980_
             _of_a4_diff__981_
             _of_a5_diff__982_
             _of_a6_diff__983_ ->
             function
             | T1 arg0__984_ ->
               let res0__985_ = _of_a1_diff__978_ arg0__984_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T1"; res0__985_ ]
             | T2 arg0__986_ ->
               let res0__987_ = _of_a2_diff__979_ arg0__986_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T2"; res0__987_ ]
             | T3 arg0__988_ ->
               let res0__989_ = _of_a3_diff__980_ arg0__988_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T3"; res0__989_ ]
             | T4 arg0__990_ ->
               let res0__991_ = _of_a4_diff__981_ arg0__990_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T4"; res0__991_ ]
             | T5 arg0__992_ ->
               let res0__993_ = _of_a5_diff__982_ arg0__992_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T5"; res0__993_ ]
             | T6 arg0__994_ ->
               let res0__995_ = _of_a6_diff__983_ arg0__994_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T6"; res0__995_ ]
           : (a1__996_ -> Sexplib0.Sexp.t)
             -> (a2__997_ -> Sexplib0.Sexp.t)
             -> (a3__998_ -> Sexplib0.Sexp.t)
             -> (a4__999_ -> Sexplib0.Sexp.t)
             -> (a5__1000_ -> Sexplib0.Sexp.t)
             -> (a6__1001_ -> Sexplib0.Sexp.t)
             -> (a1_diff__1002_ -> Sexplib0.Sexp.t)
             -> (a2_diff__1003_ -> Sexplib0.Sexp.t)
             -> (a3_diff__1004_ -> Sexplib0.Sexp.t)
             -> (a4_diff__1005_ -> Sexplib0.Sexp.t)
             -> (a5_diff__1006_ -> Sexplib0.Sexp.t)
             -> (a6_diff__1007_ -> Sexplib0.Sexp.t)
             -> ( a1__996_
                  , a2__997_
                  , a3__998_
                  , a4__999_
                  , a5__1000_
                  , a6__1001_
                  , a1_diff__1002_
                  , a2_diff__1003_
                  , a3_diff__1004_
                  , a4_diff__1005_
                  , a5_diff__1006_
                  , a6_diff__1007_ )
                  t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1260:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a5"
                  ; Bin_prot.Shape.Vid.of_string "a6"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ; Bin_prot.Shape.Vid.of_string "a5_diff"
                  ; Bin_prot.Shape.Vid.of_string "a6_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "T1"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1273:16")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")
                        ] )
                    ; ( "T2"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1274:16")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")
                        ] )
                    ; ( "T3"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1275:16")
                            (Bin_prot.Shape.Vid.of_string "a3_diff")
                        ] )
                    ; ( "T4"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1276:16")
                            (Bin_prot.Shape.Vid.of_string "a4_diff")
                        ] )
                    ; ( "T5"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1277:16")
                            (Bin_prot.Shape.Vid.of_string "a5_diff")
                        ] )
                    ; ( "T6"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1278:16")
                            (Bin_prot.Shape.Vid.of_string "a6_diff")
                        ] )
                    ] )
              ]
          in
          fun a1 a2 a3 a4 a5 a6 a1_diff a2_diff a3_diff a4_diff a5_diff a6_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1
              ; a2
              ; a3
              ; a4
              ; a5
              ; a6
              ; a1_diff
              ; a2_diff
              ; a3_diff
              ; a4_diff
              ; a5_diff
              ; a6_diff
              ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a6 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> 'a6_diff Bin_prot.Size.sizer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a6
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff
            _size_of_a6_diff ->
            function
          | T1 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a1_diff v1)
          | T2 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a2_diff v1)
          | T3 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a3_diff v1)
          | T4 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a4_diff v1)
          | T5 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a5_diff v1)
          | T6 v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a6_diff v1)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a6 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> 'a6_diff Bin_prot.Write.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a6
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            _write_a6_diff
            buf
            ~pos ->
            function
          | T1 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a1_diff buf ~pos v1
          | T2 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            _write_a2_diff buf ~pos v1
          | T3 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            _write_a3_diff buf ~pos v1
          | T4 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
            _write_a4_diff buf ~pos v1
          | T5 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
            _write_a5_diff buf ~pos v1
          | T6 v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 5 in
            _write_a6_diff buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a5
             bin_writer_a6
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff
             bin_writer_a5_diff
             bin_writer_a6_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a5.size
                     bin_writer_a6.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     bin_writer_a5_diff.size
                     bin_writer_a6_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a5.write
                     bin_writer_a6.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     bin_writer_a5_diff.write
                     bin_writer_a6_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a6
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff
                   , 'a6_diff )
                   t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a6
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            _of__a6_diff
            _buf
            ~pos_ref
            _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "tuples.ml.before-ppx.Tuple6.Diff.Entry_diff.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a6
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            _of__a6_diff
            buf
            ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a1_diff buf ~pos_ref in
            T1 arg_1
          | 1 ->
            let arg_1 = _of__a2_diff buf ~pos_ref in
            T2 arg_1
          | 2 ->
            let arg_1 = _of__a3_diff buf ~pos_ref in
            T3 arg_1
          | 3 ->
            let arg_1 = _of__a4_diff buf ~pos_ref in
            T4 arg_1
          | 4 ->
            let arg_1 = _of__a5_diff buf ~pos_ref in
            T5 arg_1
          | 5 ->
            let arg_1 = _of__a6_diff buf ~pos_ref in
            T6 arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "tuples.ml.before-ppx.Tuple6.Diff.Entry_diff.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a5
             bin_reader_a6
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff
             bin_reader_a5_diff
             bin_reader_a6_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a6.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read
                      bin_reader_a6_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a6.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read
                      bin_reader_a6_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a5
             bin_a6
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff
             bin_a5_diff
             bin_a6_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a5.writer
                   bin_a6.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
                   bin_a5_diff.writer
                   bin_a6_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a5.reader
                   bin_a6.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
                   bin_a5_diff.reader
                   bin_a6_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a5.shape
                   bin_a6.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
                   bin_a5_diff.shape
                   bin_a6_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__1047_
              _generator__1048_
              _generator__1049_
              _generator__1050_
              _generator__1051_
              _generator__1052_
              _generator__1053_
              _generator__1054_
              _generator__1055_
              _generator__1056_
              _generator__1057_
              _generator__1058_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1059_ ~random:_random__1060_ ->
                     T1
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1053_
                          ~size:_size__1059_
                          ~random:_random__1060_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1061_ ~random:_random__1062_ ->
                     T2
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1054_
                          ~size:_size__1061_
                          ~random:_random__1062_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1063_ ~random:_random__1064_ ->
                     T3
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1055_
                          ~size:_size__1063_
                          ~random:_random__1064_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1065_ ~random:_random__1066_ ->
                     T4
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1056_
                          ~size:_size__1065_
                          ~random:_random__1066_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1067_ ~random:_random__1068_ ->
                     T5
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1057_
                          ~size:_size__1067_
                          ~random:_random__1068_)) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__1069_ ~random:_random__1070_ ->
                     T6
                       (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                          _generator__1058_
                          ~size:_size__1069_
                          ~random:_random__1070_)) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__1026_
              _observer__1027_
              _observer__1028_
              _observer__1029_
              _observer__1030_
              _observer__1031_
              _observer__1032_
              _observer__1033_
              _observer__1034_
              _observer__1035_
              _observer__1036_
              _observer__1037_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__1038_ ~size:_size__1039_ ~hash:_hash__1040_ ->
               match _x__1038_ with
               | T1 _x__1041_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 0
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1032_
                     _x__1041_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_
               | T2 _x__1042_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 1
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1033_
                     _x__1042_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_
               | T3 _x__1043_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 2
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1034_
                     _x__1043_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_
               | T4 _x__1044_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 3
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1035_
                     _x__1044_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_
               | T5 _x__1045_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 4
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1036_
                     _x__1045_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_
               | T6 _x__1046_ ->
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__1040_ 5
                 in
                 let _hash__1040_ =
                   Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                     _observer__1037_
                     _x__1046_
                     ~size:_size__1039_
                     ~hash:_hash__1040_
                 in
                 _hash__1040_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__1008_
              _shrinker__1009_
              _shrinker__1010_
              _shrinker__1011_
              _shrinker__1012_
              _shrinker__1013_
              _shrinker__1014_
              _shrinker__1015_
              _shrinker__1016_
              _shrinker__1017_
              _shrinker__1018_
              _shrinker__1019_
          =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | T1 _x__1020_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1014_
                       _x__1020_)
                    ~f:(fun _x__1020_ -> T1 _x__1020_)
                ]
            | T2 _x__1021_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1015_
                       _x__1021_)
                    ~f:(fun _x__1021_ -> T2 _x__1021_)
                ]
            | T3 _x__1022_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1016_
                       _x__1022_)
                    ~f:(fun _x__1022_ -> T3 _x__1022_)
                ]
            | T4 _x__1023_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1017_
                       _x__1023_)
                    ~f:(fun _x__1023_ -> T4 _x__1023_)
                ]
            | T5 _x__1024_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1018_
                       _x__1024_)
                    ~f:(fun _x__1024_ -> T5 _x__1024_)
                ]
            | T6 _x__1025_ ->
              Ppx_quickcheck_runtime.Base.Sequence.round_robin
                [ Ppx_quickcheck_runtime.Base.Sequence.map
                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                       _shrinker__1019_
                       _x__1025_)
                    ~f:(fun _x__1025_ -> T6 _x__1025_)
                ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Entry_diff

    type ('a1
         , 'a2
         , 'a3
         , 'a4
         , 'a5
         , 'a6
         , 'a1_diff
         , 'a2_diff
         , 'a3_diff
         , 'a4_diff
         , 'a5_diff
         , 'a6_diff)
         t =
      ( 'a1
        , 'a2
        , 'a3
        , 'a4
        , 'a5
        , 'a6
        , 'a1_diff
        , 'a2_diff
        , 'a3_diff
        , 'a4_diff
        , 'a5_diff
        , 'a6_diff )
        Entry_diff.t
        list
    [@@deriving sexp, bin_io, quickcheck]

    include struct
      let _ =
        fun (_ :
              ( 'a1
                , 'a2
                , 'a3
                , 'a4
                , 'a5
                , 'a6
                , 'a1_diff
                , 'a2_diff
                , 'a3_diff
                , 'a4_diff
                , 'a5_diff
                , 'a6_diff )
                t) ->
        ()
      ;;

      let t_of_sexp
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a6)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> (Sexplib0.Sexp.t -> 'a5_diff)
        -> (Sexplib0.Sexp.t -> 'a6_diff)
        -> Sexplib0.Sexp.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
        =
        fun _of_a1__1071_
          _of_a2__1072_
          _of_a3__1073_
          _of_a4__1074_
          _of_a5__1075_
          _of_a6__1076_
          _of_a1_diff__1077_
          _of_a2_diff__1078_
          _of_a3_diff__1079_
          _of_a4_diff__1080_
          _of_a5_diff__1081_
          _of_a6_diff__1082_
          x__1084_ ->
        list_of_sexp
          (Entry_diff.t_of_sexp
             _of_a1__1071_
             _of_a2__1072_
             _of_a3__1073_
             _of_a4__1074_
             _of_a5__1075_
             _of_a6__1076_
             _of_a1_diff__1077_
             _of_a2_diff__1078_
             _of_a3_diff__1079_
             _of_a4_diff__1080_
             _of_a5_diff__1081_
             _of_a6_diff__1082_)
          x__1084_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a6 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a5_diff -> Sexplib0.Sexp.t)
        -> ('a6_diff -> Sexplib0.Sexp.t)
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__1085_
          _of_a2__1086_
          _of_a3__1087_
          _of_a4__1088_
          _of_a5__1089_
          _of_a6__1090_
          _of_a1_diff__1091_
          _of_a2_diff__1092_
          _of_a3_diff__1093_
          _of_a4_diff__1094_
          _of_a5_diff__1095_
          _of_a6_diff__1096_
          x__1097_ ->
        sexp_of_list
          (Entry_diff.sexp_of_t
             _of_a1__1085_
             _of_a2__1086_
             _of_a3__1087_
             _of_a4__1088_
             _of_a5__1089_
             _of_a6__1090_
             _of_a1_diff__1091_
             _of_a2_diff__1092_
             _of_a3_diff__1093_
             _of_a4_diff__1094_
             _of_a5_diff__1095_
             _of_a6_diff__1096_)
          x__1097_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1284:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ; Bin_prot.Shape.Vid.of_string "a5"
                ; Bin_prot.Shape.Vid.of_string "a6"
                ; Bin_prot.Shape.Vid.of_string "a1_diff"
                ; Bin_prot.Shape.Vid.of_string "a2_diff"
                ; Bin_prot.Shape.Vid.of_string "a3_diff"
                ; Bin_prot.Shape.Vid.of_string "a4_diff"
                ; Bin_prot.Shape.Vid.of_string "a5_diff"
                ; Bin_prot.Shape.Vid.of_string "a6_diff"
                ]
              , bin_shape_list
                  ((((((((((((Entry_diff.bin_shape_t
                                (Bin_prot.Shape.var
                                   (Bin_prot.Shape.Location.of_string
                                      "tuples.ml.before-ppx:1297:8")
                                   (Bin_prot.Shape.Vid.of_string "a1")))
                               (Bin_prot.Shape.var
                                  (Bin_prot.Shape.Location.of_string
                                     "tuples.ml.before-ppx:1298:8")
                                  (Bin_prot.Shape.Vid.of_string "a2")))
                              (Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "tuples.ml.before-ppx:1299:8")
                                 (Bin_prot.Shape.Vid.of_string "a3")))
                             (Bin_prot.Shape.var
                                (Bin_prot.Shape.Location.of_string
                                   "tuples.ml.before-ppx:1300:8")
                                (Bin_prot.Shape.Vid.of_string "a4")))
                            (Bin_prot.Shape.var
                               (Bin_prot.Shape.Location.of_string
                                  "tuples.ml.before-ppx:1301:8")
                               (Bin_prot.Shape.Vid.of_string "a5")))
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:1302:8")
                              (Bin_prot.Shape.Vid.of_string "a6")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:1303:8")
                             (Bin_prot.Shape.Vid.of_string "a1_diff")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1304:8")
                            (Bin_prot.Shape.Vid.of_string "a2_diff")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:1305:8")
                           (Bin_prot.Shape.Vid.of_string "a3_diff")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:1306:8")
                          (Bin_prot.Shape.Vid.of_string "a4_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1307:8")
                         (Bin_prot.Shape.Vid.of_string "a5_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1308:8")
                        (Bin_prot.Shape.Vid.of_string "a6_diff"))) )
            ]
        in
        fun a1 a2 a3 a4 a5 a6 a1_diff a2_diff a3_diff a4_diff a5_diff a6_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1
            ; a2
            ; a3
            ; a4
            ; a5
            ; a6
            ; a1_diff
            ; a2_diff
            ; a3_diff
            ; a4_diff
            ; a5_diff
            ; a6_diff
            ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a6 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> 'a5_diff Bin_prot.Size.sizer
        -> 'a6_diff Bin_prot.Size.sizer
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Size.sizer
        =
        fun _size_of_a1
          _size_of_a2
          _size_of_a3
          _size_of_a4
          _size_of_a5
          _size_of_a6
          _size_of_a1_diff
          _size_of_a2_diff
          _size_of_a3_diff
          _size_of_a4_diff
          _size_of_a5_diff
          _size_of_a6_diff
          v ->
        bin_size_list
          (Entry_diff.bin_size_t
             _size_of_a1
             _size_of_a2
             _size_of_a3
             _size_of_a4
             _size_of_a5
             _size_of_a6
             _size_of_a1_diff
             _size_of_a2_diff
             _size_of_a3_diff
             _size_of_a4_diff
             _size_of_a5_diff
             _size_of_a6_diff)
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a6 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> 'a5_diff Bin_prot.Write.writer
        -> 'a6_diff Bin_prot.Write.writer
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Write.writer
        =
        fun _write_a1
          _write_a2
          _write_a3
          _write_a4
          _write_a5
          _write_a6
          _write_a1_diff
          _write_a2_diff
          _write_a3_diff
          _write_a4_diff
          _write_a5_diff
          _write_a6_diff
          buf
          ~pos
          v ->
        bin_write_list
          (Entry_diff.bin_write_t
             _write_a1
             _write_a2
             _write_a3
             _write_a4
             _write_a5
             _write_a6
             _write_a1_diff
             _write_a2_diff
             _write_a3_diff
             _write_a4_diff
             _write_a5_diff
             _write_a6_diff)
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1
           bin_writer_a2
           bin_writer_a3
           bin_writer_a4
           bin_writer_a5
           bin_writer_a6
           bin_writer_a1_diff
           bin_writer_a2_diff
           bin_writer_a3_diff
           bin_writer_a4_diff
           bin_writer_a5_diff
           bin_writer_a6_diff ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   bin_writer_a5.size
                   bin_writer_a6.size
                   bin_writer_a1_diff.size
                   bin_writer_a2_diff.size
                   bin_writer_a3_diff.size
                   bin_writer_a4_diff.size
                   bin_writer_a5_diff.size
                   bin_writer_a6_diff.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   bin_writer_a5.write
                   bin_writer_a6.write
                   bin_writer_a1_diff.write
                   bin_writer_a2_diff.write
                   bin_writer_a3_diff.write
                   bin_writer_a4_diff.write
                   bin_writer_a5_diff.write
                   bin_writer_a6_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> 'a6_diff Bin_prot.Read.reader
        -> (int
            -> ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 t)
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a5
          _of__a6
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          _of__a5_diff
          _of__a6_diff
          buf
          ~pos_ref
          vint ->
        (__bin_read_list__
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a5
              _of__a6
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff
              _of__a5_diff
              _of__a6_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> 'a6_diff Bin_prot.Read.reader
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Read.reader
        =
        fun _of__a1
          _of__a2
          _of__a3
          _of__a4
          _of__a5
          _of__a6
          _of__a1_diff
          _of__a2_diff
          _of__a3_diff
          _of__a4_diff
          _of__a5_diff
          _of__a6_diff
          buf
          ~pos_ref ->
        (bin_read_list
           (Entry_diff.bin_read_t
              _of__a1
              _of__a2
              _of__a3
              _of__a4
              _of__a5
              _of__a6
              _of__a1_diff
              _of__a2_diff
              _of__a3_diff
              _of__a4_diff
              _of__a5_diff
              _of__a6_diff))
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1
           bin_reader_a2
           bin_reader_a3
           bin_reader_a4
           bin_reader_a5
           bin_reader_a6
           bin_reader_a1_diff
           bin_reader_a2_diff
           bin_reader_a3_diff
           bin_reader_a4_diff
           bin_reader_a5_diff
           bin_reader_a6_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a6.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read
                    bin_reader_a5_diff.read
                    bin_reader_a6_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a6.read
                    bin_reader_a1_diff.read
                    bin_reader_a2_diff.read
                    bin_reader_a3_diff.read
                    bin_reader_a4_diff.read
                    bin_reader_a5_diff.read
                    bin_reader_a6_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1
           bin_a2
           bin_a3
           bin_a4
           bin_a5
           bin_a6
           bin_a1_diff
           bin_a2_diff
           bin_a3_diff
           bin_a4_diff
           bin_a5_diff
           bin_a6_diff ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a4.writer
                 bin_a5.writer
                 bin_a6.writer
                 bin_a1_diff.writer
                 bin_a2_diff.writer
                 bin_a3_diff.writer
                 bin_a4_diff.writer
                 bin_a5_diff.writer
                 bin_a6_diff.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a4.reader
                 bin_a5.reader
                 bin_a6.reader
                 bin_a1_diff.reader
                 bin_a2_diff.reader
                 bin_a3_diff.reader
                 bin_a4_diff.reader
                 bin_a5_diff.reader
                 bin_a6_diff.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a4.shape
                 bin_a5.shape
                 bin_a6.shape
                 bin_a1_diff.shape
                 bin_a2_diff.shape
                 bin_a3_diff.shape
                 bin_a4_diff.shape
                 bin_a5_diff.shape
                 bin_a6_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let quickcheck_generator
            _generator__1122_
            _generator__1123_
            _generator__1124_
            _generator__1125_
            _generator__1126_
            _generator__1127_
            _generator__1128_
            _generator__1129_
            _generator__1130_
            _generator__1131_
            _generator__1132_
            _generator__1133_
        =
        quickcheck_generator_list
          (Entry_diff.quickcheck_generator
             _generator__1122_
             _generator__1123_
             _generator__1124_
             _generator__1125_
             _generator__1126_
             _generator__1127_
             _generator__1128_
             _generator__1129_
             _generator__1130_
             _generator__1131_
             _generator__1132_
             _generator__1133_)
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer
            _observer__1110_
            _observer__1111_
            _observer__1112_
            _observer__1113_
            _observer__1114_
            _observer__1115_
            _observer__1116_
            _observer__1117_
            _observer__1118_
            _observer__1119_
            _observer__1120_
            _observer__1121_
        =
        quickcheck_observer_list
          (Entry_diff.quickcheck_observer
             _observer__1110_
             _observer__1111_
             _observer__1112_
             _observer__1113_
             _observer__1114_
             _observer__1115_
             _observer__1116_
             _observer__1117_
             _observer__1118_
             _observer__1119_
             _observer__1120_
             _observer__1121_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker
            _shrinker__1098_
            _shrinker__1099_
            _shrinker__1100_
            _shrinker__1101_
            _shrinker__1102_
            _shrinker__1103_
            _shrinker__1104_
            _shrinker__1105_
            _shrinker__1106_
            _shrinker__1107_
            _shrinker__1108_
            _shrinker__1109_
        =
        quickcheck_shrinker_list
          (Entry_diff.quickcheck_shrinker
             _shrinker__1098_
             _shrinker__1099_
             _shrinker__1100_
             _shrinker__1101_
             _shrinker__1102_
             _shrinker__1103_
             _shrinker__1104_
             _shrinker__1105_
             _shrinker__1106_
             _shrinker__1107_
             _shrinker__1108_
             _shrinker__1109_)
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare_rank t1 t2 =
      Int.compare (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let equal_rank t1 t2 =
      Int.equal (Entry_diff.Variants.to_rank t1) (Entry_diff.Variants.to_rank t2)
    ;;

    let get get1 get2 get3 get4 get5 get6 ~from ~to_ =
      if Base.phys_equal from to_
      then Optional_diff.none
      else (
        let from_1, from_2, from_3, from_4, from_5, from_6 = from in
        let to_1, to_2, to_3, to_4, to_5, to_6 = to_ in
        let diff = [] in
        let diff =
          let __ppx_optional_e_0 = get6 ~from:from_6 ~to_:to_6 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T6 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T6 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get5 ~from:from_5 ~to_:to_5 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T5 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T5 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T4 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T4 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T3 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T3 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T2 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T2 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        let diff =
          let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
          if false
          then (
            (match
               if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               then None
               else
                 Some
                   (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                      __ppx_optional_e_0)
             with
             | None -> diff
             | Some d -> T1 d :: diff)
            [@merlin.focus])
          else (
            (match
               Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             with
             | (true [@merlin.hide]) -> diff
             | (false [@merlin.hide]) ->
               let d : _ =
                 Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                   __ppx_optional_e_0
               in
               T1 d :: diff)
            [@merlin.hide] [@ocaml.warning "-a"])
        in
        match diff with
        | [] -> Optional_diff.none
        | _ :: _ -> Optional_diff.return diff)
    ;;

    let apply_exn
          apply1_exn
          apply2_exn
          apply3_exn
          apply4_exn
          apply5_exn
          apply6_exn
          derived_on
          diff
      =
      let derived_on1, derived_on2, derived_on3, derived_on4, derived_on5, derived_on6 =
        derived_on
      in
      let t1, diff =
        match diff with
        | T1 d :: tl -> apply1_exn derived_on1 d, tl
        | _ -> derived_on1, diff
      in
      let t2, diff =
        match diff with
        | T2 d :: tl -> apply2_exn derived_on2 d, tl
        | _ -> derived_on2, diff
      in
      let t3, diff =
        match diff with
        | T3 d :: tl -> apply3_exn derived_on3 d, tl
        | _ -> derived_on3, diff
      in
      let t4, diff =
        match diff with
        | T4 d :: tl -> apply4_exn derived_on4 d, tl
        | _ -> derived_on4, diff
      in
      let t5, diff =
        match diff with
        | T5 d :: tl -> apply5_exn derived_on5 d, tl
        | _ -> derived_on5, diff
      in
      let t6, diff =
        match diff with
        | T6 d :: tl -> apply6_exn derived_on6 d, tl
        | _ -> derived_on6, diff
      in
      match diff with
      | [] -> t1, t2, t3, t4, t5, t6
      | _ :: _ -> failwith "BUG: non-empty diff after apply"
    ;;

    let of_list_exn
          of_list1_exn
          _apply1_exn
          of_list2_exn
          _apply2_exn
          of_list3_exn
          _apply3_exn
          of_list4_exn
          _apply4_exn
          of_list5_exn
          _apply5_exn
          of_list6_exn
          _apply6_exn
          ts
      =
      match ts with
      | [] -> Optional_diff.none
      | _ :: _ ->
        (match List.stable_sort ~compare:compare_rank (List.concat ts) with
         | [] -> Optional_diff.return []
         | _ :: _ as diff ->
           let rec loop acc = function
             | [] -> List.rev acc
             | T1 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T1 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T1 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list1_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T1 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T1 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T2 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T2 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T2 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list2_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T2 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T2 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T3 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T3 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T3 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list3_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T3 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T3 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T4 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T4 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T4 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list4_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T4 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T4 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T5 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T5 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T5 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list5_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T5 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T5 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
             | T6 d :: tl ->
               let ds, tl =
                 List.split_while tl ~f:(function
                   | T6 _ -> true
                   | _ -> false)
               in
               let ds =
                 List.map ds ~f:(function
                   | T6 x -> x
                   | _ -> assert false)
               in
               let __ppx_optional_e_0 = of_list6_exn (d :: ds) in
               if false
               then (
                 (match
                    if
                      Optional_diff.Optional_syntax.Optional_syntax.is_none
                        __ppx_optional_e_0
                    then None
                    else
                      Some
                        (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                           __ppx_optional_e_0)
                  with
                  | None -> loop acc tl
                  | Some d -> loop (T6 d :: acc) tl)
                 [@merlin.focus])
               else (
                 (match
                    Optional_diff.Optional_syntax.Optional_syntax.is_none
                      __ppx_optional_e_0
                  with
                  | (true [@merlin.hide]) -> loop acc tl
                  | (false [@merlin.hide]) ->
                    let d : _ =
                      Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0
                    in
                    loop (T6 d :: acc) tl)
                 [@merlin.hide] [@ocaml.warning "-a"])
           in
           Optional_diff.return (loop [] diff))
    ;;

    let singleton entry_diff = [ entry_diff ]

    let t_of_sexp
          a1_of_sexp
          a2_of_sexp
          a3_of_sexp
          a4_of_sexp
          a5_of_sexp
          a6_of_sexp
          a1_diff_of_sexp
          a2_diff_of_sexp
          a3_diff_of_sexp
          a4_diff_of_sexp
          a5_diff_of_sexp
          a6_diff_of_sexp
          sexp
      =
      let l =
        List.sort
          ~compare:compare_rank
          (t_of_sexp
             a1_of_sexp
             a2_of_sexp
             a3_of_sexp
             a4_of_sexp
             a5_of_sexp
             a6_of_sexp
             a1_diff_of_sexp
             a2_diff_of_sexp
             a3_diff_of_sexp
             a4_diff_of_sexp
             a5_diff_of_sexp
             a6_diff_of_sexp
             sexp)
      in
      match List.find_consecutive_duplicate l ~equal:equal_rank with
      | None -> l
      | Some (dup, _) ->
        failwith ("Duplicate entry in tuple diff: " ^ Entry_diff.Variants.to_name dup)
    ;;

    let create ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 () =
      let diff = [] in
      let diff =
        match t6 with
        | None -> diff
        | Some d -> T6 d :: diff
      in
      let diff =
        match t5 with
        | None -> diff
        | Some d -> T5 d :: diff
      in
      let diff =
        match t4 with
        | None -> diff
        | Some d -> T4 d :: diff
      in
      let diff =
        match t3 with
        | None -> diff
        | Some d -> T3 d :: diff
      in
      let diff =
        match t2 with
        | None -> diff
        | Some d -> T2 d :: diff
      in
      let diff =
        match t1 with
        | None -> diff
        | Some d -> T1 d :: diff
      in
      diff
    ;;

    let create_of_variants ~t1 ~t2 ~t3 ~t4 ~t5 ~t6 =
      let diff = [] in
      let diff =
        let __ppx_optional_e_0 = t6 Entry_diff.Variants.t6 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T6 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T6 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t5 Entry_diff.Variants.t5 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T5 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T5 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t4 Entry_diff.Variants.t4 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T4 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T4 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t3 Entry_diff.Variants.t3 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T3 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T3 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t2 Entry_diff.Variants.t2 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T2 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T2 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      let diff =
        let __ppx_optional_e_0 = t1 Entry_diff.Variants.t1 in
        if false
        then (
          (match
             if Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
             then None
             else
               Some
                 (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                    __ppx_optional_e_0)
           with
           | None -> diff
           | Some d -> T1 d :: diff)
          [@merlin.focus])
        else (
          (match
             Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
           with
           | (true [@merlin.hide]) -> diff
           | (false [@merlin.hide]) ->
             let d : _ =
               Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                 __ppx_optional_e_0
             in
             T1 d :: diff)
          [@merlin.hide] [@ocaml.warning "-a"])
      in
      diff
    ;;
  end

  module For_inlined_tuple = struct
    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t =
      'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t * 'a5 Gel.t * 'a6 Gel.t
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) -> ()

      let t_of_sexp
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a6)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
        =
        let error_source__1154_ = "tuples.ml.before-ppx.Tuple6.For_inlined_tuple.t" in
        fun _of_a1__1134_
          _of_a2__1135_
          _of_a3__1136_
          _of_a4__1137_
          _of_a5__1138_
          _of_a6__1139_ ->
          function
          | Sexplib0.Sexp.List
              [ arg0__1141_
              ; arg1__1142_
              ; arg2__1143_
              ; arg3__1144_
              ; arg4__1145_
              ; arg5__1146_
              ] ->
            let res0__1147_ = Gel.t_of_sexp _of_a1__1134_ arg0__1141_
            and res1__1148_ = Gel.t_of_sexp _of_a2__1135_ arg1__1142_
            and res2__1149_ = Gel.t_of_sexp _of_a3__1136_ arg2__1143_
            and res3__1150_ = Gel.t_of_sexp _of_a4__1137_ arg3__1144_
            and res4__1151_ = Gel.t_of_sexp _of_a5__1138_ arg4__1145_
            and res5__1152_ = Gel.t_of_sexp _of_a6__1139_ arg5__1146_ in
            res0__1147_, res1__1148_, res2__1149_, res3__1150_, res4__1151_, res5__1152_
          | sexp__1153_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__1154_
              6
              sexp__1153_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a6 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a1__1155_
          _of_a2__1156_
          _of_a3__1157_
          _of_a4__1158_
          _of_a5__1159_
          _of_a6__1160_
          (arg0__1161_, arg1__1162_, arg2__1163_, arg3__1164_, arg4__1165_, arg5__1166_) ->
        let res0__1167_ = Gel.sexp_of_t _of_a1__1155_ arg0__1161_
        and res1__1168_ = Gel.sexp_of_t _of_a2__1156_ arg1__1162_
        and res2__1169_ = Gel.sexp_of_t _of_a3__1157_ arg2__1163_
        and res3__1170_ = Gel.sexp_of_t _of_a4__1158_ arg3__1164_
        and res4__1171_ = Gel.sexp_of_t _of_a5__1159_ arg4__1165_
        and res5__1172_ = Gel.sexp_of_t _of_a6__1160_ arg5__1166_ in
        Sexplib0.Sexp.List
          [ res0__1167_; res1__1168_; res2__1169_; res3__1170_; res4__1171_; res5__1172_ ]
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1634:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a1"
                ; Bin_prot.Shape.Vid.of_string "a2"
                ; Bin_prot.Shape.Vid.of_string "a3"
                ; Bin_prot.Shape.Vid.of_string "a4"
                ; Bin_prot.Shape.Vid.of_string "a5"
                ; Bin_prot.Shape.Vid.of_string "a6"
                ]
              , Bin_prot.Shape.tuple
                  [ Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1635:6")
                         (Bin_prot.Shape.Vid.of_string "a1"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1635:18")
                         (Bin_prot.Shape.Vid.of_string "a2"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1635:30")
                         (Bin_prot.Shape.Vid.of_string "a3"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1635:42")
                         (Bin_prot.Shape.Vid.of_string "a4"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1635:54")
                         (Bin_prot.Shape.Vid.of_string "a5"))
                  ; Gel.bin_shape_t
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1635:66")
                         (Bin_prot.Shape.Vid.of_string "a6"))
                  ] )
            ]
        in
        fun a1 a2 a3 a4 a5 a6 ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ a1; a2; a3; a4; a5; a6 ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a6 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Size.sizer
        =
        fun _size_of_a1 _size_of_a2 _size_of_a3 _size_of_a4 _size_of_a5 _size_of_a6 ->
          function
        | v1, v2, v3, v4, v5, v6 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a1 v1) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a2 v2) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a3 v3) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a4 v4) in
          let size = Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a5 v5) in
          Bin_prot.Common.( + ) size (Gel.bin_size_t _size_of_a6 v6)
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a6 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Write.writer
        =
        fun _write_a1 _write_a2 _write_a3 _write_a4 _write_a5 _write_a6 buf ~pos ->
          function
        | v1, v2, v3, v4, v5, v6 ->
          let pos = Gel.bin_write_t _write_a1 buf ~pos v1 in
          let pos = Gel.bin_write_t _write_a2 buf ~pos v2 in
          let pos = Gel.bin_write_t _write_a3 buf ~pos v3 in
          let pos = Gel.bin_write_t _write_a4 buf ~pos v4 in
          let pos = Gel.bin_write_t _write_a5 buf ~pos v5 in
          Gel.bin_write_t _write_a6 buf ~pos v6
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a1
           bin_writer_a2
           bin_writer_a3
           bin_writer_a4
           bin_writer_a5
           bin_writer_a6 ->
           { size =
               (fun v ->
                 bin_size_t
                   bin_writer_a1.size
                   bin_writer_a2.size
                   bin_writer_a3.size
                   bin_writer_a4.size
                   bin_writer_a5.size
                   bin_writer_a6.size
                   v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_a1.write
                   bin_writer_a2.write
                   bin_writer_a3.write
                   bin_writer_a4.write
                   bin_writer_a5.write
                   bin_writer_a6.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _of__a6 _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "tuples.ml.before-ppx.Tuple6.For_inlined_tuple.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a1 'a2 'a3 'a4 'a5 'a6.
           'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Read.reader
        =
        fun _of__a1 _of__a2 _of__a3 _of__a4 _of__a5 _of__a6 buf ~pos_ref ->
        let v1 = (Gel.bin_read_t _of__a1) buf ~pos_ref in
        let v2 = (Gel.bin_read_t _of__a2) buf ~pos_ref in
        let v3 = (Gel.bin_read_t _of__a3) buf ~pos_ref in
        let v4 = (Gel.bin_read_t _of__a4) buf ~pos_ref in
        let v5 = (Gel.bin_read_t _of__a5) buf ~pos_ref in
        let v6 = (Gel.bin_read_t _of__a6) buf ~pos_ref in
        v1, v2, v3, v4, v5, v6
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a1
           bin_reader_a2
           bin_reader_a3
           bin_reader_a4
           bin_reader_a5
           bin_reader_a6 ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a6.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_a1.read
                    bin_reader_a2.read
                    bin_reader_a3.read
                    bin_reader_a4.read
                    bin_reader_a5.read
                    bin_reader_a6.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a1 bin_a2 bin_a3 bin_a4 bin_a5 bin_a6 ->
           { writer =
               bin_writer_t
                 bin_a1.writer
                 bin_a2.writer
                 bin_a3.writer
                 bin_a4.writer
                 bin_a5.writer
                 bin_a6.writer
           ; reader =
               bin_reader_t
                 bin_a1.reader
                 bin_a2.reader
                 bin_a3.reader
                 bin_a4.reader
                 bin_a5.reader
                 bin_a6.reader
           ; shape =
               bin_shape_t
                 bin_a1.shape
                 bin_a2.shape
                 bin_a3.shape
                 bin_a4.shape
                 bin_a5.shape
                 bin_a6.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff = struct
      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

      type ('a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff)
           t =
        ( 'a1
          , 'a2
          , 'a3
          , 'a4
          , 'a5
          , 'a6
          , 'a1_diff
          , 'a2_diff
          , 'a3_diff
          , 'a4_diff
          , 'a5_diff
          , 'a6_diff )
          Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include struct
        let _ =
          fun (_ :
                ( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a6
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff
                  , 'a6_diff )
                  t) ->
          ()
        ;;

        let t_of_sexp
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a6)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> (Sexplib0.Sexp.t -> 'a6_diff)
          -> Sexplib0.Sexp.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          =
          fun _of_a1__1173_
            _of_a2__1174_
            _of_a3__1175_
            _of_a4__1176_
            _of_a5__1177_
            _of_a6__1178_
            _of_a1_diff__1179_
            _of_a2_diff__1180_
            _of_a3_diff__1181_
            _of_a4_diff__1182_
            _of_a5_diff__1183_
            _of_a6_diff__1184_
            x__1186_ ->
          Diff.t_of_sexp
            _of_a1__1173_
            _of_a2__1174_
            _of_a3__1175_
            _of_a4__1176_
            _of_a5__1177_
            _of_a6__1178_
            _of_a1_diff__1179_
            _of_a2_diff__1180_
            _of_a3_diff__1181_
            _of_a4_diff__1182_
            _of_a5_diff__1183_
            _of_a6_diff__1184_
            x__1186_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a6 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a6_diff -> Sexplib0.Sexp.t)
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> Sexplib0.Sexp.t
          =
          fun _of_a1__1187_
            _of_a2__1188_
            _of_a3__1189_
            _of_a4__1190_
            _of_a5__1191_
            _of_a6__1192_
            _of_a1_diff__1193_
            _of_a2_diff__1194_
            _of_a3_diff__1195_
            _of_a4_diff__1196_
            _of_a5_diff__1197_
            _of_a6_diff__1198_
            x__1199_ ->
          Diff.sexp_of_t
            _of_a1__1187_
            _of_a2__1188_
            _of_a3__1189_
            _of_a4__1190_
            _of_a5__1191_
            _of_a6__1192_
            _of_a1_diff__1193_
            _of_a2_diff__1194_
            _of_a3_diff__1195_
            _of_a4_diff__1196_
            _of_a5_diff__1197_
            _of_a6_diff__1198_
            x__1199_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1641:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a1"
                  ; Bin_prot.Shape.Vid.of_string "a2"
                  ; Bin_prot.Shape.Vid.of_string "a3"
                  ; Bin_prot.Shape.Vid.of_string "a4"
                  ; Bin_prot.Shape.Vid.of_string "a5"
                  ; Bin_prot.Shape.Vid.of_string "a6"
                  ; Bin_prot.Shape.Vid.of_string "a1_diff"
                  ; Bin_prot.Shape.Vid.of_string "a2_diff"
                  ; Bin_prot.Shape.Vid.of_string "a3_diff"
                  ; Bin_prot.Shape.Vid.of_string "a4_diff"
                  ; Bin_prot.Shape.Vid.of_string "a5_diff"
                  ; Bin_prot.Shape.Vid.of_string "a6_diff"
                  ]
                , (((((((((((Diff.bin_shape_t
                               (Bin_prot.Shape.var
                                  (Bin_prot.Shape.Location.of_string
                                     "tuples.ml.before-ppx:1654:10")
                                  (Bin_prot.Shape.Vid.of_string "a1")))
                              (Bin_prot.Shape.var
                                 (Bin_prot.Shape.Location.of_string
                                    "tuples.ml.before-ppx:1655:10")
                                 (Bin_prot.Shape.Vid.of_string "a2")))
                             (Bin_prot.Shape.var
                                (Bin_prot.Shape.Location.of_string
                                   "tuples.ml.before-ppx:1656:10")
                                (Bin_prot.Shape.Vid.of_string "a3")))
                            (Bin_prot.Shape.var
                               (Bin_prot.Shape.Location.of_string
                                  "tuples.ml.before-ppx:1657:10")
                               (Bin_prot.Shape.Vid.of_string "a4")))
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "tuples.ml.before-ppx:1658:10")
                              (Bin_prot.Shape.Vid.of_string "a5")))
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "tuples.ml.before-ppx:1659:10")
                             (Bin_prot.Shape.Vid.of_string "a6")))
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "tuples.ml.before-ppx:1660:10")
                            (Bin_prot.Shape.Vid.of_string "a1_diff")))
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "tuples.ml.before-ppx:1661:10")
                           (Bin_prot.Shape.Vid.of_string "a2_diff")))
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "tuples.ml.before-ppx:1662:10")
                          (Bin_prot.Shape.Vid.of_string "a3_diff")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "tuples.ml.before-ppx:1663:10")
                         (Bin_prot.Shape.Vid.of_string "a4_diff")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1664:10")
                        (Bin_prot.Shape.Vid.of_string "a5_diff")))
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "tuples.ml.before-ppx:1665:10")
                       (Bin_prot.Shape.Vid.of_string "a6_diff")) )
              ]
          in
          fun a1 a2 a3 a4 a5 a6 a1_diff a2_diff a3_diff a4_diff a5_diff a6_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ a1
              ; a2
              ; a3
              ; a4
              ; a5
              ; a6
              ; a1_diff
              ; a2_diff
              ; a3_diff
              ; a4_diff
              ; a5_diff
              ; a6_diff
              ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a6 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> 'a6_diff Bin_prot.Size.sizer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Size.sizer
          =
          fun _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a6
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff
            _size_of_a6_diff
            v ->
          Diff.bin_size_t
            _size_of_a1
            _size_of_a2
            _size_of_a3
            _size_of_a4
            _size_of_a5
            _size_of_a6
            _size_of_a1_diff
            _size_of_a2_diff
            _size_of_a3_diff
            _size_of_a4_diff
            _size_of_a5_diff
            _size_of_a6_diff
            v
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a6 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> 'a6_diff Bin_prot.Write.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Write.writer
          =
          fun _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a6
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            _write_a6_diff
            buf
            ~pos
            v ->
          Diff.bin_write_t
            _write_a1
            _write_a2
            _write_a3
            _write_a4
            _write_a5
            _write_a6
            _write_a1_diff
            _write_a2_diff
            _write_a3_diff
            _write_a4_diff
            _write_a5_diff
            _write_a6_diff
            buf
            ~pos
            v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a1
             bin_writer_a2
             bin_writer_a3
             bin_writer_a4
             bin_writer_a5
             bin_writer_a6
             bin_writer_a1_diff
             bin_writer_a2_diff
             bin_writer_a3_diff
             bin_writer_a4_diff
             bin_writer_a5_diff
             bin_writer_a6_diff ->
             { size =
                 (fun v ->
                   bin_size_t
                     bin_writer_a1.size
                     bin_writer_a2.size
                     bin_writer_a3.size
                     bin_writer_a4.size
                     bin_writer_a5.size
                     bin_writer_a6.size
                     bin_writer_a1_diff.size
                     bin_writer_a2_diff.size
                     bin_writer_a3_diff.size
                     bin_writer_a4_diff.size
                     bin_writer_a5_diff.size
                     bin_writer_a6_diff.size
                     v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_a1.write
                     bin_writer_a2.write
                     bin_writer_a3.write
                     bin_writer_a4.write
                     bin_writer_a5.write
                     bin_writer_a6.write
                     bin_writer_a1_diff.write
                     bin_writer_a2_diff.write
                     bin_writer_a3_diff.write
                     bin_writer_a4_diff.write
                     bin_writer_a5_diff.write
                     bin_writer_a6_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a6
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff
                   , 'a6_diff )
                   t)
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a6
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            _of__a6_diff
            buf
            ~pos_ref
            vint ->
          (Diff.__bin_read_t__
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a5
             _of__a6
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff
             _of__a5_diff
             _of__a6_diff)
            buf
            ~pos_ref
            vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'a1 'a2 'a3 'a4 'a5 'a6 'a1_diff 'a2_diff 'a3_diff 'a4_diff 'a5_diff 'a6_diff.
             'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Read.reader
          =
          fun _of__a1
            _of__a2
            _of__a3
            _of__a4
            _of__a5
            _of__a6
            _of__a1_diff
            _of__a2_diff
            _of__a3_diff
            _of__a4_diff
            _of__a5_diff
            _of__a6_diff
            buf
            ~pos_ref ->
          (Diff.bin_read_t
             _of__a1
             _of__a2
             _of__a3
             _of__a4
             _of__a5
             _of__a6
             _of__a1_diff
             _of__a2_diff
             _of__a3_diff
             _of__a4_diff
             _of__a5_diff
             _of__a6_diff)
            buf
            ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a1
             bin_reader_a2
             bin_reader_a3
             bin_reader_a4
             bin_reader_a5
             bin_reader_a6
             bin_reader_a1_diff
             bin_reader_a2_diff
             bin_reader_a3_diff
             bin_reader_a4_diff
             bin_reader_a5_diff
             bin_reader_a6_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a6.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read
                      bin_reader_a6_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_a1.read
                      bin_reader_a2.read
                      bin_reader_a3.read
                      bin_reader_a4.read
                      bin_reader_a5.read
                      bin_reader_a6.read
                      bin_reader_a1_diff.read
                      bin_reader_a2_diff.read
                      bin_reader_a3_diff.read
                      bin_reader_a4_diff.read
                      bin_reader_a5_diff.read
                      bin_reader_a6_diff.read)
                     buf
                     ~pos_ref
                     vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a1
             bin_a2
             bin_a3
             bin_a4
             bin_a5
             bin_a6
             bin_a1_diff
             bin_a2_diff
             bin_a3_diff
             bin_a4_diff
             bin_a5_diff
             bin_a6_diff ->
             { writer =
                 bin_writer_t
                   bin_a1.writer
                   bin_a2.writer
                   bin_a3.writer
                   bin_a4.writer
                   bin_a5.writer
                   bin_a6.writer
                   bin_a1_diff.writer
                   bin_a2_diff.writer
                   bin_a3_diff.writer
                   bin_a4_diff.writer
                   bin_a5_diff.writer
                   bin_a6_diff.writer
             ; reader =
                 bin_reader_t
                   bin_a1.reader
                   bin_a2.reader
                   bin_a3.reader
                   bin_a4.reader
                   bin_a5.reader
                   bin_a6.reader
                   bin_a1_diff.reader
                   bin_a2_diff.reader
                   bin_a3_diff.reader
                   bin_a4_diff.reader
                   bin_a5_diff.reader
                   bin_a6_diff.reader
             ; shape =
                 bin_shape_t
                   bin_a1.shape
                   bin_a2.shape
                   bin_a3.shape
                   bin_a4.shape
                   bin_a5.shape
                   bin_a6.shape
                   bin_a1_diff.shape
                   bin_a2_diff.shape
                   bin_a3_diff.shape
                   bin_a4_diff.shape
                   bin_a5_diff.shape
                   bin_a6_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let quickcheck_generator
              _generator__1224_
              _generator__1225_
              _generator__1226_
              _generator__1227_
              _generator__1228_
              _generator__1229_
              _generator__1230_
              _generator__1231_
              _generator__1232_
              _generator__1233_
              _generator__1234_
              _generator__1235_
          =
          Diff.quickcheck_generator
            _generator__1224_
            _generator__1225_
            _generator__1226_
            _generator__1227_
            _generator__1228_
            _generator__1229_
            _generator__1230_
            _generator__1231_
            _generator__1232_
            _generator__1233_
            _generator__1234_
            _generator__1235_
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer
              _observer__1212_
              _observer__1213_
              _observer__1214_
              _observer__1215_
              _observer__1216_
              _observer__1217_
              _observer__1218_
              _observer__1219_
              _observer__1220_
              _observer__1221_
              _observer__1222_
              _observer__1223_
          =
          Diff.quickcheck_observer
            _observer__1212_
            _observer__1213_
            _observer__1214_
            _observer__1215_
            _observer__1216_
            _observer__1217_
            _observer__1218_
            _observer__1219_
            _observer__1220_
            _observer__1221_
            _observer__1222_
            _observer__1223_
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker
              _shrinker__1200_
              _shrinker__1201_
              _shrinker__1202_
              _shrinker__1203_
              _shrinker__1204_
              _shrinker__1205_
              _shrinker__1206_
              _shrinker__1207_
              _shrinker__1208_
              _shrinker__1209_
              _shrinker__1210_
              _shrinker__1211_
          =
          Diff.quickcheck_shrinker
            _shrinker__1200_
            _shrinker__1201_
            _shrinker__1202_
            _shrinker__1203_
            _shrinker__1204_
            _shrinker__1205_
            _shrinker__1206_
            _shrinker__1207_
            _shrinker__1208_
            _shrinker__1209_
            _shrinker__1210_
            _shrinker__1211_
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open Diff
      open Entry_diff

      let get get1 get2 get3 get4 get5 get6 ~from ~to_ =
        if Base.phys_equal from to_
        then Optional_diff.none
        else (
          let ( { Gel.g = from_1 }
              , { Gel.g = from_2 }
              , { Gel.g = from_3 }
              , { Gel.g = from_4 }
              , { Gel.g = from_5 }
              , { Gel.g = from_6 } )
            =
            from
          in
          let ( { Gel.g = to_1 }
              , { Gel.g = to_2 }
              , { Gel.g = to_3 }
              , { Gel.g = to_4 }
              , { Gel.g = to_5 }
              , { Gel.g = to_6 } )
            =
            to_
          in
          let diff = [] in
          let diff =
            let __ppx_optional_e_0 = get6 ~from:from_6 ~to_:to_6 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T6 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T6 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get5 ~from:from_5 ~to_:to_5 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T5 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T5 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get4 ~from:from_4 ~to_:to_4 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T4 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T4 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get3 ~from:from_3 ~to_:to_3 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T3 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T3 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get2 ~from:from_2 ~to_:to_2 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T2 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T2 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          let diff =
            let __ppx_optional_e_0 = get1 ~from:from_1 ~to_:to_1 in
            if false
            then (
              (match
                 if
                   Optional_diff.Optional_syntax.Optional_syntax.is_none
                     __ppx_optional_e_0
                 then None
                 else
                   Some
                     (Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                        __ppx_optional_e_0)
               with
               | None -> diff
               | Some d -> T1 d :: diff)
              [@merlin.focus])
            else (
              (match
                 Optional_diff.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
               with
               | (true [@merlin.hide]) -> diff
               | (false [@merlin.hide]) ->
                 let d : _ =
                   Optional_diff.Optional_syntax.Optional_syntax.unsafe_value
                     __ppx_optional_e_0
                 in
                 T1 d :: diff)
              [@merlin.hide] [@ocaml.warning "-a"])
          in
          match diff with
          | [] -> Optional_diff.none
          | _ :: _ -> Optional_diff.return diff)
      ;;

      let apply_exn
            apply1_exn
            apply2_exn
            apply3_exn
            apply4_exn
            apply5_exn
            apply6_exn
            derived_on
            diff
        =
        let ( { Gel.g = derived_on1 }
            , { Gel.g = derived_on2 }
            , { Gel.g = derived_on3 }
            , { Gel.g = derived_on4 }
            , { Gel.g = derived_on5 }
            , { Gel.g = derived_on6 } )
          =
          derived_on
        in
        let t1, diff =
          match diff with
          | T1 d :: tl -> apply1_exn derived_on1 d, tl
          | _ -> derived_on1, diff
        in
        let t2, diff =
          match diff with
          | T2 d :: tl -> apply2_exn derived_on2 d, tl
          | _ -> derived_on2, diff
        in
        let t3, diff =
          match diff with
          | T3 d :: tl -> apply3_exn derived_on3 d, tl
          | _ -> derived_on3, diff
        in
        let t4, diff =
          match diff with
          | T4 d :: tl -> apply4_exn derived_on4 d, tl
          | _ -> derived_on4, diff
        in
        let t5, diff =
          match diff with
          | T5 d :: tl -> apply5_exn derived_on5 d, tl
          | _ -> derived_on5, diff
        in
        let t6, diff =
          match diff with
          | T6 d :: tl -> apply6_exn derived_on6 d, tl
          | _ -> derived_on6, diff
        in
        match diff with
        | [] ->
          ( { Gel.g = t1 }
          , { Gel.g = t2 }
          , { Gel.g = t3 }
          , { Gel.g = t4 }
          , { Gel.g = t5 }
          , { Gel.g = t6 } )
        | _ :: _ -> failwith "BUG: non-empty diff after apply"
      ;;

      let of_list_exn = of_list_exn
    end
  end
end

let max_supported = Diffable_cinaps.Tuple_helpers.max_supported
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
