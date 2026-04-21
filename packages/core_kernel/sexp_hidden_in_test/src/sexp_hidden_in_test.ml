let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"sexp_hidden_in_test.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "sexp_hidden_in_test.ml.before-ppx"
;;

open! Core

module Make (M : sig
    val am_running_test : bool
  end) =
struct
  type 'a t = 'a [@@deriving bin_io, compare, equal, sexp]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "sexp_hidden_in_test.ml.before-ppx:7:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Bin_prot.Shape.var
                (Bin_prot.Shape.Location.of_string
                   "sexp_hidden_in_test.ml.before-ppx:7:14")
                (Bin_prot.Shape.Vid.of_string "a") )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a -> _size_of_a
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a -> _write_a
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

    let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Silly_type "sexp_hidden_in_test.ml.before-ppx.Make.t")
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a -> _of__a
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

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__001_ b__002_ -> _cmp__a a__001_ b__002_
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__003_ b__004_ -> _cmp__a a__003_ b__004_
    ;;

    let _ = equal

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__005_ -> _of_a__005_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__007_ -> _of_a__007_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let sexp_of_t sexp_of_a a =
    if M.am_running_test then Sexp.Atom "<hidden_in_test>" else sexp_of_a a
  ;;

  module With_non_roundtripping_in_test_of_sexp = struct
    type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, sexp]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "sexp_hidden_in_test.ml.before-ppx:14:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_t
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string
                        "sexp_hidden_in_test.ml.before-ppx:14:23")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_t _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
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
        fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
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

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__008_ b__009_ ->
        compare
          (fun a__010_ (b__011_ [@merlin.hide]) ->
             (_cmp__a a__010_ b__011_ [@merlin.hide]))
          a__008_
          b__009_
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__012_ b__013_ ->
        equal
          (fun a__014_ (b__015_ [@merlin.hide]) ->
             (_cmp__a a__014_ b__015_ [@merlin.hide]))
          a__012_
          b__013_
      ;;

      let _ = equal

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__016_ x__018_ -> t_of_sexp _of_a__016_ x__018_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__019_ x__020_ -> sexp_of_t _of_a__019_ x__020_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"sexp_hidden_in_test.ml.before-ppx"
    ~line_number:18
    ~start_pos:0
    ~end_pos:733
    (fun () ->
       let module M = struct
         module Turned_off = struct
           module Sexp_hidden_in_test_turned_off = Make (struct
               let am_running_test = false
             end)

           type nonrec t = int Sexp_hidden_in_test_turned_off.t [@@deriving sexp_of]

           include struct
             let _ = fun (_ : t) -> ()

             let sexp_of_t =
               (fun x__021_ ->
                  Sexp_hidden_in_test_turned_off.sexp_of_t sexp_of_int x__021_
                : t -> Sexplib0.Sexp.t)
             ;;

             let _ = sexp_of_t
           end [@@ocaml.doc "@inline"] [@@merlin.hide]
         end

         module Turned_on = struct
           module Sexp_hidden_in_test_turned_on = Make (struct
               let am_running_test = true
             end)

           type nonrec t = int Sexp_hidden_in_test_turned_on.t [@@deriving sexp_of]

           include struct
             let _ = fun (_ : t) -> ()

             let sexp_of_t =
               (fun x__022_ -> Sexp_hidden_in_test_turned_on.sexp_of_t sexp_of_int x__022_
                : t -> Sexplib0.Sexp.t)
             ;;

             let _ = sexp_of_t
           end [@@ocaml.doc "@inline"] [@@merlin.hide]
         end

         let () =
           match Ppx_inline_test_lib.testing with
           | `Not_testing -> ()
           | `Testing _ ->
             let module Ppx_expect_test_block =
               Ppx_expect_runtime.Make_test_block (Expect_test_config)
             in
             Ppx_expect_test_block.run_suite
               ~filename_rel_to_project_root:"sexp_hidden_in_test.ml.before-ppx"
               ~line_number:36
               ~location:{ start_bol = 873; start_pos = 877; end_pos = 989 }
               ~trailing_loc:{ start_bol = 951; start_pos = 989; end_pos = 989 }
               ~body_loc:{ start_bol = 873; start_pos = 877; end_pos = 989 }
               ~formatting_flexibility:
                 (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                    Ppx_expect_runtime.Expect_node_formatting.default)
               ~expected_exn:None
               ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
               ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
               ~description:(Some "Turned on")
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
                             ( { contents = " <hidden_in_test> "
                               ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                               }
                             , { start_bol = 951; start_pos = 966; end_pos = 988 } ))
                        ~node_loc:{ start_bol = 951; start_pos = 957; end_pos = 989 } )
                  ]
                 [@merlin.hide])
               (fun () ->
                  print_s ((Turned_on.sexp_of_t [@merlin.hide]) 1024);
                  Ppx_expect_test_block.run_test
                    ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0)
                  [@merlin.hide])
         ;;

         let () =
           match Ppx_inline_test_lib.testing with
           | `Not_testing -> ()
           | `Testing _ ->
             let module Ppx_expect_test_block =
               Ppx_expect_runtime.Make_test_block (Expect_test_config)
             in
             Ppx_expect_test_block.run_suite
               ~filename_rel_to_project_root:"sexp_hidden_in_test.ml.before-ppx"
               ~line_number:41
               ~location:{ start_bol = 998; start_pos = 1002; end_pos = 1106 }
               ~trailing_loc:{ start_bol = 1080; start_pos = 1106; end_pos = 1106 }
               ~body_loc:{ start_bol = 998; start_pos = 1002; end_pos = 1106 }
               ~formatting_flexibility:
                 (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                    Ppx_expect_runtime.Expect_node_formatting.default)
               ~expected_exn:None
               ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 4)
               ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 5)
               ~description:(Some "Turned off")
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
                             ( { contents = " 1024 "
                               ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                               }
                             , { start_bol = 1080; start_pos = 1095; end_pos = 1105 } ))
                        ~node_loc:{ start_bol = 1080; start_pos = 1086; end_pos = 1106 } )
                  ]
                 [@merlin.hide])
               (fun () ->
                  print_s ((Turned_off.sexp_of_t [@merlin.hide]) 1024);
                  Ppx_expect_test_block.run_test
                    ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3)
                  [@merlin.hide])
         ;;
       end
       in
       ())
;;

include Make (struct
    let am_running_test = am_running_test
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
