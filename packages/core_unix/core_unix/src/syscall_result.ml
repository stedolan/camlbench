let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"syscall_result.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "syscall_result.ml.before-ppx"
;;

open! Core
open! Import

type 'a t = int

module type S = Syscall_result_intf.S with type 'a syscall_result := 'a t
module type Arg = Syscall_result_intf.Arg

let create_error err = -Unix_error.to_errno err

let is_ok t =
  let open Int.O in
  t >= 0
;;

let is_error t =
  let open Int.O in
  t < 0
;;

let error_code_exn t =
  if is_ok t
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "syscall_result.ml.before-ppx"
        ; pos_lnum = 17
        ; pos_cnum = 337
        ; pos_bol = 325
        }
      "Syscall_result.error_code_exn received success value"
      t
      (sexp_of_int [@merlin.hide])
  else -t
;;

let error_exn t = Unix_error.of_errno (error_code_exn t)

module Make (M : Arg) () = struct
  let preallocated_errnos : (_, Unix_error.t) Result.t array =
    Array.init 64 ~f:(fun i -> Error (Unix_error.of_errno i))
  ;;

  let () =
    Ppx_inline_test_lib.test
      ~config:(module Inline_test_config)
      ~descr:(lazy "no 0 errno")
      ~tags:[]
      ~filename:"syscall_result.ml.before-ppx"
      ~line_number:36
      ~start_pos:2
      ~end_pos:99
      (fun () -> Poly.equal preallocated_errnos.(0) (Error (Unix_error.EUNKNOWNERR 0)))
  ;;

  let num_preallocated_errnos = Array.length preallocated_errnos

  type nonrec t = M.t t

  let compare = Int.compare
  let equal = Int.equal

  let preallocated_ms =
    let rec loop i rev_acc =
      if i = 2048
      then Array.of_list_rev rev_acc
      else (
        match M.of_int_exn i with
        | exception _ -> Array.of_list_rev rev_acc
        | m -> loop (i + 1) (Ok m :: rev_acc))
    in
    loop 0 []
  ;;

  let num_preallocated_ms = Array.length preallocated_ms

  let create_ok x =
    let t = M.to_int x in
    if t < 0
    then failwithf "Syscall_result.create_ok received negative value (%d)" t ()
    else t
  ;;

  let create_error = create_error
  let is_ok = is_ok
  let is_error = is_error

  let to_result t =
    if is_ok t
    then
      if t < num_preallocated_ms
      then Array.unsafe_get preallocated_ms t
      else Ok (M.of_int_exn t)
    else (
      let errno = -t in
      if errno < num_preallocated_errnos
      then Array.unsafe_get preallocated_errnos errno
      else Error (Unix_error.of_errno errno))
  ;;

  let sexp_of_t t =
    ((fun x__001_ -> Result.sexp_of_t M.sexp_of_t Unix_error.sexp_of_t x__001_)
       [@merlin.hide])
      (to_result t)
  ;;

  let ok_exn t =
    if is_ok t
    then M.of_int_exn t
    else
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "syscall_result.ml.before-ppx"
          ; pos_lnum = 93
          ; pos_cnum = 2502
          ; pos_bol = 2477
          }
        "Syscall_result.ok_exn received error value"
        t
        sexp_of_t
  ;;

  let error_code_exn t =
    if is_ok t
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "syscall_result.ml.before-ppx"
          ; pos_lnum = 100
          ; pos_cnum = 2652
          ; pos_bol = 2638
          }
        "Syscall_result.error_code_exn received success value"
        t
        sexp_of_t
    else -t
  ;;

  let error_exn t = Unix_error.of_errno (error_code_exn t)

  let reinterpret_error_exn t =
    if is_ok t
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "syscall_result.ml.before-ppx"
          ; pos_lnum = 113
          ; pos_cnum = 2915
          ; pos_bol = 2901
          }
        "Syscall_result.cast_error_exn received success value"
        t
        sexp_of_t
    else t
  ;;

  let ok_or_unix_error_exn t ~syscall_name =
    if is_ok t
    then M.of_int_exn t
    else raise (Unix.Unix_error (Unix_error.of_errno (-t), syscall_name, ""))
  ;;

  let ok_or_unix_error_with_args_exn t ~syscall_name x sexp_of_x =
    if is_ok t
    then M.of_int_exn t
    else
      raise
        (Unix.Unix_error
           (Unix_error.of_errno (-t), syscall_name, Sexp.to_string (sexp_of_x x)))
  ;;

  let is_none t = is_error t
  let unchecked_value t = M.of_int_exn t

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unchecked_value
    end
  end

  module Private = struct
    let of_int t = t
    let length_preallocated_errnos = Array.length preallocated_errnos
    let length_preallocated_ms = Array.length preallocated_ms
  end
end

module Int = Make (Int) ()

module Unit =
  Make
    (struct
      type t = unit [@@deriving sexp_of, compare]

      include struct
        let _ = fun (_ : t) -> ()
        let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let compare =
          (fun a__002_ b__003_ -> compare_unit a__002_ b__003_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_int_exn n = assert (n = 0)
      let to_int () = 0
    end)
    ()

module File_descr = Make (File_descr) ()

let unit = Unit.create_ok ()
let ignore_ok_value t = Core.Int.min t 0
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
