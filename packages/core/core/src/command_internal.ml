let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"command_internal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "command_internal.ml.before-ppx"
;;

open! Import
open! Std_internal
include Command

module Arg_type = struct
  include Arg_type

  module Export = struct
    include Export

    let date = create Date.of_string
    let percent = create Percent.of_string
    let host_and_port = create Host_and_port.of_string
  end
end

module Param = struct
  include (
    Param :
    sig
      include module type of Param with module Arg_type := Param.Arg_type
    end)

  module Arg_type = Arg_type
  include Arg_type.Export
end

module Spec = struct
  include (
    Spec :
    sig
      include module type of Spec with module Arg_type := Spec.Arg_type
    end)

  module Arg_type = Arg_type
  include Arg_type.Export
end

module Let_syntax = struct
  include Let_syntax

  module Let_syntax = struct
    include Let_syntax
    module Open_on_rhs = Param
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
