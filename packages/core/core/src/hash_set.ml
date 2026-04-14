let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hash_set.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hash_set.ml.before-ppx"
;;

open! Import
include Hash_set_intf
include Base.Hash_set

module type S_plain = S_plain with type 'a hash_set := 'a t
module type S = S with type 'a hash_set := 'a t
module type S_binable = S_binable with type 'a hash_set := 'a t
module type S_stable = S_stable with type 'a hash_set := 'a t
module type Elt_plain = Hashtbl.Key_plain
module type Elt = Hashtbl.Key
module type Elt_binable = Hashtbl.Key_binable
module type Elt_stable = Hashtbl.Key_stable

module Make_plain_with_hashable (T : sig
    module Elt : Elt_plain

    val hashable : Elt.t Hashtbl.Hashable.t
  end) =
struct
  type elt = T.Elt.t
  type nonrec t = elt t

  let equal = equal

  include Creators (struct
      type 'a t = T.Elt.t

      let hashable = T.hashable
    end)

  let sexp_of_t t = Poly.sexp_of_t T.Elt.sexp_of_t t

  module Provide_of_sexp
      (X : sig
             type t [@@deriving of_sexp]

             include sig
               [@@@ocaml.warning "-32"]

               val t_of_sexp : Sexplib0.Sexp.t -> t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := elt) =
  struct
    let t_of_sexp sexp = t_of_sexp X.t_of_sexp sexp
  end

  module Provide_bin_io
      (X : sig
             type t [@@deriving bin_io]

             include sig
               [@@@ocaml.warning "-32"]

               include Bin_prot.Binable.S with type t := t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := elt) =
  Bin_prot.Utils.Make_iterable_binable (struct
      module Elt = struct
        include T.Elt
        include X
      end

      type nonrec t = t
      type el = Elt.t [@@deriving bin_io]

      include struct
        let _ = fun (_ : el) -> ()

        let bin_shape_el =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "hash_set.ml.before-ppx:54:4")
              [ Bin_prot.Shape.Tid.of_string "el", [], Elt.bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) []
        ;;

        let _ = bin_shape_el
        let bin_size_el : el Bin_prot.Size.sizer = Elt.bin_size_t
        let _ = bin_size_el
        let bin_write_el : el Bin_prot.Write.writer = Elt.bin_write_t
        let _ = bin_write_el

        let bin_writer_el =
          ({ size = bin_size_el; write = bin_write_el } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_el
        let __bin_read_el__ : (int -> el) Bin_prot.Read.reader = Elt.__bin_read_t__
        let _ = __bin_read_el__
        let bin_read_el : el Bin_prot.Read.reader = Elt.bin_read_t
        let _ = bin_read_el

        let bin_reader_el =
          ({ read = bin_read_el; vtag_read = __bin_read_el__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_el

        let bin_el =
          ({ writer = bin_writer_el; reader = bin_reader_el; shape = bin_shape_el }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_el
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let _ = bin_el

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "ad381672-4992-11e6-9e36-b76dc8cd466f"
      ;;

      let module_name = Some "Core.Hash_set"
      let length = length
      let iter = iter

      let init ~len ~next =
        let t = create ~size:len () in
        for _i = 0 to len - 1 do
          let v = next () in
          add t v
        done;
        t
      ;;
    end)

  module Provide_stable_witness
      (X : sig
             type t [@@deriving stable_witness]

             include sig
               [@@@ocaml.warning "-32"]

               val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := elt) =
  struct
    let stable_witness : t Stable_witness.t =
      let (_ : elt Stable_witness.t) = X.stable_witness in
      Stable_witness.assert_stable
    ;;
  end
end

module Make_with_hashable (T : sig
    module Elt : Elt

    val hashable : Elt.t Hashtbl.Hashable.t
  end) =
struct
  include Make_plain_with_hashable (T)
  include Provide_of_sexp (T.Elt)
end

module Make_binable_with_hashable (T : sig
    module Elt : Elt_binable

    val hashable : Elt.t Hashtbl.Hashable.t
  end) =
struct
  include Make_with_hashable (T)
  include Provide_bin_io (T.Elt)
end

module Make_stable_with_hashable (T : sig
    module Elt : Elt_stable

    val hashable : Elt.t Hashtbl.Hashable.t
  end) =
struct
  include Make_binable_with_hashable (T)
  include Provide_stable_witness (T.Elt)
end

module Make_plain (Elt : Elt_plain) = Make_plain_with_hashable (struct
    module Elt = Elt

    let hashable = Hashtbl.Hashable.of_key (module Elt)
  end)

module Make (Elt : Elt) = struct
  include Make_plain (Elt)
  include Provide_of_sexp (Elt)
end

module Make_binable (Elt : Elt_binable) = struct
  include Make (Elt)
  include Provide_bin_io (Elt)
end

module Make_stable (Elt : Elt_stable) = struct
  include Make_binable (Elt)
  include Provide_stable_witness (Elt)
end

module Using_hashable = struct
  type 'a elt = 'a

  let create ?growth_allowed ?size ~hashable () =
    create ?growth_allowed ?size (Base.Hashable.to_key hashable)
  ;;

  let of_list ?growth_allowed ?size ~hashable l =
    of_list ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;
end

let hashable = Private.hashable
let create ?growth_allowed ?size m = create ?growth_allowed ?size m

let quickcheck_generator_m__t
      (type key)
      ((module Key) : (module M_quickcheck with type t = key))
  =
  Quickcheck.Generator.map
    ~f:(of_list (module Key))
    (List0.quickcheck_generator Key.quickcheck_generator)
;;

let quickcheck_observer_m__t
      (type key)
      ((module Key) : (module M_quickcheck with type t = key))
  =
  Quickcheck.Observer.unmap ~f:to_list (List0.quickcheck_observer Key.quickcheck_observer)
;;

let quickcheck_shrinker_m__t
      (type key)
      ((module Key) : (module M_quickcheck with type t = key))
  =
  Quickcheck.Shrinker.map
    ~f:(of_list (module Key))
    ~f_inverse:to_list
    (List0.quickcheck_shrinker Key.quickcheck_shrinker)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
