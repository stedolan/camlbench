let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_float_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_float_unix.ml.before-ppx"
;;

open! Core
open! Import
module Time = Core.Time_float

include (
  Time :
    (module type of struct
      include Time
    end
    with module Map := Time.Map
    with module Set := Time.Set
   [@ocaml.warning "-3"]))

module T = Time_functor.Make (Time) (Time)
include Diffable.Atomic.Make (T)

include Hashable.Make_binable (struct
    type t = Time.t [@@deriving bin_io, compare, hash]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "time_float_unix.ml.before-ppx:23:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], Time.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = Time.bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = Time.bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Time.__bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = Time.bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__001_ b__002_ -> Time.compare a__001_ b__002_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> Time.hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Time.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let sexp_of_t = T.sexp_of_t

    let t_of_sexp sexp =
      match Float.t_of_sexp sexp with
      | float -> Time.of_span_since_epoch (Time.Span.of_sec float)
      | exception _ -> T.t_of_sexp sexp
    ;;
  end)

module Span = struct
  include Time.Span

  let arg_type = T.Span.arg_type
end

module Ofday = struct
  include Time.Ofday
  module Zoned = T.Ofday.Zoned

  let now = T.Ofday.now
  let arg_type = T.Ofday.arg_type
end

module Zone = struct
  include Time.Zone

  include (
    T.Zone :
      module type of struct
        include T.Zone
      end
      with module Index := T.Zone.Index
      with type t := T.Zone.t)
end

