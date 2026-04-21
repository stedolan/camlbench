let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bigbuffer_blocking.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bigbuffer_blocking.ml.before-ppx"
;;

open! Core
open! Import
open! Core.Bigbuffer
open! Core.Core_private.Bigbuffer_internal

let add_channel buf ic len =
  let buf = __internal buf in
  if len < 0 then invalid_arg "Bigbuffer_blocking.add_channel";
  let pos = buf.pos in
  if pos + len > buf.len then resize buf len;
  Bigstring_unix.really_input ic buf.bstr ~pos ~len;
  buf.pos <- pos + len
;;

let output_buffer oc buf =
  let buf = __internal buf in
  Bigstring_unix.really_output oc buf.bstr ~len:buf.pos
;;

let md5 t =
  let t = __internal t in
  Md5.digest_subbigstring t.bstr ~pos:0 ~len:t.pos
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
