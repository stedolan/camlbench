let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"core_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "core_unix.ml.before-ppx"
;;

[%%import "config.h"]

open! Core
open! Import
open Stable_witness.Export
module Time_ns = Core.Core_private.Time_ns_alternate_sexp

let ( ^/ ) = Filename.concat
let atom x = Sexp.Atom x
let list x = Sexp.List x
let record l = list (List.map l ~f:(fun (name, value) -> list [ atom name; value ]))

let rec retry_until_no_eintr f =
  try f () with
  | Unix.Unix_error (EINTR, _, _) -> retry_until_no_eintr f
;;

let sexp_to_string_hum sexp =
  let buf = Buffer.create 100 in
  let fmt = Format.formatter_of_buffer buf in
  Format.pp_set_margin fmt 10000;
  Sexp.pp_hum fmt sexp;
  Format.pp_print_flush fmt ();
  Buffer.contents buf
;;

module Private = struct
  let sexp_to_string_hum = sexp_to_string_hum
end

let improve ?(restart = false) f make_arg_sexps =
  try if restart then retry_until_no_eintr f else f () with
  | Unix.Unix_error (e, s, _) ->
    raise (Unix.Unix_error (e, s, sexp_to_string_hum (record (make_arg_sexps ()))))
;;

module File_descr = File_descr

let sprintf = Printf.sprintf

external sync : unit -> unit = "core_unix_sync"
external fsync : Unix.file_descr -> unit = "core_unix_fsync"
external fdatasync : Unix.file_descr -> unit = "core_unix_fdatasync"
external dirfd : Unix.dir_handle -> File_descr.t = "core_unix_dirfd"
external unsetenv : string -> unit = "core_unix_unsetenv"
external exit_immediately : int -> _ = "caml_sys_exit"

external unsafe_read_assume_fd_is_nonblocking
  :  File_descr.t
  -> Bytes.t
  -> pos:int
  -> len:int
  -> int
  = "core_unix_read_assume_fd_is_nonblocking_stub"

let check_bytes_args ~loc str ~pos ~len =
  if pos < 0 then invalid_arg (loc ^ ": pos < 0");
  if len < 0 then invalid_arg (loc ^ ": len < 0");
  let str_len = Bytes.length str in
  if str_len < pos + len
  then invalid_arg (Printf.sprintf "Unix_ext.%s: length(str) < pos + len" loc)
;;

let get_opt_pos ~loc = function
  | Some pos ->
    if pos < 0 then invalid_arg (Printf.sprintf "Unix_ext.%s: pos < 0" loc);
    pos
  | None -> 0
;;

let get_opt_len str ~pos = function
  | Some len -> len
  | None -> Bytes.length str - pos
;;

let read_assume_fd_is_nonblocking fd ?pos ?len buf =
  let loc = "read_assume_fd_is_nonblocking" in
  let pos = get_opt_pos ~loc pos in
  let len = get_opt_len buf ~pos len in
  check_bytes_args ~loc buf ~pos ~len;
  unsafe_read_assume_fd_is_nonblocking fd buf ~pos ~len
;;

external unsafe_write_assume_fd_is_nonblocking
  :  File_descr.t
  -> Bytes.t
  -> pos:int
  -> len:int
  -> int
  = "core_unix_write_assume_fd_is_nonblocking_stub"

let write_assume_fd_is_nonblocking fd ?pos ?len buf =
  let loc = "write_assume_fd_is_nonblocking" in
  let pos = get_opt_pos ~loc pos in
  let len = get_opt_len buf ~pos len in
  check_bytes_args ~loc buf ~pos ~len;
  unsafe_write_assume_fd_is_nonblocking fd buf ~pos ~len
;;

external mknod
  :  string
  -> Unix.file_kind
  -> int
  -> int
  -> int
  -> unit
  = "core_unix_mknod_stub"

let mknod ?(file_kind = Unix.S_REG) ?(perm = 0o600) ?(major = 0) ?(minor = 0) pathname =
  mknod pathname file_kind perm major minor
;;

module RLimit = struct
  module Limit = struct
    type t =
      | Limit of int64
      | Infinity
    [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__003_ = "core_unix.ml.before-ppx.RLimit.Limit.t" in
         function
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("limit" | "Limit") as _tag__006_) :: sexp_args__007_)
           as _sexp__005_ ->
           (match sexp_args__007_ with
            | arg0__008_ :: [] ->
              let res0__009_ = int64_of_sexp arg0__008_ in
              Limit res0__009_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__003_
                _tag__006_
                _sexp__005_)
         | Sexplib0.Sexp.Atom ("infinity" | "Infinity") -> Infinity
         | Sexplib0.Sexp.Atom ("limit" | "Limit") as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("infinity" | "Infinity") :: _) as
           sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
         | Sexplib0.Sexp.List [] as sexp__002_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
         | sexp__002_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Limit arg0__010_ ->
           let res0__011_ = sexp_of_int64 arg0__010_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Limit"; res0__011_ ]
         | Infinity -> Sexplib0.Sexp.Atom "Infinity"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let max t1 t2 =
      match t1, t2 with
      | Infinity, _ | _, Infinity -> Infinity
      | Limit n1, Limit n2 -> Limit (Int64.max n1 n2)
    ;;

    let min t1 t2 =
      match t1, t2 with
      | Infinity, t | t, Infinity -> t
      | Limit n1, Limit n2 -> Limit (Int64.min n1 n2)
    ;;
  end

  type limit = Limit.t =
    | Limit of int64
    | Infinity
  [@@deriving sexp]

  include struct
    let _ = fun (_ : limit) -> ()

    let limit_of_sexp =
      (let error_source__014_ = "core_unix.ml.before-ppx.RLimit.limit" in
       function
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("limit" | "Limit") as _tag__017_) :: sexp_args__018_) as
         _sexp__016_ ->
         (match sexp_args__018_ with
          | arg0__019_ :: [] ->
            let res0__020_ = int64_of_sexp arg0__019_ in
            Limit res0__020_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__014_
              _tag__017_
              _sexp__016_)
       | Sexplib0.Sexp.Atom ("infinity" | "Infinity") -> Infinity
       | Sexplib0.Sexp.Atom ("limit" | "Limit") as sexp__015_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__014_ sexp__015_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("infinity" | "Infinity") :: _) as
         sexp__015_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__014_ sexp__015_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__013_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__014_ sexp__013_
       | Sexplib0.Sexp.List [] as sexp__013_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__014_ sexp__013_
       | sexp__013_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__014_ sexp__013_
       : Sexplib0.Sexp.t -> limit)
    ;;

    let _ = limit_of_sexp

    let sexp_of_limit =
      (function
       | Limit arg0__021_ ->
         let res0__022_ = sexp_of_int64 arg0__021_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Limit"; res0__022_ ]
       | Infinity -> Sexplib0.Sexp.Atom "Infinity"
       : limit -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_limit
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t =
    { cur : limit
    ; max : limit
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__024_ = "core_unix.ml.before-ppx.RLimit.t" in
       fun x__025_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__024_
           ~fields:
             (Field
                { name = "cur"
                ; kind = Required
                ; conv = limit_of_sexp
                ; rest =
                    Field
                      { name = "max"
                      ; kind = Required
                      ; conv = limit_of_sexp
                      ; rest = Empty
                      }
                })
           ~index_of_field:(function
             | "cur" -> 0
             | "max" -> 1
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (cur, (max, ())) -> ({ cur; max } : t))
           x__025_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { cur = cur__027_; max = max__029_ } ->
         let bnds__026_ = ([] : _ Stdlib.List.t) in
         let bnds__026_ =
           let arg__030_ = sexp_of_limit max__029_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max"; arg__030_ ] :: bnds__026_
            : _ Stdlib.List.t)
         in
         let bnds__026_ =
           let arg__028_ = sexp_of_limit cur__027_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "cur"; arg__028_ ] :: bnds__026_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__026_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type resource =
    | Core_file_size
    | Cpu_seconds
    | Data_segment
    | File_size
    | Num_file_descriptors
    | Stack
    | Virtual_memory
    | Nice
  [@@deriving sexp]

  include struct
    let _ = fun (_ : resource) -> ()

    let resource_of_sexp =
      (let error_source__033_ = "core_unix.ml.before-ppx.RLimit.resource" in
       function
       | Sexplib0.Sexp.Atom ("core_file_size" | "Core_file_size") -> Core_file_size
       | Sexplib0.Sexp.Atom ("cpu_seconds" | "Cpu_seconds") -> Cpu_seconds
       | Sexplib0.Sexp.Atom ("data_segment" | "Data_segment") -> Data_segment
       | Sexplib0.Sexp.Atom ("file_size" | "File_size") -> File_size
       | Sexplib0.Sexp.Atom ("num_file_descriptors" | "Num_file_descriptors") ->
         Num_file_descriptors
       | Sexplib0.Sexp.Atom ("stack" | "Stack") -> Stack
       | Sexplib0.Sexp.Atom ("virtual_memory" | "Virtual_memory") -> Virtual_memory
       | Sexplib0.Sexp.Atom ("nice" | "Nice") -> Nice
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("core_file_size" | "Core_file_size") :: _)
         as sexp__034_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cpu_seconds" | "Cpu_seconds") :: _) as
         sexp__034_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("data_segment" | "Data_segment") :: _) as
         sexp__034_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("file_size" | "File_size") :: _) as
         sexp__034_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom ("num_file_descriptors" | "Num_file_descriptors") :: _) as
         sexp__034_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("stack" | "Stack") :: _) as sexp__034_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("virtual_memory" | "Virtual_memory") :: _)
         as sexp__034_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nice" | "Nice") :: _) as sexp__034_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__033_ sexp__034_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__032_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__033_ sexp__032_
       | Sexplib0.Sexp.List [] as sexp__032_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__033_ sexp__032_
       | sexp__032_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__033_ sexp__032_
       : Sexplib0.Sexp.t -> resource)
    ;;

    let _ = resource_of_sexp

    let sexp_of_resource =
      (function
       | Core_file_size -> Sexplib0.Sexp.Atom "Core_file_size"
       | Cpu_seconds -> Sexplib0.Sexp.Atom "Cpu_seconds"
       | Data_segment -> Sexplib0.Sexp.Atom "Data_segment"
       | File_size -> Sexplib0.Sexp.Atom "File_size"
       | Num_file_descriptors -> Sexplib0.Sexp.Atom "Num_file_descriptors"
       | Stack -> Sexplib0.Sexp.Atom "Stack"
       | Virtual_memory -> Sexplib0.Sexp.Atom "Virtual_memory"
       | Nice -> Sexplib0.Sexp.Atom "Nice"
       : resource -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_resource
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let core_file_size = Core_file_size
  let cpu_seconds = Cpu_seconds
  let data_segment = Data_segment
  let file_size = File_size
  let num_file_descriptors = Num_file_descriptors
  let stack = Stack

  [%%ifdef JSC_RLIMIT_AS]

  let virtual_memory = Ok Virtual_memory

  [%%else]

  let virtual_memory = Or_error.unimplemented "RLIMIT_AS is not supported on this system"

  [%%endif]
  [%%ifdef JSC_RLIMIT_NICE]

  let nice = Ok Nice

  [%%else]

  let nice = Or_error.unimplemented "RLIMIT_NICE is not supported on this system"

  [%%endif]

  let resource_of_sexp sexp =
    match resource_of_sexp sexp with
    | Nice ->
      (match nice with
       | Ok resource -> resource
       | Error error -> of_sexp_error (Error.to_string_hum error) sexp)
    | ( Core_file_size
      | Cpu_seconds
      | Data_segment
      | File_size
      | Num_file_descriptors
      | Stack
      | Virtual_memory ) as resource -> resource
  ;;

  external get : resource -> t = "core_unix_getrlimit"
  external set : resource -> t -> unit = "core_unix_setrlimit"

  let get resource =
    improve (fun () -> get resource) (fun () -> [ "resource", sexp_of_resource resource ])
  ;;

  let set resource t =
    improve
      (fun () -> set resource t)
      (fun () -> [ "resource", sexp_of_resource resource; "limit", sexp_of_t t ])
  ;;
end

module Resource_usage = struct
  type t =
    { utime : float
    ; stime : float
    ; maxrss : int64
    ; ixrss : int64
    ; idrss : int64
    ; isrss : int64
    ; minflt : int64
    ; majflt : int64
    ; nswap : int64
    ; inblock : int64
    ; oublock : int64
    ; msgsnd : int64
    ; msgrcv : int64
    ; nsignals : int64
    ; nvcsw : int64
    ; nivcsw : int64
    }
  [@@deriving sexp, fields ~getters]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__036_ = "core_unix.ml.before-ppx.Resource_usage.t" in
       fun x__037_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__036_
           ~fields:
             (Field
                { name = "utime"
                ; kind = Required
                ; conv = float_of_sexp
                ; rest =
                    Field
                      { name = "stime"
                      ; kind = Required
                      ; conv = float_of_sexp
                      ; rest =
                          Field
                            { name = "maxrss"
                            ; kind = Required
                            ; conv = int64_of_sexp
                            ; rest =
                                Field
                                  { name = "ixrss"
                                  ; kind = Required
                                  ; conv = int64_of_sexp
                                  ; rest =
                                      Field
                                        { name = "idrss"
                                        ; kind = Required
                                        ; conv = int64_of_sexp
                                        ; rest =
                                            Field
                                              { name = "isrss"
                                              ; kind = Required
                                              ; conv = int64_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "minflt"
                                                    ; kind = Required
                                                    ; conv = int64_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "majflt"
                                                          ; kind = Required
                                                          ; conv = int64_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "nswap"
                                                                ; kind = Required
                                                                ; conv = int64_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name = "inblock"
                                                                      ; kind = Required
                                                                      ; conv =
                                                                          int64_of_sexp
                                                                      ; rest =
                                                                          Field
                                                                            { name =
                                                                                "oublock"
                                                                            ; kind =
                                                                                Required
                                                                            ; conv =
                                                                                int64_of_sexp
                                                                            ; rest =
                                                                                Field
                                                                                  { name =
                                                                                      "msgsnd"
                                                                                  ; kind =
                                                                                      Required
                                                                                  ; conv =
                                                                                      int64_of_sexp
                                                                                  ; rest =
                                                                                      Field
                                                                                        { name =
                                                                                          "msgrcv"
                                                                                        ; kind =
                                                                                          Required
                                                                                        ; conv =
                                                                                          int64_of_sexp
                                                                                        ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "nsignals"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int64_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "nvcsw"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int64_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "nivcsw"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int64_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                        }
                                                                                  }
                                                                            }
                                                                      }
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "utime" -> 0
             | "stime" -> 1
             | "maxrss" -> 2
             | "ixrss" -> 3
             | "idrss" -> 4
             | "isrss" -> 5
             | "minflt" -> 6
             | "majflt" -> 7
             | "nswap" -> 8
             | "inblock" -> 9
             | "oublock" -> 10
             | "msgsnd" -> 11
             | "msgrcv" -> 12
             | "nsignals" -> 13
             | "nvcsw" -> 14
             | "nivcsw" -> 15
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( utime
               , ( stime
                 , ( maxrss
                   , ( ixrss
                     , ( idrss
                       , ( isrss
                         , ( minflt
                           , ( majflt
                             , ( nswap
                               , ( inblock
                                 , ( oublock
                                   , (msgsnd, (msgrcv, (nsignals, (nvcsw, (nivcsw, ())))))
                                   ) ) ) ) ) ) ) ) ) ) ) ->
             ({ utime
              ; stime
              ; maxrss
              ; ixrss
              ; idrss
              ; isrss
              ; minflt
              ; majflt
              ; nswap
              ; inblock
              ; oublock
              ; msgsnd
              ; msgrcv
              ; nsignals
              ; nvcsw
              ; nivcsw
              }
              : t))
           x__037_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { utime = utime__039_
           ; stime = stime__041_
           ; maxrss = maxrss__043_
           ; ixrss = ixrss__045_
           ; idrss = idrss__047_
           ; isrss = isrss__049_
           ; minflt = minflt__051_
           ; majflt = majflt__053_
           ; nswap = nswap__055_
           ; inblock = inblock__057_
           ; oublock = oublock__059_
           ; msgsnd = msgsnd__061_
           ; msgrcv = msgrcv__063_
           ; nsignals = nsignals__065_
           ; nvcsw = nvcsw__067_
           ; nivcsw = nivcsw__069_
           } ->
         let bnds__038_ = ([] : _ Stdlib.List.t) in
         let bnds__038_ =
           let arg__070_ = sexp_of_int64 nivcsw__069_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nivcsw"; arg__070_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__068_ = sexp_of_int64 nvcsw__067_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nvcsw"; arg__068_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__066_ = sexp_of_int64 nsignals__065_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nsignals"; arg__066_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__064_ = sexp_of_int64 msgrcv__063_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "msgrcv"; arg__064_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__062_ = sexp_of_int64 msgsnd__061_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "msgsnd"; arg__062_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__060_ = sexp_of_int64 oublock__059_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "oublock"; arg__060_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__058_ = sexp_of_int64 inblock__057_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "inblock"; arg__058_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__056_ = sexp_of_int64 nswap__055_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nswap"; arg__056_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__054_ = sexp_of_int64 majflt__053_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "majflt"; arg__054_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__052_ = sexp_of_int64 minflt__051_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "minflt"; arg__052_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__050_ = sexp_of_int64 isrss__049_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "isrss"; arg__050_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__048_ = sexp_of_int64 idrss__047_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "idrss"; arg__048_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__046_ = sexp_of_int64 ixrss__045_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ixrss"; arg__046_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__044_ = sexp_of_int64 maxrss__043_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "maxrss"; arg__044_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__042_ = sexp_of_float stime__041_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stime"; arg__042_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         let bnds__038_ =
           let arg__040_ = sexp_of_float utime__039_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "utime"; arg__040_ ] :: bnds__038_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__038_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
    let nivcsw _r__ = _r__.nivcsw
    let _ = nivcsw
    let nvcsw _r__ = _r__.nvcsw
    let _ = nvcsw
    let nsignals _r__ = _r__.nsignals
    let _ = nsignals
    let msgrcv _r__ = _r__.msgrcv
    let _ = msgrcv
    let msgsnd _r__ = _r__.msgsnd
    let _ = msgsnd
    let oublock _r__ = _r__.oublock
    let _ = oublock
    let inblock _r__ = _r__.inblock
    let _ = inblock
    let nswap _r__ = _r__.nswap
    let _ = nswap
    let majflt _r__ = _r__.majflt
    let _ = majflt
    let minflt _r__ = _r__.minflt
    let _ = minflt
    let isrss _r__ = _r__.isrss
    let _ = isrss
    let idrss _r__ = _r__.idrss
    let _ = idrss
    let ixrss _r__ = _r__.ixrss
    let _ = ixrss
    let maxrss _r__ = _r__.maxrss
    let _ = maxrss
    let stime _r__ = _r__.stime
    let _ = stime
    let utime _r__ = _r__.utime
    let _ = utime
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  external getrusage : int -> t = "core_unix_getrusage"

  let get who =
    getrusage
      (match who with
       | `Self -> 0
       | `Children -> 1)
  ;;

  let add t1 t2 =
    { utime = t1.utime +. t2.utime
    ; stime = t1.stime +. t2.stime
    ; maxrss = Int64.( + ) t1.maxrss t2.maxrss
    ; ixrss = Int64.( + ) t1.ixrss t2.ixrss
    ; idrss = Int64.( + ) t1.idrss t2.idrss
    ; isrss = Int64.( + ) t1.isrss t2.isrss
    ; minflt = Int64.( + ) t1.minflt t2.minflt
    ; majflt = Int64.( + ) t1.majflt t2.majflt
    ; nswap = Int64.( + ) t1.nswap t2.nswap
    ; inblock = Int64.( + ) t1.inblock t2.inblock
    ; oublock = Int64.( + ) t1.oublock t2.oublock
    ; msgsnd = Int64.( + ) t1.msgsnd t2.msgsnd
    ; msgrcv = Int64.( + ) t1.msgrcv t2.msgrcv
    ; nsignals = Int64.( + ) t1.nsignals t2.nsignals
    ; nvcsw = Int64.( + ) t1.nvcsw t2.nvcsw
    ; nivcsw = Int64.( + ) t1.nivcsw t2.nivcsw
    }
  ;;
end

type sysconf =
  | ARG_MAX
  | CHILD_MAX
  | HOST_NAME_MAX
  | LOGIN_NAME_MAX
  | OPEN_MAX
  | PAGESIZE
  | RE_DUP_MAX
  | STREAM_MAX
  | SYMLOOP_MAX
  | TTY_NAME_MAX
  | TZNAME_MAX
  | POSIX_VERSION
  | PHYS_PAGES
  | AVPHYS_PAGES
  | IOV_MAX
  | CLK_TCK
  | NPROCESSORS_CONF
  | NPROCESSORS_ONLN
[@@deriving sexp]

include struct
  let _ = fun (_ : sysconf) -> ()

  let sysconf_of_sexp =
    (let error_source__073_ = "core_unix.ml.before-ppx.sysconf" in
     function
     | Sexplib0.Sexp.Atom ("aRG_MAX" | "ARG_MAX") -> ARG_MAX
     | Sexplib0.Sexp.Atom ("cHILD_MAX" | "CHILD_MAX") -> CHILD_MAX
     | Sexplib0.Sexp.Atom ("hOST_NAME_MAX" | "HOST_NAME_MAX") -> HOST_NAME_MAX
     | Sexplib0.Sexp.Atom ("lOGIN_NAME_MAX" | "LOGIN_NAME_MAX") -> LOGIN_NAME_MAX
     | Sexplib0.Sexp.Atom ("oPEN_MAX" | "OPEN_MAX") -> OPEN_MAX
     | Sexplib0.Sexp.Atom ("pAGESIZE" | "PAGESIZE") -> PAGESIZE
     | Sexplib0.Sexp.Atom ("rE_DUP_MAX" | "RE_DUP_MAX") -> RE_DUP_MAX
     | Sexplib0.Sexp.Atom ("sTREAM_MAX" | "STREAM_MAX") -> STREAM_MAX
     | Sexplib0.Sexp.Atom ("sYMLOOP_MAX" | "SYMLOOP_MAX") -> SYMLOOP_MAX
     | Sexplib0.Sexp.Atom ("tTY_NAME_MAX" | "TTY_NAME_MAX") -> TTY_NAME_MAX
     | Sexplib0.Sexp.Atom ("tZNAME_MAX" | "TZNAME_MAX") -> TZNAME_MAX
     | Sexplib0.Sexp.Atom ("pOSIX_VERSION" | "POSIX_VERSION") -> POSIX_VERSION
     | Sexplib0.Sexp.Atom ("pHYS_PAGES" | "PHYS_PAGES") -> PHYS_PAGES
     | Sexplib0.Sexp.Atom ("aVPHYS_PAGES" | "AVPHYS_PAGES") -> AVPHYS_PAGES
     | Sexplib0.Sexp.Atom ("iOV_MAX" | "IOV_MAX") -> IOV_MAX
     | Sexplib0.Sexp.Atom ("cLK_TCK" | "CLK_TCK") -> CLK_TCK
     | Sexplib0.Sexp.Atom ("nPROCESSORS_CONF" | "NPROCESSORS_CONF") -> NPROCESSORS_CONF
     | Sexplib0.Sexp.Atom ("nPROCESSORS_ONLN" | "NPROCESSORS_ONLN") -> NPROCESSORS_ONLN
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aRG_MAX" | "ARG_MAX") :: _) as sexp__074_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cHILD_MAX" | "CHILD_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("hOST_NAME_MAX" | "HOST_NAME_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOGIN_NAME_MAX" | "LOGIN_NAME_MAX") :: _)
       as sexp__074_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("oPEN_MAX" | "OPEN_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pAGESIZE" | "PAGESIZE") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("rE_DUP_MAX" | "RE_DUP_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sTREAM_MAX" | "STREAM_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sYMLOOP_MAX" | "SYMLOOP_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tTY_NAME_MAX" | "TTY_NAME_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tZNAME_MAX" | "TZNAME_MAX") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pOSIX_VERSION" | "POSIX_VERSION") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pHYS_PAGES" | "PHYS_PAGES") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aVPHYS_PAGES" | "AVPHYS_PAGES") :: _) as
       sexp__074_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iOV_MAX" | "IOV_MAX") :: _) as sexp__074_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cLK_TCK" | "CLK_TCK") :: _) as sexp__074_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("nPROCESSORS_CONF" | "NPROCESSORS_CONF") :: _) as sexp__074_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("nPROCESSORS_ONLN" | "NPROCESSORS_ONLN") :: _) as sexp__074_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__073_ sexp__074_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__072_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__073_ sexp__072_
     | Sexplib0.Sexp.List [] as sexp__072_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__073_ sexp__072_
     | sexp__072_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__073_ sexp__072_
     : Sexplib0.Sexp.t -> sysconf)
  ;;

  let _ = sysconf_of_sexp

  let sexp_of_sysconf =
    (function
     | ARG_MAX -> Sexplib0.Sexp.Atom "ARG_MAX"
     | CHILD_MAX -> Sexplib0.Sexp.Atom "CHILD_MAX"
     | HOST_NAME_MAX -> Sexplib0.Sexp.Atom "HOST_NAME_MAX"
     | LOGIN_NAME_MAX -> Sexplib0.Sexp.Atom "LOGIN_NAME_MAX"
     | OPEN_MAX -> Sexplib0.Sexp.Atom "OPEN_MAX"
     | PAGESIZE -> Sexplib0.Sexp.Atom "PAGESIZE"
     | RE_DUP_MAX -> Sexplib0.Sexp.Atom "RE_DUP_MAX"
     | STREAM_MAX -> Sexplib0.Sexp.Atom "STREAM_MAX"
     | SYMLOOP_MAX -> Sexplib0.Sexp.Atom "SYMLOOP_MAX"
     | TTY_NAME_MAX -> Sexplib0.Sexp.Atom "TTY_NAME_MAX"
     | TZNAME_MAX -> Sexplib0.Sexp.Atom "TZNAME_MAX"
     | POSIX_VERSION -> Sexplib0.Sexp.Atom "POSIX_VERSION"
     | PHYS_PAGES -> Sexplib0.Sexp.Atom "PHYS_PAGES"
     | AVPHYS_PAGES -> Sexplib0.Sexp.Atom "AVPHYS_PAGES"
     | IOV_MAX -> Sexplib0.Sexp.Atom "IOV_MAX"
     | CLK_TCK -> Sexplib0.Sexp.Atom "CLK_TCK"
     | NPROCESSORS_CONF -> Sexplib0.Sexp.Atom "NPROCESSORS_CONF"
     | NPROCESSORS_ONLN -> Sexplib0.Sexp.Atom "NPROCESSORS_ONLN"
     : sysconf -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_sysconf
end [@@ocaml.doc "@inline"] [@@merlin.hide]

external sysconf : sysconf -> int64 option = "core_unix_sysconf"

let sysconf_exn conf =
  match sysconf conf with
  | None ->
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "[sysconf_exn]: value not available or limit is unspecified"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "conf"
               ; (sexp_of_sysconf [@merlin.hide]) conf
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  | Some x -> x
;;

module IOVec = struct
  open Bigarray

  type 'buf t =
    { buf : 'buf
    ; pos : int
    ; len : int
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : 'buf t) -> ()

    let t_of_sexp : 'buf. (Sexplib0.Sexp.t -> 'buf) -> Sexplib0.Sexp.t -> 'buf t =
      let error_source__077_ = "core_unix.ml.before-ppx.IOVec.t" in
      fun _of_buf__075_ x__078_ ->
        Sexplib0.Sexp_conv_record.record_of_sexp
          ~caller:error_source__077_
          ~fields:
            (Field
               { name = "buf"
               ; kind = Required
               ; conv = _of_buf__075_
               ; rest =
                   Field
                     { name = "pos"
                     ; kind = Required
                     ; conv = int_of_sexp
                     ; rest =
                         Field
                           { name = "len"
                           ; kind = Required
                           ; conv = int_of_sexp
                           ; rest = Empty
                           }
                     }
               })
          ~index_of_field:(function
            | "buf" -> 0
            | "pos" -> 1
            | "len" -> 2
            | _ -> -1)
          ~allow_extra_fields:false
          ~create:(fun (buf, (pos, (len, ()))) -> ({ buf; pos; len } : _ t))
          x__078_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'buf. ('buf -> Sexplib0.Sexp.t) -> 'buf t -> Sexplib0.Sexp.t =
      fun _of_buf__079_ { buf = buf__081_; pos = pos__083_; len = len__085_ } ->
      let bnds__080_ = ([] : _ Stdlib.List.t) in
      let bnds__080_ =
        let arg__086_ = sexp_of_int len__085_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "len"; arg__086_ ] :: bnds__080_
         : _ Stdlib.List.t)
      in
      let bnds__080_ =
        let arg__084_ = sexp_of_int pos__083_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos"; arg__084_ ] :: bnds__080_
         : _ Stdlib.List.t)
      in
      let bnds__080_ =
        let arg__082_ = _of_buf__079_ buf__081_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buf"; arg__082_ ] :: bnds__080_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__080_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'buf kind = 'buf
  type bigstring = (char, int8_unsigned_elt, c_layout) Array1.t

  let string_kind = ""
  let bigstring_kind = Array1.create Bigarray.char c_layout 0
  let empty kind = { buf = kind; pos = 0; len = 0 }

  let get_iovec loc ?pos ?len true_len buf =
    let pos =
      match pos with
      | None -> 0
      | Some pos ->
        if pos < 0 then invalid_arg (loc ^ ": pos < 0");
        if pos > true_len then invalid_arg (loc ^ ": pos > length buf");
        pos
    in
    let len =
      match len with
      | None -> true_len - pos
      | Some len ->
        if len < 0 then invalid_arg (loc ^ ": len < 0");
        len
    in
    if pos + len > true_len then invalid_arg (loc ^ ": pos + len > length buf");
    { buf; pos; len }
  ;;

  let of_string ?pos ?len str =
    let str_len = String.length str in
    get_iovec "IOVec.of_string" ?pos ?len str_len str
  ;;

  let of_bigstring ?pos ?len bstr =
    let bstr_len = Array1.dim bstr in
    get_iovec "IOVec.of_bigstring" ?pos ?len bstr_len bstr
  ;;

  let drop iovec n =
    if n > iovec.len
    then failwith "IOVec.drop: n > length iovec"
    else { buf = iovec.buf; pos = iovec.pos + n; len = iovec.len - n }
  ;;

  let default_max_iovecs = 1024

  let max_iovecs =
    lazy
      (match sysconf IOV_MAX with
       | None -> default_max_iovecs
       | Some n64 ->
         if
           let open Int64 in
           n64 > of_int Array.max_length
         then Array.max_length
         else Int64.to_int_exn n64)
  ;;
end

let get_iovec_count loc iovecs = function
  | None -> Array.length iovecs
  | Some count ->
    if count < 0 then invalid_arg (loc ^ ": count < 0");
    let n_iovecs = Array.length iovecs in
    if count > n_iovecs then invalid_arg (loc ^ ": count > n_iovecs");
    count
;;

external unsafe_writev_assume_fd_is_nonblocking
  :  File_descr.t
  -> string IOVec.t array
  -> int
  -> int
  = "core_unix_writev_assume_fd_is_nonblocking_stub"

let writev_assume_fd_is_nonblocking fd ?count iovecs =
  let count = get_iovec_count "writev_assume_fd_is_nonblocking" iovecs count in
  unsafe_writev_assume_fd_is_nonblocking fd iovecs count
;;

external unsafe_writev
  :  File_descr.t
  -> string IOVec.t array
  -> int
  -> int
  = "core_unix_writev_stub"

let writev fd ?count iovecs =
  let count = get_iovec_count "writev" iovecs count in
  unsafe_writev fd iovecs count
;;

external pselect
  :  File_descr.t list
  -> File_descr.t list
  -> File_descr.t list
  -> float
  -> int list
  -> File_descr.t list * File_descr.t list * File_descr.t list
  = "core_unix_pselect_stub"

external mkstemp : string -> string * File_descr.t = "core_unix_mkstemp"
external mkdtemp : string -> string = "core_unix_mkdtemp"
external abort : unit -> 'a = "core_unix_abort" [@@noalloc]
external initgroups : string -> int -> unit = "core_unix_initgroups"
external getgrouplist : string -> int -> int array = "core_unix_getgrouplist"

[@@@ocaml.text " Globbing and shell word expansion "]

