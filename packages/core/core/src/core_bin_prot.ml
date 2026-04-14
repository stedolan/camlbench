let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"core_bin_prot.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "core_bin_prot.ml.before-ppx"
;;

open! Import
include Bin_prot

module Writer = struct
  type 'a t = 'a Bin_prot.Type_class.writer =
    { size : 'a Size.sizer
    ; write : 'a Write.writer
    }

  let to_bigstring t v =
    let len = t.size v in
    let buf = Bigstring.create len in
    let pos = t.write buf ~pos:0 v in
    assert (pos = Bigstring.length buf);
    buf
  ;;

  let to_string t v =
    let buf = to_bigstring t v in
    let str = Bigstring.to_string buf in
    Bigstring.unsafe_destroy buf;
    str
  ;;

  let to_bytes t v =
    let buf = to_bigstring t v in
    let str = Bigstring.to_bytes buf in
    Bigstring.unsafe_destroy buf;
    str
  ;;
end

module Reader = struct
  type 'a t = 'a Bin_prot.Type_class.reader =
    { read : 'a Read.reader
    ; vtag_read : (int -> 'a) Read.reader
    }

  let of_bigstring t buf =
    let pos_ref = ref 0 in
    let v = t.read buf ~pos_ref in
    assert (!pos_ref = Bigstring.length buf);
    v
  ;;

  let of_bigstring_unsafe_destroy t buf =
    let v = of_bigstring t buf in
    Bigstring.unsafe_destroy buf;
    v
  ;;

  let of_string t string = of_bigstring_unsafe_destroy t (Bigstring.of_string string)
  let of_bytes t bytes = of_bigstring_unsafe_destroy t (Bigstring.of_bytes bytes)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
