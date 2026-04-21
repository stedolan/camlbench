[@@@ocaml.text
  " Packs and unpacks various types of integers into and from strings.\n\n\
  \    Functions ending in [_int] should not be used in 32-bit programs because native \
   OCaml\n\
  \    ints will not be big enough.\n\n\
  \    [pos] arguments refer to the location in the buf string.\n\n\
  \    We support big- and little-endian ints. Note that for an 8-bit (1-byte) integer, \
   there\n\
  \    is no difference, because endian-ness only changes the order of bytes, not bits.\n"]

open! Core
open! Import

type endian =
  [ `Big_endian
  | `Little_endian
  ]
[@@deriving compare, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val compare_endian : endian -> (endian[@merlin.hide]) -> int

  val hash_fold_endian
    :  Ppx_hash_lib.Std.Hash.state
    -> endian
    -> Ppx_hash_lib.Std.Hash.state

  val hash_endian : endian -> Ppx_hash_lib.Std.Hash.hash_value
  val sexp_of_endian : endian -> Sexplib0.Sexp.t
  val endian_of_sexp : Sexplib0.Sexp.t -> endian
  val __endian_of_sexp__ : Sexplib0.Sexp.t -> endian
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val unpack_signed_8 : buf:bytes -> pos:int -> int
val pack_signed_8 : buf:bytes -> pos:int -> int -> unit
val unpack_unsigned_8 : buf:bytes -> pos:int -> int
val pack_unsigned_8 : buf:bytes -> pos:int -> int -> unit

val unpack_signed_16 : byte_order:endian -> buf:bytes -> pos:int -> int
[@@ocaml.doc
  " The functions ending with [_big_endian] or [_little_endian] are faster than the ones\n\
  \    with an explicit [byte_order] argument:\n\n\
  \    {v\n\
  \                                Name | Run time | S. dev. | Warnings\n\
  \  ---------------------------------- | -------- | ------- | --------\n\
  \        pack_signed_16_little_endian |     4 ns |    0 ns |\n\
  \      unpack_signed_16_little_endian |     5 ns |    0 ns |\n\
  \                  pack_signed_32_int |    12 ns |    0 ns |\n\
  \                unpack_signed_32_int |    12 ns |    0 ns |\n\
  \    pack_signed_32_int_little_endian |     4 ns |    0 ns |\n\
  \  unpack_signed_32_int_little_endian |     5 ns |    0 ns |        M\n\
  \                  pack_signed_64_int |    21 ns |    0 ns |        M\n\
  \                unpack_signed_64_int |    21 ns |    0 ns |        M\n\
  \        pack_signed_64_little_endian |     8 ns |    0 ns |\n\
  \      unpack_signed_64_little_endian |     9 ns |    0 ns |        M\n\n\
  \ v}\n"]

val pack_signed_16 : byte_order:endian -> buf:bytes -> pos:int -> int -> unit
val unpack_unsigned_16_big_endian : buf:bytes -> pos:int -> int
val unpack_unsigned_16_little_endian : buf:bytes -> pos:int -> int
val pack_unsigned_16_big_endian : buf:bytes -> pos:int -> int -> unit
val pack_unsigned_16_little_endian : buf:bytes -> pos:int -> int -> unit
val unpack_signed_16_big_endian : buf:bytes -> pos:int -> int
val unpack_signed_16_little_endian : buf:bytes -> pos:int -> int
val pack_signed_16_big_endian : buf:bytes -> pos:int -> int -> unit
val pack_signed_16_little_endian : buf:bytes -> pos:int -> int -> unit
val unpack_unsigned_16 : byte_order:endian -> buf:bytes -> pos:int -> int
val pack_unsigned_16 : byte_order:endian -> buf:bytes -> pos:int -> int -> unit
val unpack_signed_32 : byte_order:endian -> buf:bytes -> pos:int -> int32
val unpack_signed_32_int : byte_order:endian -> buf:bytes -> pos:int -> int
val pack_signed_32 : byte_order:endian -> buf:bytes -> pos:int -> Int32.t -> unit
val pack_signed_32_int : byte_order:endian -> buf:bytes -> pos:int -> int -> unit
val unpack_unsigned_32_int_big_endian : buf:bytes -> pos:int -> int
val unpack_unsigned_32_int_little_endian : buf:bytes -> pos:int -> int
val pack_unsigned_32_int_big_endian : buf:bytes -> pos:int -> int -> unit
val pack_unsigned_32_int_little_endian : buf:bytes -> pos:int -> int -> unit
val unpack_signed_32_int_big_endian : buf:bytes -> pos:int -> int
val unpack_signed_32_int_little_endian : buf:bytes -> pos:int -> int
val pack_signed_32_int_big_endian : buf:bytes -> pos:int -> int -> unit
val pack_signed_32_int_little_endian : buf:bytes -> pos:int -> int -> unit
val unpack_unsigned_32_int : byte_order:endian -> buf:bytes -> pos:int -> int
val pack_unsigned_32_int : byte_order:endian -> buf:bytes -> pos:int -> int -> unit
val unpack_signed_64 : byte_order:endian -> buf:bytes -> pos:int -> int64
val unpack_signed_64_int : byte_order:endian -> buf:bytes -> pos:int -> int
val pack_signed_64 : byte_order:endian -> buf:bytes -> pos:int -> Int64.t -> unit
val pack_signed_64_int : byte_order:endian -> buf:bytes -> pos:int -> int -> unit
val unpack_signed_64_int_little_endian : buf:bytes -> pos:int -> int
val pack_signed_64_int_little_endian : buf:bytes -> pos:int -> int -> unit
val unpack_signed_64_int_big_endian : buf:bytes -> pos:int -> int
val pack_signed_64_int_big_endian : buf:bytes -> pos:int -> int -> unit
val unpack_signed_64_big_endian : buf:bytes -> pos:int -> int64
val unpack_signed_64_little_endian : buf:bytes -> pos:int -> int64
val pack_signed_64_big_endian : buf:bytes -> pos:int -> int64 -> unit
val pack_signed_64_little_endian : buf:bytes -> pos:int -> int64 -> unit

val unpack_float : byte_order:endian -> buf:bytes -> pos:int -> float
[@@ocaml.doc
  " As with integers, floats can be be packed big-endian or little-endian, depending on\n\
  \    the order in which the bytes of the float are layed out. There is nothing \
   interesting\n\
  \    going on computationally from a floating-point perspective, just laying out eight\n\
  \    bytes in one order or the other. "]

val pack_float : byte_order:endian -> buf:bytes -> pos:int -> float -> unit

[@@@ocaml.text
  " The following functions operate on \"fixed-length tail-padded strings\", by which is\n\
  \    meant a string possibly followed by some padding, such that the length of the \
   string\n\
  \    plus the length of the padding equals the fixed length. "]

val unpack_tail_padded_fixed_string
  :  ?padding:char
  -> buf:Bytes.t
  -> pos:int
  -> len:int
  -> unit
  -> string
[@@ocaml.doc
  " Decode the fixed-length tail-padded string having length [len] from [buf] starting at\n\
  \    [pos]. Return a string containing only the non-padding characters. The default\n\
  \    padding is '\\x00'. "]

val pack_tail_padded_fixed_string
  :  ?padding:char
  -> buf:Bytes.t
  -> pos:int
  -> len:int
  -> string
  -> unit
[@@ocaml.doc
  " Encode and pack the given string as a tail padded fixed length string having length\n\
  \    [len]. Place it in [buf] starting at position [pos].  If the length of the string \
   is\n\
  \    less then [len] pad it with the padding characters until its length is equal to \
   [len].\n\
  \    If the string is longer than [len] raise [Invalid_argument].  The default padding \
   is\n\
  \    '\\x00'. "]

module Private : sig
  val last_nonmatch_plus_one : buf:bytes -> min_pos:int -> pos:int -> char:char -> int

  exception Unpack_signed_64_int_most_significant_byte_too_large of int
end
