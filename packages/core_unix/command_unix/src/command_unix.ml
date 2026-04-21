let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"command_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "command_unix.ml.before-ppx"
;;

open! Core
module Path = Command.Private.Path

module For_unix = Command.Private.For_unix (struct
    module Pid = Pid
    module Signal = Signal
    module Thread = Core_thread

    module Unix = struct
      include Core_unix

      let unsafe_getenv = Sys_unix.unsafe_getenv
      let create_process_env = create_process_env ?setpgid:None
      let wait pid = ignore (wait (`Pid pid) : Pid.t * Exit_or_signal.t)
    end

    module Version_util = struct
      include Version_util
      module Time = Time_float_unix
    end
  end)

let run = For_unix.run
let shape = For_unix.shape

module Deprecated = struct
  let run = For_unix.deprecated_run
end

module Shape = struct
  let help_text = For_unix.help_for_shape
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
