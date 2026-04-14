let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"import.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "import.ml.before-ppx"
;;

include struct
  open Stdio

  let eprintf = eprintf
  let printf = printf
  let print_s = print_s
  let print_string = print_string
  let print_endline = print_endline
  let prerr_endline = prerr_endline

  module In_channel = In_channel
end

include struct
  open Base.Printf

  let sprintf = sprintf
  let failwithf = failwithf
  let ksprintf = ksprintf
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
