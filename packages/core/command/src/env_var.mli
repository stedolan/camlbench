open! Base
open! Import

type t =
  | COMMAND_OUTPUT_INSTALLATION_BASH
  | COMMAND_OUTPUT_HELP_SEXP
  | COMP_CWORD
[@@ocaml.doc
  " [Command_env_var] collects all the environment variables used by [Command].\n\n\
  \    We define them centrally because some services that wrap [Command] calls need to \
   know\n\
  \    to special case them. "]
[@@deriving compare, enumerate, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_enumerate_lib.Enumerable.S with type t := t

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val to_string : t -> string
