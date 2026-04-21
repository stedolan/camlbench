[@@@ocaml.text
  " This file is a modified version of unixLabels.mli from the OCaml distribution. Many of\n\
  \    these functions raise exceptions but do not have a _exn suffixed name. "]

open! Core
open! Import

module File_descr = File_descr [@@ocaml.doc " File descriptor. "]

[@@@ocaml.text " {6 Error report} "]

type error = Unix.error =
  | E2BIG
  | EACCES
  | EAGAIN
  | EBADF
  | EBUSY
  | ECHILD
  | EDEADLK
  | EDOM
  | EEXIST
  | EFAULT
  | EFBIG
  | EINTR
  | EINVAL
  | EIO
  | EISDIR
  | EMFILE
  | EMLINK
  | ENAMETOOLONG
  | ENFILE
  | ENODEV
  | ENOENT
  | ENOEXEC
  | ENOLCK
  | ENOMEM
  | ENOSPC
  | ENOSYS
  | ENOTDIR
  | ENOTEMPTY
  | ENOTTY
  | ENXIO
  | EPERM
  | EPIPE
  | ERANGE
  | EROFS
  | ESPIPE
  | ESRCH
  | EXDEV
  | EWOULDBLOCK
  | EINPROGRESS
  | EALREADY
  | ENOTSOCK
  | EDESTADDRREQ
  | EMSGSIZE
  | EPROTOTYPE
  | ENOPROTOOPT
  | EPROTONOSUPPORT
  | ESOCKTNOSUPPORT
  | EOPNOTSUPP
  | EPFNOSUPPORT
  | EAFNOSUPPORT
  | EADDRINUSE
  | EADDRNOTAVAIL
  | ENETDOWN
  | ENETUNREACH
  | ENETRESET
  | ECONNABORTED
  | ECONNRESET
  | ENOBUFS
  | EISCONN
  | ENOTCONN
  | ESHUTDOWN
  | ETOOMANYREFS
  | ETIMEDOUT
  | ECONNREFUSED
  | EHOSTDOWN
  | EHOSTUNREACH
  | ELOOP
  | EOVERFLOW
  | EUNKNOWNERR of int
[@@deprecated "[since 2016-10] use [Unix.Error.t] instead"]

val sexp_of_error : Unix.error -> Sexp.t
[@@deprecated "[since 2016-10] use [Unix.Error.t] instead"]

val error_of_sexp : Sexp.t -> Unix.error
[@@deprecated "[since 2016-10] use [Unix.Error.t] instead"]

