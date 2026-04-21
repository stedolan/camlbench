let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"process_env.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "process_env.ml.before-ppx"
;;

open! Core
open! Import
module Unix = Core_unix

let ssh_client_var = "SSH_CLIENT"

let parse_ssh_client_var = function
  | None -> Ok `Nowhere
  | Some s ->
    (match String.split ~on:' ' s with
     | [] -> failwith "This should never happen, empty string splits as [\"\"]"
     | address :: _ ->
       (fun e ->
          Or_error.tag_arg
            e
            "Could not parse IP address in SSH_CLIENT"
            s
            (sexp_of_string [@merlin.hide]))
         (Or_error.try_with (fun () -> `From (Unix.Inet_addr.of_string address))))
;;

let parse_ssh_client () = parse_ssh_client_var (Sys.getenv ssh_client_var)

module Private = struct
  let parse_ssh_client_var = parse_ssh_client_var
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
