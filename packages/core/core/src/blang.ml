let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"blang.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "blang.ml.before-ppx"
;;

open! Import
open Std_internal

module T : sig
  type +'a t = private
    | True
    | False
    | And of 'a t * 'a t
    | Or of 'a t * 'a t
    | Not of 'a t
    | If of 'a t * 'a t * 'a t
    | Base of 'a
  [@@deriving bin_io ~localize, compare, equal, hash, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local1 with type +'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type +'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type +'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type +'a t := 'a t
    include Typerep_lib.Typerepable.S1 with type +'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val invariant : 'a t -> unit
  val true_ : 'a t
  val false_ : 'a t
  val not_ : 'a t -> 'a t
  val andalso : 'a t -> 'a t -> 'a t
  val orelse : 'a t -> 'a t -> 'a t
  val if_ : 'a t -> 'a t -> 'a t -> 'a t
  val base : 'a -> 'a t
end = struct
  type +'a t =
    | True
    | False
    | And of 'a t * 'a t
    | Or of 'a t * 'a t
    | Not of 'a t
    | If of 'a t * 'a t * 'a t
    | Base of 'a
  [@@deriving bin_io ~localize, compare, equal, hash, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "blang.ml.before-ppx:41:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Bin_prot.Shape.variant
                [ "True", []
                ; "False", []
                ; ( "And"
                  , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:44:13")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:44:20")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ] )
                ; ( "Or"
                  , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:45:12")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:45:19")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ] )
                ; ( "Not"
                  , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:46:13")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ] )
                ; ( "If"
                  , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:47:12")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:47:19")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                        [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "blang.ml.before-ppx:47:26")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ]
                    ] )
                ; ( "Base"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "blang.ml.before-ppx:48:14")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ] )
                ] )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let rec bin_size_t__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local -> function
      | And (v1, v2) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v1) in
        Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v2)
      | Or (v1, v2) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v1) in
        Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v2)
      | Not v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v1)
      | If (v1, v2, v3) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v1) in
        let size = Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v2) in
        Bin_prot.Common.( + ) size (bin_size_t__local _size_of_a__local v3)
      | Base v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_a__local v1)
      | True | False -> 1
    ;;

    let _ = bin_size_t__local

    let rec bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a -> function
      | And (v1, v2) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t _size_of_a v1) in
        Bin_prot.Common.( + ) size (bin_size_t _size_of_a v2)
      | Or (v1, v2) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t _size_of_a v1) in
        Bin_prot.Common.( + ) size (bin_size_t _size_of_a v2)
      | Not v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (bin_size_t _size_of_a v1)
      | If (v1, v2, v3) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (bin_size_t _size_of_a v1) in
        let size = Bin_prot.Common.( + ) size (bin_size_t _size_of_a v2) in
        Bin_prot.Common.( + ) size (bin_size_t _size_of_a v3)
      | Base v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_a v1)
      | True | False -> 1
    ;;

    let _ = bin_size_t

    let rec bin_write_t__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos -> function
      | True -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | False -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
      | And (v1, v2) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
        let pos = bin_write_t__local _write_a__local buf ~pos v1 in
        bin_write_t__local _write_a__local buf ~pos v2
      | Or (v1, v2) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
        let pos = bin_write_t__local _write_a__local buf ~pos v1 in
        bin_write_t__local _write_a__local buf ~pos v2
      | Not v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
        bin_write_t__local _write_a__local buf ~pos v1
      | If (v1, v2, v3) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 5 in
        let pos = bin_write_t__local _write_a__local buf ~pos v1 in
        let pos = bin_write_t__local _write_a__local buf ~pos v2 in
        bin_write_t__local _write_a__local buf ~pos v3
      | Base v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 6 in
        _write_a__local buf ~pos v1
    ;;

    let _ = bin_write_t__local

    let rec bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos -> function
      | True -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | False -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
      | And (v1, v2) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
        let pos = bin_write_t _write_a buf ~pos v1 in
        bin_write_t _write_a buf ~pos v2
      | Or (v1, v2) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
        let pos = bin_write_t _write_a buf ~pos v1 in
        bin_write_t _write_a buf ~pos v2
      | Not v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
        bin_write_t _write_a buf ~pos v1
      | If (v1, v2, v3) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 5 in
        let pos = bin_write_t _write_a buf ~pos v1 in
        let pos = bin_write_t _write_a buf ~pos v2 in
        bin_write_t _write_a buf ~pos v3
      | Base v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 6 in
        _write_a buf ~pos v1
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

    let rec __bin_read_t__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "blang.ml.before-ppx.T.t" !pos_ref

    and bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> True
      | 1 -> False
      | 2 ->
        let arg_1 = (bin_read_t _of__a) buf ~pos_ref in
        let arg_2 = (bin_read_t _of__a) buf ~pos_ref in
        And (arg_1, arg_2)
      | 3 ->
        let arg_1 = (bin_read_t _of__a) buf ~pos_ref in
        let arg_2 = (bin_read_t _of__a) buf ~pos_ref in
        Or (arg_1, arg_2)
      | 4 ->
        let arg_1 = (bin_read_t _of__a) buf ~pos_ref in
        Not arg_1
      | 5 ->
        let arg_1 = (bin_read_t _of__a) buf ~pos_ref in
        let arg_2 = (bin_read_t _of__a) buf ~pos_ref in
        let arg_3 = (bin_read_t _of__a) buf ~pos_ref in
        If (arg_1, arg_2, arg_3)
      | 6 ->
        let arg_1 = _of__a buf ~pos_ref in
        Base arg_1
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag "blang.ml.before-ppx.T.t")
          !pos_ref
    ;;

    let _ = __bin_read_t__
    and _ = bin_read_t

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

    let rec compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__001_ b__002_ ->
      if Stdlib.( == ) a__001_ b__002_
      then 0
      else (
        match a__001_, b__002_ with
        | True, True -> 0
        | True, _ -> -1
        | _, True -> 1
        | False, False -> 0
        | False, _ -> -1
        | _, False -> 1
        | And (_a__003_, _a__005_), And (_b__004_, _b__006_) ->
          (match
             compare
               (fun a__007_ (b__008_ [@merlin.hide]) ->
                  (_cmp__a a__007_ b__008_ [@merlin.hide]))
               _a__003_
               _b__004_
           with
           | 0 ->
             compare
               (fun a__009_ (b__010_ [@merlin.hide]) ->
                  (_cmp__a a__009_ b__010_ [@merlin.hide]))
               _a__005_
               _b__006_
           | n -> n)
        | And _, _ -> -1
        | _, And _ -> 1
        | Or (_a__011_, _a__013_), Or (_b__012_, _b__014_) ->
          (match
             compare
               (fun a__015_ (b__016_ [@merlin.hide]) ->
                  (_cmp__a a__015_ b__016_ [@merlin.hide]))
               _a__011_
               _b__012_
           with
           | 0 ->
             compare
               (fun a__017_ (b__018_ [@merlin.hide]) ->
                  (_cmp__a a__017_ b__018_ [@merlin.hide]))
               _a__013_
               _b__014_
           | n -> n)
        | Or _, _ -> -1
        | _, Or _ -> 1
        | Not _a__019_, Not _b__020_ ->
          compare
            (fun a__021_ (b__022_ [@merlin.hide]) ->
               (_cmp__a a__021_ b__022_ [@merlin.hide]))
            _a__019_
            _b__020_
        | Not _, _ -> -1
        | _, Not _ -> 1
        | If (_a__023_, _a__025_, _a__027_), If (_b__024_, _b__026_, _b__028_) ->
          (match
             compare
               (fun a__029_ (b__030_ [@merlin.hide]) ->
                  (_cmp__a a__029_ b__030_ [@merlin.hide]))
               _a__023_
               _b__024_
           with
           | 0 ->
             (match
                compare
                  (fun a__031_ (b__032_ [@merlin.hide]) ->
                     (_cmp__a a__031_ b__032_ [@merlin.hide]))
                  _a__025_
                  _b__026_
              with
              | 0 ->
                compare
                  (fun a__033_ (b__034_ [@merlin.hide]) ->
                     (_cmp__a a__033_ b__034_ [@merlin.hide]))
                  _a__027_
                  _b__028_
              | n -> n)
           | n -> n)
        | If _, _ -> -1
        | _, If _ -> 1
        | Base _a__035_, Base _b__036_ -> _cmp__a _a__035_ _b__036_)
    ;;

    let _ = compare

    let rec equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__037_ b__038_ ->
      if Stdlib.( == ) a__037_ b__038_
      then true
      else (
        match a__037_, b__038_ with
        | True, True -> true
        | True, _ -> false
        | _, True -> false
        | False, False -> true
        | False, _ -> false
        | _, False -> false
        | And (_a__039_, _a__041_), And (_b__040_, _b__042_) ->
          Stdlib.( && )
            (equal
               (fun a__043_ (b__044_ [@merlin.hide]) ->
                  (_cmp__a a__043_ b__044_ [@merlin.hide]))
               _a__039_
               _b__040_)
            (equal
               (fun a__045_ (b__046_ [@merlin.hide]) ->
                  (_cmp__a a__045_ b__046_ [@merlin.hide]))
               _a__041_
               _b__042_)
        | And _, _ -> false
        | _, And _ -> false
        | Or (_a__047_, _a__049_), Or (_b__048_, _b__050_) ->
          Stdlib.( && )
            (equal
               (fun a__051_ (b__052_ [@merlin.hide]) ->
                  (_cmp__a a__051_ b__052_ [@merlin.hide]))
               _a__047_
               _b__048_)
            (equal
               (fun a__053_ (b__054_ [@merlin.hide]) ->
                  (_cmp__a a__053_ b__054_ [@merlin.hide]))
               _a__049_
               _b__050_)
        | Or _, _ -> false
        | _, Or _ -> false
        | Not _a__055_, Not _b__056_ ->
          equal
            (fun a__057_ (b__058_ [@merlin.hide]) ->
               (_cmp__a a__057_ b__058_ [@merlin.hide]))
            _a__055_
            _b__056_
        | Not _, _ -> false
        | _, Not _ -> false
        | If (_a__059_, _a__061_, _a__063_), If (_b__060_, _b__062_, _b__064_) ->
          Stdlib.( && )
            (equal
               (fun a__065_ (b__066_ [@merlin.hide]) ->
                  (_cmp__a a__065_ b__066_ [@merlin.hide]))
               _a__059_
               _b__060_)
            (Stdlib.( && )
               (equal
                  (fun a__067_ (b__068_ [@merlin.hide]) ->
                     (_cmp__a a__067_ b__068_ [@merlin.hide]))
                  _a__061_
                  _b__062_)
               (equal
                  (fun a__069_ (b__070_ [@merlin.hide]) ->
                     (_cmp__a a__069_ b__070_ [@merlin.hide]))
                  _a__063_
                  _b__064_))
        | If _, _ -> false
        | _, If _ -> false
        | Base _a__071_, Base _b__072_ -> _cmp__a _a__071_ _b__072_)
    ;;

    let _ = equal

    let rec hash_fold_t
      : type a.
        (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> a t
        -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      match arg with
      | True -> Ppx_hash_lib.Std.Hash.fold_int hsv 0
      | False -> Ppx_hash_lib.Std.Hash.fold_int hsv 1
      | And (_a0, _a1) ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 2 in
        let hsv =
          let hsv = hsv in
          hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a0
        in
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
      | Or (_a0, _a1) ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 3 in
        let hsv =
          let hsv = hsv in
          hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a0
        in
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
      | Not _a0 ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 4 in
        let hsv = hsv in
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a0
      | If (_a0, _a1, _a2) ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 5 in
        let hsv =
          let hsv =
            let hsv = hsv in
            hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a0
          in
          hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
        in
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv _a2
      | Base _a0 ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 6 in
        let hsv = hsv in
        _hash_fold_a hsv _a0
    ;;

    let _ = hash_fold_t

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a t

        let name = "blang.ml.before-ppx.T.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let rec typerep_of_t
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a in
      Typerep_lib.Std.Typerep.Named
        ( name_of_t
        , Some
            (lazy
              (let tag0 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "True"
                   ; rep = typerep_of_tuple0
                   ; arity = 0
                   ; args_labels = []
                   ; index = 0
                   ; ocaml_repr = 0
                   ; tyid = typename_of_tuple0
                   ; create = Typerep_lib.Std.Typerep.Tag_internal.Const True
                   }
               in
               let tag1 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "False"
                   ; rep = typerep_of_tuple0
                   ; arity = 0
                   ; args_labels = []
                   ; index = 1
                   ; ocaml_repr = 1
                   ; tyid = typename_of_tuple0
                   ; create = Typerep_lib.Std.Typerep.Tag_internal.Const False
                   }
               in
               let tag2 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "And"
                   ; rep = typerep_of_tuple2 (typerep_of_t _of_a) (typerep_of_t _of_a)
                   ; arity = 2
                   ; args_labels = []
                   ; index = 2
                   ; ocaml_repr = 0
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create =
                       Typerep_lib.Std.Typerep.Tag_internal.Args
                         (fun (v0, v1) -> And (v0, v1))
                   }
               in
               let tag3 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "Or"
                   ; rep = typerep_of_tuple2 (typerep_of_t _of_a) (typerep_of_t _of_a)
                   ; arity = 2
                   ; args_labels = []
                   ; index = 3
                   ; ocaml_repr = 1
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create =
                       Typerep_lib.Std.Typerep.Tag_internal.Args
                         (fun (v0, v1) -> Or (v0, v1))
                   }
               in
               let tag4 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "Not"
                   ; rep = typerep_of_t _of_a
                   ; arity = 1
                   ; args_labels = []
                   ; index = 4
                   ; ocaml_repr = 2
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create = Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> Not v0)
                   }
               in
               let tag5 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "If"
                   ; rep =
                       typerep_of_tuple3
                         (typerep_of_t _of_a)
                         (typerep_of_t _of_a)
                         (typerep_of_t _of_a)
                   ; arity = 3
                   ; args_labels = []
                   ; index = 5
                   ; ocaml_repr = 3
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create =
                       Typerep_lib.Std.Typerep.Tag_internal.Args
                         (fun (v0, v1, v2) -> If (v0, v1, v2))
                   }
               in
               let tag6 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "Base"
                   ; rep = _of_a
                   ; arity = 1
                   ; args_labels = []
                   ; index = 6
                   ; ocaml_repr = 4
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create =
                       Typerep_lib.Std.Typerep.Tag_internal.Args (fun v0 -> Base v0)
                   }
               in
               let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
               let tags =
                 [| Typerep_lib.Std.Typerep.Variant_internal.Tag tag0
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag1
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag2
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag3
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag4
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag5
                  ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag6
                 |]
               in
               let polymorphic = false in
               let value = function
                 | True ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, value_tuple0)
                 | False ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag1, value_tuple0)
                 | And (v0, v1) ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag2, (v0, v1))
                 | Or (v0, v1) ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag3, (v0, v1))
                 | Not v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag4, v0)
                 | If (v0, v1, v2) ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag5, (v0, v1, v2))
                 | Base v0 -> Typerep_lib.Std.Typerep.Variant_internal.Value (tag6, v0)
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

  let invariant =
    let subterms = function
      | True | False | Base _ -> []
      | Not t1 -> [ t1 ]
      | And (t1, t2) | Or (t1, t2) -> [ t1; t2 ]
      | If (t1, t2, t3) -> [ t1; t2; t3 ]
    in
    let rec contains_no_constants = function
      | True | False -> assert false
      | t -> List.iter ~f:contains_no_constants (subterms t)
    in
    fun t -> List.iter ~f:contains_no_constants (subterms t)
  ;;

  let true_ = True
  let false_ = False
  let base v = Base v

  let not_ = function
    | True -> False
    | False -> True
    | Not t -> t
    | t -> Not t
  ;;

  let rec andalso t1 t2 =
    match t1, t2 with
    | _, False | False, _ -> False
    | other, True | True, other -> other
    | And (t1a, t1b), _ -> And (t1a, andalso t1b t2)
    | _ -> And (t1, t2)
  ;;

  let rec orelse t1 t2 =
    match t1, t2 with
    | _, True | True, _ -> True
    | other, False | False, other -> other
    | Or (t1a, t1b), _ -> Or (t1a, orelse t1b t2)
    | _ -> Or (t1, t2)
  ;;

  let if_ a b c =
    match a with
    | True -> b
    | False -> c
    | _ ->
      (match b, c with
       | True, _ -> orelse a c
       | _, False -> andalso a b
       | _, True -> orelse (not_ a) b
       | False, _ -> andalso (not_ a) c
       | _ -> If (a, b, c))
  ;;
