[@@@ocaml.text
  " String type based on [Bigarray], for use in I/O and C-bindings, extending\n\
  \    {{!Core.Bigstring}[Core.Bigstring]}. "]

open! Core
module Unix := Core_unix

include module type of struct
  include Core.Bigstring
end

exception
  IOError of int * exn
      [@ocaml.doc
        " Type of I/O errors.\n\n\
        \    In [IOError (n, exn)], [n] is the number of bytes successfully read/written \
         before the\n\
        \    error and [exn] is the exception that occurred (e.g., [Unix_error], \
         [End_of_file]) "]

[@@@ocaml.text " {2 Input functions} "]

val read
  :  ?min_len:(int[@ocaml.doc " default = 0 "])
  -> Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [read ?min_len fd ?pos ?len bstr] reads at least [min_len] (must be [>= 0]) and at\n\
  \    most [len] (must be [>= min_len]) bytes from file descriptor [fd], and writes \
   them to\n\
  \    bigstring [bstr] starting at position [pos].  Returns the number of bytes actually\n\
  \    read.\n\n\
  \    [read] returns zero only if [len = 0].  If [len > 0] and there's nothing left to \
   read,\n\
  \    [read] raises to indicate EOF even if [min_len = 0].\n\n\
  \    NOTE: Even if [len] is zero, there may still be errors when reading from the\n\
  \    descriptor!\n\n\
  \    Raises [Invalid_argument] if the designated ranges are out of bounds.  Raises\n\
  \    [IOError] in the case of input errors, or on EOF if the minimum length could not be\n\
  \    read. "]

val really_read
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " [really_read fd ?pos ?len bstr] reads [len] bytes from file descriptor [fd], and\n\
  \    writes them to bigstring [bstr] starting at position [pos].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.\n\
  \    Raises [IOError] in the case of input errors, or on EOF. "]

val really_recv
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " [really_recv sock ?pos ?len bstr] receives [len] bytes from socket [sock], and writes\n\
  \    them to bigstring [bstr] starting at position [pos].  If [len] is zero, the \
   function\n\
  \    returns immediately without performing the underlying system call.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises \
   [IOError]\n\
  \    in the case of input errors, or on EOF. "]

val recv_peek_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> len:int
  -> t
  -> int
[@@ocaml.doc
  " [recv_peek_assume_fd_is_nonblocking sock ?pos ~len bstr] peeks [len] bytes from socket\n\
  \    [sock], and writes them to bigstring [bstr] starting at position [pos].  If [len] \
   is\n\
  \    zero, the function returns immediately without performing the underlying system \
   call.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises \
   [Unix_error]\n\
  \    in the case of input errors "]

val recvfrom_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int * Unix.sockaddr
[@@ocaml.doc
  " [recvfrom_assume_fd_is_nonblocking sock ?pos ?len bstr] reads up to [len] bytes into\n\
  \    bigstring [bstr] starting at position [pos] from socket [sock] without yielding to\n\
  \    other OCaml-threads.\n\n\
  \    Returns the number of bytes actually read and the socket address of the client.\n\n\
  \    Raises [Unix_error] in the case of input errors.  Raises [Invalid_argument] if the\n\
  \    designated range is out of bounds. "]

val read_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> Unix.Syscall_result.Int.t
[@@ocaml.doc
  " [read_assume_fd_is_nonblocking fd ?pos ?len bstr] reads up to [len] bytes into\n\
  \    bigstring [bstr] starting at position [pos] from file descriptor [fd] without \
   yielding\n\
  \    to other OCaml-threads.  Returns the number of bytes actually read.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds. "]

val pread
  :  ?min_len:int
  -> Unix.File_descr.t
  -> offset:int
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc " Like [read] but uses [pread] to read from the given offset in the file. "]

val really_pread
  :  Unix.File_descr.t
  -> offset:int
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " Like [really_read] but uses [pread] to read from the given offset in the file. "]

