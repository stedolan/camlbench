let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"core_sys.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "core_sys.ml.before-ppx"
;;

open! Import
include Base.Sys

let unix_quote x =
  if
    (not (String.is_empty x))
    && String.for_all x ~f:(function
      | 'a' .. 'z'
      | 'A' .. 'Z'
      | '0' .. '9'
      | '_' | '-' | ':' | '.' | '/' | ',' | '+' | '=' | '%' | '@' -> true
      | _ -> false)
  then (
    match x with
    | "if"
    | "then"
    | "else"
    | "elif"
    | "fi"
    | "case"
    | "esac"
    | "for"
    | "select"
    | "while"
    | "until"
    | "do"
    | "done"
    | "in"
    | "function"
    | "time"
    | "coproc"
    | "foreach"
    | "repeat"
    | "nocorrect" -> Filename.quote x
    | _ -> x)
  else Filename.quote x
;;

let quote =
  match Stdlib.Sys.os_type with
  | "Unix" -> unix_quote
  | _ -> Filename.quote
;;

let concat_quoted split_command = String.concat ~sep:" " (List.map ~f:quote split_command)
let c_int_size = `Use_Sys_unix
let catch_break = `Use_Sys_unix
let chdir = `Use_Sys_unix
let command = `Use_Sys_unix
let command_exn = `Use_Sys_unix
let executable_name = `Use_Sys_unix
let execution_mode = `Use_Sys_unix
let file_exists = `Use_Sys_unix
let file_exists_exn = `Use_Sys_unix
let fold_dir = `Use_Sys_unix
let getcwd = `Use_Sys_unix
let home_directory = `Use_Sys_unix
let is_directory = `Use_Sys_unix
let is_directory_exn = `Use_Sys_unix
let is_file = `Use_Sys_unix
let is_file_exn = `Use_Sys_unix
let ls_dir = `Use_Sys_unix
let override_argv = `Use_Sys_unix
let readdir = `Use_Sys_unix
let remove = `Use_Sys_unix
let rename = `Use_Sys_unix
let unsafe_getenv = `Use_Sys_unix
let unsafe_getenv_exn = `Use_Sys_unix

exception Break = Stdlib.Sys.Break

module Private = struct
  let unix_quote = unix_quote
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
