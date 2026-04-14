let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"signal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "signal.ml.before-ppx"
;;

open! Import

include (
  Int :
  sig
    type t = int [@@deriving bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t
    include Hashable.S with type t := t
  end)

let of_caml_int t = t
let to_caml_int t = t

type sys_behavior =
  [ `Continue [@ocaml.doc " Continue the process if it is currently stopped "]
  | `Dump_core [@ocaml.doc " Terminate the process and dump core "]
  | `Ignore [@ocaml.doc " Ignore the signal "]
  | `Stop [@ocaml.doc " Stop the process "]
  | `Terminate [@ocaml.doc " Terminate the process "]
  ]
[@@deriving sexp]

include struct
  let _ = fun (_ : sys_behavior) -> ()

  let __sys_behavior_of_sexp__ =
    (let error_source__006_ = "signal.ml.before-ppx.sys_behavior" in
     function
     | Sexplib0.Sexp.Atom atom__002_ as _sexp__004_ ->
       (match atom__002_ with
        | "Continue" -> `Continue
        | "Dump_core" -> `Dump_core
        | "Ignore" -> `Ignore
        | "Stop" -> `Stop
        | "Terminate" -> `Terminate
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__002_ :: _) as _sexp__004_ ->
       (match atom__002_ with
        | "Continue" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
        | "Dump_core" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
        | "Ignore" -> Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
        | "Stop" -> Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
        | "Terminate" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var error_source__006_ sexp__003_
     | Sexplib0.Sexp.List [] as sexp__003_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var error_source__006_ sexp__003_
     : Sexplib0.Sexp.t -> sys_behavior)
  ;;

  let _ = __sys_behavior_of_sexp__

  let sys_behavior_of_sexp =
    (let error_source__008_ = "signal.ml.before-ppx.sys_behavior" in
     fun sexp__007_ ->
       try __sys_behavior_of_sexp__ sexp__007_ with
       | Sexplib0.Sexp_conv_error.No_variant_match ->
         Sexplib0.Sexp_conv_error.no_matching_variant_found error_source__008_ sexp__007_
     : Sexplib0.Sexp.t -> sys_behavior)
  ;;

  let _ = sys_behavior_of_sexp

  let sexp_of_sys_behavior =
    (function
     | `Continue -> Sexplib0.Sexp.Atom "Continue"
     | `Dump_core -> Sexplib0.Sexp.Atom "Dump_core"
     | `Ignore -> Sexplib0.Sexp.Atom "Ignore"
     | `Stop -> Sexplib0.Sexp.Atom "Stop"
     | `Terminate -> Sexplib0.Sexp.Atom "Terminate"
     : sys_behavior -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_sys_behavior
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let equal (t : t) t' = t = t'

include struct
  open Stdlib.Sys

  let abrt = sigabrt
  let alrm = sigalrm
  let bus = sigbus
  let chld = sigchld
  let cont = sigcont
  let fpe = sigfpe
  let hup = sighup
  let ill = sigill
  let int = sigint
  let kill = sigkill
  let pipe = sigpipe
  let poll = sigpoll
  let prof = sigprof
  let quit = sigquit
  let segv = sigsegv
  let stop = sigstop
  let sys = sigsys
  let term = sigterm
  let trap = sigtrap
  let tstp = sigtstp
  let ttin = sigttin
  let ttou = sigttou
  let urg = sigurg
  let usr1 = sigusr1
  let usr2 = sigusr2
  let vtalrm = sigvtalrm
  let xcpu = sigxcpu
  let xfsz = sigxfsz
  let zero = 0
end

exception Invalid_signal_mnemonic_or_number of string [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Invalid_signal_mnemonic_or_number]
      (function
      | Invalid_signal_mnemonic_or_number arg0__009_ ->
        let res0__010_ = sexp_of_string arg0__009_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "signal.ml.before-ppx.Invalid_signal_mnemonic_or_number"
          ; res0__010_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let to_string_with_version, of_string, default_sys_behavior =
  let known =
    [ "sigabrt", abrt, `Dump_core, 1
    ; "sigalrm", alrm, `Terminate, 1
    ; "sigbus", bus, `Dump_core, 2
    ; "sigchld", chld, `Ignore, 1
    ; "sigcont", cont, `Continue, 1
    ; "sigfpe", fpe, `Dump_core, 1
    ; "sighup", hup, `Terminate, 1
    ; "sigill", ill, `Dump_core, 1
    ; "sigint", int, `Terminate, 1
    ; "sigkill", kill, `Terminate, 1
    ; "sigpipe", pipe, `Terminate, 1
    ; "sigpoll", poll, `Terminate, 2
    ; "sigprof", prof, `Terminate, 1
    ; "sigquit", quit, `Dump_core, 1
    ; "sigsegv", segv, `Dump_core, 1
    ; "sigstop", stop, `Stop, 1
    ; "sigsys", sys, `Dump_core, 2
    ; "sigterm", term, `Terminate, 1
    ; "sigtrap", trap, `Dump_core, 2
    ; "sigtstp", tstp, `Stop, 1
    ; "sigttin", ttin, `Stop, 1
    ; "sigttou", ttou, `Stop, 1
    ; "sigurg", urg, `Ignore, 2
    ; "sigusr1", usr1, `Terminate, 1
    ; "sigusr2", usr2, `Terminate, 1
    ; "sigvtalrm", vtalrm, `Terminate, 1
    ; "sigxcpu", xcpu, `Dump_core, 2
    ; "sigxfsz", xfsz, `Dump_core, 2
    ; "sigzero", zero, `Ignore, 1
    ]
  in
  let name_and_version_by_t = Int.Table.create ~size:1 () in
  let t_by_name = String.Table.create ~size:1 () in
  let behavior_by_t = Int.Table.create ~size:1 () in
  List.iter known ~f:(fun (name, t, behavior, stable_version) ->
    Hashtbl.set name_and_version_by_t ~key:t ~data:(name, stable_version);
    Hashtbl.set t_by_name ~key:name ~data:t;
    Hashtbl.set behavior_by_t ~key:t ~data:behavior);
  let to_string_with_version t ~version:requested_version =
    match Hashtbl.find name_and_version_by_t t with
    | Some (string, needed_version) when requested_version >= needed_version -> string
    | _ -> "<unknown signal " ^ Int.to_string t ^ ">"
  in
  let of_string s =
    let s = String.lowercase (String.strip s) in
    match Hashtbl.find t_by_name s with
    | Some sn -> sn
    | None ->
      if String.is_prefix s ~prefix:"<unknown signal "
      then (
        try Int.of_string (String.slice s 16 ~-1) with
        | _ -> raise (Invalid_signal_mnemonic_or_number s))
      else raise (Invalid_signal_mnemonic_or_number s)
  in
  let default_sys_behavior t =
    match Hashtbl.find behavior_by_t t with
    | None ->
      raise
        (Invalid_argument
           ("Signal.default_sys_behavior: unknown signal " ^ Int.to_string t))
    | Some behavior -> behavior
  in
  to_string_with_version, of_string, default_sys_behavior
;;

exception Expected_atom of Sexp.t [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Expected_atom] (function
      | Expected_atom arg0__011_ ->
        let res0__012_ = Sexp.sexp_of_t arg0__011_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "signal.ml.before-ppx.Expected_atom"; res0__012_ ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sexp_of_t_with_version t ~version = Sexp.Atom (to_string_with_version t ~version)
let to_string s = to_string_with_version s ~version:2
let sexp_of_t t = sexp_of_t_with_version t ~version:2

let t_of_sexp s =
  match s with
  | Sexp.Atom s -> of_string s
  | _ -> raise (Expected_atom s)
;;

type pid_spec = [ `Use_Signal_unix ]
type sigprocmask_command = [ `Use_Signal_unix ]

let can_send_to = `Use_Signal_unix
let of_system_int = `Use_Signal_unix
let send = `Use_Signal_unix
let send_exn = `Use_Signal_unix
let send_i = `Use_Signal_unix
let sexp_of_pid_spec = `Use_Signal_unix
let sigpending = `Use_Signal_unix
let sigprocmask = `Use_Signal_unix
let sigsuspend = `Use_Signal_unix
let to_system_int = `Use_Signal_unix

module Expert = struct
  type behavior =
    [ `Default
    | `Ignore
    | `Handle of (t -> unit[@sexp.opaque])
    ]
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : behavior) -> ()

    let sexp_of_behavior =
      (function
       | `Default -> Sexplib0.Sexp.Atom "Default"
       | `Ignore -> Sexplib0.Sexp.Atom "Ignore"
       | `Handle v__013_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Handle"; Sexplib0.Sexp_conv.sexp_of_opaque v__013_ ]
       : behavior -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_behavior
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Behavior = struct
    let of_caml = function
      | Stdlib.Sys.Signal_default -> `Default
      | Signal_ignore -> `Ignore
      | Signal_handle f -> `Handle f
    ;;

    let to_caml = function
      | `Default -> Stdlib.Sys.Signal_default
      | `Ignore -> Signal_ignore
      | `Handle f -> Signal_handle (fun t -> Exn.handle_uncaught_and_exit (fun () -> f t))
    ;;
  end

  let signal t behavior =
    Behavior.of_caml (Stdlib.Sys.signal t (Behavior.to_caml behavior))
  ;;

  let set t behavior = ignore (signal t behavior : behavior)
  let handle t f = set t (`Handle f)
end

open Expert

let handle_default t = set t `Default
let ignore t = set t `Ignore

module Stable = struct
  module V2 = struct
    type nonrec t = t [@@deriving bin_io, compare]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "signal.ml.before-ppx:196:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__014_ b__015_ -> compare a__014_ b__015_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let t_of_sexp = t_of_sexp
    let sexp_of_t t = sexp_of_t_with_version t ~version:2
  end

  module V1 = struct
    type nonrec t = t [@@deriving bin_io, compare]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "signal.ml.before-ppx:203:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__016_ b__017_ -> compare a__016_ b__017_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let t_of_sexp = t_of_sexp
    let sexp_of_t t = sexp_of_t_with_version t ~version:1
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
