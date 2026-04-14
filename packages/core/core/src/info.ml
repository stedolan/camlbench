let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"info.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "info.ml.before-ppx"
;;

open! Import
open! Info_intf

module type S = Base.Info.S

module Source_code_position = Source_code_position0
module Binable = Binable0

module Sexp = struct
  include Sexplib.Sexp

  include (
  struct
    type t = Base.Sexp.t =
      | Atom of string
      | List of t list
    [@@deriving bin_io, compare, hash, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "info.ml.before-ppx:18:6")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.variant
                  [ "Atom", [ bin_shape_string ]
                  ; ( "List"
                    , [ bin_shape_list
                          ((Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) [])
                      ] )
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let rec bin_size_t : t Bin_prot.Size.sizer = function
        | Atom v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_string v1)
        | List v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_list bin_size_t v1)
      ;;

      let _ = bin_size_t

      let rec bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Atom v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          bin_write_string buf ~pos v1
        | List v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          bin_write_list bin_write_t buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type "info.ml.before-ppx.Sexp.t" !pos_ref

      and bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = bin_read_string buf ~pos_ref in
          Atom arg_1
        | 1 ->
          let arg_1 = (bin_read_list bin_read_t) buf ~pos_ref in
          List arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "info.ml.before-ppx.Sexp.t")
            !pos_ref
      ;;

      let _ = __bin_read_t__
      and _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let rec compare =
        (fun a__001_ b__002_ ->
           if Stdlib.( == ) a__001_ b__002_
           then 0
           else (
             match a__001_, b__002_ with
             | Atom _a__003_, Atom _b__004_ -> compare_string _a__003_ _b__004_
             | Atom _, _ -> -1
             | _, Atom _ -> 1
             | List _a__005_, List _b__006_ ->
               compare_list
                 (fun a__007_ (b__008_ [@merlin.hide]) ->
                    (compare a__007_ b__008_ [@merlin.hide]))
                 _a__005_
                 _b__006_)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let rec hash_fold_t
        : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
        =
        (fun hsv arg ->
           match arg with
           | Atom _a0 ->
             let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
             let hsv = hsv in
             hash_fold_string hsv _a0
           | List _a0 ->
             let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
             let hsv = hsv in
             hash_fold_list (fun hsv arg -> hash_fold_t hsv arg) hsv _a0
         : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func arg =
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg)
        in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let rec stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : string Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_string
        and _
          :  t Ppx_stable_witness_runtime.Stable_witness.t
          -> t list Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_list
        and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end :
    sig
      type t [@@deriving bin_io, compare, hash, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type t := t)
end

module Binable_exn = struct
  module Stable = struct
    module V1 = struct
      module T = struct
        type t = exn [@@deriving sexp_of, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()
          let sexp_of_t = (sexp_of_exn : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : exn Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_exn
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T

      let to_binable t = (sexp_of_t [@merlin.hide]) t
      let of_binable = Exn.create_s

      include
        Binable.Stable.Of_binable.V1 [@alert "-legacy"]
          (Sexp)
          (struct
            include T

            let to_binable = to_binable
            let of_binable = of_binable
          end)

      let stable_witness =
        Stable_witness.of_serializable Sexp.stable_witness of_binable to_binable
      ;;
    end
  end
end

module Extend (Info : Base.Info.S) = struct
  include Info

  module Internal_repr = struct
    module Stable = struct
      module Binable_exn = Binable_exn.Stable

      module Source_code_position = struct
        module V1 = struct
          type t = Source_code_position.Stable.V1.t [@@deriving bin_io, stable_witness]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "info.ml.before-ppx:67:10")
                  [ ( Bin_prot.Shape.Tid.of_string "t"
                    , []
                    , Source_code_position.Stable.V1.bin_shape_t )
                  ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t

            let bin_size_t : t Bin_prot.Size.sizer =
              Source_code_position.Stable.V1.bin_size_t
            ;;

            let _ = bin_size_t

            let bin_write_t : t Bin_prot.Write.writer =
              Source_code_position.Stable.V1.bin_write_t
            ;;

            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t

            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
              Source_code_position.Stable.V1.__bin_read_t__
            ;;

            let _ = __bin_read_t__

            let bin_read_t : t Bin_prot.Read.reader =
              Source_code_position.Stable.V1.bin_read_t
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
              let _
                : Source_code_position.Stable.V1.t
                    Ppx_stable_witness_runtime.Stable_witness.t
                =
                Source_code_position.Stable.V1.stable_witness
              in
              ()
            ;;

            let _ = stable_witness
            and _ = __stable_witness_checks_for_t__
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          let sexp_of_t = Source_code_position.sexp_of_t
        end
      end

      module V2 = struct
        type t = Info.Internal_repr.t =
          | Could_not_construct of Sexp.t
          | String of string
          | Exn of Binable_exn.V1.t
          | Sexp of Sexp.t
          | Tag_sexp of string * Sexp.t * Source_code_position.V1.t option
          | Tag_t of string * t
          | Tag_arg of string * Sexp.t * t
          | Of_list of int option * t list
          | With_backtrace of t * string
        [@@deriving bin_io, sexp_of, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "info.ml.before-ppx:77:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Bin_prot.Shape.variant
                      [ "Could_not_construct", [ Sexp.bin_shape_t ]
                      ; "String", [ bin_shape_string ]
                      ; "Exn", [ Binable_exn.V1.bin_shape_t ]
                      ; "Sexp", [ Sexp.bin_shape_t ]
                      ; ( "Tag_sexp"
                        , [ bin_shape_string
                          ; Sexp.bin_shape_t
                          ; bin_shape_option Source_code_position.V1.bin_shape_t
                          ] )
                      ; ( "Tag_t"
                        , [ bin_shape_string
                          ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                          ] )
                      ; ( "Tag_arg"
                        , [ bin_shape_string
                          ; Sexp.bin_shape_t
                          ; (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                          ] )
                      ; ( "Of_list"
                        , [ bin_shape_option bin_shape_int
                          ; bin_shape_list
                              ((Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t"))
                                 [])
                          ] )
                      ; ( "With_backtrace"
                        , [ (Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) []
                          ; bin_shape_string
                          ] )
                      ] )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let rec bin_size_t : t Bin_prot.Size.sizer = function
            | Could_not_construct v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (Sexp.bin_size_t v1)
            | String v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (bin_size_string v1)
            | Exn v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (Binable_exn.V1.bin_size_t v1)
            | Sexp v1 ->
              let size = 1 in
              Bin_prot.Common.( + ) size (Sexp.bin_size_t v1)
            | Tag_sexp (v1, v2, v3) ->
              let size = 1 in
              let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
              let size = Bin_prot.Common.( + ) size (Sexp.bin_size_t v2) in
              Bin_prot.Common.( + )
                size
                (bin_size_option Source_code_position.V1.bin_size_t v3)
            | Tag_t (v1, v2) ->
              let size = 1 in
              let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
              Bin_prot.Common.( + ) size (bin_size_t v2)
            | Tag_arg (v1, v2, v3) ->
              let size = 1 in
              let size = Bin_prot.Common.( + ) size (bin_size_string v1) in
              let size = Bin_prot.Common.( + ) size (Sexp.bin_size_t v2) in
              Bin_prot.Common.( + ) size (bin_size_t v3)
            | Of_list (v1, v2) ->
              let size = 1 in
              let size = Bin_prot.Common.( + ) size (bin_size_option bin_size_int v1) in
              Bin_prot.Common.( + ) size (bin_size_list bin_size_t v2)
            | With_backtrace (v1, v2) ->
              let size = 1 in
              let size = Bin_prot.Common.( + ) size (bin_size_t v1) in
              Bin_prot.Common.( + ) size (bin_size_string v2)
          ;;

          let _ = bin_size_t

          let rec bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos -> function
            | Could_not_construct v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
              Sexp.bin_write_t buf ~pos v1
            | String v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
              bin_write_string buf ~pos v1
            | Exn v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
              Binable_exn.V1.bin_write_t buf ~pos v1
            | Sexp v1 ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 3 in
              Sexp.bin_write_t buf ~pos v1
            | Tag_sexp (v1, v2, v3) ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 4 in
              let pos = bin_write_string buf ~pos v1 in
              let pos = Sexp.bin_write_t buf ~pos v2 in
              bin_write_option Source_code_position.V1.bin_write_t buf ~pos v3
            | Tag_t (v1, v2) ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 5 in
              let pos = bin_write_string buf ~pos v1 in
              bin_write_t buf ~pos v2
            | Tag_arg (v1, v2, v3) ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 6 in
              let pos = bin_write_string buf ~pos v1 in
              let pos = Sexp.bin_write_t buf ~pos v2 in
              bin_write_t buf ~pos v3
            | Of_list (v1, v2) ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 7 in
              let pos = bin_write_option bin_write_int buf ~pos v1 in
              bin_write_list bin_write_t buf ~pos v2
            | With_backtrace (v1, v2) ->
              let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 8 in
              let pos = bin_write_t buf ~pos v1 in
              bin_write_string buf ~pos v2
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun _buf ~pos_ref _vint ->
            Bin_prot.Common.raise_variant_wrong_type
              "info.ml.before-ppx.Extend.Internal_repr.Stable.V2.t"
              !pos_ref

          and bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
            | 0 ->
              let arg_1 = Sexp.bin_read_t buf ~pos_ref in
              Could_not_construct arg_1
            | 1 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              String arg_1
            | 2 ->
              let arg_1 = Binable_exn.V1.bin_read_t buf ~pos_ref in
              Exn arg_1
            | 3 ->
              let arg_1 = Sexp.bin_read_t buf ~pos_ref in
              Sexp arg_1
            | 4 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              let arg_2 = Sexp.bin_read_t buf ~pos_ref in
              let arg_3 =
                (bin_read_option Source_code_position.V1.bin_read_t) buf ~pos_ref
              in
              Tag_sexp (arg_1, arg_2, arg_3)
            | 5 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              let arg_2 = bin_read_t buf ~pos_ref in
              Tag_t (arg_1, arg_2)
            | 6 ->
              let arg_1 = bin_read_string buf ~pos_ref in
              let arg_2 = Sexp.bin_read_t buf ~pos_ref in
              let arg_3 = bin_read_t buf ~pos_ref in
              Tag_arg (arg_1, arg_2, arg_3)
            | 7 ->
              let arg_1 = (bin_read_option bin_read_int) buf ~pos_ref in
              let arg_2 = (bin_read_list bin_read_t) buf ~pos_ref in
              Of_list (arg_1, arg_2)
            | 8 ->
              let arg_1 = bin_read_t buf ~pos_ref in
              let arg_2 = bin_read_string buf ~pos_ref in
              With_backtrace (arg_1, arg_2)
            | _ ->
              Bin_prot.Common.raise_read_error
                (Bin_prot.Common.ReadError.Sum_tag
                   "info.ml.before-ppx.Extend.Internal_repr.Stable.V2.t")
                !pos_ref
          ;;

          let _ = __bin_read_t__
          and _ = bin_read_t

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

          let rec sexp_of_t =
            (function
             | Could_not_construct arg0__009_ ->
               let res0__010_ = Sexp.sexp_of_t arg0__009_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Could_not_construct"; res0__010_ ]
             | String arg0__011_ ->
               let res0__012_ = sexp_of_string arg0__011_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "String"; res0__012_ ]
             | Exn arg0__013_ ->
               let res0__014_ = Binable_exn.V1.sexp_of_t arg0__013_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exn"; res0__014_ ]
             | Sexp arg0__015_ ->
               let res0__016_ = Sexp.sexp_of_t arg0__015_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Sexp"; res0__016_ ]
             | Tag_sexp (arg0__017_, arg1__018_, arg2__019_) ->
               let res0__020_ = sexp_of_string arg0__017_
               and res1__021_ = Sexp.sexp_of_t arg1__018_
               and res2__022_ =
                 sexp_of_option Source_code_position.V1.sexp_of_t arg2__019_
               in
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "Tag_sexp"; res0__020_; res1__021_; res2__022_ ]
             | Tag_t (arg0__023_, arg1__024_) ->
               let res0__025_ = sexp_of_string arg0__023_
               and res1__026_ = sexp_of_t arg1__024_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Tag_t"; res0__025_; res1__026_ ]
             | Tag_arg (arg0__027_, arg1__028_, arg2__029_) ->
               let res0__030_ = sexp_of_string arg0__027_
               and res1__031_ = Sexp.sexp_of_t arg1__028_
               and res2__032_ = sexp_of_t arg2__029_ in
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "Tag_arg"; res0__030_; res1__031_; res2__032_ ]
             | Of_list (arg0__033_, arg1__034_) ->
               let res0__035_ = sexp_of_option sexp_of_int arg0__033_
               and res1__036_ = sexp_of_list sexp_of_t arg1__034_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Of_list"; res0__035_; res1__036_ ]
             | With_backtrace (arg0__037_, arg1__038_) ->
               let res0__039_ = sexp_of_t arg0__037_
               and res1__040_ = sexp_of_string arg1__038_ in
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "With_backtrace"; res0__039_; res1__040_ ]
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let rec stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : Sexp.t Ppx_stable_witness_runtime.Stable_witness.t =
              Sexp.stable_witness
            and _ : string Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_string
            and _ : Binable_exn.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
              Binable_exn.V1.stable_witness
            and _
              :  Source_code_position.V1.t Ppx_stable_witness_runtime.Stable_witness.t
              -> Source_code_position.V1.t option
                   Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_option
            and _ : Source_code_position.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
              Source_code_position.V1.stable_witness
            and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
            and _
              :  int Ppx_stable_witness_runtime.Stable_witness.t
              -> int option Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_option
            and _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int
            and _
              :  t Ppx_stable_witness_runtime.Stable_witness.t
              -> t list Ppx_stable_witness_runtime.Stable_witness.t
              =
              stable_witness_list
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end
    end

    include Stable.V2

    let to_info = Info.Internal_repr.to_info
    let of_info = Info.Internal_repr.of_info
  end

  module Stable = struct
    module V2 = struct
      module T = struct
        type t = Info.t [@@deriving sexp, sexp_grammar, compare, equal, hash]

        include struct
          let _ = fun (_ : t) -> ()
          let t_of_sexp = (Info.t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (Info.sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
          let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = Info.t_sexp_grammar
          let _ = t_sexp_grammar

          let compare =
            (fun a__042_ b__043_ -> Info.compare a__042_ b__043_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__044_ b__045_ -> Info.equal a__044_ b__045_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> Info.hash_fold_t hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = Info.hash in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)

      let to_binable = Info.Internal_repr.of_info
      let of_binable = Info.Internal_repr.to_info

      include
        Binable.Stable.Of_binable.V1 [@alert "-legacy"]
          (Internal_repr.Stable.V2)
          (struct
            type nonrec t = t

            let to_binable = to_binable
            let of_binable = of_binable
          end)

      let stable_witness =
        Stable_witness.of_serializable
          Internal_repr.Stable.V2.stable_witness
          of_binable
          to_binable
      ;;

      include Diffable.Atomic.Make (struct
          type nonrec t = t [@@deriving sexp, bin_io, equal]

          include struct
            let _ = fun (_ : t) -> ()
            let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
            let _ = t_of_sexp
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "info.ml.before-ppx:127:8")
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

            let equal =
              (fun a__047_ b__048_ -> equal a__047_ b__048_
               : t -> (t[@merlin.hide]) -> bool)
            ;;

            let _ = equal
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
    end

    module V1 = struct
      module T = struct
        type t = Info.t [@@deriving compare]

        include struct
          let _ = fun (_ : t) -> ()

          let compare =
            (fun a__049_ b__050_ -> Info.compare a__049_ b__050_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        include
          Sexpable.Stable.Of_sexpable.V1
            (Sexp)
            (struct
              type nonrec t = t

              let to_sexpable = Info.sexp_of_t
              let of_sexpable = Info.t_of_sexp
            end)

        let compare = compare
      end

      include T
      include Comparator.Stable.V1.Make (T)

      let to_binable = sexp_of_t
      let of_binable = t_of_sexp

      include
        Binable.Stable.Of_binable.V1 [@alert "-legacy"]
          (Sexp)
          (struct
            type nonrec t = t

            let to_binable = to_binable
            let of_binable = of_binable
          end)

      let stable_witness =
        Stable_witness.of_serializable Sexp.stable_witness of_binable to_binable
      ;;
    end
  end

  type t = Stable.V2.t [@@deriving bin_io]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "info.ml.before-ppx:170:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], Stable.V2.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = Stable.V2.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = Stable.V2.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Stable.V2.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = Stable.V2.bin_read_t
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Diff = Stable.V2.Diff
end

include Extend (Base.Info)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
