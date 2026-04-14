[@@@ocaml.text
  " A scale factor, not bounded between 0% and 100%, represented as a float. "]

open! Import
open Std_internal

type t = private float
[@@ocaml.doc
  " Exposing that this is a float allows for more optimization. E.g. compiler can\n\
  \    optimize some local refs and not box them.\n"]
[@@deriving globalize, hash, typerep]

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t

  include Ppx_hash_lib.Hashable.S with type t := t
  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Stringable with type t := t
[@@ocaml.doc
  " [of_string] and [t_of_sexp] disallow [nan], [inf], etc.  Furthermore, they round to 6\n\
  \    significant digits.  They are equivalent to [Stable.V2] sexp conversion. "]

val to_string_round_trippable : t -> string
[@@ocaml.doc " Equivalent to [Stable.V3.to_string] "]

include
  Sexpable with type t := t
[@@ocaml.doc
  " Sexps are of the form 5bp or 0.05% or 0.0005x.\n\n\
  \    Warning: [equal (t) (t_of_sexp (sexp_of_t t))] is not guaranteed.\n\n\
  \    First, sexp_of_t truncates to 6 significant digits.  Second, multiple\n\
  \    serialization round-trips may cause further multiple small drifts.\n\n\
  \    The sexp conversion here is V2 and not V3 to avoid breaking existing code at the \
   time\n\
  \    V3 was introduced (Nov 2022).\n\n\
  \    New code should explicitly use Percent.Stable.V3 for faithful round-trippable sexp\n\
  \    conversion.\n"]

include Sexplib.Sexp_grammar.S with type t := t
include Binable with type t := t
include Comparable_binable with type t := t
include Comparable.With_zero with type t := t
include Diffable.S_atomic with type t := t
include Robustly_comparable.S with type t := t
include Quickcheckable.S with type t := t

