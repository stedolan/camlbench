[@@@ocaml.text
  " Send log messages via the Unix Syslog interface.\n\n\
  \    Syslog is great for system daemons that log free-form human readable status \
   messages\n\
  \    or other debugging output, but not so great for archiving structured data.  \
   Access to\n\
  \    read Syslog's messages may also be restricted.  [syslogd]'s logs are also not\n\
  \    necessarily kept forever.  For application level logging consider\n\
  \    {!Core_extended.Std.Logger} instead. "]

open! Import

module Open_option : sig
  type t =
    | PID [@ocaml.doc " Include PID with each message "]
    | CONS
    [@ocaml.doc
      " Write directly to system console if there is an error\n\
      \                  while sending to system logger "]
    | ODELAY [@ocaml.doc " Delay opening of the connection until syslog is called "]
    | NDELAY [@ocaml.doc " No delay opening connection to syslog daemon "]
    | NOWAIT [@ocaml.doc " Do not wait for child processes while logging message "]
    | PERROR [@ocaml.doc " Print to stderr as well "]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Facility : sig
  type t =
    | KERN [@ocaml.doc " Kernel messages "]
    | USER [@ocaml.doc " Generic user-level message (default) "]
    | MAIL [@ocaml.doc " Mail subsystem "]
    | DAEMON [@ocaml.doc " System daemons without separate facility value "]
    | AUTH [@ocaml.doc " Security/authorization messages (DEPRECATED, use AUTHPRIV) "]
    | SYSLOG [@ocaml.doc " Messages generated internally by syslogd "]
    | LPR [@ocaml.doc " Line printer subsystem "]
    | NEWS [@ocaml.doc " USENET news subsystem "]
    | UUCP [@ocaml.doc " UUCP subsystem "]
    | CRON [@ocaml.doc " Clock daemon (cron and at) "]
    | AUTHPRIV [@ocaml.doc " Security/authorization messages (private) "]
    | FTP [@ocaml.doc " FTP daemon "]
    | LOCAL0
    | LOCAL1
    | LOCAL2
    | LOCAL3
    | LOCAL4
    | LOCAL5
    | LOCAL6
    | LOCAL7 [@ocaml.doc " LOCAL0-7 reserved for local use "]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc " Types of messages "]

module Level : sig
  type t =
    | EMERG [@ocaml.doc " System is unusable "]
    | ALERT [@ocaml.doc " Action must be taken immediately "]
    | CRIT [@ocaml.doc " Critical condition "]
    | ERR [@ocaml.doc " Error conditions "]
    | WARNING [@ocaml.doc " Warning conditions "]
    | NOTICE [@ocaml.doc " Normal, but significant, condition "]
    | INFO [@ocaml.doc " Informational message "]
    | DEBUG [@ocaml.doc " Debug-level message "]
  [@@ocaml.doc " [DEBUG] < [EMERG] "] [@@deriving compare, enumerate, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_enumerate_lib.Enumerable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Stringable.S with type t := t
end

val setlogmask
  :  ?allowed_levels:(Level.t list[@ocaml.doc " default is {!List.empty} "])
  -> ?from_level:(Level.t[@ocaml.doc " default is [DEBUG] "])
  -> ?to_level:(Level.t[@ocaml.doc " default is [EMERG] "])
  -> unit
  -> unit
[@@ocaml.doc
  " All levels in [allowed_levels] will be allowed, and additionally all ranging from\n\
  \    [from_level] to [to_level] (inclusive). "]

[@@@ocaml.text " {2 Logging functions} "]

val openlog
  :  ?id:(string[@ocaml.doc " default is [Sys.argv.(0)] "])
  -> ?options:(Open_option.t list[@ocaml.doc " default is [[ODELAY]] "])
  -> ?facility:(Facility.t[@ocaml.doc " default is [USER] "])
  -> unit
  -> unit
[@@ocaml.doc
  " [openlog ~id ~options ~facility ()] opens a connection to the system logger (possibly\n\
  \    delayed) using prefixed identifier [id], [options], and [facility].\n\n\
  \    WARNING: this function leaks the [id] argument, if provided.  There is no way \
   around\n\
  \    that if syslog is called in a multi-threaded environment!  Therefore it shouldn't \
   be\n\
  \    called too often.  What for, anyway?\n\n\
  \    Calling [openlog] before [syslog] is optional.  If you forget, syslog will do it \
   for\n\
  \    you with the defaults. "]

val syslog
  :  ?facility:(Facility.t[@ocaml.doc " default is [USER] "])
  -> ?level:(Level.t[@ocaml.doc " default is [INFO] "])
  -> string
  -> unit
[@@ocaml.doc
  " [syslog ~facility ~level message] logs [message] using syslog with [facility] at\n\
  \    [level]. "]

val syslogf
  :  ?facility:Facility.t
  -> ?level:Level.t
  -> ('a, unit, string, unit) format4
  -> 'a
[@@ocaml.doc
  " [syslog_printf] acts like [syslog], but allows [printf]-style specification of the\n\
  \    message. "]

val closelog : unit -> unit
[@@ocaml.doc " [closelog ()] closes the connection to the [syslog] daemon. "]
