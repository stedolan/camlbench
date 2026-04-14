[@@@ocaml.text " Common definitions used by binary protocol converters "]

open Bigarray

[@@@ocaml.text " {2 Buffers} "]

type pos = int [@@ocaml.doc " Position within buffers "]

type pos_ref = pos ref [@@ocaml.doc " Reference to a position within buffers "]

type buf = (char, int8_unsigned_elt, c_layout) Array1.t [@@ocaml.doc " Buffers "]

val create_buf : int -> buf [@@ocaml.doc " [create_buf n] creates a buffer of size [n]. "]

val buf_len : buf -> int [@@ocaml.doc " [buf_len buf] returns the length of [buf]. "]

val assert_pos : pos -> unit
[@@ocaml.doc " [assert_pos pos] @raise Invalid_argument if position [pos] is negative. "]

val check_pos : buf -> pos -> unit
[@@ocaml.doc
  " [check_pos buf pos] @raise Buffer_short if position [pos] is past the end\n\
  \    of buffer [buf]. "]

val check_next : buf -> pos -> unit
[@@ocaml.doc
  " [check_next buf pos] @raise Buffer_short if the next position after [pos] is past\n\
  \    the end of buffer [buf]. "]

val safe_get_pos : buf -> pos_ref -> pos
[@@ocaml.doc
  " [safe_get_pos buf pos_ref] @return the position referenced by [pos_ref] within buffer\n\
  \    [buf]. @raise Buffer_short if the position is past the end of the buffer [buf]. "]

val blit_string_buf : ?src_pos:int -> string -> ?dst_pos:int -> buf -> len:int -> unit
[@@ocaml.doc
  " [blit_string_buf ?src_pos src ?dst_pos dst ~len] blits [len]\n\
  \    bytes of the source string [src] starting at position [src_pos]\n\
  \    to buffer [dst] starting at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n"]

val blit_bytes_buf : ?src_pos:int -> bytes -> ?dst_pos:int -> buf -> len:int -> unit
[@@ocaml.doc
  " [blit_bytes_buf ?src_pos src ?dst_pos dst ~len] blits [len]\n\
  \    bytes of the source byte sequence [src] starting at position [src_pos]\n\
  \    to buffer [dst] starting at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n"]

val blit_buf_string : ?src_pos:int -> buf -> ?dst_pos:int -> bytes -> len:int -> unit
[@@ocaml.doc
  " [blit_buf_string ?src_pos src ?dst_pos dst ~len] blits [len]\n\
  \    bytes of the source buffer [src] starting at position [src_pos]\n\
  \    to string [dst] starting at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n"]

val blit_buf_bytes : ?src_pos:int -> buf -> ?dst_pos:int -> bytes -> len:int -> unit
[@@ocaml.doc
  " [blit_buf_bytes ?src_pos src ?dst_pos dst ~len] blits [len]\n\
  \    bytes of the source buffer [src] starting at position [src_pos]\n\
  \    to byte sequence [dst] starting at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n"]

val blit_buf : ?src_pos:int -> src:buf -> ?dst_pos:int -> dst:buf -> int -> unit
[@@ocaml.doc
  " [blit_buf ?src_pos ~src ?dst_pos ~dst len] blits [len] bytes of the\n\
  \    source buffer [src] starting at position [src_pos] to destination\n\
  \    buffer [dst] starting at position [dst_pos].\n\n\
  \    @raise Invalid_argument if the designated ranges are invalid.\n"]

[@@@ocaml.text " {2 Errors and exceptions} "]

exception Buffer_short [@ocaml.doc " Buffer too short for read/write operation "]

exception No_variant_match [@ocaml.doc " Used internally for backtracking "]

module ReadError : sig
  type t =
    | Neg_int8 [@ocaml.doc " Negative integer was positive or zero "]
    | Int_code [@ocaml.doc " Unknown integer code while reading integer "]
    | Int_overflow [@ocaml.doc " Overflow reading integer "]
    | Nat0_code [@ocaml.doc " Unknown integer code while reading natural number "]
    | Nat0_overflow [@ocaml.doc " Overflow reading natural number "]
    | Int32_code [@ocaml.doc " Unknown integer code while reading 32bit integer "]
    | Int64_code [@ocaml.doc " Unknown integer code while reading 64bit integer "]
    | Nativeint_code [@ocaml.doc " Unknown integer code while reading native integer "]
    | Unit_code [@ocaml.doc " Illegal unit value "]
    | Bool_code [@ocaml.doc " Illegal boolean value "]
    | Option_code [@ocaml.doc " Illegal option code "]
    | String_too_long [@ocaml.doc " String too long "]
    | Variant_tag [@ocaml.doc " Untagged integer encoding for variant tag "]
    | Array_too_long [@ocaml.doc " Array too long "]
    | List_too_long of
        { len : int
        ; max_len : int
        } [@ocaml.doc " List too long "]
    | Hashtbl_too_long [@ocaml.doc " Hashtable too long "]
    | Sum_tag of string [@ocaml.doc " Illegal sum tag for given type "]
    | Variant of string [@ocaml.doc " Illegal variant for given type "]
    | Poly_rec_bound of string
    [@ocaml.doc " Attempt to read data bound through polymorphic record fields "]
    | Variant_wrong_type of string
    [@ocaml.doc " Unexpected attempt to read variant with given non-variant type "]
    | Silly_type of string
    [@ocaml.doc
      " [Silly_type type_name] indicates unhandled but silly case\n\
      \        where a type of the sort [type 'a type_name = 'a] is used\n\
      \        with a polymorphic variant as type parameter and included\n\
      \        in another polymorphic variant type. "]
    | Empty_type of string
    [@ocaml.doc " Attempt to read data that corresponds to an empty type. "]

  val to_string : t -> string
  [@@ocaml.doc " [to_string err] @return string representation of read error [err]. "]
