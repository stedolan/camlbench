let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"thread_pool_cpu_affinity.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "thread_pool_cpu_affinity.ml.before-ppx"
;;

open! Core
open! Import

module Cpuset = struct
  include Validated.Make (struct
      type t = Int.Set.t [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (Int.Set.t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (Int.Set.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let here =
        { Ppx_here_lib.pos_fname = "thread_pool_cpu_affinity.ml.before-ppx"
        ; pos_lnum = 8
        ; pos_cnum = 138
        ; pos_bol = 123
        }
      ;;

      let validate t =
        Validate.first_failure
          (Int.validate_lbound ~min:(Incl 1) (Set.length t))
          (Validate.name_list
             "Thread_pool_cpuset"
             (List.map ~f:Int.validate_non_negative (Set.to_list t)))
      ;;
    end)

  let equal t1 t2 = Int.Set.equal (raw t1) (raw t2)
end

type t =
  | Inherit
  | Cpuset of Cpuset.t
[@@deriving sexp]

include struct
  let _ = fun (_ : t) -> ()

  let t_of_sexp =
    (let error_source__004_ = "thread_pool_cpu_affinity.ml.before-ppx.t" in
     function
     | Sexplib0.Sexp.Atom ("inherit" | "Inherit") -> Inherit
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("cpuset" | "Cpuset") as _tag__007_) :: sexp_args__008_) as
       _sexp__006_ ->
       (match sexp_args__008_ with
        | arg0__009_ :: [] ->
          let res0__010_ = Cpuset.t_of_sexp arg0__009_ in
          Cpuset res0__010_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__004_
            _tag__007_
            _sexp__006_)
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("inherit" | "Inherit") :: _) as sexp__005_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__004_ sexp__005_
     | Sexplib0.Sexp.Atom ("cpuset" | "Cpuset") as sexp__005_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__004_ sexp__003_
     | Sexplib0.Sexp.List [] as sexp__003_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__004_ sexp__003_
     | sexp__003_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__004_ sexp__003_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (function
     | Inherit -> Sexplib0.Sexp.Atom "Inherit"
     | Cpuset arg0__011_ ->
       let res0__012_ = Cpuset.sexp_of_t arg0__011_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Cpuset"; res0__012_ ]
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
