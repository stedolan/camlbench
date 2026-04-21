let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"signal_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "signal_unix.ml.before-ppx"
;;

open! Core
open! Import
open Core.Signal

external ml_caml_to_nonportable_signal_number
  :  t
  -> int
  = "ml_caml_to_nonportable_signal_number"

external ml_nonportable_to_caml_signal_number
  :  int
  -> t
  = "ml_nonportable_to_caml_signal_number"

let of_system_int t = ml_nonportable_to_caml_signal_number t
let to_system_int t = ml_caml_to_nonportable_signal_number t

type pid_spec =
  [ `Pid of Pid.t
  | `My_group
  | `Group of Pid.t
  ]
[@@deriving sexp_of]

include struct
  let _ = fun (_ : pid_spec) -> ()

  let sexp_of_pid_spec =
    (function
     | `Pid v__001_ ->
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Pid"; Pid.sexp_of_t v__001_ ]
     | `My_group -> Sexplib0.Sexp.Atom "My_group"
     | `Group v__002_ ->
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; Pid.sexp_of_t v__002_ ]
     : pid_spec -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_pid_spec
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pid_spec_to_int = function
  | `Pid pid -> Pid.to_int pid
  | `My_group -> 0
  | `Group pid -> -Pid.to_int pid
;;

let pid_spec_to_string p = Int.to_string (pid_spec_to_int p)

let send t pid_spec =
  try
    UnixLabels.kill ~pid:(pid_spec_to_int pid_spec) ~signal:(to_caml_int t);
    `Ok
  with
  | Unix.Unix_error (Unix.ESRCH, _, _) -> `No_such_process
;;

let send_i t pid_spec =
  match send t pid_spec with
  | `Ok | `No_such_process -> ()
;;

let send_exn t pid_spec =
  match send t pid_spec with
  | `Ok -> ()
  | `No_such_process ->
    failwithf
      "Signal_unix.send_exn %s pid:%s"
      (to_string t)
      (pid_spec_to_string pid_spec)
      ()
;;

type sigprocmask_command =
  [ `Set
  | `Block
  | `Unblock
  ]

let sigprocmask mode sigs =
  let mode =
    match mode with
    | `Block -> Unix.SIG_BLOCK
    | `Unblock -> Unix.SIG_UNBLOCK
    | `Set -> Unix.SIG_SETMASK
  in
  List.map ~f:of_caml_int (Unix.sigprocmask mode (List.map ~f:to_caml_int sigs))
;;

let sigpending () = List.map ~f:of_caml_int (Unix.sigpending ())
let sigsuspend ts = Unix.sigsuspend (List.map ~f:to_caml_int ts)

let can_send_to pid =
  try
    send_exn zero (`Pid pid);
    true
  with
  | _ -> false
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
