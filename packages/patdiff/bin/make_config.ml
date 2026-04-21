let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"make_config.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "make_config.ml.before-ppx"
;;

open Core

let doc = "FILE Write default configuration file"

let main filename =
  let delete =
    if Sys_unix.file_exists_exn filename
    then (
      printf "%s already exists. Overwrite? (y/n) %!" filename;
      let resp = In_channel.input_line In_channel.stdin in
      let resp = Option.value ~default:"" resp in
      let resp = String.lowercase resp in
      match resp with
      | "yes" | "y" -> true
      | _ -> false)
    else true
  in
  if delete
  then (
    try
      Patdiff.Configuration.save_default ~filename;
      printf "Default configuration written to %s\n%!" filename
    with
    | e -> failwithf "Error: %s" (Exn.to_string e) ())
  else (
    printf "Configuration file not written!\n%!";
    exit 1)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
