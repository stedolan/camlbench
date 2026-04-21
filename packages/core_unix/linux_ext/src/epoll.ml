let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"epoll.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "epoll.ml.before-ppx"
;;

open! Base
open! Core
include Epoll_intf

module Epoll_flags (Flag_values : sig
    val in_ : Int63.t
    val out : Int63.t
    val pri : Int63.t
    val err : Int63.t
    val hup : Int63.t
    val et : Int63.t
    val oneshot : Int63.t
  end) =
struct
  let none = Int63.zero

  include Flag_values

  include Flags.Make (struct
      let allow_intersecting = false
      let should_print_error = true
      let remove_zero_flags = false

      let known =
        [ in_, "in"
        ; out, "out"
        ; pri, "pri"
        ; err, "err"
        ; hup, "hup"
        ; et, "et"
        ; oneshot, "oneshot"
        ]
      ;;
    end)
end

module Null_impl : S = struct
  module Flags = Epoll_flags (struct
      let in_ = Int63.of_int (1 lsl 0)
      let out = Int63.of_int (1 lsl 1)
      let pri = Int63.of_int (1 lsl 3)
      let err = Int63.of_int (1 lsl 4)
      let hup = Int63.of_int (1 lsl 5)
      let et = Int63.of_int (1 lsl 6)
      let oneshot = Int63.of_int (1 lsl 7)
    end)

  type t = [ `Epoll_is_not_implemented ] [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun `Epoll_is_not_implemented -> Sexplib0.Sexp.Atom "Epoll_is_not_implemented"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create = Or_error.unimplemented "Linux_ext.Epoll.create"
  let close _ = assert false
  let invariant _ = assert false
  let find _ _ = assert false
  let find_exn _ _ = assert false
  let set _ _ _ = assert false
  let remove _ _ = assert false
  let iter _ ~f:_ = assert false
  let fold _ ~init:_ ~f:_ = assert false
  let wait _ ~timeout:_ = assert false
  let wait_timeout_after _ _ = assert false
  let iter_ready _ ~f:_ = assert false
  let fold_ready _ ~init:_ ~f:_ = assert false

  module Expert = struct
    let clear_ready _ = assert false
  end
end

module _ = Null_impl

[%%import "config.h"]
[%%ifdef JSC_LINUX_EXT]

module Impl = struct
  open Core_unix
  module Unix = Core_unix

  external flag_epollin : unit -> Int63.t = "core_linux_epoll_EPOLLIN_flag"
  external flag_epollout : unit -> Int63.t = "core_linux_epoll_EPOLLOUT_flag"
  external flag_epollpri : unit -> Int63.t = "core_linux_epoll_EPOLLPRI_flag"
  external flag_epollerr : unit -> Int63.t = "core_linux_epoll_EPOLLERR_flag"
  external flag_epollhup : unit -> Int63.t = "core_linux_epoll_EPOLLHUP_flag"
  external flag_epollet : unit -> Int63.t = "core_linux_epoll_EPOLLET_flag"
  external flag_epolloneshot : unit -> Int63.t = "core_linux_epoll_EPOLLONESHOT_flag"

  module Flags = Epoll_flags (struct
      let in_ = flag_epollin ()
      let out = flag_epollout ()
      let pri = flag_epollpri ()
      let err = flag_epollerr ()
      let hup = flag_epollhup ()
      let et = flag_epollet ()
      let oneshot = flag_epolloneshot ()
    end)

  external epoll_create : unit -> File_descr.t = "core_linux_epoll_create"

  type ready_events = Bigstring.t

  external epoll_sizeof_epoll_event : unit -> int = "core_linux_epoll_sizeof_epoll_event"
  [@@noalloc]

  external epoll_offsetof_readyfd : unit -> int = "core_linux_epoll_offsetof_readyfd"
  [@@noalloc]

  external epoll_offsetof_readyflags
    :  unit
    -> int
    = "core_linux_epoll_offsetof_readyflags"
  [@@noalloc]

  let sizeof_epoll_event = epoll_sizeof_epoll_event ()
  let offsetof_readyfd = epoll_offsetof_readyfd ()
  let offsetof_readyflags = epoll_offsetof_readyflags ()

  external epoll_ctl_add
    :  File_descr.t
    -> File_descr.t
    -> Flags.t
    -> unit
    = "core_linux_epoll_ctl_add"

  external epoll_ctl_mod
    :  File_descr.t
    -> File_descr.t
    -> Flags.t
    -> unit
    = "core_linux_epoll_ctl_mod"

  external epoll_ctl_del
    :  File_descr.t
    -> File_descr.t
    -> unit
    = "core_linux_epoll_ctl_del"

  module Table = Bounded_int_table

  module T = struct
    type 'a t =
      { epollfd : File_descr.t
      ; flags_by_fd : (File_descr.t, Flags.t) Table.t
      ; max_ready_events : int
      ; mutable num_ready_events : int
      ; ready_events : 'a
      }
    [@@deriving fields ~iterators:iter, sexp_of]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()
      let ready_events _r__ = _r__.ready_events
      let _ = ready_events
      let num_ready_events _r__ = _r__.num_ready_events
      let _ = num_ready_events
      let set_num_ready_events _r__ v__ = _r__.num_ready_events <- v__
      let _ = set_num_ready_events
      let max_ready_events _r__ = _r__.max_ready_events
      let _ = max_ready_events
      let flags_by_fd _r__ = _r__.flags_by_fd
      let _ = flags_by_fd
      let epollfd _r__ = _r__.epollfd
      let _ = epollfd

      module Fields = struct
        let ready_events =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "ready_events"
             ; getter = ready_events
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with ready_events = v__ })
             }
           : ([< `Read | `Set_and_create ], _, 'a) Fieldslib.Field.t_with_perm)
        ;;

        let _ = ready_events

        let num_ready_events =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "num_ready_events"
             ; getter = num_ready_events
             ; setter = Some set_num_ready_events
             ; fset = (fun _r__ v__ -> { _r__ with num_ready_events = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = num_ready_events

        let max_ready_events =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "max_ready_events"
             ; getter = max_ready_events
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with max_ready_events = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = max_ready_events

        let flags_by_fd =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "flags_by_fd"
             ; getter = flags_by_fd
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with flags_by_fd = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , (File_descr.t, Flags.t) Table.t )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = flags_by_fd

        let epollfd =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "epollfd"
             ; getter = epollfd
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with epollfd = v__ })
             }
           : ([< `Read | `Set_and_create ], _, File_descr.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = epollfd

        let iter
              ~epollfd:epollfd_fun__
              ~flags_by_fd:flags_by_fd_fun__
              ~max_ready_events:max_ready_events_fun__
              ~num_ready_events:num_ready_events_fun__
              ~ready_events:ready_events_fun__
          =
          (epollfd_fun__ epollfd : unit);
          (flags_by_fd_fun__ flags_by_fd : unit);
          (max_ready_events_fun__ max_ready_events : unit);
          (num_ready_events_fun__ num_ready_events : unit);
          (ready_events_fun__ ready_events : unit)
        ;;

        let _ = iter
      end

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__001_
          { epollfd = epollfd__003_
          ; flags_by_fd = flags_by_fd__005_
          ; max_ready_events = max_ready_events__007_
          ; num_ready_events = num_ready_events__009_
          ; ready_events = ready_events__011_
          } ->
        let bnds__002_ = ([] : _ Stdlib.List.t) in
        let bnds__002_ =
          let arg__012_ = _of_a__001_ ready_events__011_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ready_events"; arg__012_ ]
           :: bnds__002_
           : _ Stdlib.List.t)
        in
        let bnds__002_ =
          let arg__010_ = sexp_of_int num_ready_events__009_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "num_ready_events"; arg__010_ ]
           :: bnds__002_
           : _ Stdlib.List.t)
        in
        let bnds__002_ =
          let arg__008_ = sexp_of_int max_ready_events__007_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_ready_events"; arg__008_ ]
           :: bnds__002_
           : _ Stdlib.List.t)
        in
        let bnds__002_ =
          let arg__006_ =
            Table.sexp_of_t File_descr.sexp_of_t Flags.sexp_of_t flags_by_fd__005_
          in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags_by_fd"; arg__006_ ]
           :: bnds__002_
           : _ Stdlib.List.t)
        in
        let bnds__002_ =
          let arg__004_ = File_descr.sexp_of_t epollfd__003_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "epollfd"; arg__004_ ] :: bnds__002_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__002_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  open T

  let epoll_readyfd t i =
    File_descr.of_int
      (Bigstring.unsafe_get_int32_le t ~pos:((i * sizeof_epoll_event) + offsetof_readyfd))
  ;;

  let epoll_readyflags t i =
    Flags.of_int
      (Bigstring.unsafe_get_int32_le
         t
         ~pos:((i * sizeof_epoll_event) + offsetof_readyflags))
  ;;

  type in_use = ready_events T.t

  module Pretty = struct
    type ready_event =
      { file_descr : File_descr.t
      ; flags : Flags.t
      }
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : ready_event) -> ()

      let sexp_of_ready_event =
        (fun { file_descr = file_descr__014_; flags = flags__016_ } ->
           let bnds__013_ = ([] : _ Stdlib.List.t) in
           let bnds__013_ =
             let arg__017_ = Flags.sexp_of_t flags__016_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags"; arg__017_ ] :: bnds__013_
              : _ Stdlib.List.t)
           in
           let bnds__013_ =
             let arg__015_ = File_descr.sexp_of_t file_descr__014_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "file_descr"; arg__015_ ]
              :: bnds__013_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__013_
         : ready_event -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_ready_event
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type ready_events = ready_event array [@@deriving sexp_of]

    include struct
      let _ = fun (_ : ready_events) -> ()

      let sexp_of_ready_events =
        (fun x__018_ -> sexp_of_array sexp_of_ready_event x__018_
         : ready_events -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_ready_events
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type t = ready_events T.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (fun x__019_ -> T.sexp_of_t sexp_of_ready_events x__019_ : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  let to_pretty t =
    { t with
      ready_events =
        Array.init t.num_ready_events ~f:(fun i ->
          { Pretty.file_descr = epoll_readyfd t.ready_events i
          ; flags = epoll_readyflags t.ready_events i
          })
    }
  ;;

  let sexp_of_in_use t = Pretty.sexp_of_t (to_pretty t)

  type t = [ `Closed | `In_use of in_use ] ref [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun x__021_ ->
         sexp_of_ref
           (function
             | `Closed -> Sexplib0.Sexp.Atom "Closed"
             | `In_use v__020_ ->
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "In_use"; sexp_of_in_use v__020_ ])
           x__021_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let close t =
    match !t with
    | `Closed -> ()
    | `In_use { epollfd; _ } ->
      t := `Closed;
      Unix.close epollfd
  ;;

  let invariant t : unit =
    match !t with
    | `Closed -> ()
    | `In_use t ->
      (try
         let check f field = f (Field.get field t) in
         Fields.iter
           ~epollfd:ignore
           ~flags_by_fd:(check (Table.invariant ignore ignore))
           ~max_ready_events:
             (check (fun max_ready_events -> assert (max_ready_events > 0)))
           ~num_ready_events:(check (fun num_ready -> assert (num_ready >= 0)))
           ~ready_events:ignore
       with
       | exn ->
         failwiths
           ~here:
             { Ppx_here_lib.pos_fname = "epoll.ml.before-ppx"
             ; pos_lnum = 242
             ; pos_cnum = 7114
             ; pos_bol = 7097
             }
           "Epoll.invariant failed"
           (exn, t)
           ((fun (arg0__022_, arg1__023_) ->
              let res0__024_ = sexp_of_exn arg0__022_
              and res1__025_ = sexp_of_in_use arg1__023_ in
              Sexplib0.Sexp.List [ res0__024_; res1__025_ ]) [@merlin.hide]))
  ;;

  let create ~num_file_descrs ~max_ready_events =
    if max_ready_events < 0
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "epoll.ml.before-ppx"
          ; pos_lnum = 252
          ; pos_cnum = 7338
          ; pos_bol = 7324
          }
        "Epoll.create got nonpositive max_ready_events"
        max_ready_events
        (sexp_of_int [@merlin.hide]);
    ref
      (`In_use
          { epollfd = epoll_create ()
          ; flags_by_fd =
              Table.create
                ~num_keys:num_file_descrs
                ~key_to_int:File_descr.to_int
                ~sexp_of_key:File_descr.sexp_of_t
                ()
          ; max_ready_events
          ; num_ready_events = 0
          ; ready_events = Bigstring.create (sizeof_epoll_event * max_ready_events)
          })
  ;;

  let in_use_exn t =
    match !t with
    | `Closed -> failwith "attempt to use closed epoll set"
    | `In_use r -> r
  ;;

  let find t file_descr =
    let t = in_use_exn t in
    Table.find t.flags_by_fd file_descr
  ;;

  let find_exn t file_descr =
    let t = in_use_exn t in
    Table.find_exn t.flags_by_fd file_descr
  ;;

  let iter t ~f =
    let t = in_use_exn t in
    Table.iteri t.flags_by_fd ~f:(fun ~key:file_descr ~data:flags -> f file_descr flags)
  ;;

  let fold t ~init ~f =
    let t = in_use_exn t in
    Table.fold t.flags_by_fd ~init ~f:(fun ~key ~data -> f key data)
  ;;

  let set t fd flags =
    let t = in_use_exn t in
    let already_present = Table.mem t.flags_by_fd fd in
    let () =
      if already_present
      then epoll_ctl_mod t.epollfd fd flags
      else epoll_ctl_add t.epollfd fd flags
    in
    Table.set t.flags_by_fd ~key:fd ~data:flags
  ;;

  let remove t fd =
    let t = in_use_exn t in
    if Table.mem t.flags_by_fd fd
    then (
      Table.remove t.flags_by_fd fd;
      epoll_ctl_del t.epollfd fd)
  ;;

  external epoll_wait
    :  File_descr.t
    -> ready_events
    -> int
    -> int
    = "core_linux_epoll_wait"

  let wait_internal t ~timeout_ms =
    let t = in_use_exn t in
    t.num_ready_events <- 0;
    t.num_ready_events <- epoll_wait t.epollfd t.ready_events timeout_ms;
    if t.num_ready_events = 0 then `Timeout else `Ok
  ;;

  let wait_timeout_after t span =
    let timeout_ms =
      if Time_ns.Span.( <= ) span Time_ns.Span.zero
      then 0
      else (
        let span = Time_ns.Span.max span Time_ns.Span.millisecond in
        Int63.to_int_exn
          (let open Time_ns.Span in
           div
             (span + of_int63_ns (Int63.of_int 500_000))
             (of_int63_ns (Int63.of_int 1_000_000))))
    in
    assert (timeout_ms >= 0);
    wait_internal t ~timeout_ms
  ;;

  let wait t ~timeout =
    match timeout with
    | `Never -> wait_internal t ~timeout_ms:(-1)
    | `Immediately -> wait_internal t ~timeout_ms:0
    | `After span -> wait_timeout_after t span
  ;;

  let fold_ready t ~init ~f =
    let t = in_use_exn t in
    let ac = ref init in
    for i = 0 to t.num_ready_events - 1 do
      ac := f !ac (epoll_readyfd t.ready_events i) (epoll_readyflags t.ready_events i)
    done;
    !ac
  ;;

  let iter_ready t ~f =
    let t = in_use_exn t in
    for i = 0 to t.num_ready_events - 1 do
      f (epoll_readyfd t.ready_events i) (epoll_readyflags t.ready_events i)
    done
  ;;

  module Expert = struct
    let clear_ready t =
      let t = in_use_exn t in
      t.num_ready_events <- 0
    ;;
  end

  let create = Ok create
end

[%%else]

module Impl = Null_impl

[%%endif]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