module Fnmatch_flags = struct
  type _flag =
    [ `No_escape
    | `Pathname
    | `Period
    | `File_name
    | `Leading_dir
    | `Casefold
    ]
  [@@deriving sexp]

  include struct
    let _ = fun (_ : _flag) -> ()

    let ___flag_of_sexp__ =
      (let error_source__092_ = "core_unix.ml.before-ppx.Fnmatch_flags._flag" in
       function
       | Sexplib0.Sexp.Atom atom__088_ as _sexp__090_ ->
         (match atom__088_ with
          | "No_escape" -> `No_escape
          | "Pathname" -> `Pathname
          | "Period" -> `Period
          | "File_name" -> `File_name
          | "Leading_dir" -> `Leading_dir
          | "Casefold" -> `Casefold
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__088_ :: _) as _sexp__090_ ->
         (match atom__088_ with
          | "No_escape" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | "Pathname" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | "Period" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | "File_name" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | "Leading_dir" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | "Casefold" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__092_ _sexp__090_
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__089_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
           error_source__092_
           sexp__089_
       | Sexplib0.Sexp.List [] as sexp__089_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
           error_source__092_
           sexp__089_
       : Sexplib0.Sexp.t -> _flag)
    ;;

    let _ = ___flag_of_sexp__

    let _flag_of_sexp =
      (let error_source__094_ = "core_unix.ml.before-ppx.Fnmatch_flags._flag" in
       fun sexp__093_ ->
         try ___flag_of_sexp__ sexp__093_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__094_
             sexp__093_
       : Sexplib0.Sexp.t -> _flag)
    ;;

    let _ = _flag_of_sexp

    let sexp_of__flag =
      (function
       | `No_escape -> Sexplib0.Sexp.Atom "No_escape"
       | `Pathname -> Sexplib0.Sexp.Atom "Pathname"
       | `Period -> Sexplib0.Sexp.Atom "Period"
       | `File_name -> Sexplib0.Sexp.Atom "File_name"
       | `Leading_dir -> Sexplib0.Sexp.Atom "Leading_dir"
       | `Casefold -> Sexplib0.Sexp.Atom "Casefold"
       : _flag -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of__flag
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let flag_to_internal = function
    | `No_escape -> 0
    | `Pathname -> 1
    | `Period -> 2
    | `File_name -> 3
    | `Leading_dir -> 4
    | `Casefold -> 5
  ;;

  type t = int32 [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (int32_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_int32 : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  external internal_make : int array -> t = "core_unix_fnmatch_make_flags"

  let make = function
    | None | Some [] -> Int32.zero
    | Some flags -> internal_make (Array.map ~f:flag_to_internal (Array.of_list flags))
  ;;
end

external fnmatch : Fnmatch_flags.t -> pat:string -> string -> bool = "core_unix_fnmatch"

let fnmatch ?flags ~pat fname = fnmatch (Fnmatch_flags.make flags) ~pat fname

[%%ifdef JSC_WORDEXP]

module Wordexp_flags = struct
  type _flag =
    [ `No_cmd
    | `Show_err
    | `Undef
    ]
  [@@deriving sexp]

  include struct
    let _ = fun (_ : _flag) -> ()

    let ___flag_of_sexp__ =
      (let error_source__101_ = "core_unix.ml.before-ppx.Wordexp_flags._flag" in
       function
       | Sexplib0.Sexp.Atom atom__097_ as _sexp__099_ ->
         (match atom__097_ with
          | "No_cmd" -> `No_cmd
          | "Show_err" -> `Show_err
          | "Undef" -> `Undef
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__097_ :: _) as _sexp__099_ ->
         (match atom__097_ with
          | "No_cmd" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__101_ _sexp__099_
          | "Show_err" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__101_ _sexp__099_
          | "Undef" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__101_ _sexp__099_
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__098_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
           error_source__101_
           sexp__098_
       | Sexplib0.Sexp.List [] as sexp__098_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
           error_source__101_
           sexp__098_
       : Sexplib0.Sexp.t -> _flag)
    ;;

    let _ = ___flag_of_sexp__

    let _flag_of_sexp =
      (let error_source__103_ = "core_unix.ml.before-ppx.Wordexp_flags._flag" in
       fun sexp__102_ ->
         try ___flag_of_sexp__ sexp__102_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__103_
             sexp__102_
       : Sexplib0.Sexp.t -> _flag)
    ;;

    let _ = _flag_of_sexp

    let sexp_of__flag =
      (function
       | `No_cmd -> Sexplib0.Sexp.Atom "No_cmd"
       | `Show_err -> Sexplib0.Sexp.Atom "Show_err"
       | `Undef -> Sexplib0.Sexp.Atom "Undef"
       : _flag -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of__flag
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let flag_to_internal = function
    | `No_cmd -> 0
    | `Show_err -> 1
    | `Undef -> 2
  ;;

  type t = int32 [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (int32_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_int32 : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  external internal_make : int array -> t = "core_unix_wordexp_make_flags"

  let make = function
    | None | Some [] -> Int32.zero
    | Some flags -> internal_make (Array.map ~f:flag_to_internal (Array.of_list flags))
  ;;
end

external wordexp : Wordexp_flags.t -> string -> string array = "core_unix_wordexp"

let wordexp = Ok (fun ?flags str -> wordexp (Wordexp_flags.make flags) str)

[%%else]

let wordexp = Or_error.unimplemented "Unix.wordexp"

[%%endif]

module Utsname = struct
  module Stable = struct
    module V1 = struct
      type t =
        { sysname : string
        ; nodename : string
        ; release : string
        ; version : string
        ; machine : string
        }
      [@@deriving fields ~getters, bin_io, sexp, compare, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()
        let machine _r__ = _r__.machine
        let _ = machine
        let version _r__ = _r__.version
        let _ = version
        let release _r__ = _r__.release
        let _ = release
        let nodename _r__ = _r__.nodename
        let _ = nodename
        let sysname _r__ = _r__.sysname
        let _ = sysname

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:518:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "sysname", bin_shape_string
                    ; "nodename", bin_shape_string
                    ; "release", bin_shape_string
                    ; "version", bin_shape_string
                    ; "machine", bin_shape_string
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { sysname = v1; nodename = v2; release = v3; version = v4; machine = v5 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v2) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v3) in
            let size = Bin_prot.Common.( + ) size (bin_size_string v4) in
            Bin_prot.Common.( + ) size (bin_size_string v5)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { sysname = v1; nodename = v2; release = v3; version = v4; machine = v5 } ->
            let pos = bin_write_string buf ~pos v1 in
            let pos = bin_write_string buf ~pos v2 in
            let pos = bin_write_string buf ~pos v3 in
            let pos = bin_write_string buf ~pos v4 in
            bin_write_string buf ~pos v5
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "core_unix.ml.before-ppx.Utsname.Stable.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_sysname = bin_read_string buf ~pos_ref in
          let v_nodename = bin_read_string buf ~pos_ref in
          let v_release = bin_read_string buf ~pos_ref in
          let v_version = bin_read_string buf ~pos_ref in
          let v_machine = bin_read_string buf ~pos_ref in
          { sysname = v_sysname
          ; nodename = v_nodename
          ; release = v_release
          ; version = v_version
          ; machine = v_machine
          }
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let t_of_sexp =
          (let error_source__106_ = "core_unix.ml.before-ppx.Utsname.Stable.V1.t" in
           fun x__107_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__106_
               ~fields:
                 (Field
                    { name = "sysname"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "nodename"
                          ; kind = Required
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "release"
                                ; kind = Required
                                ; conv = string_of_sexp
                                ; rest =
                                    Field
                                      { name = "version"
                                      ; kind = Required
                                      ; conv = string_of_sexp
                                      ; rest =
                                          Field
                                            { name = "machine"
                                            ; kind = Required
                                            ; conv = string_of_sexp
                                            ; rest = Empty
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "sysname" -> 0
                 | "nodename" -> 1
                 | "release" -> 2
                 | "version" -> 3
                 | "machine" -> 4
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (sysname, (nodename, (release, (version, (machine, ()))))) ->
                 ({ sysname; nodename; release; version; machine } : t))
               x__107_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { sysname = sysname__109_
               ; nodename = nodename__111_
               ; release = release__113_
               ; version = version__115_
               ; machine = machine__117_
               } ->
             let bnds__108_ = ([] : _ Stdlib.List.t) in
             let bnds__108_ =
               let arg__118_ = sexp_of_string machine__117_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "machine"; arg__118_ ]
                :: bnds__108_
                : _ Stdlib.List.t)
             in
             let bnds__108_ =
               let arg__116_ = sexp_of_string version__115_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "version"; arg__116_ ]
                :: bnds__108_
                : _ Stdlib.List.t)
             in
             let bnds__108_ =
               let arg__114_ = sexp_of_string release__113_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "release"; arg__114_ ]
                :: bnds__108_
                : _ Stdlib.List.t)
             in
             let bnds__108_ =
               let arg__112_ = sexp_of_string nodename__111_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "nodename"; arg__112_ ]
                :: bnds__108_
                : _ Stdlib.List.t)
             in
             let bnds__108_ =
               let arg__110_ = sexp_of_string sysname__109_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sysname"; arg__110_ ]
                :: bnds__108_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__108_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__119_ b__120_ ->
             if Stdlib.( == ) a__119_ b__120_
             then 0
             else (
               match compare_string a__119_.sysname b__120_.sysname with
               | 0 ->
                 (match compare_string a__119_.nodename b__120_.nodename with
                  | 0 ->
                    (match compare_string a__119_.release b__120_.release with
                     | 0 ->
                       (match compare_string a__119_.version b__120_.version with
                        | 0 -> compare_string a__119_.machine b__120_.machine
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  include Stable.V1
end

external uname : unit -> Utsname.t = "core_unix_uname"

module Scheduler = struct
  module Policy = struct
    type t =
      [ `Fifo
      | `Round_robin
      | `Other
      ]
    [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let __t_of_sexp__ =
        (let error_source__126_ = "core_unix.ml.before-ppx.Scheduler.Policy.t" in
         function
         | Sexplib0.Sexp.Atom atom__122_ as _sexp__124_ ->
           (match atom__122_ with
            | "Fifo" -> `Fifo
            | "Round_robin" -> `Round_robin
            | "Other" -> `Other
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__122_ :: _) as _sexp__124_ ->
           (match atom__122_ with
            | "Fifo" ->
              Sexplib0.Sexp_conv_error.ptag_no_args error_source__126_ _sexp__124_
            | "Round_robin" ->
              Sexplib0.Sexp_conv_error.ptag_no_args error_source__126_ _sexp__124_
            | "Other" ->
              Sexplib0.Sexp_conv_error.ptag_no_args error_source__126_ _sexp__124_
            | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__123_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
             error_source__126_
             sexp__123_
         | Sexplib0.Sexp.List [] as sexp__123_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
             error_source__126_
             sexp__123_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = __t_of_sexp__

      let t_of_sexp =
        (let error_source__128_ = "core_unix.ml.before-ppx.Scheduler.Policy.t" in
         fun sexp__127_ ->
           try __t_of_sexp__ sexp__127_ with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__128_
               sexp__127_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | `Fifo -> Sexplib0.Sexp.Atom "Fifo"
         | `Round_robin -> Sexplib0.Sexp.Atom "Round_robin"
         | `Other -> Sexplib0.Sexp.Atom "Other"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Ordered = struct
      type t =
        | Fifo
        | Round_robin
        | Other
      [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__131_ =
             "core_unix.ml.before-ppx.Scheduler.Policy.Ordered.t"
           in
           function
           | Sexplib0.Sexp.Atom ("fifo" | "Fifo") -> Fifo
           | Sexplib0.Sexp.Atom ("round_robin" | "Round_robin") -> Round_robin
           | Sexplib0.Sexp.Atom ("other" | "Other") -> Other
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("fifo" | "Fifo") :: _) as sexp__132_
             -> Sexplib0.Sexp_conv_error.stag_no_args error_source__131_ sexp__132_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("round_robin" | "Round_robin") :: _)
             as sexp__132_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__131_ sexp__132_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("other" | "Other") :: _) as
             sexp__132_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__131_ sexp__132_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__130_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__131_
               sexp__130_
           | Sexplib0.Sexp.List [] as sexp__130_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__131_ sexp__130_
           | sexp__130_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__131_ sexp__130_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | Fifo -> Sexplib0.Sexp.Atom "Fifo"
           | Round_robin -> Sexplib0.Sexp.Atom "Round_robin"
           | Other -> Sexplib0.Sexp.Atom "Other"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let create = function
        | `Fifo -> Fifo
        | `Round_robin -> Round_robin
        | `Other -> Other
      ;;
    end
  end

  external set
    :  pid:int
    -> policy:Policy.Ordered.t
    -> priority:int
    -> unit
    = "core_unix_sched_setscheduler"

  let set ~pid ~policy ~priority =
    let pid =
      match pid with
      | None -> 0
      | Some pid -> Pid.to_int pid
    in
    set ~pid ~policy:(Policy.Ordered.create policy) ~priority
  ;;
end

module Priority = struct
  external nice : int -> int = "core_unix_nice"
end

module Mman = struct
  module Mcl_flags = struct
    type t =
      | Current
      | Future
    [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__135_ = "core_unix.ml.before-ppx.Mman.Mcl_flags.t" in
         function
         | Sexplib0.Sexp.Atom ("current" | "Current") -> Current
         | Sexplib0.Sexp.Atom ("future" | "Future") -> Future
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("current" | "Current") :: _) as
           sexp__136_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__135_ sexp__136_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("future" | "Future") :: _) as
           sexp__136_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__135_ sexp__136_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__134_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__135_ sexp__134_
         | Sexplib0.Sexp.List [] as sexp__134_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__135_ sexp__134_
         | sexp__134_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__135_ sexp__134_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Current -> Sexplib0.Sexp.Atom "Current"
         | Future -> Sexplib0.Sexp.Atom "Future"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  external unix_mlockall : Mcl_flags.t array -> unit = "core_unix_mlockall"
  external unix_munlockall : unit -> unit = "core_unix_munlockall"

  let mlockall flags = unix_mlockall (List.to_array flags)
  let munlockall = unix_munlockall
end

let dirname_r filename = "dirname", atom filename
let filename_r filename = "filename", atom filename
let file_perm_r perm = "perm", atom (Printf.sprintf "0o%o" perm)
let len_r len = "len", Int.sexp_of_t len
let uid_r uid = "uid", Int.sexp_of_t uid
let gid_r gid = "gid", Int.sexp_of_t gid
let fd_r fd = "fd", File_descr.sexp_of_t fd

let close_on_exec_r boolopt =
  ( "close_on_exec"
  , ((fun x__137_ -> sexp_of_option sexp_of_bool x__137_) [@merlin.hide]) boolopt )
;;

let dir_handle_r handle =
  let fd =
    try File_descr.sexp_of_t (dirfd handle) with
    | _ -> Int.sexp_of_t (-1)
  in
  "dir_handle", fd
;;

let unary ?restart make_r f =
  ();
  fun x -> improve ?restart (fun () -> f x) (fun () -> [ make_r x ])
;;

let unary_fd ?restart f = unary ?restart fd_r f
let unary_filename ?restart f = unary ?restart filename_r f
let unary_dirname ?restart f = unary ?restart dirname_r f
let unary_dir_handle ?restart f = unary ?restart dir_handle_r f

include Unix_error
module Syscall_result = Syscall_result

exception Unix_error = Unix.Unix_error

external unix_error : int -> string -> string -> _ = "core_unix_error_stub"

let error_message = Unix.error_message
let handle_unix_error f = Unix.handle_unix_error f ()
let environment = Unix.environment

module Error = struct
  type t = Unix.error =
    | E2BIG [@ocaml.doc " Argument list too long "]
    | EACCES [@ocaml.doc " Permission denied "]
    | EAGAIN [@ocaml.doc " Resource temporarily unavailable; try again "]
    | EBADF [@ocaml.doc " Bad file descriptor "]
    | EBUSY [@ocaml.doc " Resource unavailable "]
    | ECHILD [@ocaml.doc " No child process "]
    | EDEADLK [@ocaml.doc " Resource deadlock would occur "]
    | EDOM [@ocaml.doc " Domain error for math functions, etc. "]
    | EEXIST [@ocaml.doc " File exists "]
    | EFAULT [@ocaml.doc " Bad address "]
    | EFBIG [@ocaml.doc " File too large "]
    | EINTR [@ocaml.doc " Function interrupted by signal "]
    | EINVAL [@ocaml.doc " Invalid argument "]
    | EIO [@ocaml.doc " Hardware I/O error "]
    | EISDIR [@ocaml.doc " Is a directory "]
    | EMFILE [@ocaml.doc " Too many open files by the process "]
    | EMLINK [@ocaml.doc " Too many links "]
    | ENAMETOOLONG [@ocaml.doc " Filename too long "]
    | ENFILE [@ocaml.doc " Too many open files in the system "]
    | ENODEV [@ocaml.doc " No such device "]
    | ENOENT [@ocaml.doc " No such file or directory "]
    | ENOEXEC [@ocaml.doc " Not an executable file "]
    | ENOLCK [@ocaml.doc " No locks available "]
    | ENOMEM [@ocaml.doc " Not enough memory "]
    | ENOSPC [@ocaml.doc " No space left on device "]
    | ENOSYS [@ocaml.doc " Function not supported "]
    | ENOTDIR [@ocaml.doc " Not a directory "]
    | ENOTEMPTY [@ocaml.doc " Directory not empty "]
    | ENOTTY [@ocaml.doc " Inappropriate I/O control operation "]
    | ENXIO [@ocaml.doc " No such device or address "]
    | EPERM [@ocaml.doc " Operation not permitted "]
    | EPIPE [@ocaml.doc " Broken pipe "]
    | ERANGE [@ocaml.doc " Result too large "]
    | EROFS [@ocaml.doc " Read-only file system "]
    | ESPIPE [@ocaml.doc " Invalid seek e.g. on a pipe "]
    | ESRCH [@ocaml.doc " No such process "]
    | EXDEV [@ocaml.doc " Invalid link "]
    | EWOULDBLOCK [@ocaml.doc " Operation would block "]
    | EINPROGRESS [@ocaml.doc " Operation now in progress "]
    | EALREADY [@ocaml.doc " Operation already in progress "]
    | ENOTSOCK [@ocaml.doc " Socket operation on non-socket "]
    | EDESTADDRREQ [@ocaml.doc " Destination address required "]
    | EMSGSIZE [@ocaml.doc " Message too long "]
    | EPROTOTYPE [@ocaml.doc " Protocol wrong type for socket "]
    | ENOPROTOOPT [@ocaml.doc " Protocol not available "]
    | EPROTONOSUPPORT [@ocaml.doc " Protocol not supported "]
    | ESOCKTNOSUPPORT [@ocaml.doc " Socket type not supported "]
    | EOPNOTSUPP [@ocaml.doc " Operation not supported on socket "]
    | EPFNOSUPPORT [@ocaml.doc " Protocol family not supported "]
    | EAFNOSUPPORT [@ocaml.doc " Address family not supported by protocol family "]
    | EADDRINUSE [@ocaml.doc " Address already in use "]
    | EADDRNOTAVAIL [@ocaml.doc " Can't assign requested address "]
    | ENETDOWN [@ocaml.doc " Network is down "]
    | ENETUNREACH [@ocaml.doc " Network is unreachable "]
    | ENETRESET [@ocaml.doc " Network dropped connection on reset "]
    | ECONNABORTED [@ocaml.doc " Software caused connection abort "]
    | ECONNRESET [@ocaml.doc " Connection reset by peer "]
    | ENOBUFS [@ocaml.doc " No buffer space available "]
    | EISCONN [@ocaml.doc " Socket is already connected "]
    | ENOTCONN [@ocaml.doc " Socket is not connected "]
    | ESHUTDOWN [@ocaml.doc " Can't send after socket shutdown "]
    | ETOOMANYREFS [@ocaml.doc " Too many references: can't splice "]
    | ETIMEDOUT [@ocaml.doc " Connection timed out "]
    | ECONNREFUSED [@ocaml.doc " Connection refused "]
    | EHOSTDOWN [@ocaml.doc " Host is down "]
    | EHOSTUNREACH [@ocaml.doc " No route to host "]
    | ELOOP [@ocaml.doc " Too many levels of symbolic links "]
    | EOVERFLOW [@ocaml.doc " File size or position not representable "]
    | EUNKNOWNERR of int [@ocaml.doc " Unknown error "]
  [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__138_ b__139_ ->
         if Stdlib.( == ) a__138_ b__139_
         then 0
         else (
           match a__138_, b__139_ with
           | E2BIG, E2BIG -> 0
           | E2BIG, _ -> -1
           | _, E2BIG -> 1
           | EACCES, EACCES -> 0
           | EACCES, _ -> -1
           | _, EACCES -> 1
           | EAGAIN, EAGAIN -> 0
           | EAGAIN, _ -> -1
           | _, EAGAIN -> 1
           | EBADF, EBADF -> 0
           | EBADF, _ -> -1
           | _, EBADF -> 1
           | EBUSY, EBUSY -> 0
           | EBUSY, _ -> -1
           | _, EBUSY -> 1
           | ECHILD, ECHILD -> 0
           | ECHILD, _ -> -1
           | _, ECHILD -> 1
           | EDEADLK, EDEADLK -> 0
           | EDEADLK, _ -> -1
           | _, EDEADLK -> 1
           | EDOM, EDOM -> 0
           | EDOM, _ -> -1
           | _, EDOM -> 1
           | EEXIST, EEXIST -> 0
           | EEXIST, _ -> -1
           | _, EEXIST -> 1
           | EFAULT, EFAULT -> 0
           | EFAULT, _ -> -1
           | _, EFAULT -> 1
           | EFBIG, EFBIG -> 0
           | EFBIG, _ -> -1
           | _, EFBIG -> 1
           | EINTR, EINTR -> 0
           | EINTR, _ -> -1
           | _, EINTR -> 1
           | EINVAL, EINVAL -> 0
           | EINVAL, _ -> -1
           | _, EINVAL -> 1
           | EIO, EIO -> 0
           | EIO, _ -> -1
           | _, EIO -> 1
           | EISDIR, EISDIR -> 0
           | EISDIR, _ -> -1
           | _, EISDIR -> 1
           | EMFILE, EMFILE -> 0
           | EMFILE, _ -> -1
           | _, EMFILE -> 1
           | EMLINK, EMLINK -> 0
           | EMLINK, _ -> -1
           | _, EMLINK -> 1
           | ENAMETOOLONG, ENAMETOOLONG -> 0
           | ENAMETOOLONG, _ -> -1
           | _, ENAMETOOLONG -> 1
           | ENFILE, ENFILE -> 0
           | ENFILE, _ -> -1
           | _, ENFILE -> 1
           | ENODEV, ENODEV -> 0
           | ENODEV, _ -> -1
           | _, ENODEV -> 1
           | ENOENT, ENOENT -> 0
           | ENOENT, _ -> -1
           | _, ENOENT -> 1
           | ENOEXEC, ENOEXEC -> 0
           | ENOEXEC, _ -> -1
           | _, ENOEXEC -> 1
           | ENOLCK, ENOLCK -> 0
           | ENOLCK, _ -> -1
           | _, ENOLCK -> 1
           | ENOMEM, ENOMEM -> 0
           | ENOMEM, _ -> -1
           | _, ENOMEM -> 1
           | ENOSPC, ENOSPC -> 0
           | ENOSPC, _ -> -1
           | _, ENOSPC -> 1
           | ENOSYS, ENOSYS -> 0
           | ENOSYS, _ -> -1
           | _, ENOSYS -> 1
           | ENOTDIR, ENOTDIR -> 0
           | ENOTDIR, _ -> -1
           | _, ENOTDIR -> 1
           | ENOTEMPTY, ENOTEMPTY -> 0
           | ENOTEMPTY, _ -> -1
           | _, ENOTEMPTY -> 1
           | ENOTTY, ENOTTY -> 0
           | ENOTTY, _ -> -1
           | _, ENOTTY -> 1
           | ENXIO, ENXIO -> 0
           | ENXIO, _ -> -1
           | _, ENXIO -> 1
           | EPERM, EPERM -> 0
           | EPERM, _ -> -1
           | _, EPERM -> 1
           | EPIPE, EPIPE -> 0
           | EPIPE, _ -> -1
           | _, EPIPE -> 1
           | ERANGE, ERANGE -> 0
           | ERANGE, _ -> -1
           | _, ERANGE -> 1
           | EROFS, EROFS -> 0
           | EROFS, _ -> -1
           | _, EROFS -> 1
           | ESPIPE, ESPIPE -> 0
           | ESPIPE, _ -> -1
           | _, ESPIPE -> 1
           | ESRCH, ESRCH -> 0
           | ESRCH, _ -> -1
           | _, ESRCH -> 1
           | EXDEV, EXDEV -> 0
           | EXDEV, _ -> -1
           | _, EXDEV -> 1
           | EWOULDBLOCK, EWOULDBLOCK -> 0
           | EWOULDBLOCK, _ -> -1
           | _, EWOULDBLOCK -> 1
           | EINPROGRESS, EINPROGRESS -> 0
           | EINPROGRESS, _ -> -1
           | _, EINPROGRESS -> 1
           | EALREADY, EALREADY -> 0
           | EALREADY, _ -> -1
           | _, EALREADY -> 1
           | ENOTSOCK, ENOTSOCK -> 0
           | ENOTSOCK, _ -> -1
           | _, ENOTSOCK -> 1
           | EDESTADDRREQ, EDESTADDRREQ -> 0
           | EDESTADDRREQ, _ -> -1
           | _, EDESTADDRREQ -> 1
           | EMSGSIZE, EMSGSIZE -> 0
           | EMSGSIZE, _ -> -1
           | _, EMSGSIZE -> 1
           | EPROTOTYPE, EPROTOTYPE -> 0
           | EPROTOTYPE, _ -> -1
           | _, EPROTOTYPE -> 1
           | ENOPROTOOPT, ENOPROTOOPT -> 0
           | ENOPROTOOPT, _ -> -1
           | _, ENOPROTOOPT -> 1
           | EPROTONOSUPPORT, EPROTONOSUPPORT -> 0
           | EPROTONOSUPPORT, _ -> -1
           | _, EPROTONOSUPPORT -> 1
           | ESOCKTNOSUPPORT, ESOCKTNOSUPPORT -> 0
           | ESOCKTNOSUPPORT, _ -> -1
           | _, ESOCKTNOSUPPORT -> 1
           | EOPNOTSUPP, EOPNOTSUPP -> 0
           | EOPNOTSUPP, _ -> -1
           | _, EOPNOTSUPP -> 1
           | EPFNOSUPPORT, EPFNOSUPPORT -> 0
           | EPFNOSUPPORT, _ -> -1
           | _, EPFNOSUPPORT -> 1
           | EAFNOSUPPORT, EAFNOSUPPORT -> 0
           | EAFNOSUPPORT, _ -> -1
           | _, EAFNOSUPPORT -> 1
           | EADDRINUSE, EADDRINUSE -> 0
           | EADDRINUSE, _ -> -1
           | _, EADDRINUSE -> 1
           | EADDRNOTAVAIL, EADDRNOTAVAIL -> 0
           | EADDRNOTAVAIL, _ -> -1
           | _, EADDRNOTAVAIL -> 1
           | ENETDOWN, ENETDOWN -> 0
           | ENETDOWN, _ -> -1
           | _, ENETDOWN -> 1
           | ENETUNREACH, ENETUNREACH -> 0
           | ENETUNREACH, _ -> -1
           | _, ENETUNREACH -> 1
           | ENETRESET, ENETRESET -> 0
           | ENETRESET, _ -> -1
           | _, ENETRESET -> 1
           | ECONNABORTED, ECONNABORTED -> 0
           | ECONNABORTED, _ -> -1
           | _, ECONNABORTED -> 1
           | ECONNRESET, ECONNRESET -> 0
           | ECONNRESET, _ -> -1
           | _, ECONNRESET -> 1
           | ENOBUFS, ENOBUFS -> 0
           | ENOBUFS, _ -> -1
           | _, ENOBUFS -> 1
           | EISCONN, EISCONN -> 0
           | EISCONN, _ -> -1
           | _, EISCONN -> 1
           | ENOTCONN, ENOTCONN -> 0
           | ENOTCONN, _ -> -1
           | _, ENOTCONN -> 1
           | ESHUTDOWN, ESHUTDOWN -> 0
           | ESHUTDOWN, _ -> -1
           | _, ESHUTDOWN -> 1
           | ETOOMANYREFS, ETOOMANYREFS -> 0
           | ETOOMANYREFS, _ -> -1
           | _, ETOOMANYREFS -> 1
           | ETIMEDOUT, ETIMEDOUT -> 0
           | ETIMEDOUT, _ -> -1
           | _, ETIMEDOUT -> 1
           | ECONNREFUSED, ECONNREFUSED -> 0
           | ECONNREFUSED, _ -> -1
           | _, ECONNREFUSED -> 1
           | EHOSTDOWN, EHOSTDOWN -> 0
           | EHOSTDOWN, _ -> -1
           | _, EHOSTDOWN -> 1
           | EHOSTUNREACH, EHOSTUNREACH -> 0
           | EHOSTUNREACH, _ -> -1
           | _, EHOSTUNREACH -> 1
           | ELOOP, ELOOP -> 0
           | ELOOP, _ -> -1
           | _, ELOOP -> 1
           | EOVERFLOW, EOVERFLOW -> 0
           | EOVERFLOW, _ -> -1
           | _, EOVERFLOW -> 1
           | EUNKNOWNERR _a__140_, EUNKNOWNERR _b__141_ -> compare_int _a__140_ _b__141_)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (let error_source__144_ = "core_unix.ml.before-ppx.Error.t" in
       function
       | Sexplib0.Sexp.Atom ("e2BIG" | "E2BIG") -> E2BIG
       | Sexplib0.Sexp.Atom ("eACCES" | "EACCES") -> EACCES
       | Sexplib0.Sexp.Atom ("eAGAIN" | "EAGAIN") -> EAGAIN
       | Sexplib0.Sexp.Atom ("eBADF" | "EBADF") -> EBADF
       | Sexplib0.Sexp.Atom ("eBUSY" | "EBUSY") -> EBUSY
       | Sexplib0.Sexp.Atom ("eCHILD" | "ECHILD") -> ECHILD
       | Sexplib0.Sexp.Atom ("eDEADLK" | "EDEADLK") -> EDEADLK
       | Sexplib0.Sexp.Atom ("eDOM" | "EDOM") -> EDOM
       | Sexplib0.Sexp.Atom ("eEXIST" | "EEXIST") -> EEXIST
       | Sexplib0.Sexp.Atom ("eFAULT" | "EFAULT") -> EFAULT
       | Sexplib0.Sexp.Atom ("eFBIG" | "EFBIG") -> EFBIG
       | Sexplib0.Sexp.Atom ("eINTR" | "EINTR") -> EINTR
       | Sexplib0.Sexp.Atom ("eINVAL" | "EINVAL") -> EINVAL
       | Sexplib0.Sexp.Atom ("eIO" | "EIO") -> EIO
       | Sexplib0.Sexp.Atom ("eISDIR" | "EISDIR") -> EISDIR
       | Sexplib0.Sexp.Atom ("eMFILE" | "EMFILE") -> EMFILE
       | Sexplib0.Sexp.Atom ("eMLINK" | "EMLINK") -> EMLINK
       | Sexplib0.Sexp.Atom ("eNAMETOOLONG" | "ENAMETOOLONG") -> ENAMETOOLONG
       | Sexplib0.Sexp.Atom ("eNFILE" | "ENFILE") -> ENFILE
       | Sexplib0.Sexp.Atom ("eNODEV" | "ENODEV") -> ENODEV
       | Sexplib0.Sexp.Atom ("eNOENT" | "ENOENT") -> ENOENT
       | Sexplib0.Sexp.Atom ("eNOEXEC" | "ENOEXEC") -> ENOEXEC
       | Sexplib0.Sexp.Atom ("eNOLCK" | "ENOLCK") -> ENOLCK
       | Sexplib0.Sexp.Atom ("eNOMEM" | "ENOMEM") -> ENOMEM
       | Sexplib0.Sexp.Atom ("eNOSPC" | "ENOSPC") -> ENOSPC
       | Sexplib0.Sexp.Atom ("eNOSYS" | "ENOSYS") -> ENOSYS
       | Sexplib0.Sexp.Atom ("eNOTDIR" | "ENOTDIR") -> ENOTDIR
       | Sexplib0.Sexp.Atom ("eNOTEMPTY" | "ENOTEMPTY") -> ENOTEMPTY
       | Sexplib0.Sexp.Atom ("eNOTTY" | "ENOTTY") -> ENOTTY
       | Sexplib0.Sexp.Atom ("eNXIO" | "ENXIO") -> ENXIO
       | Sexplib0.Sexp.Atom ("ePERM" | "EPERM") -> EPERM
       | Sexplib0.Sexp.Atom ("ePIPE" | "EPIPE") -> EPIPE
       | Sexplib0.Sexp.Atom ("eRANGE" | "ERANGE") -> ERANGE
       | Sexplib0.Sexp.Atom ("eROFS" | "EROFS") -> EROFS
       | Sexplib0.Sexp.Atom ("eSPIPE" | "ESPIPE") -> ESPIPE
       | Sexplib0.Sexp.Atom ("eSRCH" | "ESRCH") -> ESRCH
       | Sexplib0.Sexp.Atom ("eXDEV" | "EXDEV") -> EXDEV
       | Sexplib0.Sexp.Atom ("eWOULDBLOCK" | "EWOULDBLOCK") -> EWOULDBLOCK
       | Sexplib0.Sexp.Atom ("eINPROGRESS" | "EINPROGRESS") -> EINPROGRESS
       | Sexplib0.Sexp.Atom ("eALREADY" | "EALREADY") -> EALREADY
       | Sexplib0.Sexp.Atom ("eNOTSOCK" | "ENOTSOCK") -> ENOTSOCK
       | Sexplib0.Sexp.Atom ("eDESTADDRREQ" | "EDESTADDRREQ") -> EDESTADDRREQ
       | Sexplib0.Sexp.Atom ("eMSGSIZE" | "EMSGSIZE") -> EMSGSIZE
       | Sexplib0.Sexp.Atom ("ePROTOTYPE" | "EPROTOTYPE") -> EPROTOTYPE
       | Sexplib0.Sexp.Atom ("eNOPROTOOPT" | "ENOPROTOOPT") -> ENOPROTOOPT
       | Sexplib0.Sexp.Atom ("ePROTONOSUPPORT" | "EPROTONOSUPPORT") -> EPROTONOSUPPORT
       | Sexplib0.Sexp.Atom ("eSOCKTNOSUPPORT" | "ESOCKTNOSUPPORT") -> ESOCKTNOSUPPORT
       | Sexplib0.Sexp.Atom ("eOPNOTSUPP" | "EOPNOTSUPP") -> EOPNOTSUPP
       | Sexplib0.Sexp.Atom ("ePFNOSUPPORT" | "EPFNOSUPPORT") -> EPFNOSUPPORT
       | Sexplib0.Sexp.Atom ("eAFNOSUPPORT" | "EAFNOSUPPORT") -> EAFNOSUPPORT
       | Sexplib0.Sexp.Atom ("eADDRINUSE" | "EADDRINUSE") -> EADDRINUSE
       | Sexplib0.Sexp.Atom ("eADDRNOTAVAIL" | "EADDRNOTAVAIL") -> EADDRNOTAVAIL
       | Sexplib0.Sexp.Atom ("eNETDOWN" | "ENETDOWN") -> ENETDOWN
       | Sexplib0.Sexp.Atom ("eNETUNREACH" | "ENETUNREACH") -> ENETUNREACH
       | Sexplib0.Sexp.Atom ("eNETRESET" | "ENETRESET") -> ENETRESET
       | Sexplib0.Sexp.Atom ("eCONNABORTED" | "ECONNABORTED") -> ECONNABORTED
       | Sexplib0.Sexp.Atom ("eCONNRESET" | "ECONNRESET") -> ECONNRESET
       | Sexplib0.Sexp.Atom ("eNOBUFS" | "ENOBUFS") -> ENOBUFS
       | Sexplib0.Sexp.Atom ("eISCONN" | "EISCONN") -> EISCONN
       | Sexplib0.Sexp.Atom ("eNOTCONN" | "ENOTCONN") -> ENOTCONN
       | Sexplib0.Sexp.Atom ("eSHUTDOWN" | "ESHUTDOWN") -> ESHUTDOWN
       | Sexplib0.Sexp.Atom ("eTOOMANYREFS" | "ETOOMANYREFS") -> ETOOMANYREFS
       | Sexplib0.Sexp.Atom ("eTIMEDOUT" | "ETIMEDOUT") -> ETIMEDOUT
       | Sexplib0.Sexp.Atom ("eCONNREFUSED" | "ECONNREFUSED") -> ECONNREFUSED
       | Sexplib0.Sexp.Atom ("eHOSTDOWN" | "EHOSTDOWN") -> EHOSTDOWN
       | Sexplib0.Sexp.Atom ("eHOSTUNREACH" | "EHOSTUNREACH") -> EHOSTUNREACH
       | Sexplib0.Sexp.Atom ("eLOOP" | "ELOOP") -> ELOOP
       | Sexplib0.Sexp.Atom ("eOVERFLOW" | "EOVERFLOW") -> EOVERFLOW
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("eUNKNOWNERR" | "EUNKNOWNERR") as _tag__147_)
           :: sexp_args__148_) as _sexp__146_ ->
         (match sexp_args__148_ with
          | arg0__149_ :: [] ->
            let res0__150_ = int_of_sexp arg0__149_ in
            EUNKNOWNERR res0__150_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__144_
              _tag__147_
              _sexp__146_)
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("e2BIG" | "E2BIG") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eACCES" | "EACCES") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eAGAIN" | "EAGAIN") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eBADF" | "EBADF") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eBUSY" | "EBUSY") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCHILD" | "ECHILD") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDEADLK" | "EDEADLK") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDOM" | "EDOM") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eEXIST" | "EEXIST") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eFAULT" | "EFAULT") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eFBIG" | "EFBIG") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINTR" | "EINTR") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINVAL" | "EINVAL") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eIO" | "EIO") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eISDIR" | "EISDIR") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMFILE" | "EMFILE") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMLINK" | "EMLINK") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNAMETOOLONG" | "ENAMETOOLONG") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNFILE" | "ENFILE") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNODEV" | "ENODEV") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOENT" | "ENOENT") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOEXEC" | "ENOEXEC") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOLCK" | "ENOLCK") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOMEM" | "ENOMEM") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOSPC" | "ENOSPC") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOSYS" | "ENOSYS") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTDIR" | "ENOTDIR") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTEMPTY" | "ENOTEMPTY") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTTY" | "ENOTTY") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNXIO" | "ENXIO") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePERM" | "EPERM") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePIPE" | "EPIPE") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eRANGE" | "ERANGE") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eROFS" | "EROFS") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSPIPE" | "ESPIPE") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSRCH" | "ESRCH") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eXDEV" | "EXDEV") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eWOULDBLOCK" | "EWOULDBLOCK") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINPROGRESS" | "EINPROGRESS") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eALREADY" | "EALREADY") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTSOCK" | "ENOTSOCK") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDESTADDRREQ" | "EDESTADDRREQ") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMSGSIZE" | "EMSGSIZE") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePROTOTYPE" | "EPROTOTYPE") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOPROTOOPT" | "ENOPROTOOPT") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom ("ePROTONOSUPPORT" | "EPROTONOSUPPORT") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom ("eSOCKTNOSUPPORT" | "ESOCKTNOSUPPORT") :: _) as sexp__145_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eOPNOTSUPP" | "EOPNOTSUPP") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePFNOSUPPORT" | "EPFNOSUPPORT") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eAFNOSUPPORT" | "EAFNOSUPPORT") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eADDRINUSE" | "EADDRINUSE") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eADDRNOTAVAIL" | "EADDRNOTAVAIL") :: _)
         as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETDOWN" | "ENETDOWN") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETUNREACH" | "ENETUNREACH") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETRESET" | "ENETRESET") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNABORTED" | "ECONNABORTED") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNRESET" | "ECONNRESET") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOBUFS" | "ENOBUFS") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eISCONN" | "EISCONN") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTCONN" | "ENOTCONN") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSHUTDOWN" | "ESHUTDOWN") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eTOOMANYREFS" | "ETOOMANYREFS") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eTIMEDOUT" | "ETIMEDOUT") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNREFUSED" | "ECONNREFUSED") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eHOSTDOWN" | "EHOSTDOWN") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eHOSTUNREACH" | "EHOSTUNREACH") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eLOOP" | "ELOOP") :: _) as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eOVERFLOW" | "EOVERFLOW") :: _) as
         sexp__145_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.Atom ("eUNKNOWNERR" | "EUNKNOWNERR") as sexp__145_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__144_ sexp__145_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__143_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__144_ sexp__143_
       | Sexplib0.Sexp.List [] as sexp__143_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__144_ sexp__143_
       | sexp__143_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__144_ sexp__143_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | E2BIG -> Sexplib0.Sexp.Atom "E2BIG"
       | EACCES -> Sexplib0.Sexp.Atom "EACCES"
       | EAGAIN -> Sexplib0.Sexp.Atom "EAGAIN"
       | EBADF -> Sexplib0.Sexp.Atom "EBADF"
       | EBUSY -> Sexplib0.Sexp.Atom "EBUSY"
       | ECHILD -> Sexplib0.Sexp.Atom "ECHILD"
       | EDEADLK -> Sexplib0.Sexp.Atom "EDEADLK"
       | EDOM -> Sexplib0.Sexp.Atom "EDOM"
       | EEXIST -> Sexplib0.Sexp.Atom "EEXIST"
       | EFAULT -> Sexplib0.Sexp.Atom "EFAULT"
       | EFBIG -> Sexplib0.Sexp.Atom "EFBIG"
       | EINTR -> Sexplib0.Sexp.Atom "EINTR"
       | EINVAL -> Sexplib0.Sexp.Atom "EINVAL"
       | EIO -> Sexplib0.Sexp.Atom "EIO"
       | EISDIR -> Sexplib0.Sexp.Atom "EISDIR"
       | EMFILE -> Sexplib0.Sexp.Atom "EMFILE"
       | EMLINK -> Sexplib0.Sexp.Atom "EMLINK"
       | ENAMETOOLONG -> Sexplib0.Sexp.Atom "ENAMETOOLONG"
       | ENFILE -> Sexplib0.Sexp.Atom "ENFILE"
       | ENODEV -> Sexplib0.Sexp.Atom "ENODEV"
       | ENOENT -> Sexplib0.Sexp.Atom "ENOENT"
       | ENOEXEC -> Sexplib0.Sexp.Atom "ENOEXEC"
       | ENOLCK -> Sexplib0.Sexp.Atom "ENOLCK"
       | ENOMEM -> Sexplib0.Sexp.Atom "ENOMEM"
       | ENOSPC -> Sexplib0.Sexp.Atom "ENOSPC"
       | ENOSYS -> Sexplib0.Sexp.Atom "ENOSYS"
       | ENOTDIR -> Sexplib0.Sexp.Atom "ENOTDIR"
       | ENOTEMPTY -> Sexplib0.Sexp.Atom "ENOTEMPTY"
       | ENOTTY -> Sexplib0.Sexp.Atom "ENOTTY"
       | ENXIO -> Sexplib0.Sexp.Atom "ENXIO"
       | EPERM -> Sexplib0.Sexp.Atom "EPERM"
       | EPIPE -> Sexplib0.Sexp.Atom "EPIPE"
       | ERANGE -> Sexplib0.Sexp.Atom "ERANGE"
       | EROFS -> Sexplib0.Sexp.Atom "EROFS"
       | ESPIPE -> Sexplib0.Sexp.Atom "ESPIPE"
       | ESRCH -> Sexplib0.Sexp.Atom "ESRCH"
       | EXDEV -> Sexplib0.Sexp.Atom "EXDEV"
       | EWOULDBLOCK -> Sexplib0.Sexp.Atom "EWOULDBLOCK"
       | EINPROGRESS -> Sexplib0.Sexp.Atom "EINPROGRESS"
       | EALREADY -> Sexplib0.Sexp.Atom "EALREADY"
       | ENOTSOCK -> Sexplib0.Sexp.Atom "ENOTSOCK"
       | EDESTADDRREQ -> Sexplib0.Sexp.Atom "EDESTADDRREQ"
       | EMSGSIZE -> Sexplib0.Sexp.Atom "EMSGSIZE"
       | EPROTOTYPE -> Sexplib0.Sexp.Atom "EPROTOTYPE"
       | ENOPROTOOPT -> Sexplib0.Sexp.Atom "ENOPROTOOPT"
       | EPROTONOSUPPORT -> Sexplib0.Sexp.Atom "EPROTONOSUPPORT"
       | ESOCKTNOSUPPORT -> Sexplib0.Sexp.Atom "ESOCKTNOSUPPORT"
       | EOPNOTSUPP -> Sexplib0.Sexp.Atom "EOPNOTSUPP"
       | EPFNOSUPPORT -> Sexplib0.Sexp.Atom "EPFNOSUPPORT"
       | EAFNOSUPPORT -> Sexplib0.Sexp.Atom "EAFNOSUPPORT"
       | EADDRINUSE -> Sexplib0.Sexp.Atom "EADDRINUSE"
       | EADDRNOTAVAIL -> Sexplib0.Sexp.Atom "EADDRNOTAVAIL"
       | ENETDOWN -> Sexplib0.Sexp.Atom "ENETDOWN"
       | ENETUNREACH -> Sexplib0.Sexp.Atom "ENETUNREACH"
       | ENETRESET -> Sexplib0.Sexp.Atom "ENETRESET"
       | ECONNABORTED -> Sexplib0.Sexp.Atom "ECONNABORTED"
       | ECONNRESET -> Sexplib0.Sexp.Atom "ECONNRESET"
       | ENOBUFS -> Sexplib0.Sexp.Atom "ENOBUFS"
       | EISCONN -> Sexplib0.Sexp.Atom "EISCONN"
       | ENOTCONN -> Sexplib0.Sexp.Atom "ENOTCONN"
       | ESHUTDOWN -> Sexplib0.Sexp.Atom "ESHUTDOWN"
       | ETOOMANYREFS -> Sexplib0.Sexp.Atom "ETOOMANYREFS"
       | ETIMEDOUT -> Sexplib0.Sexp.Atom "ETIMEDOUT"
       | ECONNREFUSED -> Sexplib0.Sexp.Atom "ECONNREFUSED"
       | EHOSTDOWN -> Sexplib0.Sexp.Atom "EHOSTDOWN"
       | EHOSTUNREACH -> Sexplib0.Sexp.Atom "EHOSTUNREACH"
       | ELOOP -> Sexplib0.Sexp.Atom "ELOOP"
       | EOVERFLOW -> Sexplib0.Sexp.Atom "EOVERFLOW"
       | EUNKNOWNERR arg0__151_ ->
         let res0__152_ = sexp_of_int arg0__151_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "EUNKNOWNERR"; res0__152_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_system_int ~errno = Unix_error.of_errno errno
  let message = Unix.error_message

  module Private = struct
    let to_errno = to_errno
  end
