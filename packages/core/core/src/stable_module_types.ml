let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_module_types.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_module_types.ml.before-ppx"
;;

open! Import

module type S0_without_comparator = sig
  type t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type S0 = sig
  include S0_without_comparator
  include Comparator.Stable.V1.S with type t := t
end

[@@@ocaml.text
  " The polymorphic signatures require a mapping function so people can write conversion\n\
  \    functions without either (1) re-implementing the mapping function inline or (2)\n\
  \    reaching into the unstable part of the module. "]

module type S1 = sig
  type 'a t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val map : 'a t -> f:('a -> 'b) -> 'b t
end

module type S2 = sig
  type ('a1, 'a2) t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
    include Ppx_compare_lib.Comparable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
    include Sexplib0.Sexpable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val map : ('a1, 'a2) t -> f1:('a1 -> 'b1) -> f2:('a2 -> 'b2) -> ('b1, 'b2) t
end

module type S3 = sig
  type ('a1, 'a2, 'a3) t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
    include Ppx_compare_lib.Comparable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
    include Sexplib0.Sexpable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val map
    :  ('a1, 'a2, 'a3) t
    -> f1:('a1 -> 'b1)
    -> f2:('a2 -> 'b2)
    -> f3:('a3 -> 'b3)
    -> ('b1, 'b2, 'b3) t
end

module type S4 = sig
  type ('a1, 'a2, 'a3, 'a4) t [@@deriving bin_io, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_t
      :  Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t

    val bin_size_t
      :  'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Size.sizer

    val bin_write_t
      :  'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Write.writer

    val bin_writer_t
      :  'a1 Bin_prot.Type_class.writer
      -> 'a2 Bin_prot.Type_class.writer
      -> 'a3 Bin_prot.Type_class.writer
      -> 'a4 Bin_prot.Type_class.writer
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Type_class.writer

    val bin_read_t
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Read.reader

    val __bin_read_t__
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4) t) Bin_prot.Read.reader

    val bin_reader_t
      :  'a1 Bin_prot.Type_class.reader
      -> 'a2 Bin_prot.Type_class.reader
      -> 'a3 Bin_prot.Type_class.reader
      -> 'a4 Bin_prot.Type_class.reader
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Type_class.reader

    val bin_t
      :  'a1 Bin_prot.Type_class.t
      -> 'a2 Bin_prot.Type_class.t
      -> 'a3 Bin_prot.Type_class.t
      -> 'a4 Bin_prot.Type_class.t
      -> ('a1, 'a2, 'a3, 'a4) t Bin_prot.Type_class.t

    val compare
      :  ('a1 -> ('a1[@merlin.hide]) -> int)
      -> ('a2 -> ('a2[@merlin.hide]) -> int)
      -> ('a3 -> ('a3[@merlin.hide]) -> int)
      -> ('a4 -> ('a4[@merlin.hide]) -> int)
      -> ('a1, 'a2, 'a3, 'a4) t
      -> (('a1, 'a2, 'a3, 'a4) t[@merlin.hide])
      -> int

    val sexp_of_t
      :  ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4) t
      -> Sexplib0.Sexp.t

    val t_of_sexp
      :  (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val map
    :  ('a1, 'a2, 'a3, 'a4) t
    -> f1:('a1 -> 'b1)
    -> f2:('a2 -> 'b2)
    -> f3:('a3 -> 'b3)
    -> f4:('a4 -> 'b4)
    -> ('b1, 'b2, 'b3, 'b4) t
end

module With_stable_witness = struct
  module type S0_without_comparator = sig
    type t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S0_without_comparator with type t := t
  end

  module type S0 = sig
    type t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S0 with type t := t
  end

  module type S1 = sig
    type 'a t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S1 with type 'a t := 'a t
  end

  module type S2 = sig
    type ('a, 'b) t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'b Ppx_stable_witness_runtime.Stable_witness.t
        -> ('a, 'b) t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S2 with type ('a, 'b) t := ('a, 'b) t
  end

  module type S3 = sig
    type ('a, 'b, 'c) t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'b Ppx_stable_witness_runtime.Stable_witness.t
        -> 'c Ppx_stable_witness_runtime.Stable_witness.t
        -> ('a, 'b, 'c) t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
  end

  module type S4 = sig
    type ('a, 'b, 'c, 'd) t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'b Ppx_stable_witness_runtime.Stable_witness.t
        -> 'c Ppx_stable_witness_runtime.Stable_witness.t
        -> 'd Ppx_stable_witness_runtime.Stable_witness.t
        -> ('a, 'b, 'c, 'd) t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include S4 with type ('a, 'b, 'c, 'd) t := ('a, 'b, 'c, 'd) t
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
