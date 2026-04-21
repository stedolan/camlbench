[@@@ocaml.text " See {{!Iobuf}[Iobuf]} for documentation. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"iobuf_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "iobuf_intf.ml.before-ppx"
;;

open! Core

[@@@ocaml.text
  " [no_seek] and [seek] are phantom types used in a similar manner to [read] and\n\
  \    [read_write]. "]

type no_seek [@@ocaml.doc " Like [read]. "] [@@deriving sexp_of]

include struct
  let _ = fun (_ : no_seek) -> ()
  let sexp_of_no_seek = (fun _ -> assert false : no_seek -> Sexplib0.Sexp.t)
  let _ = sexp_of_no_seek
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type seek = private no_seek [@@ocaml.doc " Like [read_write]. "] [@@deriving sexp_of]

include struct
  let _ = fun (_ : seek) -> ()

  let sexp_of_seek =
    (fun v__001_ -> sexp_of_no_seek (v__001_ : seek :> no_seek) : seek -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_seek
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module type Accessors_common = sig
  [@@@ocaml.text
    " [('d, 'w) Iobuf.t] accessor function manipulating ['a], either writing it to the\n\
    \      iobuf or reading it from the iobuf. "]

  type ('a, 'd, 'w) t constraint 'd = [> read ]
  type ('a, 'd, 'w) t_local constraint 'd = [> read ]
  type 'a bin_prot

  val char : (char, 'd, 'w) t
  val bin_prot : 'a bin_prot -> ('a, 'd, 'w) t
end
[@@ocaml.doc
  " Collections of access functions.  These abstract over [Iobuf.Consume], [Iobuf.Fill],\n\
  \    [Iobuf.Peek], and [Iobuf.Poke].\n\n\
  \    Make all labeled arguments mandatory in [string] and [bigstring] to avoid \
   accidental\n\
  \    allocation in, e.g., [Iobuf.Poke.string].  For convenience, [stringo] and \
   [bigstringo]\n\
  \    are available by analogy between [blit] and [blito].\n\n\
  \    [_trunc] functions silently truncate values that don't fit.  For example,\n\
  \    [Iobuf.Unsafe.Poke.int8 128] effectively writes -128. "]

module type Accessors_read = sig
  include Accessors_common

  val int8 : (int, 'd, 'w) t
  val int16_be : (int, 'd, 'w) t
  val int16_le : (int, 'd, 'w) t
  val int32_be : (int, 'd, 'w) t
  val int32_le : (int, 'd, 'w) t
  val int64_be_exn : (int, 'd, 'w) t
  val int64_le_exn : (int, 'd, 'w) t
  val int64_be_trunc : (int, 'd, 'w) t
  val int64_le_trunc : (int, 'd, 'w) t
  val uint8 : (int, 'd, 'w) t
  val uint16_be : (int, 'd, 'w) t
  val uint16_le : (int, 'd, 'w) t
  val uint32_be : (int, 'd, 'w) t
  val uint32_le : (int, 'd, 'w) t
  val uint64_be_exn : (int, 'd, 'w) t
  val uint64_le_exn : (int, 'd, 'w) t
  val int64_t_be : (Int64.t, 'd, 'w) t
  val int64_t_le : (Int64.t, 'd, 'w) t
  val head_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t
  val tail_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t
  val string : str_pos:int -> len:int -> (string, 'd, 'w) t
  val bytes : str_pos:int -> len:int -> (Bytes.t, 'd, 'w) t
  val bigstring : str_pos:int -> len:int -> (Bigstring.t, 'd, 'w) t
  val stringo : ?str_pos:int -> ?len:int -> (string, 'd, 'w) t
  val byteso : ?str_pos:int -> ?len:int -> (Bytes.t, 'd, 'w) t
  val bigstringo : ?str_pos:int -> ?len:int -> (Bigstring.t, 'd, 'w) t

  module Local : sig
    val int64_t_be : (Int64.t, 'd, 'w) t_local
    val int64_t_le : (Int64.t, 'd, 'w) t_local
    val head_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t_local
    val tail_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t_local
    val string : str_pos:int -> len:int -> (string, 'd, 'w) t_local
    val bytes : str_pos:int -> len:int -> (Bytes.t, 'd, 'w) t_local
    val stringo : ?str_pos:int -> ?len:int -> (string, 'd, 'w) t_local
    val byteso : ?str_pos:int -> ?len:int -> (Bytes.t, 'd, 'w) t_local
  end

  module Int_repr : sig
    val int8 : (Int_repr.Int8.t, 'd, 'w) t
    val int16_be : (Int_repr.Int16.t, 'd, 'w) t
    val int16_le : (Int_repr.Int16.t, 'd, 'w) t
    val int32_be : (Int_repr.Int32.t, 'd, 'w) t
    val int32_le : (Int_repr.Int32.t, 'd, 'w) t
    val int64_be : (Int_repr.Int64.t, 'd, 'w) t
    val int64_le : (Int_repr.Int64.t, 'd, 'w) t
    val uint8 : (Int_repr.Uint8.t, 'd, 'w) t
    val uint16_be : (Int_repr.Uint16.t, 'd, 'w) t
    val uint16_le : (Int_repr.Uint16.t, 'd, 'w) t
    val uint32_be : (Int_repr.Uint32.t, 'd, 'w) t
    val uint32_le : (Int_repr.Uint32.t, 'd, 'w) t
    val uint64_be : (Int_repr.Uint64.t, 'd, 'w) t
    val uint64_le : (Int_repr.Uint64.t, 'd, 'w) t
  end
end

module type Accessors_write = sig
  include Accessors_common

  val int8_trunc : (int, 'd, 'w) t
  val int16_be_trunc : (int, 'd, 'w) t
  val int16_le_trunc : (int, 'd, 'w) t
  val int32_be_trunc : (int, 'd, 'w) t
  val int32_le_trunc : (int, 'd, 'w) t
  val int64_be : (int, 'd, 'w) t
  val int64_le : (int, 'd, 'w) t
  val uint8_trunc : (int, 'd, 'w) t
  val uint16_be_trunc : (int, 'd, 'w) t
  val uint16_le_trunc : (int, 'd, 'w) t
  val uint32_be_trunc : (int, 'd, 'w) t
  val uint32_le_trunc : (int, 'd, 'w) t
  val uint64_be_trunc : (int, 'd, 'w) t
  val uint64_le_trunc : (int, 'd, 'w) t
  val int64_t_be : (Int64.t, 'd, 'w) t_local
  val int64_t_le : (Int64.t, 'd, 'w) t_local
  val head_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t_local
  val tail_padded_fixed_string : padding:char -> len:int -> (string, 'd, 'w) t_local
  val string : str_pos:int -> len:int -> (string, 'd, 'w) t_local
  val bytes : str_pos:int -> len:int -> (Bytes.t, 'd, 'w) t_local
  val bigstring : str_pos:int -> len:int -> (Bigstring.t, 'd, 'w) t_local
  val stringo : ?str_pos:int -> ?len:int -> (string, 'd, 'w) t_local
  val byteso : ?str_pos:int -> ?len:int -> (Bytes.t, 'd, 'w) t_local
  val bigstringo : ?str_pos:int -> ?len:int -> (Bigstring.t, 'd, 'w) t_local

  module Int_repr : sig
    val int8 : (Int_repr.Int8.t, 'd, 'w) t
    val int16_be : (Int_repr.Int16.t, 'd, 'w) t
    val int16_le : (Int_repr.Int16.t, 'd, 'w) t
    val int32_be : (Int_repr.Int32.t, 'd, 'w) t
    val int32_le : (Int_repr.Int32.t, 'd, 'w) t
    val int64_be : (Int_repr.Int64.t, 'd, 'w) t
    val int64_le : (Int_repr.Int64.t, 'd, 'w) t
    val uint8 : (Int_repr.Uint8.t, 'd, 'w) t
    val uint16_be : (Int_repr.Uint16.t, 'd, 'w) t
    val uint16_le : (Int_repr.Uint16.t, 'd, 'w) t
    val uint32_be : (Int_repr.Uint32.t, 'd, 'w) t
    val uint32_le : (Int_repr.Uint32.t, 'd, 'w) t
    val uint64_be : (Int_repr.Uint64.t, 'd, 'w) t
    val uint64_le : (Int_repr.Uint64.t, 'd, 'w) t
  end
end

module type Bound = sig
  type ('d, 'w) iobuf
  type t = private int [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val window : (_, _) iobuf -> t
  val limit : (_, _) iobuf -> t
  val restore : t -> (_, seek) iobuf -> unit
end
[@@ocaml.doc
  " An iobuf window bound, either upper or lower.  You can't see its int value, but you\n\
  \    can save and restore it. "]

[@@@ocaml.text " The [src_pos] argument of {!Core.Blit.blit} doesn't make sense here. "]

type ('src, 'dst) consuming_blit = src:'src -> dst:'dst -> dst_pos:int -> len:int -> unit

type ('src, 'dst) consuming_blito =
  src:'src
  -> ?src_len:(int[@ocaml.doc " Default is [Iobuf.length src]. "])
  -> dst:'dst
  -> ?dst_pos:(int[@ocaml.doc " Default is [0]. "])
  -> unit
  -> unit

module type Consuming_blit = sig
  type src
  type dst

  val blito : (src, dst) consuming_blito
  val blit : (src, dst) consuming_blit
  val unsafe_blit : (src, dst) consuming_blit

  val subo : ?len:int -> src -> dst
  [@@ocaml.doc " [subo] defaults to using [Iobuf.length src] "]

  val sub : src -> len:int -> dst
end

module type Compound_hexdump = sig
  type ('rw, 'seek) t

  module Hexdump : sig
    type nonrec ('rw, 'seek) t = ('rw, 'seek) t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('rw -> Sexplib0.Sexp.t)
        -> ('seek -> Sexplib0.Sexp.t)
        -> ('rw, 'seek) t
        -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_string_hum : ?max_lines:int -> (_, _) t -> string
    val to_sequence : ?max_lines:int -> (_, _) t -> string Sequence.t
  end
end

module type Peek = sig
  type ('rw, 'seek) iobuf
  type 'seek src = (read, 'seek) iobuf

  [@@@ocaml.text " Similar to [Consume.To_*], but do not advance the buffer. "]

  module To_bytes :
    Blit.S1_distinct with type 'seek src := 'seek src with type _ dst := Bytes.t

  module To_bigstring :
    Blit.S1_distinct with type 'seek src := 'seek src with type _ dst := Bigstring.t

  module To_string : sig
    val sub : (_ src, string) Base.Blit.sub
    val subo : (_ src, string) Base.Blit.subo
  end

  include
    Accessors_read
    with type ('a, 'd, 'w) t = ('d, 'w) iobuf -> pos:int -> 'a
    with type ('a, 'd, 'w) t_local = ('d, 'w) iobuf -> pos:int -> 'a
    with type 'a bin_prot := 'a Bin_prot.Type_class.reader
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
