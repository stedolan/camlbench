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
module Impl = Null_impl

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