end

module Raw = struct
  type 'a t = 'a T.t = private
    | True
    | False
    | And of 'a t * 'a t
    | Or of 'a t * 'a t
    | Not of 'a t
    | If of 'a t * 'a t * 'a t
    | Base of 'a
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let rec sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun (type a__092_) ->
      (fun _of_a__073_ -> function
         | True -> Sexplib0.Sexp.Atom "True"
         | False -> Sexplib0.Sexp.Atom "False"
         | And (arg0__074_, arg1__075_) ->
           let res0__076_ = sexp_of_t _of_a__073_ arg0__074_
           and res1__077_ = sexp_of_t _of_a__073_ arg1__075_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "And"; res0__076_; res1__077_ ]
         | Or (arg0__078_, arg1__079_) ->
           let res0__080_ = sexp_of_t _of_a__073_ arg0__078_
           and res1__081_ = sexp_of_t _of_a__073_ arg1__079_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Or"; res0__080_; res1__081_ ]
         | Not arg0__082_ ->
           let res0__083_ = sexp_of_t _of_a__073_ arg0__082_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Not"; res0__083_ ]
         | If (arg0__084_, arg1__085_, arg2__086_) ->
           let res0__087_ = sexp_of_t _of_a__073_ arg0__084_
           and res1__088_ = sexp_of_t _of_a__073_ arg1__085_
           and res2__089_ = sexp_of_t _of_a__073_ arg2__086_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "If"; res0__087_; res1__088_; res2__089_ ]
         | Base arg0__090_ ->
           let res0__091_ = _of_a__073_ arg0__090_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__091_ ]
       : (a__092_ -> Sexplib0.Sexp.t) -> a__092_ t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

