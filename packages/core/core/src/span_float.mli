open! Import
include Span_intf.S with type underlying = float

module Stable : sig
  module V1 : sig
    type nonrec t = t
    [@@deriving sexp, sexp_grammar, bin_io, compare, hash, equal, stable_witness, diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

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
  end
  [@@ocaml.doc
    " [V1]'s sexps use single-unit format and support units from [d] to [ms]; it does not\n\
    \      support [us] or [ns]. [V1]'s sexp conversions do not round-trip precisely. "]

  module V2 : sig
    type nonrec t = t
    [@@deriving sexp, sexp_grammar, bin_io, compare, hash, equal, stable_witness, diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

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
  end
  [@@ocaml.doc
    " [V2]'s sexps use single-unit format and support units from [d] to [ns]. [V2] can\n\
    \      read [V1] sexps but not vice versa. [V2]'s sexp conversions do not round-trip\n\
    \      precisely. "]

  module V3 : sig
    type nonrec t = t
    [@@deriving
      sexp, sexp_grammar, bin_io, compare, hash, typerep, equal, stable_witness, diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

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
  end
  [@@ocaml.doc
    " [V3] uses mixed-unit format and supports units from [d] to [ns]. [V3] can read [V2]\n\
    \      and [V1] sexps but not vice versa. [V3]'s sexp conversions round-trip \
     precisely. "]
end

module Private : sig
  val parse_suffix : string -> index:int -> Unit_of_time.t
  val suffix_of_unit_of_time : Unit_of_time.t -> string
end
