let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"readme.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "readme.ml.before-ppx"
;;

open Core
module Unix = Core_unix

let doc = " Display documentation for the configuration file and other help"

let main () =
  protectx
    (Filename_unix.temp_file "patdiff" ".man")
    ~f:(fun fn ->
      let readme = Text.Readme.readme in
      Out_channel.write_lines fn [ readme ];
      ignore
        (Unix.system (sprintf "groff -Tascii -man %s|less" fn) : Unix.Exit_or_signal.t))
    ~finally:(fun fn -> Exn.handle_uncaught (fun () -> Unix.unlink fn) ~exit:false)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
