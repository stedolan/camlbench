let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"month.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "month.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    type t =
      | Jan
      | Feb
      | Mar
      | Apr
      | May
      | Jun
      | Jul
      | Aug
      | Sep
      | Oct
      | Nov
      | Dec
    [@@deriving sexp, sexp_grammar, compare, equal, hash, quickcheck, variants]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__003_ = "month.ml.before-ppx.Stable.V1.t" in
         function
         | Sexplib0.Sexp.Atom ("jan" | "Jan") -> Jan
         | Sexplib0.Sexp.Atom ("feb" | "Feb") -> Feb
         | Sexplib0.Sexp.Atom ("mar" | "Mar") -> Mar
         | Sexplib0.Sexp.Atom ("apr" | "Apr") -> Apr
         | Sexplib0.Sexp.Atom ("may" | "May") -> May
         | Sexplib0.Sexp.Atom ("jun" | "Jun") -> Jun
         | Sexplib0.Sexp.Atom ("jul" | "Jul") -> Jul
         | Sexplib0.Sexp.Atom ("aug" | "Aug") -> Aug
         | Sexplib0.Sexp.Atom ("sep" | "Sep") -> Sep
         | Sexplib0.Sexp.Atom ("oct" | "Oct") -> Oct
         | Sexplib0.Sexp.Atom ("nov" | "Nov") -> Nov
         | Sexplib0.Sexp.Atom ("dec" | "Dec") -> Dec
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("jan" | "Jan") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("feb" | "Feb") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mar" | "Mar") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("apr" | "Apr") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("may" | "May") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("jun" | "Jun") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("jul" | "Jul") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aug" | "Aug") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sep" | "Sep") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("oct" | "Oct") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nov" | "Nov") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("dec" | "Dec") :: _) as sexp__004_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
         | Sexplib0.Sexp.List [] as sexp__002_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
         | sexp__002_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Jan -> Sexplib0.Sexp.Atom "Jan"
         | Feb -> Sexplib0.Sexp.Atom "Feb"
         | Mar -> Sexplib0.Sexp.Atom "Mar"
         | Apr -> Sexplib0.Sexp.Atom "Apr"
         | May -> Sexplib0.Sexp.Atom "May"
         | Jun -> Sexplib0.Sexp.Atom "Jun"
         | Jul -> Sexplib0.Sexp.Atom "Jul"
         | Aug -> Sexplib0.Sexp.Atom "Aug"
         | Sep -> Sexplib0.Sexp.Atom "Sep"
         | Oct -> Sexplib0.Sexp.Atom "Oct"
         | Nov -> Sexplib0.Sexp.Atom "Nov"
         | Dec -> Sexplib0.Sexp.Atom "Dec"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
        { untyped =
            Variant
              { case_sensitivity = Case_sensitive_except_first_character
              ; clauses =
                  [ No_tag { name = "Jan"; clause_kind = Atom_clause }
                  ; No_tag { name = "Feb"; clause_kind = Atom_clause }
                  ; No_tag { name = "Mar"; clause_kind = Atom_clause }
                  ; No_tag { name = "Apr"; clause_kind = Atom_clause }
                  ; No_tag { name = "May"; clause_kind = Atom_clause }
                  ; No_tag { name = "Jun"; clause_kind = Atom_clause }
                  ; No_tag { name = "Jul"; clause_kind = Atom_clause }
                  ; No_tag { name = "Aug"; clause_kind = Atom_clause }
                  ; No_tag { name = "Sep"; clause_kind = Atom_clause }
                  ; No_tag { name = "Oct"; clause_kind = Atom_clause }
                  ; No_tag { name = "Nov"; clause_kind = Atom_clause }
                  ; No_tag { name = "Dec"; clause_kind = Atom_clause }
                  ]
              }
        }
      ;;

      let _ = t_sexp_grammar

      let compare =
        (fun a__005_ b__006_ -> Stdlib.compare a__005_ b__006_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__007_ b__008_ -> Stdlib.( = ) a__007_ b__008_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        (fun hsv arg ->
           Ppx_hash_lib.Std.Hash.fold_int
             hsv
             (match arg with
              | Jan -> 0
              | Feb -> 1
              | Mar -> 2
              | Apr -> 3
              | May -> 4
              | Jun -> 5
              | Jul -> 6
              | Aug -> 7
              | Sep -> 8
              | Oct -> 9
              | Nov -> 10
              | Dec -> 11)
         : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
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

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
          [ ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__012_ ~random:_random__013_ -> Jan) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__014_ ~random:_random__015_ -> Feb) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__016_ ~random:_random__017_ -> Mar) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__018_ ~random:_random__019_ -> Apr) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__020_ ~random:_random__021_ -> May) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__022_ ~random:_random__023_ -> Jun) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__024_ ~random:_random__025_ -> Jul) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__026_ ~random:_random__027_ -> Aug) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__028_ ~random:_random__029_ -> Sep) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__030_ ~random:_random__031_ -> Oct) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__032_ ~random:_random__033_ -> Nov) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__034_ ~random:_random__035_ -> Dec) )
          ]
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__009_ ~size:_size__010_ ~hash:_hash__011_ ->
             match _x__009_ with
             | Jan ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 0
               in
               _hash__011_
             | Feb ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 1
               in
               _hash__011_
             | Mar ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 2
               in
               _hash__011_
             | Apr ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 3
               in
               _hash__011_
             | May ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 4
               in
               _hash__011_
             | Jun ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 5
               in
               _hash__011_
             | Jul ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 6
               in
               _hash__011_
             | Aug ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 7
               in
               _hash__011_
             | Sep ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 8
               in
               _hash__011_
             | Oct ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 9
               in
               _hash__011_
             | Nov ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 10
               in
               _hash__011_
             | Dec ->
               let _hash__011_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__011_ 11
               in
               _hash__011_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
          | Jan -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Feb -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Mar -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Apr -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | May -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Jun -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Jul -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Aug -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Sep -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Oct -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Nov -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Dec -> Ppx_quickcheck_runtime.Base.Sequence.round_robin [])
      ;;

      let _ = quickcheck_shrinker
      let jan = Jan
      let _ = jan
      let feb = Feb
      let _ = feb
      let mar = Mar
      let _ = mar
      let apr = Apr
      let _ = apr
      let may = May
      let _ = may
      let jun = Jun
      let _ = jun
      let jul = Jul
      let _ = jul
      let aug = Aug
      let _ = aug
      let sep = Sep
      let _ = sep
      let oct = Oct
      let _ = oct
      let nov = Nov
      let _ = nov
      let dec = Dec
      let _ = dec

      let is_jan = function
        | Jan -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_jan

      let is_feb = function
        | Feb -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_feb

      let is_mar = function
        | Mar -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_mar

      let is_apr = function
        | Apr -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_apr

      let is_may = function
        | May -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_may

      let is_jun = function
        | Jun -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_jun

      let is_jul = function
        | Jul -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_jul

      let is_aug = function
        | Aug -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_aug

      let is_sep = function
        | Sep -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_sep

      let is_oct = function
        | Oct -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_oct

      let is_nov = function
        | Nov -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_nov

      let is_dec = function
        | Dec -> true
        | _ -> false
      [@@warning "-4"]
      ;;

      let _ = is_dec

      let jan_val = function
        | Jan -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = jan_val

      let feb_val = function
        | Feb -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = feb_val

      let mar_val = function
        | Mar -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = mar_val

      let apr_val = function
        | Apr -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = apr_val

      let may_val = function
        | May -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = may_val

      let jun_val = function
        | Jun -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = jun_val

      let jul_val = function
        | Jul -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = jul_val

      let aug_val = function
        | Aug -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = aug_val

      let sep_val = function
        | Sep -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = sep_val

      let oct_val = function
        | Oct -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = oct_val

      let nov_val = function
        | Nov -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = nov_val

      let dec_val = function
        | Dec -> Stdlib.Option.Some ()
        | _ -> Stdlib.Option.None
      [@@warning "-4"]
      ;;

      let _ = dec_val

      module Variants = struct
        let jan = { Variantslib.Variant.name = "Jan"; rank = 0; constructor = jan }
        let _ = jan
        let feb = { Variantslib.Variant.name = "Feb"; rank = 1; constructor = feb }
        let _ = feb
        let mar = { Variantslib.Variant.name = "Mar"; rank = 2; constructor = mar }
        let _ = mar
        let apr = { Variantslib.Variant.name = "Apr"; rank = 3; constructor = apr }
        let _ = apr
        let may = { Variantslib.Variant.name = "May"; rank = 4; constructor = may }
        let _ = may
        let jun = { Variantslib.Variant.name = "Jun"; rank = 5; constructor = jun }
        let _ = jun
        let jul = { Variantslib.Variant.name = "Jul"; rank = 6; constructor = jul }
        let _ = jul
        let aug = { Variantslib.Variant.name = "Aug"; rank = 7; constructor = aug }
        let _ = aug
        let sep = { Variantslib.Variant.name = "Sep"; rank = 8; constructor = sep }
        let _ = sep
        let oct = { Variantslib.Variant.name = "Oct"; rank = 9; constructor = oct }
        let _ = oct
        let nov = { Variantslib.Variant.name = "Nov"; rank = 10; constructor = nov }
        let _ = nov
        let dec = { Variantslib.Variant.name = "Dec"; rank = 11; constructor = dec }
        let _ = dec

        let fold
              ~init:init__
              ~jan:jan_fun__
              ~feb:feb_fun__
              ~mar:mar_fun__
              ~apr:apr_fun__
              ~may:may_fun__
              ~jun:jun_fun__
              ~jul:jul_fun__
              ~aug:aug_fun__
              ~sep:sep_fun__
              ~oct:oct_fun__
              ~nov:nov_fun__
              ~dec:dec_fun__
          =
          dec_fun__
            (nov_fun__
               (oct_fun__
                  (sep_fun__
                     (aug_fun__
                        (jul_fun__
                           (jun_fun__
                              (may_fun__
                                 (apr_fun__
                                    (mar_fun__ (feb_fun__ (jan_fun__ init__ jan) feb) mar)
                                    apr)
                                 may)
                              jun)
                           jul)
                        aug)
                     sep)
                  oct)
               nov)
            dec
        ;;

        let _ = fold

        let iter
              ~jan:jan_fun__
              ~feb:feb_fun__
              ~mar:mar_fun__
              ~apr:apr_fun__
              ~may:may_fun__
              ~jun:jun_fun__
              ~jul:jul_fun__
              ~aug:aug_fun__
              ~sep:sep_fun__
              ~oct:oct_fun__
              ~nov:nov_fun__
              ~dec:dec_fun__
          =
          (jan_fun__ jan : unit);
          (feb_fun__ feb : unit);
          (mar_fun__ mar : unit);
          (apr_fun__ apr : unit);
          (may_fun__ may : unit);
          (jun_fun__ jun : unit);
          (jul_fun__ jul : unit);
          (aug_fun__ aug : unit);
          (sep_fun__ sep : unit);
          (oct_fun__ oct : unit);
          (nov_fun__ nov : unit);
          (dec_fun__ dec : unit)
        ;;

        let _ = iter

        let map
              t__
              ~jan:jan_fun__
              ~feb:feb_fun__
              ~mar:mar_fun__
              ~apr:apr_fun__
              ~may:may_fun__
              ~jun:jun_fun__
              ~jul:jul_fun__
              ~aug:aug_fun__
              ~sep:sep_fun__
              ~oct:oct_fun__
              ~nov:nov_fun__
              ~dec:dec_fun__
          =
          match t__ with
          | Jan -> jan_fun__ jan
          | Feb -> feb_fun__ feb
          | Mar -> mar_fun__ mar
          | Apr -> apr_fun__ apr
          | May -> may_fun__ may
          | Jun -> jun_fun__ jun
          | Jul -> jul_fun__ jul
          | Aug -> aug_fun__ aug
          | Sep -> sep_fun__ sep
          | Oct -> oct_fun__ oct
          | Nov -> nov_fun__ nov
          | Dec -> dec_fun__ dec
        ;;

        let _ = map

        let make_matcher
              ~jan:jan_fun__
              ~feb:feb_fun__
              ~mar:mar_fun__
              ~apr:apr_fun__
              ~may:may_fun__
              ~jun:jun_fun__
              ~jul:jul_fun__
              ~aug:aug_fun__
              ~sep:sep_fun__
              ~oct:oct_fun__
              ~nov:nov_fun__
              ~dec:dec_fun__
              compile_acc__
          =
          let jan_gen__, compile_acc__ = jan_fun__ jan compile_acc__ in
          let feb_gen__, compile_acc__ = feb_fun__ feb compile_acc__ in
          let mar_gen__, compile_acc__ = mar_fun__ mar compile_acc__ in
          let apr_gen__, compile_acc__ = apr_fun__ apr compile_acc__ in
          let may_gen__, compile_acc__ = may_fun__ may compile_acc__ in
          let jun_gen__, compile_acc__ = jun_fun__ jun compile_acc__ in
          let jul_gen__, compile_acc__ = jul_fun__ jul compile_acc__ in
          let aug_gen__, compile_acc__ = aug_fun__ aug compile_acc__ in
          let sep_gen__, compile_acc__ = sep_fun__ sep compile_acc__ in
          let oct_gen__, compile_acc__ = oct_fun__ oct compile_acc__ in
          let nov_gen__, compile_acc__ = nov_fun__ nov compile_acc__ in
          let dec_gen__, compile_acc__ = dec_fun__ dec compile_acc__ in
          ( map
              ~jan:(fun _ -> jan_gen__ ())
              ~feb:(fun _ -> feb_gen__ ())
              ~mar:(fun _ -> mar_gen__ ())
              ~apr:(fun _ -> apr_gen__ ())
              ~may:(fun _ -> may_gen__ ())
              ~jun:(fun _ -> jun_gen__ ())
              ~jul:(fun _ -> jul_gen__ ())
              ~aug:(fun _ -> aug_gen__ ())
              ~sep:(fun _ -> sep_gen__ ())
              ~oct:(fun _ -> oct_gen__ ())
              ~nov:(fun _ -> nov_gen__ ())
              ~dec:(fun _ -> dec_gen__ ())
          , compile_acc__ )
        ;;

        let _ = make_matcher

        let to_rank = function
          | Jan -> 0
          | Feb -> 1
          | Mar -> 2
          | Apr -> 3
          | May -> 4
          | Jun -> 5
          | Jul -> 6
          | Aug -> 7
          | Sep -> 8
          | Oct -> 9
          | Nov -> 10
          | Dec -> 11
        ;;

        let _ = to_rank

        let to_name = function
          | Jan -> "Jan"
          | Feb -> "Feb"
          | Mar -> "Mar"
          | Apr -> "Apr"
          | May -> "May"
          | Jun -> "Jun"
          | Jul -> "Jul"
          | Aug -> "Aug"
          | Sep -> "Sep"
          | Oct -> "Oct"
          | Nov -> "Nov"
          | Dec -> "Dec"
        ;;

        let _ = to_name

        let descriptions =
          [ "Jan", 0
          ; "Feb", 0
          ; "Mar", 0
          ; "Apr", 0
          ; "May", 0
          ; "Jun", 0
          ; "Jul", 0
          ; "Aug", 0
          ; "Sep", 0
          ; "Oct", 0
          ; "Nov", 0
          ; "Dec", 0
          ]
        ;;

        let _ = descriptions
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let failwithf = Printf.failwithf

    let of_int_exn i : t =
      match i with
      | 1 -> Jan
      | 2 -> Feb
      | 3 -> Mar
      | 4 -> Apr
      | 5 -> May
      | 6 -> Jun
      | 7 -> Jul
      | 8 -> Aug
      | 9 -> Sep
      | 10 -> Oct
      | 11 -> Nov
      | 12 -> Dec
      | _ -> failwithf "Month.of_int_exn %d" i ()
    ;;

    let of_int i =
      try Some (of_int_exn i) with
      | _ -> None
    ;;

    let to_int (t : t) =
      match t with
      | Jan -> 1
      | Feb -> 2
      | Mar -> 3
      | Apr -> 4
      | May -> 5
      | Jun -> 6
      | Jul -> 7
      | Aug -> 8
      | Sep -> 9
      | Oct -> 10
      | Nov -> 11
      | Dec -> 12
    ;;

    let to_binable t = to_int t - 1
    let of_binable i = of_int_exn (i + 1)

    include
      Binable.Stable.Of_binable.V1 [@alert "-legacy"]
        (Int.Stable.V1)
        (struct
          type nonrec t = t

          let to_binable = to_binable
          let of_binable = of_binable
        end)

    include (val Comparator.Stable.V1.make ~compare ~sexp_of_t)

    let stable_witness : t Stable_witness.t =
      Stable_witness.of_serializable Int.Stable.V1.stable_witness of_binable to_binable
    ;;
  end
