let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"substring.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "substring.ml.before-ppx"
;;

open! Import

module type S = Make_substring.S

include Make_substring.F (struct
    type t = Bytes.t [@@deriving quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let quickcheck_generator = Bytes.quickcheck_generator
      let _ = quickcheck_generator
      let quickcheck_observer = Bytes.quickcheck_observer
      let _ = quickcheck_observer
      let quickcheck_shrinker = Bytes.quickcheck_shrinker
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create = Bytes.create
    let length = Bytes.length
    let get = Bytes.get

    module Blit = Make_substring.Blit

    let blit = Blit.bytes_bytes
    let blit_to_string = Blit.bytes_bytes
    let blit_to_bytes = Blit.bytes_bytes
    let blit_to_bigstring = Blit.bytes_bigstring
    let blit_from_string = Blit.string_bytes
    let blit_from_bigstring = Blit.bigstring_bytes
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
