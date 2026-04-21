[@@@ocaml.text
  " A buffer for incremental decoding of an input stream.\n\n\
  \    An [Unpack_buffer.t] is a buffer to which one can [feed] strings, and then [unpack]\n\
  \    from the buffer to produce a queue of values.\n"]

open! Import

module Unpack_one : sig
  [@@@ocaml.text
    " If [unpack_one : ('a, 'state) unpack], then [unpack_one ~state ~buf ~pos ~len] must\n\
    \      unpack at most one value of type ['a] from [buf] starting at [pos], and not \
     using\n\
    \      more than [len] characters.  [unpack_one] must return one the following:\n\n\
    \      - [`Ok (value, n)] -- unpacking succeeded and consumed [n] bytes, where [0 <= \
     n <=\n\
    \        len].  It is possible to have [n = 0], e.g. for sexp unpacking, which can \
     only\n\
    \        tell it has reached the end of an atom when it encounters the following\n\
    \        punctuation character, which if it is left paren, is the start of the \
     following\n\
    \        sexp.\n\n\
    \      - [`Not_enough_data (state, n)] -- unpacking encountered a valid proper \
     prefix of a\n\
    \        packed value, and consumed [n] bytes, where [0 <= n <= len].  [state] can be\n\
    \        supplied to a future call to [unpack_one] to continue unpacking.\n\n\
    \      - [`Invalid_data] -- unpacking encountered an invalidly packed value.\n\n\
    \      A naive [unpack_one] that only succeeds on a fully packed value could lead to\n\
    \      quadratic behavior if a packed value's bytes are input using a linear number of\n\
    \      calls to [feed]. "]

  type ('a, 'state) unpack_result =
    [ `Ok of 'a * int
    | `Not_enough_data of 'state * int
    | `Invalid_data of Error.t
    ]

  type ('a, 'state) unpack =
    state:'state -> buf:Bigstring.t -> pos:int -> len:int -> ('a, 'state) unpack_result

  type 'a t =
    | T :
        { initial_state : 'state
        ; unpack : ('a, 'state) unpack
        }
        -> 'a t

  include Monad.S with type 'a t := 'a t

  val create : initial_state:'state -> unpack:('a, 'state) unpack -> 'a t

  val create_bin_prot : 'a Bin_prot.Type_class.reader -> 'a t
  [@@ocaml.doc
    " [create_bin_prot reader] returns an unpacker that reads the \"size-prefixed\" \
     bin_prot\n\
    \      encoding, in which a value is encoded by first writing the length of the \
     bin_prot\n\
    \      data as a 64-bit int, and then writing the data itself. "]

  val bin_blob : Bin_prot.Blob.Opaque.Bigstring.t t
  [@@ocaml.doc
    " Reads \"size-prefixed\" bin-blobs, much like [create_bin_prot _], but preserves the\n\
    \      size information and doesn't deserialize the blob.  This allows \
     deserialization to\n\
    \      be deferred and the remainder of the sequence can be unpacked if an \
     individual blob\n\
    \      can't be deserialized. "]

  val sexp : Sexp.t t
  [@@ocaml.doc
    " Beware that when unpacking sexps, one cannot tell if one is at the end of an atom\n\
    \      until one hits punctuation.  So, one should always feed a space (\" \") to a \
     sexp\n\
    \      unpack buffer after feeding a batch of complete sexps, to ensure that the \
     final sexp\n\
    \      is unpacked. "]

  val char : char t

  module type Equal = sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val equal : t -> t -> bool
  end

  val expect : 'a t -> (module Equal with type t = 'a) -> 'a -> unit t
  [@@ocaml.doc
    " [expect t equal a] returns an unpacker that unpacks using [t] and then returns [`Ok]\n\
    \      if the unpacked value equals [a], or [`Invalid_data] otherwise. "]

  val expect_char : char -> unit t
  [@@ocaml.doc " [expect_char] is [expect char (module Char)] "]

  val newline : unit t
end

type 'a t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t

val create : 'a Unpack_one.t -> 'a t

val create_bin_prot : 'a Bin_prot.Type_class.reader -> 'a t
[@@ocaml.doc
  " [create_bin_prot reader] returns an unpack buffer that unpacks the \"size-prefixed\"\n\
  \    bin_prot encoding, in which a value is encoded by first writing the length of the\n\
  \    bin_prot data as a 64-bit int, and then writing the bin_prot data itself. "]

val is_empty : _ t -> bool Or_error.t
[@@ocaml.doc
  " [is_empty] returns [true] if all the data fed into [t] has been unpacked into values;\n\
  \    [false] if [t] has unconsumed bytes or partially unpacked data.  [is_empty] \
   returns an\n\
  \    error if [t] has encountered an unpacking error. "]

val feed : ?pos:int -> ?len:int -> _ t -> Bigstring.t -> unit Or_error.t
[@@ocaml.doc
  " [feed t buf ?pos ?len] adds the specified substring of [buf] to [t]'s buffer.  It\n\
  \    returns an error if [t] has encountered an unpacking error. "]

val feed_string : ?pos:int -> ?len:int -> _ t -> string -> unit Or_error.t
val feed_bytes : ?pos:int -> ?len:int -> _ t -> Bytes.t -> unit Or_error.t

val unpack_into : 'a t -> 'a Queue.t -> unit Or_error.t
[@@ocaml.doc
  " [unpack_into t q] unpacks all the values that it can from [t] and enqueues them in\n\
  \    [q].  If there is an unpacking error, [unpack_into] returns an error, and \
   subsequent\n\
  \    [feed] and unpack operations on [t] will return that same error -- i.e. no more \
   data\n\
  \    can be fed to or unpacked from [t]. "]

val unpack_iter : 'a t -> f:('a -> unit) -> unit Or_error.t
[@@ocaml.doc
  " [unpack_iter t ~f] unpacks all the values that it can from [t], calling [f] on each\n\
  \    value as it's unpacked.  If there is an unpacking error (including if [f] raises),\n\
  \    [unpack_iter] returns an error, and subsequent [feed] and unpack operations on [t]\n\
  \    will return that same error -- i.e., no more data can be fed to or unpacked from \
   [t].\n\n\
  \    Behavior is unspecified if [f] operates on [t]. "]

val debug : bool ref
[@@ocaml.doc
  " [debug] controls whether invariants are checked at each call.  Setting this to [true]\n\
  \    can make things very slow. "]
