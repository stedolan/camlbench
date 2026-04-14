let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"map_diff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "map_diff.ml.before-ppx"
;;

open Base
open Bin_prot.Std
open Stable_witness.Export

module Stable = struct
  module V1 = struct
    module Change = struct
      type ('k, 'v, 'v_diff) t =
        | Remove of 'k
        | Add of 'k * 'v
        | Diff of 'k * 'v_diff
      [@@deriving sexp, bin_io, stable_witness]

      include struct
        let _ = fun (_ : ('k, 'v, 'v_diff) t) -> ()

        let t_of_sexp
          :  'k 'v 'v_diff.
             (Sexplib0.Sexp.t -> 'k)
          -> (Sexplib0.Sexp.t -> 'v)
          -> (Sexplib0.Sexp.t -> 'v_diff)
          -> Sexplib0.Sexp.t
          -> ('k, 'v, 'v_diff) t
          =
          fun (type k__027_) ->
          fun (type v__028_) ->
          fun (type v_diff__029_) ->
          (let error_source__006_ = "map_diff.ml.before-ppx.Stable.V1.Change.t" in
           fun _of_k__001_ _of_v__002_ _of_v_diff__003_ -> function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("remove" | "Remove") as _tag__009_)
                 :: sexp_args__010_) as _sexp__008_ ->
               (match sexp_args__010_ with
                | arg0__011_ :: [] ->
                  let res0__012_ = _of_k__001_ arg0__011_ in
                  Remove res0__012_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__006_
                    _tag__009_
                    _sexp__008_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("add" | "Add") as _tag__014_) :: sexp_args__015_)
               as _sexp__013_ ->
               (match sexp_args__015_ with
                | [ arg0__016_; arg1__017_ ] ->
                  let res0__018_ = _of_k__001_ arg0__016_
                  and res1__019_ = _of_v__002_ arg1__017_ in
                  Add (res0__018_, res1__019_)
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__006_
                    _tag__014_
                    _sexp__013_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("diff" | "Diff") as _tag__021_) :: sexp_args__022_)
               as _sexp__020_ ->
               (match sexp_args__022_ with
                | [ arg0__023_; arg1__024_ ] ->
                  let res0__025_ = _of_k__001_ arg0__023_
                  and res1__026_ = _of_v_diff__003_ arg1__024_ in
                  Diff (res0__025_, res1__026_)
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__006_
                    _tag__021_
                    _sexp__020_)
             | Sexplib0.Sexp.Atom ("remove" | "Remove") as sexp__007_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__006_ sexp__007_
             | Sexplib0.Sexp.Atom ("add" | "Add") as sexp__007_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__006_ sexp__007_
             | Sexplib0.Sexp.Atom ("diff" | "Diff") as sexp__007_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__006_ sexp__007_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__005_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__006_
                 sexp__005_
             | Sexplib0.Sexp.List [] as sexp__005_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__006_
                 sexp__005_
             | sexp__005_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__006_ sexp__005_
           : (Sexplib0.Sexp.t -> k__027_)
             -> (Sexplib0.Sexp.t -> v__028_)
             -> (Sexplib0.Sexp.t -> v_diff__029_)
             -> Sexplib0.Sexp.t
             -> (k__027_, v__028_, v_diff__029_) t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'k 'v 'v_diff.
             ('k -> Sexplib0.Sexp.t)
          -> ('v -> Sexplib0.Sexp.t)
          -> ('v_diff -> Sexplib0.Sexp.t)
          -> ('k, 'v, 'v_diff) t
          -> Sexplib0.Sexp.t
          =
          fun (type k__043_) ->
          fun (type v__044_) ->
          fun (type v_diff__045_) ->
          (fun _of_k__030_ _of_v__031_ _of_v_diff__032_ -> function
             | Remove arg0__033_ ->
               let res0__034_ = _of_k__030_ arg0__033_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Remove"; res0__034_ ]
             | Add (arg0__035_, arg1__036_) ->
               let res0__037_ = _of_k__030_ arg0__035_
               and res1__038_ = _of_v__031_ arg1__036_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Add"; res0__037_; res1__038_ ]
             | Diff (arg0__039_, arg1__040_) ->
               let res0__041_ = _of_k__030_ arg0__039_
               and res1__042_ = _of_v_diff__032_ arg1__040_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Diff"; res0__041_; res1__042_ ]
           : (k__043_ -> Sexplib0.Sexp.t)
             -> (v__044_ -> Sexplib0.Sexp.t)
             -> (v_diff__045_ -> Sexplib0.Sexp.t)
             -> (k__043_, v__044_, v_diff__045_) t
             -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "map_diff.ml.before-ppx:8:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "k"
                  ; Bin_prot.Shape.Vid.of_string "v"
                  ; Bin_prot.Shape.Vid.of_string "v_diff"
                  ]
                , Bin_prot.Shape.variant
                    [ ( "Remove"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "map_diff.ml.before-ppx:9:20")
                            (Bin_prot.Shape.Vid.of_string "k")
                        ] )
                    ; ( "Add"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "map_diff.ml.before-ppx:10:17")
                            (Bin_prot.Shape.Vid.of_string "k")
                        ; Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "map_diff.ml.before-ppx:10:22")
                            (Bin_prot.Shape.Vid.of_string "v")
                        ] )
                    ; ( "Diff"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "map_diff.ml.before-ppx:11:18")
                            (Bin_prot.Shape.Vid.of_string "k")
                        ; Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "map_diff.ml.before-ppx:11:23")
                            (Bin_prot.Shape.Vid.of_string "v_diff")
                        ] )
                    ] )
              ]
          in
          fun k v v_diff ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
              [ k; v; v_diff ]
        ;;

        let _ = bin_shape_t

        let bin_size_t
          :  'k 'v 'v_diff.
             'k Bin_prot.Size.sizer
          -> 'v Bin_prot.Size.sizer
          -> 'v_diff Bin_prot.Size.sizer
          -> ('k, 'v, 'v_diff) t Bin_prot.Size.sizer
          =
          fun _size_of_k _size_of_v _size_of_v_diff -> function
          | Remove v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_k v1)
          | Add (v1, v2) ->
            let size = 1 in
            let size = Bin_prot.Common.( + ) size (_size_of_k v1) in
            Bin_prot.Common.( + ) size (_size_of_v v2)
          | Diff (v1, v2) ->
            let size = 1 in
            let size = Bin_prot.Common.( + ) size (_size_of_k v1) in
            Bin_prot.Common.( + ) size (_size_of_v_diff v2)
        ;;

        let _ = bin_size_t

        let bin_write_t
          :  'k 'v 'v_diff.
             'k Bin_prot.Write.writer
          -> 'v Bin_prot.Write.writer
          -> 'v_diff Bin_prot.Write.writer
          -> ('k, 'v, 'v_diff) t Bin_prot.Write.writer
          =
          fun _write_k _write_v _write_v_diff buf ~pos -> function
          | Remove v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_k buf ~pos v1
          | Add (v1, v2) ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            let pos = _write_k buf ~pos v1 in
            _write_v buf ~pos v2
          | Diff (v1, v2) ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            let pos = _write_k buf ~pos v1 in
            _write_v_diff buf ~pos v2
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_k bin_writer_v bin_writer_v_diff ->
             { size =
                 (fun v ->
                   bin_size_t bin_writer_k.size bin_writer_v.size bin_writer_v_diff.size v)
             ; write =
                 (fun v ->
                   bin_write_t
                     bin_writer_k.write
                     bin_writer_v.write
                     bin_writer_v_diff.write
                     v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          :  'k 'v 'v_diff.
             'k Bin_prot.Read.reader
          -> 'v Bin_prot.Read.reader
          -> 'v_diff Bin_prot.Read.reader
          -> (int -> ('k, 'v, 'v_diff) t) Bin_prot.Read.reader
          =
          fun _of__k _of__v _of__v_diff _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "map_diff.ml.before-ppx.Stable.V1.Change.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t
          :  'k 'v 'v_diff.
             'k Bin_prot.Read.reader
          -> 'v Bin_prot.Read.reader
          -> 'v_diff Bin_prot.Read.reader
          -> ('k, 'v, 'v_diff) t Bin_prot.Read.reader
          =
          fun _of__k _of__v _of__v_diff buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__k buf ~pos_ref in
            Remove arg_1
          | 1 ->
            let arg_1 = _of__k buf ~pos_ref in
            let arg_2 = _of__v buf ~pos_ref in
            Add (arg_1, arg_2)
          | 2 ->
            let arg_1 = _of__k buf ~pos_ref in
            let arg_2 = _of__v_diff buf ~pos_ref in
            Diff (arg_1, arg_2)
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "map_diff.ml.before-ppx.Stable.V1.Change.t")
              !pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_k bin_reader_v bin_reader_v_diff ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t bin_reader_k.read bin_reader_v.read bin_reader_v_diff.read)
                     buf
                     ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__
                      bin_reader_k.read
                      bin_reader_v.read
                      bin_reader_v_diff.read)
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
          (fun bin_k bin_v bin_v_diff ->
             { writer = bin_writer_t bin_k.writer bin_v.writer bin_v_diff.writer
             ; reader = bin_reader_t bin_k.reader bin_v.reader bin_v_diff.reader
             ; shape = bin_shape_t bin_k.shape bin_v.shape bin_v_diff.shape
             }
           : _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t
             -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let stable_witness
              (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_diff_stable_witness :
                'v_diff Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : ('k, 'v, 'v_diff) t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_diff_stable_witness :
                'v_diff Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _ : 'k Ppx_stable_witness_runtime.Stable_witness.t = __'k_stable_witness
          and _ : 'v Ppx_stable_witness_runtime.Stable_witness.t = __'v_stable_witness
          and _ : 'v_diff Ppx_stable_witness_runtime.Stable_witness.t =
            __'v_diff_stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('k, 'v, 'v_diff) t = ('k, 'v, 'v_diff) Change.t list
    [@@deriving sexp, bin_io, stable_witness]

    include struct
      let _ = fun (_ : ('k, 'v, 'v_diff) t) -> ()

      let t_of_sexp
        :  'k 'v 'v_diff.
           (Sexplib0.Sexp.t -> 'k)
        -> (Sexplib0.Sexp.t -> 'v)
        -> (Sexplib0.Sexp.t -> 'v_diff)
        -> Sexplib0.Sexp.t
        -> ('k, 'v, 'v_diff) t
        =
        fun _of_k__046_ _of_v__047_ _of_v_diff__048_ x__050_ ->
        list_of_sexp (Change.t_of_sexp _of_k__046_ _of_v__047_ _of_v_diff__048_) x__050_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'k 'v 'v_diff.
           ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('v_diff -> Sexplib0.Sexp.t)
        -> ('k, 'v, 'v_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_k__051_ _of_v__052_ _of_v_diff__053_ x__054_ ->
        sexp_of_list (Change.sexp_of_t _of_k__051_ _of_v__052_ _of_v_diff__053_) x__054_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "map_diff.ml.before-ppx:15:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "k"
                ; Bin_prot.Shape.Vid.of_string "v"
                ; Bin_prot.Shape.Vid.of_string "v_diff"
                ]
              , bin_shape_list
                  (((Change.bin_shape_t
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "map_diff.ml.before-ppx:15:32")
                          (Bin_prot.Shape.Vid.of_string "k")))
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "map_diff.ml.before-ppx:15:36")
                         (Bin_prot.Shape.Vid.of_string "v")))
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "map_diff.ml.before-ppx:15:40")
                        (Bin_prot.Shape.Vid.of_string "v_diff"))) )
            ]
        in
        fun k v v_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
            [ k; v; v_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'k 'v 'v_diff.
           'k Bin_prot.Size.sizer
        -> 'v Bin_prot.Size.sizer
        -> 'v_diff Bin_prot.Size.sizer
        -> ('k, 'v, 'v_diff) t Bin_prot.Size.sizer
        =
        fun _size_of_k _size_of_v _size_of_v_diff v ->
        bin_size_list (Change.bin_size_t _size_of_k _size_of_v _size_of_v_diff) v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'k 'v 'v_diff.
           'k Bin_prot.Write.writer
        -> 'v Bin_prot.Write.writer
        -> 'v_diff Bin_prot.Write.writer
        -> ('k, 'v, 'v_diff) t Bin_prot.Write.writer
        =
        fun _write_k _write_v _write_v_diff buf ~pos v ->
        bin_write_list (Change.bin_write_t _write_k _write_v _write_v_diff) buf ~pos v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_k bin_writer_v bin_writer_v_diff ->
           { size =
               (fun v ->
                 bin_size_t bin_writer_k.size bin_writer_v.size bin_writer_v_diff.size v)
           ; write =
               (fun v ->
                 bin_write_t
                   bin_writer_k.write
                   bin_writer_v.write
                   bin_writer_v_diff.write
                   v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'k 'v 'v_diff.
           'k Bin_prot.Read.reader
        -> 'v Bin_prot.Read.reader
        -> 'v_diff Bin_prot.Read.reader
        -> (int -> ('k, 'v, 'v_diff) t) Bin_prot.Read.reader
        =
        fun _of__k _of__v _of__v_diff buf ~pos_ref vint ->
        (__bin_read_list__ (Change.bin_read_t _of__k _of__v _of__v_diff))
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'k 'v 'v_diff.
           'k Bin_prot.Read.reader
        -> 'v Bin_prot.Read.reader
        -> 'v_diff Bin_prot.Read.reader
        -> ('k, 'v, 'v_diff) t Bin_prot.Read.reader
        =
        fun _of__k _of__v _of__v_diff buf ~pos_ref ->
        (bin_read_list (Change.bin_read_t _of__k _of__v _of__v_diff)) buf ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_k bin_reader_v bin_reader_v_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_k.read bin_reader_v.read bin_reader_v_diff.read)
                   buf
                   ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__
                    bin_reader_k.read
                    bin_reader_v.read
                    bin_reader_v_diff.read)
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
        (fun bin_k bin_v bin_v_diff ->
           { writer = bin_writer_t bin_k.writer bin_v.writer bin_v_diff.writer
           ; reader = bin_reader_t bin_k.reader bin_v.reader bin_v_diff.reader
           ; shape = bin_shape_t bin_k.shape bin_v.shape bin_v_diff.shape
           }
         : _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t
           -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let stable_witness
            (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
            (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
            (__'v_diff_stable_witness :
              'v_diff Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : ('k, 'v, 'v_diff) t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__
            (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
            (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
            (__'v_diff_stable_witness :
              'v_diff Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _
          :  ('k, 'v, 'v_diff) Change.t Ppx_stable_witness_runtime.Stable_witness.t
          -> ('k, 'v, 'v_diff) Change.t list Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_list
        and _
          :  'k Ppx_stable_witness_runtime.Stable_witness.t
          -> 'v Ppx_stable_witness_runtime.Stable_witness.t
          -> 'v_diff Ppx_stable_witness_runtime.Stable_witness.t
          -> ('k, 'v, 'v_diff) Change.t Ppx_stable_witness_runtime.Stable_witness.t
          =
          Change.stable_witness
        and _ : 'k Ppx_stable_witness_runtime.Stable_witness.t = __'k_stable_witness
        and _ : 'v Ppx_stable_witness_runtime.Stable_witness.t = __'v_stable_witness
        and _ : 'v_diff Ppx_stable_witness_runtime.Stable_witness.t =
          __'v_diff_stable_witness
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let get
          (type a)
          (type a_diff)
          (get_a : from:a -> to_:a -> a_diff Optional_diff.t)
          ~from
          ~to_
      =
      if phys_equal from to_
      then Optional_diff.none
      else (
        let diff =
          Map.fold_symmetric_diff
            from
            to_
            ~data_equal:phys_equal
            ~init:[]
            ~f:(fun acc (key, diff) ->
              match diff with
              | `Left _ -> Change.Remove key :: acc
              | `Right value -> Change.Add (key, value) :: acc
              | `Unequal (from, to_) ->
                let diff = get_a ~from ~to_ in
                if Optional_diff.is_none diff
                then acc
                else Change.Diff (key, Optional_diff.unsafe_value diff) :: acc)
        in
        if List.is_empty diff then Optional_diff.none else Optional_diff.return diff)
    ;;

    let apply_exn apply_a_exn derived_on diff =
      List.fold ~init:derived_on diff ~f:(fun acc -> function
        | Change.Remove key -> Map.remove acc key
        | Change.Add (key, data) -> Map.set acc ~key ~data
        | Change.Diff (key, diff) ->
          Map.set acc ~key ~data:(apply_a_exn (Map.find_exn acc key) diff))
    ;;

    let of_list_exn _ _ = function
      | [] -> Optional_diff.none
      | l -> Optional_diff.return (List.concat l)
    ;;

    module Make (M : sig
        module Key : sig
          type t
          type comparator_witness
        end

        type 'v t = (Key.t, 'v, Key.comparator_witness) Map.t
      end) :
      Diff_intf.S1_plain
      with type 'v derived_on := 'v M.t
       and type ('v, 'v_diff) t := (M.Key.t, 'v, 'v_diff) t = struct
      let get = get
      let apply_exn = apply_exn
      let of_list_exn = of_list_exn
    end
  end
end

include Stable.V1

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
