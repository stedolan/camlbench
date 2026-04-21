let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"output_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "output_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  [@@@ocaml.text " An output can apply a style to a string and print a list of hunks "]

  module Rule : sig
    val apply : string -> rule:Format.Rule.t -> refined:bool -> string
  end

  val print
    :  print_global_header:bool
    -> file_names:File_name.t * File_name.t
    -> rules:Format.Rules.t
    -> print:(string -> unit)
    -> location_style:Format.Location_style.t
    -> Hunks.t
    -> unit
end

module type Output = sig
  module type S = S

  type t =
    | Ansi
    | Ascii
    | Html
  [@@ocaml.doc " Ascii is Ansi with no styles. "] [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val implies_unrefined : t -> bool
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
