let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"interval.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "interval.ml.before-ppx"
;;

open! Core
open! Int.Replace_polymorphic_compare

module Stable = struct
  open Stable_witness.Export

  module V1 = struct
    module T = struct
      type 'a t =
        | Interval of 'a * 'a
        | Empty
      [@@deriving bin_io, of_sexp, variants, compare, hash, sexp_grammar, stable_witness]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:9:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.variant
                    [ ( "Interval"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "interval.ml.before-ppx:10:22")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ; Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "interval.ml.before-ppx:10:27")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ] )
                    ; "Empty", []
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | Interval (v1, v2) ->
            let size = 1 in
            let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
            Bin_prot.Common.( + ) size (_size_of_a v2)
          | Empty -> 1
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | Interval (v1, v2) ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            let pos = _write_a buf ~pos v1 in
            _write_a buf ~pos v2
          | Empty -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
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
            "interval.ml.before-ppx.Stable.V1.T.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a buf ~pos_ref in
            let arg_2 = _of__a buf ~pos_ref in
            Interval (arg_1, arg_2)
          | 1 -> Empty
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag "interval.ml.before-ppx.Stable.V1.T.t")
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

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun (type a__013_) ->
          (let error_source__004_ = "interval.ml.before-ppx.Stable.V1.T.t" in
           fun _of_a__001_ -> function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("interval" | "Interval") as _tag__007_)
                 :: sexp_args__008_) as _sexp__006_ ->
               (match sexp_args__008_ with
                | [ arg0__009_; arg1__010_ ] ->
                  let res0__011_ = _of_a__001_ arg0__009_
                  and res1__012_ = _of_a__001_ arg1__010_ in
                  Interval (res0__011_, res1__012_)
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__004_
                    _tag__007_
                    _sexp__006_)
             | Sexplib0.Sexp.Atom ("empty" | "Empty") -> Empty
             | Sexplib0.Sexp.Atom ("interval" | "Interval") as sexp__005_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("empty" | "Empty") :: _) as
               sexp__005_ ->
               Sexplib0.Sexp_conv_error.stag_no_args error_source__004_ sexp__005_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__004_
                 sexp__003_
             | Sexplib0.Sexp.List [] as sexp__003_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__004_
                 sexp__003_
             | sexp__003_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__004_ sexp__003_
           : (Sexplib0.Sexp.t -> a__013_) -> Sexplib0.Sexp.t -> a__013_ t)
        ;;

        let _ = t_of_sexp
        let interval v0 v1 = Interval (v0, v1)
        let _ = interval
        let empty = Empty
        let _ = empty

        let is_interval = function
          | Interval _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_interval

        let is_empty = function
          | Empty -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_empty

        let interval_val = function
          | Interval (v0, v1) -> Stdlib.Option.Some (v0, v1)
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = interval_val

        let empty_val = function
          | Empty -> Stdlib.Option.Some ()
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = empty_val

        module Variants = struct
          let interval =
            { Variantslib.Variant.name = "Interval"; rank = 0; constructor = interval }
          ;;

          let _ = interval

          let empty =
            { Variantslib.Variant.name = "Empty"; rank = 1; constructor = empty }
          ;;

          let _ = empty

          let fold ~init:init__ ~interval:interval_fun__ ~empty:empty_fun__ =
            empty_fun__ (interval_fun__ init__ interval) empty
          ;;

          let _ = fold

          let iter ~interval:interval_fun__ ~empty:empty_fun__ =
            (interval_fun__ interval : unit);
            (empty_fun__ empty : unit)
          ;;

          let _ = iter

          let map t__ ~interval:interval_fun__ ~empty:empty_fun__ =
            match t__ with
            | Interval (v0, v1) -> interval_fun__ interval v0 v1
            | Empty -> empty_fun__ empty
          ;;

          let _ = map

          let make_matcher ~interval:interval_fun__ ~empty:empty_fun__ compile_acc__ =
            let interval_gen__, compile_acc__ = interval_fun__ interval compile_acc__ in
            let empty_gen__, compile_acc__ = empty_fun__ empty compile_acc__ in
            ( map ~interval:(fun _ -> interval_gen__) ~empty:(fun _ -> empty_gen__ ())
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | Interval _ -> 0
            | Empty -> 1
          ;;

          let _ = to_rank

          let to_name = function
            | Interval _ -> "Interval"
            | Empty -> "Empty"
          ;;

          let _ = to_name
          let descriptions = [ "Interval", 2; "Empty", 0 ]
          let _ = descriptions
        end

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__014_ b__015_ ->
          if Stdlib.( == ) a__014_ b__015_
          then 0
          else (
            match a__014_, b__015_ with
            | Interval (_a__016_, _a__018_), Interval (_b__017_, _b__019_) ->
              (match _cmp__a _a__016_ _b__017_ with
               | 0 -> _cmp__a _a__018_ _b__019_
               | n -> n)
            | Interval _, _ -> -1
            | _, Interval _ -> 1
            | Empty, Empty -> 0)
        ;;

        let _ = compare

        let hash_fold_t
          : type a.
            (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
            -> Ppx_hash_lib.Std.Hash.state
            -> a t
            -> Ppx_hash_lib.Std.Hash.state
          =
          fun _hash_fold_a hsv arg ->
          match arg with
          | Interval (_a0, _a1) ->
            let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
            let hsv =
              let hsv = hsv in
              _hash_fold_a hsv _a0
            in
            _hash_fold_a hsv _a1
          | Empty -> Ppx_hash_lib.Std.Hash.fold_int hsv 1
        ;;

        let _ = hash_fold_t

        let t_sexp_grammar
          : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
          =
          fun _'a_sexp_grammar ->
          { untyped =
              Variant
                { case_sensitivity = Case_sensitive_except_first_character
                ; clauses =
                    [ No_tag
                        { name = "Interval"
                        ; clause_kind =
                            List_clause
                              { args =
                                  Cons
                                    ( _'a_sexp_grammar.untyped
                                    , Cons (_'a_sexp_grammar.untyped, Empty) )
                              }
                        }
                    ; No_tag { name = "Empty"; clause_kind = Atom_clause }
                    ]
                }
          }
        ;;

        let _ = t_sexp_grammar

        let stable_witness
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      type 'a interval = 'a t
      [@@deriving bin_io, of_sexp, compare, hash, sexp_grammar, stable_witness]

      include struct
        let _ = fun (_ : 'a interval) -> ()

        let bin_shape_interval =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:14:6")
              [ ( Bin_prot.Shape.Tid.of_string "interval"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , bin_shape_t
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:14:25")
                       (Bin_prot.Shape.Vid.of_string "a")) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "interval"))
              [ a ]
        ;;

        let _ = bin_shape_interval

        let bin_size_interval
          : 'a. 'a Bin_prot.Size.sizer -> 'a interval Bin_prot.Size.sizer
          =
          fun _size_of_a v -> bin_size_t _size_of_a v
        ;;

        let _ = bin_size_interval

        let bin_write_interval
          : 'a. 'a Bin_prot.Write.writer -> 'a interval Bin_prot.Write.writer
          =
          fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
        ;;

        let _ = bin_write_interval

        let bin_writer_interval =
          (fun bin_writer_a ->
             { size = (fun v -> bin_size_interval bin_writer_a.size v)
             ; write = (fun v -> bin_write_interval bin_writer_a.write v)
             }
           : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_interval

        let __bin_read_interval__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a interval) Bin_prot.Read.reader
          =
          fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
        ;;

        let _ = __bin_read_interval__

        let bin_read_interval
          : 'a. 'a Bin_prot.Read.reader -> 'a interval Bin_prot.Read.reader
          =
          fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
        ;;

        let _ = bin_read_interval

        let bin_reader_interval =
          (fun bin_reader_a ->
             { read =
                 (fun buf ~pos_ref -> (bin_read_interval bin_reader_a.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_interval__ bin_reader_a.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_interval

        let bin_interval =
          (fun bin_a ->
             { writer = bin_writer_interval bin_a.writer
             ; reader = bin_reader_interval bin_a.reader
             ; shape = bin_shape_interval bin_a.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_interval

        let interval_of_sexp
          : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a interval
          =
          fun _of_a__020_ x__022_ -> t_of_sexp _of_a__020_ x__022_
        ;;

        let _ = interval_of_sexp

        let compare_interval
          :  'a.
             ('a -> ('a[@merlin.hide]) -> int)
          -> 'a interval
          -> ('a interval[@merlin.hide])
          -> int
          =
          fun _cmp__a a__023_ b__024_ ->
          compare
            (fun a__025_ (b__026_ [@merlin.hide]) ->
               (_cmp__a a__025_ b__026_ [@merlin.hide]))
            a__023_
            b__024_
        ;;

        let _ = compare_interval

        let hash_fold_interval
          :  'a.
             (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> 'a interval
          -> Ppx_hash_lib.Std.Hash.state
          =
          fun _hash_fold_a hsv arg ->
          hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
        ;;

        let _ = hash_fold_interval

        let interval_sexp_grammar
          : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a interval Sexplib0.Sexp_grammar.t
          =
          fun _'a_sexp_grammar -> t_sexp_grammar _'a_sexp_grammar
        ;;

        let _ = interval_sexp_grammar

        let stable_witness_interval
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : 'a interval Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_interval__
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _
            :  'a Ppx_stable_witness_runtime.Stable_witness.t
            -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness
          and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
          ()
        ;;

        let _ = stable_witness_interval
        and _ = __stable_witness_checks_for_interval__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let interval_of_sexp a_of_sexp sexp =
        try interval_of_sexp a_of_sexp sexp with
        | _exn ->
          (match sexp with
           | Sexp.List [] -> Empty
           | Sexp.List [ lb; ub ] -> Interval (a_of_sexp lb, a_of_sexp ub)
           | Sexp.Atom _ | Sexp.List _ ->
             of_sexp_error "Interval.t_of_sexp: expected pair or empty list" sexp)
      ;;

      let sexp_of_interval sexp_of_a t =
        match t with
        | Empty -> Sexp.List []
        | Interval (lb, ub) -> Sexp.List [ sexp_of_a lb; sexp_of_a ub ]
      ;;

      let interval_sexp_grammar a_sexp_grammar =
        Sexplib0.Sexp_grammar.coerce
          { untyped =
              Union
                [ (interval_sexp_grammar a_sexp_grammar).untyped
                ; List Empty
                ; List
                    (Cons (a_sexp_grammar.untyped, Cons (a_sexp_grammar.untyped, Empty)))
                ]
          }
      ;;
    end

    open T

    type 'a t = 'a interval
    [@@deriving sexp, bin_io, compare, hash, sexp_grammar, stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__027_ x__029_ -> interval_of_sexp _of_a__027_ x__029_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__030_ x__031_ -> sexp_of_interval _of_a__030_ x__031_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:48:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_interval
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:48:16")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_interval _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_interval _write_a buf ~pos v
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
        fun _of__a buf ~pos_ref vint -> (__bin_read_interval__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_interval _of__a) buf ~pos_ref
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
        fun _cmp__a a__032_ b__033_ ->
        compare_interval
          (fun a__034_ (b__035_ [@merlin.hide]) ->
             (_cmp__a a__034_ b__035_ [@merlin.hide]))
          a__032_
          b__033_
      ;;

      let _ = compare

      let hash_fold_t
        :  'a.
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        hash_fold_interval (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
      ;;

      let _ = hash_fold_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar -> interval_sexp_grammar _'a_sexp_grammar
      ;;

      let _ = t_sexp_grammar

      let stable_witness
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__
            (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a interval Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_interval
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Float = struct
      module T = struct
        type t = float interval
        [@@deriving sexp, bin_io, compare, hash, sexp_grammar, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__037_ -> interval_of_sexp float_of_sexp x__037_ : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__038_ -> sexp_of_interval sexp_of_float x__038_ : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:53:8")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_interval bin_shape_float
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> bin_size_interval bin_size_float v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v -> bin_write_interval bin_write_float buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (__bin_read_interval__ bin_read_float) buf ~pos_ref vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref -> (bin_read_interval bin_read_float) buf ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__039_ b__040_ ->
               compare_interval
                 (fun a__041_ (b__042_ [@merlin.hide]) ->
                    (compare_float a__041_ b__042_ [@merlin.hide]))
                 a__039_
                 b__040_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg ->
            hash_fold_interval (fun hsv arg -> hash_fold_float hsv arg) hsv arg
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

          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
            { untyped = Lazy (lazy (interval_sexp_grammar float_sexp_grammar).untyped) }
          ;;

          let _ = t_sexp_grammar

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _
              :  float Ppx_stable_witness_runtime.Stable_witness.t
              -> float interval Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_interval
            and _ : float Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_float
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end

    module Int = struct
      module T = struct
        type t = int interval
        [@@deriving sexp, bin_io, compare, hash, sexp_grammar, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__044_ -> interval_of_sexp int_of_sexp x__044_ : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__045_ -> sexp_of_interval sexp_of_int x__045_ : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:63:8")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_interval bin_shape_int ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> bin_size_interval bin_size_int v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v -> bin_write_interval bin_write_int buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (__bin_read_interval__ bin_read_int) buf ~pos_ref vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref -> (bin_read_interval bin_read_int) buf ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__046_ b__047_ ->
               compare_interval
                 (fun a__048_ (b__049_ [@merlin.hide]) ->
                    (compare_int a__048_ b__049_ [@merlin.hide]))
                 a__046_
                 b__047_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg ->
            hash_fold_interval (fun hsv arg -> hash_fold_int hsv arg) hsv arg
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

          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
            { untyped = Lazy (lazy (interval_sexp_grammar int_sexp_grammar).untyped) }
          ;;

          let _ = t_sexp_grammar

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _
              :  int Ppx_stable_witness_runtime.Stable_witness.t
              -> int interval Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_interval
            and _ : int Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_int
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end

    module Time = struct end
    module Time_ns = struct end

    module Ofday = struct
      module T = struct
        type t = Core.Time_float.Stable.Ofday.V1.t interval
        [@@deriving sexp, bin_io, compare, hash, sexp_grammar, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__051_ ->
               interval_of_sexp Core.Time_float.Stable.Ofday.V1.t_of_sexp x__051_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__052_ ->
               sexp_of_interval Core.Time_float.Stable.Ofday.V1.sexp_of_t x__052_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:76:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , bin_shape_interval Core.Time_float.Stable.Ofday.V1.bin_shape_t )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> bin_size_interval Core.Time_float.Stable.Ofday.V1.bin_size_t v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v ->
            bin_write_interval Core.Time_float.Stable.Ofday.V1.bin_write_t buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (__bin_read_interval__ Core.Time_float.Stable.Ofday.V1.bin_read_t)
              buf
              ~pos_ref
              vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            (bin_read_interval Core.Time_float.Stable.Ofday.V1.bin_read_t) buf ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__053_ b__054_ ->
               compare_interval
                 (fun a__055_ (b__056_ [@merlin.hide]) ->
                    (Core.Time_float.Stable.Ofday.V1.compare
                       a__055_
                       b__056_ [@merlin.hide]))
                 a__053_
                 b__054_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg ->
            hash_fold_interval
              (fun hsv arg -> Core.Time_float.Stable.Ofday.V1.hash_fold_t hsv arg)
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

          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
            { untyped =
                Lazy
                  (lazy
                    (interval_sexp_grammar Core.Time_float.Stable.Ofday.V1.t_sexp_grammar)
                      .untyped)
            }
          ;;

          let _ = t_sexp_grammar

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _
              :  Core.Time_float.Stable.Ofday.V1.t
                   Ppx_stable_witness_runtime.Stable_witness.t
              -> Core.Time_float.Stable.Ofday.V1.t interval
                   Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_interval
            and _
              : Core.Time_float.Stable.Ofday.V1.t
                  Ppx_stable_witness_runtime.Stable_witness.t
              =
              Core.Time_float.Stable.Ofday.V1.stable_witness
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end

    module Ofday_ns = struct
      module T = struct
        type t = Core.Time_ns.Stable.Ofday.V1.t interval
        [@@deriving sexp, bin_io, compare, sexp_grammar, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__058_ ->
               interval_of_sexp Core.Time_ns.Stable.Ofday.V1.t_of_sexp x__058_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__059_ ->
               sexp_of_interval Core.Time_ns.Stable.Ofday.V1.sexp_of_t x__059_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:86:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , bin_shape_interval Core.Time_ns.Stable.Ofday.V1.bin_shape_t )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> bin_size_interval Core.Time_ns.Stable.Ofday.V1.bin_size_t v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v ->
            bin_write_interval Core.Time_ns.Stable.Ofday.V1.bin_write_t buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (__bin_read_interval__ Core.Time_ns.Stable.Ofday.V1.bin_read_t)
              buf
              ~pos_ref
              vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            (bin_read_interval Core.Time_ns.Stable.Ofday.V1.bin_read_t) buf ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__060_ b__061_ ->
               compare_interval
                 (fun a__062_ (b__063_ [@merlin.hide]) ->
                    (Core.Time_ns.Stable.Ofday.V1.compare a__062_ b__063_ [@merlin.hide]))
                 a__060_
                 b__061_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
            { untyped =
                Lazy
                  (lazy
                    (interval_sexp_grammar Core.Time_ns.Stable.Ofday.V1.t_sexp_grammar)
                      .untyped)
            }
          ;;

          let _ = t_sexp_grammar

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _
              :  Core.Time_ns.Stable.Ofday.V1.t Ppx_stable_witness_runtime.Stable_witness.t
              -> Core.Time_ns.Stable.Ofday.V1.t interval
                   Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_interval
            and _
              : Core.Time_ns.Stable.Ofday.V1.t Ppx_stable_witness_runtime.Stable_witness.t
              =
              Core.Time_ns.Stable.Ofday.V1.stable_witness
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end

    module Private = struct
      include T

      let to_float t = t
      let to_int t = t
      let to_ofday t = t
      let to_time t = t
    end
  end
end

open Stable.V1.T

module type Bound = sig
  type 'a bound

  val compare : 'a bound -> 'a bound -> int
  val ( >= ) : 'a bound -> 'a bound -> bool
  val ( <= ) : 'a bound -> 'a bound -> bool
  val ( = ) : 'a bound -> 'a bound -> bool
  val ( > ) : 'a bound -> 'a bound -> bool
  val ( < ) : 'a bound -> 'a bound -> bool
  val ( <> ) : 'a bound -> 'a bound -> bool
end

module Raw_make (T : Bound) = struct
  module T = struct
    include T

    let _ = ( <> )
    let max x y = if T.( >= ) x y then x else y
    let min x y = if T.( <= ) x y then x else y
  end

  module Interval = struct
    let empty = Empty

    let is_malformed = function
      | Empty -> false
      | Interval (x, y) -> T.( > ) x y
    ;;

    let empty_cvt = function
      | Empty -> Empty
      | Interval (x, y) as i -> if T.( > ) x y then Empty else i
    ;;

    let create x y = empty_cvt (Interval (x, y))

    let intersect i1 i2 =
      match i1, i2 with
      | Empty, _ | _, Empty -> Empty
      | Interval (l1, u1), Interval (l2, u2) ->
        empty_cvt (Interval (T.max l1 l2, T.min u1 u2))
    ;;

    let is_empty = function
      | Empty -> true
      | _ -> false
    ;;

    let is_empty_or_singleton = function
      | Empty -> true
      | Interval (x, y) -> T.( = ) x y
    ;;

    let bounds = function
      | Empty -> None
      | Interval (l, u) -> Some (l, u)
    ;;

    let lbound = function
      | Empty -> None
      | Interval (l, _) -> Some l
    ;;

    let ubound = function
      | Empty -> None
      | Interval (_, u) -> Some u
    ;;

    let bounds_exn = function
      | Empty -> invalid_arg "Interval.bounds_exn: empty interval"
      | Interval (l, u) -> l, u
    ;;

    let lbound_exn = function
      | Empty -> invalid_arg "Interval.lbound_exn: empty interval"
      | Interval (l, _) -> l
    ;;

    let ubound_exn = function
      | Empty -> invalid_arg "Interval.ubound_exn: empty interval"
      | Interval (_, u) -> u
    ;;

    let compare_value i x =
      match i with
      | Empty -> `Interval_is_empty
      | Interval (l, u) ->
        if T.( < ) x l then `Below else if T.( > ) x u then `Above else `Within
    ;;

    let contains i x = Poly.( = ) (compare_value i x) `Within

    let bound i x =
      match i with
      | Empty -> None
      | Interval (l, u) ->
        let bounded_value = if T.( < ) x l then l else if T.( < ) u x then u else x in
        Some bounded_value
    ;;

    let is_superset i1 ~of_:i2 =
      match i1, i2 with
      | Interval (l1, u1), Interval (l2, u2) -> T.( <= ) l1 l2 && T.( >= ) u1 u2
      | _, Empty -> true
      | Empty, Interval (_, _) -> false
    ;;

    let is_subset i1 ~of_:i2 = is_superset i2 ~of_:i1

    let map t ~f =
      match t with
      | Empty -> Empty
      | Interval (l, u) -> empty_cvt (Interval (f l, f u))
    ;;

    let interval_compare t1 t2 =
      match t1, t2 with
      | Empty, Empty -> 0
      | Empty, Interval _ -> -1
      | Interval _, Empty -> 1
      | Interval (l1, u1), Interval (l2, u2) ->
        let c = T.compare l1 l2 in
        if Int.( <> ) c 0 then c else T.compare u1 u2
    ;;

    let are_disjoint_gen ~are_disjoint intervals =
      let intervals = Array.of_list intervals in
      try
        for i = 0 to Array.length intervals - 1 do
          for j = i + 1 to Array.length intervals - 1 do
            if not (are_disjoint intervals.(i) intervals.(j)) then raise Exit
          done
        done;
        true
      with
      | Exit -> false
    ;;

    let are_disjoint intervals =
      are_disjoint_gen intervals ~are_disjoint:(fun i1 i2 -> is_empty (intersect i1 i2))
    ;;

    let are_disjoint_as_open_intervals intervals =
      are_disjoint_gen intervals ~are_disjoint:(fun i1 i2 ->
        is_empty_or_singleton (intersect i1 i2))
    ;;

    let list_intersect ilist1 ilist2 =
      if (not (are_disjoint ilist1)) || not (are_disjoint ilist2)
      then invalid_arg "Interval.list_intersect: non-disjoint input list";
      let pairs = List.cartesian_product ilist1 ilist2 in
      List.filter_map pairs ~f:(fun (i1, i2) ->
        let i = intersect i1 i2 in
        if is_empty i then None else Some i)
    ;;

    let half_open_intervals_are_a_partition intervals =
      let intervals = List.filter ~f:(fun x -> not (is_empty x)) intervals in
      let intervals = List.sort ~compare:interval_compare intervals in
      let rec is_partition a = function
        | [] -> true
        | b :: tl -> T.( = ) (ubound_exn a) (lbound_exn b) && is_partition b tl
      in
      match intervals with
      | [] -> true
      | x :: xs -> is_partition x xs
    ;;

    let convex_hull intervals =
      List.fold intervals ~init:empty ~f:(fun i1 i2 ->
        match bounds i1, bounds i2 with
        | None, _ -> i2
        | _, None -> i1
        | Some (l1, u1), Some (l2, u2) -> create (T.min l1 l2) (T.max u1 u2))
    ;;
  end

  module Set = struct
    let drop_empty_intervals_and_sort intervals =
      List.sort
        ~compare:(Comparable.lift T.compare ~f:Interval.lbound_exn)
        (List.filter intervals ~f:(fun i -> not (Interval.is_empty i)))
    ;;

    let create_from_intervals_exn intervals =
      let intervals = drop_empty_intervals_and_sort intervals in
      if not (Interval.are_disjoint intervals)
      then failwith "Interval_set.create: intervals were not disjoint"
      else intervals
    ;;

    let create_merging_intervals intervals =
      List.rev
        (List.fold
           ~init:[]
           ~f:(fun acc interval ->
             match acc with
             | [] -> [ interval ]
             | prev_interval :: tl ->
               if Interval.are_disjoint [ prev_interval; interval ]
               then interval :: acc
               else Interval.convex_hull [ prev_interval; interval ] :: tl)
           (drop_empty_intervals_and_sort intervals))
    ;;

    let create_exn pair_list =
      let intervals =
        List.map pair_list ~f:(fun (lbound, ubound) -> Interval.create lbound ubound)
      in
      create_from_intervals_exn intervals
    ;;

    let contains_set ~container ~contained =
      List.for_all contained ~f:(fun contained_interval ->
        List.exists container ~f:(fun container_interval ->
          Interval.is_superset container_interval ~of_:contained_interval))
    ;;

    let contains t x = List.exists t ~f:(fun interval -> Interval.contains interval x)

    let ubound_exn t =
      match t with
      | [] -> invalid_arg "Interval_set.ubound called on empty set"
      | _ -> Interval.ubound_exn (List.last_exn t)
    ;;

    let lbound_exn t =
      match t with
      | [] -> invalid_arg "Interval_set.lbound called on empty set"
      | _ -> Interval.lbound_exn (List.hd_exn t)
    ;;

    let ubound t =
      match List.last t with
      | None -> None
      | Some i ->
        (match Interval.ubound i with
         | None -> assert false
         | Some x -> Some x)
    ;;

    let lbound t =
      match List.hd t with
      | None -> None
      | Some i ->
        (match Interval.lbound i with
         | None -> assert false
         | Some x -> Some x)
    ;;

    let union_list ts = create_merging_intervals (List.concat_no_order ts)
    let union t1 t2 = union_list [ t1; t2 ]
    let inter t1 t2 = create_from_intervals_exn (Interval.list_intersect t1 t2)
  end
end

type 'a t = 'a interval [@@deriving bin_io, sexp, compare, hash]

include struct
  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:372:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , bin_shape_interval
              (Bin_prot.Shape.var
                 (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:372:12")
                 (Bin_prot.Shape.Vid.of_string "a")) )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a v -> bin_size_interval _size_of_a v
  ;;

  let _ = bin_size_t

  let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
    fun _write_a buf ~pos v -> bin_write_interval _write_a buf ~pos v
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

  let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref vint -> (__bin_read_interval__ _of__a) buf ~pos_ref vint
  ;;

  let _ = __bin_read_t__

  let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref -> (bin_read_interval _of__a) buf ~pos_ref
  ;;

  let _ = bin_read_t

  let bin_reader_t =
    (fun bin_reader_a ->
       { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
       ; vtag_read =
           (fun buf ~pos_ref vtag -> (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
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

  let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
    fun _of_a__064_ x__066_ -> interval_of_sexp _of_a__064_ x__066_
  ;;

  let _ = t_of_sexp

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__067_ x__068_ -> sexp_of_interval _of_a__067_ x__068_
  ;;

  let _ = sexp_of_t

  let compare
    : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
    =
    fun _cmp__a a__069_ b__070_ ->
    compare_interval
      (fun a__071_ (b__072_ [@merlin.hide]) -> (_cmp__a a__071_ b__072_ [@merlin.hide]))
      a__069_
      b__070_
  ;;

  let _ = compare

  let hash_fold_t
    :  'a.
       (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> 'a t
    -> Ppx_hash_lib.Std.Hash.state
    =
    fun _hash_fold_a hsv arg ->
    hash_fold_interval (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
  ;;

  let _ = hash_fold_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module C = Raw_make (struct
    type 'a bound = 'a

    include Poly
  end)

include C.Interval

let t_of_sexp a_of_sexp s =
  let t = t_of_sexp a_of_sexp s in
  if is_malformed t then of_sexp_error "Interval.t_of_sexp error: malformed input" s;
  t
;;

module Set = struct
  type 'a t = 'a interval list [@@deriving bin_io, sexp, compare, hash]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:389:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , bin_shape_list
                (bin_shape_interval
                   (Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:389:14")
                      (Bin_prot.Shape.Vid.of_string "a"))) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a v -> bin_size_list (bin_size_interval _size_of_a) v
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> bin_write_list (bin_write_interval _write_a) buf ~pos v
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

    let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint ->
      (__bin_read_list__ (bin_read_interval _of__a)) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (bin_read_list (bin_read_interval _of__a)) buf ~pos_ref
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

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__073_ x__075_ -> list_of_sexp (interval_of_sexp _of_a__073_) x__075_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__076_ x__077_ -> sexp_of_list (sexp_of_interval _of_a__076_) x__077_
    ;;

    let _ = sexp_of_t

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__078_ b__079_ ->
      compare_list
        (fun a__080_ (b__081_ [@merlin.hide]) ->
           (compare_interval
              (fun a__082_ (b__083_ [@merlin.hide]) ->
                 (_cmp__a a__082_ b__083_ [@merlin.hide]))
              a__080_
              b__081_ [@merlin.hide]))
        a__078_
        b__079_
    ;;

    let _ = compare

    let hash_fold_t
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      hash_fold_list
        (fun hsv arg -> hash_fold_interval (fun hsv arg -> _hash_fold_a hsv arg) hsv arg)
        hsv
        arg
    ;;

    let _ = hash_fold_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include C.Set
end

module Make (Bound : sig
    type t [@@deriving bin_io, sexp, hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t
  end) =
struct
  type t = Bound.t interval [@@deriving bin_io, sexp, compare, hash]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:400:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_interval Bound.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = fun v -> bin_size_interval Bound.bin_size_t v
    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos v -> bin_write_interval Bound.bin_write_t buf ~pos v
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun buf ~pos_ref vint -> (__bin_read_interval__ Bound.bin_read_t) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref -> (bin_read_interval Bound.bin_read_t) buf ~pos_ref
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

    let t_of_sexp =
      (fun x__085_ -> interval_of_sexp Bound.t_of_sexp x__085_ : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__086_ -> sexp_of_interval Bound.sexp_of_t x__086_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let compare =
      (fun a__087_ b__088_ ->
         compare_interval
           (fun a__089_ (b__090_ [@merlin.hide]) ->
              (Bound.compare a__089_ b__090_ [@merlin.hide]))
           a__087_
           b__088_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> hash_fold_interval (fun hsv arg -> Bound.hash_fold_t hsv arg) hsv arg
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type interval = t [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : interval) -> ()

    let bin_shape_interval =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:401:2")
          [ Bin_prot.Shape.Tid.of_string "interval", [], bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "interval")) []
    ;;

    let _ = bin_shape_interval
    let bin_size_interval : interval Bin_prot.Size.sizer = bin_size_t
    let _ = bin_size_interval
    let bin_write_interval : interval Bin_prot.Write.writer = bin_write_t
    let _ = bin_write_interval

    let bin_writer_interval =
      ({ size = bin_size_interval; write = bin_write_interval }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_interval
    let __bin_read_interval__ : (int -> interval) Bin_prot.Read.reader = __bin_read_t__
    let _ = __bin_read_interval__
    let bin_read_interval : interval Bin_prot.Read.reader = bin_read_t
    let _ = bin_read_interval

    let bin_reader_interval =
      ({ read = bin_read_interval; vtag_read = __bin_read_interval__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_interval

    let bin_interval =
      ({ writer = bin_writer_interval
       ; reader = bin_reader_interval
       ; shape = bin_shape_interval
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_interval
    let interval_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> interval)
    let _ = interval_of_sexp
    let sexp_of_interval = (sexp_of_t : interval -> Sexplib0.Sexp.t)
    let _ = sexp_of_interval
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type bound = Bound.t

  module C = Raw_make (struct
      type 'a bound = Bound.t

      let compare = Bound.compare

      include (Bound : Comparable.Infix with type t := Bound.t)
    end)

  include C.Interval

  let to_poly (t : t) = t

  let t_of_sexp s =
    let t = t_of_sexp s in
    if is_malformed t
    then
      failwithf "Interval.Make.t_of_sexp error: malformed input %s" (Sexp.to_string s) ()
    else t
  ;;

  module Set = struct
    type t = interval list [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (fun x__093_ -> list_of_sexp interval_of_sexp x__093_ : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun x__094_ -> sexp_of_list sexp_of_interval x__094_ : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "interval.ml.before-ppx:425:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_list bin_shape_interval ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = fun v -> bin_size_list bin_size_interval v
      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos v -> bin_write_list bin_write_interval buf ~pos v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun buf ~pos_ref vint -> (__bin_read_list__ bin_read_interval) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref -> (bin_read_list bin_read_interval) buf ~pos_ref
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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    include C.Set

    let to_poly (t : t) = t
    let to_list (t : t) : interval list = t
  end
end

module type S1 = Interval_intf.S1

module type S =
  Interval_intf.S with type 'a poly_t := 'a t with type 'a poly_set := 'a Set.t

module type S_time = sig end

module Float = Make (Float)
module Ofday = Make (Core.Time_float.Ofday)
module Ofday_ns = Make (Core.Time_ns.Ofday)

module Int = struct
  include Make (Int)

  let length t =
    match t with
    | Empty -> 0
    | Interval (lo, hi) ->
      let len = 1 + hi - lo in
      if len < 0
      then
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "interval.ml.before-ppx"
            ; pos_lnum = 456
            ; pos_cnum = 12551
            ; pos_bol = 12524
            }
          "interval length not representable"
          t
          (sexp_of_t [@merlin.hide]);
      len
  ;;

  let get t i =
    let fail () =
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "interval.ml.before-ppx"
          ; pos_lnum = 462
          ; pos_cnum = 12684
          ; pos_bol = 12662
          }
        "index out of bounds"
        (i, t)
        ((fun (arg0__095_, arg1__096_) ->
           let res0__097_ = sexp_of_int arg0__095_
           and res1__098_ = sexp_of_t arg1__096_ in
           Sexplib0.Sexp.List [ res0__097_; res1__098_ ]) [@merlin.hide])
    in
    match t with
    | Empty -> fail ()
    | Interval (lo, hi) ->
      if i < 0 then fail ();
      let x = lo + i in
      if x < lo || x > hi then fail ();
      x
  ;;

  let iter t ~f =
    match t with
    | Empty -> ()
    | Interval (lo, hi) ->
      for x = lo to hi do
        f x
      done
  ;;

  let fold =
    let rec fold_interval ~lo ~hi ~acc ~f =
      if lo = hi then f acc hi else fold_interval ~lo:(lo + 1) ~hi ~acc:(f acc lo) ~f
    in
    fun t ~init ~f ->
      match t with
      | Empty -> init
      | Interval (lo, hi) -> fold_interval ~lo ~hi ~acc:init ~f
  ;;

  module For_container = Container.Make0 (struct
      type nonrec t = t

      module Elt = Int

      let iter = `Custom iter
      let fold = fold
      let length = `Custom length
    end)

  let exists = For_container.exists
  let for_all = For_container.for_all
  let sum = For_container.sum
  let count = For_container.count
  let find = For_container.find
  let find_map = For_container.find_map
  let to_list = For_container.to_list
  let to_array = For_container.to_array
  let fold_result = For_container.fold_result
  let fold_until = For_container.fold_until

  let min_elt t ~(compare : _ -> _ -> _) =
    if not (phys_equal compare Int.compare)
    then For_container.min_elt t ~compare
    else lbound t
  ;;

  let max_elt t ~(compare : _ -> _ -> _) =
    if not (phys_equal compare Int.compare)
    then For_container.max_elt t ~compare
    else ubound t
  ;;

  let mem t x =
    if not (phys_equal equal Int.equal) then For_container.mem t x else contains t x
  ;;

  module For_binary_search = Binary_searchable.Make (struct
      type nonrec t = t
      type nonrec elt = bound

      let length = length
      let get = get
    end)

  let binary_search ?pos ?len t ~compare which elt =
    let zero_based_pos = Option.map pos ~f:(fun x -> x - lbound_exn t) in
    let zero_based_result =
      For_binary_search.binary_search ?pos:zero_based_pos ?len t ~compare which elt
    in
    Option.map zero_based_result ~f:(fun x -> x + lbound_exn t)
  ;;

  let binary_search_segmented ?pos ?len t ~segment_of which =
    let zero_based_pos = Option.map pos ~f:(fun x -> x - lbound_exn t) in
    let zero_based_result =
      For_binary_search.binary_search_segmented
        ?pos:zero_based_pos
        ?len
        t
        ~segment_of
        which
    in
    Option.map zero_based_result ~f:(fun x -> x + lbound_exn t)
  ;;

  module Private = struct
    let get = get
  end
end

module Private = struct
  module Make = Make
end

module Time = struct end
module Time_ns = struct end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
