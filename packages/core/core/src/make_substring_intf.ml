let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"make_substring_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "make_substring_intf.ml.before-ppx"
;;

open! Import

module type Base = sig
  type t [@@deriving quickcheck]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : int -> t
  val length : t -> int
  val blit : (t, t) Blit.blito
  val blit_to_bytes : (t, bytes) Blit.blito
  val blit_to_bigstring : (t, bigstring) Blit.blito
  val blit_from_string : (string, t) Blit.blito
  val blit_from_bigstring : (bigstring, t) Blit.blito

  val blit_to_string : (t, bytes) Blit.blito
  [@@deprecated "[since 2017-10] use [blit_to_bytes] instead"]

  val get : t -> int -> char
end

module type S = Substring_intf.S

module type Make_substring = sig
  module type Base = Base
  module type S = S

  type bigstring = Bigstring.t

  module Blit : sig
    type ('src, 'dst) t = ('src, 'dst) Blit.blito

    val string_string : (string, bytes) t
    [@@deprecated "[since 2017-10] use [string_bytes] instead"]

    val bigstring_string : (bigstring, bytes) t
    [@@deprecated "[since 2017-10] use [bigstring_bytes] instead"]

    val string_bytes : (string, bytes) t
    val bytes_bytes : (bytes, bytes) t
    val bigstring_bytes : (bigstring, bytes) t
    val string_bigstring : (string, bigstring) t
    val bytes_bigstring : (bytes, bigstring) t
    val bigstring_bigstring : (bigstring, bigstring) t
  end

  module F : functor (Base : Base) -> S with type base = Base.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
