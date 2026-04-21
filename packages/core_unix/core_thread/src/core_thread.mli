[@@@ocaml.text " Lightweight threads. "]

open! Core
open! Import

type t [@@ocaml.doc " The type of thread handles. "] [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text " {6 Thread creation and termination} "]

val create
  :  on_uncaught_exn:[ `Kill_whole_process | `Print_to_stderr ]
  -> ('a -> unit)
  -> 'a
  -> t
[@@ocaml.doc
  " [Thread.create funct arg] creates a new thread of control, in which the function\n\
  \    application [funct arg] is executed concurrently with the other threads of the\n\
  \    program. The application of [Thread.create] returns the handle of the newly created\n\
  \    thread.\n\n\
  \    The new thread terminates when the application [funct arg] returns, either \
   normally or\n\
  \    by raising an uncaught exception.\n\n\
  \    In the latter case, behavior is controlled by [on_uncaught_exn]. If \
   [`Print_to_stderr]\n\
  \    is selected, the exception is printed on standard error, but not propagated back to\n\
  \    the parent thread.  If [`Kill_whole_process] is selected, the exception is \
   printed to\n\
  \    stderr and then the process exits with code 1 (after having run [at_exit] \
   callbacks,\n\
  \    etc.). "]

val self : unit -> t [@@ocaml.doc " Return the thread currently executing. "]

val id : t -> int
[@@ocaml.doc
  " Return the identifier of the given thread. A thread identifier\n\
  \    is an integer that identifies uniquely the thread.\n\
  \    It can be used to build data structures indexed by threads. "]

val exit : unit -> unit
[@@ocaml.doc " Terminate prematurely the currently executing thread. "]

[@@@ocaml.text
  " This has been deliberately removed from the interface because it is an inherently\n\
  \    unsafe operation and is never required.\n\n\
  \    {[\n\
  \      (** Terminate prematurely the thread whose handle is given.\n\
  \          This functionality is available only with bytecode-level threads. *)\n\
  \      val kill : t -> unit\n\
  \    ]}\n"]

[@@@ocaml.text " {6 Suspending threads} "]

val delay : float -> unit
[@@ocaml.doc
  " [delay d] suspends the execution of the calling thread for\n\
  \    [d] seconds. The other program threads continue to run during\n\
  \    this time. "]

val join : t -> unit
[@@ocaml.doc
  " [join th] suspends the execution of the calling thread\n\
  \    until the thread [th] has terminated. "]

val wait_timed_read : Unix.file_descr -> float -> bool
[@@ocaml.doc " See {!Thread.wait_timed_write}."]

val wait_timed_write : Unix.file_descr -> float -> bool
[@@ocaml.doc
  " Same as {!Thread.wait_read} and {!Thread.wait_write}, but wait for at most\n\
  \    the amount of time given as second argument (in seconds).\n\
  \    Return [true] if the file descriptor is ready for input/output\n\
  \    and [false] if the timeout expired. "]

val yield : unit -> unit
[@@ocaml.doc
  " Re-schedule the calling thread without suspending it.\n\
  \    This function can be used to give scheduling hints,\n\
  \    telling the scheduler that now is a good time to\n\
  \    switch to other threads. "]

[@@@ocaml.text " {6 Management of signals} "]

[@@@ocaml.text
  " Signal handling follows the POSIX thread model: signals generated\n\
  \    by a thread are delivered to that thread; signals generated externally\n\
  \    are delivered to one of the threads that does not block it.\n\
  \    Each thread possesses a set of blocked signals, which can be modified\n\
  \    using {!Thread.sigmask}.  This set is inherited at thread creation time.\n\
  \    Per-thread signal masks are supported only by the system thread library\n\
  \    under Unix, but not under Win32, nor by the VM thread library. "]

val sigmask : Signal_unix.sigprocmask_command -> Signal.t list -> Signal.t list
[@@ocaml.doc
  " [sigmask cmd sigs] changes the set of blocked signals for the\n\
  \    calling thread.\n\
  \    If [cmd] is [`Set], blocked signals are set to those in\n\
  \    the list [sigs].\n\
  \    If [cmd] is [`Block], the signals in [sigs] are added to\n\
  \    the set of blocked signals.\n\
  \    If [cmd] is [`Unblock], the signals in [sigs] are removed\n\
  \    from the set of blocked signals.\n\
  \    [sigmask] returns the set of previously blocked signals for the thread. "]

val wait_signal : Signal.t list -> int
[@@ocaml.doc
  " [wait_signal sigs] suspends the execution of the calling thread\n\
  \    until the process receives one of the signals specified in the\n\
  \    list [sigs].  It then returns the number of the signal received.\n\
  \    Signal handlers attached to the signals in [sigs] will not\n\
  \    be invoked.  The signals [sigs] are expected to be blocked before\n\
  \    calling [wait_signal]. "]

[@@@ocaml.text " Jane Street extensions "]

val threads_have_been_created : unit -> bool
[@@ocaml.doc
  " [true] iff Thread.create has ever been called, even if there is\n\
  \    currently only one running thread. "]

val num_threads : unit -> int option
[@@ocaml.doc
  " [num_threads ()] attempts to return the number of currently running\n\
  \    threads by parsing /proc.  Since this is an operation frought with\n\
  \    potential failure, we return an option in cases of failure "]

val block_forever : unit -> 'a
[@@ocaml.doc " [block_forever ()] will block the calling thread forever. "]

[@@@ocaml.text
  " {2 Non-portable pthread extensions}\n\n\
  \    The following operations may not be supported on all platforms. Before you\n\
  \    can use them, you must first check that they do not contain error values.\n\
  \    For example, if you wanted to use [setaffinity_self_exn] then you would\n\
  \    first do:\n\n\
  \    {[\n\
  \      let setaffinity_self_exn =\n\
  \        match Thread.setaffinity_self_exn with\n\
  \        | Ok f -> f\n\
  \        | Error err -> (* raise or provide a default implementation. *)\n\
  \    ]}\n\n\
  \    If your application requires that one of these operations be present then,\n\
  \    you could just do this instead:\n\n\
  \    {[\n\
  \      let setaffinity_self_exn = Or_error.ok_exn Thread.setaffinity_self_exn\n\
  \    ]}\n"]

val setaffinity_self_exn : (Int.Set.t -> unit) Or_error.t
[@@ocaml.doc
  " Sets the core affinity of the currently-running thread to the set\n\
  \    specified.\n\n\
  \    This function is implemented using [pthread_setaffinity_np(3)], when\n\
  \    available. See the man page for situations when this function may return an\n\
  \    error, and therefore raise. "]

val getaffinity_self_exn : (unit -> Int.Set.t) Or_error.t
[@@ocaml.doc
  " Gets the core affinity of the currently-running thread.\n\n\
  \    This function is implemented using [pthread_getaffinity_np(3)], when\n\
  \    available. See the man page for situations when this function may return an\n\
  \    error, and therefore raise. "]

module For_testing : sig
  val create_should_raise : bool ref
  [@@ocaml.doc
    " If [!create_should_raise = true], then [create] raises rather than creating a\n\
    \      thread.  This is useful for testing how code behaves upon thread-creation\n\
    \      failure, which can happen, e.g., due to lack of memory. "]
end
