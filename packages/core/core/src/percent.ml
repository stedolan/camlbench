let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"percent.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "percent.ml.before-ppx"
;;

open! Import
open Std_internal

module Stable = struct
  module V3 = struct
    type t = (float[@quickcheck.generator Float.gen_finite])
    [@@deriving compare, globalize, hash, quickcheck, typerep, stable_witness]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__001_ b__002_ -> compare_float a__001_ b__002_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let globalize : t -> t = (globalize_float : t -> t)
      let _ = globalize

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> hash_fold_float hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = hash_float in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let quickcheck_generator = Float.gen_finite
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_float
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_float
      let _ = quickcheck_shrinker

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "percent.ml.before-ppx.Stable.V3.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_float))
      ;;

      let _ = typerep_of_t

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : float Ppx_stable_witness_runtime.Stable_witness.t =
          stable_witness_float
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let rec shift_decimal_point s ~by =
      if by = 0
      then s
      else (
        let s = String.lstrip s in
        let d, e, zero, underscore =
          let d = ref None in
          let e = ref None in
          let not_zero = ref false in
          let underscore = ref false in
          for i = 0 to String.length s - 1 do
            match s.[i] with
            | '.' ->
              if Option.is_some !d
              then
                failwithf "Error parsing Percent.t: too many decimal points in '%s'" s ();
              d := Some i
            | 'e' | 'E' ->
              if Option.is_some !e
              then failwithf "Error parsing Percent.t: too many Es in '%s'" s ();
              e := Some i
            | '-' | '+' | '0' -> ()
            | '_' -> underscore := true
            | '1' .. '9' -> if Option.is_none !e then not_zero := true
            | c ->
              failwithf "Unexpected character when parsing Percent.t: '%c' in '%s'" c s ()
          done;
          !d, !e, not !not_zero, !underscore
        in
        if underscore
        then
          shift_decimal_point
            (String.filter s ~f:(fun c ->
               let open Char in
               c <> '_'))
            ~by
        else if zero
        then s
        else (
          match e with
          | Some e ->
            let exp = Int.of_string (String.drop_prefix s (e + 1)) in
            let exp = exp + by in
            if exp = 0
            then String.prefix s e
            else
              String.concat
                [ String.prefix s (e + 1)
                ; (if exp > 0 then "+" else "")
                ; Int.to_string exp
                ]
          | None ->
            let neg = Char.( = ) s.[0] '-' in
            let signed = neg || Char.( = ) s.[0] '+' in
            let s = if signed then String.drop_prefix s 1 else s in
            let s, by =
              match d with
              | None -> s, by
              | Some d ->
                let d = d - if signed then 1 else 0 in
                let suf = String.drop_prefix s (d + 1) in
                let pref = String.prefix s d in
                let s = String.lstrip ~drop:(Char.( = ) '0') (pref ^ suf) in
                let by = by - String.length suf in
                s, by
            in
            let s, by =
              let len = String.length s in
              let s = String.rstrip ~drop:(Char.( = ) '0') s in
              let by = by + len - String.length s in
              s, by
            in
            let s =
              let len = String.length s in
              if by = 0
              then s
              else if by > 0
              then s ^ String.make by '0'
              else if by > -len
              then
                String.concat [ String.drop_suffix s (-by); "."; String.suffix s (-by) ]
              else String.concat [ "0."; String.make (-by - len) '0'; s ]
            in
            if signed then (if neg then "-" else "+") ^ s else s))
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"percent.ml.before-ppx"
          ~line_number:130
          ~location:{ start_bol = 5778; start_pos = 5782; end_pos = 8766 }
          ~trailing_loc:{ start_bol = 8755; start_pos = 8766; end_pos = 8766 }
          ~body_loc:{ start_bol = 5778; start_pos = 5782; end_pos = 8766 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
          ~description:(Some "shift_decimal_point 1")
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
                        ( { contents =
                              "\n\
                              \        == 3 ==\n\
                              \        0.0000000000000000000000000000000000000003\n\
                              \        0.0000000003\n\
                              \        0.03\n\
                              \        0.3\n\
                              \        3\n\
                              \        30\n\
                              \        300\n\
                              \        30000000000\n\
                              \        30000000000000000000000000000000000000000\n\
                              \        --------------------------------------------------\n\
                              \        == 51.2 ==\n\
                              \        0.00000000000000000000000000000000000000512\n\
                              \        0.00000000512\n\
                              \        0.512\n\
                              \        5.12\n\
                              \        51.2\n\
                              \        512\n\
                              \        5120\n\
                              \        512000000000\n\
                              \        512000000000000000000000000000000000000000\n\
                              \        --------------------------------------------------\n\
                              \        == -50 ==\n\
                              \        -0.000000000000000000000000000000000000005\n\
                              \        -0.000000005\n\
                              \        -0.5\n\
                              \        -5\n\
                              \        -50\n\
                              \        -500\n\
                              \        -5000\n\
                              \        -500000000000\n\
                              \        -500000000000000000000000000000000000000000\n\
                              \        --------------------------------------------------\n\
                              \        == 3127000.000 ==\n\
                              \        0.0000000000000000000000000000000003127\n\
                              \        0.0003127\n\
                              \        31270\n\
                              \        312700\n\
                              \        3127000.000\n\
                              \        31270000\n\
                              \        312700000\n\
                              \        31270000000000000\n\
                              \        31270000000000000000000000000000000000000000000\n\
                              \        --------------------------------------------------\n\
                              \        == 1.79E+308 ==\n\
                              \        1.79E+268\n\
                              \        1.79E+298\n\
                              \        1.79E+306\n\
                              \        1.79E+307\n\
                              \        1.79E+308\n\
                              \        1.79E+309\n\
                              \        1.79E+310\n\
                              \        1.79E+318\n\
                              \        1.79E+348\n\
                              \        --------------------------------------------------\n\
                              \        == 4.940656E-324 ==\n\
                              \        4.940656E-364\n\
                              \        4.940656E-334\n\
                              \        4.940656E-326\n\
                              \        4.940656E-325\n\
                              \        4.940656E-324\n\
                              \        4.940656E-323\n\
                              \        4.940656E-322\n\
                              \        4.940656E-314\n\
                              \        4.940656E-284\n\
                              \        --------------------------------------------------\n\
                              \        == -0.000e13 ==\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        -0.000e13\n\
                              \        --------------------------------------------------\n\
                              \        == 1.47651E+10 ==\n\
                              \        1.47651E-30\n\
                              \        1.47651\n\
                              \        1.47651E+8\n\
                              \        1.47651E+9\n\
                              \        1.47651E+10\n\
                              \        1.47651E+11\n\
                              \        1.47651E+12\n\
                              \        1.47651E+20\n\
                              \        1.47651E+50\n\
                              \        --------------------------------------------------\n\
                              \        "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 6543; start_pos = 6551; end_pos = 8765 } ))
                   ~node_loc:{ start_bol = 6528; start_pos = 6534; end_pos = 8766 } )
             ]
            [@merlin.hide])
          (fun () ->
             List.iter
               [ "3"
               ; "51.2"
               ; "-50"
               ; "3127000.000"
               ; "1.79E+308"
               ; "4.940656E-324"
               ; "-0.000e13"
               ; "1.47651E+10"
               ]
               ~f:(fun s ->
                 printf "== %s ==\n" s;
                 let x = Float.of_string s in
                 List.iter [ -40; -10; -2; -1; 0; 1; 2; 10; 40 ] ~f:(fun by ->
                   let s1 = shift_decimal_point s ~by in
                   printf "%s\n" s1;
                   let x1 = Float.of_string s1 in
                   let x2 = x *. (10. ** float by) in
                   assert
                     (let open Float in
                      x1 = x2 || abs ((x1 - x2) / x1) < 1e-6
                      : bool));
                 printf "--------------------------------------------------\n");
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
    ;;

    module Stringable = struct
      type t = float

      external format_float : string -> float -> string = "caml_format_float"

      let float_to_string x =
        let y = format_float "%.15G" x in
        if Float.( = ) (float_of_string y) x then y else format_float "%.17G" x
      ;;

      let to_string' float_to_string x =
        let x_abs = Float.abs x in
        if Float.( = ) x_abs 0.
        then "0x"
        else (
          let s = float_to_string x in
          if
            let open Float in
            is_nan x || is_inf x || x_abs >= 1.
          then s ^ "x"
          else if Float.( >= ) x_abs 0.01
          then shift_decimal_point s ~by:2 ^ "%"
          else shift_decimal_point s ~by:4 ^ "bp")
      ;;

      let to_string x = to_string' float_to_string x

      let really_of_string str float_of_string =
        match String.chop_suffix str ~suffix:"x" with
        | Some str -> float_of_string str ~by:0
        | None ->
          (match String.chop_suffix str ~suffix:"%" with
           | Some str -> float_of_string str ~by:(-2)
           | None ->
             (match String.chop_suffix str ~suffix:"bp" with
              | Some str -> float_of_string str ~by:(-4)
              | None -> failwithf "Percent.of_string: must end in x, %%, or bp: %s" str ()))
      ;;

      let of_string x =
        really_of_string x (fun s ~by ->
          Float_with_finite_only_serialization.t_of_sexp
            (Sexp.Atom (shift_decimal_point s ~by)))
      ;;

      let of_string_allow_nan_and_inf x =
        really_of_string x (fun s ~by ->
          match String.lowercase s with
          | "nan"
          | "-nan"
          | "+nan"
          | "inf"
          | "infinity"
          | "+inf"
          | "+infinity"
          | "-inf"
          | "-infinity" -> Float.of_string s
          | _ -> Float.of_string (shift_decimal_point s ~by))
      ;;
    end

    include (
      Stringable :
        sig
          type t

          val to_string : t -> string
          val of_string : string -> t
          val of_string_allow_nan_and_inf : string -> t
        end
        with type t := t)

    let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar

    include (Sexpable.Stable.Of_stringable.V1 (Stringable) : Sexpable.S with type t := t)
    include (Float : Binable with type t := t)

    let bin_shape_t =
      Bin_prot.Shape.basetype
        (Bin_prot.Shape.Uuid.of_string "b32f2a1e-6b43-11ed-b33b-aac2a563f10a")
        [ bin_shape_t ]
    ;;

    include Comparable.Make_binable (struct
        type nonrec t = t [@@deriving bin_io, compare, sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:340:6")
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
            (fun a__004_ b__005_ -> compare a__004_ b__005_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving bin_io, equal, sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:344:6")
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
            (fun a__007_ b__008_ -> equal a__007_ b__008_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)

    module Always_percentage = struct
      type nonrec t = t [@@deriving sexp, bin_io]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:348:6")
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_string x =
        let s = Stringable.float_to_string x in
        shift_decimal_point s ~by:2 ^ "%"
      ;;

      let sexp_of_t t = Sexp.Atom (to_string t)
    end
  end

  module V2 = struct
    type t = (float[@quickcheck.generator Float.gen_finite])
    [@@deriving compare, globalize, hash, quickcheck, typerep, stable_witness]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__011_ b__012_ -> compare_float a__011_ b__012_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let globalize : t -> t = (globalize_float : t -> t)
      let _ = globalize

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> hash_fold_float hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = hash_float in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let quickcheck_generator = Float.gen_finite
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_float
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_float
      let _ = quickcheck_shrinker

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "percent.ml.before-ppx.Stable.V2.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_float))
      ;;

      let _ = typerep_of_t

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : float Ppx_stable_witness_runtime.Stable_witness.t =
          stable_witness_float
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let of_mult f = f
    let to_mult t = t
    let of_percentage f = f /. 100.
    let to_percentage t = t *. 100.
    let of_bp f = f /. 10_000.
    let to_bp t = t *. 10_000.
    let of_bp_int i = of_bp (Float.of_int i)
    let to_bp_int t = Float.to_int (to_bp t)

    let shift_decimal_point_in_float f ~by =
      if not (Float.is_finite f)
      then f
      else Float.of_string (V3.shift_decimal_point ~by (Float.to_string f))
    ;;

    let of_percentage_slow_more_accurate f = shift_decimal_point_in_float f ~by:(-2)
    let to_percentage_slow_more_accurate f = shift_decimal_point_in_float f ~by:2
    let of_bp_slow_more_accurate f = shift_decimal_point_in_float f ~by:(-4)
    let to_bp_slow_more_accurate f = shift_decimal_point_in_float f ~by:4

    let round_significant p ~significant_digits =
      Float.round_significant p ~significant_digits
    ;;

    let round_decimal_mult p ~decimal_digits = Float.round_decimal p ~decimal_digits

    let round_decimal_percentage p ~decimal_digits =
      Float.round_decimal (p *. 100.) ~decimal_digits /. 100.
    ;;

    let round_decimal_bp p ~decimal_digits =
      Float.round_decimal (p *. 10000.) ~decimal_digits /. 10000.
    ;;

    module Format = struct
      type t =
        | Exponent of int
        | Exponent_E of int
        | Decimal of int
        | Ocaml
        | Compact of int
        | Compact_E of int
        | Hex of int
        | Hex_E of int
      [@@deriving sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let sexp_of_t =
          (function
           | Exponent arg0__014_ ->
             let res0__015_ = sexp_of_int arg0__014_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exponent"; res0__015_ ]
           | Exponent_E arg0__016_ ->
             let res0__017_ = sexp_of_int arg0__016_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exponent_E"; res0__017_ ]
           | Decimal arg0__018_ ->
             let res0__019_ = sexp_of_int arg0__018_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Decimal"; res0__019_ ]
           | Ocaml -> Sexplib0.Sexp.Atom "Ocaml"
           | Compact arg0__020_ ->
             let res0__021_ = sexp_of_int arg0__020_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Compact"; res0__021_ ]
           | Compact_E arg0__022_ ->
             let res0__023_ = sexp_of_int arg0__022_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Compact_E"; res0__023_ ]
           | Hex arg0__024_ ->
             let res0__025_ = sexp_of_int arg0__024_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Hex"; res0__025_ ]
           | Hex_E arg0__026_ ->
             let res0__027_ = sexp_of_int arg0__026_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Hex_E"; res0__027_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let exponent ~precision = Exponent precision
      let exponent_E ~precision = Exponent_E precision
      let decimal ~precision = Decimal precision
      let ocaml = Ocaml
      let compact ~precision = Compact precision
      let compact_E ~precision = Compact_E precision
      let hex ~precision = Hex precision
      let hex_E ~precision = Hex_E precision

      let format_float t =
        match t with
        | Exponent precision -> sprintf "%.*e" precision
        | Exponent_E precision -> sprintf "%.*E" precision
        | Decimal precision -> sprintf "%.*f" precision
        | Ocaml -> sprintf "%F"
        | Compact precision -> sprintf "%.*g" precision
        | Compact_E precision -> sprintf "%.*G" precision
        | Hex precision -> sprintf "%.*h" precision
        | Hex_E precision -> sprintf "%.*H" precision
      ;;
    end

    let format x format =
      let x_abs = Float.abs x in
      let string float = Format.format_float format float in
      if Float.( = ) x_abs 0.
      then "0x"
      else if Float.( >= ) x_abs 1.
      then string (x *. 1.) ^ "x"
      else if Float.( >= ) x_abs 0.01
      then string (x *. 100.) ^ "%"
      else string (x *. 10_000.) ^ "bp"
    ;;

    module Stringable = struct
      type t = float

      let to_string x =
        let x_abs = Float.abs x in
        let string float = sprintf "%.6G" float in
        if Float.( = ) x_abs 0.
        then "0x"
        else if Float.( >= ) x_abs 1.
        then string (x *. 1.) ^ "x"
        else if Float.( >= ) x_abs 0.01
        then string (x *. 100.) ^ "%"
        else string (x *. 10_000.) ^ "bp"
      ;;

      let of_string = V3.of_string
      let of_string_allow_nan_and_inf = V3.of_string_allow_nan_and_inf
    end

    include (
      Stringable :
        sig
          type t

          val to_string : t -> string
          val of_string : string -> t
          val of_string_allow_nan_and_inf : string -> t
        end
        with type t := t)

    let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar

    include (Sexpable.Stable.Of_stringable.V1 (Stringable) : Sexpable.S with type t := t)
    include (Float : Binable with type t := t)

    let bin_shape_t =
      Bin_prot.Shape.basetype
        (Bin_prot.Shape.Uuid.of_string "1d1e76bc-ea4b-11eb-a16a-aa5b28d1f4d7")
        [ bin_shape_t ]
    ;;

    include Comparable.Make_binable_using_comparator (struct
        type nonrec t = t [@@deriving bin_io, compare, sexp]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:495:6")
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
            (fun a__028_ b__029_ -> compare a__028_ b__029_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        type comparator_witness = V3.comparator_witness

        let comparator = V3.comparator
      end)

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving bin_io, sexp, equal]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:502:6")
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
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let equal =
            (fun a__032_ b__033_ -> equal a__032_ b__033_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)

    type comparator_witness = V3.comparator_witness
  end

  module V1 = struct
    module Bin_shape_same_as_float = struct
      include V2

      let bin_shape_t = Float.bin_shape_t

      include Comparable.Make_binable_using_comparator (struct
          type nonrec t = t [@@deriving compare, sexp_of, bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let compare =
              (fun a__034_ b__035_ -> compare a__034_ b__035_
               : t -> (t[@merlin.hide]) -> int)
            ;;

            let _ = compare
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:515:8")
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
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          type comparator_witness = V3.comparator_witness

          let comparator = V3.comparator

          let t_of_sexp sexp =
            match Float.t_of_sexp sexp with
            | float -> float
            | exception _ -> t_of_sexp sexp
          ;;
        end)

      include Diffable.Atomic.Make (struct
          type nonrec t = t [@@deriving bin_io, equal, sexp]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:532:8")
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
              (fun a__036_ b__037_ -> equal a__036_ b__037_
               : t -> (t[@merlin.hide]) -> bool)
            ;;

            let _ = equal
            let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
            let _ = t_of_sexp
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
    end

    include Bin_shape_same_as_float
  end

  module Option = struct
    module Option_repr = struct
      let none = Float.nan
      let is_none t = Float.is_nan t
      let is_some t = not (is_none t)
      let some_is_representable = is_some
      let some = Fn.id
      let unchecked_value = Fn.id
      let to_option t = if is_some t then Some (unchecked_value t) else None
      let apply_with_none_as_nan = ( *. )
      let of_mult_with_nan_as_none = Fn.id
      let to_mult_with_none_as_nan = Fn.id

      let of_option opt =
        match opt with
        | None -> none
        | Some v -> some v
      ;;

      let value_exn t =
        if is_some t
        then unchecked_value t
        else
          raise_s
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Conv.sexp_of_string "percent.ml.before-ppx:561:31"
                 ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Percent.Option.value_exn none"
                 ]
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
      ;;

      let value t ~default = Bool.select (is_none t) default (unchecked_value t)
    end

    module V3 = struct
      type t = V3.t [@@deriving bin_io, compare, equal, hash, typerep, stable_witness]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:568:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], V3.bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = V3.bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = V3.bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = V3.__bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = V3.bin_read_t
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
          (fun a__039_ b__040_ -> V3.compare a__039_ b__040_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__041_ b__042_ -> V3.equal a__041_ b__042_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> V3.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = V3.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "percent.ml.before-ppx.Stable.Option.V3.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy V3.typerep_of_t))
        ;;

        let _ = typerep_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : V3.t Ppx_stable_witness_runtime.Stable_witness.t = V3.stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let bin_shape_t =
        Bin_prot.Shape.basetype
          (Bin_prot.Shape.Uuid.of_string "e9b52028-6b45-11ed-a6b6-aac2a563f10a")
          [ bin_shape_t ]
      ;;

      include Option_repr

      let sexp_of_t t = Option.sexp_of_t V3.sexp_of_t (to_option t)
      let t_of_sexp sexp = of_option ((Option.t_of_sexp V3.t_of_sexp) sexp)

      let t_sexp_grammar =
        Sexplib.Sexp_grammar.coerce
          ((Option.t_sexp_grammar V3.t_sexp_grammar
           : V3.t Option.t Sexplib0.Sexp_grammar.t)
           [@merlin.hide])
      ;;
    end

    module V2 = struct
      type t = V2.t [@@deriving bin_io, compare, hash, typerep, stable_witness]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:584:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], V2.bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = V2.bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = V2.bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = V2.__bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = V2.bin_read_t
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
          (fun a__043_ b__044_ -> V2.compare a__043_ b__044_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> V2.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = V2.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "percent.ml.before-ppx.Stable.Option.V2.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy V2.typerep_of_t))
        ;;

        let _ = typerep_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : V2.t Ppx_stable_witness_runtime.Stable_witness.t = V2.stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let bin_shape_t =
        Bin_prot.Shape.basetype
          (Bin_prot.Shape.Uuid.of_string "f7aa04e8-da3e-11ec-b546-aa7328433b70")
          [ bin_shape_t ]
      ;;

      include Option_repr

      let sexp_of_t t = Option.sexp_of_t V2.sexp_of_t (to_option t)
      let t_of_sexp sexp = of_option ((Option.t_of_sexp V2.t_of_sexp) sexp)

      let t_sexp_grammar =
        Sexplib.Sexp_grammar.coerce
          ((Option.t_sexp_grammar V2.t_sexp_grammar
           : V2.t Option.t Sexplib0.Sexp_grammar.t)
           [@merlin.hide])
      ;;
    end

    module V1 = struct
      module Bin_shape_same_as_float = struct
        include V2

        let bin_shape_t = Float.bin_shape_t
      end

      include Bin_shape_same_as_float
    end
  end
end

include Stable.V1.Bin_shape_same_as_float

module Option = struct
  module Stable = Stable.Option
  include Stable.V1.Bin_shape_same_as_float

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unchecked_value
    end
  end
end

let is_zero t = t = 0.
let apply t f = t *. f
let scale t f = t *. f

include (
struct
  include Float

  let one_hundred_percent = 1.
  let ( // ) x y = of_mult x /. of_mult y
end :
sig
  val zero : t
  val one_hundred_percent : t
  val ( * ) : t -> t -> t
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( / ) : t -> t -> t
  val ( // ) : t -> t -> float
  val abs : t -> t
  val neg : t -> t
  val is_nan : t -> bool
  val is_inf : t -> bool
  val sign_exn : t -> Sign.t

  include Robustly_comparable with type t := t
end)

include Comparable.With_zero (struct
    include Stable.V1.Bin_shape_same_as_float

    let zero = zero
  end)

let validate = Float.validate_ordinary
let of_string_allow_nan_and_inf s = Stringable.of_string_allow_nan_and_inf s
let t_of_sexp_allow_nan_and_inf sexp = of_string_allow_nan_and_inf (Sexp.to_string sexp)

module Always_percentage = struct
  type nonrec t = t

  let format x format = Format.format_float format (x *. 100.) ^ "%"
  let to_string x = sprintf "%.6G%%" (x * 100.)
  let sexp_of_t t = Sexp.Atom (to_string t)
end

let to_string_round_trippable = Stable.V3.to_string

module Almost_round_trippable = struct
  type nonrec t = t [@@deriving sexp, bin_io]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:674:2")
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
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_string x =
    let open Stable.V3.Stringable in
    to_string' (format_float "%.14G") x
  ;;

  let of_string x = Stable.V3.Stringable.of_string x
  let sexp_of_t t = Sexp.Atom (to_string t)
  let t_of_sexp = Stable.V3.t_of_sexp

  module Always_percentage = struct
    type nonrec t = t [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "percent.ml.before-ppx:682:4")
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_string x =
      let open Stable.V3 in
      let s = Stringable.format_float "%.14G" x in
      shift_decimal_point s ~by:2 ^ "%"
    ;;

    let sexp_of_t t = Sexp.Atom (to_string t)
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
