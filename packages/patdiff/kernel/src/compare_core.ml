let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"compare_core.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "compare_core.ml.before-ppx"
;;

open! Core
open! Import
include Compare_core_intf

module Make (Patdiff_core_arg : Patdiff_core.S) = struct
  let compare_lines (config : Configuration.t) ~prev ~next =
    let context = config.context in
    let keep_ws = config.keep_ws in
    let split_long_lines = config.split_long_lines in
    let line_big_enough = config.line_big_enough in
    let hunks =
      Patdiff_core_arg.diff
        ~context
        ~line_big_enough
        ~keep_ws
        ~find_moves:config.find_moves
        ~prev
        ~next
    in
    let hunks =
      match config.float_tolerance with
      | None -> hunks
      | Some tolerance -> Float_tolerance.apply hunks tolerance ~context
    in
    if config.unrefined
    then Patience_diff.Hunks.unified hunks
    else (
      let rules = config.rules in
      let output = config.output in
      let produce_unified_lines = config.produce_unified_lines in
      let interleave = config.interleave in
      let word_big_enough = config.word_big_enough in
      Patdiff_core_arg.refine
        ~rules
        ~output
        ~keep_ws
        ~produce_unified_lines
        ~split_long_lines
        ~interleave
        hunks
        ~word_big_enough)
  ;;

  let diff_strings
        ?print_global_header
        (config : Configuration.t)
        ~(prev : Diff_input.t)
        ~(next : Diff_input.t)
    =
    let lines { Diff_input.name = _; text } = Array.of_list (String.split_lines text) in
    let hunks =
      Comparison_result.create
        config
        ~prev
        ~next
        ~compare_assuming_text:(fun config ~prev ~next ->
          compare_lines config ~prev:(lines prev) ~next:(lines next))
    in
    if Comparison_result.has_no_diff hunks
    then `Same
    else
      `Different
        (match hunks with
         | Binary_same -> assert false
         | Binary_different { prev_is_binary; next_is_binary } ->
           File_helpers.binary_different_message
             ~config
             ~prev_file:(Fake prev.name)
             ~prev_is_binary
             ~next_file:(Fake next.name)
             ~next_is_binary
         | Hunks hunks ->
           Patdiff_core_arg.output_to_string
             hunks
             ?print_global_header
             ~file_names:(Fake prev.name, Fake next.name)
             ~output:config.output
             ~rules:config.rules
             ~location_style:config.location_style)
  ;;

  module Private = struct
    let compare_lines = compare_lines
  end
end

module Without_unix = Make (Patdiff_core.Without_unix)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
