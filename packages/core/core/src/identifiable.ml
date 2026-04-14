let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"identifiable.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "identifiable.ml.before-ppx"
;;

open! Import
include Identifiable_intf
module Binable = Binable0

module Make_plain (T : sig
    type t [@@deriving compare, hash, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stringable.S with type t := t

    val module_name : string
  end) =
struct
  include T
  include Comparable.Make_plain (T)
  include Hashable.Make_plain (T)
  include Pretty_printer.Register (T)
end

module Make (T : sig
    type t [@@deriving bin_io, compare, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stringable.S with type t := t

    val module_name : string
  end) =
struct
  include T
  include Comparable.Make_binable (T)
  include Hashable.Make_binable (T)
  include Pretty_printer.Register (T)
end

module Make_with_sexp_grammar (T : sig
    type t [@@deriving bin_io, compare, hash, sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stringable.S with type t := t

    val module_name : string
  end) =
struct
  include T
  include Make (T)
end

module Make_and_derive_hash_fold_t (T : sig
    type t [@@deriving bin_io, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stringable.S with type t := t

    val hash : t -> int
    val module_name : string
  end) =
Make (struct
    include T

    let hash_fold_t state t = hash_fold_int state (hash t)
  end)

module Make_using_comparator (T : sig
    type t [@@deriving bin_io, compare, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
    include Stringable.S with type t := t

    val module_name : string
  end) =
struct
  include T
  include Comparable.Make_binable_using_comparator (T)
  include Hashable.Make_binable (T)
  include Pretty_printer.Register (T)
end

module Make_plain_using_comparator (T : sig
    type t [@@deriving compare, hash, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
    include Stringable.S with type t := t

    val module_name : string
  end) =
struct
  include T
  include Comparable.Make_plain_using_comparator (T)
  include Hashable.Make_plain (T)
  include Pretty_printer.Register (T)
end

module Make_using_comparator_and_derive_hash_fold_t (T : sig
    type t [@@deriving bin_io, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
    include Stringable.S with type t := t

    val hash : t -> int
    val module_name : string
  end) =
Make_using_comparator (struct
    include T

    let hash_fold_t state t = hash_fold_int state (hash t)
  end)

module Extend (M : Base.Identifiable.S) (B : Binable0.S with type t = M.t) = struct
  module T = struct
    include M
    include (B : Binable.S with type t := t)
  end

  include T
  include Comparable.Extend_binable (M) (T)

  include Hashable.Make_binable_with_hashable (struct
      module Key = T

      let hashable = M.hashable
    end)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
