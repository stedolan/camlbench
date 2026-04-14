open! Base

module Make_diff : functor
    (M : sig
       type t [@@deriving sexp, bin_io, equal]

       include sig
         [@@@ocaml.warning "-32"]

         include Sexplib0.Sexpable.S with type t := t
         include Bin_prot.Binable.S with type t := t
         include Ppx_compare_lib.Equal.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> Diff_intf.S with type derived_on = M.t and type t = M.t

module Make_diff_plain : functor
    (M : sig
       type t [@@deriving equal]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Equal.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> Diff_intf.S_plain with type derived_on := M.t and type t := M.t

module Make : functor
    (M : sig
       type t [@@deriving equal, sexp, bin_io]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Equal.S with type t := t
         include Sexplib0.Sexpable.S with type t := t
         include Bin_prot.Binable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> Diffable_intf.S with type t := M.t and type Diff.t = M.t

module Make_plain : functor
    (M : sig
       type t [@@deriving equal]

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Equal.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end)
    -> Diffable_intf.S_plain with type t := M.t and type Diff.t = M.t