module Error : sig
  type t = Unix.error =
    | E2BIG [@ocaml.doc " Argument list too long "]
    | EACCES [@ocaml.doc " Permission denied "]
    | EAGAIN [@ocaml.doc " Resource temporarily unavailable; try again "]
    | EBADF [@ocaml.doc " Bad file descriptor "]
    | EBUSY [@ocaml.doc " Resource unavailable "]
    | ECHILD [@ocaml.doc " No child process "]
    | EDEADLK [@ocaml.doc " Resource deadlock would occur "]
    | EDOM [@ocaml.doc " Domain error for math functions, etc. "]
    | EEXIST [@ocaml.doc " File exists "]
    | EFAULT [@ocaml.doc " Bad address "]
    | EFBIG [@ocaml.doc " File too large "]
    | EINTR [@ocaml.doc " Function interrupted by signal "]
    | EINVAL [@ocaml.doc " Invalid argument "]
    | EIO [@ocaml.doc " Hardware I/O error "]
    | EISDIR [@ocaml.doc " Is a directory "]
    | EMFILE [@ocaml.doc " Too many open files by the process "]
    | EMLINK [@ocaml.doc " Too many links "]
    | ENAMETOOLONG [@ocaml.doc " Filename too long "]
    | ENFILE [@ocaml.doc " Too many open files in the system "]
    | ENODEV [@ocaml.doc " No such device "]
    | ENOENT [@ocaml.doc " No such file or directory "]
    | ENOEXEC [@ocaml.doc " Not an executable file "]
    | ENOLCK [@ocaml.doc " No locks available "]
    | ENOMEM [@ocaml.doc " Not enough memory "]
    | ENOSPC [@ocaml.doc " No space left on device "]
    | ENOSYS [@ocaml.doc " Function not supported "]
    | ENOTDIR [@ocaml.doc " Not a directory "]
    | ENOTEMPTY [@ocaml.doc " Directory not empty "]
    | ENOTTY [@ocaml.doc " Inappropriate I/O control operation "]
    | ENXIO [@ocaml.doc " No such device or address "]
    | EPERM [@ocaml.doc " Operation not permitted "]
    | EPIPE [@ocaml.doc " Broken pipe "]
    | ERANGE [@ocaml.doc " Result too large "]
    | EROFS [@ocaml.doc " Read-only file system "]
    | ESPIPE [@ocaml.doc " Invalid seek e.g. on a pipe "]
    | ESRCH [@ocaml.doc " No such process "]
    | EXDEV [@ocaml.doc " Invalid link "]
    | EWOULDBLOCK [@ocaml.doc " Operation would block "]
    | EINPROGRESS [@ocaml.doc " Operation now in progress "]
    | EALREADY [@ocaml.doc " Operation already in progress "]
    | ENOTSOCK [@ocaml.doc " Socket operation on non-socket "]
    | EDESTADDRREQ [@ocaml.doc " Destination address required "]
    | EMSGSIZE [@ocaml.doc " Message too long "]
    | EPROTOTYPE [@ocaml.doc " Protocol wrong type for socket "]
    | ENOPROTOOPT [@ocaml.doc " Protocol not available "]
    | EPROTONOSUPPORT [@ocaml.doc " Protocol not supported "]
    | ESOCKTNOSUPPORT [@ocaml.doc " Socket type not supported "]
    | EOPNOTSUPP [@ocaml.doc " Operation not supported on socket "]
    | EPFNOSUPPORT [@ocaml.doc " Protocol family not supported "]
    | EAFNOSUPPORT [@ocaml.doc " Address family not supported by protocol family "]
    | EADDRINUSE [@ocaml.doc " Address already in use "]
    | EADDRNOTAVAIL [@ocaml.doc " Can't assign requested address "]
    | ENETDOWN [@ocaml.doc " Network is down "]
    | ENETUNREACH [@ocaml.doc " Network is unreachable "]
    | ENETRESET [@ocaml.doc " Network dropped connection on reset "]
    | ECONNABORTED [@ocaml.doc " Software caused connection abort "]
    | ECONNRESET [@ocaml.doc " Connection reset by peer "]
    | ENOBUFS [@ocaml.doc " No buffer space available "]
    | EISCONN [@ocaml.doc " Socket is already connected "]
    | ENOTCONN [@ocaml.doc " Socket is not connected "]
    | ESHUTDOWN [@ocaml.doc " Can't send after socket shutdown "]
    | ETOOMANYREFS [@ocaml.doc " Too many references: can't splice "]
    | ETIMEDOUT [@ocaml.doc " Connection timed out "]
    | ECONNREFUSED [@ocaml.doc " Connection refused "]
    | EHOSTDOWN [@ocaml.doc " Host is down "]
    | EHOSTUNREACH [@ocaml.doc " No route to host "]
    | ELOOP [@ocaml.doc " Too many levels of symbolic links "]
    | EOVERFLOW [@ocaml.doc " File size or position not representable "]
    | EUNKNOWNERR of int [@ocaml.doc " Unknown error "]
  [@@ocaml.doc
    " The type of error codes.  Errors defined in the POSIX standard and additional\n\
    \      errors, mostly BSD.  All other errors are mapped to [EUNKNOWNERR]. "]
  [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val of_system_int : errno:int -> t

  val message : t -> string
  [@@ocaml.doc " Return a string describing the given error code. "]

  [@@@ocaml.text "/*"]

  module Private : sig
    val to_errno : t -> int
  end
end

exception
  Unix_error of Error.t * string * string
      [@ocaml.doc
        " Raised by the system calls below when an error is encountered.\n\
        \    The first component is the error code; the second component\n\
        \    is the function name; the third component is the string parameter\n\
        \    to the function, if it has one, or the empty string otherwise. "]

module Syscall_result : module type of Syscall_result with type 'a t = 'a Syscall_result.t

val unix_error : int -> string -> string -> _
[@@ocaml.doc " @raise Unix_error with a given errno, function name and argument "]

val error_message : Error.t -> string
[@@deprecated "[since 2016-10] use [Unix.Error.message] instead"]

val handle_unix_error : (unit -> 'a) -> 'a
[@@ocaml.doc
  " [handle_unix_error f] runs [f ()] and returns the result.  If the exception\n\
  \    [Unix_error] is raised, it prints a message describing the error and exits with \
   code\n\
  \    2. "]

val retry_until_no_eintr : (unit -> 'a) -> 'a
[@@ocaml.doc
  " [retry_until_no_eintr f] returns [f ()] unless [f ()] fails with [EINTR]; in which\n\
  \    case [f ()] is run again until it raises a different error or returns a value. "]

module Private : sig
  val sexp_to_string_hum : Sexp.t -> string
  [@@ocaml.doc
    " [sexp_to_string_hum] formats the sexp as a human readable string. Used to\n\
    \      prettify syscall arguments and attach them to the [Unix_error] in case it \
     fails.\n\n\
    \      The reason to expose this function is to make it easy for alternative\n\
    \      implementations of these functions to produce error messages in the same \
     format. "]
end

[@@@ocaml.text
  " {6 Access to the process environment}\n\n\
  \    If you're looking for [getenv], that's in the Sys module. "]

val environment : unit -> string array
[@@ocaml.doc
  " Return the process environment, as an array of strings\n\
  \    with the format ``variable=value''.  The returned array\n\
  \    is empty if the process has special privileges. "]

val putenv : key:string -> data:string -> unit
[@@ocaml.doc
  " [Unix.putenv ~key ~data] sets the value associated to a\n\
  \    variable in the process environment.\n\
  \    [key] is the name of the environment variable,\n\
  \    and [data] its new associated value. "]

val unsetenv : string -> unit
[@@ocaml.doc
  " [unsetenv name] deletes the variable [name] from the environment.\n\n\
  \    EINVAL [name] contained an \226\128\153=\226\128\153 or an '\\000' character. "]

[@@@ocaml.text " {6 Process handling} "]

module Exit : sig
  type error = [ `Exit_non_zero of int ] [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val compare_error : error -> (error[@merlin.hide]) -> int
    val sexp_of_error : error -> Sexplib0.Sexp.t
    val error_of_sexp : Sexplib0.Sexp.t -> error
    val __error_of_sexp__ : Sexplib0.Sexp.t -> error
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string_hum : t -> string
  val code : t -> int
  val of_code : int -> t
  val or_error : t -> unit Or_error.t
end
[@@ocaml.doc " The termination status of a process. "]

module Exit_or_signal : sig
  type error =
    [ Exit.error
    | `Signal of Signal.t
    ]
  [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val compare_error : error -> (error[@merlin.hide]) -> int
    val sexp_of_error : error -> Sexplib0.Sexp.t
    val error_of_sexp : Sexplib0.Sexp.t -> error
    val __error_of_sexp__ : Sexplib0.Sexp.t -> error
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val of_unix : Unix.process_status -> t
  [@@ocaml.doc
    " [of_unix] assumes that any signal numbers in the incoming value are OCaml internal\n\
    \      signal numbers. "]

  val to_string_hum : t -> string
  val or_error : t -> unit Or_error.t
end

module Exit_or_signal_or_stop : sig
  type error =
    [ Exit_or_signal.error
    | `Stop of Signal.t
    ]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_error : error -> Sexplib0.Sexp.t
    val error_of_sexp : Sexplib0.Sexp.t -> error
    val __error_of_sexp__ : Sexplib0.Sexp.t -> error
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val of_unix : Unix.process_status -> t
  [@@ocaml.doc
    " [of_unix] assumes that any signal numbers in the incoming value are OCaml internal\n\
    \      signal numbers. "]

  val to_string_hum : t -> string
  val or_error : t -> unit Or_error.t
end

module Env : sig
  type t =
    [ `Replace of (string * string) list
    | `Extend of (string * string) list
    | `Override of (string * string option) list
    | `Replace_raw of string list
    ]
  [@@ocaml.doc
    " [t] is used to control the environment of a child process, and can take four forms.\n\
    \      [`Replace_raw] replaces the entire environment with strings in the Unix \
     style, like\n\
    \      [\"VARIABLE_NAME=value\"].  [`Replace] has the same effect as [`Replace_raw], \
     but using\n\
    \      bindings represented as [\"VARIABLE_NAME\", \"value\"].  [`Extend] adds \
     entries to the\n\
    \      existing environment rather than replacing the whole environment. [`Override] \
     is\n\
    \      similar to [`Extend] but allows unsetting variables too.\n\n\
    \      If [env] contains multiple bindings for the same variable, the last takes \
     precedence.\n\
    \      In the case of [`Extend], bindings in [env] take precedence over the existing\n\
    \      environment. "]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val expand : ?base:string list Lazy.t -> t -> string list
  [@@ocaml.doc
    " [expand ?base t] returns the environment resulting from applying the changes\n\
    \      described by [t] on the given base environment, defaulting to current\n\
    \      environment. It can be useful to use the type [t] on functions that only take \
     the\n\
    \      full environment, like [Spawn.spawn] or [open_process_full]. It can also be\n\
    \      useful, when passing a base, to combine multiple [t] by applying them in \
     succession.\n\
    \  "]

  val expand_array : ?base:string list Lazy.t -> t -> string array
  [@@ocaml.doc " [expand_array t] is a shorthand for [Array.of_list (expand t)]. "]
end

type env = Env.t [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_env : env -> Sexplib0.Sexp.t
  val env_of_sexp : Sexplib0.Sexp.t -> env
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Pgid : sig
  type t
  [@@ocaml.doc
    " Only used when creating a process. If a value of this type is provided when creating\n\
    \      a process, the child will immediately set its pgid accordingly. "]

  val new_process_group : t
  [@@ocaml.doc
    " Sets the child's pgid to the same as its process id. Equivalent\n\
    \      to calling [setpgid(0, 0)]. "]

  val of_pid : int -> t
  [@@ocaml.doc " Raises [Invalid_arg] if the value is not strictly\n      positive. "]
end
[@@ocaml.doc " this module mirrors [Spawn.Pgid] "]

val exec
  :  prog:string
  -> argv:string list
  -> ?use_path:(bool[@ocaml.doc " default is [true] "])
  -> ?env:env
  -> unit
  -> never_returns
[@@ocaml.doc
  " [exec ~prog ~argv ?search_path ?env] execs [prog] with [argv].  If [use_path = true]\n\
  \    (the default) and [prog] doesn't contain a slash, then [exec] searches the [PATH]\n\
  \    environment variable for [prog].  If [env] is supplied, it determines the \
   environment\n\
  \    when [prog] is executed.\n\n\
  \    While not strictly necessary, by convention, the first element in [argv] should \
   be the\n\
  \    name of the file being executed, e.g.:\n\n\
  \    {[ exec ~prog ~argv:[ prog; arg1; arg2; ...] () ]}\n"]

val fork_exec
  :  prog:string
  -> argv:string list
  -> ?preexec_fn:(unit -> unit)
  -> ?use_path:(bool[@ocaml.doc " default is [true] "])
  -> ?env:env
  -> unit
  -> Pid.t
[@@ocaml.doc
  " [fork_exec ~prog ~argv ?preexec_fn ?use_path ?env ()] forks, calls [preexec_fn], and\n\
  \    then execs [prog] with [argv] in the child process, returning the child PID to the\n\
  \    parent. As in [exec], by convention, the 0th element in [argv] should be the \
   program\n\
  \    itself.\n\n\
  \    Since [preexec_fn] is invoked post-fork but pre-exec, it must:\n\
  \    - not allocate; and\n\
  \    - not call any async-signal-unsafe functions (see man 7 signal)\n\n\
  \    Violating these constraints may cause the program to deadlock or exhibit undefined\n\
  \    behavior. "]

val fork : unit -> [ `In_the_child | `In_the_parent of Pid.t ]
[@@ocaml.doc
  " [fork ()] forks a new process.  The return value indicates whether we are continuing\n\
  \    in the child or the parent, and if the parent, includes the child's process id. "]

[@@@ocaml.text
  " [wait{,_nohang,_untraced,_nohang_untraced} ?restart wait_on] is a family of functions\n\
  \    that wait on a process to exit (normally or via a signal) or be stopped by a signal\n\
  \    (if [untraced] is used).  The [wait_on] argument specifies which processes to \
   wait on.\n\
  \    The [nohang] variants return [None] immediately if none of the desired processes \
   has\n\
  \    exited yet.  If [nohang] is not used, [waitpid] will block until one of the desired\n\
  \    processes exits.\n\n\
  \    The non-nohang variants have a [restart] flag with (default true) that causes the\n\
  \    system call to be retried upon EAGAIN|EINTR.  The nohang variants do not have this\n\
  \    flag because they don't block. "]

type wait_on =
  [ `Any
  | `Group of Pid.t
  | `My_group
  | `Pid of Pid.t
  ]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_wait_on : wait_on -> Sexplib0.Sexp.t
  val wait_on_of_sexp : Sexplib0.Sexp.t -> wait_on
  val __wait_on_of_sexp__ : Sexplib0.Sexp.t -> wait_on
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val wait
  :  ?restart:(bool[@ocaml.doc " defaults to true "])
  -> wait_on
  -> Pid.t * Exit_or_signal.t

val wait_nohang : wait_on -> (Pid.t * Exit_or_signal.t) option

val wait_untraced
  :  ?restart:(bool[@ocaml.doc " defaults to true "])
  -> wait_on
  -> Pid.t * Exit_or_signal_or_stop.t

val wait_nohang_untraced : wait_on -> (Pid.t * Exit_or_signal_or_stop.t) option

val waitpid : Pid.t -> Exit_or_signal.t
[@@ocaml.doc
  " [waitpid pid] waits for child process [pid] to terminate, and returns its exit status.\n\
  \    [waitpid_exn] is like [waitpid], except it only returns if the child exits with \
   status\n\
  \    zero, and raises if the child terminates in any other way. "]

val waitpid_exn : Pid.t -> unit

val system : string -> Exit_or_signal.t
[@@ocaml.doc
  " Execute the given command, wait until it terminates, and return\n\
  \    its termination status. The string is interpreted by the shell\n\
  \    [/bin/sh] and therefore can contain redirections, quotes, variables,\n\
  \    etc. The result [WEXITED 127] indicates that the shell couldn't\n\
  \    be executed. "]

val getpid : unit -> Pid.t [@@ocaml.doc " Return the pid of the process. "]

val getppid : unit -> Pid.t option [@@ocaml.doc " Return the pid of the parent process. "]

val getppid_exn : unit -> Pid.t
[@@ocaml.doc
  " Return the pid of the parent process, if you're really sure\n\
  \    you're never going to be the init process.\n"]

val setpgid : of_:Pid.t -> to_:Pid.t -> unit
[@@ocaml.doc " Set process group ID of a process. "]

val getpgid : Pid.t -> Pid.t option
[@@ocaml.doc
  " Return process group ID of a process.\n\n\
  \    [None] means the pgid is zero, which cannot be represented as a [Pid.t]. This \
   happens\n\
  \    at least for kernel processes. See [ps -ejH] for examples.\n"]

module Thread_id : sig
  type t [@@deriving sexp_of, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t

  val to_int : t -> int
end

val gettid : (unit -> Thread_id.t) Or_error.t
[@@ocaml.doc
  " Get the numeric ID of the current thread, e.g. for identifying it in top(1). "]

val nice : int -> int
[@@ocaml.doc
  " Change the process priority. The integer argument is added to the\n\
  \    ``nice'' value. (Higher values of the ``nice'' value mean\n\
  \    lower priorities.) Return the new nice value. "]

[@@@ocaml.text " {6 Basic file input/output} "]

[@@@ocaml.text " The abstract type of file descriptors. "]

val stdin : File_descr.t [@@ocaml.doc " File descriptor for standard input."]

val stdout : File_descr.t [@@ocaml.doc " File descriptor for standard output."]

val stderr : File_descr.t [@@ocaml.doc " File descriptor for standard standard error. "]

[@@@ocaml.text " The flags to {!UnixLabels.openfile}. "]

type open_flag = Unix.open_flag =
  | O_RDONLY [@ocaml.doc " Open for reading "]
  | O_WRONLY [@ocaml.doc " Open for writing "]
  | O_RDWR [@ocaml.doc " Open for reading and writing "]
  | O_NONBLOCK [@ocaml.doc " Open in non-blocking mode "]
  | O_APPEND [@ocaml.doc " Open for append "]
  | O_CREAT [@ocaml.doc " Create if nonexistent "]
  | O_TRUNC [@ocaml.doc " Truncate to 0 length if existing "]
  | O_EXCL [@ocaml.doc " Fail if existing "]
  | O_NOCTTY [@ocaml.doc " Don't make this dev a controlling tty "]
  | O_DSYNC
  [@ocaml.doc " Writes complete as `Synchronised I/O data integrity completion' "]
  | O_SYNC
  [@ocaml.doc " Writes complete as `Synchronised I/O file integrity completion' "]
  | O_RSYNC [@ocaml.doc " Reads complete as writes (depending on O_SYNC/O_DSYNC) "]
  | O_SHARE_DELETE
  [@ocaml.doc " Windows only: allow the file to be deleted while still open "]
  | O_CLOEXEC
  [@ocaml.doc " Set the close-on-exec flag on the descriptor returned by {!openfile} "]
  | O_KEEPEXEC [@if ocaml_version >= (4, 05, 0)]

val open_flag_of_sexp : Sexp.t -> open_flag
[@@ocaml.doc
  " We can't use [with sexp] because pa_sexp inserts two copies of the [val] specs, which\n\
  \    leads to a spurious \"unused\" warning. "]

val sexp_of_open_flag : open_flag -> Sexp.t

type file_perm = int [@@ocaml.doc " file access rights "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_file_perm : file_perm -> Sexplib0.Sexp.t
  val file_perm_of_sexp : Sexplib0.Sexp.t -> file_perm
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val openfile : ?perm:file_perm -> mode:open_flag list -> string -> File_descr.t
[@@ocaml.doc
  " Open the named file with the given flags. Third argument is the permissions to give to\n\
  \    the file if it is created. Return a file descriptor on the named file. Default\n\
  \    permissions 0o644. "]

module Open_flags : sig
  type t
  [@@ocaml.doc
    " [Open_flags.t] represents the file access mode and file status flags flags\n\
    \      associated with a file description, as set by [openfile] and [fcntl_setfl],\n\
    \      and retrieved by [fcntl_getfl].\n\n\
    \      Since this type is not actually used by [openfile], many of the flags here are\n\
    \      meaningless. [creat], [excl], [trunc], [noctty] only make sense at\n\
    \      opening time, and can't be retrieved or configured with [fcntl].\n\n\
    \      We deliberately omit [cloexec] because [cloexec] actually isn't reported\n\
    \      by [fcntl_getfl].\n\
    \  "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Flags.S with type t := t

  val rdonly : t
  [@@ocaml.doc
    " access mode.\n\n\
    \      These three flags are not individual bits like flags usually are.  The access \
     mode\n\
    \      is represented by the lower two bits of the [Open_flags.t].  A particular\n\
    \      [Open_flags.t] should include exactly one access mode.  Combining different\n\
    \      [Open_flags.t]'s using flags operations (e.g [+]) is only sensible if they \
     have the\n\
    \      same access mode. "]

  val wronly : t
  val rdwr : t

  val creat : t [@@ocaml.doc " creation "]

  val excl : t
  val noctty : t
  val trunc : t
  val append : t
  val nonblock : t
  val dsync : t
  val sync : t
  val rsync : t
  val direct : t

  val can_read : t -> bool [@@ocaml.doc " [can_read t] iff [t] has [rdonly] or [rdwr] "]

  val can_write : t -> bool [@@ocaml.doc " [can_read t] iff [t] has [wronly] or [rdwr] "]
end

val fcntl_getfl : File_descr.t -> Open_flags.t
[@@ocaml.doc
  " [fcntl_getfl fd] gets the current flags for [fd] from the open-file-descriptor table\n\
  \    via the system call [fcntl(fd, F_GETFL)].  See \"man fcntl\". "]

val fcntl_setfl : File_descr.t -> Open_flags.t -> unit
[@@ocaml.doc
  " [fcntl_setfl fd flags] sets the flags for [fd] in the open-file-descriptor table via\n\
  \    the system call [fcntl(fd, F_SETFL, flags)].  See \"man fcntl\".  As per the \
   Linux man\n\
  \    page, on Linux this only allows [append], [async], [direct], [noatime], and \
   [nonblock]\n\
  \    to be set. "]

val close : ?restart:(bool[@ocaml.doc " defaults to false "]) -> File_descr.t -> unit
[@@ocaml.doc " Close a file descriptor. "]

val with_file
  :  ?perm:file_perm
  -> string
  -> mode:open_flag list
  -> f:(File_descr.t -> 'a)
  -> 'a
[@@ocaml.doc
  " [with_file file ~mode ~perm ~f] opens [file], and applies [f] to the resulting file\n\
  \    descriptor.  When [f] finishes (or raises), [with_file] closes the descriptor and\n\
  \    returns the result of [f] (or raises). "]

val read
  :  ?restart:(bool[@ocaml.doc " defaults to false "])
  -> ?pos:int
  -> ?len:int
  -> File_descr.t
  -> buf:Bytes.t
  -> int
[@@ocaml.doc
  " [read ~pos ~len fd ~buf] reads [len] bytes from descriptor [fd],\n\
  \    storing them in byte sequence [buf], starting at position [pos] in\n\
  \    [buf]. Return the number of bytes actually read. "]

val write : ?pos:int -> ?len:int -> File_descr.t -> buf:Bytes.t -> int
[@@ocaml.doc
  " [write ~pos ~len fd ~buf] writes [len] bytes to descriptor [fd],\n\
  \    taking them from byte sequence [buf], starting at position [pos]\n\
  \    in [buff]. Return the number of bytes actually written.\n\n\
  \    When an error is reported some characters might have already been\n\
  \    written.  Use [single_write] instead to ensure that this is not the\n\
  \    case.\n\n\
  \    WARNING: write is an interruptible call and has no way to handle\n\
  \    EINTR properly. You should most probably be using single write.\n"]

val write_substring : ?pos:int -> ?len:int -> File_descr.t -> buf:string -> int
[@@ocaml.doc " Same as [write] but with a string buffer. "]

val single_write
  :  ?restart:(bool[@ocaml.doc " defaults to false "])
  -> ?pos:int
  -> ?len:int
  -> File_descr.t
  -> buf:Bytes.t
  -> int
[@@ocaml.doc
  " Same as [write] but ensures that all errors are reported and\n\
  \    that no character has ever been written when an error is reported. "]

val single_write_substring
  :  ?restart:(bool[@ocaml.doc " defaults to false "])
  -> ?pos:int
  -> ?len:int
  -> File_descr.t
  -> buf:string
  -> int
[@@ocaml.doc " Same as [single_write] but with a string buffer. "]

[@@@ocaml.text " {6 Interfacing with the standard input/output library} "]

val in_channel_of_descr : File_descr.t -> In_channel.t
[@@ocaml.doc
  " Create an input channel reading from the given descriptor.\n\
  \    The channel is initially in binary mode; use\n\
  \    [set_binary_mode_in ic false] if text mode is desired. "]

val out_channel_of_descr : File_descr.t -> Out_channel.t
[@@ocaml.doc
  " Create an output channel writing on the given descriptor.\n\
  \    The channel is initially in binary mode; use\n\
  \    [set_binary_mode_out oc false] if text mode is desired. "]

val descr_of_in_channel : In_channel.t -> File_descr.t
[@@ocaml.doc " Return the descriptor corresponding to an input channel. "]

val descr_of_out_channel : Out_channel.t -> File_descr.t
[@@ocaml.doc " Return the descriptor corresponding to an output channel. "]

[@@@ocaml.text " {6 Seeking and truncating} "]

type seek_command = Unix.seek_command =
  | SEEK_SET [@ocaml.doc " indicates positions relative to the beginning of the file "]
  | SEEK_CUR [@ocaml.doc " indicates positions relative to the current position "]
  | SEEK_END [@ocaml.doc " indicates positions relative to the end of the file "]
[@@ocaml.doc " POSITIONING modes for {!UnixLabels.lseek}. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_seek_command : seek_command -> Sexplib0.Sexp.t
  val seek_command_of_sexp : Sexplib0.Sexp.t -> seek_command
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val lseek : File_descr.t -> int64 -> mode:seek_command -> int64
[@@ocaml.doc " Set the current position for a file descriptor "]

val truncate : string -> len:int64 -> unit
[@@ocaml.doc " Truncates the named file to the given size. "]

val ftruncate : File_descr.t -> len:int64 -> unit
[@@ocaml.doc
  " Truncates the file corresponding to the given descriptor\n    to the given size. "]

[@@@ocaml.text " {6 File statistics} "]

type file_kind = Unix.file_kind =
  | S_REG [@ocaml.doc " Regular file "]
  | S_DIR [@ocaml.doc " Directory "]
  | S_CHR [@ocaml.doc " Character device "]
  | S_BLK [@ocaml.doc " Block device "]
  | S_LNK [@ocaml.doc " Symbolic link "]
  | S_FIFO [@ocaml.doc " Named pipe "]
  | S_SOCK [@ocaml.doc " Socket "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_file_kind : file_kind -> Sexplib0.Sexp.t
  val file_kind_of_sexp : Sexplib0.Sexp.t -> file_kind
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type stats = Unix.LargeFile.stats =
  { st_dev : int [@ocaml.doc " Device number "]
  ; st_ino : int [@ocaml.doc " Inode number "]
  ; st_kind : file_kind [@ocaml.doc " Kind of the file "]
  ; st_perm : file_perm [@ocaml.doc " Access rights "]
  ; st_nlink : int [@ocaml.doc " Number of links "]
  ; st_uid : int [@ocaml.doc " User id of the owner "]
  ; st_gid : int [@ocaml.doc " Group ID of the file's group "]
  ; st_rdev : int [@ocaml.doc " Device minor number "]
  ; st_size : int64 [@ocaml.doc " Size in bytes "]
  ; st_atime : float [@ocaml.doc " Last access time "]
  ; st_mtime : float [@ocaml.doc " Last modification time "]
  ; st_ctime : float [@ocaml.doc " Last status change time "]
  }
[@@ocaml.doc
  " The informations returned by the {!UnixLabels.stat} calls.  The times are [float]\n\
  \    number of seconds since the epoch; we don't use [Time.t] because [Time] depends on\n\
  \    [Unix], so the fix isn't so trivial.  Same for [Native_file.stats] below. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_stats : stats -> Sexplib0.Sexp.t
  val stats_of_sexp : Sexplib0.Sexp.t -> stats
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val stat : string -> stats [@@ocaml.doc " Return the information for the named file. "]

val lstat : string -> stats
[@@ocaml.doc
  " Same as {!UnixLabels.stat}, but in case the file is a symbolic link,\n\
  \    return the information for the link itself. "]

val fstat : File_descr.t -> stats
[@@ocaml.doc
  " Return the information for the file associated with the given\n    descriptor. "]

module Native_file : sig
  type stats = Unix.stats =
    { st_dev : int [@ocaml.doc " Device number "]
    ; st_ino : int [@ocaml.doc " Inode number "]
    ; st_kind : file_kind [@ocaml.doc " Kind of the file "]
    ; st_perm : file_perm [@ocaml.doc " Access rights "]
    ; st_nlink : int [@ocaml.doc " Number of links "]
    ; st_uid : int [@ocaml.doc " User id of the owner "]
    ; st_gid : int [@ocaml.doc " Group ID of the file's group "]
    ; st_rdev : int [@ocaml.doc " Device minor number "]
    ; st_size : int [@ocaml.doc " Size in bytes "]
    ; st_atime : float [@ocaml.doc " Last access time "]
    ; st_mtime : float [@ocaml.doc " Last modification time "]
    ; st_ctime : float [@ocaml.doc " Last status change time "]
    }
  [@@ocaml.doc " The informations returned by the {!UnixLabels.stat} calls. "]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_stats : stats -> Sexplib0.Sexp.t
    val stats_of_sexp : Sexplib0.Sexp.t -> stats
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val stat : string -> stats [@@ocaml.doc " Return the information for the named file. "]

  val lstat : string -> stats
  [@@ocaml.doc
    " Same as {!UnixLabels.stat}, but in case the file is a symbolic link,\n\
    \      return the information for the link itself. "]

  val fstat : File_descr.t -> stats
  [@@ocaml.doc
    " Return the information for the file associated with the given\n      descriptor. "]

  val lseek : File_descr.t -> int -> mode:seek_command -> int
  val truncate : string -> len:int -> unit
  val ftruncate : File_descr.t -> len:int -> unit
end
[@@ocaml.doc
  " This sub-module provides the normal OCaml Unix functions that deal with file size\n\
  \    using native ints.  These are here because, in general, you should be using 64bit\n\
  \    file operations so that large files aren't an issue.  If you have a real need to\n\
  \    use potentially 31bit file operations (and you should be dubious of such a need) \
   you\n\
  \    can open this module "]

[@@@ocaml.text " {6 Locking} "]

type lock_command = Unix.lock_command =
  | F_ULOCK [@ocaml.doc " Unlock a region "]
  | F_LOCK [@ocaml.doc " Lock a region for writing, and block if already locked "]
  | F_TLOCK [@ocaml.doc " Lock a region for writing, or fail if already locked "]
  | F_TEST [@ocaml.doc " Test a region for other process locks "]
  | F_RLOCK [@ocaml.doc " Lock a region for reading, and block if already locked "]
  | F_TRLOCK [@ocaml.doc " Lock a region for reading, or fail if already locked "]
[@@ocaml.doc " Commands for {!lockf}. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_lock_command : lock_command -> Sexplib0.Sexp.t
  val lock_command_of_sexp : Sexplib0.Sexp.t -> lock_command
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val lockf : File_descr.t -> mode:lock_command -> len:Int64.t -> unit
[@@ocaml.doc
  " [lockf fd cmd size] place a lock on a file_descr that prevents any other process from\n\
  \    calling lockf successfully on the same file.  Due to a limitation in the current\n\
  \    implementation the length will be converted to a native int, potentially throwing \
   an\n\
  \    exception if it is too large.\n\n\
  \    Note that, despite the name, this function does not call the UNIX lockf() system \
   call;\n\
  \    rather it calls fcntl() with one of F_SETLK, F_SETLKW, or F_GETLK. "]

module Flock_command : sig
  type t

  val lock_shared : t
  val lock_exclusive : t
  val unlock : t
end

val flock : File_descr.t -> Flock_command.t -> bool
[@@ocaml.doc
  " [flock fd cmd] places or releases a lock on the fd as per the flock C call of the same\n\
  \    name. The request is \"nonblocking\" (LOCK_NB in C), meaning that if the lock \
   cannot be\n\
  \    granted immediately, the return value is false. However, the system call still \
   blocks\n\
  \    until the lock status can be ascertained. [true] is returned if the lock was \
   granted.\n"]

val flock_blocking : File_descr.t -> Flock_command.t -> unit
[@@ocaml.doc
  " [flock_blocking fd cmd] places or releases a lock on the fd as per the flock C call.\n\
  \    The function does not return until a lock can be granted. "]

val isatty : File_descr.t -> bool
[@@ocaml.doc
  " Return [true] if the given file descriptor refers to a terminal or\n\
  \    console window, [false] otherwise. "]

[@@@ocaml.text " {6 Mapping files into memory} "]

val map_file
  :  File_descr.t
  -> ?pos:int64
  -> ('a, 'b) Bigarray.kind
  -> 'c Bigarray.layout
  -> shared:bool
  -> int array
  -> ('a, 'b, 'c) Bigarray.Genarray.t
[@@ocaml.doc
  " Memory mapping of a file as a big array.\n\
  \    [map_file fd kind layout ~shared dims] returns a big array of kind [kind],\n\
  \    layout [layout], and dimensions as specified in [dims].\n\n\
  \    The data contained in this big array are the contents of the file referred to by \
   the\n\
  \    file descriptor [fd].\n\n\
  \    The optional [pos] parameter is the byte offset in the file of the data being \
   mapped.\n\
  \    It defaults to 0.\n\n\
  \    If [shared] is [true], all modifications performed on the array are reflected in\n\
  \    the file.  This requires that [fd] be opened with write permissions.  If [shared]\n\
  \    is [false], modifications performed on the array are done in memory only, using\n\
  \    copy-on-write of the modified pages; the underlying file is not affected.\n\n\
  \    To adjust automatically the dimensions of the big array to the actual size of the\n\
  \    file, the major dimension (that is, the first dimension for an array with C layout,\n\
  \    and the last dimension for an array with Fortran layout) can be given as\n\
  \    [-1]. [map_file] then determines the major dimension from the size of the file.\n\
  \    The file must contain an integral number of sub-arrays as determined by the \
   non-major\n\
  \    dimensions, otherwise [Failure] is raised. If all dimensions of the big array are\n\
  \    given, the file size is matched against the size of the big array.\n\
  \    If the file is larger than the big array, only the initial portion of the file is\n\
  \    mapped to the big array.  If the file is smaller than the bigarray, the file is\n\
  \    automatically grown to the size of the big array. This requires write permissions \
   on\n\
  \    [fd].\n\n\
  \    Array accesses are bounds-checked, but the bounds are determined by the initial \
   call\n\
  \    to [map_file]. Therefore, you should make sure no other process modifies the mapped\n\
  \    file while you're accessing it, or a SIGBUS signal may be raised. This happens,\n\
  \    for instance, if the file is shrunk. [Invalid_argument] or [Failure] may be raised\n\
  \    in cases where argument validation fails.\n\
  \    @since 4.05.0 "]

[@@@ocaml.text " {6 Operations on file names} "]

val unlink : string -> unit [@@ocaml.doc " Removes the named file "]

val remove : string -> unit [@@ocaml.doc " Removes the named file or directory "]

val rename : src:string -> dst:string -> unit
[@@ocaml.doc " [rename old new] changes the name of a file from [old] to [new]. "]

val link
  :  ?force:(bool[@ocaml.doc " defaults to false "])
  -> target:string
  -> link_name:string
  -> unit
  -> unit
[@@ocaml.doc
  " [link ?force ~target ~link_name ()] creates a hard link named [link_name]\n\
  \    to the file named [target].  If [force] is true, an existing entry in\n\
  \    place of [link_name] will be unlinked.  This unlinking may raise a Unix\n\
  \    error, e.g. if the entry is a directory. "]

[@@@ocaml.text " {6 File permissions and ownership} "]

val chmod : string -> perm:file_perm -> unit
[@@ocaml.doc " Change the permissions of the named file. "]

val fchmod : File_descr.t -> perm:file_perm -> unit
[@@ocaml.doc " Change the permissions of an opened file. "]

val chown : string -> uid:int -> gid:int -> unit
[@@ocaml.doc " Change the owner uid and owner gid of the named file. "]

val fchown : File_descr.t -> uid:int -> gid:int -> unit
[@@ocaml.doc " Change the owner uid and owner gid of an opened file. "]

val umask : int -> int
[@@ocaml.doc " Set the process creation mask, and return the previous mask. "]

val access : string -> [ `Read | `Write | `Exec | `Exists ] list -> (unit, exn) Result.t
[@@ocaml.doc " Check that the process has the given permissions over the named file. "]

val access_exn : string -> [ `Read | `Write | `Exec | `Exists ] list -> unit

[@@@ocaml.text " {6 Operations on file descriptors} "]

val dup
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> File_descr.t
  -> File_descr.t
[@@ocaml.doc
  " Return a new file descriptor referencing the same file as\n    the given descriptor. "]

val dup2
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> src:File_descr.t
  -> dst:File_descr.t
  -> unit
  -> unit
[@@ocaml.doc
  " [dup2 ~src ~dst] duplicates [src] to [dst], closing [dst] if already\n    opened. "]

val set_nonblock : File_descr.t -> unit
[@@ocaml.doc
  " Set the ``non-blocking'' flag on the given descriptor.\n\
  \    When the non-blocking flag is set, reading on a descriptor\n\
  \    on which there is temporarily no data available raises the\n\
  \    [EAGAIN] or [EWOULDBLOCK] error instead of blocking;\n\
  \    writing on a descriptor on which there is temporarily no room\n\
  \    for writing also raises [EAGAIN] or [EWOULDBLOCK]. "]

val clear_nonblock : File_descr.t -> unit
[@@ocaml.doc
  " Clear the ``non-blocking'' flag on the given descriptor.\n\
  \    See {!UnixLabels.set_nonblock}."]

val set_close_on_exec : File_descr.t -> unit
[@@ocaml.doc
  " Set the ``close-on-exec'' flag on the given descriptor.\n\
  \    A descriptor with the close-on-exec flag is automatically\n\
  \    closed when the current process starts another program with\n\
  \    one of the [exec] functions. "]

val get_close_on_exec : File_descr.t -> bool
[@@ocaml.doc
  " Check whether the ``close-on-exec'' flag is set on the given\n    descriptor. "]

val clear_close_on_exec : File_descr.t -> unit
[@@ocaml.doc
  " Clear the ``close-on-exec'' flag on the given descriptor.\n\
  \    See {!UnixLabels.set_close_on_exec}."]

[@@@ocaml.text " {6 Directories} "]

val mkdir : ?perm:file_perm -> string -> unit
[@@ocaml.doc
  " Create a directory.  The permissions of the created directory are (perm & ~umask &\n\
  \    0777).  The default perm is 0777. "]

val mkdir_p : ?perm:file_perm -> string -> unit
[@@ocaml.doc
  " Create a directory recursively.  The permissions of the created directory are\n\
  \    those granted by [mkdir ~perm]. "]

val rmdir : string -> unit [@@ocaml.doc " Remove an empty directory. "]

val chdir : string -> unit [@@ocaml.doc " Change the process working directory. "]

val getcwd : unit -> string
[@@ocaml.doc " Return the name of the current working directory. "]

val chroot : string -> unit [@@ocaml.doc " Change the process root directory. "]

type dir_handle = Unix.dir_handle
[@@ocaml.doc " The type of descriptors over opened directories. "]

val opendir : ?restart:(bool[@ocaml.doc " defaults to false "]) -> string -> dir_handle
[@@ocaml.doc " Open a descriptor on a directory "]

val readdir_opt : dir_handle -> string option
[@@ocaml.doc
  " Return the next entry in a directory.  Returns [None] when the end of the directory\n\
  \    has been reached. "]

val readdir : dir_handle -> string
[@@ocaml.doc
  " Same as [readdir_opt] except that it signals the end of the directory by raising\n\
  \    [End_of_file]. "]
[@@deprecated "[since 2016-08] use [readdir_opt] instead"]

val rewinddir : dir_handle -> unit
[@@ocaml.doc " Reposition the descriptor to the beginning of the directory "]

val closedir : dir_handle -> unit [@@ocaml.doc " Close a directory descriptor. "]

module Readdir_detailed : sig
  type t =
    { name : string
    ; inode : Nativeint.t
    ; kind : file_kind option
          [@ocaml.doc
            " Some OS/filesystems provide the file type of the directory entry, some \
             don't, some\n\
            \        do based on mount options. Code should not require the file type to \
             be present,\n\
            \        merely use it as a way to increase speed or reduce race conditions. "]
    }
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

val readdir_detailed_opt : dir_handle -> Readdir_detailed.t option
[@@ocaml.doc
  " [readdir_detailed_opt dh] return the next entry in a directory.  Returns [None] when\n\
  \    the end of the directory has been reached. "]

val ls_dir_detailed : string -> Readdir_detailed.t list
[@@ocaml.doc
  " [ls_dir_detailed path] returns the information from [readdir_detailed_opt] with an\n\
  \    interface similar to that of [Sys_unix.ls_dir]. "]

[@@@ocaml.text " {6 Pipes and redirections} "]

val pipe
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> unit
  -> File_descr.t * File_descr.t
[@@ocaml.doc
  " Create a pipe. The first component of the result is opened\n\
  \    for reading, that's the exit to the pipe. The second component is\n\
  \    opened for writing, that's the entrance to the pipe. "]

val mkfifo : string -> perm:file_perm -> unit
[@@ocaml.doc " Create a named pipe with the given permissions. "]

[@@@ocaml.text " {6 High-level process and redirection management} "]

module Process_info : sig
  type t =
    { pid : Pid.t
    ; stdin : File_descr.t
    ; stdout : File_descr.t
    ; stderr : File_descr.t
    }
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

[@@@ocaml.text " Low-level process "]

val create_process : prog:string -> args:string list -> Process_info.t
[@@ocaml.doc
  " [create_process ~prog ~args] forks a new process that executes the program [prog] with\n\
  \    arguments [args].  The function returns the pid of the process along with file\n\
  \    descriptors attached to stdin, stdout, and stderr of the new process.  The \
   executable\n\
  \    file [prog] is searched for in the path.  The new process has the same \
   environment as\n\
  \    the current process.  Unlike in [execve] the program name is automatically passed \
   as\n\
  \    the first argument. "]

val create_process_env
  :  ?working_dir:string
  -> ?prog_search_path:string list
  -> ?argv0:string
  -> ?setpgid:Pgid.t
  -> prog:string
  -> args:string list
  -> env:env
  -> unit
  -> Process_info.t
[@@ocaml.doc
  " [create_process_env ~prog ~args ~env] as [create_process], but takes an additional\n\
  \    parameter that extends or replaces the current environment. No effort is made to\n\
  \    ensure that the keys passed in as env are unique, so if an environment variable \
   is set\n\
  \    twice the second version will override the first. If [argv0] is given, it is used\n\
  \    (instead of [prog]) as the first element of the [argv] array passed to [execve].\n\n\
  \    The exact program to execute is determined using the usual conventions. More\n\
  \    precisely, if [prog] contains at least one '/' character then it is used as is\n\
  \    (relative to [working_dir] if [prog] is a relative path, absolute otherwise). Note\n\
  \    that [working_dir] defaults to the working directory of the current process,\n\
  \    i.e. [getcwd ()]. If [prog] contains no '/' character, then it is looked up in\n\
  \    [prog_search_path]: for the first [dir] in [prog_search_path] such that\n\
  \    [Filename.concat dir prog] exists and is executable, [Filename.concat dir prog] \
   is the\n\
  \    program that will be executed.\n\n\
  \    [prog_search_path] defaults to the list of directories encoded as a ':' separated \
   list\n\
  \    in the \"PATH\" environment variable of the current running process. If no such \
   variable\n\
  \    is defined, then {[[\"/bin\"; \"/usr/bin\"]]} is used instead. Note that the \
   \"PATH\"\n\
  \    environment variable is looked up in the environment of the current running \
   process,\n\
  \    i.e. via [getenv \"PATH\"]. Setting the \"PATH\" variable in the [env] argument \
   of this\n\
  \    function has no effect on how [prog] is resolved.\n\n\
  \    In a setuid or setgid program, or one which has inherited such privileges, \
   reading of\n\
  \    the PATH variable will return an empty result.  If a search path is required then \
   it\n\
  \    should be provided explicitly using [prog_search_path] in such scenarios;\n\
  \    alternatively, perhaps more satisfactorily, an absolute path should be given as\n\
  \    [prog].\n"]

module Fd_spec : sig
  type 'maybe_fd t =
    | Generate : File_descr.t t
    | Use_this : File_descr.t -> [ `Did_not_create_fd ] t
end

module Pid_with_generated_fds : sig
  type ('stdin, 'stdout, 'stderr) t =
    { pid : Pid.t
    ; stdin : 'stdin
    ; stdout : 'stdout
    ; stderr : 'stderr
    }
end

val create_process_with_fds
  :  ?working_dir:string
  -> ?prog_search_path:string list
  -> ?argv0:string
  -> ?setpgid:Pgid.t
  -> ?env:(env[@ocaml.doc " default: [`Extend []], i.e., use the current environment  "])
  -> prog:string
  -> args:string list
  -> stdin:'stdin Fd_spec.t
  -> stdout:'stdout Fd_spec.t
  -> stderr:'stderr Fd_spec.t
  -> unit
  -> ('stdin, 'stdout, 'stderr) Pid_with_generated_fds.t
[@@ocaml.doc
  " Like [create_process_env], but allowing existing file descriptors for std{in,out,err}\n\
  \    for the child process, instead of generating fresh ones. [create_process_env] is\n\
  \    essentially [create_process_with_fds] with [Generate] passed for all three.\n\n\
  \    Note that each file descriptor is either passed in via [Use_this fd] or returned \
   due\n\
  \    to [Generate]. Those passed in will be used by the new (child) process, while those\n\
  \    returned will be used by this (the parent) process. E.g., a supplied stdin must be\n\
  \    readable (by the child), while a returned stdin will be writable (by the parent).\n\n\
  \    File descriptors passed in via [Use_this fd] can be CLOEXEC; they will be [dup]ed \
   for\n\
  \    the new process. "]

val open_process_in : string -> In_channel.t
[@@ocaml.doc
  " High-level pipe and process management. These functions\n\
  \    (with {!UnixLabels.open_process_out} and {!UnixLabels.open_process})\n\
  \    run the given command in parallel with the program,\n\
  \    and return channels connected to the standard input and/or\n\
  \    the standard output of the command. The command is interpreted\n\
  \    by the shell [/bin/sh] (cf. [system]). Warning: writes on channels\n\
  \    are buffered, hence be careful to call {!Caml.flush} at the right times\n\
  \    to ensure correct synchronization. "]

val open_process_out : string -> Out_channel.t
[@@ocaml.doc " See {!UnixLabels.open_process_in}. "]

val open_process : string -> In_channel.t * Out_channel.t
[@@ocaml.doc " See {!UnixLabels.open_process_in}. "]

module Process_channels : sig
  type t =
    { stdin : Out_channel.t
    ; stdout : In_channel.t
    ; stderr : In_channel.t
    }
end
[@@ocaml.doc
  " Similar to {!UnixLabels.open_process}, but the second argument specifies\n\
  \    the environment passed to the command.  The result is a triple\n\
  \    of channels connected to the standard output, standard input,\n\
  \    and standard error of the command. "]

val open_process_full : string -> env:string array -> Process_channels.t

[@@@ocaml.text
  " [close_process_*] raises [Unix_error] if, for example, the file descriptor has already\n\
  \    been closed. "]

val close_process_in : In_channel.t -> Exit_or_signal.t
[@@ocaml.doc
  " Close channels opened by {!UnixLabels.open_process_in},\n\
  \    wait for the associated command to terminate,\n\
  \    and return its termination status. "]

val close_process_out : Out_channel.t -> Exit_or_signal.t
[@@ocaml.doc
  " Close channels opened by {!UnixLabels.open_process_out},\n\
  \    wait for the associated command to terminate,\n\
  \    and return its termination status. "]

val close_process : In_channel.t * Out_channel.t -> Exit_or_signal.t
[@@ocaml.doc
  " Close channels opened by {!UnixLabels.open_process},\n\
  \    wait for the associated command to terminate,\n\
  \    and return its termination status. "]

val close_process_full : Process_channels.t -> Exit_or_signal.t
[@@ocaml.doc
  " Close channels opened by {!UnixLabels.open_process_full},\n\
  \    wait for the associated command to terminate,\n\
  \    and return its termination status. "]

[@@@ocaml.text " {6 Symbolic links} "]

val symlink : target:string -> link_name:string -> unit
[@@ocaml.doc
  " [symlink ~target ~link_name] creates the file [link_name] as a symbolic link\n\
  \    to the file [target].\n\
  \    On Windows, this has the semantics using [stat] as described at:\n\
  \    http://caml.inria.fr/pub/docs/manual-ocaml/libref/Unix.html\n"]

val readlink : string -> string [@@ocaml.doc " Read the contents of a link. "]

[@@@ocaml.text " {6 Polling} "]

module Select_fds : sig
  type t =
    { read : File_descr.t list
    ; write : File_descr.t list
    ; except : File_descr.t list
    }
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val empty : t
end

type select_timeout =
  [ `Never
  | `Immediately
  | `After of Core.Time_ns.Span.t
  ]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_select_timeout : select_timeout -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val select
  :  ?restart:(bool[@ocaml.doc " defaults to [false] "])
  -> read:File_descr.t list
  -> write:File_descr.t list
  -> except:File_descr.t list
  -> timeout:select_timeout
  -> unit
  -> Select_fds.t
[@@ocaml.doc
  " Wait until some input/output operations become possible on some channels.  The three\n\
  \    list arguments are a set of descriptors to check for reading, for writing, or for\n\
  \    exceptional conditions.  [~timeout] is the maximal timeout.  The result is \
   composed of\n\
  \    three sets of descriptors: those ready for reading, ready for writing, and over \
   which\n\
  \    an exceptional condition is pending.\n\n\
  \    Setting restart to true means that we want [select] to restart automatically on \
   EINTR\n\
  \    (instead of propagating the exception)... "]

val pause : unit -> unit
[@@ocaml.doc " Wait until a non-ignored, non-blocked signal is delivered. "]

[@@@ocaml.text " {6 Time functions} "]

type process_times = Unix.process_times =
  { tms_utime : float [@ocaml.doc " User time for the process "]
  ; tms_stime : float [@ocaml.doc " System time for the process "]
  ; tms_cutime : float [@ocaml.doc " User time for the children processes "]
  ; tms_cstime : float [@ocaml.doc " System time for the children processes "]
  }
[@@ocaml.doc " The execution times (CPU times) of a process. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_process_times : process_times -> Sexplib0.Sexp.t
  val process_times_of_sexp : Sexplib0.Sexp.t -> process_times
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Clock : sig
  type underlying [@@ocaml.doc " Opaque representation of C [clockid_t]. "]

  type t =
    | Realtime
    | Monotonic
    | Process_cpu
    | Process_thread
    | Custom of underlying
  [@@ocaml.doc " Supported clocks. See clock_gettime(3) man pages for semantics. "]

  val get_cpuclock_for : (Pid.t -> underlying) Or_error.t
  [@@ocaml.doc " See [clock_getcpuclockid(3)]. "]

  val getres : (t -> Int63.t) Or_error.t
  [@@ocaml.doc " Return the resolution of the given clock in nanoseconds. "]

  val gettime : (t -> Int63.t) Or_error.t
  [@@ocaml.doc
    " Return the current time of the given clock since 00:00:00 UTC, Jan. 1,\n\
    \      1970, in nanoseconds. "]
end

type tm = Unix.tm =
  { tm_sec : int [@ocaml.doc " Seconds 0..59 "]
  ; tm_min : int [@ocaml.doc " Minutes 0..59 "]
  ; tm_hour : int [@ocaml.doc " Hours 0..23 "]
  ; tm_mday : int [@ocaml.doc " Day of month 1..31 "]
  ; tm_mon : int [@ocaml.doc " Month of year 0..11 "]
  ; tm_year : int [@ocaml.doc " Year - 1900 "]
  ; tm_wday : int [@ocaml.doc " Day of week (Sunday is 0) "]
  ; tm_yday : int [@ocaml.doc " Day of year 0..365 "]
  ; tm_isdst : bool [@ocaml.doc " Daylight time savings in effect "]
  }
[@@ocaml.doc " The type representing wallclock time and calendar date. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_tm : tm -> Sexplib0.Sexp.t
  val tm_of_sexp : Sexplib0.Sexp.t -> tm
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val time : unit -> float
[@@ocaml.doc " Return the current time since 00:00:00 GMT, Jan. 1, 1970, in seconds. "]

val gettimeofday : unit -> float
[@@ocaml.doc " Same as {!time} above, but with resolution better than 1 second. "]

val gmtime : float -> tm
[@@ocaml.doc
  " Convert a time in seconds, as returned by {!UnixLabels.time}, into a date and\n\
  \    a time. Assumes UTC. "]

val timegm : tm -> float
[@@ocaml.doc " Convert a UTC time in a tm record to a time in seconds "]

val localtime : float -> tm
[@@ocaml.doc
  " Convert a time in seconds, as returned by {!UnixLabels.time}, into a date and\n\
  \    a time. Assumes the local time zone. "]

val mktime : tm -> float * tm
[@@ocaml.doc
  " Convert a date and time, specified by the [tm] argument, into\n\
  \    a time in seconds, as returned by {!UnixLabels.time}. Also return a normalized\n\
  \    copy of the given [tm] record, with the [tm_wday], [tm_yday],\n\
  \    and [tm_isdst] fields recomputed from the other fields.\n\
  \    The [tm] argument is interpreted in the local time zone. "]

val strftime : tm -> string -> string
[@@ocaml.doc
  " Convert a date and time, specified by the [tm] argument, into a formatted string.\n\
  \    See 'man strftime' for format options. "]

val strptime
  :  ?allow_trailing_input:(bool[@ocaml.doc " default = false "])
  -> fmt:string
  -> string
  -> Unix.tm
[@@ocaml.doc
  " Given a format string, convert a corresponding string to a date and time\n\
  \    See 'man strptime' for format options.\n\n\
  \    Raise if [allow_trailing_input] is false and [fmt] does not consume all of the\n\
  \    input. "]

val alarm : int -> int
[@@ocaml.doc " Schedule a [SIGALRM] signal after the given number of seconds. "]

val sleep : int -> unit [@@ocaml.doc " Stop execution for the given number of seconds. "]

val nanosleep : float -> float
[@@ocaml.doc
  " [nanosleep f] delays execution of the program for at least [f] seconds.  The function\n\
  \    can return earlier if a signal has been delivered, in which case the number of \
   seconds\n\
  \    left is returned.  Any other failure raises an exception. "]

val times : unit -> process_times
[@@ocaml.doc " Return the execution times of the process. "]

val utimes : string -> access:float -> modif:float -> unit
[@@ocaml.doc
  " Set the last access time (second arg) and last modification time\n\
  \    (third arg) for a file. Times are expressed in seconds from\n\
  \    00:00:00 GMT, Jan. 1, 1970. "]

type interval_timer = Unix.interval_timer =
  | ITIMER_REAL
  [@ocaml.doc " decrements in real time, and sends the signal [SIGALRM] when expired."]
  | ITIMER_VIRTUAL
  [@ocaml.doc
    "  decrements in process virtual time, and sends [SIGVTALRM] when expired. "]
  | ITIMER_PROF
  [@ocaml.doc
    " (for profiling) decrements both when the process\n\
    \      is running and when the system is running on behalf of the\n\
    \      process; it sends [SIGPROF] when expired. "]
[@@ocaml.doc " The three kinds of interval timers. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_interval_timer : interval_timer -> Sexplib0.Sexp.t
  val interval_timer_of_sexp : Sexplib0.Sexp.t -> interval_timer
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type interval_timer_status = Unix.interval_timer_status =
  { it_interval : float [@ocaml.doc " Period "]
  ; it_value : float [@ocaml.doc " Current value of the timer "]
  }
[@@ocaml.doc " The type describing the status of an interval timer "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_interval_timer_status : interval_timer_status -> Sexplib0.Sexp.t
  val interval_timer_status_of_sexp : Sexplib0.Sexp.t -> interval_timer_status
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val getitimer : interval_timer -> interval_timer_status
[@@ocaml.doc " Return the current status of the given interval timer. "]

val setitimer : interval_timer -> interval_timer_status -> interval_timer_status
[@@ocaml.doc
  " [setitimer t s] sets the interval timer [t] and returns\n\
  \    its previous status. The [s] argument is interpreted as follows:\n\
  \    [s.it_value], if nonzero, is the time to the next timer expiration;\n\
  \    [s.it_interval], if nonzero, specifies a value to\n\
  \    be used in reloading it_value when the timer expires.\n\
  \    Setting [s.it_value] to zero disable the timer.\n\
  \    Setting [s.it_interval] to zero causes the timer to be disabled\n\
  \    after its next expiration. "]

[@@@ocaml.text
  " {6 User id, group id}\n\
  \    It's highly recommended to read the straight unix docs on these functions for more\n\
  \    color. You can get that info from man pages or\n\
  \    http://www.opengroup.org/onlinepubs/000095399/functions/setuid.html\n"]

val getuid : unit -> int
[@@ocaml.doc " Return the user id of the user executing the process. "]

val geteuid : unit -> int
[@@ocaml.doc " Return the effective user id under which the process runs. "]

val setuid : int -> unit
[@@ocaml.doc
  " Sets the real user id and effective user id for the process. Only use this when\n\
  \    superuser. To setuid as an ordinary user, see Core_extended.Unix.seteuid. "]

val getgid : unit -> int
[@@ocaml.doc " Return the group id of the user executing the process. "]

val getegid : unit -> int
[@@ocaml.doc " Return the effective group id under which the process runs. "]

val setgid : int -> unit
[@@ocaml.doc " Set the real group id and effective group id for the process. "]

module Passwd : sig
  type t =
    { name : string
    ; passwd : string
    ; uid : int
    ; gid : int
    ; gecos : string
    ; dir : string
    ; shell : string
    }
  [@@deriving compare, fields ~getters, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val shell : t -> string
    val dir : t -> string
    val gecos : t -> string
    val gid : t -> int
    val uid : t -> int
    val passwd : t -> string
    val name : t -> string

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val getbyname : string -> t option
  val getbyname_exn : string -> t
  val getbyuid : int -> t option
  val getbyuid_exn : int -> t

  val getpwents : unit -> t list
  [@@ocaml.doc
    " [getpwents] is a thread-safe wrapper over the low-level passwd database functions.\n\
    \      The order in which the results are returned is not deterministic. "]

  module Low_level : sig
    [@@@ocaml.text
      " These functions may not be thread safe.\n\
      \        Use [getpwents], above, if possible. "]

    val setpwent : unit -> unit
    val getpwent : unit -> t option
    val getpwent_exn : unit -> t
    val endpwent : unit -> unit
  end
end
[@@ocaml.doc " Structure of entries in the [passwd] database "]

module Group : sig
  type t =
    { name : string
    ; passwd : string
    ; gid : int
    ; mem : string array
    }
  [@@deriving fields ~getters, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val mem : t -> string array
    val gid : t -> int
    val passwd : t -> string
    val name : t -> string
    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val getbyname : string -> t option
  val getbyname_exn : string -> t
  val getbygid : int -> t option
  val getbygid_exn : int -> t
end
[@@ocaml.doc " Structure of entries in the [groups] database. "]

val username : unit -> string
[@@ocaml.doc
  " Return the name of the user executing the process, from the {!Passwd} module.\n\n\
  \    Note that this function is not always guaranteed to succeed: depending on OS\n\
  \    configuration, computing the current username can involve network queries, which \
   can\n\
  \    fail transiently. "]

val getlogin : unit -> string [@@ocaml.doc " A deprecated alias for [username]. "]

module Protocol_family : sig
  type t =
    [ `Unix
    | `Inet
    | `Inet6
    ]
  [@@deriving bin_io, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

[@@@ocaml.text " {6 Internet addresses} "]

module Inet_addr : sig
  type t = Unix.inet_addr [@@deriving bin_io, compare, hash, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val arg_type : t Core.Command.Arg_type.t

  val t_of_sexp : Sexp.t -> t
  [@@ocaml.doc
    " [t_of_sexp] is deprecated because it used to block to do a DNS lookup, and we don't\n\
    \      want a sexp converter to do that.  As we transition away, one can use\n\
    \      [Blocking_sexp], which has the old behavior. "]
  [@@deprecated "[since 2015-10] Replace [t] by [Stable.V1.t] or by [Blocking_sexp.t]"]

  module Blocking_sexp : sig
    type t = Unix.inet_addr [@@deriving bin_io, compare, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " [Blocking_sexp] performs DNS lookup to resolve hostnames to IP addresses. "]

  include Comparable.S with type t := t

  val of_string : string -> t
  [@@ocaml.doc
    " Conversion from the printable representation of an Internet address to its internal\n\
    \      representation.  The argument string consists of 4 numbers separated by periods\n\
    \      ([XXX.YYY.ZZZ.TTT]) for IPv4 addresses, and up to 8 numbers separated by \
     colons for\n\
    \      IPv6 addresses.  Raise [Failure] when given a string that does not match these\n\
    \      formats. "]

  val of_string_or_getbyname : string -> t
  [@@ocaml.doc " Call [of_string] and if that fails, use [Host.getbyname]. "]

  val to_string : t -> string
  [@@ocaml.doc
    " Return the printable representation of the given Internet address.  See [of_string]\n\
    \      for a description of the printable representation. "]

  val bind_any : t
  [@@ocaml.doc
    " A special address, for use only with [bind], representing all the Internet addresses\n\
    \      that the host machine possesses. "]

  val bind_any_inet6 : t

  val localhost : t
  [@@ocaml.doc " Special addresses representing the host machine. "]
  [@@ocaml.doc " [127.0.0.1] "]

  val localhost_inet6 : t [@@ocaml.doc " ([::1]) "]

  val inet4_addr_of_int32 : Int32.t -> t
  [@@ocaml.doc
    " Some things (like the kernel) report addresses as hex or decimal strings.\n\
    \      Provide conversion functions. "]

  val inet4_addr_to_int32_exn : t -> Int32.t
  [@@ocaml.doc
    " [inet4_addr_to_int32_exn t = 0l] when [t = Inet_addr.of_string (\"0.0.0.0\")].\n\
    \      An exception is raised if [t] is a not an IPv4 address. "]

  val inet4_addr_of_int63 : Int63.t -> t
  val inet4_addr_to_int63_exn : t -> Int63.t

  module Stable : sig
    module V1 : sig
      type nonrec t = t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Stable_with_witness
        with type t := t
         and type comparator_witness = comparator_witness
    end
  end
end

module Cidr : sig
  type t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val arg_type : t Core.Command.Arg_type.t

  include
    Identifiable.S with type t := t
  [@@ocaml.doc
    " [of_string] Generates a Cidr.t based on a string like [\"10.0.0.0/8\"].  Addresses \
     are\n\
    \      not expanded, i.e. [\"10/8\"] is invalid. "]

  include Invariant.S with type t := t

  val create : base_address:Inet_addr.t -> bits:int -> t

  val base_address : t -> Inet_addr.t
  [@@ocaml.doc
    " Accessors.\n\
    \      - [base_address 192.168.0.0/24 = 192.168.0.0]\n\
    \      - [bits         192.168.0.0/24 = 24]. "]

  val bits : t -> int

  val all_matching_addresses : t -> Inet_addr.t Sequence.t
  [@@ocaml.doc " Generate a sequence of all addresses in the block. "]

  val broadcast_address : t -> Inet_addr.t
  [@@ocaml.doc
    " Compute the broadcast address associated with the subnet (the top IP in the range).\n\
    \      NB: The computed broadcast address may not be useful for small (/31 and /32) \
     ranges. "]

  val multicast : t
  [@@ocaml.doc
    " IPv4 multicast address can be represented by the CIDR prefix 224.0.0.0/4,\n\
    \      (i.e. addresses from 224.0.0.0 to 239.255.255.255, inclusive) "]

  val does_match : t -> Inet_addr.t -> bool
  [@@ocaml.doc
    " Is the given address inside the given Cidr.t?  Note that the broadcast and network\n\
    \      addresses are considered valid so [does_match 10.0.0.0/8 10.0.0.0] is true. "]

  val netmask_of_bits : t -> Inet_addr.t
  [@@ocaml.doc
    " Return the netmask corresponding to the number of network bits in the CIDR.\n\
    \      For example, the netmask for a CIDR with 24 network bits (e.g. 1.2.3.0/24)\n\
    \      is 255.255.255.0. "]

  val is_subset : t -> of_:t -> bool
  [@@ocaml.doc
    " [is_subset t1 ~of:t2] is true iff the set of IP addresses specified by [t1] is a\n\
    \      subset of those specified by [t2].\n\n\
    \      If [is_subset t1 ~of_:t2], then [does_match t1 x] implies [does_match t2 x].\n\n\
    \      If [does_match t1 x] and [does_match t2 x], then either [is_subset t1 \
     ~of_:t2] or\n\
    \      [is_subset t2 ~of_:t1] (or both). "]

  module Stable : sig
    module V1 :
      Stable_comparable.With_stable_witness.V1
      with type t = t
      with type comparator_witness = comparator_witness
  end
end
[@@ocaml.doc
  " A representation of CIDR netmasks (e.g. \"192.168.0.0/24\") and functions to match \
   if a\n\
  \    given address is inside the range or not.  Only IPv4 addresses are supported.  \
   Values\n\
  \    are always normalized so the base address is the lowest IP address in the range, so\n\
  \    for example [to_string (of_string \"192.168.1.101/24\") = \"192.168.1.0/24\"].\n"]

[@@@ocaml.text " {6 Sockets} "]

type socket_domain = Unix.socket_domain =
  | PF_UNIX [@ocaml.doc " Unix domain "]
  | PF_INET [@ocaml.doc " Internet domain "]
  | PF_INET6 [@ocaml.doc " Internet domain (IPv6) "]
[@@ocaml.doc " The type of socket domains. "] [@@deriving sexp, bin_io]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_domain : socket_domain -> Sexplib0.Sexp.t
  val socket_domain_of_sexp : Sexplib0.Sexp.t -> socket_domain
  val bin_shape_socket_domain : Bin_prot.Shape.t
  val bin_size_socket_domain : socket_domain Bin_prot.Size.sizer
  val bin_write_socket_domain : socket_domain Bin_prot.Write.writer
  val bin_writer_socket_domain : socket_domain Bin_prot.Type_class.writer
  val bin_read_socket_domain : socket_domain Bin_prot.Read.reader
  val __bin_read_socket_domain__ : (int -> socket_domain) Bin_prot.Read.reader
  val bin_reader_socket_domain : socket_domain Bin_prot.Type_class.reader
  val bin_socket_domain : socket_domain Bin_prot.Type_class.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type socket_type = Unix.socket_type =
  | SOCK_STREAM [@ocaml.doc " Stream socket "]
  | SOCK_DGRAM [@ocaml.doc " Datagram socket "]
  | SOCK_RAW [@ocaml.doc " Raw socket "]
  | SOCK_SEQPACKET [@ocaml.doc " Sequenced packets socket "]
[@@ocaml.doc
  " The type of socket kinds, specifying the semantics of\n    communications. "]
[@@deriving sexp, bin_io]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_type : socket_type -> Sexplib0.Sexp.t
  val socket_type_of_sexp : Sexplib0.Sexp.t -> socket_type
  val bin_shape_socket_type : Bin_prot.Shape.t
  val bin_size_socket_type : socket_type Bin_prot.Size.sizer
  val bin_write_socket_type : socket_type Bin_prot.Write.writer
  val bin_writer_socket_type : socket_type Bin_prot.Type_class.writer
  val bin_read_socket_type : socket_type Bin_prot.Read.reader
  val __bin_read_socket_type__ : (int -> socket_type) Bin_prot.Read.reader
  val bin_reader_socket_type : socket_type Bin_prot.Type_class.reader
  val bin_socket_type : socket_type Bin_prot.Type_class.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type sockaddr = Unix.sockaddr =
  | ADDR_UNIX of string
  | ADDR_INET of Inet_addr.t * int
[@@ocaml.doc
  " The type of socket addresses. [ADDR_UNIX name] is a socket address in the Unix domain;\n\
  \    [name] is a file name in the file system. [ADDR_INET(addr,port)] is a socket \
   address\n\
  \    in the Internet domain; [addr] is the Internet address of the machine, and [port] \
   is\n\
  \    the port number. "]
[@@deriving bin_io, compare, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val bin_shape_sockaddr : Bin_prot.Shape.t
  val bin_size_sockaddr : sockaddr Bin_prot.Size.sizer
  val bin_write_sockaddr : sockaddr Bin_prot.Write.writer
  val bin_writer_sockaddr : sockaddr Bin_prot.Type_class.writer
  val bin_read_sockaddr : sockaddr Bin_prot.Read.reader
  val __bin_read_sockaddr__ : (int -> sockaddr) Bin_prot.Read.reader
  val bin_reader_sockaddr : sockaddr Bin_prot.Type_class.reader
  val bin_sockaddr : sockaddr Bin_prot.Type_class.t
  val compare_sockaddr : sockaddr -> (sockaddr[@merlin.hide]) -> int
  val sexp_of_sockaddr : sockaddr -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val sockaddr_of_sexp : Sexp.t -> sockaddr
[@@deprecated "[since 2015-10] Replace [sockaddr] by [sockaddr_blocking_sexp]"]

type sockaddr_blocking_sexp = sockaddr
[@@ocaml.doc
  " [sockaddr_blocking_sexp] is like [sockaddr], with [of_sexp] that performs DNS lookup\n\
  \    to resolve [Inet_addr.t]. "]
[@@deriving bin_io, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val bin_shape_sockaddr_blocking_sexp : Bin_prot.Shape.t
  val bin_size_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Size.sizer
  val bin_write_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Write.writer

  val bin_writer_sockaddr_blocking_sexp
    : sockaddr_blocking_sexp Bin_prot.Type_class.writer

  val bin_read_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Read.reader

  val __bin_read_sockaddr_blocking_sexp__
    : (int -> sockaddr_blocking_sexp) Bin_prot.Read.reader

  val bin_reader_sockaddr_blocking_sexp
    : sockaddr_blocking_sexp Bin_prot.Type_class.reader

  val bin_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Type_class.t
  val sexp_of_sockaddr_blocking_sexp : sockaddr_blocking_sexp -> Sexplib0.Sexp.t
  val sockaddr_blocking_sexp_of_sexp : Sexplib0.Sexp.t -> sockaddr_blocking_sexp
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val domain_of_sockaddr : sockaddr -> socket_domain
[@@ocaml.doc " Return the socket domain adequate for the given socket address. "]

val socket
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> domain:socket_domain
  -> kind:socket_type
  -> protocol:int
  -> unit
  -> File_descr.t
[@@ocaml.doc
  " Create a new socket in the given domain, and with the\n\
  \    given kind. The third argument is the protocol type; 0 selects\n\
  \    the default protocol for that kind of sockets. "]

val socketpair
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> domain:socket_domain
  -> kind:socket_type
  -> protocol:int
  -> unit
  -> File_descr.t * File_descr.t
[@@ocaml.doc " Create a pair of unnamed sockets, connected together. "]

val accept
  :  ?close_on_exec:(bool[@ocaml.doc " default: false "])
  -> File_descr.t
  -> File_descr.t * sockaddr
[@@ocaml.doc
  " Accept connections on the given socket. The returned descriptor\n\
  \    is a socket connected to the client; the returned address is\n\
  \    the address of the connecting client. "]

val bind : File_descr.t -> addr:sockaddr -> unit
[@@ocaml.doc " Bind a socket to an address. "]

val connect : File_descr.t -> addr:sockaddr -> unit
[@@ocaml.doc " Connect a socket to an address. "]

val listen : File_descr.t -> backlog:int -> unit
[@@ocaml.doc
  " Set up a socket for receiving connection requests. The integer argument is the number\n\
  \    of pending requests that will be established and queued for {!accept}.  Depending \
   on\n\
  \    operating system, version, and configuration, subsequent connections may be refused\n\
  \    actively (as with [RST]), ignored, or effectively established and queued anyway.\n\n\
  \    Because handling of excess connections varies, it is most robust for applications \
   to\n\
  \    accept and close excess connections if they can.  To be sure the client receives an\n\
  \    [RST] rather than an orderly shutdown, you can [setsockopt_optint file_descr \
   SO_LINGER\n\
  \    (Some 0)] before closing.\n\n\
  \    In Linux, for example, the system configuration parameters [tcp_max_syn_backlog],\n\
  \    [tcp_abort_on_overflow], and [syncookies] can all affect connection queuing\n\
  \    behavior. "]

type shutdown_command = Unix.shutdown_command =
  | SHUTDOWN_RECEIVE [@ocaml.doc " Close for receiving "]
  | SHUTDOWN_SEND [@ocaml.doc " Close for sending "]
  | SHUTDOWN_ALL [@ocaml.doc " Close both "]
[@@ocaml.doc " The type of commands for [shutdown]. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_shutdown_command : shutdown_command -> Sexplib0.Sexp.t
  val shutdown_command_of_sexp : Sexplib0.Sexp.t -> shutdown_command
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val shutdown : File_descr.t -> mode:shutdown_command -> unit
[@@ocaml.doc
  " Shutdown a socket connection. [SHUTDOWN_SEND] as second argument\n\
  \    causes reads on the other end of the connection to return\n\
  \    an end-of-file condition.\n\
  \    [SHUTDOWN_RECEIVE] causes writes on the other end of the connection\n\
  \    to return a closed pipe condition ([SIGPIPE] signal). "]

val getsockname : File_descr.t -> sockaddr
[@@ocaml.doc " Return the address of the given socket. "]

val getpeername : File_descr.t -> sockaddr
[@@ocaml.doc " Return the address of the host connected to the given socket. "]

type msg_flag = Unix.msg_flag =
  | MSG_OOB
  | MSG_DONTROUTE
  | MSG_PEEK
[@@ocaml.doc
  " The flags for {!UnixLabels.recv},  {!UnixLabels.recvfrom},\n\
  \    {!UnixLabels.send} and {!UnixLabels.sendto}. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_msg_flag : msg_flag -> Sexplib0.Sexp.t
  val msg_flag_of_sexp : Sexplib0.Sexp.t -> msg_flag
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val recv : File_descr.t -> buf:Bytes.t -> pos:int -> len:int -> mode:msg_flag list -> int
[@@ocaml.doc " Receive data from a connected socket. "]

val recvfrom
  :  File_descr.t
  -> buf:Bytes.t
  -> pos:int
  -> len:int
  -> mode:msg_flag list
  -> int * sockaddr
[@@ocaml.doc " Receive data from an unconnected socket. "]

val send : File_descr.t -> buf:Bytes.t -> pos:int -> len:int -> mode:msg_flag list -> int
[@@ocaml.doc " Send data over a connected socket. "]

val send_substring
  :  File_descr.t
  -> buf:string
  -> pos:int
  -> len:int
  -> mode:msg_flag list
  -> int
[@@ocaml.doc " Same as [send] but with a string buffer. "]

val sendto
  :  File_descr.t
  -> buf:Bytes.t
  -> pos:int
  -> len:int
  -> mode:msg_flag list
  -> addr:sockaddr
  -> int
[@@ocaml.doc " Send data over an unconnected socket. "]

val sendto_substring
  :  File_descr.t
  -> buf:string
  -> pos:int
  -> len:int
  -> mode:msg_flag list
  -> addr:sockaddr
  -> int
[@@ocaml.doc " Same as [sendto] but with a string buffer. "]

[@@@ocaml.text " {6 Socket options} "]

[%%if ocaml_version >= (4, 12, 0)]

type socket_bool_option =
  | SO_DEBUG [@ocaml.doc " Record debugging information "]
  | SO_BROADCAST [@ocaml.doc " Permit sending of broadcast messages "]
  | SO_REUSEADDR [@ocaml.doc " Allow reuse of local addresses for bind "]
  | SO_KEEPALIVE [@ocaml.doc " Keep connection active "]
  | SO_DONTROUTE [@ocaml.doc " Bypass the standard routing algorithms "]
  | SO_OOBINLINE [@ocaml.doc " Leave out-of-band data in line "]
  | SO_ACCEPTCONN [@ocaml.doc " Report whether socket listening is enabled "]
  | TCP_NODELAY [@ocaml.doc " Control the Nagle algorithm for TCP sockets "]
  | IPV6_ONLY [@ocaml.doc " Forbid binding an IPv6 socket to an IPv4 address "]
  | SO_REUSEPORT
[@@ocaml.doc
  " The socket options that can be consulted with {!UnixLabels.getsockopt}\n\
  \    and modified with {!UnixLabels.setsockopt}.  These options have a boolean\n\
  \    ([true]/[false]) value. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_bool_option : socket_bool_option -> Sexplib0.Sexp.t
  val socket_bool_option_of_sexp : Sexplib0.Sexp.t -> socket_bool_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[%%else]

type socket_bool_option =
  | SO_DEBUG
  | SO_BROADCAST
  | SO_REUSEADDR
  | SO_KEEPALIVE
  | SO_DONTROUTE
  | SO_OOBINLINE
  | SO_ACCEPTCONN
  | TCP_NODELAY
  | IPV6_ONLY
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_bool_option : socket_bool_option -> Sexplib0.Sexp.t
  val socket_bool_option_of_sexp : Sexplib0.Sexp.t -> socket_bool_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[%%endif]

type socket_int_option =
  | SO_SNDBUF [@ocaml.doc " Size of send buffer "]
  | SO_RCVBUF [@ocaml.doc " Size of received buffer "]
  | SO_ERROR [@alert deprecated "Use Unix.getsockopt_error instead."]
  [@ocaml.doc " Report the error status and clear it "]
  | SO_TYPE [@ocaml.doc " Report the socket type "]
  | SO_RCVLOWAT [@ocaml.doc " Minimum number of bytes to process for input operations "]
  | SO_SNDLOWAT [@ocaml.doc " Minimum number of bytes to process for output operations "]
[@@ocaml.doc
  " The socket options that can be consulted with {!UnixLabels.getsockopt_int}\n\
  \    and modified with {!UnixLabels.setsockopt_int}.  These options have an\n\
  \    integer value. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_int_option : socket_int_option -> Sexplib0.Sexp.t
  val socket_int_option_of_sexp : Sexplib0.Sexp.t -> socket_int_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type socket_optint_option =
  | SO_LINGER
  [@ocaml.doc
    " Whether to linger on closed connections with sexp that have\n\
    \      data present, and for how long (in seconds) "]
[@@ocaml.doc
  " The socket options that can be consulted with {!UnixLabels.getsockopt_optint}\n\
  \    and modified with {!UnixLabels.setsockopt_optint}.  These options have a\n\
  \    value of type [int option], with [None] meaning ``disabled''. "]

type socket_float_option =
  | SO_RCVTIMEO [@ocaml.doc " Timeout for input operations "]
  | SO_SNDTIMEO [@ocaml.doc " Timeout for output operations "]
[@@ocaml.doc
  " The socket options that can be consulted with {!UnixLabels.getsockopt_float}\n\
  \    and modified with {!UnixLabels.setsockopt_float}.  These options have a\n\
  \    floating-point value representing a time in seconds.\n\
  \    The value 0 means infinite timeout. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_socket_float_option : socket_float_option -> Sexplib0.Sexp.t
  val socket_float_option_of_sexp : Sexplib0.Sexp.t -> socket_float_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val getsockopt : File_descr.t -> socket_bool_option -> bool
[@@ocaml.doc
  " Return the current status of a boolean-valued option\n    in the given socket. "]

val setsockopt : File_descr.t -> socket_bool_option -> bool -> unit
[@@ocaml.doc " Set or clear a boolean-valued option in the given socket. "]

val getsockopt_int : File_descr.t -> socket_int_option -> int
[@@ocaml.doc " Same as {!UnixLabels.getsockopt} for an integer-valued socket option. "]

val setsockopt_int : File_descr.t -> socket_int_option -> int -> unit
[@@ocaml.doc " Same as {!UnixLabels.setsockopt} for an integer-valued socket option. "]

val getsockopt_optint : File_descr.t -> socket_optint_option -> int option
[@@ocaml.doc
  " Same as {!UnixLabels.getsockopt} for a socket option whose value is an [int option]. "]

val setsockopt_optint : File_descr.t -> socket_optint_option -> int option -> unit
[@@ocaml.doc
  " Same as {!UnixLabels.setsockopt} for a socket option whose value is an [int option]. "]

val getsockopt_float : File_descr.t -> socket_float_option -> float
[@@ocaml.doc
  " Same as {!UnixLabels.getsockopt} for a socket option whose value is a floating-point\n\
  \    number. "]

val setsockopt_float : File_descr.t -> socket_float_option -> float -> unit
[@@ocaml.doc
  " Same as {!UnixLabels.setsockopt} for a socket option whose value is a floating-point\n\
  \    number. "]

[@@@ocaml.text " {6 High-level network connection functions} "]

val open_connection : sockaddr -> In_channel.t * Out_channel.t
[@@ocaml.doc
  " Connect to a server at the given address.\n\
  \    Return a pair of buffered channels connected to the server.\n\
  \    Remember to call {!Caml.flush} on the output channel at the right times\n\
  \    to ensure correct synchronization. "]

val shutdown_connection : In_channel.t -> unit
[@@ocaml.doc
  " ``Shut down'' a connection established with {!UnixLabels.open_connection};\n\
  \    that is, transmit an end-of-file condition to the server reading\n\
  \    on the other side of the connection. "]

val establish_server : (In_channel.t -> Out_channel.t -> unit) -> addr:sockaddr -> unit
[@@ocaml.doc
  " Establish a server on the given address.\n\
  \    The function given as first argument is called for each connection\n\
  \    with two buffered channels connected to the client. A new process\n\
  \    is created for each connection. The function {!UnixLabels.establish_server}\n\
  \    never returns normally. "]

[@@@ocaml.text " {6 Host and protocol databases} "]

val gethostname : unit -> string [@@ocaml.doc " Return the name of the local host. "]

module Host : sig
  type t =
    { name : string
    ; aliases : string array
    ; family : Protocol_family.t
    ; addresses : Inet_addr.t array
    }
  [@@ocaml.doc " Structure of entries in the [hosts] database. "] [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val getbyname : string -> t option
  [@@ocaml.doc
    " Find an entry in [hosts] with the given name.\n\n\
    \      NOTE: This function is not thread safe with certain versions of winbind using \
     \"wins\"\n\
    \      name resolution. "]

  val getbyname_exn : string -> t

  val getbyaddr : Inet_addr.t -> t option
  [@@ocaml.doc " Find an entry in [hosts] with the given address. "]

  val getbyaddr_exn : Inet_addr.t -> t
  val have_address_in_common : t -> t -> bool
end

module Protocol : sig
  type t =
    { name : string
    ; aliases : string array
    ; proto : int
    }
  [@@ocaml.doc " Structure of entries in the [protocols] database. "] [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val getbyname : string -> t option
  [@@ocaml.doc " Find an entry in [protocols] with the given name. "]

  val getbyname_exn : string -> t

  val getbynumber : int -> t option
  [@@ocaml.doc " Find an entry in [protocols] with the given protocol number. "]

  val getbynumber_exn : int -> t
end

module Service : sig
  type t =
    { name : string
    ; aliases : string array
    ; port : int
    ; proto : string
    }
  [@@ocaml.doc " Structure of entries in the [services] database. "] [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val getbyname : string -> protocol:string -> t option
  [@@ocaml.doc " Find an entry in [services] with the given name. "]

  val getbyname_exn : string -> protocol:string -> t

  val getbyport : int -> protocol:string -> t option
  [@@ocaml.doc " Find an entry in [services] with the given service number. "]

  val getbyport_exn : int -> protocol:string -> t
end

type addr_info =
  { ai_family : socket_domain [@ocaml.doc " Socket domain "]
  ; ai_socktype : socket_type [@ocaml.doc " Socket type "]
  ; ai_protocol : int [@ocaml.doc " Socket protocol number "]
  ; ai_addr : sockaddr [@ocaml.doc " Address "]
  ; ai_canonname : string [@ocaml.doc " Canonical host name "]
  }
[@@ocaml.doc " Address information returned by {!Unix.getaddrinfo}. "]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_addr_info : addr_info -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type addr_info_blocking_sexp = addr_info
[@@ocaml.doc
  " [addr_info_blocking_sexp] is like [addr_info], with [of_sexp] that performs DNS lookup\n\
  \    to resolve [Inet_addr.t]. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_addr_info_blocking_sexp : addr_info_blocking_sexp -> Sexplib0.Sexp.t
  val addr_info_blocking_sexp_of_sexp : Sexplib0.Sexp.t -> addr_info_blocking_sexp
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type getaddrinfo_option =
  | AI_FAMILY of socket_domain [@ocaml.doc " Impose the given socket domain "]
  | AI_SOCKTYPE of socket_type [@ocaml.doc " Impose the given socket type "]
  | AI_PROTOCOL of int [@ocaml.doc " Impose the given protocol  "]
  | AI_NUMERICHOST [@ocaml.doc " Do not call name resolver, expect numeric IP address "]
  | AI_CANONNAME [@ocaml.doc " Fill the [ai_canonname] field of the result "]
  | AI_PASSIVE [@ocaml.doc " Set address to ``any'' address for use with {!Unix.bind} "]
[@@ocaml.doc " Options to {!Unix.getaddrinfo}. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_getaddrinfo_option : getaddrinfo_option -> Sexplib0.Sexp.t
  val getaddrinfo_option_of_sexp : Sexplib0.Sexp.t -> getaddrinfo_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val getaddrinfo : string -> string -> getaddrinfo_option list -> addr_info list
[@@ocaml.doc
  " [getaddrinfo host service opts] returns a list of {!Unix.addr_info}\n\
  \    records describing socket parameters and addresses suitable for\n\
  \    communicating with the given host and service.  The empty list is\n\
  \    returned if the host or service names are unknown, or the constraints\n\
  \    expressed in [opts] cannot be satisfied.\n\n\
  \    [host] is either a host name or the string representation of an IP\n\
  \    address.  [host] can be given as the empty string; in this case,\n\
  \    the ``any'' address or the ``loopback'' address are used,\n\
  \    depending whether [opts] contains [AI_PASSIVE].\n\
  \    [service] is either a service name or the string representation of\n\
  \    a port number.  [service] can be given as the empty string;\n\
  \    in this case, the port field of the returned addresses is set to 0.\n\
  \    [opts] is a possibly empty list of options that allows the caller\n\
  \    to force a particular socket domain (e.g. IPv6 only, or IPv4 only)\n\
  \    or a particular socket type (e.g. TCP only or UDP only). "]

type name_info =
  { ni_hostname : string [@ocaml.doc " Name or IP address of host "]
  ; ni_service : string [@ocaml.doc " Name of service or port number "]
  }
[@@ocaml.doc " Host and service information returned by {!Unix.getnameinfo}. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_name_info : name_info -> Sexplib0.Sexp.t
  val name_info_of_sexp : Sexplib0.Sexp.t -> name_info
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type getnameinfo_option =
  | NI_NOFQDN [@ocaml.doc " Do not qualify local host names "]
  | NI_NUMERICHOST [@ocaml.doc " Always return host as IP address "]
  | NI_NAMEREQD [@ocaml.doc " Fail if host name cannot be determined "]
  | NI_NUMERICSERV [@ocaml.doc " Always return service as port number "]
  | NI_DGRAM [@ocaml.doc " Consider the service as UDP-based instead of the default TCP "]
[@@ocaml.doc " Options to {!Unix.getnameinfo}. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_getnameinfo_option : getnameinfo_option -> Sexplib0.Sexp.t
  val getnameinfo_option_of_sexp : Sexplib0.Sexp.t -> getnameinfo_option
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val getnameinfo : sockaddr -> getnameinfo_option list -> name_info
[@@ocaml.doc
  " [getnameinfo addr opts] returns the host name and service name\n\
  \    corresponding to the socket address [addr].  [opts] is a possibly\n\
  \    empty list of options that governs how these names are obtained.\n\
  \    Raise [Caml.Not_found] or [Not_found_s] if an error occurs. "]

[@@@ocaml.text " {6 Terminal interface} "]

[@@@ocaml.text
  " The following functions implement the POSIX standard terminal\n\
  \    interface. They provide control over asynchronous communication ports\n\
  \    and pseudo-terminals. Refer to the [termios] man page for a complete\n\
  \    description. "]

module Terminal_io : sig
  type t = Unix.terminal_io =
    { mutable c_ignbrk : bool [@ocaml.doc " Ignore the break condition. "]
    ; mutable c_brkint : bool [@ocaml.doc " Signal interrupt on break condition. "]
    ; mutable c_ignpar : bool [@ocaml.doc " Ignore characters with parity errors. "]
    ; mutable c_parmrk : bool [@ocaml.doc " Mark parity errors. "]
    ; mutable c_inpck : bool [@ocaml.doc " Enable parity check on input. "]
    ; mutable c_istrip : bool [@ocaml.doc " Strip 8th bit on input characters. "]
    ; mutable c_inlcr : bool [@ocaml.doc " Map NL to CR on input. "]
    ; mutable c_igncr : bool [@ocaml.doc " Ignore CR on input. "]
    ; mutable c_icrnl : bool [@ocaml.doc " Map CR to NL on input. "]
    ; mutable c_ixon : bool [@ocaml.doc " Recognize XON/XOFF characters on input. "]
    ; mutable c_ixoff : bool [@ocaml.doc " Emit XON/XOFF chars to control input flow. "]
    ; mutable c_opost : bool [@ocaml.doc " Enable output processing. "]
    ; mutable c_obaud : int [@ocaml.doc " Output baud rate (0 means close connection)."]
    ; mutable c_ibaud : int [@ocaml.doc " Input baud rate. "]
    ; mutable c_csize : int [@ocaml.doc " Number of bits per character (5-8). "]
    ; mutable c_cstopb : int [@ocaml.doc " Number of stop bits (1-2). "]
    ; mutable c_cread : bool [@ocaml.doc " Reception is enabled. "]
    ; mutable c_parenb : bool [@ocaml.doc " Enable parity generation and detection. "]
    ; mutable c_parodd : bool [@ocaml.doc " Specify odd parity instead of even. "]
    ; mutable c_hupcl : bool [@ocaml.doc " Hang up on last close. "]
    ; mutable c_clocal : bool [@ocaml.doc " Ignore modem status lines. "]
    ; mutable c_isig : bool [@ocaml.doc " Generate signal on INTR, QUIT, SUSP. "]
    ; mutable c_icanon : bool
          [@ocaml.doc " Enable canonical processing (line buffering and editing) "]
    ; mutable c_noflsh : bool [@ocaml.doc " Disable flush after INTR, QUIT, SUSP. "]
    ; mutable c_echo : bool [@ocaml.doc " Echo input characters. "]
    ; mutable c_echoe : bool [@ocaml.doc " Echo ERASE (to erase previous character). "]
    ; mutable c_echok : bool [@ocaml.doc " Echo KILL (to erase the current line). "]
    ; mutable c_echonl : bool [@ocaml.doc " Echo NL even if c_echo is not set. "]
    ; mutable c_vintr : char [@ocaml.doc " Interrupt character (usually ctrl-C). "]
    ; mutable c_vquit : char [@ocaml.doc " Quit character (usually ctrl-\\). "]
    ; mutable c_verase : char [@ocaml.doc " Erase character (usually DEL or ctrl-H). "]
    ; mutable c_vkill : char [@ocaml.doc " Kill line character (usually ctrl-U). "]
    ; mutable c_veof : char [@ocaml.doc " End-of-file character (usually ctrl-D). "]
    ; mutable c_veol : char [@ocaml.doc " Alternate end-of-line char. (usually none). "]
    ; mutable c_vmin : int
          [@ocaml.doc
            " Minimum number of characters to read before the read request is satisfied. "]
    ; mutable c_vtime : int [@ocaml.doc " Maximum read wait (in 0.1s units). "]
    ; mutable c_vstart : char [@ocaml.doc " Start character (usually ctrl-Q). "]
    ; mutable c_vstop : char [@ocaml.doc " Stop character (usually ctrl-S). "]
    }
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type setattr_when = Unix.setattr_when =
    | TCSANOW
    | TCSADRAIN
    | TCSAFLUSH
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_setattr_when : setattr_when -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val tcgetattr : File_descr.t -> t
  [@@ocaml.doc
    " Return the status of the terminal referred to by the given\n      file descriptor. "]

  val tcsetattr : t -> File_descr.t -> mode:setattr_when -> unit
  [@@ocaml.doc
    " Set the status of the terminal referred to by the given\n\
    \      file descriptor. The second argument indicates when the\n\
    \      status change takes place: immediately ([TCSANOW]),\n\
    \      when all pending output has been transmitted ([TCSADRAIN]),\n\
    \      or after flushing all input that has been received but not\n\
    \      read ([TCSAFLUSH]). [TCSADRAIN] is recommended when changing\n\
    \      the output parameters; [TCSAFLUSH], when changing the input\n\
    \      parameters. "]

  val tcsendbreak : File_descr.t -> duration:int -> unit
  [@@ocaml.doc
    " Send a break condition on the given file descriptor.\n\
    \      The second argument is the duration of the break, in 0.1s units;\n\
    \      0 means standard duration (0.25s). "]

  val tcdrain : File_descr.t -> unit
  [@@ocaml.doc
    " Waits until all output written on the given file descriptor\n\
    \      has been transmitted. "]

  type flush_queue = Unix.flush_queue =
    | TCIFLUSH
    | TCOFLUSH
    | TCIOFLUSH
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_flush_queue : flush_queue -> Sexplib0.Sexp.t
    val flush_queue_of_sexp : Sexplib0.Sexp.t -> flush_queue
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val tcflush : File_descr.t -> mode:flush_queue -> unit
  [@@ocaml.doc
    " Discard data written on the given file descriptor but not yet\n\
    \      transmitted, or data received but not yet read, depending on the\n\
    \      second argument: [TCIFLUSH] flushes data received but not read,\n\
    \      [TCOFLUSH] flushes data written but not transmitted, and\n\
    \      [TCIOFLUSH] flushes both. "]

  type flow_action = Unix.flow_action =
    | TCOOFF
    | TCOON
    | TCIOFF
    | TCION
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_flow_action : flow_action -> Sexplib0.Sexp.t
    val flow_action_of_sexp : Sexplib0.Sexp.t -> flow_action
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val tcflow : File_descr.t -> mode:flow_action -> unit
  [@@ocaml.doc
    " Suspend or restart reception or transmission of data on\n\
    \      the given file descriptor, depending on the second argument:\n\
    \      [TCOOFF] suspends output, [TCOON] restarts output,\n\
    \      [TCIOFF] transmits a STOP character to suspend input,\n\
    \      and [TCION] transmits a START character to restart input. "]

  val setsid : unit -> int
  [@@ocaml.doc
    " Put the calling process in a new session and detach it from\n\
    \      its controlling terminal. "]
end

val get_sockaddr : string -> int -> sockaddr
[@@ocaml.doc " Get a sockaddr from a hostname or IP, and a port "]

val set_in_channel_timeout : In_channel.t -> float -> unit
[@@ocaml.doc " Set a timeout for a socket associated with an [In_channel.t] "]

val set_out_channel_timeout : Out_channel.t -> float -> unit
[@@ocaml.doc " Set a timeout for a socket associated with an [Out_channel.t] "]

val exit_immediately : int -> _
[@@ocaml.doc
  " [exit_immediately exit_code] immediately calls the [exit] system call with the given\n\
  \    exit code without performing any other actions (unlike Caml.exit).  Does not\n\
  \    return. "]

[@@@ocaml.text " {2 Filesystem functions} "]

val mknod
  :  ?file_kind:file_kind
  -> ?perm:int
  -> ?major:int
  -> ?minor:int
  -> string
  -> unit
[@@ocaml.doc
  " [mknod ?file_kind ?perm ?major ?minor path] creates a filesystem\n\
  \    entry.  Note that only FIFO-entries are guaranteed to be supported\n\
  \    across all platforms as required by the POSIX-standard.  On Linux\n\
  \    directories and symbolic links cannot be created with this function.\n\
  \    Use {!Unix.mkdir} and {!Unix.symlink} instead there respectively.\n\n\
  \    @raise Invalid_argument if an unsupported file kind is used.\n\
  \    @raise Unix_error if the system call fails.\n\n\
  \    @param file_kind default = [S_REG] (= regular file)\n\
  \    @param perm default = [0o600] (= read/write for user only)\n\
  \    @param major default = [0]\n\
  \    @param minor default = [0]\n"]

[@@@ocaml.text " {2 I/O vectors} "]

module IOVec : sig
  open Bigarray

  type 'buf t = private
    { buf : 'buf [@ocaml.doc " Buffer holding the I/O-vector "]
    ; pos : int [@ocaml.doc " Position of I/O-vector in buffer "]
    ; len : int [@ocaml.doc " Length of I/O-vector in buffer "]
    }
  [@@ocaml.doc
    " Representation of I/O-vectors.\n\
    \      NOTE: DO NOT CHANGE THE MEMORY LAYOUT OF THIS TYPE!!!\n\
    \      All C-functions in our bindings that handle I/O-vectors depend on it.\n\
    \  "]
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S1 with type 'buf t := 'buf t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'buf kind [@@ocaml.doc " Kind of I/O-vector buffers "]

  type bigstring = (char, int8_unsigned_elt, c_layout) Array1.t

  val string_kind : string kind
  val bigstring_kind : bigstring kind

  val empty : 'buf kind -> 'buf t [@@ocaml.doc " [empty] the empty I/O-vector. "]

  val of_string : ?pos:int -> ?len:int -> string -> string t
  [@@ocaml.doc
    " [of_string ?pos ?len str] @return an I/O-vector designated by\n\
    \      position [pos] and length [len] in string [str].\n\n\
    \      @raise Invalid_argument if designated substring out of bounds.\n\n\
    \      @param pos default = 0\n\
    \      @param len default = [String.length str - pos]\n\
    \  "]

  val of_bigstring : ?pos:int -> ?len:int -> bigstring -> bigstring t
  [@@ocaml.doc
    " [of_bigstring ?pos ?len bstr] @return an I/O-vector designated by\n\
    \      position [pos] and length [len] in bigstring [bstr].\n\n\
    \      @raise Invalid_argument if designated substring out of bounds.\n\n\
    \      @param pos default = 0\n\
    \      @param len default = [String.length str - pos]\n\
    \  "]

  val drop : 'buf t -> int -> 'buf t
  [@@ocaml.doc
    " [drop iovec n] drops [n] characters from [iovec].  @return resulting\n\
    \      I/O-vector.\n\n\
    \      @raise Failure if [n] is greater than length of [iovec].\n\
    \  "]

  val max_iovecs : int Lazy.t
end
[@@ocaml.doc " I/O-vectors for scatter/gather-operations "]

[@@@ocaml.text " {2 I/O functions} "]

val dirfd : dir_handle -> File_descr.t

[@@@ocaml.text " Extract a file descriptor from a directory handle. "]

val sync : unit -> unit [@@ocaml.doc " Synchronize all filesystem buffers with disk. "]

val fsync : File_descr.t -> unit

val fdatasync : File_descr.t -> unit
[@@ocaml.doc
  " Synchronize the kernel buffers of a given file descriptor with disk,\n\
  \    but do not necessarily write file attributes. "]

val read_assume_fd_is_nonblocking : File_descr.t -> ?pos:int -> ?len:int -> Bytes.t -> int
[@@ocaml.doc
  " [read_assume_fd_is_nonblocking fd ?pos ?len buf] calls the system call\n\
  \    [read] ASSUMING THAT IT IS NOT GOING TO BLOCK.  Reads at most [len]\n\
  \    bytes into buffer [buf] starting at position [pos].  @return the\n\
  \    number of bytes actually read.\n\n\
  \    @raise Invalid_argument if buffer range out of bounds.\n\
  \    @raise Unix_error on Unix-errors.\n\n\
  \    @param pos = 0\n\
  \    @param len = [String.length buf - pos]\n"]

val write_assume_fd_is_nonblocking
  :  File_descr.t
  -> ?pos:int
  -> ?len:int
  -> Bytes.t
  -> int
[@@ocaml.doc
  " [write_assume_fd_is_nonblocking fd ?pos ?len buf] calls the system call\n\
  \    [write] ASSUMING THAT IT IS NOT GOING TO BLOCK.  Writes at most [len]\n\
  \    bytes from buffer [buf] starting at position [pos].  @return the\n\
  \    number of bytes actually written.\n\n\
  \    @raise Invalid_argument if buffer range out of bounds.\n\
  \    @raise Unix_error on Unix-errors.\n\n\
  \    @param pos = 0\n\
  \    @param len = [String.length buf - pos]\n"]

val writev_assume_fd_is_nonblocking
  :  File_descr.t
  -> ?count:int
  -> string IOVec.t array
  -> int
[@@ocaml.doc
  " [writev_assume_fd_is_nonblocking fd ?count iovecs] calls the system call\n\
  \    [writev] ASSUMING THAT IT IS NOT GOING TO BLOCK using [count]\n\
  \    I/O-vectors [iovecs].  @return the number of bytes actually written.\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n\
  \    @raise Unix_error on Unix-errors.\n"]

val writev : File_descr.t -> ?count:int -> string IOVec.t array -> int
[@@ocaml.doc
  " [writev fd ?count iovecs] like {!writev_assume_fd_is_nonblocking}, but does\n\
  \    not require the descriptor to not block.  If you feel you have to\n\
  \    use this function, you should probably have chosen I/O-vectors that\n\
  \    build on bigstrings, because this function has to internally blit\n\
  \    the I/O-vectors (ordinary OCaml strings) to intermediate buffers on\n\
  \    the C-heap.\n\n\
  \    @return the number of bytes actually written.\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n\
  \    @raise Unix_error on Unix-errors.\n"]

val pselect
  :  File_descr.t list
  -> File_descr.t list
  -> File_descr.t list
  -> float
  -> int list
  -> File_descr.t list * File_descr.t list * File_descr.t list
[@@ocaml.doc
  " [pselect rfds wfds efds timeout sigmask] like {!Core_unix.select} but\n\
  \    also allows one to wait for the arrival of signals. "]

module RLimit : sig
  module Limit : sig
    type t =
      | Limit of int64
      | Infinity
    [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val min : t -> t -> t
    val max : t -> t -> t
  end

  type limit = Limit.t =
    | Limit of int64
    | Infinity
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_limit : limit -> Sexplib0.Sexp.t
    val limit_of_sexp : Sexplib0.Sexp.t -> limit
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t =
    { cur : limit [@ocaml.doc " soft limit "]
    ; max : limit [@ocaml.doc " hard limit (ceiling for soft limit) "]
    }
  [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type resource [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_resource : resource -> Sexplib0.Sexp.t
    val resource_of_sexp : Sexplib0.Sexp.t -> resource
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val core_file_size : resource
  val cpu_seconds : resource
  val data_segment : resource
  val file_size : resource
  val num_file_descriptors : resource
  val stack : resource
  val virtual_memory : resource Or_error.t
  val nice : resource Or_error.t

  [@@@ocaml.text " See man pages for \"getrlimit\" and \"setrlimit\" for details. "]

  val get : resource -> t
  val set : resource -> t -> unit
end
[@@ocaml.doc " {2 Resource limits} "]

module Resource_usage : sig
  type t =
    { utime : float
    ; stime : float
    ; maxrss : int64
    ; ixrss : int64
    ; idrss : int64
    ; isrss : int64
    ; minflt : int64
    ; majflt : int64
    ; nswap : int64
    ; inblock : int64
    ; oublock : int64
    ; msgsnd : int64
    ; msgrcv : int64
    ; nsignals : int64
    ; nvcsw : int64
    ; nivcsw : int64
    }
  [@@deriving sexp, fields ~getters]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t

    val nivcsw : t -> int64
    val nvcsw : t -> int64
    val nsignals : t -> int64
    val msgrcv : t -> int64
    val msgsnd : t -> int64
    val oublock : t -> int64
    val inblock : t -> int64
    val nswap : t -> int64
    val majflt : t -> int64
    val minflt : t -> int64
    val isrss : t -> int64
    val idrss : t -> int64
    val ixrss : t -> int64
    val maxrss : t -> int64
    val stime : t -> float
    val utime : t -> float
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val get : [ `Self | `Children ] -> t

  val add : t -> t -> t
  [@@ocaml.doc
    " [add ru1 ru2] adds two rusage structures (e.g. your resource usage\n\
    \      and your children's). "]
end
[@@ocaml.doc " {2 Resource usage} -- For details, \"man getrusage\" "]

val wait_with_resource_usage
  :  ?restart:bool
  -> wait_on
  -> (Pid.t * Exit_or_signal.t) * Resource_usage.t

type sysconf =
  | ARG_MAX
  | CHILD_MAX
  | HOST_NAME_MAX
  | LOGIN_NAME_MAX
  | OPEN_MAX
  | PAGESIZE
  | RE_DUP_MAX
  | STREAM_MAX
  | SYMLOOP_MAX
  | TTY_NAME_MAX
  | TZNAME_MAX
  | POSIX_VERSION
  | PHYS_PAGES
  | AVPHYS_PAGES
  | IOV_MAX
  | CLK_TCK
  | NPROCESSORS_CONF
  | NPROCESSORS_ONLN
[@@ocaml.doc " {2 System configuration}  See 'man sysconf' for documentation. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_sysconf : sysconf -> Sexplib0.Sexp.t
  val sysconf_of_sexp : Sexplib0.Sexp.t -> sysconf
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val sysconf : sysconf -> int64 option
[@@ocaml.doc " Wrapper over [sysconf] function in C. "]

val sysconf_exn : sysconf -> int64

[@@@ocaml.text " {2 Temporary file and directory creation} "]

val mkstemp : string -> string * File_descr.t
[@@ocaml.doc
  " [mkstemp prefix] creates and opens a unique temporary file with [prefix],\n\
  \    automatically appending a suffix of [.tmp.] followed by six random characters to \
   make\n\
  \    the name unique.  Unlike C's [mkstemp], [prefix] should not include six X's at the\n\
  \    end.\n\n\
  \    The file descriptor will have close-on-exec flag set, atomically when the O_CLOEXEC\n\
  \    flag is supported.\n\n\
  \    @raise Unix_error on errors.\n"]

val mkdtemp : string -> string
[@@ocaml.doc
  " [mkdtemp prefix] creates a temporary directory with [prefix], automatically appending\n\
  \    a suffix of [.tmp.] followed by six random characters to make the name unique.\n\n\
  \    @raise Unix_error on errors.\n"]

[@@@ocaml.text " {2 Signal handling} "]

val abort : unit -> _
[@@ocaml.doc
  " Causes abnormal program termination unless the signal SIGABRT is\n\
  \    caught and the signal handler does not return.  If the SIGABRT signal is\n\
  \    blocked or ignored, the abort() function will still override it.\n"]

[@@@ocaml.text " {2 User id, group id} "]

val initgroups : string -> int -> unit

val getgrouplist : string -> int -> int array
[@@ocaml.doc
  " [getgrouplist user group] returns the list of groups to which [user] belongs.\n\
  \    See 'man getgrouplist'. "]

val getgroups : unit -> int array
[@@ocaml.doc
  " Return the list of groups to which the user executing the process belongs. "]

[@@@ocaml.text " {2 Globbing and shell expansion} "]

val fnmatch
  :  ?flags:
       [ `No_escape | `Pathname | `Period | `File_name | `Leading_dir | `Casefold ] list
  -> pat:string
  -> string
  -> bool
[@@ocaml.doc " no system calls involved "]

val wordexp
  : (?flags:[ `No_cmd | `Show_err | `Undef ] list -> string -> string array) Or_error.t
[@@ocaml.doc " See man page for wordexp. "]

[@@@ocaml.text " {2 System information} "]

module Utsname : sig
  type t [@@deriving sexp_of, compare]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Ppx_compare_lib.Comparable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val sysname : t -> string
  val nodename : t -> string
  val release : t -> string
  val version : t -> string
  val machine : t -> string

  module Stable : sig
    module V1 : Stable_without_comparator_with_witness with type t = t
  end
end

val uname : unit -> Utsname.t [@@ocaml.doc " See man page for uname. "]

[@@@ocaml.text " {2 Additional IP functionality} "]

val if_indextoname : int -> string
[@@ocaml.doc
  " [if_indextoname ifindex] If [ifindex] is an interface index, then\n\
  \    the function returns the interface name.  Otherwise, it raises\n\
  \    [Unix_error]. "]

val if_nametoindex : string -> int
[@@ocaml.doc
  " [if_nametoindex ifname] If [ifname] is an interface name, then\n\
  \    the function returns the interface index.  Otherwise, it raises\n\
  \    [Unix_error]. "]

val mcast_join : ?ifname:string -> ?source:Inet_addr.t -> File_descr.t -> sockaddr -> unit
[@@ocaml.doc
  " [mcast_join ?ifname ?source sock addr] join a multicast group at [addr] with socket\n\
  \    [sock], from source at [source] if specified, optionally using network interface\n\
  \    [ifname].\n\n\
  \    @param ifname default = any interface\n"]

val mcast_leave
  :  ?ifname:string
  -> ?source:Inet_addr.t
  -> File_descr.t
  -> sockaddr
  -> unit
[@@ocaml.doc
  " [mcast_leave ?ifname ?source sock addr] leaves a multicast group at [addr] with socket\n\
  \    [sock], from source at [source] if specified, optionally using network interface\n\
  \    [ifname].\n\n\
  \    @param ifname default = any interface\n"]

val get_mcast_ttl : File_descr.t -> int
[@@ocaml.doc
  " [get_mcast_ttl sock] reads the time-to-live value of outgoing multicast packets for\n\
  \    socket [sock]. "]

val set_mcast_ttl : File_descr.t -> int -> unit
[@@ocaml.doc
  " [set_mcast_ttl sock ttl] sets the time-to-live value of outgoing multicast packets for\n\
  \    socket [sock] to [ttl]. "]

val get_mcast_loop : File_descr.t -> bool
[@@ocaml.doc
  " [get_mcast_loop sock] reads the boolean argument that determines whether sent\n\
  \    multicast packets are looped back to local sockets. "]

val set_mcast_loop : File_descr.t -> bool -> unit
[@@ocaml.doc
  " [set_mcast_loop sock loop] sets the boolean argument that determines whether sent\n\
  \    multicast packets are looped back to local sockets. "]

val set_mcast_ifname : File_descr.t -> string -> unit
[@@ocaml.doc
  " [set_mcast_ifname sock \"eth0\"] sets outgoing multicast traffic on IPv4 UDP socket\n\
  \    [sock] to go out through interface [eth0].\n\n\
  \    This uses [setsockopt] with [IP_MULTICAST_IF] and applies to multicast traffic.  \
   For\n\
  \    non-multicast applications, see {!Linux_ext.bind_to_interface}. "]

module Scheduler : sig
  module Policy : sig
    type t =
      [ `Fifo
      | `Round_robin
      | `Other
      ]
    [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
      val t_of_sexp : Sexplib0.Sexp.t -> t
      val __t_of_sexp__ : Sexplib0.Sexp.t -> t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val set : pid:Pid.t option -> policy:Policy.t -> priority:int -> unit
  [@@ocaml.doc
    " See [man sched_setscheduler].\n\n\
    \      The [priority] supplied here is *not* the nice value of a process.  It is the\n\
    \      \"static\" priority (1 .. 99) used in conjunction with real-time processes.  \
     If you\n\
    \      want to set the nice value of a normal process, use [Linux_ext.setpriority]\n\
    \      or [Core_unix.nice]. "]
end

module Priority : sig
  val nice : int -> int
end

module Mman : sig
  module Mcl_flags : sig
    type t =
      | Current
      | Future
    [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val mlockall : Mcl_flags.t list -> unit
  [@@ocaml.doc
    " Lock all pages in this process's virtual address space into physical memory. See \
     [man\n\
    \      mlockall] for more details. "]

  val munlockall : unit -> unit
  [@@ocaml.doc " Unlock previously locked pages. See [man munlockall]. "]
end
[@@ocaml.doc
  " For keeping your memory in RAM, i.e. preventing it from being swapped out. "]

module Ifaddr : sig
  module Broadcast_or_destination : sig
    type t =
      | Broadcast of Inet_addr.t
      | Destination of Inet_addr.t
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Flag : sig
    type t =
      | Allmulti
      | Automedia
      | Broadcast
      | Debug
      | Dynamic
      | Loopback
      | Master
      | Multicast
      | Noarp
      | Notrailers
      | Pointopoint
      | Portsel
      | Promisc
      | Running
      | Slave
      | Up
    [@@deriving enumerate, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_enumerate_lib.Enumerable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t

    [@@@ocaml.text "/*"]

    module Private : sig
      val core_unix_iff_to_int : t -> int
      val set_of_int : int -> Set.t
    end
  end

  module Family : sig
    type t =
      | Packet
      | Inet4
      | Inet6
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  type t =
    { name : string
    ; family : Family.t
    ; flags : Flag.Set.t
    ; address : Inet_addr.t option
    ; netmask : Inet_addr.t option
    ; broadcast_or_destination : Broadcast_or_destination.t option
    }
  [@@deriving fields ~getters, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val broadcast_or_destination : t -> Broadcast_or_destination.t option
    val netmask : t -> Inet_addr.t option
    val address : t -> Inet_addr.t option
    val flags : t -> Flag.Set.t
    val family : t -> Family.t
    val name : t -> string
    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc " A network interface on the local machine.  See [man getifaddrs]. "]

val getifaddrs : unit -> Ifaddr.t list
val get_all_ifnames : unit -> string list

module Expert : sig
  val exec
    :  prog:string
    -> argv:string array
    -> use_path:bool
    -> env:string array option
    -> never_returns
  [@@ocaml.doc
    " [Expert.exec] is essentially equivalent to the non-expert [exec], but it allocates\n\
    \      less. "]
end

module Stable : sig
  module Inet_addr = Inet_addr.Stable
  module Cidr = Cidr.Stable
  module Signal = Signal.Stable
  module Utsname = Utsname.Stable
end
