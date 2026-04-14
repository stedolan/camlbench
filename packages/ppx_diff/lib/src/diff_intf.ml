let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"diff_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "diff_intf.ml.before-ppx"
;;

module type S_plain = sig
  type derived_on
  type t

  val get : from:derived_on -> to_:derived_on -> t Optional_diff.t
  val apply_exn : derived_on -> t -> derived_on
  val of_list_exn : t list -> t Optional_diff.t
end

module type S = sig
  type derived_on
  type t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S_plain with type derived_on := derived_on and type t := t
end

module type S_atomic = sig
  type derived_on

  include S with type derived_on := derived_on and type t = derived_on
end

module type S1_plain = sig
  type 'a derived_on
  type ('a, 'a_diff) t

  val get
    :  (from:'a -> to_:'a -> 'a_diff Optional_diff.t)
    -> from:'a derived_on
    -> to_:'a derived_on
    -> ('a, 'a_diff) t Optional_diff.t

  val apply_exn
    :  ('a -> 'a_diff -> 'a)
    -> 'a derived_on
    -> ('a, 'a_diff) t
    -> 'a derived_on

  val of_list_exn
    :  ('a_diff list -> 'a_diff Optional_diff.t)
    -> ('a -> 'a_diff -> 'a)
    -> ('a, 'a_diff) t list
    -> ('a, 'a_diff) t Optional_diff.t
end

module type S1 = sig
  type 'a derived_on
  type ('a, 'a_diff) t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
    include Bin_prot.Binable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    S1_plain
    with type 'a derived_on := 'a derived_on
     and type ('a, 'a_diff) t := ('a, 'a_diff) t
end

module type S2_plain = sig
  type ('a, 'b) derived_on
  type ('a, 'b, 'a_diff, 'b_diff) t

  val get
    :  (from:'a -> to_:'a -> 'a_diff Optional_diff.t)
    -> (from:'b -> to_:'b -> 'b_diff Optional_diff.t)
    -> from:('a, 'b) derived_on
    -> to_:('a, 'b) derived_on
    -> ('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t

  val apply_exn
    :  ('a -> 'a_diff -> 'a)
    -> ('b -> 'b_diff -> 'b)
    -> ('a, 'b) derived_on
    -> ('a, 'b, 'a_diff, 'b_diff) t
    -> ('a, 'b) derived_on

  val of_list_exn
    :  ('a_diff list -> 'a_diff Optional_diff.t)
    -> ('a -> 'a_diff -> 'a)
    -> ('b_diff list -> 'b_diff Optional_diff.t)
    -> ('b -> 'b_diff -> 'b)
    -> ('a, 'b, 'a_diff, 'b_diff) t list
    -> ('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t
end

module type S2 = sig
  type ('a, 'b) derived_on
  type ('a, 'b, 'a_diff, 'b_diff) t [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('a -> Sexplib0.Sexp.t)
      -> ('b -> Sexplib0.Sexp.t)
      -> ('a_diff -> Sexplib0.Sexp.t)
      -> ('b_diff -> Sexplib0.Sexp.t)
      -> ('a, 'b, 'a_diff, 'b_diff) t
      -> Sexplib0.Sexp.t

    val t_of_sexp
      :  (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'b)
      -> (Sexplib0.Sexp.t -> 'a_diff)
      -> (Sexplib0.Sexp.t -> 'b_diff)
      -> Sexplib0.Sexp.t
      -> ('a, 'b, 'a_diff, 'b_diff) t

    val bin_shape_t
      :  Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t

    val bin_size_t
      :  'a Bin_prot.Size.sizer
      -> 'b Bin_prot.Size.sizer
      -> 'a_diff Bin_prot.Size.sizer
      -> 'b_diff Bin_prot.Size.sizer
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Size.sizer

    val bin_write_t
      :  'a Bin_prot.Write.writer
      -> 'b Bin_prot.Write.writer
      -> 'a_diff Bin_prot.Write.writer
      -> 'b_diff Bin_prot.Write.writer
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Write.writer

    val bin_writer_t
      :  'a Bin_prot.Type_class.writer
      -> 'b Bin_prot.Type_class.writer
      -> 'a_diff Bin_prot.Type_class.writer
      -> 'b_diff Bin_prot.Type_class.writer
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Type_class.writer

    val bin_read_t
      :  'a Bin_prot.Read.reader
      -> 'b Bin_prot.Read.reader
      -> 'a_diff Bin_prot.Read.reader
      -> 'b_diff Bin_prot.Read.reader
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Read.reader

    val __bin_read_t__
      :  'a Bin_prot.Read.reader
      -> 'b Bin_prot.Read.reader
      -> 'a_diff Bin_prot.Read.reader
      -> 'b_diff Bin_prot.Read.reader
      -> (int -> ('a, 'b, 'a_diff, 'b_diff) t) Bin_prot.Read.reader

    val bin_reader_t
      :  'a Bin_prot.Type_class.reader
      -> 'b Bin_prot.Type_class.reader
      -> 'a_diff Bin_prot.Type_class.reader
      -> 'b_diff Bin_prot.Type_class.reader
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Type_class.reader

    val bin_t
      :  'a Bin_prot.Type_class.t
      -> 'b Bin_prot.Type_class.t
      -> 'a_diff Bin_prot.Type_class.t
      -> 'b_diff Bin_prot.Type_class.t
      -> ('a, 'b, 'a_diff, 'b_diff) t Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    S2_plain
    with type ('a, 'b) derived_on := ('a, 'b) derived_on
     and type ('a, 'b, 'a_diff, 'b_diff) t := ('a, 'b, 'a_diff, 'b_diff) t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
