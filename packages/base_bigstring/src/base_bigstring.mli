[@@@ocaml.text " String type based on [Bigarray], for use in I/O and C-bindings. "]

open! Base
open Stdlib.Bigarray

[@@@ocaml.text " {2 Types and exceptions} "]

type t = (char, int8_unsigned_elt, c_layout) Array1.t
[@@ocaml.doc " Type of bigstrings "] [@@deriving compare, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type t_frozen = t
[@@ocaml.doc
  " Type of bigstrings which support hashing. Note that mutation invalidates previous\n\
  \    hashes. "]
[@@deriving compare, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

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

include Equal.S with type t := t

[@@@ocaml.text " {2 Creation and string conversion} "]

val create : int -> t
[@@ocaml.doc
  " [create length]\n\
  \    @return a new bigstring having [length].\n\
  \    Content is undefined. "]

val init : int -> f:(int -> char) -> t
[@@ocaml.doc " [init n ~f] creates a bigstring [t] of length [n], with [t.{i} = f i]. "]

val of_string : ?pos:int -> ?len:int -> string -> t
[@@ocaml.doc
  " [of_string ?pos ?len str] @return a new bigstring that is equivalent\n\
  \    to the substring of length [len] in [str] starting at position [pos].\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [String.length str - pos] "]

val of_bytes : ?pos:int -> ?len:int -> bytes -> t
[@@ocaml.doc
  " [of_bytes ?pos ?len str] @return a new bigstring that is equivalent\n\
  \    to the subbytes of length [len] in [str] starting at position [pos].\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [Bytes.length str - pos] "]

val to_string : ?pos:int -> ?len:int -> t -> string
[@@ocaml.doc
  " [to_string ?pos ?len bstr] @return a new string that is equivalent\n\
  \    to the substring of length [len] in [bstr] starting at position [pos].\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [length bstr - pos]\n\n\
  \    @raise Invalid_argument if the string would exceed runtime limits. "]

val to_bytes : ?pos:int -> ?len:int -> t -> bytes
[@@ocaml.doc
  " [to_bytes ?pos ?len bstr] @return a new byte sequence that is equivalent\n\
  \    to the substring of length [len] in [bstr] starting at position [pos].\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [length bstr - pos]\n\n\
  \    @raise Invalid_argument if the bytes would exceed runtime limits. "]

val concat : ?sep:t -> t list -> t
[@@ocaml.doc
  " [concat ?sep list] returns the concatenation of [list] with [sep] in between each. "]

[@@@ocaml.text " {2 Checking} "]

val check_args : loc:string -> pos:int -> len:int -> t -> unit
[@@ocaml.doc
  " [check_args ~loc ~pos ~len bstr] checks the position and length\n\
  \    arguments [pos] and [len] for bigstrings [bstr].  @raise\n\
  \    Invalid_argument if these arguments are illegal for the given\n\
  \    bigstring using [loc] to indicate the calling context. "]

val get_opt_len : t -> pos:int -> int option -> int
[@@ocaml.doc
  " [get_opt_len bstr ~pos opt_len] @return the length of a subbigstring\n\
  \    in [bstr] starting at position [pos] and given optional length\n\
  \    [opt_len].  This function does not check the validity of its\n\
  \    arguments.  Use {!check_args} for that purpose. "]

[@@@ocaml.text " {2 Accessors} "]

val length : t -> int
[@@ocaml.doc " [length bstr] @return the length of bigstring [bstr]. "]

external get : t -> int -> char = "%caml_ba_ref_1"
[@@ocaml.doc " [get t pos] returns the character at [pos] "]

external unsafe_get : t -> int -> char = "%caml_ba_unsafe_ref_1"
[@@ocaml.doc
  " [unsafe_get t pos] returns the character at [pos], without bounds checks. "]

external set : t -> int -> char -> unit = "%caml_ba_set_1"
[@@ocaml.doc " [set t pos] sets the character at [pos] "]

external unsafe_set : t -> int -> char -> unit = "%caml_ba_unsafe_set_1"
[@@ocaml.doc " [unsafe_set t pos] sets the character at [pos], without bounds checks. "]

external is_mmapped : t -> bool = "bigstring_is_mmapped_stub"
[@@ocaml.doc
  " [is_mmapped bstr] @return whether the bigstring [bstr] is\n    memory-mapped. "]
[@@noalloc]

[@@@ocaml.text " {2 Blitting} "]

[@@@ocaml.text
  " [blit ~src ?src_pos ?src_len ~dst ?dst_pos ()] blits [src_len] characters\n\
  \    from [src] starting at position [src_pos] to [dst] at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are out of bounds. "]

include Blit.S with type t := t

val copy : t -> t

module To_string : sig
  val blit : (t, bytes) Blit.blit
  [@@deprecated "[since 2017-10] use [Bigstring.To_bytes.blit] instead"]

  val blito : (t, bytes) Blit.blito
  [@@deprecated "[since 2017-10] use [Bigstring.To_bytes.blito] instead"]

  val unsafe_blit : (t, bytes) Blit.blit
  [@@deprecated "[since 2017-10] use [Bigstring.To_bytes.unsafe_blit] instead"]

  include Blit.S_to_string with type t := t
end

module From_string : Blit.S_distinct with type src := string with type dst := t
module To_bytes : Blit.S_distinct with type src := t with type dst := bytes
module From_bytes : Blit.S_distinct with type src := bytes with type dst := t

val memset : t -> pos:int -> len:int -> char -> unit
[@@ocaml.doc
  " [memset t ~pos ~len c] fills [t] with [c] within the range [\\[pos, pos + len)]. "]

val unsafe_memset : t -> pos:int -> len:int -> char -> unit
[@@ocaml.doc
  " [unsafe_memset t ~pos ~len c] fills [t] with [c] within the range [\\[pos, pos + \
   len)],\n\
  \    without bounds checks. "]

[@@@ocaml.text " Memcmp "]

val memcmp : t -> pos1:int -> t -> pos2:int -> len:int -> int
[@@ocaml.doc
  " [memcmp t1 ~pos1 t2 ~pos2 ~len] is like [compare t1 t2] except performs the comparison\n\
  \    on the subregions of [t1] and [t2] defined by [pos1], [pos2], and [len]. "]

val memcmp_bytes : t -> pos1:int -> Bytes.t -> pos2:int -> len:int -> int
[@@ocaml.doc
  " [memcmp_bytes], for efficient [memcmp] between [Bigstring] and [Bytes] data. "]

val memcmp_string : t -> pos1:int -> string -> pos2:int -> len:int -> int
[@@ocaml.doc
  " [memcmp_string], for efficient [memcmp] between [Bigstring] and [string] data. "]

[@@@ocaml.text " {2 Search} "]

val find : ?pos:int -> ?len:int -> char -> t -> int option
[@@ocaml.doc
  " [find ?pos ?len char t] returns [Some i] for the smallest [i >= pos] such that\n\
  \    [t.{i} = char], or [None] if there is no such [i].\n\n\
  \    @param pos default = 0\n\
  \    @param len default = [length bstr - pos] "]

external unsafe_find : t -> char -> pos:int -> len:int -> int = "bigstring_find"
[@@ocaml.doc
  " Same as [find], but does no bounds checking, and returns a negative value instead of\n\
  \    [None] if [char] is not found. "]
[@@noalloc]

val memmem
  :  haystack:t
  -> needle:t
  -> ?haystack_pos:int
  -> ?haystack_len:int
  -> ?needle_pos:int
  -> ?needle_len:int
  -> unit
  -> int option
[@@ocaml.doc
  " Search for the position of (a substring of) [needle] in (a substring of) [haystack]. "]

external unsafe_memmem
  :  haystack:t
  -> needle:t
  -> haystack_pos:int
  -> haystack_len:int
  -> needle_pos:int
  -> needle_len:int
  -> int
  = "bigstring_memmem_bytecode" "bigstring_memmem"
[@@ocaml.doc " As [unsafe_find] for [memmem]. "] [@@noalloc]

[@@@ocaml.text
  " {2 Accessors for parsing binary values, analogous to [Binary_packing]}\n\n\
  \    These are in [Bigstring] rather than a separate module because:\n\n\
  \    1. Existing [Binary_packing] requires copies and does not work with [bigstring]s.\n\
  \    2. The accessors rely on the implementation of [bigstring], and hence should change\n\
  \    should the implementation of [bigstring] move away from [Bigarray].\n\
  \    3. [Bigstring] already has some external C functions, so it didn't require many\n\
  \    changes to the [jbuild] ^_^.\n\n\
  \    In a departure from [Binary_packing], the naming conventions are chosen to be \
   close to\n\
  \    C99 stdint types, as it's a more standard description and it is somewhat useful in\n\
  \    making compact macros for the implementations.  The accessor names contain \
   endian-ness\n\
  \    to allow for branch-free implementations\n\n\
  \    <accessor>  ::= <unsafe><operation><type><endian>\n\
  \    <unsafe>    ::= unsafe_ | ''\n\
  \    <operation> ::= get_ | set_\n\
  \    <type>      ::= int8 | uint8 | int16 | uint16 | int32 | uint32 | int64 | uint64\n\
  \    <endian>    ::= _le | _be | ''\n\n\
  \    The [unsafe_] prefix indicates that these functions do no bounds checking and \
   silently\n\
  \    truncate out-of-range numeric arguments. "]

val get_int8 : t -> pos:int -> int
val set_int8_exn : t -> pos:int -> int -> unit
val get_uint8 : t -> pos:int -> int
val set_uint8_exn : t -> pos:int -> int -> unit
val unsafe_get_int8 : t -> pos:int -> int
val unsafe_set_int8 : t -> pos:int -> int -> unit
val unsafe_get_uint8 : t -> pos:int -> int
val unsafe_set_uint8 : t -> pos:int -> int -> unit

[@@@ocaml.text " {2 16-bit methods} "]

val get_int16_le : t -> pos:int -> int
val get_int16_be : t -> pos:int -> int
val set_int16_le_exn : t -> pos:int -> int -> unit
val set_int16_be_exn : t -> pos:int -> int -> unit
val unsafe_get_int16_le : t -> pos:int -> int
val unsafe_get_int16_be : t -> pos:int -> int
val unsafe_set_int16_le : t -> pos:int -> int -> unit
val unsafe_set_int16_be : t -> pos:int -> int -> unit
val get_uint16_le : t -> pos:int -> int
val get_uint16_be : t -> pos:int -> int
val set_uint16_le_exn : t -> pos:int -> int -> unit
val set_uint16_be_exn : t -> pos:int -> int -> unit
val unsafe_get_uint16_le : t -> pos:int -> int
val unsafe_get_uint16_be : t -> pos:int -> int
val unsafe_set_uint16_le : t -> pos:int -> int -> unit
val unsafe_set_uint16_be : t -> pos:int -> int -> unit

[@@@ocaml.text " {2 32-bit methods} "]

val get_int32_le : t -> pos:int -> int
val get_int32_be : t -> pos:int -> int
val set_int32_le_exn : t -> pos:int -> int -> unit
val set_int32_be_exn : t -> pos:int -> int -> unit
val unsafe_get_int32_le : t -> pos:int -> int
val unsafe_get_int32_be : t -> pos:int -> int
val unsafe_set_int32_le : t -> pos:int -> int -> unit
val unsafe_set_int32_be : t -> pos:int -> int -> unit
val get_uint32_le : t -> pos:int -> int
val get_uint32_be : t -> pos:int -> int
val set_uint32_le_exn : t -> pos:int -> int -> unit
val set_uint32_be_exn : t -> pos:int -> int -> unit
val unsafe_get_uint32_le : t -> pos:int -> int
val unsafe_get_uint32_be : t -> pos:int -> int
val unsafe_set_uint32_le : t -> pos:int -> int -> unit
val unsafe_set_uint32_be : t -> pos:int -> int -> unit

[@@@ocaml.text
  " Similar to the usage in binary_packing, the below methods are treating the value being\n\
  \    read (or written), as an ocaml immediate integer, as such it is actually 63 bits. \
   If\n\
  \    the user is confident that the range of values used in practice will not require\n\
  \    64-bit precision (i.e. Less than Max_Long), then we can avoid allocation and use an\n\
  \    immediate.  If the user is wrong, an exception will be thrown (for get). "]

[@@@ocaml.text " {2 64-bit signed values} "]

val get_int64_le_exn : t -> pos:int -> int
val get_int64_be_exn : t -> pos:int -> int
val get_int64_le_trunc : t -> pos:int -> int
val get_int64_be_trunc : t -> pos:int -> int
val set_int64_le : t -> pos:int -> int -> unit
val set_int64_be : t -> pos:int -> int -> unit
val unsafe_get_int64_le_exn : t -> pos:int -> int
val unsafe_get_int64_be_exn : t -> pos:int -> int
val unsafe_get_int64_le_trunc : t -> pos:int -> int
val unsafe_get_int64_be_trunc : t -> pos:int -> int
val unsafe_set_int64_le : t -> pos:int -> int -> unit
val unsafe_set_int64_be : t -> pos:int -> int -> unit

[@@@ocaml.text " {2 64-bit unsigned values} "]

val get_uint64_be_exn : t -> pos:int -> int
val get_uint64_le_exn : t -> pos:int -> int
val set_uint64_le_exn : t -> pos:int -> int -> unit
val set_uint64_be_exn : t -> pos:int -> int -> unit
val unsafe_get_uint64_be_exn : t -> pos:int -> int
val unsafe_get_uint64_le_exn : t -> pos:int -> int
val unsafe_set_uint64_le : t -> pos:int -> int -> unit
val unsafe_set_uint64_be : t -> pos:int -> int -> unit

[@@@ocaml.text " {2 32-bit methods with full precision} "]

val get_int32_t_le : t -> pos:int -> Int32.t
val get_int32_t_be : t -> pos:int -> Int32.t
val set_int32_t_le : t -> pos:int -> Int32.t -> unit
val set_int32_t_be : t -> pos:int -> Int32.t -> unit
val unsafe_get_int32_t_le : t -> pos:int -> Int32.t
val unsafe_get_int32_t_be : t -> pos:int -> Int32.t
val unsafe_set_int32_t_le : t -> pos:int -> Int32.t -> unit
val unsafe_set_int32_t_be : t -> pos:int -> Int32.t -> unit

[@@@ocaml.text " {2 64-bit methods with full precision} "]

val get_int64_t_le : t -> pos:int -> Int64.t
val get_int64_t_be : t -> pos:int -> Int64.t
val set_int64_t_le : t -> pos:int -> Int64.t -> unit
val set_int64_t_be : t -> pos:int -> Int64.t -> unit
val unsafe_get_int64_t_le : t -> pos:int -> Int64.t
val unsafe_get_int64_t_be : t -> pos:int -> Int64.t
val unsafe_set_int64_t_le : t -> pos:int -> Int64.t -> unit
val unsafe_set_int64_t_be : t -> pos:int -> Int64.t -> unit

[@@@ocaml.text
  " {2 String methods}\n\n\
  \    These are alternatives to [to_string] that follow the conventions of the int\n\
  \    accessors, and in particular avoid optional arguments. "]

val get_string : t -> pos:int -> len:int -> string
val unsafe_get_string : t -> pos:int -> len:int -> string

module Local : sig
  val get_int64_t_le : t -> pos:int -> Int64.t
  val get_int64_t_be : t -> pos:int -> Int64.t
  val unsafe_get_int64_t_le : t -> pos:int -> Int64.t
  val unsafe_get_int64_t_be : t -> pos:int -> Int64.t
  val get_string : t -> pos:int -> len:int -> string
  val unsafe_get_string : t -> pos:int -> len:int -> string
end

module Int_repr : sig
  include Int_repr.Get with type t := t
  include Int_repr.Set with type t := t

  module Unsafe : sig
    include Int_repr.Get with type t := t
    include Int_repr.Set with type t := t
  end
end

module Private : sig
  val sign_extend_16 : int -> int
end