val pread_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> offset:int
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [pread_assume_fd_is_nonblocking fd ~offset ?pos ?len bstr] reads up to [len] bytes\n\
  \    from file descriptor [fd] at offset [offset], and writes them to bigstring [bstr]\n\
  \    starting at position [pos].  The [fd] must be capable of seeking, and the current \
   file\n\
  \    offset used for a regular [read()] is unchanged. Please see [man pread] for more\n\
  \    information. Returns the number of bytes actually read.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of input errors. "]

val input
  :  ?min_len:(int[@ocaml.doc " default = 0 "])
  -> In_channel.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [input ?min_len ic ?pos ?len bstr] tries to read [len] bytes (guarantees to read at\n\
  \    least [min_len] bytes, which must be [>= 0] and [<= len]), if possible, before\n\
  \    returning, from input channel [ic], and writes them to bigstring [bstr] starting at\n\
  \    position [pos].  Returns the number of bytes actually read.\n\n\
  \    NOTE: Even if [len] is zero, there may still be errors when reading from the\n\
  \    descriptor, which will be done if the internal buffer is empty!\n\n\
  \    NOTE: If at least [len] characters are available in the input channel buffer and if\n\
  \    [len] is not zero, data will only be fetched from the channel buffer.  Otherwise \
   data\n\
  \    will be read until at least [min_len] characters are available.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises \
   [IOError]\n\
  \    in the case of input errors, or on premature EOF. "]

val really_input
  :  In_channel.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " [really_input ic ?pos ?len bstr] reads exactly [len] bytes from input channel [ic],\n\
  \    and writes them to bigstring [bstr] starting at position [pos].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.\n\
  \    Raises [IOError] in the case of input errors, or on premature EOF. "]

[@@@ocaml.text " {2 Output functions} "]

val really_write
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " [really_write fd ?pos ?len bstr] writes [len] bytes in bigstring [bstr] starting at\n\
  \    position [pos] to file descriptor [fd].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises \
   [IOError]\n\
  \    in the case of output errors. "]

val really_send_no_sigpipe
  : (Unix.File_descr.t
     -> ?pos:(int[@ocaml.doc " default = 0 "])
     -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
     -> t
     -> unit)
      Or_error.t
[@@ocaml.doc
  " [really_send_no_sigpipe sock ?pos ?len bstr] sends [len] bytes in bigstring [bstr]\n\
  \    starting at position [pos] to socket [sock] without blocking and ignoring \
   [SIGPIPE].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.\n\
  \    Raises [IOError] in the case of output errors.\n\n\
  \    [really_send_no_sigpipe] is not implemented on some platforms, in which case it\n\
  \    returns an [Error] value indicating that it is unimplemented. "]

val send_nonblocking_no_sigpipe
  : (Unix.File_descr.t
     -> ?pos:(int[@ocaml.doc " default = 0 "])
     -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
     -> t
     -> Unix.Syscall_result.Int.t)
      Or_error.t
[@@ocaml.doc
  " [send_nonblocking_no_sigpipe sock ?pos ?len bstr] tries to send [len] bytes in\n\
  \    bigstring [bstr] starting at position [pos] to socket [sock]. Returns \
   [bytes_written].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds. "]

val sendto_nonblocking_no_sigpipe
  : (Unix.File_descr.t
     -> ?pos:(int[@ocaml.doc " default = 0 "])
     -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
     -> t
     -> Unix.sockaddr
     -> Unix.Syscall_result.Int.t)
      Or_error.t
[@@ocaml.doc
  " [sendto_nonblocking_no_sigpipe sock ?pos ?len bstr sockaddr] tries to send [len] bytes\n\
  \    in bigstring [bstr] starting at position [pos] to socket [sock] using address\n\
  \    [addr]. Returns [bytes_written].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds. "]

val write
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [write fd ?pos ?len bstr] writes [len] bytes in bigstring [bstr] starting at position\n\
  \    [pos] to file descriptor [fd].  Returns the number of bytes actually written.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of output errors. "]

