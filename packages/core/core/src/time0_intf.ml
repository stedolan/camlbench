let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time0_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time0_intf.ml.before-ppx"
;;

open! Import
open Std_internal

module type Basic = sig
  module Span : Span_intf.S

  type t

  module Replace_polymorphic_compare : Comparable.Comparisons with type t := t
  include Comparable.Comparisons with type t := t
  include Robustly_comparable with type t := t

  val add : t -> Span.t -> t
  val sub : t -> Span.t -> t
  val diff : t -> t -> Span.t

  val next : t -> t [@@ocaml.doc " [next t] returns the next t (forwards in time) "]

  val prev : t -> t [@@ocaml.doc " [prev t] returns the previous t (backwards in time) "]

  val to_span_since_epoch : t -> Span.t
  val of_span_since_epoch : Span.t -> t
end

module type S = sig
  type underlying
  type t = private underlying [@@deriving bin_io, compare, hash, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Span : Span_intf.S with type underlying = underlying
  module Ofday : Ofday_intf.S with type underlying := underlying and module Span := Span
  include Basic with type t := t and module Span := Span

  include
    Comparable.S_common
    with type t := t
     and module Replace_polymorphic_compare := Replace_polymorphic_compare

  module Date_and_ofday : sig
      type absolute = t
      type t = private underlying

      [@@@ocaml.text " {2 Constructors and accessors} "]

      val of_date_ofday : Date0.t -> Ofday.t -> t
      val to_date_ofday : t -> Date0.t * Ofday.t
      val to_date : t -> Date0.t
      val to_ofday : t -> Ofday.t

      [@@@ocaml.text
        " {2 Conversions between absolute times and date + ofday}\n\n\
        \        Based on the offset from UTC at the given time. It is usually simpler \
         to use the\n\
        \        [Time.Zone] wrappers of these conversions. "]

      val of_absolute : absolute -> offset_from_utc:Span.t -> t
      val to_absolute : t -> offset_from_utc:Span.t -> absolute

      [@@@ocaml.text
        " {2 Low-level conversions}\n\n\
        \        Convert between [t] and a synthetic span representing the difference in \
         date from\n\
        \        epoch, times the length of a day, plus the ofday's distance from \
         midnight.\n\n\
        \        These spans do not correspond with any actual duration of time. \
         Arithmetic on\n\
        \        these spans is only meaningful within a range where no DST transitions \
         can occur.\n\
        \        For example, rounding to the nearest second makes sense but adding \
         arbitrary spans\n\
        \        does not.\n\n\
        \        These functions are intended for low-level DST transition arithmetic. \
         Most clients\n\
        \        should not call these functions directly. "]

      val of_synthetic_span_since_epoch : Span.t -> t
      val to_synthetic_span_since_epoch : t -> Span.t
    end
    with type absolute := t
  [@@ocaml.doc
    " Equivalent to a [Date.t] and an [Ofday.t] with no time zone. A [Date_and_ofday.t]\n\
    \      does not correspond to a single, unambiguous point in time. "]

  val next_multiple
    :  ?can_equal_after:(bool[@ocaml.doc " default is [false] "])
    -> base:t
    -> after:t
    -> interval:Span.t
    -> unit
    -> t
  [@@ocaml.doc
    " [next_multiple ~base ~after ~interval] returns the smallest [time] of the form:\n\n\
    \      {[\n\
    \        time = base + k * interval\n\
    \      ]}\n\n\
    \      where [k >= 0] and [time > after].  It is an error if [interval <= 0].\n\n\
    \      Supplying [~can_equal_after:true] allows the result to satisfy [time >= after].\n\
    \  "]

  val prev_multiple
    :  ?can_equal_before:(bool[@ocaml.doc " default is [false] "])
    -> base:t
    -> before:t
    -> interval:Span.t
    -> unit
    -> t
  [@@ocaml.doc
    " [prev_multiple ~base ~before ~interval] returns the largest [time] of the form:\n\n\
    \      {[\n\
    \        time = base + k * interval\n\
    \      ]}\n\n\
    \      where [k >= 0] and [time < before].  It is an error if [interval <= 0].\n\n\
    \      Supplying [~can_equal_before:true] allows the result to satisfy [time <= \
     before].\n\
    \  "]

  val now : unit -> t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
