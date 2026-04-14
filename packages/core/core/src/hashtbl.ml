let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hashtbl.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hashtbl.ml.before-ppx"
;;

open! Import
open Hashtbl_intf
module Hashable = Hashtbl_intf.Hashable
module Merge_into_action = Hashtbl_intf.Merge_into_action
module List = List0

let failwiths = Error.failwiths

module Creators = Hashtbl.Creators

include (
  Hashtbl :
  sig
    type ('a, 'b) t = ('a, 'b) Hashtbl.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('a, 'b) t
        -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Base.Hashtbl.S_without_submodules with type ('a, 'b) t := ('a, 'b) t
  end)

let validate ~name f t = Validate.alist ~name f (to_alist t)

module Using_hashable = struct
  type nonrec ('a, 'b) t = ('a, 'b) t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : ('a, 'b) t) -> ()

    let sexp_of_t
      :  'a 'b.
         ('a -> Sexplib0.Sexp.t)
      -> ('b -> Sexplib0.Sexp.t)
      -> ('a, 'b) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a__001_ _of_b__002_ x__003_ -> sexp_of_t _of_a__001_ _of_b__002_ x__003_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create ?growth_allowed ?size ~hashable () =
    create ?growth_allowed ?size (Base.Hashable.to_key hashable)
  ;;

  let of_alist ?growth_allowed ?size ~hashable l =
    of_alist ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;

  let of_alist_report_all_dups ?growth_allowed ?size ~hashable l =
    of_alist_report_all_dups ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;

  let of_alist_or_error ?growth_allowed ?size ~hashable l =
    of_alist_or_error ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;

  let of_alist_exn ?growth_allowed ?size ~hashable l =
    of_alist_exn ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;

  let of_alist_multi ?growth_allowed ?size ~hashable l =
    of_alist_multi ?growth_allowed ?size (Base.Hashable.to_key hashable) l
  ;;

  let create_mapped ?growth_allowed ?size ~hashable ~get_key ~get_data l =
    create_mapped
      ?growth_allowed
      ?size
      (Base.Hashable.to_key hashable)
      ~get_key
      ~get_data
      l
  ;;

  let create_with_key ?growth_allowed ?size ~hashable ~get_key l =
    create_with_key ?growth_allowed ?size (Base.Hashable.to_key hashable) ~get_key l
  ;;

  let create_with_key_or_error ?growth_allowed ?size ~hashable ~get_key l =
    create_with_key_or_error
      ?growth_allowed
      ?size
      (Base.Hashable.to_key hashable)
      ~get_key
      l
  ;;

  let create_with_key_exn ?growth_allowed ?size ~hashable ~get_key l =
    create_with_key_exn ?growth_allowed ?size (Base.Hashable.to_key hashable) ~get_key l
  ;;

  let group ?growth_allowed ?size ~hashable ~get_key ~get_data ~combine l =
    group
      ?growth_allowed
      ?size
      (Base.Hashable.to_key hashable)
      ~get_key
      ~get_data
      ~combine
      l
  ;;
end

module type S_plain = S_plain with type ('a, 'b) hashtbl = ('a, 'b) t
module type S = S with type ('a, 'b) hashtbl = ('a, 'b) t
module type S_binable = S_binable with type ('a, 'b) hashtbl = ('a, 'b) t
module type S_stable = S_stable with type ('a, 'b) hashtbl = ('a, 'b) t
module type Key_plain = Key_plain
module type Key = Key
module type Key_binable = Key_binable
module type Key_stable = Key_stable

module Poly = struct
  include Hashtbl.Poly

  let validate = validate

  include Bin_prot.Utils.Make_iterable_binable2 (struct
      type nonrec ('a, 'b) t = ('a, 'b) t
      type ('a, 'b) el = 'a * 'b [@@deriving bin_io]

      include struct
        let _ = fun (_ : ('a, 'b) el) -> ()

        let bin_shape_el =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "hashtbl.ml.before-ppx:103:4")
              [ ( Bin_prot.Shape.Tid.of_string "el"
                , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "b" ]
                , Bin_prot.Shape.tuple
                    [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "hashtbl.ml.before-ppx:103:23")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ; Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "hashtbl.ml.before-ppx:103:28")
                        (Bin_prot.Shape.Vid.of_string "b")
                    ] )
              ]
          in
          fun a b ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ a; b ]
        ;;

        let _ = bin_shape_el

        let bin_size_el
          :  'a 'b.
             'a Bin_prot.Size.sizer
          -> 'b Bin_prot.Size.sizer
          -> ('a, 'b) el Bin_prot.Size.sizer
          =
          fun _size_of_a _size_of_b -> function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
            Bin_prot.Common.( + ) size (_size_of_b v2)
        ;;

        let _ = bin_size_el

        let bin_write_el
          :  'a 'b.
             'a Bin_prot.Write.writer
          -> 'b Bin_prot.Write.writer
          -> ('a, 'b) el Bin_prot.Write.writer
          =
          fun _write_a _write_b buf ~pos -> function
          | v1, v2 ->
            let pos = _write_a buf ~pos v1 in
            _write_b buf ~pos v2
        ;;

        let _ = bin_write_el

        let bin_writer_el =
          (fun bin_writer_a bin_writer_b ->
             { size = (fun v -> bin_size_el bin_writer_a.size bin_writer_b.size v)
             ; write = (fun v -> bin_write_el bin_writer_a.write bin_writer_b.write v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_el

        let __bin_read_el__
          :  'a 'b.
             'a Bin_prot.Read.reader
          -> 'b Bin_prot.Read.reader
          -> (int -> ('a, 'b) el) Bin_prot.Read.reader
          =
          fun _of__a _of__b _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "hashtbl.ml.before-ppx.Poly.el"
            !pos_ref
        ;;

        let _ = __bin_read_el__

        let bin_read_el
          :  'a 'b.
             'a Bin_prot.Read.reader
          -> 'b Bin_prot.Read.reader
          -> ('a, 'b) el Bin_prot.Read.reader
          =
          fun _of__a _of__b buf ~pos_ref ->
          let v1 = _of__a buf ~pos_ref in
          let v2 = _of__b buf ~pos_ref in
          v1, v2
        ;;

        let _ = bin_read_el

        let bin_reader_el =
          (fun bin_reader_a bin_reader_b ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_el bin_reader_a.read bin_reader_b.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_el__ bin_reader_a.read bin_reader_b.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_el

        let bin_el =
          (fun bin_a bin_b ->
             { writer = bin_writer_el bin_a.writer bin_b.writer
             ; reader = bin_reader_el bin_a.reader bin_b.reader
             ; shape = bin_shape_el bin_a.shape bin_b.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_el
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "8f3e445c-4992-11e6-a279-3703be311e7b"
      ;;

      let module_name = Some "Core.Hashtbl"
      let length = length
      let iter t ~f = iteri t ~f:(fun ~key ~data -> f (key, data))

      let init ~len ~next =
        let t = create ~size:len () in
        for _i = 0 to len - 1 do
          let key, data = next () in
          match find t key with
          | None -> set t ~key ~data
          | Some _ -> failwith "Core_hashtbl.bin_read_t_: duplicate key"
        done;
        t
      ;;
    end)
end

module Make_plain_with_hashable (T : sig
    module Key : Key_plain

    val hashable : Key.t Hashable.t
  end) =
struct
  let hashable = T.hashable

  type key = T.Key.t
  type ('a, 'b) hashtbl = ('a, 'b) t
  type 'a t = (T.Key.t, 'a) hashtbl
  type 'a key_ = T.Key.t

  include Creators (struct
      type 'a t = T.Key.t

      let hashable = hashable
    end)

  include (
    Hashtbl :
    sig
      include Invariant.S2 with type ('a, 'b) t := ('a, 'b) hashtbl
    end)

  let equal = Hashtbl.equal
  let invariant invariant_key t = invariant ignore invariant_key t
  let sexp_of_t sexp_of_v t = Poly.sexp_of_t T.Key.sexp_of_t sexp_of_v t

  module Provide_of_sexp
      (Key : sig
               type t [@@deriving of_sexp]

               include sig
                 [@@@ocaml.warning "-32"]

                 val t_of_sexp : Sexplib0.Sexp.t -> t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := key) =
  struct
    let t_of_sexp v_of_sexp sexp = t_of_sexp Key.t_of_sexp v_of_sexp sexp
  end

  module Provide_bin_io
      (Key' : sig
                type t [@@deriving bin_io]

                include sig
                  [@@@ocaml.warning "-32"]

                  include Bin_prot.Binable.S with type t := t
                end
                [@@ocaml.doc "@inline"] [@@merlin.hide]
              end
              with type t := key) =
  Bin_prot.Utils.Make_iterable_binable1 (struct
      module Key = struct
        include T.Key
        include Key'
      end

      type nonrec 'a t = 'a t
      type 'a el = Key.t * 'a [@@deriving bin_io]

      include struct
        let _ = fun (_ : 'a el) -> ()

        let bin_shape_el =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "hashtbl.ml.before-ppx:176:4")
              [ ( Bin_prot.Shape.Tid.of_string "el"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.tuple
                    [ Key.bin_shape_t
                    ; Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "hashtbl.ml.before-ppx:176:25")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ a ]
        ;;

        let _ = bin_shape_el

        let bin_size_el : 'a. 'a Bin_prot.Size.sizer -> 'a el Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (Key.bin_size_t v1) in
            Bin_prot.Common.( + ) size (_size_of_a v2)
        ;;

        let _ = bin_size_el

        let bin_write_el : 'a. 'a Bin_prot.Write.writer -> 'a el Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | v1, v2 ->
            let pos = Key.bin_write_t buf ~pos v1 in
            _write_a buf ~pos v2
        ;;

        let _ = bin_write_el

        let bin_writer_el =
          (fun bin_writer_a ->
             { size = (fun v -> bin_size_el bin_writer_a.size v)
             ; write = (fun v -> bin_write_el bin_writer_a.write v)
             }
           : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_el

        let __bin_read_el__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a el) Bin_prot.Read.reader
          =
          fun _of__a _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "hashtbl.ml.before-ppx.Make_plain_with_hashable.Provide_bin_io.el"
            !pos_ref
        ;;

        let _ = __bin_read_el__

        let bin_read_el : 'a. 'a Bin_prot.Read.reader -> 'a el Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          let v1 = Key.bin_read_t buf ~pos_ref in
          let v2 = _of__a buf ~pos_ref in
          v1, v2
        ;;

        let _ = bin_read_el

        let bin_reader_el =
          (fun bin_reader_a ->
             { read = (fun buf ~pos_ref -> (bin_read_el bin_reader_a.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_el__ bin_reader_a.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_el

        let bin_el =
          (fun bin_a ->
             { writer = bin_writer_el bin_a.writer
             ; reader = bin_reader_el bin_a.reader
             ; shape = bin_shape_el bin_a.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_el
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "8fabab0a-4992-11e6-8cca-9ba2c4686d9e"
      ;;

      let module_name = Some "Core.Hashtbl"
      let length = length
      let iter t ~f = iteri t ~f:(fun ~key ~data -> f (key, data))

      let init ~len ~next =
        let t = create ~size:len () in
        for _i = 0 to len - 1 do
          let key, data = next () in
          match find t key with
          | None -> set t ~key ~data
          | Some _ ->
            failwiths
              ~here:
                { Ppx_here_lib.pos_fname = "hashtbl.ml.before-ppx"
                ; pos_lnum = 194
                ; pos_cnum = 5147
                ; pos_bol = 5129
                }
              "Hashtbl.bin_read_t: duplicate key"
              key
              (Key.sexp_of_t [@merlin.hide])
        done;
        t
      ;;
    end)

  module Provide_stable_witness
      (Key' : sig
                type t [@@deriving stable_witness]

                include sig
                  [@@@ocaml.warning "-32"]

                  val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
                end
                [@@ocaml.doc "@inline"] [@@merlin.hide]
              end
              with type t := key) =
  struct
    let stable_witness (type data) (_data_stable_witness : data Stable_witness.t)
      : data t Stable_witness.t
      =
      let (_ : key Stable_witness.t) = Key'.stable_witness in
      Stable_witness.assert_stable
    ;;
  end
end

module Make_with_hashable (T : sig
    module Key : Key

    val hashable : Key.t Hashable.t
  end) =
struct
  include Make_plain_with_hashable (T)
  include Provide_of_sexp (T.Key)
end

module Make_binable_with_hashable (T : sig
    module Key : Key_binable

    val hashable : Key.t Hashable.t
  end) =
struct
  include Make_with_hashable (T)
  include Provide_bin_io (T.Key)
end

module Make_stable_with_hashable (T : sig
    module Key : Key_stable

    val hashable : Key.t Hashable.t
  end) =
struct
  include Make_binable_with_hashable (T)
  include Provide_stable_witness (T.Key)
end

module Make_plain (Key : Key_plain) = Make_plain_with_hashable (struct
    module Key = Key

    let hashable =
      { Hashable.hash = Key.hash; compare = Key.compare; sexp_of_t = Key.sexp_of_t }
    ;;
  end)

module Make (Key : Key) = struct
  include Make_plain (Key)
  include Provide_of_sexp (Key)
end

module Make_binable (Key : Key_binable) = struct
  include Make (Key)
  include Provide_bin_io (Key)
end

module Make_stable (Key : Key_stable) = struct
  include Make_binable (Key)
  include Provide_stable_witness (Key)
end

module M = Hashtbl.M

module type For_deriving = For_deriving

module For_deriving : For_deriving with type ('a, 'b) t := ('a, 'b) t = struct
  include (Hashtbl : Hashtbl.For_deriving with type ('a, 'b) t := ('a, 'b) t)

  module type M_quickcheck = M_quickcheck

  let of_alist_option m alist = Result.ok (of_alist_or_error m alist)

  let quickcheck_generator_m__t
        (type key)
        ((module Key) : (module M_quickcheck with type t = key))
        quickcheck_generator_data
    =
    Quickcheck.Generator.filter_map
      ~f:(of_alist_option (module Key))
      (List.quickcheck_generator
         (Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
            (fun ~size:_size__004_ ~random:_random__005_ ->
               ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   Key.quickcheck_generator
                   ~size:_size__004_
                   ~random:_random__005_
               , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_data
                   ~size:_size__004_
                   ~random:_random__005_ ))))
  ;;

  let quickcheck_observer_m__t
        (type key)
        ((module Key) : (module M_quickcheck with type t = key))
        quickcheck_observer_data
    =
    Quickcheck.Observer.unmap
      ~f:to_alist
      (List.quickcheck_observer
         (Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__006_ ~size:_size__009_ ~hash:_hash__010_ ->
               let _x__007_, _x__008_ = _x__006_ in
               let _hash__010_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Key.quickcheck_observer
                   _x__007_
                   ~size:_size__009_
                   ~hash:_hash__010_
               in
               let _hash__010_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   quickcheck_observer_data
                   _x__008_
                   ~size:_size__009_
                   ~hash:_hash__010_
               in
               _hash__010_)))
  ;;

  let quickcheck_shrinker_m__t
        (type key)
        ((module Key) : (module M_quickcheck with type t = key))
        quickcheck_shrinker_data
    =
    Quickcheck.Shrinker.filter_map
      ~f:(of_alist_option (module Key))
      ~f_inverse:to_alist
      (List.quickcheck_shrinker
         (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
            (fun (_x__011_, _x__012_) ->
               Ppx_quickcheck_runtime.Base.Sequence.round_robin
                 [ Ppx_quickcheck_runtime.Base.Sequence.map
                     (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                        Key.quickcheck_shrinker
                        _x__011_)
                     ~f:(fun _x__011_ -> _x__011_, _x__012_)
                 ; Ppx_quickcheck_runtime.Base.Sequence.map
                     (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                        quickcheck_shrinker_data
                        _x__012_)
                     ~f:(fun _x__012_ -> _x__011_, _x__012_)
                 ])))
  ;;
end

include For_deriving

let hashable = Hashtbl.Private.hashable
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
