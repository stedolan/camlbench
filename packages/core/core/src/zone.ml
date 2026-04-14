let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"zone.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "zone.ml.before-ppx"
;;

open Import
open Std_internal
open! Int.Replace_polymorphic_compare
include Zone_intf

exception Invalid_file_format of string [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Invalid_file_format]
      (function
      | Invalid_file_format arg0__001_ ->
        let res0__002_ = sexp_of_string arg0__001_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "zone.ml.before-ppx.Invalid_file_format"; res0__002_ ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Stable = struct
  module Full_data = struct
    module V1 = struct
      module Index = struct
        type t = int

        let next = Int.succ
        let prev = Int.pred
        let before_first_transition = -1
        let to_external t = max 0 t
        let of_external (_ : t) = -1

        include
          Binable.Of_binable_without_uuid [@alert "-legacy"]
            (Int.Stable.V1)
            (struct
              type t = int

              let to_binable = to_external
              let of_binable = of_external
            end)

        let stable_witness =
          Stable_witness.of_serializable
            Int.Stable.V1.stable_witness
            of_external
            to_external
        ;;

        include
          Sexpable.Of_sexpable
            (Int)
            (struct
              type t = int

              let to_sexpable = to_external
              let of_sexpable = of_external
            end)
      end

      module Regime = struct
        type t = Timezone_types.Regime.t =
          { utc_offset_in_seconds : Int63.Stable.V1.t
          ; is_dst : bool
          ; abbrv : string
          }
        [@@deriving bin_io, sexp, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "zone.ml.before-ppx:71:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.record
                      [ "utc_offset_in_seconds", Int63.Stable.V1.bin_shape_t
                      ; "is_dst", bin_shape_bool
                      ; "abbrv", bin_shape_string
                      ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer = function
            | { utc_offset_in_seconds = v1; is_dst = v2; abbrv = v3 } ->
              let size = 0 in
              let size = Bin_prot.Common.( + ) size (Int63.Stable.V1.bin_size_t v1) in
              let size = Bin_prot.Common.( + ) size (bin_size_bool v2) in
              Bin_prot.Common.( + ) size (bin_size_string v3)
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | { utc_offset_in_seconds = v1; is_dst = v2; abbrv = v3 } ->
              let pos = Int63.Stable.V1.bin_write_t buf ~pos v1 in
              let pos = bin_write_bool buf ~pos v2 in
              bin_write_string buf ~pos v3
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "zone.ml.before-ppx.Stable.Full_data.V1.Regime.t"
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            let v_utc_offset_in_seconds = Int63.Stable.V1.bin_read_t buf ~pos_ref in
            let v_is_dst = bin_read_bool buf ~pos_ref in
            let v_abbrv = bin_read_string buf ~pos_ref in
            { utc_offset_in_seconds = v_utc_offset_in_seconds
            ; is_dst = v_is_dst
            ; abbrv = v_abbrv
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

          let t_of_sexp =
            (let error_source__004_ = "zone.ml.before-ppx.Stable.Full_data.V1.Regime.t" in
             fun x__005_ ->
               Sexplib0.Sexp_conv_record.record_of_sexp
                 ~caller:error_source__004_
                 ~fields:
                   (Field
                      { name = "utc_offset_in_seconds"
                      ; kind = Required
                      ; conv = Int63.Stable.V1.t_of_sexp
                      ; rest =
                          Field
                            { name = "is_dst"
                            ; kind = Required
                            ; conv = bool_of_sexp
                            ; rest =
                                Field
                                  { name = "abbrv"
                                  ; kind = Required
                                  ; conv = string_of_sexp
                                  ; rest = Empty
                                  }
                            }
                      })
                 ~index_of_field:(function
                   | "utc_offset_in_seconds" -> 0
                   | "is_dst" -> 1
                   | "abbrv" -> 2
                   | _ -> -1)
                 ~allow_extra_fields:false
                 ~create:(fun (utc_offset_in_seconds, (is_dst, (abbrv, ()))) ->
                   ({ utc_offset_in_seconds; is_dst; abbrv } : t))
                 x__005_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun { utc_offset_in_seconds = utc_offset_in_seconds__007_
                 ; is_dst = is_dst__009_
                 ; abbrv = abbrv__011_
                 } ->
               let bnds__006_ = ([] : _ Stdlib.List.t) in
               let bnds__006_ =
                 let arg__012_ = sexp_of_string abbrv__011_ in
                 (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "abbrv"; arg__012_ ]
                  :: bnds__006_
                  : _ Stdlib.List.t)
               in
               let bnds__006_ =
                 let arg__010_ = sexp_of_bool is_dst__009_ in
                 (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "is_dst"; arg__010_ ]
                  :: bnds__006_
                  : _ Stdlib.List.t)
               in
               let bnds__006_ =
                 let arg__008_ = Int63.Stable.V1.sexp_of_t utc_offset_in_seconds__007_ in
                 (Sexplib0.Sexp.List
                    [ Sexplib0.Sexp.Atom "utc_offset_in_seconds"; arg__008_ ]
                  :: bnds__006_
                  : _ Stdlib.List.t)
               in
               Sexplib0.Sexp.List bnds__006_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : Int63.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
              Int63.Stable.V1.stable_witness
            and _ : bool Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_bool
            and _ : string Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_string
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      module Leap_second = struct
        type t =
          { time_in_seconds_since_epoch : Int63.Stable.V1.t
          ; seconds : int
          }
        [@@deriving bin_io, sexp, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "zone.ml.before-ppx:83:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.record
                      [ "time_in_seconds_since_epoch", Int63.Stable.V1.bin_shape_t
                      ; "seconds", bin_shape_int
                      ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer = function
            | { time_in_seconds_since_epoch = v1; seconds = v2 } ->
              let size = 0 in
              let size = Bin_prot.Common.( + ) size (Int63.Stable.V1.bin_size_t v1) in
              Bin_prot.Common.( + ) size (bin_size_int v2)
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | { time_in_seconds_since_epoch = v1; seconds = v2 } ->
              let pos = Int63.Stable.V1.bin_write_t buf ~pos v1 in
              bin_write_int buf ~pos v2
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "zone.ml.before-ppx.Stable.Full_data.V1.Leap_second.t"
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            let v_time_in_seconds_since_epoch = Int63.Stable.V1.bin_read_t buf ~pos_ref in
            let v_seconds = bin_read_int buf ~pos_ref in
            { time_in_seconds_since_epoch = v_time_in_seconds_since_epoch
            ; seconds = v_seconds
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

          let t_of_sexp =
            (let error_source__014_ =
               "zone.ml.before-ppx.Stable.Full_data.V1.Leap_second.t"
             in
             fun x__015_ ->
               Sexplib0.Sexp_conv_record.record_of_sexp
                 ~caller:error_source__014_
                 ~fields:
                   (Field
                      { name = "time_in_seconds_since_epoch"
                      ; kind = Required
                      ; conv = Int63.Stable.V1.t_of_sexp
                      ; rest =
                          Field
                            { name = "seconds"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest = Empty
                            }
                      })
                 ~index_of_field:(function
                   | "time_in_seconds_since_epoch" -> 0
                   | "seconds" -> 1
                   | _ -> -1)
                 ~allow_extra_fields:false
                 ~create:(fun (time_in_seconds_since_epoch, (seconds, ())) ->
                   ({ time_in_seconds_since_epoch; seconds } : t))
                 x__015_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun { time_in_seconds_since_epoch = time_in_seconds_since_epoch__017_
                 ; seconds = seconds__019_
                 } ->
               let bnds__016_ = ([] : _ Stdlib.List.t) in
               let bnds__016_ =
                 let arg__020_ = sexp_of_int seconds__019_ in
                 (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "seconds"; arg__020_ ]
                  :: bnds__016_
                  : _ Stdlib.List.t)
               in
               let bnds__016_ =
                 let arg__018_ =
                   Int63.Stable.V1.sexp_of_t time_in_seconds_since_epoch__017_
                 in
                 (Sexplib0.Sexp.List
                    [ Sexplib0.Sexp.Atom "time_in_seconds_since_epoch"; arg__018_ ]
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
            let _ : Int63.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
              Int63.Stable.V1.stable_witness
            and _ : int Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_int
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      module Transition = struct
        type t = Timezone_types.Transition.t =
          { start_time_in_seconds_since_epoch : Int63.Stable.V1.t
          ; new_regime : Regime.t
          }
        [@@deriving bin_io, sexp, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "zone.ml.before-ppx:91:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.record
                      [ "start_time_in_seconds_since_epoch", Int63.Stable.V1.bin_shape_t
                      ; "new_regime", Regime.bin_shape_t
                      ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer = function
            | { start_time_in_seconds_since_epoch = v1; new_regime = v2 } ->
              let size = 0 in
              let size = Bin_prot.Common.( + ) size (Int63.Stable.V1.bin_size_t v1) in
              Bin_prot.Common.( + ) size (Regime.bin_size_t v2)
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | { start_time_in_seconds_since_epoch = v1; new_regime = v2 } ->
              let pos = Int63.Stable.V1.bin_write_t buf ~pos v1 in
              Regime.bin_write_t buf ~pos v2
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "zone.ml.before-ppx.Stable.Full_data.V1.Transition.t"
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            let v_start_time_in_seconds_since_epoch =
              Int63.Stable.V1.bin_read_t buf ~pos_ref
            in
            let v_new_regime = Regime.bin_read_t buf ~pos_ref in
            { start_time_in_seconds_since_epoch = v_start_time_in_seconds_since_epoch
            ; new_regime = v_new_regime
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

          let t_of_sexp =
            (let error_source__022_ =
               "zone.ml.before-ppx.Stable.Full_data.V1.Transition.t"
             in
             fun x__023_ ->
               Sexplib0.Sexp_conv_record.record_of_sexp
                 ~caller:error_source__022_
                 ~fields:
                   (Field
                      { name = "start_time_in_seconds_since_epoch"
                      ; kind = Required
                      ; conv = Int63.Stable.V1.t_of_sexp
                      ; rest =
                          Field
                            { name = "new_regime"
                            ; kind = Required
                            ; conv = Regime.t_of_sexp
                            ; rest = Empty
                            }
                      })
                 ~index_of_field:(function
                   | "start_time_in_seconds_since_epoch" -> 0
                   | "new_regime" -> 1
                   | _ -> -1)
                 ~allow_extra_fields:false
                 ~create:(fun (start_time_in_seconds_since_epoch, (new_regime, ())) ->
                   ({ start_time_in_seconds_since_epoch; new_regime } : t))
                 x__023_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun { start_time_in_seconds_since_epoch =
                     start_time_in_seconds_since_epoch__025_
                 ; new_regime = new_regime__027_
                 } ->
               let bnds__024_ = ([] : _ Stdlib.List.t) in
               let bnds__024_ =
                 let arg__028_ = Regime.sexp_of_t new_regime__027_ in
                 (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "new_regime"; arg__028_ ]
                  :: bnds__024_
                  : _ Stdlib.List.t)
               in
               let bnds__024_ =
                 let arg__026_ =
                   Int63.Stable.V1.sexp_of_t start_time_in_seconds_since_epoch__025_
                 in
                 (Sexplib0.Sexp.List
                    [ Sexplib0.Sexp.Atom "start_time_in_seconds_since_epoch"; arg__026_ ]
                  :: bnds__024_
                  : _ Stdlib.List.t)
               in
               Sexplib0.Sexp.List bnds__024_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : Int63.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
              Int63.Stable.V1.stable_witness
            and _ : Regime.t Ppx_stable_witness_runtime.Stable_witness.t =
              Regime.stable_witness
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      type t =
        { name : string
        ; original_filename : string option
        ; digest : Md5.As_binary_string.Stable.V1.t option
        ; transitions : Transition.t array
        ; mutable last_regime_index : Index.t
        ; default_local_time_type : Regime.t
        ; leap_seconds : Leap_second.t list
        }
      [@@deriving bin_io, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "zone.ml.before-ppx:98:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "name", bin_shape_string
                    ; "original_filename", bin_shape_option bin_shape_string
                    ; ( "digest"
                      , bin_shape_option Md5.As_binary_string.Stable.V1.bin_shape_t )
                    ; "transitions", bin_shape_array Transition.bin_shape_t
                    ; "last_regime_index", Index.bin_shape_t
                    ; "default_local_time_type", Regime.bin_shape_t
                    ; "leap_seconds", bin_shape_list Leap_second.bin_shape_t
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { name = v1
            ; original_filename = v2
            ; digest = v3
            ; transitions = v4
            ; last_regime_index = v5
            ; default_local_time_type = v6
            ; leap_seconds = v7
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_option bin_size_string v2) in
            let size =
              Bin_prot.Common.( + )
                size
                (bin_size_option Md5.As_binary_string.Stable.V1.bin_size_t v3)
            in
            let size =
              Bin_prot.Common.( + ) size (bin_size_array Transition.bin_size_t v4)
            in
            let size = Bin_prot.Common.( + ) size (Index.bin_size_t v5) in
            let size = Bin_prot.Common.( + ) size (Regime.bin_size_t v6) in
            Bin_prot.Common.( + ) size (bin_size_list Leap_second.bin_size_t v7)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { name = v1
            ; original_filename = v2
            ; digest = v3
            ; transitions = v4
            ; last_regime_index = v5
            ; default_local_time_type = v6
            ; leap_seconds = v7
            } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_option bin_write_string buf ~pos v2 in
            let pos =
              bin_write_option Md5.As_binary_string.Stable.V1.bin_write_t buf ~pos v3
            in
            let pos = bin_write_array Transition.bin_write_t buf ~pos v4 in
            let pos = Index.bin_write_t buf ~pos v5 in
            let pos = Regime.bin_write_t buf ~pos v6 in
            bin_write_list Leap_second.bin_write_t buf ~pos v7
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "zone.ml.before-ppx.Stable.Full_data.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_name = bin_read_string buf ~pos_ref in
          let v_original_filename = (bin_read_option bin_read_string) buf ~pos_ref in
          let v_digest =
            (bin_read_option Md5.As_binary_string.Stable.V1.bin_read_t) buf ~pos_ref
          in
          let v_transitions = (bin_read_array Transition.bin_read_t) buf ~pos_ref in
          let v_last_regime_index = Index.bin_read_t buf ~pos_ref in
          let v_default_local_time_type = Regime.bin_read_t buf ~pos_ref in
          let v_leap_seconds = (bin_read_list Leap_second.bin_read_t) buf ~pos_ref in
          { name = v_name
          ; original_filename = v_original_filename
          ; digest = v_digest
          ; transitions = v_transitions
          ; last_regime_index = v_last_regime_index
          ; default_local_time_type = v_default_local_time_type
          ; leap_seconds = v_leap_seconds
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

        let t_of_sexp =
          (let error_source__030_ = "zone.ml.before-ppx.Stable.Full_data.V1.t" in
           fun x__031_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__030_
               ~fields:
                 (Field
                    { name = "name"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "original_filename"
                          ; kind = Required
                          ; conv = option_of_sexp string_of_sexp
                          ; rest =
                              Field
                                { name = "digest"
                                ; kind = Required
                                ; conv =
                                    option_of_sexp
                                      Md5.As_binary_string.Stable.V1.t_of_sexp
                                ; rest =
                                    Field
                                      { name = "transitions"
                                      ; kind = Required
                                      ; conv = array_of_sexp Transition.t_of_sexp
                                      ; rest =
                                          Field
                                            { name = "last_regime_index"
                                            ; kind = Required
                                            ; conv = Index.t_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "default_local_time_type"
                                                  ; kind = Required
                                                  ; conv = Regime.t_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "leap_seconds"
                                                        ; kind = Required
                                                        ; conv =
                                                            list_of_sexp
                                                              Leap_second.t_of_sexp
                                                        ; rest = Empty
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "name" -> 0
                 | "original_filename" -> 1
                 | "digest" -> 2
                 | "transitions" -> 3
                 | "last_regime_index" -> 4
                 | "default_local_time_type" -> 5
                 | "leap_seconds" -> 6
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( name
                   , ( original_filename
                     , ( digest
                       , ( transitions
                         , ( last_regime_index
                           , (default_local_time_type, (leap_seconds, ())) ) ) ) ) ) ->
                 ({ name
                  ; original_filename
                  ; digest
                  ; transitions
                  ; last_regime_index
                  ; default_local_time_type
                  ; leap_seconds
                  }
                  : t))
               x__031_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { name = name__033_
               ; original_filename = original_filename__035_
               ; digest = digest__037_
               ; transitions = transitions__039_
               ; last_regime_index = last_regime_index__041_
               ; default_local_time_type = default_local_time_type__043_
               ; leap_seconds = leap_seconds__045_
               } ->
             let bnds__032_ = ([] : _ Stdlib.List.t) in
             let bnds__032_ =
               let arg__046_ = sexp_of_list Leap_second.sexp_of_t leap_seconds__045_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "leap_seconds"; arg__046_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__044_ = Regime.sexp_of_t default_local_time_type__043_ in
               (Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom "default_local_time_type"; arg__044_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__042_ = Index.sexp_of_t last_regime_index__041_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "last_regime_index"; arg__042_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__040_ = sexp_of_array Transition.sexp_of_t transitions__039_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "transitions"; arg__040_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__038_ =
                 sexp_of_option Md5.As_binary_string.Stable.V1.sexp_of_t digest__037_
               in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "digest"; arg__038_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__036_ = sexp_of_option sexp_of_string original_filename__035_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "original_filename"; arg__036_ ]
                :: bnds__032_
                : _ Stdlib.List.t)
             in
             let bnds__032_ =
               let arg__034_ = sexp_of_string name__033_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__034_ ] :: bnds__032_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__032_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            :  Md5.As_binary_string.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            -> Md5.As_binary_string.Stable.V1.t option
                 Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            : Md5.As_binary_string.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Md5.As_binary_string.Stable.V1.stable_witness
          and _
            :  Transition.t Ppx_stable_witness_runtime.Stable_witness.t
            -> Transition.t array Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_array
          and _ : Transition.t Ppx_stable_witness_runtime.Stable_witness.t =
            Transition.stable_witness
          and _ : Index.t Ppx_stable_witness_runtime.Stable_witness.t =
            Index.stable_witness
          and _ : Regime.t Ppx_stable_witness_runtime.Stable_witness.t =
            Regime.stable_witness
          and _
            :  Leap_second.t Ppx_stable_witness_runtime.Stable_witness.t
            -> Leap_second.t list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : Leap_second.t Ppx_stable_witness_runtime.Stable_witness.t =
            Leap_second.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let compare t1 t2 = String.compare t1.name t2.name
      let original_filename zone = zone.original_filename
      let digest zone = zone.digest

      module Zone_file : sig
        val input_tz_file : zonename:string -> filename:string -> t
      end = struct
        let bool_of_int i = i <> 0

        let input_long_as_int32 =
          let long = Bytes.create 4 in
          let int32_of_char chr = Int32.of_int_exn (int_of_char chr) in
          fun ic ->
            In_channel.really_input_exn ic ~buf:long ~pos:0 ~len:4;
            let sb1 = Int32.shift_left (int32_of_char (Bytes.get long 0)) 24 in
            let sb2 = Int32.shift_left (int32_of_char (Bytes.get long 1)) 16 in
            let sb3 = Int32.shift_left (int32_of_char (Bytes.get long 2)) 8 in
            let sb4 = int32_of_char (Bytes.get long 3) in
            Int32.bit_or (Int32.bit_or sb1 sb2) (Int32.bit_or sb3 sb4)
        ;;

        let input_long_as_int ic = Int32.to_int_exn (input_long_as_int32 ic)
        let input_long_as_int63 ic = Int63.of_int32 (input_long_as_int32 ic)

        let input_long_long_as_int63 ic =
          let int63_of_char chr = Int63.of_int_exn (int_of_char chr) in
          let shift c bits = Int63.shift_left (int63_of_char c) bits in
          let long_long = Bytes.create 8 in
          In_channel.really_input_exn ic ~buf:long_long ~pos:0 ~len:8;
          let result = shift (Bytes.get long_long 0) 56 in
          let result = Int63.bit_or result (shift (Bytes.get long_long 1) 48) in
          let result = Int63.bit_or result (shift (Bytes.get long_long 2) 40) in
          let result = Int63.bit_or result (shift (Bytes.get long_long 3) 32) in
          let result = Int63.bit_or result (shift (Bytes.get long_long 4) 24) in
          let result = Int63.bit_or result (shift (Bytes.get long_long 5) 16) in
          let result = Int63.bit_or result (shift (Bytes.get long_long 6) 8) in
          let result = Int63.bit_or result (int63_of_char (Bytes.get long_long 7)) in
          result
        ;;

        let input_list ic ~len ~f =
          let rec loop c lst =
            if c > 0 then loop (c - 1) (f ic :: lst) else List.rev lst
          in
          loop len []
        ;;

        let input_array ic ~len ~f = Array.of_list (input_list ic ~len ~f)

        let input_regime ic =
          let utc_offset_in_seconds = input_long_as_int63 ic in
          let is_dst = bool_of_int (Option.value_exn (In_channel.input_byte ic)) in
          let abbrv_index = Option.value_exn (In_channel.input_byte ic) in
          let lt abbrv = { Regime.utc_offset_in_seconds; is_dst; abbrv } in
          lt, abbrv_index
        ;;

        let input_abbreviations ic ~len =
          let raw_abbrvs =
            input_list ic ~len ~f:(fun ic -> Option.value_exn (In_channel.input_char ic))
          in
          let buf = Buffer.create len in
          let _, indexed_abbrvs =
            List.fold raw_abbrvs ~init:(0, Map.Poly.empty) ~f:(fun (index, abbrvs) c ->
              match c with
              | '\000' ->
                let data = Buffer.contents buf in
                let next_index = index + String.length data + 1 in
                let abbrvs = Map.set abbrvs ~key:index ~data in
                Buffer.clear buf;
                next_index, abbrvs
              | c ->
                Buffer.add_char buf c;
                index, abbrvs)
          in
          if Buffer.length buf <> 0
          then
            raise
              (Invalid_file_format
                 "missing \000 terminating character in input_abbreviations");
          indexed_abbrvs
        ;;

        let input_tz_file_gen ~input_transition ~input_leap_second ic =
          let utc_local_count = input_long_as_int ic in
          let std_wall_count = input_long_as_int ic in
          let leap_count = input_long_as_int ic in
          let transition_count = input_long_as_int ic in
          let type_count = input_long_as_int ic in
          let abbrv_char_count = input_long_as_int ic in
          let transition_times =
            input_list ic ~f:input_transition ~len:transition_count
          in
          let transition_indices =
            input_list
              ic
              ~f:(fun ic -> Option.value_exn (In_channel.input_byte ic))
              ~len:transition_count
          in
          let regimes = input_list ic ~f:input_regime ~len:type_count in
          let abbreviations = input_abbreviations ic ~len:abbrv_char_count in
          let leap_seconds = input_list ic ~f:input_leap_second ~len:leap_count in
          let _std_wall_indicators =
            input_array ic ~len:std_wall_count ~f:(fun ic ->
              bool_of_int (Option.value_exn (In_channel.input_byte ic)))
          in
          let _utc_local_indicators =
            input_array ic ~len:utc_local_count ~f:(fun ic ->
              bool_of_int (Option.value_exn (In_channel.input_byte ic)))
          in
          let regimes =
            Array.of_list
              (List.map regimes ~f:(fun (lt, abbrv_index) ->
                 let abbrv = Map.find_exn abbreviations abbrv_index in
                 lt abbrv))
          in
          let raw_transitions =
            List.map2_exn transition_times transition_indices ~f:(fun time index ->
              let regime = regimes.(index) in
              time, regime)
          in
          let transitions =
            let rec make_transitions acc l =
              match l with
              | [] -> Array.of_list (List.rev acc)
              | (start_time_in_seconds_since_epoch, new_regime) :: rest ->
                make_transitions
                  ({ Transition.start_time_in_seconds_since_epoch; new_regime } :: acc)
                  rest
            in
            make_transitions [] raw_transitions
          in
          let default_local_time_type =
            match Array.find regimes ~f:(fun r -> not r.Regime.is_dst) with
            | None -> regimes.(0)
            | Some ltt -> ltt
          in
          fun name ~original_filename ~digest ->
            { name
            ; original_filename = Some original_filename
            ; digest = Some digest
            ; transitions
            ; last_regime_index = Index.before_first_transition
            ; default_local_time_type
            ; leap_seconds
            }
        ;;

        let input_leap_second_gen ~input_leap_second ic =
          let time_in_seconds_since_epoch = input_leap_second ic in
          let seconds = input_long_as_int ic in
          { Leap_second.time_in_seconds_since_epoch; seconds }
        ;;

        let read_header ic =
          let magic =
            let buf = Bytes.create 4 in
            In_channel.really_input_exn ic ~buf ~pos:0 ~len:4;
            Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf
          in
          if not (String.equal magic "TZif")
          then raise (Invalid_file_format "magic characters TZif not present");
          let version =
            match In_channel.input_char ic with
            | Some '\000' -> `V1
            | Some '2' -> `V2
            | Some '3' -> `V3
            | None -> raise (Invalid_file_format "expected version, found nothing")
            | Some bad_version ->
              raise (Invalid_file_format (sprintf "version (%c) is invalid" bad_version))
          in
          In_channel.really_input_exn ic ~buf:(Bytes.create 15) ~pos:0 ~len:15;
          version
        ;;

        let input_tz_file_v1 ic =
          let input_leap_second =
            input_leap_second_gen ~input_leap_second:input_long_as_int63
          in
          input_tz_file_gen ~input_transition:input_long_as_int63 ~input_leap_second ic
        ;;

        let input_tz_file_v2_or_v3 ~version ic =
          let (_ : string -> original_filename:string -> digest:Md5_lib.t -> t) =
            input_tz_file_v1 ic
          in
          assert (
            (fun (_x__047_ : [ `V1 | `V2 | `V3 ]) _x__048_ ->
               (match
                  (fun (a__049_ : [ `V1 | `V2 | `V3 ])
                    ((b__050_ : [ `V1 | `V2 | `V3 ]) [@merlin.hide]) ->
                     (if Stdlib.( == ) a__049_ b__050_
                      then 0
                      else (
                        match a__049_, b__050_ with
                        | `V1, `V1 -> 0
                        | `V2, `V2 -> 0
                        | `V3, `V3 -> 0
                        | x, y -> Stdlib.compare x y))
                     [@merlin.hide])
                    _x__047_
                    _x__048_
                with
                | 0 -> true
                | _ -> false)
               [@merlin.hide])
              (read_header ic)
              version);
          let input_leap_second =
            input_leap_second_gen ~input_leap_second:input_long_long_as_int63
          in
          input_tz_file_gen
            ~input_transition:input_long_long_as_int63
            ~input_leap_second
            ic
        ;;

        let input_tz_file ~zonename ~filename =
          try
            protectx (In_channel.create filename) ~finally:In_channel.close ~f:(fun ic ->
              let make_zone =
                match read_header ic with
                | `V1 -> input_tz_file_v1 ic
                | (`V2 | `V3) as version -> input_tz_file_v2_or_v3 ~version ic
              in
              let digest = Md5.digest_file_blocking filename in
              let r = make_zone zonename ~original_filename:filename ~digest in
              r)
          with
          | Invalid_file_format reason ->
            raise (Invalid_file_format (sprintf "%s - %s" filename reason))
        ;;
      end

      let of_utc_offset_explicit_name ~name ~hours:offset =
        assert (offset >= -24 && offset <= 24);
        let utc_offset_in_seconds = Int63.of_int (offset * 60 * 60) in
        { name
        ; original_filename = None
        ; digest = None
        ; transitions = [||]
        ; last_regime_index = Index.before_first_transition
        ; default_local_time_type =
            { Regime.utc_offset_in_seconds; is_dst = false; abbrv = name }
        ; leap_seconds = []
        }
      ;;

      let of_utc_offset ~hours:offset =
        let name =
          if offset = 0
          then "UTC"
          else sprintf "UTC%s%d" (if offset < 0 then "-" else "+") (abs offset)
        in
        of_utc_offset_explicit_name ~name ~hours:offset
      ;;
    end
  end
end

include Stable.Full_data.V1

let sexp_of_t t = Sexp.Atom t.name

let likely_machine_zones =
  ref [ "America/New_York"; "Europe/London"; "Asia/Hong_Kong"; "America/Chicago" ]
;;

let finalize_js_loaded ~zonename ~filename ~first_transition ~remaining_transitions =
  let transitions = Array.of_list (first_transition :: remaining_transitions) in
  { name = zonename
  ; original_filename = Some filename
  ; digest = None
  ; transitions
  ; last_regime_index = Index.before_first_transition
  ; default_local_time_type = first_transition.Transition.new_regime
  ; leap_seconds = []
  }
;;

let input_tz_file ~zonename ~filename =
  match Timezone_js_loader.load zonename with
  | Error (Disabled | Platform_not_supported) ->
    Zone_file.input_tz_file ~zonename ~filename
  | Error (Failed exn_from_js_loader) ->
    (try Zone_file.input_tz_file ~zonename ~filename with
     | exn_from_input_tz_file ->
       raise (Exn.Finally (exn_from_js_loader, exn_from_input_tz_file)))
  | Ok { first_transition; remaining_transitions } ->
    finalize_js_loaded ~zonename ~filename ~first_transition ~remaining_transitions
;;

let utc = of_utc_offset ~hours:0
let name zone = zone.name
let reset_transition_cache t = t.last_regime_index <- Index.before_first_transition

let get_regime_exn t index =
  if index < 0 then t.default_local_time_type else t.transitions.(index).new_regime
;;

module Mode = struct
  type t =
    | Absolute
    | Date_and_ofday
end

let effective_start_time ~mode (x : Transition.t) =
  let open Int63.O in
  match (mode : Mode.t) with
  | Absolute -> x.start_time_in_seconds_since_epoch
  | Date_and_ofday ->
    x.start_time_in_seconds_since_epoch + x.new_regime.utc_offset_in_seconds
;;

let index_lower_bound_contains_seconds_since_epoch t index ~mode seconds =
  index < 0 || Int63.( >= ) seconds (effective_start_time ~mode t.transitions.(index))
;;

let index_upper_bound_contains_seconds_since_epoch t index ~mode seconds =
  index + 1 >= Array.length t.transitions
  || Int63.( < ) seconds (effective_start_time ~mode t.transitions.(index + 1))
;;

let binary_search_index_of_seconds_since_epoch t ~mode seconds : Index.t =
  Option.value
    ~default:Index.before_first_transition
    (Array.binary_search_segmented
       t.transitions
       `Last_on_left
       ~segment_of:(fun transition ->
         if Int63.( <= ) (effective_start_time transition ~mode) seconds
         then `Left
         else `Right))
;;

let index_of_seconds_since_epoch t ~mode seconds =
  let index =
    let index = t.last_regime_index in
    if not (index_lower_bound_contains_seconds_since_epoch t index ~mode seconds)
    then (
      let index = index - 1 in
      if not (index_lower_bound_contains_seconds_since_epoch t index ~mode seconds)
      then binary_search_index_of_seconds_since_epoch t ~mode seconds
      else index)
    else if not (index_upper_bound_contains_seconds_since_epoch t index ~mode seconds)
    then (
      let index = index + 1 in
      if not (index_upper_bound_contains_seconds_since_epoch t index ~mode seconds)
      then binary_search_index_of_seconds_since_epoch t ~mode seconds
      else index)
    else index
  in
  t.last_regime_index <- index;
  index
;;

module Time_in_seconds : sig
  include Zone_intf.Time_in_seconds
end = struct
  module Span = struct
    type t = Int63.t

    let of_int63_seconds = Fn.id
    let to_int63_seconds_round_down_exn = Fn.id
  end

  module Absolute = struct
    type t = Int63.t

    let of_span_since_epoch = Fn.id
    let to_span_since_epoch = Fn.id
  end

  module Date_and_ofday = struct
    type t = Int63.t

    let of_synthetic_span_since_epoch = Fn.id
    let to_synthetic_span_since_epoch = Fn.id
  end

  include Absolute
end

let index t time =
  index_of_seconds_since_epoch
    t
    ~mode:Absolute
    (Time_in_seconds.Span.to_int63_seconds_round_down_exn
       (Time_in_seconds.to_span_since_epoch time))
;;

let index_of_date_and_ofday t time =
  index_of_seconds_since_epoch
    t
    ~mode:Date_and_ofday
    (Time_in_seconds.Span.to_int63_seconds_round_down_exn
       (Time_in_seconds.Date_and_ofday.to_synthetic_span_since_epoch time))
;;

let index_has_prev_clock_shift t index = index >= 0 && index < Array.length t.transitions
let index_has_next_clock_shift t index = index_has_prev_clock_shift t (index + 1)

let index_prev_clock_shift_time_exn t index =
  let transition = t.transitions.(index) in
  Time_in_seconds.of_span_since_epoch
    (Time_in_seconds.Span.of_int63_seconds transition.start_time_in_seconds_since_epoch)
;;

let index_next_clock_shift_time_exn t index = index_prev_clock_shift_time_exn t (index + 1)

let index_prev_clock_shift_amount_exn t index =
  let transition = t.transitions.(index) in
  let after = transition.new_regime in
  let before =
    if index = 0 then t.default_local_time_type else t.transitions.(index - 1).new_regime
  in
  Time_in_seconds.Span.of_int63_seconds
    (Int63.( - ) after.utc_offset_in_seconds before.utc_offset_in_seconds)
;;

let index_next_clock_shift_amount_exn t index =
  index_prev_clock_shift_amount_exn t (index + 1)
;;

let index_abbreviation_exn t index =
  let regime = get_regime_exn t index in
  regime.abbrv
;;

let index_offset_from_utc_exn t index =
  let regime = get_regime_exn t index in
  Time_in_seconds.Span.of_int63_seconds regime.utc_offset_in_seconds
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
