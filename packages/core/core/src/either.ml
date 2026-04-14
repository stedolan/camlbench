let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"either.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "either.ml.before-ppx"
;;

module Stable = struct
  module V1 = struct
    type ('f, 's) t = ('f, 's) Base.Either.t =
      | First of 'f
      | Second of 's
    [@@deriving bin_io ~localize, compare, equal, hash, sexp, typerep, stable_witness]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : ('f, 's) t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "either.ml.before-ppx:3:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "f"; Bin_prot.Shape.Vid.of_string "s" ]
              , Bin_prot.Shape.variant
                  [ ( "First"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "either.ml.before-ppx:4:17")
                          (Bin_prot.Shape.Vid.of_string "f")
                      ] )
                  ; ( "Second"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "either.ml.before-ppx:5:18")
                          (Bin_prot.Shape.Vid.of_string "s")
                      ] )
                  ] )
            ]
        in
        fun f s ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ f; s ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        :  'f 's.
           'f Bin_prot.Size.sizer_local
        -> 's Bin_prot.Size.sizer_local
        -> ('f, 's) t Bin_prot.Size.sizer_local
        =
        fun _size_of_f__local _size_of_s__local -> function
        | First v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_f__local v1)
        | Second v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_s__local v1)
      ;;

      let _ = bin_size_t__local

      let bin_size_t
        :  'f 's.
           'f Bin_prot.Size.sizer
        -> 's Bin_prot.Size.sizer
        -> ('f, 's) t Bin_prot.Size.sizer
        =
        fun _size_of_f _size_of_s -> function
        | First v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_f v1)
        | Second v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_s v1)
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        :  'f 's.
           'f Bin_prot.Write.writer_local
        -> 's Bin_prot.Write.writer_local
        -> ('f, 's) t Bin_prot.Write.writer_local
        =
        fun _write_f__local _write_s__local buf ~pos -> function
        | First v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_f__local buf ~pos v1
        | Second v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_s__local buf ~pos v1
      ;;

      let _ = bin_write_t__local

      let bin_write_t
        :  'f 's.
           'f Bin_prot.Write.writer
        -> 's Bin_prot.Write.writer
        -> ('f, 's) t Bin_prot.Write.writer
        =
        fun _write_f _write_s buf ~pos -> function
        | First v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          _write_f buf ~pos v1
        | Second v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_s buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_f bin_writer_s ->
           { size = (fun v -> bin_size_t bin_writer_f.size bin_writer_s.size v)
           ; write = (fun v -> bin_write_t bin_writer_f.write bin_writer_s.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'f 's.
           'f Bin_prot.Read.reader
        -> 's Bin_prot.Read.reader
        -> (int -> ('f, 's) t) Bin_prot.Read.reader
        =
        fun _of__f _of__s _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "either.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'f 's.
           'f Bin_prot.Read.reader
        -> 's Bin_prot.Read.reader
        -> ('f, 's) t Bin_prot.Read.reader
        =
        fun _of__f _of__s buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = _of__f buf ~pos_ref in
          First arg_1
        | 1 ->
          let arg_1 = _of__s buf ~pos_ref in
          Second arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "either.ml.before-ppx.Stable.V1.t")
            !pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_f bin_reader_s ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_f.read bin_reader_s.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_f.read bin_reader_s.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_f bin_s ->
           { writer = bin_writer_t bin_f.writer bin_s.writer
           ; reader = bin_reader_t bin_f.reader bin_s.reader
           ; shape = bin_shape_t bin_f.shape bin_s.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        :  'f 's.
           ('f -> ('f[@merlin.hide]) -> int)
        -> ('s -> ('s[@merlin.hide]) -> int)
        -> ('f, 's) t
        -> (('f, 's) t[@merlin.hide])
        -> int
        =
        fun _cmp__f _cmp__s a__001_ b__002_ ->
        if Stdlib.( == ) a__001_ b__002_
        then 0
        else (
          match a__001_, b__002_ with
          | First _a__003_, First _b__004_ -> _cmp__f _a__003_ _b__004_
          | First _, _ -> -1
          | _, First _ -> 1
          | Second _a__005_, Second _b__006_ -> _cmp__s _a__005_ _b__006_)
      ;;

      let _ = compare

      let equal
        :  'f 's.
           ('f -> ('f[@merlin.hide]) -> bool)
        -> ('s -> ('s[@merlin.hide]) -> bool)
        -> ('f, 's) t
        -> (('f, 's) t[@merlin.hide])
        -> bool
        =
        fun _cmp__f _cmp__s a__007_ b__008_ ->
        if Stdlib.( == ) a__007_ b__008_
        then true
        else (
          match a__007_, b__008_ with
          | First _a__009_, First _b__010_ -> _cmp__f _a__009_ _b__010_
          | First _, _ -> false
          | _, First _ -> false
          | Second _a__011_, Second _b__012_ -> _cmp__s _a__011_ _b__012_)
      ;;

      let _ = equal

      let hash_fold_t
        : type f s.
          (Ppx_hash_lib.Std.Hash.state -> f -> Ppx_hash_lib.Std.Hash.state)
          -> (Ppx_hash_lib.Std.Hash.state -> s -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> (f, s) t
          -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_f _hash_fold_s hsv arg ->
        match arg with
        | First _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
          let hsv = hsv in
          _hash_fold_f hsv _a0
        | Second _a0 ->
          let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
          let hsv = hsv in
          _hash_fold_s hsv _a0
      ;;

      let _ = hash_fold_t

      let t_of_sexp
        :  'f 's.
           (Sexplib0.Sexp.t -> 'f)
        -> (Sexplib0.Sexp.t -> 's)
        -> Sexplib0.Sexp.t
        -> ('f, 's) t
        =
        fun (type f__029_) ->
        fun (type s__030_) ->
        (let error_source__017_ = "either.ml.before-ppx.Stable.V1.t" in
         fun _of_f__013_ _of_s__014_ -> function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("first" | "First") as _tag__020_) :: sexp_args__021_)
             as _sexp__019_ ->
             (match sexp_args__021_ with
              | arg0__022_ :: [] ->
                let res0__023_ = _of_f__013_ arg0__022_ in
                First res0__023_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__017_
                  _tag__020_
                  _sexp__019_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("second" | "Second") as _tag__025_)
               :: sexp_args__026_) as _sexp__024_ ->
             (match sexp_args__026_ with
              | arg0__027_ :: [] ->
                let res0__028_ = _of_s__014_ arg0__027_ in
                Second res0__028_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__017_
                  _tag__025_
                  _sexp__024_)
           | Sexplib0.Sexp.Atom ("first" | "First") as sexp__018_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__017_ sexp__018_
           | Sexplib0.Sexp.Atom ("second" | "Second") as sexp__018_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__017_ sexp__018_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__016_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__017_
               sexp__016_
           | Sexplib0.Sexp.List [] as sexp__016_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__017_ sexp__016_
           | sexp__016_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__017_ sexp__016_
         : (Sexplib0.Sexp.t -> f__029_)
           -> (Sexplib0.Sexp.t -> s__030_)
           -> Sexplib0.Sexp.t
           -> (f__029_, s__030_) t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'f 's.
           ('f -> Sexplib0.Sexp.t)
        -> ('s -> Sexplib0.Sexp.t)
        -> ('f, 's) t
        -> Sexplib0.Sexp.t
        =
        fun (type f__037_) ->
        fun (type s__038_) ->
        (fun _of_f__031_ _of_s__032_ -> function
           | First arg0__033_ ->
             let res0__034_ = _of_f__031_ arg0__033_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "First"; res0__034_ ]
           | Second arg0__035_ ->
             let res0__036_ = _of_s__032_ arg0__035_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Second"; res0__036_ ]
         : (f__037_ -> Sexplib0.Sexp.t)
           -> (s__038_ -> Sexplib0.Sexp.t)
           -> (f__037_, s__038_) t
           -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make2 (struct
          type nonrec ('f, 's) t = ('f, 's) t

          let name = "either.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        :  'f 's.
           'f Typerep_lib.Std.Typerep.t
        -> 's Typerep_lib.Std.Typerep.t
        -> ('f, 's) t Typerep_lib.Std.Typerep.t
        =
        fun (type f) ->
        fun (type s) ->
        fun (_of_f : f Typerep_lib.Std.Typerep.t) (_of_s : s Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_f _of_s in
        Typerep_lib.Std.Typerep.Named
          ( name_of_t
          , Some
              (lazy
                (let tag0 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "First"
                     ; rep = _of_f
                     ; arity = 1
                     ; args_labels = []
                     ; index = 0
                     ; ocaml_repr = 0
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; create =
                         Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> First v0)
                     }
                 in
                 let tag1 =
                   Typerep_lib.Std.Typerep.Tag.internal_use_only
                     { Typerep_lib.Std.Typerep.Tag_internal.label = "Second"
                     ; rep = _of_s
                     ; arity = 1
                     ; args_labels = []
                     ; index = 1
                     ; ocaml_repr = 1
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; create =
                         Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> Second v0)
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
                   | First v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, v0)
                   | Second v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag1, v0)
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

      let stable_witness
            (__'f_stable_witness : 'f Ppx_stable_witness_runtime.Stable_witness.t)
            (__'s_stable_witness : 's Ppx_stable_witness_runtime.Stable_witness.t)
        =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : ('f, 's) t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__
            (__'f_stable_witness : 'f Ppx_stable_witness_runtime.Stable_witness.t)
            (__'s_stable_witness : 's Ppx_stable_witness_runtime.Stable_witness.t)
            ()
        =
        let _ : 'f Ppx_stable_witness_runtime.Stable_witness.t = __'f_stable_witness
        and _ : 's Ppx_stable_witness_runtime.Stable_witness.t = __'s_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let map x ~f1 ~f2 =
      match x with
      | First x1 -> First (f1 x1)
      | Second x2 -> Second (f2 x2)
    ;;
  end
end

include Stable.V1
include Base.Either

include Comparator.Derived2 (struct
    type nonrec ('a, 'b) t = ('a, 'b) t [@@deriving sexp_of, compare]

    include struct
      let _ = fun (_ : ('a, 'b) t) -> ()

      let sexp_of_t
        :  'a 'b.
           ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('a, 'b) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a__039_ _of_b__040_ x__041_ -> sexp_of_t _of_a__039_ _of_b__040_ x__041_
      ;;

      let _ = sexp_of_t

      let compare
        :  'a 'b.
           ('a -> ('a[@merlin.hide]) -> int)
        -> ('b -> ('b[@merlin.hide]) -> int)
        -> ('a, 'b) t
        -> (('a, 'b) t[@merlin.hide])
        -> int
        =
        fun _cmp__a _cmp__b a__042_ b__043_ ->
        compare
          (fun a__044_ (b__045_ [@merlin.hide]) ->
             (_cmp__a a__044_ b__045_ [@merlin.hide]))
          (fun a__046_ (b__047_ [@merlin.hide]) ->
             (_cmp__b a__046_ b__047_ [@merlin.hide]))
          a__042_
          b__043_
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

let quickcheck_generator = Base_quickcheck.Generator.either
let quickcheck_observer = Base_quickcheck.Observer.either
let quickcheck_shrinker = Base_quickcheck.Shrinker.either
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
