open! Core

val run
  :  ?add_validate_parsing_flag:bool
  -> ?verbose_on_parse_error:bool
  -> ?version:string
  -> ?build_info:string
  -> ?argv:string list
  -> ?extend:(string list -> string list)
  -> ?when_parsing_succeeds:(unit -> unit)
  -> ?complete_subcommands:
       (path:string list -> part:string -> string list list -> string list option)
  -> Command.t
  -> unit
[@@ocaml.doc
  " Runs a command against [Sys.argv], or [argv] if it is specified.\n\n\
  \    [extend] can be used to add extra command line arguments to basic subcommands of \
   the\n\
  \    command.  [extend] will be passed the (fully expanded) path to a command, and its\n\
  \    output will be appended to the list of arguments being processed.  For example,\n\
  \    suppose a program like this is compiled into [exe]:\n\n\
  \    {[\n\
  \      let bar = Command.basic ___\n\
  \      let foo = Command.group ~summary:___ [\"bar\", bar]\n\
  \      let main = Command.group ~summary:___ [\"foo\", foo]\n\
  \      let () = Command.run ~extend:(fun _ -> [\"-baz\"]) main\n\
  \    ]}\n\n\
  \    Then if a user ran [exe f b], [extend] would be passed [[\"foo\"; \"bar\"]] and \
   [\"-baz\"]\n\
  \    would be appended to the command line for processing by [bar].  This can be used to\n\
  \    add a default flags section to a user config file.\n\n\
  \    [verbose_on_parse_error] controls whether to print a line suggesting the user try \
   the\n\
  \    \"-help\" flag when an exception is raised while parsing the arguments.  By \
   default it\n\
  \    is true.\n\n\
  \    [when_parsing_succeeds] is invoked after argument parsing has completed \
   successfully,\n\
  \    but before the main function of the associated command has run. One use-case is for\n\
  \    performing logging when a command is being invoked, where there's no reason to log\n\
  \    incorrect invocations or -help calls.\n\n\
  \    [complete_subcommands] can be used to override the completion mechanism.\n"]

module Path : sig
  type t
  [@@ocaml.doc
    " [Path.t] is a top-level executable name and sequence of subcommand names that can be\n\
    \      used to identify a command. "]

  val create : path_to_exe:string -> t
  [@@ocaml.doc
    " [create] creates a path from a toplevel executable given by [path_to_exe]. "]

  val append : t -> subcommand:string -> t
  [@@ocaml.doc " [append] appends a subcommand to [t]. "]

  val parts : t -> string list
  [@@ocaml.doc
    " [parts] returns a list containing the path's executable name followed by its\n\
    \      subcommands. "]
end

module Shape : sig
  val help_text
    :  Command.Shape.t
    -> Path.t
    -> expand_dots:bool
    -> flags:bool
    -> recursive:bool
    -> string
  [@@ocaml.doc
    " Get the help text for a command shape.\n\n\
    \      The [Path.t] argument should be the path that identifies the shape argument.\n\n\
    \      [expand_dots]: expand subcommands in recursive help. (default: false)\n\
    \      This is the same as the [help] subcommand's [\"-expand-dots\"] flag.\n\n\
    \      [flags]: show flags in recursive help. (default: false)\n\
    \      This is the same as the [help] subcommand's [\"-flags\"] flag.\n\n\
    \      [recursive]: show subcommands of subcommands. (default: false)\n\
    \      This is the same as the [help] subcommand's [\"-recursive\"] flag. "]
end

val shape : Command.t -> Command.Shape.t [@@ocaml.doc " Exposes the shape of a command. "]

module Deprecated : sig
  val run
    :  Command.t
    -> cmd:string
    -> args:string list
    -> is_help:bool
    -> is_help_rec:bool
    -> is_help_rec_flags:bool
    -> is_expand_dots:bool
    -> unit
end
[@@ocaml.doc
  " [Deprecated] should be used only by [Deprecated_command].  At some point\n\
  \    it will go away. "]
