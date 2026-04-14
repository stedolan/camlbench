let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"month_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "month_intf.ml.before-ppx"
;;

open! Import

module type Month = sig
  type t =
    | Jan
    | Feb
    | Mar
    | Apr
    | May
    | Jun
    | Jul
    | Aug
    | Sep
    | Oct
    | Nov
    | Dec
  [@@deriving bin_io, hash, equal, quickcheck, sexp, sexp_grammar, variants]

  include sig
    [@@@ocaml.warning "-32-60"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    val jan : t
    val feb : t
    val mar : t
    val apr : t
    val may : t
    val jun : t
    val jul : t
    val aug : t
    val sep : t
    val oct : t
    val nov : t
    val dec : t
    val is_jan : t -> bool
    val is_feb : t -> bool
    val is_mar : t -> bool
    val is_apr : t -> bool
    val is_may : t -> bool
    val is_jun : t -> bool
    val is_jul : t -> bool
    val is_aug : t -> bool
    val is_sep : t -> bool
    val is_oct : t -> bool
    val is_nov : t -> bool
    val is_dec : t -> bool
    val jan_val : t -> unit option
    val feb_val : t -> unit option
    val mar_val : t -> unit option
    val apr_val : t -> unit option
    val may_val : t -> unit option
    val jun_val : t -> unit option
    val jul_val : t -> unit option
    val aug_val : t -> unit option
    val sep_val : t -> unit option
    val oct_val : t -> unit option
    val nov_val : t -> unit option
    val dec_val : t -> unit option

    module Variants : sig
      val jan : t Variantslib.Variant.t
      val feb : t Variantslib.Variant.t
      val mar : t Variantslib.Variant.t
      val apr : t Variantslib.Variant.t
      val may : t Variantslib.Variant.t
      val jun : t Variantslib.Variant.t
      val jul : t Variantslib.Variant.t
      val aug : t Variantslib.Variant.t
      val sep : t Variantslib.Variant.t
      val oct : t Variantslib.Variant.t
      val nov : t Variantslib.Variant.t
      val dec : t Variantslib.Variant.t

      val fold
        :  init:'acc__0
        -> jan:('acc__0 -> t Variantslib.Variant.t -> 'acc__1)
        -> feb:('acc__1 -> t Variantslib.Variant.t -> 'acc__2)
        -> mar:('acc__2 -> t Variantslib.Variant.t -> 'acc__3)
        -> apr:('acc__3 -> t Variantslib.Variant.t -> 'acc__4)
        -> may:('acc__4 -> t Variantslib.Variant.t -> 'acc__5)
        -> jun:('acc__5 -> t Variantslib.Variant.t -> 'acc__6)
        -> jul:('acc__6 -> t Variantslib.Variant.t -> 'acc__7)
        -> aug:('acc__7 -> t Variantslib.Variant.t -> 'acc__8)
        -> sep:('acc__8 -> t Variantslib.Variant.t -> 'acc__9)
        -> oct:('acc__9 -> t Variantslib.Variant.t -> 'acc__10)
        -> nov:('acc__10 -> t Variantslib.Variant.t -> 'acc__11)
        -> dec:('acc__11 -> t Variantslib.Variant.t -> 'acc__12)
        -> 'acc__12

      val iter
        :  jan:(t Variantslib.Variant.t -> unit)
        -> feb:(t Variantslib.Variant.t -> unit)
        -> mar:(t Variantslib.Variant.t -> unit)
        -> apr:(t Variantslib.Variant.t -> unit)
        -> may:(t Variantslib.Variant.t -> unit)
        -> jun:(t Variantslib.Variant.t -> unit)
        -> jul:(t Variantslib.Variant.t -> unit)
        -> aug:(t Variantslib.Variant.t -> unit)
        -> sep:(t Variantslib.Variant.t -> unit)
        -> oct:(t Variantslib.Variant.t -> unit)
        -> nov:(t Variantslib.Variant.t -> unit)
        -> dec:(t Variantslib.Variant.t -> unit)
        -> unit

      val map
        :  t
        -> jan:(t Variantslib.Variant.t -> 'result__)
        -> feb:(t Variantslib.Variant.t -> 'result__)
        -> mar:(t Variantslib.Variant.t -> 'result__)
        -> apr:(t Variantslib.Variant.t -> 'result__)
        -> may:(t Variantslib.Variant.t -> 'result__)
        -> jun:(t Variantslib.Variant.t -> 'result__)
        -> jul:(t Variantslib.Variant.t -> 'result__)
        -> aug:(t Variantslib.Variant.t -> 'result__)
        -> sep:(t Variantslib.Variant.t -> 'result__)
        -> oct:(t Variantslib.Variant.t -> 'result__)
        -> nov:(t Variantslib.Variant.t -> 'result__)
        -> dec:(t Variantslib.Variant.t -> 'result__)
        -> 'result__

      val make_matcher
        :  jan:(t Variantslib.Variant.t -> 'acc__0 -> (unit -> 'result__) * 'acc__1)
        -> feb:(t Variantslib.Variant.t -> 'acc__1 -> (unit -> 'result__) * 'acc__2)
        -> mar:(t Variantslib.Variant.t -> 'acc__2 -> (unit -> 'result__) * 'acc__3)
        -> apr:(t Variantslib.Variant.t -> 'acc__3 -> (unit -> 'result__) * 'acc__4)
        -> may:(t Variantslib.Variant.t -> 'acc__4 -> (unit -> 'result__) * 'acc__5)
        -> jun:(t Variantslib.Variant.t -> 'acc__5 -> (unit -> 'result__) * 'acc__6)
        -> jul:(t Variantslib.Variant.t -> 'acc__6 -> (unit -> 'result__) * 'acc__7)
        -> aug:(t Variantslib.Variant.t -> 'acc__7 -> (unit -> 'result__) * 'acc__8)
        -> sep:(t Variantslib.Variant.t -> 'acc__8 -> (unit -> 'result__) * 'acc__9)
        -> oct:(t Variantslib.Variant.t -> 'acc__9 -> (unit -> 'result__) * 'acc__10)
        -> nov:(t Variantslib.Variant.t -> 'acc__10 -> (unit -> 'result__) * 'acc__11)
        -> dec:(t Variantslib.Variant.t -> 'acc__11 -> (unit -> 'result__) * 'acc__12)
        -> 'acc__0
        -> (t -> 'result__) * 'acc__12

      val to_rank : t -> int
      val to_name : t -> string
      val descriptions : (string * int) list
    end
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S_binable with type t := t
  include Hashable.S_binable with type t := t

  include
    Stringable.S with type t := t
  [@@ocaml.doc
    " [of_string s] accepts three-character abbreviations with three capitalizations\n\
    \      (e.g. Jan, JAN, and jan). "]

  val all : t list

  val of_int : int -> t option
  [@@ocaml.doc
    " [of_int i] returns the [i]th month if [i] is in 1, 2, ... , 12. Otherwise it\n\
    \      returns [None]. "]

  val of_int_exn : int -> t

  val to_int : t -> int [@@ocaml.doc " [to_int t] returns an int in 1, 2, ... 12. "]

  val shift : t -> int -> t
  [@@ocaml.doc " [shift t i] goes forward (or backward) the specified number of months. "]

  module Export : sig
    type month = t =
      | Jan
      | Feb
      | Mar
      | Apr
      | May
      | Jun
      | Jul
      | Aug
      | Sep
      | Oct
      | Nov
      | Dec
    [@@deprecated
      "[since 2016-06] no longer needed since ocaml is now better at inferring the \
       module where a constructor is defined"]
  end

  module Stable : sig
    module V1 : sig
      type nonrec t = t =
        | Jan
        | Feb
        | Mar
        | Apr
        | May
        | Jun
        | Jul
        | Aug
        | Sep
        | Oct
        | Nov
        | Dec
      [@@deriving sexp, sexp_grammar, bin_io, compare, hash, equal]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Stable_module_types.With_stable_witness.S0
        with type comparator_witness = comparator_witness
         and type t := t
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
