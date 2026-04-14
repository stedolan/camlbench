[@@@ocaml.text
  " This module extends {{!Base.Maybe_bound}[Base.Maybe_bound]} with bin_io and with\n\
  \    compare functions in the form of [As_lower_bound] and [As_upper_bound] modules. "]

type 'a t = 'a Base.Maybe_bound.t =
  | Incl of 'a
  | Excl of 'a
  | Unbounded
[@@deriving bin_io ~localize, equal, hash, quickcheck]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Maybe_bound
  end
  with type 'a t := 'a t
[@@ocaml.doc " @inline "]

module As_lower_bound : sig
  type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Compares [t] values as lower bounds, where [Unbounded] is lowest, [Incl x < Excl x],\n\
  \    and other cases of [Incl] and/or [Excl] are compared based on ['a].  If\n\
  \    [As_lower_bound.compare compare t1 t2 <= 0] and [is_lower_bound t2 ~of_:a \
   ~compare],\n\
  \    then [is_lower_bound t1 ~of_:a ~compare].  For example, for [int \
   As_lower_bound.t]:\n\n\
  \    {[\n\
  \      Unbounded < ... < Incl 13 < Excl 13 < Incl 14 < Excl 14 < ...\n\
  \    ]} "]

module As_upper_bound : sig
  type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Compares [t] values as upper bounds, where [Unbounded] is highest, [Incl x > Excl x],\n\
  \    and other cases of [Incl] and/or [Excl] are compared based on ['a].  If\n\
  \    [As_upper_bound.compare compare_a t1 t2 <= 0] and [is_upper_bound t1 ~of_:a \
   ~compare],\n\
  \    then [is_upper_bound t2 ~of_:a ~compare].  For example, for [int \
   As_upper_bound.t]:\n\n\
  \    {[\n\
  \      ... < Excl 13 < Incl 13 < Excl 14 < Incl 14 < ... < Unbounded\n\
  \    ]} "]

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S1 with type 'a t := 'a t
  end
end
