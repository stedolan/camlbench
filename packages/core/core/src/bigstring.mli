[@@@ocaml.text " String type based on [Bigarray], for use in I/O and C-bindings. "]

open! Import
open Bigarray

[@@@ocaml.text " {2 Types and exceptions} "]

type t = (char, int8_unsigned_elt, c_layout) Array1.t
[@@ocaml.doc " Type of bigstrings "] [@@deriving compare, quickcheck, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type t_frozen = t
[@@ocaml.doc
  " Type of bigstrings which support hashing. Note that mutation invalidates previous \
   hashes. "]
[@@deriving compare, hash, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val compare_t_frozen : t_frozen -> (t_frozen[@merlin.hide]) -> int

  val hash_fold_t_frozen
    :  Ppx_hash_lib.Std.Hash.state
    -> t_frozen
    -> Ppx_hash_lib.Std.Hash.state

  val hash_t_frozen : t_frozen -> Ppx_hash_lib.Std.Hash.hash_value
  val sexp_of_t_frozen : t_frozen -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of Base_bigstring with type t := t and type t_frozen := t_frozen
include Hexdump.S with type t := t

[@@@ocaml.text " {2 Creation and string conversion} "]

val create : int -> t
[@@ocaml.doc
  " [create length]\n\
  \    @return a new bigstring having [length].\n\
  \    Content is undefined. "]

val sub_shared : ?pos:int -> ?len:int -> t -> t
[@@ocaml.doc
  " [sub_shared ?pos ?len bstr] @return the sub-bigstring in [bstr]\n\
  \    that starts at position [pos] and has length [len].  The sub-bigstring\n\
  \    shares the same memory region, i.e. modifying it will modify the\n\
  \    original bigstring.  Holding on to the sub-bigstring will also keep\n\
  \    the (usually bigger) original one around.\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [Bigstring.length bstr - pos] "]

[@@@ocaml.text " {2 Reading/writing bin-prot} "]

[@@@ocaml.text
  " These functions write the \"size-prefixed\" bin-prot format that is used by, e.g.,\n\
  \    async's [Writer.write_bin_prot], [Reader.read_bin_prot] and\n\
  \    [Unpack_buffer.Unpack_one.create_bin_prot]. "]

val write_bin_prot
  :  t
  -> ?pos:(int[@ocaml.doc " default is 0 "])
  -> 'a Bin_prot.Type_class.writer
  -> 'a
  -> int
[@@ocaml.doc
  " [write_bin_prot t writer a] writes [a] to [t] starting at [pos], and returns the index\n\
  \    in [t] immediately after the last byte written.  It raises if [pos < 0] or if [a]\n\
  \    doesn't fit in [t]. "]

val write_bin_prot_known_size
  :  t
  -> ?pos:(int[@ocaml.doc " default is 0 "])
  -> 'a Bin_prot.Write.writer
  -> size:int
  -> 'a
  -> int
[@@ocaml.doc
  " Same as [write_bin_prot], with the difference that [size] is pre-computed by the\n\
  \    caller. [size] is assumed to be the result of calling the bin prot sizer on the \
   value\n\
  \    being written. "]

val read_bin_prot
  :  t
  -> ?pos:int
  -> ?len:int
  -> 'a Bin_prot.Type_class.reader
  -> ('a * int) Or_error.t
[@@ocaml.doc
  " The [read_bin_prot*] functions read from the region of [t] starting at [pos] of length\n\
  \    [len].  They return the index in [t] immediately after the last byte read.  They \
   raise\n\
  \    if [pos] and [len] don't describe a region of [t]. "]

val read_bin_prot_verbose_errors
  :  t
  -> ?pos:int
  -> ?len:int
  -> 'a Bin_prot.Type_class.reader
  -> [ `Invalid_data of Error.t | `Not_enough_data | `Ok of 'a * int ]

[@@@ocaml.text " {2 Destruction} "]

external unsafe_destroy : t -> unit = "bigstring_destroy_stub"
[@@ocaml.doc
  " [unsafe_destroy bstr] destroys the bigstring by deallocating its associated data or,\n\
  \    if memory-mapped, unmapping the corresponding file, and setting all dimensions to\n\
  \    zero.  This effectively frees the associated memory or address-space resources\n\
  \    instantaneously.  This feature helps reclaim the resources sooner than they are\n\
  \    automatically reclaimed by the GC.\n\n\
  \    This operation is safe unless you have passed the bigstring to another thread \
   that is\n\
  \    performing operations on it at the same time.  Access to the bigstring after this\n\
  \    operation will yield array bounds exceptions.\n\n\
  \    @raise Failure if the bigstring has already been deallocated (or deemed \
   \"external\",\n\
  \    which is treated equivalently), or if it has proxies, i.e. other bigstrings \
   referring\n\
  \    to the same data. "]

external unsafe_destroy_and_resize : t -> len:int -> t = "bigstring_realloc"
[@@ocaml.doc
  " [unsafe_destroy_and_resize bstr ~len] reallocates the memory backing\n\
  \    [bstr] and returns a new bigstring that starts at position 0 and has\n\
  \    length [len]. If [len] is greater than [length bstr] then the newly\n\
  \    allocated memory will not be initialized.\n\n\
  \    Similar to [unsafe_destroy], this operation is safe unless you have passed\n\
  \    the bigstring to another thread that is performing operations on it at the\n\
  \    same time.  Access to [bstr] after this operation will yield array bounds\n\
  \    exceptions.\n\n\
  \    @raise Failure if the bigstring has already been deallocated (or deemed\n\
  \    \"external\", which is treated equivalently), if it is backed by a memory\n\
  \    map, or if it has proxies, i.e. other bigstrings referring to the same\n\
  \    data. "]

val get_tail_padded_fixed_string
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> unit
  -> string
[@@ocaml.doc
  " Similar to [Binary_packing.unpack_tail_padded_fixed_string] and\n\
  \    [.pack_tail_padded_fixed_string]. "]

val get_tail_padded_fixed_string_local
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> unit
  -> string

val set_tail_padded_fixed_string
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> string
  -> unit

val get_head_padded_fixed_string
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> unit
  -> string

val get_head_padded_fixed_string_local
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> unit
  -> string

val set_head_padded_fixed_string
  :  padding:char
  -> t
  -> pos:int
  -> len:int
  -> string
  -> unit

module Unstable : sig
  type nonrec t = t [@@deriving bin_io ~localize, compare, equal, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type nonrec t_frozen = t_frozen [@@deriving bin_io ~localize, compare, hash, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_t_frozen : Bin_prot.Shape.t
    val bin_size_t_frozen : t_frozen Bin_prot.Size.sizer
    val bin_size_t_frozen__local : t_frozen Bin_prot.Size.sizer_local
    val bin_write_t_frozen : t_frozen Bin_prot.Write.writer
    val bin_write_t_frozen__local : t_frozen Bin_prot.Write.writer_local
    val bin_writer_t_frozen : t_frozen Bin_prot.Type_class.writer
    val bin_read_t_frozen : t_frozen Bin_prot.Read.reader
    val __bin_read_t_frozen__ : (int -> t_frozen) Bin_prot.Read.reader
    val bin_reader_t_frozen : t_frozen Bin_prot.Type_class.reader
    val bin_t_frozen : t_frozen Bin_prot.Type_class.t
    val compare_t_frozen : t_frozen -> (t_frozen[@merlin.hide]) -> int

    val hash_fold_t_frozen
      :  Ppx_hash_lib.Std.Hash.state
      -> t_frozen
      -> Ppx_hash_lib.Std.Hash.state

    val hash_t_frozen : t_frozen -> Ppx_hash_lib.Std.Hash.hash_value
    val sexp_of_t_frozen : t_frozen -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize, stable_witness, compare, equal, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nonrec t_frozen = t_frozen
    [@@deriving bin_io ~localize, stable_witness, compare, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_t_frozen : Bin_prot.Shape.t
      val bin_size_t_frozen : t_frozen Bin_prot.Size.sizer
      val bin_size_t_frozen__local : t_frozen Bin_prot.Size.sizer_local
      val bin_write_t_frozen : t_frozen Bin_prot.Write.writer
      val bin_write_t_frozen__local : t_frozen Bin_prot.Write.writer_local
      val bin_writer_t_frozen : t_frozen Bin_prot.Type_class.writer
      val bin_read_t_frozen : t_frozen Bin_prot.Read.reader
      val __bin_read_t_frozen__ : (int -> t_frozen) Bin_prot.Read.reader
      val bin_reader_t_frozen : t_frozen Bin_prot.Type_class.reader
      val bin_t_frozen : t_frozen Bin_prot.Type_class.t
      val stable_witness_t_frozen : t_frozen Ppx_stable_witness_runtime.Stable_witness.t
      val compare_t_frozen : t_frozen -> (t_frozen[@merlin.hide]) -> int

      val hash_fold_t_frozen
        :  Ppx_hash_lib.Std.Hash.state
        -> t_frozen
        -> Ppx_hash_lib.Std.Hash.state

      val hash_t_frozen : t_frozen -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_t_frozen : t_frozen -> Sexplib0.Sexp.t
      val t_frozen_of_sexp : Sexplib0.Sexp.t -> t_frozen
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
