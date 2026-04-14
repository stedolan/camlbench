[@@@ocaml.text
  " Utility functions for parsing and outputing strings containing known numbers\n\
  \    of digits.  Used primarily for building functions for reading in and writing\n\
  \    out Time related values. "]

open! Import

val write_int63 : bytes -> pos:int -> digits:int -> Int63.t -> unit
[@@ocaml.doc
  " {2 Write digit functions}\n\n\
  \    [write_int63 bytes ~pos ~digits int63] writes the string representation of [int63],\n\
  \    0-padded to fill [digits] characters, into [bytes] starting at position [pos]. \
   Raises\n\
  \    if [int] is negative or is too long for [bytes], if [pos] is an invalid index in\n\
  \    [bytes] for the number of digits, or if [digits < 1]. "]

val write_1_digit_int : bytes -> pos:int -> int -> unit
[@@ocaml.doc
  " [write_*_digit_int] is like [write_int63] for a hard-coded number of digits and for\n\
  \    [int] rather than [Int63.t]. "]

val write_2_digit_int : bytes -> pos:int -> int -> unit
val write_3_digit_int : bytes -> pos:int -> int -> unit
val write_4_digit_int : bytes -> pos:int -> int -> unit
val write_5_digit_int : bytes -> pos:int -> int -> unit
val write_6_digit_int : bytes -> pos:int -> int -> unit
val write_7_digit_int : bytes -> pos:int -> int -> unit
val write_8_digit_int : bytes -> pos:int -> int -> unit
val write_9_digit_int : bytes -> pos:int -> int -> unit

val read_int63 : string -> pos:int -> digits:int -> Int63.t
[@@ocaml.doc
  " {2 Read digit functions}\n\n\
  \    [read_int63 string ~pos ~digits] parses [digits] characters starting at [pos] in\n\
  \    [string] and returns the corresponding [Int63.t]. It raises if [digits < 1] or\n\
  \    [pos < 0] or [pos + digits > String.length string]. "]

val read_1_digit_int : string -> pos:int -> int
[@@ocaml.doc
  " [read_*_digit_int] is like [read_int63] for a hard-coded number of digits and for\n\
  \    [int] rather than [Int63.t]. "]

val read_2_digit_int : string -> pos:int -> int
val read_3_digit_int : string -> pos:int -> int
val read_4_digit_int : string -> pos:int -> int
val read_5_digit_int : string -> pos:int -> int
val read_6_digit_int : string -> pos:int -> int
val read_7_digit_int : string -> pos:int -> int
val read_8_digit_int : string -> pos:int -> int
val read_9_digit_int : string -> pos:int -> int

module Round : sig
  type t =
    | Toward_positive_infinity
    | Toward_negative_infinity
  [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

val read_int63_decimal
  :  string
  -> pos:int
  -> decimals:int
  -> scale:Int63.t
  -> round_ties:Round.t
  -> allow_underscore:bool
  -> Int63.t
[@@ocaml.doc
  " [read_int63_decimal string ~pos ~decimals ~scale ~round_ties ~allow_underscore] reads\n\
  \    [decimals] characters from [string] starting at [pos] as a decimal value as if\n\
  \    starting immediately after a decimal point, and returns that fraction times \
   [scale].\n\
  \    The result is rounded to the nearest value, with ties broken by [round_ties].\n\n\
  \    This function is useful for reading the decimal parts of numbers annotated with \
   units\n\
  \    that scale the result, such as when reading time units like \"1.0ms\" or \
   \"12.125s\".\n\n\
  \    If [allow_underscore = true], then '_' characters in [string] are allowed and \
   ignored.\n\
  \    Otherwise only digit characters are allowed.\n\n\
  \    Raises if [pos] is out of range for [string] and [decimals], or if [scale < 1] or\n\
  \    [scale > max_value / 20]. "]

val max_int63_with : digits:int -> Int63.t
[@@ocaml.doc
  " [max_int63_with ~digits] returns the maximum [Int63.t] that fits in [digits] decimal\n\
  \    digits. "]

module Unsafe : sig
  val divide_and_round_up : numerator:Int63.t -> denominator:Int63.t -> Int63.t
  [@@ocaml.doc
    " [divide_and_round_up ~numerator ~denominator] returns [ceil\n\
    \      (numerator/denominator)]. "]
end
