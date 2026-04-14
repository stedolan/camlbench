[@@@ocaml.text
  " An interface for creating unit tests to check stability of sexp and bin-io\n\
  \    serializations "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_unit_test_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_unit_test_intf.ml.before-ppx"
;;

open! Import

module type Arg = sig
  type t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val equal : t -> t -> bool

  val tests : (t * string * string) list
  [@@ocaml.doc
    " [tests] is a list of (value, sexp-representation, bin-io-representation) triples.\n\
    \      The unit tests check that the type properly serializes and\n\
    \      de-serializes according to the given representations. "]
end

module Unordered_container_test = struct
  type t =
    { sexps : string list
    ; bin_io_header : string
    ; bin_io_elements : string list
    }
end
[@@ocaml.doc
  " Unordered container tests are for types with serializations that will contain a\n\
  \    certain set of elements (each represented by a single sexp or bin-io string) \
   which may\n\
  \    appear in any order, such as hash tables and hash sets. "]

module type Unordered_container_arg = sig
  type t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val equal : t -> t -> bool
  val tests : (t * Unordered_container_test.t) list
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