end

let num_months = 12

module T = struct
  include Stable.V1

  let all = [ Jan; Feb; Mar; Apr; May; Jun; Jul; Aug; Sep; Oct; Nov; Dec ]
  let hash = to_int
end

include T

include (
  Hashable.Make_binable (struct
    include T
  end) :
    Hashable.S_binable with type t := t)

include Comparable.Make_binable_using_comparator (struct
    include T

    let t_of_sexp sexp =
      match Option.try_with (fun () -> Int.t_of_sexp sexp) with
      | Some i -> of_int_exn (i + 1)
      | None -> T.t_of_sexp sexp
    ;;
  end)

let sexp_of_t = T.sexp_of_t
let t_of_sexp = T.t_of_sexp
let shift t i = of_int_exn (1 + Int.( % ) (to_int t - 1 + i) num_months)

let all_strings =
  lazy
    (Array.of_list (List.map all ~f:(fun variant -> Sexp.to_string (sexp_of_t variant))))
;;

let to_string (t : t) =
  let all_strings = Lazy.force all_strings in
  all_strings.(to_int t - 1)
;;

let of_string =
  let table =
    lazy
      (let module T = String.Table in
       let table = T.create ~size:num_months () in
       Array.iteri (Lazy.force all_strings) ~f:(fun i s ->
         let t = of_int_exn (i + 1) in
         Hashtbl.set table ~key:s ~data:t;
         Hashtbl.set table ~key:(String.lowercase s) ~data:t;
         Hashtbl.set table ~key:(String.uppercase s) ~data:t);
       table)
  in
  fun str ->
    match Hashtbl.find (Lazy.force table) str with
    | Some x -> x
    | None -> failwithf "Invalid month: %s" str ()
;;

module Export = struct
  type month = t =
    | Jan
    | Feb
    | Mar
    | Apr
    | May
    | Jun
    | Jul
    | Aug
    | Sep
    | Oct
    | Nov
    | Dec
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
