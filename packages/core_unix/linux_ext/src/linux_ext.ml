let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"linux_ext.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "linux_ext.ml.before-ppx"
;;

open! Core
module Unix = Core_unix
module Thread = Core_thread
module Time_ns = Time_ns_unix
module File_descr = Unix.File_descr
module Syscall_result = Unix.Syscall_result

module Sysinfo0 = struct
  type t =
    { uptime : Time_float.Span.t
    ; load1 : int
    ; load5 : int
    ; load15 : int
    ; total_ram : int
    ; free_ram : int
    ; shared_ram : int
    ; buffer_ram : int
    ; total_swap : int
    ; free_swap : int
    ; procs : int
    ; totalhigh : int
    ; freehigh : int
    ; mem_unit : int
    }
  [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:9:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , []
            , Bin_prot.Shape.record
                [ "uptime", Time_float.Span.bin_shape_t
                ; "load1", bin_shape_int
                ; "load5", bin_shape_int
                ; "load15", bin_shape_int
                ; "total_ram", bin_shape_int
                ; "free_ram", bin_shape_int
                ; "shared_ram", bin_shape_int
                ; "buffer_ram", bin_shape_int
                ; "total_swap", bin_shape_int
                ; "free_swap", bin_shape_int
                ; "procs", bin_shape_int
                ; "totalhigh", bin_shape_int
                ; "freehigh", bin_shape_int
                ; "mem_unit", bin_shape_int
                ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t

    let bin_size_t : t Bin_prot.Size.sizer = function
      | { uptime = v1
        ; load1 = v2
        ; load5 = v3
        ; load15 = v4
        ; total_ram = v5
        ; free_ram = v6
        ; shared_ram = v7
        ; buffer_ram = v8
        ; total_swap = v9
        ; free_swap = v10
        ; procs = v11
        ; totalhigh = v12
        ; freehigh = v13
        ; mem_unit = v14
        } ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (Time_float.Span.bin_size_t v1) in
        let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
        let size = Bin_prot.Common.( + ) size (bin_size_int v3) in
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
        Bin_prot.Common.( + ) size (bin_size_int v14)
    ;;

    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos -> function
      | { uptime = v1
        ; load1 = v2
        ; load5 = v3
        ; load15 = v4
        ; total_ram = v5
        ; free_ram = v6
        ; shared_ram = v7
        ; buffer_ram = v8
        ; total_swap = v9
        ; free_swap = v10
        ; procs = v11
        ; totalhigh = v12
        ; freehigh = v13
        ; mem_unit = v14
        } ->
        let pos = Time_float.Span.bin_write_t buf ~pos v1 in
        let pos = bin_write_int buf ~pos v2 in
        let pos = bin_write_int buf ~pos v3 in
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
        bin_write_int buf ~pos v14
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "linux_ext.ml.before-ppx.Sysinfo0.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      let v_uptime = Time_float.Span.bin_read_t buf ~pos_ref in
      let v_load1 = bin_read_int buf ~pos_ref in
      let v_load5 = bin_read_int buf ~pos_ref in
      let v_load15 = bin_read_int buf ~pos_ref in
      let v_total_ram = bin_read_int buf ~pos_ref in
      let v_free_ram = bin_read_int buf ~pos_ref in
      let v_shared_ram = bin_read_int buf ~pos_ref in
      let v_buffer_ram = bin_read_int buf ~pos_ref in
      let v_total_swap = bin_read_int buf ~pos_ref in
      let v_free_swap = bin_read_int buf ~pos_ref in
      let v_procs = bin_read_int buf ~pos_ref in
      let v_totalhigh = bin_read_int buf ~pos_ref in
      let v_freehigh = bin_read_int buf ~pos_ref in
      let v_mem_unit = bin_read_int buf ~pos_ref in
      { uptime = v_uptime
      ; load1 = v_load1
      ; load5 = v_load5
      ; load15 = v_load15
      ; total_ram = v_total_ram
      ; free_ram = v_free_ram
      ; shared_ram = v_shared_ram
      ; buffer_ram = v_buffer_ram
      ; total_swap = v_total_swap
      ; free_swap = v_free_swap
      ; procs = v_procs
      ; totalhigh = v_totalhigh
      ; freehigh = v_freehigh
      ; mem_unit = v_mem_unit
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
      (let error_source__002_ = "linux_ext.ml.before-ppx.Sysinfo0.t" in
       fun x__003_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__002_
           ~fields:
             (Field
                { name = "uptime"
                ; kind = Required
                ; conv = Time_float.Span.t_of_sexp
                ; rest =
                    Field
                      { name = "load1"
                      ; kind = Required
                      ; conv = int_of_sexp
                      ; rest =
                          Field
                            { name = "load5"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest =
                                Field
                                  { name = "load15"
                                  ; kind = Required
                                  ; conv = int_of_sexp
                                  ; rest =
                                      Field
                                        { name = "total_ram"
                                        ; kind = Required
                                        ; conv = int_of_sexp
                                        ; rest =
                                            Field
                                              { name = "free_ram"
                                              ; kind = Required
                                              ; conv = int_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "shared_ram"
                                                    ; kind = Required
                                                    ; conv = int_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "buffer_ram"
                                                          ; kind = Required
                                                          ; conv = int_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "total_swap"
                                                                ; kind = Required
                                                                ; conv = int_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name = "free_swap"
                                                                      ; kind = Required
                                                                      ; conv = int_of_sexp
                                                                      ; rest =
                                                                          Field
                                                                            { name =
                                                                                "procs"
                                                                            ; kind =
                                                                                Required
                                                                            ; conv =
                                                                                int_of_sexp
                                                                            ; rest =
                                                                                Field
                                                                                  { name =
                                                                                      "totalhigh"
                                                                                  ; kind =
                                                                                      Required
                                                                                  ; conv =
                                                                                      int_of_sexp
                                                                                  ; rest =
                                                                                      Field
                                                                                        { name =
                                                                                          "freehigh"
                                                                                        ; kind =
                                                                                          Required
                                                                                        ; conv =
                                                                                          int_of_sexp
                                                                                        ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "mem_unit"
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
                })
           ~index_of_field:(function
             | "uptime" -> 0
             | "load1" -> 1
             | "load5" -> 2
             | "load15" -> 3
             | "total_ram" -> 4
             | "free_ram" -> 5
             | "shared_ram" -> 6
             | "buffer_ram" -> 7
             | "total_swap" -> 8
             | "free_swap" -> 9
             | "procs" -> 10
             | "totalhigh" -> 11
             | "freehigh" -> 12
             | "mem_unit" -> 13
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( uptime
               , ( load1
                 , ( load5
                   , ( load15
                     , ( total_ram
                       , ( free_ram
                         , ( shared_ram
                           , ( buffer_ram
                             , ( total_swap
                               , ( free_swap
                                 , (procs, (totalhigh, (freehigh, (mem_unit, ())))) ) ) )
                           ) ) ) ) ) ) ) ->
             ({ uptime
              ; load1
              ; load5
              ; load15
              ; total_ram
              ; free_ram
              ; shared_ram
              ; buffer_ram
              ; total_swap
              ; free_swap
              ; procs
              ; totalhigh
              ; freehigh
              ; mem_unit
              }
              : t))
           x__003_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { uptime = uptime__005_
           ; load1 = load1__007_
           ; load5 = load5__009_
           ; load15 = load15__011_
           ; total_ram = total_ram__013_
           ; free_ram = free_ram__015_
           ; shared_ram = shared_ram__017_
           ; buffer_ram = buffer_ram__019_
           ; total_swap = total_swap__021_
           ; free_swap = free_swap__023_
           ; procs = procs__025_
           ; totalhigh = totalhigh__027_
           ; freehigh = freehigh__029_
           ; mem_unit = mem_unit__031_
           } ->
         let bnds__004_ = ([] : _ Stdlib.List.t) in
         let bnds__004_ =
           let arg__032_ = sexp_of_int mem_unit__031_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mem_unit"; arg__032_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__030_ = sexp_of_int freehigh__029_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "freehigh"; arg__030_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__028_ = sexp_of_int totalhigh__027_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "totalhigh"; arg__028_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__026_ = sexp_of_int procs__025_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "procs"; arg__026_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__024_ = sexp_of_int free_swap__023_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_swap"; arg__024_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__022_ = sexp_of_int total_swap__021_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "total_swap"; arg__022_ ]
            :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__020_ = sexp_of_int buffer_ram__019_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buffer_ram"; arg__020_ ]
            :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__018_ = sexp_of_int shared_ram__017_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shared_ram"; arg__018_ ]
            :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__016_ = sexp_of_int free_ram__015_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "free_ram"; arg__016_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__014_ = sexp_of_int total_ram__013_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "total_ram"; arg__014_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__012_ = sexp_of_int load15__011_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "load15"; arg__012_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__010_ = sexp_of_int load5__009_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "load5"; arg__010_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__008_ = sexp_of_int load1__007_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "load1"; arg__008_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__006_ = Time_float.Span.sexp_of_t uptime__005_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "uptime"; arg__006_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__004_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

type tcp_bool_option =
  | TCP_CORK
  | TCP_QUICKACK
[@@deriving sexp, bin_io]

include struct
  let _ = fun (_ : tcp_bool_option) -> ()

  let tcp_bool_option_of_sexp =
    (let error_source__035_ = "linux_ext.ml.before-ppx.tcp_bool_option" in
     function
     | Sexplib0.Sexp.Atom ("tCP_CORK" | "TCP_CORK") -> TCP_CORK
     | Sexplib0.Sexp.Atom ("tCP_QUICKACK" | "TCP_QUICKACK") -> TCP_QUICKACK
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_CORK" | "TCP_CORK") :: _) as
       sexp__036_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__035_ sexp__036_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_QUICKACK" | "TCP_QUICKACK") :: _) as
       sexp__036_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__035_ sexp__036_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__034_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__035_ sexp__034_
     | Sexplib0.Sexp.List [] as sexp__034_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__035_ sexp__034_
     | sexp__034_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__035_ sexp__034_
     : Sexplib0.Sexp.t -> tcp_bool_option)
  ;;

  let _ = tcp_bool_option_of_sexp

  let sexp_of_tcp_bool_option =
    (function
     | TCP_CORK -> Sexplib0.Sexp.Atom "TCP_CORK"
     | TCP_QUICKACK -> Sexplib0.Sexp.Atom "TCP_QUICKACK"
     : tcp_bool_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_tcp_bool_option

  let bin_shape_tcp_bool_option =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:30:0")
        [ ( Bin_prot.Shape.Tid.of_string "tcp_bool_option"
          , []
          , Bin_prot.Shape.variant [ "TCP_CORK", []; "TCP_QUICKACK", [] ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "tcp_bool_option")) []
  ;;

  let _ = bin_shape_tcp_bool_option

  let bin_size_tcp_bool_option : tcp_bool_option Bin_prot.Size.sizer = function
    | TCP_CORK | TCP_QUICKACK -> 1
  ;;

  let _ = bin_size_tcp_bool_option

  let bin_write_tcp_bool_option : tcp_bool_option Bin_prot.Write.writer =
    fun buf ~pos -> function
    | TCP_CORK -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
    | TCP_QUICKACK -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
  ;;

  let _ = bin_write_tcp_bool_option

  let bin_writer_tcp_bool_option =
    ({ size = bin_size_tcp_bool_option; write = bin_write_tcp_bool_option }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_tcp_bool_option

  let __bin_read_tcp_bool_option__ : (int -> tcp_bool_option) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type
      "linux_ext.ml.before-ppx.tcp_bool_option"
      !pos_ref
  ;;

  let _ = __bin_read_tcp_bool_option__

  let bin_read_tcp_bool_option : tcp_bool_option Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 -> TCP_CORK
    | 1 -> TCP_QUICKACK
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "linux_ext.ml.before-ppx.tcp_bool_option")
        !pos_ref
  ;;

  let _ = bin_read_tcp_bool_option

  let bin_reader_tcp_bool_option =
    ({ read = bin_read_tcp_bool_option; vtag_read = __bin_read_tcp_bool_option__ }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_tcp_bool_option

  let bin_tcp_bool_option =
    ({ writer = bin_writer_tcp_bool_option
     ; reader = bin_reader_tcp_bool_option
     ; shape = bin_shape_tcp_bool_option
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_tcp_bool_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type tcp_string_option = TCP_CONGESTION [@@deriving sexp, bin_io]

include struct
  let _ = fun (_ : tcp_string_option) -> ()

  let tcp_string_option_of_sexp =
    (let error_source__039_ = "linux_ext.ml.before-ppx.tcp_string_option" in
     function
     | Sexplib0.Sexp.Atom ("tCP_CONGESTION" | "TCP_CONGESTION") -> TCP_CONGESTION
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_CONGESTION" | "TCP_CONGESTION") :: _)
       as sexp__040_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__039_ sexp__040_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__038_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__039_ sexp__038_
     | Sexplib0.Sexp.List [] as sexp__038_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__039_ sexp__038_
     | sexp__038_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__039_ sexp__038_
     : Sexplib0.Sexp.t -> tcp_string_option)
  ;;

  let _ = tcp_string_option_of_sexp

  let sexp_of_tcp_string_option =
    (fun TCP_CONGESTION -> Sexplib0.Sexp.Atom "TCP_CONGESTION"
     : tcp_string_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_tcp_string_option

  let bin_shape_tcp_string_option =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:35:0")
        [ ( Bin_prot.Shape.Tid.of_string "tcp_string_option"
          , []
          , Bin_prot.Shape.variant [ "TCP_CONGESTION", [] ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "tcp_string_option")) []
  ;;

  let _ = bin_shape_tcp_string_option

  let bin_size_tcp_string_option : tcp_string_option Bin_prot.Size.sizer = function
    | TCP_CONGESTION -> 1
  ;;

  let _ = bin_size_tcp_string_option

  let bin_write_tcp_string_option : tcp_string_option Bin_prot.Write.writer =
    fun buf ~pos -> function
    | TCP_CONGESTION -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
  ;;

  let _ = bin_write_tcp_string_option

  let bin_writer_tcp_string_option =
    ({ size = bin_size_tcp_string_option; write = bin_write_tcp_string_option }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_tcp_string_option

  let __bin_read_tcp_string_option__ : (int -> tcp_string_option) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type
      "linux_ext.ml.before-ppx.tcp_string_option"
      !pos_ref
  ;;

  let _ = __bin_read_tcp_string_option__

  let bin_read_tcp_string_option : tcp_string_option Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 -> TCP_CONGESTION
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "linux_ext.ml.before-ppx.tcp_string_option")
        !pos_ref
  ;;

  let _ = bin_read_tcp_string_option

  let bin_reader_tcp_string_option =
    ({ read = bin_read_tcp_string_option; vtag_read = __bin_read_tcp_string_option__ }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_tcp_string_option

  let bin_tcp_string_option =
    ({ writer = bin_writer_tcp_string_option
     ; reader = bin_reader_tcp_string_option
     ; shape = bin_shape_tcp_string_option
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_tcp_string_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Bound_to_interface = struct
  type t =
    | Any
    | Only of string
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | Any -> Sexplib0.Sexp.Atom "Any"
       | Only arg0__041_ ->
         let res0__042_ = sexp_of_string arg0__041_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Only"; res0__042_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Priority : sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val equal : t -> t -> bool
  val of_int : int -> t
  val to_int : t -> int
  val incr : t -> t
  val decr : t -> t
end = struct
  type t = int [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_int t = t
  let to_int t = t
  let incr t = t - 1
  let decr t = t + 1
  let equal (t : t) t' = t = t'
end

module Peer_credentials = struct
  type t =
    { pid : Pid.t
    ; uid : int
    ; gid : int
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { pid = pid__045_; uid = uid__047_; gid = gid__049_ } ->
         let bnds__044_ = ([] : _ Stdlib.List.t) in
         let bnds__044_ =
           let arg__050_ = sexp_of_int gid__049_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "gid"; arg__050_ ] :: bnds__044_
            : _ Stdlib.List.t)
         in
         let bnds__044_ =
           let arg__048_ = sexp_of_int uid__047_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "uid"; arg__048_ ] :: bnds__044_
            : _ Stdlib.List.t)
         in
         let bnds__044_ =
           let arg__046_ = Pid.sexp_of_t pid__045_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pid"; arg__046_ ] :: bnds__044_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__044_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let cpu_list_of_string_exn str =
  let parse_int_pair ~sep str =
    try Tuple2.map ~f:int_of_string (String.lsplit2_exn str ~on:sep) with
    | _ ->
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "cpu_list_of_string_exn: expected separated integer pair"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sep"; (sexp_of_char [@merlin.hide]) sep ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "str"
                 ; (sexp_of_string [@merlin.hide]) str
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  in
  let parse_range_pair str =
    let first, last = parse_int_pair ~sep:'-' str in
    if first > last
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "cpu_list_of_string_exn: range start is after end"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "first"
                 ; (sexp_of_int [@merlin.hide]) first
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "last"; (sexp_of_int [@merlin.hide]) last ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    else first, last
  in
  let parts =
    if
      let open String in
      str = ""
    then []
    else String.split ~on:',' str
  in
  List.dedup_and_sort
    ~compare:Int.compare
    (List.fold parts ~init:[] ~f:(fun acc part ->
       match String.lsplit2 part ~on:':', String.lsplit2 part ~on:'-' with
       | None, None ->
         let cpu =
           try int_of_string part with
           | _ ->
             raise_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                        "cpu_list_of_string_exn: expected integer"
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "part"
                        ; (sexp_of_string [@merlin.hide]) part
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]))
         in
         acc @ [ cpu ]
       | None, Some _range ->
         let first, last = parse_range_pair part in
         let rlist = List.init (last - first + 1) ~f:(Int.( + ) first) in
         acc @ rlist
       | Some (range, amt_stride), _ ->
         let first, last = parse_range_pair range in
         let amt, stride = parse_int_pair ~sep:'/' amt_stride in
         if amt <= 0 || stride <= 0
         then
           raise_s
             (let ppx_sexp_message () =
                Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                      "cpu_list_of_string_exn: invalid grouped range stride or amount"
                  ; Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Sexp.Atom "amt"
                      ; (sexp_of_int [@merlin.hide]) amt
                      ]
                  ; Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Sexp.Atom "stride"
                      ; (sexp_of_int [@merlin.hide]) stride
                      ]
                  ]
                  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
              in
              (ppx_sexp_message () [@nontail]))
         else if amt >= stride
         then (
           let rlist = List.init (last - first + 1) ~f:(Int.( + ) first) in
           acc @ rlist)
         else (
           let n_sublists =
             Float.to_int (Float.round_up ((last - first + 1) // stride))
           in
           let starts = List.init n_sublists ~f:(fun li -> first + (li * stride)) in
           let rlist =
             List.concat_map starts ~f:(fun start ->
               let group_end = Int.min (start + (amt - 1)) last in
               List.init (group_end - start + 1) ~f:(Int.( + ) start))
           in
           acc @ rlist)))
;;

let cpu_list_of_file_exn file =
  match List.hd (In_channel.with_file file ~f:In_channel.input_lines) with
  | None -> []
  | Some cpu_list -> cpu_list_of_string_exn cpu_list
;;

let isolated_cpus =
  Memo.unit (fun () -> cpu_list_of_file_exn "/sys/devices/system/cpu/isolated")
;;

let online_cpus =
  Memo.unit (fun () -> cpu_list_of_file_exn "/sys/devices/system/cpu/online")
;;

let cpus_local_to_nic ~ifname =
  cpu_list_of_file_exn (sprintf "/sys/class/net/%s/device/local_cpulist" ifname)
;;

module Null_toplevel = struct
  module Sysinfo = struct
    include Sysinfo0

    let sysinfo = Or_error.unimplemented "Linux_ext.Sysinfo.sysinfo"
  end

  let u = Or_error.unimplemented
  let cores = u "Linux_ext.cores"
  let cpu_list_of_string_exn = cpu_list_of_string_exn
  let isolated_cpus = u "Linux_ext.isolated_cores"
  let online_cpus = u "Linux_ext.online_cores"
  let cpus_local_to_nic = u "Linux_ext.cpus_local_to_nic"
  let file_descr_realpath = u "Linux_ext.file_descr_realpath"
  let get_ipv4_address_for_interface = u "Linux_ext.get_ipv4_address_for_interface"
  let get_mac_address = u "Linux_ext.get_mac_address"
  let bind_to_interface = u "Linux_ext.bind_to_interface"
  let get_bind_to_interface = u "Linux_ext.get_bind_to_interface"
  let get_terminal_size = u "Linux_ext.get_terminal_size"
  let gettcpopt_bool = u "Linux_ext.gettcpopt_bool"
  let gettcpopt_string = u "Linux_ext.gettcpopt_string"
  let setpriority = u "Linux_ext.setpriority"
  let getpriority = u "Linux_ext.getpriority"
  let in_channel_realpath = u "Linux_ext.in_channel_realpath"
  let out_channel_realpath = u "Linux_ext.out_channel_realpath"
  let pr_get_name = u "Linux_ext.pr_get_name"
  let pr_get_pdeathsig = u "Linux_ext.pr_get_pdeathsig"
  let pr_set_name_first16 = u "Linux_ext.pr_set_name_first16"
  let pr_set_pdeathsig = u "Linux_ext.pr_set_pdeathsig"
  let sched_setaffinity = u "Linux_ext.sched_setaffinity"
  let sched_getaffinity = u "Linux_ext.sched_getaffinity"
  let sched_setaffinity_this_thread = u "Linux_ext.sched_setaffinity_this_thread"
  let send_no_sigpipe = u "Linux_ext.send_no_sigpipe"
  let send_nonblocking_no_sigpipe = u "Linux_ext.send_nonblocking_no_sigpipe"
  let sendfile = u "Linux_ext.sendfile"
  let sendmsg_nonblocking_no_sigpipe = u "Linux_ext.sendmsg_nonblocking_no_sigpipe"
  let settcpopt_bool = u "Linux_ext.settcpopt_bool"
  let settcpopt_string = u "Linux_ext.settcpopt_string"
  let peer_credentials = u "Linux_ext.peer_credentials"

  module Epoll = Epoll.Impl
end

module Null : Linux_ext_intf.S = struct
  type nonrec tcp_bool_option = tcp_bool_option =
    | TCP_CORK
    | TCP_QUICKACK
  [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : tcp_bool_option) -> ()

    let tcp_bool_option_of_sexp =
      (let error_source__053_ = "linux_ext.ml.before-ppx.Null.tcp_bool_option" in
       function
       | Sexplib0.Sexp.Atom ("tCP_CORK" | "TCP_CORK") -> TCP_CORK
       | Sexplib0.Sexp.Atom ("tCP_QUICKACK" | "TCP_QUICKACK") -> TCP_QUICKACK
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_CORK" | "TCP_CORK") :: _) as
         sexp__054_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__053_ sexp__054_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_QUICKACK" | "TCP_QUICKACK") :: _) as
         sexp__054_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__053_ sexp__054_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__052_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__053_ sexp__052_
       | Sexplib0.Sexp.List [] as sexp__052_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__053_ sexp__052_
       | sexp__052_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__053_ sexp__052_
       : Sexplib0.Sexp.t -> tcp_bool_option)
    ;;

    let _ = tcp_bool_option_of_sexp

    let sexp_of_tcp_bool_option =
      (function
       | TCP_CORK -> Sexplib0.Sexp.Atom "TCP_CORK"
       | TCP_QUICKACK -> Sexplib0.Sexp.Atom "TCP_QUICKACK"
       : tcp_bool_option -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_tcp_bool_option

    let bin_shape_tcp_bool_option =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:219:2")
          [ ( Bin_prot.Shape.Tid.of_string "tcp_bool_option"
            , []
            , Bin_prot.Shape.variant [ "TCP_CORK", []; "TCP_QUICKACK", [] ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "tcp_bool_option")) []
    ;;

    let _ = bin_shape_tcp_bool_option

    let bin_size_tcp_bool_option : tcp_bool_option Bin_prot.Size.sizer = function
      | TCP_CORK | TCP_QUICKACK -> 1
    ;;

    let _ = bin_size_tcp_bool_option

    let bin_write_tcp_bool_option : tcp_bool_option Bin_prot.Write.writer =
      fun buf ~pos -> function
      | TCP_CORK -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | TCP_QUICKACK -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
    ;;

    let _ = bin_write_tcp_bool_option

    let bin_writer_tcp_bool_option =
      ({ size = bin_size_tcp_bool_option; write = bin_write_tcp_bool_option }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_tcp_bool_option

    let __bin_read_tcp_bool_option__ : (int -> tcp_bool_option) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "linux_ext.ml.before-ppx.Null.tcp_bool_option"
        !pos_ref
    ;;

    let _ = __bin_read_tcp_bool_option__

    let bin_read_tcp_bool_option : tcp_bool_option Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> TCP_CORK
      | 1 -> TCP_QUICKACK
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag
             "linux_ext.ml.before-ppx.Null.tcp_bool_option")
          !pos_ref
    ;;

    let _ = bin_read_tcp_bool_option

    let bin_reader_tcp_bool_option =
      ({ read = bin_read_tcp_bool_option; vtag_read = __bin_read_tcp_bool_option__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_tcp_bool_option

    let bin_tcp_bool_option =
      ({ writer = bin_writer_tcp_bool_option
       ; reader = bin_reader_tcp_bool_option
       ; shape = bin_shape_tcp_bool_option
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_tcp_bool_option
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type nonrec tcp_string_option = tcp_string_option = TCP_CONGESTION
  [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : tcp_string_option) -> ()

    let tcp_string_option_of_sexp =
      (let error_source__057_ = "linux_ext.ml.before-ppx.Null.tcp_string_option" in
       function
       | Sexplib0.Sexp.Atom ("tCP_CONGESTION" | "TCP_CONGESTION") -> TCP_CONGESTION
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_CONGESTION" | "TCP_CONGESTION") :: _)
         as sexp__058_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__057_ sexp__058_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__056_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__057_ sexp__056_
       | Sexplib0.Sexp.List [] as sexp__056_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__057_ sexp__056_
       | sexp__056_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__057_ sexp__056_
       : Sexplib0.Sexp.t -> tcp_string_option)
    ;;

    let _ = tcp_string_option_of_sexp

    let sexp_of_tcp_string_option =
      (fun TCP_CONGESTION -> Sexplib0.Sexp.Atom "TCP_CONGESTION"
       : tcp_string_option -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_tcp_string_option

    let bin_shape_tcp_string_option =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:224:2")
          [ ( Bin_prot.Shape.Tid.of_string "tcp_string_option"
            , []
            , Bin_prot.Shape.variant [ "TCP_CONGESTION", [] ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "tcp_string_option"))
        []
    ;;

    let _ = bin_shape_tcp_string_option

    let bin_size_tcp_string_option : tcp_string_option Bin_prot.Size.sizer = function
      | TCP_CONGESTION -> 1
    ;;

    let _ = bin_size_tcp_string_option

    let bin_write_tcp_string_option : tcp_string_option Bin_prot.Write.writer =
      fun buf ~pos -> function
      | TCP_CONGESTION -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
    ;;

    let _ = bin_write_tcp_string_option

    let bin_writer_tcp_string_option =
      ({ size = bin_size_tcp_string_option; write = bin_write_tcp_string_option }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_tcp_string_option

    let __bin_read_tcp_string_option__ : (int -> tcp_string_option) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "linux_ext.ml.before-ppx.Null.tcp_string_option"
        !pos_ref
    ;;

    let _ = __bin_read_tcp_string_option__

    let bin_read_tcp_string_option : tcp_string_option Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> TCP_CONGESTION
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag
             "linux_ext.ml.before-ppx.Null.tcp_string_option")
          !pos_ref
    ;;

    let _ = bin_read_tcp_string_option

    let bin_reader_tcp_string_option =
      ({ read = bin_read_tcp_string_option; vtag_read = __bin_read_tcp_string_option__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_tcp_string_option

    let bin_tcp_string_option =
      ({ writer = bin_writer_tcp_string_option
       ; reader = bin_reader_tcp_string_option
       ; shape = bin_shape_tcp_string_option
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_tcp_string_option
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Bound_to_interface = struct
    type t = Bound_to_interface.t =
      | Any
      | Only of string
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (function
         | Any -> Sexplib0.Sexp.Atom "Any"
         | Only arg0__059_ ->
           let res0__060_ = sexp_of_string arg0__059_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Only"; res0__060_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Peer_credentials = Peer_credentials
  module Priority = Priority

  module Clock = struct
    type t

    let get = Or_error.unimplemented "Linux_ext.Clock.get"
    let get_time = Or_error.unimplemented "Linux_ext.Clock.get_time"
    let set_time = Or_error.unimplemented "Linux_ext.Clock.set_time"
    let get_resolution = Or_error.unimplemented "Linux_ext.Clock.get_resolution"
    let get_process_clock = Or_error.unimplemented "Linux_ext.Clock.get_process_clock"
    let get_thread_clock = Or_error.unimplemented "Linux_ext.Clock.get_thread_clock"
  end

  module Eventfd = struct
    type t = File_descr.t [@@deriving compare, sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__061_ b__062_ -> File_descr.compare a__061_ b__062_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let sexp_of_t = (File_descr.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Flags = struct
      let nonblock = Int63.of_int 0o4000
      let cloexec = Int63.of_int 0o2000000
      let semaphore = Int63.of_int 0o1

      include Flags.Make (struct
          let allow_intersecting = true
          let should_print_error = true
          let remove_zero_flags = false
          let known = [ nonblock, "nonblock"; cloexec, "cloexec"; semaphore, "semaphore" ]
        end)
    end

    let create = Or_error.unimplemented "Linux_ext.Eventfd.create"
    let read _ = assert false
    let write _ = assert false
    let to_file_descr t = t
  end

  module Timerfd = struct
    module Clock = struct
      type t = unit [@@deriving bin_io, compare, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "linux_ext.ml.before-ppx:274:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_unit ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_unit
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_unit
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_unit__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_unit
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
          (fun a__063_ b__064_ -> compare_unit a__063_ b__064_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let t_of_sexp = (unit_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let realtime = ()
      let monotonic = ()
    end

    module Flags = struct
      let nonblock = Int63.of_int 0o4000
      let cloexec = Int63.of_int 0o2000000

      include Flags.Make (struct
          let allow_intersecting = false
          let should_print_error = true
          let remove_zero_flags = false
          let known = List.rev [ nonblock, "nonblock"; cloexec, "cloexec" ]
        end)
    end

    type t = File_descr.t [@@deriving compare, sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__066_ b__067_ -> File_descr.compare a__066_ b__067_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let sexp_of_t = (File_descr.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_file_descr t = t

    type repeat =
      { fire_after : Time_ns.Span.t
      ; interval : Time_ns.Span.t
      }

    let create = Or_error.unimplemented "Linux_ext.Timerfd.create"
    let set_at _ _ = assert false
    let set_after _ _ = assert false
    let set_repeating ?after:_ _ _ = assert false
    let set_repeating_at _ _ _ = assert false
    let clear _ = assert false
    let get _ = assert false

    module Private = struct
      let unsafe_timerfd_settime _ = assert false
    end
  end

  module Memfd = struct
    module Flags = struct
      let i63 = Int63.of_int
      let cloexec = i63 0x0001
      let allow_sealing = i63 0x0002
      let hugetlb = i63 0x0004
      let noexec_seal = i63 0x0008
      let exec = i63 0x0010
      let hugetlb_flag_encode_shift = 26
      let huge_2mb = i63 (21 lsl hugetlb_flag_encode_shift)
      let huge_1gb = i63 (30 lsl hugetlb_flag_encode_shift)

      include Flags.Make (struct
          let allow_intersecting = true
          let should_print_error = true
          let remove_zero_flags = false

          let known =
            [ cloexec, "cloexec"
            ; allow_sealing, "allow_sealing"
            ; hugetlb, "hugetlb"
            ; noexec_seal, "noexec_seal"
            ; exec, "exec"
            ; huge_2mb, "huge_2mb"
            ; huge_1gb, "huge_1gb"
            ]
          ;;
        end)
    end

    type t = File_descr.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()
      let sexp_of_t = (File_descr.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_file_descr = Fn.id
    let create = Or_error.unimplemented "Linux_ext.Memfd.create"
  end

  module Extended_file_attributes = struct
    module Get_attr_result = struct
      type t =
        | Ok of string
        | ENOATTR
        | ERANGE
        | ENOTSUP
      [@@deriving sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let sexp_of_t =
          (function
           | Ok arg0__068_ ->
             let res0__069_ = sexp_of_string arg0__068_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ok"; res0__069_ ]
           | ENOATTR -> Sexplib0.Sexp.Atom "ENOATTR"
           | ERANGE -> Sexplib0.Sexp.Atom "ERANGE"
           | ENOTSUP -> Sexplib0.Sexp.Atom "ENOTSUP"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    let getxattr = Or_error.unimplemented "Linux_ext.Extended_file_attributes.getxattr"

    module Set_attr_result = struct
      type t =
        | Ok
        | EEXIST
        | ENOATTR
        | ENOTSUP
      [@@deriving sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let sexp_of_t =
          (function
           | Ok -> Sexplib0.Sexp.Atom "Ok"
           | EEXIST -> Sexplib0.Sexp.Atom "EEXIST"
           | ENOATTR -> Sexplib0.Sexp.Atom "ENOATTR"
           | ENOTSUP -> Sexplib0.Sexp.Atom "ENOTSUP"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    let setxattr = Or_error.unimplemented "Linux_ext.Extended_file_attributes.setxattr"
  end

  include Null_toplevel
end

module _ = Null
module Clock = Null.Clock
module Timerfd = Null.Timerfd
module Memfd = Null.Memfd
include Null_toplevel
module Eventfd = Null.Eventfd
module Extended_file_attributes = Null.Extended_file_attributes

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