module Option : sig
  type value := t
  type t = private float [@@deriving bin_io, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Immediate_option.S_without_immediate with type value := value and type t := t

  val apply_with_none_as_nan : t -> float -> float
  [@@ocaml.doc
    " [apply_with_none_as_nan (some x) y = apply x y], and\n\
    \      [apply_with_none_as_nan none y = apply (of_mult Float.nan) y] "]

  val of_mult_with_nan_as_none : float -> t
  [@@ocaml.doc
    " [of_mult_with_nan_as_none Float.nan = none], and\n\
    \      [of_mult_with_nan_as_none x = some (of_mult x)] otherwise "]

  val to_mult_with_none_as_nan : t -> float
  [@@ocaml.doc
    " [to_mult_with_none_as_nan none = Float.nan], and\n\
    \      [to_mult_with_none_as_nan (some x) = to_mult x] "]
end
[@@ocaml.doc " The value [nan] cannot be represented as an [Option.t] "]

val ( * ) : t -> t -> t
val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( / ) : t -> t -> t
val ( // ) : t -> t -> float
val zero : t
val one_hundred_percent : t
val neg : t -> t
val abs : t -> t
val is_zero : t -> bool
val is_nan : t -> bool
val is_inf : t -> bool

val apply : t -> float -> float
[@@ocaml.doc " [apply t x] multiplies the percent [t] by [x], returning a float. "]

val scale : t -> float -> t
[@@ocaml.doc " [scale t x] scales the percent [t] by [x], returning a new [t]. "]

val of_mult : float -> t [@@ocaml.doc " [of_mult 5.] is 5x = 500% = 50_000bp "]

val to_mult : t -> float

val of_percentage : float -> t
[@@ocaml.doc
  " [of_percentage 5.] is 5% = 0.05x = 500bp.  Note: this function performs float division\n\
  \    by 100.0 and it may introduce rounding errors, for example:\n\
  \    {[ of_percentage 70.18 |> to_mult = 0.70180000000000009 ]}\n\
  \    It is also not consistent with [of_string] or [t_of_sexp] for \"%\"-ending \
   strings.  The\n\
  \    results can be off by an ulp.  If this matters to you, use\n\
  \    [of_percentage_slow_more_accurate] instead. "]

val of_percentage_slow_more_accurate : float -> t
[@@ocaml.doc
  " Like [of_percentage], but consistent with [of_string] and [t_of_sexp], that is,\n\
  \    [of_percentage_slow_more_accurate x = of_string (Float.to_string x ^ \"%\")] "]

val to_percentage : t -> float
[@@ocaml.doc
  " [to_percentage (Percent.of_string \"5%\")] is 5.0.  Note: this function performs float\n\
  \    multiplication by 100.0 and it may introduce rounding errors, for example:\n\
  \    {[ to_percentage (Percent.of_mult 0.56) = 56.000000000000007 ]}\n\
  \    It is also not consistent with [Stable.V3.sexp_of_t] or \
   [to_string_round_trippable].\n\
  \    If this matters to you, use [to_percentage_slow_more_accurate] instead. "]

val to_percentage_slow_more_accurate : t -> float
[@@ocaml.doc
  " Like [to_percentage], but consistent with [Stable.V3.sexp_of_t] and\n\
  \    [to_string_round_trippable]. "]

val of_bp : float -> t
[@@ocaml.doc
  " [of_bp 5.] is 5bp = 0.05% = 0.0005x.  Note: this function performs float division by\n\
  \    10,000.0 and it may introduce rounding errors, for example:\n\
  \    {[ of_bp 70.18 |> to_mult = 0.0070180000000000008 ]}\n\
  \    It is also not consistent with [of_string] or [t_of_sexp] for \"bp\"-ending \
   strings.\n\
  \    The results can be off by an ulp.  If this matters to you, use\n\
  \    [of_bp_slow_more_accurate] instead. "]

val of_bp_slow_more_accurate : float -> t
[@@ocaml.doc
  " Like [of_bp], but consistent with [of_string] and [t_of_sexp], that is,\n\
  \    [of_bp_slow_more_accurate x = of_string (Float.to_string x ^ \"bp\")] "]

val to_bp : t -> float
[@@ocaml.doc
  " [to_bp (Percent.of_bp \"4bp\")] is 4.0.  Note: this function performs float\n\
  \    multiplication by 10000.0 and and it may introduce rounding errors, for example:\n\
  \    {[ to_bp (Percent.of_mult 0.56) = 5600.0000000000009 ]}\n\
  \    It is also not consistent with [Stable.V3.sexp_of_t] or \
   [to_string_round_trippable].\n\
  \    If this matters to you, use [to_bp_slow_more_accurate] instead. "]

val to_bp_slow_more_accurate : t -> float
[@@ocaml.doc
  " Like [to_bp], but consistent with [Stable.V3.sexp_of_t] and\n\
  \    [to_string_round_trippable]. "]

val of_bp_int : int -> t

val to_bp_int : t -> int [@@ocaml.doc " rounds down "]

val round_significant : t -> significant_digits:int -> t
[@@ocaml.doc " 0.0123456% ~significant_digits:4 is 1.235bp "]

val round_decimal_mult : t -> decimal_digits:int -> t
[@@ocaml.doc " 0.0123456% ~decimal_digits:4 is 0.0001 = 1bp "]

val round_decimal_percentage : t -> decimal_digits:int -> t
[@@ocaml.doc " 0.0123456% ~decimal_digits:4 is 0.0123% = 1.23bp "]

val round_decimal_bp : t -> decimal_digits:int -> t
[@@ocaml.doc " 0.0123456% ~decimal_digits:4 is 1.2346bp "]

val t_of_sexp_allow_nan_and_inf : Sexp.t -> t
val of_string_allow_nan_and_inf : string -> t

module Format : sig
  type t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val exponent : precision:int -> t [@@ocaml.doc " [sprintf \"%.*e\" precision] "]

  val exponent_E : precision:int -> t [@@ocaml.doc " [sprintf \"%.*E\" precision] "]

  val decimal : precision:int -> t [@@ocaml.doc " [sprintf \"%.*f\" precision] "]

  val ocaml : t [@@ocaml.doc " [sprintf \"%F\"] "]

  val compact : precision:int -> t [@@ocaml.doc " [sprintf \"%.*g\" precision] "]

  val compact_E : precision:int -> t [@@ocaml.doc " [sprintf \"%.*G\" precision] "]

  val hex : precision:int -> t [@@ocaml.doc " [sprintf \"%.*h\" precision] "]

  val hex_E : precision:int -> t [@@ocaml.doc " [sprintf \"%.*H\" precision] "]
end
[@@ocaml.doc
  " A [Format.t] tells [Percent.format] how to render a floating-point value as a string,\n\
  \    like a [printf] conversion specification.\n\n\
  \    For example:\n\n\
  \    {[\n\
  \      format (Format.exponent ~precision) = sprintf \"%.e\" precision\n\
  \    ]}\n\n\
  \    The [_E] naming suffix in [Format] values is mnenomic of a capital [E] (rather than\n\
  \    [e]) being used in floating-point exponent notation.\n\n\
  \    Here is the documentation of the floating-point conversion specifications from the\n\
  \    OCaml manual:\n\n\
  \    - f: convert a floating-point argument to decimal notation, in the style \
   dddd.ddd.\n\n\
  \    - F: convert a floating-point argument to OCaml syntax (dddd. or dddd.ddd or d.ddd\n\
  \      e+-dd).\n\n\
  \    - e or E: convert a floating-point argument to decimal notation, in the style d.ddd\n\
  \      e+-dd (mantissa and exponent).\n\n\
  \    - g or G: convert a floating-point argument to decimal notation, in style f or e, E\n\
  \      (whichever is more compact).\n\n\
  \    - h or H: convert a floating-point argument to hexadecimal notation, in the style\n\
  \      0xh.hhhh e+-dd (hexadecimal mantissa, exponent in decimal and denotes a power of\n\
  \      2).\n"]

val format : t -> Format.t -> string
val validate : t -> Validate.t
val sign : t -> Sign.t [@@deprecated "[since 2016-01] Replace [sign] with [sign_exn]"]

val sign_exn : t -> Sign.t
[@@ocaml.doc
  " The sign of a [Percent.t].  Both [-0.] and [0.] map to [Zero].  Raises on nan.  All\n\
  \    other values map to [Neg] or [Pos]. "]

module Stable : sig
  module V1 : sig
    module Bin_shape_same_as_float : sig
      type nonrec t = t
      [@@deriving
        sexp
      , sexp_grammar
      , bin_io
      , compare
      , globalize
      , hash
      , equal
      , typerep
      , stable_witness
      , diff]

      include sig
        [@@@ocaml.warning "-32-60"]

        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t

        val globalize : t -> t

        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Typerep_lib.Typerepable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

        module Diff : sig
          open! Diffable.For_ppx

          type derived_on = t
          type t = Diff.t [@@deriving sexp, bin_io]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S with type t := t
            include Bin_prot.Binable.S with type t := t
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
    end
    [@@ocaml.doc
      " Tl;dr: For new code use [Stable.V3] if you care about exact round-trippability via\n\
      \        sexp, or [Almost_round_trippable] if you want to round your output to 14\n\
      \        significant digits to hide common floating-point rounding errors and make \
       it less\n\
      \        of an eyesore but also less accurate.\n\n\
      \        The difference between [V3] and [V2] is that V3 sexp (de)serialization is \
       fully\n\
      \        round-trippable.  There is no difference in [bin_io] between [V2] and \
       [V3], and\n\
      \        they have identical bin_shape.\n\n\
      \        [V1] and [V2] sexp serialization rounds to 6 significant digits, and \
       serialization\n\
      \        / deserialization go through an extra float multiplication / divison in \
       the [%] or\n\
      \        [bp] case.  This may cause further loss of precision, which is the reason \
       why\n\
      \        [V1]'s or [V2]'s [t_of_sexp] may be slightly off even when reading \
       [V3]-generated\n\
      \        sexps.\n\n\
      \        If one wants to stick to the 6 significant digits in the sexp output, it \
       is still\n\
      \        recommended to use [V2] over [V1]:\n\n\
      \        [V1.Bin_shape_same_as_float.t]'s sexp and bin-io representations are the \
       same as\n\
      \        [V2.t]'s. There are only two differences:\n\n\
      \        - [V2] has a distinct [bin_shape_t] from [Float.bin_shape_t], to suggest \
       that\n\
      \          changing a protocol type from a percent to a float (or vice-versa) is a \
       breaking\n\
      \          change, semantically.\n\
      \        - [V2.{Map,Set}.t_of_sexp] no longer accept keys/elements formatted as \
       floats\n\
      \          rather than as {Percent}s.\n\n\
      \        Usually existing code can upgrade in-place from \
       [V1.Bin_shape_same_as_float] to\n\
      \        [V2], as long as no client code uses [bin_shape_t] dynamically.\n\
      \    "]
  end

  module V2 : sig
    type nonrec t = t
    [@@ocaml.doc
      " This format is not round-trippable as sexp.  Only accurate up to 6 significant\n\
      \        digits when going via sexp.  This is the format used by \
       [Percent.sexp_of_t] and\n\
      \        [Percent.to_string] (think user interfaces).  Read the comment above at \
       [V1] for\n\
      \        details. "]
    [@@deriving
      sexp
    , sexp_grammar
    , bin_io
    , compare
    , globalize
    , hash
    , equal
    , typerep
    , stable_witness
    , diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t

      val globalize : t -> t

      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

      module Diff : sig
        open! Diffable.For_ppx

        type derived_on = t
        type t = Diff.t [@@deriving sexp, bin_io]

        include sig
          [@@@ocaml.warning "-32"]

          include Sexplib0.Sexpable.S with type t := t
          include Bin_prot.Binable.S with type t := t
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

    val to_string : t -> string
    val of_string : string -> t
    val of_string_allow_nan_and_inf : string -> t
  end

  module V3 : sig
    type nonrec t = t
    [@@ocaml.doc
      " Fully round-trippable format, which does not use float multiplication or division\n\
      \        to serialize or deserialize [%] or [bp] but instead does string \
       manipulation.\n\n\
      \        Note that as a consequence, this may yield ugly-looking output for \
       [Percent.t]\n\
      \        values obtained as a result of a calculation, including \
       [Percent.of_percentage],\n\
      \        because of accumulated floating-point rounding errors.  Use\n\
      \        [Almost_round_trippable] when the esthetics (aka human readability) of \
       the output\n\
      \        is more important than exact round-trippability.\n\n\
      \        Also note that [Percent.Stable.V3.t_of_sexp] and \
       [Percent.Stable.V2.t_of_sexp]\n\
      \        may yield results off by one ulp because the latter does the division by \
       100.0 or\n\
      \        10,000.0 in the '%' or 'bp' case, respectively.\n\n\
      \        For example,\n\n\
      \        {[ stable.V3.of_string \"17.33%\" <> of_percentage 17.33 ]}\n\
      \    "]
    [@@deriving
      sexp
    , sexp_grammar
    , bin_io
    , compare
    , globalize
    , hash
    , equal
    , typerep
    , stable_witness
    , diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t

      val globalize : t -> t

      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

      module Diff : sig
        open! Diffable.For_ppx

        type derived_on = t
        type t = Diff.t [@@deriving sexp, bin_io]

        include sig
          [@@@ocaml.warning "-32"]

          include Sexplib0.Sexpable.S with type t := t
          include Bin_prot.Binable.S with type t := t
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
      Comparable_binable
      with type t := t
       and type comparator_witness := comparator_witness

    val to_string : t -> string
    val of_string : string -> t
    val of_string_allow_nan_and_inf : string -> t

    module Always_percentage : sig
      type nonrec t = t [@@deriving sexp, bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t
        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_string : t -> string
    end
    [@@ocaml.doc
      " A variant with alternative serialization, which always uses the [%] format,\n\
      \        regardless of the absolute value of [t].  Fully inter-operable with\n\
      \        [Percent.Stable.V3.t]: either can read the other's output and it's fully\n\
      \        round-trippable in both directions.\n\
      \    "]
  end

  module Option : sig
    module V1 : sig
      module Bin_shape_same_as_float : sig
        type t = Option.t [@@deriving bin_io, compare, hash, sexp, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Ppx_compare_lib.Comparable.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end
      [@@ocaml.doc " See comment for [Stable.V1.Bin_shape_same_as_float]. "]
    end

    module V2 : sig
      type t = Option.t [@@deriving bin_io, compare, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V3 : sig
      type t = Option.t
      [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end
end

module Always_percentage : sig
  type nonrec t = t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string : t -> string
  val format : t -> Format.t -> string
end
[@@ocaml.doc
  " Does not format small values as \"3bp\" or large ones as \"2x\"; always uses \
   percentages\n\
  \    (\"0.0003%\" or \"200%\").  The standard [of_sexp] can read these just fine.\n\n\
  \    Note: rounds to 6 significant digits only (as opposed to\n\
  \    [Percent.Stable.V3.Always_percentage], which is accurate, or\n\
  \    [Percent.Almost_round_trippable.Always_percentage], which rounds to 14 significant\n\
  \    digits).\n"]

module Almost_round_trippable : sig
  type nonrec t = t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string : t -> string
  val of_string : string -> t

  module Always_percentage : sig
    type nonrec t = t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_string : t -> string
  end
  [@@ocaml.doc
    " A variant with alternative serialization, which always uses the [%] format,\n\
    \      regardless of the absolute value of [t].  Fully inter-operable with\n\
    \      [Percent.Almost_round_trippable.t]: either can read the other's output and the\n\
    \      precision is exactly the same for both. "]
end
[@@ocaml.doc
  " Similar to [Stable.V3], but rounds to 14 significant digits in order to make the\n\
  \    output more palatable to humans, at the cost of making it not exactly \
   round-trippable,\n\
  \    e.g.\n\n\
  \    {[\n\
  \      Percent.Stable.V3.to_string (Percent.of_percentage 17.13) = \
   \"17.129999999999998%\"\n\
  \    ]}\n\n\
  \    (this is because of the [17.13 /. 100.] float division hidden in\n\
  \    [Percent.of_percentage]).  But:\n\n\
  \    {[\n\
  \      Percent.Almost_round_trippable.to_string (Percent.of_percentage 17.13) = \
   \"17.13%\"\n\
  \    ]}\n"]
