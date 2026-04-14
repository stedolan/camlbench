open Base

module type S_with_quickcheck = sig
  type t [@@deriving quickcheck]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Diff_intf.S with type t := t
end

module Diff_of_bool : S_with_quickcheck with type derived_on = bool and type t = bool
module Diff_of_char : S_with_quickcheck with type derived_on = char and type t = char
module Diff_of_float : S_with_quickcheck with type derived_on = float and type t = float
module Diff_of_int : S_with_quickcheck with type derived_on = int and type t = int

module Diff_of_string :
  S_with_quickcheck with type derived_on = string and type t = string

module Diff_of_unit : S_with_quickcheck with type derived_on = unit and type t = unit

module Diff_of_option : sig
  type 'a derived_on = 'a option [@@deriving sexp, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_derived_on : ('a -> Sexplib0.Sexp.t) -> 'a derived_on -> Sexplib0.Sexp.t
    val derived_on_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a derived_on
    val bin_shape_derived_on : Bin_prot.Shape.t -> Bin_prot.Shape.t
    val bin_size_derived_on : 'a Bin_prot.Size.sizer -> 'a derived_on Bin_prot.Size.sizer

    val bin_write_derived_on
      :  'a Bin_prot.Write.writer
      -> 'a derived_on Bin_prot.Write.writer

    val bin_writer_derived_on
      :  'a Bin_prot.Type_class.writer
      -> 'a derived_on Bin_prot.Type_class.writer

    val bin_read_derived_on
      :  'a Bin_prot.Read.reader
      -> 'a derived_on Bin_prot.Read.reader

    val __bin_read_derived_on__
      :  'a Bin_prot.Read.reader
      -> (int -> 'a derived_on) Bin_prot.Read.reader

    val bin_reader_derived_on
      :  'a Bin_prot.Type_class.reader
      -> 'a derived_on Bin_prot.Type_class.reader

    val bin_derived_on : 'a Bin_prot.Type_class.t -> 'a derived_on Bin_prot.Type_class.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'a_diff) t =
    | Set_to_none
    | Set_to_some of 'a
    | Diff_some of 'a_diff
  [@@deriving sexp, bin_io, quickcheck]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t
    include Bin_prot.Binable.S2 with type ('a, 'a_diff) t := ('a, 'a_diff) t

    include
      Ppx_quickcheck_runtime.Quickcheckable.S2
      with type ('a, 'a_diff) t := ('a, 'a_diff) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    Diff_intf.S1
    with type 'a derived_on := 'a derived_on
     and type ('a, 'a_diff) t := ('a, 'a_diff) t
end
