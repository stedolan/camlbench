[@@@ocaml.text
  " This module provides support for daemonizing a process.  It provides flexibility as to\n\
  \    where the standard file descriptors (stdin, stdout and stderr) are connected after\n\
  \    daemonization has occurred. "]

open! Core
open! Import

module Fd_redirection : sig
  type t =
    [ `Dev_null
    | `Dev_null_skip_regular_files
      [@ocaml.doc
        " Redirect to /dev/null unless already redirected to\n\
        \                                       a regular file. "]
    | `Do_not_redirect
    | `File_append of string
    | `File_truncate of string
    ]
end

val daemonize
  :  ?redirect_stdout:Fd_redirection.t
  -> ?redirect_stderr:Fd_redirection.t
  -> ?cd:string
  -> ?perm:
       (int
       [@ocaml.doc
         " permission to pass to [openfile] when using [`File_append] or\n\
         \                     [`File_truncate] "])
  -> ?umask:(int[@ocaml.doc " defaults to use existing umask "])
  -> ?allow_threads_to_have_been_created:(bool[@ocaml.doc " defaults to false "])
  -> unit
  -> unit
[@@ocaml.doc
  " [daemonize] makes the executing process a daemon.\n\n\
  \    The optional arguments have defaults as per [daemonize_wait], below.\n\n\
  \    By default, output sent to stdout and stderr after daemonization will be silently\n\
  \    eaten.  This behaviour may be adjusted by using [redirect_stdout] and\n\
  \    [redirect_stderr].  See the documentation for [daemonize_wait] below.\n\n\
  \    See [daemonize_wait] for a description of [allow_threads_to_have_been_created].\n\n\
  \    Raises [Failure] if fork was unsuccessful. "]

val daemonize_wait
  :  ?redirect_stdout:
       (Fd_redirection.t[@ocaml.doc " default `Dev_null_skip_regular_files "])
  -> ?redirect_stderr:
       (Fd_redirection.t[@ocaml.doc " default `Dev_null_skip_regular_files "])
  -> ?cd:(string[@ocaml.doc " default / "])
  -> ?perm:
       (int
       [@ocaml.doc
         " permission to pass to [openfile] when using [`File_append] or\n\
         \                     [`File_truncate] "])
  -> ?umask:(int[@ocaml.doc " defaults to use existing umask "])
  -> ?allow_threads_to_have_been_created:(bool[@ocaml.doc " defaults to false "])
  -> unit
  -> (unit -> unit) Staged.t
[@@ocaml.doc
  " [daemonize_wait] makes the executing process a daemon, but delays full detachment from\n\
  \    the calling shell/process until the returned \"release\" closure is called.\n\n\
  \    Any output to stdout/stderr before the \"release\" closure is called will get\n\
  \    sent out normally. After \"release\" is called, stdin is connected to /dev/null,\n\
  \    and stdout and stderr are connected as specified by [redirect_stdout] and\n\
  \    [redirect_stderr]. The default is the usual behavior whereby both of these\n\
  \    descriptors are connected to /dev/null. [daemonize_wait], however, will not\n\
  \    redirect stdout/stderr to /dev/null if they are already redirected to a regular\n\
  \    file by default, i.e., default redirection is [`Dev_null_skip_regular_files]. This\n\
  \    is to preserve behavior from earlier versions.)\n\n\
  \    Note that calling [release] will adjust SIGPIPE handling, so you should not rely on\n\
  \    the delivery of this signal during this time.\n\n\
  \    [daemonize_wait] allows you to daemonize and then start asynchronously, but still \
   have\n\
  \    stdout/stderr go to the controlling terminal during startup. By default, when you\n\
  \    [daemonize], toplevel exceptions during startup would get sent to /dev/null. With\n\
  \    [daemonize_wait], toplevel exceptions can go to the terminal until you call \
   [release].\n\n\
  \    Forking (especially to daemonize) when running multiple threads is tricky and\n\
  \    generally a mistake. [daemonize] and [daemonize_wait] check that the current \
   number of\n\
  \    threads is not greater than expected. [daemonize_wait] and [daemonize] also check \
   that\n\
  \    threads have not been created, which is more conservative than the actual \
   requirement\n\
  \    that multiple threads are not running. Using\n\
  \    [~allow_threads_to_have_been_created:true] bypasses that check. This is useful if\n\
  \    Async was previously running, and therefore threads have been created, but has \
   since\n\
  \    been shut down. On non-Linux platforms, using\n\
  \    [~allow_threads_to_have_been_created:true] eliminates the protection [daemonize] \
   and\n\
  \    [daemonize_wait] have regarding threads.\n\n\
  \    Raises [Failure] if forking was unsuccessful. "]
