let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"lock_file_blocking.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "lock_file_blocking.ml.before-ppx"
;;

open! Core
module Unix = Core_unix

[%%import "config.h"]

let flock fd ~exclusive =
  let flock_command =
    match exclusive with
    | true -> Unix.Flock_command.lock_exclusive
    | false -> Unix.Flock_command.lock_shared
  in
  Unix.flock fd flock_command
;;

let lockf ?(mode = Unix.F_TLOCK) fd =
  try
    Unix.lockf fd ~mode ~len:Int64.zero;
    true
  with
  | _ -> false
;;

[%%ifdef JSC_LINUX_EXT]

let lock fd =
  let flocked = flock fd ~exclusive:true in
  let lockfed = lockf fd in
  flocked && lockfed
;;

[%%else]

let lock = flock ~exclusive:true

[%%endif]

let create
      ?(message = Pid.to_string (Unix.getpid ()))
      ?(close_on_exec = true)
      ?(unlink_on_exit = false)
      path
  =
  let message = sprintf "%s\n" message in
  let fd =
    Unix.openfile
      path
      ~mode:([ Unix.O_WRONLY; O_CREAT ] @ if close_on_exec then [ O_CLOEXEC ] else [])
      ~perm:0o664
  in
  try
    if lock fd
    then (
      let pid_when_lock_file_was_created = Unix.getpid () in
      if unlink_on_exit
      then
        at_exit (fun () ->
          if Pid.( = ) pid_when_lock_file_was_created (Unix.getpid ())
          then (
            try Unix.unlink path with
            | _ -> ()));
      Unix.ftruncate fd ~len:Int64.zero;
      ignore (Unix.write_substring fd ~buf:message ~pos:0 ~len:(String.length message));
      ignore (lockf fd);
      true)
    else (
      Unix.close fd;
      false)
  with
  | e ->
    Unix.close fd;
    raise e
;;

let create_exn ?message ?close_on_exec ?unlink_on_exit path =
  if not (create ?message ?close_on_exec ?unlink_on_exit path)
  then
    failwithf
      "Lock_file.create_exn '%s' was unable to acquire the lock. The process that \
       acquired the lock is likely still running"
      path
      ()
;;

let random = lazy (Random.State.make_self_init ())

let default_max_retry_delay ~timeout =
  let default_delay = Time_float.Span.of_int_ms 300 in
  match timeout with
  | None -> default_delay
  | Some timeout -> Time_float.Span.min default_delay (Time_float.Span.( / ) timeout 3.)
;;

let wait_at_most max_delay random =
  let delay = Random.State.float (Lazy.force random) (Time_float.Span.to_sec max_delay) in
  ignore (Unix.nanosleep delay : float)
;;

let repeat_with_timeout ?max_retry_delay ?(random = random) ?timeout lockf path =
  let max_retry_delay =
    match max_retry_delay with
    | Some delay -> delay
    | None -> default_max_retry_delay ~timeout
  in
  match timeout with
  | None ->
    let rec loop () =
      try lockf path with
      | _ ->
        wait_at_most max_retry_delay random;
        loop ()
    in
    loop ()
  | Some timeout ->
    let start_time = Time_float.now () in
    let rec loop () =
      try lockf path with
      | e ->
        let since_start = Time_float.abs_diff start_time (Time_float.now ()) in
        if
          let open Time_float.Span in
          since_start > timeout
        then
          failwithf
            "Lock_file: '%s' timed out waiting for existing lock. Last error was %s"
            path
            (Exn.to_string e)
            ()
        else (
          wait_at_most max_retry_delay random;
          loop ())
    in
    loop ()
;;

let blocking_create
      ?max_retry_delay
      ?random
      ?timeout
      ?message
      ?close_on_exec
      ?unlink_on_exit
      path
  =
  repeat_with_timeout
    ?max_retry_delay
    ?random
    ?timeout
    (fun path -> create_exn ?message ?close_on_exec ?unlink_on_exit path)
    path
;;

let is_locked path =
  try
    let fd = Unix.openfile path ~mode:[ Unix.O_RDONLY ] ~perm:0o664 in
    let flocked = flock fd ~exclusive:true in
    let lockfed = lockf fd ~mode:Unix.F_TEST in
    Unix.close fd;
    if flocked && lockfed then false else true
  with
  | Unix.Unix_error (ENOENT, _, _) -> false
  | e -> raise e
;;

let read_file_and_convert ~of_string path =
  Option.try_with (fun () -> of_string (String.strip (In_channel.read_all path)))
;;

let get_pid path =
  let of_string string = Pid.of_int (Int.of_string string) in
  read_file_and_convert ~of_string path
;;

