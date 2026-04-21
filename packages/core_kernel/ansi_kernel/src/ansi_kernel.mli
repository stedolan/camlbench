[@@@ocaml.text
  " Common ANSI display attribute definitions.\n\n\
  \    NOTE: assorted content lifted from lib/console/src/console.ml "]

module Color_256 = Color_256

module Color : sig
  type primary =
    [ `Black
    | `Red
    | `Green
    | `Yellow
    | `Blue
    | `Magenta
    | `Cyan
    | `White
    ]

  type t =
    [ primary
    | `Color_256 of Color_256.t
    | `Default_color
    ]
  [@@ocaml.doc
    " Standard 8 colors and 256-color palette. The [`Default_color]s depend on the\n\
    \      terminal but are likely to be the same as [`White] and [`Black] (and which \
     one is\n\
    \      foreground vs background will depend on whether the terminal is \
     white-on-black or\n\
    \      black-on-white) "]
  [@@deriving sexp_of, compare, hash, equal]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val compare : t -> (t[@merlin.hide]) -> int

    include Ppx_hash_lib.Hashable.S with type t := t

    val equal : t -> (t[@merlin.hide]) -> bool
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_int_list : [< t ] -> int list
end

module Attr : sig
  type t =
    [ `Bright
    | `Dim
    | `Underscore
    | `Reverse
    | Color.t
    | `Bg of Color.t
    ]
  [@@ocaml.doc
    " Styling attributes: these provide most of the ANSI display attributes,\n\
    \      but not directly `Reset, `Blink and `Hidden, so as to explicitly\n\
    \      discourage their use in general code. "]
  [@@deriving sexp_of, compare, hash, equal]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val compare : t -> (t[@merlin.hide]) -> int

    include Ppx_hash_lib.Hashable.S with type t := t

    val equal : t -> (t[@merlin.hide]) -> bool
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_int_list : [< t ] -> int list
  val list_to_string : [< t ] list -> string
end

module With_all_attrs : sig
  type t =
    [ Attr.t
    | `Reset
    | `Blink
    | `Hidden
    ]
  [@@ocaml.doc " All supported (by this library) ANSI display attributes. "]
  [@@deriving sexp_of, compare, hash, equal]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val compare : t -> (t[@merlin.hide]) -> int

    include Ppx_hash_lib.Hashable.S with type t := t

    val equal : t -> (t[@merlin.hide]) -> bool
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_int_list : [< t ] -> int list
  val list_to_string : [< t ] list -> string
end

module Stable : sig
  module Color : sig
    module V1 : sig
      type primary
      type t [@@deriving sexp, compare, hash, equal]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 : sig
      type primary = Color.primary
      type t = Color.t [@@deriving sexp, compare, hash, equal]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val of_v1 : V1.t -> t
      val to_v1 : t -> foreground:bool -> V1.t
      val primary_of_v1 : V1.primary -> primary
      val primary_to_v1 : primary -> V1.primary
    end
  end

  module Attr : sig
    module V1 : sig
      type t [@@deriving sexp, compare, hash, equal]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 : sig
      type t = Attr.t [@@deriving sexp, compare, hash, equal]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val of_v1 : V1.t -> t
      val to_v1 : t -> V1.t
    end
  end
end
