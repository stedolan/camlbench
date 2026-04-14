let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bounded_index.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bounded_index.ml.before-ppx"
;;

open! Import
open! Stable_internal

module Stable = struct
  module V1 = struct
    module Make (M : sig
        val label : string
      end) =
    struct
      type t =
        { index : int
        ; min_index : int
        ; max_index : int
        }
      [@@deriving bin_io, compare, hash, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "bounded_index.ml.before-ppx:10:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "index", bin_shape_int
                    ; "min_index", bin_shape_int
                    ; "max_index", bin_shape_int
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { index = v1; min_index = v2; max_index = v3 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
            let size = Bin_prot.Common.( + ) size (bin_size_int v2) in
            Bin_prot.Common.( + ) size (bin_size_int v3)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { index = v1; min_index = v2; max_index = v3 } ->
            let pos = bin_write_int buf ~pos v1 in
            let pos = bin_write_int buf ~pos v2 in
            bin_write_int buf ~pos v3
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "bounded_index.ml.before-ppx.Stable.V1.Make.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_index = bin_read_int buf ~pos_ref in
          let v_min_index = bin_read_int buf ~pos_ref in
          let v_max_index = bin_read_int buf ~pos_ref in
          { index = v_index; min_index = v_min_index; max_index = v_max_index }
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

        let compare =
          (fun a__001_ b__002_ ->
             if Stdlib.( == ) a__001_ b__002_
             then 0
             else (
               match compare_int a__001_.index b__002_.index with
               | 0 ->
                 (match compare_int a__001_.min_index b__002_.min_index with
                  | 0 -> compare_int a__001_.max_index b__002_.max_index
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv = hsv in
              hash_fold_int hsv arg.index
            in
            hash_fold_int hsv arg.min_index
          in
          hash_fold_int hsv arg.max_index
        ;;

        let _ = hash_fold_t

        let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func arg =
            Ppx_hash_lib.Std.Hash.get_hash_value
              (let hsv = Ppx_hash_lib.Std.Hash.create () in
               hash_fold_t hsv arg)
          in
          fun x -> func x
        ;;

        let _ = hash

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let create index ~min ~max =
        if index < min || index > max
        then
          Error.raise_s
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Conv.sexp_of_string "index out of bounds"
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "index"
                     ; (sexp_of_int [@merlin.hide]) index
                     ]
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "min"
                     ; (sexp_of_int [@merlin.hide]) min
                     ]
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "max"
                     ; (sexp_of_int [@merlin.hide]) max
                     ]
                 ]
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
        else { index; min_index = min; max_index = max }
      ;;

      module For_sexpable = struct
        type t = string * int * string * int * string * int [@@deriving sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (let error_source__017_ =
               "bounded_index.ml.before-ppx.Stable.V1.Make.For_sexpable.t"
             in
             function
             | Sexplib0.Sexp.List
                 [ arg0__004_
                 ; arg1__005_
                 ; arg2__006_
                 ; arg3__007_
                 ; arg4__008_
                 ; arg5__009_
                 ] ->
               let res0__010_ = string_of_sexp arg0__004_
               and res1__011_ = int_of_sexp arg1__005_
               and res2__012_ = string_of_sexp arg2__006_
               and res3__013_ = int_of_sexp arg3__007_
               and res4__014_ = string_of_sexp arg4__008_
               and res5__015_ = int_of_sexp arg5__009_ in
               res0__010_, res1__011_, res2__012_, res3__013_, res4__014_, res5__015_
             | sexp__016_ ->
               Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                 error_source__017_
                 6
                 sexp__016_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun (arg0__018_, arg1__019_, arg2__020_, arg3__021_, arg4__022_, arg5__023_) ->
               let res0__024_ = sexp_of_string arg0__018_
               and res1__025_ = sexp_of_int arg1__019_
               and res2__026_ = sexp_of_string arg2__020_
               and res3__027_ = sexp_of_int arg3__021_
               and res4__028_ = sexp_of_string arg4__022_
               and res5__029_ = sexp_of_int arg5__023_ in
               Sexplib0.Sexp.List
                 [ res0__024_
                 ; res1__025_
                 ; res2__026_
                 ; res3__027_
                 ; res4__028_
                 ; res5__029_
                 ]
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include
        Sexpable.Stable.Of_sexpable.V1
          (For_sexpable)
          (struct
            type nonrec t = t

            let to_sexpable t = M.label, t.index, "of", t.min_index, "to", t.max_index

            let of_sexpable (label, index, of_, min, to_, max) =
              if
                String.equal label M.label
                && String.equal of_ "of"
                && String.equal to_ "to"
              then create index ~min ~max
              else
                Error.raise_s
                  (let ppx_sexp_message () =
                     Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Conv.sexp_of_string "invalid sexp for index"
                       ; Ppx_sexp_conv_lib.Sexp.List
                           [ Ppx_sexp_conv_lib.Sexp.Atom "label"
                           ; Ppx_sexp_conv_lib.Conv.sexp_of_string M.label
                           ]
                       ]
                       [@@ocaml.inline never]
                       [@@ocaml.local never]
                       [@@ocaml.specialise never]
                   in
                   (ppx_sexp_message () [@nontail]))
            ;;
          end)

      include Comparator.Stable.V1.Make (struct
          type nonrec t = t [@@deriving sexp_of, compare]

          include struct
            let _ = fun (_ : t) -> ()
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t

            let compare =
              (fun a__030_ b__031_ -> compare a__030_ b__031_
               : t -> (t[@merlin.hide]) -> int)
            ;;

            let _ = compare
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)

      include Comparable.Stable.V1.With_stable_witness.Make (struct
          type nonrec t = t [@@deriving sexp, compare, bin_io, stable_witness]

          include struct
            let _ = fun (_ : t) -> ()
            let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
            let _ = t_of_sexp
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t

            let compare =
              (fun a__033_ b__034_ -> compare a__033_ b__034_
               : t -> (t[@merlin.hide]) -> int)
            ;;

            let _ = compare

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "bounded_index.ml.before-ppx:51:8")
                  [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t
            let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
            let _ = bin_size_t
            let bin_write_t : t Bin_prot.Write.writer = bin_write_t
            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t
            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
            let _ = __bin_read_t__
            let bin_read_t : t Bin_prot.Read.reader = bin_read_t
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
              let _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness in
              ()
            ;;

            let _ = stable_witness
            and _ = __stable_witness_checks_for_t__
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          type nonrec comparator_witness = comparator_witness

          let comparator = comparator
        end)
    end
  end
end

open! Std_internal

module type S = Bounded_index_intf.S

module Make (M : sig
    val label : string
    val module_name : string
  end) =
struct
  module Stable = struct
    module V1 = Stable.V1.Make (M)
  end

  open Stable.V1

  type t = Stable.V1.t [@@deriving bin_io, compare, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "bounded_index.ml.before-ppx:75:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], Stable.V1.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = Stable.V1.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = Stable.V1.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Stable.V1.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = Stable.V1.bin_read_t
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
      (fun a__035_ b__036_ -> Stable.V1.compare a__035_ b__036_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Stable.V1.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Stable.V1.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Stable.V1.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Stable.V1.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type comparator_witness = Stable.V1.comparator_witness

  let create = Stable.V1.create

  let create_all ~min ~max =
    Sequence.to_list
      (Sequence.unfold ~init:min ~f:(fun index ->
         if index < min || index > max
         then None
         else Some (create index ~min ~max, index + 1)))
  ;;

  let index t = t.index
  let max_index t = t.max_index
  let min_index t = t.min_index
  let zero_based_index t = index t - min_index t
  let num_indexes t = max_index t - min_index t + 1

  include Sexpable.To_stringable (struct
      type nonrec t = t [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

  include Identifiable.Make_using_comparator (struct
      type nonrec t = t [@@deriving bin_io, compare, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "bounded_index.ml.before-ppx:97:4")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
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

        let compare =
          (fun a__039_ b__040_ -> compare a__039_ b__040_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec comparator_witness = comparator_witness

      let comparator = comparator
      let of_string = of_string
      let to_string = to_string
      let module_name = M.module_name
    end)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
