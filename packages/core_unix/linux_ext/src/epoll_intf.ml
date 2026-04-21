let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"epoll_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "epoll_intf.ml.before-ppx"
;;

open Base
open Core
open Core_unix

[@@@ocaml.text
  " epoll(): a Linux I/O multiplexer of the same family as select() or poll().  Its main\n\
  \    differences are support for Edge- or Level-triggered notifications (we're using\n\
  \    Level-triggered to emulate \"select\") and much better scaling with the number of \
   file\n\
  \    descriptors.\n\n\
  \    See the man pages for a full description of the epoll facility. "]

module type S = sig
  module Flags : sig
    type t
    [@@ocaml.doc
      " An [Epoll.Flags.t] is an immutable set of flags for which one can register\n\
      \        interest in a file descriptor.  It is implemented as a bitmask, and so all\n\
      \        operations (+, -, etc.) are constant time with no allocation.\n\n\
      \        [sexp_of_t] produces a human-readable list of bits, e.g., \"(in out)\". "]
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Flags.S with type t := t

    [@@@ocaml.text
      " The names of the flags match the man pages.  E.g. [in_] = \"EPOLLIN\", [out] =\n\
      \        \"EPOLLOUT\", etc. "]

    val none : t [@@ocaml.doc " Associated fd is readable                      "]

    val in_ : t [@@ocaml.doc " Associated fd is readable                      "]

    val out : t [@@ocaml.doc " Associated fd is writable                      "]

    val pri : t [@@ocaml.doc " Urgent data available                          "]

    val err : t [@@ocaml.doc " Error condition (always on, no need to set it) "]

    val hup : t [@@ocaml.doc " Hang up happened (always on)                   "]

    val et : t [@@ocaml.doc " Edge-Triggered behavior (see man page)         "]

    val oneshot : t [@@ocaml.doc " One-shot behavior for the associated fd        "]
  end

  type t
  [@@ocaml.doc
    " An [Epoll.t] maintains a map from [File_descr.t] to [Flags.t], where the domain is\n\
    \      the set of file descriptors that one is interested in, and the flags associated\n\
    \      with each file descriptor specify the types of events one is interested in \
     being\n\
    \      notified about for that file descriptor.  Our implementation maintains a\n\
    \      user-level table equivalent to the kernel epoll set, so that [sexp_of_t] \
     produces\n\
    \      useful human-readable information, and so that we can present our standard \
     table\n\
    \      interface.\n\n\
    \      The implementation assumes that one never closes a file descriptor that is the\n\
    \      domain of an [Epoll.t], since doing so might remove the [fd] from the kernel \
     epoll\n\
    \      set without the implementation's knowledge.\n\n\
    \      An [Epoll.t] also has a buffer that is used to store the set of ready [fd]s\n\
    \      returned by calling [wait]. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val invariant : t -> unit

  val create : (num_file_descrs:int -> max_ready_events:int -> t) Or_error.t
  [@@ocaml.doc
    " [create ~num_file_descrs] creates a new epoll set able to watch file descriptors\n\
    \      in \\[0, [num_file_descrs]).  Additionally, the set allocates space for \
     reading the\n\
    \      \"ready\" events when [wait] returns, allowing for up to [max_ready_events] \
     to be\n\
    \      returned in a single call to [wait]. "]

  val close : t -> unit

  [@@@ocaml.text " Map operations "]

  val find : t -> File_descr.t -> Flags.t option
  [@@ocaml.doc " [find] raises in the case that [t] is closed. "]

  val find_exn : t -> File_descr.t -> Flags.t
  val set : t -> File_descr.t -> Flags.t -> unit
  val remove : t -> File_descr.t -> unit
  val iter : t -> f:(File_descr.t -> Flags.t -> unit) -> unit
  val fold : t -> init:'a -> f:(File_descr.t -> Flags.t -> 'a -> 'a) -> 'a

  val wait
    :  t
    -> timeout:[ `Never | `Immediately | `After of Time_ns.Span.t ]
    -> [ `Ok | `Timeout ]
  [@@ocaml.doc
    " [wait t ~timeout] blocks until at least one file descriptor in [t] is ready for\n\
    \      one of the events it is being watched for, or [timeout] passes.  [wait] side\n\
    \      effects [t] by storing the ready set in it.  One can subsequently access the \
     ready\n\
    \      set by calling [iter_ready] or [fold_ready].\n\n\
    \      With [wait ~timeout:(`After span)], [span <= 0] is treated as [0].  If [span \
     > 0],\n\
    \      then [span] is rounded to the nearest millisecond, with a minimum value of one\n\
    \      millisecond.\n\n\
    \      Note that this method should not be considered thread-safe.  There is mutable\n\
    \      state in [t] that will be changed by invocations to [wait] that cannot be\n\
    \      prevented by mutexes around [wait]. "]

  val wait_timeout_after : t -> Time_ns.Span.t -> [ `Ok | `Timeout ]
  [@@ocaml.doc
    " [wait_timeout_after t span = wait t ~timeout:(`After span)].  [wait_timeout_after]\n\
    \      is a performance hack to avoid allocating [`After span]. "]

  val iter_ready : t -> f:(File_descr.t -> Flags.t -> unit) -> unit
  [@@ocaml.doc
    " [iter_ready] and [fold_ready] iterate over the ready set computed by the last\n\
    \      call to [wait]. "]

  val fold_ready : t -> init:'a -> f:('a -> File_descr.t -> Flags.t -> 'a) -> 'a

  module Expert : sig
    val clear_ready : t -> unit
    [@@ocaml.doc
      " [clear_ready t] sets the number of ready events in [t] to [0]. This\n\
      \        should be called after all the events in [t] have been processed,\n\
      \        following a call to {!wait}. "]
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
