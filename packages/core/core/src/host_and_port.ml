let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"host_and_port.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "host_and_port.ml.before-ppx"
;;

module Stable = struct
  open Stable_internal

  module V1 = struct
    module Serializable = struct
      type t = string * int [@@deriving sexp, bin_io, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__007_ =
             "host_and_port.ml.before-ppx.Stable.V1.Serializable.t"
           in
           function
           | Sexplib0.Sexp.List [ arg0__002_; arg1__003_ ] ->
             let res0__004_ = string_of_sexp arg0__002_
             and res1__005_ = int_of_sexp arg1__003_ in
             res0__004_, res1__005_
           | sexp__006_ ->
             Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
               error_source__007_
               2
               sexp__006_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun (arg0__008_, arg1__009_) ->
             let res0__010_ = sexp_of_string arg0__008_
             and res1__011_ = sexp_of_int arg1__009_ in
             Sexplib0.Sexp.List [ res0__010_; res1__011_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "host_and_port.ml.before-ppx:6:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.tuple [ bin_shape_string; bin_shape_int ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            Bin_prot.Common.( + ) size (bin_size_int v2)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | v1, v2 ->
            let pos = bin_write_string buf ~pos v1 in
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
            "host_and_port.ml.before-ppx.Stable.V1.Serializable.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v1 = bin_read_string buf ~pos_ref in
          let v2 = bin_read_int buf ~pos_ref in
          v1, v2
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

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module T0 = struct
      type t =
        { host : String.t
        ; port : Int.t
        }
      [@@deriving compare, equal, hash, quickcheck]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__012_ b__013_ ->
             if Stdlib.( == ) a__012_ b__013_
             then 0
             else (
               match String.compare a__012_.host b__013_.host with
               | 0 -> Int.compare a__012_.port b__013_.port
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__014_ b__015_ ->
             if Stdlib.( == ) a__014_ b__015_
             then true
             else
               Stdlib.( && )
                 (String.equal a__014_.host b__015_.host)
                 (Int.equal a__014_.port b__015_.port)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv = hsv in
            String.hash_fold_t hsv arg.host
          in
          Int.hash_fold_t hsv arg.port
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

        let quickcheck_generator =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
            (fun ~size:_size__023_ ~random:_random__024_ ->
               { host =
                   Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                     String.quickcheck_generator
                     ~size:_size__023_
                     ~random:_random__024_
               ; port =
                   Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                     Int.quickcheck_generator
                     ~size:_size__023_
                     ~random:_random__024_
               })
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__018_ ~size:_size__021_ ~hash:_hash__022_ ->
               let { host = _x__019_; port = _x__020_ } = _x__018_ in
               let _hash__022_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   String.quickcheck_observer
                   _x__019_
                   ~size:_size__021_
                   ~hash:_hash__022_
               in
               let _hash__022_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Int.quickcheck_observer
                   _x__020_
                   ~size:_size__021_
                   ~hash:_hash__022_
               in
               _hash__022_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
            (fun { host = _x__016_; port = _x__017_ } ->
               Ppx_quickcheck_runtime.Base.Sequence.round_robin
                 [ Ppx_quickcheck_runtime.Base.Sequence.map
                     (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                        String.quickcheck_shrinker
                        _x__016_)
                     ~f:(fun _x__016_ -> { host = _x__016_; port = _x__017_ })
                 ; Ppx_quickcheck_runtime.Base.Sequence.map
                     (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                        Int.quickcheck_shrinker
                        _x__017_)
                     ~f:(fun _x__017_ -> { host = _x__016_; port = _x__017_ })
                 ])
        ;;

        let _ = quickcheck_shrinker
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_serializable { host; port } = host, port
      let of_serializable (host, port) = { host; port }
    end

    module T1 = struct
      include T0

      include
        Binable.Stable.Of_binable.V1 [@alert "-legacy"]
          (Serializable)
          (struct
            include T0

            let to_binable = to_serializable
            let of_binable = of_serializable
          end)

      let stable_witness =
        Stable_witness.of_serializable
          Serializable.stable_witness
          of_serializable
          to_serializable
      ;;

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"host_and_port.ml.before-ppx"
            ~line_number:40
            ~location:{ start_bol = 899; start_pos = 905; end_pos = 1154 }
            ~trailing_loc:{ start_bol = 1141; start_pos = 1154; end_pos = 1154 }
            ~body_loc:{ start_bol = 899; start_pos = 905; end_pos = 1154 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
            ~description:(Some "stable")
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
                          ( { contents =
                                "\n\
                                \          957990f0fc4161fb874e66872550fb40\n\
                                \          957990f0fc4161fb874e66872550fb40\n\
                                \          "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 1042; start_pos = 1052; end_pos = 1153 } ))
                     ~node_loc:{ start_bol = 1025; start_pos = 1033; end_pos = 1154 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest bin_shape_t));
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest Serializable.bin_shape_t));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
      ;;

      include
        Sexpable.Stable.Of_sexpable.V1
          (Serializable)
          (struct
            include T0

            let to_sexpable = to_serializable
            let of_sexpable = of_serializable
          end)

      open! Import
      open! Std_internal
      open! T0

      let to_string { host; port } = sprintf "%s:%d" host port

      let of_string s =
        match String.split s ~on:':' with
        | [ host; port ] ->
          let port =
            try Int.of_string port with
            | _exn -> failwithf "Host_and_port.of_string: bad port: %s" s ()
          in
          { host; port }
        | _ -> failwithf "Host_and_port.of_string: %s" s ()
      ;;

      let t_of_sexp = function
        | Sexp.Atom s as sexp ->
          (try of_string s with
           | Failure err -> of_sexp_error err sexp)
        | sexp -> t_of_sexp sexp
      ;;

      let t_sexp_grammar =
        let open Sexplib.Sexp_grammar in
        { untyped = Union [ String; List (Cons (String, Cons (Integer, Empty))) ] }
      ;;

      include (val Comparator.Stable.V1.make ~compare ~sexp_of_t)
    end

    include T1
    include Comparable.Stable.V1.With_stable_witness.Make (T1)

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "t_of_sexp")
        ~tags:[]
        ~filename:"host_and_port.ml.before-ppx"
        ~line_number:102
        ~start_pos:4
        ~end_pos:298
        (fun () ->
           (fun ?(here = []) ?message ?equal ~expect got ->
              let pos = "host_and_port.ml.before-ppx:103:21" in
              let sexpifier = (sexp_of_t [@merlin.hide]) in
              let comparator =
                (fun (a__025_ : t) ((b__026_ : t) [@merlin.hide]) ->
                (compare a__025_ b__026_ [@merlin.hide]))
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
             (t_of_sexp (Sexp.of_string {|(localhost 8080)|}))
             ~expect:{ host = "localhost"; port = 8080 };
           (fun ?(here = []) ?message ?equal ~expect got ->
              let pos = "host_and_port.ml.before-ppx:106:21" in
              let sexpifier = (sexp_of_t [@merlin.hide]) in
              let comparator =
                (fun (a__027_ : t) ((b__028_ : t) [@merlin.hide]) ->
                (compare a__027_ b__028_ [@merlin.hide]))
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
             (t_of_sexp (Sexp.of_string {|localhost:8080|}))
             ~expect:{ host = "localhost"; port = 8080 };
           ())
    ;;

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "sexp roundtrip")
        ~tags:[]
        ~filename:"host_and_port.ml.before-ppx"
        ~line_number:111
        ~start_pos:4
        ~end_pos:161
        (fun () ->
           Quickcheck.test quickcheck_generator ~f:(fun t ->
             (fun ?(here = []) ?message ?equal ~expect got ->
                let pos = "host_and_port.ml.before-ppx:113:23" in
                let sexpifier = (sexp_of_t [@merlin.hide]) in
                let comparator =
                  (fun (a__029_ : t) ((b__030_ : t) [@merlin.hide]) ->
                  (compare a__029_ b__030_ [@merlin.hide]))
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
               (t_of_sexp (sexp_of_t t))
               ~expect:t);
           ())
    ;;
  end
end

open! Import
open! Std_internal

module Latest = struct
  module T = Stable.V1
  include T

  include Pretty_printer.Register (struct
      type nonrec t = t

      let to_string = to_string
      let module_name = "Core.Host_and_port"
    end)

  include (Hashable.Make_binable (T) : Hashable.S_binable with type t := t)
  include Comparable.Make_binable_using_comparator (T)
end

include Latest

let create ~host ~port = { host; port }
let host t = t.host
let port t = t.port
let tuple t = to_serializable t
let type_id = Type_equal.Id.create ~name:"Host_and_port" sexp_of_t

module Hide_port_in_test = struct
  include Latest

  let sexp_of_t t =
    match am_running_test with
    | false -> sexp_of_t t
    | true -> List [ Atom t.host; Atom "PORT" ]
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
