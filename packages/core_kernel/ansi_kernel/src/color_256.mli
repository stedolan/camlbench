[@@@ocaml.text
  " Support for 256-color handling on terminals/consoles.  Note that the\n\
  \    functions [of_rgb6_exn] and [of_rgb6] return values within the 6x6x6\n\
  \    color-cube space, even though equivalent duplicates exist in the first 16\n\
  \    and last 24 colors (a \"best-fit-equivalent\" function could be added some\n\
  \    day, if there ever becomes a requirement for it -- see note 2 below).\n\n\
  \    NOTE 1: the color-cube is not linear in terms of RGB levels, but is\n\
  \    \"shifted\" towards brighter values (as opposed to a logarithmic or other\n\
  \    mapping). Visually, the \"rgb6\" values 0 to 5 (used in [of_rgb6_exn] and\n\
  \    encoded in the 256-color palette values) map into RGB levels as follows:\n\n\
  \    {v\n\
  \    Cube-val:  0           1    2    3    4    5\n\
  \       v       +-----------+----+----+----+----+\n\
  \      RGB:     0           95   135  175  215  255\n\
  \    v}\n\n\
  \    The floating-point values used in [of_rgb] are {e not} weighted in the same\n\
  \    way, but are rounded to the nearest cube-value -- a value of 0.5 (50% or\n\
  \    127.5/255) would result in a color-cube value of 2, for example.  Any level\n\
  \    less than 0.187 (approx.) maps to 0 (black) and greater than 0.921 to 5\n\
  \    (white).\n\n\
  \    NOTE 2: is is {e not} recommended to use the 256-color palette for\n\
  \    representing the 16 (8 * 2) 'primary' colors.  The standard [`Black],\n\
  \    [`Blue], etc. attributes are recommended for these.\n"]

type t [@@deriving sexp_of, compare, hash, equal]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val to_int : t -> int
val of_int_exn : int -> t

val of_rgb6_exn : int * int * int -> t
[@@ocaml.doc
  " Takes an RGB triple with values in the range [0,5] (inclusive) and returns\n\
  \    the appropriate 256-color palette value.  Will throw an exception if any of\n\
  \    the inputs are out-of-range.  Note that the input values are weighted as\n\
  \    described above. "]

val of_rgb : float * float * float -> t
[@@ocaml.doc
  " Takes an RGB triple with float values in the closed (inclusive) interval\n\
  \    [0,1] and returns the nearest (rounded) 256-color palette value.\n\
  \    Out-of-bound values are clamped to the range.  The inputs are {e not}\n\
  \    weighted, unlike [of_rgb6_exn] as described above. "]

val of_rgb_8bit : int * int * int -> t
[@@ocaml.doc
  " Takes an RGB triple with integer values in the closed (inclusive) range\n\
  \    [0,255] and returns the nearest (rounded) 256-color palette color-cube\n\
  \    value.  Out-of-bound values are clamped to the range.  The inputs are\n\
  \    {e not} weighted, unlike [of_rgb6_exn] as described above. "]

val of_rgb_int1k : int * int * int -> t
[@@ocaml.doc
  " Takes an RGB triple with integer values in the closed (inclusive) range\n\
  \    [0,1000] and returns the nearest (rounded) 256-color palette color-cube\n\
  \    value.  Out-of-bound values are clamped to the range.  The inputs are {e not}\n\
  \    weighted, unlike [of_rgb6_exn] as described above. "]

val of_gray24_exn : int -> t
[@@ocaml.doc
  " Takes a grayscale level from [0-23] (inclusive, not-black-to-not-white)\n\
  \    and returns the appropriate 256-color palette value.  Will throw an\n\
  \    exception if the input value is out-of-range. "]

val to_rgb : t -> [> `Primary of int | `RGB of float * float * float ]
[@@ocaml.doc
  " Takes a color palette value and returns, for color-cube and grayscale\n\
  \    palette values, an approximated [`RGB] triple with each component in the\n\
  \    range [0,1];  for the first 16 values, [`Primary] followed by the specific\n\
  \    palette index is returned, as these are not consistently defined. "]

val to_rgb_hex24 : t -> string
[@@ocaml.doc
  " Takes a color palette value and returns a hex-encoded RGB 24-bit triplet,\n\
  \    with a leading '#'.  I.e. \"#000000\" through \"#ffffff\".  The values\n\
  \    returned for the first 16 (primary) colors follow the Windows Console\n\
  \    scheme, as documented here: https://en.wikipedia.org/wiki/ANSI_escape_code .\n"]

val to_luma : t -> float
[@@ocaml.doc
  " Takes a color palette value and returns an approximate luminance value\n\
  \    in the closed interval [0,1]. "]

val to_rgb_8bit : t -> int * int * int
[@@ocaml.doc
  " Takes a color palette value and returns a triple of RGB integers in\n\
  \    the closed interval [0,255]. "]

val to_rgb_int1k : t -> int * int * int
[@@ocaml.doc
  " Takes a color palette value and returns a triple of RGB integers in\n\
  \    the closed interval [0,1000]. "]

val to_rgb6 : t -> int * int * int
[@@ocaml.doc
  " Takes a color palette value and returns a triple of RGB integers in\n\
  \    the closed interval [0,5].  For color-cube palette values, this simply\n\
  \    un-does [of_rgb6_exn].  For others, it will return the closest matching\n\
  \    value in the color-cube. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving sexp, compare, hash, equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