val pwrite_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> offset:int
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [pwrite_assume_fd_is_nonblocking fd ~offset ?pos ?len bstr] writes up to [len] bytes\n\
  \    of bigstring [bstr] starting at position [pos] to file descriptor [fd] at position\n\
  \    [offset].  The [fd] must be capable of seeking, and the current file offset used \
   for\n\
  \    non-positional [read()]/[write()] calls is unchanged. Returns the number of bytes\n\
  \    written.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of output errors. "]

val write_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [write_assume_fd_is_nonblocking fd ?pos ?len bstr] writes [len] bytes in bigstring\n\
  \    [bstr] starting at position [pos] to file descriptor [fd] without yielding to other\n\
  \    OCaml-threads. Returns the number of bytes actually written.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of output errors. "]

val writev
  :  Unix.File_descr.t
  -> ?count:(int[@ocaml.doc " default = [Array.length iovecs] "])
  -> t Unix.IOVec.t array
  -> int
[@@ocaml.doc
  " [writev fd ?count iovecs] writes [count] [iovecs] of bigstrings to file descriptor\n\
  \    [fd]. Returns the number of bytes written.\n\n\
  \    Raises [Invalid_argument] if [count] is out of range.  Raises [Unix_error] in the \
   case\n\
  \    of output errors. "]

val writev_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> ?count:(int[@ocaml.doc " default = [Array.length iovecs] "])
  -> t Unix.IOVec.t array
  -> int
[@@ocaml.doc
  " [writev_assume_fd_is_nonblocking fd ?count iovecs] writes [count] [iovecs] of\n\
  \    bigstrings to file descriptor [fd] without yielding to other OCaml-threads. Returns\n\
  \    the number of bytes actually written.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of output errors. "]

val recvmmsg_assume_fd_is_nonblocking
  : (Unix.File_descr.t
     -> ?count:(int[@ocaml.doc " default = [Array.length iovecs] "])
     -> ?srcs:Unix.sockaddr array
     -> t Unix.IOVec.t array
     -> lens:int array
     -> int)
      Or_error.t
[@@ocaml.doc
  " [recvmmsg_assume_fd_is_nonblocking fd iovecs ~count ~lens] receives up to [count]\n\
  \    messages into [iovecs] from file descriptor [fd] without yielding to other OCaml\n\
  \    threads. If [~count] is supplied, it must be that [0 <= count <= Array.length\n\
  \    iovecs]. If [~srcs] is supplied, saves the source addresses for corresponding \
   received\n\
  \    messages there.  If supplied, [Array.length srcs] must be [>= count]. Saves the\n\
  \    lengths of the received messages in [lens]. It is required that [Array.length \
   lens >=\n\
  \    count].\n\n\
  \    If an IOVec isn't long enough for its corresponding message, excess bytes may be\n\
  \    discarded, depending on the type of socket the message is received from.  While the\n\
  \    [recvmmsg] system call itself does return details of such truncation, etc., those\n\
  \    details are not (yet) passed through this interface.\n\n\
  \    See [\"recvmmsg(2)\"] re. the underlying system call.\n\n\
  \    Returns the number of messages actually read, or a negative number to indicate\n\
  \    [EWOULDBLOCK] or [EAGAIN]. This is a compromise to mitigate the exception \
   overhead for\n\
  \    what ends up being a very common result with our use of [recvmmsg].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.  Raises\n\
  \    [Unix_error] in the case of output errors. "]

val unsafe_recvmmsg_assume_fd_is_nonblocking
  : (Unix.File_descr.t
     -> t Unix.IOVec.t array
     -> int
     -> Unix.sockaddr array option
     -> int array
     -> int)
      Or_error.t

val sendmsg_nonblocking_no_sigpipe
  : (Unix.File_descr.t
     -> ?count:(int[@ocaml.doc " default = [Array.length iovecs] "])
     -> t Unix.IOVec.t array
     -> int option)
      Or_error.t
