let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"syscall_result_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "syscall_result_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  type ok_value
  type 'a syscall_result
  type t = ok_value syscall_result [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Equal.S with type t := t

  val create_ok : ok_value -> t
  val create_error : Unix_error.t -> t
  val is_ok : t -> bool
  val is_error : t -> bool

  val to_result : t -> (ok_value, Unix_error.t) Result.t
  [@@ocaml.doc
    " This returns a preallocated object for all errors and at least a few [ok_value]s, so\n\
    \      can be used in many contexts where avoiding allocation is important. "]

  val ok_exn : t -> ok_value
  val error_exn : t -> Unix_error.t

  val reinterpret_error_exn : t -> _ syscall_result
  [@@ocaml.doc
    " This is more efficient than calling [error_exn] and then the [create_error] of the\n\
    \      destination type. "]

  val ok_or_unix_error_exn : t -> syscall_name:string -> ok_value

  val ok_or_unix_error_with_args_exn
    :  t
    -> syscall_name:string
    -> 'a
    -> ('a -> Sexp.t)
    -> ok_value

  module Optional_syntax : Optional_syntax.S with type t := t and type value := ok_value

  [@@@ocaml.text "/*"]

  module Private : sig
    val of_int : int -> t
    val length_preallocated_errnos : int
    val length_preallocated_ms : int
  end
end

module type Arg = sig
  type t [@@deriving sexp_of, compare]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Ppx_compare_lib.Comparable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_int : t -> int
  [@@ocaml.doc " [to_int t] must be >= 0, otherwise [create_ok] will raise. "]

  val of_int_exn : int -> t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
