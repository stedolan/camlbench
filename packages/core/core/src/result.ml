let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"result.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "result.ml.before-ppx"
;;

open! Import
module Result = Base.Result

module Stable = struct
  module V1 = struct
    type ('a, 'b) t = ('a, 'b) Result.t =
      | Ok of 'a
      | Error of 'b
    [@@deriving
      bin_io ~localize
    , compare
    , diff
    , equal
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , stable_witness
    , typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : ('a, 'b) t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "result.ml.before-ppx:6:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "b" ]
              , Bin_prot.Shape.variant
                  [ ( "Ok"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "result.ml.before-ppx:7:14")
                          (Bin_prot.Shape.Vid.of_string "a")
                      ] )
                  ; ( "Error"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "result.ml.before-ppx:8:17")
                          (Bin_prot.Shape.Vid.of_string "b")
                      ] )
                  ] )
            ]
        in
        fun a b ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; b ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        :  'a 'b.
           'a Bin_prot.Size.sizer_local
        -> 'b Bin_prot.Size.sizer_local
        -> ('a, 'b) t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local _size_of_b__local -> function
        | Ok v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a__local v1)
        | Error v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_b__local v1)
      ;;

      let _ = bin_size_t__local

      let bin_size_t
        :  'a 'b.
           'a Bin_prot.Size.sizer
        -> 'b Bin_prot.Size.sizer
        -> ('a, 'b) t Bin_prot.Size.sizer
        =
        fun _size_of_a _size_of_b -> function
        | Ok v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a v1)
        | Error v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_b v1)
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        :  'a 'b.
           'a Bin_prot.Write.writer_local
        -> 'b Bin_prot.Write.writer_local
        -> ('a, 'b) t Bin_prot.Write.writer_local
        =
        fun _write_a__local _write_b__local buf ~pos -> function
        | Ok v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_a__local buf ~pos v1
        | Error v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_b__local buf ~pos v1
      ;;

      let _ = bin_write_t__local

      let bin_write_t
        :  'a 'b.
           'a Bin_prot.Write.writer
        -> 'b Bin_prot.Write.writer
        -> ('a, 'b) t Bin_prot.Write.writer
        =
        fun _write_a _write_b buf ~pos -> function
        | Ok v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_a buf ~pos v1
        | Error v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_b buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a bin_writer_b ->
           { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_b.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_b.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a 'b.
           'a Bin_prot.Read.reader
        -> 'b Bin_prot.Read.reader
        -> (int -> ('a, 'b) t) Bin_prot.Read.reader
        =
        fun _of__a _of__b _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "result.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a 'b.
           'a Bin_prot.Read.reader
        -> 'b Bin_prot.Read.reader
        -> ('a, 'b) t Bin_prot.Read.reader
        =
        fun _of__a _of__b buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = _of__a buf ~pos_ref in
          Ok arg_1
        | 1 ->
          let arg_1 = _of__b buf ~pos_ref in
          Error arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "result.ml.before-ppx.Stable.V1.t")
            !pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a bin_reader_b ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_a.read bin_reader_b.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read bin_reader_b.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a bin_b ->
           { writer = bin_writer_t bin_a.writer bin_b.writer
           ; reader = bin_reader_t bin_a.reader bin_b.reader
           ; shape = bin_shape_t bin_a.shape bin_b.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        :  'a 'b.
           ('a -> ('a[@merlin.hide]) -> int)
        -> ('b -> ('b[@merlin.hide]) -> int)
        -> ('a, 'b) t
        -> (('a, 'b) t[@merlin.hide])
        -> int
        =
        fun _cmp__a _cmp__b a__001_ b__002_ ->
        if Stdlib.( == ) a__001_ b__002_
        then 0
        else (
          match a__001_, b__002_ with
          | Ok _a__003_, Ok _b__004_ -> _cmp__a _a__003_ _b__004_
          | Ok _, _ -> -1
          | _, Ok _ -> 1
          | Error _a__005_, Error _b__006_ -> _cmp__b _a__005_ _b__006_)
      ;;

      let _ = compare

      module Diff = struct
        open! Diffable.For_ppx

        [@@@ocaml.warning "-34"]

        type ('a, 'b) derived_on = ('a, 'b) t =
          | Ok of 'a
          | Error of 'b

        type ('a, 'b, 'a_diff, 'b_diff) t =
          | Set_to_ok of 'a
          | Set_to_error of 'b
          | Diff_ok of 'a_diff
          | Diff_error of 'b_diff
        [@@deriving bin_io, sexp]

        include struct
          let _ = fun (_ : ('a, 'b, 'a_diff, 'b_diff) t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "result.ml.before-ppx:6:4")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , [ Bin_prot.Shape.Vid.of_string "a"
                    ; Bin_prot.Shape.Vid.of_string "b"
                    ; Bin_prot.Shape.Vid.of_string "a_diff"
                    ; Bin_prot.Shape.Vid.of_string "b_diff"
                    ]
                  , Bin_prot.Shape.variant
                      [ ( "Set_to_ok"
                        , [ Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "result.ml.before-ppx:6:4")
                              (Bin_prot.Shape.Vid.of_string "a")
                          ] )
                      ; ( "Set_to_error"
                        , [ Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "result.ml.before-ppx:6:4")
                              (Bin_prot.Shape.Vid.of_string "b")
                          ] )
                      ; ( "Diff_ok"
                        , [ Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "result.ml.before-ppx:6:4")
                              (Bin_prot.Shape.Vid.of_string "a_diff")
                          ] )
                      ; ( "Diff_error"
                        , [ Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "result.ml.before-ppx:6:4")
                              (Bin_prot.Shape.Vid.of_string "b_diff")
                          ] )
                      ] )
                ]
            in
            fun a b a_diff b_diff ->
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
                [ a; b; a_diff; b_diff ]
          ;;

          let _ = bin_shape_t

          let bin_size_t
            :  'a 'b 'a_diff 'b_diff.
               'a Bin_prot.Size.sizer
            -> 'b Bin_prot.Size.sizer
            -> 'a_diff Bin_prot.Size.sizer
            -> 'b_diff Bin_prot.Size.sizer
            -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Size.sizer
            =
            fun _size_of_a _size_of_b _size_of_a_diff _size_of_b_diff -> function
            | Set_to_ok v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (_size_of_a v1)
            | Set_to_error v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (_size_of_b v1)
            | Diff_ok v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (_size_of_a_diff v1)
            | Diff_error v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (_size_of_b_diff v1)
          ;;

          let _ = bin_size_t

          let bin_write_t
            :  'a 'b 'a_diff 'b_diff.
               'a Bin_prot.Write.writer
            -> 'b Bin_prot.Write.writer
            -> 'a_diff Bin_prot.Write.writer
            -> 'b_diff Bin_prot.Write.writer
            -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Write.writer
            =
            fun _write_a _write_b _write_a_diff _write_b_diff buf ~pos -> function
            | Set_to_ok v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
              _write_a buf ~pos v1
            | Set_to_error v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
              _write_b buf ~pos v1
            | Diff_ok v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
              _write_a_diff buf ~pos v1
            | Diff_error v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
              _write_b_diff buf ~pos v1
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            (fun bin_writer_a bin_writer_b bin_writer_a_diff bin_writer_b_diff ->
               { size =
                   (fun v ->
                     bin_size_t
                       bin_writer_a.size
                       bin_writer_b.size
                       bin_writer_a_diff.size
                       bin_writer_b_diff.size
                       v)
               ; write =
                   (fun v ->
                     bin_write_t
                       bin_writer_a.write
                       bin_writer_b.write
                       bin_writer_a_diff.write
                       bin_writer_b_diff.write
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
            :  'a 'b 'a_diff 'b_diff.
               'a Bin_prot.Read.reader
            -> 'b Bin_prot.Read.reader
            -> 'a_diff Bin_prot.Read.reader
            -> 'b_diff Bin_prot.Read.reader
            -> (int -> ('a, 'b, 'a_diff, 'b_diff) t) Bin_prot.Read.reader
            =
            fun _of__a _of__b _of__a_diff _of__b_diff _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "result.ml.before-ppx.Stable.V1.Diff.t"
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t
            :  'a 'b 'a_diff 'b_diff.
               'a Bin_prot.Read.reader
            -> 'b Bin_prot.Read.reader
            -> 'a_diff Bin_prot.Read.reader
            -> 'b_diff Bin_prot.Read.reader
            -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Read.reader
            =
            fun _of__a _of__b _of__a_diff _of__b_diff buf ~pos_ref ->
            match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
            | 0 ->
              let arg_1 = _of__a buf ~pos_ref in
              Set_to_ok arg_1
            | 1 ->
              let arg_1 = _of__b buf ~pos_ref in
              Set_to_error arg_1
            | 2 ->
              let arg_1 = _of__a_diff buf ~pos_ref in
              Diff_ok arg_1
            | 3 ->
              let arg_1 = _of__b_diff buf ~pos_ref in
              Diff_error arg_1
            | _ ->
              Bin_prot.Common.raise_read_error
                (Bin_prot.Common.ReadError.Sum_tag "result.ml.before-ppx.Stable.V1.Diff.t")
                !pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            (fun bin_reader_a bin_reader_b bin_reader_a_diff bin_reader_b_diff ->
               { read =
                   (fun buf ~pos_ref ->
                     (bin_read_t
                        bin_reader_a.read
                        bin_reader_b.read
                        bin_reader_a_diff.read
                        bin_reader_b_diff.read)
                       buf
                       ~pos_ref)
               ; vtag_read =
                   (fun buf ~pos_ref vtag ->
                     (__bin_read_t__
                        bin_reader_a.read
                        bin_reader_b.read
                        bin_reader_a_diff.read
                        bin_reader_b_diff.read)
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
            (fun bin_a bin_b bin_a_diff bin_b_diff ->
               { writer =
                   bin_writer_t
                     bin_a.writer
                     bin_b.writer
                     bin_a_diff.writer
                     bin_b_diff.writer
               ; reader =
                   bin_reader_t
                     bin_a.reader
                     bin_b.reader
                     bin_a_diff.reader
                     bin_b_diff.reader
               ; shape =
                   bin_shape_t bin_a.shape bin_b.shape bin_a_diff.shape bin_b_diff.shape
               }
             : _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let t_of_sexp
            :  'a 'b 'a_diff 'b_diff.
               (Sexplib0.Sexp.t -> 'a)
            -> (Sexplib0.Sexp.t -> 'b)
            -> (Sexplib0.Sexp.t -> 'a_diff)
            -> (Sexplib0.Sexp.t -> 'b_diff)
            -> Sexplib0.Sexp.t
            -> ('a, 'b, 'a_diff, 'b_diff) t
            =
            fun (type a__074_) ->
            fun (type b__075_) ->
            fun (type a_diff__076_) ->
            fun (type b_diff__077_) ->
            (let error_source__052_ = "result.ml.before-ppx.Stable.V1.Diff.t" in
             fun _of_a__046_ _of_b__047_ _of_a_diff__048_ _of_b_diff__049_ -> function
               | Sexplib0.Sexp.List
                   (Sexplib0.Sexp.Atom (("set_to_ok" | "Set_to_ok") as _tag__055_)
                   :: sexp_args__056_) as _sexp__054_ ->
                 (match sexp_args__056_ with
                  | arg0__057_ :: [] ->
                    let res0__058_ = _of_a__046_ arg0__057_ in
                    Set_to_ok res0__058_
                  | _ ->
                    Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                      error_source__052_
                      _tag__055_
                      _sexp__054_)
               | Sexplib0.Sexp.List
                   (Sexplib0.Sexp.Atom (("set_to_error" | "Set_to_error") as _tag__060_)
                   :: sexp_args__061_) as _sexp__059_ ->
                 (match sexp_args__061_ with
                  | arg0__062_ :: [] ->
                    let res0__063_ = _of_b__047_ arg0__062_ in
                    Set_to_error res0__063_
                  | _ ->
                    Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                      error_source__052_
                      _tag__060_
                      _sexp__059_)
               | Sexplib0.Sexp.List
                   (Sexplib0.Sexp.Atom (("diff_ok" | "Diff_ok") as _tag__065_)
                   :: sexp_args__066_) as _sexp__064_ ->
                 (match sexp_args__066_ with
                  | arg0__067_ :: [] ->
                    let res0__068_ = _of_a_diff__048_ arg0__067_ in
                    Diff_ok res0__068_
                  | _ ->
                    Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                      error_source__052_
                      _tag__065_
                      _sexp__064_)
               | Sexplib0.Sexp.List
                   (Sexplib0.Sexp.Atom (("diff_error" | "Diff_error") as _tag__070_)
                   :: sexp_args__071_) as _sexp__069_ ->
                 (match sexp_args__071_ with
                  | arg0__072_ :: [] ->
                    let res0__073_ = _of_b_diff__049_ arg0__072_ in
                    Diff_error res0__073_
                  | _ ->
                    Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                      error_source__052_
                      _tag__070_
                      _sexp__069_)
               | Sexplib0.Sexp.Atom ("set_to_ok" | "Set_to_ok") as sexp__053_ ->
                 Sexplib0.Sexp_conv_error.stag_takes_args error_source__052_ sexp__053_
               | Sexplib0.Sexp.Atom ("set_to_error" | "Set_to_error") as sexp__053_ ->
                 Sexplib0.Sexp_conv_error.stag_takes_args error_source__052_ sexp__053_
               | Sexplib0.Sexp.Atom ("diff_ok" | "Diff_ok") as sexp__053_ ->
                 Sexplib0.Sexp_conv_error.stag_takes_args error_source__052_ sexp__053_
               | Sexplib0.Sexp.Atom ("diff_error" | "Diff_error") as sexp__053_ ->
                 Sexplib0.Sexp_conv_error.stag_takes_args error_source__052_ sexp__053_
               | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__051_ ->
                 Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                   error_source__052_
                   sexp__051_
               | Sexplib0.Sexp.List [] as sexp__051_ ->
                 Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                   error_source__052_
                   sexp__051_
               | sexp__051_ ->
                 Sexplib0.Sexp_conv_error.unexpected_stag error_source__052_ sexp__051_
             : (Sexplib0.Sexp.t -> a__074_)
               -> (Sexplib0.Sexp.t -> b__075_)
               -> (Sexplib0.Sexp.t -> a_diff__076_)
               -> (Sexplib0.Sexp.t -> b_diff__077_)
               -> Sexplib0.Sexp.t
               -> (a__074_, b__075_, a_diff__076_, b_diff__077_) t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t
            :  'a 'b 'a_diff 'b_diff.
               ('a -> Sexplib0.Sexp.t)
            -> ('b -> Sexplib0.Sexp.t)
            -> ('a_diff -> Sexplib0.Sexp.t)
            -> ('b_diff -> Sexplib0.Sexp.t)
            -> ('a, 'b, 'a_diff, 'b_diff) t
            -> Sexplib0.Sexp.t
            =
            fun (type a__090_) ->
            fun (type b__091_) ->
            fun (type a_diff__092_) ->
            fun (type b_diff__093_) ->
            (fun _of_a__078_ _of_b__079_ _of_a_diff__080_ _of_b_diff__081_ -> function
               | Set_to_ok arg0__082_ ->
                 let res0__083_ = _of_a__078_ arg0__082_ in
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Set_to_ok"; res0__083_ ]
               | Set_to_error arg0__084_ ->
                 let res0__085_ = _of_b__079_ arg0__084_ in
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Set_to_error"; res0__085_ ]
               | Diff_ok arg0__086_ ->
                 let res0__087_ = _of_a_diff__080_ arg0__086_ in
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Diff_ok"; res0__087_ ]
               | Diff_error arg0__088_ ->
                 let res0__089_ = _of_b_diff__081_ arg0__088_ in
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Diff_error"; res0__089_ ]
             : (a__090_ -> Sexplib0.Sexp.t)
               -> (b__091_ -> Sexplib0.Sexp.t)
               -> (a_diff__092_ -> Sexplib0.Sexp.t)
               -> (b_diff__093_ -> Sexplib0.Sexp.t)
               -> (a__090_, b__091_, a_diff__092_, b_diff__093_) t
               -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let get
          :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> (from:'b -> to_:'b -> ('b_diff Optional_diff.t[@jane.erasable.mode local]))
          -> from:('a, 'b) derived_on
          -> to_:('a, 'b) derived_on
          -> (('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t[@jane.erasable.mode local])
          =
          fun _get_a _get_b ->
          let get_Error = _get_b in
          let get_Ok = _get_a in
          fun ~from ~to_ ->
            if Base.phys_equal from to_
            then Optional_diff.none
            else (
              match from, to_ with
              | Ok from, Ok to_ ->
                Optional_diff.map (get_Ok ~from ~to_) ~f:(fun diff -> Diff_ok diff)
              | Error from, Error to_ ->
                Optional_diff.map (get_Error ~from ~to_) ~f:(fun diff -> Diff_error diff)
              | _, Ok to_ -> Optional_diff.return (Set_to_ok to_)
              | _, Error to_ -> Optional_diff.return (Set_to_error to_))
        ;;

        let _ = get

        let apply_exn
          :  ('a -> 'a_diff -> 'a)
          -> ('b -> 'b_diff -> 'b)
          -> ('a, 'b) derived_on
          -> ('a, 'b, 'a_diff, 'b_diff) t
          -> ('a, 'b) derived_on
          =
          fun _apply_a_exn _apply_b_exn ->
          let apply_exn_Error = _apply_b_exn in
          let apply_exn_Ok = _apply_a_exn in
          let derived_on_variant_name derived_on =
            match derived_on with
            | Ok _x -> "Ok"
            | Error _x -> "Error"
          in
          fun derived_on diff ->
            match derived_on, diff with
            | _, Set_to_ok to_ -> Ok to_
            | _, Set_to_error to_ -> Error to_
            | Ok derived_on, Diff_ok diff ->
              let to_ = apply_exn_Ok derived_on diff in
              Ok to_
            | Error derived_on, Diff_error diff ->
              let to_ = apply_exn_Error derived_on diff in
              Error to_
            | derived_on, Diff_ok _d ->
              failwith
                ("Diff mismatch. Applying to variant "
                 ^ derived_on_variant_name derived_on
                 ^ " but diff is of variant "
                 ^ "Diff_ok")
            | derived_on, Diff_error _d ->
              failwith
                ("Diff mismatch. Applying to variant "
                 ^ derived_on_variant_name derived_on
                 ^ " but diff is of variant "
                 ^ "Diff_error")
        ;;

        let _ = apply_exn

        let of_list_exn
          :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> ('a -> 'a_diff -> 'a)
          -> ('b_diff list -> ('b_diff Optional_diff.t[@jane.erasable.mode local]))
          -> ('b -> 'b_diff -> 'b)
          -> ('a, 'b, 'a_diff, 'b_diff) t list
          -> (('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t[@jane.erasable.mode local])
          =
          fun _of_list_a_exn _apply_a_exn _of_list_b_exn _apply_b_exn ->
          let of_list_exn_Error = _of_list_b_exn in
          let apply_exn_Error = _apply_b_exn in
          let of_list_exn_Ok = _of_list_a_exn in
          let apply_exn_Ok = _apply_a_exn in
          let diff_variant_name diff =
            match diff with
            | Set_to_ok _ -> "Set_to_ok"
            | Set_to_error _ -> "Set_to_error"
            | Diff_ok _ -> "Diff_ok"
            | Diff_error _ -> "Diff_error"
          in
          function
          | [] -> Optional_diff.none
          | hd :: [] -> Optional_diff.return hd
          | l ->
            let diffs_rev, rest_rev =
              Base.List.split_while
                ~f:(function
                  | Diff_ok _ -> true
                  | Diff_error _ -> true
                  | Set_to_ok _ -> false
                  | Set_to_error _ -> false)
                (Base.List.rev l)
            in
            let diffs = Base.List.rev diffs_rev in
            (match rest_rev, diffs with
             | [], [] -> assert false
             | (Diff_ok _ | Diff_error _) :: _, _ -> assert false
             | _, (Set_to_ok _ | Set_to_error _) :: _ -> assert false
             | ((Set_to_ok _ | Set_to_error _) as t) :: _, [] -> Optional_diff.return t
             | [], Diff_ok hd :: tl ->
               let tl =
                 Base.List.map tl ~f:(function
                   | Diff_ok diff -> diff
                   | t ->
                     failwith
                       ("Diff mismatch. Can't combine diff of variant "
                        ^ "Diff_ok"
                        ^ " with diff of variant "
                        ^ diff_variant_name t))
               in
               let d = of_list_exn_Ok (hd :: tl) in
               Optional_diff.map d ~f:(fun diff -> Diff_ok diff)
             | [], Diff_error hd :: tl ->
               let tl =
                 Base.List.map tl ~f:(function
                   | Diff_error diff -> diff
                   | t ->
                     failwith
                       ("Diff mismatch. Can't combine diff of variant "
                        ^ "Diff_error"
                        ^ " with diff of variant "
                        ^ diff_variant_name t))
               in
               let d = of_list_exn_Error (hd :: tl) in
               Optional_diff.map d ~f:(fun diff -> Diff_error diff)
             | Set_to_ok to_ :: _, diffs ->
               let diffs =
                 Base.List.map diffs ~f:(function
                   | Diff_ok diff -> diff
                   | t ->
                     failwith
                       ("Diff mismatch. Can't combine diff of variant "
                        ^ "Set_to_ok"
                        ^ " with diff of variant "
                        ^ diff_variant_name t))
               in
               let to_ =
                 Base.List.fold ~init:to_ diffs ~f:(fun acc diff ->
                   let to_ = apply_exn_Ok acc diff in
                   to_)
               in
               Optional_diff.return (Set_to_ok to_)
             | Set_to_error to_ :: _, diffs ->
               let diffs =
                 Base.List.map diffs ~f:(function
                   | Diff_error diff -> diff
                   | t ->
                     failwith
                       ("Diff mismatch. Can't combine diff of variant "
                        ^ "Set_to_error"
                        ^ " with diff of variant "
                        ^ diff_variant_name t))
               in
               let to_ =
                 Base.List.fold ~init:to_ diffs ~f:(fun acc diff ->
                   let to_ = apply_exn_Error acc diff in
                   to_)
               in
               Optional_diff.return (Set_to_error to_))
        ;;

        let _ = of_list_exn
      end

      let equal
        :  'a 'b.
           ('a -> ('a[@merlin.hide]) -> bool)
        -> ('b -> ('b[@merlin.hide]) -> bool)
        -> ('a, 'b) t
        -> (('a, 'b) t[@merlin.hide])
        -> bool
        =
        fun _cmp__a _cmp__b a__007_ b__008_ ->
        if Stdlib.( == ) a__007_ b__008_
        then true
        else (
          match a__007_, b__008_ with
          | Ok _a__009_, Ok _b__010_ -> _cmp__a _a__009_ _b__010_
          | Ok _, _ -> false
          | _, Ok _ -> false
          | Error _a__011_, Error _b__012_ -> _cmp__b _a__011_ _b__012_)
      ;;

      let _ = equal

      let globalize : 'a 'b. ('a -> 'a) -> ('b -> 'b) -> ('a, 'b) t -> ('a, 'b) t =
        fun (type a__013_) ->
        fun (type b__014_) ->
        (fun _globalize_a__016_ _globalize_b__015_ x__017_ ->
           match x__017_ with
           | Ok arg__018_ -> Ok (_globalize_a__016_ arg__018_)
           | Error arg__019_ -> Error (_globalize_b__015_ arg__019_)
         : (a__013_ -> a__013_)
           -> (b__014_ -> b__014_)
           -> (a__013_, b__014_) t
           -> (a__013_, b__014_) t)
      ;;

      let _ = globalize

      let hash_fold_t
        : type a b.
          (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
          -> (Ppx_hash_lib.Std.Hash.state -> b -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> (a, b) t
          -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a _hash_fold_b hsv arg ->
        match arg with
        | Ok _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
          let hsv = hsv in
          _hash_fold_a hsv _a0
        | Error _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
          let hsv = hsv in
          _hash_fold_b hsv _a0
      ;;

      let _ = hash_fold_t

      let t_of_sexp
        :  'a 'b.
           (Sexplib0.Sexp.t -> 'a)
        -> (Sexplib0.Sexp.t -> 'b)
        -> Sexplib0.Sexp.t
        -> ('a, 'b) t
        =
        fun (type a__036_) ->
        fun (type b__037_) ->
        (let error_source__024_ = "result.ml.before-ppx.Stable.V1.t" in
         fun _of_a__020_ _of_b__021_ -> function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("ok" | "Ok") as _tag__027_) :: sexp_args__028_) as
             _sexp__026_ ->
             (match sexp_args__028_ with
              | arg0__029_ :: [] ->
                let res0__030_ = _of_a__020_ arg0__029_ in
                Ok res0__030_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__024_
                  _tag__027_
                  _sexp__026_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("error" | "Error") as _tag__032_) :: sexp_args__033_)
             as _sexp__031_ ->
             (match sexp_args__033_ with
              | arg0__034_ :: [] ->
                let res0__035_ = _of_b__021_ arg0__034_ in
                Error res0__035_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__024_
                  _tag__032_
                  _sexp__031_)
           | Sexplib0.Sexp.Atom ("ok" | "Ok") as sexp__025_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__024_ sexp__025_
           | Sexplib0.Sexp.Atom ("error" | "Error") as sexp__025_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__024_ sexp__025_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__023_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__024_
               sexp__023_
           | Sexplib0.Sexp.List [] as sexp__023_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__024_ sexp__023_
           | sexp__023_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__024_ sexp__023_
         : (Sexplib0.Sexp.t -> a__036_)
           -> (Sexplib0.Sexp.t -> b__037_)
           -> Sexplib0.Sexp.t
           -> (a__036_, b__037_) t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a 'b.
           ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('a, 'b) t
        -> Sexplib0.Sexp.t
        =
        fun (type a__044_) ->
        fun (type b__045_) ->
        (fun _of_a__038_ _of_b__039_ -> function
           | Ok arg0__040_ ->
             let res0__041_ = _of_a__038_ arg0__040_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ok"; res0__041_ ]
           | Error arg0__042_ ->
             let res0__043_ = _of_b__039_ arg0__042_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Error"; res0__043_ ]
         : (a__044_ -> Sexplib0.Sexp.t)
           -> (b__045_ -> Sexplib0.Sexp.t)
           -> (a__044_, b__045_) t
           -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar
        :  'a 'b.
           'a Sexplib0.Sexp_grammar.t
        -> 'b Sexplib0.Sexp_grammar.t
        -> ('a, 'b) t Sexplib0.Sexp_grammar.t
        =
        fun _'a_sexp_grammar _'b_sexp_grammar ->
        { untyped =
            Variant
              { case_sensitivity = Case_sensitive_except_first_character
              ; clauses =
                  [ No_tag
                      { name = "Ok"
                      ; clause_kind =
                          List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                      }
                  ; No_tag
                      { name = "Error"
                      ; clause_kind =
                          List_clause { args = Cons (_'b_sexp_grammar.untyped, Empty) }
                      }
                  ]
              }
        }
      ;;

      let _ = t_sexp_grammar

      let stable_witness
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
            (__'b_stable_witness : 'b Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : ('a, 'b) t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
            (__'b_stable_witness : 'b Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness
        and _ : 'b Ppx_stable_witness_runtime.Stable_witness.t = __'b_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make2 (struct
          type nonrec ('a, 'b) t = ('a, 'b) t

          let name = "result.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        :  'a 'b.
           'a Typerep_lib.Std.Typerep.t
        -> 'b Typerep_lib.Std.Typerep.t
        -> ('a, 'b) t Typerep_lib.Std.Typerep.t
        =
        fun (type a) ->
        fun (type b) ->
        fun (_of_a : a Typerep_lib.Std.Typerep.t) (_of_b : b Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_a _of_b in
        Typerep_lib.Std.Typerep.Named
          ( name_of_t
          , Some
              (lazy
                (let tag0 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Ok"
                     ; rep = _of_a
                     ; arity = 1
                     ; args_labels = []
                     ; index = 0
                     ; ocaml_repr = 0
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; create =
                         Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> Ok v0)
                     }
                 in
                 let tag1 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Error"
                     ; rep = _of_b
                     ; arity = 1
                     ; args_labels = []
                     ; index = 1
                     ; ocaml_repr = 1
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; create =
                         Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> Error v0)
                     }
                 in
                 let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
                 let tags =
                   [| Typerep_lib.Std.Typerep.Variant_internal.Tag tag0
                    ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag1
                   |]
                 in
                 let polymorphic = false in
                 let value = function
                   | Ok v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, v0)
                   | Error v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag1, v0)
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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let map x ~f1 ~f2 =
      match x with
      | Error err -> Error (f2 err)
      | Ok x -> Ok (f1 x)
    ;;
  end

  module V1_stable_unit_test = struct
    type t = (string, int) V1.t [@@deriving bin_io, compare, equal, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "result.ml.before-ppx:29:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , (V1.bin_shape_t bin_shape_string) bin_shape_int )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer =
        fun v -> V1.bin_size_t bin_size_string bin_size_int v
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos v -> V1.bin_write_t bin_write_string bin_write_int buf ~pos v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun buf ~pos_ref vint ->
        (V1.__bin_read_t__ bin_read_string bin_read_int) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref -> (V1.bin_read_t bin_read_string bin_read_int) buf ~pos_ref
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
        (fun a__094_ b__095_ ->
           V1.compare
             (fun a__096_ (b__097_ [@merlin.hide]) ->
                (compare_string a__096_ b__097_ [@merlin.hide]))
             (fun a__098_ (b__099_ [@merlin.hide]) ->
                (compare_int a__098_ b__099_ [@merlin.hide]))
             a__094_
             b__095_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__100_ b__101_ ->
           V1.equal
             (fun a__102_ (b__103_ [@merlin.hide]) ->
                (equal_string a__102_ b__103_ [@merlin.hide]))
             (fun a__104_ (b__105_ [@merlin.hide]) ->
                (equal_int a__104_ b__105_ [@merlin.hide]))
             a__100_
             b__101_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        V1.hash_fold_t
          (fun hsv arg -> hash_fold_string hsv arg)
          (fun hsv arg -> hash_fold_int hsv arg)
          hsv
          arg
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
        (fun x__107_ -> V1.t_of_sexp string_of_sexp int_of_sexp x__107_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun x__108_ -> V1.sexp_of_t sexp_of_string sexp_of_int x__108_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let tests =
      [ V1.Ok "foo", "(Ok foo)", "\000\003foo"; V1.Error 7, "(Error 7)", "\001\007" ]
    ;;
  end
end

include Stable.V1
include Result

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
