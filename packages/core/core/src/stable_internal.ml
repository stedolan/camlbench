let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_internal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_internal.ml.before-ppx"
;;

open! Import
include Bin_prot.Std
include Hash.Builtin
include Stable_witness.Export

include (
  Base :
    sig
      type nonrec 'a array = 'a array [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_array : ('a -> Sexplib0.Sexp.t) -> 'a array -> Sexplib0.Sexp.t
        val array_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a array

        val array_sexp_grammar
          :  'a Sexplib0.Sexp_grammar.t
          -> 'a array Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec bool = bool [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_bool : bool -> Sexplib0.Sexp.t
        val bool_of_sexp : Sexplib0.Sexp.t -> bool
        val bool_sexp_grammar : bool Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec char = char [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_char : char -> Sexplib0.Sexp.t
        val char_of_sexp : Sexplib0.Sexp.t -> char
        val char_sexp_grammar : char Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec exn = exn [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_exn : exn -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec float = float [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_float : float -> Sexplib0.Sexp.t
        val float_of_sexp : Sexplib0.Sexp.t -> float
        val float_sexp_grammar : float Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec int = int [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_int : int -> Sexplib0.Sexp.t
        val int_of_sexp : Sexplib0.Sexp.t -> int
        val int_sexp_grammar : int Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec int32 = int32 [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_int32 : int32 -> Sexplib0.Sexp.t
        val int32_of_sexp : Sexplib0.Sexp.t -> int32
        val int32_sexp_grammar : int32 Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec int64 = int64 [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_int64 : int64 -> Sexplib0.Sexp.t
        val int64_of_sexp : Sexplib0.Sexp.t -> int64
        val int64_sexp_grammar : int64 Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec 'a list = 'a list [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_list : ('a -> Sexplib0.Sexp.t) -> 'a list -> Sexplib0.Sexp.t
        val list_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a list

        val list_sexp_grammar
          :  'a Sexplib0.Sexp_grammar.t
          -> 'a list Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec nativeint = nativeint [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_nativeint : nativeint -> Sexplib0.Sexp.t
        val nativeint_of_sexp : Sexplib0.Sexp.t -> nativeint
        val nativeint_sexp_grammar : nativeint Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec 'a option = 'a option [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_option : ('a -> Sexplib0.Sexp.t) -> 'a option -> Sexplib0.Sexp.t
        val option_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a option

        val option_sexp_grammar
          :  'a Sexplib0.Sexp_grammar.t
          -> 'a option Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec 'a ref = 'a ref [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_ref : ('a -> Sexplib0.Sexp.t) -> 'a ref -> Sexplib0.Sexp.t
        val ref_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a ref

        val ref_sexp_grammar
          :  'a Sexplib0.Sexp_grammar.t
          -> 'a ref Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec string = string [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_string : string -> Sexplib0.Sexp.t
        val string_of_sexp : Sexplib0.Sexp.t -> string
        val string_sexp_grammar : string Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec bytes = bytes [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_bytes : bytes -> Sexplib0.Sexp.t
        val bytes_of_sexp : Sexplib0.Sexp.t -> bytes
        val bytes_sexp_grammar : bytes Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec unit = unit [@@deriving sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_unit : unit -> Sexplib0.Sexp.t
        val unit_of_sexp : Sexplib0.Sexp.t -> unit
        val unit_sexp_grammar : unit Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a array := 'a array
    with type bool := bool
    with type char := char
    with type exn := exn
    with type float := float
    with type int := int
    with type int32 := int32
    with type int64 := int64
    with type 'a list := 'a list
    with type nativeint := nativeint
    with type 'a option := 'a option
    with type 'a ref := 'a ref
    with type string := string
    with type bytes := bytes
    with type unit := unit)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
