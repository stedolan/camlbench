open! Core
open! Import

val default_context : int
[@@ocaml.doc " Default amount of context shown around each change in the diff "]

[@@@ocaml.text " The following constants were all chosen empirically. "]

val default_line_big_enough : int
[@@ocaml.doc
  " Default cutoff for line-level semantic cleanup.  Any match of \
   [default_line_big_enough]\n\
  \    or more will not be deleted, even if it's surrounded by large inserts and deletes.\n\
  \    Raising this quantity can only decrease the number of matches, and lowering it\n\
  \    can only increase the number of matches. "]

val default_word_big_enough : int
[@@ocaml.doc " Analogous to {!default_line_big_enough}, but for word-level refinement "]

val too_short_to_split : int
[@@ocaml.doc
  " Governs the behavior of [split_for_readability].  We will only split ranges around\n\
  \    matches of size greater than [too_short_to_split].  Note that this should always\n\
  \    be at least 1, otherwise we will split on a single `Newline token.\n\
  \    Raising this quantity will result in less ranges being split, and setting it to\n\
  \    infinity is the same as passing in [~interleave:false]. "]

val warn_if_no_trailing_newline_in_both_default : bool

type t = private
  { output : Output.t
  ; rules : Format.Rules.t
  ; float_tolerance : Percent.t option
  ; produce_unified_lines : bool
  ; unrefined : bool
  ; keep_ws : bool
  ; find_moves : bool
  ; split_long_lines : bool
  ; interleave : bool
  ; assume_text : bool
  ; context : int
  ; line_big_enough : int
  ; word_big_enough : int
  ; shallow : bool
  ; quiet : bool
  ; double_check : bool
  ; mask_uniques : bool
  ; prev_alt : string option
  ; next_alt : string option
  ; location_style : Format.Location_style.t
  ; warn_if_no_trailing_newline_in_both : bool
  }
[@@deriving compare, fields ~getters, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t

  val warn_if_no_trailing_newline_in_both : t -> bool
  val location_style : t -> Format.Location_style.t
  val next_alt : t -> string option
  val prev_alt : t -> string option
  val mask_uniques : t -> bool
  val double_check : t -> bool
  val quiet : t -> bool
  val shallow : t -> bool
  val word_big_enough : t -> int
  val line_big_enough : t -> int
  val context : t -> int
  val assume_text : t -> bool
  val interleave : t -> bool
  val split_long_lines : t -> bool
  val find_moves : t -> bool
  val keep_ws : t -> bool
  val unrefined : t -> bool
  val produce_unified_lines : t -> bool
  val float_tolerance : t -> Percent.t option
  val rules : t -> Format.Rules.t
  val output : t -> Output.t
  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S with type t := t

val create_exn
  :  output:Output.t
  -> rules:Format.Rules.t
  -> float_tolerance:Percent.t option
  -> produce_unified_lines:bool
  -> unrefined:bool
  -> keep_ws:bool
  -> find_moves:bool
  -> split_long_lines:bool
  -> interleave:bool
  -> assume_text:bool
  -> context:int
  -> line_big_enough:int
  -> word_big_enough:int
  -> shallow:bool
  -> quiet:bool
  -> double_check:bool
  -> mask_uniques:bool
  -> prev_alt:string option
  -> next_alt:string option
  -> location_style:Format.Location_style.t
  -> warn_if_no_trailing_newline_in_both:bool
  -> t
[@@ocaml.doc " Raises if [invariant t] fails. "]

val override
  :  ?output:Output.t
  -> ?rules:Format.Rules.t
  -> ?float_tolerance:Percent.t option
  -> ?produce_unified_lines:bool
  -> ?unrefined:bool
  -> ?keep_ws:bool
  -> ?find_moves:bool
  -> ?split_long_lines:bool
  -> ?interleave:bool
  -> ?assume_text:bool
  -> ?context:int
  -> ?line_big_enough:int
  -> ?word_big_enough:int
  -> ?shallow:bool
  -> ?quiet:bool
  -> ?double_check:bool
  -> ?mask_uniques:bool
  -> ?prev_alt:string option
  -> ?next_alt:string option
  -> ?location_style:Format.Location_style.t
  -> ?warn_if_no_trailing_newline_in_both:bool
  -> t
  -> t

val default : t
