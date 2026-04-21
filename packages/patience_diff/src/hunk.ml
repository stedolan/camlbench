let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"hunk.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "hunk.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable
  module Range = Range.Stable

  module V2 = struct
    type 'a t =
      { prev_start : int
      ; prev_size : int
      ; next_start : int
      ; next_size : int
      ; ranges : 'a Range.V2.t list
      }
    [@@deriving fields ~getters, sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()
      let ranges _r__ = _r__.ranges
      let _ = ranges
      let next_size _r__ = _r__.next_size
      let _ = next_size
      let next_start _r__ = _r__.next_start
      let _ = next_start
      let prev_size _r__ = _r__.prev_size
      let _ = prev_size
      let prev_start _r__ = _r__.prev_start
      let _ = prev_start

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        let error_source__003_ = "hunk.ml.before-ppx.Stable.V2.t" in
        fun _of_a__001_ x__004_ ->
          Sexplib0.Sexp_conv_record.record_of_sexp
            ~caller:error_source__003_
            ~fields:
              (Field
                 { name = "prev_start"
                 ; kind = Required
                 ; conv = int_of_sexp
                 ; rest =
                     Field
                       { name = "prev_size"
                       ; kind = Required
                       ; conv = int_of_sexp
                       ; rest =
                           Field
                             { name = "next_start"
                             ; kind = Required
                             ; conv = int_of_sexp
                             ; rest =
                                 Field
                                   { name = "next_size"
                                   ; kind = Required
                                   ; conv = int_of_sexp
                                   ; rest =
                                       Field
                                         { name = "ranges"
                                         ; kind = Required
                                         ; conv =
                                             list_of_sexp (Range.V2.t_of_sexp _of_a__001_)
                                         ; rest = Empty
                                         }
                                   }
                             }
                       }
                 })
            ~index_of_field:(function
              | "prev_start" -> 0
              | "prev_size" -> 1
              | "next_start" -> 2
              | "next_size" -> 3
              | "ranges" -> 4
              | _ -> -1)
            ~allow_extra_fields:false
            ~create:
              (fun
                (prev_start, (prev_size, (next_start, (next_size, (ranges, ()))))) ->
              ({ prev_start; prev_size; next_start; next_size; ranges } : _ t))
            x__004_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__005_
          { prev_start = prev_start__007_
          ; prev_size = prev_size__009_
          ; next_start = next_start__011_
          ; next_size = next_size__013_
          ; ranges = ranges__015_
          } ->
        let bnds__006_ = ([] : _ Stdlib.List.t) in
        let bnds__006_ =
          let arg__016_ = sexp_of_list (Range.V2.sexp_of_t _of_a__005_) ranges__015_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ranges"; arg__016_ ] :: bnds__006_
           : _ Stdlib.List.t)
        in
        let bnds__006_ =
          let arg__014_ = sexp_of_int next_size__013_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_size"; arg__014_ ] :: bnds__006_
           : _ Stdlib.List.t)
        in
        let bnds__006_ =
          let arg__012_ = sexp_of_int next_start__011_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_start"; arg__012_ ] :: bnds__006_
           : _ Stdlib.List.t)
        in
        let bnds__006_ =
          let arg__010_ = sexp_of_int prev_size__009_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_size"; arg__010_ ] :: bnds__006_
           : _ Stdlib.List.t)
        in
        let bnds__006_ =
          let arg__008_ = sexp_of_int prev_start__007_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_start"; arg__008_ ] :: bnds__006_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__006_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "hunk.ml.before-ppx:6:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.record
                  [ "prev_start", bin_shape_int
                  ; "prev_size", bin_shape_int
                  ; "next_start", bin_shape_int
                  ; "next_size", bin_shape_int
                  ; ( "ranges"
                    , bin_shape_list
                        (Range.V2.bin_shape_t
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "hunk.ml.before-ppx:11:17")
                              (Bin_prot.Shape.Vid.of_string "a"))) )
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | { prev_start = v1
          ; prev_size = v2
          ; next_start = v3
          ; next_size = v4
          ; ranges = v5
          } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
          Bin_prot.Common.( + ) size (bin_size_list (Range.V2.bin_size_t _size_of_a) v5)
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | { prev_start = v1
          ; prev_size = v2
          ; next_start = v3
          ; next_size = v4
          ; ranges = v5
          } ->
          let pos = bin_write_int buf ~pos v1 in
          let pos = bin_write_int buf ~pos v2 in
          let pos = bin_write_int buf ~pos v3 in
          let pos = bin_write_int buf ~pos v4 in
          bin_write_list (Range.V2.bin_write_t _write_a) buf ~pos v5
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
        Bin_prot.Common.raise_variant_wrong_type "hunk.ml.before-ppx.Stable.V2.t" !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        let v_prev_start = bin_read_int buf ~pos_ref in
        let v_prev_size = bin_read_int buf ~pos_ref in
        let v_next_start = bin_read_int buf ~pos_ref in
        let v_next_size = bin_read_int buf ~pos_ref in
        let v_ranges = (bin_read_list (Range.V2.bin_read_t _of__a)) buf ~pos_ref in
        { prev_start = v_prev_start
        ; prev_size = v_prev_size
        ; next_start = v_next_start
        ; next_size = v_next_size
        ; ranges = v_ranges
        }
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
      { prev_start : int
      ; prev_size : int
      ; next_start : int
      ; next_size : int
      ; ranges : 'a Range.V1.t list
      }
    [@@deriving fields ~getters, sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()
      let ranges _r__ = _r__.ranges
      let _ = ranges
      let next_size _r__ = _r__.next_size
      let _ = next_size
      let next_start _r__ = _r__.next_start
      let _ = next_start
      let prev_size _r__ = _r__.prev_size
      let _ = prev_size
      let prev_start _r__ = _r__.prev_start
      let _ = prev_start

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        let error_source__019_ = "hunk.ml.before-ppx.Stable.V1.t" in
        fun _of_a__017_ x__020_ ->
          Sexplib0.Sexp_conv_record.record_of_sexp
            ~caller:error_source__019_
            ~fields:
              (Field
                 { name = "prev_start"
                 ; kind = Required
                 ; conv = int_of_sexp
                 ; rest =
                     Field
                       { name = "prev_size"
                       ; kind = Required
                       ; conv = int_of_sexp
                       ; rest =
                           Field
                             { name = "next_start"
                             ; kind = Required
                             ; conv = int_of_sexp
                             ; rest =
                                 Field
                                   { name = "next_size"
                                   ; kind = Required
                                   ; conv = int_of_sexp
                                   ; rest =
                                       Field
                                         { name = "ranges"
                                         ; kind = Required
                                         ; conv =
                                             list_of_sexp (Range.V1.t_of_sexp _of_a__017_)
                                         ; rest = Empty
                                         }
                                   }
                             }
                       }
                 })
            ~index_of_field:(function
              | "prev_start" -> 0
              | "prev_size" -> 1
              | "next_start" -> 2
              | "next_size" -> 3
              | "ranges" -> 4
              | _ -> -1)
            ~allow_extra_fields:false
            ~create:
              (fun
                (prev_start, (prev_size, (next_start, (next_size, (ranges, ()))))) ->
              ({ prev_start; prev_size; next_start; next_size; ranges } : _ t))
            x__020_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__021_
          { prev_start = prev_start__023_
          ; prev_size = prev_size__025_
          ; next_start = next_start__027_
          ; next_size = next_size__029_
          ; ranges = ranges__031_
          } ->
        let bnds__022_ = ([] : _ Stdlib.List.t) in
        let bnds__022_ =
          let arg__032_ = sexp_of_list (Range.V1.sexp_of_t _of_a__021_) ranges__031_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ranges"; arg__032_ ] :: bnds__022_
           : _ Stdlib.List.t)
        in
        let bnds__022_ =
          let arg__030_ = sexp_of_int next_size__029_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_size"; arg__030_ ] :: bnds__022_
           : _ Stdlib.List.t)
        in
        let bnds__022_ =
          let arg__028_ = sexp_of_int next_start__027_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_start"; arg__028_ ] :: bnds__022_
           : _ Stdlib.List.t)
        in
        let bnds__022_ =
          let arg__026_ = sexp_of_int prev_size__025_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_size"; arg__026_ ] :: bnds__022_
           : _ Stdlib.List.t)
        in
        let bnds__022_ =
          let arg__024_ = sexp_of_int prev_start__023_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_start"; arg__024_ ] :: bnds__022_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__022_
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "hunk.ml.before-ppx:17:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.record
                  [ "prev_start", bin_shape_int
                  ; "prev_size", bin_shape_int
                  ; "next_start", bin_shape_int
                  ; "next_size", bin_shape_int
                  ; ( "ranges"
                    , bin_shape_list
                        (Range.V1.bin_shape_t
                           (Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "hunk.ml.before-ppx:22:17")
                              (Bin_prot.Shape.Vid.of_string "a"))) )
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | { prev_start = v1
          ; prev_size = v2
          ; next_start = v3
          ; next_size = v4
          ; ranges = v5
          } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v4) in
          Bin_prot.Common.( + ) size (bin_size_list (Range.V1.bin_size_t _size_of_a) v5)
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | { prev_start = v1
          ; prev_size = v2
          ; next_start = v3
          ; next_size = v4
          ; ranges = v5
          } ->
          let pos = bin_write_int buf ~pos v1 in
          let pos = bin_write_int buf ~pos v2 in
          let pos = bin_write_int buf ~pos v3 in
          let pos = bin_write_int buf ~pos v4 in
          bin_write_list (Range.V1.bin_write_t _write_a) buf ~pos v5
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
        Bin_prot.Common.raise_variant_wrong_type "hunk.ml.before-ppx.Stable.V1.t" !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        let v_prev_start = bin_read_int buf ~pos_ref in
        let v_prev_size = bin_read_int buf ~pos_ref in
        let v_next_start = bin_read_int buf ~pos_ref in
        let v_next_size = bin_read_int buf ~pos_ref in
        let v_ranges = (bin_read_list (Range.V1.bin_read_t _of__a)) buf ~pos_ref in
        { prev_start = v_prev_start
        ; prev_size = v_prev_size
        ; next_start = v_next_start
        ; next_size = v_next_size
        ; ranges = v_ranges
        }
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

    let to_v2 t =
      { V2.prev_start = t.prev_start
      ; prev_size = t.prev_size
      ; next_start = t.next_start
      ; next_size = t.next_size
      ; ranges = Core.List.map t.ranges ~f:Range.V1.to_v2
      }
    ;;

    let of_v2_no_moves_exn (t : _ V2.t) =
      { prev_start = t.prev_start
      ; prev_size = t.prev_size
      ; next_start = t.next_start
      ; next_size = t.next_size
      ; ranges = Core.List.map t.ranges ~f:Range.V1.of_v2_no_moves_exn
      }
    ;;
  end
