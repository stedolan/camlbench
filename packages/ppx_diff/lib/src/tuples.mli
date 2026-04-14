val max_supported : int * Lexing.position

module Tuple2 : sig
  type ('a1, 'a2) t = 'a1 * 'a2 [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
    include Bin_prot.Binable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff : sig
    type ('a1, 'a2) derived_on = ('a1, 'a2) t

    module Entry_diff : sig
      type ('a1, 'a2, 'a1_diff, 'a2_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32-60"]

        val t1 : 'a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        val t2 : 'a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        val is_t1 : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> bool
        val is_t2 : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> bool
        val t1_val : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> 'a1_diff option
        val t2_val : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> 'a2_diff option

        module Variants : sig
          val t1 : ('a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
          val t2 : ('a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t

          val fold
            :  init:'acc__0
            -> t1:
                 ('acc__0
                  -> ('a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'acc__1)
            -> t2:
                 ('acc__1
                  -> ('a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'acc__2)
            -> 'acc__2

          val iter
            :  t1:
                 (('a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> unit)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> unit)
            -> unit

          val map
            :  ('a1, 'a2, 'a1_diff, 'a2_diff) t
            -> t1:
                 (('a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'a1_diff
                  -> 'result__)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'a2_diff
                  -> 'result__)
            -> 'result__

          val make_matcher
            :  t1:
                 (('a1_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'acc__0
                  -> ('a1_diff -> 'result__) * 'acc__1)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Variantslib.Variant.t
                  -> 'acc__1
                  -> ('a2_diff -> 'result__) * 'acc__2)
            -> 'acc__0
            -> (('a1, 'a2, 'a1_diff, 'a2_diff) t -> 'result__) * 'acc__2

          val to_rank : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> int
          val to_name : ('a1, 'a2, 'a1_diff, 'a2_diff) t -> string
          val descriptions : (string * int) list
        end

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('a1, 'a2, 'a1_diff, 'a2_diff) t =
      private
      ('a1, 'a2, 'a1_diff, 'a2_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a1_diff Bin_prot.Type_class.writer
        -> 'a2_diff Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a1_diff Bin_prot.Type_class.reader
        -> 'a2_diff Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a1_diff Bin_prot.Type_class.t
        -> 'a2_diff Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.t

      val quickcheck_generator
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

      val quickcheck_observer
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

      val quickcheck_shrinker
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
      -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
      -> from:('a1, 'a2) derived_on
      -> to_:('a1, 'a2) derived_on
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Optional_diff.t

    val apply_exn
      :  ('a1 -> 'a1_diff -> 'a1)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a1, 'a2) derived_on
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
      -> ('a1, 'a2) derived_on

    val of_list_exn
      :  ('a1_diff list -> 'a1_diff Optional_diff.t)
      -> ('a1 -> 'a1_diff -> 'a1)
      -> ('a2_diff list -> 'a2_diff Optional_diff.t)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t list
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Optional_diff.t

    val singleton
      :  ('a1, 'a2, 'a1_diff, 'a2_diff) Entry_diff.t
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t

    val create : ?t1:'a1_diff -> ?t2:'a2_diff -> unit -> ('a1, 'a2, 'a1_diff, 'a2_diff) t

    val create_of_variants
      :  t1:('a1_diff, ('a1, 'a2, 'a1_diff, 'a2_diff) Entry_diff.t) Of_variant.t
      -> t2:('a2_diff, ('a1, 'a2, 'a1_diff, 'a2_diff) Entry_diff.t) Of_variant.t
      -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
  end

  module For_inlined_tuple : sig
    type ('a1, 'a2) t = 'a1 Gel.t * 'a2 Gel.t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
      include Bin_prot.Binable.S2 with type ('a1, 'a2) t := ('a1, 'a2) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff : sig
      type ('a1, 'a2) derived_on = ('a1, 'a2) t

      type ('a1, 'a2, 'a1_diff, 'a2_diff) t = ('a1, 'a2, 'a1_diff, 'a2_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a1_diff, 'a2_diff) t) Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
        -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
        -> from:('a1, 'a2) derived_on
        -> to_:('a1, 'a2) derived_on
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Optional_diff.t

      val apply_exn
        :  ('a1 -> 'a1_diff -> 'a1)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a1, 'a2) derived_on
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t
        -> ('a1, 'a2) derived_on

      val of_list_exn
        :  ('a1_diff list -> 'a1_diff Optional_diff.t)
        -> ('a1 -> 'a1_diff -> 'a1)
        -> ('a2_diff list -> 'a2_diff Optional_diff.t)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t list
        -> ('a1, 'a2, 'a1_diff, 'a2_diff) t Optional_diff.t
    end
  end
end

module Tuple3 : sig
  type ('a1, 'a2, 'a3) t = 'a1 * 'a2 * 'a3 [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
    include Bin_prot.Binable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff : sig
    type ('a1, 'a2, 'a3) derived_on = ('a1, 'a2, 'a3) t

    module Entry_diff : sig
      type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32-60"]

        val t1 : 'a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        val t2 : 'a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        val t3 : 'a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        val is_t1 : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> bool
        val is_t2 : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> bool
        val is_t3 : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> bool
        val t1_val : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> 'a1_diff option
        val t2_val : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> 'a2_diff option
        val t3_val : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> 'a3_diff option

        module Variants : sig
          val t1
            : ('a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                Variantslib.Variant.t

          val t2
            : ('a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                Variantslib.Variant.t

          val t3
            : ('a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                Variantslib.Variant.t

          val fold
            :  init:'acc__0
            -> t1:
                 ('acc__0
                  -> ('a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__1)
            -> t2:
                 ('acc__1
                  -> ('a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__2)
            -> t3:
                 ('acc__2
                  -> ('a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__3)
            -> 'acc__3

          val iter
            :  t1:
                 (('a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> t3:
                 (('a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> unit

          val map
            :  ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
            -> t1:
                 (('a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'a1_diff
                  -> 'result__)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'a2_diff
                  -> 'result__)
            -> t3:
                 (('a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'a3_diff
                  -> 'result__)
            -> 'result__

          val make_matcher
            :  t1:
                 (('a1_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__0
                  -> ('a1_diff -> 'result__) * 'acc__1)
            -> t2:
                 (('a2_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__1
                  -> ('a2_diff -> 'result__) * 'acc__2)
            -> t3:
                 (('a3_diff -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__2
                  -> ('a3_diff -> 'result__) * 'acc__3)
            -> 'acc__0
            -> (('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> 'result__) * 'acc__3

          val to_rank : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> int
          val to_name : ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t -> string
          val descriptions : (string * int) list
        end

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
      private
      ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a1_diff Bin_prot.Type_class.writer
        -> 'a2_diff Bin_prot.Type_class.writer
        -> 'a3_diff Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a1_diff Bin_prot.Type_class.reader
        -> 'a2_diff Bin_prot.Type_class.reader
        -> 'a3_diff Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a1_diff Bin_prot.Type_class.t
        -> 'a2_diff Bin_prot.Type_class.t
        -> 'a3_diff Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.t

      val quickcheck_generator
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

      val quickcheck_observer
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

      val quickcheck_shrinker
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
      -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
      -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
      -> from:('a1, 'a2, 'a3) derived_on
      -> to_:('a1, 'a2, 'a3) derived_on
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Optional_diff.t

    val apply_exn
      :  ('a1 -> 'a1_diff -> 'a1)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a1, 'a2, 'a3) derived_on
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
      -> ('a1, 'a2, 'a3) derived_on

    val of_list_exn
      :  ('a1_diff list -> 'a1_diff Optional_diff.t)
      -> ('a1 -> 'a1_diff -> 'a1)
      -> ('a2_diff list -> 'a2_diff Optional_diff.t)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3_diff list -> 'a3_diff Optional_diff.t)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t list
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Optional_diff.t

    val singleton
      :  ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t

    val create
      :  ?t1:'a1_diff
      -> ?t2:'a2_diff
      -> ?t3:'a3_diff
      -> unit
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t

    val create_of_variants
      :  t1:
           ( 'a1_diff
             , ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t )
             Of_variant.t
      -> t2:
           ( 'a2_diff
             , ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t )
             Of_variant.t
      -> t3:
           ( 'a3_diff
             , ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Entry_diff.t )
             Of_variant.t
      -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
  end

  module For_inlined_tuple : sig
    type ('a1, 'a2, 'a3) t = 'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
      include Bin_prot.Binable.S3 with type ('a1, 'a2, 'a3) t := ('a1, 'a2, 'a3) t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff : sig
      type ('a1, 'a2, 'a3) derived_on = ('a1, 'a2, 'a3) t

      type ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t =
        ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t) Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
        -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
        -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
        -> from:('a1, 'a2, 'a3) derived_on
        -> to_:('a1, 'a2, 'a3) derived_on
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Optional_diff.t

      val apply_exn
        :  ('a1 -> 'a1_diff -> 'a1)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a1, 'a2, 'a3) derived_on
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t
        -> ('a1, 'a2, 'a3) derived_on

      val of_list_exn
        :  ('a1_diff list -> 'a1_diff Optional_diff.t)
        -> ('a1 -> 'a1_diff -> 'a1)
        -> ('a2_diff list -> 'a2_diff Optional_diff.t)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3_diff list -> 'a3_diff Optional_diff.t)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t list
        -> ('a1, 'a2, 'a3, 'a1_diff, 'a2_diff, 'a3_diff) t Optional_diff.t
    end
  end
end

module Tuple4 : sig
  type ('a1, 'a2, 'a3, 'a4) t = 'a1 * 'a2 * 'a3 * 'a4 [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

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
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff : sig
    type ('a1, 'a2, 'a3, 'a4) derived_on = ('a1, 'a2, 'a3, 'a4) t

    module Entry_diff : sig
      type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32-60"]

        val t1
          :  'a1_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val t2
          :  'a2_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val t3
          :  'a3_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val t4
          :  'a4_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val is_t1 : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t -> bool
        val is_t2 : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t -> bool
        val is_t3 : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t -> bool
        val is_t4 : ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t -> bool

        val t1_val
          :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> 'a1_diff option

        val t2_val
          :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> 'a2_diff option

        val t3_val
          :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> 'a3_diff option

        val t4_val
          :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> 'a4_diff option

        module Variants : sig
          val t1
            : ('a1_diff -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                Variantslib.Variant.t

          val t2
            : ('a2_diff -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                Variantslib.Variant.t

          val t3
            : ('a3_diff -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                Variantslib.Variant.t

          val t4
            : ('a4_diff -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                Variantslib.Variant.t

          val fold
            :  init:'acc__0
            -> t1:
                 ('acc__0
                  -> ('a1_diff
                      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__1)
            -> t2:
                 ('acc__1
                  -> ('a2_diff
                      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__2)
            -> t3:
                 ('acc__2
                  -> ('a3_diff
                      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__3)
            -> t4:
                 ('acc__3
                  -> ('a4_diff
                      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                       Variantslib.Variant.t
                  -> 'acc__4)
            -> 'acc__4

          val iter
            :  t1:
                 (('a1_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> t2:
                 (('a2_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> t3:
                 (('a3_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> t4:
                 (('a4_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> unit)
            -> unit

          val map
            :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
            -> t1:
                 (('a1_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'a1_diff
                  -> 'result__)
            -> t2:
                 (('a2_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'a2_diff
                  -> 'result__)
            -> t3:
                 (('a3_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'a3_diff
                  -> 'result__)
            -> t4:
                 (('a4_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'a4_diff
                  -> 'result__)
            -> 'result__

          val make_matcher
            :  t1:
                 (('a1_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__0
                  -> ('a1_diff -> 'result__) * 'acc__1)
            -> t2:
                 (('a2_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__1
                  -> ('a2_diff -> 'result__) * 'acc__2)
            -> t3:
                 (('a3_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__2
                  -> ('a3_diff -> 'result__) * 'acc__3)
            -> t4:
                 (('a4_diff
                   -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
                    Variantslib.Variant.t
                  -> 'acc__3
                  -> ('a4_diff -> 'result__) * 'acc__4)
            -> 'acc__0
            -> (('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
                -> 'result__)
               * 'acc__4

          val to_rank
            :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
            -> int

          val to_name
            :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
            -> string

          val descriptions : (string * int) list
        end

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
      private
      ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t list
    [@@deriving sexp, bin_io, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a4 Bin_prot.Type_class.writer
        -> 'a1_diff Bin_prot.Type_class.writer
        -> 'a2_diff Bin_prot.Type_class.writer
        -> 'a3_diff Bin_prot.Type_class.writer
        -> 'a4_diff Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
             Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a4 Bin_prot.Type_class.reader
        -> 'a1_diff Bin_prot.Type_class.reader
        -> 'a2_diff Bin_prot.Type_class.reader
        -> 'a3_diff Bin_prot.Type_class.reader
        -> 'a4_diff Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a4 Bin_prot.Type_class.t
        -> 'a1_diff Bin_prot.Type_class.t
        -> 'a2_diff Bin_prot.Type_class.t
        -> 'a3_diff Bin_prot.Type_class.t
        -> 'a4_diff Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Bin_prot.Type_class.t

      val quickcheck_generator
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

      val quickcheck_observer
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

      val quickcheck_shrinker
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
      -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
      -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
      -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
      -> from:('a1, 'a2, 'a3, 'a4) derived_on
      -> to_:('a1, 'a2, 'a3, 'a4) derived_on
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t Optional_diff.t

    val apply_exn
      :  ('a1 -> 'a1_diff -> 'a1)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a1, 'a2, 'a3, 'a4) derived_on
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
      -> ('a1, 'a2, 'a3, 'a4) derived_on

    val of_list_exn
      :  ('a1_diff list -> 'a1_diff Optional_diff.t)
      -> ('a1 -> 'a1_diff -> 'a1)
      -> ('a2_diff list -> 'a2_diff Optional_diff.t)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3_diff list -> 'a3_diff Optional_diff.t)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4_diff list -> 'a4_diff Optional_diff.t)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t list
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t Optional_diff.t

    val singleton
      :  ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

    val create
      :  ?t1:'a1_diff
      -> ?t2:'a2_diff
      -> ?t3:'a3_diff
      -> ?t4:'a4_diff
      -> unit
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

    val create_of_variants
      :  t1:
           ( 'a1_diff
             , ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t
             )
             Of_variant.t
      -> t2:
           ( 'a2_diff
             , ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t
             )
             Of_variant.t
      -> t3:
           ( 'a3_diff
             , ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t
             )
             Of_variant.t
      -> t4:
           ( 'a4_diff
             , ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Entry_diff.t
             )
             Of_variant.t
      -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
  end

  module For_inlined_tuple : sig
    type ('a1, 'a2, 'a3, 'a4) t = 'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t
    [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

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
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff : sig
      type ('a1, 'a2, 'a3, 'a4) derived_on = ('a1, 'a2, 'a3, 'a4) t

      type ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t =
        ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> (int -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
        -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
        -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
        -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
        -> from:('a1, 'a2, 'a3, 'a4) derived_on
        -> to_:('a1, 'a2, 'a3, 'a4) derived_on
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t Optional_diff.t

      val apply_exn
        :  ('a1 -> 'a1_diff -> 'a1)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a1, 'a2, 'a3, 'a4) derived_on
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t
        -> ('a1, 'a2, 'a3, 'a4) derived_on

      val of_list_exn
        :  ('a1_diff list -> 'a1_diff Optional_diff.t)
        -> ('a1 -> 'a1_diff -> 'a1)
        -> ('a2_diff list -> 'a2_diff Optional_diff.t)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3_diff list -> 'a3_diff Optional_diff.t)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4_diff list -> 'a4_diff Optional_diff.t)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t list
        -> ('a1, 'a2, 'a3, 'a4, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff) t Optional_diff.t
    end
  end
end

module Tuple5 : sig
  type ('a1, 'a2, 'a3, 'a4, 'a5) t = 'a1 * 'a2 * 'a3 * 'a4 * 'a5 [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t
      -> Sexplib0.Sexp.t

    val t_of_sexp
      :  (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> (Sexplib0.Sexp.t -> 'a5)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t

    val bin_shape_t
      :  Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t

    val bin_size_t
      :  'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> 'a5 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Size.sizer

    val bin_write_t
      :  'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> 'a5 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Write.writer

    val bin_writer_t
      :  'a1 Bin_prot.Type_class.writer
      -> 'a2 Bin_prot.Type_class.writer
      -> 'a3 Bin_prot.Type_class.writer
      -> 'a4 Bin_prot.Type_class.writer
      -> 'a5 Bin_prot.Type_class.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.writer

    val bin_read_t
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Read.reader

    val __bin_read_t__
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5) t) Bin_prot.Read.reader

    val bin_reader_t
      :  'a1 Bin_prot.Type_class.reader
      -> 'a2 Bin_prot.Type_class.reader
      -> 'a3 Bin_prot.Type_class.reader
      -> 'a4 Bin_prot.Type_class.reader
      -> 'a5 Bin_prot.Type_class.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.reader

    val bin_t
      :  'a1 Bin_prot.Type_class.t
      -> 'a2 Bin_prot.Type_class.t
      -> 'a3 Bin_prot.Type_class.t
      -> 'a4 Bin_prot.Type_class.t
      -> 'a5 Bin_prot.Type_class.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff : sig
    type ('a1, 'a2, 'a3, 'a4, 'a5) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5) t

    module Entry_diff : sig
      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
        | T5 of 'a5_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32-60"]

        val t1
          :  'a1_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val t2
          :  'a2_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val t3
          :  'a3_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val t4
          :  'a4_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val t5
          :  'a5_diff
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val is_t1
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> bool

        val is_t2
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> bool

        val is_t3
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> bool

        val is_t4
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> bool

        val is_t5
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> bool

        val t1_val
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> 'a1_diff option

        val t2_val
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> 'a2_diff option

        val t3_val
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> 'a3_diff option

        val t4_val
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> 'a4_diff option

        val t5_val
          :  ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> 'a5_diff option

        module Variants : sig
          val t1
            : ('a1_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff )
                    t)
                Variantslib.Variant.t

          val t2
            : ('a2_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff )
                    t)
                Variantslib.Variant.t

          val t3
            : ('a3_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff )
                    t)
                Variantslib.Variant.t

          val t4
            : ('a4_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff )
                    t)
                Variantslib.Variant.t

          val t5
            : ('a5_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff )
                    t)
                Variantslib.Variant.t

          val fold
            :  init:'acc__0
            -> t1:
                 ('acc__0
                  -> ('a1_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__1)
            -> t2:
                 ('acc__1
                  -> ('a2_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__2)
            -> t3:
                 ('acc__2
                  -> ('a3_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__3)
            -> t4:
                 ('acc__3
                  -> ('a4_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__4)
            -> t5:
                 ('acc__4
                  -> ('a5_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__5)
            -> 'acc__5

          val iter
            :  t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> unit

          val map
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 t
            -> t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a1_diff
                  -> 'result__)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a2_diff
                  -> 'result__)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a3_diff
                  -> 'result__)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a4_diff
                  -> 'result__)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a5_diff
                  -> 'result__)
            -> 'result__

          val make_matcher
            :  t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__0
                  -> ('a1_diff -> 'result__) * 'acc__1)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__1
                  -> ('a2_diff -> 'result__) * 'acc__2)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__2
                  -> ('a3_diff -> 'result__) * 'acc__3)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__3
                  -> ('a4_diff -> 'result__) * 'acc__4)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__4
                  -> ('a5_diff -> 'result__) * 'acc__5)
            -> 'acc__0
            -> (( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff )
                  t
                -> 'result__)
               * 'acc__5

          val to_rank
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 t
            -> int

          val to_name
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 t
            -> string

          val descriptions : (string * int) list
        end

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a5 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> 'a5_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff )
                   t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a5 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> 'a5_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a5 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> 'a5_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
      private
      ( 'a1
        , 'a2
        , 'a3
        , 'a4
        , 'a5
        , 'a1_diff
        , 'a2_diff
        , 'a3_diff
        , 'a4_diff
        , 'a5_diff )
        Entry_diff.t
        list
    [@@deriving sexp, bin_io, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a5_diff -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> (Sexplib0.Sexp.t -> 'a5_diff)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> 'a5_diff Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> 'a5_diff Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a4 Bin_prot.Type_class.writer
        -> 'a5 Bin_prot.Type_class.writer
        -> 'a1_diff Bin_prot.Type_class.writer
        -> 'a2_diff Bin_prot.Type_class.writer
        -> 'a3_diff Bin_prot.Type_class.writer
        -> 'a4_diff Bin_prot.Type_class.writer
        -> 'a5_diff Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> (int
            -> ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 t)
             Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a4 Bin_prot.Type_class.reader
        -> 'a5 Bin_prot.Type_class.reader
        -> 'a1_diff Bin_prot.Type_class.reader
        -> 'a2_diff Bin_prot.Type_class.reader
        -> 'a3_diff Bin_prot.Type_class.reader
        -> 'a4_diff Bin_prot.Type_class.reader
        -> 'a5_diff Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a4 Bin_prot.Type_class.t
        -> 'a5 Bin_prot.Type_class.t
        -> 'a1_diff Bin_prot.Type_class.t
        -> 'a2_diff Bin_prot.Type_class.t
        -> 'a3_diff Bin_prot.Type_class.t
        -> 'a4_diff Bin_prot.Type_class.t
        -> 'a5_diff Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Bin_prot.Type_class.t

      val quickcheck_generator
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

      val quickcheck_observer
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

      val quickcheck_shrinker
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
      -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
      -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
      -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
      -> (from:'a5 -> to_:'a5 -> 'a5_diff Optional_diff.t)
      -> from:('a1, 'a2, 'a3, 'a4, 'a5) derived_on
      -> to_:('a1, 'a2, 'a3, 'a4, 'a5) derived_on
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
           Optional_diff.t

    val apply_exn
      :  ('a1 -> 'a1_diff -> 'a1)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a5 -> 'a5_diff -> 'a5)
      -> ('a1, 'a2, 'a3, 'a4, 'a5) derived_on
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
      -> ('a1, 'a2, 'a3, 'a4, 'a5) derived_on

    val of_list_exn
      :  ('a1_diff list -> 'a1_diff Optional_diff.t)
      -> ('a1 -> 'a1_diff -> 'a1)
      -> ('a2_diff list -> 'a2_diff Optional_diff.t)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3_diff list -> 'a3_diff Optional_diff.t)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4_diff list -> 'a4_diff Optional_diff.t)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a5_diff list -> 'a5_diff Optional_diff.t)
      -> ('a5 -> 'a5_diff -> 'a5)
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
           list
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
           Optional_diff.t

    val singleton
      :  ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff )
           Entry_diff.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

    val create
      :  ?t1:'a1_diff
      -> ?t2:'a2_diff
      -> ?t3:'a3_diff
      -> ?t4:'a4_diff
      -> ?t5:'a5_diff
      -> unit
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

    val create_of_variants
      :  t1:
           ( 'a1_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t2:
           ( 'a2_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t3:
           ( 'a3_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t4:
           ( 'a4_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t5:
           ( 'a5_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff )
                 Entry_diff.t )
             Of_variant.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
  end

  module For_inlined_tuple : sig
    type ('a1, 'a2, 'a3, 'a4, 'a5) t =
      'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t * 'a5 Gel.t
    [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a4 Bin_prot.Type_class.writer
        -> 'a5 Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5) t) Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a4 Bin_prot.Type_class.reader
        -> 'a5 Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a4 Bin_prot.Type_class.t
        -> 'a5 Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5) t Bin_prot.Type_class.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff : sig
      type ('a1, 'a2, 'a3, 'a4, 'a5) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5) t

      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t =
        ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> Sexplib0.Sexp.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a5 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> 'a5_diff Bin_prot.Type_class.writer
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff )
                   t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a5 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> 'a5_diff Bin_prot.Type_class.reader
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a5 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> 'a5_diff Bin_prot.Type_class.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
        -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
        -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
        -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
        -> (from:'a5 -> to_:'a5 -> 'a5_diff Optional_diff.t)
        -> from:('a1, 'a2, 'a3, 'a4, 'a5) derived_on
        -> to_:('a1, 'a2, 'a3, 'a4, 'a5) derived_on
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Optional_diff.t

      val apply_exn
        :  ('a1 -> 'a1_diff -> 'a1)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a5 -> 'a5_diff -> 'a5)
        -> ('a1, 'a2, 'a3, 'a4, 'a5) derived_on
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
        -> ('a1, 'a2, 'a3, 'a4, 'a5) derived_on

      val of_list_exn
        :  ('a1_diff list -> 'a1_diff Optional_diff.t)
        -> ('a1 -> 'a1_diff -> 'a1)
        -> ('a2_diff list -> 'a2_diff Optional_diff.t)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3_diff list -> 'a3_diff Optional_diff.t)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4_diff list -> 'a4_diff Optional_diff.t)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a5_diff list -> 'a5_diff Optional_diff.t)
        -> ('a5 -> 'a5_diff -> 'a5)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             list
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a1_diff, 'a2_diff, 'a3_diff, 'a4_diff, 'a5_diff) t
             Optional_diff.t
    end
  end
end

module Tuple6 : sig
  type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t = 'a1 * 'a2 * 'a3 * 'a4 * 'a5 * 'a6
  [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('a1 -> Sexplib0.Sexp.t)
      -> ('a2 -> Sexplib0.Sexp.t)
      -> ('a3 -> Sexplib0.Sexp.t)
      -> ('a4 -> Sexplib0.Sexp.t)
      -> ('a5 -> Sexplib0.Sexp.t)
      -> ('a6 -> Sexplib0.Sexp.t)
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
      -> Sexplib0.Sexp.t

    val t_of_sexp
      :  (Sexplib0.Sexp.t -> 'a1)
      -> (Sexplib0.Sexp.t -> 'a2)
      -> (Sexplib0.Sexp.t -> 'a3)
      -> (Sexplib0.Sexp.t -> 'a4)
      -> (Sexplib0.Sexp.t -> 'a5)
      -> (Sexplib0.Sexp.t -> 'a6)
      -> Sexplib0.Sexp.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

    val bin_shape_t
      :  Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t
      -> Bin_prot.Shape.t

    val bin_size_t
      :  'a1 Bin_prot.Size.sizer
      -> 'a2 Bin_prot.Size.sizer
      -> 'a3 Bin_prot.Size.sizer
      -> 'a4 Bin_prot.Size.sizer
      -> 'a5 Bin_prot.Size.sizer
      -> 'a6 Bin_prot.Size.sizer
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Size.sizer

    val bin_write_t
      :  'a1 Bin_prot.Write.writer
      -> 'a2 Bin_prot.Write.writer
      -> 'a3 Bin_prot.Write.writer
      -> 'a4 Bin_prot.Write.writer
      -> 'a5 Bin_prot.Write.writer
      -> 'a6 Bin_prot.Write.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Write.writer

    val bin_writer_t
      :  'a1 Bin_prot.Type_class.writer
      -> 'a2 Bin_prot.Type_class.writer
      -> 'a3 Bin_prot.Type_class.writer
      -> 'a4 Bin_prot.Type_class.writer
      -> 'a5 Bin_prot.Type_class.writer
      -> 'a6 Bin_prot.Type_class.writer
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.writer

    val bin_read_t
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> 'a6 Bin_prot.Read.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Read.reader

    val __bin_read_t__
      :  'a1 Bin_prot.Read.reader
      -> 'a2 Bin_prot.Read.reader
      -> 'a3 Bin_prot.Read.reader
      -> 'a4 Bin_prot.Read.reader
      -> 'a5 Bin_prot.Read.reader
      -> 'a6 Bin_prot.Read.reader
      -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) Bin_prot.Read.reader

    val bin_reader_t
      :  'a1 Bin_prot.Type_class.reader
      -> 'a2 Bin_prot.Type_class.reader
      -> 'a3 Bin_prot.Type_class.reader
      -> 'a4 Bin_prot.Type_class.reader
      -> 'a5 Bin_prot.Type_class.reader
      -> 'a6 Bin_prot.Type_class.reader
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.reader

    val bin_t
      :  'a1 Bin_prot.Type_class.t
      -> 'a2 Bin_prot.Type_class.t
      -> 'a3 Bin_prot.Type_class.t
      -> 'a4 Bin_prot.Type_class.t
      -> 'a5 Bin_prot.Type_class.t
      -> 'a6 Bin_prot.Type_class.t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff : sig
    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

    module Entry_diff : sig
      type ('a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff)
           t =
        | T1 of 'a1_diff
        | T2 of 'a2_diff
        | T3 of 'a3_diff
        | T4 of 'a4_diff
        | T5 of 'a5_diff
        | T6 of 'a6_diff
      [@@deriving variants, sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32-60"]

        val t1
          :  'a1_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val t2
          :  'a2_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val t3
          :  'a3_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val t4
          :  'a4_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val t5
          :  'a5_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val t6
          :  'a6_diff
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val is_t1
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val is_t2
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val is_t3
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val is_t4
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val is_t5
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val is_t6
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> bool

        val t1_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a1_diff option

        val t2_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a2_diff option

        val t3_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a3_diff option

        val t4_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a4_diff option

        val t5_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a5_diff option

        val t6_val
          :  ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> 'a6_diff option

        module Variants : sig
          val t1
            : ('a1_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val t2
            : ('a2_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val t3
            : ('a3_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val t4
            : ('a4_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val t5
            : ('a5_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val t6
            : ('a6_diff
               -> ( 'a1
                    , 'a2
                    , 'a3
                    , 'a4
                    , 'a5
                    , 'a6
                    , 'a1_diff
                    , 'a2_diff
                    , 'a3_diff
                    , 'a4_diff
                    , 'a5_diff
                    , 'a6_diff )
                    t)
                Variantslib.Variant.t

          val fold
            :  init:'acc__0
            -> t1:
                 ('acc__0
                  -> ('a1_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__1)
            -> t2:
                 ('acc__1
                  -> ('a2_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__2)
            -> t3:
                 ('acc__2
                  -> ('a3_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__3)
            -> t4:
                 ('acc__3
                  -> ('a4_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__4)
            -> t5:
                 ('acc__4
                  -> ('a5_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__5)
            -> t6:
                 ('acc__5
                  -> ('a6_diff
                      -> ( 'a1
                           , 'a2
                           , 'a3
                           , 'a4
                           , 'a5
                           , 'a6
                           , 'a1_diff
                           , 'a2_diff
                           , 'a3_diff
                           , 'a4_diff
                           , 'a5_diff
                           , 'a6_diff )
                           t)
                       Variantslib.Variant.t
                  -> 'acc__6)
            -> 'acc__6

          val iter
            :  t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> t6:
                 (('a6_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> unit)
            -> unit

          val map
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 t
            -> t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a1_diff
                  -> 'result__)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a2_diff
                  -> 'result__)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a3_diff
                  -> 'result__)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a4_diff
                  -> 'result__)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a5_diff
                  -> 'result__)
            -> t6:
                 (('a6_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'a6_diff
                  -> 'result__)
            -> 'result__

          val make_matcher
            :  t1:
                 (('a1_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__0
                  -> ('a1_diff -> 'result__) * 'acc__1)
            -> t2:
                 (('a2_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__1
                  -> ('a2_diff -> 'result__) * 'acc__2)
            -> t3:
                 (('a3_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__2
                  -> ('a3_diff -> 'result__) * 'acc__3)
            -> t4:
                 (('a4_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__3
                  -> ('a4_diff -> 'result__) * 'acc__4)
            -> t5:
                 (('a5_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__4
                  -> ('a5_diff -> 'result__) * 'acc__5)
            -> t6:
                 (('a6_diff
                   -> ( 'a1
                        , 'a2
                        , 'a3
                        , 'a4
                        , 'a5
                        , 'a6
                        , 'a1_diff
                        , 'a2_diff
                        , 'a3_diff
                        , 'a4_diff
                        , 'a5_diff
                        , 'a6_diff )
                        t)
                    Variantslib.Variant.t
                  -> 'acc__5
                  -> ('a6_diff -> 'result__) * 'acc__6)
            -> 'acc__0
            -> (( 'a1
                  , 'a2
                  , 'a3
                  , 'a4
                  , 'a5
                  , 'a6
                  , 'a1_diff
                  , 'a2_diff
                  , 'a3_diff
                  , 'a4_diff
                  , 'a5_diff
                  , 'a6_diff )
                  t
                -> 'result__)
               * 'acc__6

          val to_rank
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 t
            -> int

          val to_name
            :  ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 t
            -> string

          val descriptions : (string * int) list
        end

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a6 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a6_diff -> Sexplib0.Sexp.t)
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a6)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> (Sexplib0.Sexp.t -> 'a6_diff)
          -> Sexplib0.Sexp.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a6 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> 'a6_diff Bin_prot.Size.sizer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a6 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> 'a6_diff Bin_prot.Write.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a5 Bin_prot.Type_class.writer
          -> 'a6 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> 'a5_diff Bin_prot.Type_class.writer
          -> 'a6_diff Bin_prot.Type_class.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a6
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff
                   , 'a6_diff )
                   t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a5 Bin_prot.Type_class.reader
          -> 'a6 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> 'a5_diff Bin_prot.Type_class.reader
          -> 'a6_diff Bin_prot.Type_class.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a5 Bin_prot.Type_class.t
          -> 'a6 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> 'a5_diff Bin_prot.Type_class.t
          -> 'a6_diff Bin_prot.Type_class.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('a1
         , 'a2
         , 'a3
         , 'a4
         , 'a5
         , 'a6
         , 'a1_diff
         , 'a2_diff
         , 'a3_diff
         , 'a4_diff
         , 'a5_diff
         , 'a6_diff)
         t =
      private
      ( 'a1
        , 'a2
        , 'a3
        , 'a4
        , 'a5
        , 'a6
        , 'a1_diff
        , 'a2_diff
        , 'a3_diff
        , 'a4_diff
        , 'a5_diff
        , 'a6_diff )
        Entry_diff.t
        list
    [@@deriving sexp, bin_io, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a6 -> Sexplib0.Sexp.t)
        -> ('a1_diff -> Sexplib0.Sexp.t)
        -> ('a2_diff -> Sexplib0.Sexp.t)
        -> ('a3_diff -> Sexplib0.Sexp.t)
        -> ('a4_diff -> Sexplib0.Sexp.t)
        -> ('a5_diff -> Sexplib0.Sexp.t)
        -> ('a6_diff -> Sexplib0.Sexp.t)
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a6)
        -> (Sexplib0.Sexp.t -> 'a1_diff)
        -> (Sexplib0.Sexp.t -> 'a2_diff)
        -> (Sexplib0.Sexp.t -> 'a3_diff)
        -> (Sexplib0.Sexp.t -> 'a4_diff)
        -> (Sexplib0.Sexp.t -> 'a5_diff)
        -> (Sexplib0.Sexp.t -> 'a6_diff)
        -> Sexplib0.Sexp.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a6 Bin_prot.Size.sizer
        -> 'a1_diff Bin_prot.Size.sizer
        -> 'a2_diff Bin_prot.Size.sizer
        -> 'a3_diff Bin_prot.Size.sizer
        -> 'a4_diff Bin_prot.Size.sizer
        -> 'a5_diff Bin_prot.Size.sizer
        -> 'a6_diff Bin_prot.Size.sizer
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a6 Bin_prot.Write.writer
        -> 'a1_diff Bin_prot.Write.writer
        -> 'a2_diff Bin_prot.Write.writer
        -> 'a3_diff Bin_prot.Write.writer
        -> 'a4_diff Bin_prot.Write.writer
        -> 'a5_diff Bin_prot.Write.writer
        -> 'a6_diff Bin_prot.Write.writer
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a4 Bin_prot.Type_class.writer
        -> 'a5 Bin_prot.Type_class.writer
        -> 'a6 Bin_prot.Type_class.writer
        -> 'a1_diff Bin_prot.Type_class.writer
        -> 'a2_diff Bin_prot.Type_class.writer
        -> 'a3_diff Bin_prot.Type_class.writer
        -> 'a4_diff Bin_prot.Type_class.writer
        -> 'a5_diff Bin_prot.Type_class.writer
        -> 'a6_diff Bin_prot.Type_class.writer
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> 'a6_diff Bin_prot.Read.reader
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> 'a1_diff Bin_prot.Read.reader
        -> 'a2_diff Bin_prot.Read.reader
        -> 'a3_diff Bin_prot.Read.reader
        -> 'a4_diff Bin_prot.Read.reader
        -> 'a5_diff Bin_prot.Read.reader
        -> 'a6_diff Bin_prot.Read.reader
        -> (int
            -> ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 t)
             Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a4 Bin_prot.Type_class.reader
        -> 'a5 Bin_prot.Type_class.reader
        -> 'a6 Bin_prot.Type_class.reader
        -> 'a1_diff Bin_prot.Type_class.reader
        -> 'a2_diff Bin_prot.Type_class.reader
        -> 'a3_diff Bin_prot.Type_class.reader
        -> 'a4_diff Bin_prot.Type_class.reader
        -> 'a5_diff Bin_prot.Type_class.reader
        -> 'a6_diff Bin_prot.Type_class.reader
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a4 Bin_prot.Type_class.t
        -> 'a5 Bin_prot.Type_class.t
        -> 'a6 Bin_prot.Type_class.t
        -> 'a1_diff Bin_prot.Type_class.t
        -> 'a2_diff Bin_prot.Type_class.t
        -> 'a3_diff Bin_prot.Type_class.t
        -> 'a4_diff Bin_prot.Type_class.t
        -> 'a5_diff Bin_prot.Type_class.t
        -> 'a6_diff Bin_prot.Type_class.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Bin_prot.Type_class.t

      val quickcheck_generator
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

      val quickcheck_observer
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

      val quickcheck_shrinker
        :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
      -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
      -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
      -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
      -> (from:'a5 -> to_:'a5 -> 'a5_diff Optional_diff.t)
      -> (from:'a6 -> to_:'a6 -> 'a6_diff Optional_diff.t)
      -> from:('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
      -> to_:('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t
           Optional_diff.t

    val apply_exn
      :  ('a1 -> 'a1_diff -> 'a1)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a5 -> 'a5_diff -> 'a5)
      -> ('a6 -> 'a6_diff -> 'a6)
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t
      -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on

    val of_list_exn
      :  ('a1_diff list -> 'a1_diff Optional_diff.t)
      -> ('a1 -> 'a1_diff -> 'a1)
      -> ('a2_diff list -> 'a2_diff Optional_diff.t)
      -> ('a2 -> 'a2_diff -> 'a2)
      -> ('a3_diff list -> 'a3_diff Optional_diff.t)
      -> ('a3 -> 'a3_diff -> 'a3)
      -> ('a4_diff list -> 'a4_diff Optional_diff.t)
      -> ('a4 -> 'a4_diff -> 'a4)
      -> ('a5_diff list -> 'a5_diff Optional_diff.t)
      -> ('a5 -> 'a5_diff -> 'a5)
      -> ('a6_diff list -> 'a6_diff Optional_diff.t)
      -> ('a6 -> 'a6_diff -> 'a6)
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t
           list
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t
           Optional_diff.t

    val singleton
      :  ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           Entry_diff.t
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t

    val create
      :  ?t1:'a1_diff
      -> ?t2:'a2_diff
      -> ?t3:'a3_diff
      -> ?t4:'a4_diff
      -> ?t5:'a5_diff
      -> ?t6:'a6_diff
      -> unit
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t

    val create_of_variants
      :  t1:
           ( 'a1_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t2:
           ( 'a2_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t3:
           ( 'a3_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t4:
           ( 'a4_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t5:
           ( 'a5_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> t6:
           ( 'a6_diff
             , ( 'a1
                 , 'a2
                 , 'a3
                 , 'a4
                 , 'a5
                 , 'a6
                 , 'a1_diff
                 , 'a2_diff
                 , 'a3_diff
                 , 'a4_diff
                 , 'a5_diff
                 , 'a6_diff )
                 Entry_diff.t )
             Of_variant.t
      -> ( 'a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff )
           t
  end

  module For_inlined_tuple : sig
    type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t =
      'a1 Gel.t * 'a2 Gel.t * 'a3 Gel.t * 'a4 Gel.t * 'a5 Gel.t * 'a6 Gel.t
    [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a1 -> Sexplib0.Sexp.t)
        -> ('a2 -> Sexplib0.Sexp.t)
        -> ('a3 -> Sexplib0.Sexp.t)
        -> ('a4 -> Sexplib0.Sexp.t)
        -> ('a5 -> Sexplib0.Sexp.t)
        -> ('a6 -> Sexplib0.Sexp.t)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a1)
        -> (Sexplib0.Sexp.t -> 'a2)
        -> (Sexplib0.Sexp.t -> 'a3)
        -> (Sexplib0.Sexp.t -> 'a4)
        -> (Sexplib0.Sexp.t -> 'a5)
        -> (Sexplib0.Sexp.t -> 'a6)
        -> Sexplib0.Sexp.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

      val bin_shape_t
        :  Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t
        -> Bin_prot.Shape.t

      val bin_size_t
        :  'a1 Bin_prot.Size.sizer
        -> 'a2 Bin_prot.Size.sizer
        -> 'a3 Bin_prot.Size.sizer
        -> 'a4 Bin_prot.Size.sizer
        -> 'a5 Bin_prot.Size.sizer
        -> 'a6 Bin_prot.Size.sizer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Size.sizer

      val bin_write_t
        :  'a1 Bin_prot.Write.writer
        -> 'a2 Bin_prot.Write.writer
        -> 'a3 Bin_prot.Write.writer
        -> 'a4 Bin_prot.Write.writer
        -> 'a5 Bin_prot.Write.writer
        -> 'a6 Bin_prot.Write.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Write.writer

      val bin_writer_t
        :  'a1 Bin_prot.Type_class.writer
        -> 'a2 Bin_prot.Type_class.writer
        -> 'a3 Bin_prot.Type_class.writer
        -> 'a4 Bin_prot.Type_class.writer
        -> 'a5 Bin_prot.Type_class.writer
        -> 'a6 Bin_prot.Type_class.writer
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.writer

      val bin_read_t
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Read.reader

      val __bin_read_t__
        :  'a1 Bin_prot.Read.reader
        -> 'a2 Bin_prot.Read.reader
        -> 'a3 Bin_prot.Read.reader
        -> 'a4 Bin_prot.Read.reader
        -> 'a5 Bin_prot.Read.reader
        -> 'a6 Bin_prot.Read.reader
        -> (int -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t) Bin_prot.Read.reader

      val bin_reader_t
        :  'a1 Bin_prot.Type_class.reader
        -> 'a2 Bin_prot.Type_class.reader
        -> 'a3 Bin_prot.Type_class.reader
        -> 'a4 Bin_prot.Type_class.reader
        -> 'a5 Bin_prot.Type_class.reader
        -> 'a6 Bin_prot.Type_class.reader
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.reader

      val bin_t
        :  'a1 Bin_prot.Type_class.t
        -> 'a2 Bin_prot.Type_class.t
        -> 'a3 Bin_prot.Type_class.t
        -> 'a4 Bin_prot.Type_class.t
        -> 'a5 Bin_prot.Type_class.t
        -> 'a6 Bin_prot.Type_class.t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t Bin_prot.Type_class.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Diff : sig
      type ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on = ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) t

      type ('a1
           , 'a2
           , 'a3
           , 'a4
           , 'a5
           , 'a6
           , 'a1_diff
           , 'a2_diff
           , 'a3_diff
           , 'a4_diff
           , 'a5_diff
           , 'a6_diff)
           t =
        ( 'a1
          , 'a2
          , 'a3
          , 'a4
          , 'a5
          , 'a6
          , 'a1_diff
          , 'a2_diff
          , 'a3_diff
          , 'a4_diff
          , 'a5_diff
          , 'a6_diff )
          Diff.t
      [@@deriving sexp, bin_io, quickcheck]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a1 -> Sexplib0.Sexp.t)
          -> ('a2 -> Sexplib0.Sexp.t)
          -> ('a3 -> Sexplib0.Sexp.t)
          -> ('a4 -> Sexplib0.Sexp.t)
          -> ('a5 -> Sexplib0.Sexp.t)
          -> ('a6 -> Sexplib0.Sexp.t)
          -> ('a1_diff -> Sexplib0.Sexp.t)
          -> ('a2_diff -> Sexplib0.Sexp.t)
          -> ('a3_diff -> Sexplib0.Sexp.t)
          -> ('a4_diff -> Sexplib0.Sexp.t)
          -> ('a5_diff -> Sexplib0.Sexp.t)
          -> ('a6_diff -> Sexplib0.Sexp.t)
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          :  (Sexplib0.Sexp.t -> 'a1)
          -> (Sexplib0.Sexp.t -> 'a2)
          -> (Sexplib0.Sexp.t -> 'a3)
          -> (Sexplib0.Sexp.t -> 'a4)
          -> (Sexplib0.Sexp.t -> 'a5)
          -> (Sexplib0.Sexp.t -> 'a6)
          -> (Sexplib0.Sexp.t -> 'a1_diff)
          -> (Sexplib0.Sexp.t -> 'a2_diff)
          -> (Sexplib0.Sexp.t -> 'a3_diff)
          -> (Sexplib0.Sexp.t -> 'a4_diff)
          -> (Sexplib0.Sexp.t -> 'a5_diff)
          -> (Sexplib0.Sexp.t -> 'a6_diff)
          -> Sexplib0.Sexp.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t

        val bin_shape_t
          :  Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t
          -> Bin_prot.Shape.t

        val bin_size_t
          :  'a1 Bin_prot.Size.sizer
          -> 'a2 Bin_prot.Size.sizer
          -> 'a3 Bin_prot.Size.sizer
          -> 'a4 Bin_prot.Size.sizer
          -> 'a5 Bin_prot.Size.sizer
          -> 'a6 Bin_prot.Size.sizer
          -> 'a1_diff Bin_prot.Size.sizer
          -> 'a2_diff Bin_prot.Size.sizer
          -> 'a3_diff Bin_prot.Size.sizer
          -> 'a4_diff Bin_prot.Size.sizer
          -> 'a5_diff Bin_prot.Size.sizer
          -> 'a6_diff Bin_prot.Size.sizer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Size.sizer

        val bin_write_t
          :  'a1 Bin_prot.Write.writer
          -> 'a2 Bin_prot.Write.writer
          -> 'a3 Bin_prot.Write.writer
          -> 'a4 Bin_prot.Write.writer
          -> 'a5 Bin_prot.Write.writer
          -> 'a6 Bin_prot.Write.writer
          -> 'a1_diff Bin_prot.Write.writer
          -> 'a2_diff Bin_prot.Write.writer
          -> 'a3_diff Bin_prot.Write.writer
          -> 'a4_diff Bin_prot.Write.writer
          -> 'a5_diff Bin_prot.Write.writer
          -> 'a6_diff Bin_prot.Write.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Write.writer

        val bin_writer_t
          :  'a1 Bin_prot.Type_class.writer
          -> 'a2 Bin_prot.Type_class.writer
          -> 'a3 Bin_prot.Type_class.writer
          -> 'a4 Bin_prot.Type_class.writer
          -> 'a5 Bin_prot.Type_class.writer
          -> 'a6 Bin_prot.Type_class.writer
          -> 'a1_diff Bin_prot.Type_class.writer
          -> 'a2_diff Bin_prot.Type_class.writer
          -> 'a3_diff Bin_prot.Type_class.writer
          -> 'a4_diff Bin_prot.Type_class.writer
          -> 'a5_diff Bin_prot.Type_class.writer
          -> 'a6_diff Bin_prot.Type_class.writer
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.writer

        val bin_read_t
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Read.reader

        val __bin_read_t__
          :  'a1 Bin_prot.Read.reader
          -> 'a2 Bin_prot.Read.reader
          -> 'a3 Bin_prot.Read.reader
          -> 'a4 Bin_prot.Read.reader
          -> 'a5 Bin_prot.Read.reader
          -> 'a6 Bin_prot.Read.reader
          -> 'a1_diff Bin_prot.Read.reader
          -> 'a2_diff Bin_prot.Read.reader
          -> 'a3_diff Bin_prot.Read.reader
          -> 'a4_diff Bin_prot.Read.reader
          -> 'a5_diff Bin_prot.Read.reader
          -> 'a6_diff Bin_prot.Read.reader
          -> (int
              -> ( 'a1
                   , 'a2
                   , 'a3
                   , 'a4
                   , 'a5
                   , 'a6
                   , 'a1_diff
                   , 'a2_diff
                   , 'a3_diff
                   , 'a4_diff
                   , 'a5_diff
                   , 'a6_diff )
                   t)
               Bin_prot.Read.reader

        val bin_reader_t
          :  'a1 Bin_prot.Type_class.reader
          -> 'a2 Bin_prot.Type_class.reader
          -> 'a3 Bin_prot.Type_class.reader
          -> 'a4 Bin_prot.Type_class.reader
          -> 'a5 Bin_prot.Type_class.reader
          -> 'a6 Bin_prot.Type_class.reader
          -> 'a1_diff Bin_prot.Type_class.reader
          -> 'a2_diff Bin_prot.Type_class.reader
          -> 'a3_diff Bin_prot.Type_class.reader
          -> 'a4_diff Bin_prot.Type_class.reader
          -> 'a5_diff Bin_prot.Type_class.reader
          -> 'a6_diff Bin_prot.Type_class.reader
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.reader

        val bin_t
          :  'a1 Bin_prot.Type_class.t
          -> 'a2 Bin_prot.Type_class.t
          -> 'a3 Bin_prot.Type_class.t
          -> 'a4 Bin_prot.Type_class.t
          -> 'a5 Bin_prot.Type_class.t
          -> 'a6 Bin_prot.Type_class.t
          -> 'a1_diff Bin_prot.Type_class.t
          -> 'a2_diff Bin_prot.Type_class.t
          -> 'a3_diff Bin_prot.Type_class.t
          -> 'a4_diff Bin_prot.Type_class.t
          -> 'a5_diff Bin_prot.Type_class.t
          -> 'a6_diff Bin_prot.Type_class.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Bin_prot.Type_class.t

        val quickcheck_generator
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Generator.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Generator.t

        val quickcheck_observer
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Observer.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.t

        val quickcheck_shrinker
          :  'a1 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a6 Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a1_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a2_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a3_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a4_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a5_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> 'a6_diff Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
          -> ( 'a1
               , 'a2
               , 'a3
               , 'a4
               , 'a5
               , 'a6
               , 'a1_diff
               , 'a2_diff
               , 'a3_diff
               , 'a4_diff
               , 'a5_diff
               , 'a6_diff )
               t
               Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val get
        :  (from:'a1 -> to_:'a1 -> 'a1_diff Optional_diff.t)
        -> (from:'a2 -> to_:'a2 -> 'a2_diff Optional_diff.t)
        -> (from:'a3 -> to_:'a3 -> 'a3_diff Optional_diff.t)
        -> (from:'a4 -> to_:'a4 -> 'a4_diff Optional_diff.t)
        -> (from:'a5 -> to_:'a5 -> 'a5_diff Optional_diff.t)
        -> (from:'a6 -> to_:'a6 -> 'a6_diff Optional_diff.t)
        -> from:('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
        -> to_:('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Optional_diff.t

      val apply_exn
        :  ('a1 -> 'a1_diff -> 'a1)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a5 -> 'a5_diff -> 'a5)
        -> ('a6 -> 'a6_diff -> 'a6)
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
        -> ('a1, 'a2, 'a3, 'a4, 'a5, 'a6) derived_on

      val of_list_exn
        :  ('a1_diff list -> 'a1_diff Optional_diff.t)
        -> ('a1 -> 'a1_diff -> 'a1)
        -> ('a2_diff list -> 'a2_diff Optional_diff.t)
        -> ('a2 -> 'a2_diff -> 'a2)
        -> ('a3_diff list -> 'a3_diff Optional_diff.t)
        -> ('a3 -> 'a3_diff -> 'a3)
        -> ('a4_diff list -> 'a4_diff Optional_diff.t)
        -> ('a4 -> 'a4_diff -> 'a4)
        -> ('a5_diff list -> 'a5_diff Optional_diff.t)
        -> ('a5 -> 'a5_diff -> 'a5)
        -> ('a6_diff list -> 'a6_diff Optional_diff.t)
        -> ('a6 -> 'a6_diff -> 'a6)
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             list
        -> ( 'a1
             , 'a2
             , 'a3
             , 'a4
             , 'a5
             , 'a6
             , 'a1_diff
             , 'a2_diff
             , 'a3_diff
             , 'a4_diff
             , 'a5_diff
             , 'a6_diff )
             t
             Optional_diff.t
    end
  end
end
