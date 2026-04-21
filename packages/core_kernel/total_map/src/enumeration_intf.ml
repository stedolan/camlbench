let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"enumeration_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "enumeration_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  type ('a, 'b) enumeration
  type t
  type enumeration_witness

  val enumeration : (t, enumeration_witness) enumeration
end

module type S_fc = sig
  type enumerable_t

  include S with type t := enumerable_t
end

module type Enumeration = sig
  type ('a, 'witness) t = private { all : 'a list }

  module type S = S with type ('a, 'witness) enumeration := ('a, 'witness) t
  module type S_fc = S_fc with type ('a, 'witness) enumeration := ('a, 'witness) t

  module Make : functor
      (T : sig
         type t [@@deriving enumerate]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_enumerate_lib.Enumerable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S with type t := T.t

  val make : all:'a list -> (module S_fc with type enumerable_t = 'a)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