end

exception Read_error of ReadError.t * pos [@ocaml.doc " [ReadError (err, err_pos)] "]

exception
  Poly_rec_write of string
      [@ocaml.doc
        " [PolyRecWrite type] gets raised when the user attempts to write or\n\
        \    estimate the size of a value of a type that is bound through a\n\
        \    polymorphic record field in type definition [type]. "]

exception
  Empty_type of string
      [@ocaml.doc
        " [EmptyType] gets raised when the user attempts to write or estimate\n\
        \    the size of a value of an empty type, which would not make sense. "]

val raise_read_error : ReadError.t -> pos -> 'a
[@@ocaml.doc " [raise_read_error err pos] "]

val raise_variant_wrong_type : string -> pos -> 'a
[@@ocaml.doc " [raise_variant_wrong_type name pos] "]

val raise_concurrent_modification : string -> 'a
[@@ocaml.doc
  " [raise_concurrent_modification loc] @raise Failure if a binary writer\n\
  \    detects a concurrent change to the underlying data structure. "]

val array_bound_error : unit -> 'a [@@ocaml.doc " [array_bound_error ()] "]

[@@@ocaml.text " {2 Bigarrays} "]

type vec32 = (float, float32_elt, fortran_layout) Array1.t
type vec64 = (float, float64_elt, fortran_layout) Array1.t
type vec = vec64
type mat32 = (float, float32_elt, fortran_layout) Array2.t
type mat64 = (float, float64_elt, fortran_layout) Array2.t
type mat = mat64

[@@@ocaml.text " {2 Miscellaneous} "]

val copy_htbl_list : ('a, 'b) Hashtbl.t -> ('a * 'b) list -> ('a, 'b) Hashtbl.t
[@@ocaml.doc
  " [copy_htbl_list htbl lst] adds all [(key, value)] pairs in [lst]\n\
  \    to hash table [htbl]. "]

[@@@ocaml.text " {2 NOTE: unsafe functions!!!} "]

external unsafe_blit_buf
  :  src_pos:int
  -> src:(buf[@local_opt])
  -> dst_pos:int
  -> dst:buf
  -> len:int
  -> unit
  = "bin_prot_blit_buf_stub"

external unsafe_blit_string_buf
  :  src_pos:int
  -> (string[@local_opt])
  -> dst_pos:int
  -> buf
  -> len:int
  -> unit
  = "bin_prot_blit_string_buf_stub"
[@@noalloc]

external unsafe_blit_bytes_buf
  :  src_pos:int
  -> (bytes[@local_opt])
  -> dst_pos:int
  -> buf
  -> len:int
  -> unit
  = "bin_prot_blit_bytes_buf_stub"
[@@noalloc]

external unsafe_blit_buf_string
  :  src_pos:int
  -> buf
  -> dst_pos:int
  -> bytes
  -> len:int
  -> unit
  = "bin_prot_blit_buf_bytes_stub"
[@@noalloc]

external unsafe_blit_buf_bytes
  :  src_pos:int
  -> buf
  -> dst_pos:int
  -> bytes
  -> len:int
  -> unit
  = "bin_prot_blit_buf_bytes_stub"
[@@noalloc]

external unsafe_blit_float_array_buf
  :  src_pos:int
  -> (float array[@local_opt])
  -> dst_pos:int
  -> buf
  -> len:int
  -> unit
  = "bin_prot_blit_float_array_buf_stub"
[@@noalloc]

external unsafe_blit_buf_float_array
  :  src_pos:int
  -> buf
  -> dst_pos:int
  -> float array
  -> len:int
  -> unit
  = "bin_prot_blit_buf_float_array_stub"
[@@noalloc]

external unsafe_blit_floatarray_buf
  :  src_pos:int
  -> (floatarray[@local_opt])
  -> dst_pos:int
  -> buf
  -> len:int
  -> unit
  = "bin_prot_blit_float_array_buf_stub"
[@@noalloc]

external unsafe_blit_buf_floatarray
  :  src_pos:int
  -> buf
  -> dst_pos:int
  -> floatarray
  -> len:int
  -> unit
  = "bin_prot_blit_buf_float_array_stub"
[@@noalloc]

val ( + ) : int -> int -> int
