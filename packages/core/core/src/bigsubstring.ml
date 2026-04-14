let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bigsubstring.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bigsubstring.ml.before-ppx"
;;

open! Import

include Make_substring.F (struct
    type t = Bigstring.t [@@deriving quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let quickcheck_generator = Bigstring.quickcheck_generator
      let _ = quickcheck_generator
      let quickcheck_observer = Bigstring.quickcheck_observer
      let _ = quickcheck_observer
      let quickcheck_shrinker = Bigstring.quickcheck_shrinker
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create = Bigstring.create
    let length = Bigstring.length
    let get = Bigstring.get

    module Blit = Make_substring.Blit

    let blit = Blit.bigstring_bigstring
    let blit_to_string = Blit.bigstring_bytes
    let blit_to_bytes = Blit.bigstring_bytes
    let blit_to_bigstring = Blit.bigstring_bigstring
    let blit_from_string = Blit.string_bigstring
    let blit_from_bigstring = Blit.bigstring_bigstring
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