end

let putenv ~key ~data =
  improve
    (fun () -> Unix.putenv key data)
    (fun () -> [ "key", atom key; "data", atom data ])
;;

let unsetenv name =
  if String.contains name '\000' then raise (Unix_error (EINVAL, "unsetenv", name));
  unsetenv name
;;

type process_status = Unix.process_status =
  | WEXITED of int
  | WSIGNALED of int
  | WSTOPPED of int
[@@deriving sexp]

include struct
  let _ = fun (_ : process_status) -> ()

  let process_status_of_sexp =
    (let error_source__155_ = "core_unix.ml.before-ppx.process_status" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("wEXITED" | "WEXITED") as _tag__158_) :: sexp_args__159_)
       as _sexp__157_ ->
       (match sexp_args__159_ with
        | arg0__160_ :: [] ->
          let res0__161_ = int_of_sexp arg0__160_ in
          WEXITED res0__161_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__155_
            _tag__158_
            _sexp__157_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("wSIGNALED" | "WSIGNALED") as _tag__163_)
         :: sexp_args__164_) as _sexp__162_ ->
       (match sexp_args__164_ with
        | arg0__165_ :: [] ->
          let res0__166_ = int_of_sexp arg0__165_ in
          WSIGNALED res0__166_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__155_
            _tag__163_
            _sexp__162_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("wSTOPPED" | "WSTOPPED") as _tag__168_) :: sexp_args__169_)
       as _sexp__167_ ->
       (match sexp_args__169_ with
        | arg0__170_ :: [] ->
          let res0__171_ = int_of_sexp arg0__170_ in
          WSTOPPED res0__171_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__155_
            _tag__168_
            _sexp__167_)
     | Sexplib0.Sexp.Atom ("wEXITED" | "WEXITED") as sexp__156_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__155_ sexp__156_
     | Sexplib0.Sexp.Atom ("wSIGNALED" | "WSIGNALED") as sexp__156_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__155_ sexp__156_
     | Sexplib0.Sexp.Atom ("wSTOPPED" | "WSTOPPED") as sexp__156_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__155_ sexp__156_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__154_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__155_ sexp__154_
     | Sexplib0.Sexp.List [] as sexp__154_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__155_ sexp__154_
     | sexp__154_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__155_ sexp__154_
     : Sexplib0.Sexp.t -> process_status)
  ;;

  let _ = process_status_of_sexp

  let sexp_of_process_status =
    (function
     | WEXITED arg0__172_ ->
       let res0__173_ = sexp_of_int arg0__172_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "WEXITED"; res0__173_ ]
     | WSIGNALED arg0__174_ ->
       let res0__175_ = sexp_of_int arg0__174_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "WSIGNALED"; res0__175_ ]
     | WSTOPPED arg0__176_ ->
       let res0__177_ = sexp_of_int arg0__176_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "WSTOPPED"; res0__177_ ]
     : process_status -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_process_status
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Exit = struct
  type error = [ `Exit_non_zero of int ] [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : error) -> ()

    let compare_error =
      (fun a__178_ b__179_ ->
         if Stdlib.( == ) a__178_ b__179_
         then 0
         else (
           match a__178_, b__179_ with
           | `Exit_non_zero _left__180_, `Exit_non_zero _right__181_ ->
             compare_int _left__180_ _right__181_)
       : error -> (error[@merlin.hide]) -> int)
    ;;

    let _ = compare_error

    let __error_of_sexp__ =
      (let error_source__190_ = "core_unix.ml.before-ppx.Exit.error" in
       function
       | Sexplib0.Sexp.Atom atom__183_ as _sexp__185_ ->
         (match atom__183_ with
          | "Exit_non_zero" ->
            Sexplib0.Sexp_conv_error.ptag_takes_args error_source__190_ _sexp__185_
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__183_ :: sexp_args__186_) as
         _sexp__185_ ->
         (match atom__183_ with
          | "Exit_non_zero" as _tag__187_ ->
            (match sexp_args__186_ with
             | arg0__188_ :: [] ->
               let res0__189_ = int_of_sexp arg0__188_ in
               `Exit_non_zero res0__189_
             | _ ->
               Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                 error_source__190_
                 _tag__187_
                 _sexp__185_)
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__184_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
           error_source__190_
           sexp__184_
       | Sexplib0.Sexp.List [] as sexp__184_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
           error_source__190_
           sexp__184_
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = __error_of_sexp__

    let error_of_sexp =
      (let error_source__192_ = "core_unix.ml.before-ppx.Exit.error" in
       fun sexp__191_ ->
         try __error_of_sexp__ sexp__191_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__192_
             sexp__191_
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = error_of_sexp

    let sexp_of_error =
      (fun (`Exit_non_zero v__193_) ->
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exit_non_zero"; sexp_of_int v__193_ ]
       : error -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_error
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__194_ b__195_ ->
         Result.compare
           (fun a__196_ (b__197_ [@merlin.hide]) ->
              (compare_unit a__196_ b__197_ [@merlin.hide]))
           (fun a__198_ (b__199_ [@merlin.hide]) ->
              (compare_error a__198_ b__199_ [@merlin.hide]))
           a__194_
           b__195_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (fun x__201_ -> Result.t_of_sexp unit_of_sexp error_of_sexp x__201_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__202_ -> Result.sexp_of_t sexp_of_unit sexp_of_error x__202_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_string_hum = function
    | Ok () -> "exited normally"
    | Error (`Exit_non_zero i) -> sprintf "exited with code %d" i
  ;;

  let code = function
    | Ok () -> 0
    | Error (`Exit_non_zero i) -> i
  ;;

  exception Exit_code_must_be_nonnegative of int [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add
        [%extension_constructor Exit_code_must_be_nonnegative]
        (function
        | Exit_code_must_be_nonnegative arg0__203_ ->
          let res0__204_ = sexp_of_int arg0__203_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom
                "core_unix.ml.before-ppx.Exit.Exit_code_must_be_nonnegative"
            ; res0__204_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_code code =
    if code < 0
    then raise (Exit_code_must_be_nonnegative code)
    else if code = 0
    then Ok ()
    else Error (`Exit_non_zero code)
  ;;

  let or_error = function
    | Ok _ as ok -> ok
    | Error error -> Or_error.error "Unix.Exit" error sexp_of_error
  ;;
end

module Exit_or_signal = struct
  type error =
    [ Exit.error
    | `Signal of Signal.t
    ]
  [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : error) -> ()

    let compare_error =
      (fun a__205_ b__206_ ->
         if Stdlib.( == ) a__205_ b__206_
         then 0
         else (
           match a__205_, b__206_ with
           | (#Exit.error as _left__207_), (#Exit.error as _right__208_) ->
             Exit.compare_error _left__207_ _right__208_
           | `Signal _left__209_, `Signal _right__210_ ->
             Signal.compare _left__209_ _right__210_
           | x, y -> Stdlib.compare x y)
       : error -> (error[@merlin.hide]) -> int)
    ;;

    let _ = compare_error

    let __error_of_sexp__ =
      (let error_source__219_ = "core_unix.ml.before-ppx.Exit_or_signal.error" in
       fun sexp__211_ ->
         try (Exit.__error_of_sexp__ sexp__211_ :> error) with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           (match sexp__211_ with
            | Sexplib0.Sexp.Atom atom__212_ as _sexp__214_ ->
              (match atom__212_ with
               | "Signal" ->
                 Sexplib0.Sexp_conv_error.ptag_takes_args error_source__219_ _sexp__214_
               | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
            | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__212_ :: sexp_args__215_) as
              _sexp__214_ ->
              (match atom__212_ with
               | "Signal" as _tag__216_ ->
                 (match sexp_args__215_ with
                  | arg0__217_ :: [] ->
                    let res0__218_ = Signal.t_of_sexp arg0__217_ in
                    `Signal res0__218_
                  | _ ->
                    Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                      error_source__219_
                      _tag__216_
                      _sexp__214_)
               | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
            | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__213_ ->
              Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                error_source__219_
                sexp__213_
            | Sexplib0.Sexp.List [] as sexp__213_ ->
              Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                error_source__219_
                sexp__213_)
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = __error_of_sexp__

    let error_of_sexp =
      (let error_source__221_ = "core_unix.ml.before-ppx.Exit_or_signal.error" in
       fun sexp__220_ ->
         try __error_of_sexp__ sexp__220_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__221_
             sexp__220_
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = error_of_sexp

    let sexp_of_error =
      (function
       | #Exit.error as v__222_ -> Exit.sexp_of_error v__222_
       | `Signal v__223_ ->
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Signal"; Signal.sexp_of_t v__223_ ]
       : error -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_error
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__224_ b__225_ ->
         Result.compare
           (fun a__226_ (b__227_ [@merlin.hide]) ->
              (compare_unit a__226_ b__227_ [@merlin.hide]))
           (fun a__228_ (b__229_ [@merlin.hide]) ->
              (compare_error a__228_ b__229_ [@merlin.hide]))
           a__224_
           b__225_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (fun x__231_ -> Result.t_of_sexp unit_of_sexp error_of_sexp x__231_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__232_ -> Result.sexp_of_t sexp_of_unit sexp_of_error x__232_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_string_hum = function
    | (Ok () | Error #Exit.error) as e -> Exit.to_string_hum e
    | Error (`Signal s) ->
      sprintf
        "died after receiving %s (signal number %d)"
        (Signal.to_string s)
        (Signal_unix.to_system_int s)
  ;;

  exception Of_unix_got_invalid_status of process_status [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add
        [%extension_constructor Of_unix_got_invalid_status]
        (function
        | Of_unix_got_invalid_status arg0__233_ ->
          let res0__234_ = sexp_of_process_status arg0__233_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom
                "core_unix.ml.before-ppx.Exit_or_signal.Of_unix_got_invalid_status"
            ; res0__234_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix = function
    | WEXITED i -> if i = 0 then Ok () else Error (`Exit_non_zero i)
    | WSIGNALED i -> Error (`Signal (Signal.of_caml_int i))
    | WSTOPPED _ as status -> raise (Of_unix_got_invalid_status status)
  ;;

  let or_error = function
    | Ok _ as ok -> ok
    | Error error -> Or_error.error "Unix.Exit_or_signal" error sexp_of_error
  ;;
end

module Exit_or_signal_or_stop = struct
  type error =
    [ Exit_or_signal.error
    | `Stop of Signal.t
    ]
  [@@deriving sexp]

  include struct
    let _ = fun (_ : error) -> ()

    let __error_of_sexp__ =
      (let error_source__243_ = "core_unix.ml.before-ppx.Exit_or_signal_or_stop.error" in
       fun sexp__235_ ->
         try (Exit_or_signal.__error_of_sexp__ sexp__235_ :> error) with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           (match sexp__235_ with
            | Sexplib0.Sexp.Atom atom__236_ as _sexp__238_ ->
              (match atom__236_ with
               | "Stop" ->
                 Sexplib0.Sexp_conv_error.ptag_takes_args error_source__243_ _sexp__238_
               | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
            | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__236_ :: sexp_args__239_) as
              _sexp__238_ ->
              (match atom__236_ with
               | "Stop" as _tag__240_ ->
                 (match sexp_args__239_ with
                  | arg0__241_ :: [] ->
                    let res0__242_ = Signal.t_of_sexp arg0__241_ in
                    `Stop res0__242_
                  | _ ->
                    Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                      error_source__243_
                      _tag__240_
                      _sexp__238_)
               | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
            | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__237_ ->
              Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                error_source__243_
                sexp__237_
            | Sexplib0.Sexp.List [] as sexp__237_ ->
              Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                error_source__243_
                sexp__237_)
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = __error_of_sexp__

    let error_of_sexp =
      (let error_source__245_ = "core_unix.ml.before-ppx.Exit_or_signal_or_stop.error" in
       fun sexp__244_ ->
         try __error_of_sexp__ sexp__244_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__245_
             sexp__244_
       : Sexplib0.Sexp.t -> error)
    ;;

    let _ = error_of_sexp

    let sexp_of_error =
      (function
       | #Exit_or_signal.error as v__246_ -> Exit_or_signal.sexp_of_error v__246_
       | `Stop v__247_ ->
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Stop"; Signal.sexp_of_t v__247_ ]
       : error -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_error
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = (unit, error) Result.t [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (fun x__249_ -> Result.t_of_sexp unit_of_sexp error_of_sexp x__249_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__250_ -> Result.sexp_of_t sexp_of_unit sexp_of_error x__250_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_string_hum = function
    | (Ok () | Error #Exit_or_signal.error) as e -> Exit_or_signal.to_string_hum e
    | Error (`Stop s) ->
      sprintf
        "stopped by %s (signal number %d)"
        (Signal.to_string s)
        (Signal_unix.to_system_int s)
  ;;

  let of_unix = function
    | WEXITED i -> if i = 0 then Ok () else Error (`Exit_non_zero i)
    | WSIGNALED i -> Error (`Signal (Signal.of_caml_int i))
    | WSTOPPED i -> Error (`Stop (Signal.of_caml_int i))
  ;;

  let or_error = function
    | Ok _ as ok -> ok
    | Error error -> Or_error.error "Unix.Exit_or_signal_or_stop" error sexp_of_error
  ;;
end

let prog_r prog = "prog", atom prog
let args_r argv = "argv", sexp_of_array atom argv
let env_r env = "env", sexp_of_array atom env

let execv ~prog ~argv =
  improve (fun () -> Unix.execv ~prog ~args:argv) (fun () -> [ prog_r prog; args_r argv ])
;;

let execve ~prog ~argv ~env =
  improve
    (fun () -> Unix.execve ~prog ~args:argv ~env)
    (fun () -> [ prog_r prog; args_r argv; env_r env ])
;;

let execvp ~prog ~argv =
  improve
    (fun () -> Unix.execvp ~prog ~args:argv)
    (fun () -> [ prog_r prog; args_r argv ])
;;

let execvpe ~prog ~argv ~env =
  improve
    (fun () -> Unix.execvpe ~prog ~args:argv ~env)
    (fun () -> [ prog_r prog; args_r argv; env_r env ])
;;

module Env = struct
  type t =
    [ `Replace of (string * string) list
    | `Extend of (string * string) list
    | `Override of (string * string option) list
    | `Replace_raw of string list
    ]
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let __t_of_sexp__ =
      (let error_source__259_ = "core_unix.ml.before-ppx.Env.t" in
       function
       | Sexplib0.Sexp.Atom atom__252_ as _sexp__254_ ->
         (match atom__252_ with
          | "Replace" ->
            Sexplib0.Sexp_conv_error.ptag_takes_args error_source__259_ _sexp__254_
          | "Extend" ->
            Sexplib0.Sexp_conv_error.ptag_takes_args error_source__259_ _sexp__254_
          | "Override" ->
            Sexplib0.Sexp_conv_error.ptag_takes_args error_source__259_ _sexp__254_
          | "Replace_raw" ->
            Sexplib0.Sexp_conv_error.ptag_takes_args error_source__259_ _sexp__254_
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__252_ :: sexp_args__255_) as
         _sexp__254_ ->
         (match atom__252_ with
          | "Replace" as _tag__276_ ->
            (match sexp_args__255_ with
             | arg0__282_ :: [] ->
               let res0__283_ =
                 list_of_sexp
                   (function
                     | Sexplib0.Sexp.List [ arg0__277_; arg1__278_ ] ->
                       let res0__279_ = string_of_sexp arg0__277_
                       and res1__280_ = string_of_sexp arg1__278_ in
                       res0__279_, res1__280_
                     | sexp__281_ ->
                       Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                         error_source__259_
                         2
                         sexp__281_)
                   arg0__282_
               in
               `Replace res0__283_
             | _ ->
               Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                 error_source__259_
                 _tag__276_
                 _sexp__254_)
          | "Extend" as _tag__268_ ->
            (match sexp_args__255_ with
             | arg0__274_ :: [] ->
               let res0__275_ =
                 list_of_sexp
                   (function
                     | Sexplib0.Sexp.List [ arg0__269_; arg1__270_ ] ->
                       let res0__271_ = string_of_sexp arg0__269_
                       and res1__272_ = string_of_sexp arg1__270_ in
                       res0__271_, res1__272_
                     | sexp__273_ ->
                       Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                         error_source__259_
                         2
                         sexp__273_)
                   arg0__274_
               in
               `Extend res0__275_
             | _ ->
               Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                 error_source__259_
                 _tag__268_
                 _sexp__254_)
          | "Override" as _tag__260_ ->
            (match sexp_args__255_ with
             | arg0__266_ :: [] ->
               let res0__267_ =
                 list_of_sexp
                   (function
                     | Sexplib0.Sexp.List [ arg0__261_; arg1__262_ ] ->
                       let res0__263_ = string_of_sexp arg0__261_
                       and res1__264_ = option_of_sexp string_of_sexp arg1__262_ in
                       res0__263_, res1__264_
                     | sexp__265_ ->
                       Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                         error_source__259_
                         2
                         sexp__265_)
                   arg0__266_
               in
               `Override res0__267_
             | _ ->
               Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                 error_source__259_
                 _tag__260_
                 _sexp__254_)
          | "Replace_raw" as _tag__256_ ->
            (match sexp_args__255_ with
             | arg0__257_ :: [] ->
               let res0__258_ = list_of_sexp string_of_sexp arg0__257_ in
               `Replace_raw res0__258_
             | _ ->
               Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                 error_source__259_
                 _tag__256_
                 _sexp__254_)
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__253_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
           error_source__259_
           sexp__253_
       | Sexplib0.Sexp.List [] as sexp__253_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
           error_source__259_
           sexp__253_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = __t_of_sexp__

    let t_of_sexp =
      (let error_source__285_ = "core_unix.ml.before-ppx.Env.t" in
       fun sexp__284_ ->
         try __t_of_sexp__ sexp__284_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__285_
             sexp__284_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | `Replace v__286_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Replace"
           ; sexp_of_list
               (fun (arg0__287_, arg1__288_) ->
                  let res0__289_ = sexp_of_string arg0__287_
                  and res1__290_ = sexp_of_string arg1__288_ in
                  Sexplib0.Sexp.List [ res0__289_; res1__290_ ])
               v__286_
           ]
       | `Extend v__291_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Extend"
           ; sexp_of_list
               (fun (arg0__292_, arg1__293_) ->
                  let res0__294_ = sexp_of_string arg0__292_
                  and res1__295_ = sexp_of_string arg1__293_ in
                  Sexplib0.Sexp.List [ res0__294_; res1__295_ ])
               v__291_
           ]
       | `Override v__296_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Override"
           ; sexp_of_list
               (fun (arg0__297_, arg1__298_) ->
                  let res0__299_ = sexp_of_string arg0__297_
                  and res1__300_ = sexp_of_option sexp_of_string arg1__298_ in
                  Sexplib0.Sexp.List [ res0__299_; res1__300_ ])
               v__296_
           ]
       | `Replace_raw v__301_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Replace_raw"; sexp_of_list sexp_of_string v__301_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let current ~base () =
    let base =
      match base with
      | Some v -> force v
      | None -> Array.to_list (Unix.environment ())
    in
    List.map base ~f:(fun s -> String.lsplit2_exn s ~on:'=')
  ;;

  let env_map ~base env =
    let map_of_list list = String.Map.of_alist_reduce list ~f:(fun _ x -> x) in
    match env with
    | `Replace env -> map_of_list env
    | `Extend extend -> map_of_list (current ~base () @ extend)
    | `Override overrides ->
      List.fold_left
        overrides
        ~init:(map_of_list (current ~base ()))
        ~f:(fun acc (key, v) ->
          match v with
          | None -> Map.remove acc key
          | Some data -> Map.set acc ~key ~data)
  ;;

  let expand ?base env =
    match env with
    | `Replace_raw env -> env
    | (`Replace _ | `Extend _ | `Override _) as env ->
      Map.fold (env_map ~base env) ~init:[] ~f:(fun ~key ~data acc ->
        (key ^ "=" ^ data) :: acc)
  ;;

  let expand_array ?base env = Array.of_list (expand ?base env)
end

type env = Env.t [@@deriving sexp]

include struct
  let _ = fun (_ : env) -> ()
  let env_of_sexp = (Env.t_of_sexp : Sexplib0.Sexp.t -> env)
  let _ = env_of_sexp
  let sexp_of_env = (Env.sexp_of_t : env -> Sexplib0.Sexp.t)
  let _ = sexp_of_env
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Pgid = struct
  type t = Spawn.Pgid.t

  let new_process_group = Spawn.Pgid.new_process_group
  let of_pid = Spawn.Pgid.of_pid
end

let exec_internal ~prog ~argv ~use_path ~env =
  match use_path, env with
  | false, None -> execv ~prog ~argv
  | false, Some env -> execve ~prog ~argv ~env
  | true, None -> execvp ~prog ~argv
  | true, Some env -> execvpe ~prog ~argv ~env
;;

exception Fork_returned_negative_result of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Fork_returned_negative_result]
      (function
      | Fork_returned_negative_result arg0__303_ ->
        let res0__304_ = sexp_of_int arg0__303_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Fork_returned_negative_result"
          ; res0__304_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let fork () =
  let pid = Unix.fork () in
  if pid < 0
  then raise (Fork_returned_negative_result pid)
  else if pid = 0
  then `In_the_child
  else `In_the_parent (Pid.of_int pid)
;;

external sys_exit : int -> 'a = "caml_sys_exit"

let fork_exec ~prog ~argv ?preexec_fn ?(use_path = true) ?env () =
  let argv = Array.of_list argv in
  let env = Option.map env ~f:Env.expand_array in
  match fork () with
  | `In_the_child ->
    (try
       Option.call ~f:preexec_fn ();
       never_returns (exec_internal ~prog ~argv ~use_path ~env)
     with
     | _ -> sys_exit 127)
  | `In_the_parent pid -> pid
;;

type wait_flag = Unix.wait_flag =
  | WNOHANG
  | WUNTRACED
[@@deriving sexp]

include struct
  let _ = fun (_ : wait_flag) -> ()

  let wait_flag_of_sexp =
    (let error_source__307_ = "core_unix.ml.before-ppx.wait_flag" in
     function
     | Sexplib0.Sexp.Atom ("wNOHANG" | "WNOHANG") -> WNOHANG
     | Sexplib0.Sexp.Atom ("wUNTRACED" | "WUNTRACED") -> WUNTRACED
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("wNOHANG" | "WNOHANG") :: _) as sexp__308_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__307_ sexp__308_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("wUNTRACED" | "WUNTRACED") :: _) as
       sexp__308_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__307_ sexp__308_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__306_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__307_ sexp__306_
     | Sexplib0.Sexp.List [] as sexp__306_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__307_ sexp__306_
     | sexp__306_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__307_ sexp__306_
     : Sexplib0.Sexp.t -> wait_flag)
  ;;

  let _ = wait_flag_of_sexp

  let sexp_of_wait_flag =
    (function
     | WNOHANG -> Sexplib0.Sexp.Atom "WNOHANG"
     | WUNTRACED -> Sexplib0.Sexp.Atom "WUNTRACED"
     : wait_flag -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_wait_flag
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type wait_on =
  [ `Any
  | `My_group
  | `Group of Pid.t
  | `Pid of Pid.t
  ]
[@@deriving sexp]

include struct
  let _ = fun (_ : wait_on) -> ()

  let __wait_on_of_sexp__ =
    (let error_source__314_ = "core_unix.ml.before-ppx.wait_on" in
     function
     | Sexplib0.Sexp.Atom atom__310_ as _sexp__312_ ->
       (match atom__310_ with
        | "Any" -> `Any
        | "My_group" -> `My_group
        | "Group" ->
          Sexplib0.Sexp_conv_error.ptag_takes_args error_source__314_ _sexp__312_
        | "Pid" -> Sexplib0.Sexp_conv_error.ptag_takes_args error_source__314_ _sexp__312_
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__310_ :: sexp_args__313_) as
       _sexp__312_ ->
       (match atom__310_ with
        | "Group" as _tag__318_ ->
          (match sexp_args__313_ with
           | arg0__319_ :: [] ->
             let res0__320_ = Pid.t_of_sexp arg0__319_ in
             `Group res0__320_
           | _ ->
             Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
               error_source__314_
               _tag__318_
               _sexp__312_)
        | "Pid" as _tag__315_ ->
          (match sexp_args__313_ with
           | arg0__316_ :: [] ->
             let res0__317_ = Pid.t_of_sexp arg0__316_ in
             `Pid res0__317_
           | _ ->
             Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
               error_source__314_
               _tag__315_
               _sexp__312_)
        | "Any" -> Sexplib0.Sexp_conv_error.ptag_no_args error_source__314_ _sexp__312_
        | "My_group" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__314_ _sexp__312_
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__311_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var error_source__314_ sexp__311_
     | Sexplib0.Sexp.List [] as sexp__311_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var error_source__314_ sexp__311_
     : Sexplib0.Sexp.t -> wait_on)
  ;;

  let _ = __wait_on_of_sexp__

  let wait_on_of_sexp =
    (let error_source__322_ = "core_unix.ml.before-ppx.wait_on" in
     fun sexp__321_ ->
       try __wait_on_of_sexp__ sexp__321_ with
       | Sexplib0.Sexp_conv_error.No_variant_match ->
         Sexplib0.Sexp_conv_error.no_matching_variant_found error_source__322_ sexp__321_
     : Sexplib0.Sexp.t -> wait_on)
  ;;

  let _ = wait_on_of_sexp

  let sexp_of_wait_on =
    (function
     | `Any -> Sexplib0.Sexp.Atom "Any"
     | `My_group -> Sexplib0.Sexp.Atom "My_group"
     | `Group v__323_ ->
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; Pid.sexp_of_t v__323_ ]
     | `Pid v__324_ ->
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Pid"; Pid.sexp_of_t v__324_ ]
     : wait_on -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_wait_on
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pid_of_wait_on = function
  | `Any -> -1
  | `Group pid -> -Pid.to_int pid
  | `My_group -> 0
  | `Pid pid -> Pid.to_int pid
;;

type mode = wait_flag list [@@deriving sexp_of]

include struct
  let _ = fun (_ : mode) -> ()

  let sexp_of_mode =
    (fun x__325_ -> sexp_of_list sexp_of_wait_flag x__325_ : mode -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_mode
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type _t = mode
type waitpid_result = (Pid.t * Exit_or_signal_or_stop.t) option [@@deriving sexp_of]

include struct
  let _ = fun (_ : waitpid_result) -> ()

  let sexp_of_waitpid_result =
    (fun x__330_ ->
       sexp_of_option
         (fun (arg0__326_, arg1__327_) ->
            let res0__328_ = Pid.sexp_of_t arg0__326_
            and res1__329_ = Exit_or_signal_or_stop.sexp_of_t arg1__327_ in
            Sexplib0.Sexp.List [ res0__328_; res1__329_ ])
         x__330_
     : waitpid_result -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_waitpid_result
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let wait_gen ~mode (type a) (f : waitpid_result -> a option) ~restart wait_on : a =
  let pid = pid_of_wait_on wait_on in
  let pid, status =
    improve
      ~restart
      (fun () ->
         let x, ps = Unix.waitpid ~mode pid in
         x, Exit_or_signal_or_stop.of_unix ps)
      (fun () ->
         [ "mode", sexp_of_list sexp_of_wait_flag mode; "pid", Int.sexp_of_t pid ])
  in
  let waitpid_result =
    if pid = 0
    then None
    else (
      let pid = Pid.of_int pid in
      Some (pid, status))
  in
  match f waitpid_result with
  | Some a -> a
  | None ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "core_unix.ml.before-ppx"
        ; pos_lnum = 987
        ; pos_cnum = 26297
        ; pos_bol = 26285
        }
      "waitpid syscall returned invalid result for mode"
      (pid, mode, waitpid_result)
      ((fun (arg0__331_, arg1__332_, arg2__333_) ->
         let res0__334_ = sexp_of_int arg0__331_
         and res1__335_ = sexp_of_mode arg1__332_
         and res2__336_ = sexp_of_waitpid_result arg2__333_ in
         Sexplib0.Sexp.List [ res0__334_; res1__335_; res2__336_ ]) [@merlin.hide])
;;

let wait ?(restart = true) pid =
  let f = function
    | Some ((_, (Ok _ | Error #Exit_or_signal.error)) as x) -> Some x
    | _ -> None
  in
  wait_gen ~restart ~mode:[] f pid
;;

let wait_nohang pid =
  let f = function
    | (None | Some (_, (Ok _ | Error #Exit_or_signal.error))) as x -> Some x
    | _ -> None
  in
  wait_gen ~mode:[ WNOHANG ] ~restart:true f pid
;;

let wait_untraced ?(restart = true) pid = wait_gen ~restart ~mode:[ WUNTRACED ] Fn.id pid

let wait_nohang_untraced pid =
  wait_gen ~mode:[ WNOHANG; WUNTRACED ] Option.some ~restart:true pid
;;

let waitpid pid =
  let pid', exit_or_signal = wait (`Pid pid) in
  assert (Pid.equal pid pid');
  exit_or_signal
;;

let waitpid_exn pid =
  let exit_or_signal = waitpid pid in
  if Result.is_error exit_or_signal
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "core_unix.ml.before-ppx"
        ; pos_lnum = 1026
        ; pos_cnum = 27263
        ; pos_bol = 27251
        }
      "child process didn't exit with status 0"
      (`Child_pid pid, exit_or_signal)
      ((fun (arg0__338_, arg1__339_) ->
         let res0__340_ =
           let (`Child_pid v__337_) = arg0__338_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Child_pid"; Pid.sexp_of_t v__337_ ]
         and res1__341_ = Exit_or_signal.sexp_of_t arg1__339_ in
         Sexplib0.Sexp.List [ res0__340_; res1__341_ ]) [@merlin.hide])
;;

external wait4
  :  Unix.wait_flag list
  -> int
  -> (int * process_status) * Resource_usage.t
  = "core_unix_wait4"

let wait4 ?(restart = true) ~mode wait_on =
  let pid = pid_of_wait_on wait_on in
  let (x, ps), rusage =
    improve
      ~restart
      (fun () -> wait4 mode pid)
      (fun () ->
         [ "mode", sexp_of_list sexp_of_wait_flag mode; "pid", Int.sexp_of_t pid ])
  in
  if x = 0 then None else Some ((Pid.of_int x, Exit_or_signal_or_stop.of_unix ps), rusage)
;;

let wait_with_resource_usage ?restart wait_on =
  let (pid, ps), rusage =
    Option.value_exn
      ~message:"unexpected None with wait4 without WNOHANG"
      (wait4 ?restart ~mode:[] wait_on)
  in
  match ps with
  | (Ok _ | Error #Exit_or_signal.error) as x -> (pid, x), rusage
  | Error (`Stop _) ->
    raise_s
      (Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "process status is `Stop, which is unexpected when waiting without \
                  WUNTRACED"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "pid"; (Pid.sexp_of_t [@merlin.hide]) pid ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "ps"
                 ; (Exit_or_signal_or_stop.sexp_of_t [@merlin.hide]) ps
                 ]
             ]
         ])
;;

let system s =
  improve
    (fun () -> Exit_or_signal.of_unix (Unix.system s))
    (fun () -> [ "command", atom s ])
;;

let getpid () = Pid.of_int (Unix.getpid ())

let getppid () =
  match Unix.getppid () with
  | x when x < 1 -> None
  | x -> Some (Pid.of_int x)
;;

let getppid_exn () =
  Option.value_exn ~message:"You don't have a parent process" (getppid ())
;;

module Thread_id = Int

[%%if JSC_THREAD_ID_METHOD > 0]

external gettid : unit -> Thread_id.t = "core_unix_gettid"

let gettid = Ok gettid

[%%else]

let gettid = Or_error.unimplemented "gettid is not supported on this system"

[%%endif]

let nice i = improve (fun () -> Unix.nice i) (fun () -> [ "priority", Int.sexp_of_t i ])
let stdin = Unix.stdin
let stdout = Unix.stdout
let stderr = Unix.stderr

type open_flag = Unix.open_flag =
  | O_RDONLY
  | O_WRONLY
  | O_RDWR
  | O_NONBLOCK
  | O_APPEND
  | O_CREAT
  | O_TRUNC
  | O_EXCL
  | O_NOCTTY
  | O_DSYNC
  | O_SYNC
  | O_RSYNC
  | O_SHARE_DELETE
  | O_CLOEXEC
  | O_KEEPEXEC [@if ocaml_version >= (4, 05, 0)]
[@@deriving sexp]

include struct
  let _ = fun (_ : open_flag) -> ()

  let open_flag_of_sexp =
    (let error_source__344_ = "core_unix.ml.before-ppx.open_flag" in
     function
     | Sexplib0.Sexp.Atom ("o_RDONLY" | "O_RDONLY") -> O_RDONLY
     | Sexplib0.Sexp.Atom ("o_WRONLY" | "O_WRONLY") -> O_WRONLY
     | Sexplib0.Sexp.Atom ("o_RDWR" | "O_RDWR") -> O_RDWR
     | Sexplib0.Sexp.Atom ("o_NONBLOCK" | "O_NONBLOCK") -> O_NONBLOCK
     | Sexplib0.Sexp.Atom ("o_APPEND" | "O_APPEND") -> O_APPEND
     | Sexplib0.Sexp.Atom ("o_CREAT" | "O_CREAT") -> O_CREAT
     | Sexplib0.Sexp.Atom ("o_TRUNC" | "O_TRUNC") -> O_TRUNC
     | Sexplib0.Sexp.Atom ("o_EXCL" | "O_EXCL") -> O_EXCL
     | Sexplib0.Sexp.Atom ("o_NOCTTY" | "O_NOCTTY") -> O_NOCTTY
     | Sexplib0.Sexp.Atom ("o_DSYNC" | "O_DSYNC") -> O_DSYNC
     | Sexplib0.Sexp.Atom ("o_SYNC" | "O_SYNC") -> O_SYNC
     | Sexplib0.Sexp.Atom ("o_RSYNC" | "O_RSYNC") -> O_RSYNC
     | Sexplib0.Sexp.Atom ("o_SHARE_DELETE" | "O_SHARE_DELETE") -> O_SHARE_DELETE
     | Sexplib0.Sexp.Atom ("o_CLOEXEC" | "O_CLOEXEC") -> O_CLOEXEC
     | Sexplib0.Sexp.Atom ("o_KEEPEXEC" | "O_KEEPEXEC") -> O_KEEPEXEC
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_RDONLY" | "O_RDONLY") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_WRONLY" | "O_WRONLY") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_RDWR" | "O_RDWR") :: _) as sexp__345_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_NONBLOCK" | "O_NONBLOCK") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_APPEND" | "O_APPEND") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_CREAT" | "O_CREAT") :: _) as sexp__345_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_TRUNC" | "O_TRUNC") :: _) as sexp__345_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_EXCL" | "O_EXCL") :: _) as sexp__345_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_NOCTTY" | "O_NOCTTY") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_DSYNC" | "O_DSYNC") :: _) as sexp__345_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_SYNC" | "O_SYNC") :: _) as sexp__345_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_RSYNC" | "O_RSYNC") :: _) as sexp__345_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_SHARE_DELETE" | "O_SHARE_DELETE") :: _)
       as sexp__345_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_CLOEXEC" | "O_CLOEXEC") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("o_KEEPEXEC" | "O_KEEPEXEC") :: _) as
       sexp__345_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__344_ sexp__345_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__343_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__344_ sexp__343_
     | Sexplib0.Sexp.List [] as sexp__343_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__344_ sexp__343_
     | sexp__343_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__344_ sexp__343_
     : Sexplib0.Sexp.t -> open_flag)
  ;;

  let _ = open_flag_of_sexp

  let sexp_of_open_flag =
    (function
     | O_RDONLY -> Sexplib0.Sexp.Atom "O_RDONLY"
     | O_WRONLY -> Sexplib0.Sexp.Atom "O_WRONLY"
     | O_RDWR -> Sexplib0.Sexp.Atom "O_RDWR"
     | O_NONBLOCK -> Sexplib0.Sexp.Atom "O_NONBLOCK"
     | O_APPEND -> Sexplib0.Sexp.Atom "O_APPEND"
     | O_CREAT -> Sexplib0.Sexp.Atom "O_CREAT"
     | O_TRUNC -> Sexplib0.Sexp.Atom "O_TRUNC"
     | O_EXCL -> Sexplib0.Sexp.Atom "O_EXCL"
     | O_NOCTTY -> Sexplib0.Sexp.Atom "O_NOCTTY"
     | O_DSYNC -> Sexplib0.Sexp.Atom "O_DSYNC"
     | O_SYNC -> Sexplib0.Sexp.Atom "O_SYNC"
     | O_RSYNC -> Sexplib0.Sexp.Atom "O_RSYNC"
     | O_SHARE_DELETE -> Sexplib0.Sexp.Atom "O_SHARE_DELETE"
     | O_CLOEXEC -> Sexplib0.Sexp.Atom "O_CLOEXEC"
     | O_KEEPEXEC -> Sexplib0.Sexp.Atom "O_KEEPEXEC"
     : open_flag -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_open_flag
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type file_perm = int [@@deriving of_sexp]

include struct
  let _ = fun (_ : file_perm) -> ()
  let file_perm_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> file_perm)
  let _ = file_perm_of_sexp
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sexp_of_file_perm fp = Sexp.Atom (Printf.sprintf "0o%03o" fp)

