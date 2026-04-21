let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"file_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "file_helpers.ml.before-ppx"
;;

open! Core
open! Import

module Trailing_newline = struct
  type t =
    [ `Missing_trailing_newline
    | `With_trailing_newline
    ]
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | `Missing_trailing_newline -> Sexplib0.Sexp.Atom "Missing_trailing_newline"
       | `With_trailing_newline -> Sexplib0.Sexp.Atom "With_trailing_newline"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let lines_of_contents contents =
  let lines = Array.of_list (String.split_lines contents) in
  let has_trailing_newline =
    let length = String.length contents in
    if length = 0 || Char.equal contents.[length - 1] '\n'
    then `With_trailing_newline
    else `Missing_trailing_newline
  in
  lines, has_trailing_newline
;;

let warn_if_no_trailing_newline
      ~warn_if_no_trailing_newline_in_both
      ~warn
      ~prev:(prev_file_newline, prev_file)
      ~next:(next_file_newline, next_file)
  =
  match prev_file_newline, next_file_newline with
  | `With_trailing_newline, `With_trailing_newline -> ()
  | `With_trailing_newline, `Missing_trailing_newline -> warn next_file
  | `Missing_trailing_newline, `With_trailing_newline -> warn prev_file
  | `Missing_trailing_newline, `Missing_trailing_newline ->
    if warn_if_no_trailing_newline_in_both
    then (
      warn prev_file;
      warn next_file)
;;

let binary_different_message
      ~(config : Configuration.t)
      ~prev_file
      ~prev_is_binary
      ~next_file
      ~next_is_binary
  =
  match config.location_style with
  | Diff | None | Separator ->
    sprintf
      ((Format
          ( String_literal
              ( "Files "
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__002_ ->
                      File_name.to_string_hum _custom_printf__002_)
                  , String
                      ( No_padding
                      , String_literal
                          ( " and "
                          , Custom
                              ( Custom_succ Custom_zero
                              , (fun () _custom_printf__001_ ->
                                  File_name.to_string_hum _custom_printf__001_)
                              , String
                                  (No_padding, String_literal (" differ", End_of_format))
                              ) ) ) ) )
          , "Files %{File_name#hum}%s and %{File_name#hum}%s differ" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      prev_file
      (if prev_is_binary then " (binary)" else "")
      next_file
      (if next_is_binary then " (binary)" else "")
  | Omake ->
    sprintf
      ((Format
          ( String
              ( No_padding
              , String_literal
                  ( "\n  File \""
                  , Custom
                      ( Custom_succ Custom_zero
                      , (fun () _custom_printf__003_ ->
                          File_name.to_string_hum _custom_printf__003_)
                      , String_literal ("\"\n  binary files differ\n", End_of_format) ) )
              )
          , "%s\n  File \"%{File_name#hum}\"\n  binary files differ\n" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      (Format.Location_style.omake_style_error_message_start
         ~file:(File_name.display_name prev_file)
         ~line:1)
      next_file
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
