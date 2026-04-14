open Base

module Stable : sig
  module V1 : sig
    module Change : sig
      type ('k, 'v, 'v_diff) t =
        | Remove of 'k
        | Add of 'k * 'v
        | Diff of 'k * 'v_diff
      [@@deriving sexp, bin_io, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S3 with type ('k, 'v, 'v_diff) t := ('k, 'v, 'v_diff) t
        include Bin_prot.Binable.S3 with type ('k, 'v, 'v_diff) t := ('k, 'v, 'v_diff) t

        val stable_witness
          :  'k Ppx_stable_witness_runtime.Stable_witness.t
          -> 'v Ppx_stable_witness_runtime.Stable_witness.t
          -> 'v_diff Ppx_stable_witness_runtime.Stable_witness.t
          -> ('k, 'v, 'v_diff) t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type ('k, 'v, 'v_diff) t = ('k, 'v, 'v_diff) Change.t list
    [@@deriving sexp, bin_io, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S3 with type ('k, 'v, 'v_diff) t := ('k, 'v, 'v_diff) t
      include Bin_prot.Binable.S3 with type ('k, 'v, 'v_diff) t := ('k, 'v, 'v_diff) t

      val stable_witness
        :  'k Ppx_stable_witness_runtime.Stable_witness.t
        -> 'v Ppx_stable_witness_runtime.Stable_witness.t
        -> 'v_diff Ppx_stable_witness_runtime.Stable_witness.t
        -> ('k, 'v, 'v_diff) t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val get
      :  (from:'v -> to_:'v -> 'v_diff Optional_diff.t)
      -> from:('k, 'v, 'cmp) Map.t
      -> to_:('k, 'v, 'cmp) Map.t
      -> ('k, 'v, 'v_diff) t Optional_diff.t

    val apply_exn
      :  ('v -> 'v_diff -> 'v)
      -> ('k, 'v, 'cmp) Map.t
      -> ('k, 'v, 'v_diff) t
      -> ('k, 'v, 'cmp) Map.t

    val of_list_exn
      :  ('v_diff list -> 'v_diff Optional_diff.t)
      -> ('v -> 'v_diff -> 'v)
      -> ('k, 'v, 'v_diff) t list
      -> ('k, 'v, 'v_diff) t Optional_diff.t

    module Make : functor
        (M : sig
           module Key : sig
             type t
             type comparator_witness
           end

           type 'v t = (Key.t, 'v, Key.comparator_witness) Map.t
         end)
        ->
      Diff_intf.S1_plain
      with type 'v derived_on := 'v M.t
       and type ('v, 'v_diff) t := (M.Key.t, 'v, 'v_diff) t
  end
end

include
  module type of Stable.V1
  with type ('k, 'v, 'v_diff) Change.t = ('k, 'v, 'v_diff) Stable.V1.Change.t