end

open! Core
include Stable.V2

let _invariant t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "hunk.ml.before-ppx"
    ; pos_lnum = 50
    ; pos_cnum = 1108
    ; pos_bol = 1086
    }
    t
    ((fun x__033_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__033_) [@merlin.hide])
    (fun () ->
       (fun ?(here = []) ?message ?equal ~expect got ->
          let pos = "hunk.ml.before-ppx:51:19" in
          let sexpifier = (sexp_of_int [@merlin.hide]) in
          let comparator =
            (fun (a__034_ : int) ((b__035_ : int) [@merlin.hide]) ->
            (compare_int a__034_ b__035_ [@merlin.hide]))
            [@merlin.hide]
          in
          Ppx_assert_lib.Runtime.test_result
            ~pos
            ~sexpifier
            ~comparator
            ~here
            ?message
            ?equal
            ~expect
            ~got)
         (List.sum (module Int) t.ranges ~f:Range.prev_size)
         ~expect:t.prev_size
         ~message:"prev_size";
       (fun ?(here = []) ?message ?equal ~expect got ->
          let pos = "hunk.ml.before-ppx:55:19" in
          let sexpifier = (sexp_of_int [@merlin.hide]) in
          let comparator =
            (fun (a__036_ : int) ((b__037_ : int) [@merlin.hide]) ->
            (compare_int a__036_ b__037_ [@merlin.hide]))
            [@merlin.hide]
          in
          Ppx_assert_lib.Runtime.test_result
            ~pos
            ~sexpifier
            ~comparator
            ~here
            ?message
            ?equal
            ~expect
            ~got)
         (List.sum (module Int) t.ranges ~f:Range.next_size)
         ~expect:t.next_size
         ~message:"next_size")
;;

let all_same hunk = Range.all_same hunk.ranges
let concat_map t ~f = { t with ranges = List.concat_map t.ranges ~f }
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
