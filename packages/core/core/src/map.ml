let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"map.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "map.ml.before-ppx"
;;

open! Import
open Map_intf
module List = List0

module Symmetric_diff_element = struct
  module Stable = struct
    module V1 = struct
      type ('k, 'v) t = 'k * [ `Left of 'v | `Right of 'v | `Unequal of 'v * 'v ]
      [@@deriving bin_io, compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : ('k, 'v) t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:8:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "k"; Bin_prot.Shape.Vid.of_string "v" ]
                , Bin_prot.Shape.tuple
                    [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:8:24")
                        (Bin_prot.Shape.Vid.of_string "k")
                    ; Bin_prot.Shape.poly_variant
                        (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:8:29")
                        [ Bin_prot.Shape.constr
                            "Left"
                            (Some
                               (Bin_prot.Shape.var
                                  (Bin_prot.Shape.Location.of_string
                                     "map.ml.before-ppx:8:40")
                                  (Bin_prot.Shape.Vid.of_string "v")))
                        ; Bin_prot.Shape.constr
                            "Right"
                            (Some
                               (Bin_prot.Shape.var
                                  (Bin_prot.Shape.Location.of_string
                                     "map.ml.before-ppx:8:55")
                                  (Bin_prot.Shape.Vid.of_string "v")))
                        ; Bin_prot.Shape.constr
                            "Unequal"
                            (Some
                               (Bin_prot.Shape.tuple
                                  [ Bin_prot.Shape.var
                                      (Bin_prot.Shape.Location.of_string
                                         "map.ml.before-ppx:8:72")
                                      (Bin_prot.Shape.Vid.of_string "v")
                                  ; Bin_prot.Shape.var
                                      (Bin_prot.Shape.Location.of_string
                                         "map.ml.before-ppx:8:77")
                                      (Bin_prot.Shape.Vid.of_string "v")
                                  ]))
                        ]
                    ] )
              ]
          in
          fun k v ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ k; v ]
        ;;

        let _ = bin_shape_t

        let bin_size_t =
          (fun _size_of_k _size_of_v -> function
             | v1, v2 ->
               let size = 0 in
               let size = Bin_prot.Common.( + ) size (_size_of_k v1) in
               Bin_prot.Common.( + )
                 size
                 (match v2 with
                  | `Left args ->
                    let size_args = _size_of_v args in
                    Bin_prot.Common.( + ) size_args 4
                  | `Right args ->
                    let size_args = _size_of_v args in
                    Bin_prot.Common.( + ) size_args 4
                  | `Unequal args ->
                    let size_args =
                      match args with
                      | v1, v2 ->
                        let size = 0 in
                        let size = Bin_prot.Common.( + ) size (_size_of_v v1) in
                        Bin_prot.Common.( + ) size (_size_of_v v2)
                    in
                    Bin_prot.Common.( + ) size_args 4)
           : _ Bin_prot.Size.sizer -> _ Bin_prot.Size.sizer -> _ Bin_prot.Size.sizer)
        ;;

        let _ = bin_size_t

        let bin_write_t =
          (fun _write_k _write_v buf ~pos -> function
             | v1, v2 ->
               let pos = _write_k buf ~pos v1 in
               (match v2 with
                | `Left args ->
                  let pos = Bin_prot.Write.bin_write_variant_int buf ~pos 847852583 in
                  _write_v buf ~pos args
                | `Right args ->
                  let pos = Bin_prot.Write.bin_write_variant_int buf ~pos (-57574468) in
                  _write_v buf ~pos args
                | `Unequal args ->
                  let pos = Bin_prot.Write.bin_write_variant_int buf ~pos 1013247643 in
                  (match args with
                   | v1, v2 ->
                     let pos = _write_v buf ~pos v1 in
                     _write_v buf ~pos v2))
           : _ Bin_prot.Write.writer -> _ Bin_prot.Write.writer -> _ Bin_prot.Write.writer)
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_k bin_writer_v ->
             { size = (fun v -> bin_size_t bin_writer_k.size bin_writer_v.size v)
             ; write = (fun v -> bin_write_t bin_writer_k.write bin_writer_v.write v)
             }
           : _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer
             -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ _of__k _of__v _buf ~pos_ref _vint =
          Bin_prot.Common.raise_variant_wrong_type
            "map.ml.before-ppx.Symmetric_diff_element.Stable.V1.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t _of__k _of__v buf ~pos_ref =
          let v1 = _of__k buf ~pos_ref in
          let v2 =
            let vint = Bin_prot.Read.bin_read_variant_int buf ~pos_ref in
            try
              match vint with
              | 847852583 ->
                let arg_1 = _of__v buf ~pos_ref in
                `Left arg_1
              | -57574468 ->
                let arg_1 = _of__v buf ~pos_ref in
                `Right arg_1
              | 1013247643 ->
                let arg_1 =
                  let v1 = _of__v buf ~pos_ref in
                  let v2 = _of__v buf ~pos_ref in
                  v1, v2
                in
                `Unequal arg_1
              | _ -> raise Bin_prot.Common.No_variant_match
            with
            | Bin_prot.Common.No_variant_match ->
              Bin_prot.Common.raise_variant_wrong_type
                "map.ml.before-ppx.Symmetric_diff_element.Stable.V1.t"
                !pos_ref
          in
          v1, v2
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_k bin_reader_v ->
             { read =
                 (fun buf ~pos_ref ->
                   (bin_read_t bin_reader_k.read bin_reader_v.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__ bin_reader_k.read bin_reader_v.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader
             -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_k bin_v ->
             { writer = bin_writer_t bin_k.writer bin_v.writer
             ; reader = bin_reader_t bin_k.reader bin_v.reader
             ; shape = bin_shape_t bin_k.shape bin_v.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let compare
          :  'k 'v.
             ('k -> ('k[@merlin.hide]) -> int)
          -> ('v -> ('v[@merlin.hide]) -> int)
          -> ('k, 'v) t
          -> (('k, 'v) t[@merlin.hide])
          -> int
          =
          fun _cmp__k _cmp__v a__001_ b__002_ ->
          let t__003_, t__004_ = a__001_ in
          let t__005_, t__006_ = b__002_ in
          match _cmp__k t__003_ t__005_ with
          | 0 ->
            if Stdlib.( == ) t__004_ t__006_
            then 0
            else (
              match t__004_, t__006_ with
              | `Left _left__007_, `Left _right__008_ -> _cmp__v _left__007_ _right__008_
              | `Right _left__009_, `Right _right__010_ ->
                _cmp__v _left__009_ _right__010_
              | `Unequal _left__011_, `Unequal _right__012_ ->
                let t__013_, t__014_ = _left__011_ in
                let t__015_, t__016_ = _right__012_ in
                (match _cmp__v t__013_ t__015_ with
                 | 0 -> _cmp__v t__014_ t__016_
                 | n -> n)
              | x, y -> Stdlib.compare x y)
          | n -> n
        ;;

        let _ = compare

        let t_of_sexp
          :  'k 'v.
             (Sexplib0.Sexp.t -> 'k)
          -> (Sexplib0.Sexp.t -> 'v)
          -> Sexplib0.Sexp.t
          -> ('k, 'v) t
          =
          let error_source__031_ =
            "map.ml.before-ppx.Symmetric_diff_element.Stable.V1.t"
          in
          fun _of_k__017_ _of_v__018_ -> function
            | Sexplib0.Sexp.List [ arg0__041_; arg1__042_ ] ->
              let res0__043_ = _of_k__017_ arg0__041_
              and res1__044_ =
                let sexp__040_ = arg1__042_ in
                try
                  match sexp__040_ with
                  | Sexplib0.Sexp.Atom atom__021_ as _sexp__023_ ->
                    (match atom__021_ with
                     | "Left" ->
                       Sexplib0.Sexp_conv_error.ptag_takes_args
                         error_source__031_
                         _sexp__023_
                     | "Right" ->
                       Sexplib0.Sexp_conv_error.ptag_takes_args
                         error_source__031_
                         _sexp__023_
                     | "Unequal" ->
                       Sexplib0.Sexp_conv_error.ptag_takes_args
                         error_source__031_
                         _sexp__023_
                     | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                  | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__021_ :: sexp_args__024_)
                    as _sexp__023_ ->
                    (match atom__021_ with
                     | "Left" as _tag__037_ ->
                       (match sexp_args__024_ with
                        | arg0__038_ :: [] ->
                          let res0__039_ = _of_v__018_ arg0__038_ in
                          `Left res0__039_
                        | _ ->
                          Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                            error_source__031_
                            _tag__037_
                            _sexp__023_)
                     | "Right" as _tag__034_ ->
                       (match sexp_args__024_ with
                        | arg0__035_ :: [] ->
                          let res0__036_ = _of_v__018_ arg0__035_ in
                          `Right res0__036_
                        | _ ->
                          Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                            error_source__031_
                            _tag__034_
                            _sexp__023_)
                     | "Unequal" as _tag__025_ ->
                       (match sexp_args__024_ with
                        | arg0__032_ :: [] ->
                          let res0__033_ =
                            match arg0__032_ with
                            | Sexplib0.Sexp.List [ arg0__026_; arg1__027_ ] ->
                              let res0__028_ = _of_v__018_ arg0__026_
                              and res1__029_ = _of_v__018_ arg1__027_ in
                              res0__028_, res1__029_
                            | sexp__030_ ->
                              Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                                error_source__031_
                                2
                                sexp__030_
                          in
                          `Unequal res0__033_
                        | _ ->
                          Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                            error_source__031_
                            _tag__025_
                            _sexp__023_)
                     | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                  | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__022_ ->
                    Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                      error_source__031_
                      sexp__022_
                  | Sexplib0.Sexp.List [] as sexp__022_ ->
                    Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                      error_source__031_
                      sexp__022_
                with
                | Sexplib0.Sexp_conv_error.No_variant_match ->
                  Sexplib0.Sexp_conv_error.no_matching_variant_found
                    error_source__031_
                    sexp__040_
              in
              res0__043_, res1__044_
            | sexp__045_ ->
              Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                error_source__031_
                2
                sexp__045_
        ;;

        let _ = t_of_sexp

        let sexp_of_t
          :  'k 'v.
             ('k -> Sexplib0.Sexp.t)
          -> ('v -> Sexplib0.Sexp.t)
          -> ('k, 'v) t
          -> Sexplib0.Sexp.t
          =
          fun _of_k__046_ _of_v__047_ (arg0__055_, arg1__056_) ->
          let res0__057_ = _of_k__046_ arg0__055_
          and res1__058_ =
            match arg1__056_ with
            | `Left v__048_ ->
              Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Left"; _of_v__047_ v__048_ ]
            | `Right v__049_ ->
              Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Right"; _of_v__047_ v__049_ ]
            | `Unequal v__050_ ->
              Sexplib0.Sexp.List
                [ Sexplib0.Sexp.Atom "Unequal"
                ; (let arg0__051_, arg1__052_ = v__050_ in
                   let res0__053_ = _of_v__047_ arg0__051_
                   and res1__054_ = _of_v__047_ arg1__052_ in
                   Sexplib0.Sexp.List [ res0__053_; res1__054_ ])
                ]
          in
          Sexplib0.Sexp.List [ res0__057_; res1__058_ ]
        ;;

        let _ = sexp_of_t

        let stable_witness
              (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : ('k, 'v) t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'k_stable_witness : 'k Ppx_stable_witness_runtime.Stable_witness.t)
              (__'v_stable_witness : 'v Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _ : 'k Ppx_stable_witness_runtime.Stable_witness.t = __'k_stable_witness
          and _ : 'v Ppx_stable_witness_runtime.Stable_witness.t = __'v_stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"map.ml.before-ppx"
            ~line_number:11
            ~location:{ start_bol = 275; start_pos = 281; end_pos = 411 }
            ~trailing_loc:{ start_bol = 355; start_pos = 411; end_pos = 411 }
            ~body_loc:{ start_bol = 275; start_pos = 281; end_pos = 411 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 0
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " 00674be9fe8dfe9e9ad476067d7d8101 "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 355; start_pos = 372; end_pos = 410 } ))
                     ~node_loc:{ start_bol = 355; start_pos = 363; end_pos = 411 } )
               ]
              [@merlin.hide])
            (fun () ->
               print_endline
                 (Bin_prot.Shape.Digest.to_hex
                    (Bin_prot.Shape.eval_to_digest
                       ((bin_shape_t bin_shape_int) bin_shape_string)));
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
      ;;

      let map (k, diff) ~f1 ~f2 =
        let k = f1 k in
        let diff =
          match diff with
          | `Left v -> `Left (f2 v)
          | `Right v -> `Right (f2 v)
          | `Unequal (v1, v2) -> `Unequal (f2 v1, f2 v2)
        in
        k, diff
      ;;

      let map_data t ~f = map t ~f1:Fn.id ~f2:f

      let left (_key, diff) =
        match diff with
        | `Left x | `Unequal (x, _) -> Some x
        | `Right _ -> None
      ;;

      let right (_key, diff) =
        match diff with
        | `Right x | `Unequal (_, x) -> Some x
        | `Left _ -> None
      ;;
    end
  end

  include Stable.V1
end

module Merge_element = Base.Map.Merge_element
module Continue_or_stop = Base.Map.Continue_or_stop
module Finished_or_unfinished = Base.Map.Finished_or_unfinished

let to_comparator = Comparator.of_module
let of_comparator = Comparator.to_module

module For_quickcheck = struct
  let gen_tree ~comparator k_gen v_gen =
    Base_quickcheck.Generator.map_tree_using_comparator ~comparator k_gen v_gen
  ;;

  let quickcheck_generator ~comparator k_gen v_gen =
    Base_quickcheck.Generator.map_t_m (of_comparator comparator) k_gen v_gen
  ;;

  let obs_tree k_obs v_obs = Base_quickcheck.Observer.map_tree k_obs v_obs

  let shr_tree ~comparator k_shr v_shr =
    Base_quickcheck.Shrinker.map_tree_using_comparator ~comparator k_shr v_shr
  ;;
end

let quickcheck_generator = Base_quickcheck.Generator.map_t_m
let quickcheck_observer = Base_quickcheck.Observer.map_t
let quickcheck_shrinker = Base_quickcheck.Shrinker.map_t

module Using_comparator = struct
  include Map.Using_comparator
  include For_quickcheck

  let of_hashtbl_exn ~comparator hashtbl =
    match of_iteri ~comparator ~iteri:(Hashtbl.iteri hashtbl) with
    | `Ok map -> map
    | `Duplicate_key key ->
      Error.failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "map.ml.before-ppx"
          ; pos_lnum = 82
          ; pos_cnum = 2263
          ; pos_bol = 2249
          }
        "Map.of_hashtbl_exn: duplicate key"
        key
        comparator.sexp_of_t
  ;;

  let tree_of_hashtbl_exn ~comparator hashtbl =
    to_tree (of_hashtbl_exn ~comparator hashtbl)
  ;;

  let key_set ~comparator t =
    Base.Set.Using_comparator.of_sorted_array_unchecked
      ~comparator
      (List.to_array (keys t))
  ;;

  let key_set_of_tree ~comparator t = key_set ~comparator (of_tree ~comparator t)

  let of_key_set key_set ~f =
    of_sorted_array_unchecked
      ~comparator:(Base.Set.comparator key_set)
      (Array.map (Base.Set.to_array key_set) ~f:(fun key -> key, f key))
  ;;

  let tree_of_key_set key_set ~f = to_tree (of_key_set key_set ~f)
end

module Accessors = struct
  include (
    Map.Using_comparator :
      Map.Accessors_generic
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) Map.t
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) Tree.t
      with type 'k key := 'k
      with type 'c cmp := 'c)

  let validate ~name f t = Validate.alist ~name f (to_alist t)
  let validatei ~name f t = Validate.list ~name:(Fn.compose name fst) f (to_alist t)
  let quickcheck_observer k v = quickcheck_observer k v
  let quickcheck_shrinker k v = quickcheck_shrinker k v
  let key_set t = Using_comparator.key_set t ~comparator:(Using_comparator.comparator t)
end

let key_set t = Using_comparator.key_set ~comparator:(Using_comparator.comparator t) t
let of_key_set = Using_comparator.of_key_set
let hash_fold_direct = Using_comparator.hash_fold_direct
let comparator = Using_comparator.comparator
let comparator_s = Base.Map.comparator_s

type 'k key = 'k
type 'c cmp = 'c

include (
struct
  include Map

  let validate ~name f t = Validate.alist ~name f (to_alist t)
  let validatei ~name f t = Validate.list ~name:(Fn.compose name fst) f (to_alist t)
  let of_tree m = Map.Using_comparator.of_tree ~comparator:(to_comparator m)
  let to_tree = Map.Using_comparator.to_tree
end :
sig
  type ('a, 'b, 'c) t = ('a, 'b, 'c) Map.t

  include
    Map.Creators_and_accessors_generic
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Map.With_first_class_module.t
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Map.Without_comparator.t
    with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
    with type ('a, 'b, 'c) tree := ('a, 'b, 'c) Tree.t
    with type 'k key := 'k key
    with type 'c cmp := 'c cmp

  val validate : name:('k -> string) -> 'v Validate.check -> ('k, 'v, _) t Validate.check

  val validatei
    :  name:('k key -> string)
    -> ('k key * 'v) Validate.check
    -> ('k, 'v, _) t Validate.check
end)

module Empty_without_value_restriction = Using_comparator.Empty_without_value_restriction

let find_or_error t key =
  let comparator = comparator t in
  match find t key with
  | Some data -> Ok data
  | None ->
    let sexp_of_key = comparator.sexp_of_t in
    Or_error.error_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "key not found"
           ; (sexp_of_key [@merlin.hide]) key
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let merge_skewed = Map.merge_skewed
let of_hashtbl_exn m t = Using_comparator.of_hashtbl_exn ~comparator:(to_comparator m) t

module Creators (Key : Comparator.S1) : sig
  type ('a, 'b, 'c) t_ = ('a Key.t, 'b, Key.comparator_witness) t
  type ('a, 'b, 'c) tree = ('a, 'b, Key.comparator_witness) Tree.t

  val t_of_sexp
    :  (Base.Sexp.t -> 'a Key.t)
    -> (Base.Sexp.t -> 'b)
    -> Base.Sexp.t
    -> ('a, 'b, _) t_

  include
    Creators_generic
    with type ('a, 'b, 'c) t := ('a, 'b, 'c) t_
    with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
    with type 'a key := 'a Key.t
    with type 'a cmp := Key.comparator_witness
    with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
    with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
end = struct
  let comparator = Key.comparator

  type ('a, 'b, 'c) t_ = ('a Key.t, 'b, Key.comparator_witness) t
  type ('a, 'b, 'c) tree = ('a, 'b, Key.comparator_witness) Tree.t

  module M_empty = Empty_without_value_restriction (Key)

  let empty = M_empty.empty
  let of_tree tree = Using_comparator.of_tree ~comparator tree
  let singleton k v = Using_comparator.singleton ~comparator k v

  let of_sorted_array_unchecked array =
    Using_comparator.of_sorted_array_unchecked ~comparator array
  ;;

  let of_sorted_array array = Using_comparator.of_sorted_array ~comparator array

  let of_increasing_iterator_unchecked ~len ~f =
    Using_comparator.of_increasing_iterator_unchecked ~comparator ~len ~f
  ;;

  let of_increasing_sequence seq = Using_comparator.of_increasing_sequence ~comparator seq
  let of_sequence seq = Using_comparator.of_sequence ~comparator seq
  let of_sequence_or_error seq = Using_comparator.of_sequence_or_error ~comparator seq
  let of_sequence_exn seq = Using_comparator.of_sequence_exn ~comparator seq
  let of_sequence_multi seq = Using_comparator.of_sequence_multi ~comparator seq

  let of_sequence_fold seq ~init ~f =
    Using_comparator.of_sequence_fold ~comparator seq ~init ~f
  ;;

  let of_sequence_reduce seq ~f = Using_comparator.of_sequence_reduce ~comparator seq ~f

  let of_list_with_key list ~get_key =
    Using_comparator.of_list_with_key ~comparator list ~get_key
  ;;

  let of_list_with_key_or_error list ~get_key =
    Using_comparator.of_list_with_key_or_error ~comparator list ~get_key
  ;;

  let of_list_with_key_exn list ~get_key =
    Using_comparator.of_list_with_key_exn ~comparator list ~get_key
  ;;

  let of_list_with_key_multi list ~get_key =
    Using_comparator.of_list_with_key_multi ~comparator list ~get_key
  ;;

  let of_list_with_key_fold list ~get_key ~init ~f =
    Using_comparator.of_list_with_key_fold ~comparator list ~get_key ~init ~f
  ;;

  let of_list_with_key_reduce list ~get_key ~f =
    Using_comparator.of_list_with_key_reduce ~comparator list ~get_key ~f
  ;;

  let of_alist alist = Using_comparator.of_alist ~comparator alist
  let of_alist_or_error alist = Using_comparator.of_alist_or_error ~comparator alist
  let of_alist_exn alist = Using_comparator.of_alist_exn ~comparator alist
  let of_hashtbl_exn hashtbl = Using_comparator.of_hashtbl_exn ~comparator hashtbl
  let of_alist_multi alist = Using_comparator.of_alist_multi ~comparator alist

  let of_alist_fold alist ~init ~f =
    Using_comparator.of_alist_fold ~comparator alist ~init ~f
  ;;

  let of_alist_reduce alist ~f = Using_comparator.of_alist_reduce ~comparator alist ~f
  let of_iteri ~iteri = Using_comparator.of_iteri ~comparator ~iteri
  let of_iteri_exn ~iteri = Using_comparator.of_iteri_exn ~comparator ~iteri

  let t_of_sexp k_of_sexp v_of_sexp sexp =
    Using_comparator.t_of_sexp_direct ~comparator k_of_sexp v_of_sexp sexp
  ;;

  let of_key_set key_set ~f = Using_comparator.of_key_set key_set ~f
  let map_keys t ~f = Using_comparator.map_keys ~comparator t ~f
  let map_keys_exn t ~f = Using_comparator.map_keys_exn ~comparator t ~f
  let transpose_keys t = Using_comparator.transpose_keys ~comparator t

  let quickcheck_generator gen_k gen_v =
    Using_comparator.quickcheck_generator ~comparator gen_k gen_v
  ;;
end

module Make_tree_S1 (Key : Comparator.S1) = struct
  open Tree

  let comparator = Key.comparator
  let sexp_of_t = sexp_of_t
  let t_of_sexp a b c = t_of_sexp_direct a b c ~comparator
  let empty = empty_without_value_restriction
  let of_tree tree = tree
  let singleton a = singleton a ~comparator
  let of_sorted_array_unchecked a = of_sorted_array_unchecked a ~comparator
  let of_sorted_array a = of_sorted_array a ~comparator

  let of_increasing_iterator_unchecked ~len ~f =
    of_increasing_iterator_unchecked ~len ~f ~comparator
  ;;

  let of_increasing_sequence seq = of_increasing_sequence ~comparator seq
  let of_sequence s = of_sequence s ~comparator
  let of_sequence_or_error s = of_sequence_or_error s ~comparator
  let of_sequence_exn s = of_sequence_exn s ~comparator
  let of_sequence_multi s = of_sequence_multi s ~comparator
  let of_sequence_fold s ~init ~f = of_sequence_fold s ~init ~f ~comparator
  let of_sequence_reduce s ~f = of_sequence_reduce s ~f ~comparator
  let of_alist a = of_alist a ~comparator
  let of_alist_or_error a = of_alist_or_error a ~comparator
  let of_alist_exn a = of_alist_exn a ~comparator
  let of_hashtbl_exn a = Using_comparator.tree_of_hashtbl_exn a ~comparator
  let of_alist_multi a = of_alist_multi a ~comparator
  let of_alist_fold a ~init ~f = of_alist_fold a ~init ~f ~comparator
  let of_alist_reduce a ~f = of_alist_reduce a ~f ~comparator
  let of_list_with_key l ~get_key = of_list_with_key l ~get_key ~comparator

  let of_list_with_key_or_error l ~get_key =
    of_list_with_key_or_error l ~get_key ~comparator
  ;;

  let of_list_with_key_exn l ~get_key = of_list_with_key_exn l ~get_key ~comparator
  let of_list_with_key_multi l ~get_key = of_list_with_key_multi l ~get_key ~comparator

  let of_list_with_key_fold l ~get_key ~init ~f =
    of_list_with_key_fold l ~get_key ~init ~f ~comparator
  ;;

  let of_list_with_key_reduce l ~get_key ~f =
    of_list_with_key_reduce l ~get_key ~f ~comparator
  ;;

  let of_iteri ~iteri = of_iteri ~iteri ~comparator
  let of_iteri_exn ~iteri = of_iteri_exn ~iteri ~comparator
  let of_key_set = Using_comparator.tree_of_key_set
  let to_tree t = t
  let invariants a = invariants a ~comparator
  let is_empty a = is_empty a
  let length a = length a
  let set a ~key ~data = set a ~key ~data ~comparator
  let add a ~key ~data = add a ~key ~data ~comparator
  let add_exn a ~key ~data = add_exn a ~key ~data ~comparator
  let add_multi a ~key ~data = add_multi a ~key ~data ~comparator
  let remove_multi a b = remove_multi a b ~comparator
  let find_multi a b = find_multi a b ~comparator
  let change a b ~f = change a b ~f ~comparator
  let update a b ~f = update a b ~f ~comparator
  let find_exn a b = find_exn a b ~comparator
  let find a b = find a b ~comparator
  let remove a b = remove a b ~comparator
  let mem a b = mem a b ~comparator
  let iter_keys = iter_keys
  let iter = iter
  let iteri = iteri
  let iteri_until = iteri_until
  let iter2 a b ~f = iter2 a b ~f ~comparator
  let map = map
  let mapi = mapi
  let fold = fold
  let fold_until = fold_until
  let fold_right = fold_right
  let fold2 a b ~init ~f = fold2 a b ~init ~f ~comparator
  let filter_keys a ~f = filter_keys a ~f
  let filter a ~f = filter a ~f
  let filteri a ~f = filteri a ~f
  let filter_map a ~f = filter_map a ~f
  let filter_mapi a ~f = filter_mapi a ~f
  let partition_mapi t ~f = partition_mapi t ~f
  let partition_map t ~f = partition_map t ~f
  let partitioni_tf t ~f = partitioni_tf t ~f
  let partition_tf t ~f = partition_tf t ~f
  let combine_errors t = combine_errors t ~comparator
  let unzip = unzip
  let compare_direct a b c = compare_direct a b c ~comparator
  let equal a b c = equal a b c ~comparator
  let keys = keys
  let data = data
  let to_alist = to_alist
  let validate ~name f t = Validate.alist ~name f (to_alist t)
  let validatei ~name f t = Validate.list ~name:(Fn.compose name fst) f (to_alist t)
  let symmetric_diff a b ~data_equal = symmetric_diff a b ~data_equal ~comparator

  let fold_symmetric_diff a b ~data_equal ~init ~f =
    fold_symmetric_diff a b ~data_equal ~f ~init ~comparator
  ;;

  let merge a b ~f = merge a b ~f ~comparator
  let merge_disjoint_exn a b = merge_disjoint_exn a b ~comparator
  let merge_skewed a b ~combine = merge_skewed a b ~combine ~comparator
  let min_elt = min_elt
  let min_elt_exn = min_elt_exn
  let max_elt = max_elt
  let max_elt_exn = max_elt_exn
  let for_all = for_all
  let for_alli = for_alli
  let exists = exists
  let existsi = existsi
  let count = count
  let counti = counti
  let sum = sum
  let sumi = sumi
  let split a b = split a b ~comparator
  let split_le_gt a b = split_le_gt a b ~comparator
  let split_lt_ge a b = split_lt_ge a b ~comparator
  let append ~lower_part ~upper_part = append ~lower_part ~upper_part ~comparator

  let subrange t ~lower_bound ~upper_bound =
    subrange t ~lower_bound ~upper_bound ~comparator
  ;;

  let fold_range_inclusive t ~min ~max ~init ~f =
    fold_range_inclusive t ~min ~max ~init ~f ~comparator
  ;;

  let range_to_alist t ~min ~max = range_to_alist t ~min ~max ~comparator
  let closest_key a b c = closest_key a b c ~comparator
  let nth = nth
  let nth_exn = nth_exn
  let rank a b = rank a b ~comparator

  let to_sequence ?order ?keys_greater_or_equal_to ?keys_less_or_equal_to t =
    to_sequence ~comparator ?order ?keys_greater_or_equal_to ?keys_less_or_equal_to t
  ;;

  let binary_search t ~compare how v = binary_search ~comparator t ~compare how v

  let binary_search_segmented t ~segment_of how =
    binary_search_segmented ~comparator t ~segment_of how
  ;;

  let binary_search_subrange t ~compare ~lower_bound ~upper_bound =
    binary_search_subrange ~comparator t ~compare ~lower_bound ~upper_bound
  ;;

  module Make_applicative_traversals (A : Applicative.Lazy_applicative) = struct
    module Traversals = Make_applicative_traversals (A)

    let mapi = Traversals.mapi
    let filter_mapi = Traversals.filter_mapi
  end

  let key_set t = Using_comparator.key_set_of_tree ~comparator t
  let map_keys t ~f = map_keys t ~f ~comparator
  let map_keys_exn t ~f = map_keys_exn t ~f ~comparator
  let transpose_keys t = transpose_keys ~comparator ~comparator t
  let quickcheck_generator k v = For_quickcheck.gen_tree ~comparator k v
  let quickcheck_observer k v = For_quickcheck.obs_tree k v
  let quickcheck_shrinker k v = For_quickcheck.shr_tree ~comparator k v
end

module Make_tree_plain (Key : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  module Key_S1 = Comparator.S_to_S1 (Key)
  include Make_tree_S1 (Key_S1)

  type +'v t = (Key.t, 'v, Key.comparator_witness) Tree.t

  let sexp_of_t sexp_of_v t =
    sexp_of_t Key.sexp_of_t sexp_of_v ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide]) t
  ;;

  module Provide_of_sexp
      (X : sig
             type t [@@deriving of_sexp]

             include sig
               [@@@ocaml.warning "-32"]

               val t_of_sexp : Sexplib0.Sexp.t -> t
             end
             [@@ocaml.doc "@inline"] [@@merlin.hide]
           end
           with type t := Key.t) =
  struct
    let t_of_sexp v_of_sexp sexp = t_of_sexp X.t_of_sexp v_of_sexp sexp
  end
end

module Make_tree (Key : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  include Make_tree_plain (Key)
  include Provide_of_sexp (Key)
end

let init_for_bin_prot ~len ~f ~comparator =
  let map = Using_comparator.of_increasing_iterator_unchecked ~len ~f ~comparator in
  if invariants map
  then map
  else (
    match Using_comparator.of_iteri ~iteri:(iteri map) ~comparator with
    | `Ok map -> map
    | `Duplicate_key _key -> failwith "Map.bin_read_t: duplicate element in map")
;;

module Poly = struct
  include Creators (Comparator.Poly)

  type ('a, 'b, 'c) map = ('a, 'b, 'c) t
  type ('k, 'v) t = ('k, 'v, Comparator.Poly.comparator_witness) map
  type comparator_witness = Comparator.Poly.comparator_witness

  include Accessors

  let compare _ cmpv t1 t2 = compare_direct cmpv t1 t2

  let sexp_of_t sexp_of_k sexp_of_v t =
    Using_comparator.sexp_of_t
      sexp_of_k
      sexp_of_v
      ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      t
  ;;

  let t_sexp_grammar k_grammar v_grammar =
    Sexplib.Sexp_grammar.coerce (List.Assoc.t_sexp_grammar k_grammar v_grammar)
  ;;

  include Bin_prot.Utils.Make_iterable_binable2 (struct
      type nonrec ('a, 'b) t = ('a, 'b) t
      type ('a, 'b) el = 'a * 'b [@@deriving bin_io]

      include struct
        let _ = fun (_ : ('a, 'b) el) -> ()

        let bin_shape_el =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:517:4")
              [ ( Bin_prot.Shape.Tid.of_string "el"
                , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "b" ]
                , Bin_prot.Shape.tuple
                    [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:517:23")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ; Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:517:28")
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
          Bin_prot.Common.raise_variant_wrong_type "map.ml.before-ppx.Poly.el" !pos_ref
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

      let _ = bin_el

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "b7d7b1a0-4992-11e6-8a32-bbb221fa025c"
      ;;

      let module_name = Some "Core.Map"
      let length = length
      let iter t ~f = iteri t ~f:(fun ~key ~data -> f (key, data))

      let init ~len ~next =
        init_for_bin_prot
          ~len
          ~f:(fun _ -> next ())
          ~comparator:Comparator.Poly.comparator
      ;;
    end)

  module Tree = struct
    include Make_tree_S1 (Comparator.Poly)

    type ('k, +'v) t = ('k, 'v, Comparator.Poly.comparator_witness) tree
    type comparator_witness = Comparator.Poly.comparator_witness

    let sexp_of_t sexp_of_k sexp_of_v t =
      sexp_of_t sexp_of_k sexp_of_v ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide]) t
    ;;

    let t_sexp_grammar k_grammar v_grammar =
      Sexplib.Sexp_grammar.coerce (List.Assoc.t_sexp_grammar k_grammar v_grammar)
    ;;
  end
end

module type Key_plain = Key_plain
module type Key = Key
module type Key_binable = Key_binable
module type Key_hashable = Key_hashable
module type Key_binable_hashable = Key_binable_hashable
module type S_plain = S_plain
module type S = S
module type S_binable = S_binable

module Key_bin_io = Key_bin_io

module Provide_bin_io (Key : Key_bin_io.S) = Bin_prot.Utils.Make_iterable_binable1 (struct
    module Key = Key

    type nonrec 'v t = (Key.t, 'v, Key.comparator_witness) t
    type 'v el = Key.t * 'v [@@deriving bin_io]

    include struct
      let _ = fun (_ : 'v el) -> ()

      let bin_shape_el =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:563:2")
            [ ( Bin_prot.Shape.Tid.of_string "el"
              , [ Bin_prot.Shape.Vid.of_string "v" ]
              , Bin_prot.Shape.tuple
                  [ Key.bin_shape_t
                  ; Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:563:23")
                      (Bin_prot.Shape.Vid.of_string "v")
                  ] )
            ]
        in
        fun v -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ v ]
      ;;

      let _ = bin_shape_el

      let bin_size_el : 'v. 'v Bin_prot.Size.sizer -> 'v el Bin_prot.Size.sizer =
        fun _size_of_v -> function
        | v1, v2 ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Key.bin_size_t v1) in
          Bin_prot.Common.( + ) size (_size_of_v v2)
      ;;

      let _ = bin_size_el

      let bin_write_el : 'v. 'v Bin_prot.Write.writer -> 'v el Bin_prot.Write.writer =
        fun _write_v buf ~pos -> function
        | v1, v2 ->
          let pos = Key.bin_write_t buf ~pos v1 in
          _write_v buf ~pos v2
      ;;

      let _ = bin_write_el

      let bin_writer_el =
        (fun bin_writer_v ->
           { size = (fun v -> bin_size_el bin_writer_v.size v)
           ; write = (fun v -> bin_write_el bin_writer_v.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_el

      let __bin_read_el__
        : 'v. 'v Bin_prot.Read.reader -> (int -> 'v el) Bin_prot.Read.reader
        =
        fun _of__v _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "map.ml.before-ppx.Provide_bin_io.el"
          !pos_ref
      ;;

      let _ = __bin_read_el__

      let bin_read_el : 'v. 'v Bin_prot.Read.reader -> 'v el Bin_prot.Read.reader =
        fun _of__v buf ~pos_ref ->
        let v1 = Key.bin_read_t buf ~pos_ref in
        let v2 = _of__v buf ~pos_ref in
        v1, v2
      ;;

      let _ = bin_read_el

      let bin_reader_el =
        (fun bin_reader_v ->
           { read = (fun buf ~pos_ref -> (bin_read_el bin_reader_v.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_el__ bin_reader_v.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_el

      let bin_el =
        (fun bin_v ->
           { writer = bin_writer_el bin_v.writer
           ; reader = bin_reader_el bin_v.reader
           ; shape = bin_shape_el bin_v.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_el
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let _ = bin_el

    let caller_identity =
      Bin_prot.Shape.Uuid.of_string "dfb300f8-4992-11e6-9c15-73a2ac6b815c"
    ;;

    let module_name = Some "Core.Map"
    let length = length
    let iter t ~f = iteri t ~f:(fun ~key ~data -> f (key, data))

    let init ~len ~next =
      init_for_bin_prot ~len ~f:(fun _ -> next ()) ~comparator:Key.comparator
    ;;
  end)

module Provide_stable_witness (Key : sig
    type t [@@deriving stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  let stable_witness (type data) (_data_stable_witness : data Stable_witness.t)
    : (Key.t, data, Key.comparator_witness) t Stable_witness.t
    =
    let (_ : Key.t Stable_witness.t) = Key.stable_witness in
    Stable_witness.assert_stable
  ;;
end

module Make_plain_using_comparator (Key : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  module Key = Key
  module Key_S1 = Comparator.S_to_S1 (Key)
  include Creators (Key_S1)

  type key = Key.t
  type ('a, 'b, 'c) map = ('a, 'b, 'c) t
  type 'v t = (key, 'v, Key.comparator_witness) map

  include Accessors

  let compare cmpv t1 t2 = compare_direct cmpv t1 t2

  let sexp_of_t sexp_of_v t =
    Using_comparator.sexp_of_t
      Key.sexp_of_t
      sexp_of_v
      ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      t
  ;;

  module Diff = struct
    type 'a derived_on = 'a t
    type ('a, 'a_diff) t = (Key.t, 'a, 'a_diff) Diffable.Map_diff.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : ('a, 'a_diff) t) -> ()

      let sexp_of_t
        :  'a 'a_diff.
           ('a -> Sexplib0.Sexp.t)
        -> ('a_diff -> Sexplib0.Sexp.t)
        -> ('a, 'a_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a__059_ _of_a_diff__060_ x__061_ ->
        Diffable.Map_diff.sexp_of_t Key.sexp_of_t _of_a__059_ _of_a_diff__060_ x__061_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let get = Diffable.Map_diff.get
    let apply_exn = Diffable.Map_diff.apply_exn
    let of_list_exn = Diffable.Map_diff.of_list_exn
  end

  module Provide_of_sexp
      (Key : sig
               type t [@@deriving of_sexp]

               include sig
                 [@@@ocaml.warning "-32"]

                 val t_of_sexp : Sexplib0.Sexp.t -> t
               end
               [@@ocaml.doc "@inline"] [@@merlin.hide]
             end
             with type t := Key.t) =
  struct
    let t_of_sexp v_of_sexp sexp = t_of_sexp Key.t_of_sexp v_of_sexp sexp

    module Diff = struct
      include Diff

      let t_of_sexp v_of_sexp v_diff_of_sexp sexp =
        Diffable.Map_diff.t_of_sexp Key.t_of_sexp v_of_sexp v_diff_of_sexp sexp
      ;;
    end
  end

  module Provide_hash (Key' : Hasher.S with type t := Key.t) = struct
    let hash_fold_t (type a) hash_fold_data state (t : a t) =
      Using_comparator.hash_fold_direct Key'.hash_fold_t hash_fold_data state t
    ;;
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
              with type t := Key.t) =
  Provide_bin_io (struct
      include Key
      include Key'
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
              with type t := Key.t) =
  Provide_stable_witness (struct
      include Key
      include Key'
    end)
end

module Make_plain (Key : Key_plain) = Make_plain_using_comparator (struct
    include Key
    include Comparator.Make (Key)
  end)

module Make_using_comparator (Key_sexp : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  include Make_plain_using_comparator (Key_sexp)
  module Key = Key_sexp
  include Provide_of_sexp (Key)

  module _ = struct
    include Tree
    include Provide_of_sexp (Key)
  end
end

module Make (Key : Key) = Make_using_comparator (struct
    include Key
    include Comparator.Make (Key)
  end)

module Make_binable_using_comparator (Key_bin_sexp : sig
    type t [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.S with type t := t
  end) =
struct
  include Make_using_comparator (Key_bin_sexp)
  module Key = Key_bin_sexp
  include Provide_bin_io (Key)

  module Diff = struct
    include Diff

    type ('a, 'a_diff) t = (Key.t, 'a, 'a_diff) Diffable.Map_diff.t
    [@@deriving bin_io, sexp]

    include struct
      let _ = fun (_ : ('a, 'a_diff) t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:710:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a"
                ; Bin_prot.Shape.Vid.of_string "a_diff"
                ]
              , ((Diffable.Map_diff.bin_shape_t Key.bin_shape_t)
                   (Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:710:35")
                      (Bin_prot.Shape.Vid.of_string "a")))
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "map.ml.before-ppx:710:39")
                     (Bin_prot.Shape.Vid.of_string "a_diff")) )
            ]
        in
        fun a a_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; a_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a 'a_diff.
           'a Bin_prot.Size.sizer
        -> 'a_diff Bin_prot.Size.sizer
        -> ('a, 'a_diff) t Bin_prot.Size.sizer
        =
        fun _size_of_a _size_of_a_diff v ->
        Diffable.Map_diff.bin_size_t Key.bin_size_t _size_of_a _size_of_a_diff v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a 'a_diff.
           'a Bin_prot.Write.writer
        -> 'a_diff Bin_prot.Write.writer
        -> ('a, 'a_diff) t Bin_prot.Write.writer
        =
        fun _write_a _write_a_diff buf ~pos v ->
        Diffable.Map_diff.bin_write_t Key.bin_write_t _write_a _write_a_diff buf ~pos v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a bin_writer_a_diff ->
           { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_a_diff.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_a_diff.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a 'a_diff.
           'a Bin_prot.Read.reader
        -> 'a_diff Bin_prot.Read.reader
        -> (int -> ('a, 'a_diff) t) Bin_prot.Read.reader
        =
        fun _of__a _of__a_diff buf ~pos_ref vint ->
        (Diffable.Map_diff.__bin_read_t__ Key.bin_read_t _of__a _of__a_diff)
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a 'a_diff.
           'a Bin_prot.Read.reader
        -> 'a_diff Bin_prot.Read.reader
        -> ('a, 'a_diff) t Bin_prot.Read.reader
        =
        fun _of__a _of__a_diff buf ~pos_ref ->
        (Diffable.Map_diff.bin_read_t Key.bin_read_t _of__a _of__a_diff) buf ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a bin_reader_a_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_a.read bin_reader_a_diff.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read bin_reader_a_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a bin_a_diff ->
           { writer = bin_writer_t bin_a.writer bin_a_diff.writer
           ; reader = bin_reader_t bin_a.reader bin_a_diff.reader
           ; shape = bin_shape_t bin_a.shape bin_a_diff.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let t_of_sexp
        :  'a 'a_diff.
           (Sexplib0.Sexp.t -> 'a)
        -> (Sexplib0.Sexp.t -> 'a_diff)
        -> Sexplib0.Sexp.t
        -> ('a, 'a_diff) t
        =
        fun _of_a__062_ _of_a_diff__063_ x__065_ ->
        Diffable.Map_diff.t_of_sexp Key.t_of_sexp _of_a__062_ _of_a_diff__063_ x__065_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a 'a_diff.
           ('a -> Sexplib0.Sexp.t)
        -> ('a_diff -> Sexplib0.Sexp.t)
        -> ('a, 'a_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a__066_ _of_a_diff__067_ x__068_ ->
        Diffable.Map_diff.sexp_of_t Key.sexp_of_t _of_a__066_ _of_a_diff__067_ x__068_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Make_binable (Key : Key_binable) = Make_binable_using_comparator (struct
    include Key
    include Comparator.Make (Key)
  end)

module For_deriving = struct
  module M = Map.M

  let bin_shape_m__t (type t) (type c) (m : (t, c) Key_bin_io.t) =
    let module M = Provide_bin_io ((val m)) in
    M.bin_shape_t
  ;;

  let bin_size_m__t (type t) (type c) (m : (t, c) Key_bin_io.t) =
    let module M = Provide_bin_io ((val m)) in
    M.bin_size_t
  ;;

  let bin_write_m__t (type t) (type c) (m : (t, c) Key_bin_io.t) =
    let module M = Provide_bin_io ((val m)) in
    M.bin_write_t
  ;;

  let bin_read_m__t (type t) (type c) (m : (t, c) Key_bin_io.t) =
    let module M = Provide_bin_io ((val m)) in
    M.bin_read_t
  ;;

  let __bin_read_m__t__ (type t) (type c) (m : (t, c) Key_bin_io.t) =
    let module M = Provide_bin_io ((val m)) in
    M.__bin_read_t__
  ;;

  module type Quickcheck_generator_m = sig
    include Comparator.S

    val quickcheck_generator : t Quickcheck.Generator.t
  end

  module type Quickcheck_observer_m = sig
    include Comparator.S

    val quickcheck_observer : t Quickcheck.Observer.t
  end

  module type Quickcheck_shrinker_m = sig
    include Comparator.S

    val quickcheck_shrinker : t Quickcheck.Shrinker.t
  end

  let quickcheck_generator_m__t
        (type k)
        (type cmp)
        ((module Key) :
          (module Quickcheck_generator_m with type t = k and type comparator_witness = cmp))
        v_generator
    =
    quickcheck_generator (module Key) Key.quickcheck_generator v_generator
  ;;

  let quickcheck_observer_m__t
        (type k)
        (type cmp)
        ((module Key) :
          (module Quickcheck_observer_m with type t = k and type comparator_witness = cmp))
        v_observer
    =
    quickcheck_observer Key.quickcheck_observer v_observer
  ;;

  let quickcheck_shrinker_m__t
        (type k)
        (type cmp)
        ((module Key) :
          (module Quickcheck_shrinker_m with type t = k and type comparator_witness = cmp))
        v_shrinker
    =
    quickcheck_shrinker Key.quickcheck_shrinker v_shrinker
  ;;

  module type For_deriving = Map.For_deriving

  include (Map : For_deriving with type ('a, 'b, 'c) t := ('a, 'b, 'c) t)
end

module For_deriving_stable = struct
  module type Stable_witness_m = sig
    include Comparator.S

    val stable_witness : t Stable_witness.t
  end

  let stable_witness_m__t
        (type k)
        (type cmp)
        ((module Key) :
          (module Stable_witness_m with type t = k and type comparator_witness = cmp))
    =
    let module M = Provide_stable_witness (Key) in
    M.stable_witness
  ;;
end

include For_deriving

module Tree = struct
  include Tree

  let validate ~name f t = Validate.alist ~name f (to_alist t)
  let validatei ~name f t = Validate.list ~name:(Fn.compose name fst) f (to_alist t)
  let of_hashtbl_exn = Using_comparator.tree_of_hashtbl_exn
  let key_set = Using_comparator.key_set_of_tree
  let of_key_set = Using_comparator.tree_of_key_set
  let quickcheck_generator ~comparator k v = For_quickcheck.gen_tree ~comparator k v
  let quickcheck_observer k v = For_quickcheck.obs_tree k v
  let quickcheck_shrinker ~comparator k v = For_quickcheck.shr_tree ~comparator k v
end

module Stable = struct
  module V1 = struct
    type nonrec ('k, 'v, 'cmp) t = ('k, 'v, 'cmp) t

    module type S = sig
      type key
      type comparator_witness
      type nonrec 'a t = (key, 'a, comparator_witness) t

      include Stable_module_types.S1 with type 'a t := 'a t

      include
        Diffable.S1
        with type 'a t := 'a t
         and type ('a, 'a_diff) Diff.t = (key, 'a, 'a_diff) Diffable.Map_diff.Stable.V1.t
    end

    include For_deriving
    include For_deriving_stable
    module Make (Key : Stable_module_types.S0) = Make_binable_using_comparator (Key)

    module With_stable_witness = struct
      module type S = sig
        include S

        val stable_witness : 'a Stable_witness.t -> 'a t Stable_witness.t
      end

      module Make (Key_stable : Stable_module_types.With_stable_witness.S0) = struct
        include Make (Key_stable)
        include Provide_stable_witness (Key_stable)
      end
    end
  end

  module Symmetric_diff_element = Symmetric_diff_element.Stable
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
