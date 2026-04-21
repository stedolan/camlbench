let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"linux_ext_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "linux_ext_intf.ml.before-ppx"
;;

open! Core
open Core_unix
module Thread = Core_thread

module type S = sig
  [@@@ocaml.text " {2 sysinfo} "]

  module Sysinfo : sig
    type t =
      { uptime : Time_float.Span.t [@ocaml.doc " Time since boot "]
      ; load1 : int [@ocaml.doc " Load average over the last minute "]
      ; load5 : int [@ocaml.doc " Load average over the last 5 minutes"]
      ; load15 : int [@ocaml.doc " Load average over the last 15 minutes "]
      ; total_ram : int [@ocaml.doc " Total usable main memory "]
      ; free_ram : int [@ocaml.doc " Available memory size "]
      ; shared_ram : int [@ocaml.doc " Amount of shared memory "]
      ; buffer_ram : int [@ocaml.doc " Memory used by buffers "]
      ; total_swap : int [@ocaml.doc " Total swap page size "]
      ; free_swap : int [@ocaml.doc " Available swap space "]
      ; procs : int [@ocaml.doc " Number of current processes "]
      ; totalhigh : int [@ocaml.doc " Total high memory size "]
      ; freehigh : int [@ocaml.doc " Available high memory size "]
      ; mem_unit : int [@ocaml.doc " Memory unit size in bytes "]
      }
    [@@ocaml.doc " Result of sysinfo syscall (man 2 sysinfo). "] [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val sysinfo : (unit -> t) Or_error.t
  end

  [@@@ocaml.text " {2 Filesystem functions} "]

  val sendfile
    : (?pos:(int[@ocaml.doc " Defaults to 0. "])
       -> ?len:
            (int
            [@ocaml.doc
              " Defaults to length of data (file) associated with descriptor [fd]. "])
       -> fd:File_descr.t
       -> File_descr.t
       -> int)
        Or_error.t
  [@@ocaml.doc
    " [sendfile ?pos ?len ~fd sock] sends mmap-able data from file descriptor [fd] to\n\
    \      socket [sock] using offset [pos] and length [len]. Returns the number of \
     characters\n\
    \      actually written.\n\n\
    \      NOTE: If the returned value is unequal to what was requested (= the initial \
     size of\n\
    \      the data by default), the system call may have been interrupted by a signal, \
     the\n\
    \      source file may have been truncated during operation, or a timeout may have \
     occurred\n\
    \      on the socket during sending.  It is currently impossible to find out which \
     of these\n\
    \      events actually happened.  Calling {!sendfile} several times on the same \
     descriptor\n\
    \      that only partially accepted data due to a timeout will eventually lead to \
     the Unix\n\
    \      error [EAGAIN].\n\n\
    \      Raises [Unix_error] on Unix-errors. "]

  module Bound_to_interface : sig
    type t =
      | Any
      | Only of string
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Type for status of SO_BINDTODEVICE socket option. The socket may either restrict the\n\
    \      traffic to a given (by name, e.g. \"eth0\") interface, or do no restriction \
     at all. "]

  [@@@ocaml.text " {2 Non-portable TCP functionality} "]

  type tcp_bool_option =
    | TCP_CORK
    [@ocaml.doc
      " (Since Linux 2.2) If set, don\226\128\153t send out partial frames.  All queued \
       partial\n\
      \        frames are sent when the option is cleared again.  This is useful for \
       prepending\n\
      \        headers before calling [sendfile(2)], or for throughput optimization.  As\n\
      \        currently implemented, there is a 200ms ceiling on the time for which \
       output is\n\
      \        corked by TCP_CORK.  If this ceiling is reached, queued data is \
       automatically\n\
      \        transmitted.\n\n\
      \        This option should not be used in code intended to be portable. "]
    | TCP_QUICKACK
    [@ocaml.doc
      " (Since Linux 2.4.4) Quick ack solves an unfortunate interaction between the\n\
      \        delayed acks and the Nagle algorithm (TCP_NODELAY).  On fast LANs, the \
       Linux TCP\n\
      \        stack quickly reaches a CWND (congestion window) of 1 (Linux interprets \
       this as \"1\n\
      \        unacknowledged packet\", BSD/Windows and others consider it \"1 \
       unacknowledged\n\
      \        segment of data\").\n\n\
      \        If Linux determines a connection to be bidirectional, it will delay \
       sending acks,\n\
      \        hoping to bundle them with other outgoing data.  This can lead to serious\n\
      \        connection stalls on, say, a TCP market data connection with one second\n\
      \        heartbeats.  TCP_QUICKACK can be used to prevent entering this delayed \
       ack state.\n\n\
      \        This option should not be used in code intended to be portable. "]
  [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_tcp_bool_option : tcp_bool_option -> Sexplib0.Sexp.t
    val tcp_bool_option_of_sexp : Sexplib0.Sexp.t -> tcp_bool_option
    val bin_shape_tcp_bool_option : Bin_prot.Shape.t
    val bin_size_tcp_bool_option : tcp_bool_option Bin_prot.Size.sizer
    val bin_write_tcp_bool_option : tcp_bool_option Bin_prot.Write.writer
    val bin_writer_tcp_bool_option : tcp_bool_option Bin_prot.Type_class.writer
    val bin_read_tcp_bool_option : tcp_bool_option Bin_prot.Read.reader
    val __bin_read_tcp_bool_option__ : (int -> tcp_bool_option) Bin_prot.Read.reader
    val bin_reader_tcp_bool_option : tcp_bool_option Bin_prot.Type_class.reader
    val bin_tcp_bool_option : tcp_bool_option Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type tcp_string_option =
    | TCP_CONGESTION
    [@ocaml.doc
      " (Since Linux 2.6.13) Get or set the congestion-control algorithm for this \
       socket.\n\n\
      \        The algorithm \"reno\" is always permitted; other algorithms may be \
       available,\n\
      \        depending on kernel configuration and loaded modules (see\n\
      \        /proc/sys/net/ipv4/tcp_allowed_congestion_control; add more using \
       modprobe).\n\n\
      \        \"man 7 tcp\" states that getsockopt(... TCP_CONGESTION ...) can return \
       the empty\n\
      \        string to indicate \"uses the default congestion algorithm\", but this \
       does not seem\n\
      \        to be necessarily true; sometimes in that situation it will just return \
       the name\n\
      \        of the default congestion algorithm. "]
  [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_tcp_string_option : tcp_string_option -> Sexplib0.Sexp.t
    val tcp_string_option_of_sexp : Sexplib0.Sexp.t -> tcp_string_option
    val bin_shape_tcp_string_option : Bin_prot.Shape.t
    val bin_size_tcp_string_option : tcp_string_option Bin_prot.Size.sizer
    val bin_write_tcp_string_option : tcp_string_option Bin_prot.Write.writer
    val bin_writer_tcp_string_option : tcp_string_option Bin_prot.Type_class.writer
    val bin_read_tcp_string_option : tcp_string_option Bin_prot.Read.reader
    val __bin_read_tcp_string_option__ : (int -> tcp_string_option) Bin_prot.Read.reader
    val bin_reader_tcp_string_option : tcp_string_option Bin_prot.Type_class.reader
    val bin_tcp_string_option : tcp_string_option Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val gettcpopt_bool : (File_descr.t -> tcp_bool_option -> bool) Or_error.t
  [@@ocaml.doc
    " [gettcpopt_bool sock opt] Returns the current value of the boolean TCP socket option\n\
    \      [opt] for socket [sock]. "]

  val settcpopt_bool : (File_descr.t -> tcp_bool_option -> bool -> unit) Or_error.t
  [@@ocaml.doc
    " [settcpopt_bool sock opt v] sets the current value of the boolean TCP socket option\n\
    \      [opt] for socket [sock] to value [v]. "]

  val gettcpopt_string : (File_descr.t -> tcp_string_option -> string) Or_error.t
  [@@ocaml.doc
    " [gettcpopt_string sock opt] Returns the current value of the string TCP socket\n\
    \      option [opt] for socket [sock]. "]

  val settcpopt_string : (File_descr.t -> tcp_string_option -> string -> unit) Or_error.t
  [@@ocaml.doc
    " [settcpopt_string sock opt v] sets the current value of the string TCP socket option\n\
    \      [opt] for socket [sock] to value [v]. "]

  val send_nonblocking_no_sigpipe
    : (File_descr.t
       -> ?pos:(int[@ocaml.doc " default = 0 "])
       -> ?len:(int[@ocaml.doc " default = [Bytes.length buf - pos] "])
       -> Bytes.t
       -> int option)
        Or_error.t
  [@@ocaml.doc
    " [send_nonblocking_no_sigpipe sock ?pos ?len buf] tries to do a nonblocking send on\n\
    \      socket [sock] given buffer [buf], offset [pos] and length [len].  Prevents\n\
    \      [SIGPIPE], i.e., raises a Unix-error in that case immediately.  Returns [Some\n\
    \      bytes_written] or [None] if the operation would have blocked.\n\n\
    \      Raises [Invalid_argument] if the designated buffer range is invalid.\n\
    \      Raises [Unix_error] on Unix-errors. "]

  val send_no_sigpipe
    : (File_descr.t
       -> ?pos:(int[@ocaml.doc " default = 0 "])
       -> ?len:(int[@ocaml.doc " default = [Bytes.length buf - pos] "])
       -> Bytes.t
       -> int)
        Or_error.t
  [@@ocaml.doc
    " [send_no_sigpipe sock ?pos ?len buf] tries to do a blocking send on socket [sock]\n\
    \      given buffer [buf], offset [pos] and length [len]. Prevents [SIGPIPE], i.e., \
     raises\n\
    \      a Unix-error in that case immediately. Returns the number of bytes written.\n\n\
    \      Raises [Invalid_argument] if the designated buffer range is invalid.\n\
    \      Raises [Unix_error] on Unix-errors. "]

  val sendmsg_nonblocking_no_sigpipe
    : (File_descr.t -> ?count:int -> string IOVec.t array -> int option) Or_error.t
  [@@ocaml.doc
    " [sendmsg_nonblocking_no_sigpipe sock ?count iovecs] tries to do a nonblocking send\n\
    \      on socket [sock] using [count] I/O-vectors [iovecs].  Prevents [SIGPIPE],\n\
    \      i.e., raises a Unix-error in that case immediately.  Returns [Some \
     bytes_written] or\n\
    \      [None] if the operation would have blocked.\n\n\
    \      Raises [Invalid_argument] if the designated ranges are invalid.\n\
    \      Raises [Unix_error] on Unix-errors. "]

  [@@@ocaml.text " {2 Non-portable socket functionality} "]

  module Peer_credentials : sig
    type t =
      { pid : Pid.t
      ; uid : int
      ; gid : int
      }
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val peer_credentials : (File_descr.t -> Peer_credentials.t) Or_error.t
  [@@ocaml.doc
    " [peer_credential fd] takes a file descriptor of a unix socket. It returns the pid\n\
    \      and real ids of the process on the other side, as described in [man 7 socket] \
     entry\n\
    \      for SO_PEERCRED.\n\
    \      This is useful in particular in the presence of pid namespace, as the \
     returned pid\n\
    \      will be a pid in the current namespace, not the namespace of the other \
     process.\n\n\
    \      Raises [Unix_error] if something goes wrong (file descriptor doesn't satisfy \
     the\n\
    \      conditions above, no process on the other side of the socket, etc.). "]

  [@@@ocaml.text " {2 Clock functions} "]

  module Clock : sig
    type t

    [@@@ocaml.text " All these functions can raise [Unix_error]. "]

    val get : (Thread.t -> t) Or_error.t
    [@@ocaml.doc " Returns the CPU-clock associated with the thread. "]

    val get_time : (t -> Time_float.Span.t) Or_error.t
    val set_time : (t -> Time_float.Span.t -> unit) Or_error.t
    val get_resolution : (t -> Time_float.Span.t) Or_error.t

    val get_process_clock : (unit -> t) Or_error.t
    [@@ocaml.doc " The clock measuring the CPU time of a process. "]

    val get_thread_clock : (unit -> t) Or_error.t
    [@@ocaml.doc " The clock measuring the CPU time of the current thread. "]
  end

  [@@@ocaml.text " {2 Eventfd functions} "]

  module Eventfd : sig
    module Flags : sig
      type t = private Int63.t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Flags.S with type t := t

      val cloexec : t [@@ocaml.doc " [EFD_CLOEXEC] "]

      val nonblock : t [@@ocaml.doc " [EFD_NONBLOCK] "]

      val semaphore : t [@@ocaml.doc " [EFD_SEMAPHORE] "]
    end

    type t = private File_descr.t [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create : (?flags:Flags.t -> Int32.t -> t) Or_error.t
    [@@ocaml.doc
      " [create ?flags init] creates a new event file descriptor with [init] as the\n\
      \        counter's initial value.  With Linux 2.6.26 or earlier, [flags] must be\n\
      \        [empty]. "]

    val read : t -> Int64.t
    [@@ocaml.doc
      " [read t] will block until [t]'s counter is nonzero, after which its behavior\n\
      \        depends on whether [t] was created with the {!Flags.semaphore} flag set. \
       If it was\n\
      \        set, then [read t] will return [1] and decrement [t]'s counter. If it was \
       not set,\n\
      \        then [read t] will return the value of [t]'s counter and set the counter \
       to [0].\n\
      \        The returned value should be interpreted as an unsigned 64-bit integer.\n\n\
      \        In the case that [t] was created with the {!Flags.nonblock} flag set, this\n\
      \        function will raise a Unix error with the error code [EAGAIN] or \
       [EWOULDBLOCK],\n\
      \        instead of blocking. "]

    val write : t -> Int64.t -> unit
    [@@ocaml.doc
      " [write t v] will block until [t]'s counter is less than the max value of a\n\
      \        [uint64_t], after which it will increment [t]'s counter by [v], which \
       will be\n\
      \        interpreted as an unsigned 64-bit integer.\n\n\
      \        In the case that [t] was created with the {!Flags.nonblock} flag set, this\n\
      \        function will raise a Unix error with the error code [EAGAIN] or \
       [EWOULDBLOCK],\n\
      \        instead of blocking. "]

    val to_file_descr : t -> File_descr.t
  end

  [@@@ocaml.text " {2 Timerfd functions} "]

  module Timerfd : sig
    module Clock : sig
      type t [@@deriving bin_io, compare, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val realtime : t [@@ocaml.doc " Settable system-wide clock. "]

      val monotonic : t
      [@@ocaml.doc
        " Nonsettable clock.  It is not affected by manual changes to the system time. "]
    end
    [@@ocaml.doc " Clock used to mark the progress of a timer. "]

    module Flags : sig
      type t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Flags.S with type t := t

      val nonblock : t [@@ocaml.doc " [TFD_NONBLOCK] "]

      val cloexec : t [@@ocaml.doc " [TFD_CLOEXEC]  "]
    end

    type t = private File_descr.t [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_file_descr : t -> File_descr.t

    val create : (?flags:Flags.t -> Clock.t -> t) Or_error.t
    [@@ocaml.doc
      " [create ?flags clock] creates a new timer file descriptor.  With Linux 2.6.26 or\n\
      \        earlier, [flags] must be empty. "]

    val set_at : t -> Time_ns.t -> unit
    [@@ocaml.doc
      " [set_at t at] and [set_after t span] set [t] to fire once, at [at] or after\n\
      \        [span].  [set_after] treats [span <= 0] as [span = 1ns]; unlike the \
       underlying\n\
      \        system call, [timerfd_settime], it does not clear the timer if [span = \
       0].  To\n\
      \        clear a timerfd, use [Timerfd.clear].\n\n\
      \        [set_repeating ?after t interval] sets [t] to fire every [interval] \
       starting after\n\
      \        [after] (default is [interval]), raising if [interval <= 0].\n\n\
      \        [set_repeating_at t start interval] sets [t] to fire every [interval] \
       starting at\n\
      \        [start] and raising if [interval <= 0].  A [start] time in the past will \
       cause the\n\
      \        timer to start immediately. "]

    val set_after : t -> Time_ns.Span.t -> unit
    val set_repeating : ?after:Time_ns.Span.t -> t -> Time_ns.Span.t -> unit
    val set_repeating_at : t -> Time_ns.t -> Time_ns.Span.t -> unit

    val clear : t -> unit [@@ocaml.doc " [clear t] causes [t] to not fire anymore. "]

    type repeat =
      { fire_after : Time_ns.Span.t
      ; interval : Time_ns.Span.t
      }

    val get : t -> [ `Not_armed | `Fire_after of Time_ns.Span.t | `Repeat of repeat ]
    [@@ocaml.doc " [get t] returns the current state of the timer [t]. "]

    [@@@ocaml.text "/*"]

    module Private : sig
      val unsafe_timerfd_settime
        :  File_descr.t
        -> bool
        -> initial:Int63.t
        -> interval:Int63.t
        -> Syscall_result.Unit.t
    end
  end

  [@@@ocaml.text " {2 Memfd functions} "]

  module Memfd : sig
    module Flags : sig
      type t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Flags.S with type t := t

      val cloexec : t [@@ocaml.doc " MFD_CLOEXEC "]

      val allow_sealing : t [@@ocaml.doc " MFD_ALLOW_SEALING "]

      val hugetlb : t [@@ocaml.doc " MFD_HUGETLB "]

      val noexec_seal : t [@@ocaml.doc " MFD_NOEXEC_SEAL "]

      val exec : t [@@ocaml.doc " MFD_EXEC "]

      val huge_2mb : t [@@ocaml.doc " MFD_HUGE_2MB "]

      val huge_1gb : t [@@ocaml.doc " MFD_HUGE_1GB "]
    end

    type t = private File_descr.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_file_descr : t -> File_descr.t

    val create : (?flags:Flags.t -> ?initial_size:int -> string -> t) Or_error.t
    [@@ocaml.doc
      " From memfd_create():\n\n\
      \        [create] creates an anonymous file and returns a file descriptor that \
       refers to\n\
      \        it.  The file behaves like a regular file, and so can be modified, \
       truncated,\n\
      \        memory-mapped, and so on.  However, unlike a regular file, it lives in \
       RAM and has\n\
      \        a volatile backing storage.\n\n\
      \        Once all references to the file are dropped, it is automatically released.\n\
      \        Anonymous memory is used for all backing pages of the file.  Therefore, \
       files\n\
      \        created by [create] have the same semantics as other anonymous memory \
       allocations\n\
      \        such as those allocated using [mmap] with the [MAP_ANONYMOUS] flag. "]
  end

  [@@@ocaml.text " {2 Parent death notifications} "]

  val pr_set_pdeathsig : (Signal.t -> unit) Or_error.t
  [@@ocaml.doc
    " [pr_set_pdeathsig s] sets the signal [s] to be sent to the executing process when\n\
    \      its parent dies.  NOTE: the parent may have died before or while executing this\n\
    \      system call.  To make sure that you do not miss this event, you should call\n\
    \      {!getppid} to get the parent process id after this system call.  If the \
     parent has\n\
    \      died, the returned parent PID will be 1, i.e., the init process will have \
     adopted\n\
    \      the child.  You should then either send the signal to yourself using \
     [Unix.kill], or\n\
    \      execute an appropriate handler. "]

  val pr_get_pdeathsig : (unit -> Signal.t) Or_error.t
  [@@ocaml.doc
    " [pr_get_pdeathsig ()] gets the signal that will be sent to the currently executing\n\
    \      process when its parent dies. "]

  [@@@ocaml.text " {2 Task name} "]

  val pr_set_name_first16 : (string -> unit) Or_error.t
  [@@ocaml.doc
    " [pr_set_name_first16 name] sets the name of the executing thread to [name].  Only\n\
    \      the first 16 bytes in [name] will be used; the rest is ignored. "]

  val pr_get_name : (unit -> string) Or_error.t
  [@@ocaml.doc
    " [pr_get_name ()] gets the name of the executing thread.  The name is at most 16\n\
    \      bytes long. "]

  [@@@ocaml.text " {2 Pathname resolution} "]

  val file_descr_realpath : (File_descr.t -> string) Or_error.t
  [@@ocaml.doc
    " [file_descr_realpath fd] returns the canonicalized absolute pathname of the file\n\
    \      associated with file descriptor [fd].\n\n\
    \      Raises [Unix_error] on errors. "]

  val out_channel_realpath : (Out_channel.t -> string) Or_error.t
  [@@ocaml.doc
    " [out_channel_realpath oc] returns the canonicalized absolute pathname of the file\n\
    \      associated with output channel [oc].\n\n\
    \      Raises [Unix_error] on errors. "]

  val in_channel_realpath : (In_channel.t -> string) Or_error.t
  [@@ocaml.doc
    " [in_channel_realpath ic] returns the canonicalized absolute pathname of the file\n\
    \      associated with input channel [ic].\n\n\
    \      Raises [Unix_error] on errors.\n\
    \  "]

  [@@@ocaml.text " {2 Affinity} "]

  val sched_setaffinity : (?pid:Pid.t -> cpuset:int list -> unit -> unit) Or_error.t
  [@@ocaml.doc
    " Setting the CPU affinity causes a thread to only run on the cores chosen. You can\n\
    \      find out how many cores a system has in /proc/cpuinfo. This can be useful in \
     two\n\
    \      ways: first, it limits a process to a core so that it won't interfere with \
     processes\n\
    \      on other cores. Second, you save time by not moving the process back and forth\n\
    \      between CPUs, which sometimes invalidates their cache.\n\n\
    \      See [man sched_setaffinity] for details.\n\n\
    \      Note, in particular, that affinity is a \"per-thread attribute that can be \
     adjusted\n\
    \      independently for each of the threads in a thread group\", and so omitting \
     [~pid] (or\n\
    \      specifying [?pid] as [None]) \"will set the attribute for the calling \
     thread\", and\n\
    \      \"passing the value returned from a call to getpid will set the attribute for \
     the\n\
    \      main thread of the thread group\". (A thread group is what you might think of \
     as\n\
    \      a process.) "]

  val sched_getaffinity : (?pid:Pid.t -> unit -> int list) Or_error.t

  val sched_setaffinity_this_thread : (cpuset:int list -> unit) Or_error.t
  [@@ocaml.doc
    " [sched_setaffinity_this_thread] is equivalent to [sched_setaffinity ?pid:None],\n\
    \      though happens to be implemented by using [gettid] rather than passing \
     [pid=0] to\n\
    \      [sched_setaffinity]. It exists for historical reasons, and may be removed in \
     the\n\
    \      future. "]

  val cores : (unit -> int) Or_error.t
  [@@ocaml.doc
    " [cores ()] returns the number of cores on the machine.  This may be different\n\
    \      than the number of cores available to the calling process. "]

  val cpu_list_of_string_exn : string -> int list
  [@@ocaml.doc
    " Parse a kernel %*pbl-format CPU list (e.g. [1,2,3,10-15]) into an [int list]. "]

  val isolated_cpus : (unit -> int list) Or_error.t
  [@@ocaml.doc " [isolated_cpus ()] returns the list of cores marked as isolated. "]

  val online_cpus : (unit -> int list) Or_error.t
  [@@ocaml.doc " [online_cpus ()] returns the list of cores online for scheduling. "]

  val cpus_local_to_nic : (ifname:string -> int list) Or_error.t
  [@@ocaml.doc
    " [cpus_local_to_nic ~ifname] returns the list of cores NUMA-local to [ifname]. "]

  val get_terminal_size : ([ `Controlling | `Fd of File_descr.t ] -> int * int) Or_error.t
  [@@ocaml.doc
    " [get_terminal_size term] returns [(rows, cols)], the number of rows and columns of\n\
    \      the controlling terminal (raises if no controlling terminal), or of the \
     specified\n\
    \      file descriptor (useful when writing to stdout, because stdout doesn't have \
     to be\n\
    \      the controlling terminal). "]

  module Priority : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val equal : t -> t -> bool
    val of_int : int -> t
    val to_int : t -> int
    val incr : t -> t
    val decr : t -> t
  end
  [@@ocaml.doc
    " [Priority.t] is what is usually referred to as the \"nice\" value of a process.  \
     It is\n\
    \      also known as the \"dynamic\" priority.  It is used with normal (as opposed to\n\
    \      real-time) processes that have static priority zero.  See \
     [Unix.Scheduler.set] for\n\
    \      setting the static priority. "]

  [@@@ocaml.text
    " The meaning of [pid]s for [get/setpriority] is a bit weird. According to the POSIX\n\
    \      standard the priority is per process (pid), however in Linux the priority is \
     per\n\
    \      thread (tid/LWP): [man 2 setpriority] says, in the \"BUGS\" section, that \
     \"According\n\
    \      to POSIX, the nice value is a per-process setting. However, under the current\n\
    \      Linux/NPTL implementation of POSIX threads, the nice value is a per-thread \
     attribute\n\
    \      ... portable applications should avoid relying on the Linux behavior\".\n\n\
    \      As a result, if you omit [?pid] or pass [?pid:None], only the current thread \
     will be\n\
    \      affected; passing [~pid:(getpid ())] will only affect the main thread of the \
     current\n\
    \      process. "]

  val setpriority : (?pid:Pid.t -> Priority.t -> unit) Or_error.t
  [@@ocaml.doc
    " Set the thread's priority in the Linux scheduler. Omitting the [pid] argument means\n\
    \      that (only) the calling thread will be affected. "]

  val getpriority : (?pid:Pid.t -> unit -> Priority.t) Or_error.t
  [@@ocaml.doc
    " Get the thread's priority in the Linux scheduler. Omitting the [pid] argument means\n\
    \      that the calling thread's priority will be retrieved. "]

  val get_ipv4_address_for_interface : (string -> string) Or_error.t
  [@@ocaml.doc
    " [get_ipv4_address_for_interface \"eth0\"] returns the IP address assigned to eth0, \
     or\n\
    \      throws an exception if no IP address is configured. "]

  val get_mac_address : (ifname:string -> string) Or_error.t
  [@@ocaml.doc
    " [get_mac_address] returns the mac address of [ifname] in the canonical form, e.g.\n\
    \      \"aa:bb:cc:12:34:56\". "]

  val bind_to_interface : (File_descr.t -> Bound_to_interface.t -> unit) Or_error.t
  [@@ocaml.doc
    " [bind_to_interface fd (Only \"eth0\")] restricts packets from being\n\
    \      received/sent on the given file descriptor [fd] on any interface other than \
     \"eth0\".\n\
    \      Use [bind_to_interface fd Any] to allow traffic on any interface.  The \
     bindings are\n\
    \      not cumulative; you may only select one interface, or [Any].\n\n\
    \      Not to be confused with a traditional BSD sockets API [bind()] call, this\n\
    \      Linux-specific socket option ([SO_BINDTODEVICE]) is used for applications on\n\
    \      multi-homed machines with specific security concerns.  For similar \
     functionality\n\
    \      when using multicast, see {!Core_unix.mcast_set_ifname}. "]

  [@@@ocaml.text
    " [get_bind_to_interface fd] returns the current interface the socket is bound to. It\n\
    \      uses getsockopt() with Linux-specific [SO_BINDTODEVICE] option. Empty string \
     means\n\
    \      it is not bound to any specific interface. See [man 7 socket] for more \
     information.\n\
    \  "]

  val get_bind_to_interface : (File_descr.t -> Bound_to_interface.t) Or_error.t

  module Epoll : Epoll.S

  module Extended_file_attributes : sig
    [@@@ocaml.text
      " Extended attributes are name:value pairs associated with inodes (files,\n\
      \        directories, symlinks, etc). They are extensions to the normal attributes \
       which\n\
      \        are associated with all inodes in the system (i.e. the 'man 2 stat' \
       data). A\n\
      \        complete overview of extended attributes concepts can be found in 'man 5 \
       attr'.\n\n\
      \        [getxattr] retrieves the value of the extended attribute identified by \
       name and\n\
      \        associated with the given path in the filesystem.\n\n\
      \        The [name] includes a namespace prefix - there may be several, disjoint \
       namespaces\n\
      \        associated with an individual inode. The [value] is a chunk of arbitrary \
       textual\n\
      \        or binary data.\n\n\
      \        If the attribute exists, it is returned as [Ok string]. Several common \
       errors are\n\
      \        returned as possible constructors, namely:\n\
      \        - [ENOATTR]: The named attribute does not exist, or the process has no \
       access to\n\
      \          this attribute.\n\
      \        - [ERANGE]: The size of the value buffer is too small to hold the result.\n\
      \        - [ENOTSUP]: Extended attributes are not supported by the filesystem, or \
       are\n\
      \          disabled.\n\n\
      \        Many other errors are possible, and will raise an exception. See the man \
       pages for\n\
      \        full details. "]

    module Get_attr_result : sig
      type t =
        | Ok of string
        | ENOATTR
        | ERANGE
        | ENOTSUP
      [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    val getxattr
      : (follow_symlinks:bool -> path:string -> name:string -> Get_attr_result.t)
          Or_error.t

    [@@@ocaml.text
      " [setxattr] sets the value of the extended attribute identified by name and\n\
      \        associated with the given path in the filesystem.\n\n\
      \        [how] defaults to [`Set], in which case the extended attribute will be \
       created if\n\
      \        need be, or will simply replace the value if the attribute exists. If \
       [how] is\n\
      \        [`Create], then [setxattr] returns [EEXIST] if the named attribute exists \
       already.\n\
      \        If [how] is [`Replace], then [setxattr] returns [ENOATTR] if the named \
       attribute\n\
      \        does not already exist.\n\n\
      \        [ENOTSUP] means extended attributes are not supported by the filesystem, \
       or are\n\
      \        disabled. Many other errors are possible, and will raise an exception. \
       See the man\n\
      \        pages for full details. "]

    module Set_attr_result : sig
      type t =
        | Ok
        | EEXIST
        | ENOATTR
        | ENOTSUP
      [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    val setxattr
      : (?how:[ `Set | `Create | `Replace ]
         -> follow_symlinks:bool
         -> path:string
         -> name:string
         -> value:string
         -> unit
         -> Set_attr_result.t)
          Or_error.t
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
