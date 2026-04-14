let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"info_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "info_intf.ml.before-ppx"
;;

open! Import

module type Extension = sig
  type t [@@deriving bin_io, diff ~how:"atomic" ~extra_derive:[ sexp ]]

  include sig
    [@@@ocaml.warning "-32-60"]

    include Bin_prot.Binable.S with type t := t

    module Diff : sig
      open! Diffable.For_ppx

      type derived_on = t
      type t = derived_on [@@deriving bin_io, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  from:derived_on
        -> to_:derived_on
        -> (t Optional_diff.t[@jane.erasable.mode local])

      val apply_exn : derived_on -> t -> derived_on
      val of_list_exn : t list -> (t Optional_diff.t[@jane.erasable.mode local])
    end
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Stable : sig
    module V1 : Stable_module_types.With_stable_witness.S0 with type t = t
    [@@ocaml.doc
      " [Info.t] is wire-compatible with [V2.t], but not [V1.t].  [V1] bin-prots a sexp of\n\
      \        the underlying message, whereas [V2] bin-prots the underlying message. "]

    module V2 : sig
      type nonrec t = t
      [@@deriving equal, hash, sexp_grammar, diff ~extra_derive:[ sexp; bin_io ]]

      include sig
        [@@@ocaml.warning "-32-60"]

        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

        module Diff : sig
          open! Diffable.For_ppx

          type derived_on = t
          type t = Diff.t [@@deriving sexp, bin_io]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S with type t := t
            include Bin_prot.Binable.S with type t := t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]

          val get
            :  from:derived_on
            -> to_:derived_on
            -> (t Optional_diff.t[@jane.erasable.mode local])

          val apply_exn : derived_on -> t -> derived_on
          val of_list_exn : t list -> (t Optional_diff.t[@jane.erasable.mode local])
        end
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Stable_module_types.With_stable_witness.S0 with type t := t
    end
  end
end
[@@ocaml.doc " Extension to the base signature "]

module type S = sig
  include Base.Info.S
  include Extension with type t := t
end

module type Info = sig
  include module type of struct
    include Base.Info
  end
  [@@ocaml.doc " @inline "]

  module Internal_repr : module type of Base.Info.Internal_repr
  include Extension with type t := t
  module Extend : functor (Info : Base.Info.S) -> Extension with type t := Info.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
