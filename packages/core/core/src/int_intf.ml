[@@@ocaml.text " This module extends {{!Base.Int_intf}[Base.Int_intf]}. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"int_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "int_intf.ml.before-ppx"
;;

module type Round = Base.Int.Round

module type Stable = sig
  module V1 : sig
    type t [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_comparable.With_stable_witness.V1 with type t := t
  end
end

module type Binaryable = sig
  type t

  module Binary : sig
    type nonrec t = t [@@deriving bin_io, sexp_of, compare ~localize, hash, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Comparable.S_local with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_string : t -> string
    val to_string_hum : ?delimiter:char -> t -> string
  end

  include Base.Int.Binaryable with type t := t and module Binary := Binary
end

module type Hexable = sig
  type t

  module Hex : sig
    type nonrec t = t
    [@@deriving bin_io, sexp, sexp_grammar, compare ~localize, hash, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Comparable.S_local with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Typerep_lib.Typerepable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Base.Stringable.S with type t := t

    val to_string_hum : ?delimiter:char -> t -> string
  end

  include Base.Int.Hexable with type t := t and module Hex := Hex
end

module type Extension = sig
  type t [@@deriving bin_io, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Binaryable with type t := t
  include Hexable with type t := t
  include Identifiable.S with type t := t
  include Comparable.Validate_with_zero with type t := t
  include Quickcheckable.S_int with type t := t
end

module type S_unbounded = sig
  include Base.Int.S_unbounded
  include Extension with type t := t with type comparator_witness := comparator_witness
end

module type S = sig
  include Base.Int.S
  include Extension with type t := t with type comparator_witness := comparator_witness
end

module type Extension_with_stable = sig
  include Extension

  module Stable :
    Stable with type V1.t = t and type V1.comparator_witness = comparator_witness
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
