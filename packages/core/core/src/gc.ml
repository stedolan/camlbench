let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"gc.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "gc.ml.before-ppx"
;;

open! Import

module Stable = struct
  module Allocation_policy = struct
    module V1 = struct
      type t =
        | Next_fit
        | First_fit
        | Best_fit
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:6:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.variant
                    [ "Next_fit", []; "First_fit", []; "Best_fit", [] ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | Next_fit | First_fit | Best_fit -> 1
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | Next_fit -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
          | First_fit -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
          | Best_fit -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Allocation_policy.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 -> Next_fit
          | 1 -> First_fit
          | 2 -> Best_fit
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "gc.ml.before-ppx.Stable.Allocation_policy.V1.t")
              !pos_ref
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
          (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__003_ b__004_ -> Stdlib.( = ) a__003_ b__004_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          (fun hsv arg ->
             Ppx_hash_lib.Std.Hash.fold_int
               hsv
               (match arg with
                | Next_fit -> 0
                | First_fit -> 1
                | Best_fit -> 2)
           : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
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
          (let error_source__007_ = "gc.ml.before-ppx.Stable.Allocation_policy.V1.t" in
           function
           | Sexplib0.Sexp.Atom ("next_fit" | "Next_fit") -> Next_fit
           | Sexplib0.Sexp.Atom ("first_fit" | "First_fit") -> First_fit
           | Sexplib0.Sexp.Atom ("best_fit" | "Best_fit") -> Best_fit
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("next_fit" | "Next_fit") :: _) as
             sexp__008_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("first_fit" | "First_fit") :: _) as
             sexp__008_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("best_fit" | "Best_fit") :: _) as
             sexp__008_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__006_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__007_
               sexp__006_
           | Sexplib0.Sexp.List [] as sexp__006_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__007_ sexp__006_
           | sexp__006_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__007_ sexp__006_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | Next_fit -> Sexplib0.Sexp.Atom "Next_fit"
           | First_fit -> Sexplib0.Sexp.Atom "First_fit"
           | Best_fit -> Sexplib0.Sexp.Atom "Best_fit"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)
        ;;

        let _ = stable_witness
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  module Stat = struct
    [%%if ocaml_version < (4, 12, 0)]

    module V1 = struct
      type t = Stdlib.Gc.stat =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:18:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            Bin_prot.Common.( + ) size (bin_size_int v16)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            bin_write_int buf ~pos v16
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          }
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
          (fun a__009_ b__010_ ->
             if Stdlib.( == ) a__009_ b__010_
             then 0
             else (
               match compare_float a__009_.minor_words b__010_.minor_words with
               | 0 ->
                 (match compare_float a__009_.promoted_words b__010_.promoted_words with
                  | 0 ->
                    (match compare_float a__009_.major_words b__010_.major_words with
                     | 0 ->
                       (match
                          compare_int a__009_.minor_collections b__010_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__009_.major_collections
                               b__010_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__009_.heap_words b__010_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__009_.heap_chunks b__010_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__009_.live_words b__010_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__009_.live_blocks
                                           b__010_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__009_.free_words
                                              b__010_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__009_.free_blocks
                                                 b__010_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__009_.largest_free
                                                    b__010_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__009_.fragments
                                                       b__010_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__009_.compactions
                                                          b__010_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__009_.top_heap_words
                                                             b__010_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           compare_int
                                                             a__009_.stack_size
                                                             b__010_.stack_size
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__011_ b__012_ ->
             if Stdlib.( == ) a__011_ b__012_
             then true
             else
               Stdlib.( && )
                 (equal_float a__011_.minor_words b__012_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__011_.promoted_words b__012_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__011_.major_words b__012_.major_words)
                       (Stdlib.( && )
                          (equal_int a__011_.minor_collections b__012_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__011_.major_collections
                                b__012_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__011_.heap_words b__012_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__011_.heap_chunks b__012_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__011_.live_words b__012_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__011_.live_blocks
                                            b__012_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__011_.free_words
                                               b__012_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__011_.free_blocks
                                                  b__012_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__011_.largest_free
                                                     b__012_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__011_.fragments
                                                        b__012_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__011_.compactions
                                                           b__012_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__011_.top_heap_words
                                                              b__012_.top_heap_words)
                                                           (equal_int
                                                              a__011_.stack_size
                                                              b__012_.stack_size)))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv = hsv in
                                        hash_fold_float hsv arg.minor_words
                                      in
                                      hash_fold_float hsv arg.promoted_words
                                    in
                                    hash_fold_float hsv arg.major_words
                                  in
                                  hash_fold_int hsv arg.minor_collections
                                in
                                hash_fold_int hsv arg.major_collections
                              in
                              hash_fold_int hsv arg.heap_words
                            in
                            hash_fold_int hsv arg.heap_chunks
                          in
                          hash_fold_int hsv arg.live_words
                        in
                        hash_fold_int hsv arg.live_blocks
                      in
                      hash_fold_int hsv arg.free_words
                    in
                    hash_fold_int hsv arg.free_blocks
                  in
                  hash_fold_int hsv arg.largest_free
                in
                hash_fold_int hsv arg.fragments
              in
              hash_fold_int hsv arg.compactions
            in
            hash_fold_int hsv arg.top_heap_words
          in
          hash_fold_int hsv arg.stack_size
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
          (let error_source__014_ = "gc.ml.before-ppx.Stable.Stat.V1.t" in
           fun x__015_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__014_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , (top_heap_words, (stack_size, ())) ) ) ) )
                                     ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  }
                  : t))
               x__015_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__017_
               ; promoted_words = promoted_words__019_
               ; major_words = major_words__021_
               ; minor_collections = minor_collections__023_
               ; major_collections = major_collections__025_
               ; heap_words = heap_words__027_
               ; heap_chunks = heap_chunks__029_
               ; live_words = live_words__031_
               ; live_blocks = live_blocks__033_
               ; free_words = free_words__035_
               ; free_blocks = free_blocks__037_
               ; largest_free = largest_free__039_
               ; fragments = fragments__041_
               ; compactions = compactions__043_
               ; top_heap_words = top_heap_words__045_
               ; stack_size = stack_size__047_
               } ->
             let bnds__016_ = ([] : _ Stdlib.List.t) in
             let bnds__016_ =
               let arg__048_ = sexp_of_int stack_size__047_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__048_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__046_ = sexp_of_int top_heap_words__045_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__046_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__044_ = sexp_of_int compactions__043_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__044_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__042_ = sexp_of_int fragments__041_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__042_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__040_ = sexp_of_int largest_free__039_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__040_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__038_ = sexp_of_int free_blocks__037_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__038_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__036_ = sexp_of_int free_words__035_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__036_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__034_ = sexp_of_int live_blocks__033_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__034_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__032_ = sexp_of_int live_words__031_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__032_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__030_ = sexp_of_int heap_chunks__029_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__030_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__028_ = sexp_of_int heap_words__027_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__028_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__026_ = sexp_of_int major_collections__025_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__026_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__024_ = sexp_of_int minor_collections__023_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__024_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__022_ = sexp_of_float major_words__021_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__022_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__020_ = sexp_of_float promoted_words__019_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__020_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             let bnds__016_ =
               let arg__018_ = sexp_of_float minor_words__017_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__018_ ]
                :: bnds__016_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__016_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 = struct
      type t =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        ; forced_major_collections : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:40:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ; "forced_major_collections", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v16) in
            Bin_prot.Common.( + ) size (bin_size_int v17)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            let pos = bin_write_int buf ~pos v16 in
            bin_write_int buf ~pos v17
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          let v_forced_major_collections = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          ; forced_major_collections = v_forced_major_collections
          }
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
          (fun a__049_ b__050_ ->
             if Stdlib.( == ) a__049_ b__050_
             then 0
             else (
               match compare_float a__049_.minor_words b__050_.minor_words with
               | 0 ->
                 (match compare_float a__049_.promoted_words b__050_.promoted_words with
                  | 0 ->
                    (match compare_float a__049_.major_words b__050_.major_words with
                     | 0 ->
                       (match
                          compare_int a__049_.minor_collections b__050_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__049_.major_collections
                               b__050_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__049_.heap_words b__050_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__049_.heap_chunks b__050_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__049_.live_words b__050_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__049_.live_blocks
                                           b__050_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__049_.free_words
                                              b__050_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__049_.free_blocks
                                                 b__050_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__049_.largest_free
                                                    b__050_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__049_.fragments
                                                       b__050_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__049_.compactions
                                                          b__050_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__049_.top_heap_words
                                                             b__050_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           (match
                                                              compare_int
                                                                a__049_.stack_size
                                                                b__050_.stack_size
                                                            with
                                                            | 0 ->
                                                              compare_int
                                                                a__049_
                                                                  .forced_major_collections
                                                                b__050_
                                                                  .forced_major_collections
                                                            | n -> n)
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__051_ b__052_ ->
             if Stdlib.( == ) a__051_ b__052_
             then true
             else
               Stdlib.( && )
                 (equal_float a__051_.minor_words b__052_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__051_.promoted_words b__052_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__051_.major_words b__052_.major_words)
                       (Stdlib.( && )
                          (equal_int a__051_.minor_collections b__052_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__051_.major_collections
                                b__052_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__051_.heap_words b__052_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__051_.heap_chunks b__052_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__051_.live_words b__052_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__051_.live_blocks
                                            b__052_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__051_.free_words
                                               b__052_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__051_.free_blocks
                                                  b__052_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__051_.largest_free
                                                     b__052_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__051_.fragments
                                                        b__052_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__051_.compactions
                                                           b__052_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__051_.top_heap_words
                                                              b__052_.top_heap_words)
                                                           (Stdlib.( && )
                                                              (equal_int
                                                                 a__051_.stack_size
                                                                 b__052_.stack_size)
                                                              (equal_int
                                                                 a__051_
                                                                   .forced_major_collections
                                                                 b__052_
                                                                   .forced_major_collections))))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv =
                                          let hsv = hsv in
                                          hash_fold_float hsv arg.minor_words
                                        in
                                        hash_fold_float hsv arg.promoted_words
                                      in
                                      hash_fold_float hsv arg.major_words
                                    in
                                    hash_fold_int hsv arg.minor_collections
                                  in
                                  hash_fold_int hsv arg.major_collections
                                in
                                hash_fold_int hsv arg.heap_words
                              in
                              hash_fold_int hsv arg.heap_chunks
                            in
                            hash_fold_int hsv arg.live_words
                          in
                          hash_fold_int hsv arg.live_blocks
                        in
                        hash_fold_int hsv arg.free_words
                      in
                      hash_fold_int hsv arg.free_blocks
                    in
                    hash_fold_int hsv arg.largest_free
                  in
                  hash_fold_int hsv arg.fragments
                in
                hash_fold_int hsv arg.compactions
              in
              hash_fold_int hsv arg.top_heap_words
            in
            hash_fold_int hsv arg.stack_size
          in
          hash_fold_int hsv arg.forced_major_collections
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
          (let error_source__054_ = "gc.ml.before-ppx.Stable.Stat.V2.t" in
           fun x__055_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__054_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "forced_major_collections"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | "forced_major_collections" -> 16
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , ( top_heap_words
                                               , ( stack_size
                                                 , (forced_major_collections, ()) ) ) ) )
                                         ) ) ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  ; forced_major_collections
                  }
                  : t))
               x__055_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__057_
               ; promoted_words = promoted_words__059_
               ; major_words = major_words__061_
               ; minor_collections = minor_collections__063_
               ; major_collections = major_collections__065_
               ; heap_words = heap_words__067_
               ; heap_chunks = heap_chunks__069_
               ; live_words = live_words__071_
               ; live_blocks = live_blocks__073_
               ; free_words = free_words__075_
               ; free_blocks = free_blocks__077_
               ; largest_free = largest_free__079_
               ; fragments = fragments__081_
               ; compactions = compactions__083_
               ; top_heap_words = top_heap_words__085_
               ; stack_size = stack_size__087_
               ; forced_major_collections = forced_major_collections__089_
               } ->
             let bnds__056_ = ([] : _ Stdlib.List.t) in
             let bnds__056_ =
               let arg__090_ = sexp_of_int forced_major_collections__089_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "forced_major_collections"; arg__090_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__088_ = sexp_of_int stack_size__087_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__088_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__086_ = sexp_of_int top_heap_words__085_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__086_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__084_ = sexp_of_int compactions__083_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__084_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__082_ = sexp_of_int fragments__081_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__082_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__080_ = sexp_of_int largest_free__079_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__080_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__078_ = sexp_of_int free_blocks__077_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__078_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__076_ = sexp_of_int free_words__075_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__076_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__074_ = sexp_of_int live_blocks__073_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__074_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__072_ = sexp_of_int live_words__071_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__072_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__070_ = sexp_of_int heap_chunks__069_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__070_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__068_ = sexp_of_int heap_words__067_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__068_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__066_ = sexp_of_int major_collections__065_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__066_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__064_ = sexp_of_int minor_collections__063_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__064_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__062_ = sexp_of_float major_words__061_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__062_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__060_ = sexp_of_float promoted_words__059_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__060_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             let bnds__056_ =
               let arg__058_ = sexp_of_float minor_words__057_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__058_ ]
                :: bnds__056_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__056_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    [%%elif ocaml_version < (5, 5, 0)]

    module V1 = struct
      type t =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:65:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            Bin_prot.Common.( + ) size (bin_size_int v16)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            bin_write_int buf ~pos v16
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          }
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
          (fun a__091_ b__092_ ->
             if Stdlib.( == ) a__091_ b__092_
             then 0
             else (
               match compare_float a__091_.minor_words b__092_.minor_words with
               | 0 ->
                 (match compare_float a__091_.promoted_words b__092_.promoted_words with
                  | 0 ->
                    (match compare_float a__091_.major_words b__092_.major_words with
                     | 0 ->
                       (match
                          compare_int a__091_.minor_collections b__092_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__091_.major_collections
                               b__092_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__091_.heap_words b__092_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__091_.heap_chunks b__092_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__091_.live_words b__092_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__091_.live_blocks
                                           b__092_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__091_.free_words
                                              b__092_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__091_.free_blocks
                                                 b__092_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__091_.largest_free
                                                    b__092_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__091_.fragments
                                                       b__092_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__091_.compactions
                                                          b__092_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__091_.top_heap_words
                                                             b__092_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           compare_int
                                                             a__091_.stack_size
                                                             b__092_.stack_size
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__093_ b__094_ ->
             if Stdlib.( == ) a__093_ b__094_
             then true
             else
               Stdlib.( && )
                 (equal_float a__093_.minor_words b__094_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__093_.promoted_words b__094_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__093_.major_words b__094_.major_words)
                       (Stdlib.( && )
                          (equal_int a__093_.minor_collections b__094_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__093_.major_collections
                                b__094_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__093_.heap_words b__094_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__093_.heap_chunks b__094_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__093_.live_words b__094_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__093_.live_blocks
                                            b__094_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__093_.free_words
                                               b__094_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__093_.free_blocks
                                                  b__094_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__093_.largest_free
                                                     b__094_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__093_.fragments
                                                        b__094_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__093_.compactions
                                                           b__094_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__093_.top_heap_words
                                                              b__094_.top_heap_words)
                                                           (equal_int
                                                              a__093_.stack_size
                                                              b__094_.stack_size)))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv = hsv in
                                        hash_fold_float hsv arg.minor_words
                                      in
                                      hash_fold_float hsv arg.promoted_words
                                    in
                                    hash_fold_float hsv arg.major_words
                                  in
                                  hash_fold_int hsv arg.minor_collections
                                in
                                hash_fold_int hsv arg.major_collections
                              in
                              hash_fold_int hsv arg.heap_words
                            in
                            hash_fold_int hsv arg.heap_chunks
                          in
                          hash_fold_int hsv arg.live_words
                        in
                        hash_fold_int hsv arg.live_blocks
                      in
                      hash_fold_int hsv arg.free_words
                    in
                    hash_fold_int hsv arg.free_blocks
                  in
                  hash_fold_int hsv arg.largest_free
                in
                hash_fold_int hsv arg.fragments
              in
              hash_fold_int hsv arg.compactions
            in
            hash_fold_int hsv arg.top_heap_words
          in
          hash_fold_int hsv arg.stack_size
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
          (let error_source__096_ = "gc.ml.before-ppx.Stable.Stat.V1.t" in
           fun x__097_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__096_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , (top_heap_words, (stack_size, ())) ) ) ) )
                                     ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  }
                  : t))
               x__097_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__099_
               ; promoted_words = promoted_words__101_
               ; major_words = major_words__103_
               ; minor_collections = minor_collections__105_
               ; major_collections = major_collections__107_
               ; heap_words = heap_words__109_
               ; heap_chunks = heap_chunks__111_
               ; live_words = live_words__113_
               ; live_blocks = live_blocks__115_
               ; free_words = free_words__117_
               ; free_blocks = free_blocks__119_
               ; largest_free = largest_free__121_
               ; fragments = fragments__123_
               ; compactions = compactions__125_
               ; top_heap_words = top_heap_words__127_
               ; stack_size = stack_size__129_
               } ->
             let bnds__098_ = ([] : _ Stdlib.List.t) in
             let bnds__098_ =
               let arg__130_ = sexp_of_int stack_size__129_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__130_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__128_ = sexp_of_int top_heap_words__127_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__128_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__126_ = sexp_of_int compactions__125_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__126_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__124_ = sexp_of_int fragments__123_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__124_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__122_ = sexp_of_int largest_free__121_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__122_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__120_ = sexp_of_int free_blocks__119_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__120_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__118_ = sexp_of_int free_words__117_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__118_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__116_ = sexp_of_int live_blocks__115_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__116_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__114_ = sexp_of_int live_words__113_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__114_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__112_ = sexp_of_int heap_chunks__111_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__112_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__110_ = sexp_of_int heap_words__109_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__110_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__108_ = sexp_of_int major_collections__107_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__108_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__106_ = sexp_of_int minor_collections__105_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__106_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__104_ = sexp_of_float major_words__103_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__104_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__102_ = sexp_of_float promoted_words__101_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__102_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             let bnds__098_ =
               let arg__100_ = sexp_of_float minor_words__099_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__100_ ]
                :: bnds__098_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__098_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 = struct
      type t = Stdlib.Gc.stat =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        ; forced_major_collections : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:87:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ; "forced_major_collections", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v16) in
            Bin_prot.Common.( + ) size (bin_size_int v17)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            let pos = bin_write_int buf ~pos v16 in
            bin_write_int buf ~pos v17
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          let v_forced_major_collections = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          ; forced_major_collections = v_forced_major_collections
          }
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
          (fun a__131_ b__132_ ->
             if Stdlib.( == ) a__131_ b__132_
             then 0
             else (
               match compare_float a__131_.minor_words b__132_.minor_words with
               | 0 ->
                 (match compare_float a__131_.promoted_words b__132_.promoted_words with
                  | 0 ->
                    (match compare_float a__131_.major_words b__132_.major_words with
                     | 0 ->
                       (match
                          compare_int a__131_.minor_collections b__132_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__131_.major_collections
                               b__132_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__131_.heap_words b__132_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__131_.heap_chunks b__132_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__131_.live_words b__132_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__131_.live_blocks
                                           b__132_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__131_.free_words
                                              b__132_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__131_.free_blocks
                                                 b__132_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__131_.largest_free
                                                    b__132_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__131_.fragments
                                                       b__132_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__131_.compactions
                                                          b__132_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__131_.top_heap_words
                                                             b__132_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           (match
                                                              compare_int
                                                                a__131_.stack_size
                                                                b__132_.stack_size
                                                            with
                                                            | 0 ->
                                                              compare_int
                                                                a__131_
                                                                  .forced_major_collections
                                                                b__132_
                                                                  .forced_major_collections
                                                            | n -> n)
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__133_ b__134_ ->
             if Stdlib.( == ) a__133_ b__134_
             then true
             else
               Stdlib.( && )
                 (equal_float a__133_.minor_words b__134_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__133_.promoted_words b__134_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__133_.major_words b__134_.major_words)
                       (Stdlib.( && )
                          (equal_int a__133_.minor_collections b__134_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__133_.major_collections
                                b__134_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__133_.heap_words b__134_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__133_.heap_chunks b__134_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__133_.live_words b__134_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__133_.live_blocks
                                            b__134_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__133_.free_words
                                               b__134_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__133_.free_blocks
                                                  b__134_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__133_.largest_free
                                                     b__134_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__133_.fragments
                                                        b__134_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__133_.compactions
                                                           b__134_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__133_.top_heap_words
                                                              b__134_.top_heap_words)
                                                           (Stdlib.( && )
                                                              (equal_int
                                                                 a__133_.stack_size
                                                                 b__134_.stack_size)
                                                              (equal_int
                                                                 a__133_
                                                                   .forced_major_collections
                                                                 b__134_
                                                                   .forced_major_collections))))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv =
                                          let hsv = hsv in
                                          hash_fold_float hsv arg.minor_words
                                        in
                                        hash_fold_float hsv arg.promoted_words
                                      in
                                      hash_fold_float hsv arg.major_words
                                    in
                                    hash_fold_int hsv arg.minor_collections
                                  in
                                  hash_fold_int hsv arg.major_collections
                                in
                                hash_fold_int hsv arg.heap_words
                              in
                              hash_fold_int hsv arg.heap_chunks
                            in
                            hash_fold_int hsv arg.live_words
                          in
                          hash_fold_int hsv arg.live_blocks
                        in
                        hash_fold_int hsv arg.free_words
                      in
                      hash_fold_int hsv arg.free_blocks
                    in
                    hash_fold_int hsv arg.largest_free
                  in
                  hash_fold_int hsv arg.fragments
                in
                hash_fold_int hsv arg.compactions
              in
              hash_fold_int hsv arg.top_heap_words
            in
            hash_fold_int hsv arg.stack_size
          in
          hash_fold_int hsv arg.forced_major_collections
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
          (let error_source__136_ = "gc.ml.before-ppx.Stable.Stat.V2.t" in
           fun x__137_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__136_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "forced_major_collections"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | "forced_major_collections" -> 16
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , ( top_heap_words
                                               , ( stack_size
                                                 , (forced_major_collections, ()) ) ) ) )
                                         ) ) ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  ; forced_major_collections
                  }
                  : t))
               x__137_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__139_
               ; promoted_words = promoted_words__141_
               ; major_words = major_words__143_
               ; minor_collections = minor_collections__145_
               ; major_collections = major_collections__147_
               ; heap_words = heap_words__149_
               ; heap_chunks = heap_chunks__151_
               ; live_words = live_words__153_
               ; live_blocks = live_blocks__155_
               ; free_words = free_words__157_
               ; free_blocks = free_blocks__159_
               ; largest_free = largest_free__161_
               ; fragments = fragments__163_
               ; compactions = compactions__165_
               ; top_heap_words = top_heap_words__167_
               ; stack_size = stack_size__169_
               ; forced_major_collections = forced_major_collections__171_
               } ->
             let bnds__138_ = ([] : _ Stdlib.List.t) in
             let bnds__138_ =
               let arg__172_ = sexp_of_int forced_major_collections__171_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "forced_major_collections"; arg__172_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__170_ = sexp_of_int stack_size__169_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__170_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__168_ = sexp_of_int top_heap_words__167_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__168_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__166_ = sexp_of_int compactions__165_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__166_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__164_ = sexp_of_int fragments__163_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__164_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__162_ = sexp_of_int largest_free__161_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__162_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__160_ = sexp_of_int free_blocks__159_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__160_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__158_ = sexp_of_int free_words__157_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__158_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__156_ = sexp_of_int live_blocks__155_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__156_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__154_ = sexp_of_int live_words__153_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__154_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__152_ = sexp_of_int heap_chunks__151_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__152_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__150_ = sexp_of_int heap_words__149_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__150_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__148_ = sexp_of_int major_collections__147_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__148_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__146_ = sexp_of_int minor_collections__145_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__146_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__144_ = sexp_of_float major_words__143_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__144_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__142_ = sexp_of_float promoted_words__141_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__142_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             let bnds__138_ =
               let arg__140_ = sexp_of_float minor_words__139_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__140_ ]
                :: bnds__138_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__138_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    [%%else]

    module V1 = struct
      type t =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:112:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            Bin_prot.Common.( + ) size (bin_size_int v16)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            bin_write_int buf ~pos v16
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          }
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
          (fun a__173_ b__174_ ->
             if Stdlib.( == ) a__173_ b__174_
             then 0
             else (
               match compare_float a__173_.minor_words b__174_.minor_words with
               | 0 ->
                 (match compare_float a__173_.promoted_words b__174_.promoted_words with
                  | 0 ->
                    (match compare_float a__173_.major_words b__174_.major_words with
                     | 0 ->
                       (match
                          compare_int a__173_.minor_collections b__174_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__173_.major_collections
                               b__174_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__173_.heap_words b__174_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__173_.heap_chunks b__174_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__173_.live_words b__174_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__173_.live_blocks
                                           b__174_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__173_.free_words
                                              b__174_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__173_.free_blocks
                                                 b__174_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__173_.largest_free
                                                    b__174_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__173_.fragments
                                                       b__174_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__173_.compactions
                                                          b__174_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__173_.top_heap_words
                                                             b__174_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           compare_int
                                                             a__173_.stack_size
                                                             b__174_.stack_size
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__175_ b__176_ ->
             if Stdlib.( == ) a__175_ b__176_
             then true
             else
               Stdlib.( && )
                 (equal_float a__175_.minor_words b__176_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__175_.promoted_words b__176_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__175_.major_words b__176_.major_words)
                       (Stdlib.( && )
                          (equal_int a__175_.minor_collections b__176_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__175_.major_collections
                                b__176_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__175_.heap_words b__176_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__175_.heap_chunks b__176_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__175_.live_words b__176_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__175_.live_blocks
                                            b__176_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__175_.free_words
                                               b__176_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__175_.free_blocks
                                                  b__176_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__175_.largest_free
                                                     b__176_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__175_.fragments
                                                        b__176_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__175_.compactions
                                                           b__176_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__175_.top_heap_words
                                                              b__176_.top_heap_words)
                                                           (equal_int
                                                              a__175_.stack_size
                                                              b__176_.stack_size)))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv = hsv in
                                        hash_fold_float hsv arg.minor_words
                                      in
                                      hash_fold_float hsv arg.promoted_words
                                    in
                                    hash_fold_float hsv arg.major_words
                                  in
                                  hash_fold_int hsv arg.minor_collections
                                in
                                hash_fold_int hsv arg.major_collections
                              in
                              hash_fold_int hsv arg.heap_words
                            in
                            hash_fold_int hsv arg.heap_chunks
                          in
                          hash_fold_int hsv arg.live_words
                        in
                        hash_fold_int hsv arg.live_blocks
                      in
                      hash_fold_int hsv arg.free_words
                    in
                    hash_fold_int hsv arg.free_blocks
                  in
                  hash_fold_int hsv arg.largest_free
                in
                hash_fold_int hsv arg.fragments
              in
              hash_fold_int hsv arg.compactions
            in
            hash_fold_int hsv arg.top_heap_words
          in
          hash_fold_int hsv arg.stack_size
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
          (let error_source__178_ = "gc.ml.before-ppx.Stable.Stat.V1.t" in
           fun x__179_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__178_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , (top_heap_words, (stack_size, ())) ) ) ) )
                                     ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  }
                  : t))
               x__179_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__181_
               ; promoted_words = promoted_words__183_
               ; major_words = major_words__185_
               ; minor_collections = minor_collections__187_
               ; major_collections = major_collections__189_
               ; heap_words = heap_words__191_
               ; heap_chunks = heap_chunks__193_
               ; live_words = live_words__195_
               ; live_blocks = live_blocks__197_
               ; free_words = free_words__199_
               ; free_blocks = free_blocks__201_
               ; largest_free = largest_free__203_
               ; fragments = fragments__205_
               ; compactions = compactions__207_
               ; top_heap_words = top_heap_words__209_
               ; stack_size = stack_size__211_
               } ->
             let bnds__180_ = ([] : _ Stdlib.List.t) in
             let bnds__180_ =
               let arg__212_ = sexp_of_int stack_size__211_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__212_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__210_ = sexp_of_int top_heap_words__209_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__210_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__208_ = sexp_of_int compactions__207_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__208_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__206_ = sexp_of_int fragments__205_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__206_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__204_ = sexp_of_int largest_free__203_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__204_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__202_ = sexp_of_int free_blocks__201_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__202_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__200_ = sexp_of_int free_words__199_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__200_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__198_ = sexp_of_int live_blocks__197_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__198_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__196_ = sexp_of_int live_words__195_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__196_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__194_ = sexp_of_int heap_chunks__193_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__194_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__192_ = sexp_of_int heap_words__191_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__192_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__190_ = sexp_of_int major_collections__189_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__190_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__188_ = sexp_of_int minor_collections__187_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__188_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__186_ = sexp_of_float major_words__185_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__186_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__184_ = sexp_of_float promoted_words__183_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__184_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             let bnds__180_ =
               let arg__182_ = sexp_of_float minor_words__181_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__182_ ]
                :: bnds__180_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__180_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 = struct
      type t = Stdlib.Gc.stat =
        { minor_words : float
        ; promoted_words : float
        ; major_words : float
        ; minor_collections : int
        ; major_collections : int
        ; heap_words : int
        ; heap_chunks : int
        ; live_words : int
        ; live_blocks : int
        ; free_words : int
        ; free_blocks : int
        ; largest_free : int
        ; fragments : int
        ; compactions : int
        ; top_heap_words : int
        ; stack_size : int
        ; forced_major_collections : int
        ; live_stacks_words : int
        }
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:134:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_words", bin_shape_float
                    ; "promoted_words", bin_shape_float
                    ; "major_words", bin_shape_float
                    ; "minor_collections", bin_shape_int
                    ; "major_collections", bin_shape_int
                    ; "heap_words", bin_shape_int
                    ; "heap_chunks", bin_shape_int
                    ; "live_words", bin_shape_int
                    ; "live_blocks", bin_shape_int
                    ; "free_words", bin_shape_int
                    ; "free_blocks", bin_shape_int
                    ; "largest_free", bin_shape_int
                    ; "fragments", bin_shape_int
                    ; "compactions", bin_shape_int
                    ; "top_heap_words", bin_shape_int
                    ; "stack_size", bin_shape_int
                    ; "forced_major_collections", bin_shape_int
                    ; "live_stacks_words", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            ; live_stacks_words = v18
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v16) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v17) in
            Bin_prot.Common.( + ) size (bin_size_int v18)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_words = v1
            ; promoted_words = v2
            ; major_words = v3
            ; minor_collections = v4
            ; major_collections = v5
            ; heap_words = v6
            ; heap_chunks = v7
            ; live_words = v8
            ; live_blocks = v9
            ; free_words = v10
            ; free_blocks = v11
            ; largest_free = v12
            ; fragments = v13
            ; compactions = v14
            ; top_heap_words = v15
            ; stack_size = v16
            ; forced_major_collections = v17
            ; live_stacks_words = v18
            } ->
            let pos = bin_write_float buf ~pos v1 in
            let pos = bin_write_float buf ~pos v2 in
            let pos = bin_write_float buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            let pos = bin_write_int buf ~pos v11 in
            let pos = bin_write_int buf ~pos v12 in
            let pos = bin_write_int buf ~pos v13 in
            let pos = bin_write_int buf ~pos v14 in
            let pos = bin_write_int buf ~pos v15 in
            let pos = bin_write_int buf ~pos v16 in
            let pos = bin_write_int buf ~pos v17 in
            bin_write_int buf ~pos v18
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Stat.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_words = bin_read_float buf ~pos_ref in
          let v_promoted_words = bin_read_float buf ~pos_ref in
          let v_major_words = bin_read_float buf ~pos_ref in
          let v_minor_collections = bin_read_int buf ~pos_ref in
          let v_major_collections = bin_read_int buf ~pos_ref in
          let v_heap_words = bin_read_int buf ~pos_ref in
          let v_heap_chunks = bin_read_int buf ~pos_ref in
          let v_live_words = bin_read_int buf ~pos_ref in
          let v_live_blocks = bin_read_int buf ~pos_ref in
          let v_free_words = bin_read_int buf ~pos_ref in
          let v_free_blocks = bin_read_int buf ~pos_ref in
          let v_largest_free = bin_read_int buf ~pos_ref in
          let v_fragments = bin_read_int buf ~pos_ref in
          let v_compactions = bin_read_int buf ~pos_ref in
          let v_top_heap_words = bin_read_int buf ~pos_ref in
          let v_stack_size = bin_read_int buf ~pos_ref in
          let v_forced_major_collections = bin_read_int buf ~pos_ref in
          let v_live_stacks_words = bin_read_int buf ~pos_ref in
          { minor_words = v_minor_words
          ; promoted_words = v_promoted_words
          ; major_words = v_major_words
          ; minor_collections = v_minor_collections
          ; major_collections = v_major_collections
          ; heap_words = v_heap_words
          ; heap_chunks = v_heap_chunks
          ; live_words = v_live_words
          ; live_blocks = v_live_blocks
          ; free_words = v_free_words
          ; free_blocks = v_free_blocks
          ; largest_free = v_largest_free
          ; fragments = v_fragments
          ; compactions = v_compactions
          ; top_heap_words = v_top_heap_words
          ; stack_size = v_stack_size
          ; forced_major_collections = v_forced_major_collections
          ; live_stacks_words = v_live_stacks_words
          }
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
          (fun a__213_ b__214_ ->
             if Stdlib.( == ) a__213_ b__214_
             then 0
             else (
               match compare_float a__213_.minor_words b__214_.minor_words with
               | 0 ->
                 (match compare_float a__213_.promoted_words b__214_.promoted_words with
                  | 0 ->
                    (match compare_float a__213_.major_words b__214_.major_words with
                     | 0 ->
                       (match
                          compare_int a__213_.minor_collections b__214_.minor_collections
                        with
                        | 0 ->
                          (match
                             compare_int
                               a__213_.major_collections
                               b__214_.major_collections
                           with
                           | 0 ->
                             (match compare_int a__213_.heap_words b__214_.heap_words with
                              | 0 ->
                                (match
                                   compare_int a__213_.heap_chunks b__214_.heap_chunks
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__213_.live_words b__214_.live_words
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__213_.live_blocks
                                           b__214_.live_blocks
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__213_.free_words
                                              b__214_.free_words
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__213_.free_blocks
                                                 b__214_.free_blocks
                                             with
                                             | 0 ->
                                               (match
                                                  compare_int
                                                    a__213_.largest_free
                                                    b__214_.largest_free
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_int
                                                       a__213_.fragments
                                                       b__214_.fragments
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_int
                                                          a__213_.compactions
                                                          b__214_.compactions
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_int
                                                             a__213_.top_heap_words
                                                             b__214_.top_heap_words
                                                         with
                                                         | 0 ->
                                                           (match
                                                              compare_int
                                                                a__213_.stack_size
                                                                b__214_.stack_size
                                                            with
                                                            | 0 ->
                                                              (match
                                                                 compare_int
                                                                   a__213_
                                                                     .forced_major_collections
                                                                   b__214_
                                                                     .forced_major_collections
                                                               with
                                                               | 0 ->
                                                                 compare_int
                                                                   a__213_
                                                                     .live_stacks_words
                                                                   b__214_
                                                                     .live_stacks_words
                                                               | n -> n)
                                                            | n -> n)
                                                         | n -> n)
                                                      | n -> n)
                                                   | n -> n)
                                                | n -> n)
                                             | n -> n)
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__215_ b__216_ ->
             if Stdlib.( == ) a__215_ b__216_
             then true
             else
               Stdlib.( && )
                 (equal_float a__215_.minor_words b__216_.minor_words)
                 (Stdlib.( && )
                    (equal_float a__215_.promoted_words b__216_.promoted_words)
                    (Stdlib.( && )
                       (equal_float a__215_.major_words b__216_.major_words)
                       (Stdlib.( && )
                          (equal_int a__215_.minor_collections b__216_.minor_collections)
                          (Stdlib.( && )
                             (equal_int
                                a__215_.major_collections
                                b__216_.major_collections)
                             (Stdlib.( && )
                                (equal_int a__215_.heap_words b__216_.heap_words)
                                (Stdlib.( && )
                                   (equal_int a__215_.heap_chunks b__216_.heap_chunks)
                                   (Stdlib.( && )
                                      (equal_int a__215_.live_words b__216_.live_words)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__215_.live_blocks
                                            b__216_.live_blocks)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__215_.free_words
                                               b__216_.free_words)
                                            (Stdlib.( && )
                                               (equal_int
                                                  a__215_.free_blocks
                                                  b__216_.free_blocks)
                                               (Stdlib.( && )
                                                  (equal_int
                                                     a__215_.largest_free
                                                     b__216_.largest_free)
                                                  (Stdlib.( && )
                                                     (equal_int
                                                        a__215_.fragments
                                                        b__216_.fragments)
                                                     (Stdlib.( && )
                                                        (equal_int
                                                           a__215_.compactions
                                                           b__216_.compactions)
                                                        (Stdlib.( && )
                                                           (equal_int
                                                              a__215_.top_heap_words
                                                              b__216_.top_heap_words)
                                                           (Stdlib.( && )
                                                              (equal_int
                                                                 a__215_.stack_size
                                                                 b__216_.stack_size)
                                                              (Stdlib.( && )
                                                                 (equal_int
                                                                    a__215_
                                                                      .forced_major_collections
                                                                    b__216_
                                                                      .forced_major_collections)
                                                                 (equal_int
                                                                    a__215_
                                                                      .live_stacks_words
                                                                    b__216_
                                                                      .live_stacks_words)))))))))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv =
                                          let hsv =
                                            let hsv = hsv in
                                            hash_fold_float hsv arg.minor_words
                                          in
                                          hash_fold_float hsv arg.promoted_words
                                        in
                                        hash_fold_float hsv arg.major_words
                                      in
                                      hash_fold_int hsv arg.minor_collections
                                    in
                                    hash_fold_int hsv arg.major_collections
                                  in
                                  hash_fold_int hsv arg.heap_words
                                in
                                hash_fold_int hsv arg.heap_chunks
                              in
                              hash_fold_int hsv arg.live_words
                            in
                            hash_fold_int hsv arg.live_blocks
                          in
                          hash_fold_int hsv arg.free_words
                        in
                        hash_fold_int hsv arg.free_blocks
                      in
                      hash_fold_int hsv arg.largest_free
                    in
                    hash_fold_int hsv arg.fragments
                  in
                  hash_fold_int hsv arg.compactions
                in
                hash_fold_int hsv arg.top_heap_words
              in
              hash_fold_int hsv arg.stack_size
            in
            hash_fold_int hsv arg.forced_major_collections
          in
          hash_fold_int hsv arg.live_stacks_words
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
          (let error_source__218_ = "gc.ml.before-ppx.Stable.Stat.V2.t" in
           fun x__219_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__218_
               ~fields:
                 (Field
                    { name = "minor_words"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "promoted_words"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "major_words"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest =
                                    Field
                                      { name = "minor_collections"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "major_collections"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "heap_words"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "heap_chunks"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "live_words"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "live_blocks"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "free_words"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "free_blocks"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "largest_free"
                                                                                      ; kind =
                                                                                          Required
                                                                                      ; conv =
                                                                                          int_of_sexp
                                                                                      ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "forced_major_collections"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "live_stacks_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_words" -> 0
                 | "promoted_words" -> 1
                 | "major_words" -> 2
                 | "minor_collections" -> 3
                 | "major_collections" -> 4
                 | "heap_words" -> 5
                 | "heap_chunks" -> 6
                 | "live_words" -> 7
                 | "live_blocks" -> 8
                 | "free_words" -> 9
                 | "free_blocks" -> 10
                 | "largest_free" -> 11
                 | "fragments" -> 12
                 | "compactions" -> 13
                 | "top_heap_words" -> 14
                 | "stack_size" -> 15
                 | "forced_major_collections" -> 16
                 | "live_stacks_words" -> 17
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_words
                   , ( promoted_words
                     , ( major_words
                       , ( minor_collections
                         , ( major_collections
                           , ( heap_words
                             , ( heap_chunks
                               , ( live_words
                                 , ( live_blocks
                                   , ( free_words
                                     , ( free_blocks
                                       , ( largest_free
                                         , ( fragments
                                           , ( compactions
                                             , ( top_heap_words
                                               , ( stack_size
                                                 , ( forced_major_collections
                                                   , (live_stacks_words, ()) ) ) ) ) ) )
                                       ) ) ) ) ) ) ) ) ) ) ) ->
                 ({ minor_words
                  ; promoted_words
                  ; major_words
                  ; minor_collections
                  ; major_collections
                  ; heap_words
                  ; heap_chunks
                  ; live_words
                  ; live_blocks
                  ; free_words
                  ; free_blocks
                  ; largest_free
                  ; fragments
                  ; compactions
                  ; top_heap_words
                  ; stack_size
                  ; forced_major_collections
                  ; live_stacks_words
                  }
                  : t))
               x__219_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_words = minor_words__221_
               ; promoted_words = promoted_words__223_
               ; major_words = major_words__225_
               ; minor_collections = minor_collections__227_
               ; major_collections = major_collections__229_
               ; heap_words = heap_words__231_
               ; heap_chunks = heap_chunks__233_
               ; live_words = live_words__235_
               ; live_blocks = live_blocks__237_
               ; free_words = free_words__239_
               ; free_blocks = free_blocks__241_
               ; largest_free = largest_free__243_
               ; fragments = fragments__245_
               ; compactions = compactions__247_
               ; top_heap_words = top_heap_words__249_
               ; stack_size = stack_size__251_
               ; forced_major_collections = forced_major_collections__253_
               ; live_stacks_words = live_stacks_words__255_
               } ->
             let bnds__220_ = ([] : _ Stdlib.List.t) in
             let bnds__220_ =
               let arg__256_ = sexp_of_int live_stacks_words__255_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_stacks_words"; arg__256_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__254_ = sexp_of_int forced_major_collections__253_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "forced_major_collections"; arg__254_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__252_ = sexp_of_int stack_size__251_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__252_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__250_ = sexp_of_int top_heap_words__249_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__250_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__248_ = sexp_of_int compactions__247_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__248_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__246_ = sexp_of_int fragments__245_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__246_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__244_ = sexp_of_int largest_free__243_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__244_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__242_ = sexp_of_int free_blocks__241_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__242_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__240_ = sexp_of_int free_words__239_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__240_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__238_ = sexp_of_int live_blocks__237_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__238_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__236_ = sexp_of_int live_words__235_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__236_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__234_ = sexp_of_int heap_chunks__233_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__234_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__232_ = sexp_of_int heap_words__231_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__232_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__230_ = sexp_of_int major_collections__229_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__230_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__228_ = sexp_of_int minor_collections__227_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__228_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__226_ = sexp_of_float major_words__225_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__226_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__224_ = sexp_of_float promoted_words__223_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__224_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             let bnds__220_ =
               let arg__222_ = sexp_of_float minor_words__221_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__222_ ]
                :: bnds__220_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__220_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : float Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_float
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    [%%endif]
  end

  module Control = struct
    [%%if ocaml_version < (5, 0, 0)]

    module V1 = struct
      [@@@ocaml.warning "-3"]

      type t = Stdlib.Gc.control =
        { mutable minor_heap_size : int
        ; mutable major_heap_increment : int
        ; mutable space_overhead : int
        ; mutable verbose : int
        ; mutable max_overhead : int
        ; mutable stack_limit : int
        ; mutable allocation_policy : int
        ; window_size : int
        ; custom_major_ratio : int
        ; custom_minor_ratio : int
        ; custom_minor_max_size : int
        }
      [@@deriving bin_io, compare, equal, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:166:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_heap_size", bin_shape_int
                    ; "major_heap_increment", bin_shape_int
                    ; "space_overhead", bin_shape_int
                    ; "verbose", bin_shape_int
                    ; "max_overhead", bin_shape_int
                    ; "stack_limit", bin_shape_int
                    ; "allocation_policy", bin_shape_int
                    ; "window_size", bin_shape_int
                    ; "custom_major_ratio", bin_shape_int
                    ; "custom_minor_ratio", bin_shape_int
                    ; "custom_minor_max_size", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_heap_size = v1
            ; major_heap_increment = v2
            ; space_overhead = v3
            ; verbose = v4
            ; max_overhead = v5
            ; stack_limit = v6
            ; allocation_policy = v7
            ; window_size = v8
            ; custom_major_ratio = v9
            ; custom_minor_ratio = v10
            ; custom_minor_max_size = v11
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            Bin_prot.Common.( + ) size (bin_size_int v11)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_heap_size = v1
            ; major_heap_increment = v2
            ; space_overhead = v3
            ; verbose = v4
            ; max_overhead = v5
            ; stack_limit = v6
            ; allocation_policy = v7
            ; window_size = v8
            ; custom_major_ratio = v9
            ; custom_minor_ratio = v10
            ; custom_minor_max_size = v11
            } ->
            let pos = bin_write_int buf ~pos v1 in
            let pos = bin_write_int buf ~pos v2 in
            let pos = bin_write_int buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            bin_write_int buf ~pos v11
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Control.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_heap_size = bin_read_int buf ~pos_ref in
          let v_major_heap_increment = bin_read_int buf ~pos_ref in
          let v_space_overhead = bin_read_int buf ~pos_ref in
          let v_verbose = bin_read_int buf ~pos_ref in
          let v_max_overhead = bin_read_int buf ~pos_ref in
          let v_stack_limit = bin_read_int buf ~pos_ref in
          let v_allocation_policy = bin_read_int buf ~pos_ref in
          let v_window_size = bin_read_int buf ~pos_ref in
          let v_custom_major_ratio = bin_read_int buf ~pos_ref in
          let v_custom_minor_ratio = bin_read_int buf ~pos_ref in
          let v_custom_minor_max_size = bin_read_int buf ~pos_ref in
          { minor_heap_size = v_minor_heap_size
          ; major_heap_increment = v_major_heap_increment
          ; space_overhead = v_space_overhead
          ; verbose = v_verbose
          ; max_overhead = v_max_overhead
          ; stack_limit = v_stack_limit
          ; allocation_policy = v_allocation_policy
          ; window_size = v_window_size
          ; custom_major_ratio = v_custom_major_ratio
          ; custom_minor_ratio = v_custom_minor_ratio
          ; custom_minor_max_size = v_custom_minor_max_size
          }
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
          (fun a__257_ b__258_ ->
             if Stdlib.( == ) a__257_ b__258_
             then 0
             else (
               match compare_int a__257_.minor_heap_size b__258_.minor_heap_size with
               | 0 ->
                 (match
                    compare_int a__257_.major_heap_increment b__258_.major_heap_increment
                  with
                  | 0 ->
                    (match compare_int a__257_.space_overhead b__258_.space_overhead with
                     | 0 ->
                       (match compare_int a__257_.verbose b__258_.verbose with
                        | 0 ->
                          (match
                             compare_int a__257_.max_overhead b__258_.max_overhead
                           with
                           | 0 ->
                             (match
                                compare_int a__257_.stack_limit b__258_.stack_limit
                              with
                              | 0 ->
                                (match
                                   compare_int
                                     a__257_.allocation_policy
                                     b__258_.allocation_policy
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__257_.window_size b__258_.window_size
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__257_.custom_major_ratio
                                           b__258_.custom_major_ratio
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__257_.custom_minor_ratio
                                              b__258_.custom_minor_ratio
                                          with
                                          | 0 ->
                                            compare_int
                                              a__257_.custom_minor_max_size
                                              b__258_.custom_minor_max_size
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__259_ b__260_ ->
             if Stdlib.( == ) a__259_ b__260_
             then true
             else
               Stdlib.( && )
                 (equal_int a__259_.minor_heap_size b__260_.minor_heap_size)
                 (Stdlib.( && )
                    (equal_int a__259_.major_heap_increment b__260_.major_heap_increment)
                    (Stdlib.( && )
                       (equal_int a__259_.space_overhead b__260_.space_overhead)
                       (Stdlib.( && )
                          (equal_int a__259_.verbose b__260_.verbose)
                          (Stdlib.( && )
                             (equal_int a__259_.max_overhead b__260_.max_overhead)
                             (Stdlib.( && )
                                (equal_int a__259_.stack_limit b__260_.stack_limit)
                                (Stdlib.( && )
                                   (equal_int
                                      a__259_.allocation_policy
                                      b__260_.allocation_policy)
                                   (Stdlib.( && )
                                      (equal_int a__259_.window_size b__260_.window_size)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__259_.custom_major_ratio
                                            b__260_.custom_major_ratio)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__259_.custom_minor_ratio
                                               b__260_.custom_minor_ratio)
                                            (equal_int
                                               a__259_.custom_minor_max_size
                                               b__260_.custom_minor_max_size))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let t_of_sexp =
          (let error_source__262_ = "gc.ml.before-ppx.Stable.Control.V1.t" in
           fun x__263_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__262_
               ~fields:
                 (Field
                    { name = "minor_heap_size"
                    ; kind = Required
                    ; conv = int_of_sexp
                    ; rest =
                        Field
                          { name = "major_heap_increment"
                          ; kind = Required
                          ; conv = int_of_sexp
                          ; rest =
                              Field
                                { name = "space_overhead"
                                ; kind = Required
                                ; conv = int_of_sexp
                                ; rest =
                                    Field
                                      { name = "verbose"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "max_overhead"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "stack_limit"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "allocation_policy"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "window_size"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name =
                                                                        "custom_major_ratio"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "custom_minor_ratio"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "custom_minor_max_size"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Empty
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_heap_size" -> 0
                 | "major_heap_increment" -> 1
                 | "space_overhead" -> 2
                 | "verbose" -> 3
                 | "max_overhead" -> 4
                 | "stack_limit" -> 5
                 | "allocation_policy" -> 6
                 | "window_size" -> 7
                 | "custom_major_ratio" -> 8
                 | "custom_minor_ratio" -> 9
                 | "custom_minor_max_size" -> 10
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_heap_size
                   , ( major_heap_increment
                     , ( space_overhead
                       , ( verbose
                         , ( max_overhead
                           , ( stack_limit
                             , ( allocation_policy
                               , ( window_size
                                 , ( custom_major_ratio
                                   , (custom_minor_ratio, (custom_minor_max_size, ())) )
                                 ) ) ) ) ) ) ) ) ->
                 ({ minor_heap_size
                  ; major_heap_increment
                  ; space_overhead
                  ; verbose
                  ; max_overhead
                  ; stack_limit
                  ; allocation_policy
                  ; window_size
                  ; custom_major_ratio
                  ; custom_minor_ratio
                  ; custom_minor_max_size
                  }
                  : t))
               x__263_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_heap_size = minor_heap_size__265_
               ; major_heap_increment = major_heap_increment__267_
               ; space_overhead = space_overhead__269_
               ; verbose = verbose__271_
               ; max_overhead = max_overhead__273_
               ; stack_limit = stack_limit__275_
               ; allocation_policy = allocation_policy__277_
               ; window_size = window_size__279_
               ; custom_major_ratio = custom_major_ratio__281_
               ; custom_minor_ratio = custom_minor_ratio__283_
               ; custom_minor_max_size = custom_minor_max_size__285_
               } ->
             let bnds__264_ = ([] : _ Stdlib.List.t) in
             let bnds__264_ =
               let arg__286_ = sexp_of_int custom_minor_max_size__285_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "custom_minor_max_size"; arg__286_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__284_ = sexp_of_int custom_minor_ratio__283_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_ratio"; arg__284_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__282_ = sexp_of_int custom_major_ratio__281_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_major_ratio"; arg__282_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__280_ = sexp_of_int window_size__279_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "window_size"; arg__280_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__278_ = sexp_of_int allocation_policy__277_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "allocation_policy"; arg__278_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__276_ = sexp_of_int stack_limit__275_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_limit"; arg__276_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__274_ = sexp_of_int max_overhead__273_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_overhead"; arg__274_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__272_ = sexp_of_int verbose__271_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "verbose"; arg__272_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__270_ = sexp_of_int space_overhead__269_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "space_overhead"; arg__270_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__268_ = sexp_of_int major_heap_increment__267_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "major_heap_increment"; arg__268_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             let bnds__264_ =
               let arg__266_ = sexp_of_int minor_heap_size__265_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_heap_size"; arg__266_ ]
                :: bnds__264_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__264_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    [%%else]

    module V1 = struct
      [@@@ocaml.warning "-3"]

      type t = Stdlib.Gc.control =
        { minor_heap_size : int
        ; major_heap_increment : int
        ; space_overhead : int
        ; verbose : int
        ; max_overhead : int
        ; stack_limit : int
        ; allocation_policy : int
        ; window_size : int
        ; custom_major_ratio : int
        ; custom_minor_ratio : int
        ; custom_minor_max_size : int
        }
      [@@deriving bin_io, compare, equal, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:187:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "minor_heap_size", bin_shape_int
                    ; "major_heap_increment", bin_shape_int
                    ; "space_overhead", bin_shape_int
                    ; "verbose", bin_shape_int
                    ; "max_overhead", bin_shape_int
                    ; "stack_limit", bin_shape_int
                    ; "allocation_policy", bin_shape_int
                    ; "window_size", bin_shape_int
                    ; "custom_major_ratio", bin_shape_int
                    ; "custom_minor_ratio", bin_shape_int
                    ; "custom_minor_max_size", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { minor_heap_size = v1
            ; major_heap_increment = v2
            ; space_overhead = v3
            ; verbose = v4
            ; max_overhead = v5
            ; stack_limit = v6
            ; allocation_policy = v7
            ; window_size = v8
            ; custom_major_ratio = v9
            ; custom_minor_ratio = v10
            ; custom_minor_max_size = v11
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
            Bin_prot.Common.( + ) size (bin_size_int v11)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { minor_heap_size = v1
            ; major_heap_increment = v2
            ; space_overhead = v3
            ; verbose = v4
            ; max_overhead = v5
            ; stack_limit = v6
            ; allocation_policy = v7
            ; window_size = v8
            ; custom_major_ratio = v9
            ; custom_minor_ratio = v10
            ; custom_minor_max_size = v11
            } ->
            let pos = bin_write_int buf ~pos v1 in
            let pos = bin_write_int buf ~pos v2 in
            let pos = bin_write_int buf ~pos v3 in
            let pos = bin_write_int buf ~pos v4 in
            let pos = bin_write_int buf ~pos v5 in
            let pos = bin_write_int buf ~pos v6 in
            let pos = bin_write_int buf ~pos v7 in
            let pos = bin_write_int buf ~pos v8 in
            let pos = bin_write_int buf ~pos v9 in
            let pos = bin_write_int buf ~pos v10 in
            bin_write_int buf ~pos v11
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "gc.ml.before-ppx.Stable.Control.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_minor_heap_size = bin_read_int buf ~pos_ref in
          let v_major_heap_increment = bin_read_int buf ~pos_ref in
          let v_space_overhead = bin_read_int buf ~pos_ref in
          let v_verbose = bin_read_int buf ~pos_ref in
          let v_max_overhead = bin_read_int buf ~pos_ref in
          let v_stack_limit = bin_read_int buf ~pos_ref in
          let v_allocation_policy = bin_read_int buf ~pos_ref in
          let v_window_size = bin_read_int buf ~pos_ref in
          let v_custom_major_ratio = bin_read_int buf ~pos_ref in
          let v_custom_minor_ratio = bin_read_int buf ~pos_ref in
          let v_custom_minor_max_size = bin_read_int buf ~pos_ref in
          { minor_heap_size = v_minor_heap_size
          ; major_heap_increment = v_major_heap_increment
          ; space_overhead = v_space_overhead
          ; verbose = v_verbose
          ; max_overhead = v_max_overhead
          ; stack_limit = v_stack_limit
          ; allocation_policy = v_allocation_policy
          ; window_size = v_window_size
          ; custom_major_ratio = v_custom_major_ratio
          ; custom_minor_ratio = v_custom_minor_ratio
          ; custom_minor_max_size = v_custom_minor_max_size
          }
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
          (fun a__287_ b__288_ ->
             if Stdlib.( == ) a__287_ b__288_
             then 0
             else (
               match compare_int a__287_.minor_heap_size b__288_.minor_heap_size with
               | 0 ->
                 (match
                    compare_int a__287_.major_heap_increment b__288_.major_heap_increment
                  with
                  | 0 ->
                    (match compare_int a__287_.space_overhead b__288_.space_overhead with
                     | 0 ->
                       (match compare_int a__287_.verbose b__288_.verbose with
                        | 0 ->
                          (match
                             compare_int a__287_.max_overhead b__288_.max_overhead
                           with
                           | 0 ->
                             (match
                                compare_int a__287_.stack_limit b__288_.stack_limit
                              with
                              | 0 ->
                                (match
                                   compare_int
                                     a__287_.allocation_policy
                                     b__288_.allocation_policy
                                 with
                                 | 0 ->
                                   (match
                                      compare_int a__287_.window_size b__288_.window_size
                                    with
                                    | 0 ->
                                      (match
                                         compare_int
                                           a__287_.custom_major_ratio
                                           b__288_.custom_major_ratio
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__287_.custom_minor_ratio
                                              b__288_.custom_minor_ratio
                                          with
                                          | 0 ->
                                            compare_int
                                              a__287_.custom_minor_max_size
                                              b__288_.custom_minor_max_size
                                          | n -> n)
                                       | n -> n)
                                    | n -> n)
                                 | n -> n)
                              | n -> n)
                           | n -> n)
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__289_ b__290_ ->
             if Stdlib.( == ) a__289_ b__290_
             then true
             else
               Stdlib.( && )
                 (equal_int a__289_.minor_heap_size b__290_.minor_heap_size)
                 (Stdlib.( && )
                    (equal_int a__289_.major_heap_increment b__290_.major_heap_increment)
                    (Stdlib.( && )
                       (equal_int a__289_.space_overhead b__290_.space_overhead)
                       (Stdlib.( && )
                          (equal_int a__289_.verbose b__290_.verbose)
                          (Stdlib.( && )
                             (equal_int a__289_.max_overhead b__290_.max_overhead)
                             (Stdlib.( && )
                                (equal_int a__289_.stack_limit b__290_.stack_limit)
                                (Stdlib.( && )
                                   (equal_int
                                      a__289_.allocation_policy
                                      b__290_.allocation_policy)
                                   (Stdlib.( && )
                                      (equal_int a__289_.window_size b__290_.window_size)
                                      (Stdlib.( && )
                                         (equal_int
                                            a__289_.custom_major_ratio
                                            b__290_.custom_major_ratio)
                                         (Stdlib.( && )
                                            (equal_int
                                               a__289_.custom_minor_ratio
                                               b__290_.custom_minor_ratio)
                                            (equal_int
                                               a__289_.custom_minor_max_size
                                               b__290_.custom_minor_max_size))))))))))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let t_of_sexp =
          (let error_source__292_ = "gc.ml.before-ppx.Stable.Control.V1.t" in
           fun x__293_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__292_
               ~fields:
                 (Field
                    { name = "minor_heap_size"
                    ; kind = Required
                    ; conv = int_of_sexp
                    ; rest =
                        Field
                          { name = "major_heap_increment"
                          ; kind = Required
                          ; conv = int_of_sexp
                          ; rest =
                              Field
                                { name = "space_overhead"
                                ; kind = Required
                                ; conv = int_of_sexp
                                ; rest =
                                    Field
                                      { name = "verbose"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "max_overhead"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "stack_limit"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "allocation_policy"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "window_size"
                                                              ; kind = Required
                                                              ; conv = int_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name =
                                                                        "custom_major_ratio"
                                                                    ; kind = Required
                                                                    ; conv = int_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "custom_minor_ratio"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              int_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "custom_minor_max_size"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    int_of_sexp
                                                                                ; rest =
                                                                                    Empty
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "minor_heap_size" -> 0
                 | "major_heap_increment" -> 1
                 | "space_overhead" -> 2
                 | "verbose" -> 3
                 | "max_overhead" -> 4
                 | "stack_limit" -> 5
                 | "allocation_policy" -> 6
                 | "window_size" -> 7
                 | "custom_major_ratio" -> 8
                 | "custom_minor_ratio" -> 9
                 | "custom_minor_max_size" -> 10
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( minor_heap_size
                   , ( major_heap_increment
                     , ( space_overhead
                       , ( verbose
                         , ( max_overhead
                           , ( stack_limit
                             , ( allocation_policy
                               , ( window_size
                                 , ( custom_major_ratio
                                   , (custom_minor_ratio, (custom_minor_max_size, ())) )
                                 ) ) ) ) ) ) ) ) ->
                 ({ minor_heap_size
                  ; major_heap_increment
                  ; space_overhead
                  ; verbose
                  ; max_overhead
                  ; stack_limit
                  ; allocation_policy
                  ; window_size
                  ; custom_major_ratio
                  ; custom_minor_ratio
                  ; custom_minor_max_size
                  }
                  : t))
               x__293_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { minor_heap_size = minor_heap_size__295_
               ; major_heap_increment = major_heap_increment__297_
               ; space_overhead = space_overhead__299_
               ; verbose = verbose__301_
               ; max_overhead = max_overhead__303_
               ; stack_limit = stack_limit__305_
               ; allocation_policy = allocation_policy__307_
               ; window_size = window_size__309_
               ; custom_major_ratio = custom_major_ratio__311_
               ; custom_minor_ratio = custom_minor_ratio__313_
               ; custom_minor_max_size = custom_minor_max_size__315_
               } ->
             let bnds__294_ = ([] : _ Stdlib.List.t) in
             let bnds__294_ =
               let arg__316_ = sexp_of_int custom_minor_max_size__315_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "custom_minor_max_size"; arg__316_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__314_ = sexp_of_int custom_minor_ratio__313_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_ratio"; arg__314_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__312_ = sexp_of_int custom_major_ratio__311_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_major_ratio"; arg__312_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__310_ = sexp_of_int window_size__309_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "window_size"; arg__310_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__308_ = sexp_of_int allocation_policy__307_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "allocation_policy"; arg__308_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__306_ = sexp_of_int stack_limit__305_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_limit"; arg__306_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__304_ = sexp_of_int max_overhead__303_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_overhead"; arg__304_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__302_ = sexp_of_int verbose__301_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "verbose"; arg__302_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__300_ = sexp_of_int space_overhead__299_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "space_overhead"; arg__300_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__298_ = sexp_of_int major_heap_increment__297_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "major_heap_increment"; arg__298_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             let bnds__294_ =
               let arg__296_ = sexp_of_int minor_heap_size__295_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_heap_size"; arg__296_ ]
                :: bnds__294_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__294_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    [%%endif]
  end
end

include Stdlib.Gc

module Stat = struct
  module T = struct
    [%%if ocaml_version < (4, 12, 0)]

    type t = Stdlib.Gc.stat =
      { minor_words : float
      ; promoted_words : float
      ; major_words : float
      ; minor_collections : int
      ; major_collections : int
      ; heap_words : int
      ; heap_chunks : int
      ; live_words : int
      ; live_blocks : int
      ; free_words : int
      ; free_blocks : int
      ; largest_free : int
      ; fragments : int
      ; compactions : int
      ; top_heap_words : int
      ; stack_size : int
      }
    [@@deriving compare, hash, bin_io, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__317_ b__318_ ->
           if Stdlib.( == ) a__317_ b__318_
           then 0
           else (
             match compare_float a__317_.minor_words b__318_.minor_words with
             | 0 ->
               (match compare_float a__317_.promoted_words b__318_.promoted_words with
                | 0 ->
                  (match compare_float a__317_.major_words b__318_.major_words with
                   | 0 ->
                     (match
                        compare_int a__317_.minor_collections b__318_.minor_collections
                      with
                      | 0 ->
                        (match
                           compare_int a__317_.major_collections b__318_.major_collections
                         with
                         | 0 ->
                           (match compare_int a__317_.heap_words b__318_.heap_words with
                            | 0 ->
                              (match
                                 compare_int a__317_.heap_chunks b__318_.heap_chunks
                               with
                               | 0 ->
                                 (match
                                    compare_int a__317_.live_words b__318_.live_words
                                  with
                                  | 0 ->
                                    (match
                                       compare_int a__317_.live_blocks b__318_.live_blocks
                                     with
                                     | 0 ->
                                       (match
                                          compare_int
                                            a__317_.free_words
                                            b__318_.free_words
                                        with
                                        | 0 ->
                                          (match
                                             compare_int
                                               a__317_.free_blocks
                                               b__318_.free_blocks
                                           with
                                           | 0 ->
                                             (match
                                                compare_int
                                                  a__317_.largest_free
                                                  b__318_.largest_free
                                              with
                                              | 0 ->
                                                (match
                                                   compare_int
                                                     a__317_.fragments
                                                     b__318_.fragments
                                                 with
                                                 | 0 ->
                                                   (match
                                                      compare_int
                                                        a__317_.compactions
                                                        b__318_.compactions
                                                    with
                                                    | 0 ->
                                                      (match
                                                         compare_int
                                                           a__317_.top_heap_words
                                                           b__318_.top_heap_words
                                                       with
                                                       | 0 ->
                                                         compare_int
                                                           a__317_.stack_size
                                                           b__318_.stack_size
                                                       | n -> n)
                                                    | n -> n)
                                                 | n -> n)
                                              | n -> n)
                                           | n -> n)
                                        | n -> n)
                                     | n -> n)
                                  | n -> n)
                               | n -> n)
                            | n -> n)
                         | n -> n)
                      | n -> n)
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let hsv =
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv = hsv in
                                      hash_fold_float hsv arg.minor_words
                                    in
                                    hash_fold_float hsv arg.promoted_words
                                  in
                                  hash_fold_float hsv arg.major_words
                                in
                                hash_fold_int hsv arg.minor_collections
                              in
                              hash_fold_int hsv arg.major_collections
                            in
                            hash_fold_int hsv arg.heap_words
                          in
                          hash_fold_int hsv arg.heap_chunks
                        in
                        hash_fold_int hsv arg.live_words
                      in
                      hash_fold_int hsv arg.live_blocks
                    in
                    hash_fold_int hsv arg.free_words
                  in
                  hash_fold_int hsv arg.free_blocks
                in
                hash_fold_int hsv arg.largest_free
              in
              hash_fold_int hsv arg.fragments
            in
            hash_fold_int hsv arg.compactions
          in
          hash_fold_int hsv arg.top_heap_words
        in
        hash_fold_int hsv arg.stack_size
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

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "gc.ml.before-ppx:213:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.record
                  [ "minor_words", bin_shape_float
                  ; "promoted_words", bin_shape_float
                  ; "major_words", bin_shape_float
                  ; "minor_collections", bin_shape_int
                  ; "major_collections", bin_shape_int
                  ; "heap_words", bin_shape_int
                  ; "heap_chunks", bin_shape_int
                  ; "live_words", bin_shape_int
                  ; "live_blocks", bin_shape_int
                  ; "free_words", bin_shape_int
                  ; "free_blocks", bin_shape_int
                  ; "largest_free", bin_shape_int
                  ; "fragments", bin_shape_int
                  ; "compactions", bin_shape_int
                  ; "top_heap_words", bin_shape_int
                  ; "stack_size", bin_shape_int
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | { minor_words = v1
          ; promoted_words = v2
          ; major_words = v3
          ; minor_collections = v4
          ; major_collections = v5
          ; heap_words = v6
          ; heap_chunks = v7
          ; live_words = v8
          ; live_blocks = v9
          ; free_words = v10
          ; free_blocks = v11
          ; largest_free = v12
          ; fragments = v13
          ; compactions = v14
          ; top_heap_words = v15
          ; stack_size = v16
          } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (bin_size_float v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_float v2) in
          let size = Bin_prot.Common.( + ) size (bin_size_float v3) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v5) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v6) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v7) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v8) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v9) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v10) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v11) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v12) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v13) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v14) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v15) in
          Bin_prot.Common.( + ) size (bin_size_int v16)
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | { minor_words = v1
          ; promoted_words = v2
          ; major_words = v3
          ; minor_collections = v4
          ; major_collections = v5
          ; heap_words = v6
          ; heap_chunks = v7
          ; live_words = v8
          ; live_blocks = v9
          ; free_words = v10
          ; free_blocks = v11
          ; largest_free = v12
          ; fragments = v13
          ; compactions = v14
          ; top_heap_words = v15
          ; stack_size = v16
          } ->
          let pos = bin_write_float buf ~pos v1 in
          let pos = bin_write_float buf ~pos v2 in
          let pos = bin_write_float buf ~pos v3 in
          let pos = bin_write_int buf ~pos v4 in
          let pos = bin_write_int buf ~pos v5 in
          let pos = bin_write_int buf ~pos v6 in
          let pos = bin_write_int buf ~pos v7 in
          let pos = bin_write_int buf ~pos v8 in
          let pos = bin_write_int buf ~pos v9 in
          let pos = bin_write_int buf ~pos v10 in
          let pos = bin_write_int buf ~pos v11 in
          let pos = bin_write_int buf ~pos v12 in
          let pos = bin_write_int buf ~pos v13 in
          let pos = bin_write_int buf ~pos v14 in
          let pos = bin_write_int buf ~pos v15 in
          bin_write_int buf ~pos v16
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type "gc.ml.before-ppx.Stat.T.t" !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        let v_minor_words = bin_read_float buf ~pos_ref in
        let v_promoted_words = bin_read_float buf ~pos_ref in
        let v_major_words = bin_read_float buf ~pos_ref in
        let v_minor_collections = bin_read_int buf ~pos_ref in
        let v_major_collections = bin_read_int buf ~pos_ref in
        let v_heap_words = bin_read_int buf ~pos_ref in
        let v_heap_chunks = bin_read_int buf ~pos_ref in
        let v_live_words = bin_read_int buf ~pos_ref in
        let v_live_blocks = bin_read_int buf ~pos_ref in
        let v_free_words = bin_read_int buf ~pos_ref in
        let v_free_blocks = bin_read_int buf ~pos_ref in
        let v_largest_free = bin_read_int buf ~pos_ref in
        let v_fragments = bin_read_int buf ~pos_ref in
        let v_compactions = bin_read_int buf ~pos_ref in
        let v_top_heap_words = bin_read_int buf ~pos_ref in
        let v_stack_size = bin_read_int buf ~pos_ref in
        { minor_words = v_minor_words
        ; promoted_words = v_promoted_words
        ; major_words = v_major_words
        ; minor_collections = v_minor_collections
        ; major_collections = v_major_collections
        ; heap_words = v_heap_words
        ; heap_chunks = v_heap_chunks
        ; live_words = v_live_words
        ; live_blocks = v_live_blocks
        ; free_words = v_free_words
        ; free_blocks = v_free_blocks
        ; largest_free = v_largest_free
        ; fragments = v_fragments
        ; compactions = v_compactions
        ; top_heap_words = v_top_heap_words
        ; stack_size = v_stack_size
        }
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
        (let error_source__320_ = "gc.ml.before-ppx.Stat.T.t" in
         fun x__321_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__320_
             ~fields:
               (Field
                  { name = "minor_words"
                  ; kind = Required
                  ; conv = float_of_sexp
                  ; rest =
                      Field
                        { name = "promoted_words"
                        ; kind = Required
                        ; conv = float_of_sexp
                        ; rest =
                            Field
                              { name = "major_words"
                              ; kind = Required
                              ; conv = float_of_sexp
                              ; rest =
                                  Field
                                    { name = "minor_collections"
                                    ; kind = Required
                                    ; conv = int_of_sexp
                                    ; rest =
                                        Field
                                          { name = "major_collections"
                                          ; kind = Required
                                          ; conv = int_of_sexp
                                          ; rest =
                                              Field
                                                { name = "heap_words"
                                                ; kind = Required
                                                ; conv = int_of_sexp
                                                ; rest =
                                                    Field
                                                      { name = "heap_chunks"
                                                      ; kind = Required
                                                      ; conv = int_of_sexp
                                                      ; rest =
                                                          Field
                                                            { name = "live_words"
                                                            ; kind = Required
                                                            ; conv = int_of_sexp
                                                            ; rest =
                                                                Field
                                                                  { name = "live_blocks"
                                                                  ; kind = Required
                                                                  ; conv = int_of_sexp
                                                                  ; rest =
                                                                      Field
                                                                        { name =
                                                                            "free_words"
                                                                        ; kind = Required
                                                                        ; conv =
                                                                            int_of_sexp
                                                                        ; rest =
                                                                            Field
                                                                              { name =
                                                                                  "free_blocks"
                                                                              ; kind =
                                                                                  Required
                                                                              ; conv =
                                                                                  int_of_sexp
                                                                              ; rest =
                                                                                  Field
                                                                                    { name =
                                                                                        "largest_free"
                                                                                    ; kind =
                                                                                        Required
                                                                                    ; conv =
                                                                                        int_of_sexp
                                                                                    ; rest =
                                                                                        Field
                                                                                          { 
                                                                                          name =
                                                                                          "fragments"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "compactions"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "top_heap_words"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "stack_size"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "minor_words" -> 0
               | "promoted_words" -> 1
               | "major_words" -> 2
               | "minor_collections" -> 3
               | "major_collections" -> 4
               | "heap_words" -> 5
               | "heap_chunks" -> 6
               | "live_words" -> 7
               | "live_blocks" -> 8
               | "free_words" -> 9
               | "free_blocks" -> 10
               | "largest_free" -> 11
               | "fragments" -> 12
               | "compactions" -> 13
               | "top_heap_words" -> 14
               | "stack_size" -> 15
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:
               (fun
                 ( minor_words
                 , ( promoted_words
                   , ( major_words
                     , ( minor_collections
                       , ( major_collections
                         , ( heap_words
                           , ( heap_chunks
                             , ( live_words
                               , ( live_blocks
                                 , ( free_words
                                   , ( free_blocks
                                     , ( largest_free
                                       , ( fragments
                                         , ( compactions
                                           , (top_heap_words, (stack_size, ())) ) ) ) ) )
                                 ) ) ) ) ) ) ) ) ) ->
               ({ minor_words
                ; promoted_words
                ; major_words
                ; minor_collections
                ; major_collections
                ; heap_words
                ; heap_chunks
                ; live_words
                ; live_blocks
                ; free_words
                ; free_blocks
                ; largest_free
                ; fragments
                ; compactions
                ; top_heap_words
                ; stack_size
                }
                : t))
             x__321_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { minor_words = minor_words__323_
             ; promoted_words = promoted_words__325_
             ; major_words = major_words__327_
             ; minor_collections = minor_collections__329_
             ; major_collections = major_collections__331_
             ; heap_words = heap_words__333_
             ; heap_chunks = heap_chunks__335_
             ; live_words = live_words__337_
             ; live_blocks = live_blocks__339_
             ; free_words = free_words__341_
             ; free_blocks = free_blocks__343_
             ; largest_free = largest_free__345_
             ; fragments = fragments__347_
             ; compactions = compactions__349_
             ; top_heap_words = top_heap_words__351_
             ; stack_size = stack_size__353_
             } ->
           let bnds__322_ = ([] : _ Stdlib.List.t) in
           let bnds__322_ =
             let arg__354_ = sexp_of_int stack_size__353_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__354_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__352_ = sexp_of_int top_heap_words__351_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__352_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__350_ = sexp_of_int compactions__349_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__350_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__348_ = sexp_of_int fragments__347_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__348_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__346_ = sexp_of_int largest_free__345_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__346_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__344_ = sexp_of_int free_blocks__343_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__344_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__342_ = sexp_of_int free_words__341_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__342_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__340_ = sexp_of_int live_blocks__339_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__340_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__338_ = sexp_of_int live_words__337_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__338_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__336_ = sexp_of_int heap_chunks__335_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__336_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__334_ = sexp_of_int heap_words__333_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__334_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__332_ = sexp_of_int major_collections__331_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__332_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__330_ = sexp_of_int minor_collections__329_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__330_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__328_ = sexp_of_float major_words__327_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__328_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__326_ = sexp_of_float promoted_words__325_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__326_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           let bnds__322_ =
             let arg__324_ = sexp_of_float minor_words__323_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__324_ ]
              :: bnds__322_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__322_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    [%%elif ocaml_version < (5, 5, 0)]

    type t = Stdlib.Gc.stat =
      { minor_words : float
      ; promoted_words : float
      ; major_words : float
      ; minor_collections : int
      ; major_collections : int
      ; heap_words : int
      ; heap_chunks : int
      ; live_words : int
      ; live_blocks : int
      ; free_words : int
      ; free_blocks : int
      ; largest_free : int
      ; fragments : int
      ; compactions : int
      ; top_heap_words : int
      ; stack_size : int
      ; forced_major_collections : int
      }
    [@@deriving
      compare
    , hash
    , sexp_of
    , fields
        ~getters
        ~setters
        ~fields
        ~iterators:(create, fold, iter, map, to_list)
        ~direct_iterators:to_list]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__355_ b__356_ ->
           if Stdlib.( == ) a__355_ b__356_
           then 0
           else (
             match compare_float a__355_.minor_words b__356_.minor_words with
             | 0 ->
               (match compare_float a__355_.promoted_words b__356_.promoted_words with
                | 0 ->
                  (match compare_float a__355_.major_words b__356_.major_words with
                   | 0 ->
                     (match
                        compare_int a__355_.minor_collections b__356_.minor_collections
                      with
                      | 0 ->
                        (match
                           compare_int a__355_.major_collections b__356_.major_collections
                         with
                         | 0 ->
                           (match compare_int a__355_.heap_words b__356_.heap_words with
                            | 0 ->
                              (match
                                 compare_int a__355_.heap_chunks b__356_.heap_chunks
                               with
                               | 0 ->
                                 (match
                                    compare_int a__355_.live_words b__356_.live_words
                                  with
                                  | 0 ->
                                    (match
                                       compare_int a__355_.live_blocks b__356_.live_blocks
                                     with
                                     | 0 ->
                                       (match
                                          compare_int
                                            a__355_.free_words
                                            b__356_.free_words
                                        with
                                        | 0 ->
                                          (match
                                             compare_int
                                               a__355_.free_blocks
                                               b__356_.free_blocks
                                           with
                                           | 0 ->
                                             (match
                                                compare_int
                                                  a__355_.largest_free
                                                  b__356_.largest_free
                                              with
                                              | 0 ->
                                                (match
                                                   compare_int
                                                     a__355_.fragments
                                                     b__356_.fragments
                                                 with
                                                 | 0 ->
                                                   (match
                                                      compare_int
                                                        a__355_.compactions
                                                        b__356_.compactions
                                                    with
                                                    | 0 ->
                                                      (match
                                                         compare_int
                                                           a__355_.top_heap_words
                                                           b__356_.top_heap_words
                                                       with
                                                       | 0 ->
                                                         (match
                                                            compare_int
                                                              a__355_.stack_size
                                                              b__356_.stack_size
                                                          with
                                                          | 0 ->
                                                            compare_int
                                                              a__355_
                                                                .forced_major_collections
                                                              b__356_
                                                                .forced_major_collections
                                                          | n -> n)
                                                       | n -> n)
                                                    | n -> n)
                                                 | n -> n)
                                              | n -> n)
                                           | n -> n)
                                        | n -> n)
                                     | n -> n)
                                  | n -> n)
                               | n -> n)
                            | n -> n)
                         | n -> n)
                      | n -> n)
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let hsv =
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv = hsv in
                                        hash_fold_float hsv arg.minor_words
                                      in
                                      hash_fold_float hsv arg.promoted_words
                                    in
                                    hash_fold_float hsv arg.major_words
                                  in
                                  hash_fold_int hsv arg.minor_collections
                                in
                                hash_fold_int hsv arg.major_collections
                              in
                              hash_fold_int hsv arg.heap_words
                            in
                            hash_fold_int hsv arg.heap_chunks
                          in
                          hash_fold_int hsv arg.live_words
                        in
                        hash_fold_int hsv arg.live_blocks
                      in
                      hash_fold_int hsv arg.free_words
                    in
                    hash_fold_int hsv arg.free_blocks
                  in
                  hash_fold_int hsv arg.largest_free
                in
                hash_fold_int hsv arg.fragments
              in
              hash_fold_int hsv arg.compactions
            in
            hash_fold_int hsv arg.top_heap_words
          in
          hash_fold_int hsv arg.stack_size
        in
        hash_fold_int hsv arg.forced_major_collections
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

      let sexp_of_t =
        (fun { minor_words = minor_words__358_
             ; promoted_words = promoted_words__360_
             ; major_words = major_words__362_
             ; minor_collections = minor_collections__364_
             ; major_collections = major_collections__366_
             ; heap_words = heap_words__368_
             ; heap_chunks = heap_chunks__370_
             ; live_words = live_words__372_
             ; live_blocks = live_blocks__374_
             ; free_words = free_words__376_
             ; free_blocks = free_blocks__378_
             ; largest_free = largest_free__380_
             ; fragments = fragments__382_
             ; compactions = compactions__384_
             ; top_heap_words = top_heap_words__386_
             ; stack_size = stack_size__388_
             ; forced_major_collections = forced_major_collections__390_
             } ->
           let bnds__357_ = ([] : _ Stdlib.List.t) in
           let bnds__357_ =
             let arg__391_ = sexp_of_int forced_major_collections__390_ in
             (Sexplib0.Sexp.List
                [ Sexplib0.Sexp.Atom "forced_major_collections"; arg__391_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__389_ = sexp_of_int stack_size__388_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__389_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__387_ = sexp_of_int top_heap_words__386_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__387_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__385_ = sexp_of_int compactions__384_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__385_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__383_ = sexp_of_int fragments__382_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__383_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__381_ = sexp_of_int largest_free__380_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__381_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__379_ = sexp_of_int free_blocks__378_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__379_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__377_ = sexp_of_int free_words__376_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__377_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__375_ = sexp_of_int live_blocks__374_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__375_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__373_ = sexp_of_int live_words__372_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__373_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__371_ = sexp_of_int heap_chunks__370_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__371_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__369_ = sexp_of_int heap_words__368_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__369_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__367_ = sexp_of_int major_collections__366_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__367_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__365_ = sexp_of_int minor_collections__364_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__365_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__363_ = sexp_of_float major_words__362_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__363_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__361_ = sexp_of_float promoted_words__360_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__361_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           let bnds__357_ =
             let arg__359_ = sexp_of_float minor_words__358_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__359_ ]
              :: bnds__357_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__357_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let forced_major_collections _r__ = _r__.forced_major_collections
      let _ = forced_major_collections
      let stack_size _r__ = _r__.stack_size
      let _ = stack_size
      let top_heap_words _r__ = _r__.top_heap_words
      let _ = top_heap_words
      let compactions _r__ = _r__.compactions
      let _ = compactions
      let fragments _r__ = _r__.fragments
      let _ = fragments
      let largest_free _r__ = _r__.largest_free
      let _ = largest_free
      let free_blocks _r__ = _r__.free_blocks
      let _ = free_blocks
      let free_words _r__ = _r__.free_words
      let _ = free_words
      let live_blocks _r__ = _r__.live_blocks
      let _ = live_blocks
      let live_words _r__ = _r__.live_words
      let _ = live_words
      let heap_chunks _r__ = _r__.heap_chunks
      let _ = heap_chunks
      let heap_words _r__ = _r__.heap_words
      let _ = heap_words
      let major_collections _r__ = _r__.major_collections
      let _ = major_collections
      let minor_collections _r__ = _r__.minor_collections
      let _ = minor_collections
      let major_words _r__ = _r__.major_words
      let _ = major_words
      let promoted_words _r__ = _r__.promoted_words
      let _ = promoted_words
      let minor_words _r__ = _r__.minor_words
      let _ = minor_words

      module Fields = struct
        let forced_major_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "forced_major_collections"
             ; getter = forced_major_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with forced_major_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = forced_major_collections

        let stack_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "stack_size"
             ; getter = stack_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with stack_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = stack_size

        let top_heap_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "top_heap_words"
             ; getter = top_heap_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with top_heap_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = top_heap_words

        let compactions =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "compactions"
             ; getter = compactions
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with compactions = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = compactions

        let fragments =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "fragments"
             ; getter = fragments
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with fragments = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = fragments

        let largest_free =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "largest_free"
             ; getter = largest_free
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with largest_free = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = largest_free

        let free_blocks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "free_blocks"
             ; getter = free_blocks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with free_blocks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = free_blocks

        let free_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "free_words"
             ; getter = free_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with free_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = free_words

        let live_blocks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "live_blocks"
             ; getter = live_blocks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with live_blocks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = live_blocks

        let live_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "live_words"
             ; getter = live_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with live_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = live_words

        let heap_chunks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "heap_chunks"
             ; getter = heap_chunks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with heap_chunks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = heap_chunks

        let heap_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "heap_words"
             ; getter = heap_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with heap_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = heap_words

        let major_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_collections"
             ; getter = major_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with major_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_collections

        let minor_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_collections"
             ; getter = minor_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with minor_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_collections

        let major_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_words"
             ; getter = major_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with major_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_words

        let promoted_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "promoted_words"
             ; getter = promoted_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with promoted_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = promoted_words

        let minor_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_words"
             ; getter = minor_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with minor_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_words

        let create
              ~minor_words
              ~promoted_words
              ~major_words
              ~minor_collections
              ~major_collections
              ~heap_words
              ~heap_chunks
              ~live_words
              ~live_blocks
              ~free_words
              ~free_blocks
              ~largest_free
              ~fragments
              ~compactions
              ~top_heap_words
              ~stack_size
              ~forced_major_collections
          =
          { minor_words
          ; promoted_words
          ; major_words
          ; minor_collections
          ; major_collections
          ; heap_words
          ; heap_chunks
          ; live_words
          ; live_blocks
          ; free_words
          ; free_blocks
          ; largest_free
          ; fragments
          ; compactions
          ; top_heap_words
          ; stack_size
          ; forced_major_collections
          }
        ;;

        let _ = create

        let map
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
          =
          { minor_words = minor_words_fun__ minor_words
          ; promoted_words = promoted_words_fun__ promoted_words
          ; major_words = major_words_fun__ major_words
          ; minor_collections = minor_collections_fun__ minor_collections
          ; major_collections = major_collections_fun__ major_collections
          ; heap_words = heap_words_fun__ heap_words
          ; heap_chunks = heap_chunks_fun__ heap_chunks
          ; live_words = live_words_fun__ live_words
          ; live_blocks = live_blocks_fun__ live_blocks
          ; free_words = free_words_fun__ free_words
          ; free_blocks = free_blocks_fun__ free_blocks
          ; largest_free = largest_free_fun__ largest_free
          ; fragments = fragments_fun__ fragments
          ; compactions = compactions_fun__ compactions
          ; top_heap_words = top_heap_words_fun__ top_heap_words
          ; stack_size = stack_size_fun__ stack_size
          ; forced_major_collections =
              forced_major_collections_fun__ forced_major_collections
          }
        ;;

        let _ = map

        let iter
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
          =
          (minor_words_fun__ minor_words : unit);
          (promoted_words_fun__ promoted_words : unit);
          (major_words_fun__ major_words : unit);
          (minor_collections_fun__ minor_collections : unit);
          (major_collections_fun__ major_collections : unit);
          (heap_words_fun__ heap_words : unit);
          (heap_chunks_fun__ heap_chunks : unit);
          (live_words_fun__ live_words : unit);
          (live_blocks_fun__ live_blocks : unit);
          (free_words_fun__ free_words : unit);
          (free_blocks_fun__ free_blocks : unit);
          (largest_free_fun__ largest_free : unit);
          (fragments_fun__ fragments : unit);
          (compactions_fun__ compactions : unit);
          (top_heap_words_fun__ top_heap_words : unit);
          (stack_size_fun__ stack_size : unit);
          (forced_major_collections_fun__ forced_major_collections : unit)
        ;;

        let _ = iter

        let fold
              ~init:init__
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
          =
          forced_major_collections_fun__
            (stack_size_fun__
               (top_heap_words_fun__
                  (compactions_fun__
                     (fragments_fun__
                        (largest_free_fun__
                           (free_blocks_fun__
                              (free_words_fun__
                                 (live_blocks_fun__
                                    (live_words_fun__
                                       (heap_chunks_fun__
                                          (heap_words_fun__
                                             (major_collections_fun__
                                                (minor_collections_fun__
                                                   (major_words_fun__
                                                      (promoted_words_fun__
                                                         (minor_words_fun__
                                                            init__
                                                            minor_words)
                                                         promoted_words)
                                                      major_words)
                                                   minor_collections)
                                                major_collections)
                                             heap_words)
                                          heap_chunks)
                                       live_words)
                                    live_blocks)
                                 free_words)
                              free_blocks)
                           largest_free)
                        fragments)
                     compactions)
                  top_heap_words)
               stack_size)
            forced_major_collections
        ;;

        let _ = fold

        let to_list
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
          =
          [ minor_words_fun__ minor_words
          ; promoted_words_fun__ promoted_words
          ; major_words_fun__ major_words
          ; minor_collections_fun__ minor_collections
          ; major_collections_fun__ major_collections
          ; heap_words_fun__ heap_words
          ; heap_chunks_fun__ heap_chunks
          ; live_words_fun__ live_words
          ; live_blocks_fun__ live_blocks
          ; free_words_fun__ free_words
          ; free_blocks_fun__ free_blocks
          ; largest_free_fun__ largest_free
          ; fragments_fun__ fragments
          ; compactions_fun__ compactions
          ; top_heap_words_fun__ top_heap_words
          ; stack_size_fun__ stack_size
          ; forced_major_collections_fun__ forced_major_collections
          ]
        ;;

        let _ = to_list

        module Direct = struct
          let to_list
                record__
                ~minor_words:minor_words_fun__
                ~promoted_words:promoted_words_fun__
                ~major_words:major_words_fun__
                ~minor_collections:minor_collections_fun__
                ~major_collections:major_collections_fun__
                ~heap_words:heap_words_fun__
                ~heap_chunks:heap_chunks_fun__
                ~live_words:live_words_fun__
                ~live_blocks:live_blocks_fun__
                ~free_words:free_words_fun__
                ~free_blocks:free_blocks_fun__
                ~largest_free:largest_free_fun__
                ~fragments:fragments_fun__
                ~compactions:compactions_fun__
                ~top_heap_words:top_heap_words_fun__
                ~stack_size:stack_size_fun__
                ~forced_major_collections:forced_major_collections_fun__
            =
            [ minor_words_fun__ minor_words record__ record__.minor_words
            ; promoted_words_fun__ promoted_words record__ record__.promoted_words
            ; major_words_fun__ major_words record__ record__.major_words
            ; minor_collections_fun__
                minor_collections
                record__
                record__.minor_collections
            ; major_collections_fun__
                major_collections
                record__
                record__.major_collections
            ; heap_words_fun__ heap_words record__ record__.heap_words
            ; heap_chunks_fun__ heap_chunks record__ record__.heap_chunks
            ; live_words_fun__ live_words record__ record__.live_words
            ; live_blocks_fun__ live_blocks record__ record__.live_blocks
            ; free_words_fun__ free_words record__ record__.free_words
            ; free_blocks_fun__ free_blocks record__ record__.free_blocks
            ; largest_free_fun__ largest_free record__ record__.largest_free
            ; fragments_fun__ fragments record__ record__.fragments
            ; compactions_fun__ compactions record__ record__.compactions
            ; top_heap_words_fun__ top_heap_words record__ record__.top_heap_words
            ; stack_size_fun__ stack_size record__ record__.stack_size
            ; forced_major_collections_fun__
                forced_major_collections
                record__
                record__.forced_major_collections
            ]
          ;;

          let _ = to_list
        end
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    [%%else]

    type t = Stdlib.Gc.stat =
      { minor_words : float
      ; promoted_words : float
      ; major_words : float
      ; minor_collections : int
      ; major_collections : int
      ; heap_words : int
      ; heap_chunks : int
      ; live_words : int
      ; live_blocks : int
      ; free_words : int
      ; free_blocks : int
      ; largest_free : int
      ; fragments : int
      ; compactions : int
      ; top_heap_words : int
      ; stack_size : int
      ; forced_major_collections : int
      ; live_stacks_words : int
      }
    [@@deriving
      compare
    , hash
    , sexp_of
    , fields
        ~getters
        ~setters
        ~fields
        ~iterators:(create, fold, iter, map, to_list)
        ~direct_iterators:to_list]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__392_ b__393_ ->
           if Stdlib.( == ) a__392_ b__393_
           then 0
           else (
             match compare_float a__392_.minor_words b__393_.minor_words with
             | 0 ->
               (match compare_float a__392_.promoted_words b__393_.promoted_words with
                | 0 ->
                  (match compare_float a__392_.major_words b__393_.major_words with
                   | 0 ->
                     (match
                        compare_int a__392_.minor_collections b__393_.minor_collections
                      with
                      | 0 ->
                        (match
                           compare_int a__392_.major_collections b__393_.major_collections
                         with
                         | 0 ->
                           (match compare_int a__392_.heap_words b__393_.heap_words with
                            | 0 ->
                              (match
                                 compare_int a__392_.heap_chunks b__393_.heap_chunks
                               with
                               | 0 ->
                                 (match
                                    compare_int a__392_.live_words b__393_.live_words
                                  with
                                  | 0 ->
                                    (match
                                       compare_int a__392_.live_blocks b__393_.live_blocks
                                     with
                                     | 0 ->
                                       (match
                                          compare_int
                                            a__392_.free_words
                                            b__393_.free_words
                                        with
                                        | 0 ->
                                          (match
                                             compare_int
                                               a__392_.free_blocks
                                               b__393_.free_blocks
                                           with
                                           | 0 ->
                                             (match
                                                compare_int
                                                  a__392_.largest_free
                                                  b__393_.largest_free
                                              with
                                              | 0 ->
                                                (match
                                                   compare_int
                                                     a__392_.fragments
                                                     b__393_.fragments
                                                 with
                                                 | 0 ->
                                                   (match
                                                      compare_int
                                                        a__392_.compactions
                                                        b__393_.compactions
                                                    with
                                                    | 0 ->
                                                      (match
                                                         compare_int
                                                           a__392_.top_heap_words
                                                           b__393_.top_heap_words
                                                       with
                                                       | 0 ->
                                                         (match
                                                            compare_int
                                                              a__392_.stack_size
                                                              b__393_.stack_size
                                                          with
                                                          | 0 ->
                                                            (match
                                                               compare_int
                                                                 a__392_
                                                                   .forced_major_collections
                                                                 b__393_
                                                                   .forced_major_collections
                                                             with
                                                             | 0 ->
                                                               compare_int
                                                                 a__392_.live_stacks_words
                                                                 b__393_.live_stacks_words
                                                             | n -> n)
                                                          | n -> n)
                                                       | n -> n)
                                                    | n -> n)
                                                 | n -> n)
                                              | n -> n)
                                           | n -> n)
                                        | n -> n)
                                     | n -> n)
                                  | n -> n)
                               | n -> n)
                            | n -> n)
                         | n -> n)
                      | n -> n)
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let hsv =
          let hsv =
            let hsv =
              let hsv =
                let hsv =
                  let hsv =
                    let hsv =
                      let hsv =
                        let hsv =
                          let hsv =
                            let hsv =
                              let hsv =
                                let hsv =
                                  let hsv =
                                    let hsv =
                                      let hsv =
                                        let hsv =
                                          let hsv = hsv in
                                          hash_fold_float hsv arg.minor_words
                                        in
                                        hash_fold_float hsv arg.promoted_words
                                      in
                                      hash_fold_float hsv arg.major_words
                                    in
                                    hash_fold_int hsv arg.minor_collections
                                  in
                                  hash_fold_int hsv arg.major_collections
                                in
                                hash_fold_int hsv arg.heap_words
                              in
                              hash_fold_int hsv arg.heap_chunks
                            in
                            hash_fold_int hsv arg.live_words
                          in
                          hash_fold_int hsv arg.live_blocks
                        in
                        hash_fold_int hsv arg.free_words
                      in
                      hash_fold_int hsv arg.free_blocks
                    in
                    hash_fold_int hsv arg.largest_free
                  in
                  hash_fold_int hsv arg.fragments
                in
                hash_fold_int hsv arg.compactions
              in
              hash_fold_int hsv arg.top_heap_words
            in
            hash_fold_int hsv arg.stack_size
          in
          hash_fold_int hsv arg.forced_major_collections
        in
        hash_fold_int hsv arg.live_stacks_words
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

      let sexp_of_t =
        (fun { minor_words = minor_words__395_
             ; promoted_words = promoted_words__397_
             ; major_words = major_words__399_
             ; minor_collections = minor_collections__401_
             ; major_collections = major_collections__403_
             ; heap_words = heap_words__405_
             ; heap_chunks = heap_chunks__407_
             ; live_words = live_words__409_
             ; live_blocks = live_blocks__411_
             ; free_words = free_words__413_
             ; free_blocks = free_blocks__415_
             ; largest_free = largest_free__417_
             ; fragments = fragments__419_
             ; compactions = compactions__421_
             ; top_heap_words = top_heap_words__423_
             ; stack_size = stack_size__425_
             ; forced_major_collections = forced_major_collections__427_
             ; live_stacks_words = live_stacks_words__429_
             } ->
           let bnds__394_ = ([] : _ Stdlib.List.t) in
           let bnds__394_ =
             let arg__430_ = sexp_of_int live_stacks_words__429_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_stacks_words"; arg__430_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__428_ = sexp_of_int forced_major_collections__427_ in
             (Sexplib0.Sexp.List
                [ Sexplib0.Sexp.Atom "forced_major_collections"; arg__428_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__426_ = sexp_of_int stack_size__425_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_size"; arg__426_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__424_ = sexp_of_int top_heap_words__423_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "top_heap_words"; arg__424_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__422_ = sexp_of_int compactions__421_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "compactions"; arg__422_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__420_ = sexp_of_int fragments__419_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "fragments"; arg__420_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__418_ = sexp_of_int largest_free__417_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "largest_free"; arg__418_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__416_ = sexp_of_int free_blocks__415_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_blocks"; arg__416_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__414_ = sexp_of_int free_words__413_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_words"; arg__414_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__412_ = sexp_of_int live_blocks__411_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_blocks"; arg__412_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__410_ = sexp_of_int live_words__409_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "live_words"; arg__410_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__408_ = sexp_of_int heap_chunks__407_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_chunks"; arg__408_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__406_ = sexp_of_int heap_words__405_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "heap_words"; arg__406_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__404_ = sexp_of_int major_collections__403_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_collections"; arg__404_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__402_ = sexp_of_int minor_collections__401_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_collections"; arg__402_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__400_ = sexp_of_float major_words__399_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words"; arg__400_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__398_ = sexp_of_float promoted_words__397_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "promoted_words"; arg__398_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           let bnds__394_ =
             let arg__396_ = sexp_of_float minor_words__395_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words"; arg__396_ ]
              :: bnds__394_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__394_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let live_stacks_words _r__ = _r__.live_stacks_words
      let _ = live_stacks_words
      let forced_major_collections _r__ = _r__.forced_major_collections
      let _ = forced_major_collections
      let stack_size _r__ = _r__.stack_size
      let _ = stack_size
      let top_heap_words _r__ = _r__.top_heap_words
      let _ = top_heap_words
      let compactions _r__ = _r__.compactions
      let _ = compactions
      let fragments _r__ = _r__.fragments
      let _ = fragments
      let largest_free _r__ = _r__.largest_free
      let _ = largest_free
      let free_blocks _r__ = _r__.free_blocks
      let _ = free_blocks
      let free_words _r__ = _r__.free_words
      let _ = free_words
      let live_blocks _r__ = _r__.live_blocks
      let _ = live_blocks
      let live_words _r__ = _r__.live_words
      let _ = live_words
      let heap_chunks _r__ = _r__.heap_chunks
      let _ = heap_chunks
      let heap_words _r__ = _r__.heap_words
      let _ = heap_words
      let major_collections _r__ = _r__.major_collections
      let _ = major_collections
      let minor_collections _r__ = _r__.minor_collections
      let _ = minor_collections
      let major_words _r__ = _r__.major_words
      let _ = major_words
      let promoted_words _r__ = _r__.promoted_words
      let _ = promoted_words
      let minor_words _r__ = _r__.minor_words
      let _ = minor_words

      module Fields = struct
        let live_stacks_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "live_stacks_words"
             ; getter = live_stacks_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with live_stacks_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = live_stacks_words

        let forced_major_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "forced_major_collections"
             ; getter = forced_major_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with forced_major_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = forced_major_collections

        let stack_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "stack_size"
             ; getter = stack_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with stack_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = stack_size

        let top_heap_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "top_heap_words"
             ; getter = top_heap_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with top_heap_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = top_heap_words

        let compactions =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "compactions"
             ; getter = compactions
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with compactions = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = compactions

        let fragments =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "fragments"
             ; getter = fragments
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with fragments = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = fragments

        let largest_free =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "largest_free"
             ; getter = largest_free
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with largest_free = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = largest_free

        let free_blocks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "free_blocks"
             ; getter = free_blocks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with free_blocks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = free_blocks

        let free_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "free_words"
             ; getter = free_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with free_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = free_words

        let live_blocks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "live_blocks"
             ; getter = live_blocks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with live_blocks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = live_blocks

        let live_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "live_words"
             ; getter = live_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with live_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = live_words

        let heap_chunks =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "heap_chunks"
             ; getter = heap_chunks
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with heap_chunks = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = heap_chunks

        let heap_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "heap_words"
             ; getter = heap_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with heap_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = heap_words

        let major_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_collections"
             ; getter = major_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with major_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_collections

        let minor_collections =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_collections"
             ; getter = minor_collections
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with minor_collections = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_collections

        let major_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_words"
             ; getter = major_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with major_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_words

        let promoted_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "promoted_words"
             ; getter = promoted_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with promoted_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = promoted_words

        let minor_words =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_words"
             ; getter = minor_words
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with minor_words = v__ })
             }
           : ([< `Read | `Set_and_create ], _, float) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_words

        let create
              ~minor_words
              ~promoted_words
              ~major_words
              ~minor_collections
              ~major_collections
              ~heap_words
              ~heap_chunks
              ~live_words
              ~live_blocks
              ~free_words
              ~free_blocks
              ~largest_free
              ~fragments
              ~compactions
              ~top_heap_words
              ~stack_size
              ~forced_major_collections
              ~live_stacks_words
          =
          { minor_words
          ; promoted_words
          ; major_words
          ; minor_collections
          ; major_collections
          ; heap_words
          ; heap_chunks
          ; live_words
          ; live_blocks
          ; free_words
          ; free_blocks
          ; largest_free
          ; fragments
          ; compactions
          ; top_heap_words
          ; stack_size
          ; forced_major_collections
          ; live_stacks_words
          }
        ;;

        let _ = create

        let map
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
              ~live_stacks_words:live_stacks_words_fun__
          =
          { minor_words = minor_words_fun__ minor_words
          ; promoted_words = promoted_words_fun__ promoted_words
          ; major_words = major_words_fun__ major_words
          ; minor_collections = minor_collections_fun__ minor_collections
          ; major_collections = major_collections_fun__ major_collections
          ; heap_words = heap_words_fun__ heap_words
          ; heap_chunks = heap_chunks_fun__ heap_chunks
          ; live_words = live_words_fun__ live_words
          ; live_blocks = live_blocks_fun__ live_blocks
          ; free_words = free_words_fun__ free_words
          ; free_blocks = free_blocks_fun__ free_blocks
          ; largest_free = largest_free_fun__ largest_free
          ; fragments = fragments_fun__ fragments
          ; compactions = compactions_fun__ compactions
          ; top_heap_words = top_heap_words_fun__ top_heap_words
          ; stack_size = stack_size_fun__ stack_size
          ; forced_major_collections =
              forced_major_collections_fun__ forced_major_collections
          ; live_stacks_words = live_stacks_words_fun__ live_stacks_words
          }
        ;;

        let _ = map

        let iter
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
              ~live_stacks_words:live_stacks_words_fun__
          =
          (minor_words_fun__ minor_words : unit);
          (promoted_words_fun__ promoted_words : unit);
          (major_words_fun__ major_words : unit);
          (minor_collections_fun__ minor_collections : unit);
          (major_collections_fun__ major_collections : unit);
          (heap_words_fun__ heap_words : unit);
          (heap_chunks_fun__ heap_chunks : unit);
          (live_words_fun__ live_words : unit);
          (live_blocks_fun__ live_blocks : unit);
          (free_words_fun__ free_words : unit);
          (free_blocks_fun__ free_blocks : unit);
          (largest_free_fun__ largest_free : unit);
          (fragments_fun__ fragments : unit);
          (compactions_fun__ compactions : unit);
          (top_heap_words_fun__ top_heap_words : unit);
          (stack_size_fun__ stack_size : unit);
          (forced_major_collections_fun__ forced_major_collections : unit);
          (live_stacks_words_fun__ live_stacks_words : unit)
        ;;

        let _ = iter

        let fold
              ~init:init__
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
              ~live_stacks_words:live_stacks_words_fun__
          =
          live_stacks_words_fun__
            (forced_major_collections_fun__
               (stack_size_fun__
                  (top_heap_words_fun__
                     (compactions_fun__
                        (fragments_fun__
                           (largest_free_fun__
                              (free_blocks_fun__
                                 (free_words_fun__
                                    (live_blocks_fun__
                                       (live_words_fun__
                                          (heap_chunks_fun__
                                             (heap_words_fun__
                                                (major_collections_fun__
                                                   (minor_collections_fun__
                                                      (major_words_fun__
                                                         (promoted_words_fun__
                                                            (minor_words_fun__
                                                               init__
                                                               minor_words)
                                                            promoted_words)
                                                         major_words)
                                                      minor_collections)
                                                   major_collections)
                                                heap_words)
                                             heap_chunks)
                                          live_words)
                                       live_blocks)
                                    free_words)
                                 free_blocks)
                              largest_free)
                           fragments)
                        compactions)
                     top_heap_words)
                  stack_size)
               forced_major_collections)
            live_stacks_words
        ;;

        let _ = fold

        let to_list
              ~minor_words:minor_words_fun__
              ~promoted_words:promoted_words_fun__
              ~major_words:major_words_fun__
              ~minor_collections:minor_collections_fun__
              ~major_collections:major_collections_fun__
              ~heap_words:heap_words_fun__
              ~heap_chunks:heap_chunks_fun__
              ~live_words:live_words_fun__
              ~live_blocks:live_blocks_fun__
              ~free_words:free_words_fun__
              ~free_blocks:free_blocks_fun__
              ~largest_free:largest_free_fun__
              ~fragments:fragments_fun__
              ~compactions:compactions_fun__
              ~top_heap_words:top_heap_words_fun__
              ~stack_size:stack_size_fun__
              ~forced_major_collections:forced_major_collections_fun__
              ~live_stacks_words:live_stacks_words_fun__
          =
          [ minor_words_fun__ minor_words
          ; promoted_words_fun__ promoted_words
          ; major_words_fun__ major_words
          ; minor_collections_fun__ minor_collections
          ; major_collections_fun__ major_collections
          ; heap_words_fun__ heap_words
          ; heap_chunks_fun__ heap_chunks
          ; live_words_fun__ live_words
          ; live_blocks_fun__ live_blocks
          ; free_words_fun__ free_words
          ; free_blocks_fun__ free_blocks
          ; largest_free_fun__ largest_free
          ; fragments_fun__ fragments
          ; compactions_fun__ compactions
          ; top_heap_words_fun__ top_heap_words
          ; stack_size_fun__ stack_size
          ; forced_major_collections_fun__ forced_major_collections
          ; live_stacks_words_fun__ live_stacks_words
          ]
        ;;

        let _ = to_list

        module Direct = struct
          let to_list
                record__
                ~minor_words:minor_words_fun__
                ~promoted_words:promoted_words_fun__
                ~major_words:major_words_fun__
                ~minor_collections:minor_collections_fun__
                ~major_collections:major_collections_fun__
                ~heap_words:heap_words_fun__
                ~heap_chunks:heap_chunks_fun__
                ~live_words:live_words_fun__
                ~live_blocks:live_blocks_fun__
                ~free_words:free_words_fun__
                ~free_blocks:free_blocks_fun__
                ~largest_free:largest_free_fun__
                ~fragments:fragments_fun__
                ~compactions:compactions_fun__
                ~top_heap_words:top_heap_words_fun__
                ~stack_size:stack_size_fun__
                ~forced_major_collections:forced_major_collections_fun__
                ~live_stacks_words:live_stacks_words_fun__
            =
            [ minor_words_fun__ minor_words record__ record__.minor_words
            ; promoted_words_fun__ promoted_words record__ record__.promoted_words
            ; major_words_fun__ major_words record__ record__.major_words
            ; minor_collections_fun__
                minor_collections
                record__
                record__.minor_collections
            ; major_collections_fun__
                major_collections
                record__
                record__.major_collections
            ; heap_words_fun__ heap_words record__ record__.heap_words
            ; heap_chunks_fun__ heap_chunks record__ record__.heap_chunks
            ; live_words_fun__ live_words record__ record__.live_words
            ; live_blocks_fun__ live_blocks record__ record__.live_blocks
            ; free_words_fun__ free_words record__ record__.free_words
            ; free_blocks_fun__ free_blocks record__ record__.free_blocks
            ; largest_free_fun__ largest_free record__ record__.largest_free
            ; fragments_fun__ fragments record__ record__.fragments
            ; compactions_fun__ compactions record__ record__.compactions
            ; top_heap_words_fun__ top_heap_words record__ record__.top_heap_words
            ; stack_size_fun__ stack_size record__ record__.stack_size
            ; forced_major_collections_fun__
                forced_major_collections
                record__
                record__.forced_major_collections
            ; live_stacks_words_fun__
                live_stacks_words
                record__
                record__.live_stacks_words
            ]
          ;;

          let _ = to_list
        end
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    [%%endif]
  end

  include T
  include Comparable.Make_plain (T)

  [%%if ocaml_version < (4, 12, 0)]

  let combine first second ~float_f ~int_f =
    { minor_words = float_f first.minor_words second.minor_words
    ; promoted_words = float_f first.promoted_words second.promoted_words
    ; major_words = float_f first.major_words second.major_words
    ; minor_collections = int_f first.minor_collections second.minor_collections
    ; major_collections = int_f first.major_collections second.major_collections
    ; heap_words = int_f first.heap_words second.heap_words
    ; heap_chunks = int_f first.heap_chunks second.heap_chunks
    ; live_words = int_f first.live_words second.live_words
    ; live_blocks = int_f first.live_blocks second.live_blocks
    ; free_words = int_f first.free_words second.free_words
    ; free_blocks = int_f first.free_blocks second.free_blocks
    ; largest_free = int_f first.largest_free second.largest_free
    ; fragments = int_f first.fragments second.fragments
    ; compactions = int_f first.compactions second.compactions
    ; top_heap_words = int_f first.top_heap_words second.top_heap_words
    ; stack_size = int_f first.stack_size second.stack_size
    }
  ;;

  [%%elif ocaml_version < (5, 5, 0)]

  let combine first second ~float_f ~int_f =
    { minor_words = float_f first.minor_words second.minor_words
    ; promoted_words = float_f first.promoted_words second.promoted_words
    ; major_words = float_f first.major_words second.major_words
    ; minor_collections = int_f first.minor_collections second.minor_collections
    ; major_collections = int_f first.major_collections second.major_collections
    ; heap_words = int_f first.heap_words second.heap_words
    ; heap_chunks = int_f first.heap_chunks second.heap_chunks
    ; live_words = int_f first.live_words second.live_words
    ; live_blocks = int_f first.live_blocks second.live_blocks
    ; free_words = int_f first.free_words second.free_words
    ; free_blocks = int_f first.free_blocks second.free_blocks
    ; largest_free = int_f first.largest_free second.largest_free
    ; fragments = int_f first.fragments second.fragments
    ; compactions = int_f first.compactions second.compactions
    ; top_heap_words = int_f first.top_heap_words second.top_heap_words
    ; stack_size = int_f first.stack_size second.stack_size
    ; forced_major_collections =
        int_f first.forced_major_collections second.forced_major_collections
    }
  ;;

  [%%else]

  let combine first second ~float_f ~int_f =
    { minor_words = float_f first.minor_words second.minor_words
    ; promoted_words = float_f first.promoted_words second.promoted_words
    ; major_words = float_f first.major_words second.major_words
    ; minor_collections = int_f first.minor_collections second.minor_collections
    ; major_collections = int_f first.major_collections second.major_collections
    ; heap_words = int_f first.heap_words second.heap_words
    ; heap_chunks = int_f first.heap_chunks second.heap_chunks
    ; live_words = int_f first.live_words second.live_words
    ; live_blocks = int_f first.live_blocks second.live_blocks
    ; free_words = int_f first.free_words second.free_words
    ; free_blocks = int_f first.free_blocks second.free_blocks
    ; largest_free = int_f first.largest_free second.largest_free
    ; fragments = int_f first.fragments second.fragments
    ; compactions = int_f first.compactions second.compactions
    ; top_heap_words = int_f first.top_heap_words second.top_heap_words
    ; stack_size = int_f first.stack_size second.stack_size
    ; forced_major_collections =
        int_f first.forced_major_collections second.forced_major_collections
    ; live_stacks_words = int_f first.live_stacks_words second.live_stacks_words
    }
  ;;

  [%%endif]

  let add = combine ~float_f:Float.( + ) ~int_f:Int.( + )
  let diff = combine ~float_f:Float.( - ) ~int_f:Int.( - )
end

module Control = struct
  [%%if ocaml_version < (5, 0, 0)]

  module T = struct
    [@@@ocaml.warning "-3"]

    type t = Stdlib.Gc.control =
      { mutable minor_heap_size : int
      ; mutable major_heap_increment : int
      ; mutable space_overhead : int
      ; mutable verbose : int
      ; mutable max_overhead : int
      ; mutable stack_limit : int
      ; mutable allocation_policy : int
      ; window_size : int
      ; custom_major_ratio : int
      ; custom_minor_ratio : int
      ; custom_minor_max_size : int
      }
    [@@deriving
      compare, sexp_of, fields ~getters ~setters ~fields ~iterators:(map, to_list)]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__431_ b__432_ ->
           if Stdlib.( == ) a__431_ b__432_
           then 0
           else (
             match compare_int a__431_.minor_heap_size b__432_.minor_heap_size with
             | 0 ->
               (match
                  compare_int a__431_.major_heap_increment b__432_.major_heap_increment
                with
                | 0 ->
                  (match compare_int a__431_.space_overhead b__432_.space_overhead with
                   | 0 ->
                     (match compare_int a__431_.verbose b__432_.verbose with
                      | 0 ->
                        (match compare_int a__431_.max_overhead b__432_.max_overhead with
                         | 0 ->
                           (match compare_int a__431_.stack_limit b__432_.stack_limit with
                            | 0 ->
                              (match
                                 compare_int
                                   a__431_.allocation_policy
                                   b__432_.allocation_policy
                               with
                               | 0 ->
                                 (match
                                    compare_int a__431_.window_size b__432_.window_size
                                  with
                                  | 0 ->
                                    (match
                                       compare_int
                                         a__431_.custom_major_ratio
                                         b__432_.custom_major_ratio
                                     with
                                     | 0 ->
                                       (match
                                          compare_int
                                            a__431_.custom_minor_ratio
                                            b__432_.custom_minor_ratio
                                        with
                                        | 0 ->
                                          compare_int
                                            a__431_.custom_minor_max_size
                                            b__432_.custom_minor_max_size
                                        | n -> n)
                                     | n -> n)
                                  | n -> n)
                               | n -> n)
                            | n -> n)
                         | n -> n)
                      | n -> n)
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let sexp_of_t =
        (fun { minor_heap_size = minor_heap_size__434_
             ; major_heap_increment = major_heap_increment__436_
             ; space_overhead = space_overhead__438_
             ; verbose = verbose__440_
             ; max_overhead = max_overhead__442_
             ; stack_limit = stack_limit__444_
             ; allocation_policy = allocation_policy__446_
             ; window_size = window_size__448_
             ; custom_major_ratio = custom_major_ratio__450_
             ; custom_minor_ratio = custom_minor_ratio__452_
             ; custom_minor_max_size = custom_minor_max_size__454_
             } ->
           let bnds__433_ = ([] : _ Stdlib.List.t) in
           let bnds__433_ =
             let arg__455_ = sexp_of_int custom_minor_max_size__454_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_max_size"; arg__455_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__453_ = sexp_of_int custom_minor_ratio__452_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_ratio"; arg__453_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__451_ = sexp_of_int custom_major_ratio__450_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_major_ratio"; arg__451_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__449_ = sexp_of_int window_size__448_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "window_size"; arg__449_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__447_ = sexp_of_int allocation_policy__446_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "allocation_policy"; arg__447_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__445_ = sexp_of_int stack_limit__444_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_limit"; arg__445_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__443_ = sexp_of_int max_overhead__442_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_overhead"; arg__443_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__441_ = sexp_of_int verbose__440_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "verbose"; arg__441_ ] :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__439_ = sexp_of_int space_overhead__438_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "space_overhead"; arg__439_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__437_ = sexp_of_int major_heap_increment__436_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_heap_increment"; arg__437_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           let bnds__433_ =
             let arg__435_ = sexp_of_int minor_heap_size__434_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_heap_size"; arg__435_ ]
              :: bnds__433_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__433_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let custom_minor_max_size _r__ = _r__.custom_minor_max_size
      let _ = custom_minor_max_size
      let custom_minor_ratio _r__ = _r__.custom_minor_ratio
      let _ = custom_minor_ratio
      let custom_major_ratio _r__ = _r__.custom_major_ratio
      let _ = custom_major_ratio
      let window_size _r__ = _r__.window_size
      let _ = window_size
      let allocation_policy _r__ = _r__.allocation_policy
      let _ = allocation_policy
      let set_allocation_policy _r__ v__ = _r__.allocation_policy <- v__
      let _ = set_allocation_policy
      let stack_limit _r__ = _r__.stack_limit
      let _ = stack_limit
      let set_stack_limit _r__ v__ = _r__.stack_limit <- v__
      let _ = set_stack_limit
      let max_overhead _r__ = _r__.max_overhead
      let _ = max_overhead
      let set_max_overhead _r__ v__ = _r__.max_overhead <- v__
      let _ = set_max_overhead
      let verbose _r__ = _r__.verbose
      let _ = verbose
      let set_verbose _r__ v__ = _r__.verbose <- v__
      let _ = set_verbose
      let space_overhead _r__ = _r__.space_overhead
      let _ = space_overhead
      let set_space_overhead _r__ v__ = _r__.space_overhead <- v__
      let _ = set_space_overhead
      let major_heap_increment _r__ = _r__.major_heap_increment
      let _ = major_heap_increment
      let set_major_heap_increment _r__ v__ = _r__.major_heap_increment <- v__
      let _ = set_major_heap_increment
      let minor_heap_size _r__ = _r__.minor_heap_size
      let _ = minor_heap_size
      let set_minor_heap_size _r__ v__ = _r__.minor_heap_size <- v__
      let _ = set_minor_heap_size

      module Fields = struct
        let custom_minor_max_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_minor_max_size"
             ; getter = custom_minor_max_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_minor_max_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_minor_max_size

        let custom_minor_ratio =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_minor_ratio"
             ; getter = custom_minor_ratio
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_minor_ratio = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_minor_ratio

        let custom_major_ratio =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_major_ratio"
             ; getter = custom_major_ratio
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_major_ratio = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_major_ratio

        let window_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "window_size"
             ; getter = window_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with window_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = window_size

        let allocation_policy =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "allocation_policy"
             ; getter = allocation_policy
             ; setter = Some set_allocation_policy
             ; fset = (fun _r__ v__ -> { _r__ with allocation_policy = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = allocation_policy

        let stack_limit =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "stack_limit"
             ; getter = stack_limit
             ; setter = Some set_stack_limit
             ; fset = (fun _r__ v__ -> { _r__ with stack_limit = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = stack_limit

        let max_overhead =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "max_overhead"
             ; getter = max_overhead
             ; setter = Some set_max_overhead
             ; fset = (fun _r__ v__ -> { _r__ with max_overhead = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = max_overhead

        let verbose =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "verbose"
             ; getter = verbose
             ; setter = Some set_verbose
             ; fset = (fun _r__ v__ -> { _r__ with verbose = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = verbose

        let space_overhead =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "space_overhead"
             ; getter = space_overhead
             ; setter = Some set_space_overhead
             ; fset = (fun _r__ v__ -> { _r__ with space_overhead = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = space_overhead

        let major_heap_increment =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_heap_increment"
             ; getter = major_heap_increment
             ; setter = Some set_major_heap_increment
             ; fset = (fun _r__ v__ -> { _r__ with major_heap_increment = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_heap_increment

        let minor_heap_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_heap_size"
             ; getter = minor_heap_size
             ; setter = Some set_minor_heap_size
             ; fset = (fun _r__ v__ -> { _r__ with minor_heap_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_heap_size

        let map
              ~minor_heap_size:minor_heap_size_fun__
              ~major_heap_increment:major_heap_increment_fun__
              ~space_overhead:space_overhead_fun__
              ~verbose:verbose_fun__
              ~max_overhead:max_overhead_fun__
              ~stack_limit:stack_limit_fun__
              ~allocation_policy:allocation_policy_fun__
              ~window_size:window_size_fun__
              ~custom_major_ratio:custom_major_ratio_fun__
              ~custom_minor_ratio:custom_minor_ratio_fun__
              ~custom_minor_max_size:custom_minor_max_size_fun__
          =
          { minor_heap_size = minor_heap_size_fun__ minor_heap_size
          ; major_heap_increment = major_heap_increment_fun__ major_heap_increment
          ; space_overhead = space_overhead_fun__ space_overhead
          ; verbose = verbose_fun__ verbose
          ; max_overhead = max_overhead_fun__ max_overhead
          ; stack_limit = stack_limit_fun__ stack_limit
          ; allocation_policy = allocation_policy_fun__ allocation_policy
          ; window_size = window_size_fun__ window_size
          ; custom_major_ratio = custom_major_ratio_fun__ custom_major_ratio
          ; custom_minor_ratio = custom_minor_ratio_fun__ custom_minor_ratio
          ; custom_minor_max_size = custom_minor_max_size_fun__ custom_minor_max_size
          }
        ;;

        let _ = map

        let to_list
              ~minor_heap_size:minor_heap_size_fun__
              ~major_heap_increment:major_heap_increment_fun__
              ~space_overhead:space_overhead_fun__
              ~verbose:verbose_fun__
              ~max_overhead:max_overhead_fun__
              ~stack_limit:stack_limit_fun__
              ~allocation_policy:allocation_policy_fun__
              ~window_size:window_size_fun__
              ~custom_major_ratio:custom_major_ratio_fun__
              ~custom_minor_ratio:custom_minor_ratio_fun__
              ~custom_minor_max_size:custom_minor_max_size_fun__
          =
          [ minor_heap_size_fun__ minor_heap_size
          ; major_heap_increment_fun__ major_heap_increment
          ; space_overhead_fun__ space_overhead
          ; verbose_fun__ verbose
          ; max_overhead_fun__ max_overhead
          ; stack_limit_fun__ stack_limit
          ; allocation_policy_fun__ allocation_policy
          ; window_size_fun__ window_size
          ; custom_major_ratio_fun__ custom_major_ratio
          ; custom_minor_ratio_fun__ custom_minor_ratio
          ; custom_minor_max_size_fun__ custom_minor_max_size
          ]
        ;;

        let _ = to_list
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  [%%else]

  module T = struct
    [@@@ocaml.warning "-3"]

    type t = Stdlib.Gc.control =
      { minor_heap_size : int
      ; major_heap_increment : int
      ; space_overhead : int
      ; verbose : int
      ; max_overhead : int
      ; stack_limit : int
      ; allocation_policy : int
      ; window_size : int
      ; custom_major_ratio : int
      ; custom_minor_ratio : int
      ; custom_minor_max_size : int
      }
    [@@deriving
      compare, sexp_of, fields ~getters ~setters ~fields ~iterators:(map, to_list)]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__456_ b__457_ ->
           if Stdlib.( == ) a__456_ b__457_
           then 0
           else (
             match compare_int a__456_.minor_heap_size b__457_.minor_heap_size with
             | 0 ->
               (match
                  compare_int a__456_.major_heap_increment b__457_.major_heap_increment
                with
                | 0 ->
                  (match compare_int a__456_.space_overhead b__457_.space_overhead with
                   | 0 ->
                     (match compare_int a__456_.verbose b__457_.verbose with
                      | 0 ->
                        (match compare_int a__456_.max_overhead b__457_.max_overhead with
                         | 0 ->
                           (match compare_int a__456_.stack_limit b__457_.stack_limit with
                            | 0 ->
                              (match
                                 compare_int
                                   a__456_.allocation_policy
                                   b__457_.allocation_policy
                               with
                               | 0 ->
                                 (match
                                    compare_int a__456_.window_size b__457_.window_size
                                  with
                                  | 0 ->
                                    (match
                                       compare_int
                                         a__456_.custom_major_ratio
                                         b__457_.custom_major_ratio
                                     with
                                     | 0 ->
                                       (match
                                          compare_int
                                            a__456_.custom_minor_ratio
                                            b__457_.custom_minor_ratio
                                        with
                                        | 0 ->
                                          compare_int
                                            a__456_.custom_minor_max_size
                                            b__457_.custom_minor_max_size
                                        | n -> n)
                                     | n -> n)
                                  | n -> n)
                               | n -> n)
                            | n -> n)
                         | n -> n)
                      | n -> n)
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let sexp_of_t =
        (fun { minor_heap_size = minor_heap_size__459_
             ; major_heap_increment = major_heap_increment__461_
             ; space_overhead = space_overhead__463_
             ; verbose = verbose__465_
             ; max_overhead = max_overhead__467_
             ; stack_limit = stack_limit__469_
             ; allocation_policy = allocation_policy__471_
             ; window_size = window_size__473_
             ; custom_major_ratio = custom_major_ratio__475_
             ; custom_minor_ratio = custom_minor_ratio__477_
             ; custom_minor_max_size = custom_minor_max_size__479_
             } ->
           let bnds__458_ = ([] : _ Stdlib.List.t) in
           let bnds__458_ =
             let arg__480_ = sexp_of_int custom_minor_max_size__479_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_max_size"; arg__480_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__478_ = sexp_of_int custom_minor_ratio__477_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_minor_ratio"; arg__478_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__476_ = sexp_of_int custom_major_ratio__475_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "custom_major_ratio"; arg__476_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__474_ = sexp_of_int window_size__473_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "window_size"; arg__474_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__472_ = sexp_of_int allocation_policy__471_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "allocation_policy"; arg__472_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__470_ = sexp_of_int stack_limit__469_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stack_limit"; arg__470_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__468_ = sexp_of_int max_overhead__467_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_overhead"; arg__468_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__466_ = sexp_of_int verbose__465_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "verbose"; arg__466_ ] :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__464_ = sexp_of_int space_overhead__463_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "space_overhead"; arg__464_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__462_ = sexp_of_int major_heap_increment__461_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_heap_increment"; arg__462_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           let bnds__458_ =
             let arg__460_ = sexp_of_int minor_heap_size__459_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_heap_size"; arg__460_ ]
              :: bnds__458_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__458_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let custom_minor_max_size _r__ = _r__.custom_minor_max_size
      let _ = custom_minor_max_size
      let custom_minor_ratio _r__ = _r__.custom_minor_ratio
      let _ = custom_minor_ratio
      let custom_major_ratio _r__ = _r__.custom_major_ratio
      let _ = custom_major_ratio
      let window_size _r__ = _r__.window_size
      let _ = window_size
      let allocation_policy _r__ = _r__.allocation_policy
      let _ = allocation_policy
      let stack_limit _r__ = _r__.stack_limit
      let _ = stack_limit
      let max_overhead _r__ = _r__.max_overhead
      let _ = max_overhead
      let verbose _r__ = _r__.verbose
      let _ = verbose
      let space_overhead _r__ = _r__.space_overhead
      let _ = space_overhead
      let major_heap_increment _r__ = _r__.major_heap_increment
      let _ = major_heap_increment
      let minor_heap_size _r__ = _r__.minor_heap_size
      let _ = minor_heap_size

      module Fields = struct
        let custom_minor_max_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_minor_max_size"
             ; getter = custom_minor_max_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_minor_max_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_minor_max_size

        let custom_minor_ratio =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_minor_ratio"
             ; getter = custom_minor_ratio
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_minor_ratio = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_minor_ratio

        let custom_major_ratio =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "custom_major_ratio"
             ; getter = custom_major_ratio
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with custom_major_ratio = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = custom_major_ratio

        let window_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "window_size"
             ; getter = window_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with window_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = window_size

        let allocation_policy =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "allocation_policy"
             ; getter = allocation_policy
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with allocation_policy = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = allocation_policy

        let stack_limit =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "stack_limit"
             ; getter = stack_limit
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with stack_limit = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = stack_limit

        let max_overhead =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "max_overhead"
             ; getter = max_overhead
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with max_overhead = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = max_overhead

        let verbose =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "verbose"
             ; getter = verbose
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with verbose = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = verbose

        let space_overhead =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "space_overhead"
             ; getter = space_overhead
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with space_overhead = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = space_overhead

        let major_heap_increment =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "major_heap_increment"
             ; getter = major_heap_increment
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with major_heap_increment = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = major_heap_increment

        let minor_heap_size =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "minor_heap_size"
             ; getter = minor_heap_size
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with minor_heap_size = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = minor_heap_size

        let map
              ~minor_heap_size:minor_heap_size_fun__
              ~major_heap_increment:major_heap_increment_fun__
              ~space_overhead:space_overhead_fun__
              ~verbose:verbose_fun__
              ~max_overhead:max_overhead_fun__
              ~stack_limit:stack_limit_fun__
              ~allocation_policy:allocation_policy_fun__
              ~window_size:window_size_fun__
              ~custom_major_ratio:custom_major_ratio_fun__
              ~custom_minor_ratio:custom_minor_ratio_fun__
              ~custom_minor_max_size:custom_minor_max_size_fun__
          =
          { minor_heap_size = minor_heap_size_fun__ minor_heap_size
          ; major_heap_increment = major_heap_increment_fun__ major_heap_increment
          ; space_overhead = space_overhead_fun__ space_overhead
          ; verbose = verbose_fun__ verbose
          ; max_overhead = max_overhead_fun__ max_overhead
          ; stack_limit = stack_limit_fun__ stack_limit
          ; allocation_policy = allocation_policy_fun__ allocation_policy
          ; window_size = window_size_fun__ window_size
          ; custom_major_ratio = custom_major_ratio_fun__ custom_major_ratio
          ; custom_minor_ratio = custom_minor_ratio_fun__ custom_minor_ratio
          ; custom_minor_max_size = custom_minor_max_size_fun__ custom_minor_max_size
          }
        ;;

        let _ = map

        let to_list
              ~minor_heap_size:minor_heap_size_fun__
              ~major_heap_increment:major_heap_increment_fun__
              ~space_overhead:space_overhead_fun__
              ~verbose:verbose_fun__
              ~max_overhead:max_overhead_fun__
              ~stack_limit:stack_limit_fun__
              ~allocation_policy:allocation_policy_fun__
              ~window_size:window_size_fun__
              ~custom_major_ratio:custom_major_ratio_fun__
              ~custom_minor_ratio:custom_minor_ratio_fun__
              ~custom_minor_max_size:custom_minor_max_size_fun__
          =
          [ minor_heap_size_fun__ minor_heap_size
          ; major_heap_increment_fun__ major_heap_increment
          ; space_overhead_fun__ space_overhead
          ; verbose_fun__ verbose
          ; max_overhead_fun__ max_overhead
          ; stack_limit_fun__ stack_limit
          ; allocation_policy_fun__ allocation_policy
          ; window_size_fun__ window_size
          ; custom_major_ratio_fun__ custom_major_ratio
          ; custom_minor_ratio_fun__ custom_minor_ratio
          ; custom_minor_max_size_fun__ custom_minor_max_size
          ]
        ;;

        let _ = to_list
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  [%%endif]

  include T
  include Comparable.Make_plain (T)
end

module Allocation_policy = struct
  type t = Stable.Allocation_policy.V1.t =
    | Next_fit
    | First_fit
    | Best_fit
  [@@deriving compare, equal, hash, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__481_ b__482_ -> Stdlib.compare a__481_ b__482_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__483_ b__484_ -> Stdlib.( = ) a__483_ b__484_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      (fun hsv arg ->
         Ppx_hash_lib.Std.Hash.fold_int
           hsv
           (match arg with
            | Next_fit -> 0
            | First_fit -> 1
            | Best_fit -> 2)
       : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
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

    let sexp_of_t =
      (function
       | Next_fit -> Sexplib0.Sexp.Atom "Next_fit"
       | First_fit -> Sexplib0.Sexp.Atom "First_fit"
       | Best_fit -> Sexplib0.Sexp.Atom "Best_fit"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_int = function
    | Next_fit -> 0
    | First_fit -> 1
    | Best_fit -> 2
  ;;
end

let tune
      ?logger
      ?minor_heap_size
      ?major_heap_increment
      ?space_overhead
      ?verbose
      ?max_overhead
      ?stack_limit
      ?allocation_policy
      ?window_size
      ?custom_major_ratio
      ?custom_minor_ratio
      ?custom_minor_max_size
      ()
  =
  let old_control_params = get () in
  let f opt to_string field =
    let old_value = Field.get field old_control_params in
    match opt with
    | None -> old_value
    | Some new_value ->
      Option.iter logger ~f:(fun f ->
        Printf.ksprintf
          f
          "Gc.Control.%s: %s -> %s"
          (Field.name field)
          (to_string old_value)
          (to_string new_value));
      new_value
  in
  let allocation_policy = Option.map allocation_policy ~f:Allocation_policy.to_int in
  let new_control_params =
    Control.Fields.map
      ~minor_heap_size:(f minor_heap_size string_of_int)
      ~major_heap_increment:(f major_heap_increment string_of_int)
      ~space_overhead:(f space_overhead string_of_int)
      ~verbose:(f verbose string_of_int)
      ~max_overhead:(f max_overhead string_of_int)
      ~stack_limit:(f stack_limit string_of_int)
      ~allocation_policy:(f allocation_policy string_of_int)
      ~window_size:(f window_size string_of_int)
      ~custom_major_ratio:(f custom_major_ratio string_of_int)
      ~custom_minor_ratio:(f custom_minor_ratio string_of_int)
      ~custom_minor_max_size:(f custom_minor_max_size string_of_int)
  in
  set new_control_params
;;

let disable_compaction ?logger ~allocation_policy () =
  let allocation_policy =
    match allocation_policy with
    | `Don't_change -> None
    | `Set_to policy -> Some policy
  in
  tune ?logger ?allocation_policy ~max_overhead:1_000_000 ()
;;

external minor_words : unit -> int = "core_gc_minor_words"
external major_words : unit -> int = "core_gc_major_words" [@@noalloc]
external promoted_words : unit -> int = "core_gc_promoted_words" [@@noalloc]
external minor_collections : unit -> int = "core_gc_minor_collections" [@@noalloc]
external major_collections : unit -> int = "core_gc_major_collections" [@@noalloc]
external major_plus_minor_words : unit -> int = "core_gc_major_plus_minor_words"
external allocated_words : unit -> int = "core_gc_allocated_words"
external run_memprof_callbacks : unit -> unit = "core_gc_run_memprof_callbacks"

module Runtime4 = struct
  external heap_words : unit -> int = "core_gc_heap_words" [@@noalloc]
  external heap_chunks : unit -> int = "core_gc_heap_chunks" [@@noalloc]
  external top_heap_words : unit -> int = "core_gc_top_heap_words" [@@noalloc]
end

[%%import "gc_stubs.h"]
[%%if ocaml_version < (5, 0, 0)]

external compactions : unit -> int = "core_gc_compactions" [@@noalloc]

let heap_words = Runtime4.heap_words
let heap_chunks = Runtime4.heap_chunks
let top_heap_words = Runtime4.top_heap_words

[%%else]

module Runtime5 = struct
  let heap_words () = (quick_stat ()).heap_words
  let heap_chunks () = (quick_stat ()).heap_chunks
  let top_heap_words () = (quick_stat ()).top_heap_words
end

[%%if OCAML_5_MINUS]

external runtime5 : unit -> bool = "%runtime5"
external compactions : unit -> int = "core_gc_compactions" [@@noalloc]

let runtime5 = runtime5 ()
let heap_words = if runtime5 then Runtime5.heap_words else Runtime4.heap_words
let heap_chunks = if runtime5 then Runtime5.heap_chunks else Runtime4.heap_chunks
let top_heap_words = if runtime5 then Runtime5.top_heap_words else Runtime4.top_heap_words

[%%else]

let compactions () = (quick_stat ()).compactions
let heap_words = Runtime5.heap_words
let heap_chunks = Runtime5.heap_chunks
let top_heap_words = Runtime5.top_heap_words

[%%endif]
[%%endif]

let stat_size_lazy =
  lazy (Obj.reachable_words (Obj.repr (Stdlib.Gc.quick_stat () : Stat.t)))
;;

let stat_size () = Lazy.force stat_size_lazy
let zero = Sys.opaque_identity (int_of_string "0")
let rec keep_alive o = if zero <> 0 then keep_alive (Sys.opaque_identity o)

module For_testing = struct
  type 'a globl = { g : 'a } [@@unboxed]

  let measure_internal ~on_result (f : unit -> 'a) =
    let minor_words_before = minor_words () in
    let major_words_before = major_words () in
    let x = Sys.opaque_identity (f ()) in
    let minor_words_after = minor_words () in
    let major_words_after = major_words () in
    let major_words_allocated = major_words_after - major_words_before in
    let minor_words_allocated = minor_words_after - minor_words_before in
    on_result ~major_words_allocated ~minor_words_allocated x
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let is_zero_alloc_local (type a) (f : unit -> a) =
    measure_internal
      f
      ~on_result:(fun ~major_words_allocated ~minor_words_allocated value ->
        ignore (Sys.opaque_identity value : a);
        major_words_allocated == 0 && minor_words_allocated == 0)
    [@nontail]
  ;;

  let is_zero_alloc f = is_zero_alloc_local (fun () -> { g = f () }) [@nontail]

  module Allocation_report = struct
    type t =
      { major_words_allocated : int [@globalized]
      ; minor_words_allocated : int [@globalized]
      }
    [@@deriving sexp_of, globalize]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (fun { major_words_allocated = major_words_allocated__486_
             ; minor_words_allocated = minor_words_allocated__488_
             } ->
           let bnds__485_ = ([] : _ Stdlib.List.t) in
           let bnds__485_ =
             let arg__489_ = sexp_of_int minor_words_allocated__488_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minor_words_allocated"; arg__489_ ]
              :: bnds__485_
              : _ Stdlib.List.t)
           in
           let bnds__485_ =
             let arg__487_ = sexp_of_int major_words_allocated__486_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "major_words_allocated"; arg__487_ ]
              :: bnds__485_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__485_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let globalize : t -> t =
        (fun x__490_ ->
           let { major_words_allocated = major_words_allocated__492_
               ; minor_words_allocated = minor_words_allocated__491_
               }
             =
             x__490_
           in
           { major_words_allocated = (fun x -> x : int -> int) major_words_allocated__492_
           ; minor_words_allocated = (fun x -> x : int -> int) minor_words_allocated__491_
           }
         : t -> t)
      ;;

      let _ = globalize
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create ~major_words_allocated ~minor_words_allocated =
      { major_words_allocated; minor_words_allocated }
    ;;
  end

  let measure_allocation_local f =
    measure_internal f ~on_result:(fun ~major_words_allocated ~minor_words_allocated x ->
      x, Allocation_report.create ~major_words_allocated ~minor_words_allocated)
  ;;

  let measure_allocation_for_runtime5_local f =
    let minor_words_before = minor_words () in
    let promoted_words_before = promoted_words () in
    let major_words_before = major_words () in
    let x = Sys.opaque_identity (f ()) in
    let minor_words_after = minor_words () in
    let promoted_words_after = promoted_words () in
    let major_words_after = major_words () in
    let major_words_allocated =
      major_words_after
      - promoted_words_after
      - (major_words_before - promoted_words_before)
    in
    let minor_words_allocated = minor_words_after - minor_words_before in
    x, Allocation_report.create ~major_words_allocated ~minor_words_allocated
  ;;

  let measure_allocation f =
    let g, allocation_report = measure_allocation_local (fun () -> { g = f () }) in
    g.g, Allocation_report.globalize allocation_report
  ;;

  module Allocation_log = struct
    type t =
      { size_in_words : int [@globalized]
      ; is_major : bool [@globalized]
      ; backtrace : string
      }
    [@@deriving sexp_of, globalize]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (fun { size_in_words = size_in_words__495_
             ; is_major = is_major__497_
             ; backtrace = backtrace__499_
             } ->
           let bnds__494_ = ([] : _ Stdlib.List.t) in
           let bnds__494_ =
             let arg__500_ = sexp_of_string backtrace__499_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "backtrace"; arg__500_ ]
              :: bnds__494_
              : _ Stdlib.List.t)
           in
           let bnds__494_ =
             let arg__498_ = sexp_of_bool is_major__497_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "is_major"; arg__498_ ]
              :: bnds__494_
              : _ Stdlib.List.t)
           in
           let bnds__494_ =
             let arg__496_ = sexp_of_int size_in_words__495_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "size_in_words"; arg__496_ ]
              :: bnds__494_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__494_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let globalize : t -> t =
        (fun x__501_ ->
           let { size_in_words = size_in_words__504_
               ; is_major = is_major__503_
               ; backtrace = backtrace__502_
               }
             =
             x__501_
           in
           { size_in_words = (fun x -> x : int -> int) size_in_words__504_
           ; is_major = (fun x -> x : bool -> bool) is_major__503_
           ; backtrace = globalize_string backtrace__502_
           }
         : t -> t)
      ;;

      let _ = globalize
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  [%%if ocaml_version >= (4, 11, 0)]

  let measure_and_log_allocation_local (f : unit -> 'a) =
    let log : Allocation_log.t list ref = ref []
    and major_allocs = ref 0
    and minor_allocs = ref 0 in
    let on_alloc ~is_major (info : Stdlib.Gc.Memprof.allocation) =
      if is_major
      then major_allocs := !major_allocs + info.n_samples
      else minor_allocs := !minor_allocs + info.n_samples;
      let backtrace = Stdlib.Printexc.raw_backtrace_to_string info.callstack in
      let backtrace =
        match String.substr_index backtrace ~pattern:"measure_and_log_allocation" with
        | None -> backtrace
        | Some p ->
          String.rstrip
            ~drop:(function
              | '\n' -> false
              | _ -> true)
            (String.sub ~pos:0 ~len:p backtrace)
      in
      let info : Allocation_log.t =
        { size_in_words = info.n_samples; is_major; backtrace }
      in
      log := info :: !log;
      None
    in
    let tracker =
      { Stdlib.Gc.Memprof.null_tracker with
        alloc_minor = on_alloc ~is_major:false
      ; alloc_major = on_alloc ~is_major:true
      }
    in
    match Stdlib.Gc.Memprof.start ~sampling_rate:1.0 tracker with
    | _ ->
      let result =
        match f () with
        | x ->
          run_memprof_callbacks ();
          Stdlib.Gc.Memprof.stop ();
          x
        | exception e ->
          run_memprof_callbacks ();
          Stdlib.Gc.Memprof.stop ();
          raise e
      in
      ( result
      , Allocation_report.create
          ~major_words_allocated:!major_allocs
          ~minor_words_allocated:!minor_allocs
      , List.rev !log )
    | exception Failure msg ->
      if String.equal msg "Gc.memprof.start: not implemented in multicore"
      then (
        let a, b = measure_allocation_for_runtime5_local f in
        a, b, [])
      else failwith msg
  ;;

  let measure_and_log_allocation f =
    let { g }, allocation_report, log =
      measure_and_log_allocation_local (fun () -> { g = f () })
    in
    ( g
    , Allocation_report.globalize allocation_report
    , (fun x__506_ -> globalize_list Allocation_log.globalize x__506_) log )
  ;;

  [%%else]

  let measure_and_log_allocation f =
    let x, report = measure_allocation f in
    x, report, []
  ;;

  let measure_and_log_allocation_local = measure_and_log_allocation

  [%%endif]

  let require_no_allocation_local_failed here allocation_report allocation_log =
    let allocation_report = Allocation_report.globalize allocation_report in
    let allocation_log =
      (fun x__509_ -> globalize_list Allocation_log.globalize x__509_) allocation_log
    in
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "allocation detected"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "here"
               ; (Source_code_position.sexp_of_t [@merlin.hide]) here
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "allocation_report"
               ; (Allocation_report.sexp_of_t [@merlin.hide]) allocation_report
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "allocation_log"
               ; ((fun x__511_ -> sexp_of_list Allocation_log.sexp_of_t x__511_)
                    [@merlin.hide])
                   allocation_log
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let assert_no_allocation_local here f =
    let result, allocation_report, allocation_log = measure_and_log_allocation_local f in
    if
      allocation_report.major_words_allocated > 0
      || allocation_report.minor_words_allocated > 0
    then require_no_allocation_local_failed here allocation_report allocation_log;
    result
  ;;

  let assert_no_allocation here f =
    (assert_no_allocation_local here (fun () -> { g = f () })).g
  ;;
end

module Expert = struct
  let add_finalizer x f =
    try Stdlib.Gc.finalise (fun x -> Exn.handle_uncaught_and_exit (fun () -> f x)) x with
    | Invalid_argument _ -> ()
  ;;

  let add_finalizer_exn x f =
    try Stdlib.Gc.finalise (fun x -> Exn.handle_uncaught_and_exit (fun () -> f x)) x with
    | Invalid_argument _ ->
      ignore (Heap_block.create x : _ Heap_block.t option);
      ()
  ;;

  let add_finalizer_last x f =
    try Stdlib.Gc.finalise_last (fun () -> Exn.handle_uncaught_and_exit f) x with
    | Invalid_argument _ -> ()
  ;;

  let add_finalizer_last_exn x f =
    try Stdlib.Gc.finalise_last (fun () -> Exn.handle_uncaught_and_exit f) x with
    | Invalid_argument _ ->
      ignore (Heap_block.create x : _ Heap_block.t option);
      ()
  ;;

  let finalize_release = Stdlib.Gc.finalise_release

  module Alarm = struct
    type t = alarm

    let sexp_of_t _ = (sexp_of_string [@merlin.hide]) "<gc alarm>"
    let create f = create_alarm (fun () -> Exn.handle_uncaught_and_exit f)
    let delete = delete_alarm
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
