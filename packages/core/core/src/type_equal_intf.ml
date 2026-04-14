let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"type_equal_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "type_equal_intf.ml.before-ppx"
;;

module type Uid = sig
  include module type of struct
    include Base.Type_equal.Id.Uid
  end

  include
    Comparable.S_plain with type t := t and type comparator_witness := comparator_witness

  include Hashable.S_plain with type t := t
end

module type Id = sig
  include module type of struct
    include Base.Type_equal.Id
  end

  module Uid : Uid
end

module type Type_equal = sig
  include module type of struct
    include Base.Type_equal
  end
  [@@ocaml.doc " @inline "]

  module Id : Id
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