module Stable = struct
  module V1 = struct
    include T
    include Diffable.Atomic.Make (T)

    let stable_witness : t Stable_witness.t = Stable_witness.assert_stable

    module Map = struct
      include Map

      let stable_witness _ = Stable_witness.assert_stable
    end

    module Set = struct
      include Set

      let stable_witness = Stable_witness.assert_stable
    end
  end

  module With_utc_sexp = struct
    module V1 = struct
      module C = struct
        include (
          V1 : module type of V1 with module Map := V1.Map and module Set := V1.Set)

        let sexp_of_t t = sexp_of_t_abs t ~zone:Zone.utc
      end

      include C
      module Map = Map.Make_binable_using_comparator (C)
      module Set = Set.Make_binable_using_comparator (C)
    end

    module V2 = struct
      module C = struct
        include Time.Stable.With_utc_sexp.V2

        type comparator_witness = T.comparator_witness

        let comparator = T.comparator
      end

      include C
      include Comparable.Stable.V1.Make (C)
    end
  end

  module With_t_of_sexp_abs = struct
    module V1 = struct
      include (V1 : module type of V1 with module Map := V1.Map and module Set := V1.Set)

      let t_of_sexp = t_of_sexp_abs
    end
  end

  module Span = Time.Stable.Span

  module Ofday = struct
    include Time.Stable.Ofday

    module Zoned = struct
      module V1 = struct
        open T.Ofday.Zoned

        type nonrec t = t [@@deriving hash]

        include struct
          let _ = fun (_ : t) -> ()

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_t hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let compare = With_nonchronological_compare.compare

        module Bin_repr = struct
          type t =
            { ofday : Time.Stable.Ofday.V1.t
            ; zone : Timezone.Stable.V1.t
            }
          [@@deriving bin_io, stable_witness]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string
                     "time_float_unix.ml.before-ppx:134:10")
                  [ ( Bin_prot.Shape.Tid.of_string "t"
                    , []
                    , Bin_prot.Shape.record
                        [ "ofday", Time.Stable.Ofday.V1.bin_shape_t
                        ; "zone", Timezone.Stable.V1.bin_shape_t
                        ] )
                  ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t

            let bin_size_t : t Bin_prot.Size.sizer = function
              | { ofday = v1; zone = v2 } ->
                let size = 0 in
                let size =
                  Bin_prot.Common.( + ) size (Time.Stable.Ofday.V1.bin_size_t v1)
                in
                Bin_prot.Common.( + ) size (Timezone.Stable.V1.bin_size_t v2)
            ;;

            let _ = bin_size_t

            let bin_write_t : t Bin_prot.Write.writer =
              fun buf ~pos -> function
              | { ofday = v1; zone = v2 } ->
                let pos = Time.Stable.Ofday.V1.bin_write_t buf ~pos v1 in
                Timezone.Stable.V1.bin_write_t buf ~pos v2
            ;;

            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t

            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
              fun _buf ~pos_ref _vint ->
              Bin_prot.Common.raise_variant_wrong_type
                "time_float_unix.ml.before-ppx.Stable.Ofday.Zoned.V1.Bin_repr.t"
                !pos_ref
            ;;

            let _ = __bin_read_t__

            let bin_read_t : t Bin_prot.Read.reader =
              fun buf ~pos_ref ->
              let v_ofday = Time.Stable.Ofday.V1.bin_read_t buf ~pos_ref in
              let v_zone = Timezone.Stable.V1.bin_read_t buf ~pos_ref in
              { ofday = v_ofday; zone = v_zone }
            ;;

            let _ = bin_read_t

            let bin_reader_t =
              ({ read = bin_read_t; vtag_read = __bin_read_t__ }
               : _ Bin_prot.Type_class.reader)
            ;;

            let _ = bin_reader_t

            let bin_t =
              ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
               : _ Bin_prot.Type_class.t)
            ;;

            let _ = bin_t

            let stable_witness =
              (Ppx_stable_witness_runtime.Stable_witness.assert_stable
               : t Ppx_stable_witness_runtime.Stable_witness.t)

            and __stable_witness_checks_for_t__ () =
              let _ : Time.Stable.Ofday.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
                Time.Stable.Ofday.V1.stable_witness
              and _ : Timezone.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
                Timezone.Stable.V1.stable_witness
              in
              ()
            ;;

            let _ = stable_witness
            and _ = __stable_witness_checks_for_t__
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        let to_binable t : Bin_repr.t = { ofday = ofday t; zone = zone t }
        let of_binable (repr : Bin_repr.t) = create repr.ofday repr.zone

        include
          Binable.Stable.Of_binable.V1 [@alert "-legacy"]
            (Bin_repr)
            (struct
              type nonrec t = t

              let to_binable = to_binable
              let of_binable = of_binable
            end)

        let stable_witness =
          Stable_witness.of_serializable
            (let _ : Bin_repr.t Ppx_stable_witness_runtime.Stable_witness.t =
               Bin_repr.stable_witness
             in
             (Ppx_stable_witness_runtime.Stable_witness.assert_stable
              : Bin_repr.t Ppx_stable_witness_runtime.Stable_witness.t))
            of_binable
            to_binable
        ;;

        let () =
          match Ppx_inline_test_lib.testing with
          | `Not_testing -> ()
          | `Testing _ ->
            let module Ppx_expect_test_block =
              Ppx_expect_runtime.Make_test_block (Expect_test_config)
            in
            Ppx_expect_test_block.run_suite
              ~filename_rel_to_project_root:"time_float_unix.ml.before-ppx"
              ~line_number:161
              ~location:{ start_bol = 3937; start_pos = 3945; end_pos = 4065 }
              ~trailing_loc:{ start_bol = 4007; start_pos = 4065; end_pos = 4065 }
              ~body_loc:{ start_bol = 3937; start_pos = 3945; end_pos = 4065 }
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
                            ( { contents = " 490573c3397b4fe37e8ade0086fb4759 "
                              ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                              }
                            , { start_bol = 4007; start_pos = 4026; end_pos = 4064 } ))
                       ~node_loc:{ start_bol = 4007; start_pos = 4017; end_pos = 4065 } )
                 ]
                [@merlin.hide])
              (fun () ->
                 print_endline
                   (Bin_prot.Shape.Digest.to_hex
                      (Bin_prot.Shape.eval_to_digest bin_shape_t));
                 Ppx_expect_test_block.run_test
                   ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0)
                 [@merlin.hide])
        ;;

        type sexp_repr = Time.Stable.Ofday.V1.t * Timezone.Stable.V1.t [@@deriving sexp]

        include struct
          let _ = fun (_ : sexp_repr) -> ()

          let sexp_repr_of_sexp =
            (let error_source__009_ =
               "time_float_unix.ml.before-ppx.Stable.Ofday.Zoned.V1.sexp_repr"
             in
             function
             | Sexplib0.Sexp.List [ arg0__004_; arg1__005_ ] ->
               let res0__006_ = Time.Stable.Ofday.V1.t_of_sexp arg0__004_
               and res1__007_ = Timezone.Stable.V1.t_of_sexp arg1__005_ in
               res0__006_, res1__007_
             | sexp__008_ ->
               Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                 error_source__009_
                 2
                 sexp__008_
             : Sexplib0.Sexp.t -> sexp_repr)
          ;;

          let _ = sexp_repr_of_sexp

          let sexp_of_sexp_repr =
            (fun (arg0__010_, arg1__011_) ->
               let res0__012_ = Time.Stable.Ofday.V1.sexp_of_t arg0__010_
               and res1__013_ = Timezone.Stable.V1.sexp_of_t arg1__011_ in
               Sexplib0.Sexp.List [ res0__012_; res1__013_ ]
             : sexp_repr -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_sexp_repr
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let sexp_of_t t = (sexp_of_sexp_repr [@merlin.hide]) (ofday t, zone t)

        let t_of_sexp sexp =
          let ofday, zone = (sexp_repr_of_sexp [@merlin.hide]) sexp in
          create ofday zone
        ;;
      end
    end
  end

  module Zone = Timezone.Stable
end

include (
  T :
    module type of struct
      include T
    end
    with module Table := T.Table
    with module Hash_set := T.Hash_set
    with module Hash_queue := T.Hash_queue
    with module Span := T.Span
    with module Ofday := T.Ofday
    with module Replace_polymorphic_compare := T.Replace_polymorphic_compare
    with module Date_and_ofday := T.Date_and_ofday
    with module Zone := T.Zone
    with type underlying := T.underlying
    with type t := T.t
    with type comparator_witness := T.comparator_witness)

let to_string = T.to_string
let of_string = T.of_string
let of_string_gen = T.of_string_gen
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