let is_rw_open_flag = function
  | O_RDONLY | O_WRONLY | O_RDWR -> true
  | _ -> false
;;

let openfile ?(perm = 0o644) ~mode filename =
  let mode_sexp () = sexp_of_list sexp_of_open_flag mode in
  if not (List.exists mode ~f:is_rw_open_flag)
  then
    failwithf
      "Unix.openfile: no read or write flag specified in mode: %s"
      (Sexp.to_string (mode_sexp ()))
      ()
  else
    improve
      (fun () -> Unix.openfile filename ~mode ~perm)
      (fun () -> [ filename_r filename; "mode", mode_sexp (); file_perm_r perm ])
;;

let close ?restart = unary_fd ?restart Unix.close
let with_close fd ~f = protect ~f:(fun () -> f fd) ~finally:(fun () -> close fd)
let with_file ?perm file ~mode ~f = with_close (openfile file ~mode ?perm) ~f

let read_write f ?restart ?pos ?len fd ~buf =
  let (pos : int), (len : int) =
    Ordered_collection_common.get_pos_len_exn
      ()
      ?pos
      ?len
      ~total_length:(Bytes.length buf)
  in
  improve
    ?restart
    (fun () -> f fd ~buf ~pos ~len)
    (fun () -> [ fd_r fd; "pos", Int.sexp_of_t pos; len_r len ])
;;

let read_write_string f ?restart ?pos ?len fd ~buf =
  let (pos : int), (len : int) =
    Ordered_collection_common.get_pos_len_exn
      ()
      ?pos
      ?len
      ~total_length:(String.length buf)
  in
  improve
    ?restart
    (fun () -> f fd ~buf ~pos ~len)
    (fun () -> [ fd_r fd; "pos", Int.sexp_of_t pos; len_r len ])
;;

let read = read_write Unix.read
let write = read_write Unix.write ?restart:None
let write_substring = read_write_string Unix.write_substring ?restart:None
let single_write = read_write Unix.single_write
let single_write_substring = read_write_string Unix.single_write_substring
let in_channel_of_descr = Unix.in_channel_of_descr
let out_channel_of_descr = Unix.out_channel_of_descr
let descr_of_in_channel = Unix.descr_of_in_channel
let descr_of_out_channel = Unix.descr_of_out_channel

type seek_command = Unix.seek_command =
  | SEEK_SET
  | SEEK_CUR
  | SEEK_END
[@@deriving sexp]

include struct
  let _ = fun (_ : seek_command) -> ()

  let seek_command_of_sexp =
    (let error_source__349_ = "core_unix.ml.before-ppx.seek_command" in
     function
     | Sexplib0.Sexp.Atom ("sEEK_SET" | "SEEK_SET") -> SEEK_SET
     | Sexplib0.Sexp.Atom ("sEEK_CUR" | "SEEK_CUR") -> SEEK_CUR
     | Sexplib0.Sexp.Atom ("sEEK_END" | "SEEK_END") -> SEEK_END
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sEEK_SET" | "SEEK_SET") :: _) as
       sexp__350_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__349_ sexp__350_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sEEK_CUR" | "SEEK_CUR") :: _) as
       sexp__350_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__349_ sexp__350_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sEEK_END" | "SEEK_END") :: _) as
       sexp__350_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__349_ sexp__350_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__348_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__349_ sexp__348_
     | Sexplib0.Sexp.List [] as sexp__348_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__349_ sexp__348_
     | sexp__348_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__349_ sexp__348_
     : Sexplib0.Sexp.t -> seek_command)
  ;;

  let _ = seek_command_of_sexp

  let sexp_of_seek_command =
    (function
     | SEEK_SET -> Sexplib0.Sexp.Atom "SEEK_SET"
     | SEEK_CUR -> Sexplib0.Sexp.Atom "SEEK_CUR"
     | SEEK_END -> Sexplib0.Sexp.Atom "SEEK_END"
     : seek_command -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_seek_command
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type file_kind = Unix.file_kind =
  | S_REG
  | S_DIR
  | S_CHR
  | S_BLK
  | S_LNK
  | S_FIFO
  | S_SOCK
[@@deriving sexp]

include struct
  let _ = fun (_ : file_kind) -> ()

  let file_kind_of_sexp =
    (let error_source__353_ = "core_unix.ml.before-ppx.file_kind" in
     function
     | Sexplib0.Sexp.Atom ("s_REG" | "S_REG") -> S_REG
     | Sexplib0.Sexp.Atom ("s_DIR" | "S_DIR") -> S_DIR
     | Sexplib0.Sexp.Atom ("s_CHR" | "S_CHR") -> S_CHR
     | Sexplib0.Sexp.Atom ("s_BLK" | "S_BLK") -> S_BLK
     | Sexplib0.Sexp.Atom ("s_LNK" | "S_LNK") -> S_LNK
     | Sexplib0.Sexp.Atom ("s_FIFO" | "S_FIFO") -> S_FIFO
     | Sexplib0.Sexp.Atom ("s_SOCK" | "S_SOCK") -> S_SOCK
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_REG" | "S_REG") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_DIR" | "S_DIR") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_CHR" | "S_CHR") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_BLK" | "S_BLK") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_LNK" | "S_LNK") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_FIFO" | "S_FIFO") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("s_SOCK" | "S_SOCK") :: _) as sexp__354_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__353_ sexp__354_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__352_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__353_ sexp__352_
     | Sexplib0.Sexp.List [] as sexp__352_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__353_ sexp__352_
     | sexp__352_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__353_ sexp__352_
     : Sexplib0.Sexp.t -> file_kind)
  ;;

  let _ = file_kind_of_sexp

  let sexp_of_file_kind =
    (function
     | S_REG -> Sexplib0.Sexp.Atom "S_REG"
     | S_DIR -> Sexplib0.Sexp.Atom "S_DIR"
     | S_CHR -> Sexplib0.Sexp.Atom "S_CHR"
     | S_BLK -> Sexplib0.Sexp.Atom "S_BLK"
     | S_LNK -> Sexplib0.Sexp.Atom "S_LNK"
     | S_FIFO -> Sexplib0.Sexp.Atom "S_FIFO"
     | S_SOCK -> Sexplib0.Sexp.Atom "S_SOCK"
     : file_kind -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_file_kind
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let isatty = unary_fd Unix.isatty

module Native_file = struct
  type stats = Unix.stats =
    { st_dev : int
    ; st_ino : int
    ; st_kind : file_kind
    ; st_perm : file_perm
    ; st_nlink : int
    ; st_uid : int
    ; st_gid : int
    ; st_rdev : int
    ; st_size : int
    ; st_atime : float
    ; st_mtime : float
    ; st_ctime : float
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : stats) -> ()

    let stats_of_sexp =
      (let error_source__356_ = "core_unix.ml.before-ppx.Native_file.stats" in
       fun x__357_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__356_
           ~fields:
             (Field
                { name = "st_dev"
                ; kind = Required
                ; conv = int_of_sexp
                ; rest =
                    Field
                      { name = "st_ino"
                      ; kind = Required
                      ; conv = int_of_sexp
                      ; rest =
                          Field
                            { name = "st_kind"
                            ; kind = Required
                            ; conv = file_kind_of_sexp
                            ; rest =
                                Field
                                  { name = "st_perm"
                                  ; kind = Required
                                  ; conv = file_perm_of_sexp
                                  ; rest =
                                      Field
                                        { name = "st_nlink"
                                        ; kind = Required
                                        ; conv = int_of_sexp
                                        ; rest =
                                            Field
                                              { name = "st_uid"
                                              ; kind = Required
                                              ; conv = int_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "st_gid"
                                                    ; kind = Required
                                                    ; conv = int_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "st_rdev"
                                                          ; kind = Required
                                                          ; conv = int_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "st_size"
                                                                ; kind = Required
                                                                ; conv = int_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name = "st_atime"
                                                                      ; kind = Required
                                                                      ; conv =
                                                                          float_of_sexp
                                                                      ; rest =
                                                                          Field
                                                                            { name =
                                                                                "st_mtime"
                                                                            ; kind =
                                                                                Required
                                                                            ; conv =
                                                                                float_of_sexp
                                                                            ; rest =
                                                                                Field
                                                                                  { name =
                                                                                      "st_ctime"
                                                                                  ; kind =
                                                                                      Required
                                                                                  ; conv =
                                                                                      float_of_sexp
                                                                                  ; rest =
                                                                                      Empty
                                                                                  }
                                                                            }
                                                                      }
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "st_dev" -> 0
             | "st_ino" -> 1
             | "st_kind" -> 2
             | "st_perm" -> 3
             | "st_nlink" -> 4
             | "st_uid" -> 5
             | "st_gid" -> 6
             | "st_rdev" -> 7
             | "st_size" -> 8
             | "st_atime" -> 9
             | "st_mtime" -> 10
             | "st_ctime" -> 11
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( st_dev
               , ( st_ino
                 , ( st_kind
                   , ( st_perm
                     , ( st_nlink
                       , ( st_uid
                         , ( st_gid
                           , (st_rdev, (st_size, (st_atime, (st_mtime, (st_ctime, ())))))
                           ) ) ) ) ) ) ) ->
             ({ st_dev
              ; st_ino
              ; st_kind
              ; st_perm
              ; st_nlink
              ; st_uid
              ; st_gid
              ; st_rdev
              ; st_size
              ; st_atime
              ; st_mtime
              ; st_ctime
              }
              : stats))
           x__357_
       : Sexplib0.Sexp.t -> stats)
    ;;

    let _ = stats_of_sexp

    let sexp_of_stats =
      (fun { st_dev = st_dev__359_
           ; st_ino = st_ino__361_
           ; st_kind = st_kind__363_
           ; st_perm = st_perm__365_
           ; st_nlink = st_nlink__367_
           ; st_uid = st_uid__369_
           ; st_gid = st_gid__371_
           ; st_rdev = st_rdev__373_
           ; st_size = st_size__375_
           ; st_atime = st_atime__377_
           ; st_mtime = st_mtime__379_
           ; st_ctime = st_ctime__381_
           } ->
         let bnds__358_ = ([] : _ Stdlib.List.t) in
         let bnds__358_ =
           let arg__382_ = sexp_of_float st_ctime__381_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_ctime"; arg__382_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__380_ = sexp_of_float st_mtime__379_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_mtime"; arg__380_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__378_ = sexp_of_float st_atime__377_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_atime"; arg__378_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__376_ = sexp_of_int st_size__375_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_size"; arg__376_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__374_ = sexp_of_int st_rdev__373_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_rdev"; arg__374_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__372_ = sexp_of_int st_gid__371_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_gid"; arg__372_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__370_ = sexp_of_int st_uid__369_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_uid"; arg__370_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__368_ = sexp_of_int st_nlink__367_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_nlink"; arg__368_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__366_ = sexp_of_file_perm st_perm__365_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_perm"; arg__366_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__364_ = sexp_of_file_kind st_kind__363_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_kind"; arg__364_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__362_ = sexp_of_int st_ino__361_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_ino"; arg__362_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         let bnds__358_ =
           let arg__360_ = sexp_of_int st_dev__359_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_dev"; arg__360_ ] :: bnds__358_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__358_
       : stats -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_stats
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let stat = unary_filename Unix.stat
  let lstat = unary_filename Unix.lstat
  let fstat = unary_fd Unix.fstat

  let lseek fd pos ~mode =
    improve
      (fun () -> Unix.lseek fd pos ~mode)
      (fun () -> [ fd_r fd; "pos", Int.sexp_of_t pos; "mode", sexp_of_seek_command mode ])
  ;;

  let truncate filename ~len =
    improve
      (fun () -> Unix.truncate filename ~len)
      (fun () -> [ filename_r filename; len_r len ])
  ;;

  let ftruncate fd ~len =
    improve (fun () -> Unix.ftruncate fd ~len) (fun () -> [ fd_r fd; len_r len ])
  ;;
end

type lock_command = Unix.lock_command =
  | F_ULOCK
  | F_LOCK
  | F_TLOCK
  | F_TEST
  | F_RLOCK
  | F_TRLOCK
[@@deriving sexp]

include struct
  let _ = fun (_ : lock_command) -> ()

  let lock_command_of_sexp =
    (let error_source__385_ = "core_unix.ml.before-ppx.lock_command" in
     function
     | Sexplib0.Sexp.Atom ("f_ULOCK" | "F_ULOCK") -> F_ULOCK
     | Sexplib0.Sexp.Atom ("f_LOCK" | "F_LOCK") -> F_LOCK
     | Sexplib0.Sexp.Atom ("f_TLOCK" | "F_TLOCK") -> F_TLOCK
     | Sexplib0.Sexp.Atom ("f_TEST" | "F_TEST") -> F_TEST
     | Sexplib0.Sexp.Atom ("f_RLOCK" | "F_RLOCK") -> F_RLOCK
     | Sexplib0.Sexp.Atom ("f_TRLOCK" | "F_TRLOCK") -> F_TRLOCK
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_ULOCK" | "F_ULOCK") :: _) as sexp__386_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_LOCK" | "F_LOCK") :: _) as sexp__386_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_TLOCK" | "F_TLOCK") :: _) as sexp__386_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_TEST" | "F_TEST") :: _) as sexp__386_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_RLOCK" | "F_RLOCK") :: _) as sexp__386_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_TRLOCK" | "F_TRLOCK") :: _) as
       sexp__386_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__385_ sexp__386_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__384_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__385_ sexp__384_
     | Sexplib0.Sexp.List [] as sexp__384_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__385_ sexp__384_
     | sexp__384_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__385_ sexp__384_
     : Sexplib0.Sexp.t -> lock_command)
  ;;

  let _ = lock_command_of_sexp

  let sexp_of_lock_command =
    (function
     | F_ULOCK -> Sexplib0.Sexp.Atom "F_ULOCK"
     | F_LOCK -> Sexplib0.Sexp.Atom "F_LOCK"
     | F_TLOCK -> Sexplib0.Sexp.Atom "F_TLOCK"
     | F_TEST -> Sexplib0.Sexp.Atom "F_TEST"
     | F_RLOCK -> Sexplib0.Sexp.Atom "F_RLOCK"
     | F_TRLOCK -> Sexplib0.Sexp.Atom "F_TRLOCK"
     : lock_command -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_lock_command
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let lockf fd ~mode ~len =
  let len =
    try Int64.to_int_exn len with
    | _ -> failwith "~len passed to Unix.lockf too large to fit in native int"
  in
  improve
    (fun () -> Unix.lockf fd ~mode ~len)
    (fun () -> [ fd_r fd; "mode", sexp_of_lock_command mode; len_r len ])
;;

module Flock_command : sig
  type t

  val lock_shared : t
  val lock_exclusive : t
  val unlock : t
end = struct
  type t = int

  let lock_shared = 0
  let lock_exclusive = 1
  let unlock = 2
end

external real_flock
  :  blocking:bool
  -> File_descr.t
  -> Flock_command.t
  -> bool
  = "core_unix_flock"

let flock = real_flock ~blocking:false
let flock_blocking fd command = assert (real_flock ~blocking:true fd command)

let lseek fd pos ~mode =
  improve
    (fun () -> Unix.LargeFile.lseek fd pos ~mode)
    (fun () -> [ fd_r fd; "pos", Int64.sexp_of_t pos; "mode", sexp_of_seek_command mode ])
;;

let len64_r len = "len", Int64.sexp_of_t len

let truncate filename ~len =
  improve
    (fun () -> Unix.LargeFile.truncate filename ~len)
    (fun () -> [ filename_r filename; len64_r len ])
;;

let ftruncate fd ~len =
  improve
    (fun () -> Unix.LargeFile.ftruncate fd ~len)
    (fun () -> [ fd_r fd; len64_r len ])
;;

type stats = Unix.LargeFile.stats =
  { st_dev : int
  ; st_ino : int
  ; st_kind : file_kind
  ; st_perm : file_perm
  ; st_nlink : int
  ; st_uid : int
  ; st_gid : int
  ; st_rdev : int
  ; st_size : int64
  ; st_atime : float
  ; st_mtime : float
  ; st_ctime : float
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : stats) -> ()

  let stats_of_sexp =
    (let error_source__388_ = "core_unix.ml.before-ppx.stats" in
     fun x__389_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__388_
         ~fields:
           (Field
              { name = "st_dev"
              ; kind = Required
              ; conv = int_of_sexp
              ; rest =
                  Field
                    { name = "st_ino"
                    ; kind = Required
                    ; conv = int_of_sexp
                    ; rest =
                        Field
                          { name = "st_kind"
                          ; kind = Required
                          ; conv = file_kind_of_sexp
                          ; rest =
                              Field
                                { name = "st_perm"
                                ; kind = Required
                                ; conv = file_perm_of_sexp
                                ; rest =
                                    Field
                                      { name = "st_nlink"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "st_uid"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "st_gid"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "st_rdev"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "st_size"
                                                              ; kind = Required
                                                              ; conv = int64_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name = "st_atime"
                                                                    ; kind = Required
                                                                    ; conv = float_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "st_mtime"
                                                                          ; kind =
                                                                              Required
                                                                          ; conv =
                                                                              float_of_sexp
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "st_ctime"
                                                                                ; kind =
                                                                                    Required
                                                                                ; conv =
                                                                                    float_of_sexp
                                                                                ; rest =
                                                                                    Empty
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    }
              })
         ~index_of_field:(function
           | "st_dev" -> 0
           | "st_ino" -> 1
           | "st_kind" -> 2
           | "st_perm" -> 3
           | "st_nlink" -> 4
           | "st_uid" -> 5
           | "st_gid" -> 6
           | "st_rdev" -> 7
           | "st_size" -> 8
           | "st_atime" -> 9
           | "st_mtime" -> 10
           | "st_ctime" -> 11
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:
           (fun
             ( st_dev
             , ( st_ino
               , ( st_kind
                 , ( st_perm
                   , ( st_nlink
                     , ( st_uid
                       , ( st_gid
                         , (st_rdev, (st_size, (st_atime, (st_mtime, (st_ctime, ()))))) )
                       ) ) ) ) ) ) ->
           ({ st_dev
            ; st_ino
            ; st_kind
            ; st_perm
            ; st_nlink
            ; st_uid
            ; st_gid
            ; st_rdev
            ; st_size
            ; st_atime
            ; st_mtime
            ; st_ctime
            }
            : stats))
         x__389_
     : Sexplib0.Sexp.t -> stats)
  ;;

  let _ = stats_of_sexp

  let sexp_of_stats =
    (fun { st_dev = st_dev__391_
         ; st_ino = st_ino__393_
         ; st_kind = st_kind__395_
         ; st_perm = st_perm__397_
         ; st_nlink = st_nlink__399_
         ; st_uid = st_uid__401_
         ; st_gid = st_gid__403_
         ; st_rdev = st_rdev__405_
         ; st_size = st_size__407_
         ; st_atime = st_atime__409_
         ; st_mtime = st_mtime__411_
         ; st_ctime = st_ctime__413_
         } ->
       let bnds__390_ = ([] : _ Stdlib.List.t) in
       let bnds__390_ =
         let arg__414_ = sexp_of_float st_ctime__413_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_ctime"; arg__414_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__412_ = sexp_of_float st_mtime__411_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_mtime"; arg__412_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__410_ = sexp_of_float st_atime__409_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_atime"; arg__410_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__408_ = sexp_of_int64 st_size__407_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_size"; arg__408_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__406_ = sexp_of_int st_rdev__405_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_rdev"; arg__406_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__404_ = sexp_of_int st_gid__403_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_gid"; arg__404_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__402_ = sexp_of_int st_uid__401_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_uid"; arg__402_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__400_ = sexp_of_int st_nlink__399_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_nlink"; arg__400_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__398_ = sexp_of_file_perm st_perm__397_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_perm"; arg__398_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__396_ = sexp_of_file_kind st_kind__395_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_kind"; arg__396_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__394_ = sexp_of_int st_ino__393_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_ino"; arg__394_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       let bnds__390_ =
         let arg__392_ = sexp_of_int st_dev__391_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "st_dev"; arg__392_ ] :: bnds__390_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__390_
     : stats -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_stats
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let stat = unary_filename Unix.LargeFile.stat
let lstat = unary_filename Unix.LargeFile.lstat
let fstat = unary_fd Unix.LargeFile.fstat

let src_dst f ~src ~dst =
  improve (fun () -> f ~src ~dst) (fun () -> [ "src", atom src; "dst", atom dst ])
;;

let unlink = unary_filename Unix.unlink
let rename = src_dst Unix.rename

[%%if ocaml_version >= (4, 08, 0)]

let unix_link ~src ~dst = Unix.link ~src ~dst ?follow:None

[%%else]

let unix_link ~src ~dst = Unix.link ~src ~dst

[%%endif]

let link ?(force = false) ~target ~link_name () =
  improve
    (fun () ->
       if force
       then (
         try Unix.unlink link_name with
         | Unix_error (Unix.ENOENT, _, _) -> ());
       unix_link ~src:target ~dst:link_name)
    (fun () -> [ "target", atom target; "link_name", atom link_name ])
;;

let map_file fd ?pos kind layout ~shared dims =
  Unix.map_file fd ?pos ~kind ~layout ~shared ~dims
;;

type access_permission = Unix.access_permission =
  | R_OK
  | W_OK
  | X_OK
  | F_OK
[@@deriving sexp]

include struct
  let _ = fun (_ : access_permission) -> ()

  let access_permission_of_sexp =
    (let error_source__417_ = "core_unix.ml.before-ppx.access_permission" in
     function
     | Sexplib0.Sexp.Atom ("r_OK" | "R_OK") -> R_OK
     | Sexplib0.Sexp.Atom ("w_OK" | "W_OK") -> W_OK
     | Sexplib0.Sexp.Atom ("x_OK" | "X_OK") -> X_OK
     | Sexplib0.Sexp.Atom ("f_OK" | "F_OK") -> F_OK
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("r_OK" | "R_OK") :: _) as sexp__418_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__417_ sexp__418_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("w_OK" | "W_OK") :: _) as sexp__418_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__417_ sexp__418_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("x_OK" | "X_OK") :: _) as sexp__418_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__417_ sexp__418_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("f_OK" | "F_OK") :: _) as sexp__418_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__417_ sexp__418_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__416_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__417_ sexp__416_
     | Sexplib0.Sexp.List [] as sexp__416_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__417_ sexp__416_
     | sexp__416_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__417_ sexp__416_
     : Sexplib0.Sexp.t -> access_permission)
  ;;

  let _ = access_permission_of_sexp

  let sexp_of_access_permission =
    (function
     | R_OK -> Sexplib0.Sexp.Atom "R_OK"
     | W_OK -> Sexplib0.Sexp.Atom "W_OK"
     | X_OK -> Sexplib0.Sexp.Atom "X_OK"
     | F_OK -> Sexplib0.Sexp.Atom "F_OK"
     : access_permission -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_access_permission
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let chmod filename ~perm =
  improve
    (fun () -> Unix.chmod filename ~perm)
    (fun () -> [ filename_r filename; file_perm_r perm ])
;;

let fchmod fd ~perm =
  improve (fun () -> Unix.fchmod fd ~perm) (fun () -> [ fd_r fd; file_perm_r perm ])
;;

let chown filename ~uid ~gid =
  improve
    (fun () -> Unix.chown filename ~uid ~gid)
    (fun () -> [ filename_r filename; uid_r uid; gid_r gid ])
;;

let fchown fd ~uid ~gid =
  improve
    (fun () -> Unix.fchown fd ~uid ~gid)
    (fun () -> [ fd_r fd; uid_r uid; gid_r gid ])
;;

let umask mode =
  improve
    (fun () -> Unix.umask mode)
    (fun () -> [ "mode", atom (Printf.sprintf "0o%o" mode) ])
;;

let access filename ~perm =
  improve
    (fun () -> Unix.access filename ~perm)
    (fun () ->
       [ filename_r filename; "perm", sexp_of_list sexp_of_access_permission perm ])
;;

let access filename perm =
  Result.try_with (fun () ->
    access
      filename
      ~perm:
        (List.map perm ~f:(function
           | `Read -> Unix.R_OK
           | `Write -> Unix.W_OK
           | `Exec -> Unix.X_OK
           | `Exists -> Unix.F_OK)))
;;

let access_exn filename perm = Result.ok_exn (access filename perm)

external remove : string -> unit = "core_unix_remove"

let remove = unary_filename remove

let dup ?close_on_exec fd =
  improve
    (fun () -> Unix.dup ?cloexec:close_on_exec fd)
    (fun () -> [ fd_r fd; close_on_exec_r close_on_exec ])
;;

let dup2 ?close_on_exec ~src ~dst () =
  improve
    (fun () -> Unix.dup2 ?cloexec:close_on_exec ~src ~dst)
    (fun () ->
       [ "src", File_descr.sexp_of_t src
       ; "dst", File_descr.sexp_of_t dst
       ; close_on_exec_r close_on_exec
       ])
;;

let set_nonblock = unary_fd Unix.set_nonblock
let clear_nonblock = unary_fd Unix.clear_nonblock
let set_close_on_exec = unary_fd Unix.set_close_on_exec
let clear_close_on_exec = unary_fd Unix.clear_close_on_exec

external get_close_on_exec : Unix.file_descr -> bool = "core_unix_get_close_on_exec"

module Open_flags = struct
  external append : unit -> Int63.t = "unix_O_APPEND"
  external async : unit -> Int63.t = "unix_O_ASYNC"
  external cloexec : unit -> Int63.t = "unix_O_CLOEXEC"
  external creat : unit -> Int63.t = "unix_O_CREAT"
  external direct : unit -> Int63.t = "unix_O_DIRECT"
  external directory : unit -> Int63.t = "unix_O_DIRECTORY"
  external dsync : unit -> Int63.t = "unix_O_DSYNC"
  external excl : unit -> Int63.t = "unix_O_EXCL"
  external noatime : unit -> Int63.t = "unix_O_NOATIME"
  external noctty : unit -> Int63.t = "unix_O_NOCTTY"
  external nofollow : unit -> Int63.t = "unix_O_NOFOLLOW"
  external nonblock : unit -> Int63.t = "unix_O_NONBLOCK"
  external rdonly : unit -> Int63.t = "unix_O_RDONLY"
  external rdwr : unit -> Int63.t = "unix_O_RDWR"
  external rsync : unit -> Int63.t = "unix_O_RSYNC"
  external sync : unit -> Int63.t = "unix_O_SYNC"
  external trunc : unit -> Int63.t = "unix_O_TRUNC"
  external wronly : unit -> Int63.t = "unix_O_WRONLY"

  let append = append ()
  let async = async ()
  let cloexec = cloexec ()
  let creat = creat ()
  let direct = direct ()
  let directory = directory ()
  let dsync = dsync ()
  let excl = excl ()
  let noatime = noatime ()
  let noctty = noctty ()
  let nofollow = nofollow ()
  let nonblock = nonblock ()
  let rdonly = rdonly ()
  let rdwr = rdwr ()
  let rsync = rsync ()
  let sync = sync ()
  let trunc = trunc ()
  let wronly = wronly ()

  let known =
    [ append, "append"
    ; async, "async"
    ; cloexec, "cloexec"
    ; creat, "creat"
    ; direct, "direct"
    ; directory, "directory"
    ; dsync, "dsync"
    ; excl, "excl"
    ; noatime, "noatime"
    ; noctty, "noctty"
    ; nofollow, "nofollow"
    ; nonblock, "nonblock"
    ; rsync, "rsync"
    ; sync, "sync"
    ; trunc, "trunc"
    ]
  ;;

  let access_modes = [ rdonly, "rdonly"; rdwr, "rdwr"; wronly, "wronly" ]

  include Flags.Make (struct
      let allow_intersecting = true
      let should_print_error = true
      let known = known
      let remove_zero_flags = true
    end)

  let access_mode t = Int63.bit_and t (Int63.of_int 3)
  let can_read t = access_mode t = rdonly || access_mode t = rdwr
  let can_write t = access_mode t = wronly || access_mode t = rdwr

  let sexp_of_t t =
    let a = access_mode t in
    let t, prefix =
      match List.find access_modes ~f:(fun (a', _) -> a = a') with
      | None -> t, []
      | Some (_, name) -> t - a, [ Sexp.Atom name ]
    in
    let rest =
      match sexp_of_t t with
      | Sexp.Atom _ as s -> [ s ]
      | Sexp.List l -> l
    in
    Sexp.List (prefix @ rest)
  ;;
end

let fcntl_getfl, fcntl_setfl =
  let module M = struct
    external unix_fcntl
      :  Unix.file_descr
      -> Int63.t
      -> Int63.t
      -> Int63.t
      = "core_unix_fcntl"

    external getfl : unit -> Int63.t = "unix_F_GETFL"
    external setfl : unit -> Int63.t = "unix_F_SETFL"

    let getfl = getfl ()
    let setfl = setfl ()
  end
  in
  let open M in
  let fcntl_getfl fd = unix_fcntl fd getfl Int63.zero in
  let fcntl_setfl fd flags =
    let result = unix_fcntl fd setfl flags in
    assert (Int63.equal result Int63.zero)
  in
  fcntl_getfl, fcntl_setfl
;;

module Mkdir : sig
  val mkdir : ?perm:file_perm -> string -> unit
  val mkdir_p : ?perm:file_perm -> string -> unit
end = struct
  let improve_mkdir mkdir dirname ~perm =
    improve
      (fun () -> mkdir dirname ~perm)
      (fun () -> [ dirname_r dirname; file_perm_r perm ])
  [@@inline always]
  ;;

  let mkdir = improve_mkdir Unix.mkdir

  let mkdir_idempotent dirname ~perm =
    match Unix.mkdir dirname ~perm with
    | () -> ()
    | exception Unix_error ((EEXIST | EISDIR), _, _) -> ()
  ;;

  let mkdir_idempotent = improve_mkdir mkdir_idempotent

  let rec mkdir_p dir ~perm =
    match mkdir_idempotent ~perm dir with
    | () -> ()
    | exception (Unix_error (ENOENT, _, _) as exn) ->
      let parent = Filename.dirname dir in
      if Filename.( = ) parent dir
      then raise exn
      else (
        mkdir_p ~perm parent;
        mkdir_idempotent ~perm dir)
  ;;

  let mkdir ?(perm = 0o777) dir = mkdir ~perm dir
  let mkdir_p ?(perm = 0o777) dir = mkdir_p ~perm dir
end

include Mkdir

let rmdir = unary_dirname Unix.rmdir
let chdir = unary_dirname Unix.chdir
let getcwd = Unix.getcwd
let chroot = unary_dirname Unix.chroot

type dir_handle = Unix.dir_handle

let opendir ?restart = unary_dirname ?restart Unix.opendir
let readdir = unary_dir_handle Unix.readdir

let readdir_opt dh =
  match readdir dh with
  | entry -> Some entry
  | exception End_of_file -> None
;;

let rewinddir = unary_dir_handle Unix.rewinddir

let closedir =
  unary_dir_handle (fun dh ->
    try Unix.closedir dh with
    | Invalid_argument _ -> ())
;;

module Readdir_detailed = struct
  type t =
    { name : string
    ; inode : Nativeint.t
    ; kind : file_kind option
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { name = name__420_; inode = inode__422_; kind = kind__424_ } ->
         let bnds__419_ = ([] : _ Stdlib.List.t) in
         let bnds__419_ =
           let arg__425_ = sexp_of_option sexp_of_file_kind kind__424_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "kind"; arg__425_ ] :: bnds__419_
            : _ Stdlib.List.t)
         in
         let bnds__419_ =
           let arg__423_ = Nativeint.sexp_of_t inode__422_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "inode"; arg__423_ ] :: bnds__419_
            : _ Stdlib.List.t)
         in
         let bnds__419_ =
           let arg__421_ = sexp_of_string name__420_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__421_ ] :: bnds__419_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__419_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

