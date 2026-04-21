open! Import

type t = Mutex.t

val create : unit -> t
val equal : t -> t -> bool

val lock : t -> unit
[@@ocaml.doc
  " [lock mtx] locks [mtx], possibly waiting for it to be released\n\
  \    first by another thread.\n\n\
  \    @raise Unix_error if [lock] attempts to acquire [mtx] recursively.\n"]

val try_lock : t -> [ `Already_held_by_me_or_other | `Acquired ]
[@@ocaml.doc
  " [try_lock] is like [lock], but always returns immediately.  If the calling thread or\n\
  \    another one already has the mutex it returns [`Already_held_by_me_or_other], \
   otherwise\n\
  \    it locks it and returns [`Acquired]. "]

val unlock : t -> unit
[@@ocaml.doc
  " [unlock mtx] unlocks [mtx].\n\n\
  \    @raise Unix_error if [unlock] attempts to release an unacquired\n\
  \    mutex or a mutex held by another thread.\n"]

val critical_section : t -> f:(unit -> 'a) -> 'a
[@@ocaml.doc
  " [critical_section t ~f] locks [t], runs [f], unlocks [t], and returns the result of\n\
  \    [f] (or raises if [f] raised). "]

val synchronize : ('a -> 'b) -> 'a -> 'b
[@@ocaml.doc
  " [synchronize f] creates a mutex and returns a new function that is identical to [f]\n\
  \    except that the mutex is held during its execution. "]

val update_signal : t -> Condition.t -> f:(unit -> 'a) -> 'a
[@@ocaml.doc
  " [update_signal mtx cnd ~f] updates some state within a critical\n\
  \    section protected by mutex [mtx] using function [f] and signals\n\
  \    condition variable [cnd] after finishing.  If [f] raises an exception,\n\
  \    the condition will NOT be signaled! "]

val update_broadcast : t -> Condition.t -> f:(unit -> 'a) -> 'a
[@@ocaml.doc
  " [update_broadcast mtx cnd ~f] updates some state within a critical\n\
  \    section protected by mutex [mtx] using function [f] and broadcasts\n\
  \    condition variable [cnd] after finishing.  If [f] raises an exception,\n\
  \    the condition will NOT be broadcast! "]
