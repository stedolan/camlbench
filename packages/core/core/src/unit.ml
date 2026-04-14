let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"unit.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "unit.ml.before-ppx"
;;

module Stable = struct
  open Stable_witness.Export
  open Base.Export
  open Bin_prot.Std

  module V1 = struct
    module T = struct
      type t = unit [@@deriving bin_io ~localize, compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "unit.ml.before-ppx:8:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_unit ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_unit__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_unit__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
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
          (fun a__001_ b__002_ -> compare_unit a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let t_of_sexp = (unit_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : unit Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_unit
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T
    include Comparator.Stable.V1.Make (T)

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"unit.ml.before-ppx"
          ~line_number:14
          ~location:{ start_bol = 282; start_pos = 286; end_pos = 398 }
          ~trailing_loc:{ start_bol = 344; start_pos = 398; end_pos = 398 }
          ~body_loc:{ start_bol = 282; start_pos = 286; end_pos = 398 }
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
                        ( { contents = " 86ba5df747eec837f0b391dd49f33f9e "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 344; start_pos = 359; end_pos = 397 } ))
                   ~node_loc:{ start_bol = 344; start_pos = 350; end_pos = 398 } )
             ]
            [@merlin.hide])
          (fun () ->
             print_endline
               (Bin_prot.Shape.Digest.to_hex (Bin_prot.Shape.eval_to_digest bin_shape_t));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
    ;;
  end

  module V2 = struct
    type t = unit [@@deriving compare, equal, sexp, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__004_ b__005_ -> compare_unit a__004_ b__005_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__006_ b__007_ -> equal_unit a__006_ b__007_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let t_of_sexp = (unit_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : unit Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_unit in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type comparator_witness = V1.comparator_witness

    let comparator = V1.comparator
    let bin_name = "unit_v2"

    let __bin_read_t__ (_ : Bin_prot.Common.buf) ~pos_ref (_ : int) =
      Bin_prot.Common.raise_variant_wrong_type bin_name !pos_ref
    ;;

    let bin_read_t (_ : Bin_prot.Common.buf) ~pos_ref:(_ : int ref) = ()

    let bin_reader_t =
      { Bin_prot.Type_class.read = bin_read_t; vtag_read = __bin_read_t__ }
    ;;

    let bin_shape_t =
      (let open Bin_prot.Shape in
       basetype (Uuid.of_string bin_name))
        []
    ;;

    let bin_size_t () = 0
    let bin_size_t__local () = 0
    let bin_write_t (_ : Bin_prot.Common.buf) ~pos () = pos
    let bin_write_t__local (_ : Bin_prot.Common.buf) ~pos () = pos
    let bin_writer_t = { Bin_prot.Type_class.size = bin_size_t; write = bin_write_t }

    let bin_t =
      { Bin_prot.Type_class.shape = bin_shape_t
      ; writer = bin_writer_t
      ; reader = bin_reader_t
      }
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"unit.ml.before-ppx"
          ~line_number:51
          ~location:{ start_bol = 1434; start_pos = 1438; end_pos = 1550 }
          ~trailing_loc:{ start_bol = 1496; start_pos = 1550; end_pos = 1550 }
          ~body_loc:{ start_bol = 1434; start_pos = 1438; end_pos = 1550 }
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
                        ( { contents = " ffbd1a307a4f7ebe8023040fecebf697 "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 1496; start_pos = 1511; end_pos = 1549 } ))
                   ~node_loc:{ start_bol = 1496; start_pos = 1502; end_pos = 1550 } )
             ]
            [@merlin.hide])
          (fun () ->
             print_endline
               (Bin_prot.Shape.Digest.to_hex (Bin_prot.Shape.eval_to_digest bin_shape_t));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide])
    ;;
  end
end

open! Import

include
  Identifiable.Extend
    (Base.Unit)
    (struct
      type t = unit [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "unit.ml.before-ppx:64:6")
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

include Base.Unit

type t = unit [@@deriving typerep, bin_io ~localize]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "unit.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_unit))
  ;;

  let _ = typerep_of_t

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "unit.ml.before-ppx:69:0")
        [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_unit ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
  ;;

  let _ = bin_shape_t
  let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_unit__local
  let _ = bin_size_t__local
  let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
  let _ = bin_size_t
  let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_unit__local
  let _ = bin_write_t__local
  let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
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
    ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_t

  let bin_t =
    ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let quickcheck_generator = Base_quickcheck.Generator.unit
let quickcheck_observer = Base_quickcheck.Observer.unit
let quickcheck_shrinker = Base_quickcheck.Shrinker.unit

module type S = sig end

type m = (module S)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