external readdir_detailed
  :  Unix.dir_handle
  -> string * nativeint * int
  = "core_unix_readdir_detailed_stub"

let readdir_kind : int -> Unix.file_kind option = function
  | 0 -> Some S_BLK
  | 1 -> Some S_CHR
  | 2 -> Some S_DIR
  | 3 -> Some S_FIFO
  | 4 -> Some S_LNK
  | 5 -> Some S_REG
  | 6 -> Some S_SOCK
  | _ -> None
;;

let readdir_detailed_opt dh : Readdir_detailed.t option =
  match readdir_detailed dh with
  | name, inode, kind -> Some { name; inode; kind = readdir_kind kind }
  | exception End_of_file -> None
;;

let ls_dir_detailed path =
  Exn.protectx (opendir ~restart:true path) ~finally:closedir ~f:(fun fd ->
    let acc = ref [] in
    while
      match readdir_detailed_opt fd with
      | exception Unix_error (EINTR, _, _) -> true
      | None -> false
      | Some r ->
        (match r.name with
         | "." | ".." -> ()
         | _ -> acc := r :: !acc);
        true
    do
      ()
    done;
    !acc)
;;

let pipe ?close_on_exec () = Unix.pipe ?cloexec:close_on_exec ()

let mkfifo name ~perm =
  improve
    (fun () -> Unix.mkfifo name ~perm)
    (fun () -> [ "name", atom name; file_perm_r perm ])
;;

module Process_info = struct
  type t =
    { pid : Pid.t
    ; stdin : File_descr.t
    ; stdout : File_descr.t
    ; stderr : File_descr.t
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { pid = pid__427_
           ; stdin = stdin__429_
           ; stdout = stdout__431_
           ; stderr = stderr__433_
           } ->
         let bnds__426_ = ([] : _ Stdlib.List.t) in
         let bnds__426_ =
           let arg__434_ = File_descr.sexp_of_t stderr__433_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stderr"; arg__434_ ] :: bnds__426_
            : _ Stdlib.List.t)
         in
         let bnds__426_ =
           let arg__432_ = File_descr.sexp_of_t stdout__431_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stdout"; arg__432_ ] :: bnds__426_
            : _ Stdlib.List.t)
         in
         let bnds__426_ =
           let arg__430_ = File_descr.sexp_of_t stdin__429_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "stdin"; arg__430_ ] :: bnds__426_
            : _ Stdlib.List.t)
         in
         let bnds__426_ =
           let arg__428_ = Pid.sexp_of_t pid__427_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pid"; arg__428_ ] :: bnds__426_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__426_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Fd_spec = struct
  type 'maybe_fd t =
    | Generate : File_descr.t t
    | Use_this : File_descr.t -> [ `Did_not_create_fd ] t
end

module Pid_with_generated_fds = struct
  type ('stdin, 'stdout, 'stderr) t =
    { pid : Pid.t
    ; stdin : 'stdin
    ; stdout : 'stdout
    ; stderr : 'stderr
    }

  let process_info { pid; stdin; stdout; stderr } =
    { Process_info.pid; stdin; stdout; stderr }
  ;;
end

let create_process_internal ~stdin ~stdout ~stderr ~working_dir ~setpgid ~prog ~argv ~env =
  let close_on_err = ref [] in
  let close_on_success = ref [] in
  let safe_pipe ~is_stdin =
    let fd_for_parent, fd_for_child =
      let fd_read, fd_write = Spawn.safe_pipe () in
      if is_stdin then fd_write, fd_read else fd_read, fd_write
    in
    close_on_err := fd_for_parent :: fd_for_child :: !close_on_err;
    close_on_success := fd_for_child :: !close_on_success;
    fd_for_parent, fd_for_child
  in
  try
    let get_fds (type maybe_fd) (fd : maybe_fd Fd_spec.t) ~is_stdin
      : maybe_fd * File_descr.t
      =
      match fd with
      | Use_this fd -> `Did_not_create_fd, fd
      | Generate -> safe_pipe ~is_stdin
    in
    let stdin_for_parent, stdin_for_child = get_fds stdin ~is_stdin:true in
    let stdout_for_parent, stdout_for_child = get_fds stdout ~is_stdin:false in
    let stderr_for_parent, stderr_for_child = get_fds stderr ~is_stdin:false in
    let pid =
      Pid.of_int
        (Spawn.spawn
           ?cwd:(Option.map working_dir ~f:(fun x -> Spawn.Working_dir.Path x))
           ?setpgid
           ~prog
           ~argv
           ~env:(Spawn.Env.of_list env)
           ~stdin:stdin_for_child
           ~stdout:stdout_for_child
           ~stderr:stderr_for_child
           ())
    in
    List.iter !close_on_success ~f:close;
    { Pid_with_generated_fds.pid
    ; stdin = stdin_for_parent
    ; stdout = stdout_for_parent
    ; stderr = stderr_for_parent
    }
  with
  | exn ->
    List.iter !close_on_err ~f:(fun x ->
      try close x with
      | _ -> ());
    raise exn
;;

module Execvp_emulation : sig
  val run
    :  working_dir:string option
    -> spawn:(prog:string -> argv:string list -> 'a)
    -> prog:string
    -> args:string list
    -> ?prog_search_path:string list
    -> ?argv0:string
    -> unit
    -> 'a
end = struct
  let get_path prog_search_path =
    match prog_search_path with
    | Some [] -> invalid_arg "Core_unix.create_process: empty prog_search_path"
    | Some dirs -> dirs
    | None ->
      List.map
        ~f:(function
          | "" -> "."
          | x -> x)
        (Option.value_map
           ~f:(String.split ~on:':')
           ~default:[ "/bin"; "/usr/bin" ]
           (Sys.getenv "PATH"))
  ;;

  let candidate_paths ?prog_search_path prog =
    assert (String.equal Filename.dir_sep "/");
    if String.contains prog '/'
    then [ prog ]
    else List.map (get_path prog_search_path) ~f:(fun h -> h ^/ prog)
  ;;

  type 'a spawn1_result =
    | Eaccess of exn
    | Enoent_or_similar of exn
    | Ok of 'a

  let run ~working_dir ~spawn ~prog ~args ?prog_search_path ?argv0 () =
    let argv = Option.value argv0 ~default:prog :: args in
    let spawn1 candidate =
      match
        (try
           Unix.access
             (if not (Filename.is_relative candidate)
              then candidate
              else (
                match working_dir with
                | Some working_dir -> working_dir ^/ candidate
                | None -> candidate))
             ~perm:[ Unix.X_OK ]
         with
         | Unix_error (code, _, args) ->
           raise (Unix_error (code, "Core_unix.create_process", args)));
        spawn ~prog:candidate ~argv
      with
      | exception Unix_error (ENOEXEC, _, _) ->
        Ok (spawn ~prog:"/bin/sh" ~argv:("/bin/sh" :: candidate :: args))
      | exception (Unix_error (EACCES, _, _) as exn) -> Eaccess exn
      | exception
          (Unix_error
             ( (EISDIR | ELOOP | ENAMETOOLONG | ENODEV | ENOENT | ENOTDIR | ETIMEDOUT)
             , _
             , _ ) as exn) -> Enoent_or_similar exn
      | pid -> Ok pid
    in
    let rec go first_eaccess = function
      | [] -> assert false
      | candidate :: [] ->
        (match spawn1 candidate with
         | Eaccess exn | Enoent_or_similar exn ->
           raise (Option.value first_eaccess ~default:exn)
         | Ok pid -> pid)
      | candidate :: (_ :: _ as candidates) ->
        (match spawn1 candidate with
         | Eaccess exn ->
           let first_eaccess = Some (Option.value first_eaccess ~default:exn) in
           go first_eaccess candidates
         | Enoent_or_similar _exn -> go first_eaccess candidates
         | Ok pid -> pid)
    in
    go None (candidate_paths ?prog_search_path prog)
  ;;
end

let create_process_with_fds
      ?working_dir
      ?prog_search_path
      ?argv0
      ?setpgid
      ?(env = `Extend [])
      ~prog
      ~args
      ~stdin
      ~stdout
      ~stderr
      ()
  =
  improve
    (fun () ->
       let env_assignments = Env.expand env in
       Execvp_emulation.run
         ~prog
         ~args
         ?argv0
         ?prog_search_path
         ~working_dir
         ~spawn:(fun ~prog ~argv ->
           create_process_internal
             ~working_dir
             ~setpgid
             ~prog
             ~argv
             ~env:env_assignments
             ~stdin
             ~stdout
             ~stderr)
         ())
    (fun () ->
       (match working_dir with
        | None -> []
        | Some working_dir -> [ "working_dir", atom working_dir ])
       @ [ "prog", atom prog; "args", sexp_of_list atom args; "env", sexp_of_env env ])
;;

let create_process_env ?working_dir ?prog_search_path ?argv0 ?setpgid ~prog ~args ~env () =
  Pid_with_generated_fds.process_info
    (create_process_with_fds
       ?working_dir
       ?prog_search_path
       ?argv0
       ?setpgid
       ~stdin:Generate
       ~stdout:Generate
       ~stderr:Generate
       ~prog
       ~args
       ~env
       ())
;;

let create_process ~prog ~args =
  improve
    (fun () -> create_process_env ~prog ~args ~env:(`Extend []) ())
    (fun () -> [ "prog", atom prog; "args", sexp_of_list atom args ])
;;

let make_open_process f command =
  improve (fun () -> f command) (fun () -> [ "command", atom command ])
;;

let open_process_in = make_open_process Unix.open_process_in
let open_process_out = make_open_process Unix.open_process_out
let open_process = make_open_process Unix.open_process

module Process_channels = struct
  type t =
    { stdin : Out_channel.t
    ; stdout : In_channel.t
    ; stderr : In_channel.t
    }
end

let open_process_full command ~env =
  improve
    (fun () ->
       let stdout, stdin, stderr = Unix.open_process_full command ~env in
       { Process_channels.stdin; stdout; stderr })
    (fun () -> [ "command", atom command; "env", sexp_of_array atom env ])
;;

let close_process_in ic = Exit_or_signal.of_unix (Unix.close_process_in ic)
let close_process_out oc = Exit_or_signal.of_unix (Unix.close_process_out oc)
let close_process (ic, oc) = Exit_or_signal.of_unix (Unix.close_process (ic, oc))

let close_process_full c =
  let module C = Process_channels in
  Exit_or_signal.of_unix (Unix.close_process_full (c.C.stdout, c.C.stdin, c.C.stderr))
;;

external setpgid : int -> int -> unit = "core_unix_setpgid"
external getpgid : int -> int = "core_unix_getpgid"

let setpgid ~of_ ~to_ = setpgid (Pid.to_int of_) (Pid.to_int to_)

let getpgid pid =
  match getpgid (Pid.to_int pid) with
  | 0 -> None
  | pgid -> Some (Pid.of_int pgid)
;;

let symlink ~target ~link_name =
  improve
    (fun () -> Unix.symlink ?to_dir:None ~src:target ~dst:link_name)
    (fun () -> [ "target", atom target; "link_name", atom link_name ])
;;

let readlink = unary_filename Unix.readlink

module Select_fds = struct
  type t =
    { read : File_descr.t list
    ; write : File_descr.t list
    ; except : File_descr.t list
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { read = read__436_; write = write__438_; except = except__440_ } ->
         let bnds__435_ = ([] : _ Stdlib.List.t) in
         let bnds__435_ =
           let arg__441_ = sexp_of_list File_descr.sexp_of_t except__440_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "except"; arg__441_ ] :: bnds__435_
            : _ Stdlib.List.t)
         in
         let bnds__435_ =
           let arg__439_ = sexp_of_list File_descr.sexp_of_t write__438_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "write"; arg__439_ ] :: bnds__435_
            : _ Stdlib.List.t)
         in
         let bnds__435_ =
           let arg__437_ = sexp_of_list File_descr.sexp_of_t read__436_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "read"; arg__437_ ] :: bnds__435_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__435_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let empty = { read = []; write = []; except = [] }
end

