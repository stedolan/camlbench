open! Core
open! Iobuf
module Unix := Core_unix

type ok_or_eof =
  | Ok
  | Eof
[@@deriving compare, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val compare_ok_or_eof : ok_or_eof -> (ok_or_eof[@merlin.hide]) -> int
  val sexp_of_ok_or_eof : ok_or_eof -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val input : ([> write ], seek) t -> In_channel.t -> ok_or_eof
[@@ocaml.doc
  " [Iobuf] has analogs of various [Bigstring] functions.  These analogs advance by the\n\
  \    amount written/read. "]

val read : ([> write ], seek) t -> Unix.File_descr.t -> ok_or_eof

val read_assume_fd_is_nonblocking
  :  ([> write ], seek) t
  -> Unix.File_descr.t
  -> Unix.Syscall_result.Unit.t

val pread_assume_fd_is_nonblocking
  :  ([> write ], seek) t
  -> Unix.File_descr.t
  -> offset:int
  -> unit

val recvfrom_assume_fd_is_nonblocking
  :  ([> write ], seek) t
  -> Unix.File_descr.t
  -> Unix.sockaddr

module Recvmmsg_context : sig
    type ('rw, 'seek) iobuf
    type t

    val create : (read_write, seek) iobuf array -> t
    [@@ocaml.doc
      " Do not change these [Iobuf]'s [buf]s or limits before calling\n\
      \      [recvmmsg_assume_fd_is_nonblocking]. "]
  end
  with type ('rw, 'seek) iobuf := ('rw, 'seek) t
[@@ocaml.doc
  " [recvmmsg]'s context comprises data needed by the system call.  Setup can be\n\
  \    expensive, particularly for many buffers.\n\n\
  \    NOTE: Unlike most system calls involving iobufs, the lo offset is not respected.\n\
  \    Instead, the iobuf is implicity [reset] (i.e., [lo <- lo_min] and [hi <- hi_max])\n\
  \    prior to reading and a [flip_lo] applied afterward.  This is to prevent the\n\
  \    memory-unsafe case where an iobuf's lo pointer is advanced and [recvmmsg] \
   attempts to\n\
  \    copy into memory exceeding the underlying [bigstring]'s capacity.  If any of the\n\
  \    returned iobufs have had their underlying bigstring or limits changed (e.g., \
   through a\n\
  \    call to [set_bounds_and_buffer] or [narrow_lo]), the call will fail with \
   [EINVAL]. "]

val recvmmsg_assume_fd_is_nonblocking
  : (Unix.File_descr.t -> Recvmmsg_context.t -> Unix.Syscall_result.Int.t) Or_error.t
[@@ocaml.doc
  " [recvmmsg_assume_fd_is_nonblocking fd context] returns the number of [context] iobufs\n\
  \    read into (or [errno]).  [fd] must not block.  [THREAD_IO_CUTOFF] is ignored.\n\n\
  \    [EINVAL] is returned if an [Iobuf] passed to [Recvmmsg_context.create] has its \
   [buf]\n\
  \    or limits changed. "]

val send_nonblocking_no_sigpipe
  :  unit
  -> (([> read ], seek) t -> Unix.File_descr.t -> Unix.Syscall_result.Unit.t) Or_error.t

val sendto_nonblocking_no_sigpipe
  :  unit
  -> (([> read ], seek) t
      -> Unix.File_descr.t
      -> Unix.sockaddr
      -> Unix.Syscall_result.Unit.t)
       Or_error.t

module Peek : sig
  val output : ([> read ], _) t -> Out_channel.t -> int
  val write : ([> read ], _) t -> Unix.File_descr.t -> int
  val write_assume_fd_is_nonblocking : ([> read ], _) t -> Unix.File_descr.t -> int
end
[@@ocaml.doc
  " Write from the iobuf to the specified channel without changing the iobuf\n\
  \    window.  Returns the number of bytes written. "]

val output : ([> read ], seek) t -> Out_channel.t -> unit
[@@ocaml.doc " As [Peek], but advances the window by the number of bytes written. "]

val write : ([> read ], seek) t -> Unix.File_descr.t -> unit
val write_assume_fd_is_nonblocking : ([> read ], seek) t -> Unix.File_descr.t -> unit

val pwrite_assume_fd_is_nonblocking
  :  ([> read ], seek) t
  -> Unix.File_descr.t
  -> offset:int
  -> unit

module In_channel_optimized : sig
  type 'a channel_op_with_opts :=
    ?fix_win_eol:(bool[@ocaml.doc " defaults to [true] "])
    -> ?buf:
         ((read_write, seek) t
         [@ocaml.doc
           " Allocates a fresh buffer by default; will merrily resize (and rebind!) any \
            passed\n\
           \        buffer. "])
    -> In_channel.t
    -> 'a

  val fold_lines : (init:'a -> f:('a -> string -> 'a) -> 'a) channel_op_with_opts
  val iter_lines : (f:(string -> unit) -> unit) channel_op_with_opts
  val input_lines : string array channel_op_with_opts

  val fold_lines_raw
    : (init:'a -> f:('a -> (read_write, seek) t -> 'a) -> 'a) channel_op_with_opts
  [@@ocaml.doc
    " More efficient than [fold_lines] because no string allocation/copying.\n  "]
end
[@@ocaml.doc
  " As similar APIs in [In_channel], but using an intermediate [Iobuf]; considerably\n\
  \    faster. "]

[@@@ocaml.text " {2 Expert} "]

module Expert : sig
  val fillf_float
    :  (read_write, seek) t
    -> c_format:string
    -> float
    -> [ `Ok | `Truncated | `Format_error ]
  [@@ocaml.doc
    " [fillf_float t ~c_format float] attempts to fill a string representation of a float\n\
    \      into an iobuf at the current position. The representation is specified by \
     standard C\n\
    \      [printf] formatting codes.\n\n\
    \      The highest available byte of the window is unusable and will be set to 0 in \
     the\n\
    \      case that a properly formatted string would otherwise fully fill the window.\n\n\
    \      If there is enough room in (window - 1) to format the float as specified then \
     [`Ok]\n\
    \      is returned and the window is advanced past the written bytes.\n\n\
    \      If there is not enough room in (window - 1) to format as specified then \
     [`Truncated]\n\
    \      is returned.\n\n\
    \      If C [snprintf] indicates a format error then [`Format_error] is returned.\n\n\
    \      Operation is unsafe if a format code not intended for a double precision \
     float is\n\
    \      used (e.g., %s) or if more than one format specifier is provided, etc. "]

  val to_iovec_shared : ?pos:int -> ?len:int -> (_, _) t -> Bigstring.t Unix.IOVec.t
end
[@@ocaml.doc
  " The [Expert] module is for building efficient out-of-module [Iobuf] abstractions. "]
