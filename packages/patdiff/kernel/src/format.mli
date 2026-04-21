open! Core
open! Import

[@@@ocaml.text
  " Patdiff_format is the home of all the internal representations of the formatting\n\
  \    that will be applied to the diff. ie. prefixes, suffixes, & valid styles. "]

module Color : sig
  module RGB6 : sig
    type t = private
      { r : int
      ; g : int
      ; b : int
      }
    [@@ocaml.doc " expected (0 \226\137\164 r, g, b < 6) "]
    [@@deriving compare, quickcheck, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create_exn : r:int -> g:int -> b:int -> t
  end

  module Gray24 : sig
    type t = private { level : int }
    [@@ocaml.doc " expected (0 \226\137\164 level < 24) "] [@@deriving compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create_exn : level:int -> t
  end

  type t =
    | Black
    | Red
    | Green
    | Yellow
    | Blue
    | Magenta
    | Cyan
    | White
    | Default
    | Gray
    | Bright_black
    | Bright_red
    | Bright_green
    | Bright_yellow
    | Bright_blue
    | Bright_magenta
    | Bright_cyan
    | Bright_white
    | RGB6 of RGB6.t
    | Gray24 of Gray24.t
  [@@deriving compare, quickcheck, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t

  val rgb6_exn : int * int * int -> t
  [@@ocaml.doc
    " [rgb6_exn r g b] and [gray24_exn level] raise if the values are out of bound. "]

  val gray24_exn : int -> t
end

module Style : sig
  type t =
    | Bold
    | Underline
    | Emph
    | Blink
    | Dim
    | Inverse
    | Hide
    | Reset
    | Foreground of Color.t
    | Fg of Color.t
    | Background of Color.t
    | Bg of Color.t
  [@@deriving compare, quickcheck, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t
end

module Rule : sig
  module Affix : sig
    type t = private
      { text : string
      ; styles : Style.t list
      }

    val create : ?styles:Style.t list -> string -> t
    val blank : t
  end
  [@@ocaml.doc " An affix is either a prefix or a suffix. "]

  type t = private
    { pre : Affix.t
    ; suf : Affix.t
    ; styles : Style.t list
    }
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : ?pre:Affix.t -> ?suf:Affix.t -> Style.t list -> t
  [@@ocaml.doc
    " Rule creation: Most rules have a style, and maybe a prefix. For\n\
    \      instance, a line_next rule might have a bold \"+\" prefix and a green\n\
    \      style. "]

  val blank : t
  val unstyled_prefix : string -> t
  val strip_styles : t -> t
end
[@@ocaml.doc
  " A rule consists of a styled prefix, a styled suffix, and a style. Rules\n\
  \    are applied to strings using functions defined in Output_ops. "]

module Rules : sig
  type t =
    { line_same : Rule.t
    ; line_prev : Rule.t
    ; line_next : Rule.t
    ; line_unified : Rule.t
    ; word_same_prev : Rule.t
    ; word_same_next : Rule.t
    ; word_same_unified : Rule.t
    ; word_same_unified_in_move : Rule.t
    ; word_prev : Rule.t
    ; word_next : Rule.t
    ; hunk : Rule.t
    ; header_prev : Rule.t
    ; header_next : Rule.t
    ; moved_from_prev : Rule.t
    ; moved_to_next : Rule.t
    ; removed_in_move : Rule.t
    ; added_in_move : Rule.t
    ; line_unified_in_move : Rule.t
    }
  [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val default : t
  val strip_styles : t -> t
end
[@@ocaml.doc
  " Rules are configured in the configuration file.\n\
  \    Default values are provided in Configuration. "]

module Location_style : sig
  type t =
    | Diff
    | Omake
    | None
    | Separator
  [@@deriving bin_io, compare, quickcheck, enumerate, equal, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Ppx_enumerate_lib.Enumerable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Stringable.S with type t := t

  val omake_style_error_message_start : file:string -> line:int -> string

  val sprint
    :  t
    -> string Patience_diff.Hunk.t
    -> prev_filename:string
    -> rule:(string -> string)
    -> string
end
