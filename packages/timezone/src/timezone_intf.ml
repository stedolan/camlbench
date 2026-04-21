let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timezone_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timezone_intf.ml.before-ppx"
;;

open Core

module type Extend_zone = sig
  type t [@@deriving sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Identifiable.S with type t := t
  include Diffable.S_atomic with type t := t

  val find : string -> t option
  [@@ocaml.doc
    " [find name] looks up a [t] by its name and returns it.  This also accepts some\n\
    \      aliases, including:\n\n\
    \      - chi -> America/Chicago\n\
    \      - nyc -> America/New_York\n\
    \      - hkg -> Asia/Hong_Kong\n\
    \      - ldn -> Europe/London\n\
    \      - lon -> Europe/London\n\
    \      - tyo -> Asia/Tokyo "]

  val find_exn : string -> t

  val local : t Lazy.t
  [@@ocaml.doc
    " [local] is the machine's local timezone, as determined from the [TZ]\n\
    \      environment variable or the [/etc/localtime] file.  It is computed from\n\
    \      the state of the process environment and on-disk tzdata database at\n\
    \      some unspecified moment prior to its first use, so its value may be\n\
    \      unpredictable if that state changes during program operation. Arguably,\n\
    \      changing the timezone of a running program is a problematic operation\n\
    \      anyway -- most people write code assuming the clock doesn't suddenly\n\
    \      jump several hours without warning.\n\n\
    \      Note that any function using this timezone can throw an exception if\n\
    \      the [TZ] environment variable is misconfigured or if the appropriate\n\
    \      timezone files can't be found because of the way the box is configured.\n\
    \      We don't sprinkle [_exn] all over all the names in this module because\n\
    \      such misconfiguration is quite rare. "]

  val initialized_zones : unit -> (string * t) list
  [@@ocaml.doc
    " [initialized_zones ()] returns a sorted list of time zone names that have\n\
    \      been loaded from disk thus far. "]

  [@@@ocaml.text
    " {3 Low-level functions}\n\n\
    \      The functions below are lower level and should be used more rarely. "]

  val init : unit -> unit
  [@@ocaml.doc
    " [init ()] pre-load all available time zones from disk, this function has no effect \
     if\n\
    \      it is called multiple times.  Time zones will otherwise be loaded at need \
     from the\n\
    \      disk on the first call to find/find_exn. "]
end

module type Timezone = sig
  module type Extend_zone = Extend_zone

  include Core_private.Time_zone.S with type t = Time_float.Zone.t
  include Extend_zone with type t := t

  module Stable : sig
    module V1 : sig
      type nonrec t = t
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

      include Stringable.S with type t := t
      include Diffable.S with type t := t and type Diff.t = Diff.t
    end

    include Core_private.Time_zone.S_stable with type t := t
  end

  [@@@ocaml.text "/*"]

  module Private : sig
    module Zone_cache : sig
      type z =
        { mutable full : bool
        ; basedir : string
        ; table : Time_float.Zone.t String.Table.t
        }

      val the_one_and_only : z
      val init : unit -> unit
      val find : string -> t option
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