module Nfs = struct
  let process_start_time pid =
    match Linux_ext.Sysinfo.sysinfo with
    | Error _ -> None
    | Ok sysinfo ->
      let of_string stat =
        let boot_time =
          Time_float.sub (Time_float.now ()) (sysinfo ()).Linux_ext.Sysinfo.uptime
        in
        let jiffies =
          let fields =
            String.split ~on:' ' (String.strip (snd (String.rsplit2_exn stat ~on:')')))
          in
          Float.of_string (List.nth_exn fields 19)
        in
        let hz = Int64.to_float (Option.value_exn (Unix.sysconf Unix.CLK_TCK)) in
        Time_float.add boot_time (Time_float.Span.of_sec (jiffies /. hz))
      in
      read_file_and_convert
        (sprintf
           ((Format
               ( String_literal
                   ( "/proc/"
                   , Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__001_ ->
                           Pid.to_string _custom_printf__001_)
                       , String_literal ("/stat", End_of_format) ) )
               , "/proc/%{Pid}/stat" )
            : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
            [@merlin.hide])
           pid)
        ~of_string
  ;;

  module Info = struct
    type t =
      { host : string
      ; pid : Pid.Stable.V1.t
      ; message : string
      ; start_time : Time_float.Stable.With_utc_sexp.V2.t option [@sexp.option]
      }
    [@@deriving sexp, fields ~getters]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__003_ = "lock_file_blocking.ml.before-ppx.Nfs.Info.t" in
         fun x__004_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__003_
             ~fields:
               (Field
                  { name = "host"
                  ; kind = Required
                  ; conv = string_of_sexp
                  ; rest =
                      Field
                        { name = "pid"
                        ; kind = Required
                        ; conv = Pid.Stable.V1.t_of_sexp
                        ; rest =
                            Field
                              { name = "message"
                              ; kind = Required
                              ; conv = string_of_sexp
                              ; rest =
                                  Field
                                    { name = "start_time"
                                    ; kind = Sexp_option
                                    ; conv = Time_float.Stable.With_utc_sexp.V2.t_of_sexp
                                    ; rest = Empty
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "host" -> 0
               | "pid" -> 1
               | "message" -> 2
               | "start_time" -> 3
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (host, (pid, (message, (start_time, ())))) ->
               ({ host; pid; message; start_time } : t))
             x__004_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { host = host__006_
             ; pid = pid__008_
             ; message = message__010_
             ; start_time = start_time__012_
             } ->
           let bnds__005_ = ([] : _ Stdlib.List.t) in
           let bnds__005_ =
             match start_time__012_ with
             | Stdlib.Option.None -> bnds__005_
             | Stdlib.Option.Some v__013_ ->
               let arg__015_ = Time_float.Stable.With_utc_sexp.V2.sexp_of_t v__013_ in
               let bnd__014_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "start_time"; arg__015_ ]
               in
               (bnd__014_ :: bnds__005_ : _ Stdlib.List.t)
           in
           let bnds__005_ =
             let arg__011_ = sexp_of_string message__010_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "message"; arg__011_ ] :: bnds__005_
              : _ Stdlib.List.t)
           in
           let bnds__005_ =
             let arg__009_ = Pid.Stable.V1.sexp_of_t pid__008_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pid"; arg__009_ ] :: bnds__005_
              : _ Stdlib.List.t)
           in
           let bnds__005_ =
             let arg__007_ = sexp_of_string host__006_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "host"; arg__007_ ] :: bnds__005_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__005_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let start_time _r__ = _r__.start_time
      let _ = start_time
      let message _r__ = _r__.message
      let _ = message
      let pid _r__ = _r__.pid
      let _ = pid
      let host _r__ = _r__.host
      let _ = host
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create ~message =
      let pid = Unix.getpid () in
      { host = Unix.gethostname (); pid; message; start_time = process_start_time pid }
    ;;

    let of_string string = t_of_sexp (Sexp.of_string string)
    let of_file = read_file_and_convert ~of_string
  end

  let lock_path path = path ^ ".nfs_lock"

  let get_hostname_and_pid path =
    Option.map (Info.of_file path) ~f:(fun info -> Info.host info, Info.pid info)
  ;;

  let get_message path = Option.map (Info.of_file path) ~f:Info.message

  let unlock_safely_exn ~unlock_myself path =
    let lock_path = lock_path path in
    let error s =
      failwithf "Lock_file.Nfs.unlock_safely_exn: unable to unlock %s: %s" lock_path s ()
    in
    match Sys_unix.file_exists ~follow_symlinks:false lock_path with
    | `Unknown -> error (sprintf "unable to read %s" lock_path)
    | `No -> ()
    | `Yes ->
      (match Info.of_file lock_path with
       | None -> error "unknown lock file format"
       | Some info ->
         let my_pid = Unix.getpid () in
         let my_hostname = Unix.gethostname () in
         let locking_hostname = Info.host info in
         let locking_pid = Info.pid info in
         if String.( <> ) my_hostname locking_hostname
         then
           error
             (sprintf
                "locked from %s, unlock attempted from %s"
                locking_hostname
                my_hostname)
         else (
           let pid_start_matches_lock pid =
             match Option.both (Info.start_time info) (process_start_time pid) with
             | None -> true
             | Some (lock_start, pid_start) ->
               let epsilon = Time_float.Span.of_sec 1. in
               Time_float.Span.( < ) (Time_float.abs_diff lock_start pid_start) epsilon
           in
           let is_locked_by_me () =
             Pid.equal locking_pid my_pid && pid_start_matches_lock my_pid
           in
           let locking_pid_exists () =
             Signal_unix.can_send_to locking_pid && pid_start_matches_lock locking_pid
           in
           if (unlock_myself && is_locked_by_me ()) || not (locking_pid_exists ())
           then (
             (try Unix.unlink path with
              | Unix.Unix_error (ENOENT, _, _) -> ()
              | e -> error (Exn.to_string e));
             try Unix.unlink lock_path with
             | e -> error (Exn.to_string e))
           else
             error
               (sprintf
                  "locking process (pid %i) still running on %s"
                  (Pid.to_int locking_pid)
                  locking_hostname)))
  ;;

  let create_exn ?(message = "") path =
    try
      unlock_safely_exn ~unlock_myself:false path;
      let fd = Unix.openfile path ~mode:[ Unix.O_WRONLY; Unix.O_CREAT ] in
      let cleanup = ref (fun () -> Unix.close fd) in
      protect
        ~finally:(fun () -> !cleanup ())
        ~f:(fun () ->
          Unix.link ~target:path ~link_name:(lock_path path) ();
          Unix.ftruncate fd ~len:0L;
          let info = Info.create ~message in
          try
            let out_channel = Unix.out_channel_of_descr fd in
            (cleanup := fun () -> Stdlib.close_out_noerr out_channel);
            fprintf out_channel "%s\n%!" (Sexp.to_string_hum (Info.sexp_of_t info))
          with
          | Sys_error _ as err ->
            Unix.unlink path;
            Unix.unlink (lock_path path);
            raise err);
      at_exit (fun () ->
        try unlock_safely_exn ~unlock_myself:true path with
        | _ -> ())
    with
    | e ->
      failwithf
        "Lock_file.Nfs.create_exn: unable to lock '%s' - %s"
        path
        (Exn.to_string e)
        ()
  ;;

  let create ?message path = Or_error.try_with (fun () -> create_exn ?message path)

  let blocking_create ?timeout ?message path =
    repeat_with_timeout ?timeout (fun path -> create_exn ?message path) path
  ;;

  let critical_section ?message path ~timeout ~f =
    blocking_create ~timeout ?message path;
    Exn.protect ~f ~finally:(fun () -> unlock_safely_exn ~unlock_myself:true path)
  ;;

  let unlock_exn path = unlock_safely_exn ~unlock_myself:true path
  let unlock path = Or_error.try_with (fun () -> unlock_exn path)
end

let canonicalize_dirname path =
  let dir, name = Filename.dirname path, Filename.basename path in
  let dir = Filename_unix.realpath dir in
  dir ^/ name
;;

module Mkdir = struct
  type t = Locked of { lock_path : string }

  let lock_exn ~lock_path =
    let lock_path = canonicalize_dirname lock_path in
    match Unix.mkdir lock_path with
    | exception Core_unix.Unix_error (EEXIST, _, _) -> `Somebody_else_took_it
    | () -> `We_took_it (Locked { lock_path })
  ;;

  let unlock_exn (Locked { lock_path }) = Unix.rmdir lock_path
end

module Symlink = struct
  type t = Locked of { lock_path : string }

  let lock_exn ~lock_path ~metadata =
    let lock_path = canonicalize_dirname lock_path in
    match Unix.symlink ~link_name:lock_path ~target:metadata with
    | exception Core_unix.Unix_error (EEXIST, _, _) ->
      `Somebody_else_took_it (Or_error.try_with (fun () -> Unix.readlink lock_path))
    | () -> `We_took_it (Locked { lock_path })
  ;;

  let unlock_exn (Locked { lock_path }) = Unix.unlink lock_path
end

module Flock = struct
  type t =
    { fd : Caml_unix.file_descr
    ; mutable unlocked : bool
    }

  let lock_exn ?lock_owner_uid ?(exclusive = true) ?(close_on_exec = true) () ~lock_path =
    let fd =
      Core_unix.openfile
        lock_path
        ~mode:([ Unix.O_WRONLY; O_CREAT ] @ if close_on_exec then [ O_CLOEXEC ] else [])
        ~perm:0o664
    in
    Option.iter lock_owner_uid ~f:(fun uid -> Core_unix.fchown fd ~uid ~gid:(-1));
    match flock ~exclusive fd with
    | false ->
      Core_unix.close ~restart:true fd;
      `Somebody_else_took_it
    | true -> `We_took_it { fd; unlocked = false }
    | exception exn ->
      Core_unix.close ~restart:true fd;
      raise exn
  ;;

  let unlock_exn t =
    if t.unlocked
    then
      raise_s
        (Ppx_sexp_conv_lib.Conv.sexp_of_string
           "Lock_file_blocking.Flock.unlock_exn called twice");
    t.unlocked <- true;
    Core_unix.close ~restart:true t.fd
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
