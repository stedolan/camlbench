[@@@ocaml.text " This module extends {{!Base.Printf}[Base.Printf]}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"printf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "printf.ml.before-ppx"
;;

open! Import

include Base.Printf [@@ocaml.doc " @open "]

let eprintf = Stdio.Out_channel.eprintf
let fprintf = Stdio.Out_channel.fprintf
let kfprintf = Stdio.Out_channel.kfprintf
let printf = Stdio.Out_channel.printf

let exitf fmt =
  ksprintf
    (fun s () ->
       eprintf "%s\n%!" s;
       exit 1)
    fmt
[@@ocaml.doc " print to stderr; exit 1 "]
;;

type printf = { printf : 'a. ('a, Buffer.t, unit) format -> 'a }

let collect_to_string f =
  let buf = Buffer.create 64 in
  let done_ = ref false in
  let printf fmt =
    kbprintf
      (fun buf ->
         if !done_
         then (
           Buffer.reset buf;
           raise_s
             (let ppx_sexp_message () =
                Ppx_sexp_conv_lib.Conv.sexp_of_string
                  "[printf] used after [collect_to_string] returned"
                  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
              in
              (ppx_sexp_message () [@nontail]))))
      buf
      fmt
  in
  f { printf };
  done_ := true;
  let output = Buffer.contents buf in
  Buffer.reset buf;
  output
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
