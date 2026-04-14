[@@@ocaml.text " For representing a day of the week. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"day_of_week_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "day_of_week_intf.ml.before-ppx"
;;

open! Import

module type Day_of_week = sig
  type t =
    | Sun
    | Mon
    | Tue
    | Wed
    | Thu
    | Fri
    | Sat
  [@@deriving bin_io ~localize, compare, hash, quickcheck, sexp, sexp_grammar, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S_binable with type t := t
  include Hashable.S_binable with type t := t

  include
    Stringable.S with type t := t
  [@@ocaml.doc
    " [of_string s] accepts three-character abbreviations and full day names\n\
    \      with any capitalization, and strings of the integers 0-6. "]

  val to_string_long : t -> string
  [@@ocaml.doc
    " Capitalized full day names rather than all-caps 3-letter abbreviations. "]

  val of_int_exn : int -> t
  [@@ocaml.doc " These use the same mapping as [Unix.tm_wday]: 0 <-> Sun, ... 6 <-> Sat "]

  val of_int : int -> t option
  val to_int : t -> int

  val iso_8601_weekday_number : t -> int
  [@@ocaml.doc " As per ISO 8601, Mon->1, Tue->2, ... Sun->7 "]

  val shift : t -> int -> t
  [@@ocaml.doc " [shift] goes forward (or backward) the specified number of days. "]

  val num_days : from:t -> to_:t -> int
  [@@ocaml.doc
    " [num_days ~from ~to_] gives the number of days that must elapse from a [from] to get\n\
    \      to a [to_], i.e., the smallest non-negative number [i] such that [shift from \
     i =\n\
    \      to_].\n\
    \  "]

  val is_sun_or_sat : t -> bool
  val all : t list

  val weekdays : t list [@@ocaml.doc " [ Mon; Tue; Wed; Thu; Fri ] "]

  val weekends : t list [@@ocaml.doc " [ Sat; Sun ] "]

  module Stable : sig
    module V1 : sig
      type nonrec t = t
      [@@deriving
        bin_io ~localize, equal, sexp, sexp_grammar, compare, hash, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S_local with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Comparable.Stable.V1.With_stable_witness.S
        with type comparable := t
        with type comparator_witness := comparator_witness

      include Hashable.Stable.V1.With_stable_witness.S with type key := t
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
