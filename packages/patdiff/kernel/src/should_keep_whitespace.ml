let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"should_keep_whitespace.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "should_keep_whitespace.ml.before-ppx"
;;

open! Core
open! Import

let looks_like_python_filename = String.is_suffix ~suffix:".py"

let looks_like_python_first_line first_line =
  String.is_prefix first_line ~prefix:"#!"
  && String.is_substring first_line ~substring:"python"
;;

let looks_like_python input ~get_name ~get_first_line =
  looks_like_python_filename (get_name input)
  || looks_like_python_first_line (get_first_line input)
;;

let fsharp_suffixes =
  let non_base_suffixes = "iylx" in
  let base = ".fs" in
  base
  :: List.map (String.to_list non_base_suffixes) ~f:(fun char ->
    base ^ Char.to_string char)
;;

let () =
  match Ppx_inline_test_lib.testing with
  | `Not_testing -> ()
  | `Testing _ ->
    let module Ppx_expect_test_block =
      Ppx_expect_runtime.Make_test_block (Expect_test_config)
    in
    Ppx_expect_test_block.run_suite
      ~filename_rel_to_project_root:"should_keep_whitespace.ml.before-ppx"
      ~line_number:24
      ~location:{ start_bol = 593; start_pos = 593; end_pos = 723 }
      ~trailing_loc:{ start_bol = 680; start_pos = 723; end_pos = 723 }
      ~body_loc:{ start_bol = 593; start_pos = 593; end_pos = 723 }
      ~formatting_flexibility:
        (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
           Ppx_expect_runtime.Expect_node_formatting.default)
      ~expected_exn:None
      ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
      ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
      ~description:(Some "fsharp_suffixes")
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
                    ( { contents = " (.fs .fsi .fsy .fsl .fsx) "
                      ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                      }
                    , { start_bol = 680; start_pos = 691; end_pos = 722 } ))
               ~node_loc:{ start_bol = 680; start_pos = 682; end_pos = 723 } )
         ]
        [@merlin.hide])
      (fun () ->
         print_s
           (((fun x__001_ -> sexp_of_list sexp_of_string x__001_) [@merlin.hide])
              fsharp_suffixes);
         Ppx_expect_test_block.run_test
           ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
;;

let looks_like_fsharp_filename filename =
  List.exists fsharp_suffixes ~f:(fun suffix -> String.is_suffix ~suffix filename)
;;

let looks_like_fsharp input ~get_name ~get_first_line:_ =
  looks_like_fsharp_filename (get_name input)
;;

let for_diff_internal ~prev ~next ~get_name ~get_first_line =
  List.exists [ looks_like_python; looks_like_fsharp ] ~f:(fun f ->
    List.exists [ prev; next ] ~f:(fun input -> f input ~get_name ~get_first_line))
;;

let for_diff =
  for_diff_internal
    ~get_name:Diff_input.name
    ~get_first_line:(fun (input : Diff_input.t) ->
      match String.lsplit2 input.text ~on:'\n' with
      | Some (first_line, _) -> first_line
      | None -> input.text)
;;

let for_diff_array =
  for_diff_internal ~get_name:fst ~get_first_line:(fun (_, lines) ->
    if Array.is_empty lines then "" else lines.(0))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
