let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"core_pervasives.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "core_pervasives.ml.before-ppx"
;;

include Stdlib

external raise : exn -> 'a = "%reraise"
external ignore : ('a[@local_opt]) -> unit = "%ignore"

external __LOC_OF__ : ('a[@local_opt]) -> (string * 'a[@local_opt]) = "%loc_LOC"
external __LINE_OF__ : ('a[@local_opt]) -> (int * 'a[@local_opt]) = "%loc_LINE"

external __POS_OF__
  :  ('a[@local_opt])
  -> ((string * int * int * int) * 'a[@local_opt])
  = "%loc_POS"

external ( |> ) : 'a -> (('a -> 'b)[@local_opt]) -> 'b = "%revapply"
external ( @@ ) : (('a -> 'b)[@local_opt]) -> 'a -> 'b = "%apply"
external int_of_char : (char[@local_opt]) -> int = "%identity"

external format_of_string
  :  (('a, 'b, 'c, 'd, 'e, 'f) format6[@local_opt])
  -> (('a, 'b, 'c, 'd, 'e, 'f) format6[@local_opt])
  = "%identity"

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
