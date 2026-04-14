let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"comparable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "comparable_intf.ml.before-ppx"
;;

open! Import

module type Infix = Base.Comparable.Infix
module type Comparisons = Base.Comparable.Comparisons
module type With_compare = Base.Comparable.With_compare

module type Validate = sig
  type t

  val validate_lbound : min:t Maybe_bound.t -> t Validate.check
  val validate_ubound : max:t Maybe_bound.t -> t Validate.check
  val validate_bound : min:t Maybe_bound.t -> max:t Maybe_bound.t -> t Validate.check
end

module type Validate_with_zero = sig
  type t

  include Validate with type t := t

  val validate_positive : t Validate.check
  val validate_non_negative : t Validate.check
  val validate_negative : t Validate.check
  val validate_non_positive : t Validate.check
end

module type With_zero = sig
  type t

  include Base.Comparable.With_zero with type t := t
  include Validate_with_zero with type t := t
end

module type S_common = sig
  include Base.Comparable.S
  include Validate with type t := t
  module Replace_polymorphic_compare : Comparisons with type t := t
end

[@@@ocaml.text
  " Usage example:\n\n\
  \    {[\n\
  \      module Foo : sig\n\
  \        type t = ...\n\
  \        include Comparable.S with type t := t\n\
  \      end\n\
  \    ]}\n\n\
  \    Then use [Comparable.Make] in the struct (see comparable.mli for an example). "]

module type S_plain = sig
  include S_common

  module Map :
    Map.S_plain with type Key.t = t with type Key.comparator_witness = comparator_witness

  module Set :
    Set.S_plain with type Elt.t = t with type Elt.comparator_witness = comparator_witness
end

module type S = sig
  include S_common

  module Map :
    Map.S with type Key.t = t with type Key.comparator_witness = comparator_witness

  module Set :
    Set.S with type Elt.t = t with type Elt.comparator_witness = comparator_witness
end

module type Map_and_set_binable = sig
  type t

  include Comparator.S with type t := t

  module Map :
    Map.S_binable
    with type Key.t = t
    with type Key.comparator_witness = comparator_witness

  module Set :
    Set.S_binable
    with type Elt.t = t
    with type Elt.comparator_witness = comparator_witness
end

module type S_binable = sig
  include S_common

  include
    Map_and_set_binable
    with type t := t
    with type comparator_witness := comparator_witness
end

