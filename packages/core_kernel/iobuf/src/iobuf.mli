[@@@ocaml.text
  " A non-moving (in the GC sense) contiguous range of bytes, useful for I/O operations.\n\n\
  \    An iobuf consists of:\n\n\
  \    - bigstring\n\
  \    - limits -- a subrange of the bigstring\n\
  \    - window -- a subrange of the limits\n\n\
  \    All iobuf operations are restricted to operate within the limits.  Initially, the\n\
  \    window of an iobuf is identical to its limits.  A phantom type, the \"seek\" \
   permission,\n\
  \    controls whether or not code is allowed to change the limits and window.  With seek\n\
  \    permission, the limits can be [narrow]ed, but can never be widened, and the \
   window can\n\
  \    be set to an arbitrary subrange of the limits.\n\n\
  \    A phantom type controls whether code can read and write bytes in the bigstring \
   (within\n\
  \    the limits) or can only read them.\n\n\
  \    To present a restricted view of an iobuf to a client, one can create a sub-iobuf or\n\
  \    add a type constraint.\n\n\
  \    Functions operate on the window unless the documentation or naming indicates\n\
  \    otherwise. "]

open! Core
open Iobuf_intf

type nonrec seek = seek [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_seek : seek -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type nonrec no_seek = no_seek [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_no_seek : no_seek -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type t_repr
[@@ocaml.doc
  " This type is a compiler witness that 'rw and 'seek do not affect layout; it enables\n\
  \    wider use of unboxed GADTs. "]

type (-'data_perm_read_write, +'seek_permission) t = private t_repr
[@@ocaml.doc
  " The first type parameter controls whether the iobuf can be written to.  The second\n\
  \    type parameter controls whether the window and limits can be changed.\n\n\
  \    See the [Perms] module for information on how the first type parameter is used.\n\n\
  \    To allow [no_seek] or [seek] access, a function's type uses [_] rather than \
   [no_seek]\n\
  \    as the type argument to [t].  Using [_] allows the function to be directly \
   applied to\n\
  \    either permission.  Using a specific permission would require code to use coercion\n\
  \    [:>].\n\n\
  \    There is no [t_of_sexp].  One should use [Iobuf.Hexdump.t_of_sexp] or \
   [@sexp.opaque]\n\
  \    as desired. "]

val globalize : _ -> _ -> ('rw, _) t -> ('rw, _) t

type ('rw, 'seek) iobuf := ('rw, 'seek) t

type ('rw, 'seek) t_with_shallow_sexp = ('rw, 'seek) t
[@@ocaml.doc
  " [t_with_shallow_sexp] has a [sexp_of] that shows the windows and limits of\n\
  \    the underlying bigstring, but no data. We do this rather than deriving sexp_of\n\
  \    on [t] because it is much more likely to be noise than useful information, and\n\
  \    so callers should probably not display the iobuf at all. "]
[@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t_with_shallow_sexp
    :  ('rw -> Sexplib0.Sexp.t)
    -> ('seek -> Sexplib0.Sexp.t)
    -> ('rw, 'seek) t_with_shallow_sexp
    -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S2 with type ('rw, 'seek) t := ('rw, 'seek) t

module Window : Hexdump.S2 with type ('rw, 'seek) t := ('rw, 'seek) t
[@@ocaml.doc
  " Provides a [Window.Hexdump] submodule that renders the contents of [t]'s window. "]

module Limits : Hexdump.S2 with type ('rw, 'seek) t := ('rw, 'seek) t
[@@ocaml.doc
  " Provides a [Limits.Hexdump] submodule that renders the contents of [t]'s limits. "]

include
  Compound_hexdump with type ('rw, 'seek) t := ('rw, 'seek) t
[@@ocaml.doc
  " Provides a [Hexdump] submodule that renders the contents of [t]'s window and limits\n\
  \    using indices relative to the limits. "]

module Debug : Compound_hexdump with type ('rw, 'seek) t := ('rw, 'seek) t
[@@ocaml.doc
  " Provides a [Debug.Hexdump] submodule that renders the contents of [t]'s window,\n\
  \    limits, and underlying bigstring using indices relative to the bigstring. "]

[@@@ocaml.text " {2 Creation} "]

val create : len:int -> (_, _) t
[@@ocaml.doc
  " [create ~len] creates a new iobuf, backed by a bigstring of length [len],\n\
  \    with the limits and window set to the entire bigstring. "]

val empty : (read, no_seek) t [@@ocaml.doc " [empty] is an immutable [t] of size 0. "]

val of_bigstring
  :  ?pos:(int[@ocaml.doc " default is [0] "])
  -> ?len:(int[@ocaml.doc " default is [Bigstring.length bigstring - pos] "])
  -> Bigstring.t
  -> ([< read_write ], _) t
[@@ocaml.doc
  " [of_bigstring bigstring ~pos ~len] returns an iobuf backed by [bigstring], with the\n\
  \    window and limits specified starting at [pos] and of length [len]. "]
[@@ocaml.doc " forbid [immutable] to prevent aliasing "]

val of_bigstring_local : ?pos:int -> ?len:int -> Bigstring.t -> ([< read_write ], _) t
[@@ocaml.doc
  " [of_bigstring_local] is like [of_bigstring], but it allocates the iobuf record\n\
  \    locally."]

val unsafe_bigstring_view : pos:int -> len:int -> Bigstring.t -> ([< read_write ], _) t
[@@ocaml.doc " More efficient than the above (optional arguments are costly). "]

val bigstring_view : pos:int -> len:int -> Bigstring.t -> ([< read_write ], _) t

val of_string : string -> (_, _) t
[@@ocaml.doc " [of_string s] returns a new iobuf whose contents are [s]. "]

val sub_shared : ?pos:int -> ?len:int -> ('d, _) t -> ('d, _) t
[@@ocaml.doc
  " [sub_shared t ~pos ~len] returns a new iobuf with limits and window set to the\n\
  \    subrange of [t]'s window specified by [pos] and [len].  [sub_shared] preserves data\n\
  \    permissions, but allows arbitrary seek permissions on the resulting iobuf. "]

val sub_shared_local : ?pos:int -> ?len:int -> ('d, _) t -> ('d, _) t
[@@ocaml.doc
  " [sub_shared_local] is like [sub_shared], but it allocates the iobuf record locally. "]

val copy : (_, _) t -> (_, _) t
[@@ocaml.doc
  " [copy t] returns a new iobuf whose contents are the same as those in the window of\n\
  \    [t]. "]

val clone : (_, _) t -> (_, _) t
[@@ocaml.doc
  " [clone t] returns a new iobuf that is a deep-copy of [t] including an exact copy of\n\
  \    the underlying buffer and bounds. This means data outside the window is copied as\n\
  \    well. "]

val transfer : src:([> read ], _) t -> dst:([> write ], seek) t -> unit
[@@ocaml.doc
  " [transfer ~src ~dst] makes the window of [dst] into a copy of the window of [src].\n\
  \    Like [blito], [transfer] will raise if [Iobuf.length dst] < [Iobuf.length src].\n\n\
  \    It is a utility function defined as [reset dst; blito ~src ~dst; flip_lo dst]. "]

val set_bounds_and_buffer
  :  src:(([> write ] as 'data), _) t
  -> dst:('data, seek) t
  -> unit
[@@ocaml.doc
  " [set_bounds_and_buffer ~src ~dst] copies bounds metadata (i.e., limits and window) and\n\
  \    shallowly copies the buffer (data pointer) from [src] to [dst].  It does not access\n\
  \    data, but does allow access through [dst].  This makes [dst] an alias of [src].\n\n\
  \    Because [set_bounds_and_buffer] creates an alias, we disallow immutable [src] and\n\
  \    [dst] using [[> write]].  Otherwise, one of [src] or [dst] could be [read_write :>\n\
  \    read] and the other [immutable :> read], which would allow you to write the\n\
  \    [immutable] alias's data through the [read_write] alias.\n\n\
  \    [set_bounds_and_buffer] is typically used with a frame iobuf that need only be\n\
  \    allocated once.  This frame can be updated repeatedly and handed to users, without\n\
  \    further allocation.  Allocation-sensitive applications need this. "]

val set_bounds_and_buffer_sub
  :  pos:int
  -> len:int
  -> src:(([> write ] as 'data), _) t
  -> dst:('data, seek) t
  -> unit
[@@ocaml.doc
  " [set_bounds_and_buffer_sub ~pos ~len ~src ~dst] is a more efficient version of\n\
  \    [set_bounds_and_buffer ~src:(Iobuf.sub_shared ~pos ~len src) ~dst].\n\n\
  \    [set_bounds_and_buffer ~src ~dst] is not the same as [set_bounds_and_buffer_sub \
   ~dst\n\
  \    ~src ~len:(Iobuf.length src)] because the limits are narrowed in the latter case.\n\n\
  \    [~len] and [~pos] are mandatory for performance reasons, in concert with \
   [@@inline].\n\
  \    If they were optional, allocation would be necessary when passing a non-default,\n\
  \    non-constant value, which is an important use case. "]

[@@@ocaml.text
  " {2 Generalization}\n\n\
  \    One may wonder why you'd want to call [no_seek], given that a cast is already\n\
  \    possible, e.g., [t : (_, seek) t :> (_, no_seek) t].  It turns out that if you \
   want to\n\
  \    define some [f : (_, _) t -> unit] of your own that can be conveniently applied to\n\
  \    [seek] iobufs without the user having to cast [seek] up, you need this [no_seek]\n\
  \    function.\n\n\
  \    [read_only] is more of a historical convenience now that [read_write] is a \
   polymorphic\n\
  \    variant, as one can now explicitly specify the general type for an argument with\n\
  \    something like [t : (_ perms, _) t :> (read, _) t]. "]

val read_only : ([> read ], 's) t -> (read, 's) t
val read_only_local : ([> read ], 's) t -> (read, 's) t
val no_seek : ('r, _) t -> ('r, no_seek) t
val no_seek_local : ('r, _) t -> ('r, no_seek) t

[@@@ocaml.text " {2 Accessors} "]

val capacity : (_, _) t -> int
[@@ocaml.doc
  " [capacity t] returns the size of [t]'s limits subrange.  The capacity of an iobuf can\n\
  \    be reduced via [narrow]. "]

val length : (_, _) t -> int
[@@ocaml.doc " [length t] returns the size of [t]'s window. "]

val length_lo : (_, _) t -> int
[@@ocaml.doc
  " [length_lo t] returns the length that [t]'s window would have after calling [flip_lo],\n\
  \    without actually changing the window. This is the number of bytes between the lower\n\
  \    limit and the start of the window.\n\n\
  \    When you're writing to the window, you can think of this as the number of bytes\n\
  \    already written. When reading from the window, this can mean the number of bytes\n\
  \    already consumed.\n\n\
  \    This is equivalent to: {[ Iobuf.Expert.(lo t - lo_min t)]}. "]

val length_hi : (_, _) t -> int
[@@ocaml.doc
  " [length_hi t] returns the length that [t]'s window would have after calling [flip_hi],\n\
  \    without actually changing the window. This is the number of bytes between the end \
   of\n\
  \    the window and the upper limit of the buffer.\n\n\
  \    This is equivalent to: {[ Iobuf.Expert.(hi_max t - hi t) ]}. "]

val is_empty : (_, _) t -> bool [@@ocaml.doc " [is_empty t] is [length t = 0]. "]

[@@@ocaml.text " {2 Changing the limits} "]

val narrow : (_, seek) t -> unit
[@@ocaml.doc " [narrow t] sets [t]'s limits to the current window. "]

val narrow_lo : (_, seek) t -> unit
[@@ocaml.doc
  " [narrow_lo t] sets [t]'s lower limit to the beginning of the current window. "]

val narrow_hi : (_, seek) t -> unit
[@@ocaml.doc " [narrow_hi t] sets [t]'s upper limit to the end of the current window. "]

[@@@ocaml.text " {2 Comparison} "]

val memcmp : (_, _) t -> (_, _) t -> int
[@@ocaml.doc
  " [memcmp a b] first compares the length of [a] and [b]'s windows and then compares the\n\
  \    bytes in the windows for equivalence. "]

[@@@ocaml.text " {2 Changing the window} "]

[@@@ocaml.text
  " One can call [Lo_bound.window t] to get a snapshot of the lower bound of the window,\n\
  \    and then later restore that snapshot with [Lo_bound.restore].  This is useful for\n\
  \    speculatively parsing, and then rewinding when there isn't enough data to finish.\n\n\
  \    Similarly for [Hi_bound.window] and [Lo_bound.restore].\n\n\
  \    Using a snapshot with a different iobuf, even a sub iobuf of the snapshotted one, \
   has\n\
  \    unspecified results.  An exception may be raised, or a silent error may occur.\n\
  \    However, the safety guarantees of the iobuf will not be violated, i.e., the attempt\n\
  \    will not enlarge the limits of the subject iobuf. "]

module type Bound = Bound with type ('d, 'w) iobuf := ('d, 'w) t

module Lo_bound : Bound
module Hi_bound : Bound

val advance : (_, seek) t -> int -> unit
[@@ocaml.doc
  " [advance t amount] advances the lower bound of the window by [amount].  It is an error\n\
  \    to advance past the upper bound of the window or the lower limit. "]

val unsafe_advance : (_, seek) t -> int -> unit
[@@ocaml.doc
  " [unsafe_advance] is like [advance] but with no bounds checking, so incorrect usage can\n\
  \    easily cause segfaults. "]

val resize : (_, seek) t -> len:int -> unit
[@@ocaml.doc
  " [resize t] sets the length of [t]'s window, provided it does not exceed limits. "]

val unsafe_resize : (_, seek) t -> len:int -> unit
[@@ocaml.doc
  " [unsafe_resize] is like [resize] but with no bounds checking, so incorrect usage can\n\
  \    easily cause segfaults. "]

val rewind : (_, seek) t -> unit
[@@ocaml.doc " [rewind t] sets the lower bound of the window to the lower limit. "]

val reset : (_, seek) t -> unit [@@ocaml.doc " [reset t] sets the window to the limits. "]

val flip_lo : (_, seek) t -> unit
[@@ocaml.doc
  " [flip_lo t] sets the window to range from the lower limit to the lower bound of the\n\
  \    old window.  This is typically called after a series of [Fill]s, to reposition the\n\
  \    window in preparation to [Consume] the newly written data.\n\n\
  \    The bounded version narrows the effective limit.  This can preserve some data \
   near the\n\
  \    limit, such as a hypothetical packet header (in the case of [bounded_flip_lo]) or\n\
  \    unfilled suffix of a buffer (in [bounded_flip_hi]). "]

val bounded_flip_lo : (_, seek) t -> Lo_bound.t -> unit

val compact : (read_write, seek) t -> unit
[@@ocaml.doc
  " [compact t] copies data from the window to the lower limit of the iobuf and sets the\n\
  \    window to range from the end of the copied data to the upper limit.  This is \
   typically\n\
  \    called after a series of [Consume]s to save unread data and prepare for the next\n\
  \    series of [Fill]s and [flip_lo]. "]

val bounded_compact : (read_write, seek) t -> Lo_bound.t -> Hi_bound.t -> unit

val flip_hi : (_, seek) t -> unit
[@@ocaml.doc
  " [flip_hi t] sets the window to range from the the upper bound of the current window to\n\
  \    the upper limit.  This operation is dual to [flip_lo] and is typically called \
   when the\n\
  \    data in the current (narrowed) window has been processed and the window needs to be\n\
  \    positioned over the remaining data in the buffer.  For example:\n\n\
  \    {[\n\
  \      (* ... determine initial_data_len ... *)\n\
  \      Iobuf.resize buf ~len:initial_data_len;\n\
  \      (* ... and process initial data ... *)\n\
  \      Iobuf.flip_hi buf;\n\
  \    ]}\n\n\
  \    Now the window of [buf] ranges over the remainder of the data. "]

val bounded_flip_hi : (_, seek) t -> Hi_bound.t -> unit

val protect_window_bounds_and_buffer : ('rw, no_seek) t -> f:(('rw, seek) t -> 'a) -> 'a
[@@ocaml.doc
  " [protect_window_bounds_and_buffer t ~f] calls [f t] with [t]'s bounds set to its \
   current\n\
  \    window, and restores [t]'s window, bounds, and buffer afterward. "]

val protect_window_bounds_and_buffer_local
  :  ('rw, no_seek) t
  -> f:(('rw, seek) t -> 'a)
  -> 'a
[@@ocaml.doc
  " [protect_window_bounds_and_buffer_local] is similar to\n\
  \    [protect_window_bounds_and_buffer] except that it returns a local value "]

val protect_window_bounds_and_buffer_1
  :  ('rw, no_seek) t
  -> 'a
  -> f:(('rw, seek) t -> 'a -> 'b)
  -> 'b
[@@ocaml.doc
  " [protect_window_bounds_and_buffer_1 t x ~f] is a more efficient version of\n\
  \    [protect_window_bounds_and_buffer t ~f:(fun t -> f t x)]. "]

val protect_window_bounds_and_buffer_2
  :  ('rw, no_seek) t
  -> 'a
  -> 'b
  -> f:(('rw, seek) t -> 'a -> 'b -> 'c)
  -> 'c
[@@ocaml.doc
  " [protect_window_bounds_and_buffer_2 t x y ~f] is a more efficient version of\n\
  \    [protect_window_bounds_and_buffer t ~f:(fun t -> f t x y)]. "]

val protect_window_bounds_and_buffer_3
  :  ('rw, no_seek) t
  -> 'a
  -> 'b
  -> 'c
  -> f:(('rw, seek) t -> 'a -> 'b -> 'c -> 'd)
  -> 'd
[@@ocaml.doc
  " [protect_window_bounds_and_buffer_3 t x y z ~f] is a more efficient version of\n\
  \    [protect_window_bounds_and_buffer t ~f:(fun t -> f t x y z)]. "]

[@@@ocaml.text
  " {2 Getting and setting data}\n\n\
  \    \"consume\" and \"fill\" functions access data at the lower bound of the window and\n\
  \    advance the lower bound of the window. \"peek\" and \"poke\" functions access \
   data but do\n\
  \    not advance the window. "]

val to_string : ?len:int -> ([> read ], _) t -> string
[@@ocaml.doc
  " [to_string t] returns the bytes in [t] as a string.  It does not alter the window. "]

val to_string_hum : ?max_lines:int -> (_, _) t -> string
[@@ocaml.doc
  " Equivalent to [Hexdump.to_string_hum].  Renders [t]'s windows and limits. "]

val to_bytes : ?len:int -> (_, _) t -> Bytes.t
[@@ocaml.doc
  " [to_bytes t] returns the bytes in [t] as a bytes.  It does not alter the window. "]

val of_bytes : Bytes.t -> (_, _) t
[@@ocaml.doc " [of_bytes b] returns a new iobuf whose contents is [b]. "]

module Itoa : sig
  val num_digits : int -> int
  [@@ocaml.doc
    " [num_digits x] returns the number of digits in [x].\n\
    \      ([num_digits 0] is defined as 1)."]
end

module Date_string : sig
  val len_iso8601_extended : int
  [@@ocaml.doc
    " [len_iso8601_extended] is the length (in bytes) of a date in YYYY-MM-DD format,\n\
    \      i.e. 10. "]
end

module Consume : sig
  type src = (read, seek) t
  [@@ocaml.doc
    " [To_bytes.blito ~src ~dst ~dst_pos ~src_len ()] reads [src_len] bytes from [src],\n\
    \      advancing [src]'s window accordingly, and writes them into [dst] starting at\n\
    \      [dst_pos].  By default [dst_pos = 0] and [src_len = length src].  It is an \
     error if\n\
    \      [dst_pos] and [src_len] don't specify a valid region of [dst] or if [src_len >\n\
    \      length src]. "]

  module To_bytes : Consuming_blit with type src := src with type dst := Bytes.t
  module To_bigstring : Consuming_blit with type src := src with type dst := Bigstring.t

  module To_string : sig
    val subo : ?len:int -> src -> string
    [@@ocaml.doc " [subo] defaults to using [Iobuf.length src]. "]

    val sub : src -> len:int -> string
  end

  include
    Accessors_read
    with type ('a, 'r, 's) t = (([> read ] as 'r), seek) t -> 'a
    with type ('a, 'r, 's) t_local = (([> read ] as 'r), seek) t -> 'a
    with type 'a bin_prot := 'a Bin_prot.Type_class.reader
end
[@@ocaml.doc
  " [Consume.string t ~len] reads [len] characters (all, by default) from [t] into a new\n\
  \    string and advances the lower bound of the window accordingly.\n\n\
  \    [Consume.bin_prot X.bin_read_t t] returns the initial [X.t] in [t], advancing \
   past the\n\
  \    bytes read. "]

module Fill : sig
  include
    Accessors_write
    with type ('a, 'd, 'w) t = (read_write, seek) t -> 'a -> unit
    with type ('a, 'd, 'w) t_local = (read_write, seek) t -> 'a -> unit
    with type 'a bin_prot := 'a Bin_prot.Type_class.writer

  val decimal : (int, _, _) t
  [@@ocaml.doc
    " [decimal t int] is equivalent to [Iobuf.Fill.string t (Int.to_string int)], but with\n\
    \      improved efficiency and no intermediate allocation.\n\n\
    \      In other words: It fills the decimal representation of [int] to [t].  [t] is\n\
    \      advanced by the number of characters written and no terminator is added.  If\n\
    \      sufficient space is not available, [decimal] will raise. "]

  val padded_decimal : len:int -> (int, _, _) t
  [@@ocaml.doc " Same as [decimal t int], but padding to [len] with prefix '0's. "]

  val date_string_iso8601_extended : (Date.t, _, _) t
  [@@ocaml.doc
    " [date_string_iso8601_extended t date] is equivalent to [Iobuf.Fill.string t\n\
    \      (Date.to_string date)], but with improved efficiency and no intermediate \
     allocation.\n\n\
    \      In other words: It fills the ISO 8601 extended representation (YYYY-MM-DD) of \
     [date]\n\
    \      to [t]. [t] is advanced by 10 characters and no terminator is added. If \
     sufficient\n\
    \      space is not available, [date] will raise. "]
end
[@@ocaml.doc
  " [Fill.bin_prot X.bin_write_t t x] writes [x] to [t] in bin-prot form, advancing past\n\
  \    the bytes written. "]

module Peek : sig
  include Peek with type ('rw, 'seek) iobuf := ('rw, 'seek) t [@@ocaml.doc " @open "]

  val index : ([> read ], _) iobuf -> ?pos:int -> ?len:int -> char -> int option
  [@@ocaml.doc
    " [index ?pos ?len t c] returns [Some i] for the smallest [i >= pos] such that [char t\n\
    \      i = c], or [None] if there is no such [i].\n\n\
    \      @param pos default = 0\n\
    \      @param len default = [length t - pos] "]
end
[@@ocaml.doc
  " [Peek] and [Poke] functions access a value at [pos] from the lower bound of the window\n\
  \    and do not advance.\n\n\
  \    [Peek.bin_prot X.bin_read_t t] returns the initial [X.t] in [t] without \
   advancing.\n\n\
  \    Following the [bin_prot] protocol, the representation of [x] is [X.bin_size_t x] \
   bytes\n\
  \    long.  [Peek.], [Poke.], [Consume.], and [Fill.bin_prot] do not add any size \
   prefix or\n\
  \    other framing to the [bin_prot] representation. "]

module Poke : sig
  val decimal : (read_write, 'w) t -> pos:int -> int -> int
  [@@ocaml.doc " [decimal t ~pos i] returns the number of bytes written at [pos]. "]

  val padded_decimal : (read_write, 'w) t -> pos:int -> len:int -> int -> int
  [@@ocaml.doc " Same as [decimal t int], but padding to [len] with prefix '0's. "]

  val bin_prot_size
    :  'a Bin_prot.Type_class.writer
    -> (read_write, _) t
    -> pos:int
    -> 'a
    -> int
  [@@ocaml.doc " As [bin_prot] but returns the number of bytes written. "]

  include
    Accessors_write
    with type ('a, 'd, 'w) t = (read_write, 'w) t -> pos:int -> 'a -> unit
    with type ('a, 'd, 'w) t_local = (read_write, 'w) t -> pos:int -> 'a -> unit
    with type 'a bin_prot := 'a Bin_prot.Type_class.writer

  val date_string_iso8601_extended : (Date.t, _, _) t
  [@@ocaml.doc
    " Same as [Fill.date_string_iso8601_extended t date], but does not advance [t]. "]
end
[@@ocaml.doc
  " [Poke.bin_prot X.bin_write_t t x] writes [x] to the beginning of [t] in binary form\n\
  \    without advancing.  You can use [X.bin_size_t] to tell how long it was.\n\
  \    [X.bin_write_t] is only allowed to write that portion of the buffer you have access\n\
  \    to. "]

module Unsafe : sig
  module Consume : module type of Consume
  module Fill : module type of Fill

  module Peek : sig
    include Peek with type ('rw, 'seek) iobuf := ('rw, 'seek) t [@@ocaml.doc " @open "]

    val index_or_neg : ([> read ], _) iobuf -> pos:int -> len:int -> char -> int
    [@@ocaml.doc
      " Like [Peek.index] but with no bounds checks, and returns a negative number rather\n\
      \        than [None] when the character is not found. "]
  end

  module Poke : sig
    include module type of Poke

    val bin_prot_with_known_size
      :  'a Bin_prot.Type_class.writer
      -> (read_write, _) iobuf
      -> pos:int
      -> size:int
      -> 'a
      -> unit
    [@@ocaml.doc
      " Like [bin_prot], but skips bin size and bounds checks. Useful for call sites where\n\
      \        the size is already known. "]
  end
end
[@@ocaml.doc
  " [Unsafe] has submodules that are like their corresponding module, except with no range\n\
  \    checks.  Hence, mistaken uses can cause segfaults.  Be careful! "]

val bin_prot_length_prefix_bytes : int
[@@ocaml.doc
  " The number of bytes in the length prefix of [consume_bin_prot] and [fill_bin_prot]. "]

val fill_bin_prot
  :  ([> write ], seek) t
  -> 'a Bin_prot.Type_class.writer
  -> 'a
  -> unit Or_error.t
[@@ocaml.doc
  " [fill_bin_prot] writes a bin-prot value to the lower bound of the window, prefixed by\n\
  \    its length, and advances by the amount written.  [fill_bin_prot] returns an error \
   if\n\
  \    the window is too small to write the value.\n\n\
  \    [consume_bin_prot t reader] reads a bin-prot value from the lower bound of the \
   window,\n\
  \    which should have been written using [fill_bin_prot], and advances the window by \
   the\n\
  \    amount read.  [consume_bin_prot] returns an error if there is not a complete \
   message\n\
  \    in the window and in that case the window is left unchanged.\n\n\
  \    Don't use these without a good reason, as they are incompatible with similar \
   functions\n\
  \    in [Reader] and [Writer].  They use a 4-byte length rather than an 8-byte length. "]

val fill_bin_prot_local
  :  ([> write ], seek) t
  -> 'a Bin_prot.Size.sizer_local
  -> 'a Bin_prot.Write.writer_local
  -> 'a
  -> unit Or_error.t

val consume_bin_prot
  :  ([> read ], seek) t
  -> 'a Bin_prot.Type_class.reader
  -> 'a Or_error.t

module Blit : sig
  val blit : (([> read ], _) t, ([> write ], _) t) Base.Blit.blit
  val blito : (([> read ], _) t, ([> write ], _) t) Base.Blit.blito
  val unsafe_blit : (([> read ], _) t, ([> write ], _) t) Base.Blit.blit
  val sub : (([> read ], _) t, (_, _) t) Base.Blit.sub
  val subo : (([> read ], _) t, (_, _) t) Base.Blit.subo

  val blit_maximal
    :  src:([> read ], _) t
    -> ?src_pos:int
    -> dst:([> write ], _) t
    -> ?dst_pos:int
    -> unit
    -> int
  [@@ocaml.doc
    " Copies as much as possible (returning the number of bytes copied) without running\n\
    \      out of either buffer's window. "]
end
[@@ocaml.doc " [Blit] copies between iobufs and advances neither [src] nor [dst]. "]

module Blit_consume : sig
  val blit
    :  src:([> read ], seek) t
    -> dst:([> write ], _) t
    -> dst_pos:int
    -> len:int
    -> unit

  val blito
    :  src:([> read ], seek) t
    -> ?src_len:int
    -> dst:([> write ], _) t
    -> ?dst_pos:int
    -> unit
    -> unit

  val unsafe_blit
    :  src:([> read ], seek) t
    -> dst:([> write ], _) t
    -> dst_pos:int
    -> len:int
    -> unit

  val sub : ([> read ], seek) t -> len:int -> (_, _) t
  val subo : ?len:int -> ([> read ], seek) t -> (_, _) t

  val blit_maximal
    :  src:([> read ], seek) t
    -> dst:([> write ], _) t
    -> ?dst_pos:int
    -> unit
    -> int
end
[@@ocaml.doc
  " [Blit_consume] copies between iobufs and advances [src] but does not advance [dst]. "]

module Blit_fill : sig
  val blit
    :  src:([> read ], _) t
    -> src_pos:int
    -> dst:([> write ], seek) t
    -> len:int
    -> unit

  val blito
    :  src:([> read ], _) t
    -> ?src_pos:int
    -> ?src_len:int
    -> dst:([> write ], seek) t
    -> unit
    -> unit

  val unsafe_blit
    :  src:([> read ], _) t
    -> src_pos:int
    -> dst:([> write ], seek) t
    -> len:int
    -> unit

  val blit_maximal
    :  src:([> read ], _) t
    -> ?src_pos:int
    -> dst:([> write ], seek) t
    -> unit
    -> int
end
[@@ocaml.doc
  " [Blit_fill] copies between iobufs and advances [dst] but does not advance [src]. "]

module Blit_consume_and_fill : sig
  val blit : src:([> read ], seek) t -> dst:([> write ], seek) t -> len:int -> unit

  val blito
    :  src:([> read ], seek) t
    -> ?src_len:int
    -> dst:([> write ], seek) t
    -> unit
    -> unit

  val unsafe_blit : src:([> read ], seek) t -> dst:([> write ], seek) t -> len:int -> unit
  val blit_maximal : src:([> read ], seek) t -> dst:([> write ], seek) t -> int
end
[@@ocaml.doc
  " [Blit_consume_and_fill] copies between iobufs and advances both [src] and [dst]. "]

val memset : (read_write, _) t -> pos:int -> len:int -> char -> unit
[@@ocaml.doc
  " [memset t ~pos ~len c] fills [t] with [c] within the range [\\[pos, pos + len)]. "]

val zero : (read_write, _) t -> unit [@@ocaml.doc " [memset]s a buffer to zero. "]

val concat : ([> read ], _) t array -> (_, _) t
[@@ocaml.doc
  " Create a new iobuf whose contents are the appended contents of the passed array. "]

[@@@ocaml.text " {2 Expert} "]

module Expert : sig
  val buf : (_, _) t -> Bigstring.t
  [@@ocaml.doc
    " These accessors will not allocate, and are mainly here to assist in building\n\
    \      low-cost syscall wrappers.\n\n\
    \      One must be careful to avoid writing out of the limits (between [lo_min] and\n\
    \      [hi_max]) of the [buf].  Doing so would violate the invariants of the parent\n\
    \      [Iobuf]. "]

  val hi_max : (_, _) t -> int
  val hi : (_, _) t -> int
  val lo : (_, _) t -> int
  val lo_min : (_, _) t -> int

  val set_buf : (_, _) t -> Bigstring.t -> unit
  [@@ocaml.doc
    " These setters directly set fields in [t] without checking any invariants. "]

  val set_hi_max : (_, _) t -> int -> unit
  val set_hi : (_, _) t -> int -> unit
  val set_lo : (_, _) t -> int -> unit
  val set_lo_min : (_, _) t -> int -> unit

  val to_bigstring_shared : ?pos:int -> ?len:int -> (_, _) t -> Bigstring.t
  [@@ocaml.doc
    " [to_bigstring_shared t] and [to_iobuf_shared t] allocate new wrappers around the\n\
    \      storage of [buf t], relative to [t]'s current bounds.\n\n\
    \      These operations allow access outside the bounds and limits of [t], and without\n\
    \      respect to its read/write access.  Be careful not to violate [t]'s \
     invariants. "]

  val reinitialize_of_bigstring : (_, _) t -> pos:int -> len:int -> Bigstring.t -> unit
  [@@ocaml.doc
    " [reinitialize_of_bigstring t bigstring] reinitializes [t] with backing [bigstring],\n\
    \      and the window and limits specified starting at [pos] and of length [len]. "]

  val unsafe_reinitialize
    :  (_, _) t
    -> lo_min:int
    -> lo:int
    -> hi:int
    -> hi_max:int
    -> Bigstring.t
    -> unit
  [@@ocaml.doc
    " As [reinitialize_of_bigstring] but without checking, and requires explicit\n\
    \      specification of bounds. "]

  val set_bounds_and_buffer : src:('data, _) t -> dst:('data, seek) t -> unit
  [@@ocaml.doc
    " These versions of [set_bounds_and_buffer] allow [~src] to be read-only.  [~dst] will\n\
    \      be writable through [~src] aliases even though the type does not reflect \
     this! "]

  val set_bounds_and_buffer_sub
    :  pos:int
    -> len:int
    -> src:('data, _) t
    -> dst:('data, seek) t
    -> unit

  val protect_window : ('rw, _) t -> f:(('rw, seek) t -> 'a) -> 'a
  [@@ocaml.doc
    " Similar to [protect_window_bounds_and_buffer], but does not save/restore the \
     buffer or\n\
    \      bounds. Mixing this with functions like [set_bounds_and_buffer] or [narrow] is\n\
    \      unsafe; you should not modify anyything but the window inside [f]. "]

  val protect_window_global_deprecated : ('rw, _) t -> f:(('rw, seek) t -> 'a) -> 'a
  [@@ocaml.doc
    " As [protect_window] but does not enforce that the closure should not let the buffer\n\
    \      escape. Letting the buffer escape is dangerous and almost certainly not what \
     you\n\
    \      wanted. "]

  val protect_window_1 : ('rw, _) t -> 'a -> f:(('rw, seek) t -> 'a -> 'b) -> 'b

  val protect_window_1_global_deprecated
    :  ('rw, _) t
    -> 'a
    -> f:(('rw, seek) t -> 'a -> 'b)
    -> 'b

  val protect_window_2
    :  ('rw, _) t
    -> 'a
    -> 'b
    -> f:(('rw, seek) t -> 'a -> 'b -> 'c)
    -> 'c

  val protect_window_2_global_deprecated
    :  ('rw, _) t
    -> 'a
    -> 'b
    -> f:(('rw, seek) t -> 'a -> 'b -> 'c)
    -> 'c

  val protect_window_local : ('rw, _) t -> f:(('rw, seek) t -> 'a) -> 'a
  [@@ocaml.doc " Similar to [protect_window] but returns a local value. "]

  val buf_pos_exn : (_, _) t -> pos:int -> len:int -> int
  [@@ocaml.doc
    " Computes the position within [buf] for [pos] relative to our window. Checks [len]\n\
    \      bytes are available. "]

  val unsafe_buf_pos : (_, _) t -> pos:int -> len:int -> int
  [@@ocaml.doc " As [buf_pos_exn] without checks. "]
end
[@@ocaml.doc
  " The [Expert] module is for building efficient out-of-module [Iobuf] abstractions. "]

module type Accessors_common = Accessors_common
module type Accessors_read = Accessors_read
module type Accessors_write = Accessors_write
module type Consuming_blit = Consuming_blit

type nonrec ('src, 'dst) consuming_blito = ('src, 'dst) consuming_blito

val contains : ([> read ], _) t -> substring:Bigstring.t -> bool
