let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hashable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hashable_intf.ml.before-ppx"
;;

open! Import

module type Common = sig
  type t [@@deriving compare, hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val hashable : t Hashtbl.Hashable.t
end

module type S_plain = sig
  include Common
  module Table : Hashtbl.S_plain with type key = t
  module Hash_set : Hash_set.S_plain with type elt = t
  module Hash_queue : Hash_queue.S with type key = t
end

module type S = sig
  include Common
  module Table : Hashtbl.S with type key = t
  module Hash_set : Hash_set.S with type elt = t
  module Hash_queue : Hash_queue.S with type key = t
end

module type S_binable = sig
  type t [@@deriving hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val hashable : t Hashtbl.Hashable.t

  module Table : Hashtbl.S_binable with type key = t
  module Hash_set : Hash_set.S_binable with type elt = t
  module Hash_queue : Hash_queue.S with type key = t
end

module type Hashable = sig
  module type Common = Common
  module type S = S
  module type S_binable = S_binable
  module type S_plain = S_plain

  module Make_plain : functor
      (T : sig
         type t [@@deriving hash]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_hash_lib.Hashable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Hashtbl.Key_plain with type t := t
       end)
      -> S_plain with type t := T.t

  module Make_plain_and_derive_hash_fold_t : functor (T : Hashtbl.Key_plain) ->
    S_plain with type t := T.t

  module Make : functor
      (T : sig
         type t [@@deriving hash]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_hash_lib.Hashable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Hashtbl.Key with type t := t
       end)
      -> S with type t := T.t

  module Make_and_derive_hash_fold_t : functor (T : Hashtbl.Key) -> S with type t := T.t

  module Make_binable : functor
      (T : sig
         type t [@@deriving hash]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_hash_lib.Hashable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Hashtbl.Key_binable with type t := t
       end)
      -> S_binable with type t := T.t

  module Make_plain_with_hashable : functor
      (T : sig
         module Key : sig
           type t [@@deriving hash]

           include sig
             [@@@ocaml.warning "-32"]

             include Ppx_hash_lib.Hashable.S with type t := t
           end
           [@@ocaml.doc "@inline"] [@@merlin.hide]

           include Hashtbl.Key_plain with type t := t
         end

         val hashable : Key.t Hashtbl.Hashable.t
       end)
      -> S_plain with type t := T.Key.t

  module Make_with_hashable : functor
      (T : sig
         module Key : sig
           type t [@@deriving hash]

           include sig
             [@@@ocaml.warning "-32"]

             include Ppx_hash_lib.Hashable.S with type t := t
           end
           [@@ocaml.doc "@inline"] [@@merlin.hide]

           include Hashtbl.Key with type t := t
         end

         val hashable : Key.t Hashtbl.Hashable.t
       end)
      -> S with type t := T.Key.t

  module Make_binable_with_hashable : functor
      (T : sig
         module Key : sig
           type t [@@deriving hash]

           include sig
             [@@@ocaml.warning "-32"]

             include Ppx_hash_lib.Hashable.S with type t := t
           end
           [@@ocaml.doc "@inline"] [@@merlin.hide]

           include Hashtbl.Key_binable with type t := t
         end

         val hashable : Key.t Hashtbl.Hashable.t
       end)
      -> S_binable with type t := T.Key.t

  module Make_binable_and_derive_hash_fold_t : functor (T : Hashtbl.Key_binable) ->
    S_binable with type t := T.t

  module Stable : sig
    module V1 : sig
      module type S = sig
        type key

        module Table : sig
          type 'a t = (key, 'a) Hashtbl.t [@@deriving sexp, bin_io]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S1 with type 'a t := 'a t
            include Bin_prot.Binable.S1 with type 'a t := 'a t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        module Hash_set : sig
          type t = key Hash_set.t [@@deriving sexp, bin_io]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S with type t := t
            include Bin_prot.Binable.S with type t := t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        val hashable : key Hashtbl.Hashable.t
      end

      module Make : functor (Key : Hashtbl.Key_binable) -> S with type key := Key.t

      module Make_with_hashable : functor
          (T : sig
             module Key : Hashtbl.Key_binable

             val hashable : Key.t Hashtbl.Hashable.t
           end)
          -> S with type key := T.Key.t

      module With_stable_witness : sig
        module type S = sig
          type key

          module Table : sig
            type 'a t = (key, 'a) Hashtbl.t [@@deriving sexp, bin_io, stable_witness]

            include sig
              [@@@ocaml.warning "-32"]

              include Sexplib0.Sexpable.S1 with type 'a t := 'a t
              include Bin_prot.Binable.S1 with type 'a t := 'a t

              val stable_witness
                :  'a Ppx_stable_witness_runtime.Stable_witness.t
                -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
            end
            [@@ocaml.doc "@inline"] [@@merlin.hide]
          end

          module Hash_set : sig
            type t = key Hash_set.t [@@deriving sexp, bin_io, stable_witness]

            include sig
              [@@@ocaml.warning "-32"]

              include Sexplib0.Sexpable.S with type t := t
              include Bin_prot.Binable.S with type t := t

              val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
            end
            [@@ocaml.doc "@inline"] [@@merlin.hide]
          end

          val hashable : key Hashtbl.Hashable.t
        end

        module Make : functor (Key : Hashtbl.Key_stable) -> S with type key := Key.t

        module Make_with_hashable : functor
            (T : sig
               module Key : Hashtbl.Key_stable

               val hashable : Key.t Hashtbl.Hashable.t
             end)
            -> S with type key := T.Key.t
      end
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
