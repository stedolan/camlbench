let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"source_code_position0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "source_code_position0.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    include Base.Source_code_position

    type t = Base.Source_code_position.t =
      { pos_fname : string
      ; pos_lnum : int
      ; pos_bol : int
      ; pos_cnum : int
      }
    [@@deriving bin_io, compare, equal, fields ~getters, hash, sexp, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "source_code_position0.ml.before-ppx:7:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.record
                  [ "pos_fname", bin_shape_string
                  ; "pos_lnum", bin_shape_int
                  ; "pos_bol", bin_shape_int
                  ; "pos_cnum", bin_shape_int
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | { pos_fname = v1; pos_lnum = v2; pos_bol = v3; pos_cnum = v4 } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
          let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
          Bin_prot.Common.( + ) size (bin_size_int v4)
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | { pos_fname = v1; pos_lnum = v2; pos_bol = v3; pos_cnum = v4 } ->
          let pos = bin_write_string buf ~pos v1 in
          let pos = bin_write_int buf ~pos v2 in
          let pos = bin_write_int buf ~pos v3 in
          bin_write_int buf ~pos v4
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "source_code_position0.ml.before-ppx.Stable.V1.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        let v_pos_fname = bin_read_string buf ~pos_ref in
        let v_pos_lnum = bin_read_int buf ~pos_ref in
        let v_pos_bol = bin_read_int buf ~pos_ref in
        let v_pos_cnum = bin_read_int buf ~pos_ref in
        { pos_fname = v_pos_fname
        ; pos_lnum = v_pos_lnum
        ; pos_bol = v_pos_bol
        ; pos_cnum = v_pos_cnum
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

      let compare =
        (fun a__001_ b__002_ ->
           if Stdlib.( == ) a__001_ b__002_
           then 0
           else (
             match compare_string a__001_.pos_fname b__002_.pos_fname with
             | 0 ->
               (match compare_int a__001_.pos_lnum b__002_.pos_lnum with
                | 0 ->
                  (match compare_int a__001_.pos_bol b__002_.pos_bol with
                   | 0 -> compare_int a__001_.pos_cnum b__002_.pos_cnum
                   | n -> n)
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__003_ b__004_ ->
           if Stdlib.( == ) a__003_ b__004_
           then true
           else
             Stdlib.( && )
               (equal_string a__003_.pos_fname b__004_.pos_fname)
               (Stdlib.( && )
                  (equal_int a__003_.pos_lnum b__004_.pos_lnum)
                  (Stdlib.( && )
                     (equal_int a__003_.pos_bol b__004_.pos_bol)
                     (equal_int a__003_.pos_cnum b__004_.pos_cnum)))
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let pos_cnum _r__ = _r__.pos_cnum
      let _ = pos_cnum
      let pos_bol _r__ = _r__.pos_bol
      let _ = pos_bol
      let pos_lnum _r__ = _r__.pos_lnum
      let _ = pos_lnum
      let pos_fname _r__ = _r__.pos_fname
      let _ = pos_fname

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let hsv =
          let hsv =
            let hsv =
              let hsv = hsv in
              hash_fold_string hsv arg.pos_fname
            in
            hash_fold_int hsv arg.pos_lnum
          in
          hash_fold_int hsv arg.pos_bol
        in
        hash_fold_int hsv arg.pos_cnum
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
        (let error_source__006_ = "source_code_position0.ml.before-ppx.Stable.V1.t" in
         fun x__007_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__006_
             ~fields:
               (Field
                  { name = "pos_fname"
                  ; kind = Required
                  ; conv = string_of_sexp
                  ; rest =
                      Field
                        { name = "pos_lnum"
                        ; kind = Required
                        ; conv = int_of_sexp
                        ; rest =
                            Field
                              { name = "pos_bol"
                              ; kind = Required
                              ; conv = int_of_sexp
                              ; rest =
                                  Field
                                    { name = "pos_cnum"
                                    ; kind = Required
                                    ; conv = int_of_sexp
                                    ; rest = Empty
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "pos_fname" -> 0
               | "pos_lnum" -> 1
               | "pos_bol" -> 2
               | "pos_cnum" -> 3
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (pos_fname, (pos_lnum, (pos_bol, (pos_cnum, ())))) ->
               ({ pos_fname; pos_lnum; pos_bol; pos_cnum } : t))
             x__007_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { pos_fname = pos_fname__009_
             ; pos_lnum = pos_lnum__011_
             ; pos_bol = pos_bol__013_
             ; pos_cnum = pos_cnum__015_
             } ->
           let bnds__008_ = ([] : _ Stdlib.List.t) in
           let bnds__008_ =
             let arg__016_ = sexp_of_int pos_cnum__015_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos_cnum"; arg__016_ ]
              :: bnds__008_
              : _ Stdlib.List.t)
           in
           let bnds__008_ =
             let arg__014_ = sexp_of_int pos_bol__013_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos_bol"; arg__014_ ] :: bnds__008_
              : _ Stdlib.List.t)
           in
           let bnds__008_ =
             let arg__012_ = sexp_of_int pos_lnum__011_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos_lnum"; arg__012_ ]
              :: bnds__008_
              : _ Stdlib.List.t)
           in
           let bnds__008_ =
             let arg__010_ = sexp_of_string pos_fname__009_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos_fname"; arg__010_ ]
              :: bnds__008_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__008_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : string Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_string
        and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

include Stable.V1

let to_string = Base.Source_code_position.to_string
let sexp_of_t = Base.Source_code_position.sexp_of_t
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
