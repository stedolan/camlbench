[@@@ocaml.text
  " For making an abstract version of a type that ensures a validation check has passed.\n\n\
  \    Suppose one wants to have a type of positive integers:\n\n\
  \    {[\n\
  \      module Positive_int = Validated.Make (struct\n\
  \          type t = int\n\
  \          let here = [%here]\n\
  \          let validate = Int.validate_positive\n\
  \        end)\n\
  \    ]}\n\n\
  \    With this, one is certain that any value of type [Positive_int.t] has passed\n\
  \    [Int.validate_positive].\n\n\
  \    One can call [Positive_int.create_exn n] to create a new positive int from an [n],\n\
  \    which will of course raise if [n <= 0].  One can call [Positive_int.raw \
   positive_int]\n\
  \    to get the [int] from a [Positive_int.t].  "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"validated_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "validated_intf.ml.before-ppx"
;;

open! Import

module type Raw = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val here : Source_code_position.t
  [@@ocaml.doc " [here] will appear in validation-failure error messages. "]

  val validate : t Validate.check
end

module type Raw_bin_io = sig
  type t [@@deriving bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Raw with type t := t

  val validate_binio_deserialization : bool
  [@@ocaml.doc
    " [validate_binio_deserialization] controls whether when the binio representation of a\n\
    \      value is deserialized, the resulting value is validated.  Whether one needs to\n\
    \      validate values upon deserialization depends on how serialization is being \
     used.  If\n\
    \      one only ever serializes/deserializes so that the validation function is the \
     same on\n\
    \      both ends, then one need not validate upon deserialization, because only \
     values that\n\
    \      already pass the validation function can be serialized.\n\n\
    \      If the validation functions in the serializer and deserializer may be \
     different,\n\
    \      e.g. because of two different versions of the code compiled at different \
     times, then\n\
    \      it is possible to serialize a value that may fail validation upon \
     deserialization.\n\
    \      In that case, having [validate_binio_deserialization = true] is necessary to \
     prevent\n\
    \      creating values that don't pass the validation function. "]
end

module type Raw_bin_io_compare_hash_sexp = sig
  type t [@@deriving compare, hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Raw_bin_io with type t := t
end

module type Raw_bin_io_compare_globalize_hash_sexp = sig
  type t [@@deriving globalize]

  include sig
    [@@@ocaml.warning "-32"]

    val globalize : t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Raw_bin_io_compare_hash_sexp with type t := t
end

module type S_allowing_substitution = sig
  type ('raw, 'witness) validated
  type witness
  type raw
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : raw -> t Or_error.t
  val create_exn : raw -> t
  val raw : t -> raw
  val raw_local : t -> raw
  val create_stable_witness : raw Stable_witness.t -> t Stable_witness.t
  val type_equal : (t, (raw, witness) validated) Type_equal.t
end
[@@ocaml.doc
  " [S_allowing_substitution] is the same as [S], but allows writing interfaces like:\n\n\
  \    {[\n\
  \      type t [@@deriving bin_io, compare, ...]\n\n\
  \      include Validated.S_allowing_substitution with type t := t and type raw := \
   my_raw_type\n\
  \    ]}\n\n\
  \    which is not possible with [S] due to the fact that it constrains [t].  The \
   downside\n\
  \    is that you can no longer directly coerce [t] to be a [raw] but:\n\n\
  \    + You can use the [raw] function instead\n\
  \    + You can match on [type_equal] to do the coercion if you really need to (although\n\
  \    that's still a bit clunkier than a direct coercion would be)\n"]

module type S = sig
  type ('raw, 'witness) validated
  type witness
  type raw
  type t = (raw, witness) validated

  include
    S_allowing_substitution
    with type t := t
     and type raw := raw
     and type witness := witness
     and type ('raw, 'witness) validated := ('raw, 'witness) validated
end

module type S_bin_io = sig
  include S

  include sig
      type t = (raw, witness) validated [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t
end

module type S_bin_io_compare_hash_sexp = sig
  include S

  include sig
      type t = (raw, witness) validated [@@deriving bin_io, compare, hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t
end

module type S_bin_io_compare_globalize_hash_sexp = sig
  include S_bin_io_compare_hash_sexp

  include sig
      type t = (raw, witness) validated [@@deriving globalize]

      include sig
        [@@@ocaml.warning "-32"]

        val globalize : t -> t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t
end

module type Validated = sig
  type ('raw, 'witness) t = private 'raw

  val raw : ('raw, _) t -> 'raw
  val raw_local : ('raw, _) t -> 'raw

  module type Raw = Raw
  module type S = S with type ('a, 'b) validated := ('a, 'b) t

  module type S_allowing_substitution =
    S_allowing_substitution with type ('a, 'b) validated := ('a, 'b) t

  module type S_bin_io = S_bin_io with type ('a, 'b) validated := ('a, 'b) t

  module type S_bin_io_compare_hash_sexp =
    S_bin_io_compare_hash_sexp with type ('a, 'b) validated := ('a, 'b) t

  module type S_bin_io_compare_globalize_hash_sexp =
    S_bin_io_compare_globalize_hash_sexp with type ('a, 'b) validated := ('a, 'b) t

  module Make : functor (Raw : Raw) -> S with type raw := Raw.t
  module Make_binable : functor (Raw : Raw_bin_io) -> S_bin_io with type raw := Raw.t

  module Make_bin_io_compare_hash_sexp : functor (Raw : Raw_bin_io_compare_hash_sexp) ->
    S_bin_io_compare_hash_sexp with type raw := Raw.t
  [@@ocaml.doc " [Make_bin_io_compare_hash_sexp] is useful for stable types. "]

  module Make_bin_io_compare_globalize_hash_sexp : functor
      (Raw : Raw_bin_io_compare_globalize_hash_sexp)
      -> S_bin_io_compare_globalize_hash_sexp with type raw := Raw.t

  module Add_bin_io : functor
      (Raw : sig
         type t [@@deriving bin_io]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Raw_bin_io with type t := t
       end)
      -> functor
      (Validated : S with type raw := Raw.t)
      -> sig
      type t [@@deriving bin_io]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := Validated.t

  module Add_compare : functor
      (Raw : sig
         type t [@@deriving compare]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Raw with type t := t
       end)
      -> functor
      (Validated : S with type raw := Raw.t)
      -> sig
      type t [@@deriving compare]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := Validated.t

  module Add_hash : functor
      (Raw : sig
         type t [@@deriving hash]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_hash_lib.Hashable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Raw with type t := t
       end)
      -> functor
      (Validated : S with type raw := Raw.t)
      -> sig
      type t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := Validated.t

  module Add_typerep : functor
      (Raw : sig
         type t [@@deriving typerep]

         include sig
           [@@@ocaml.warning "-32"]

           include Typerep_lib.Typerepable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Raw with type t := t
       end)
      -> functor
      (Validated : S with type raw := Raw.t)
      -> sig
      type t [@@deriving typerep]

      include sig
        [@@@ocaml.warning "-32"]

        include Typerep_lib.Typerepable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := Validated.t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
