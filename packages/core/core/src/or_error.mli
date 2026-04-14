[@@@ocaml.text " This module extends {{!Base.Or_error}[Base.Or_error]} with bin_io. "]

open! Import

type 'a t = ('a, Error.t) Result.t [@@deriving bin_io, diff ~extra_derive:[ sexp ]]

include sig
  [@@@ocaml.warning "-32-60"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t

  module Diff : sig
    open! Diffable.For_ppx

    type 'a derived_on = 'a t

    type ('a, 'a_diff) t = ('a, Error.t, 'a_diff, Error.Diff.t) Result.Diff.t
    [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
      include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> from:'a derived_on
      -> to_:'a derived_on
      -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])

    val apply_exn
      :  ('a -> 'a_diff -> 'a)
      -> 'a derived_on
      -> ('a, 'a_diff) t
      -> 'a derived_on

    val of_list_exn
      :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> ('a -> 'a_diff -> 'a)
      -> ('a, 'a_diff) t list
      -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
  end
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Or_error
  end
  with type 'a t := 'a t
[@@ocaml.doc " @inline "]

module Expect_test_config : Expect_test_config_types.S with type 'a IO.t = 'a t

module Expect_test_config_with_unit_expect = Expect_test_config
[@@deprecated "[since 2022-05] Use [Expect_test_config] instead, it is equivalent."]

module Stable : sig
  module V1 : Stable_module_types.With_stable_witness.S1 with type 'a t = 'a t
  [@@ocaml.doc
    " [Or_error.t] is wire compatible with [V2.t], but not [V1.t], like [Info.Stable]\n\
    \      and [Error.Stable]. "]

  module V2 : sig
    type nonrec 'a t = 'a t
    [@@deriving equal, sexp_grammar, diff ~extra_derive:[ sexp; bin_io ]]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

      module Diff : sig
        open! Diffable.For_ppx

        type 'a derived_on = 'a t
        type ('a, 'a_diff) t = ('a, 'a_diff) Diff.t [@@deriving sexp, bin_io]

        include sig
          [@@@ocaml.warning "-32"]

          include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
          include Bin_prot.Binable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val get
          :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> from:'a derived_on
          -> to_:'a derived_on
          -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])

        val apply_exn
          :  ('a -> 'a_diff -> 'a)
          -> 'a derived_on
          -> ('a, 'a_diff) t
          -> 'a derived_on

        val of_list_exn
          :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> ('a -> 'a_diff -> 'a)
          -> ('a, 'a_diff) t list
          -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
      end
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S1 with type 'a t := 'a t
  end
end
