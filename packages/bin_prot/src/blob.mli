[@@@ocaml.text
  " ['a Blob.t] is type-equivalent to ['a], but has different bin-prot serializers that\n\
  \    prefix the representation with the size of ['a].\n\n\
  \    To understand where this is useful, imagine we have an event type where many\n\
  \    applications look at some parts of an event, but not all applications need to deal\n\
  \    with all parts of an event. We might define:\n\n\
  \    {[\n\
  \      type 'a event =\n\
  \        { time : Time.t\n\
  \        ; source : string\n\
  \        ; details : 'a\n\
  \        } [@@deriving bin_io]\n\
  \    ]}\n\n\
  \    Applications that need to understand all the details of an event could use:\n\n\
  \    {[ type concrete_event = Details.t Blob.t event [@@deriving bin_io] ]}\n\n\
  \    An application that filters events to downsteam consumers based on just [source] or\n\
  \    [time] (but doesn't need to parse [details]) may use:\n\n\
  \    {[ type opaque_event = Blob.Opaque.Bigstring.t event [@@deriving bin_io] ]}\n\n\
  \    This has two advantages:\n\
  \    - (de)serializing messages is faster because potentially costly (de)serialization \
   of\n\
  \      [details] is avoided\n\
  \    - the application can be compiled without any knowledge of any conrete [Details.t]\n\
  \      type, so it's robust to changes in [Details.t]\n\n\
  \    An application that's happy to throw away [details] may use:\n\n\
  \    {[ type ignored_event = Blob.Ignored.t event [@@deriving bin_read] ]}\n\n\
  \    Whereas [opaque_event]s roundtrip, [ignored_event]s actually drop the bytes\n\
  \    representing [details] when deserializing, and therefore do not roundtrip.\n"]

type 'a id = 'a
type 'a t = 'a [@@deriving compare, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Binable.S1 with type 'a t := 'a id

module Opaque : sig
  module Bigstring : sig
    type t [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Binable.S with type t := t

    val to_opaque : 'a -> 'a Type_class.writer -> t
    val of_opaque_exn : t -> 'a Type_class.reader -> 'a
  end

  module String : sig
    type t [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Binable.S with type t := t

    val length : t -> int
    [@@ocaml.doc
      " For performance's concern, we require caller of [to_opaque] and [of_opaque_exn] to\n\
      \        pass in the [buf] as the intermediate buffer for bin_prot conversion. \
       These two\n\
      \        functions will write bytes into the buffer, but will not resize the \
       buffer. So the\n\
      \        caller should prepare big enough buffer for their need.\n\n\
      \        For [of_opaque_exn t], the minimum buffer size should be [length t].\n\n\
      \        For [to_opaque] the necessary buffer size can be computed using [size] from\n\
      \        Type_class.writer or you can catch the exception \
       [Bin_prot.Common.Buffer_short]\n\
      \        (although the latter is not very reliable because some custom bin_io\n\
      \        implementations raise a different exception).\n\n\
      \        Additional caveat: if the opaque blob is malformed/partial then \
       [of_opaque_exn]\n\
      \        can read past the end of the blob, which can result in:\n\
      \        - confusing/non-deterministic error messages (referring to the contents \
       of [buf]\n\
      \          rather than the contents of the blob)\n\
      \        - degraded performance (having to read through the buffer just to fail at \
       the end)\n\
      \    "]

    val to_opaque : buf:Common.buf -> 'a -> 'a Type_class.writer -> t
    val of_opaque_exn : buf:Common.buf -> t -> 'a Type_class.reader -> 'a
  end
end
[@@ocaml.doc
  " An [Opaque.Bigstring.t] or [Opaque.String.t] is an arbitrary piece of bin-prot. The\n\
  \    bin-prot (de-)serializers simply read/write the data, prefixed with its size.\n\n\
  \    When reading bin-prot data, sometimes you won't care about deserializing a \
   particular\n\
  \    piece: perhaps you want to operate on a bin-prot stream, transforming some bits of\n\
  \    the stream and passing the others through untouched. In these cases you can\n\
  \    deserialize using the bin-prot converters for a type involving [Opaque.t]. This is\n\
  \    analogous to reading a sexp file / operating on a sexp stream and using\n\
  \    (de-)serialization functions for a type involving [Sexp.t].\n\n\
  \    The internal representation of [Opaque.Bigstring.t] is a Bigstring, while\n\
  \    [Opaque.String.t] is a string.\n"]

module Ignored : sig
  type t

  val bin_size_t : t Size.sizer
  val bin_read_t : t Read.reader
  val __bin_read_t__ : (int -> t) Read.reader
  val bin_reader_t : t Type_class.reader
end
[@@ocaml.doc
  " An [Ignored.t] is an unusable value with special bin-prot converters. The reader reads\n\
  \    the size and drops that much data from the buffer. Writing is not supported, \
   however\n\
  \    the size of [t] is kept, so [bin_size_t] is available.\n\n\
  \    This can be used in similar situations to [Opaque.t]. If instead of transforming a\n\
  \    bin-prot stream, you are simply consuming it (and not passing it on anywhere), \
   there\n\
  \    is no need to remember the bin-prot representation for the bits you're ignoring. \
   E.g.\n\
  \    if you wish to extract a subset of information from a bin-prot file, which contains\n\
  \    the serialized representation of some type T (or a bunch of Ts in a row, or \
   something\n\
  \    similar), you can define a type which is similar to T but has various components\n\
  \    replaced with [Ignored.t].\n"]
