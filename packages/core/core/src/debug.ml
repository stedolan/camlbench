let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"debug.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "debug.ml.before-ppx"
;;

open! Import
module List = Base.List
module String = Base.String

let eprint message = Printf.eprintf "%s\n%!" message
let eprint_s sexp = eprint (Sexp.to_string_hum sexp)

let eprints message a sexp_of_a =
  eprint_s
    (((fun (arg0__001_, arg1__002_) ->
        let res0__003_ = sexp_of_string arg0__001_
        and res1__004_ = sexp_of_a arg1__002_ in
        Sexplib0.Sexp.List [ res0__003_; res1__004_ ]) [@merlin.hide])
       (message, a))
;;

let eprintf format = Printf.ksprintf eprint format
let failwiths = Error.failwiths

module Make () = struct
  let check_invariant = ref true
  let show_messages = ref true

  let debug invariant ~module_name name ts arg sexp_of_arg sexp_of_result f =
    if !show_messages
    then eprints (String.concat ~sep:"" [ module_name; "."; name ]) arg sexp_of_arg;
    if !check_invariant
    then (
      try List.iter ts ~f:invariant with
      | exn ->
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "debug.ml.before-ppx"
            ; pos_lnum = 23
            ; pos_cnum = 736
            ; pos_bol = 720
            }
          "invariant pre-condition failed"
          (name, exn)
          ((fun (arg0__005_, arg1__006_) ->
             let res0__007_ = sexp_of_string arg0__005_
             and res1__008_ = sexp_of_exn arg1__006_ in
             Sexplib0.Sexp.List [ res0__007_; res1__008_ ]) [@merlin.hide]));
    let result_or_exn = Result.try_with f in
    if !check_invariant
    then (
      try List.iter ts ~f:invariant with
      | exn ->
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "debug.ml.before-ppx"
            ; pos_lnum = 33
            ; pos_cnum = 1016
            ; pos_bol = 1000
            }
          "invariant post-condition failed"
          (name, exn)
          ((fun (arg0__009_, arg1__010_) ->
             let res0__011_ = sexp_of_string arg0__009_
             and res1__012_ = sexp_of_exn arg1__010_ in
             Sexplib0.Sexp.List [ res0__011_; res1__012_ ]) [@merlin.hide]));
    if !show_messages
    then
      eprints
        (String.concat ~sep:"" [ module_name; "."; name; "-result" ])
        result_or_exn
        ((fun x__013_ -> Result.sexp_of_t sexp_of_result sexp_of_exn x__013_)
           [@merlin.hide]);
    Result.ok_exn result_or_exn
  ;;
end

let should_print_backtrace = ref false

let am_internal here message =
  Printf.eprintf "%s:\n" (Source_code_position.to_string here);
  if !should_print_backtrace
  then
    Printf.eprintf
      "%s\n"
      (Sexp.to_string_hum ((Backtrace.sexp_of_t [@merlin.hide]) (Backtrace.get ())));
  (match message with
   | None -> ()
   | Some message -> Printf.eprintf "%s\n" message);
  Printf.eprintf "%!"
;;

let am here = am_internal here None
let amf here fmt = Printf.ksprintf (fun string -> am_internal here (Some string)) fmt

let ams here message a sexp_of_a =
  am_internal
    here
    (Some
       (Sexp.to_string_hum
          (((fun (arg0__014_, arg1__015_) ->
              let res0__016_ = sexp_of_string arg0__014_
              and res1__017_ = sexp_of_a arg1__015_ in
              Sexplib0.Sexp.List [ res0__016_; res1__017_ ]) [@merlin.hide])
             (message, a))))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
