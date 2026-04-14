let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"diffable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "diffable_intf.ml.before-ppx"
;;

module type S_plain = sig
  type t

  module Diff : Diff_intf.S_plain with type derived_on = t
end

module type S = sig
  type t

  module Diff : Diff_intf.S with type derived_on = t
end

module type S_atomic = sig
  type t

  module Diff : Diff_intf.S_atomic with type derived_on = t
end

module type S1_plain = sig
  type 'a t

  module Diff : Diff_intf.S1_plain with type 'a derived_on = 'a t
end

module type S1 = sig
  type 'a t

  module Diff : Diff_intf.S1 with type 'a derived_on = 'a t
end

module type S2_plain = sig
  type ('a, 'b) t

  module Diff : Diff_intf.S2_plain with type ('a, 'b) derived_on = ('a, 'b) t
end

module type S2 = sig
  type ('a, 'b) t

  module Diff : Diff_intf.S2 with type ('a, 'b) derived_on = ('a, 'b) t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
