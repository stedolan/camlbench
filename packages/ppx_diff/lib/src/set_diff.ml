let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"set_diff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "set_diff.ml.before-ppx"
;;

open Base
open Bin_prot.Std

module Stable = struct
  module V1 = struct
    module Change = struct
      type 'a t =
        | Add of 'a
        | Remove of 'a
      [@@deriving sexp, bin_io]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun (type a__016_) ->
          (let error_source__004_ = "set_diff.ml.before-ppx.Stable.V1.Change.t" in
           fun _of_a__001_ -> function
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("add" | "Add") as _tag__007_) :: sexp_args__008_)
               as _sexp__006_ ->
               (match sexp_args__008_ with
                | arg0__009_ :: [] ->
                  let res0__010_ = _of_a__001_ arg0__009_ in
                  Add res0__010_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__004_
                    _tag__007_
                    _sexp__006_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("remove" | "Remove") as _tag__012_)
                 :: sexp_args__013_) as _sexp__011_ ->
               (match sexp_args__013_ with
                | arg0__014_ :: [] ->
                  let res0__015_ = _of_a__001_ arg0__014_ in
                  Remove res0__015_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__004_
                    _tag__012_
                    _sexp__011_)
             | Sexplib0.Sexp.Atom ("add" | "Add") as sexp__005_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
             | Sexplib0.Sexp.Atom ("remove" | "Remove") as sexp__005_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
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
           : (Sexplib0.Sexp.t -> a__016_) -> Sexplib0.Sexp.t -> a__016_ t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun (type a__022_) ->
          (fun _of_a__017_ -> function
             | Add arg0__018_ ->
               let res0__019_ = _of_a__017_ arg0__018_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Add"; res0__019_ ]
             | Remove arg0__020_ ->
               let res0__021_ = _of_a__017_ arg0__020_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Remove"; res0__021_ ]
           : (a__022_ -> Sexplib0.Sexp.t) -> a__022_ t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "set_diff.ml.before-ppx:7:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.variant
                    [ ( "Add"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "set_diff.ml.before-ppx:8:17")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ] )
                    ; ( "Remove"
                      , [ Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "set_diff.ml.before-ppx:9:20")
                            (Bin_prot.Shape.Vid.of_string "a")
                        ] )
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | Add v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a v1)
          | Remove v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (_size_of_a v1)
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | Add v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            _write_a buf ~pos v1
          | Remove v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
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

        let __bin_read_t__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
          =
          fun _of__a _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "set_diff.ml.before-ppx.Stable.V1.Change.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = _of__a buf ~pos_ref in
            Add arg_1
          | 1 ->
            let arg_1 = _of__a buf ~pos_ref in
            Remove arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "set_diff.ml.before-ppx.Stable.V1.Change.t")
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

    type 'a t = 'a Change.t list [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__023_ x__025_ -> list_of_sexp (Change.t_of_sexp _of_a__023_) x__025_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__026_ x__027_ -> sexp_of_list (Change.sexp_of_t _of_a__026_) x__027_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "set_diff.ml.before-ppx:13:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_list
                  (Change.bin_shape_t
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "set_diff.ml.before-ppx:13:16")
                        (Bin_prot.Shape.Vid.of_string "a"))) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_list (Change.bin_size_t _size_of_a) v
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_list (Change.bin_write_t _write_a) buf ~pos v
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
        fun _of__a buf ~pos_ref vint ->
        (__bin_read_list__ (Change.bin_read_t _of__a)) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_list (Change.bin_read_t _of__a)) buf ~pos_ref
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

    let get ~from ~to_ =
      if phys_equal from to_
      then Optional_diff.none
      else (
        let diff =
          List.map
            ~f:(function
              | First a -> Change.Remove a
              | Second a -> Change.Add a)
            (Sequence.to_list (Set.symmetric_diff from to_))
        in
        if List.is_empty diff then Optional_diff.none else Optional_diff.return diff)
    ;;

    let apply_exn set diff =
      List.fold diff ~init:set ~f:(fun acc diff ->
        match diff with
        | Change.Remove set -> Set.remove acc set
        | Change.Add set -> Set.add acc set)
    ;;

    let of_list_exn = function
      | [] -> Optional_diff.none
      | _ :: _ as l -> Optional_diff.return (List.concat l)
    ;;

    module Make (S : sig
        module Elt : sig
          type t
          type comparator_witness
        end

        type t = (Elt.t, Elt.comparator_witness) Set.t
      end) : Diff_intf.S_plain with type derived_on := S.t and type t := S.Elt.t t =
    struct
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
