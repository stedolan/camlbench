let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "command_shape.ml.before-ppx"
;;

include Command.Shape

module Stable = struct
  open! Stable_internal
  open! Ppx_compare_lib.Builtin

  module Anons = struct
    module Grammar = struct
      module V1 = struct
        include Command.Shape.Stable.Anons.Grammar.V1

        type t = Command.Shape.Stable.Anons.Grammar.V1.t =
          | Zero
          | One of string
          | Many of t
          | Maybe of t
          | Concat of t list
          | Ad_hoc of string
        [@@deriving bin_io]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:12:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.variant
                      [ "Zero", []
                      ; "One", [ bin_shape_string ]
                      ; ( "Many"
                        , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                          ] )
                      ; ( "Maybe"
                        , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                          ] )
                      ; ( "Concat"
                        , [ bin_shape_list
                              ((Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                                 [])
                          ] )
                      ; "Ad_hoc", [ bin_shape_string ]
                      ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let rec bin_size_t : t Bin_prot.Size.sizer = function
            | One v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_string v1)
            | Many v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_t v1)
            | Maybe v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_t v1)
            | Concat v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_list bin_size_t v1)
            | Ad_hoc v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_string v1)
            | Zero -> 1
          ;;

          let _ = bin_size_t

          let rec bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | Zero -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
            | One v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
              bin_write_string buf ~pos v1
            | Many v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
              bin_write_t buf ~pos v1
            | Maybe v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
              bin_write_t buf ~pos v1
            | Concat v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
              bin_write_list bin_write_t buf ~pos v1
            | Ad_hoc v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 5 in
              bin_write_string buf ~pos v1
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "command_shape.ml.before-ppx.Stable.Anons.Grammar.V1.t"
              !pos_ref

          and bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
            | 0 -> Zero
            | 1 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              One arg_1
            | 2 ->
              let arg_1 = bin_read_t buf ~pos_ref in
              Many arg_1
            | 3 ->
              let arg_1 = bin_read_t buf ~pos_ref in
              Maybe arg_1
            | 4 ->
              let arg_1 = (bin_read_list bin_read_t) buf ~pos_ref in
              Concat arg_1
            | 5 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              Ad_hoc arg_1
            | _ ->
              Bin_prot.Common.raise_read_error
                (Bin_prot.Common.ReadError.Sum_tag
                   "command_shape.ml.before-ppx.Stable.Anons.Grammar.V1.t")
                !pos_ref
          ;;

          let _ = __bin_read_t__
          and _ = bin_read_t

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
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let () =
          match Ppx_inline_test_lib.testing with
          | `Not_testing -> ()
          | `Testing _ ->
            let module Ppx_expect_test_block =
              Ppx_expect_runtime.Make_test_block (Expect_test_config)
            in
            Ppx_expect_test_block.run_suite
              ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
              ~line_number:21
              ~location:{ start_bol = 469; start_pos = 477; end_pos = 597 }
              ~trailing_loc:{ start_bol = 539; start_pos = 597; end_pos = 597 }
              ~body_loc:{ start_bol = 469; start_pos = 477; end_pos = 597 }
              ~formatting_flexibility:
                (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                   Ppx_expect_runtime.Expect_node_formatting.default)
              ~expected_exn:None
              ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
              ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
              ~description:None
              ~tags:[]
              ~inline_test_config:(module Inline_test_config)
              ~expectations:
                ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 0
                   , Ppx_expect_runtime.Test_node.Create.expect
                       ~formatting_flexibility:
                         (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                          .Flexible_modulo
                            Ppx_expect_runtime.Expect_node_formatting.default)
                       ~located_payload:
                         (Some
                            ( { contents = " a17fd34ec213e508db450f6469f7fe99 "
                              ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                              }
                            , { start_bol = 539; start_pos = 558; end_pos = 596 } ))
                       ~node_loc:{ start_bol = 539; start_pos = 549; end_pos = 597 } )
                 ]
                [@merlin.hide])
              (fun () ->
                 print_endline
                   (Bin_prot.Shape.Digest.to_hex
                      (Bin_prot.Shape.eval_to_digest bin_shape_t));
                 Ppx_expect_test_block.run_test
                   ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0)
                 [@merlin.hide])
        ;;
      end
    end

    module V2 = struct
      include Command.Shape.Stable.Anons.V2

      type t = Command.Shape.Stable.Anons.V2.t =
        | Usage of string
        | Grammar of Grammar.V1.t
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:31:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.variant
                    [ "Usage", [ bin_shape_string ]
                    ; "Grammar", [ Grammar.V1.bin_shape_t ]
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | Usage v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (bin_size_string v1)
          | Grammar v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (Grammar.V1.bin_size_t v1)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | Usage v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            bin_write_string buf ~pos v1
          | Grammar v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            Grammar.V1.bin_write_t buf ~pos v1
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "command_shape.ml.before-ppx.Stable.Anons.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = bin_read_string buf ~pos_ref in
            Usage arg_1
          | 1 ->
            let arg_1 = Grammar.V1.bin_read_t buf ~pos_ref in
            Grammar arg_1
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "command_shape.ml.before-ppx.Stable.Anons.V2.t")
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:36
            ~location:{ start_bol = 832; start_pos = 838; end_pos = 954 }
            ~trailing_loc:{ start_bol = 898; start_pos = 954; end_pos = 954 }
            ~body_loc:{ start_bol = 832; start_pos = 838; end_pos = 954 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 4)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 5)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 3
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " 081d9ec167903f8f8c49cbf8e3fb3a66 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 898; start_pos = 915; end_pos = 953 } ))
                     ~node_loc:{ start_bol = 898; start_pos = 906; end_pos = 954 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide])
      ;;
    end
  end

  module Flag_info = struct
    module V1 = struct
      include Command.Shape.Stable.Flag_info.V1

      type t = Command.Shape.Stable.Flag_info.V1.t =
        { name : string
        ; doc : string
        ; aliases : string list
        }
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:47:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "name", bin_shape_string
                    ; "doc", bin_shape_string
                    ; "aliases", bin_shape_list bin_shape_string
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { name = v1; doc = v2; aliases = v3 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v2) in
            Bin_prot.Common.( + ) size (bin_size_list bin_size_string v3)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { name = v1; doc = v2; aliases = v3 } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_string buf ~pos v2 in
            bin_write_list bin_write_string buf ~pos v3
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "command_shape.ml.before-ppx.Stable.Flag_info.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_name = bin_read_string buf ~pos_ref in
          let v_doc = bin_read_string buf ~pos_ref in
          let v_aliases = (bin_read_list bin_read_string) buf ~pos_ref in
          { name = v_name; doc = v_doc; aliases = v_aliases }
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:54
            ~location:{ start_bol = 1248; start_pos = 1254; end_pos = 1370 }
            ~trailing_loc:{ start_bol = 1314; start_pos = 1370; end_pos = 1370 }
            ~body_loc:{ start_bol = 1248; start_pos = 1254; end_pos = 1370 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 7)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 8)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 6
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " bd8d6fb7a662d2c0b5e0d2026c6d2d21 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 1314; start_pos = 1331; end_pos = 1369 } ))
                     ~node_loc:{ start_bol = 1314; start_pos = 1322; end_pos = 1370 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 6) [@merlin.hide])
      ;;
    end
  end

  module Base_info = struct
    module V2 = struct
      include Command.Shape.Stable.Base_info.V2

      type t = Command.Shape.Stable.Base_info.V2.t =
        { summary : string
        ; readme : string option
        ; anons : Anons.V2.t
        ; flags : Flag_info.V1.t list
        }
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:65:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "summary", bin_shape_string
                    ; "readme", bin_shape_option bin_shape_string
                    ; "anons", Anons.V2.bin_shape_t
                    ; "flags", bin_shape_list Flag_info.V1.bin_shape_t
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { summary = v1; readme = v2; anons = v3; flags = v4 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_option bin_size_string v2) in
            let size = Bin_prot.Common.( + ) size (Anons.V2.bin_size_t v3) in
            Bin_prot.Common.( + ) size (bin_size_list Flag_info.V1.bin_size_t v4)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { summary = v1; readme = v2; anons = v3; flags = v4 } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_option bin_write_string buf ~pos v2 in
            let pos = Anons.V2.bin_write_t buf ~pos v3 in
            bin_write_list Flag_info.V1.bin_write_t buf ~pos v4
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "command_shape.ml.before-ppx.Stable.Base_info.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_summary = bin_read_string buf ~pos_ref in
          let v_readme = (bin_read_option bin_read_string) buf ~pos_ref in
          let v_anons = Anons.V2.bin_read_t buf ~pos_ref in
          let v_flags = (bin_read_list Flag_info.V1.bin_read_t) buf ~pos_ref in
          { summary = v_summary; readme = v_readme; anons = v_anons; flags = v_flags }
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:73
            ~location:{ start_bol = 1712; start_pos = 1718; end_pos = 1834 }
            ~trailing_loc:{ start_bol = 1778; start_pos = 1834; end_pos = 1834 }
            ~body_loc:{ start_bol = 1712; start_pos = 1718; end_pos = 1834 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 10)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 11)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 9
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " 8faac1e8d9deb0baaa56ac8ebf85b498 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 1778; start_pos = 1795; end_pos = 1833 } ))
                     ~node_loc:{ start_bol = 1778; start_pos = 1786; end_pos = 1834 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 9) [@merlin.hide])
      ;;
    end
  end

  module Group_info = struct
    type a = Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types
    [@@deriving bin_io]

    include struct
      let _ = fun (_ : a) -> ()

      let bin_shape_a =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:81:4")
            [ ( Bin_prot.Shape.Tid.of_string "a"
              , []
              , Bin_prot.Shape.variant
                  [ ( "Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types"
                    , [] )
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "a")) []
      ;;

      let _ = bin_shape_a

      let bin_size_a : a Bin_prot.Size.sizer = function
        | Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types -> 1
      ;;

      let _ = bin_size_a

      let bin_write_a : a Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types ->
          Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      ;;

      let _ = bin_write_a

      let bin_writer_a =
        ({ size = bin_size_a; write = bin_write_a } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_a

      let __bin_read_a__ : (int -> a) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "command_shape.ml.before-ppx.Stable.Group_info.a"
          !pos_ref
      ;;

      let _ = __bin_read_a__

      let bin_read_a : a Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 -> Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag
               "command_shape.ml.before-ppx.Stable.Group_info.a")
            !pos_ref
      ;;

      let _ = bin_read_a

      let bin_reader_a =
        ({ read = bin_read_a; vtag_read = __bin_read_a__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_a

      let bin_a =
        ({ writer = bin_writer_a; reader = bin_reader_a; shape = bin_shape_a }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_a
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module V2 = struct
      include Command.Shape.Stable.Group_info.V2

      type 'a t = 'a Command.Shape.Stable.Group_info.V2.t =
        { summary : string
        ; readme : string option
        ; subcommands : (string * 'a) List.Stable.V1.t Lazy.Stable.V1.t
        }
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:87:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.record
                    [ "summary", bin_shape_string
                    ; "readme", bin_shape_option bin_shape_string
                    ; ( "subcommands"
                      , Lazy.Stable.V1.bin_shape_t
                          (List.Stable.V1.bin_shape_t
                             (Bin_prot.Shape.tuple
                                [ bin_shape_string
                                ; Bin_prot.Shape.var
                                    (Bin_prot.Shape.Location.of_string
                                       "command_shape.ml.before-ppx:90:34")
                                    (Bin_prot.Shape.Vid.of_string "a")
                                ])) )
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | { summary = v1; readme = v2; subcommands = v3 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_option bin_size_string v2) in
            Bin_prot.Common.( + )
              size
              (Lazy.Stable.V1.bin_size_t
                 (List.Stable.V1.bin_size_t (function v1, v2 ->
                      let size = 0 in
                      let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
                      Bin_prot.Common.( + ) size (_size_of_a v2)))
                 v3)
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | { summary = v1; readme = v2; subcommands = v3 } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_option bin_write_string buf ~pos v2 in
            Lazy.Stable.V1.bin_write_t
              (List.Stable.V1.bin_write_t (fun buf ~pos -> function
                 | v1, v2 ->
                   let pos = bin_write_string buf ~pos v1 in
                   _write_a buf ~pos v2))
              buf
              ~pos
              v3
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
            "command_shape.ml.before-ppx.Stable.Group_info.V2.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          let v_summary = bin_read_string buf ~pos_ref in
          let v_readme = (bin_read_option bin_read_string) buf ~pos_ref in
          let v_subcommands =
            (Lazy.Stable.V1.bin_read_t
               (List.Stable.V1.bin_read_t (fun buf ~pos_ref ->
                  let v1 = bin_read_string buf ~pos_ref in
                  let v2 = _of__a buf ~pos_ref in
                  v1, v2)))
              buf
              ~pos_ref
          in
          { summary = v_summary; readme = v_readme; subcommands = v_subcommands }
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

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:94
            ~location:{ start_bol = 2302; start_pos = 2308; end_pos = 2426 }
            ~trailing_loc:{ start_bol = 2370; start_pos = 2426; end_pos = 2426 }
            ~body_loc:{ start_bol = 2302; start_pos = 2308; end_pos = 2426 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 13)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 14)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 12
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " 2cc3eeb58d12d8fe4400009e592d7827 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 2370; start_pos = 2387; end_pos = 2425 } ))
                     ~node_loc:{ start_bol = 2370; start_pos = 2378; end_pos = 2426 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest (bin_shape_t bin_shape_a)));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 12) [@merlin.hide])
      ;;
    end
  end

  module Exec_info = struct
    module V3 = struct
      include Command.Shape.Stable.Exec_info.V3

      type t = Command.Shape.Stable.Exec_info.V3.t =
        { summary : string
        ; readme : string option
        ; working_dir : string
        ; path_to_exe : string
        ; child_subcommand : string list
        }
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:105:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "summary", bin_shape_string
                    ; "readme", bin_shape_option bin_shape_string
                    ; "working_dir", bin_shape_string
                    ; "path_to_exe", bin_shape_string
                    ; "child_subcommand", bin_shape_list bin_shape_string
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { summary = v1
            ; readme = v2
            ; working_dir = v3
            ; path_to_exe = v4
            ; child_subcommand = v5
            } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_option bin_size_string v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v4) in
            Bin_prot.Common.( + ) size (bin_size_list bin_size_string v5)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { summary = v1
            ; readme = v2
            ; working_dir = v3
            ; path_to_exe = v4
            ; child_subcommand = v5
            } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_option bin_write_string buf ~pos v2 in
            let pos = bin_write_string buf ~pos v3 in
            let pos = bin_write_string buf ~pos v4 in
            bin_write_list bin_write_string buf ~pos v5
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "command_shape.ml.before-ppx.Stable.Exec_info.V3.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_summary = bin_read_string buf ~pos_ref in
          let v_readme = (bin_read_option bin_read_string) buf ~pos_ref in
          let v_working_dir = bin_read_string buf ~pos_ref in
          let v_path_to_exe = bin_read_string buf ~pos_ref in
          let v_child_subcommand = (bin_read_list bin_read_string) buf ~pos_ref in
          { summary = v_summary
          ; readme = v_readme
          ; working_dir = v_working_dir
          ; path_to_exe = v_path_to_exe
          ; child_subcommand = v_child_subcommand
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:114
            ~location:{ start_bol = 2804; start_pos = 2810; end_pos = 2926 }
            ~trailing_loc:{ start_bol = 2870; start_pos = 2926; end_pos = 2926 }
            ~body_loc:{ start_bol = 2804; start_pos = 2810; end_pos = 2926 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 16)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 17)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 15
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " c0c8256e9238cdd8f2ec1f8785e02ae0 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 2870; start_pos = 2887; end_pos = 2925 } ))
                     ~node_loc:{ start_bol = 2870; start_pos = 2878; end_pos = 2926 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 15) [@merlin.hide])
      ;;
    end
  end

  module Fully_forced = struct
    module V1 = struct
      include Command.Shape.Stable.Fully_forced.V1

      type t = Command.Shape.Stable.Fully_forced.V1.t =
        | Basic of Base_info.V2.t
        | Group of t Group_info.V2.t
        | Exec of Exec_info.V3.t * t
      [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "command_shape.ml.before-ppx:125:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.variant
                    [ "Basic", [ Base_info.V2.bin_shape_t ]
                    ; ( "Group"
                      , [ Group_info.V2.bin_shape_t
                            ((Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                               [])
                        ] )
                    ; ( "Exec"
                      , [ Exec_info.V3.bin_shape_t
                        ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                        ] )
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let rec bin_size_t : t Bin_prot.Size.sizer = function
          | Basic v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (Base_info.V2.bin_size_t v1)
          | Group v1 ->
            let size = 1 in
            Bin_prot.Common.( + ) size (Group_info.V2.bin_size_t bin_size_t v1)
          | Exec (v1, v2) ->
            let size = 1 in
            let size = Bin_prot.Common.( + ) size (Exec_info.V3.bin_size_t v1) in
            Bin_prot.Common.( + ) size (bin_size_t v2)
        ;;

        let _ = bin_size_t

        let rec bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | Basic v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
            Base_info.V2.bin_write_t buf ~pos v1
          | Group v1 ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
            Group_info.V2.bin_write_t bin_write_t buf ~pos v1
          | Exec (v1, v2) ->
            let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
            let pos = Exec_info.V3.bin_write_t buf ~pos v1 in
            bin_write_t buf ~pos v2
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "command_shape.ml.before-ppx.Stable.Fully_forced.V1.t"
            !pos_ref

        and bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 ->
            let arg_1 = Base_info.V2.bin_read_t buf ~pos_ref in
            Basic arg_1
          | 1 ->
            let arg_1 = (Group_info.V2.bin_read_t bin_read_t) buf ~pos_ref in
            Group arg_1
          | 2 ->
            let arg_1 = Exec_info.V3.bin_read_t buf ~pos_ref in
            let arg_2 = bin_read_t buf ~pos_ref in
            Exec (arg_1, arg_2)
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag
                 "command_shape.ml.before-ppx.Stable.Fully_forced.V1.t")
              !pos_ref
        ;;

        let _ = __bin_read_t__
        and _ = bin_read_t

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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"command_shape.ml.before-ppx"
            ~line_number:131
            ~location:{ start_bol = 3248; start_pos = 3254; end_pos = 3370 }
            ~trailing_loc:{ start_bol = 3314; start_pos = 3370; end_pos = 3370 }
            ~body_loc:{ start_bol = 3248; start_pos = 3254; end_pos = 3370 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 19)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 20)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 18
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " 981154ef3919437c6c822619882841d4 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 3314; start_pos = 3331; end_pos = 3369 } ))
                     ~node_loc:{ start_bol = 3314; start_pos = 3322; end_pos = 3370 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 18) [@merlin.hide])
      ;;
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
