let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"total_map.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "total_map.ml.before-ppx"
;;

include Total_map_intf

module Stable = struct
  open Core.Core_stable

  module V1 = struct
    type ('key, 'a, 'cmp, 'enum) t = ('key, 'a, 'cmp) Map.V1.t

    module type S =
      Stable_V1_S with type ('key, 'a, 'cmp, 'enum) total_map := ('key, 'a, 'cmp, 'enum) t

    module type For_include_functor =
      Stable_V1_For_include_functor
      with type ('key, 'a, 'cmp, 'enum) Total_map.total_map := ('key, 'a, 'cmp, 'enum) t

    module Make_with_witnesses (Key : Key_with_witnesses) = struct
      module Key = struct
        include Key
        include Comparable.V1.Make (Key)
      end

      type comparator_witness = Key.comparator_witness
      type enumeration_witness = Key.enumeration_witness
      type nonrec 'a t = 'a Key.Map.t [@@deriving bin_io, sexp, compare]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "total_map.ml.before-ppx:24:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Key.Map.bin_shape_t
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "total_map.ml.before-ppx:24:25")
                       (Bin_prot.Shape.Vid.of_string "a")) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> Key.Map.bin_size_t _size_of_a v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v -> Key.Map.bin_write_t _write_a buf ~pos v
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a ->
             { size = (fun v -> bin_size_t bin_writer_a.size v)
             ; write = (fun v -> bin_write_t bin_writer_a.write v)
             }
           : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
          =
          fun _of__a buf ~pos_ref vint ->
          (Key.Map.__bin_read_t__ _of__a) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref -> (Key.Map.bin_read_t _of__a) buf ~pos_ref
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a ->
             { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a ->
             { writer = bin_writer_t bin_a.writer
             ; reader = bin_reader_t bin_a.reader
             ; shape = bin_shape_t bin_a.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun _of_a__001_ x__003_ -> Key.Map.t_of_sexp _of_a__001_ x__003_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__004_ x__005_ -> Key.Map.sexp_of_t _of_a__004_ x__005_
        ;;

        let _ = sexp_of_t

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__006_ b__007_ ->
          Key.Map.compare
            (fun a__008_ (b__009_ [@merlin.hide]) ->
               (_cmp__a a__008_ b__009_ [@merlin.hide]))
            a__006_
            b__007_
        ;;

        let _ = compare
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Make_for_include_functor_with_witnesses (Key : Key_with_witnesses) = struct
      module Total_map = Make_with_witnesses (Key)
    end
  end
end

open! Core
open! Import
module Enumeration = Enumeration

type ('key, 'a, 'cmp, 'enum) t = ('key, 'a, 'cmp, 'enum) Stable.V1.t

module type S_plain =
  S_plain with type ('key, 'a, 'cmp, 'enum) total_map := ('key, 'a, 'cmp, 'enum) t

module type For_include_functor_plain =
  For_include_functor_plain
  with type ('key, 'a, 'cmp, 'enum) Total_map.total_map := ('key, 'a, 'cmp, 'enum) t

module type S = S with type ('key, 'a, 'cmp, 'enum) total_map := ('key, 'a, 'cmp, 'enum) t

module type For_include_functor =
  For_include_functor
  with type ('key, 'a, 'cmp, 'enum) Total_map.total_map := ('key, 'a, 'cmp, 'enum) t

let to_map t = t

let key_not_in_enumeration t key =
  failwiths
    ~here:
      { Ppx_here_lib.pos_fname = "total_map.ml.before-ppx"
      ; pos_lnum = 56
      ; pos_cnum = 1652
      ; pos_bol = 1642
      }
    "Key was not provided in the enumeration given to [Total_map.Make]"
    key
    (Map.comparator t).sexp_of_t
;;

let change t k ~f =
  Map.update t k ~f:(function
    | Some x -> f x
    | None -> key_not_in_enumeration t k)
;;

let find t k =
  try Map.find_exn t k with
  | _ -> key_not_in_enumeration t k
;;

let pair t1 t2 key = function
  | `Left _ -> key_not_in_enumeration t2 key
  | `Right _ -> key_not_in_enumeration t1 key
  | `Both (v1, v2) -> v1, v2
;;

let iter2 t1 t2 ~f =
  Map.iter2 t1 t2 ~f:(fun ~key ~data ->
    let v1, v2 = pair t1 t2 key data in
    f ~key v1 v2)
;;

let fold2 t1 t2 ~init ~f =
  Map.fold2 t1 t2 ~init ~f:(fun ~key ~data acc ->
    let v1, v2 = pair t1 t2 key data in
    f ~key v1 v2 acc)
;;

let map2 t1 t2 ~f =
  Map.merge t1 t2 ~f:(fun ~key v ->
    let v1, v2 = pair t1 t2 key v in
    Some (f v1 v2))
;;

let set t key data = Map.set t ~key ~data

module Sequence3 (A : Applicative.S3) = struct
  let sequence t =
    List.fold
      (Map.to_alist t)
      ~init:(A.return (Map.Using_comparator.empty ~comparator:(Map.comparator t)))
      ~f:(fun acc (key, data) ->
        A.map2 acc data ~f:(fun acc data -> Map.set acc ~key ~data))
  ;;
end

module Sequence2 (A : Applicative.S2) = Sequence3 (Applicative.S2_to_S3 (A))
module Sequence (A : Applicative) = Sequence2 (Applicative.S_to_S2 (A))

include struct
  open Map

  let combine_errors = combine_errors
  let data = data
  let for_all = for_all
  let for_alli = for_alli
  let iter = iter
  let iter_keys = iter_keys
  let iteri = iteri
  let map = map
  let mapi = mapi
  let fold = fold
  let fold_right = fold_right
  let to_alist = to_alist
end

module Make_plain_with_witnesses (Key : Key_plain_with_witnesses) = struct
  module Key = struct
    include Key
    include Comparable.Make_plain_using_comparator (Key)
  end

  type comparator_witness = Key.comparator_witness
  type enumeration_witness = Key.enumeration_witness
  type 'a t = 'a Key.Map.t [@@deriving sexp_of, compare, equal]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__010_ x__011_ -> Key.Map.sexp_of_t _of_a__010_ x__011_
    ;;

    let _ = sexp_of_t

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__012_ b__013_ ->
      Key.Map.compare
        (fun a__014_ (b__015_ [@merlin.hide]) -> (_cmp__a a__014_ b__015_ [@merlin.hide]))
        a__012_
        b__013_
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__016_ b__017_ ->
      Key.Map.equal
        (fun a__018_ (b__019_ [@merlin.hide]) -> (_cmp__a a__018_ b__019_ [@merlin.hide]))
        a__016_
        b__017_
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create f =
    List.fold Key.all ~init:Key.Map.empty ~f:(fun t key -> Map.set t ~key ~data:(f key))
  ;;

  let create_const x = create (fun _ -> x)

  let named_key_set : _ Set.Named.t =
    { set = Key.Set.of_list Key.all; name = "[Key.all]" }
  ;;

  let of_map_exn map =
    ok_exn
      (Set.Named.equal
         named_key_set
         { set = Map.key_set map; name = "[Map.key_set map]" });
    create (fun key ->
      match Map.find map key with
      | Some value -> value
      | None ->
        raise_s
          (let ppx_sexp_message () =
             Ppx_sexp_conv_lib.Conv.sexp_of_string
               "impossible: all keys must be present in the map as verified by the key \
                set"
               [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
           in
           (ppx_sexp_message () [@nontail])))
  ;;

  let of_alist_exn alist = of_map_exn (Key.Map.of_alist_exn alist)

  include Applicative.Make (struct
      type nonrec 'a t = 'a t

      let return = create_const
      let apply t1 t2 = map2 t1 t2 ~f:(fun f x -> f x)
      let map = `Custom map
    end)
end

module Make_for_include_functor_plain_with_witnesses (Key : Key_plain_with_witnesses) =
struct
  module Total_map = Make_plain_with_witnesses (Key)
end

module Make_with_witnesses (Key : Key_with_witnesses) = struct
  module Key = struct
    include Key
    include Comparable.Make_binable_using_comparator (Key)
  end

  type 'a t = 'a Key.Map.t [@@deriving sexp, bin_io, compare, equal]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__020_ x__022_ -> Key.Map.t_of_sexp _of_a__020_ x__022_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__023_ x__024_ -> Key.Map.sexp_of_t _of_a__023_ x__024_
    ;;

    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "total_map.ml.before-ppx:183:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Key.Map.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "total_map.ml.before-ppx:183:14")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a v -> Key.Map.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> Key.Map.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_t bin_writer_a.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (Key.Map.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (Key.Map.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a ->
         { writer = bin_writer_t bin_a.writer
         ; reader = bin_reader_t bin_a.reader
         ; shape = bin_shape_t bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__025_ b__026_ ->
      Key.Map.compare
        (fun a__027_ (b__028_ [@merlin.hide]) -> (_cmp__a a__027_ b__028_ [@merlin.hide]))
        a__025_
        b__026_
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__029_ b__030_ ->
      Key.Map.equal
        (fun a__031_ (b__032_ [@merlin.hide]) -> (_cmp__a a__031_ b__032_ [@merlin.hide]))
        a__029_
        b__030_
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include (
    Make_plain_with_witnesses
      (Key) :
        module type of Make_plain_with_witnesses (Key)
        with module Key := Key
        with type 'a t := 'a t)

  let all_set = Key.Set.of_list Key.all

  let validate_map_from_serialization map =
    let keys = Map.key_set map in
    let keys_minus_all = Set.diff keys all_set in
    let all_minus_keys = Set.diff all_set keys in
    Validate.maybe_raise
      (Validate.of_list
         [ (if Set.is_empty keys_minus_all
            then Validate.pass
            else
              Validate.fails
                "map from serialization has keys not provided in the enumeration"
                keys_minus_all
                (Key.Set.sexp_of_t [@merlin.hide]))
         ; (if Set.is_empty all_minus_keys
            then Validate.pass
            else
              Validate.fails
                "map from serialization doesn't have keys it should have"
                all_minus_keys
                (Key.Set.sexp_of_t [@merlin.hide]))
         ])
  ;;

  let t_of_sexp a_of_sexp sexp =
    let t = t_of_sexp a_of_sexp sexp in
    validate_map_from_serialization t;
    t
  ;;

  include Bin_prot.Utils.Make_binable1_without_uuid [@alert "-legacy"] (struct
      type nonrec 'a t = 'a t

      module Binable = Key.Map

      let to_binable x = x

      let of_binable x =
        validate_map_from_serialization x;
        x
      ;;
    end)
  end

module Make_for_include_functor_with_witnesses (Key : Key_with_witnesses) = struct
  module Total_map = Make_with_witnesses (Key)
end

module Make_plain (Key : Key_plain) = Make_plain_with_witnesses (struct
    include Key
    include Comparable.Make_plain (Key)
    include Enumeration.Make (Key)
  end)

module Make_for_include_functor_plain (Key : Key_plain) = struct
  module Total_map = Make_plain (Key)
end

module Make (Key : Key) = Make_with_witnesses (struct
    include Key
    include Comparable.Make_binable (Key)
    include Enumeration.Make (Key)
  end)

module Make_for_include_functor (Key : Key) = struct
  module Total_map = Make (Key)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
