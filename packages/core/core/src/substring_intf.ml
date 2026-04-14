[@@@ocaml.text " Interface for {{!Core.Substring}[Substring]}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"substring_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "substring_intf.ml.before-ppx"
;;

open! Import

module type S = sig
  type base [@@ocaml.doc " The type of strings that type [t] is a substring of. "]

  type t
  [@@ocaml.doc " [sexp_of_t] is equivalent to [String.sexp_of_t (to_string t)] "]
  [@@deriving sexp_of, quickcheck]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Indexed_container.S0 with type t := t with type elt := char

  val base : t -> base

  val pos : t -> int
  [@@ocaml.doc
    " [pos] refers to the position in the base string, not any other substring that this\n\
    \      substring was generated from. "]

  val get : t -> int -> char
  [@@ocaml.doc
    " Per [String.get] and [Bigstring.get], this raises an exception if the index is out\n\
    \      of bounds. "]

  val create : ?pos:int -> ?len:int -> base -> t
  [@@ocaml.doc
    " [create ?pos ?len base] creates a substring of the base sequence of\n\
    \      length [len] starting at position [pos], i.e.,\n\n\
    \      {[ base.[pos], base.[pos + 1], ... base.[pos + len - 1] ]}\n\n\
    \      An exception is raised if any of those indices into [base] is invalid.\n\n\
    \      It does not copy the characters, so mutating [base] mutates [t] and vice versa.\n\
    \  "]

  val sub : ?pos:int -> ?len:int -> t -> t

  [@@@ocaml.text
    " {2 Blit functions}\n\n\
    \      For copying characters from a substring to and from both strings and \
     substrings. "]

  val blit_to_string : t -> dst:bytes -> dst_pos:int -> unit
  val blit_to_bytes : t -> dst:bytes -> dst_pos:int -> unit
  val blit_to_bigstring : t -> dst:Bigstring.t -> dst_pos:int -> unit
  val blit_from_string : t -> src:string -> src_pos:int -> len:int -> unit
  val blit_from_bigstring : t -> src:Bigstring.t -> src_pos:int -> len:int -> unit

  [@@@ocaml.text " {2 String concatenation} "]

  [@@@ocaml.text " These functions always copy. "]

  val concat : t list -> t
  val concat_string : t list -> string
  val concat_bigstring : t list -> Bigstring.t

  [@@@ocaml.text " {2 Conversion to/from substrings} "]

  [@@@ocaml.text " These functions always copy. "]

  val to_string : t -> string
  val to_bigstring : t -> Bigstring.t

  [@@@ocaml.text " These functions always copy. Use [create] if you want sharing. "]

  val of_string : string -> t [@@deprecated "[since 2017-11] use [create] instead"]

  val of_bigstring : Bigstring.t -> t
  [@@deprecated "[since 2017-11] use [create] instead"]

  [@@@ocaml.text
    " {2 Prefixes and suffixes}\n\n\
    \      The result of these functions share data with their input, but don't mutate the\n\
    \      underlying string. "]

  val drop_prefix : t -> int -> t
  val drop_suffix : t -> int -> t
  val prefix : t -> int -> t
  val suffix : t -> int -> t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
