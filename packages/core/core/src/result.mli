[@@@ocaml.text " This module extends {{!Base.Result}[Base.Result]}. "]

open! Import

type ('a, 'b) t = ('a, 'b) Base.Result.t =
  | Ok of 'a
  | Error of 'b
[@@deriving bin_io ~localize, compare, equal, globalize, hash, typerep, sexp, diff]

include sig
  [@@@ocaml.warning "-32-60"]

  include Bin_prot.Binable.S_local2 with type ('a, 'b) t := ('a, 'b) t
  include Ppx_compare_lib.Comparable.S2 with type ('a, 'b) t := ('a, 'b) t
  include Ppx_compare_lib.Equal.S2 with type ('a, 'b) t := ('a, 'b) t

  val globalize : ('a -> 'a) -> ('b -> 'b) -> ('a, 'b) t -> ('a, 'b) t

  include Ppx_hash_lib.Hashable.S2 with type ('a, 'b) t := ('a, 'b) t
  include Typerep_lib.Typerepable.S2 with type ('a, 'b) t := ('a, 'b) t
  include Sexplib0.Sexpable.S2 with type ('a, 'b) t := ('a, 'b) t

  module Diff : sig
    open! Diffable.For_ppx

    type ('a, 'b) derived_on = ('a, 'b) t

    type ('a, 'b, 'a_diff, 'b_diff) t =
      | Set_to_ok of 'a
      | Set_to_error of 'b
      | Diff_ok of 'a_diff
      | Diff_error of 'b_diff
    [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

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
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> (from:'b -> to_:'b -> ('b_diff Optional_diff.t[@jane.erasable.mode local]))
      -> from:('a, 'b) derived_on
      -> to_:('a, 'b) derived_on
      -> (('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t[@jane.erasable.mode local])

    val apply_exn
      :  ('a -> 'a_diff -> 'a)
      -> ('b -> 'b_diff -> 'b)
      -> ('a, 'b) derived_on
      -> ('a, 'b, 'a_diff, 'b_diff) t
      -> ('a, 'b) derived_on

    val of_list_exn
      :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> ('a -> 'a_diff -> 'a)
      -> ('b_diff list -> ('b_diff Optional_diff.t[@jane.erasable.mode local]))
      -> ('b -> 'b_diff -> 'b)
      -> ('a, 'b, 'a_diff, 'b_diff) t list
      -> (('a, 'b, 'a_diff, 'b_diff) t Optional_diff.t[@jane.erasable.mode local])
  end
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  module type of Base.Result with type ('a, 'b) t := ('a, 'b) t
[@@ocaml.doc " @inline "]

module Stable : sig
  module V1 : sig
    type nonrec ('ok, 'err) t = ('ok, 'err) t =
      | Ok of 'ok
      | Error of 'err
    [@@deriving bin_io ~localize, equal, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local2 with type ('ok, 'err) t := ('ok, 'err) t
      include Ppx_compare_lib.Equal.S2 with type ('ok, 'err) t := ('ok, 'err) t

      val t_sexp_grammar
        :  'ok Sexplib0.Sexp_grammar.t
        -> 'err Sexplib0.Sexp_grammar.t
        -> ('ok, 'err) t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_module_types.With_stable_witness.S2 with type ('ok, 'err) t := ('ok, 'err) t

    include
      Diffable.S2
      with type ('ok, 'err) t := ('ok, 'err) t
       and type ('ok, 'err, 'ok_diff, 'err_diff) Diff.t =
        ('ok, 'err, 'ok_diff, 'err_diff) Diff.t
  end

  module V1_stable_unit_test : Stable_unit_test_intf.Arg
  [@@ocaml.doc
    " We export the unit test arg rather than instantiate the functor inside result.ml in\n\
    \      order to avoid circular dependencies.  The functor is instantiated in \
     stable.ml. "]
end
