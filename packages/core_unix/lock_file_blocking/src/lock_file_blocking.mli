[@@@ocaml.text
  " Mutual exclusion between processes using flock and lockf.  A file is considered locked\n\
  \    only if both of these mechanisms work.\n\n\
  \    These locks are advisory, meaning that they will not work with systems that don't \
   also\n\
  \    try to acquire the matching locks. Although lockf can work across systems (and, \
   in our\n\
  \    environment, does work across Linux systems), it is not guaranteed to do so \
   across all\n\
  \    implementations.\n"]

open! Core

val create
  :  ?message:string
  -> ?close_on_exec:(bool[@ocaml.doc " defaults to true "])
  -> ?unlink_on_exit:(bool[@ocaml.doc " defaults to false "])
  -> string
  -> bool
[@@ocaml.doc
  " [create ?close_on_exec ?message path] tries to create a file at [path] containing the\n\
  \    text [message], which defaults to the pid of the locking process.  It returns \
   true on\n\
  \    success, false on failure.\n\n\
  \    Note: there is no way to release the lock or the fd created inside!  It will only \
   be\n\
  \    released when the process dies. If [close_on_exec] is [false], then the lock will \
   not\n\
  \    be released until children created via fork and exec also terminate. If not \
   specified,\n\
  \    [close_on_exec=true].\n\n\
  \    Note that by default, the lock file is not cleaned up for you when the process\n\
  \    exits. If you pass [unlink_on_exit:true], an [at_exit] handler will be set up to\n\
  \    remove the lock file on program termination.\n\n\
  \    The lock file is created with mode 664, so will not be world-writable even with\n\
  \    umask 0. "]

val create_exn
  :  ?message:string
  -> ?close_on_exec:(bool[@ocaml.doc " defaults to true "])
  -> ?unlink_on_exit:(bool[@ocaml.doc " defaults to false "])
  -> string
  -> unit
[@@ocaml.doc
  " [create_exn ?message path] is like [create] except that it throws an exception on\n\
  \    failure instead of returning a boolean value. "]

val blocking_create
  :  ?max_retry_delay:
       (Time_float.Span.t[@ocaml.doc " defaults to [min(300ms, timeout / 3)] "])
  -> ?random:
       (Random.State.t Lazy.t
       [@ocaml.doc " defaults to a system-dependent low-entropy seed "])
  -> ?timeout:(Time_float.Span.t[@ocaml.doc " defaults to wait indefinitely "])
  -> ?message:string
  -> ?close_on_exec:(bool[@ocaml.doc " defaults to true "])
  -> ?unlink_on_exit:(bool[@ocaml.doc " defaults to false "])
  -> string
  -> unit
[@@ocaml.doc
  " [blocking_create t] tries to create the lock. If another process holds the lock this\n\
  \    function will retry periodically until it is released or until [timeout] expires. \
   The\n\
  \    delay between retries is chosen uniformly at random between 0 and \
   [max_retry_delay].\n"]

val is_locked : string -> bool
[@@ocaml.doc
  " [is_locked path] returns [true] when the file at [path] exists and is locked, [false]\n\
  \    otherwise. Requires write permission for the lock file. "]

val get_pid : string -> Pid.t option
[@@ocaml.doc
  " [get_pid path] reads the lock file at [path] and returns the pid in the file.  Returns\n\
  \    [None] if the file cannot be read, or if the file contains a message that is not an\n\
  \    int. "]

