[@@@ocaml.text " Signature for use by {{!module:Core.Unique_id}[Unique_id]}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unique_id_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unique_id_intf.ml.before-ppx"
;;

open! Import
open Std_internal

module type Id = sig
  type t
  [@@ocaml.doc " The sexps and strings look like integers. "]
  [@@deriving bin_io, hash, sexp, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    Comparable.S_binable with type t := t
  [@@ocaml.doc
    " {b Caveat}: values created with [of_float], [of_sexp], or [of_string] may be equal\n\
    \      to previously created values. "]

  include Hashable.S_binable with type t := t
  include Intable with type t := t
  include Stringable with type t := t

  val create : unit -> t
  [@@ocaml.doc
    " Always returns a value that is not equal to any other value created with\n\
    \      [create]. "]

  module For_testing : sig
    val reset_counter : unit -> unit
    [@@ocaml.doc
      " Resets the counter to its default starting value. The nth call to [create] after\n\
      \        [reset_counter] has been called has the same ID value as the nth call to \
       [create]\n\
      \        after the start of the program (before [reset_counter] has been called).\n\n\
      \        This should only be used in testing to set up a deterministic environment \
       when\n\
      \        potentially running multiple tests in a row, because calling this will \
       break the\n\
      \        guarantee that [create] always returns a unique value. "]
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
