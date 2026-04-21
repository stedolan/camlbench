let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"daemon.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "daemon.ml.before-ppx"
;;

open! Core
open Poly
open! Import
module Unix = Core_unix

let check_threads ~allow_threads_to_have_been_created =
  if (not allow_threads_to_have_been_created) && Thread.threads_have_been_created ()
  then
    failwith
      "Daemon.check_threads: may not be called if any threads have ever been created";
  match Thread.num_threads () with
  | None -> ()
  | Some (1 | 2) -> ()
  | Some _ ->
    failwith
      "Daemon.check_threads: may not be called if more than 2 threads (hopefully the \
       main thread + ticker thread) are running"
;;

module Fd_redirection = struct
  type do_redirect =
    [ `Dev_null
    | `Dev_null_skip_regular_files
    | `File_append of string
    | `File_truncate of string
    ]

  type t =
    [ `Do_not_redirect
    | do_redirect
    ]
end

let redirect_fd ?perm ~mode ~src ~dst () =
  match src with
  | `Do_not_redirect -> ()
  | #Fd_redirection.do_redirect as src ->
    let redirect src =
      Unix.dup2 ~src ~dst ();
      Unix.close src
    in
    let open_dev_null () = Unix.openfile "/dev/null" ~mode:[ mode ] ~perm:0o777 in
    (match src with
     | `Dev_null_skip_regular_files ->
       let is_regular () =
         try (Unix.fstat dst).Unix.st_kind = Unix.S_REG with
         | Unix.Unix_error (EBADF, _, _) -> false
       in
       if not (is_regular ()) then redirect (open_dev_null ()) else ()
     | `Dev_null -> redirect (open_dev_null ())
     | `File_append file ->
       redirect (Unix.openfile file ?perm ~mode:[ mode; Unix.O_CREAT; Unix.O_APPEND ])
     | `File_truncate file ->
       redirect (Unix.openfile file ?perm ~mode:[ mode; Unix.O_CREAT; Unix.O_TRUNC ]))
;;

let redirect_stdio_fds ?perm ~stdout ~stderr () =
  redirect_fd ?perm ~mode:Unix.O_RDONLY ~src:`Dev_null ~dst:Unix.stdin ();
  redirect_fd ?perm ~mode:Unix.O_WRONLY ~src:stdout ~dst:Unix.stdout ();
  redirect_fd ?perm ~mode:Unix.O_WRONLY ~src:stderr ~dst:Unix.stderr ()
;;

let daemonize
      ?(redirect_stdout = `Dev_null)
      ?(redirect_stderr = `Dev_null)
      ?(cd = "/")
      ?perm
      ?umask
      ?(allow_threads_to_have_been_created = false)
      ()
  =
  check_threads ~allow_threads_to_have_been_created;
  let fork_no_parent () =
    match Unix.handle_unix_error Unix.fork with
    | `In_the_child -> ()
    | `In_the_parent _ -> exit 0
  in
  fork_no_parent ();
  ignore (Unix.Terminal_io.setsid ());
  fork_no_parent ();
  Unix.chdir cd;
  Option.iter umask ~f:(fun umask -> ignore (Unix.umask umask));
  redirect_stdio_fds ?perm ~stdout:redirect_stdout ~stderr:redirect_stderr ()
;;

let process_status_to_exit_code = function
  | Ok () -> 0
  | Error (`Exit_non_zero i) -> i
  | Error (`Signal s) -> Signal.to_caml_int s
;;

let daemonize_wait
      ?(redirect_stdout = `Dev_null_skip_regular_files)
      ?(redirect_stderr = `Dev_null_skip_regular_files)
      ?(cd = "/")
      ?perm
      ?umask
      ?(allow_threads_to_have_been_created = false)
      ()
  =
  check_threads ~allow_threads_to_have_been_created;
  match Unix.handle_unix_error Unix.fork with
  | `In_the_child ->
    ignore (Unix.Terminal_io.setsid ());
    let read_end, write_end = Unix.pipe () in
    let buf = "done" in
    let len = String.length buf in
    (match Unix.handle_unix_error Unix.fork with
     | `In_the_child ->
       Unix.close read_end;
       Unix.chdir cd;
       Option.iter umask ~f:(fun umask -> ignore (Unix.umask umask));
       Staged.stage (fun () ->
         redirect_stdio_fds ?perm ~stdout:redirect_stdout ~stderr:redirect_stderr ();
         let old_sigpipe_behavior = Signal.Expert.signal Signal.pipe `Ignore in
         (try ignore (Unix.write_substring write_end ~buf ~pos:0 ~len : int) with
          | _ -> ());
         Signal.Expert.set Signal.pipe old_sigpipe_behavior;
         Unix.close write_end)
     | `In_the_parent pid ->
       Unix.close write_end;
       let rec loop () =
         match Unix.wait_nohang (`Pid pid) with
         | None ->
           (match
              Unix.select
                ~read:[ read_end ]
                ~write:[]
                ~except:[]
                ~timeout:(`After (Time_ns.Span.of_sec 0.1))
                ()
            with
            | { Unix.Select_fds.read = read_end :: []; write = []; except = [] } ->
              if Unix.read read_end ~buf:(Bytes.create len) ~pos:0 ~len > 0
              then exit 0
              else loop ()
            | _ -> loop ())
         | Some (_pid, process_status) ->
           exit (process_status_to_exit_code process_status)
       in
       loop ())
  | `In_the_parent pid -> exit (process_status_to_exit_code (Unix.waitpid pid))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
