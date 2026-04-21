let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"nonempty_list.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "nonempty_list.ml.before-ppx"
;;

open Core.Core_stable

module Stable = struct
  module V3 = struct
    module T = struct
      type nonrec 'a t = ( :: ) of 'a * 'a list [@@deriving compare, equal, hash]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__001_ b__002_ ->
          if Stdlib.( == ) a__001_ b__002_
          then 0
          else (
            match a__001_, b__002_ with
            | _a__003_ :: _a__005_, _b__004_ :: _b__006_ ->
              (match _cmp__a _a__003_ _b__004_ with
               | 0 ->
                 compare_list
                   (fun a__007_ (b__008_ [@merlin.hide]) ->
                      (_cmp__a a__007_ b__008_ [@merlin.hide]))
                   _a__005_
                   _b__006_
               | n -> n))
        ;;

        let _ = compare

        let equal
          : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
          =
          fun _cmp__a a__009_ b__010_ ->
          if Stdlib.( == ) a__009_ b__010_
          then true
          else (
            match a__009_, b__010_ with
            | _a__011_ :: _a__013_, _b__012_ :: _b__014_ ->
              Stdlib.( && )
                (_cmp__a _a__011_ _b__012_)
                (equal_list
                   (fun a__015_ (b__016_ [@merlin.hide]) ->
                      (_cmp__a a__015_ b__016_ [@merlin.hide]))
                   _a__013_
                   _b__014_))
        ;;

        let _ = equal

        let hash_fold_t
          : type a.
            (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
            -> Ppx_hash_lib.Std.Hash.state
            -> a t
            -> Ppx_hash_lib.Std.Hash.state
          =
          fun _hash_fold_a hsv arg ->
          match arg with
          | _a0 :: _a1 ->
            let hsv = hsv in
            let hsv =
              let hsv = hsv in
              _hash_fold_a hsv _a0
            in
            hash_fold_list (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
        ;;

        let _ = hash_fold_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_list (hd :: tl) : _ list = hd :: tl

      let of_list_exn : _ list -> _ t = function
        | [] ->
          Core.raise_s
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Nonempty_list.of_list_exn: empty list"
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
        | hd :: tl -> hd :: tl
      ;;
    end

    include T

    module Format = struct
      type 'a t = 'a list [@@deriving bin_io, sexp, stable_witness]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "nonempty_list.ml.before-ppx:19:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , bin_shape_list
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string
                          "nonempty_list.ml.before-ppx:19:18")
                       (Bin_prot.Shape.Vid.of_string "a")) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> bin_size_list _size_of_a v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v -> bin_write_list _write_a buf ~pos v
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
          fun _of__a buf ~pos_ref vint -> (__bin_read_list__ _of__a) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref -> (bin_read_list _of__a) buf ~pos_ref
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
          fun _of_a__017_ x__019_ -> list_of_sexp _of_a__017_ x__019_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__020_ x__021_ -> sexp_of_list _of_a__020_ x__021_
        ;;

        let _ = sexp_of_t

        let stable_witness
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _
            :  'a Ppx_stable_witness_runtime.Stable_witness.t
            -> 'a list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include
      Binable.Of_binable1.V2
        (Format)
        (struct
          include T

          let to_binable = to_list
          let of_binable = of_list_exn

          let caller_identity =
            Bin_prot.Shape.Uuid.of_string "9a63aaee-82e0-11ea-8fb6-aa00005c6184"
          ;;
        end)

    include
      Sexpable.Of_sexpable1.V1
        (Format)
        (struct
          include T

          let to_sexpable = to_list
          let of_sexpable = of_list_exn
        end)

    let t_sexp_grammar (type a) ({ untyped = element } : a Sexplib0.Sexp_grammar.t)
      : a t Sexplib0.Sexp_grammar.t
      =
      { untyped = List (Cons (element, Many element)) }
    ;;

    let stable_witness (type a) =
      (fun witness ->
         let module Stable_witness = Stable_witness.Of_serializable1 (Format) (T) in
         Stable_witness.of_serializable Format.stable_witness of_list_exn to_list witness
       : a Stable_witness.t -> a t Stable_witness.t)
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"nonempty_list.ml.before-ppx"
          ~line_number:58
          ~location:{ start_bol = 1471; start_pos = 1475; end_pos = 1591 }
          ~trailing_loc:{ start_bol = 1537; start_pos = 1591; end_pos = 1591 }
          ~body_loc:{ start_bol = 1471; start_pos = 1475; end_pos = 1591 }
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
                        ( { contents = " eaa5c1535ea5c1691291b3bdbbd7b014 "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 1537; start_pos = 1552; end_pos = 1590 } ))
                   ~node_loc:{ start_bol = 1537; start_pos = 1543; end_pos = 1591 } )
             ]
            [@merlin.hide])
          (fun () ->
             print_endline
               (Bin_prot.Shape.Digest.to_hex
                  (Bin_prot.Shape.eval_to_digest (bin_shape_t bin_shape_int)));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
    ;;
  end

  module V2 = struct
    module T = struct
      type nonrec 'a t = 'a V3.t = ( :: ) of 'a * 'a list
      [@@deriving compare, equal, hash]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__022_ b__023_ ->
          if Stdlib.( == ) a__022_ b__023_
          then 0
          else (
            match a__022_, b__023_ with
            | _a__024_ :: _a__026_, _b__025_ :: _b__027_ ->
              (match _cmp__a _a__024_ _b__025_ with
               | 0 ->
                 compare_list
                   (fun a__028_ (b__029_ [@merlin.hide]) ->
                      (_cmp__a a__028_ b__029_ [@merlin.hide]))
                   _a__026_
                   _b__027_
               | n -> n))
        ;;

        let _ = compare

        let equal
          : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
          =
          fun _cmp__a a__030_ b__031_ ->
          if Stdlib.( == ) a__030_ b__031_
          then true
          else (
            match a__030_, b__031_ with
            | _a__032_ :: _a__034_, _b__033_ :: _b__035_ ->
              Stdlib.( && )
                (_cmp__a _a__032_ _b__033_)
                (equal_list
                   (fun a__036_ (b__037_ [@merlin.hide]) ->
                      (_cmp__a a__036_ b__037_ [@merlin.hide]))
                   _a__034_
                   _b__035_))
        ;;

        let _ = equal

        let hash_fold_t
          : type a.
            (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
            -> Ppx_hash_lib.Std.Hash.state
            -> a t
            -> Ppx_hash_lib.Std.Hash.state
          =
          fun _hash_fold_a hsv arg ->
          match arg with
          | _a0 :: _a1 ->
            let hsv = hsv in
            let hsv =
              let hsv = hsv in
              _hash_fold_a hsv _a0
            in
            hash_fold_list (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
        ;;

        let _ = hash_fold_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let sexp_of_t = V3.sexp_of_t
      let t_of_sexp = V3.t_of_sexp
    end

    include T

    module Record_format = struct
      type 'a t =
        { hd : 'a
        ; tl : 'a list
        }
      [@@deriving bin_io, compare, stable_witness]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "nonempty_list.ml.before-ppx:76:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.record
                    [ ( "hd"
                      , Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "nonempty_list.ml.before-ppx:77:15")
                          (Bin_prot.Shape.Vid.of_string "a") )
                    ; ( "tl"
                      , bin_shape_list
                          (Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "nonempty_list.ml.before-ppx:78:15")
                             (Bin_prot.Shape.Vid.of_string "a")) )
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | { hd = v1; tl = v2 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
            Bin_prot.Common.( + ) size (bin_size_list _size_of_a v2)
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | { hd = v1; tl = v2 } ->
            let pos = _write_a buf ~pos v1 in
            bin_write_list _write_a buf ~pos v2
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
          fun _of__a _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "nonempty_list.ml.before-ppx.Stable.V2.Record_format.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          let v_hd = _of__a buf ~pos_ref in
          let v_tl = (bin_read_list _of__a) buf ~pos_ref in
          { hd = v_hd; tl = v_tl }
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
          fun _cmp__a a__038_ b__039_ ->
          if Stdlib.( == ) a__038_ b__039_
          then 0
          else (
            match _cmp__a a__038_.hd b__039_.hd with
            | 0 ->
              compare_list
                (fun a__040_ (b__041_ [@merlin.hide]) ->
                   (_cmp__a a__040_ b__041_ [@merlin.hide]))
                a__038_.tl
                b__039_.tl
            | n -> n)
        ;;

        let _ = compare

        let stable_witness
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness
          and _
            :  'a Ppx_stable_witness_runtime.Stable_witness.t
            -> 'a list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_nonempty_list (hd :: tl) = { hd; tl }
      let to_nonempty_list { hd; tl } = hd :: tl
    end

    include
      Binable.Of_binable1.V1 [@alert "-legacy"]
        (Record_format)
        (struct
          include T

          let to_binable = Record_format.of_nonempty_list
          let of_binable = Record_format.to_nonempty_list
        end)

    let stable_witness (type a) =
      (fun witness ->
         let module Stable_witness = Stable_witness.Of_serializable1 (Record_format) (T)
         in
         Stable_witness.of_serializable
           Record_format.stable_witness
           Record_format.to_nonempty_list
           Record_format.of_nonempty_list
           witness
       : a Stable_witness.t -> a t Stable_witness.t)
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"nonempty_list.ml.before-ppx"
          ~line_number:106
          ~location:{ start_bol = 2722; start_pos = 2726; end_pos = 2842 }
          ~trailing_loc:{ start_bol = 2788; start_pos = 2842; end_pos = 2842 }
          ~body_loc:{ start_bol = 2722; start_pos = 2726; end_pos = 2842 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 4)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 5)
          ~description:None
          ~tags:[]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 3
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 2aede2e9b03754f5dfa5f1a61877b330 "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 2788; start_pos = 2803; end_pos = 2841 } ))
                   ~node_loc:{ start_bol = 2788; start_pos = 2794; end_pos = 2842 } )
             ]
            [@merlin.hide])
          (fun () ->
             print_endline
               (Bin_prot.Shape.Digest.to_hex
                  (Bin_prot.Shape.eval_to_digest (bin_shape_t bin_shape_int)));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide])
    ;;
  end

  module V1 = struct
    module T = struct
      type 'a t = 'a V2.t = ( :: ) of 'a * 'a list [@@deriving compare, equal]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__042_ b__043_ ->
          if Stdlib.( == ) a__042_ b__043_
          then 0
          else (
            match a__042_, b__043_ with
            | _a__044_ :: _a__046_, _b__045_ :: _b__047_ ->
              (match _cmp__a _a__044_ _b__045_ with
               | 0 ->
                 compare_list
                   (fun a__048_ (b__049_ [@merlin.hide]) ->
                      (_cmp__a a__048_ b__049_ [@merlin.hide]))
                   _a__046_
                   _b__047_
               | n -> n))
        ;;

        let _ = compare

        let equal
          : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
          =
          fun _cmp__a a__050_ b__051_ ->
          if Stdlib.( == ) a__050_ b__051_
          then true
          else (
            match a__050_, b__051_ with
            | _a__052_ :: _a__054_, _b__053_ :: _b__055_ ->
              Stdlib.( && )
                (_cmp__a _a__052_ _b__053_)
                (equal_list
                   (fun a__056_ (b__057_ [@merlin.hide]) ->
                      (_cmp__a a__056_ b__057_ [@merlin.hide]))
                   _a__054_
                   _b__055_))
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let sexp_of_t = V2.sexp_of_t
      let t_of_sexp = V2.t_of_sexp
    end

    include T

    module Pair_format = struct
      type 'a t = 'a * 'a list [@@deriving bin_io, compare, stable_witness]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "nonempty_list.ml.before-ppx:123:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.tuple
                    [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string
                           "nonempty_list.ml.before-ppx:123:18")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ; bin_shape_list
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "nonempty_list.ml.before-ppx:123:23")
                           (Bin_prot.Shape.Vid.of_string "a"))
                    ] )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
            Bin_prot.Common.( + ) size (bin_size_list _size_of_a v2)
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos -> function
          | v1, v2 ->
            let pos = _write_a buf ~pos v1 in
            bin_write_list _write_a buf ~pos v2
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
          fun _of__a _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "nonempty_list.ml.before-ppx.Stable.V1.Pair_format.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          let v1 = _of__a buf ~pos_ref in
          let v2 = (bin_read_list _of__a) buf ~pos_ref in
          v1, v2
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
          fun _cmp__a a__058_ b__059_ ->
          let t__060_, t__061_ = a__058_ in
          let t__062_, t__063_ = b__059_ in
          match _cmp__a t__060_ t__062_ with
          | 0 ->
            compare_list
              (fun a__064_ (b__065_ [@merlin.hide]) ->
                 (_cmp__a a__064_ b__065_ [@merlin.hide]))
              t__061_
              t__063_
          | n -> n
        ;;

        let _ = compare

        let stable_witness
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
          =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__
              (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
              ()
          =
          let _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness
          and _
            :  'a Ppx_stable_witness_runtime.Stable_witness.t
            -> 'a list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_nonempty_list (hd :: tl) = hd, tl
      let to_nonempty_list (hd, tl) = hd :: tl
    end

    include
      Binable.Of_binable1.V1 [@alert "-legacy"]
        (Pair_format)
        (struct
          include T

          let to_binable = Pair_format.of_nonempty_list
          let of_binable = Pair_format.to_nonempty_list
        end)

    let stable_witness (type a) =
      (fun witness ->
         let module Stable_witness = Stable_witness.Of_serializable1 (Pair_format) (T) in
         Stable_witness.of_serializable
           Pair_format.stable_witness
           Pair_format.to_nonempty_list
           Pair_format.of_nonempty_list
           witness
       : a Stable_witness.t -> a t Stable_witness.t)
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"nonempty_list.ml.before-ppx"
          ~line_number:149
          ~location:{ start_bol = 3888; start_pos = 3892; end_pos = 4008 }
          ~trailing_loc:{ start_bol = 3954; start_pos = 4008; end_pos = 4008 }
          ~body_loc:{ start_bol = 3888; start_pos = 3892; end_pos = 4008 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 7)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 8)
          ~description:None
          ~tags:[]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 6
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " f27871ef428aef2925f18d6be687bf9c "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 3954; start_pos = 3969; end_pos = 4007 } ))
                   ~node_loc:{ start_bol = 3954; start_pos = 3960; end_pos = 4008 } )
             ]
            [@merlin.hide])
          (fun () ->
             print_endline
               (Bin_prot.Shape.Digest.to_hex
                  (Bin_prot.Shape.eval_to_digest (bin_shape_t bin_shape_int)));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 6) [@merlin.hide])
    ;;
  end
