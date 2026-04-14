let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"comparator.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "comparator.ml.before-ppx"
;;

open! Import
module Comparator = Base.Comparator

type ('a, 'witness) t = ('a, 'witness) Comparator.t = private
  { compare : 'a -> 'a -> int
  ; sexp_of_t : 'a -> Base.Sexp.t
  }

module type Base_mask = module type of Comparator with type ('a, 'b) t := ('a, 'b) t

include (Comparator : Base_mask)

module Stable = struct
  module V1 = struct
    type nonrec ('a, 'witness) t = ('a, 'witness) t = private
      { compare : 'a -> 'a -> int
      ; sexp_of_t : 'a -> Base.Sexp.t
      }

    type ('a, 'b) comparator = ('a, 'b) t

    module type S = S
    module type S1 = S1

    let make = make

    module Make = Make
    module Make1 = Make1
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