type select_timeout =
  [ `Never
  | `Immediately
  | `After of Time_ns.Span.t
  ]
[@@deriving sexp_of]

include struct
  let _ = fun (_ : select_timeout) -> ()

  let sexp_of_select_timeout =
    (function
     | `Never -> Sexplib0.Sexp.Atom "Never"
     | `Immediately -> Sexplib0.Sexp.Atom "Immediately"
     | `After v__442_ ->
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "After"; Time_ns.Span.sexp_of_t v__442_ ]
     : select_timeout -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_select_timeout
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let select ?restart ~read ~write ~except ~timeout () =
  improve
    ?restart
    (fun () ->
       let timeout =
         match timeout with
         | `Never -> -1.
         | `Immediately -> 0.
         | `After span ->
           if Time_ns.Span.( < ) span Time_ns.Span.zero
           then 0.
           else Time_ns.Span.to_sec span
       in
       let read, write, except = Unix.select ~read ~write ~except ~timeout in
       { Select_fds.read; write; except })
    (fun () ->
       [ "read", sexp_of_list File_descr.sexp_of_t read
       ; "write", sexp_of_list File_descr.sexp_of_t write
       ; "except", sexp_of_list File_descr.sexp_of_t except
       ; "timeout", (sexp_of_select_timeout [@merlin.hide]) timeout
       ])
;;

let pause = Unix.pause

type process_times = Unix.process_times =
  { tms_utime : float
  ; tms_stime : float
  ; tms_cutime : float
  ; tms_cstime : float
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : process_times) -> ()

  let process_times_of_sexp =
    (let error_source__444_ = "core_unix.ml.before-ppx.process_times" in
     fun x__445_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__444_
         ~fields:
           (Field
              { name = "tms_utime"
              ; kind = Required
              ; conv = float_of_sexp
              ; rest =
                  Field
                    { name = "tms_stime"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest =
                        Field
                          { name = "tms_cutime"
                          ; kind = Required
                          ; conv = float_of_sexp
                          ; rest =
                              Field
                                { name = "tms_cstime"
                                ; kind = Required
                                ; conv = float_of_sexp
                                ; rest = Empty
                                }
                          }
                    }
              })
         ~index_of_field:(function
           | "tms_utime" -> 0
           | "tms_stime" -> 1
           | "tms_cutime" -> 2
           | "tms_cstime" -> 3
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:(fun (tms_utime, (tms_stime, (tms_cutime, (tms_cstime, ())))) ->
           ({ tms_utime; tms_stime; tms_cutime; tms_cstime } : process_times))
         x__445_
     : Sexplib0.Sexp.t -> process_times)
  ;;

  let _ = process_times_of_sexp

  let sexp_of_process_times =
    (fun { tms_utime = tms_utime__447_
         ; tms_stime = tms_stime__449_
         ; tms_cutime = tms_cutime__451_
         ; tms_cstime = tms_cstime__453_
         } ->
       let bnds__446_ = ([] : _ Stdlib.List.t) in
       let bnds__446_ =
         let arg__454_ = sexp_of_float tms_cstime__453_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tms_cstime"; arg__454_ ] :: bnds__446_
          : _ Stdlib.List.t)
       in
       let bnds__446_ =
         let arg__452_ = sexp_of_float tms_cutime__451_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tms_cutime"; arg__452_ ] :: bnds__446_
          : _ Stdlib.List.t)
       in
       let bnds__446_ =
         let arg__450_ = sexp_of_float tms_stime__449_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tms_stime"; arg__450_ ] :: bnds__446_
          : _ Stdlib.List.t)
       in
       let bnds__446_ =
         let arg__448_ = sexp_of_float tms_utime__447_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tms_utime"; arg__448_ ] :: bnds__446_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__446_
     : process_times -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_process_times
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Clock = struct
  type underlying = int

  type t =
    | Realtime
    | Monotonic
    | Process_cpu
    | Process_thread
    | Custom of underlying

  [%%ifdef JSC_POSIX_TIMERS]
  [%%ifdef JSC_ARCH_SIXTYFOUR]

  external getres : t -> Int63.t = "caml_clock_getres" [@@noalloc]
  external gettime : t -> Int63.t = "caml_clock_gettime" [@@noalloc]

  [%%ifdef JSC_CLOCK_GETCPUCLOCKID]

  external get_cpuclock_for : Pid.t -> underlying = "caml_clock_getcpuclockid"

  let get_cpuclock_for = Ok get_cpuclock_for

  [%%else]

  let get_cpuclock_for = Or_error.unimplemented "Unix.Clock.get_cpuclock_for"

  [%%endif]
  [%%else]

  external getres : t -> Int63.t = "caml_clock_getres"
  external gettime : t -> Int63.t = "caml_clock_gettime"

  let get_cpuclock_for = Or_error.unimplemented "Unix.Clock.get_cpuclock_for"

  [%%endif]

  let getres = Ok getres
  let gettime = Ok gettime

  [%%else]

  let getres = Or_error.unimplemented "Unix.Clock.getres"
  let gettime = Or_error.unimplemented "Unix.Clock.gettime"
  let get_cpuclock_for = Or_error.unimplemented "Unix.Clock.get_cpuclock_for"

  [%%endif]
end

type tm = Unix.tm =
  { tm_sec : int
  ; tm_min : int
  ; tm_hour : int
  ; tm_mday : int
  ; tm_mon : int
  ; tm_year : int
  ; tm_wday : int
  ; tm_yday : int
  ; tm_isdst : bool
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : tm) -> ()

  let tm_of_sexp =
    (let error_source__456_ = "core_unix.ml.before-ppx.tm" in
     fun x__457_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__456_
         ~fields:
           (Field
              { name = "tm_sec"
              ; kind = Required
              ; conv = int_of_sexp
              ; rest =
                  Field
                    { name = "tm_min"
                    ; kind = Required
                    ; conv = int_of_sexp
                    ; rest =
                        Field
                          { name = "tm_hour"
                          ; kind = Required
                          ; conv = int_of_sexp
                          ; rest =
                              Field
                                { name = "tm_mday"
                                ; kind = Required
                                ; conv = int_of_sexp
                                ; rest =
                                    Field
                                      { name = "tm_mon"
                                      ; kind = Required
                                      ; conv = int_of_sexp
                                      ; rest =
                                          Field
                                            { name = "tm_year"
                                            ; kind = Required
                                            ; conv = int_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "tm_wday"
                                                  ; kind = Required
                                                  ; conv = int_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "tm_yday"
                                                        ; kind = Required
                                                        ; conv = int_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "tm_isdst"
                                                              ; kind = Required
                                                              ; conv = bool_of_sexp
                                                              ; rest = Empty
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    }
              })
         ~index_of_field:(function
           | "tm_sec" -> 0
           | "tm_min" -> 1
           | "tm_hour" -> 2
           | "tm_mday" -> 3
           | "tm_mon" -> 4
           | "tm_year" -> 5
           | "tm_wday" -> 6
           | "tm_yday" -> 7
           | "tm_isdst" -> 8
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:
           (fun
             ( tm_sec
             , ( tm_min
               , ( tm_hour
                 , (tm_mday, (tm_mon, (tm_year, (tm_wday, (tm_yday, (tm_isdst, ())))))) )
               ) ) ->
           ({ tm_sec
            ; tm_min
            ; tm_hour
            ; tm_mday
            ; tm_mon
            ; tm_year
            ; tm_wday
            ; tm_yday
            ; tm_isdst
            }
            : tm))
         x__457_
     : Sexplib0.Sexp.t -> tm)
  ;;

  let _ = tm_of_sexp

  let sexp_of_tm =
    (fun { tm_sec = tm_sec__459_
         ; tm_min = tm_min__461_
         ; tm_hour = tm_hour__463_
         ; tm_mday = tm_mday__465_
         ; tm_mon = tm_mon__467_
         ; tm_year = tm_year__469_
         ; tm_wday = tm_wday__471_
         ; tm_yday = tm_yday__473_
         ; tm_isdst = tm_isdst__475_
         } ->
       let bnds__458_ = ([] : _ Stdlib.List.t) in
       let bnds__458_ =
         let arg__476_ = sexp_of_bool tm_isdst__475_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_isdst"; arg__476_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__474_ = sexp_of_int tm_yday__473_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_yday"; arg__474_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__472_ = sexp_of_int tm_wday__471_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_wday"; arg__472_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__470_ = sexp_of_int tm_year__469_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_year"; arg__470_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__468_ = sexp_of_int tm_mon__467_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_mon"; arg__468_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__466_ = sexp_of_int tm_mday__465_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_mday"; arg__466_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__464_ = sexp_of_int tm_hour__463_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_hour"; arg__464_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__462_ = sexp_of_int tm_min__461_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_min"; arg__462_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       let bnds__458_ =
         let arg__460_ = sexp_of_int tm_sec__459_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "tm_sec"; arg__460_ ] :: bnds__458_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__458_
     : tm -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_tm
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let time = Unix.time
let gettimeofday = Unix.gettimeofday

external strftime : Unix.tm -> string -> string = "core_time_ns_strftime"
external localtime : float -> Unix.tm = "core_localtime"
external gmtime : float -> Unix.tm = "core_gmtime"
external timegm : Unix.tm -> float = "core_timegm"

let mktime = Unix.mktime
let alarm = Unix.alarm
let sleep = Unix.sleep
let times = Unix.times
let utimes = Unix.utimes

external strptime
  :  allow_trailing_input:bool
  -> fmt:string
  -> string
  -> Unix.tm
  = "core_unix_strptime"

let strptime ?(allow_trailing_input = false) ~fmt s =
  strptime ~allow_trailing_input ~fmt s
;;

type interval_timer = Unix.interval_timer =
  | ITIMER_REAL
  | ITIMER_VIRTUAL
  | ITIMER_PROF
[@@deriving sexp]

include struct
  let _ = fun (_ : interval_timer) -> ()

  let interval_timer_of_sexp =
    (let error_source__479_ = "core_unix.ml.before-ppx.interval_timer" in
     function
     | Sexplib0.Sexp.Atom ("iTIMER_REAL" | "ITIMER_REAL") -> ITIMER_REAL
     | Sexplib0.Sexp.Atom ("iTIMER_VIRTUAL" | "ITIMER_VIRTUAL") -> ITIMER_VIRTUAL
     | Sexplib0.Sexp.Atom ("iTIMER_PROF" | "ITIMER_PROF") -> ITIMER_PROF
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iTIMER_REAL" | "ITIMER_REAL") :: _) as
       sexp__480_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__479_ sexp__480_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iTIMER_VIRTUAL" | "ITIMER_VIRTUAL") :: _)
       as sexp__480_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__479_ sexp__480_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iTIMER_PROF" | "ITIMER_PROF") :: _) as
       sexp__480_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__479_ sexp__480_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__478_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__479_ sexp__478_
     | Sexplib0.Sexp.List [] as sexp__478_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__479_ sexp__478_
     | sexp__478_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__479_ sexp__478_
     : Sexplib0.Sexp.t -> interval_timer)
  ;;

  let _ = interval_timer_of_sexp

  let sexp_of_interval_timer =
    (function
     | ITIMER_REAL -> Sexplib0.Sexp.Atom "ITIMER_REAL"
     | ITIMER_VIRTUAL -> Sexplib0.Sexp.Atom "ITIMER_VIRTUAL"
     | ITIMER_PROF -> Sexplib0.Sexp.Atom "ITIMER_PROF"
     : interval_timer -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_interval_timer
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type interval_timer_status = Unix.interval_timer_status =
  { it_interval : float
  ; it_value : float
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : interval_timer_status) -> ()

  let interval_timer_status_of_sexp =
    (let error_source__482_ = "core_unix.ml.before-ppx.interval_timer_status" in
     fun x__483_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__482_
         ~fields:
           (Field
              { name = "it_interval"
              ; kind = Required
              ; conv = float_of_sexp
              ; rest =
                  Field
                    { name = "it_value"
                    ; kind = Required
                    ; conv = float_of_sexp
                    ; rest = Empty
                    }
              })
         ~index_of_field:(function
           | "it_interval" -> 0
           | "it_value" -> 1
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:(fun (it_interval, (it_value, ())) ->
           ({ it_interval; it_value } : interval_timer_status))
         x__483_
     : Sexplib0.Sexp.t -> interval_timer_status)
  ;;

  let _ = interval_timer_status_of_sexp

  let sexp_of_interval_timer_status =
    (fun { it_interval = it_interval__485_; it_value = it_value__487_ } ->
       let bnds__484_ = ([] : _ Stdlib.List.t) in
       let bnds__484_ =
         let arg__488_ = sexp_of_float it_value__487_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "it_value"; arg__488_ ] :: bnds__484_
          : _ Stdlib.List.t)
       in
       let bnds__484_ =
         let arg__486_ = sexp_of_float it_interval__485_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "it_interval"; arg__486_ ] :: bnds__484_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__484_
     : interval_timer_status -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_interval_timer_status
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let getitimer = Unix.getitimer
let setitimer = Unix.setitimer
let getuid = Unix.getuid
let geteuid = Unix.geteuid

let setuid uid =
  improve (fun () -> Unix.setuid uid) (fun () -> [ "uid", Int.sexp_of_t uid ])
;;

let getgid = Unix.getgid
let getegid = Unix.getegid

let setgid gid =
  improve (fun () -> Unix.setgid gid) (fun () -> [ "gid", Int.sexp_of_t gid ])
;;

let getgroups = Unix.getgroups

let with_buffer_increased_on_ERANGE f x =
  let rec go n =
    match f x (Core.Bigstring.create n) with
    | exception Unix_error (ERANGE, _, _) -> go (4 * n)
    | x -> x
  in
  go 10000
;;

let make_by f make_exn =
  let normal arg =
    try Some (f arg) with
    | Not_found_s _ | Stdlib.Not_found -> None
  in
  let exn arg =
    try f arg with
    | Not_found_s _ | Stdlib.Not_found -> raise (make_exn arg)
  in
  normal, exn
;;

let string_to_zero_terminated_bigstring s =
  if String.contains s '\000'
  then
    Printf.ksprintf
      invalid_arg
      "NUL bytes are not allowed in the group and user names, but found one in %S"
      s;
  Core.Bigstring.of_string (s ^ "\000")
;;

let make_by' f make_exn = make_by (with_buffer_increased_on_ERANGE f) make_exn

module Passwd = struct
  type t =
    { name : string
    ; passwd : string
    ; uid : int
    ; gid : int
    ; gecos : string
    ; dir : string
    ; shell : string
    }
  [@@deriving compare, fields ~getters, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__489_ b__490_ ->
         if Stdlib.( == ) a__489_ b__490_
         then 0
         else (
           match compare_string a__489_.name b__490_.name with
           | 0 ->
             (match compare_string a__489_.passwd b__490_.passwd with
              | 0 ->
                (match compare_int a__489_.uid b__490_.uid with
                 | 0 ->
                   (match compare_int a__489_.gid b__490_.gid with
                    | 0 ->
                      (match compare_string a__489_.gecos b__490_.gecos with
                       | 0 ->
                         (match compare_string a__489_.dir b__490_.dir with
                          | 0 -> compare_string a__489_.shell b__490_.shell
                          | n -> n)
                       | n -> n)
                    | n -> n)
                 | n -> n)
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let shell _r__ = _r__.shell
    let _ = shell
    let dir _r__ = _r__.dir
    let _ = dir
    let gecos _r__ = _r__.gecos
    let _ = gecos
    let gid _r__ = _r__.gid
    let _ = gid
    let uid _r__ = _r__.uid
    let _ = uid
    let passwd _r__ = _r__.passwd
    let _ = passwd
    let name _r__ = _r__.name
    let _ = name

    let t_of_sexp =
      (let error_source__492_ = "core_unix.ml.before-ppx.Passwd.t" in
       fun x__493_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__492_
           ~fields:
             (Field
                { name = "name"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "passwd"
                      ; kind = Required
                      ; conv = string_of_sexp
                      ; rest =
                          Field
                            { name = "uid"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest =
                                Field
                                  { name = "gid"
                                  ; kind = Required
                                  ; conv = int_of_sexp
                                  ; rest =
                                      Field
                                        { name = "gecos"
                                        ; kind = Required
                                        ; conv = string_of_sexp
                                        ; rest =
                                            Field
                                              { name = "dir"
                                              ; kind = Required
                                              ; conv = string_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "shell"
                                                    ; kind = Required
                                                    ; conv = string_of_sexp
                                                    ; rest = Empty
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "name" -> 0
             | "passwd" -> 1
             | "uid" -> 2
             | "gid" -> 3
             | "gecos" -> 4
             | "dir" -> 5
             | "shell" -> 6
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (name, (passwd, (uid, (gid, (gecos, (dir, (shell, ()))))))) ->
             ({ name; passwd; uid; gid; gecos; dir; shell } : t))
           x__493_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { name = name__495_
           ; passwd = passwd__497_
           ; uid = uid__499_
           ; gid = gid__501_
           ; gecos = gecos__503_
           ; dir = dir__505_
           ; shell = shell__507_
           } ->
         let bnds__494_ = ([] : _ Stdlib.List.t) in
         let bnds__494_ =
           let arg__508_ = sexp_of_string shell__507_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shell"; arg__508_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__506_ = sexp_of_string dir__505_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "dir"; arg__506_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__504_ = sexp_of_string gecos__503_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "gecos"; arg__504_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__502_ = sexp_of_int gid__501_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "gid"; arg__502_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__500_ = sexp_of_int uid__499_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "uid"; arg__500_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__498_ = sexp_of_string passwd__497_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "passwd"; arg__498_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         let bnds__494_ =
           let arg__496_ = sexp_of_string name__495_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__496_ ] :: bnds__494_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__494_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix u =
    let module U = Unix in
    { name = u.U.pw_name
    ; passwd = u.U.pw_passwd
    ; uid = u.U.pw_uid
    ; gid = u.U.pw_gid
    ; gecos = u.U.pw_gecos
    ; dir = u.U.pw_dir
    ; shell = u.U.pw_shell
    }
  ;;

  module Low_level = struct
    type passwd_entry = Unix.passwd_entry =
      { pw_name : string
      ; pw_passwd : string
      ; pw_uid : file_perm
      ; pw_gid : file_perm
      ; pw_gecos : string
      ; pw_dir : string
      ; pw_shell : string
      }

    external core_setpwent : unit -> unit = "core_unix_setpwent"
    external core_endpwent : unit -> unit = "core_unix_endpwent"
    external core_getpwent : unit -> passwd_entry = "core_unix_getpwent"

    let setpwent = core_setpwent
    let getpwent_exn () = of_unix (core_getpwent ())
    let getpwent () = Option.try_with (fun () -> getpwent_exn ())
    let endpwent = core_endpwent

    external getpwnam_r : bigstring -> bigstring -> passwd_entry = "core_unix_getpwnam_r"
    external getpwuid_r : int -> bigstring -> passwd_entry = "core_unix_getpwuid_r"
  end

  exception Getbyname of string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyname] (function
        | Getbyname arg0__509_ ->
          let res0__510_ = sexp_of_string arg0__509_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Passwd.Getbyname"; res0__510_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyname, getbyname_exn =
    make_by'
      (fun name buf ->
         of_unix (Low_level.getpwnam_r (string_to_zero_terminated_bigstring name) buf))
      (fun s -> Getbyname s)
  ;;

  exception Getbyuid of int [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyuid] (function
        | Getbyuid arg0__511_ ->
          let res0__512_ = sexp_of_int arg0__511_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Passwd.Getbyuid"; res0__512_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyuid, getbyuid_exn =
    make_by' (fun uid buf -> of_unix (Low_level.getpwuid_r uid buf)) (fun s -> Getbyuid s)
  ;;

  let pwdb_lock = Error_checking_mutex.create ()

  let getpwents () =
    Error_checking_mutex.critical_section pwdb_lock ~f:(fun () ->
      Low_level.setpwent ();
      Exn.protect
        ~f:(fun () ->
          let rec loop acc =
            match Low_level.getpwent_exn () with
            | exception End_of_file -> List.rev acc
            | ent -> loop (ent :: acc)
          in
          loop [])
        ~finally:(fun () -> Low_level.endpwent ()))
  ;;
end

module Group = struct
  type t =
    { name : string
    ; passwd : string
    ; gid : int
    ; mem : string array
    }
  [@@deriving fields ~getters, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let mem _r__ = _r__.mem
    let _ = mem
    let gid _r__ = _r__.gid
    let _ = gid
    let passwd _r__ = _r__.passwd
    let _ = passwd
    let name _r__ = _r__.name
    let _ = name

    let sexp_of_t =
      (fun { name = name__514_; passwd = passwd__516_; gid = gid__518_; mem = mem__520_ } ->
         let bnds__513_ = ([] : _ Stdlib.List.t) in
         let bnds__513_ =
           let arg__521_ = sexp_of_array sexp_of_string mem__520_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mem"; arg__521_ ] :: bnds__513_
            : _ Stdlib.List.t)
         in
         let bnds__513_ =
           let arg__519_ = sexp_of_int gid__518_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "gid"; arg__519_ ] :: bnds__513_
            : _ Stdlib.List.t)
         in
         let bnds__513_ =
           let arg__517_ = sexp_of_string passwd__516_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "passwd"; arg__517_ ] :: bnds__513_
            : _ Stdlib.List.t)
         in
         let bnds__513_ =
           let arg__515_ = sexp_of_string name__514_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__515_ ] :: bnds__513_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__513_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix u =
    { name = u.Unix.gr_name
    ; passwd = u.Unix.gr_passwd
    ; gid = u.Unix.gr_gid
    ; mem = u.Unix.gr_mem
    }
  ;;

  module Low_level = struct
    type group_entry = Unix.group_entry =
      { gr_name : string
      ; gr_passwd : string
      ; gr_gid : file_perm
      ; gr_mem : string array
      }

    external getgrnam_r : bigstring -> bigstring -> group_entry = "core_unix_getgrnam_r"
    external getgrgid_r : int -> bigstring -> group_entry = "core_unix_getgrgid_r"
  end

  exception Getbyname of string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyname] (function
        | Getbyname arg0__522_ ->
          let res0__523_ = sexp_of_string arg0__522_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Group.Getbyname"; res0__523_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyname, getbyname_exn =
    make_by'
      (fun name buf ->
         of_unix (Low_level.getgrnam_r (string_to_zero_terminated_bigstring name) buf))
      (fun s -> Getbyname s)
  ;;

  exception Getbygid of int [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbygid] (function
        | Getbygid arg0__524_ ->
          let res0__525_ = sexp_of_int arg0__524_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Group.Getbygid"; res0__525_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbygid, getbygid_exn =
    make_by' (fun gid buf -> of_unix (Low_level.getgrgid_r gid buf)) (fun s -> Getbygid s)
  ;;
end

let username () = (Passwd.getbyuid_exn (getuid ())).name
let getlogin = username

module Protocol_family = struct
  type t =
    [ `Unix
    | `Inet
    | `Inet6
    ]
  [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2333:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , []
            , Bin_prot.Shape.poly_variant
                (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2334:4")
                [ Bin_prot.Shape.constr "Unix" None
                ; Bin_prot.Shape.constr "Inet" None
                ; Bin_prot.Shape.constr "Inet6" None
                ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t

    let bin_size_t =
      (function
       | _ -> 4
       : _ Bin_prot.Size.sizer)
    ;;

    let _ = bin_size_t

    let bin_write_t =
      (fun buf ~pos -> function
         | `Unix -> Bin_prot.Write.bin_write_variant_int buf ~pos 948106920
         | `Inet -> Bin_prot.Write.bin_write_variant_int buf ~pos 815031220
         | `Inet6 -> Bin_prot.Write.bin_write_variant_int buf ~pos (-784147966)
       : _ Bin_prot.Write.writer)
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ _buf ~pos_ref:_ vint =
      match vint with
      | 948106920 -> `Unix
      | 815031220 -> `Inet
      | -784147966 -> `Inet6
      | _ -> raise Bin_prot.Common.No_variant_match
    ;;

    let _ = __bin_read_t__

    let bin_read_t buf ~pos_ref =
      let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
      try __bin_read_t__ buf ~pos_ref vint with
      | Bin_prot.Common.No_variant_match ->
        let err =
          Bin_prot.Common.ReadError.Variant "core_unix.ml.before-ppx.Protocol_family.t"
        in
        Bin_prot.Common.raise_read_error err !pos_ref
    ;;

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

    let __t_of_sexp__ =
      (let error_source__531_ = "core_unix.ml.before-ppx.Protocol_family.t" in
       function
       | Sexplib0.Sexp.Atom atom__527_ as _sexp__529_ ->
         (match atom__527_ with
          | "Unix" -> `Unix
          | "Inet" -> `Inet
          | "Inet6" -> `Inet6
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__527_ :: _) as _sexp__529_ ->
         (match atom__527_ with
          | "Unix" -> Sexplib0.Sexp_conv_error.ptag_no_args error_source__531_ _sexp__529_
          | "Inet" -> Sexplib0.Sexp_conv_error.ptag_no_args error_source__531_ _sexp__529_
          | "Inet6" ->
            Sexplib0.Sexp_conv_error.ptag_no_args error_source__531_ _sexp__529_
          | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__528_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
           error_source__531_
           sexp__528_
       | Sexplib0.Sexp.List [] as sexp__528_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
           error_source__531_
           sexp__528_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = __t_of_sexp__

    let t_of_sexp =
      (let error_source__533_ = "core_unix.ml.before-ppx.Protocol_family.t" in
       fun sexp__532_ ->
         try __t_of_sexp__ sexp__532_ with
         | Sexplib0.Sexp_conv_error.No_variant_match ->
           Sexplib0.Sexp_conv_error.no_matching_variant_found
             error_source__533_
             sexp__532_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | `Unix -> Sexplib0.Sexp.Atom "Unix"
       | `Inet -> Sexplib0.Sexp.Atom "Inet"
       | `Inet6 -> Sexplib0.Sexp.Atom "Inet6"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix = function
    | Unix.PF_UNIX -> `Unix
    | Unix.PF_INET -> `Inet
    | Unix.PF_INET6 -> `Inet6
  ;;
end

let gethostname = Unix.gethostname

module Inet_addr0 = struct
  module Stable = struct
    module V1 = struct
      module T0 = struct
        type t = Unix.inet_addr

        let stable_witness = Stable_witness.assert_stable
        let of_string = Unix.inet_addr_of_string
        let to_string = Unix.string_of_inet_addr
        let compare = Poly.compare
        let hash_fold_t hash (t : t) = hash_fold_int hash (Hashtbl.hash t)
        let hash = Ppx_hash_lib.Std.Hash.of_fold hash_fold_t
      end

      module T1 = struct
        include T0
        include Sexpable.Of_stringable (T0)
        include Binable.Of_stringable_without_uuid [@alert "-legacy"] (T0)
      end

      include T1
      include Comparable.Make (T1)
    end
  end

  include Stable.V1

  include Stable_unit_test.Make (struct
      type nonrec t = t [@@deriving sexp, bin_io]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2380:4")
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
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let equal = equal

      let tests =
        [ of_string "0.0.0.0", "0.0.0.0", "\0070.0.0.0"
        ; of_string "10.0.0.0", "10.0.0.0", "\b10.0.0.0"
        ; of_string "127.0.0.1", "127.0.0.1", "\t127.0.0.1"
        ; of_string "192.168.1.101", "192.168.1.101", "\r192.168.1.101"
        ; of_string "255.255.255.255", "255.255.255.255", "\015255.255.255.255"
        ; ( of_string "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
          , "2001:db8:85a3::8a2e:370:7334"
          , "\0282001:db8:85a3::8a2e:370:7334" )
        ; ( of_string "2001:db8:85a3:0:0:8a2e:370:7334"
          , "2001:db8:85a3::8a2e:370:7334"
          , "\0282001:db8:85a3::8a2e:370:7334" )
        ; ( of_string "2001:db8:85a3::8a2e:370:7334"
          , "2001:db8:85a3::8a2e:370:7334"
          , "\0282001:db8:85a3::8a2e:370:7334" )
        ; of_string "0:0:0:0:0:0:0:1", "::1", "\003::1"
        ; of_string "::1", "::1", "\003::1"
        ; of_string "0:0:0:0:0:0:0:0", "::", "\002::"
        ; of_string "::", "::", "\002::"
        ; of_string "::ffff:c000:0280", "::ffff:192.0.2.128", "\018::ffff:192.0.2.128"
        ; of_string "::ffff:192.0.2.128", "::ffff:192.0.2.128", "\018::ffff:192.0.2.128"
        ; of_string "2001:0db8::0001", "2001:db8::1", "\0112001:db8::1"
        ; of_string "2001:db8::1", "2001:db8::1", "\0112001:db8::1"
        ; of_string "2001:db8::2:1", "2001:db8::2:1", "\r2001:db8::2:1"
        ; ( of_string "2001:db8:0000:1:1:1:1:1"
          , "2001:db8:0:1:1:1:1:1"
          , "\0202001:db8:0:1:1:1:1:1" )
        ; ( of_string "2001:db8::1:1:1:1:1"
          , "2001:db8:0:1:1:1:1:1"
          , "\0202001:db8:0:1:1:1:1:1" )
        ; ( of_string "2001:db8:0:1:1:1:1:1"
          , "2001:db8:0:1:1:1:1:1"
          , "\0202001:db8:0:1:1:1:1:1" )
        ; of_string "2001:db8:0:0:1:0:0:1", "2001:db8::1:0:0:1", "\0172001:db8::1:0:0:1"
        ; of_string "2001:db8:0:0:1::1", "2001:db8::1:0:0:1", "\0172001:db8::1:0:0:1"
        ; of_string "2001:db8::1:0:0:1", "2001:db8::1:0:0:1", "\0172001:db8::1:0:0:1"
        ; of_string "2001:DB8::1", "2001:db8::1", "\0112001:db8::1"
        ; of_string "2001:db8::1", "2001:db8::1", "\0112001:db8::1"
        ]
      ;;
    end)

  let arg_type = Core.Command.Arg_type.create of_string
end

module Host = struct
  type t =
    { name : string
    ; aliases : string array
    ; family : Protocol_family.t
    ; addresses : Inet_addr0.t array
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { name = name__536_
           ; aliases = aliases__538_
           ; family = family__540_
           ; addresses = addresses__542_
           } ->
         let bnds__535_ = ([] : _ Stdlib.List.t) in
         let bnds__535_ =
           let arg__543_ = sexp_of_array Inet_addr0.sexp_of_t addresses__542_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "addresses"; arg__543_ ] :: bnds__535_
            : _ Stdlib.List.t)
         in
         let bnds__535_ =
           let arg__541_ = Protocol_family.sexp_of_t family__540_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "family"; arg__541_ ] :: bnds__535_
            : _ Stdlib.List.t)
         in
         let bnds__535_ =
           let arg__539_ = sexp_of_array sexp_of_string aliases__538_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliases"; arg__539_ ] :: bnds__535_
            : _ Stdlib.List.t)
         in
         let bnds__535_ =
           let arg__537_ = sexp_of_string name__536_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__537_ ] :: bnds__535_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__535_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix u =
    { name = u.Unix.h_name
    ; aliases = u.Unix.h_aliases
    ; family = Protocol_family.of_unix u.Unix.h_addrtype
    ; addresses = u.Unix.h_addr_list
    }
  ;;

  exception Getbyname of string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyname] (function
        | Getbyname arg0__544_ ->
          let res0__545_ = sexp_of_string arg0__544_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Host.Getbyname"; res0__545_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyname, getbyname_exn =
    make_by (fun name -> of_unix (Unix.gethostbyname name)) (fun s -> Getbyname s)
  ;;

  exception Getbyaddr of Inet_addr0.t [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyaddr] (function
        | Getbyaddr arg0__546_ ->
          let res0__547_ = Inet_addr0.sexp_of_t arg0__546_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Host.Getbyaddr"; res0__547_ ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyaddr, getbyaddr_exn =
    make_by (fun addr -> of_unix (Unix.gethostbyaddr addr)) (fun a -> Getbyaddr a)
  ;;

  let have_address_in_common h1 h2 =
    let addrs1 = Inet_addr0.Set.of_array h1.addresses in
    let addrs2 = Inet_addr0.Set.of_array h2.addresses in
    not (Set.is_empty (Set.inter addrs1 addrs2))
  ;;
end

module Inet_addr = struct
  include Inet_addr0

  exception Get_inet_addr of string * string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add
        [%extension_constructor Get_inet_addr]
        (function
        | Get_inet_addr (arg0__548_, arg1__549_) ->
          let res0__550_ = sexp_of_string arg0__548_
          and res1__551_ = sexp_of_string arg1__549_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Inet_addr.Get_inet_addr"
            ; res0__550_
            ; res1__551_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_string_or_getbyname name =
    try of_string name with
    | Failure _ ->
      (match Host.getbyname name with
       | None -> raise (Get_inet_addr (name, "host not found"))
       | Some host ->
         (match host.Host.family with
          | `Unix -> assert false
          | `Inet | `Inet6 ->
            let addrs = host.Host.addresses in
            if Int.( > ) (Array.length addrs) 0
            then addrs.(0)
            else raise (Get_inet_addr (name, "empty addrs"))))
  ;;

  module Blocking_sexp = struct
    module T = struct
      include Inet_addr0

      let of_string = of_string_or_getbyname
    end

    include T
    include Sexpable.Of_stringable (T)
  end

  let t_of_sexp = Blocking_sexp.t_of_sexp
  let bind_any = Unix.inet_addr_any
  let bind_any_inet6 = Unix.inet6_addr_any
  let localhost = Unix.inet_addr_loopback
  let localhost_inet6 = Unix.inet6_addr_loopback

  external inet4_addr_of_int32 : int32 -> t = "core_unix_inet4_addr_of_int32"
  external inet4_addr_to_int32_exn : t -> int32 = "core_unix_inet4_addr_to_int32_exn"
  external inet4_addr_of_int63 : Int63.t -> t = "core_unix_inet4_addr_of_int63"
  external inet4_addr_to_int63_exn : t -> Int63.t = "core_unix_inet4_addr_to_int63_exn"
end

[@@@ocaml.text
  " IPv6 addresses are not supported.\n\
  \    The RFC regarding how to properly format an IPv6 string is...painful.\n\n\
  \    Note the 0010 and 0000:\n\
  \    # \"2a03:2880:0010:1f03:face:b00c:0000:0025\" |> Unix.Inet_addr.of_string |!\n\
  \    Unix.Inet_addr.to_string ;;\n\
  \    - : string = \"2a03:2880:10:1f03:face:b00c:0:25\"\n"]

module Cidr = struct
  module Stable = struct
    module V1 = struct
      module T0 = struct
        type t =
          { address : int32
          ; bits : int
          }
        [@@deriving fields ~getters, bin_io, compare, hash, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()
          let bits _r__ = _r__.bits
          let _ = bits
          let address _r__ = _r__.address
          let _ = address

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2524:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.record
                      [ "address", bin_shape_int32; "bits", bin_shape_int ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer = function
            | { address = v1; bits = v2 } ->
              let size = 0 in
              let size = Bin_prot.Common.( + ) size (bin_size_int32 v1) in
              Bin_prot.Common.( + ) size (bin_size_int v2)
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | { address = v1; bits = v2 } ->
              let pos = bin_write_int32 buf ~pos v1 in
              bin_write_int buf ~pos v2
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "core_unix.ml.before-ppx.Cidr.Stable.V1.T0.t"
              !pos_ref
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            let v_address = bin_read_int32 buf ~pos_ref in
            let v_bits = bin_read_int buf ~pos_ref in
            { address = v_address; bits = v_bits }
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__552_ b__553_ ->
               if Stdlib.( == ) a__552_ b__553_
               then 0
               else (
                 match compare_int32 a__552_.address b__553_.address with
                 | 0 -> compare_int a__552_.bits b__553_.bits
                 | n -> n)
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg ->
            let hsv =
              let hsv = hsv in
              hash_fold_int32 hsv arg.address
            in
            hash_fold_int hsv arg.bits
          ;;

          let _ = hash_fold_t

          let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func arg =
              Ppx_hash_lib.Std.Hash.get_hash_value
                (let hsv = Ppx_hash_lib.Std.Hash.create () in
                 hash_fold_t hsv arg)
            in
            fun x -> func x
          ;;

          let _ = hash

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : int32 Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_int32
            and _ : int Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_int
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let normalized_address ~base ~bits =
          if bits = 0
          then 0l
          else (
            let shift = 32 - bits in
            let open Int32 in
            shift_left (shift_right_logical base shift) shift)
        ;;

        let create ~base_address ~bits =
          if bits < 0 || bits > 32
          then failwithf "%d is an invalid number of mask bits (0 <= bits <= 32)" bits ();
          let base = Inet_addr.inet4_addr_to_int32_exn base_address in
          let address = normalized_address ~base ~bits in
          { address; bits }
        ;;

        let of_string s =
          match String.split ~on:'/' s with
          | [ s_inet_address; s_bits ] ->
            create
              ~base_address:(Inet_addr.of_string s_inet_address)
              ~bits:(Int.of_string s_bits)
          | _ -> failwithf "Couldn't parse '%s' into a CIDR address/bits pair" s ()
        ;;

        let to_string t =
          let addr = Inet_addr.inet4_addr_of_int32 t.address in
          sprintf "%s/%d" (Inet_addr.to_string addr) t.bits
        ;;
      end

      module T1 = Sexpable.Stable.Of_stringable.V1 (T0)

      module T2 = Comparator.Stable.V1.Make (struct
          include T0
          include T1
        end)

      module T3 = Comparable.Stable.V1.With_stable_witness.Make (struct
          include T0
          include T1
          include T2
        end)

      include T0
      include T1
      include T2
      include T3
    end
  end

  include Stable.V1.T0
  include Stable.V1.T1
  include Stable.V1.T2

  let invariant t =
    assert (t.bits >= 0 && t.bits <= 32);
    assert (Int32.equal t.address (normalized_address ~base:t.address ~bits:t.bits))
  ;;

  let base_address t = Inet_addr.inet4_addr_of_int32 t.address

  let broadcast_address t =
    let inverted_netmask = Int32.bit_not (Int32.shift_left 0xffffffffl (32 - t.bits)) in
    Inet_addr.inet4_addr_of_int32 (Int32.bit_or t.address inverted_netmask)
  ;;

  let netmask_of_bits t =
    Inet_addr.inet4_addr_of_int32 (Int32.shift_left 0xffffffffl (32 - t.bits))
  ;;

  let does_match_int32 t address =
    Int32.equal t.address (normalized_address ~base:address ~bits:t.bits)
  ;;

  let does_match t inet_addr =
    match Inet_addr.inet4_addr_to_int32_exn inet_addr with
    | exception _ -> false
    | address -> does_match_int32 t address
  ;;

  let multicast = of_string "224.0.0.0/4"
  let is_subset t ~of_ = bits of_ <= bits t && does_match_int32 of_ t.address

  let all_matching_addresses t =
    Sequence.unfold ~init:t.address ~f:(fun address ->
      if does_match_int32 t address
      then Some (Inet_addr.inet4_addr_of_int32 address, Int32.succ address)
      else None)
  ;;

  include Identifiable.Make_using_comparator (struct
      let module_name = "Core_unix.Cidr"

      include Stable.V1.T0
      include Stable.V1.T1
      include Stable.V1.T2
    end)

  let arg_type = Core.Command.Arg_type.create of_string
end

module Protocol = struct
  type t =
    { name : string
    ; aliases : string array
    ; proto : int
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__555_ = "core_unix.ml.before-ppx.Protocol.t" in
       fun x__556_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__555_
           ~fields:
             (Field
                { name = "name"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "aliases"
                      ; kind = Required
                      ; conv = array_of_sexp string_of_sexp
                      ; rest =
                          Field
                            { name = "proto"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest = Empty
                            }
                      }
                })
           ~index_of_field:(function
             | "name" -> 0
             | "aliases" -> 1
             | "proto" -> 2
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (name, (aliases, (proto, ()))) -> ({ name; aliases; proto } : t))
           x__556_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { name = name__558_; aliases = aliases__560_; proto = proto__562_ } ->
         let bnds__557_ = ([] : _ Stdlib.List.t) in
         let bnds__557_ =
           let arg__563_ = sexp_of_int proto__562_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "proto"; arg__563_ ] :: bnds__557_
            : _ Stdlib.List.t)
         in
         let bnds__557_ =
           let arg__561_ = sexp_of_array sexp_of_string aliases__560_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliases"; arg__561_ ] :: bnds__557_
            : _ Stdlib.List.t)
         in
         let bnds__557_ =
           let arg__559_ = sexp_of_string name__558_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__559_ ] :: bnds__557_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__557_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix u =
    { name = u.Unix.p_name; aliases = u.Unix.p_aliases; proto = u.Unix.p_proto }
  ;;

  exception Getbyname of string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyname] (function
        | Getbyname arg0__564_ ->
          let res0__565_ = sexp_of_string arg0__564_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Protocol.Getbyname"
            ; res0__565_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyname, getbyname_exn =
    make_by (fun name -> of_unix (Unix.getprotobyname name)) (fun s -> Getbyname s)
  ;;

  exception Getbynumber of int [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbynumber] (function
        | Getbynumber arg0__566_ ->
          let res0__567_ = sexp_of_int arg0__566_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Protocol.Getbynumber"
            ; res0__567_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbynumber, getbynumber_exn =
    make_by (fun i -> of_unix (Unix.getprotobynumber i)) (fun i -> Getbynumber i)
  ;;
end

module Service = struct
  type t =
    { name : string
    ; aliases : string array
    ; port : int
    ; proto : string
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__569_ = "core_unix.ml.before-ppx.Service.t" in
       fun x__570_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__569_
           ~fields:
             (Field
                { name = "name"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "aliases"
                      ; kind = Required
                      ; conv = array_of_sexp string_of_sexp
                      ; rest =
                          Field
                            { name = "port"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest =
                                Field
                                  { name = "proto"
                                  ; kind = Required
                                  ; conv = string_of_sexp
                                  ; rest = Empty
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "name" -> 0
             | "aliases" -> 1
             | "port" -> 2
             | "proto" -> 3
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (name, (aliases, (port, (proto, ())))) ->
             ({ name; aliases; port; proto } : t))
           x__570_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { name = name__572_
           ; aliases = aliases__574_
           ; port = port__576_
           ; proto = proto__578_
           } ->
         let bnds__571_ = ([] : _ Stdlib.List.t) in
         let bnds__571_ =
           let arg__579_ = sexp_of_string proto__578_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "proto"; arg__579_ ] :: bnds__571_
            : _ Stdlib.List.t)
         in
         let bnds__571_ =
           let arg__577_ = sexp_of_int port__576_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "port"; arg__577_ ] :: bnds__571_
            : _ Stdlib.List.t)
         in
         let bnds__571_ =
           let arg__575_ = sexp_of_array sexp_of_string aliases__574_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliases"; arg__575_ ] :: bnds__571_
            : _ Stdlib.List.t)
         in
         let bnds__571_ =
           let arg__573_ = sexp_of_string name__572_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__573_ ] :: bnds__571_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__571_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_unix u =
    { name = u.Unix.s_name
    ; aliases = u.Unix.s_aliases
    ; port = u.Unix.s_port
    ; proto = u.Unix.s_proto
    }
  ;;

  exception Getbyname of string * string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyname] (function
        | Getbyname (arg0__580_, arg1__581_) ->
          let res0__582_ = sexp_of_string arg0__580_
          and res1__583_ = sexp_of_string arg1__581_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Service.Getbyname"
            ; res0__582_
            ; res1__583_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyname_exn name ~protocol =
    try of_unix (Unix.getservbyname name ~protocol) with
    | Not_found_s _ | Stdlib.Not_found -> raise (Getbyname (name, protocol))
  ;;

  let getbyname name ~protocol =
    try Some (of_unix (Unix.getservbyname name ~protocol)) with
    | _ -> None
  ;;

  exception Getbyport of int * string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Getbyport] (function
        | Getbyport (arg0__584_, arg1__585_) ->
          let res0__586_ = sexp_of_int arg0__584_
          and res1__587_ = sexp_of_string arg1__585_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "core_unix.ml.before-ppx.Service.Getbyport"
            ; res0__586_
            ; res1__587_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let getbyport_exn num ~protocol =
    try of_unix (Unix.getservbyport num ~protocol) with
    | Not_found_s _ | Stdlib.Not_found -> raise (Getbyport (num, protocol))
  ;;

  let getbyport num ~protocol =
    try Some (of_unix (Unix.getservbyport num ~protocol)) with
    | Not_found_s _ | Stdlib.Not_found -> None
  ;;
end

type socket_domain = Unix.socket_domain =
  | PF_UNIX
  | PF_INET
  | PF_INET6
[@@deriving sexp, bin_io]

include struct
  let _ = fun (_ : socket_domain) -> ()

  let socket_domain_of_sexp =
    (let error_source__590_ = "core_unix.ml.before-ppx.socket_domain" in
     function
     | Sexplib0.Sexp.Atom ("pF_UNIX" | "PF_UNIX") -> PF_UNIX
     | Sexplib0.Sexp.Atom ("pF_INET" | "PF_INET") -> PF_INET
     | Sexplib0.Sexp.Atom ("pF_INET6" | "PF_INET6") -> PF_INET6
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pF_UNIX" | "PF_UNIX") :: _) as sexp__591_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__590_ sexp__591_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pF_INET" | "PF_INET") :: _) as sexp__591_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__590_ sexp__591_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pF_INET6" | "PF_INET6") :: _) as
       sexp__591_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__590_ sexp__591_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__589_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__590_ sexp__589_
     | Sexplib0.Sexp.List [] as sexp__589_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__590_ sexp__589_
     | sexp__589_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__590_ sexp__589_
     : Sexplib0.Sexp.t -> socket_domain)
  ;;

  let _ = socket_domain_of_sexp

  let sexp_of_socket_domain =
    (function
     | PF_UNIX -> Sexplib0.Sexp.Atom "PF_UNIX"
     | PF_INET -> Sexplib0.Sexp.Atom "PF_INET"
     | PF_INET6 -> Sexplib0.Sexp.Atom "PF_INET6"
     : socket_domain -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_domain

  let bin_shape_socket_domain =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2699:0")
        [ ( Bin_prot.Shape.Tid.of_string "socket_domain"
          , []
          , Bin_prot.Shape.variant [ "PF_UNIX", []; "PF_INET", []; "PF_INET6", [] ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "socket_domain")) []
  ;;

  let _ = bin_shape_socket_domain

  let bin_size_socket_domain : socket_domain Bin_prot.Size.sizer = function
    | PF_UNIX | PF_INET | PF_INET6 -> 1
  ;;

  let _ = bin_size_socket_domain

  let bin_write_socket_domain : socket_domain Bin_prot.Write.writer =
    fun buf ~pos -> function
    | PF_UNIX -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
    | PF_INET -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
    | PF_INET6 -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
  ;;

  let _ = bin_write_socket_domain

  let bin_writer_socket_domain =
    ({ size = bin_size_socket_domain; write = bin_write_socket_domain }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_socket_domain

  let __bin_read_socket_domain__ : (int -> socket_domain) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type
      "core_unix.ml.before-ppx.socket_domain"
      !pos_ref
  ;;

  let _ = __bin_read_socket_domain__

  let bin_read_socket_domain : socket_domain Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 -> PF_UNIX
    | 1 -> PF_INET
    | 2 -> PF_INET6
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "core_unix.ml.before-ppx.socket_domain")
        !pos_ref
  ;;

  let _ = bin_read_socket_domain

  let bin_reader_socket_domain =
    ({ read = bin_read_socket_domain; vtag_read = __bin_read_socket_domain__ }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_socket_domain

  let bin_socket_domain =
    ({ writer = bin_writer_socket_domain
     ; reader = bin_reader_socket_domain
     ; shape = bin_shape_socket_domain
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_socket_domain
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type socket_type = Unix.socket_type =
  | SOCK_STREAM
  | SOCK_DGRAM
  | SOCK_RAW
  | SOCK_SEQPACKET
[@@deriving sexp, bin_io]

include struct
  let _ = fun (_ : socket_type) -> ()

  let socket_type_of_sexp =
    (let error_source__594_ = "core_unix.ml.before-ppx.socket_type" in
     function
     | Sexplib0.Sexp.Atom ("sOCK_STREAM" | "SOCK_STREAM") -> SOCK_STREAM
     | Sexplib0.Sexp.Atom ("sOCK_DGRAM" | "SOCK_DGRAM") -> SOCK_DGRAM
     | Sexplib0.Sexp.Atom ("sOCK_RAW" | "SOCK_RAW") -> SOCK_RAW
     | Sexplib0.Sexp.Atom ("sOCK_SEQPACKET" | "SOCK_SEQPACKET") -> SOCK_SEQPACKET
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sOCK_STREAM" | "SOCK_STREAM") :: _) as
       sexp__595_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__594_ sexp__595_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sOCK_DGRAM" | "SOCK_DGRAM") :: _) as
       sexp__595_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__594_ sexp__595_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sOCK_RAW" | "SOCK_RAW") :: _) as
       sexp__595_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__594_ sexp__595_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sOCK_SEQPACKET" | "SOCK_SEQPACKET") :: _)
       as sexp__595_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__594_ sexp__595_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__593_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__594_ sexp__593_
     | Sexplib0.Sexp.List [] as sexp__593_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__594_ sexp__593_
     | sexp__593_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__594_ sexp__593_
     : Sexplib0.Sexp.t -> socket_type)
  ;;

  let _ = socket_type_of_sexp

  let sexp_of_socket_type =
    (function
     | SOCK_STREAM -> Sexplib0.Sexp.Atom "SOCK_STREAM"
     | SOCK_DGRAM -> Sexplib0.Sexp.Atom "SOCK_DGRAM"
     | SOCK_RAW -> Sexplib0.Sexp.Atom "SOCK_RAW"
     | SOCK_SEQPACKET -> Sexplib0.Sexp.Atom "SOCK_SEQPACKET"
     : socket_type -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_type

  let bin_shape_socket_type =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2705:0")
        [ ( Bin_prot.Shape.Tid.of_string "socket_type"
          , []
          , Bin_prot.Shape.variant
              [ "SOCK_STREAM", []
              ; "SOCK_DGRAM", []
              ; "SOCK_RAW", []
              ; "SOCK_SEQPACKET", []
              ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "socket_type")) []
  ;;

  let _ = bin_shape_socket_type

  let bin_size_socket_type : socket_type Bin_prot.Size.sizer = function
    | SOCK_STREAM | SOCK_DGRAM | SOCK_RAW | SOCK_SEQPACKET -> 1
  ;;

  let _ = bin_size_socket_type

  let bin_write_socket_type : socket_type Bin_prot.Write.writer =
    fun buf ~pos -> function
    | SOCK_STREAM -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
    | SOCK_DGRAM -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
    | SOCK_RAW -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
    | SOCK_SEQPACKET -> Bin_prot.Write.bin_write_int_8bit buf ~pos 3
  ;;

  let _ = bin_write_socket_type

  let bin_writer_socket_type =
    ({ size = bin_size_socket_type; write = bin_write_socket_type }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_socket_type

  let __bin_read_socket_type__ : (int -> socket_type) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type
      "core_unix.ml.before-ppx.socket_type"
      !pos_ref
  ;;

  let _ = __bin_read_socket_type__

  let bin_read_socket_type : socket_type Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 -> SOCK_STREAM
    | 1 -> SOCK_DGRAM
    | 2 -> SOCK_RAW
    | 3 -> SOCK_SEQPACKET
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "core_unix.ml.before-ppx.socket_type")
        !pos_ref
  ;;

  let _ = bin_read_socket_type

  let bin_reader_socket_type =
    ({ read = bin_read_socket_type; vtag_read = __bin_read_socket_type__ }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_socket_type

  let bin_socket_type =
    ({ writer = bin_writer_socket_type
     ; reader = bin_reader_socket_type
     ; shape = bin_shape_socket_type
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_socket_type
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type sockaddr = Unix.sockaddr =
  | ADDR_UNIX of string
  | ADDR_INET of Inet_addr.t * int
[@@deriving compare, sexp_of, bin_io]

include struct
  let _ = fun (_ : sockaddr) -> ()

  let compare_sockaddr =
    (fun a__596_ b__597_ ->
       if Stdlib.( == ) a__596_ b__597_
       then 0
       else (
         match a__596_, b__597_ with
         | ADDR_UNIX _a__598_, ADDR_UNIX _b__599_ -> compare_string _a__598_ _b__599_
         | ADDR_UNIX _, _ -> -1
         | _, ADDR_UNIX _ -> 1
         | ADDR_INET (_a__600_, _a__602_), ADDR_INET (_b__601_, _b__603_) ->
           (match Inet_addr.compare _a__600_ _b__601_ with
            | 0 -> compare_int _a__602_ _b__603_
            | n -> n))
     : sockaddr -> (sockaddr[@merlin.hide]) -> int)
  ;;

  let _ = compare_sockaddr

  let sexp_of_sockaddr =
    (function
     | ADDR_UNIX arg0__604_ ->
       let res0__605_ = sexp_of_string arg0__604_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ADDR_UNIX"; res0__605_ ]
     | ADDR_INET (arg0__606_, arg1__607_) ->
       let res0__608_ = Inet_addr.sexp_of_t arg0__606_
       and res1__609_ = sexp_of_int arg1__607_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ADDR_INET"; res0__608_; res1__609_ ]
     : sockaddr -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_sockaddr

  let bin_shape_sockaddr =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2712:0")
        [ ( Bin_prot.Shape.Tid.of_string "sockaddr"
          , []
          , Bin_prot.Shape.variant
              [ "ADDR_UNIX", [ bin_shape_string ]
              ; "ADDR_INET", [ Inet_addr.bin_shape_t; bin_shape_int ]
              ] )
        ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "sockaddr")) []
  ;;

  let _ = bin_shape_sockaddr

  let bin_size_sockaddr : sockaddr Bin_prot.Size.sizer = function
    | ADDR_UNIX v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (bin_size_string v1)
    | ADDR_INET (v1, v2) ->
      let size = 1 in
      let size = Bin_prot.Common.( + ) size (Inet_addr.bin_size_t v1) in
      Bin_prot.Common.( + ) size (bin_size_int v2)
  ;;

  let _ = bin_size_sockaddr

  let bin_write_sockaddr : sockaddr Bin_prot.Write.writer =
    fun buf ~pos -> function
    | ADDR_UNIX v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
      bin_write_string buf ~pos v1
    | ADDR_INET (v1, v2) ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
      let pos = Inet_addr.bin_write_t buf ~pos v1 in
      bin_write_int buf ~pos v2
  ;;

  let _ = bin_write_sockaddr

  let bin_writer_sockaddr =
    ({ size = bin_size_sockaddr; write = bin_write_sockaddr }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_sockaddr

  let __bin_read_sockaddr__ : (int -> sockaddr) Bin_prot.Read.reader =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type "core_unix.ml.before-ppx.sockaddr" !pos_ref
  ;;

  let _ = __bin_read_sockaddr__

  let bin_read_sockaddr : sockaddr Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 ->
      let arg_1 = bin_read_string buf ~pos_ref in
      ADDR_UNIX arg_1
    | 1 ->
      let arg_1 = Inet_addr.bin_read_t buf ~pos_ref in
      let arg_2 = bin_read_int buf ~pos_ref in
      ADDR_INET (arg_1, arg_2)
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag "core_unix.ml.before-ppx.sockaddr")
        !pos_ref
  ;;

  let _ = bin_read_sockaddr

  let bin_reader_sockaddr =
    ({ read = bin_read_sockaddr; vtag_read = __bin_read_sockaddr__ }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_sockaddr

  let bin_sockaddr =
    ({ writer = bin_writer_sockaddr
     ; reader = bin_reader_sockaddr
     ; shape = bin_shape_sockaddr
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_sockaddr
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type sockaddr_blocking_sexp = Unix.sockaddr =
  | ADDR_UNIX of string
  | ADDR_INET of Inet_addr.Blocking_sexp.t * int
[@@deriving sexp, bin_io]

include struct
  let _ = fun (_ : sockaddr_blocking_sexp) -> ()

  let sockaddr_blocking_sexp_of_sexp =
    (let error_source__612_ = "core_unix.ml.before-ppx.sockaddr_blocking_sexp" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("aDDR_UNIX" | "ADDR_UNIX") as _tag__615_)
         :: sexp_args__616_) as _sexp__614_ ->
       (match sexp_args__616_ with
        | arg0__617_ :: [] ->
          let res0__618_ = string_of_sexp arg0__617_ in
          ADDR_UNIX res0__618_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__612_
            _tag__615_
            _sexp__614_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("aDDR_INET" | "ADDR_INET") as _tag__620_)
         :: sexp_args__621_) as _sexp__619_ ->
       (match sexp_args__621_ with
        | [ arg0__622_; arg1__623_ ] ->
          let res0__624_ = Inet_addr.Blocking_sexp.t_of_sexp arg0__622_
          and res1__625_ = int_of_sexp arg1__623_ in
          ADDR_INET (res0__624_, res1__625_)
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__612_
            _tag__620_
            _sexp__619_)
     | Sexplib0.Sexp.Atom ("aDDR_UNIX" | "ADDR_UNIX") as sexp__613_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__612_ sexp__613_
     | Sexplib0.Sexp.Atom ("aDDR_INET" | "ADDR_INET") as sexp__613_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__612_ sexp__613_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__611_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__612_ sexp__611_
     | Sexplib0.Sexp.List [] as sexp__611_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__612_ sexp__611_
     | sexp__611_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__612_ sexp__611_
     : Sexplib0.Sexp.t -> sockaddr_blocking_sexp)
  ;;

  let _ = sockaddr_blocking_sexp_of_sexp

  let sexp_of_sockaddr_blocking_sexp =
    (function
     | ADDR_UNIX arg0__626_ ->
       let res0__627_ = sexp_of_string arg0__626_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ADDR_UNIX"; res0__627_ ]
     | ADDR_INET (arg0__628_, arg1__629_) ->
       let res0__630_ = Inet_addr.Blocking_sexp.sexp_of_t arg0__628_
       and res1__631_ = sexp_of_int arg1__629_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ADDR_INET"; res0__630_; res1__631_ ]
     : sockaddr_blocking_sexp -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_sockaddr_blocking_sexp

  let bin_shape_sockaddr_blocking_sexp =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:2717:0")
        [ ( Bin_prot.Shape.Tid.of_string "sockaddr_blocking_sexp"
          , []
          , Bin_prot.Shape.variant
              [ "ADDR_UNIX", [ bin_shape_string ]
              ; "ADDR_INET", [ Inet_addr.Blocking_sexp.bin_shape_t; bin_shape_int ]
              ] )
        ]
    in
    (Bin_prot.Shape.top_app
       _group
       (Bin_prot.Shape.Tid.of_string "sockaddr_blocking_sexp"))
      []
  ;;

  let _ = bin_shape_sockaddr_blocking_sexp

  let bin_size_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Size.sizer =
    function
    | ADDR_UNIX v1 ->
      let size = 1 in
      Bin_prot.Common.( + ) size (bin_size_string v1)
    | ADDR_INET (v1, v2) ->
      let size = 1 in
      let size = Bin_prot.Common.( + ) size (Inet_addr.Blocking_sexp.bin_size_t v1) in
      Bin_prot.Common.( + ) size (bin_size_int v2)
  ;;

  let _ = bin_size_sockaddr_blocking_sexp

  let bin_write_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Write.writer =
    fun buf ~pos -> function
    | ADDR_UNIX v1 ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
      bin_write_string buf ~pos v1
    | ADDR_INET (v1, v2) ->
      let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
      let pos = Inet_addr.Blocking_sexp.bin_write_t buf ~pos v1 in
      bin_write_int buf ~pos v2
  ;;

  let _ = bin_write_sockaddr_blocking_sexp

  let bin_writer_sockaddr_blocking_sexp =
    ({ size = bin_size_sockaddr_blocking_sexp; write = bin_write_sockaddr_blocking_sexp }
     : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_sockaddr_blocking_sexp

  let __bin_read_sockaddr_blocking_sexp__
    : (int -> sockaddr_blocking_sexp) Bin_prot.Read.reader
    =
    fun _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_variant_wrong_type
      "core_unix.ml.before-ppx.sockaddr_blocking_sexp"
      !pos_ref
  ;;

  let _ = __bin_read_sockaddr_blocking_sexp__

  let bin_read_sockaddr_blocking_sexp : sockaddr_blocking_sexp Bin_prot.Read.reader =
    fun buf ~pos_ref ->
    match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
    | 0 ->
      let arg_1 = bin_read_string buf ~pos_ref in
      ADDR_UNIX arg_1
    | 1 ->
      let arg_1 = Inet_addr.Blocking_sexp.bin_read_t buf ~pos_ref in
      let arg_2 = bin_read_int buf ~pos_ref in
      ADDR_INET (arg_1, arg_2)
    | _ ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Sum_tag
           "core_unix.ml.before-ppx.sockaddr_blocking_sexp")
        !pos_ref
  ;;

  let _ = bin_read_sockaddr_blocking_sexp

  let bin_reader_sockaddr_blocking_sexp =
    ({ read = bin_read_sockaddr_blocking_sexp
     ; vtag_read = __bin_read_sockaddr_blocking_sexp__
     }
     : _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_sockaddr_blocking_sexp

  let bin_sockaddr_blocking_sexp =
    ({ writer = bin_writer_sockaddr_blocking_sexp
     ; reader = bin_reader_sockaddr_blocking_sexp
     ; shape = bin_shape_sockaddr_blocking_sexp
     }
     : _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_sockaddr_blocking_sexp
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sockaddr_of_sexp = sockaddr_blocking_sexp_of_sexp
let domain_of_sockaddr = Unix.domain_of_sockaddr
let addr_r addr = "addr", sexp_of_sockaddr addr

let socket_or_pair f ?close_on_exec ~domain ~kind ~protocol () =
  improve
    (fun () -> f ?cloexec:close_on_exec ~domain ~kind ~protocol)
    (fun () ->
       [ "domain", sexp_of_socket_domain domain
       ; "kind", sexp_of_socket_type kind
       ; "protocol", Int.sexp_of_t protocol
       ; close_on_exec_r close_on_exec
       ])
;;

let socket = socket_or_pair Unix.socket
let socketpair = socket_or_pair Unix.socketpair

let accept ?close_on_exec fd =
  let fd, addr =
    improve
      (fun () -> Unix.accept ?cloexec:close_on_exec fd)
      (fun () -> [ fd_r fd; close_on_exec_r close_on_exec ])
  in
  let addr =
    match addr with
    | ADDR_UNIX _ -> ADDR_UNIX ""
    | ADDR_INET _ -> addr
  in
  fd, addr
;;

let with_socket_length_restriction_workaround f fd ~addr =
  match addr with
  | ADDR_INET _ -> f fd ~addr
  | ADDR_UNIX path ->
    (try f fd ~addr with
     | Unix_error (ENAMETOOLONG, orig1, orig2) as orig_exn ->
       (match close (openfile ~mode:[ O_CLOEXEC; O_RDONLY ] "/proc/self/fd") with
        | exception Unix_error (EINTR, _, _) -> raise (Unix_error (EINTR, orig1, orig2))
        | exception Unix_error _ -> raise orig_exn
        | () ->
          Exn.protectx
            (openfile ~mode:[ O_CLOEXEC; O_RDONLY ] (Filename.dirname path))
            ~finally:close
            ~f:(fun dirfd ->
              let path =
                sprintf
                  "/proc/self/fd/%d/%s"
                  (File_descr.to_int dirfd)
                  (Filename.basename path)
              in
              f fd ~addr:(ADDR_UNIX path))))
;;

let bind fd ~addr =
  improve
    (fun () -> with_socket_length_restriction_workaround Unix.bind fd ~addr)
    (fun () -> [ fd_r fd; addr_r addr ])
;;

let connect fd ~addr =
  improve
    (fun () -> with_socket_length_restriction_workaround Unix.connect fd ~addr)
    (fun () -> [ fd_r fd; addr_r addr ])
;;

let listen fd ~backlog =
  improve
    (fun () -> Unix.listen fd ~max:backlog)
    (fun () -> [ fd_r fd; "backlog", Int.sexp_of_t backlog ])
;;

type shutdown_command = Unix.shutdown_command =
  | SHUTDOWN_RECEIVE
  | SHUTDOWN_SEND
  | SHUTDOWN_ALL
[@@deriving sexp]

include struct
  let _ = fun (_ : shutdown_command) -> ()

  let shutdown_command_of_sexp =
    (let error_source__634_ = "core_unix.ml.before-ppx.shutdown_command" in
     function
     | Sexplib0.Sexp.Atom ("sHUTDOWN_RECEIVE" | "SHUTDOWN_RECEIVE") -> SHUTDOWN_RECEIVE
     | Sexplib0.Sexp.Atom ("sHUTDOWN_SEND" | "SHUTDOWN_SEND") -> SHUTDOWN_SEND
     | Sexplib0.Sexp.Atom ("sHUTDOWN_ALL" | "SHUTDOWN_ALL") -> SHUTDOWN_ALL
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("sHUTDOWN_RECEIVE" | "SHUTDOWN_RECEIVE") :: _) as sexp__635_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__634_ sexp__635_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sHUTDOWN_SEND" | "SHUTDOWN_SEND") :: _) as
       sexp__635_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__634_ sexp__635_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sHUTDOWN_ALL" | "SHUTDOWN_ALL") :: _) as
       sexp__635_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__634_ sexp__635_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__633_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__634_ sexp__633_
     | Sexplib0.Sexp.List [] as sexp__633_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__634_ sexp__633_
     | sexp__633_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__634_ sexp__633_
     : Sexplib0.Sexp.t -> shutdown_command)
  ;;

  let _ = shutdown_command_of_sexp

  let sexp_of_shutdown_command =
    (function
     | SHUTDOWN_RECEIVE -> Sexplib0.Sexp.Atom "SHUTDOWN_RECEIVE"
     | SHUTDOWN_SEND -> Sexplib0.Sexp.Atom "SHUTDOWN_SEND"
     | SHUTDOWN_ALL -> Sexplib0.Sexp.Atom "SHUTDOWN_ALL"
     : shutdown_command -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_shutdown_command
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let shutdown fd ~mode =
  improve
    (fun () ->
       try Unix.shutdown fd ~mode with
       | Unix.Unix_error (Unix.ENOTCONN, _, _) -> ())
    (fun () -> [ fd_r fd; "mode", sexp_of_shutdown_command mode ])
;;

let getsockname = unary_fd Unix.getsockname
let getpeername = unary_fd Unix.getpeername

type msg_flag = Unix.msg_flag =
  | MSG_OOB
  | MSG_DONTROUTE
  | MSG_PEEK
[@@deriving sexp]

include struct
  let _ = fun (_ : msg_flag) -> ()

  let msg_flag_of_sexp =
    (let error_source__638_ = "core_unix.ml.before-ppx.msg_flag" in
     function
     | Sexplib0.Sexp.Atom ("mSG_OOB" | "MSG_OOB") -> MSG_OOB
     | Sexplib0.Sexp.Atom ("mSG_DONTROUTE" | "MSG_DONTROUTE") -> MSG_DONTROUTE
     | Sexplib0.Sexp.Atom ("mSG_PEEK" | "MSG_PEEK") -> MSG_PEEK
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mSG_OOB" | "MSG_OOB") :: _) as sexp__639_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__638_ sexp__639_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mSG_DONTROUTE" | "MSG_DONTROUTE") :: _) as
       sexp__639_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__638_ sexp__639_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mSG_PEEK" | "MSG_PEEK") :: _) as
       sexp__639_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__638_ sexp__639_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__637_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__638_ sexp__637_
     | Sexplib0.Sexp.List [] as sexp__637_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__638_ sexp__637_
     | sexp__637_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__638_ sexp__637_
     : Sexplib0.Sexp.t -> msg_flag)
  ;;

  let _ = msg_flag_of_sexp

  let sexp_of_msg_flag =
    (function
     | MSG_OOB -> Sexplib0.Sexp.Atom "MSG_OOB"
     | MSG_DONTROUTE -> Sexplib0.Sexp.Atom "MSG_DONTROUTE"
     | MSG_PEEK -> Sexplib0.Sexp.Atom "MSG_PEEK"
     : msg_flag -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_msg_flag
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let recv_send f fd ~buf ~pos ~len ~mode =
  improve
    (fun () -> f fd ~buf ~pos ~len ~mode)
    (fun () ->
       [ fd_r fd
       ; "pos", Int.sexp_of_t pos
       ; len_r len
       ; "mode", sexp_of_list sexp_of_msg_flag mode
       ])
;;

let recv = recv_send Unix.recv
let recvfrom = recv_send Unix.recvfrom
let send = recv_send Unix.send
let send_substring = recv_send Unix.send_substring

let sendto fd ~buf ~pos ~len ~mode ~addr =
  improve
    (fun () -> Unix.sendto fd ~buf ~pos ~len ~mode ~addr)
    (fun () ->
       [ fd_r fd
       ; "pos", Int.sexp_of_t pos
       ; len_r len
       ; "mode", sexp_of_list sexp_of_msg_flag mode
       ; "addr", sexp_of_sockaddr addr
       ])
;;

[%%if ocaml_version >= (4, 05, 0)]

let unix_sendto_substring = Unix.sendto_substring

[%%else]

let unix_sendto_substring fd ~buf ~pos ~len ~mode addr =
  Unix.sendto_substring fd ~bug:buf ~pos ~len ~mode addr
;;

[%%endif]

let sendto_substring fd ~buf ~pos ~len ~mode ~addr =
  improve
    (fun () -> unix_sendto_substring fd ~buf ~pos ~len ~mode addr)
    (fun () ->
       [ fd_r fd
       ; "pos", Int.sexp_of_t pos
       ; len_r len
       ; "mode", sexp_of_list sexp_of_msg_flag mode
       ; "addr", sexp_of_sockaddr addr
       ])
;;

[%%if ocaml_version >= (4, 12, 0)]

type socket_bool_option = Unix.socket_bool_option =
  | SO_DEBUG
  | SO_BROADCAST
  | SO_REUSEADDR
  | SO_KEEPALIVE
  | SO_DONTROUTE
  | SO_OOBINLINE
  | SO_ACCEPTCONN
  | TCP_NODELAY
  | IPV6_ONLY
  | SO_REUSEPORT
[@@deriving sexp]

include struct
  let _ = fun (_ : socket_bool_option) -> ()

  let socket_bool_option_of_sexp =
    (let error_source__642_ = "core_unix.ml.before-ppx.socket_bool_option" in
     function
     | Sexplib0.Sexp.Atom ("sO_DEBUG" | "SO_DEBUG") -> SO_DEBUG
     | Sexplib0.Sexp.Atom ("sO_BROADCAST" | "SO_BROADCAST") -> SO_BROADCAST
     | Sexplib0.Sexp.Atom ("sO_REUSEADDR" | "SO_REUSEADDR") -> SO_REUSEADDR
     | Sexplib0.Sexp.Atom ("sO_KEEPALIVE" | "SO_KEEPALIVE") -> SO_KEEPALIVE
     | Sexplib0.Sexp.Atom ("sO_DONTROUTE" | "SO_DONTROUTE") -> SO_DONTROUTE
     | Sexplib0.Sexp.Atom ("sO_OOBINLINE" | "SO_OOBINLINE") -> SO_OOBINLINE
     | Sexplib0.Sexp.Atom ("sO_ACCEPTCONN" | "SO_ACCEPTCONN") -> SO_ACCEPTCONN
     | Sexplib0.Sexp.Atom ("tCP_NODELAY" | "TCP_NODELAY") -> TCP_NODELAY
     | Sexplib0.Sexp.Atom ("iPV6_ONLY" | "IPV6_ONLY") -> IPV6_ONLY
     | Sexplib0.Sexp.Atom ("sO_REUSEPORT" | "SO_REUSEPORT") -> SO_REUSEPORT
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_DEBUG" | "SO_DEBUG") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_BROADCAST" | "SO_BROADCAST") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_REUSEADDR" | "SO_REUSEADDR") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_KEEPALIVE" | "SO_KEEPALIVE") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_DONTROUTE" | "SO_DONTROUTE") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_OOBINLINE" | "SO_OOBINLINE") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_ACCEPTCONN" | "SO_ACCEPTCONN") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_NODELAY" | "TCP_NODELAY") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iPV6_ONLY" | "IPV6_ONLY") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_REUSEPORT" | "SO_REUSEPORT") :: _) as
       sexp__643_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__642_ sexp__643_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__641_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__642_ sexp__641_
     | Sexplib0.Sexp.List [] as sexp__641_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__642_ sexp__641_
     | sexp__641_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__642_ sexp__641_
     : Sexplib0.Sexp.t -> socket_bool_option)
  ;;

  let _ = socket_bool_option_of_sexp

  let sexp_of_socket_bool_option =
    (function
     | SO_DEBUG -> Sexplib0.Sexp.Atom "SO_DEBUG"
     | SO_BROADCAST -> Sexplib0.Sexp.Atom "SO_BROADCAST"
     | SO_REUSEADDR -> Sexplib0.Sexp.Atom "SO_REUSEADDR"
     | SO_KEEPALIVE -> Sexplib0.Sexp.Atom "SO_KEEPALIVE"
     | SO_DONTROUTE -> Sexplib0.Sexp.Atom "SO_DONTROUTE"
     | SO_OOBINLINE -> Sexplib0.Sexp.Atom "SO_OOBINLINE"
     | SO_ACCEPTCONN -> Sexplib0.Sexp.Atom "SO_ACCEPTCONN"
     | TCP_NODELAY -> Sexplib0.Sexp.Atom "TCP_NODELAY"
     | IPV6_ONLY -> Sexplib0.Sexp.Atom "IPV6_ONLY"
     | SO_REUSEPORT -> Sexplib0.Sexp.Atom "SO_REUSEPORT"
     : socket_bool_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_bool_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

[%%else]

type socket_bool_option = Unix.socket_bool_option =
  | SO_DEBUG
  | SO_BROADCAST
  | SO_REUSEADDR
  | SO_KEEPALIVE
  | SO_DONTROUTE
  | SO_OOBINLINE
  | SO_ACCEPTCONN
  | TCP_NODELAY
  | IPV6_ONLY
[@@deriving sexp]

include struct
  let _ = fun (_ : socket_bool_option) -> ()

  let socket_bool_option_of_sexp =
    (let error_source__646_ = "core_unix.ml.before-ppx.socket_bool_option" in
     function
     | Sexplib0.Sexp.Atom ("sO_DEBUG" | "SO_DEBUG") -> SO_DEBUG
     | Sexplib0.Sexp.Atom ("sO_BROADCAST" | "SO_BROADCAST") -> SO_BROADCAST
     | Sexplib0.Sexp.Atom ("sO_REUSEADDR" | "SO_REUSEADDR") -> SO_REUSEADDR
     | Sexplib0.Sexp.Atom ("sO_KEEPALIVE" | "SO_KEEPALIVE") -> SO_KEEPALIVE
     | Sexplib0.Sexp.Atom ("sO_DONTROUTE" | "SO_DONTROUTE") -> SO_DONTROUTE
     | Sexplib0.Sexp.Atom ("sO_OOBINLINE" | "SO_OOBINLINE") -> SO_OOBINLINE
     | Sexplib0.Sexp.Atom ("sO_ACCEPTCONN" | "SO_ACCEPTCONN") -> SO_ACCEPTCONN
     | Sexplib0.Sexp.Atom ("tCP_NODELAY" | "TCP_NODELAY") -> TCP_NODELAY
     | Sexplib0.Sexp.Atom ("iPV6_ONLY" | "IPV6_ONLY") -> IPV6_ONLY
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_DEBUG" | "SO_DEBUG") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_BROADCAST" | "SO_BROADCAST") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_REUSEADDR" | "SO_REUSEADDR") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_KEEPALIVE" | "SO_KEEPALIVE") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_DONTROUTE" | "SO_DONTROUTE") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_OOBINLINE" | "SO_OOBINLINE") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_ACCEPTCONN" | "SO_ACCEPTCONN") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCP_NODELAY" | "TCP_NODELAY") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iPV6_ONLY" | "IPV6_ONLY") :: _) as
       sexp__647_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__646_ sexp__647_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__645_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__646_ sexp__645_
     | Sexplib0.Sexp.List [] as sexp__645_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__646_ sexp__645_
     | sexp__645_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__646_ sexp__645_
     : Sexplib0.Sexp.t -> socket_bool_option)
  ;;

  let _ = socket_bool_option_of_sexp

  let sexp_of_socket_bool_option =
    (function
     | SO_DEBUG -> Sexplib0.Sexp.Atom "SO_DEBUG"
     | SO_BROADCAST -> Sexplib0.Sexp.Atom "SO_BROADCAST"
     | SO_REUSEADDR -> Sexplib0.Sexp.Atom "SO_REUSEADDR"
     | SO_KEEPALIVE -> Sexplib0.Sexp.Atom "SO_KEEPALIVE"
     | SO_DONTROUTE -> Sexplib0.Sexp.Atom "SO_DONTROUTE"
     | SO_OOBINLINE -> Sexplib0.Sexp.Atom "SO_OOBINLINE"
     | SO_ACCEPTCONN -> Sexplib0.Sexp.Atom "SO_ACCEPTCONN"
     | TCP_NODELAY -> Sexplib0.Sexp.Atom "TCP_NODELAY"
     | IPV6_ONLY -> Sexplib0.Sexp.Atom "IPV6_ONLY"
     : socket_bool_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_bool_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

[%%endif]

include struct
  [@@@alert "-deprecated"]

  type socket_int_option = Unix.socket_int_option =
    | SO_SNDBUF
    | SO_RCVBUF
    | SO_ERROR
    | SO_TYPE
    | SO_RCVLOWAT
    | SO_SNDLOWAT
  [@@deriving sexp]

  include struct
    let _ = fun (_ : socket_int_option) -> ()

    let socket_int_option_of_sexp =
      (let error_source__650_ = "core_unix.ml.before-ppx.socket_int_option" in
       function
       | Sexplib0.Sexp.Atom ("sO_SNDBUF" | "SO_SNDBUF") -> SO_SNDBUF
       | Sexplib0.Sexp.Atom ("sO_RCVBUF" | "SO_RCVBUF") -> SO_RCVBUF
       | Sexplib0.Sexp.Atom ("sO_ERROR" | "SO_ERROR") -> SO_ERROR
       | Sexplib0.Sexp.Atom ("sO_TYPE" | "SO_TYPE") -> SO_TYPE
       | Sexplib0.Sexp.Atom ("sO_RCVLOWAT" | "SO_RCVLOWAT") -> SO_RCVLOWAT
       | Sexplib0.Sexp.Atom ("sO_SNDLOWAT" | "SO_SNDLOWAT") -> SO_SNDLOWAT
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_SNDBUF" | "SO_SNDBUF") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_RCVBUF" | "SO_RCVBUF") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_ERROR" | "SO_ERROR") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_TYPE" | "SO_TYPE") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_RCVLOWAT" | "SO_RCVLOWAT") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_SNDLOWAT" | "SO_SNDLOWAT") :: _) as
         sexp__651_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__650_ sexp__651_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__649_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__650_ sexp__649_
       | Sexplib0.Sexp.List [] as sexp__649_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__650_ sexp__649_
       | sexp__649_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__650_ sexp__649_
       : Sexplib0.Sexp.t -> socket_int_option)
    ;;

    let _ = socket_int_option_of_sexp

    let sexp_of_socket_int_option =
      (function
       | SO_SNDBUF -> Sexplib0.Sexp.Atom "SO_SNDBUF"
       | SO_RCVBUF -> Sexplib0.Sexp.Atom "SO_RCVBUF"
       | SO_ERROR -> Sexplib0.Sexp.Atom "SO_ERROR"
       | SO_TYPE -> Sexplib0.Sexp.Atom "SO_TYPE"
       | SO_RCVLOWAT -> Sexplib0.Sexp.Atom "SO_RCVLOWAT"
       | SO_SNDLOWAT -> Sexplib0.Sexp.Atom "SO_SNDLOWAT"
       : socket_int_option -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_socket_int_option
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

type socket_optint_option = Unix.socket_optint_option = SO_LINGER [@@deriving sexp]

include struct
  let _ = fun (_ : socket_optint_option) -> ()

  let socket_optint_option_of_sexp =
    (let error_source__654_ = "core_unix.ml.before-ppx.socket_optint_option" in
     function
     | Sexplib0.Sexp.Atom ("sO_LINGER" | "SO_LINGER") -> SO_LINGER
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_LINGER" | "SO_LINGER") :: _) as
       sexp__655_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__654_ sexp__655_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__653_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__654_ sexp__653_
     | Sexplib0.Sexp.List [] as sexp__653_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__654_ sexp__653_
     | sexp__653_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__654_ sexp__653_
     : Sexplib0.Sexp.t -> socket_optint_option)
  ;;

  let _ = socket_optint_option_of_sexp

  let sexp_of_socket_optint_option =
    (fun SO_LINGER -> Sexplib0.Sexp.Atom "SO_LINGER"
     : socket_optint_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_optint_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type socket_float_option = Unix.socket_float_option =
  | SO_RCVTIMEO
  | SO_SNDTIMEO
[@@deriving sexp]

include struct
  let _ = fun (_ : socket_float_option) -> ()

  let socket_float_option_of_sexp =
    (let error_source__658_ = "core_unix.ml.before-ppx.socket_float_option" in
     function
     | Sexplib0.Sexp.Atom ("sO_RCVTIMEO" | "SO_RCVTIMEO") -> SO_RCVTIMEO
     | Sexplib0.Sexp.Atom ("sO_SNDTIMEO" | "SO_SNDTIMEO") -> SO_SNDTIMEO
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_RCVTIMEO" | "SO_RCVTIMEO") :: _) as
       sexp__659_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__658_ sexp__659_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sO_SNDTIMEO" | "SO_SNDTIMEO") :: _) as
       sexp__659_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__658_ sexp__659_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__657_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__658_ sexp__657_
     | Sexplib0.Sexp.List [] as sexp__657_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__658_ sexp__657_
     | sexp__657_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__658_ sexp__657_
     : Sexplib0.Sexp.t -> socket_float_option)
  ;;

  let _ = socket_float_option_of_sexp

  let sexp_of_socket_float_option =
    (function
     | SO_RCVTIMEO -> Sexplib0.Sexp.Atom "SO_RCVTIMEO"
     | SO_SNDTIMEO -> Sexplib0.Sexp.Atom "SO_SNDTIMEO"
     : socket_float_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_socket_float_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let make_sockopt get set sexp_of_opt sexp_of_val =
  let getsockopt fd opt =
    improve (fun () -> get fd opt) (fun () -> [ fd_r fd; "opt", sexp_of_opt opt ])
  in
  let setsockopt fd opt value =
    improve
      (fun () -> set fd opt value)
      (fun () -> [ fd_r fd; "opt", sexp_of_opt opt; "val", sexp_of_val value ])
  in
  getsockopt, setsockopt
;;

let getsockopt, setsockopt =
  make_sockopt Unix.getsockopt Unix.setsockopt sexp_of_socket_bool_option sexp_of_bool
;;

let getsockopt_int, setsockopt_int =
  make_sockopt
    Unix.getsockopt_int
    Unix.setsockopt_int
    sexp_of_socket_int_option
    sexp_of_int
;;

let getsockopt_optint, setsockopt_optint =
  make_sockopt
    Unix.getsockopt_optint
    Unix.setsockopt_optint
    sexp_of_socket_optint_option
    (sexp_of_option sexp_of_int)
;;

let getsockopt_float, setsockopt_float =
  make_sockopt
    Unix.getsockopt_float
    Unix.setsockopt_float
    sexp_of_socket_float_option
    sexp_of_float
;;

external if_indextoname : int -> string = "core_unix_if_indextoname"
external if_nametoindex : string -> int = "core_unix_if_nametoindex"

module Mcast_action = struct
  type t =
    | Add
    | Drop
end

external mcast_modify
  :  Mcast_action.t
  -> ?ifname:string
  -> ?source:Inet_addr.t
  -> File_descr.t
  -> Unix.sockaddr
  -> unit
  = "core_unix_mcast_modify"

let mcast_join ?ifname ?source fd sockaddr =
  mcast_modify Mcast_action.Add ?ifname ?source fd sockaddr
;;

let mcast_leave ?ifname ?source fd sockaddr =
  mcast_modify Mcast_action.Drop ?ifname ?source fd sockaddr
;;

external get_mcast_ttl : File_descr.t -> int = "core_unix_mcast_get_ttl"
external set_mcast_ttl : File_descr.t -> int -> unit = "core_unix_mcast_set_ttl"
external get_mcast_loop : File_descr.t -> bool = "core_unix_mcast_get_loop"
external set_mcast_loop : File_descr.t -> bool -> unit = "core_unix_mcast_set_loop"
external set_mcast_ifname : File_descr.t -> string -> unit = "core_unix_mcast_set_ifname"

let set_mcast_ifname fd ifname =
  try set_mcast_ifname fd ifname with
  | Unix_error (message, errno, "") -> raise (Unix_error (message, errno, ifname))
;;

let open_connection addr =
  improve (fun () -> Unix.open_connection addr) (fun () -> [ addr_r addr ])
;;

let shutdown_connection = Unix.shutdown_connection

let establish_server handle_connection ~addr =
  improve
    (fun () -> Unix.establish_server handle_connection ~addr)
    (fun () -> [ addr_r addr ])
;;

type addr_info = Unix.addr_info =
  { ai_family : socket_domain
  ; ai_socktype : socket_type
  ; ai_protocol : int
  ; ai_addr : sockaddr
  ; ai_canonname : string
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : addr_info) -> ()

  let sexp_of_addr_info =
    (fun { ai_family = ai_family__661_
         ; ai_socktype = ai_socktype__663_
         ; ai_protocol = ai_protocol__665_
         ; ai_addr = ai_addr__667_
         ; ai_canonname = ai_canonname__669_
         } ->
       let bnds__660_ = ([] : _ Stdlib.List.t) in
       let bnds__660_ =
         let arg__670_ = sexp_of_string ai_canonname__669_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_canonname"; arg__670_ ]
          :: bnds__660_
          : _ Stdlib.List.t)
       in
       let bnds__660_ =
         let arg__668_ = sexp_of_sockaddr ai_addr__667_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_addr"; arg__668_ ] :: bnds__660_
          : _ Stdlib.List.t)
       in
       let bnds__660_ =
         let arg__666_ = sexp_of_int ai_protocol__665_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_protocol"; arg__666_ ] :: bnds__660_
          : _ Stdlib.List.t)
       in
       let bnds__660_ =
         let arg__664_ = sexp_of_socket_type ai_socktype__663_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_socktype"; arg__664_ ] :: bnds__660_
          : _ Stdlib.List.t)
       in
       let bnds__660_ =
         let arg__662_ = sexp_of_socket_domain ai_family__661_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_family"; arg__662_ ] :: bnds__660_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__660_
     : addr_info -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_addr_info
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type addr_info_blocking_sexp = Unix.addr_info =
  { ai_family : socket_domain
  ; ai_socktype : socket_type
  ; ai_protocol : int
  ; ai_addr : sockaddr_blocking_sexp
  ; ai_canonname : string
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : addr_info_blocking_sexp) -> ()

  let addr_info_blocking_sexp_of_sexp =
    (let error_source__672_ = "core_unix.ml.before-ppx.addr_info_blocking_sexp" in
     fun x__673_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__672_
         ~fields:
           (Field
              { name = "ai_family"
              ; kind = Required
              ; conv = socket_domain_of_sexp
              ; rest =
                  Field
                    { name = "ai_socktype"
                    ; kind = Required
                    ; conv = socket_type_of_sexp
                    ; rest =
                        Field
                          { name = "ai_protocol"
                          ; kind = Required
                          ; conv = int_of_sexp
                          ; rest =
                              Field
                                { name = "ai_addr"
                                ; kind = Required
                                ; conv = sockaddr_blocking_sexp_of_sexp
                                ; rest =
                                    Field
                                      { name = "ai_canonname"
                                      ; kind = Required
                                      ; conv = string_of_sexp
                                      ; rest = Empty
                                      }
                                }
                          }
                    }
              })
         ~index_of_field:(function
           | "ai_family" -> 0
           | "ai_socktype" -> 1
           | "ai_protocol" -> 2
           | "ai_addr" -> 3
           | "ai_canonname" -> 4
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:
           (fun
             (ai_family, (ai_socktype, (ai_protocol, (ai_addr, (ai_canonname, ()))))) ->
           ({ ai_family; ai_socktype; ai_protocol; ai_addr; ai_canonname }
            : addr_info_blocking_sexp))
         x__673_
     : Sexplib0.Sexp.t -> addr_info_blocking_sexp)
  ;;

  let _ = addr_info_blocking_sexp_of_sexp

  let sexp_of_addr_info_blocking_sexp =
    (fun { ai_family = ai_family__675_
         ; ai_socktype = ai_socktype__677_
         ; ai_protocol = ai_protocol__679_
         ; ai_addr = ai_addr__681_
         ; ai_canonname = ai_canonname__683_
         } ->
       let bnds__674_ = ([] : _ Stdlib.List.t) in
       let bnds__674_ =
         let arg__684_ = sexp_of_string ai_canonname__683_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_canonname"; arg__684_ ]
          :: bnds__674_
          : _ Stdlib.List.t)
       in
       let bnds__674_ =
         let arg__682_ = sexp_of_sockaddr_blocking_sexp ai_addr__681_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_addr"; arg__682_ ] :: bnds__674_
          : _ Stdlib.List.t)
       in
       let bnds__674_ =
         let arg__680_ = sexp_of_int ai_protocol__679_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_protocol"; arg__680_ ] :: bnds__674_
          : _ Stdlib.List.t)
       in
       let bnds__674_ =
         let arg__678_ = sexp_of_socket_type ai_socktype__677_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_socktype"; arg__678_ ] :: bnds__674_
          : _ Stdlib.List.t)
       in
       let bnds__674_ =
         let arg__676_ = sexp_of_socket_domain ai_family__675_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ai_family"; arg__676_ ] :: bnds__674_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__674_
     : addr_info_blocking_sexp -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_addr_info_blocking_sexp
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type getaddrinfo_option = Unix.getaddrinfo_option =
  | AI_FAMILY of socket_domain
  | AI_SOCKTYPE of socket_type
  | AI_PROTOCOL of int
  | AI_NUMERICHOST
  | AI_CANONNAME
  | AI_PASSIVE
