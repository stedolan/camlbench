let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"maybe_bound.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "maybe_bound.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    type 'a t = 'a Base.Maybe_bound.t =
      | Incl of 'a
      | Excl of 'a
      | Unbounded
    [@@deriving
      bin_io ~localize, compare, equal, hash, sexp, sexp_grammar, stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:5:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.variant
                  [ ( "Incl"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "maybe_bound.ml.before-ppx:6:16")
                          (Bin_prot.Shape.Vid.of_string "a")
                      ] )
                  ; ( "Excl"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "maybe_bound.ml.before-ppx:7:16")
                          (Bin_prot.Shape.Vid.of_string "a")
                      ] )
                  ; "Unbounded", []
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local -> function
        | Incl v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a__local v1)
        | Excl v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a__local v1)
        | Unbounded -> 1
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | Incl v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a v1)
        | Excl v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a v1)
        | Unbounded -> 1
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
        =
        fun _write_a__local buf ~pos -> function
        | Incl v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_a__local buf ~pos v1
        | Excl v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_a__local buf ~pos v1
        | Unbounded -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
      ;;

      let _ = bin_write_t__local

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | Incl v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_a buf ~pos v1
        | Excl v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_a buf ~pos v1
        | Unbounded -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
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
          "maybe_bound.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = _of__a buf ~pos_ref in
          Incl arg_1
        | 1 ->
          let arg_1 = _of__a buf ~pos_ref in
          Excl arg_1
        | 2 -> Unbounded
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "maybe_bound.ml.before-ppx.Stable.V1.t")
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

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__001_ b__002_ ->
        if Stdlib.( == ) a__001_ b__002_
        then 0
        else (
          match a__001_, b__002_ with
          | Incl _a__003_, Incl _b__004_ -> _cmp__a _a__003_ _b__004_
          | Incl _, _ -> -1
          | _, Incl _ -> 1
          | Excl _a__005_, Excl _b__006_ -> _cmp__a _a__005_ _b__006_
          | Excl _, _ -> -1
          | _, Excl _ -> 1
          | Unbounded, Unbounded -> 0)
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__007_ b__008_ ->
        if Stdlib.( == ) a__007_ b__008_
        then true
        else (
          match a__007_, b__008_ with
          | Incl _a__009_, Incl _b__010_ -> _cmp__a _a__009_ _b__010_
          | Incl _, _ -> false
          | _, Incl _ -> false
          | Excl _a__011_, Excl _b__012_ -> _cmp__a _a__011_ _b__012_
          | Excl _, _ -> false
          | _, Excl _ -> false
          | Unbounded, Unbounded -> true)
      ;;

      let _ = equal

      let hash_fold_t
        : type a.
          (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> a t
          -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        match arg with
        | Incl _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
          let hsv = hsv in
          _hash_fold_a hsv _a0
        | Excl _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
          let hsv = hsv in
          _hash_fold_a hsv _a0
        | Unbounded -> Ppx_hash_lib.Std.Hash.fold_int hsv 2
      ;;

      let _ = hash_fold_t

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun (type a__028_) ->
        (let error_source__016_ = "maybe_bound.ml.before-ppx.Stable.V1.t" in
         fun _of_a__013_ -> function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("incl" | "Incl") as _tag__019_) :: sexp_args__020_)
             as _sexp__018_ ->
             (match sexp_args__020_ with
              | arg0__021_ :: [] ->
                let res0__022_ = _of_a__013_ arg0__021_ in
                Incl res0__022_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__016_
                  _tag__019_
                  _sexp__018_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("excl" | "Excl") as _tag__024_) :: sexp_args__025_)
             as _sexp__023_ ->
             (match sexp_args__025_ with
              | arg0__026_ :: [] ->
                let res0__027_ = _of_a__013_ arg0__026_ in
                Excl res0__027_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__016_
                  _tag__024_
                  _sexp__023_)
           | Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") -> Unbounded
           | Sexplib0.Sexp.Atom ("incl" | "Incl") as sexp__017_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__016_ sexp__017_
           | Sexplib0.Sexp.Atom ("excl" | "Excl") as sexp__017_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__016_ sexp__017_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") :: _) as
             sexp__017_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__016_ sexp__017_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__015_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__016_
               sexp__015_
           | Sexplib0.Sexp.List [] as sexp__015_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__016_ sexp__015_
           | sexp__015_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__016_ sexp__015_
         : (Sexplib0.Sexp.t -> a__028_) -> Sexplib0.Sexp.t -> a__028_ t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun (type a__034_) ->
        (fun _of_a__029_ -> function
           | Incl arg0__030_ ->
             let res0__031_ = _of_a__029_ arg0__030_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Incl"; res0__031_ ]
           | Excl arg0__032_ ->
             let res0__033_ = _of_a__029_ arg0__032_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Excl"; res0__033_ ]
           | Unbounded -> Sexplib0.Sexp.Atom "Unbounded"
         : (a__034_ -> Sexplib0.Sexp.t) -> a__034_ t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar ->
        { untyped =
            Variant
              { case_sensitivity = Case_sensitive_except_first_character
              ; clauses =
                  [ No_tag
                      { name = "Incl"
                      ; clause_kind =
                          List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                      }
                  ; No_tag
                      { name = "Excl"
                      ; clause_kind =
                          List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                      }
                  ; No_tag { name = "Unbounded"; clause_kind = Atom_clause }
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

    let map x ~f =
      match x with
      | Incl x -> Incl (f x)
      | Excl x -> Excl (f x)
      | Unbounded -> Unbounded
    ;;
  end
end

include Base.Maybe_bound

type 'a t = 'a Stable.V1.t =
  | Incl of 'a
  | Excl of 'a
  | Unbounded
[@@deriving bin_io ~localize, compare, equal, hash, quickcheck, sexp]

include struct
  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:23:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , Bin_prot.Shape.variant
              [ ( "Incl"
                , [ Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string
                         "maybe_bound.ml.before-ppx:24:12")
                      (Bin_prot.Shape.Vid.of_string "a")
                  ] )
              ; ( "Excl"
                , [ Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string
                         "maybe_bound.ml.before-ppx:25:12")
                      (Bin_prot.Shape.Vid.of_string "a")
                  ] )
              ; "Unbounded", []
              ] )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t__local
    : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
    =
    fun _size_of_a__local -> function
    | Incl v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (_size_of_a__local v1)
    | Excl v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (_size_of_a__local v1)
    | Unbounded -> 1
  ;;

  let _ = bin_size_t__local

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a -> function
    | Incl v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (_size_of_a v1)
    | Excl v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (_size_of_a v1)
    | Unbounded -> 1
  ;;

  let _ = bin_size_t

  let bin_write_t__local
    : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
    =
    fun _write_a__local buf ~pos -> function
    | Incl v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
      _write_a__local buf ~pos v1
    | Excl v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
      _write_a__local buf ~pos v1
    | Unbounded -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
  ;;

  let _ = bin_write_t__local

  let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
    fun _write_a buf ~pos -> function
    | Incl v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
      _write_a buf ~pos v1
    | Excl v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
      _write_a buf ~pos v1
    | Unbounded -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
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
    fun _of__a _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type "maybe_bound.ml.before-ppx.t" !pos_ref
  ;;

  let _ = __bin_read_t__

  let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 ->
      let arg_1 = _of__a buf ~pos_ref in
      Incl arg_1
    | 1 ->
      let arg_1 = _of__a buf ~pos_ref in
      Excl arg_1
    | 2 -> Unbounded
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "maybe_bound.ml.before-ppx.t")
        !pos_ref
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

  let compare
    : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
    =
    fun _cmp__a a__035_ b__036_ ->
    if Stdlib.( == ) a__035_ b__036_
    then 0
    else (
      match a__035_, b__036_ with
      | Incl _a__037_, Incl _b__038_ -> _cmp__a _a__037_ _b__038_
      | Incl _, _ -> -1
      | _, Incl _ -> 1
      | Excl _a__039_, Excl _b__040_ -> _cmp__a _a__039_ _b__040_
      | Excl _, _ -> -1
      | _, Excl _ -> 1
      | Unbounded, Unbounded -> 0)
  ;;

  let _ = compare

  let equal
    : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
    =
    fun _cmp__a a__041_ b__042_ ->
    if Stdlib.( == ) a__041_ b__042_
    then true
    else (
      match a__041_, b__042_ with
      | Incl _a__043_, Incl _b__044_ -> _cmp__a _a__043_ _b__044_
      | Incl _, _ -> false
      | _, Incl _ -> false
      | Excl _a__045_, Excl _b__046_ -> _cmp__a _a__045_ _b__046_
      | Excl _, _ -> false
      | _, Excl _ -> false
      | Unbounded, Unbounded -> true)
  ;;

  let _ = equal

  let hash_fold_t
    : type a.
      (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> a t
      -> Ppx_hash_lib.Std.Hash.state
    =
    fun _hash_fold_a hsv arg ->
    match arg with
    | Incl _a0 ->
      let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
      let hsv = hsv in
      _hash_fold_a hsv _a0
    | Excl _a0 ->
      let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
      let hsv = hsv in
      _hash_fold_a hsv _a0
    | Unbounded -> Ppx_hash_lib.Std.Hash.fold_int hsv 2
  ;;

  let _ = hash_fold_t

  let quickcheck_generator _generator__056_ =
    Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
      [ ( 1.
        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
            (fun ~size:_size__057_ ~random:_random__058_ ->
               Incl
                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                    _generator__056_
                    ~size:_size__057_
                    ~random:_random__058_)) )
      ; ( 1.
        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
            (fun ~size:_size__059_ ~random:_random__060_ ->
               Excl
                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                    _generator__056_
                    ~size:_size__059_
                    ~random:_random__060_)) )
      ; ( 1.
        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
            (fun ~size:_size__061_ ~random:_random__062_ -> Unbounded) )
      ]
  ;;

  let _ = quickcheck_generator

  let quickcheck_observer _observer__050_ =
    Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
      (fun _x__051_ ~size:_size__052_ ~hash:_hash__053_ ->
         match _x__051_ with
         | Incl _x__054_ ->
           let _hash__053_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__053_ 0 in
           let _hash__053_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__050_
               _x__054_
               ~size:_size__052_
               ~hash:_hash__053_
           in
           _hash__053_
         | Excl _x__055_ ->
           let _hash__053_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__053_ 1 in
           let _hash__053_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__050_
               _x__055_
               ~size:_size__052_
               ~hash:_hash__053_
           in
           _hash__053_
         | Unbounded ->
           let _hash__053_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__053_ 2 in
           _hash__053_)
  ;;

  let _ = quickcheck_observer

  let quickcheck_shrinker _shrinker__047_ =
    Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
      | Incl _x__048_ ->
        Ppx_quickcheck_runtime.Base.Sequence.round_robin
          [ Ppx_quickcheck_runtime.Base.Sequence.map
              (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                 _shrinker__047_
                 _x__048_)
              ~f:(fun _x__048_ -> Incl _x__048_)
          ]
      | Excl _x__049_ ->
        Ppx_quickcheck_runtime.Base.Sequence.round_robin
          [ Ppx_quickcheck_runtime.Base.Sequence.map
              (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                 _shrinker__047_
                 _x__049_)
              ~f:(fun _x__049_ -> Excl _x__049_)
          ]
      | Unbounded -> Ppx_quickcheck_runtime.Base.Sequence.round_robin [])
  ;;

  let _ = quickcheck_shrinker

  let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
    fun (type a__078_) ->
    (let error_source__066_ = "maybe_bound.ml.before-ppx.t" in
     fun _of_a__063_ -> function
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("incl" | "Incl") as _tag__069_) :: sexp_args__070_) as
         _sexp__068_ ->
         (match sexp_args__070_ with
          | arg0__071_ :: [] ->
            let res0__072_ = _of_a__063_ arg0__071_ in
            Incl res0__072_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__066_
              _tag__069_
              _sexp__068_)
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("excl" | "Excl") as _tag__074_) :: sexp_args__075_) as
         _sexp__073_ ->
         (match sexp_args__075_ with
          | arg0__076_ :: [] ->
            let res0__077_ = _of_a__063_ arg0__076_ in
            Excl res0__077_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__066_
              _tag__074_
              _sexp__073_)
       | Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") -> Unbounded
       | Sexplib0.Sexp.Atom ("incl" | "Incl") as sexp__067_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__066_ sexp__067_
       | Sexplib0.Sexp.Atom ("excl" | "Excl") as sexp__067_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__066_ sexp__067_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") :: _) as
         sexp__067_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__066_ sexp__067_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__065_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__066_ sexp__065_
       | Sexplib0.Sexp.List [] as sexp__065_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__066_ sexp__065_
       | sexp__065_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__066_ sexp__065_
     : (Sexplib0.Sexp.t -> a__078_) -> Sexplib0.Sexp.t -> a__078_ t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun (type a__084_) ->
    (fun _of_a__079_ -> function
       | Incl arg0__080_ ->
         let res0__081_ = _of_a__079_ arg0__080_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Incl"; res0__081_ ]
       | Excl arg0__082_ ->
         let res0__083_ = _of_a__079_ arg0__082_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Excl"; res0__083_ ]
       | Unbounded -> Sexplib0.Sexp.Atom "Unbounded"
     : (a__084_ -> Sexplib0.Sexp.t) -> a__084_ t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let compare_one_sided ~side compare_a t1 t2 =
  match t1, t2 with
  | Unbounded, Unbounded -> 0
  | Unbounded, _ ->
    (match side with
     | `Lower -> -1
     | `Upper -> 1)
  | _, Unbounded ->
    (match side with
     | `Lower -> 1
     | `Upper -> -1)
  | Incl a1, Incl a2 -> compare_a a1 a2
  | Excl a1, Excl a2 -> compare_a a1 a2
  | Incl a1, Excl a2 ->
    let c = compare_a a1 a2 in
    if c = 0
    then (
      match side with
      | `Lower -> -1
      | `Upper -> 1)
    else c
  | Excl a1, Incl a2 ->
    let c = compare_a a1 a2 in
    if c = 0
    then (
      match side with
      | `Lower -> 1
      | `Upper -> -1)
    else c
;;

module As_lower_bound = struct
  type nonrec 'a t = 'a t [@@deriving bin_io, equal, hash, sexp]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:61:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:61:21")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a v -> bin_size_t _size_of_a v
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
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
      fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
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

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__085_ b__086_ ->
      equal
        (fun a__087_ (b__088_ [@merlin.hide]) -> (_cmp__a a__087_ b__088_ [@merlin.hide]))
        a__085_
        b__086_
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
      hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_t

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__089_ x__091_ -> t_of_sexp _of_a__089_ x__091_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__092_ x__093_ -> sexp_of_t _of_a__092_ x__093_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let compare compare_a t1 t2 = compare_one_sided ~side:`Lower compare_a t1 t2
end

module As_upper_bound = struct
  type nonrec 'a t = 'a t [@@deriving bin_io, equal, hash, sexp]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:67:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "maybe_bound.ml.before-ppx:67:21")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a v -> bin_size_t _size_of_a v
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
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
      fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
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

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__094_ b__095_ ->
      equal
        (fun a__096_ (b__097_ [@merlin.hide]) -> (_cmp__a a__096_ b__097_ [@merlin.hide]))
        a__094_
        b__095_
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
      hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_t

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__098_ x__100_ -> t_of_sexp _of_a__098_ x__100_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__101_ x__102_ -> sexp_of_t _of_a__101_ x__102_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let compare compare_a t1 t2 = compare_one_sided ~side:`Upper compare_a t1 t2
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
