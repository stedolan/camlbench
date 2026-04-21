[@@@ocaml.text " Signal handlers. "]

open! Core
open! Import
open Signal

val of_system_int : int -> t
[@@ocaml.doc
  " [of_system_int] and [to_system_int] return and take respectively a signal number\n\
  \    corresponding to those in the system's /usr/include/bits/signum.h (or \
   equivalent).  It\n\
  \    is not guaranteed that these numbers are portable across any given pair of \
   systems --\n\
  \    although some are defined as standard by POSIX. "]

val to_system_int : t -> int

type pid_spec =
  [ `Pid of Pid.t
  | `My_group
  | `Group of Pid.t
  ]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_pid_spec : pid_spec -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val send : t -> pid_spec -> [ `Ok | `No_such_process ]
[@@ocaml.doc
  " [send signal pid_spec] sends [signal] to the processes specified by [pid_spec].\n\n\
  \    [send_i] is like [send], except that it silently returns if the specified processes\n\
  \    don't exist.\n\n\
  \    [send_exn] is like [send], except that it raises if the specified processes\n\
  \    don't exist.\n\n\
  \    All of [send], [send_i], and [send_exn] raise if you don't have permission to \
   send the\n\
  \    signal to the specified processes or if [signal] is unknown. "]

val send_i : t -> pid_spec -> unit
val send_exn : t -> pid_spec -> unit

val can_send_to : Pid.t -> bool
[@@ocaml.doc
  " [can_send_to pid] returns true if [pid] is running and the current process has\n\
  \    permission to send it signals. "]

type sigprocmask_command =
  [ `Set
  | `Block
  | `Unblock
  ]

val sigprocmask : sigprocmask_command -> t list -> t list
[@@ocaml.doc
  " [sigprocmask cmd sigs] changes the set of blocked signals.\n\n\
  \    - If [cmd] is [`Set], blocked signals are set to those in the list [sigs].\n\
  \    - If [cmd] is [`Block], the signals in [sigs] are added to the set of blocked \
   signals.\n\
  \    - If [cmd] is [`Unblock], the signals in [sigs] are removed from the set of blocked\n\
  \      signals.\n\n\
  \    [sigprocmask] returns the set of previously blocked signals.\n"]

val sigpending : unit -> t list
[@@ocaml.doc
  " [sigpending ()] returns the set of blocked signals that are currently pending.\n"]

val sigsuspend : t list -> unit
[@@ocaml.doc
  " [sigsuspend sigs] atomically sets the blocked signals to [sigs] and waits for\n\
  \ * a non-ignored, non-blocked signal to be delivered.  On return, the blocked\n\
  \ * signals are reset to their initial value.\n"]