[@@deriving sexp]

include struct
  let _ = fun (_ : getaddrinfo_option) -> ()

  let getaddrinfo_option_of_sexp =
    (let error_source__687_ = "core_unix.ml.before-ppx.getaddrinfo_option" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("aI_FAMILY" | "AI_FAMILY") as _tag__690_)
         :: sexp_args__691_) as _sexp__689_ ->
       (match sexp_args__691_ with
        | arg0__692_ :: [] ->
          let res0__693_ = socket_domain_of_sexp arg0__692_ in
          AI_FAMILY res0__693_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__687_
            _tag__690_
            _sexp__689_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("aI_SOCKTYPE" | "AI_SOCKTYPE") as _tag__695_)
         :: sexp_args__696_) as _sexp__694_ ->
       (match sexp_args__696_ with
        | arg0__697_ :: [] ->
          let res0__698_ = socket_type_of_sexp arg0__697_ in
          AI_SOCKTYPE res0__698_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__687_
            _tag__695_
            _sexp__694_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("aI_PROTOCOL" | "AI_PROTOCOL") as _tag__700_)
         :: sexp_args__701_) as _sexp__699_ ->
       (match sexp_args__701_ with
        | arg0__702_ :: [] ->
          let res0__703_ = int_of_sexp arg0__702_ in
          AI_PROTOCOL res0__703_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__687_
            _tag__700_
            _sexp__699_)
     | Sexplib0.Sexp.Atom ("aI_NUMERICHOST" | "AI_NUMERICHOST") -> AI_NUMERICHOST
     | Sexplib0.Sexp.Atom ("aI_CANONNAME" | "AI_CANONNAME") -> AI_CANONNAME
     | Sexplib0.Sexp.Atom ("aI_PASSIVE" | "AI_PASSIVE") -> AI_PASSIVE
     | Sexplib0.Sexp.Atom ("aI_FAMILY" | "AI_FAMILY") as sexp__688_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.Atom ("aI_SOCKTYPE" | "AI_SOCKTYPE") as sexp__688_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.Atom ("aI_PROTOCOL" | "AI_PROTOCOL") as sexp__688_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aI_NUMERICHOST" | "AI_NUMERICHOST") :: _)
       as sexp__688_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aI_CANONNAME" | "AI_CANONNAME") :: _) as
       sexp__688_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aI_PASSIVE" | "AI_PASSIVE") :: _) as
       sexp__688_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__687_ sexp__688_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__686_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__687_ sexp__686_
     | Sexplib0.Sexp.List [] as sexp__686_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__687_ sexp__686_
     | sexp__686_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__687_ sexp__686_
     : Sexplib0.Sexp.t -> getaddrinfo_option)
  ;;

  let _ = getaddrinfo_option_of_sexp

  let sexp_of_getaddrinfo_option =
    (function
     | AI_FAMILY arg0__704_ ->
       let res0__705_ = sexp_of_socket_domain arg0__704_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "AI_FAMILY"; res0__705_ ]
     | AI_SOCKTYPE arg0__706_ ->
       let res0__707_ = sexp_of_socket_type arg0__706_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "AI_SOCKTYPE"; res0__707_ ]
     | AI_PROTOCOL arg0__708_ ->
       let res0__709_ = sexp_of_int arg0__708_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "AI_PROTOCOL"; res0__709_ ]
     | AI_NUMERICHOST -> Sexplib0.Sexp.Atom "AI_NUMERICHOST"
     | AI_CANONNAME -> Sexplib0.Sexp.Atom "AI_CANONNAME"
     | AI_PASSIVE -> Sexplib0.Sexp.Atom "AI_PASSIVE"
     : getaddrinfo_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_getaddrinfo_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let getaddrinfo host service opts =
  improve
    (fun () -> Unix.getaddrinfo host service opts)
    (fun () ->
       [ "host", atom host
       ; "service", atom service
       ; "opts", sexp_of_list sexp_of_getaddrinfo_option opts
       ])
;;