module type Comparable = sig
  [@@@ocaml.text
    " Comparable extends {{!Base.Comparable}[Base.Comparable]} and provides functions for\n\
    \      comparing like types.\n\n\
    \      Usage example:\n\n\
    \      {[\n\
    \        module Foo = struct\n\
    \          module T = struct\n\
    \            type t = ... [@@deriving compare, sexp]\n\
    \          end\n\
    \          include T\n\
    \          include Comparable.Make (T)\n\
    \        end\n\
    \      ]}\n\n\
    \      Then include [Comparable.S] in the signature (see {!Comparable_intf} for an\n\
    \      example).\n\n\
    \      To add an [Infix] submodule:\n\n\
    \      {[\n\
    \        module C = Comparable.Make (T)\n\
    \        include C\n\
    \        module Infix = (C : Comparable.Infix with type t := t)\n\
    \      ]}\n\n\
    \      Common pattern: Define a module [O] with a restricted signature.  It aims to be\n\
    \      (locally) opened to bring useful operators into scope without shadowing \
     unexpected\n\
    \      variable names.  E.g. in the [Date] module:\n\n\
    \      {[\n\
    \        module O = struct\n\
    \          include (C : Comparable.Infix with type t := t)\n\
    \          let to_string t = ..\n\
    \        end\n\
    \      ]}\n\n\
    \      Opening [Date] would shadow [now], but opening [Date.O] doesn't:\n\n\
    \      {[\n\
    \        let now = .. in\n\
    \        let someday = .. in\n\
    \        Date.O.(now > someday)\n\
    \      ]}\n\
    \  "]

  module type Infix = Infix
  module type Map_and_set_binable = Map_and_set_binable
  module type Comparisons = Comparisons
  module type S_plain = S_plain
  module type S = S
  module type S_binable = S_binable
  module type S_common = S_common
  module type Validate = Validate
  module type Validate_with_zero = Validate_with_zero
  module type With_compare = With_compare
  module type With_zero = With_zero

  include With_compare

  module Inherit : functor
      (C : sig
         type t [@@deriving compare]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> functor
      (T : sig
         type t [@@deriving sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         val component : t -> C.t
       end)
      -> S with type t := T.t
  [@@ocaml.doc " Inherit comparability from a component. "]

  [@@@ocaml.text
    " {2 Comparison-only Functors}\n\n\
    \      These functors require only [type t] and [val compare]. They do not require \
     [val\n\
    \      sexp_of_t], and do not generate container datatypes.\n\
    \  "]

  module Infix : functor
      (T : sig
         type t [@@deriving compare]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> Infix with type t := T.t

  module Comparisons : functor
      (T : sig
         type t [@@deriving compare]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> Comparisons with type t := T.t

  [@@@ocaml.text
    " {2 Make Functors}\n\n\
    \      The Comparable Make functor family allows users to choose among the following\n\
    \      attributes:\n\n\
    \      - [*_using_comparator] or not\n\
    \      - [*_binable] or not\n\
    \      - [*_plain] or not\n\n\
    \      Thus there are functors like [Make_plain] or [Make_binable_using_comparator], \
     etc.\n\
    \  "]

  module Make_plain : functor
      (T : sig
         type t [@@deriving compare, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S_plain with type t := T.t

  module Make : functor
      (T : sig
         type t [@@deriving compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S with type t := T.t

  module Make_plain_using_comparator : functor
      (T : sig
         type t [@@deriving sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
       end)
      -> S_plain with type t := T.t with type comparator_witness := T.comparator_witness

  module Make_using_comparator : functor
      (T : sig
         type t [@@deriving sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
       end)
      -> S with type t := T.t with type comparator_witness := T.comparator_witness

  module Make_binable : functor
      (T : sig
         type t [@@deriving bin_io, compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S_binable with type t := T.t

  module Make_binable_using_comparator : functor
      (T : sig
         type t [@@deriving bin_io, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
       end)
      ->
    S_binable with type t := T.t with type comparator_witness := T.comparator_witness

  module Extend_plain : functor
      (M : Base.Comparable.S)
      -> functor
      (X : sig
         type t = M.t [@@deriving sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S_plain with type t := M.t with type comparator_witness := M.comparator_witness

  module Extend : functor
      (M : Base.Comparable.S)
      -> functor
      (X : sig
         type t = M.t [@@deriving sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S with type t := M.t with type comparator_witness := M.comparator_witness

  module Extend_binable : functor
      (M : Base.Comparable.S)
      -> functor
      (X : sig
         type t = M.t [@@deriving bin_io, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      ->
    S_binable with type t := M.t with type comparator_witness := M.comparator_witness

  module Map_and_set_binable : functor
      (T : sig
         type t [@@deriving bin_io, compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> Map_and_set_binable with type t := T.t

  module Map_and_set_binable_using_comparator : functor
      (T : sig
         type t [@@deriving bin_io, compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
       end)
      ->
    Map_and_set_binable
    with type t := T.t
    with type comparator_witness := T.comparator_witness

  module Poly : functor
      (T : sig
         type t [@@deriving sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> S with type t := T.t

  module Validate : functor
      (T : sig
         type t [@@deriving compare, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]
       end)
      -> Validate with type t := T.t

  module Validate_with_zero : functor
      (T : sig
         type t [@@deriving compare, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         val zero : t
       end)
      -> Validate_with_zero with type t := T.t

  module With_zero : functor
      (T : sig
         type t [@@deriving compare, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         val zero : t
       end)
      -> With_zero with type t := T.t

  [@@@ocaml.text
    " The following module types and functors may be used to define stable modules: "]

  module Stable : sig
    module V1 : sig
      module type S = sig
        type comparable
        type comparator_witness

        module Map :
          Map.Stable.V1.S
          with type key := comparable
          with type comparator_witness := comparator_witness

        module Set :
          Set.Stable.V1.S
          with type elt := comparable
          with type elt_comparator_witness := comparator_witness
      end

      module Make : functor (X : Stable_module_types.S0) ->
        S with type comparable := X.t with type comparator_witness := X.comparator_witness

      module With_stable_witness : sig
        module type S = sig
          type comparable
          type comparator_witness

          module Map :
            Map.Stable.V1.With_stable_witness.S
            with type key := comparable
            with type comparator_witness := comparator_witness

          module Set :
            Set.Stable.V1.With_stable_witness.S
            with type elt := comparable
            with type elt_comparator_witness := comparator_witness
        end

        module Make : functor (X : Stable_module_types.With_stable_witness.S0) ->
          S
          with type comparable := X.t
          with type comparator_witness := X.comparator_witness
      end
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
