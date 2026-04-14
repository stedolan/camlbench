let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"optional_syntax_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "optional_syntax_intf.ml.before-ppx"
;;

open! Import

module type S = sig
  type t
  type value

  module Optional_syntax : sig
    val is_none : t -> bool
    val unsafe_value : t -> value
  end
end

module type S1 = sig
  type 'a t
  type 'a value

  module Optional_syntax : sig
    val is_none : _ t -> bool
    val unsafe_value : 'a t -> 'a value
  end
end

module type S2 = sig
  type ('a, 'b) t
  type ('a, 'b) value

  module Optional_syntax : sig
    val is_none : _ t -> bool
    val unsafe_value : ('a, 'b) t -> ('a, 'b) value
  end
end

module type Optional_syntax = sig
  [@@@ocaml.text
    " Idiomatic usage is to have a module [M] like:\n\n\
    \      {[\n\
    \        module M : sig\n\
    \          type t\n\n\
    \          module Optional_syntax : Optional_syntax.S\n\
    \            with type t := t\n\
    \            with type value := ...\n\
    \        end = struct\n\
    \          ...\n\n\
    \          module Optional_syntax = struct\n\
    \            module Optional_syntax = struct\n\
    \              let is_none = is_none\n\
    \              let unsafe_value = unsafe_value\n\
    \            end\n\
    \          end\n\
    \        end\n\
    \      ]}\n\n\
    \      Then, uses look like:\n\n\
    \      {[\n\
    \        match%optional.M m with\n\
    \        | None   -> ?\n\
    \        | Some v -> ?\n\
    \      ]}\n\n\
    \      [match%optional] then expands to references to [M.Optional_syntax]'s \
     [is_none] and\n\
    \      [unsafe_value] functions.\n\n\
    \      The reason for the double [module Optional_syntax] is historical.  The idiom \
     used to\n\
    \      use [open M.Optional_syntax], and we wanted that to bring into scope as \
     little as\n\
    \      possible, so we made it put in scope only [module Optional_syntax].\n\n\
    \      [unsafe_value] does not have to be memory-safe if not guarded by [is_none].\n\n\
    \      Implementations of [is_none] and [unsafe_value] must not have any side effects.\n\
    \      More precisely, if you mutate any value currently being match'ed on (not \
     necessarily\n\
    \      your own argument) you risk a segfault as well.\n\n\
    \      This is because [match%optional] does not make any guarantee about [is_none] \
     call\n\
    \      being immediately followed by the corresponding [unsafe_value] call. In fact it\n\
    \      makes several [is_none] calls followed by several [unsafe_value] calls, so in\n\
    \      the presence of side-effects by the time it makes an [unsafe_value] call the \
     result\n\
    \      of the corresponding [is_none] can go stale.\n\n\
    \      For more details on the syntax extension, see [ppx/ppx_optional/README.md]. "]

  module type S = S
  module type S1 = S1
  module type S2 = S2
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
