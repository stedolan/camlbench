let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"stack.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "stack.ml.before-ppx"
;;

include Base.Stack

include Bin_prot.Utils.Make_binable1_without_uuid [@alert "-legacy"] (struct
    type nonrec 'a t = 'a t

    module Binable = List

    let to_binable = to_list
    let of_binable = of_list
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
