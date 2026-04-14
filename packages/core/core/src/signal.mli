[@@@ocaml.text " Signal handlers. "]

open! Import

type t [@@deriving bin_io, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Comparable.S with type t := t
include Hashable.S with type t := t
include Stringable.S with type t := t

val equal : t -> t -> bool

val of_caml_int : int -> t
[@@ocaml.doc
  " [of_caml_int] constructs a [Signal.t] given an OCaml internal signal number.  This is\n\
  \    only for the use of the [Core_unix] module. "]

val to_caml_int : t -> int

val to_string : t -> string
[@@ocaml.doc
  " [to_string t] returns a human-readable name: \"sigabrt\", \"sigalrm\", ... "]

type sys_behavior =
  [ `Continue [@ocaml.doc " Continue the process if it is currently stopped "]
  | `Dump_core [@ocaml.doc " Terminate the process and dump core "]
  | `Ignore [@ocaml.doc " Ignore the signal "]
  | `Stop [@ocaml.doc " Stop (suspend) the process "]
  | `Terminate [@ocaml.doc " Terminate the process "]
  ]
[@@ocaml.doc
  " The behaviour of the system if a signal is received by a process.\n\
  \    See include/linux/kernel.h in the Linux kernel source tree (not the file\n\
  \    /usr/include/linux/kernel.h). "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_sys_behavior : sys_behavior -> Sexplib0.Sexp.t
  val sys_behavior_of_sexp : Sexplib0.Sexp.t -> sys_behavior
  val __sys_behavior_of_sexp__ : Sexplib0.Sexp.t -> sys_behavior
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val default_sys_behavior : t -> sys_behavior
[@@ocaml.doc "\n   Queries the default system behavior for a signal.\n"]

val handle_default : t -> unit [@@ocaml.doc " [handle_default t] is [set t `Default]. "]

val ignore : t -> unit [@@ocaml.doc " [ignore t] is [set t `Ignore]. "]

[@@@ocaml.text " Specific signals, along with their default behavior and meaning. "]

val abrt : t [@@ocaml.doc " [Dump_core]  Abnormal termination                           "]

val alrm : t [@@ocaml.doc " [Terminate]  Timeout                                        "]

val bus : t [@@ocaml.doc " [Dump_core]  Bus error                                      "]

val chld : t [@@ocaml.doc " [Ignore]     Child process terminated                       "]

val cont : t [@@ocaml.doc " [Continue]   Continue                                       "]

val fpe : t [@@ocaml.doc " [Dump_core]  Arithmetic exception                           "]

val hup : t [@@ocaml.doc " [Terminate]  Hangup on controlling terminal                 "]

val ill : t [@@ocaml.doc " [Dump_core]  Invalid hardware instruction                   "]

val int : t [@@ocaml.doc " [Terminate]  Interactive interrupt (ctrl-C)                 "]

val kill : t [@@ocaml.doc " [Terminate]  Termination (cannot be ignored)                "]

val pipe : t [@@ocaml.doc " [Terminate]  Broken pipe                                    "]

val poll : t [@@ocaml.doc " [Terminate]  Pollable event                                 "]

val prof : t [@@ocaml.doc " [Terminate]  Profiling interrupt                            "]

val quit : t [@@ocaml.doc " [Dump_core]  Interactive termination                        "]

val segv : t [@@ocaml.doc " [Dump_core]  Invalid memory reference                       "]

val sys : t [@@ocaml.doc " [Dump_core]  Bad argument to routine                        "]

val stop : t [@@ocaml.doc " [Stop]       Stop                                           "]

val term : t [@@ocaml.doc " [Terminate]  Termination                                    "]

val trap : t [@@ocaml.doc " [Dump_core]  Trace/breakpoint trap                          "]

val tstp : t [@@ocaml.doc " [Stop]       Interactive stop                               "]

val ttin : t [@@ocaml.doc " [Stop]       Terminal read from background process          "]

val ttou : t [@@ocaml.doc " [Stop]       Terminal write from background process         "]

val urg : t [@@ocaml.doc " [Ignore]     Urgent condition on socket                     "]

val usr1 : t [@@ocaml.doc " [Terminate]  Application-defined signal 1                   "]

val usr2 : t [@@ocaml.doc " [Terminate]  Application-defined signal 2                   "]

val vtalrm : t
[@@ocaml.doc " [Terminate]  Timeout in virtual time                        "]

val xcpu : t [@@ocaml.doc " [Dump_core]  Timeout in cpu time                            "]

val xfsz : t [@@ocaml.doc " [Dump_core]  File size limit exceeded                       "]

val zero : t
[@@ocaml.doc
  " [Ignore]     No-op; can be used to test whether the target\n\
  \    process exists and the current process has\n\
  \    permission to signal it                        "]

type pid_spec = [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]

type sigprocmask_command = [ `Use_Signal_unix ]
[@@deprecated "[since 2021-04] Use [Signal_unix]"]

val can_send_to : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]

val of_system_int : [ `Use_Signal_unix ]
[@@deprecated "[since 2021-04] Use [Signal_unix]"]

val send : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]
val send_exn : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]
val send_i : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]

val sexp_of_pid_spec : [ `Use_Signal_unix ]
[@@deprecated "[since 2021-04] Use [Signal_unix]"]

val sigpending : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]
val sigprocmask : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]
val sigsuspend : [ `Use_Signal_unix ] [@@deprecated "[since 2021-04] Use [Signal_unix]"]

val to_system_int : [ `Use_Signal_unix ]
[@@deprecated "[since 2021-04] Use [Signal_unix]"]

module Expert : sig
  type behavior =
    [ `Default
    | `Ignore
    | `Handle of t -> unit
    ]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_behavior : behavior -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val signal : t -> behavior -> behavior
  [@@ocaml.doc
    " [signal t] sets the behavior of the system on receipt of signal [t] and returns the\n\
    \      behavior previously associated with [t].  If [t] is not available on your \
     system,\n\
    \      [signal] raises. "]

  val set : t -> behavior -> unit [@@ocaml.doc " [set t b] is [ignore (signal t b)]. "]

  val handle : t -> (t -> unit) -> unit
  [@@ocaml.doc " [handle t f] is [set t (`Handle f)]. "]
end
[@@ocaml.doc
  " The [Expert] module contains functions that novice users should avoid, due to their\n\
  \    complexity.\n\n\
  \    An OCaml signal handler can run at any time, which introduces all the semantic\n\
  \    complexities of multithreading.  It is much easier to use Async's signal \
   handling, see\n\
  \    {!Async_unix.Signal}, which does not involve multithreading, and runs user code as\n\
  \    ordinary Async jobs.  Also, beware that there can only be a single OCaml signal\n\
  \    handler for any signal, so handling a signal with a [Core] signal handler will\n\
  \    interfere if Async is attempting to handle the same signal.\n\n\
  \    All signal handler functions are called with [Exn.handle_uncaught_and_exit], to\n\
  \    prevent the signal handler from raising, because raising from a signal handler \
   could\n\
  \    raise to any allocation or GC point in any thread, which would be impossible to\n\
  \    reason about.\n\n\
  \    If you do use [Core] signal handlers, you should strive to make the signal handler\n\
  \    perform a simple idempotent action, like setting a ref. "]

module Stable : sig
  module V2 : sig
    type nonrec t = t [@@deriving bin_io, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module V1 : sig
    type nonrec t = t [@@deriving bin_io, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
