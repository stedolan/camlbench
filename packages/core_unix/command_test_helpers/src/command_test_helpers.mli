[@@@ocaml.text " Functions to help test [Command]. "]

open! Core
open! Import

val parse_command_line
  :  ?path:string list
  -> ?summary:string
  -> ?readme:(unit -> string)
  -> 'a Command.Param.t
  -> (?on_error:(unit -> unit) -> ?on_success:('a -> unit) -> string list -> unit)
       Staged.t
[@@ocaml.doc
  " [parse_command_line param] returns a function which evaluates [param] against a string\n\
  \    list as if those were the arguments passed to [param]. No shelling out takes place.\n\
  \    However, the [param] is evaluated, and side effects of that evaluation do occur.\n\n\
  \    See [validate_command_line] below for a less accurate but generally safer test that\n\
  \    does not evaluate the param.  (Of course if your param is side-effect free, \
   there's no\n\
  \    reason to shy away from this one.)\n\n\
  \    If the command-line fails to parse, an error will be printed.  If the command-line\n\
  \    parsing code exits for any reason (e.g. you passed \"-help\"), the exit code is \
   printed.\n"]

val parse_command_line_or_error
  :  ?path:string list
  -> ?summary:string
  -> ?readme:(unit -> string)
  -> 'a Command.Param.t
  -> (string list -> 'a Or_error.t) Staged.t

val validate_command : Command.t -> string list -> unit Or_error.t
[@@ocaml.doc
  " [validate_command command] provides a function [f] s.t. [f args] will parse the args\n\
  \    against [command] without executing the body of [command] if parsing succeeds.\n\n\
  \    [f args] will raise if [args] goes through an [Exec _].\n\n\
  \    This will trigger any side-effects caused by parsing the args but it does\n\
  \    guarentee the the args provided are completely valid.\n\n\
  \    [validate_command command] does not work in top-level expect tests.\n"]

val validate_command_line : Command.Shape.t -> (string list -> unit Or_error.t) Or_error.t
[@@ocaml.doc
  " [validate_command_line shape] provides a function [f] s.t. [f args] is best-effort\n\
  \    check of [args] against the command described by [shape], without actual \
   execution of\n\
  \    that command.\n\n\
  \    [validate_command_line] raises if any subcommand of [shape] would exec another \
   command\n\
  \    binary. This prevents us from introducing unexpected external dependencies into \
   tests.\n\n\
  \    What we check:\n\n\
  \    1. [args] refers to a valid subcommand of [shape].\n\n\
  \    2. [args] passes an acceptable number of anonymous arguments.\n\n\
  \    3. [args] passes flags that exist, an acceptable number of times, and with \
   arguments\n\
  \    where they are expected.\n\n\
  \    What we do not check:\n\n\
  \    1. Whether argument have acceptable values. E.g., it falsely accepts floats where \
   ints\n\
  \    are expected.\n\n\
  \    2. Side effects during argument parsing, including aborting further parsing of the\n\
  \    command line.  E.g., it does not handle [-help] or [escape] flags correctly.\n\n\
  \    3. Aliases excluded from help.  E.g., [--help].\n\n\
  \    4. [full_flag_required].  We assume every flag can be passed by prefix.\n"]

val complete
  :  ?which_arg:(int[@ocaml.doc " zero-indexed. Default: the last arg "])
  -> _ Command.Param.t
  -> args:string list
  -> unit
[@@ocaml.doc
  " [complete ?which_arg param ~args] prints the completion suggestions to stderr.\n\n\
  \    Thread safety:\n\n\
  \    [complete] is not in general thread-safe. It sets and then restores the environment\n\
  \    variable [COMP_CWORD]. However, the cooperative multi-threading semantics of \
   [Async]\n\
  \    mean that other async jobs will not see the altered environments.\n\n\
  \    Side effects:\n\n\
  \    [complete] will not perform the side effects of the param proper (e.g., due to \
   the [f]\n\
  \    of a [Param.map ~f]).\n\n\
  \    [complete] will perform side effects of completion (e.g., due to the [complete] of\n\
  \    [Arg_type.create ~complete]).\n"]

val complete_command
  :  ?complete_subcommands:
       (path:string list -> part:string -> string list list -> string list option)
  -> ?which_arg:int
  -> Command.t
  -> args:string list
  -> unit
[@@ocaml.doc " As [complete] but applies to an intact [Command]. "]
