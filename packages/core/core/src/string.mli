[@@@ocaml.text " This module extends {{!Base.String}[Base.String]}. "]

include module type of struct
  include Base.String
end
[@@ocaml.doc " @inline "]

type t = string [@@deriving bin_io ~localize, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local with type t := t
  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Caseless : sig
  include module type of struct
    include Caseless
  end

  type nonrec t = t [@@deriving bin_io ~localize, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S_binable with type t := t
  include Hashable.S_binable with type t := t
end
[@@ocaml.doc
  " [Caseless] compares and hashes strings ignoring case, so that for example\n\
  \    [Caseless.equal \"OCaml\" \"ocaml\"] and [Caseless.(\"apple\" < \"Banana\")] are \
   [true], and\n\
  \    [Caseless.Map], [Caseless.Table] lookup and [Caseless.Set] membership is\n\
  \    case-insensitive.\n\n\
  \    [Caseless] also provides case-insensitive [is_suffix] and [is_prefix] functions, so\n\
  \    that for example [Caseless.is_suffix \"OCaml\" ~suffix:\"AmL\"] and \
   [Caseless.is_prefix\n\
  \    \"OCaml\" ~prefix:\"oc\"] are [true]. "]

val slice : t -> int -> int -> t
[@@ocaml.doc
  " [slice t start stop] returns a new string including elements [t.(start)] through\n\
  \    [t.(stop-1)], normalized Python-style with the exception that [stop = 0] is \
   treated as\n\
  \    [stop = length t]. "]

val nget : t -> int -> char
[@@ocaml.doc " [nget s i] gets the char at normalized position [i] in [s]. "]

val take_while : t -> f:(char -> bool) -> t
[@@ocaml.doc
  " [take_while s ~f] returns the longest prefix of [s] satisfying [for_all prefix ~f]\n\
  \    (See [lstrip] to drop such a prefix) "]

val rtake_while : t -> f:(char -> bool) -> t
[@@ocaml.doc
  " [rtake_while s ~f] returns the longest suffix of [s] satisfying [for_all suffix ~f]\n\
  \    (See [rstrip] to drop such a suffix) "]

include Hexdump.S with type t := t
include Identifiable.S with type t := t and type comparator_witness := comparator_witness
include Diffable.S_atomic with type t := t
include Quickcheckable.S with type t := t

val gen_nonempty : t Quickcheck.Generator.t
[@@ocaml.doc " Like [quickcheck_generator], but without empty strings. "]

val gen' : char Quickcheck.Generator.t -> t Quickcheck.Generator.t
[@@ocaml.doc
  " Like [quickcheck_generator], but generate strings with the given distribution of\n\
  \    characters. "]

val gen_nonempty' : char Quickcheck.Generator.t -> t Quickcheck.Generator.t
[@@ocaml.doc " Like [gen'], but without empty strings. "]

val gen_with_length : int -> char Quickcheck.Generator.t -> t Quickcheck.Generator.t
[@@ocaml.doc " Like [gen'], but generate strings with the given length. "]

module type Utf = sig
  include Utf

  include
    Identifiable.S with type t := t and type comparator_witness := comparator_witness

  include Quickcheckable.S with type t := t
end

module type Utf_as_string = Utf with type t = private string
[@@ocaml.doc " Iterface for Unicode encodings, specialized for string representation. "]

module Utf8 :
  Utf with type t = Utf8.t and type comparator_witness = Utf8.comparator_witness

module Utf16le :
  Utf with type t = Utf16le.t and type comparator_witness = Utf16le.comparator_witness

module Utf16be :
  Utf with type t = Utf16be.t and type comparator_witness = Utf16be.comparator_witness

module Utf32le :
  Utf
  with type t = Base.String.Utf32le.t
   and type comparator_witness = Base.String.Utf32le.comparator_witness

module Utf32be :
  Utf
  with type t = Base.String.Utf32be.t
   and type comparator_witness = Base.String.Utf32be.comparator_witness

module Stable : sig
  module type Identifiable_without_binio := sig
    type t [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type comparator_witness

    include Base.Stringable.S with type t := t

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
      with type comparator_witness := comparator_witness

    include Hashable.Stable.V1.With_stable_witness.S with type key := t
  end

  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize, diff ~extra_derive:[ sexp ]]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Bin_prot.Binable.S_local with type t := t

      module Diff : sig
        open! Diffable.For_ppx

        type derived_on = t
        type t = Diff.t [@@deriving bin_io, sexp]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val get
          :  from:derived_on
          -> to_:derived_on
          -> (t Optional_diff.t[@jane.erasable.mode local])

        val apply_exn : derived_on -> t -> derived_on
        val of_list_exn : t list -> (t Optional_diff.t[@jane.erasable.mode local])
      end
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Identifiable_without_binio
      with type t := t
       and type comparator_witness = comparator_witness
  end

  module Utf8 : sig
    module V1 : sig
      type t = Utf8.t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Identifiable_without_binio
        with type t := t
         and type comparator_witness = Utf8.comparator_witness
    end
  end

  module Utf16le : sig
    module V1 : sig
      type t = Utf16le.t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Identifiable_without_binio
        with type t := t
         and type comparator_witness = Utf16le.comparator_witness
    end
  end

  module Utf16be : sig
    module V1 : sig
      type t = Utf16be.t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Identifiable_without_binio
        with type t := t
         and type comparator_witness = Utf16be.comparator_witness
    end
  end

  module Utf32le : sig
    module V1 : sig
      type t = Utf32le.t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Identifiable_without_binio
        with type t := t
         and type comparator_witness = Utf32le.comparator_witness
    end
  end

  module Utf32be : sig
    module V1 : sig
      type t = Utf32be.t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Identifiable_without_binio
        with type t := t
         and type comparator_witness = Utf32be.comparator_witness
    end
  end
end
[@@ocaml.doc
  " Note that [string] is already stable by itself, since as a primitive type it is an\n\
  \    integral part of the sexp / bin_io protocol. [String.Stable] exists only to \
   introduce\n\
  \    [String.Stable.Set], [String.Stable.Map], [String.Stable.Table], and provide \
   interface\n\
  \    uniformity with other stable types. "]