end

open Core
module Unstable = Stable.V3

module T' = struct
  type 'a t = 'a Stable.V3.t = ( :: ) of 'a * 'a list
  [@@deriving compare, equal, hash, quickcheck, typerep, bin_io, globalize]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__066_ b__067_ ->
      if Stdlib.( == ) a__066_ b__067_
      then 0
      else (
        match a__066_, b__067_ with
        | _a__068_ :: _a__070_, _b__069_ :: _b__071_ ->
          (match _cmp__a _a__068_ _b__069_ with
           | 0 ->
             compare_list
               (fun a__072_ (b__073_ [@merlin.hide]) ->
                  (_cmp__a a__072_ b__073_ [@merlin.hide]))
               _a__070_
               _b__071_
           | n -> n))
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__074_ b__075_ ->
      if Stdlib.( == ) a__074_ b__075_
      then true
      else (
        match a__074_, b__075_ with
        | _a__076_ :: _a__078_, _b__077_ :: _b__079_ ->
          Stdlib.( && )
            (_cmp__a _a__076_ _b__077_)
            (equal_list
               (fun a__080_ (b__081_ [@merlin.hide]) ->
                  (_cmp__a a__080_ b__081_ [@merlin.hide]))
               _a__078_
               _b__079_))
    ;;

    let _ = equal

    let hash_fold_t
      : type a.
        (Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> a t
        -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      match arg with
      | _a0 :: _a1 ->
        let hsv = hsv in
        let hsv =
          let hsv = hsv in
          _hash_fold_a hsv _a0
        in
        hash_fold_list (fun hsv arg -> _hash_fold_a hsv arg) hsv _a1
    ;;

    let _ = hash_fold_t

    let quickcheck_generator _generator__091_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__092_ ~random:_random__093_ ->
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   _generator__091_
                   ~size:_size__092_
                   ~random:_random__093_
                 :: Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      (quickcheck_generator_list _generator__091_)
                      ~size:_size__092_
                      ~random:_random__093_) )
        ]
    ;;

    let _ = quickcheck_generator

    let quickcheck_observer _observer__085_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__086_ ~size:_size__087_ ~hash:_hash__088_ ->
           match _x__086_ with
           | _x__089_ :: _x__090_ ->
             let _hash__088_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__088_ 0 in
             let _hash__088_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__085_
                 _x__089_
                 ~size:_size__087_
                 ~hash:_hash__088_
             in
             let _hash__088_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_list _observer__085_)
                 _x__090_
                 ~size:_size__087_
                 ~hash:_hash__088_
             in
             _hash__088_)
    ;;

    let _ = quickcheck_observer

    let quickcheck_shrinker _shrinker__082_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
          | _x__083_ :: _x__084_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__082_
                   _x__083_)
                ~f:(fun _x__083_ -> _x__083_ :: _x__084_)
            ; Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   (quickcheck_shrinker_list _shrinker__082_)
                   _x__084_)
                ~f:(fun _x__084_ -> _x__083_ :: _x__084_)
            ])
    ;;

    let _ = quickcheck_shrinker

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a t

        let name = "nonempty_list.ml.before-ppx.T'.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a in
      Typerep_lib.Std.Typerep.Named
        ( name_of_t
        , Some
            (lazy
              (let tag0 =
                 Typerep_lib.Std.Typerep.Tag.internal_use_only
                   { Typerep_lib.Std.Typerep.Tag_internal.label = "::"
                   ; rep = typerep_of_tuple2 _of_a (typerep_of_list _of_a)
                   ; arity = 2
                   ; args_labels = []
                   ; index = 0
                   ; ocaml_repr = 0
                   ; tyid = Typerep_lib.Std.Typename.create ()
                   ; create =
                       Typerep_lib.Std.Typerep.Tag_internal.Args
                         (fun (v0, v1) -> v0 :: v1)
                   }
               in
               let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
               let tags = [| Typerep_lib.Std.Typerep.Variant_internal.Tag tag0 |] in
               let polymorphic = false in
               let value = function
                 | v0 :: v1 ->
                   Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, (v0, v1))
               in
               Typerep_lib.Std.Typerep.Variant
                 (Typerep_lib.Std.Typerep.Variant.internal_use_only
                    { Typerep_lib.Std.Typerep.Variant_internal.typename
                    ; Typerep_lib.Std.Typerep.Variant_internal.tags
                    ; Typerep_lib.Std.Typerep.Variant_internal.polymorphic
                    ; Typerep_lib.Std.Typerep.Variant_internal.value
                    }))) )
    ;;

    let _ = typerep_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "nonempty_list.ml.before-ppx:160:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Bin_prot.Shape.variant
                [ ( "::"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string
                           "nonempty_list.ml.before-ppx:160:41")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ; bin_shape_list
                        (Bin_prot.Shape.var
                           (Bin_prot.Shape.Location.of_string
                              "nonempty_list.ml.before-ppx:160:46")
                           (Bin_prot.Shape.Vid.of_string "a"))
                    ] )
                ] )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a -> function
      | v1 :: v2 ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
        Bin_prot.Common.( + ) size (bin_size_list _size_of_a v2)
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos -> function
      | v1 :: v2 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
        let pos = _write_a buf ~pos v1 in
        bin_write_list _write_a buf ~pos v2
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
      fun _of__a _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "nonempty_list.ml.before-ppx.T'.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 ->
        let arg_1 = _of__a buf ~pos_ref in
        let arg_2 = (bin_read_list _of__a) buf ~pos_ref in
        arg_1 :: arg_2
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag "nonempty_list.ml.before-ppx.T'.t")
          !pos_ref
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

    let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
      fun (type a__094_) ->
      (fun _globalize_a__095_ x__096_ ->
         match x__096_ with
         | arg__099_ :: arg__097_ ->
           _globalize_a__095_ arg__099_ :: globalize_list _globalize_a__095_ arg__097_
       : (a__094_ -> a__094_) -> a__094_ t -> a__094_ t)
    ;;

    let _ = globalize
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let sexp_of_t = Stable.V3.sexp_of_t
  let t_of_sexp = Stable.V3.t_of_sexp
  let t_sexp_grammar = Stable.V3.t_sexp_grammar
  let to_list = Stable.V3.to_list
  let of_list_exn = Stable.V3.of_list_exn
  let hd (hd :: _) = hd
  let tl (_ :: tl) = tl

  let of_list = function
    | [] -> None
    | hd :: tl -> Some (hd :: tl)
  ;;

  let of_list_error = function
    | [] ->
      Core.error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Conv.sexp_of_string "empty list"
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | hd :: tl -> Ok (hd :: tl)
  ;;

  let fold (hd :: tl) ~init ~f = List.fold tl ~init:(f init hd) ~f
  let foldi = `Define_using_fold

  let iter =
    `Custom
      (fun (hd :: tl) ~f ->
        f hd;
        List.iter tl ~f)
  ;;

  let iteri = `Define_using_fold
  let length = `Custom (fun (_ :: tl) -> 1 + List.length tl)
