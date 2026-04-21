let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"reversed_list.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "reversed_list.ml.before-ppx"
;;

type 'a t = 'a list =
  | []
  | ( :: ) of 'a * 'a t
[@@deriving equal]

include struct
  let _ = fun (_ : 'a t) -> ()

  let rec equal
    : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
    =
    fun _cmp__a a__001_ b__002_ ->
    if Stdlib.( == ) a__001_ b__002_
    then true
    else (
      match a__001_, b__002_ with
      | [], [] -> true
      | [], _ -> false
      | _, [] -> false
      | _a__003_ :: _a__005_, _b__004_ :: _b__006_ ->
        Stdlib.( && )
          (_cmp__a _a__003_ _b__004_)
          (equal
             (fun a__007_ (b__008_ [@merlin.hide]) ->
                (_cmp__a a__007_ b__008_ [@merlin.hide]))
             _a__005_
             _b__006_))
  ;;

  let _ = equal
end [@@ocaml.doc "@inline"] [@@merlin.hide]

open Base

let of_list_rev = List.rev
let rev = List.rev
let rev_append = List.rev_append
let rev_map = List.rev_map
let rev_filter_map = List.rev_filter_map
let is_empty = List.is_empty
let length = List.length

module With_sexp_of = struct
  type nonrec 'a t = 'a t

  let sexp_of_t sexp_of_a t = List.sexp_of_t sexp_of_a t

  let () =
    match Ppx_inline_test_lib.testing with
    | `Not_testing -> ()
    | `Testing _ ->
      let module Ppx_expect_test_block =
        Ppx_expect_runtime.Make_test_block (Expect_test_config)
      in
      Ppx_expect_test_block.run_suite
        ~filename_rel_to_project_root:"reversed_list.ml.before-ppx"
        ~line_number:21
        ~location:{ start_bol = 400; start_pos = 402; end_pos = 517 }
        ~trailing_loc:{ start_bol = 492; start_pos = 517; end_pos = 517 }
        ~body_loc:{ start_bol = 400; start_pos = 402; end_pos = 517 }
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
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " (1 2) "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 492; start_pos = 505; end_pos = 516 } ))
                 ~node_loc:{ start_bol = 492; start_pos = 496; end_pos = 517 } )
           ]
          [@merlin.hide])
        (fun () ->
           Stdlib.print_endline
             (Sexp.to_string
                (((fun x__009_ -> sexp_of_t sexp_of_int x__009_) [@merlin.hide]) [ 1; 2 ]));
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
  ;;
end

module With_rev_sexp_of = struct
  type nonrec 'a t = 'a t

  let sexp_of_t sexp_of_a t = List.sexp_of_t sexp_of_a (rev t)

  let () =
    match Ppx_inline_test_lib.testing with
    | `Not_testing -> ()
    | `Testing _ ->
      let module Ppx_expect_test_block =
        Ppx_expect_runtime.Make_test_block (Expect_test_config)
      in
      Ppx_expect_test_block.run_suite
        ~filename_rel_to_project_root:"reversed_list.ml.before-ppx"
        ~line_number:32
        ~location:{ start_bol = 652; start_pos = 654; end_pos = 769 }
        ~trailing_loc:{ start_bol = 744; start_pos = 769; end_pos = 769 }
        ~body_loc:{ start_bol = 652; start_pos = 654; end_pos = 769 }
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
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " (2 1) "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 744; start_pos = 757; end_pos = 768 } ))
                 ~node_loc:{ start_bol = 744; start_pos = 748; end_pos = 769 } )
           ]
          [@merlin.hide])
        (fun () ->
           Stdlib.print_endline
             (Sexp.to_string
                (((fun x__010_ -> sexp_of_t sexp_of_int x__010_) [@merlin.hide]) [ 1; 2 ]));
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide])
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
