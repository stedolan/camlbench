let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"quickcheckable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "quickcheckable_intf.ml.before-ppx"
;;

open! Import

module type Conv = sig
  type quickcheckable
  type t

  val of_quickcheckable : quickcheckable -> t
  val to_quickcheckable : t -> quickcheckable
end

module type Conv1 = sig
  type 'a quickcheckable
  type 'a t

  val of_quickcheckable : 'a quickcheckable -> 'a t
  val to_quickcheckable : 'a t -> 'a quickcheckable
end

module type Conv_filtered = sig
  type quickcheckable
  type t

  val of_quickcheckable : quickcheckable -> t option
  val to_quickcheckable : t -> quickcheckable
end

module type Conv_filtered1 = sig
  type 'a quickcheckable
  type 'a t

  val of_quickcheckable : 'a quickcheckable -> 'a t option
  val to_quickcheckable : 'a t -> 'a quickcheckable
end

module type Quickcheckable = sig
  module type Conv = Conv
  module type Conv1 = Conv1
  module type Conv_filtered = Conv_filtered
  module type Conv_filtered1 = Conv_filtered1
  module type S = Quickcheck.S
  module type S1 = Quickcheck.S1
  module type S2 = Quickcheck.S2
  module type S_int = Quickcheck.S_int

  module Of_quickcheckable : functor
      (Quickcheckable : S)
      -> functor
      (Conv : Conv with type quickcheckable := Quickcheckable.t)
      -> S with type t := Conv.t

  module Of_quickcheckable1 : functor
      (Quickcheckable : S1)
      -> functor
      (Conv : Conv1 with type 'a quickcheckable := 'a Quickcheckable.t)
      -> S1 with type 'a t := 'a Conv.t

  module Of_quickcheckable_filtered : functor
      (Quickcheckable : S)
      -> functor
      (Conv : Conv_filtered with type quickcheckable := Quickcheckable.t)
      -> S with type t := Conv.t

  module Of_quickcheckable_filtered1 : functor
      (Quickcheckable : S1)
      -> functor
      (Conv : Conv_filtered1 with type 'a quickcheckable := 'a Quickcheckable.t)
      -> S1 with type 'a t := 'a Conv.t
end
[@@ocaml.doc " Provides functors for making a module quickcheckable with {!Quickcheck}. "]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