include T

module Stable = struct
  module V1 : sig
    type 'a t = 'a T.t = private
      | True
      | False
      | And of 'a t * 'a t
      | Or of 'a t * 'a t
      | Not of 'a t
      | If of 'a t * 'a t * 'a t
      | Base of 'a
    [@@deriving
      bin_io ~localize, stable_witness, compare, equal, hash, sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val and_ : 'a t list -> 'a t
    val or_ : 'a t list -> 'a t
    val gather_conjuncts : 'a t -> 'a t list
    val gather_disjuncts : 'a t -> 'a t list
  end = struct
    type 'a t = 'a T.t = private
      | True
      | False
      | And of 'a t * 'a t
      | Or of 'a t * 'a t
      | Not of 'a t
      | If of 'a t * 'a t * 'a t
      | Base of 'a

    let stable_witness (_ : 'a Stable_witness.t) : 'a t Stable_witness.t =
      Stable_witness.assert_stable
    ;;

    include (
      T :
        sig
          type 'a t [@@deriving bin_io ~localize, compare, equal, hash]

          include sig
            [@@@ocaml.warning "-32"]

            include Bin_prot.Binable.S_local1 with type 'a t := 'a t
            include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
            include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
            include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end
        with type 'a t := 'a t)

    type sexp = Sexp.t =
      | Atom of string
      | List of sexp list

    let gather_conjuncts t =
      let rec loop acc = function
        | True :: ts -> loop acc ts
        | And (t1, t2) :: ts -> loop acc (t1 :: t2 :: ts)
        | t :: ts -> loop (t :: acc) ts
        | [] -> List.rev acc
      in
      loop [] [ t ]
    ;;

    let gather_disjuncts t =
      let rec loop acc = function
        | False :: ts -> loop acc ts
        | Or (t1, t2) :: ts -> loop acc (t1 :: t2 :: ts)
        | t :: ts -> loop (t :: acc) ts
        | [] -> List.rev acc
      in
      loop [] [ t ]
    ;;

    let and_ ts = List.fold_right ts ~init:true_ ~f:andalso
    let or_ ts = List.fold_right ts ~init:false_ ~f:orelse

    let unary name args sexp =
      match args with
      | x :: [] -> x
      | _ ->
        let n = List.length args in
        of_sexp_error (sprintf "%s expects one argument, %d found" name n) sexp
    ;;

    let ternary name args sexp =
      match args with
      | [ x; y; z ] -> x, y, z
      | _ ->
        let n = List.length args in
        of_sexp_error (sprintf "%s expects three arguments, %d found" name n) sexp
    ;;

    let sexp_of_t sexp_of_value t =
      let rec aux t =
        match t with
        | Base x -> sexp_of_value x
        | True -> Atom "true"
        | False -> Atom "false"
        | Not t -> List [ Atom "not"; aux t ]
        | If (t1, t2, t3) -> List [ Atom "if"; aux t1; aux t2; aux t3 ]
        | And _ as t ->
          let ts = gather_conjuncts t in
          List (Atom "and" :: List.map ~f:aux ts)
        | Or _ as t ->
          let ts = gather_disjuncts t in
          List (Atom "or" :: List.map ~f:aux ts)
      in
      aux t
    ;;

    let t_of_sexp base_of_sexp sexp =
      let base sexp = base (base_of_sexp sexp) in
      let rec aux sexp =
        match sexp with
        | Atom kw ->
          (match String.lowercase kw with
           | "true" -> true_
           | "false" -> false_
           | _ -> base sexp)
        | List (Atom kw :: args) ->
          (match String.lowercase kw with
           | "and" -> and_ (List.map ~f:aux args)
           | "or" -> or_ (List.map ~f:aux args)
           | "not" -> not_ (aux (unary "not" args sexp))
           | "if" ->
             let x, y, z = ternary "if" args sexp in
             if_ (aux x) (aux y) (aux z)
           | _ -> base sexp)
        | _ -> base sexp
      in
      aux sexp
    ;;

    let t_sexp_grammar : 'a. 'a Sexplib.Sexp_grammar.t -> 'a t Sexplib.Sexp_grammar.t =
      let defns : Sexplib.Sexp_grammar.defn list =
        let blang : Sexplib.Sexp_grammar.grammar = Recursive ("blang", [ Tyvar "a" ]) in
        [ { tycon = "blang"
          ; tyvars = [ "a" ]
          ; grammar =
              Union
                [ Tyvar "a"
                ; Variant
                    { case_sensitivity = Case_insensitive
                    ; clauses =
                        [ No_tag { name = "true"; clause_kind = Atom_clause }
                        ; No_tag { name = "false"; clause_kind = Atom_clause }
                        ; No_tag
                            { name = "if"
                            ; clause_kind =
                                List_clause
                                  { args = Cons (blang, Cons (blang, Cons (blang, Empty)))
                                  }
                            }
                        ; No_tag
                            { name = "and"
                            ; clause_kind = List_clause { args = Many blang }
                            }
                        ; No_tag
                            { name = "or"
                            ; clause_kind = List_clause { args = Many blang }
                            }
                        ; No_tag
                            { name = "not"
                            ; clause_kind = List_clause { args = Cons (blang, Empty) }
                            }
                        ]
                    }
                ]
          }
        ]
      in
      fun base_grammar -> { untyped = Tycon ("blang", [ base_grammar.untyped ], defns) }
    ;;
  end
end

include (Stable.V1 : module type of Stable.V1 with type 'a t := 'a t)

let constant b = if b then true_ else false_

module type Constructors = sig
  val base : 'a -> 'a t
  val true_ : _ t
  val false_ : _ t
  val constant : bool -> _ t
  val not_ : 'a t -> 'a t
  val and_ : 'a t list -> 'a t
  val or_ : 'a t list -> 'a t
  val if_ : 'a t -> 'a t -> 'a t -> 'a t
end

module O = struct
  include T

  let not = not_
  let and_ = and_
  let or_ = or_
  let constant = constant
  let ( && ) = andalso
  let ( || ) = orelse
  let ( ==> ) a b = (not a) || b
end

let constant_value = function
  | True -> Some true
  | False -> Some false
  | _ -> None
;;

let values t =
  let rec loop acc = function
    | Base v :: ts -> loop (v :: acc) ts
    | True :: ts -> loop acc ts
    | False :: ts -> loop acc ts
    | Not t1 :: ts -> loop acc (t1 :: ts)
    | And (t1, t2) :: ts -> loop acc (t1 :: t2 :: ts)
    | Or (t1, t2) :: ts -> loop acc (t1 :: t2 :: ts)
    | If (t1, t2, t3) :: ts -> loop acc (t1 :: t2 :: t3 :: ts)
    | [] -> List.rev acc
  in
  loop [] [ t ]
;;

module C = Container.Make (struct
    type 'a t = 'a T.t

    let fold t ~init ~f =
      let rec loop acc t pending =
        match t with
        | Base a -> next (f acc a) pending
        | True | False -> next acc pending
        | Not t -> loop acc t pending
        | And (t1, t2) | Or (t1, t2) -> loop acc t1 (t2 :: pending)
        | If (t1, t2, t3) -> loop acc t1 (t2 :: t3 :: pending)
      and next acc = function
        | [] -> acc
        | t :: ts -> loop acc t ts
      in
      (loop init t [] [@nontail])
    ;;

    let rec iter t ~f =
      match t with
      | Base a -> f a
      | True | False -> ()
      | Not t -> iter t ~f
      | And (t1, t2) | Or (t1, t2) ->
        iter t1 ~f;
        iter t2 ~f
      | If (t1, t2, t3) ->
        iter t1 ~f;
        iter t2 ~f;
        iter t3 ~f
    ;;

    let iter = `Custom iter
    let length = `Define_using_fold
  end)

let count = C.count
let sum = C.sum
let exists = C.exists
let find = C.find
let find_map = C.find_map
let fold = C.fold
let for_all = C.for_all
let is_empty = C.is_empty
let iter = C.iter
let length = C.length
let mem = C.mem
let to_array = C.to_array
let to_list = C.to_list
let min_elt = C.min_elt
let max_elt = C.max_elt
let fold_result = C.fold_result
let fold_until = C.fold_until

let rec bind t ~f:k =
  match t with
  | Base v -> k v
  | True -> true_
  | False -> false_
  | Not t1 -> not_ (bind t1 ~f:k)
  | And (t1, t2) ->
    (match bind t1 ~f:k with
     | False -> false_
     | other -> andalso other (bind t2 ~f:k))
  | Or (t1, t2) ->
    (match bind t1 ~f:k with
     | True -> true_
     | other -> orelse other (bind t2 ~f:k))
  | If (t1, t2, t3) ->
    (match bind t1 ~f:k with
     | True -> bind t2 ~f:k
     | False -> bind t3 ~f:k
     | other -> if_ other (bind t2 ~f:k) (bind t3 ~f:k))
;;

let rec eval t base_eval =
  match t with
  | True -> true
  | False -> false
  | And (t1, t2) -> eval t1 base_eval && eval t2 base_eval
  | Or (t1, t2) -> eval t1 base_eval || eval t2 base_eval
  | Not t -> not (eval t base_eval)
  | If (t1, t2, t3) -> if eval t1 base_eval then eval t2 base_eval else eval t3 base_eval
  | Base x -> base_eval x
;;

let specialize t f =
  bind t ~f:(fun v ->
    match f v with
    | `Known c -> constant c
    | `Unknown -> base v)
  [@nontail]
;;

let eval_set ~universe:all set_of_base t =
  let rec aux (b : _ t) =
    match b with
    | True -> force all
    | False -> Set.Using_comparator.empty ~comparator:(Set.comparator (force all))
    | And (a, b) -> Set.inter (aux a) (aux b)
    | Or (a, b) -> Set.union (aux a) (aux b)
    | Not a -> Set.diff (force all) (aux a)
    | Base a -> set_of_base a
    | If (cond, a, b) ->
      let cond = aux cond in
      Set.union (Set.inter cond (aux a)) (Set.inter (Set.diff (force all) cond) (aux b))
  in
  (aux t [@nontail])
;;

include Monad.Make (struct
    type 'a t = 'a T.t

    let return = base
    let bind = bind
    let map = `Define_using_bind
  end)

module type Monadic = sig
  module M : Monad.S

  val map : 'a t -> f:('a -> 'b M.t) -> 'b t M.t
  val bind : 'a t -> f:('a -> 'b t M.t) -> 'b t M.t
  val eval : 'a t -> f:('a -> bool M.t) -> bool M.t
end

module For_monad (M : Monad.S) : Monadic with module M := M = struct
  open M.Monad_infix

  let rec bind t ~f =
    match t with
    | Base x -> f x
    | True -> M.return true_
    | False -> M.return false_
    | And (a, b) ->
      bind a ~f
      >>= (function
       | False -> M.return false_
       | True -> bind b ~f
       | a -> bind b ~f >>| fun b -> andalso a b)
    | Or (a, b) ->
      bind a ~f
      >>= (function
       | True -> M.return true_
       | False -> bind b ~f
       | a -> bind b ~f >>| fun b -> orelse a b)
    | Not a -> bind a ~f >>| not_
    | If (a, b, c) ->
      bind a ~f
      >>= (function
       | True -> bind b ~f
       | False -> bind c ~f
       | a -> bind b ~f >>= fun b -> bind c ~f >>| fun c -> if_ a b c)
  ;;

  let map t ~f = bind t ~f:(fun x -> f x >>| base)

  let eval t ~f =
    bind t ~f:(fun x ->
      f x
      >>| function
      | true -> true_
      | false -> false_)
    >>| fun t -> eval t Nothing.unreachable_code
  ;;
end

let quickcheck_generator a_generator =
  Quickcheck.Generator.recursive_union
    [ Quickcheck.Generator.map ~f:base a_generator
    ; Quickcheck.Generator.singleton true_
    ; Quickcheck.Generator.singleton false_
    ]
    ~f:(fun self ->
      [ Quickcheck.Generator.map self ~f:not_
      ; Quickcheck.Generator.map2 self self ~f:O.( || )
      ; Quickcheck.Generator.map2 self self ~f:O.( && )
      ; Quickcheck.Generator.map3 self self self ~f:if_
      ])
[@@ocaml.doc
  " We avoid deriving quickcheck to ensure that the invariants described in [T]'s comments\n\
  \    above are preserved. "]
;;

let quickcheck_shrinker (type a) (a_shrinker : a Quickcheck.Shrinker.t) =
  Quickcheck.Shrinker.fixed_point (fun self ->
    let binop operator left right =
      Sequence.round_robin
        [ Sequence.singleton left
        ; Sequence.singleton right
        ; Sequence.map (Quickcheck.Shrinker.shrink self left) ~f:(fun left ->
            operator left right)
        ; Sequence.map (Quickcheck.Shrinker.shrink self right) ~f:(fun right ->
            operator left right)
        ]
    in
    Quickcheck.Shrinker.create (fun t ->
      match t with
      | True | False -> Sequence.empty
      | Base a -> Sequence.map ~f:base (Quickcheck.Shrinker.shrink a_shrinker a)
      | Or (left, right) -> binop O.( || ) left right
      | And (left, right) -> binop O.( && ) left right
      | Not t ->
        Sequence.append
          (Sequence.singleton t)
          (Sequence.map ~f:not_ (Quickcheck.Shrinker.shrink self t))
      | If (if_, then_, else_) ->
        Sequence.round_robin
          [ Sequence.singleton if_
          ; Sequence.singleton then_
          ; Sequence.singleton else_
          ; Sequence.map (Quickcheck.Shrinker.shrink self if_) ~f:(fun if_ ->
              O.if_ if_ then_ else_)
          ; Sequence.map (Quickcheck.Shrinker.shrink self then_) ~f:(fun then_ ->
              O.if_ if_ then_ else_)
          ; Sequence.map (Quickcheck.Shrinker.shrink self else_) ~f:(fun else_ ->
              O.if_ if_ then_ else_)
          ]))
;;

let quickcheck_observer (type a) (a_observer : a Quickcheck.Observer.t) =
  Base_quickcheck.Observer.create (fun t ~size ~hash ->
    hash_fold_t
      (fun hash a -> Quickcheck.Observer.observe a_observer a ~size ~hash)
      hash
      t)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