[@@ocaml.doc
  " [sendmsg_nonblocking_no_sigpipe sock ?count iovecs] sends [count] [iovecs] of\n\
  \    bigstrings to socket [sock]. Returns [Some bytes_written], or [None] if the \
   operation\n\
  \    would have blocked.  This system call will not cause signal [SIGPIPE] if an \
   attempt is\n\
  \    made to write to a socket that was closed by the other side.\n\n\
  \    Raises [Invalid_argument] if [count] is out of range.  Raises [Unix_error] in the \
   case\n\
  \    of output errors. "]

val output
  :  ?min_len:(int[@ocaml.doc " default = 0 "])
  -> Out_channel.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> int
[@@ocaml.doc
  " [output ?min_len oc ?pos ?len bstr] tries to output [len] bytes (guarantees to write\n\
  \    at least [min_len] bytes, which must be [>= 0]), if possible, before returning, \
   from\n\
  \    bigstring [bstr] starting at position [pos] to output channel [oc]. Returns the\n\
  \    number of bytes actually written.\n\n\
  \    NOTE: You may need to flush [oc] to make sure that the data is actually sent.\n\n\
  \    NOTE: If [len] characters fit into the channel buffer completely, they will be\n\
  \    buffered.  Otherwise writes will be attempted until at least [min_len] characters \
   have\n\
  \    been sent.\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.\n\n\
  \    Raises [IOError] in the case of output errors. The [IOError] argument counting the\n\
  \    number of successful bytes includes those that have been transferred to the channel\n\
  \    buffer before the error. "]

val really_output
  :  Out_channel.t
  -> ?pos:(int[@ocaml.doc " default = 0 "])
  -> ?len:(int[@ocaml.doc " default = [length bstr - pos] "])
  -> t
  -> unit
[@@ocaml.doc
  " [really_output oc ?pos ?len bstr] outputs exactly [len] bytes from bigstring [bstr]\n\
  \    starting at position [pos] to output channel [oc].\n\n\
  \    Raises [Invalid_argument] if the designated range is out of bounds.\n\n\
  \    Raises [IOError] in the case of output errors.  The [IOError] argument counting the\n\
  \    number of successful bytes includes those that have been transferred to the channel\n\
  \    buffer before the error. "]

[@@@ocaml.text " {2 Unsafe functions} "]

external unsafe_read_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> Unix.Syscall_result.Int.t
  = "bigstring_read_assume_fd_is_nonblocking_stub"
[@@ocaml.doc
  " [unsafe_read_assume_fd_is_nonblocking fd ~pos ~len bstr] is similar to\n\
  \    {!Bigstring.read_assume_fd_is_nonblocking}, but does not perform any bounds checks.\n\
  \    Will crash on bounds errors! "]

external unsafe_write
  :  Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> int
  = "bigstring_write_stub"
[@@ocaml.doc
  " [unsafe_write fd ~pos ~len bstr] is similar to {!Bigstring.write}, but does not\n\
  \    perform any bounds checks.  Will crash on bounds errors! "]

external unsafe_write_assume_fd_is_nonblocking
  :  Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> int
  = "bigstring_write_assume_fd_is_nonblocking_stub"
[@@ocaml.doc
  " [unsafe_write_assume_fd_is_nonblocking fd ~pos ~len bstr] is similar to\n\
  \    {!Bigstring.write_assume_fd_is_nonblocking}, but does not perform any bounds \
   checks.\n\
  \    Will crash on bounds errors! "]

external unsafe_read
  :  min_len:int
  -> Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> int
  = "bigstring_read_stub"
[@@ocaml.doc
  " [unsafe_read ~min_len fd ~pos ~len bstr] is similar to {!Bigstring.read}, but does not\n\
  \    perform any bounds checks.  Will crash on bounds errors! "]

