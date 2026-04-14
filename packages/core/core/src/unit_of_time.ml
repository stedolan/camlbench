let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unit_of_time.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unit_of_time.ml.before-ppx"
;;

open! Import

type t =
  | Nanosecond
  | Microsecond
  | Millisecond
  | Second
  | Minute
  | Hour
  | Day
[@@deriving sexp, compare, enumerate, hash]

include struct
  let _ = fun (_ : t) -> ()

  let t_of_sexp =
    (let error_source__003_ = "unit_of_time.ml.before-ppx.t" in
     function
     | Sexplib0.Sexp.Atom ("nanosecond" | "Nanosecond") -> Nanosecond
     | Sexplib0.Sexp.Atom ("microsecond" | "Microsecond") -> Microsecond
     | Sexplib0.Sexp.Atom ("millisecond" | "Millisecond") -> Millisecond
     | Sexplib0.Sexp.Atom ("second" | "Second") -> Second
     | Sexplib0.Sexp.Atom ("minute" | "Minute") -> Minute
     | Sexplib0.Sexp.Atom ("hour" | "Hour") -> Hour
     | Sexplib0.Sexp.Atom ("day" | "Day") -> Day
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nanosecond" | "Nanosecond") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("microsecond" | "Microsecond") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("millisecond" | "Millisecond") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("second" | "Second") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("minute" | "Minute") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("hour" | "Hour") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("day" | "Day") :: _) as sexp__004_ ->
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
     | Nanosecond -> Sexplib0.Sexp.Atom "Nanosecond"
     | Microsecond -> Sexplib0.Sexp.Atom "Microsecond"
     | Millisecond -> Sexplib0.Sexp.Atom "Millisecond"
     | Second -> Sexplib0.Sexp.Atom "Second"
     | Minute -> Sexplib0.Sexp.Atom "Minute"
     | Hour -> Sexplib0.Sexp.Atom "Hour"
     | Day -> Sexplib0.Sexp.Atom "Day"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t

  let compare =
    (fun a__005_ b__006_ -> Stdlib.compare a__005_ b__006_
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare
  let all = ([ Nanosecond; Microsecond; Millisecond; Second; Minute; Hour; Day ] : t list)
  let _ = all

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    (fun hsv arg ->
       Ppx_hash_lib.Std.Hash.fold_int
         hsv
         (match arg with
          | Nanosecond -> 0
          | Microsecond -> 1
          | Millisecond -> 2
          | Second -> 3
          | Minute -> 4
          | Hour -> 5
          | Day -> 6)
     : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
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
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
