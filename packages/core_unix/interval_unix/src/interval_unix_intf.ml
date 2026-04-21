let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"interval_unix_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "interval_unix_intf.ml.before-ppx"
;;

open! Core
module Interval = Interval_lib.Interval
module Zone = Time_float.Zone

module type S_time = sig
  module Time : sig
    type t

    module Ofday : sig
      type t
    end
  end

  include Interval.S with type bound = Time.t [@@ocaml.doc " @open "]

  val create_ending_after : ?zone:Zone.t -> Time.Ofday.t * Time.Ofday.t -> now:Time.t -> t
  [@@ocaml.doc
    " [create_ending_after ?zone (od1, od2) ~now] returns the smallest interval [(t1 t2)]\n\
    \      with minimum [t2] such that [t2 >= now], [to_ofday t1 = od1], and [to_ofday \
     t2 =\n\
    \      od2]. If a zone is specified, it is used to translate [od1] and [od2] into \
     times,\n\
    \      otherwise the machine's time zone is used.\n\n\
    \      It is not guaranteed that the interval will contain [now]: for instance if it's\n\
    \      11:15am, [od1] is 12pm, and [od2] is 2pm, the returned interval will be \
     12pm-2pm\n\
    \      today, which obviously doesn't include 11:15am. In general [contains (t1 t2) \
     now]\n\
    \      will only be true when now is between [to_ofday od1] and [to_ofday od2].\n\n\
    \      You might want to use this function if, for example, there's a daily meeting \
     from\n\
    \      10:30am-11:30am and you want to find the next instance of the meeting, \
     relative to\n\
    \      now. "]

  val create_ending_before
    :  ?zone:Zone.t
    -> Time.Ofday.t * Time.Ofday.t
    -> ubound:Time.t
    -> t
  [@@ocaml.doc
    " [create_ending_before ?zone (od1, od2) ~ubound] returns the smallest interval [(t1\n\
    \      t2)] with maximum [t2] such that [t2 <= ubound], [to_ofday t1 = od1], and \
     [to_ofday\n\
    \      t2 = od2]. If a zone is specified, it is used to translate [od1] and [od2] into\n\
    \      times, otherwise the machine's time zone is used.\n\n\
    \      You might want to use this function if, for example, there's a lunch hour from\n\
    \      noon to 1pm and you want to find the first instance of that lunch hour (an \
     interval)\n\
    \      before [ubound]. The result will either be on the same day as [ubound], if\n\
    \      [to_ofday ubound] is after 1pm, or the day before, if [to_ofday ubound] is any\n\
    \      earlier. "]
end

module type Interval_unix = sig
  module type S_time = S_time
  [@@ocaml.doc
    "\n\
    \     [S_time] is a signature that's used below to define the interfaces for [Time] \
     and\n\
    \     [Time_ns] without duplication.\n\
    \  "]

  [@@@ocaml.text " {3 Specialized time interval types} "]

  module Time : S_time with module Time := Time_float and type t = Time_float.t Interval.t
  module Time_ns : S_time with module Time := Time_ns and type t = Time_ns.t Interval.t

  module Stable : sig
    module V1 : sig
      module Time : Stable with type t = Time.t
      module Time_ns : Stable with type t = Time_ns.t
    end
  end
  [@@ocaml.doc
    "\n\
    \     [Stable] is used to build stable protocols. It ensures backwards compatibility \
     by\n\
    \     checking the sexp and bin-io representations of a given module. Here it's \
     applied\n\
    \     to the [Time], and [Time_ns] intervals.\n\
    \  "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
