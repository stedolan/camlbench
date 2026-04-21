[@@@ocaml.text
  " A nano-mutex is a lightweight mutex that can be used only within a single OCaml\n\
  \    runtime.\n\n\
  \    {2 Performance}\n\n\
  \    Nano-mutexes are intended to be significantly cheaper than OS-level mutexes.  \
   Creating\n\
  \    a nano-mutex allocates a single OCaml record.  Locking and unlocking an uncontested\n\
  \    nano-mutex each take a handful of instructions.  Only if a nano-mutex is contested\n\
  \    will it fall back to using an OS-level mutex.  If a nano-mutex becomes uncontested\n\
  \    again, it will switch back to using an OCaml-only lock.\n\n\
  \    Nano-mutexes can be faster than using OS-level mutexes because OCaml uses a global\n\
  \    lock on the runtime, and requires all running OCaml code to hold the lock.  The \
   OCaml\n\
  \    compiler only allows thread switches at certain points, and we can use that fact to\n\
  \    get the atomic test-and-set used in the core of our implementation without \
   needing any\n\
  \    primitive locking, essentially because we're protected by the OCaml global lock.\n\n\
  \    Here are some benchmarks comparing various mutexes available in OCaml\n\
  \    (run in 2020-03):\n\n\
  \    {v\n\
  \      |----------------------------------+----------+---------|\n\
  \      | Name                             | Time/Run | mWd/Run |\n\
  \      |----------------------------------+----------+---------|\n\
  \      | Caml_threads.Mutex create        | 42.1 ns  | 3.00w   |\n\
  \      | Caml_threads.Mutex lock/unlock   | 23.6 ns  |         |\n\
  \      | Error_checking_mutex create      | 47.2 ns  | 3.00w   |\n\
  \      | Error_checking_mutex lock/unlock | 25.6 ns  |         |\n\
  \      | Nano_mutex create                | 4.4 ns   | 4.00w   |\n\
  \      | Nano_mutex lock/unlock           | 12.3 ns  |         |\n\
  \      |----------------------------------+----------+---------|\n\
  \    v}\n\n\
  \    The benchmark code is in core/extended/lib_test/bench_nano_mutex.ml.\n\n\
  \    {2 Error handling}\n\n\
  \    For any mutex, there are design choices as to how to behave in certain \
   situations:\n\n\
  \    - recursive locking (when a thread locks a mutex it already has)\n\
  \    - unlocking an unlocked mutex\n\
  \    - unlocking a mutex held by another thread\n\n\
  \    Here is a table comparing how the various mutexes behave:\n\n\
  \    {v\n\
  \      |--------------------+--------------------+----------------------+------------|\n\
  \      |                    | Caml_threads.Mutex | Error_checking_mutex | Nano_mutex |\n\
  \      |--------------------+--------------------+----------------------+------------|\n\
  \      | recursive lock     | undefined          | error                | error      |\n\
  \      | unlocking unlocked | undefined          | error                | error      |\n\
  \      | t1:lock  t2:unlock | undefined          | error                | error      |\n\
  \      |--------------------+--------------------+----------------------+------------|\n\
  \    v}\n"]

open! Core
open! Import

type t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val invariant : t -> unit

val create : unit -> t [@@ocaml.doc " [create ()] returns a new, unlocked mutex. "]

val equal : t -> t -> bool [@@ocaml.doc " [equal] is [phys_equal] "]

val current_thread_has_lock : t -> bool
[@@ocaml.doc
  " [current_thread_has_lock t] returns [true] iff the current thread has [t] locked. "]

val lock : t -> unit Or_error.t
[@@ocaml.doc
  " [lock t] locks the mutex [t], blocking until it can be locked.  [lock] immediately\n\
  \    returns [Error] if the current thread already holds [t]. "]

val lock_exn : t -> unit

val try_lock : t -> [ `Acquired | `Not_acquired ] Or_error.t
[@@ocaml.doc
  " [try_lock t] locks [t] if it can immediately do so.  The result indicates whether\n\
  \    [try_lock] succeeded in acquiring the lock.  [try_lock] returns [Error] if the \
   current\n\
  \    thread already holds [t]. "]

val try_lock_exn : t -> [ `Acquired | `Not_acquired ]

val unlock : t -> unit Or_error.t
[@@ocaml.doc
  " [unlock t] unlocks [t], if the current thread holds it.  [unlock] returns [Error] if\n\
  \    the lock is not held by the calling thread. "]

val unlock_exn : t -> unit
val critical_section : t -> f:(unit -> 'a) -> 'a