module Nfs : sig
  val create : ?message:string -> string -> unit Or_error.t
  [@@ocaml.doc
    " [create ?message path] tries to create and lock the file at [path] by creating a\n\
    \      hard link to [path].nfs_lock. The contents of [path] will be replaced with a \
     sexp\n\
    \      containing the caller's hostname and pid, and the optional [message].\n\n\
    \      Efforts will be made to release this lock when the calling program exits. But \
     there\n\
    \      is no guarantee that this will occur under some types of program crash. If the\n\
    \      program crashes without removing the lock file an attempt will be made to \
     clean up\n\
    \      on restart by checking the hostname and pid stored in the lockfile.\n\
    \  "]

  val create_exn : ?message:string -> string -> unit
  [@@ocaml.doc
    " [create_exn ?message path] is like [create], but throws an exception when it fails\n\
    \      to obtain the lock. "]

  val blocking_create : ?timeout:Time_float.Span.t -> ?message:string -> string -> unit
  [@@ocaml.doc
    " [blocking_create ?message path] is like [create], but sleeps for a short while\n\
    \      between lock attempts and does not return until it succeeds or [timeout] \
     expires.\n\
    \      Timeout defaults to wait indefinitely. "]

  val critical_section
    :  ?message:string
    -> string
    -> timeout:Time_float.Span.t
    -> f:(unit -> 'a)
    -> 'a
  [@@ocaml.doc
    " [critical_section ?message ~timeout path ~f] wraps function [f] (including\n\
    \      exceptions escaping it) by first locking (using {!blocking_create}) and then\n\
    \      unlocking the given lock file. "]

  val get_hostname_and_pid : string -> (string * Pid.t) option
  [@@ocaml.doc
    " [get_hostname_and_pid path] reads the lock file at [path] and returns the hostname\n\
    \      and path in the file.  Returns [None] if the file cannot be read. "]

  val get_message : string -> string option
  [@@ocaml.doc
    " [get_message path] reads the lock file at [path] and returns the message in the\n\
    \      file.  Returns [None] if the file cannot be read. "]

  val unlock_exn : string -> unit
  [@@ocaml.doc
    " [unlock_exn path] unlocks [path] if [path] was locked from the same host and the pid\n\
    \      in the file is either the current pid or not the pid of a running process.\n\n\
    \      It will raise if for some reason the lock at the given path cannot be \
     unlocked, for\n\
    \      example if the lock is taken by somebody else that is still alive on the same \
     box,\n\
    \      or taken by a process on a different host, or if there are Unix permissions \
     issues,\n\
    \      etc.\n\n\
    \      This function should be used only by programs that need to release their lock \
     before\n\
    \      exiting. If releasing the lock can or should wait till the end of the running\n\
    \      process, do not call this function -- this library already takes care of \
     releasing\n\
    \      at exit all the locks taken. "]

  val unlock : string -> unit Or_error.t
end
[@@ocaml.doc
  " An implementation-neutral NFS lock file scheme that relies on the atomicity of link\n\
  \    over NFS.  Rather than relying on a working traditional advisory lock system over \
   NFS,\n\
  \    we create a hard link between the file given to the [create] call and a new file\n\
  \    <filename>.nfs_lock.  This link call is atomic (in that it succeeds or fails) \
   across\n\
  \    all systems that have the same filesystem mounted.  The link file must be cleaned \
   up\n\
  \    on program exit (normally accomplished by an [at_exit] handler, but see caveats\n\
  \    below).\n\n\
  \    There are a few caveats compared to local file locks:\n\n\
  \    - These calls require the locker to have write access to the directory containing \
   the\n\
  \      file being locked.\n\n\
  \    - Unlike a normal flock call the lock may not be removed when the calling program\n\
  \      exits (in particular if it is killed with SIGKILL).\n\n\
  \    - NFS lock files are non-standard and difficult to reason about.  This \
   implementation\n\
  \      strives to strike a balance between safety and utility in the common case:\n\
  \      {ul\n\
  \      {li one program per machine}\n\
  \      {li one shared user running the program}\n\
  \      }\n\n\
  \    Use cases outside of this may push on/break assumptions used for easy lock\n\
  \    cleanup/taking and may lead to double-taking the lock.  If you have such an odd use\n\
  \    case you should test it carefully/consider a different locking mechanism.\n\n\
  \    Specific known bugs:\n\n\
  \    - Safety bug: if there are two instances running on the same machine,\n\
  \      stale lock clean-up mechanism can remove a non-stale lock so the lock ends up\n\
  \      taken twice.\n\n\
  \    - Liveness bug: a process can write its hostname*pid information to the void\n\
  \      upon taking the lock, so you may end up with a broken (empty) lock file, which\n\
  \      needs manual clean-up afterwards.\n\
  \      (it seems that for this to happen another process needs to take and release the \
   lock\n\
  \      in quick succession)\n"]

module Mkdir : sig
  type t

  val lock_exn : lock_path:string -> [ `We_took_it of t | `Somebody_else_took_it ]
  [@@ocaml.doc
    " Raises an exception if the [mkdir] system call fails for any reason other than\n\
    \      [EEXIST]. "]

  val unlock_exn : t -> unit
  [@@ocaml.doc " Raises an exception if the [rmdir] system call fails. "]
end
[@@ocaml.doc
  " This is the dumbest lock imaginable: we [mkdir] to lock and [rmdir] to unlock.\n\
  \    This gives you pretty good mutual exclusion, but it makes you vulnerable to\n\
  \    stale locks. "]

module Symlink : sig
  type t

  val lock_exn
    :  lock_path:string
    -> metadata:string
    -> [ `We_took_it of t | `Somebody_else_took_it of string Or_error.t ]
  [@@ocaml.doc
    " [metadata] should include some information to help the user identify\n\
    \      the lock holder. Usually it's the pid of the holder, but if you use this\n\
    \      across a fork or take the lock multiple times in the same program,\n\
    \      then some extra information could be useful.\n\
    \      This string will be saved as the target of a (usually dangling) symbolic link\n\
    \      at path [lock_path].\n\n\
    \      [`Somebody_else_took_it] returns the metadata of the process who took it\n\
    \      or an error if that can't be determined (for example: they released the lock \
     by the\n\
    \      time we tried to inspect it)\n\n\
    \      Raises an exception if taking the lock fails for any reason other than somebody\n\
    \      else holding the lock.\n\
    \  "]

  val unlock_exn : t -> unit
end
[@@ocaml.doc
  " This is a bit better than [Mkdir] and is very likely to be compatible: it lets you\n\
  \    atomically write the owner of the lock into the symlink, it's used both by emacs \
   and\n\
  \    hg, and it's supposed to work on nfs. "]

module Flock : sig
  type t

  val lock_exn
    :  ?lock_owner_uid:int
    -> ?exclusive:bool
    -> ?close_on_exec:bool
    -> unit
    -> lock_path:string
    -> [ `We_took_it of t | `Somebody_else_took_it ]
  [@@ocaml.doc
    " Raises an exception if taking the lock fails for any reason other than somebody else\n\
    \      holding the lock. Optionally sets the lock owner to [lock_owner_uid]. "]

  val unlock_exn : t -> unit
  [@@ocaml.doc " Raises an exception if this lock was already unlocked earlier. "]
end
[@@ocaml.doc
  " This just uses [flock].\n\
  \    The main reason this module exists is that [create] won't let you release locks,\n\
  \    so we need a new interface.\n\n\
  \    Another difference is that implementation is simpler because it omits some of\n\
  \    the features, such as\n\n\
  \    1. Unlinking on exit.\n\
  \    That seems unsafe. Consider the following scenario:\n\
  \    - both a and b create and open the file\n\
  \    - a locks, unlinks and unlocks it\n\
  \    - b locks and stays in critical section\n\
  \    - c finds that there is no file, creates a new one, locks it and enters\n\
  \      critical section\n\
  \      You end up with b and c in the critical section together!\n\n\
  \    2. Writing pid or message in the file.\n\
  \    The file is shared between multiple processes so this feature seems hard to\n\
  \    think about, and it already led to weird code. Let's just remove it.\n\
  \    You can still find who holds the file open by inspecting output of [lsof]. "]
