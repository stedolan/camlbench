let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"enumeration.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "enumeration.ml.before-ppx"
;;

open! Core
open! Import

type ('a, 'b) t = { all : 'a list }

module type S =
  Enumeration_intf.S with type ('a, 'witness) enumeration := ('a, 'witness) t

module type S_fc =
  Enumeration_intf.S_fc with type ('a, 'witness) enumeration := ('a, 'witness) t

module Make (T : sig
    type t [@@deriving enumerate]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_enumerate_lib.Enumerable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  type enumeration_witness

  let enumeration =
    let open T in
    { all }
  ;;
end

let make (type t) ~all =
  ((module struct
     type enumerable_t = t
     type enumeration_witness

     let enumeration = { all }
   end)
   : (module S_fc with type enumerable_t = t))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