external unsafe_really_recv
  :  Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> unit
  = "bigstring_really_recv_stub"
[@@ocaml.doc
  " [unsafe_really_recv sock ~pos ~len bstr] is similar to {!Bigstring.really_recv}, but\n\
  \    does not perform any bounds checks.  Will crash on bounds errors! "]

external unsafe_really_write
  :  Unix.File_descr.t
  -> pos:int
  -> len:int
  -> t
  -> unit
  = "bigstring_really_write_stub"
[@@ocaml.doc
  " [unsafe_really_write fd ~pos ~len bstr] is similar to {!Bigstring.write}, but does not\n\
  \    perform any bounds checks.  Will crash on bounds errors! "]

val unsafe_really_send_no_sigpipe
  : (Unix.File_descr.t -> pos:int -> len:int -> t -> unit) Or_error.t
[@@ocaml.doc
  " [unsafe_really_send_no_sigpipe sock ~pos ~len bstr] is similar to {!Bigstring.send},\n\
  \    but does not perform any bounds checks.  Will crash on bounds errors! "]

val unsafe_send_nonblocking_no_sigpipe
  : (Unix.File_descr.t -> pos:int -> len:int -> t -> Unix.Syscall_result.Int.t) Or_error.t
[@@ocaml.doc
  " [unsafe_send_nonblocking_no_sigpipe sock ~pos ~len bstr] is similar to\n\
  \    {!Bigstring.send_nonblocking_no_sigpipe}, but does not perform any bounds checks.\n\
  \    Will crash on bounds errors! "]

external unsafe_writev
  :  Unix.File_descr.t
  -> t Unix.IOVec.t array
  -> int
  -> int
  = "bigstring_writev_stub"
[@@ocaml.doc
  " [unsafe_writev fd iovecs count] is similar to {!Bigstring.writev}, but does not\n\
  \    perform any bounds checks.  Will crash on bounds errors! "]

val unsafe_sendmsg_nonblocking_no_sigpipe
  : (Unix.File_descr.t -> t Unix.IOVec.t array -> int -> int option) Or_error.t
[@@ocaml.doc
  " [unsafe_sendmsg_nonblocking_no_sigpipe fd iovecs count] is similar to\n\
  \    {!Bigstring.sendmsg_nonblocking_no_sigpipe}, but does not perform any bounds \
   checks.\n\
  \    Will crash on bounds errors! "]

external unsafe_input
  :  min_len:int
  -> In_channel.t
  -> pos:int
  -> len:int
  -> t
  -> int
  = "bigstring_input_stub"
[@@ocaml.doc
  " [unsafe_input ~min_len ic ~pos ~len bstr] is similar to {!Bigstring.input}, but does\n\
  \    not perform any bounds checks. Will crash on bounds errors! "]

external unsafe_output
  :  min_len:int
  -> Out_channel.t
  -> pos:int
  -> len:int
  -> t
  -> int
  = "bigstring_output_stub"
[@@ocaml.doc
  " [unsafe_output ~min_len oc ~pos ~len bstr] is similar to {!Bigstring.output}, but does\n\
  \    not perform any bounds checks.  Will crash on bounds errors! "]

[@@@ocaml.text " {2 Memory mapping} "]

val map_file : shared:bool -> Unix.File_descr.t -> int -> t
[@@ocaml.doc
  " [map_file shared fd n] memory-maps [n] characters of the data associated with\n\
  \    descriptor [fd] to a bigstring.  Iff [shared] is [true], all changes to the \
   bigstring\n\
  \    will be reflected in the file.\n\n\
  \    Users must keep in mind that operations on the resulting bigstring may result in \
   disk\n\
  \    operations which block the runtime.  This is true for pure OCaml operations (such \
   as\n\
  \    [t.{1} <- 1]), and for calls to [blit].  While some I/O operations may release the\n\
  \    OCaml lock, users should not expect this to be done for all operations on a \
   bigstring\n\
  \    returned from [map_file].  "]