type name_info = Unix.name_info =
  { ni_hostname : string
  ; ni_service : string
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : name_info) -> ()

  let name_info_of_sexp =
    (let error_source__711_ = "core_unix.ml.before-ppx.name_info" in
     fun x__712_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__711_
         ~fields:
           (Field
              { name = "ni_hostname"
              ; kind = Required
              ; conv = string_of_sexp
              ; rest =
                  Field
                    { name = "ni_service"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest = Empty
                    }
              })
         ~index_of_field:(function
           | "ni_hostname" -> 0
           | "ni_service" -> 1
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:(fun (ni_hostname, (ni_service, ())) ->
           ({ ni_hostname; ni_service } : name_info))
         x__712_
     : Sexplib0.Sexp.t -> name_info)
  ;;

  let _ = name_info_of_sexp

  let sexp_of_name_info =
    (fun { ni_hostname = ni_hostname__714_; ni_service = ni_service__716_ } ->
       let bnds__713_ = ([] : _ Stdlib.List.t) in
       let bnds__713_ =
         let arg__717_ = sexp_of_string ni_service__716_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ni_service"; arg__717_ ] :: bnds__713_
          : _ Stdlib.List.t)
       in
       let bnds__713_ =
         let arg__715_ = sexp_of_string ni_hostname__714_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ni_hostname"; arg__715_ ] :: bnds__713_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__713_
     : name_info -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_name_info
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type getnameinfo_option = Unix.getnameinfo_option =
  | NI_NOFQDN
  | NI_NUMERICHOST
  | NI_NAMEREQD
  | NI_NUMERICSERV
  | NI_DGRAM
[@@deriving sexp]

include struct
  let _ = fun (_ : getnameinfo_option) -> ()

  let getnameinfo_option_of_sexp =
    (let error_source__720_ = "core_unix.ml.before-ppx.getnameinfo_option" in
     function
     | Sexplib0.Sexp.Atom ("nI_NOFQDN" | "NI_NOFQDN") -> NI_NOFQDN
     | Sexplib0.Sexp.Atom ("nI_NUMERICHOST" | "NI_NUMERICHOST") -> NI_NUMERICHOST
     | Sexplib0.Sexp.Atom ("nI_NAMEREQD" | "NI_NAMEREQD") -> NI_NAMEREQD
     | Sexplib0.Sexp.Atom ("nI_NUMERICSERV" | "NI_NUMERICSERV") -> NI_NUMERICSERV
     | Sexplib0.Sexp.Atom ("nI_DGRAM" | "NI_DGRAM") -> NI_DGRAM
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nI_NOFQDN" | "NI_NOFQDN") :: _) as
       sexp__721_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__720_ sexp__721_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nI_NUMERICHOST" | "NI_NUMERICHOST") :: _)
       as sexp__721_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__720_ sexp__721_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nI_NAMEREQD" | "NI_NAMEREQD") :: _) as
       sexp__721_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__720_ sexp__721_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nI_NUMERICSERV" | "NI_NUMERICSERV") :: _)
       as sexp__721_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__720_ sexp__721_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nI_DGRAM" | "NI_DGRAM") :: _) as
       sexp__721_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__720_ sexp__721_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__719_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__720_ sexp__719_
     | Sexplib0.Sexp.List [] as sexp__719_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__720_ sexp__719_
     | sexp__719_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__720_ sexp__719_
     : Sexplib0.Sexp.t -> getnameinfo_option)
  ;;

  let _ = getnameinfo_option_of_sexp

  let sexp_of_getnameinfo_option =
    (function
     | NI_NOFQDN -> Sexplib0.Sexp.Atom "NI_NOFQDN"
     | NI_NUMERICHOST -> Sexplib0.Sexp.Atom "NI_NUMERICHOST"
     | NI_NAMEREQD -> Sexplib0.Sexp.Atom "NI_NAMEREQD"
     | NI_NUMERICSERV -> Sexplib0.Sexp.Atom "NI_NUMERICSERV"
     | NI_DGRAM -> Sexplib0.Sexp.Atom "NI_DGRAM"
     : getnameinfo_option -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_getnameinfo_option
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let getnameinfo addr opts =
  improve
    (fun () ->
       try Unix.getnameinfo addr opts with
       | Stdlib.Not_found ->
         raise
           (Not_found_s
              (let ppx_sexp_message () =
                 Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unix.getnameinfo: not found"
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "addr"
                       ; (sexp_of_sockaddr [@merlin.hide]) addr
                       ]
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "opts"
                       ; ((fun x__722_ -> sexp_of_list sexp_of_getnameinfo_option x__722_)
                            [@merlin.hide])
                           opts
                       ]
                   ]
                   [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
               in
               (ppx_sexp_message () [@nontail]))))
    (fun () ->
       [ "addr", sexp_of_sockaddr addr
       ; "opts", sexp_of_list sexp_of_getnameinfo_option opts
       ])
;;

module Terminal_io = struct
  type t = Unix.terminal_io =
    { mutable c_ignbrk : bool
    ; mutable c_brkint : bool
    ; mutable c_ignpar : bool
    ; mutable c_parmrk : bool
    ; mutable c_inpck : bool
    ; mutable c_istrip : bool
    ; mutable c_inlcr : bool
    ; mutable c_igncr : bool
    ; mutable c_icrnl : bool
    ; mutable c_ixon : bool
    ; mutable c_ixoff : bool
    ; mutable c_opost : bool
    ; mutable c_obaud : int
    ; mutable c_ibaud : int
    ; mutable c_csize : int
    ; mutable c_cstopb : int
    ; mutable c_cread : bool
    ; mutable c_parenb : bool
    ; mutable c_parodd : bool
    ; mutable c_hupcl : bool
    ; mutable c_clocal : bool
    ; mutable c_isig : bool
    ; mutable c_icanon : bool
    ; mutable c_noflsh : bool
    ; mutable c_echo : bool
    ; mutable c_echoe : bool
    ; mutable c_echok : bool
    ; mutable c_echonl : bool
    ; mutable c_vintr : char
    ; mutable c_vquit : char
    ; mutable c_verase : char
    ; mutable c_vkill : char
    ; mutable c_veof : char
    ; mutable c_veol : char
    ; mutable c_vmin : int
    ; mutable c_vtime : int
    ; mutable c_vstart : char
    ; mutable c_vstop : char
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__724_ = "core_unix.ml.before-ppx.Terminal_io.t" in
       fun x__725_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__724_
           ~fields:
             (Field
                { name = "c_ignbrk"
                ; kind = Required
                ; conv = bool_of_sexp
                ; rest =
                    Field
                      { name = "c_brkint"
                      ; kind = Required
                      ; conv = bool_of_sexp
                      ; rest =
                          Field
                            { name = "c_ignpar"
                            ; kind = Required
                            ; conv = bool_of_sexp
                            ; rest =
                                Field
                                  { name = "c_parmrk"
                                  ; kind = Required
                                  ; conv = bool_of_sexp
                                  ; rest =
                                      Field
                                        { name = "c_inpck"
                                        ; kind = Required
                                        ; conv = bool_of_sexp
                                        ; rest =
                                            Field
                                              { name = "c_istrip"
                                              ; kind = Required
                                              ; conv = bool_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "c_inlcr"
                                                    ; kind = Required
                                                    ; conv = bool_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "c_igncr"
                                                          ; kind = Required
                                                          ; conv = bool_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "c_icrnl"
                                                                ; kind = Required
                                                                ; conv = bool_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name = "c_ixon"
                                                                      ; kind = Required
                                                                      ; conv =
                                                                          bool_of_sexp
                                                                      ; rest =
                                                                          Field
                                                                            { name =
                                                                                "c_ixoff"
                                                                            ; kind =
                                                                                Required
                                                                            ; conv =
                                                                                bool_of_sexp
                                                                            ; rest =
                                                                                Field
                                                                                  { name =
                                                                                      "c_opost"
                                                                                  ; kind =
                                                                                      Required
                                                                                  ; conv =
                                                                                      bool_of_sexp
                                                                                  ; rest =
                                                                                      Field
                                                                                        { name =
                                                                                          "c_obaud"
                                                                                        ; kind =
                                                                                          Required
                                                                                        ; conv =
                                                                                          int_of_sexp
                                                                                        ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_ibaud"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_csize"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_cstopb"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_cread"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_parenb"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_parodd"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_hupcl"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_clocal"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_isig"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_icanon"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_noflsh"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_echo"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_echoe"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_echok"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_echonl"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vintr"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vquit"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_verase"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vkill"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_veof"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_veol"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vmin"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vtime"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          int_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vstart"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "c_vstop"
                                                                                          ; 
                                                                                          kind =
                                                                                          Required
                                                                                          ; 
                                                                                          conv =
                                                                                          char_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                        }
                                                                                  }
                                                                            }
                                                                      }
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "c_ignbrk" -> 0
             | "c_brkint" -> 1
             | "c_ignpar" -> 2
             | "c_parmrk" -> 3
             | "c_inpck" -> 4
             | "c_istrip" -> 5
             | "c_inlcr" -> 6
             | "c_igncr" -> 7
             | "c_icrnl" -> 8
             | "c_ixon" -> 9
             | "c_ixoff" -> 10
             | "c_opost" -> 11
             | "c_obaud" -> 12
             | "c_ibaud" -> 13
             | "c_csize" -> 14
             | "c_cstopb" -> 15
             | "c_cread" -> 16
             | "c_parenb" -> 17
             | "c_parodd" -> 18
             | "c_hupcl" -> 19
             | "c_clocal" -> 20
             | "c_isig" -> 21
             | "c_icanon" -> 22
             | "c_noflsh" -> 23
             | "c_echo" -> 24
             | "c_echoe" -> 25
             | "c_echok" -> 26
             | "c_echonl" -> 27
             | "c_vintr" -> 28
             | "c_vquit" -> 29
             | "c_verase" -> 30
             | "c_vkill" -> 31
             | "c_veof" -> 32
             | "c_veol" -> 33
             | "c_vmin" -> 34
             | "c_vtime" -> 35
             | "c_vstart" -> 36
             | "c_vstop" -> 37
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( c_ignbrk
               , ( c_brkint
                 , ( c_ignpar
                   , ( c_parmrk
                     , ( c_inpck
                       , ( c_istrip
                         , ( c_inlcr
                           , ( c_igncr
                             , ( c_icrnl
                               , ( c_ixon
                                 , ( c_ixoff
                                   , ( c_opost
                                     , ( c_obaud
                                       , ( c_ibaud
                                         , ( c_csize
                                           , ( c_cstopb
                                             , ( c_cread
                                               , ( c_parenb
                                                 , ( c_parodd
                                                   , ( c_hupcl
                                                     , ( c_clocal
                                                       , ( c_isig
                                                         , ( c_icanon
                                                           , ( c_noflsh
                                                             , ( c_echo
                                                               , ( c_echoe
                                                                 , ( c_echok
                                                                   , ( c_echonl
                                                                     , ( c_vintr
                                                                       , ( c_vquit
                                                                         , ( c_verase
                                                                           , ( c_vkill
                                                                             , ( c_veof
                                                                               , ( c_veol
                                                                                 , ( c_vmin
                                                                                   , ( c_vtime
                                                                                     , ( c_vstart
                                                                                       , ( 
                                                                                         c_vstop
                                                                                       , ()
                                                                                         )
                                                                                       )
                                                                                     ) )
                                                                                 ) ) ) )
                                                                         ) ) ) ) ) ) ) )
                                                         ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
                         ) ) ) ) ) ) ->
             ({ c_ignbrk
              ; c_brkint
              ; c_ignpar
              ; c_parmrk
              ; c_inpck
              ; c_istrip
              ; c_inlcr
              ; c_igncr
              ; c_icrnl
              ; c_ixon
              ; c_ixoff
              ; c_opost
              ; c_obaud
              ; c_ibaud
              ; c_csize
              ; c_cstopb
              ; c_cread
              ; c_parenb
              ; c_parodd
              ; c_hupcl
              ; c_clocal
              ; c_isig
              ; c_icanon
              ; c_noflsh
              ; c_echo
              ; c_echoe
              ; c_echok
              ; c_echonl
              ; c_vintr
              ; c_vquit
              ; c_verase
              ; c_vkill
              ; c_veof
              ; c_veol
              ; c_vmin
              ; c_vtime
              ; c_vstart
              ; c_vstop
              }
              : t))
           x__725_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { c_ignbrk = c_ignbrk__727_
           ; c_brkint = c_brkint__729_
           ; c_ignpar = c_ignpar__731_
           ; c_parmrk = c_parmrk__733_
           ; c_inpck = c_inpck__735_
           ; c_istrip = c_istrip__737_
           ; c_inlcr = c_inlcr__739_
           ; c_igncr = c_igncr__741_
           ; c_icrnl = c_icrnl__743_
           ; c_ixon = c_ixon__745_
           ; c_ixoff = c_ixoff__747_
           ; c_opost = c_opost__749_
           ; c_obaud = c_obaud__751_
           ; c_ibaud = c_ibaud__753_
           ; c_csize = c_csize__755_
           ; c_cstopb = c_cstopb__757_
           ; c_cread = c_cread__759_
           ; c_parenb = c_parenb__761_
           ; c_parodd = c_parodd__763_
           ; c_hupcl = c_hupcl__765_
           ; c_clocal = c_clocal__767_
           ; c_isig = c_isig__769_
           ; c_icanon = c_icanon__771_
           ; c_noflsh = c_noflsh__773_
           ; c_echo = c_echo__775_
           ; c_echoe = c_echoe__777_
           ; c_echok = c_echok__779_
           ; c_echonl = c_echonl__781_
           ; c_vintr = c_vintr__783_
           ; c_vquit = c_vquit__785_
           ; c_verase = c_verase__787_
           ; c_vkill = c_vkill__789_
           ; c_veof = c_veof__791_
           ; c_veol = c_veol__793_
           ; c_vmin = c_vmin__795_
           ; c_vtime = c_vtime__797_
           ; c_vstart = c_vstart__799_
           ; c_vstop = c_vstop__801_
           } ->
         let bnds__726_ = ([] : _ Stdlib.List.t) in
         let bnds__726_ =
           let arg__802_ = sexp_of_char c_vstop__801_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vstop"; arg__802_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__800_ = sexp_of_char c_vstart__799_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vstart"; arg__800_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__798_ = sexp_of_int c_vtime__797_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vtime"; arg__798_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__796_ = sexp_of_int c_vmin__795_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vmin"; arg__796_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__794_ = sexp_of_char c_veol__793_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_veol"; arg__794_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__792_ = sexp_of_char c_veof__791_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_veof"; arg__792_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__790_ = sexp_of_char c_vkill__789_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vkill"; arg__790_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__788_ = sexp_of_char c_verase__787_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_verase"; arg__788_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__786_ = sexp_of_char c_vquit__785_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vquit"; arg__786_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__784_ = sexp_of_char c_vintr__783_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_vintr"; arg__784_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__782_ = sexp_of_bool c_echonl__781_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_echonl"; arg__782_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__780_ = sexp_of_bool c_echok__779_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_echok"; arg__780_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__778_ = sexp_of_bool c_echoe__777_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_echoe"; arg__778_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__776_ = sexp_of_bool c_echo__775_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_echo"; arg__776_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__774_ = sexp_of_bool c_noflsh__773_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_noflsh"; arg__774_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__772_ = sexp_of_bool c_icanon__771_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_icanon"; arg__772_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__770_ = sexp_of_bool c_isig__769_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_isig"; arg__770_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__768_ = sexp_of_bool c_clocal__767_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_clocal"; arg__768_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__766_ = sexp_of_bool c_hupcl__765_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_hupcl"; arg__766_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__764_ = sexp_of_bool c_parodd__763_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_parodd"; arg__764_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__762_ = sexp_of_bool c_parenb__761_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_parenb"; arg__762_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__760_ = sexp_of_bool c_cread__759_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_cread"; arg__760_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__758_ = sexp_of_int c_cstopb__757_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_cstopb"; arg__758_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__756_ = sexp_of_int c_csize__755_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_csize"; arg__756_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__754_ = sexp_of_int c_ibaud__753_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_ibaud"; arg__754_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__752_ = sexp_of_int c_obaud__751_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_obaud"; arg__752_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__750_ = sexp_of_bool c_opost__749_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_opost"; arg__750_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__748_ = sexp_of_bool c_ixoff__747_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_ixoff"; arg__748_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__746_ = sexp_of_bool c_ixon__745_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_ixon"; arg__746_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__744_ = sexp_of_bool c_icrnl__743_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_icrnl"; arg__744_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__742_ = sexp_of_bool c_igncr__741_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_igncr"; arg__742_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__740_ = sexp_of_bool c_inlcr__739_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_inlcr"; arg__740_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__738_ = sexp_of_bool c_istrip__737_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_istrip"; arg__738_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__736_ = sexp_of_bool c_inpck__735_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_inpck"; arg__736_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__734_ = sexp_of_bool c_parmrk__733_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_parmrk"; arg__734_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__732_ = sexp_of_bool c_ignpar__731_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_ignpar"; arg__732_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__730_ = sexp_of_bool c_brkint__729_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_brkint"; arg__730_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         let bnds__726_ =
           let arg__728_ = sexp_of_bool c_ignbrk__727_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "c_ignbrk"; arg__728_ ] :: bnds__726_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__726_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let tcgetattr = unary_fd Unix.tcgetattr

  type setattr_when = Unix.setattr_when =
    | TCSANOW
    | TCSADRAIN
    | TCSAFLUSH
  [@@deriving sexp]

  include struct
    let _ = fun (_ : setattr_when) -> ()

    let setattr_when_of_sexp =
      (let error_source__805_ = "core_unix.ml.before-ppx.Terminal_io.setattr_when" in
       function
       | Sexplib0.Sexp.Atom ("tCSANOW" | "TCSANOW") -> TCSANOW
       | Sexplib0.Sexp.Atom ("tCSADRAIN" | "TCSADRAIN") -> TCSADRAIN
       | Sexplib0.Sexp.Atom ("tCSAFLUSH" | "TCSAFLUSH") -> TCSAFLUSH
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCSANOW" | "TCSANOW") :: _) as
         sexp__806_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__805_ sexp__806_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCSADRAIN" | "TCSADRAIN") :: _) as
         sexp__806_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__805_ sexp__806_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCSAFLUSH" | "TCSAFLUSH") :: _) as
         sexp__806_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__805_ sexp__806_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__804_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__805_ sexp__804_
       | Sexplib0.Sexp.List [] as sexp__804_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__805_ sexp__804_
       | sexp__804_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__805_ sexp__804_
       : Sexplib0.Sexp.t -> setattr_when)
    ;;

    let _ = setattr_when_of_sexp

    let sexp_of_setattr_when =
      (function
       | TCSANOW -> Sexplib0.Sexp.Atom "TCSANOW"
       | TCSADRAIN -> Sexplib0.Sexp.Atom "TCSADRAIN"
       | TCSAFLUSH -> Sexplib0.Sexp.Atom "TCSAFLUSH"
       : setattr_when -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_setattr_when
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let tcsetattr t fd ~mode =
    improve
      (fun () -> Unix.tcsetattr fd ~mode t)
      (fun () -> [ fd_r fd; "mode", sexp_of_setattr_when mode; "termios", sexp_of_t t ])
  ;;

  let tcsendbreak fd ~duration =
    improve
      (fun () -> Unix.tcsendbreak fd ~duration)
      (fun () -> [ fd_r fd; "duration", Int.sexp_of_t duration ])
  ;;

  let tcdrain = unary_fd Unix.tcdrain

  type flush_queue = Unix.flush_queue =
    | TCIFLUSH
    | TCOFLUSH
    | TCIOFLUSH
  [@@deriving sexp]

  include struct
    let _ = fun (_ : flush_queue) -> ()

    let flush_queue_of_sexp =
      (let error_source__809_ = "core_unix.ml.before-ppx.Terminal_io.flush_queue" in
       function
       | Sexplib0.Sexp.Atom ("tCIFLUSH" | "TCIFLUSH") -> TCIFLUSH
       | Sexplib0.Sexp.Atom ("tCOFLUSH" | "TCOFLUSH") -> TCOFLUSH
       | Sexplib0.Sexp.Atom ("tCIOFLUSH" | "TCIOFLUSH") -> TCIOFLUSH
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCIFLUSH" | "TCIFLUSH") :: _) as
         sexp__810_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__809_ sexp__810_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCOFLUSH" | "TCOFLUSH") :: _) as
         sexp__810_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__809_ sexp__810_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCIOFLUSH" | "TCIOFLUSH") :: _) as
         sexp__810_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__809_ sexp__810_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__808_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__809_ sexp__808_
       | Sexplib0.Sexp.List [] as sexp__808_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__809_ sexp__808_
       | sexp__808_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__809_ sexp__808_
       : Sexplib0.Sexp.t -> flush_queue)
    ;;

    let _ = flush_queue_of_sexp

    let sexp_of_flush_queue =
      (function
       | TCIFLUSH -> Sexplib0.Sexp.Atom "TCIFLUSH"
       | TCOFLUSH -> Sexplib0.Sexp.Atom "TCOFLUSH"
       | TCIOFLUSH -> Sexplib0.Sexp.Atom "TCIOFLUSH"
       : flush_queue -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_flush_queue
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let tcflush fd ~mode =
    improve
      (fun () -> Unix.tcflush fd ~mode)
      (fun () -> [ fd_r fd; "mode", sexp_of_flush_queue mode ])
  ;;

  type flow_action = Unix.flow_action =
    | TCOOFF
    | TCOON
    | TCIOFF
    | TCION
  [@@deriving sexp]

  include struct
    let _ = fun (_ : flow_action) -> ()

    let flow_action_of_sexp =
      (let error_source__813_ = "core_unix.ml.before-ppx.Terminal_io.flow_action" in
       function
       | Sexplib0.Sexp.Atom ("tCOOFF" | "TCOOFF") -> TCOOFF
       | Sexplib0.Sexp.Atom ("tCOON" | "TCOON") -> TCOON
       | Sexplib0.Sexp.Atom ("tCIOFF" | "TCIOFF") -> TCIOFF
       | Sexplib0.Sexp.Atom ("tCION" | "TCION") -> TCION
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCOOFF" | "TCOOFF") :: _) as sexp__814_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__813_ sexp__814_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCOON" | "TCOON") :: _) as sexp__814_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__813_ sexp__814_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCIOFF" | "TCIOFF") :: _) as sexp__814_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__813_ sexp__814_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("tCION" | "TCION") :: _) as sexp__814_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__813_ sexp__814_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__812_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__813_ sexp__812_
       | Sexplib0.Sexp.List [] as sexp__812_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__813_ sexp__812_
       | sexp__812_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__813_ sexp__812_
       : Sexplib0.Sexp.t -> flow_action)
    ;;

    let _ = flow_action_of_sexp

    let sexp_of_flow_action =
      (function
       | TCOOFF -> Sexplib0.Sexp.Atom "TCOOFF"
       | TCOON -> Sexplib0.Sexp.Atom "TCOON"
       | TCIOFF -> Sexplib0.Sexp.Atom "TCIOFF"
       | TCION -> Sexplib0.Sexp.Atom "TCION"
       : flow_action -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_flow_action
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let tcflow fd ~mode =
    improve
      (fun () -> Unix.tcflow fd ~mode)
      (fun () -> [ fd_r fd; "mode", sexp_of_flow_action mode ])
  ;;

  let setsid = Unix.setsid
end

let get_sockaddr name port = ADDR_INET (Inet_addr.of_string_or_getbyname name, port)

let set_in_channel_timeout ic rcv_timeout =
  let s = descr_of_in_channel ic in
  setsockopt_float s SO_RCVTIMEO rcv_timeout
;;

let set_out_channel_timeout oc snd_timeout =
  let s = descr_of_out_channel oc in
  setsockopt_float s SO_SNDTIMEO snd_timeout
;;

external nanosleep : float -> float = "core_time_ns_nanosleep"

let () = Sexplib_unix.Sexplib_unix_conv.linkme

module Ifaddr = struct
  module Broadcast_or_destination = struct
    type t =
      | Broadcast of Inet_addr.t
      | Destination of Inet_addr.t
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (function
         | Broadcast arg0__815_ ->
           let res0__816_ = Inet_addr.sexp_of_t arg0__815_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Broadcast"; res0__816_ ]
         | Destination arg0__817_ ->
           let res0__818_ = Inet_addr.sexp_of_t arg0__817_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Destination"; res0__818_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Family = struct
    type t =
      | Packet
      | Inet4
      | Inet6
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__821_ = "core_unix.ml.before-ppx.Ifaddr.Family.t" in
         function
         | Sexplib0.Sexp.Atom ("packet" | "Packet") -> Packet
         | Sexplib0.Sexp.Atom ("inet4" | "Inet4") -> Inet4
         | Sexplib0.Sexp.Atom ("inet6" | "Inet6") -> Inet6
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("packet" | "Packet") :: _) as
           sexp__822_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__821_ sexp__822_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("inet4" | "Inet4") :: _) as sexp__822_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__821_ sexp__822_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("inet6" | "Inet6") :: _) as sexp__822_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__821_ sexp__822_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__820_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__821_ sexp__820_
         | Sexplib0.Sexp.List [] as sexp__820_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__821_ sexp__820_
         | sexp__820_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__821_ sexp__820_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Packet -> Sexplib0.Sexp.Atom "Packet"
         | Inet4 -> Sexplib0.Sexp.Atom "Inet4"
         | Inet6 -> Sexplib0.Sexp.Atom "Inet6"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "core_unix.ml.before-ppx:3212:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.variant [ "Packet", []; "Inet4", []; "Inet6", [] ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | Packet | Inet4 | Inet6 -> 1
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Packet -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
        | Inet4 -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
        | Inet6 -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "core_unix.ml.before-ppx.Ifaddr.Family.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 -> Packet
        | 1 -> Inet4
        | 2 -> Inet6
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "core_unix.ml.before-ppx.Ifaddr.Family.t")
            !pos_ref
      ;;

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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Flag = struct
    module T = struct
      type t =
        | Allmulti
        | Automedia
        | Broadcast
        | Debug
        | Dynamic
        | Loopback
        | Master
        | Multicast
        | Noarp
        | Notrailers
        | Pointopoint
        | Portsel
        | Promisc
        | Running
        | Slave
        | Up
      [@@deriving sexp, compare, enumerate]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__825_ = "core_unix.ml.before-ppx.Ifaddr.Flag.T.t" in
           function
           | Sexplib0.Sexp.Atom ("allmulti" | "Allmulti") -> Allmulti
           | Sexplib0.Sexp.Atom ("automedia" | "Automedia") -> Automedia
           | Sexplib0.Sexp.Atom ("broadcast" | "Broadcast") -> Broadcast
           | Sexplib0.Sexp.Atom ("debug" | "Debug") -> Debug
           | Sexplib0.Sexp.Atom ("dynamic" | "Dynamic") -> Dynamic
           | Sexplib0.Sexp.Atom ("loopback" | "Loopback") -> Loopback
           | Sexplib0.Sexp.Atom ("master" | "Master") -> Master
           | Sexplib0.Sexp.Atom ("multicast" | "Multicast") -> Multicast
           | Sexplib0.Sexp.Atom ("noarp" | "Noarp") -> Noarp
           | Sexplib0.Sexp.Atom ("notrailers" | "Notrailers") -> Notrailers
           | Sexplib0.Sexp.Atom ("pointopoint" | "Pointopoint") -> Pointopoint
           | Sexplib0.Sexp.Atom ("portsel" | "Portsel") -> Portsel
           | Sexplib0.Sexp.Atom ("promisc" | "Promisc") -> Promisc
           | Sexplib0.Sexp.Atom ("running" | "Running") -> Running
           | Sexplib0.Sexp.Atom ("slave" | "Slave") -> Slave
           | Sexplib0.Sexp.Atom ("up" | "Up") -> Up
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("allmulti" | "Allmulti") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("automedia" | "Automedia") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("broadcast" | "Broadcast") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("debug" | "Debug") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("dynamic" | "Dynamic") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("loopback" | "Loopback") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("master" | "Master") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("multicast" | "Multicast") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("noarp" | "Noarp") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("notrailers" | "Notrailers") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pointopoint" | "Pointopoint") :: _)
             as sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("portsel" | "Portsel") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("promisc" | "Promisc") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("running" | "Running") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("slave" | "Slave") :: _) as
             sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("up" | "Up") :: _) as sexp__826_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__825_ sexp__826_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__824_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__825_
               sexp__824_
           | Sexplib0.Sexp.List [] as sexp__824_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__825_ sexp__824_
           | sexp__824_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__825_ sexp__824_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | Allmulti -> Sexplib0.Sexp.Atom "Allmulti"
           | Automedia -> Sexplib0.Sexp.Atom "Automedia"
           | Broadcast -> Sexplib0.Sexp.Atom "Broadcast"
           | Debug -> Sexplib0.Sexp.Atom "Debug"
           | Dynamic -> Sexplib0.Sexp.Atom "Dynamic"
           | Loopback -> Sexplib0.Sexp.Atom "Loopback"
           | Master -> Sexplib0.Sexp.Atom "Master"
           | Multicast -> Sexplib0.Sexp.Atom "Multicast"
           | Noarp -> Sexplib0.Sexp.Atom "Noarp"
           | Notrailers -> Sexplib0.Sexp.Atom "Notrailers"
           | Pointopoint -> Sexplib0.Sexp.Atom "Pointopoint"
           | Portsel -> Sexplib0.Sexp.Atom "Portsel"
           | Promisc -> Sexplib0.Sexp.Atom "Promisc"
           | Running -> Sexplib0.Sexp.Atom "Running"
           | Slave -> Sexplib0.Sexp.Atom "Slave"
           | Up -> Sexplib0.Sexp.Atom "Up"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__827_ b__828_ -> Stdlib.compare a__827_ b__828_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let all =
          ([ Allmulti
           ; Automedia
           ; Broadcast
           ; Debug
           ; Dynamic
           ; Loopback
           ; Master
           ; Multicast
           ; Noarp
           ; Notrailers
           ; Pointopoint
           ; Portsel
           ; Promisc
           ; Running
           ; Slave
           ; Up
           ]
           : t list)
        ;;

        let _ = all
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T
    include Comparable.Make (T)

    external core_unix_iff_to_int : t -> int = "core_unix_iff_to_int"

    let set_of_int bitmask =
      List.fold all ~init:Set.empty ~f:(fun flags t ->
        let v = core_unix_iff_to_int t in
        match bitmask land v with
        | 0 -> flags
        | _ -> Core.Set.add flags t)
    ;;

    module Private = struct
      let core_unix_iff_to_int = core_unix_iff_to_int
      let set_of_int = set_of_int
    end
  end

  type t =
    { name : string
    ; family : Family.t
    ; flags : Flag.Set.t
    ; address : Inet_addr.t option [@sexp.option]
    ; netmask : Inet_addr.t option [@sexp.option]
    ; broadcast_or_destination : Broadcast_or_destination.t option [@sexp.option]
    }
  [@@deriving sexp_of, fields ~getters]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { name = name__830_
           ; family = family__832_
           ; flags = flags__834_
           ; address = address__836_
           ; netmask = netmask__840_
           ; broadcast_or_destination = broadcast_or_destination__844_
           } ->
         let bnds__829_ = ([] : _ Stdlib.List.t) in
         let bnds__829_ =
           match broadcast_or_destination__844_ with
           | Stdlib.Option.None -> bnds__829_
           | Stdlib.Option.Some v__845_ ->
             let arg__847_ = Broadcast_or_destination.sexp_of_t v__845_ in
             let bnd__846_ =
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "broadcast_or_destination"; arg__847_ ]
             in
             (bnd__846_ :: bnds__829_ : _ Stdlib.List.t)
         in
         let bnds__829_ =
           match netmask__840_ with
           | Stdlib.Option.None -> bnds__829_
           | Stdlib.Option.Some v__841_ ->
             let arg__843_ = Inet_addr.sexp_of_t v__841_ in
             let bnd__842_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "netmask"; arg__843_ ]
             in
             (bnd__842_ :: bnds__829_ : _ Stdlib.List.t)
         in
         let bnds__829_ =
           match address__836_ with
           | Stdlib.Option.None -> bnds__829_
           | Stdlib.Option.Some v__837_ ->
             let arg__839_ = Inet_addr.sexp_of_t v__837_ in
             let bnd__838_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "address"; arg__839_ ]
             in
             (bnd__838_ :: bnds__829_ : _ Stdlib.List.t)
         in
         let bnds__829_ =
           let arg__835_ = Flag.Set.sexp_of_t flags__834_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags"; arg__835_ ] :: bnds__829_
            : _ Stdlib.List.t)
         in
         let bnds__829_ =
           let arg__833_ = Family.sexp_of_t family__832_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "family"; arg__833_ ] :: bnds__829_
            : _ Stdlib.List.t)
         in
         let bnds__829_ =
           let arg__831_ = sexp_of_string name__830_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__831_ ] :: bnds__829_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__829_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
    let broadcast_or_destination _r__ = _r__.broadcast_or_destination
    let _ = broadcast_or_destination
    let netmask _r__ = _r__.netmask
    let _ = netmask
    let address _r__ = _r__.address
    let _ = address
    let flags _r__ = _r__.flags
    let _ = flags
    let family _r__ = _r__.family
    let _ = family
    let name _r__ = _r__.name
    let _ = name
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ifaddrs =
    { name : string
    ; family : Family.t
    ; flags : int
    ; addr_octets : string
    ; netmask_octets : string
    ; broadcast_octets : string
    ; destination_octets : string
    }

  external core_unix_getifaddrs : unit -> ifaddrs list = "core_unix_getifaddrs"

  let inet4_to_inet_addr addr =
    match String.length addr with
    | 0 -> None
    | 4 ->
      Option.return
        (Inet_addr.of_string
           (sprintf
              "%d.%d.%d.%d"
              (Char.to_int addr.[0])
              (Char.to_int addr.[1])
              (Char.to_int addr.[2])
              (Char.to_int addr.[3])))
    | addrlen -> failwithf "IPv4 address is length %d!" addrlen ()
  ;;

  let inet6_to_inet_addr addr =
    match String.length addr with
    | 0 -> None
    | 16 ->
      Option.return
        (Inet_addr.of_string
           (sprintf
              "%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x"
              (Char.to_int addr.[0])
              (Char.to_int addr.[1])
              (Char.to_int addr.[2])
              (Char.to_int addr.[3])
              (Char.to_int addr.[4])
              (Char.to_int addr.[5])
              (Char.to_int addr.[6])
              (Char.to_int addr.[7])
              (Char.to_int addr.[8])
              (Char.to_int addr.[9])
              (Char.to_int addr.[10])
              (Char.to_int addr.[11])
              (Char.to_int addr.[12])
              (Char.to_int addr.[13])
              (Char.to_int addr.[14])
              (Char.to_int addr.[15])))
    | addrlen -> failwithf "IPv6 address is length %d!" addrlen ()
  ;;

  let addr_to_inet_addr family addr =
    match family with
    | Family.Packet -> None
    | Family.Inet4 -> inet4_to_inet_addr addr
    | Family.Inet6 -> inet6_to_inet_addr addr
  ;;

  let test_and_convert ifa =
    let flags = Flag.set_of_int ifa.flags in
    let broadcast_or_destination_convert ifa =
      if Set.mem flags Broadcast
      then
        Option.map (addr_to_inet_addr ifa.family ifa.broadcast_octets) ~f:(fun x ->
          Broadcast_or_destination.Broadcast x)
      else if Set.mem flags Pointopoint
      then
        Option.map (addr_to_inet_addr ifa.family ifa.destination_octets) ~f:(fun x ->
          Broadcast_or_destination.Destination x)
      else None
    in
    { address = addr_to_inet_addr ifa.family ifa.addr_octets
    ; netmask = addr_to_inet_addr ifa.family ifa.netmask_octets
    ; broadcast_or_destination = broadcast_or_destination_convert ifa
    ; flags
    ; name = ifa.name
    ; family = ifa.family
    }
  ;;
end

let getifaddrs () = List.map (Ifaddr.core_unix_getifaddrs ()) ~f:Ifaddr.test_and_convert

external get_all_ifnames : unit -> string list = "core_unix_all_ifnames"

module Stable = struct
  module Inet_addr = Inet_addr.Stable
  module Cidr = Cidr.Stable
  module Signal = Signal.Stable
  module Utsname = Utsname.Stable
end

let exec ~prog ~argv ?(use_path = true) ?env () =
  let argv = Array.of_list argv in
  let env = Option.map env ~f:Env.expand_array in
  exec_internal ~prog ~argv ~use_path ~env
;;

module Expert = struct
  let exec = exec_internal
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