end

include T'
include Comparator.Derived (T')

include struct
  let is_empty _ = false
  let to_list = to_list

  module From_indexed_container_make = Indexed_container.Make (T')
  open From_indexed_container_make

  let mem = mem
  let length = length
  let iter = iter
  let fold = fold
  let fold_result = fold_result
  let fold_until = fold_until
  let exists = exists
  let for_all = for_all
  let count = count
  let sum = sum
  let find = find
  let find_map = find_map
  let to_array = to_array
  let min_elt = min_elt
  let max_elt = max_elt
  let iteri = iteri
  let find_mapi = find_mapi
  let findi = findi
  let counti = counti
  let for_alli = for_alli
  let existsi = existsi
  let foldi = foldi
end

let invariant f t = iter t ~f
let create hd tl = hd :: tl
let singleton hd = [ hd ]
let cons x (hd :: tl) = x :: hd :: tl

let nth (hd :: tl) n =
  match n with
  | 0 -> Some hd
  | n -> List.nth tl (n - 1)
;;

let nth_exn t n =
  match nth t n with
  | None ->
    invalid_argf "Nonempty_list.nth_exn %d called on list of length %d" n (length t) ()
  | Some a -> a
;;

let mapi (hd :: tl) ~f =
  let hd = f 0 hd in
  hd :: List.mapi tl ~f:(fun i x -> f (i + 1) x)
;;

let filter_map (hd :: tl) ~f : _ list =
  match f hd with
  | None -> List.filter_map tl ~f
  | Some hd -> hd :: List.filter_map tl ~f
;;

let filter_mapi (hd :: tl) ~f : _ list =
  let hd = f 0 hd in
  let f i x = f (i + 1) x [@@inline always] in
  match hd with
  | None -> List.filter_mapi tl ~f [@nontail]
  | Some hd -> hd :: List.filter_mapi tl ~f
;;

let filter (hd :: tl) ~f : _ list =
  match f hd with
  | false -> List.filter tl ~f
  | true -> hd :: List.filter tl ~f
;;

let filteri (hd :: tl) ~f : _ list =
  let include_hd = f 0 hd in
  let f i x = f (i + 1) x [@@inline always] in
  match include_hd with
  | false -> List.filteri tl ~f [@nontail]
  | true -> hd :: List.filteri tl ~f
;;

let map t ~f = mapi t ~f:(fun (_ : int) x -> f x) [@nontail]

let map2 t1 t2 ~f : _ List.Or_unequal_lengths.t =
  match List.map2 (to_list t1) (to_list t2) ~f with
  | Ok x -> Ok (of_list_exn x)
  | Unequal_lengths -> Unequal_lengths
;;

let map2_exn t1 t2 ~f = of_list_exn (List.map2_exn (to_list t1) (to_list t2) ~f)
let reduce (hd :: tl) ~f = List.fold ~init:hd tl ~f

let reverse (hd :: tl) =
  let rec loop acc x xs =
    match xs with
    | [] -> x :: acc
    | y :: ys -> loop (x :: acc) y ys
  in
  loop [] hd tl
;;

let append (hd :: tl) l = hd :: List.append tl l

include Monad.Make_local (struct
    type nonrec 'a t = 'a t

    let return hd = [ hd ]
    let map = `Custom map

    let bind (hd :: tl) ~f =
      let f_hd = f hd in
      append f_hd (List.concat_map tl ~f:(fun x -> to_list (f x)))
    ;;
  end)

let unzip ((hd1, hd2) :: tl) =
  let tl1, tl2 = List.unzip tl in
  hd1 :: tl1, hd2 :: tl2
;;

let concat t = bind t ~f:Fn.id
let concat_map = bind

let zip t1 t2 : _ List.Or_unequal_lengths.t =
  match List.zip (to_list t1) (to_list t2) with
  | Ok x -> Ok (of_list_exn x)
  | Unequal_lengths -> Unequal_lengths
;;

let zip_exn t1 t2 = of_list_exn (List.zip_exn (to_list t1) (to_list t2))
let last (hd :: tl) = List.fold tl ~init:hd ~f:(fun _ elt -> elt)

let drop_last (hd :: tl) =
  match List.drop_last tl with
  | None -> []
  | Some l -> hd :: l
;;

let to_sequence t = Sequence.of_list (to_list t)
let sort t ~compare = of_list_exn (List.sort (to_list t) ~compare)
let stable_sort t ~compare = of_list_exn (List.stable_sort (to_list t) ~compare)
let dedup_and_sort t ~compare = of_list_exn (List.dedup_and_sort ~compare (to_list t))
let permute ?random_state t = of_list_exn (List.permute ?random_state (to_list t))

let min_elt' (hd :: tl) ~compare =
  List.fold tl ~init:hd ~f:(fun min elt -> if compare min elt > 0 then elt else min)
  [@nontail]
;;

let max_elt' t ~compare = min_elt' t ~compare:(fun x y -> compare y x) [@nontail]

let map_add_multi map ~key ~data =
  Map.update map key ~f:(function
    | None -> singleton data
    | Some t -> cons data t)
;;

let map_of_container_multi fold container ~comparator =
  fold container ~init:(Map.empty comparator) ~f:(fun acc (key, data) ->
    map_add_multi acc ~key ~data)
;;

let map_of_alist_multi alist = map_of_container_multi List.fold alist
let map_of_sequence_multi sequence = map_of_container_multi Sequence.fold sequence
let fold_nonempty (hd :: tl) ~init ~f = List.fold tl ~init:(init hd) ~f

let map_of_list_with_key_multi list ~comparator ~get_key =
  List.fold list ~init:(Map.empty comparator) ~f:(fun acc data ->
    let key = get_key data in
    map_add_multi acc ~key ~data)
;;

let fold_right (hd :: tl) ~init:acc ~f =
  let acc = List.fold_right tl ~init:acc ~f in
  f hd acc
;;

let folding_map (hd :: tl) ~init ~f =
  let acc, hd = f init hd in
  hd :: List.folding_map tl ~init:acc ~f
;;

let fold_map (hd :: tl) ~init:acc ~f =
  let acc, hd = f acc hd in
  let acc, tl = List.fold_map tl ~init:acc ~f in
  acc, hd :: tl
;;

let combine_errors t =
  match Result.combine_errors (to_list t) with
  | Ok oks -> Ok (of_list_exn oks)
  | Error errors -> Error (of_list_exn errors)
;;

let combine_errors_unit t =
  match Result.combine_errors_unit (to_list t) with
  | Ok _ as ok -> ok
  | Error errors -> Error (of_list_exn errors)
;;

let combine_or_errors t =
  match Or_error.combine_errors (to_list t) with
  | Ok oks -> Ok (of_list_exn oks)
  | Error _ as e -> e
;;

let combine_or_errors_unit t = Or_error.combine_errors_unit (to_list t)
let validate ~name check t = Validate.list ~name check (to_list t)
let validate_indexed check t = Validate.list_indexed check (to_list t)

let rec rev_append xs acc =
  match (xs : _ Reversed_list.t) with
  | [] -> acc
  | hd :: tl -> rev_append tl (cons hd acc)
;;

let init n ~f =
  if n < 1 then invalid_argf "Nonempty_list.init %d" n ();
  let tl = List.init (n - 1) ~f:(fun i -> f (i + 1)) in
  let hd = f 0 in
  hd :: tl
;;

let cartesian_product t t' = of_list_exn (List.cartesian_product (to_list t) (to_list t'))

module Reversed = struct
  type 'a t = ( :: ) of 'a * 'a Reversed_list.t

  let to_rev_list (hd :: tl) : _ Reversed_list.t = hd :: tl
  let rev_append (hd :: tl : _ t) xs = rev_append tl (hd :: xs)
  let rev t = rev_append t []

  let rec rev_map_aux i xs ~f acc =
    match (xs : _ Reversed_list.t) with
    | [] -> acc
    | hd :: tl -> rev_map_aux (i + 1) tl ~f (cons (f i hd) acc)
  ;;

  let rev_mapi (hd :: tl : _ t) ~f = rev_map_aux 1 tl ~f ([ f 0 hd ] : _ T'.t)
  let rev_map t ~f = rev_mapi t ~f:(fun _ x -> f x) [@nontail]
  let cons x t = x :: to_rev_list t

  module With_sexp_of = struct
    type nonrec 'a t = 'a t

    let sexp_of_t sexp_of_a t =
      Reversed_list.With_sexp_of.sexp_of_t sexp_of_a (to_rev_list t)
    ;;
  end

  module With_rev_sexp_of = struct
    type nonrec 'a t = 'a t

    let sexp_of_t sexp_of_a t =
      Reversed_list.With_rev_sexp_of.sexp_of_t sexp_of_a (to_rev_list t)
    ;;
  end
end

let rev' (hd :: tl) =
  List.fold tl ~init:([ hd ] : _ Reversed.t) ~f:(Fn.flip Reversed.cons)
;;

let flag arg_type =
  Command.Param.map_flag
    (Command.Param.one_or_more_as_pair arg_type)
    ~f:(fun (one, more) -> one :: more)
;;

let comma_separated_argtype ?key ?strip_whitespace ?unique_values arg_type =
  Command.Param.Arg_type.map
    ?key
    ~f:of_list_exn
    (Command.Param.Arg_type.comma_separated
       ~allow_empty:false
       ?strip_whitespace
       ?unique_values
       arg_type)
;;

type 'a nonempty_list = 'a t

module Option = struct
  type 'a t = 'a list
  [@@deriving compare, equal, sexp, sexp_grammar, hash, quickcheck, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__100_ b__101_ ->
      compare_list
        (fun a__102_ (b__103_ [@merlin.hide]) -> (_cmp__a a__102_ b__103_ [@merlin.hide]))
        a__100_
        b__101_
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__104_ b__105_ ->
      equal_list
        (fun a__106_ (b__107_ [@merlin.hide]) -> (_cmp__a a__106_ b__107_ [@merlin.hide]))
        a__104_
        b__105_
    ;;

    let _ = equal

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__108_ x__110_ -> list_of_sexp _of_a__108_ x__110_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__111_ x__112_ -> sexp_of_list _of_a__111_ x__112_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar -> list_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = t_sexp_grammar

    let hash_fold_t
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      hash_fold_list (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_t
    let quickcheck_generator _generator__115_ = quickcheck_generator_list _generator__115_
    let _ = quickcheck_generator
    let quickcheck_observer _observer__114_ = quickcheck_observer_list _observer__114_
    let _ = quickcheck_observer
    let quickcheck_shrinker _shrinker__113_ = quickcheck_shrinker_list _shrinker__113_
    let _ = quickcheck_shrinker

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a t

        let name = "nonempty_list.ml.before-ppx.Option.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_list _of_a)))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let none = []
  let some (_ :: _ as value : 'a nonempty_list) : 'a t = Obj.magic value
  let unchecked_value (t : 'a t) : 'a nonempty_list = Obj.magic t
  let is_none t = phys_equal t none
  let is_some t = not (is_none t)
  let to_option = of_list

  let of_option = function
    | None -> none
    | Some value -> some value
  ;;

  let value_exn = function
    | [] ->
      raise_s
        (Ppx_sexp_conv_lib.Conv.sexp_of_string
           "Nonempty_list.Option.value_exn: empty list")
    | _ :: _ as l -> unchecked_value l
  ;;

  let value t ~default = Bool.select (is_none t) default (unchecked_value t)

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unchecked_value
    end
  end
end
[@@ocaml.doc
  " This relies on the fact that the representation of [List.( :: )] constructor is\n\
  \    identical to that of [Nonempty_list.( :: )], and that they are each the first\n\
  \    non-constant constructor in their respective types. "]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
