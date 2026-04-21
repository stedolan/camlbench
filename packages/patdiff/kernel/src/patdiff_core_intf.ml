let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patdiff_core_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patdiff_core_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  val diff
    :  context:int
    -> line_big_enough:int
    -> keep_ws:bool
    -> find_moves:bool
    -> prev:string array
    -> next:string array
    -> Hunks.t
  [@@ocaml.doc
    " [diff ~context ~keep_ws ~prev ~next] uses [Patience_diff.String] to get a list of\n\
    \      hunks describing the comparison between [prev] and [next]. "]

  val find_moves : line_big_enough:int -> keep_ws:bool -> Hunks.t -> Hunks.t

  val refine
    :  rules:Format.Rules.t
    -> produce_unified_lines:bool
    -> output:Output.t
    -> keep_ws:bool
    -> split_long_lines:bool
    -> interleave:bool
    -> word_big_enough:int
    -> Hunks.t
    -> Hunks.t
  [@@ocaml.doc
    " [refine hunks] maps each [Range.Replace (prev, next)] in [hunks] to a diff of [prev]\n\
    \      against [next]. "]

  val explode
    :  string array
    -> keep_ws:bool
    -> [ `Newline of int * string option | `Word of string ] array

  val print
    :  file_names:File_name.t * File_name.t
    -> rules:Format.Rules.t
    -> output:Output.t
    -> location_style:Format.Location_style.t
    -> Hunks.t
    -> unit
  [@@ocaml.doc " Print a hunk list, usually from [diff] or [refine] "]

  val output_to_string
    :  ?print_global_header:bool
    -> file_names:File_name.t * File_name.t
    -> rules:Format.Rules.t
    -> output:Output.t
    -> location_style:Format.Location_style.t
    -> Hunks.t
    -> string
  [@@ocaml.doc " Output a hunk list, usually from [diff] or [refine], to a string "]

  val iter_ansi
    :  rules:Format.Rules.t
    -> f_hunk_break:(int * int -> int * int -> unit)
    -> f_line:(string -> unit)
    -> Hunks.t
    -> unit
  [@@ocaml.doc
    " Iter along the lines of the diff and the breaks between hunks. Offers more \
     flexibility\n\
    \      regarding what the caller wants to do with the lines "]

  val patdiff
    :  ?context:int
    -> ?keep_ws:bool
    -> ?find_moves:bool
    -> ?rules:Format.Rules.t
    -> ?output:Output.t
    -> ?produce_unified_lines:bool
    -> ?split_long_lines:bool
    -> ?print_global_header:bool
    -> ?location_style:Format.Location_style.t
    -> ?interleave:bool
    -> ?float_tolerance:Percent.t
    -> ?line_big_enough:int
    -> ?word_big_enough:int
    -> prev:Diff_input.t
    -> next:Diff_input.t
    -> unit
    -> string
  [@@ocaml.doc
    " Runs the equivalent of the command line version of patdiff on two given contents\n\
    \      [prev] and [next].  Uses [Patience_diff.String]. "]
end

module type Output_impls = sig
  val implementation : Output.t -> (module Output.S)
  val console_width : unit -> int Or_error.t
end

module type Patdiff_core = sig
  module type S = S

  val default_context : int
  val default_line_big_enough : int
  val default_word_big_enough : int

  val remove_ws : string -> string
  [@@ocaml.doc " [remove_ws] calls String.strip and replaces whitespace with \" \" "]

  module Private : sig
    module Make : functor (Output_impls : Output_impls) -> S
  end

  module Without_unix : S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
