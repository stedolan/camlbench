[@@@ocaml.text
  " Conversions between units of measure that are based on bytes (like kilobytes,\n\
  \    megabytes, gigabytes, and words).\n\n\
  \    [t]'s are created with [of_bytes_float_exn], [of_words_float_exn], [of_kilobytes],\n\
  \    [of_megabytes], etc.\n\n\
  \    Note: in this module, kilobytes, Megabytes, etc. are defined as powers of 1024:\n\n\
  \    - 1 kilobyte: 2^10 = 1024   bytes\n\
  \    - 1 Megabyte: 2^20 = 1024^2 bytes\n\
  \    - 1 Gigabyte: 2^30 = 1024^3 bytes\n\
  \    - 1 Terabyte: 2^40 = 1024^4 bytes\n\
  \    - 1 Petabyte: 2^50 = 1024^5 bytes\n\
  \    - 1 Exabyte:  2^60 = 1024^6 bytes\n"]

open! Import

type t [@@deriving sexp_of, typerep] [@@immediate64]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t

  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : [ `Bytes | `Kilobytes | `Megabytes | `Gigabytes | `Words ] -> float -> t
[@@deprecated
  "[since 2019-01] Use [of_bytes], [of_kilobytes], [of_megabytes], etc as appropriate."]

include Comparable.S_plain with type t := t
include Hashable.S_plain with type t := t
include Stringable.S with type t := t

val of_bytes : float -> t
[@@ocaml.doc " This is a deprecated alias for [of_bytes_float_exn]. "]
[@@deprecated
  "[since 2019-01] Use [of_bytes_int], [of_bytes_int63], [of_bytes_int64_exn] or \
   [of_bytes_float_exn] as appropriate."]

val of_bytes_int : int -> t
val of_bytes_int63 : Int63.t -> t

val of_bytes_int64_exn : Int64.t -> t
[@@ocaml.doc
  " This will raise if and only if the argument can not be represented as a \
   [Byte_units.t].\n\
  \    Specifically this is if the argument is outside of \\[-2^62,2^62). "]

val of_bytes_float_exn : float -> t
[@@ocaml.doc
  " This will raise if and only if the argument can not be represented as a \
   [Byte_units.t].\n\
  \    Specifically this is if the argument is outside of \\[-2^62,2^62), "]

val of_kilobytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of kilobytes.\n\
  \    N.B. This will raise if the value is outside of \\[-2^52,2^52). "]

val of_megabytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of Megabytes.\n\
  \    N.B. This will raise if the value is outside of \\[-2^42,2^42). "]

val of_gigabytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of Gigabytes.\n\
  \    N.B. This will raise if the value is outside of \\[-2^32,2^32). "]

val of_terabytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of Terabytes.\n\
  \    N.B. This will raise if the value is outside of \\[-2^22,2^22). "]

val of_petabytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of Petabytes.\n\
  \    N.B. This will raise if the value is outside of \\[-2^12,2^12). "]

val of_exabytes : float -> t
[@@ocaml.doc
  " create of [Byte_units] based on the number of Exabytes.\n\
  \    N.B. This will raise if the value is outside of \\[-4,4). "]

val of_words : float -> t
[@@ocaml.doc
  " Do not use, consider using [of_words_int] instead. Alias for [of_words_float_exn]. "]
[@@deprecated "[since 2019-01] Use [of_words_int] or [of_words_float_exn] instead."]

val of_words_int : int -> t
[@@ocaml.doc " create of [Byte_units] based on the number of machine words. "]

val of_words_float_exn : float -> t
[@@ocaml.doc
  " Create of [Byte_units] based on the number of machine words.\n\
  \    On 64-bit platforms this will raise if the value is outside of \\[-2^59,2^59).\n\
  \    On 32-bit platforms (including JS) this will raise if the value is outside of  \
   \\[-2^60,2^60). "]

val to_string_hum : t -> string
[@@ocaml.doc
  " [to_string_hum t] returns a string representation of [t]. This will use the largest\n\
  \    unit that will not make the translated value be below 1.\n\n\
  \    For example [Byte_units.to_string_hum (Byte_units.of_bytes_int 1000)] gives \
   [1000B],\n\
  \    but [Byte_units.to_string_hum (Byte_units.of_bytes_int 1500)] gives [1.46484K]. "]

val to_string_short : t -> string
[@@deprecated "[since 2020-06] Use [Short.to_string] instead."]

module Short : sig
  type nonrec t = t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string : t -> string
  [@@ocaml.doc
    " [Short.to_string] is like [to_string_hum] but will attempt to only show 4 \
     significant\n\
    \      digits.\n\n\
    \      For example [Byte_units.to_string_hum (Byte_units.of_bytes_int 1000)] gives \
     [1000B],\n\
    \      but [Byte_units.to_string_hum (Byte_units.of_bytes_int 1500)] gives [1.46K].\n\n\
    \      [Short.sexp_of_t] does the same.\n\
    \  "]
end

val bytes : t -> float
[@@ocaml.doc " This is a deprecated alias for [bytes_float]. "]
[@@deprecated
  "[since 2019-01] Use [bytes_int_exn], [bytes_int63], [bytes_int64] or [bytes_float] as \
   appropriate."]

val bytes_int_exn : t -> int
[@@ocaml.doc
  " This will raise if and only if the value of this [Byte_units.t] can not be represented\n\
  \    as an int.\n\
  \    This can only happen on platforms where [int] is less than 63 bits, specifically JS\n\
  \    and 32-bit OCaml where this will raise if the number of bytes is outside\n\
  \    of \\[-2^30,2^30). "]

val bytes_int63 : t -> Int63.t
val bytes_int64 : t -> Int64.t
val bytes_float : t -> float
val kilobytes : t -> float
val megabytes : t -> float
val gigabytes : t -> float
val terabytes : t -> float
val petabytes : t -> float
val exabytes : t -> float

val words : t -> float
[@@ocaml.doc
  " Do not use, consider using [words_int_exn] instead. Alias for [words_float] "]
[@@deprecated "[since 2019-01] Use [words_int_exn] or [words_float] instead."]

val words_int_exn : t -> int
[@@ocaml.doc
  " In JS and on 32-bit OCaml this will raise if and only if the number of bytes is \
   outside\n\
  \    of \\[-2^32,2^32). "]

val words_float : t -> float
val zero : t
val min_value : t
val max_value : t
val sign : t -> Sign.t
val abs : t -> t
val neg : t -> t

val scale : t -> float -> t [@@ocaml.doc " [scale t mul] scale the measure [t] by [mul] "]

val arg_type : t Command.Arg_type.t

module Infix : sig
  val ( - ) : t -> t -> t
  val ( + ) : t -> t -> t

  val ( / ) : t -> float -> t [@@ocaml.doc " [( / ) t mul] scales [t] by [1/mul] "]

  val ( // ) : t -> t -> float
  [@@ocaml.doc " [( // ) t1 t2] returns the ratio of t1 to t2 "]
end

include module type of Infix
include Quickcheck.S_range with type t := t

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S0_without_comparator with type t := t
  end

  module V2 : sig
    type nonrec t = t [@@deriving equal, hash, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S0_without_comparator with type t := t
  end
end
