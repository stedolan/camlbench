let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"deriving_hash_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "deriving_hash_intf.ml.before-ppx"
;;

open! Import

module type S = sig
  type t [@@deriving hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Deriving_hash = sig
  module Of_deriving_hash : functor
      (Repr : S)
      -> functor
      (M : sig
         type t

         val to_repr : t -> Repr.t
       end)
      -> S with type t := M.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
