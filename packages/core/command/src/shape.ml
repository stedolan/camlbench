let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"shape.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "shape.ml.before-ppx"
;;

module Stable = struct
  open Sexplib0.Sexp_conv
  open Ppx_compare_lib.Builtin
  open Ppx_stable_witness_runtime.Stable_witness.Export

  module Lazy = struct
    type 'a t = 'a lazy_t [@@deriving sexp, stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__001_ x__003_ -> lazy_t_of_sexp _of_a__001_ x__003_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__004_ x__005_ -> sexp_of_lazy_t _of_a__004_ x__005_
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
          -> 'a lazy_t Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_lazy_t
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare = Base.Lazy.compare
  end

  module Anons = struct
    module Grammar = struct
      module V1 = struct
        type t =
          | Zero
          | One of string
          | Many of t
          | Maybe of t
          | Concat of t list
          | Ad_hoc of string
        [@@deriving compare, sexp, stable_witness]

        include struct
          let _ = fun (_ : t) -> ()

          let rec compare =
            (fun a__006_ b__007_ ->
               if Stdlib.( == ) a__006_ b__007_
               then 0
               else (
                 match a__006_, b__007_ with
                 | Zero, Zero -> 0
                 | Zero, _ -> -1
                 | _, Zero -> 1
                 | One _a__008_, One _b__009_ -> compare_string _a__008_ _b__009_
                 | One _, _ -> -1
                 | _, One _ -> 1
                 | Many _a__010_, Many _b__011_ -> compare _a__010_ _b__011_
                 | Many _, _ -> -1
                 | _, Many _ -> 1
                 | Maybe _a__012_, Maybe _b__013_ -> compare _a__012_ _b__013_
                 | Maybe _, _ -> -1
                 | _, Maybe _ -> 1
                 | Concat _a__014_, Concat _b__015_ ->
                   compare_list
                     (fun a__016_ (b__017_ [@merlin.hide]) ->
                        (compare a__016_ b__017_ [@merlin.hide]))
                     _a__014_
                     _b__015_
                 | Concat _, _ -> -1
                 | _, Concat _ -> 1
                 | Ad_hoc _a__018_, Ad_hoc _b__019_ -> compare_string _a__018_ _b__019_)
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let rec t_of_sexp =
            (let error_source__022_ = "shape.ml.before-ppx.Stable.Anons.Grammar.V1.t" in
             function
             | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("one" | "One") as _tag__025_) :: sexp_args__026_)
               as _sexp__024_ ->
               (match sexp_args__026_ with
                | arg0__027_ :: [] ->
                  let res0__028_ = string_of_sexp arg0__027_ in
                  One res0__028_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__025_
                    _sexp__024_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("many" | "Many") as _tag__030_) :: sexp_args__031_)
               as _sexp__029_ ->
               (match sexp_args__031_ with
                | arg0__032_ :: [] ->
                  let res0__033_ = t_of_sexp arg0__032_ in
                  Many res0__033_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__030_
                    _sexp__029_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("maybe" | "Maybe") as _tag__035_)
                 :: sexp_args__036_) as _sexp__034_ ->
               (match sexp_args__036_ with
                | arg0__037_ :: [] ->
                  let res0__038_ = t_of_sexp arg0__037_ in
                  Maybe res0__038_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__035_
                    _sexp__034_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("concat" | "Concat") as _tag__040_)
                 :: sexp_args__041_) as _sexp__039_ ->
               (match sexp_args__041_ with
                | arg0__042_ :: [] ->
                  let res0__043_ = list_of_sexp t_of_sexp arg0__042_ in
                  Concat res0__043_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__040_
                    _sexp__039_)
             | Sexplib0.Sexp.List
                 (Sexplib0.Sexp.Atom (("ad_hoc" | "Ad_hoc") as _tag__045_)
                 :: sexp_args__046_) as _sexp__044_ ->
               (match sexp_args__046_ with
                | arg0__047_ :: [] ->
                  let res0__048_ = string_of_sexp arg0__047_ in
                  Ad_hoc res0__048_
                | _ ->
                  Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                    error_source__022_
                    _tag__045_
                    _sexp__044_)
             | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("zero" | "Zero") :: _) as
               sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_no_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("one" | "One") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("many" | "Many") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("maybe" | "Maybe") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("concat" | "Concat") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.Atom ("ad_hoc" | "Ad_hoc") as sexp__023_ ->
               Sexplib0.Sexp_conv_error.stag_takes_args error_source__022_ sexp__023_
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__021_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_sum
                 error_source__022_
                 sexp__021_
             | Sexplib0.Sexp.List [] as sexp__021_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_sum
                 error_source__022_
                 sexp__021_
             | sexp__021_ ->
               Sexplib0.Sexp_conv_error.unexpected_stag error_source__022_ sexp__021_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let rec sexp_of_t =
            (function
             | Zero -> Sexplib0.Sexp.Atom "Zero"
             | One arg0__049_ ->
               let res0__050_ = sexp_of_string arg0__049_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "One"; res0__050_ ]
             | Many arg0__051_ ->
               let res0__052_ = sexp_of_t arg0__051_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Many"; res0__052_ ]
             | Maybe arg0__053_ ->
               let res0__054_ = sexp_of_t arg0__053_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Maybe"; res0__054_ ]
             | Concat arg0__055_ ->
               let res0__056_ = sexp_of_list sexp_of_t arg0__055_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Concat"; res0__056_ ]
             | Ad_hoc arg0__057_ ->
               let res0__058_ = sexp_of_string arg0__057_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ad_hoc"; res0__058_ ]
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let rec stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_string
            and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
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

        let rec invariant t =
          Base.Invariant.invariant
            { Ppx_here_lib.pos_fname = "shape.ml.before-ppx"
            ; pos_lnum = 25
            ; pos_cnum = 621
            ; pos_bol = 586
            }
            t
            (sexp_of_t [@merlin.hide])
            (fun () ->
               match t with
               | Zero -> ()
               | One _ -> ()
               | Many Zero -> failwith "Many Zero should be just Zero"
               | Many t -> invariant t
               | Maybe Zero -> failwith "Maybe Zero should be just Zero"
               | Maybe t -> invariant t
               | Concat [] | Concat (_ :: []) ->
                 failwith "Flatten zero and one-element Concat"
               | Concat ts -> Base.List.iter ts ~f:invariant
               | Ad_hoc _ -> ())
        ;;

        let t_of_sexp sexp =
          let t = (t_of_sexp [@merlin.hide]) sexp in
          invariant t;
          t
        ;;

        let rec usage =
          let open Import in
          function
          | Zero -> ""
          | One usage -> usage
          | Many Zero -> failwith "bug in command.ml"
          | Many (One _ as t) -> sprintf "[%s ...]" (usage t)
          | Many t -> sprintf "[(%s) ...]" (usage t)
          | Maybe Zero -> failwith "bug in command.ml"
          | Maybe t -> sprintf "[%s]" (usage t)
          | Concat ts -> Base.String.concat ~sep:" " (Base.List.map ts ~f:usage)
          | Ad_hoc usage -> usage
        ;;
      end

      module Model = V1
    end

    module V2 = struct
      type t =
        | Usage of string
        | Grammar of Grammar.V1.t
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__059_ b__060_ ->
             if Stdlib.( == ) a__059_ b__060_
             then 0
             else (
               match a__059_, b__060_ with
               | Usage _a__061_, Usage _b__062_ -> compare_string _a__061_ _b__062_
               | Usage _, _ -> -1
               | _, Usage _ -> 1
               | Grammar _a__063_, Grammar _b__064_ ->
                 Grammar.V1.compare _a__063_ _b__064_)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let t_of_sexp =
          (let error_source__067_ = "shape.ml.before-ppx.Stable.Anons.V2.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("usage" | "Usage") as _tag__070_) :: sexp_args__071_)
             as _sexp__069_ ->
             (match sexp_args__071_ with
              | arg0__072_ :: [] ->
                let res0__073_ = string_of_sexp arg0__072_ in
                Usage res0__073_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__067_
                  _tag__070_
                  _sexp__069_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("grammar" | "Grammar") as _tag__075_)
               :: sexp_args__076_) as _sexp__074_ ->
             (match sexp_args__076_ with
              | arg0__077_ :: [] ->
                let res0__078_ = Grammar.V1.t_of_sexp arg0__077_ in
                Grammar res0__078_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__067_
                  _tag__075_
                  _sexp__074_)
           | Sexplib0.Sexp.Atom ("usage" | "Usage") as sexp__068_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__067_ sexp__068_
           | Sexplib0.Sexp.Atom ("grammar" | "Grammar") as sexp__068_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__067_ sexp__068_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__066_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__067_
               sexp__066_
           | Sexplib0.Sexp.List [] as sexp__066_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__067_ sexp__066_
           | sexp__066_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__067_ sexp__066_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | Usage arg0__079_ ->
             let res0__080_ = sexp_of_string arg0__079_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Usage"; res0__080_ ]
           | Grammar arg0__081_ ->
             let res0__082_ = Grammar.V1.sexp_of_t arg0__081_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Grammar"; res0__082_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _ : Grammar.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Grammar.V1.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Model = V2
  end

  module Flag_info = struct
    module V1 = struct
      type t =
        { name : string
        ; doc : string
        ; aliases : string list
        }
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__083_ b__084_ ->
             if Stdlib.( == ) a__083_ b__084_
             then 0
             else (
               match compare_string a__083_.name b__084_.name with
               | 0 ->
                 (match compare_string a__083_.doc b__084_.doc with
                  | 0 ->
                    compare_list
                      (fun a__085_ (b__086_ [@merlin.hide]) ->
                         (compare_string a__085_ b__086_ [@merlin.hide]))
                      a__083_.aliases
                      b__084_.aliases
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let t_of_sexp =
          (let error_source__088_ = "shape.ml.before-ppx.Stable.Flag_info.V1.t" in
           fun x__089_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__088_
               ~fields:
                 (Field
                    { name = "name"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "doc"
                          ; kind = Required
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "aliases"
                                ; kind = Required
                                ; conv = list_of_sexp string_of_sexp
                                ; rest = Empty
                                }
                          }
                    })
               ~index_of_field:(function
                 | "name" -> 0
                 | "doc" -> 1
                 | "aliases" -> 2
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (name, (doc, (aliases, ()))) -> ({ name; doc; aliases } : t))
               x__089_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { name = name__091_; doc = doc__093_; aliases = aliases__095_ } ->
             let bnds__090_ = ([] : _ Stdlib.List.t) in
             let bnds__090_ =
               let arg__096_ = sexp_of_list sexp_of_string aliases__095_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliases"; arg__096_ ]
                :: bnds__090_
                : _ Stdlib.List.t)
             in
             let bnds__090_ =
               let arg__094_ = sexp_of_string doc__093_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "doc"; arg__094_ ] :: bnds__090_
                : _ Stdlib.List.t)
             in
             let bnds__090_ =
               let arg__092_ = sexp_of_string name__091_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__092_ ] :: bnds__090_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__090_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Model = V1
  end

  module Base_info = struct
    module V2 = struct
      type t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; anons : Anons.V2.t
        ; flags : Flag_info.V1.t list
        }
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__097_ b__098_ ->
             if Stdlib.( == ) a__097_ b__098_
             then 0
             else (
               match compare_string a__097_.summary b__098_.summary with
               | 0 ->
                 (match
                    compare_option
                      (fun a__099_ (b__100_ [@merlin.hide]) ->
                         (compare_string a__099_ b__100_ [@merlin.hide]))
                      a__097_.readme
                      b__098_.readme
                  with
                  | 0 ->
                    (match Anons.V2.compare a__097_.anons b__098_.anons with
                     | 0 ->
                       compare_list
                         (fun a__101_ (b__102_ [@merlin.hide]) ->
                            (Flag_info.V1.compare a__101_ b__102_ [@merlin.hide]))
                         a__097_.flags
                         b__098_.flags
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let t_of_sexp =
          (let error_source__104_ = "shape.ml.before-ppx.Stable.Base_info.V2.t" in
           fun x__105_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__104_
               ~fields:
                 (Field
                    { name = "summary"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "readme"
                          ; kind = Sexp_option
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "anons"
                                ; kind = Required
                                ; conv = Anons.V2.t_of_sexp
                                ; rest =
                                    Field
                                      { name = "flags"
                                      ; kind = Required
                                      ; conv = list_of_sexp Flag_info.V1.t_of_sexp
                                      ; rest = Empty
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "summary" -> 0
                 | "readme" -> 1
                 | "anons" -> 2
                 | "flags" -> 3
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (summary, (readme, (anons, (flags, ())))) ->
                 ({ summary; readme; anons; flags } : t))
               x__105_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { summary = summary__107_
               ; readme = readme__109_
               ; anons = anons__113_
               ; flags = flags__115_
               } ->
             let bnds__106_ = ([] : _ Stdlib.List.t) in
             let bnds__106_ =
               let arg__116_ = sexp_of_list Flag_info.V1.sexp_of_t flags__115_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags"; arg__116_ ] :: bnds__106_
                : _ Stdlib.List.t)
             in
             let bnds__106_ =
               let arg__114_ = Anons.V2.sexp_of_t anons__113_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "anons"; arg__114_ ] :: bnds__106_
                : _ Stdlib.List.t)
             in
             let bnds__106_ =
               match readme__109_ with
               | Stdlib.Option.None -> bnds__106_
               | Stdlib.Option.Some v__110_ ->
                 let arg__112_ = sexp_of_string v__110_ in
                 let bnd__111_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__112_ ]
                 in
                 (bnd__111_ :: bnds__106_ : _ Stdlib.List.t)
             in
             let bnds__106_ =
               let arg__108_ = sexp_of_string summary__107_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__108_ ]
                :: bnds__106_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__106_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _ : Anons.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
            Anons.V2.stable_witness
          and _
            :  Flag_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            -> Flag_info.V1.t list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : Flag_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Flag_info.V1.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V1 = struct
      type t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; usage : string
        ; flags : Flag_info.V1.t list
        }
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__118_ = "shape.ml.before-ppx.Stable.Base_info.V1.t" in
           fun x__119_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__118_
               ~fields:
                 (Field
                    { name = "summary"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "readme"
                          ; kind = Sexp_option
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "usage"
                                ; kind = Required
                                ; conv = string_of_sexp
                                ; rest =
                                    Field
                                      { name = "flags"
                                      ; kind = Required
                                      ; conv = list_of_sexp Flag_info.V1.t_of_sexp
                                      ; rest = Empty
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "summary" -> 0
                 | "readme" -> 1
                 | "usage" -> 2
                 | "flags" -> 3
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (summary, (readme, (usage, (flags, ())))) ->
                 ({ summary; readme; usage; flags } : t))
               x__119_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { summary = summary__121_
               ; readme = readme__123_
               ; usage = usage__127_
               ; flags = flags__129_
               } ->
             let bnds__120_ = ([] : _ Stdlib.List.t) in
             let bnds__120_ =
               let arg__130_ = sexp_of_list Flag_info.V1.sexp_of_t flags__129_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags"; arg__130_ ] :: bnds__120_
                : _ Stdlib.List.t)
             in
             let bnds__120_ =
               let arg__128_ = sexp_of_string usage__127_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "usage"; arg__128_ ] :: bnds__120_
                : _ Stdlib.List.t)
             in
             let bnds__120_ =
               match readme__123_ with
               | Stdlib.Option.None -> bnds__120_
               | Stdlib.Option.Some v__124_ ->
                 let arg__126_ = sexp_of_string v__124_ in
                 let bnd__125_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__126_ ]
                 in
                 (bnd__125_ :: bnds__120_ : _ Stdlib.List.t)
             in
             let bnds__120_ =
               let arg__122_ = sexp_of_string summary__121_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__122_ ]
                :: bnds__120_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__120_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            :  Flag_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            -> Flag_info.V1.t list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : Flag_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Flag_info.V1.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_latest { summary; readme; usage; flags } =
        { V2.summary; readme; anons = Usage usage; flags }
      ;;

      let of_latest { V2.summary; readme; anons; flags } =
        { summary
        ; readme
        ; usage =
            (match anons with
             | Usage usage -> usage
             | Grammar grammar -> Anons.Grammar.V1.usage grammar)
        ; flags
        }
      ;;
    end

    module Model = V2
  end

  module Group_info = struct
    type a = Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types
    [@@deriving bin_io]

    include struct
      let _ = fun (_ : a) -> ()

      let bin_shape_a =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "shape.ml.before-ppx:125:4")
            [ ( Bin_prot.Shape.Tid.of_string "a"
              , []
              , Bin_prot.Shape.variant
                  [ ( "Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types"
                    , [] )
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "a")) []
      ;;

      let _ = bin_shape_a

      let bin_size_a : a Bin_prot.Size.sizer = function
        | Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types -> 1
      ;;

      let _ = bin_size_a

      let bin_write_a : a Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types ->
          Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      ;;

      let _ = bin_write_a

      let bin_writer_a =
        ({ size = bin_size_a; write = bin_write_a } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_a

      let __bin_read_a__ : (int -> a) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "shape.ml.before-ppx.Stable.Group_info.a"
          !pos_ref
      ;;

      let _ = __bin_read_a__

      let bin_read_a : a Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 -> Dummy_type_because_we_cannot_digest_type_constructors_only_concrete_types
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "shape.ml.before-ppx.Stable.Group_info.a")
            !pos_ref
      ;;

      let _ = bin_read_a

      let bin_reader_a =
        ({ read = bin_read_a; vtag_read = __bin_read_a__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_a

      let bin_a =
        ({ writer = bin_writer_a; reader = bin_reader_a; shape = bin_shape_a }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_a
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module V2 = struct
      type 'a t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; subcommands : (string * 'a) list Lazy.t
        }
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__131_ b__132_ ->
          if Stdlib.( == ) a__131_ b__132_
          then 0
          else (
            match compare_string a__131_.summary b__132_.summary with
            | 0 ->
              (match
                 compare_option
                   (fun a__133_ (b__134_ [@merlin.hide]) ->
                      (compare_string a__133_ b__134_ [@merlin.hide]))
                   a__131_.readme
                   b__132_.readme
               with
               | 0 ->
                 Lazy.compare
                   (fun a__135_ (b__136_ [@merlin.hide]) ->
                      (compare_list
                         (fun a__137_ (b__138_ [@merlin.hide]) ->
                            ((let t__139_, t__140_ = a__137_ in
                              let t__141_, t__142_ = b__138_ in
                              match compare_string t__139_ t__141_ with
                              | 0 -> _cmp__a t__140_ t__142_
                              | n -> n)
                            [@merlin.hide]))
                         a__135_
                         b__136_ [@merlin.hide]))
                   a__131_.subcommands
                   b__132_.subcommands
               | n -> n)
            | n -> n)
        ;;

        let _ = compare

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          let error_source__145_ = "shape.ml.before-ppx.Stable.Group_info.V2.t" in
          fun _of_a__143_ x__151_ ->
            Sexplib0.Sexp_conv_record.record_of_sexp
              ~caller:error_source__145_
              ~fields:
                (Field
                   { name = "summary"
                   ; kind = Required
                   ; conv = string_of_sexp
                   ; rest =
                       Field
                         { name = "readme"
                         ; kind = Sexp_option
                         ; conv = string_of_sexp
                         ; rest =
                             Field
                               { name = "subcommands"
                               ; kind = Required
                               ; conv =
                                   Lazy.t_of_sexp
                                     (list_of_sexp (function
                                        | Sexplib0.Sexp.List [ arg0__146_; arg1__147_ ] ->
                                          let res0__148_ = string_of_sexp arg0__146_
                                          and res1__149_ = _of_a__143_ arg1__147_ in
                                          res0__148_, res1__149_
                                        | sexp__150_ ->
                                          Sexplib0.Sexp_conv_error
                                          .tuple_of_size_n_expected
                                            error_source__145_
                                            2
                                            sexp__150_))
                               ; rest = Empty
                               }
                         }
                   })
              ~index_of_field:(function
                | "summary" -> 0
                | "readme" -> 1
                | "subcommands" -> 2
                | _ -> -1)
              ~allow_extra_fields:false
              ~create:(fun (summary, (readme, (subcommands, ()))) ->
                ({ summary; readme; subcommands } : _ t))
              x__151_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__152_
            { summary = summary__154_
            ; readme = readme__156_
            ; subcommands = subcommands__160_
            } ->
          let bnds__153_ = ([] : _ Stdlib.List.t) in
          let bnds__153_ =
            let arg__161_ =
              Lazy.sexp_of_t
                (sexp_of_list (fun (arg0__162_, arg1__163_) ->
                   let res0__164_ = sexp_of_string arg0__162_
                   and res1__165_ = _of_a__152_ arg1__163_ in
                   Sexplib0.Sexp.List [ res0__164_; res1__165_ ]))
                subcommands__160_
            in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "subcommands"; arg__161_ ]
             :: bnds__153_
             : _ Stdlib.List.t)
          in
          let bnds__153_ =
            match readme__156_ with
            | Stdlib.Option.None -> bnds__153_
            | Stdlib.Option.Some v__157_ ->
              let arg__159_ = sexp_of_string v__157_ in
              let bnd__158_ =
                Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__159_ ]
              in
              (bnd__158_ :: bnds__153_ : _ Stdlib.List.t)
          in
          let bnds__153_ =
            let arg__155_ = sexp_of_string summary__154_ in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__155_ ] :: bnds__153_
             : _ Stdlib.List.t)
          in
          Sexplib0.Sexp.List bnds__153_
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
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            :  (string * 'a) list Ppx_stable_witness_runtime.Stable_witness.t
            -> (string * 'a) list Lazy.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Lazy.stable_witness
          and _
            :  (string * 'a) Ppx_stable_witness_runtime.Stable_witness.t
            -> (string * 'a) list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open! Base

      let map t ~f =
        { t with subcommands = Lazy.map t.subcommands ~f:(List.Assoc.map ~f) }
      ;;
    end

    module Model = V2

    module V1 = struct
      type 'a t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; subcommands : (string * 'a) list
        }
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__166_ b__167_ ->
          if Stdlib.( == ) a__166_ b__167_
          then 0
          else (
            match compare_string a__166_.summary b__167_.summary with
            | 0 ->
              (match
                 compare_option
                   (fun a__168_ (b__169_ [@merlin.hide]) ->
                      (compare_string a__168_ b__169_ [@merlin.hide]))
                   a__166_.readme
                   b__167_.readme
               with
               | 0 ->
                 compare_list
                   (fun a__170_ (b__171_ [@merlin.hide]) ->
                      ((let t__172_, t__173_ = a__170_ in
                        let t__174_, t__175_ = b__171_ in
                        match compare_string t__172_ t__174_ with
                        | 0 -> _cmp__a t__173_ t__175_
                        | n -> n)
                      [@merlin.hide]))
                   a__166_.subcommands
                   b__167_.subcommands
               | n -> n)
            | n -> n)
        ;;

        let _ = compare

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          let error_source__178_ = "shape.ml.before-ppx.Stable.Group_info.V1.t" in
          fun _of_a__176_ x__184_ ->
            Sexplib0.Sexp_conv_record.record_of_sexp
              ~caller:error_source__178_
              ~fields:
                (Field
                   { name = "summary"
                   ; kind = Required
                   ; conv = string_of_sexp
                   ; rest =
                       Field
                         { name = "readme"
                         ; kind = Sexp_option
                         ; conv = string_of_sexp
                         ; rest =
                             Field
                               { name = "subcommands"
                               ; kind = Required
                               ; conv =
                                   list_of_sexp (function
                                     | Sexplib0.Sexp.List [ arg0__179_; arg1__180_ ] ->
                                       let res0__181_ = string_of_sexp arg0__179_
                                       and res1__182_ = _of_a__176_ arg1__180_ in
                                       res0__181_, res1__182_
                                     | sexp__183_ ->
                                       Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                                         error_source__178_
                                         2
                                         sexp__183_)
                               ; rest = Empty
                               }
                         }
                   })
              ~index_of_field:(function
                | "summary" -> 0
                | "readme" -> 1
                | "subcommands" -> 2
                | _ -> -1)
              ~allow_extra_fields:false
              ~create:(fun (summary, (readme, (subcommands, ()))) ->
                ({ summary; readme; subcommands } : _ t))
              x__184_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__185_
            { summary = summary__187_
            ; readme = readme__189_
            ; subcommands = subcommands__193_
            } ->
          let bnds__186_ = ([] : _ Stdlib.List.t) in
          let bnds__186_ =
            let arg__194_ =
              sexp_of_list
                (fun (arg0__195_, arg1__196_) ->
                   let res0__197_ = sexp_of_string arg0__195_
                   and res1__198_ = _of_a__185_ arg1__196_ in
                   Sexplib0.Sexp.List [ res0__197_; res1__198_ ])
                subcommands__193_
            in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "subcommands"; arg__194_ ]
             :: bnds__186_
             : _ Stdlib.List.t)
          in
          let bnds__186_ =
            match readme__189_ with
            | Stdlib.Option.None -> bnds__186_
            | Stdlib.Option.Some v__190_ ->
              let arg__192_ = sexp_of_string v__190_ in
              let bnd__191_ =
                Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__192_ ]
              in
              (bnd__191_ :: bnds__186_ : _ Stdlib.List.t)
          in
          let bnds__186_ =
            let arg__188_ = sexp_of_string summary__187_ in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__188_ ] :: bnds__186_
             : _ Stdlib.List.t)
          in
          Sexplib0.Sexp.List bnds__186_
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
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            :  (string * 'a) Ppx_stable_witness_runtime.Stable_witness.t
            -> (string * 'a) list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      open! Base

      let map t ~f = { t with subcommands = List.Assoc.map t.subcommands ~f }

      let to_latest { summary; readme; subcommands } : 'a Model.t =
        { summary; readme; subcommands = Lazy.from_val subcommands }
      ;;

      let of_latest ({ summary; readme; subcommands } : 'a Model.t) : 'a t =
        { summary; readme; subcommands = Lazy.force subcommands }
      ;;
    end
  end

  module Exec_info = struct
    let abs_path ~dir path =
      if Filename_base.is_absolute path then path else Filename_base.concat dir path
    ;;

    module V3 = struct
      type t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; working_dir : string
        ; path_to_exe : string
        ; child_subcommand : string list
        }
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__199_ b__200_ ->
             if Stdlib.( == ) a__199_ b__200_
             then 0
             else (
               match compare_string a__199_.summary b__200_.summary with
               | 0 ->
                 (match
                    compare_option
                      (fun a__201_ (b__202_ [@merlin.hide]) ->
                         (compare_string a__201_ b__202_ [@merlin.hide]))
                      a__199_.readme
                      b__200_.readme
                  with
                  | 0 ->
                    (match compare_string a__199_.working_dir b__200_.working_dir with
                     | 0 ->
                       (match compare_string a__199_.path_to_exe b__200_.path_to_exe with
                        | 0 ->
                          compare_list
                            (fun a__203_ (b__204_ [@merlin.hide]) ->
                               (compare_string a__203_ b__204_ [@merlin.hide]))
                            a__199_.child_subcommand
                            b__200_.child_subcommand
                        | n -> n)
                     | n -> n)
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let t_of_sexp =
          (let error_source__206_ = "shape.ml.before-ppx.Stable.Exec_info.V3.t" in
           fun x__207_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__206_
               ~fields:
                 (Field
                    { name = "summary"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "readme"
                          ; kind = Sexp_option
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "working_dir"
                                ; kind = Required
                                ; conv = string_of_sexp
                                ; rest =
                                    Field
                                      { name = "path_to_exe"
                                      ; kind = Required
                                      ; conv = string_of_sexp
                                      ; rest =
                                          Field
                                            { name = "child_subcommand"
                                            ; kind = Required
                                            ; conv = list_of_sexp string_of_sexp
                                            ; rest = Empty
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "summary" -> 0
                 | "readme" -> 1
                 | "working_dir" -> 2
                 | "path_to_exe" -> 3
                 | "child_subcommand" -> 4
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( summary
                   , (readme, (working_dir, (path_to_exe, (child_subcommand, ())))) ) ->
                 ({ summary; readme; working_dir; path_to_exe; child_subcommand } : t))
               x__207_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { summary = summary__209_
               ; readme = readme__211_
               ; working_dir = working_dir__215_
               ; path_to_exe = path_to_exe__217_
               ; child_subcommand = child_subcommand__219_
               } ->
             let bnds__208_ = ([] : _ Stdlib.List.t) in
             let bnds__208_ =
               let arg__220_ = sexp_of_list sexp_of_string child_subcommand__219_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "child_subcommand"; arg__220_ ]
                :: bnds__208_
                : _ Stdlib.List.t)
             in
             let bnds__208_ =
               let arg__218_ = sexp_of_string path_to_exe__217_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "path_to_exe"; arg__218_ ]
                :: bnds__208_
                : _ Stdlib.List.t)
             in
             let bnds__208_ =
               let arg__216_ = sexp_of_string working_dir__215_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "working_dir"; arg__216_ ]
                :: bnds__208_
                : _ Stdlib.List.t)
             in
             let bnds__208_ =
               match readme__211_ with
               | Stdlib.Option.None -> bnds__208_
               | Stdlib.Option.Some v__212_ ->
                 let arg__214_ = sexp_of_string v__212_ in
                 let bnd__213_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__214_ ]
                 in
                 (bnd__213_ :: bnds__208_ : _ Stdlib.List.t)
             in
             let bnds__208_ =
               let arg__210_ = sexp_of_string summary__209_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__210_ ]
                :: bnds__208_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__208_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string list Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_list
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_latest = Base.Fn.id
      let of_latest = Base.Fn.id
    end

    module Model = V3

    module V2 = struct
      type t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; working_dir : string
        ; path_to_exe : string
        }
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__222_ = "shape.ml.before-ppx.Stable.Exec_info.V2.t" in
           fun x__223_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__222_
               ~fields:
                 (Field
                    { name = "summary"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "readme"
                          ; kind = Sexp_option
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "working_dir"
                                ; kind = Required
                                ; conv = string_of_sexp
                                ; rest =
                                    Field
                                      { name = "path_to_exe"
                                      ; kind = Required
                                      ; conv = string_of_sexp
                                      ; rest = Empty
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "summary" -> 0
                 | "readme" -> 1
                 | "working_dir" -> 2
                 | "path_to_exe" -> 3
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (summary, (readme, (working_dir, (path_to_exe, ())))) ->
                 ({ summary; readme; working_dir; path_to_exe } : t))
               x__223_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { summary = summary__225_
               ; readme = readme__227_
               ; working_dir = working_dir__231_
               ; path_to_exe = path_to_exe__233_
               } ->
             let bnds__224_ = ([] : _ Stdlib.List.t) in
             let bnds__224_ =
               let arg__234_ = sexp_of_string path_to_exe__233_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "path_to_exe"; arg__234_ ]
                :: bnds__224_
                : _ Stdlib.List.t)
             in
             let bnds__224_ =
               let arg__232_ = sexp_of_string working_dir__231_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "working_dir"; arg__232_ ]
                :: bnds__224_
                : _ Stdlib.List.t)
             in
             let bnds__224_ =
               match readme__227_ with
               | Stdlib.Option.None -> bnds__224_
               | Stdlib.Option.Some v__228_ ->
                 let arg__230_ = sexp_of_string v__228_ in
                 let bnd__229_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__230_ ]
                 in
                 (bnd__229_ :: bnds__224_ : _ Stdlib.List.t)
             in
             let bnds__224_ =
               let arg__226_ = sexp_of_string summary__225_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__226_ ]
                :: bnds__224_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__224_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_v3 t : V3.t =
        { summary = t.summary
        ; readme = t.readme
        ; working_dir = t.working_dir
        ; path_to_exe = t.path_to_exe
        ; child_subcommand = []
        }
      ;;

      let of_v3 (t : V3.t) =
        { summary = t.summary
        ; readme = t.readme
        ; working_dir = t.working_dir
        ; path_to_exe = abs_path ~dir:t.working_dir t.path_to_exe
        }
      ;;

      let to_latest = Base.Fn.compose V3.to_latest to_v3
      let of_latest = Base.Fn.compose of_v3 V3.of_latest
    end

    module V1 = struct
      type t =
        { summary : string
        ; readme : string option [@sexp.option]
        ; path_to_exe : string
        }
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__236_ = "shape.ml.before-ppx.Stable.Exec_info.V1.t" in
           fun x__237_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__236_
               ~fields:
                 (Field
                    { name = "summary"
                    ; kind = Required
                    ; conv = string_of_sexp
                    ; rest =
                        Field
                          { name = "readme"
                          ; kind = Sexp_option
                          ; conv = string_of_sexp
                          ; rest =
                              Field
                                { name = "path_to_exe"
                                ; kind = Required
                                ; conv = string_of_sexp
                                ; rest = Empty
                                }
                          }
                    })
               ~index_of_field:(function
                 | "summary" -> 0
                 | "readme" -> 1
                 | "path_to_exe" -> 2
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (summary, (readme, (path_to_exe, ()))) ->
                 ({ summary; readme; path_to_exe } : t))
               x__237_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { summary = summary__239_
               ; readme = readme__241_
               ; path_to_exe = path_to_exe__245_
               } ->
             let bnds__238_ = ([] : _ Stdlib.List.t) in
             let bnds__238_ =
               let arg__246_ = sexp_of_string path_to_exe__245_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "path_to_exe"; arg__246_ ]
                :: bnds__238_
                : _ Stdlib.List.t)
             in
             let bnds__238_ =
               match readme__241_ with
               | Stdlib.Option.None -> bnds__238_
               | Stdlib.Option.Some v__242_ ->
                 let arg__244_ = sexp_of_string v__242_ in
                 let bnd__243_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__244_ ]
                 in
                 (bnd__243_ :: bnds__238_ : _ Stdlib.List.t)
             in
             let bnds__238_ =
               let arg__240_ = sexp_of_string summary__239_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__240_ ]
                :: bnds__238_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__238_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          and _
            :  string Ppx_stable_witness_runtime.Stable_witness.t
            -> string option Ppx_stable_witness_runtime.Stable_witness.t
            =
            stable_witness_option
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_v2 t : V2.t =
        { summary = t.summary
        ; readme = t.readme
        ; working_dir = "/"
        ; path_to_exe = t.path_to_exe
        }
      ;;

      let of_v2 (t : V2.t) =
        { summary = t.summary
        ; readme = t.readme
        ; path_to_exe = abs_path ~dir:t.working_dir t.path_to_exe
        }
      ;;

      let to_latest = Base.Fn.compose V2.to_latest to_v2
      let of_latest = Base.Fn.compose of_v2 V2.of_latest
    end
  end

  module Fully_forced = struct
    module V1 = struct
      type t =
        | Basic of Base_info.V2.t
        | Group of t Group_info.V2.t
        | Exec of Exec_info.V3.t * t
      [@@deriving compare, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let rec compare =
          (fun a__247_ b__248_ ->
             if Stdlib.( == ) a__247_ b__248_
             then 0
             else (
               match a__247_, b__248_ with
               | Basic _a__249_, Basic _b__250_ -> Base_info.V2.compare _a__249_ _b__250_
               | Basic _, _ -> -1
               | _, Basic _ -> 1
               | Group _a__251_, Group _b__252_ ->
                 Group_info.V2.compare
                   (fun a__253_ (b__254_ [@merlin.hide]) ->
                      (compare a__253_ b__254_ [@merlin.hide]))
                   _a__251_
                   _b__252_
               | Group _, _ -> -1
               | _, Group _ -> 1
               | Exec (_a__255_, _a__257_), Exec (_b__256_, _b__258_) ->
                 (match Exec_info.V3.compare _a__255_ _b__256_ with
                  | 0 -> compare _a__257_ _b__258_
                  | n -> n))
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let rec t_of_sexp =
          (let error_source__261_ = "shape.ml.before-ppx.Stable.Fully_forced.V1.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("basic" | "Basic") as _tag__264_) :: sexp_args__265_)
             as _sexp__263_ ->
             (match sexp_args__265_ with
              | arg0__266_ :: [] ->
                let res0__267_ = Base_info.V2.t_of_sexp arg0__266_ in
                Basic res0__267_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__261_
                  _tag__264_
                  _sexp__263_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("group" | "Group") as _tag__269_) :: sexp_args__270_)
             as _sexp__268_ ->
             (match sexp_args__270_ with
              | arg0__271_ :: [] ->
                let res0__272_ = Group_info.V2.t_of_sexp t_of_sexp arg0__271_ in
                Group res0__272_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__261_
                  _tag__269_
                  _sexp__268_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("exec" | "Exec") as _tag__274_) :: sexp_args__275_)
             as _sexp__273_ ->
             (match sexp_args__275_ with
              | [ arg0__276_; arg1__277_ ] ->
                let res0__278_ = Exec_info.V3.t_of_sexp arg0__276_
                and res1__279_ = t_of_sexp arg1__277_ in
                Exec (res0__278_, res1__279_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__261_
                  _tag__274_
                  _sexp__273_)
           | Sexplib0.Sexp.Atom ("basic" | "Basic") as sexp__262_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__261_ sexp__262_
           | Sexplib0.Sexp.Atom ("group" | "Group") as sexp__262_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__261_ sexp__262_
           | Sexplib0.Sexp.Atom ("exec" | "Exec") as sexp__262_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__261_ sexp__262_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__260_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__261_
               sexp__260_
           | Sexplib0.Sexp.List [] as sexp__260_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__261_ sexp__260_
           | sexp__260_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__261_ sexp__260_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let rec sexp_of_t =
          (function
           | Basic arg0__280_ ->
             let res0__281_ = Base_info.V2.sexp_of_t arg0__280_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Basic"; res0__281_ ]
           | Group arg0__282_ ->
             let res0__283_ = Group_info.V2.sexp_of_t sexp_of_t arg0__282_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__283_ ]
           | Exec (arg0__284_, arg1__285_) ->
             let res0__286_ = Exec_info.V3.sexp_of_t arg0__284_
             and res1__287_ = sexp_of_t arg1__285_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__286_; res1__287_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let rec stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : Base_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
            Base_info.V2.stable_witness
          and _
            :  t Ppx_stable_witness_runtime.Stable_witness.t
            -> t Group_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Group_info.V2.stable_witness
          and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
          and _ : Exec_info.V3.t Ppx_stable_witness_runtime.Stable_witness.t =
            Exec_info.V3.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Model = V1
  end

  module Sexpable = struct
    module V3 = struct
      type t =
        | Base of Base_info.V2.t
        | Group of t Group_info.V2.t
        | Exec of Exec_info.V3.t
        | Lazy of t Lazy.t
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let rec t_of_sexp =
          (let error_source__290_ = "shape.ml.before-ppx.Stable.Sexpable.V3.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("base" | "Base") as _tag__293_) :: sexp_args__294_)
             as _sexp__292_ ->
             (match sexp_args__294_ with
              | arg0__295_ :: [] ->
                let res0__296_ = Base_info.V2.t_of_sexp arg0__295_ in
                Base res0__296_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__290_
                  _tag__293_
                  _sexp__292_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("group" | "Group") as _tag__298_) :: sexp_args__299_)
             as _sexp__297_ ->
             (match sexp_args__299_ with
              | arg0__300_ :: [] ->
                let res0__301_ = Group_info.V2.t_of_sexp t_of_sexp arg0__300_ in
                Group res0__301_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__290_
                  _tag__298_
                  _sexp__297_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("exec" | "Exec") as _tag__303_) :: sexp_args__304_)
             as _sexp__302_ ->
             (match sexp_args__304_ with
              | arg0__305_ :: [] ->
                let res0__306_ = Exec_info.V3.t_of_sexp arg0__305_ in
                Exec res0__306_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__290_
                  _tag__303_
                  _sexp__302_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("lazy" | "Lazy") as _tag__308_) :: sexp_args__309_)
             as _sexp__307_ ->
             (match sexp_args__309_ with
              | arg0__310_ :: [] ->
                let res0__311_ = Lazy.t_of_sexp t_of_sexp arg0__310_ in
                Lazy res0__311_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__290_
                  _tag__308_
                  _sexp__307_)
           | Sexplib0.Sexp.Atom ("base" | "Base") as sexp__291_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__290_ sexp__291_
           | Sexplib0.Sexp.Atom ("group" | "Group") as sexp__291_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__290_ sexp__291_
           | Sexplib0.Sexp.Atom ("exec" | "Exec") as sexp__291_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__290_ sexp__291_
           | Sexplib0.Sexp.Atom ("lazy" | "Lazy") as sexp__291_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__290_ sexp__291_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__289_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__290_
               sexp__289_
           | Sexplib0.Sexp.List [] as sexp__289_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__290_ sexp__289_
           | sexp__289_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__290_ sexp__289_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let rec sexp_of_t =
          (function
           | Base arg0__312_ ->
             let res0__313_ = Base_info.V2.sexp_of_t arg0__312_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__313_ ]
           | Group arg0__314_ ->
             let res0__315_ = Group_info.V2.sexp_of_t sexp_of_t arg0__314_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__315_ ]
           | Exec arg0__316_ ->
             let res0__317_ = Exec_info.V3.sexp_of_t arg0__316_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__317_ ]
           | Lazy arg0__318_ ->
             let res0__319_ = Lazy.sexp_of_t sexp_of_t arg0__318_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Lazy"; res0__319_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let rec stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : Base_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
            Base_info.V2.stable_witness
          and _
            :  t Ppx_stable_witness_runtime.Stable_witness.t
            -> t Group_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Group_info.V2.stable_witness
          and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
          and _ : Exec_info.V3.t Ppx_stable_witness_runtime.Stable_witness.t =
            Exec_info.V3.stable_witness
          and _
            :  t Ppx_stable_witness_runtime.Stable_witness.t
            -> t Lazy.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Lazy.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_latest = Base.Fn.id
      let of_latest = Base.Fn.id
    end

    module Model = V3

    module V2 = struct
      type t =
        | Base of Base_info.V2.t
        | Group of t Group_info.V1.t
        | Exec of Exec_info.V2.t
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let rec t_of_sexp =
          (let error_source__322_ = "shape.ml.before-ppx.Stable.Sexpable.V2.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("base" | "Base") as _tag__325_) :: sexp_args__326_)
             as _sexp__324_ ->
             (match sexp_args__326_ with
              | arg0__327_ :: [] ->
                let res0__328_ = Base_info.V2.t_of_sexp arg0__327_ in
                Base res0__328_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__322_
                  _tag__325_
                  _sexp__324_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("group" | "Group") as _tag__330_) :: sexp_args__331_)
             as _sexp__329_ ->
             (match sexp_args__331_ with
              | arg0__332_ :: [] ->
                let res0__333_ = Group_info.V1.t_of_sexp t_of_sexp arg0__332_ in
                Group res0__333_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__322_
                  _tag__330_
                  _sexp__329_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("exec" | "Exec") as _tag__335_) :: sexp_args__336_)
             as _sexp__334_ ->
             (match sexp_args__336_ with
              | arg0__337_ :: [] ->
                let res0__338_ = Exec_info.V2.t_of_sexp arg0__337_ in
                Exec res0__338_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__322_
                  _tag__335_
                  _sexp__334_)
           | Sexplib0.Sexp.Atom ("base" | "Base") as sexp__323_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__322_ sexp__323_
           | Sexplib0.Sexp.Atom ("group" | "Group") as sexp__323_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__322_ sexp__323_
           | Sexplib0.Sexp.Atom ("exec" | "Exec") as sexp__323_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__322_ sexp__323_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__321_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__322_
               sexp__321_
           | Sexplib0.Sexp.List [] as sexp__321_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__322_ sexp__321_
           | sexp__321_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__322_ sexp__321_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let rec sexp_of_t =
          (function
           | Base arg0__339_ ->
             let res0__340_ = Base_info.V2.sexp_of_t arg0__339_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__340_ ]
           | Group arg0__341_ ->
             let res0__342_ = Group_info.V1.sexp_of_t sexp_of_t arg0__341_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__342_ ]
           | Exec arg0__343_ ->
             let res0__344_ = Exec_info.V2.sexp_of_t arg0__343_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__344_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let rec stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : Base_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
            Base_info.V2.stable_witness
          and _
            :  t Ppx_stable_witness_runtime.Stable_witness.t
            -> t Group_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Group_info.V1.stable_witness
          and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
          and _ : Exec_info.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
            Exec_info.V2.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let rec to_latest : t -> Model.t = function
        | Base b -> Base b
        | Exec e -> Exec (Exec_info.V2.to_latest e)
        | Group g -> Group (Group_info.V1.to_latest (Group_info.V1.map g ~f:to_latest))
      ;;

      let rec of_latest : Model.t -> t = function
        | Base b -> Base b
        | Exec e -> Exec (Exec_info.V2.of_latest e)
        | Lazy thunk -> of_latest (Base.Lazy.force thunk)
        | Group g -> Group (Group_info.V1.map (Group_info.V1.of_latest g) ~f:of_latest)
      ;;
    end

    module V1 = struct
      type t =
        | Base of Base_info.V1.t
        | Group of t Group_info.V1.t
        | Exec of Exec_info.V1.t
      [@@deriving sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let rec t_of_sexp =
          (let error_source__347_ = "shape.ml.before-ppx.Stable.Sexpable.V1.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("base" | "Base") as _tag__350_) :: sexp_args__351_)
             as _sexp__349_ ->
             (match sexp_args__351_ with
              | arg0__352_ :: [] ->
                let res0__353_ = Base_info.V1.t_of_sexp arg0__352_ in
                Base res0__353_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__347_
                  _tag__350_
                  _sexp__349_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("group" | "Group") as _tag__355_) :: sexp_args__356_)
             as _sexp__354_ ->
             (match sexp_args__356_ with
              | arg0__357_ :: [] ->
                let res0__358_ = Group_info.V1.t_of_sexp t_of_sexp arg0__357_ in
                Group res0__358_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__347_
                  _tag__355_
                  _sexp__354_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("exec" | "Exec") as _tag__360_) :: sexp_args__361_)
             as _sexp__359_ ->
             (match sexp_args__361_ with
              | arg0__362_ :: [] ->
                let res0__363_ = Exec_info.V1.t_of_sexp arg0__362_ in
                Exec res0__363_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__347_
                  _tag__360_
                  _sexp__359_)
           | Sexplib0.Sexp.Atom ("base" | "Base") as sexp__348_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__347_ sexp__348_
           | Sexplib0.Sexp.Atom ("group" | "Group") as sexp__348_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__347_ sexp__348_
           | Sexplib0.Sexp.Atom ("exec" | "Exec") as sexp__348_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__347_ sexp__348_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__346_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__347_
               sexp__346_
           | Sexplib0.Sexp.List [] as sexp__346_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__347_ sexp__346_
           | sexp__346_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__347_ sexp__346_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let rec sexp_of_t =
          (function
           | Base arg0__364_ ->
             let res0__365_ = Base_info.V1.sexp_of_t arg0__364_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__365_ ]
           | Group arg0__366_ ->
             let res0__367_ = Group_info.V1.sexp_of_t sexp_of_t arg0__366_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__367_ ]
           | Exec arg0__368_ ->
             let res0__369_ = Exec_info.V1.sexp_of_t arg0__368_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__369_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let rec stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : Base_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Base_info.V1.stable_witness
          and _
            :  t Ppx_stable_witness_runtime.Stable_witness.t
            -> t Group_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t
            =
            Group_info.V1.stable_witness
          and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness
          and _ : Exec_info.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Exec_info.V1.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let rec to_latest : t -> Model.t = function
        | Base b -> Base (Base_info.V1.to_latest b)
        | Exec e -> Exec (Exec_info.V1.to_latest e)
        | Group g -> Group (Group_info.V1.to_latest (Group_info.V1.map g ~f:to_latest))
      ;;

      let rec of_latest : Model.t -> t = function
        | Base b -> Base (Base_info.V1.of_latest b)
        | Exec e -> Exec (Exec_info.V1.of_latest e)
        | Lazy thunk -> of_latest (Base.Lazy.force thunk)
        | Group g -> Group (Group_info.V1.map (Group_info.V1.of_latest g) ~f:of_latest)
      ;;
    end

    module Versioned = struct
      type t =
        | V1 of V1.t
        | V2 of V2.t
        | V3 of V3.t
      [@@deriving sexp, variants, stable_witness]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__372_ = "shape.ml.before-ppx.Stable.Sexpable.Versioned.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("v1" | "V1") as _tag__375_) :: sexp_args__376_) as
             _sexp__374_ ->
             (match sexp_args__376_ with
              | arg0__377_ :: [] ->
                let res0__378_ = V1.t_of_sexp arg0__377_ in
                V1 res0__378_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__372_
                  _tag__375_
                  _sexp__374_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("v2" | "V2") as _tag__380_) :: sexp_args__381_) as
             _sexp__379_ ->
             (match sexp_args__381_ with
              | arg0__382_ :: [] ->
                let res0__383_ = V2.t_of_sexp arg0__382_ in
                V2 res0__383_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__372_
                  _tag__380_
                  _sexp__379_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("v3" | "V3") as _tag__385_) :: sexp_args__386_) as
             _sexp__384_ ->
             (match sexp_args__386_ with
              | arg0__387_ :: [] ->
                let res0__388_ = V3.t_of_sexp arg0__387_ in
                V3 res0__388_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__372_
                  _tag__385_
                  _sexp__384_)
           | Sexplib0.Sexp.Atom ("v1" | "V1") as sexp__373_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__372_ sexp__373_
           | Sexplib0.Sexp.Atom ("v2" | "V2") as sexp__373_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__372_ sexp__373_
           | Sexplib0.Sexp.Atom ("v3" | "V3") as sexp__373_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__372_ sexp__373_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__371_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__372_
               sexp__371_
           | Sexplib0.Sexp.List [] as sexp__371_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__372_ sexp__371_
           | sexp__371_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__372_ sexp__371_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | V1 arg0__389_ ->
             let res0__390_ = V1.sexp_of_t arg0__389_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "V1"; res0__390_ ]
           | V2 arg0__391_ ->
             let res0__392_ = V2.sexp_of_t arg0__391_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "V2"; res0__392_ ]
           | V3 arg0__393_ ->
             let res0__394_ = V3.sexp_of_t arg0__393_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "V3"; res0__394_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
        let v1 v0 = V1 v0
        let _ = v1
        let v2 v0 = V2 v0
        let _ = v2
        let v3 v0 = V3 v0
        let _ = v3

        let is_v1 = function
          | V1 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_v1

        let is_v2 = function
          | V2 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_v2

        let is_v3 = function
          | V3 _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_v3

        let v1_val = function
          | V1 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = v1_val

        let v2_val = function
          | V2 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = v2_val

        let v3_val = function
          | V3 v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = v3_val

        module Variants = struct
          let v1 = { Variantslib.Variant.name = "V1"; rank = 0; constructor = v1 }
          let _ = v1
          let v2 = { Variantslib.Variant.name = "V2"; rank = 1; constructor = v2 }
          let _ = v2
          let v3 = { Variantslib.Variant.name = "V3"; rank = 2; constructor = v3 }
          let _ = v3

          let fold ~init:init__ ~v1:v1_fun__ ~v2:v2_fun__ ~v3:v3_fun__ =
            v3_fun__ (v2_fun__ (v1_fun__ init__ v1) v2) v3
          ;;

          let _ = fold

          let iter ~v1:v1_fun__ ~v2:v2_fun__ ~v3:v3_fun__ =
            (v1_fun__ v1 : unit);
            (v2_fun__ v2 : unit);
            (v3_fun__ v3 : unit)
          ;;

          let _ = iter

          let map t__ ~v1:v1_fun__ ~v2:v2_fun__ ~v3:v3_fun__ =
            match t__ with
            | V1 v0 -> v1_fun__ v1 v0
            | V2 v0 -> v2_fun__ v2 v0
            | V3 v0 -> v3_fun__ v3 v0
          ;;

          let _ = map

          let make_matcher ~v1:v1_fun__ ~v2:v2_fun__ ~v3:v3_fun__ compile_acc__ =
            let v1_gen__, compile_acc__ = v1_fun__ v1 compile_acc__ in
            let v2_gen__, compile_acc__ = v2_fun__ v2 compile_acc__ in
            let v3_gen__, compile_acc__ = v3_fun__ v3 compile_acc__ in
            ( map ~v1:(fun _ -> v1_gen__) ~v2:(fun _ -> v2_gen__) ~v3:(fun _ -> v3_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | V1 _ -> 0
            | V2 _ -> 1
            | V3 _ -> 2
          ;;

          let _ = to_rank

          let to_name = function
            | V1 _ -> "V1"
            | V2 _ -> "V2"
            | V3 _ -> "V3"
          ;;

          let _ = to_name
          let descriptions = [ "V1", 1; "V2", 1; "V3", 1 ]
          let _ = descriptions
        end

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : V1.t Ppx_stable_witness_runtime.Stable_witness.t = V1.stable_witness
          and _ : V2.t Ppx_stable_witness_runtime.Stable_witness.t = V2.stable_witness
          and _ : V3.t Ppx_stable_witness_runtime.Stable_witness.t = V3.stable_witness in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_latest = function
        | V1 t -> V1.to_latest t
        | V2 t -> V2.to_latest t
        | V3 t -> V3.to_latest t
      ;;

      let of_latest ~version_to_use latest =
        match version_to_use with
        | 1 -> V1 (V1.of_latest latest)
        | 2 -> V2 (V2.of_latest latest)
        | 3 -> V3 (V3.of_latest latest)
        | other ->
          Base.Error.raise
            (Base.Error.create
               ~here:
                 { Ppx_here_lib.pos_fname = "shape.ml.before-ppx"
                 ; pos_lnum = 336
                 ; pos_cnum = 9011
                 ; pos_bol = 8993
                 }
               "unsupported version_to_use"
               other
               (sexp_of_int [@merlin.hide]))
      ;;
    end
  end
end

open! Base
open! Import

module Anons = struct
  module Grammar = struct
    type t = Stable.Anons.Grammar.Model.t =
      | Zero
      | One of string
      | Many of t
      | Maybe of t
      | Concat of t list
      | Ad_hoc of string
    [@@deriving compare, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let rec compare =
        (fun a__395_ b__396_ ->
           if Stdlib.( == ) a__395_ b__396_
           then 0
           else (
             match a__395_, b__396_ with
             | Zero, Zero -> 0
             | Zero, _ -> -1
             | _, Zero -> 1
             | One _a__397_, One _b__398_ -> compare_string _a__397_ _b__398_
             | One _, _ -> -1
             | _, One _ -> 1
             | Many _a__399_, Many _b__400_ -> compare _a__399_ _b__400_
             | Many _, _ -> -1
             | _, Many _ -> 1
             | Maybe _a__401_, Maybe _b__402_ -> compare _a__401_ _b__402_
             | Maybe _, _ -> -1
             | _, Maybe _ -> 1
             | Concat _a__403_, Concat _b__404_ ->
               compare_list
                 (fun a__405_ (b__406_ [@merlin.hide]) ->
                    (compare a__405_ b__406_ [@merlin.hide]))
                 _a__403_
                 _b__404_
             | Concat _, _ -> -1
             | _, Concat _ -> 1
             | Ad_hoc _a__407_, Ad_hoc _b__408_ -> compare_string _a__407_ _b__408_)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let rec t_of_sexp =
        (let error_source__411_ = "shape.ml.before-ppx.Anons.Grammar.t" in
         function
         | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("one" | "One") as _tag__414_) :: sexp_args__415_) as
           _sexp__413_ ->
           (match sexp_args__415_ with
            | arg0__416_ :: [] ->
              let res0__417_ = string_of_sexp arg0__416_ in
              One res0__417_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__411_
                _tag__414_
                _sexp__413_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("many" | "Many") as _tag__419_) :: sexp_args__420_) as
           _sexp__418_ ->
           (match sexp_args__420_ with
            | arg0__421_ :: [] ->
              let res0__422_ = t_of_sexp arg0__421_ in
              Many res0__422_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__411_
                _tag__419_
                _sexp__418_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("maybe" | "Maybe") as _tag__424_) :: sexp_args__425_)
           as _sexp__423_ ->
           (match sexp_args__425_ with
            | arg0__426_ :: [] ->
              let res0__427_ = t_of_sexp arg0__426_ in
              Maybe res0__427_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__411_
                _tag__424_
                _sexp__423_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("concat" | "Concat") as _tag__429_) :: sexp_args__430_)
           as _sexp__428_ ->
           (match sexp_args__430_ with
            | arg0__431_ :: [] ->
              let res0__432_ = list_of_sexp t_of_sexp arg0__431_ in
              Concat res0__432_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__411_
                _tag__429_
                _sexp__428_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("ad_hoc" | "Ad_hoc") as _tag__434_) :: sexp_args__435_)
           as _sexp__433_ ->
           (match sexp_args__435_ with
            | arg0__436_ :: [] ->
              let res0__437_ = string_of_sexp arg0__436_ in
              Ad_hoc res0__437_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__411_
                _tag__434_
                _sexp__433_)
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("zero" | "Zero") :: _) as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.Atom ("one" | "One") as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.Atom ("many" | "Many") as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.Atom ("maybe" | "Maybe") as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.Atom ("concat" | "Concat") as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.Atom ("ad_hoc" | "Ad_hoc") as sexp__412_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__411_ sexp__412_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__410_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__411_ sexp__410_
         | Sexplib0.Sexp.List [] as sexp__410_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__411_ sexp__410_
         | sexp__410_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__411_ sexp__410_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let rec sexp_of_t =
        (function
         | Zero -> Sexplib0.Sexp.Atom "Zero"
         | One arg0__438_ ->
           let res0__439_ = sexp_of_string arg0__438_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "One"; res0__439_ ]
         | Many arg0__440_ ->
           let res0__441_ = sexp_of_t arg0__440_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Many"; res0__441_ ]
         | Maybe arg0__442_ ->
           let res0__443_ = sexp_of_t arg0__442_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Maybe"; res0__443_ ]
         | Concat arg0__444_ ->
           let res0__445_ = sexp_of_list sexp_of_t arg0__444_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Concat"; res0__445_ ]
         | Ad_hoc arg0__446_ ->
           let res0__447_ = sexp_of_string arg0__446_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ad_hoc"; res0__447_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let invariant = Stable.Anons.Grammar.Model.invariant
    let usage = Stable.Anons.Grammar.Model.usage
  end

  type t = Stable.Anons.Model.t =
    | Usage of string
    | Grammar of Grammar.t
  [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__448_ b__449_ ->
         if Stdlib.( == ) a__448_ b__449_
         then 0
         else (
           match a__448_, b__449_ with
           | Usage _a__450_, Usage _b__451_ -> compare_string _a__450_ _b__451_
           | Usage _, _ -> -1
           | _, Usage _ -> 1
           | Grammar _a__452_, Grammar _b__453_ -> Grammar.compare _a__452_ _b__453_)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (let error_source__456_ = "shape.ml.before-ppx.Anons.t" in
       function
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("usage" | "Usage") as _tag__459_) :: sexp_args__460_) as
         _sexp__458_ ->
         (match sexp_args__460_ with
          | arg0__461_ :: [] ->
            let res0__462_ = string_of_sexp arg0__461_ in
            Usage res0__462_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__456_
              _tag__459_
              _sexp__458_)
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("grammar" | "Grammar") as _tag__464_) :: sexp_args__465_)
         as _sexp__463_ ->
         (match sexp_args__465_ with
          | arg0__466_ :: [] ->
            let res0__467_ = Grammar.t_of_sexp arg0__466_ in
            Grammar res0__467_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__456_
              _tag__464_
              _sexp__463_)
       | Sexplib0.Sexp.Atom ("usage" | "Usage") as sexp__457_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__456_ sexp__457_
       | Sexplib0.Sexp.Atom ("grammar" | "Grammar") as sexp__457_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__456_ sexp__457_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__455_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__456_ sexp__455_
       | Sexplib0.Sexp.List [] as sexp__455_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__456_ sexp__455_
       | sexp__455_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__456_ sexp__455_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | Usage arg0__468_ ->
         let res0__469_ = sexp_of_string arg0__468_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Usage"; res0__469_ ]
       | Grammar arg0__470_ ->
         let res0__471_ = Grammar.sexp_of_t arg0__470_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Grammar"; res0__471_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Num_occurrences = struct
  type t =
    { at_least_once : bool
    ; at_most_once : bool
    }
  [@@deriving compare, enumerate, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__472_ b__473_ ->
         if Stdlib.( == ) a__472_ b__473_
         then 0
         else (
           match compare_bool a__472_.at_least_once b__473_.at_least_once with
           | 0 -> compare_bool a__472_.at_most_once b__473_.at_most_once
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let all =
      (let enumerate__474_ = [ false; true ] in
       let enumerate__475_ = [ false; true ] in
       let rec loop acc enumerate__478_ enumerate__479_ =
         match enumerate__478_, enumerate__479_ with
         | _, [] -> Ppx_enumerate_lib.List.rev acc
         | enumerate__476_ :: enumerate__480_, enumerate__477_ :: _ ->
           loop
             ({ at_least_once = enumerate__476_; at_most_once = enumerate__477_ } :: acc)
             enumerate__480_
             enumerate__479_
         | [], _ :: enumerate__480_ -> loop acc enumerate__474_ enumerate__480_
       in
       loop [] enumerate__474_ enumerate__475_
       : t list)
    ;;

    let _ = all

    let sexp_of_t =
      (fun { at_least_once = at_least_once__482_; at_most_once = at_most_once__484_ } ->
         let bnds__481_ = ([] : _ Stdlib.List.t) in
         let bnds__481_ =
           let arg__485_ = sexp_of_bool at_most_once__484_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "at_most_once"; arg__485_ ]
            :: bnds__481_
            : _ Stdlib.List.t)
         in
         let bnds__481_ =
           let arg__483_ = sexp_of_bool at_least_once__482_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "at_least_once"; arg__483_ ]
            :: bnds__481_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__481_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let maybe_missing_prefix = "["
  let maybe_missing_suffix = "]"
  let maybe_more_suffix = " ..."

  let to_help_string t ~flag_name =
    let { at_least_once; at_most_once } = t in
    let description =
      if at_least_once
      then flag_name
      else String.concat [ maybe_missing_prefix; flag_name; maybe_missing_suffix ]
    in
    if at_most_once then description else String.concat [ description; maybe_more_suffix ]
  ;;

  let of_help_string name =
    let at_most_once, name =
      match String.chop_suffix name ~suffix:maybe_more_suffix with
      | None -> true, name
      | Some name -> false, name
    in
    let at_least_once, name =
      match
        Option.bind
          ~f:(String.chop_suffix ~suffix:maybe_missing_suffix)
          (String.chop_prefix name ~prefix:maybe_missing_prefix)
      with
      | None -> true, name
      | Some name -> false, name
    in
    { at_least_once; at_most_once }, name
  ;;

  let () =
    match Ppx_inline_test_lib.testing with
    | `Not_testing -> ()
    | `Testing _ ->
      let module Ppx_expect_test_block =
        Ppx_expect_runtime.Make_test_block (Expect_test_config)
      in
      Ppx_expect_test_block.run_suite
        ~filename_rel_to_project_root:"shape.ml.before-ppx"
        ~line_number:408
        ~location:{ start_bol = 10743; start_pos = 10745; end_pos = 11360 }
        ~trailing_loc:{ start_bol = 11351; start_pos = 11360; end_pos = 11360 }
        ~body_loc:{ start_bol = 10743; start_pos = 10745; end_pos = 11360 }
        ~formatting_flexibility:
          (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
             Ppx_expect_runtime.Expect_node_formatting.default)
        ~expected_exn:None
        ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
        ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
        ~description:(Some "to_help_string")
        ~tags:[]
        ~inline_test_config:(module Inline_test_config)
        ~expectations:
          ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 0
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents =
                            "\n\
                            \      (((at_least_once false) (at_most_once false)) \
                             \"[name] ...\")\n\
                            \      (((at_least_once true) (at_most_once false)) \"name \
                             ...\")\n\
                            \      (((at_least_once false) (at_most_once true)) [name])\n\
                            \      (((at_least_once true) (at_most_once true)) name)\n\
                            \      "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 11098; start_pos = 11104; end_pos = 11359 } ))
                 ~node_loc:{ start_bol = 11085; start_pos = 11089; end_pos = 11360 } )
           ]
          [@merlin.hide])
        (fun () ->
           let flag_name = "name" in
           List.iter all ~f:(fun t ->
             let s = to_help_string t ~flag_name in
             print_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ (sexp_of_t [@merlin.hide]) t
                    ; Ppx_sexp_conv_lib.Conv.sexp_of_string s
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
             let t', flag_name' = of_help_string s in
             assert (
               (fun (_x__486_ : t) _x__487_ ->
                  (match
                     (fun (a__488_ : t) ((b__489_ : t) [@merlin.hide]) ->
                        (compare a__488_ b__489_ [@merlin.hide]))
                       _x__486_
                       _x__487_
                   with
                   | 0 -> true
                   | _ -> false)
                  [@merlin.hide])
                 t
                 t');
             assert (
               (fun (_x__490_ : string) _x__491_ ->
                  (match
                     (fun (a__492_ : string) ((b__493_ : string) [@merlin.hide]) ->
                        (compare_string a__492_ b__493_ [@merlin.hide]))
                       _x__490_
                       _x__491_
                   with
                   | 0 -> true
                   | _ -> false)
                  [@merlin.hide])
                 flag_name
                 flag_name'));
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
  ;;
end

module Flag_info = struct
  type t = Stable.Flag_info.Model.t =
    { name : string
    ; doc : string
    ; aliases : string list
    }
  [@@deriving compare, fields ~getters, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__494_ b__495_ ->
         if Stdlib.( == ) a__494_ b__495_
         then 0
         else (
           match compare_string a__494_.name b__495_.name with
           | 0 ->
             (match compare_string a__494_.doc b__495_.doc with
              | 0 ->
                compare_list
                  (fun a__496_ (b__497_ [@merlin.hide]) ->
                     (compare_string a__496_ b__497_ [@merlin.hide]))
                  a__494_.aliases
                  b__495_.aliases
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let aliases _r__ = _r__.aliases
    let _ = aliases
    let doc _r__ = _r__.doc
    let _ = doc
    let name _r__ = _r__.name
    let _ = name

    let t_of_sexp =
      (let error_source__499_ = "shape.ml.before-ppx.Flag_info.t" in
       fun x__500_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__499_
           ~fields:
             (Field
                { name = "name"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "doc"
                      ; kind = Required
                      ; conv = string_of_sexp
                      ; rest =
                          Field
                            { name = "aliases"
                            ; kind = Required
                            ; conv = list_of_sexp string_of_sexp
                            ; rest = Empty
                            }
                      }
                })
           ~index_of_field:(function
             | "name" -> 0
             | "doc" -> 1
             | "aliases" -> 2
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (name, (doc, (aliases, ()))) -> ({ name; doc; aliases } : t))
           x__500_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { name = name__502_; doc = doc__504_; aliases = aliases__506_ } ->
         let bnds__501_ = ([] : _ Stdlib.List.t) in
         let bnds__501_ =
           let arg__507_ = sexp_of_list sexp_of_string aliases__506_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliases"; arg__507_ ] :: bnds__501_
            : _ Stdlib.List.t)
         in
         let bnds__501_ =
           let arg__505_ = sexp_of_string doc__504_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "doc"; arg__505_ ] :: bnds__501_
            : _ Stdlib.List.t)
         in
         let bnds__501_ =
           let arg__503_ = sexp_of_string name__502_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "name"; arg__503_ ] :: bnds__501_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__501_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let parse_name t =
    let num_occurrences, flag_name = Num_occurrences.of_help_string t.name in
    match String.split flag_name ~on:' ' with
    | flag_name :: [] -> Ok (num_occurrences, false, flag_name)
    | [ flag_name; _arg_doc ] -> Ok (num_occurrences, true, flag_name)
    | _ ->
      Error
        (Error.create_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unable to parse"
                ; Ppx_sexp_conv_lib.Conv.sexp_of_string flag_name
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
  ;;

  let flag_name t =
    Or_error.map
      ~f:(fun ((_ : Num_occurrences.t), (_ : bool), flag_name) -> flag_name)
      (parse_name t)
  ;;

  let num_occurrences t =
    Or_error.map
      ~f:(fun (num_occurrences, (_ : bool), (_ : string)) -> num_occurrences)
      (parse_name t)
  ;;

  let requires_arg t =
    Or_error.map
      ~f:(fun ((_ : Num_occurrences.t), requires_arg, (_ : string)) -> requires_arg)
      (parse_name t)
  ;;

  let help_screen_compare a b =
    match a, b with
    | _, "[-help]" -> -1
    | "[-help]", _ -> 1
    | _, "[-version]" -> -1
    | "[-version]", _ -> 1
    | _, "[-build-info]" -> -1
    | "[-build-info]", _ -> 1
    | _, "help" -> -1
    | "help", _ -> 1
    | _, "version" -> -1
    | "version", _ -> 1
    | _ -> 0
  ;;
end

module Flag_help_display = struct
  type t = Flag_info.t list

  let sort t =
    List.stable_sort t ~compare:(fun a b ->
      Flag_info.help_screen_compare a.Flag_info.name b.Flag_info.name)
  ;;

  let word_wrap_and_strip text width =
    let chunks = String.split text ~on:'\n' in
    List.concat_map chunks ~f:(fun text ->
      let words =
        List.filter
          ~f:(fun word -> not (String.is_empty word))
          (String.split text ~on:' ')
      in
      match
        List.fold words ~init:None ~f:(fun acc word ->
          Some
            (match acc with
             | None -> [], word
             | Some (lines, line) ->
               let line_and_word = line ^ " " ^ word in
               if String.length line_and_word <= width
               then lines, line_and_word
               else line :: lines, word))
      with
      | None -> []
      | Some (lines, line) -> List.rev (line :: lines))
  ;;

  module Display : sig
    val to_string : t -> string
  end = struct
    let num_cols = 80
    let spaces_string width = String.make width ' '

    let pad_spaces_to_suffix x ~width =
      let slack = width - String.length x in
      x ^ spaces_string slack
    ;;

    let indentation = "  "
    let indent_and_newline x = List.concat [ [ indentation ]; x; [ "\n" ] ]
    let spacing_dot = ". "
    let dot_indentation_offset = 27
    let documentation_start_column = dot_indentation_offset + String.length indentation
    let lhs_width = documentation_start_column
    let lhs_pad_width = dot_indentation_offset + String.length indentation
    let lhs_pad = spaces_string lhs_pad_width

    let lhs_pad_and_newline_terminate =
      List.map ~f:(fun v -> indent_and_newline [ lhs_pad; v ])
    ;;

    let rows flag_name_with_aliases documentation =
      let flag_on_its_own_line =
        let flag_width =
          String.length indentation + String.length flag_name_with_aliases
        in
        if flag_width >= dot_indentation_offset + String.length spacing_dot
        then indent_and_newline [ flag_name_with_aliases ]
        else
          indent_and_newline
            [ pad_spaces_to_suffix ~width:dot_indentation_offset flag_name_with_aliases
            ; spacing_dot
            ]
      in
      let wrapped_documentation =
        word_wrap_and_strip
          documentation
          (num_cols - lhs_width - String.length indentation)
      in
      match wrapped_documentation with
      | [] -> [ flag_on_its_own_line ]
      | doc_wrapped_first_line :: doc_wrapped_rest_lines ->
        let wrapped_doc_lines = lhs_pad_and_newline_terminate doc_wrapped_rest_lines in
        let prefix_doc_wrapped_first_line_with x =
          indent_and_newline
            [ pad_spaces_to_suffix ~width:dot_indentation_offset x
            ; spacing_dot
            ; doc_wrapped_first_line
            ]
        in
        if String.length flag_name_with_aliases >= dot_indentation_offset
        then
          flag_on_its_own_line
          :: prefix_doc_wrapped_first_line_with ""
          :: wrapped_doc_lines
        else
          prefix_doc_wrapped_first_line_with flag_name_with_aliases :: wrapped_doc_lines
    ;;

    let to_string t =
      String.concat
        (List.concat_map t ~f:(fun t ->
           let flag_name_with_aliases =
             let flag = t.Flag_info.name in
             String.concat ~sep:", " (flag :: t.aliases)
           in
           List.concat (rows flag_name_with_aliases t.doc)))
    ;;
  end

  let to_string t = Display.to_string t
end

module Key_type = struct
  type t =
    | Subcommand
    | Flag

  let to_string = function
    | Subcommand -> "subcommand"
    | Flag -> "flag"
  ;;
end

let lookup_expand alist prefix key_type =
  let is_dash = Char.equal '-' in
  let alist =
    if String.for_all prefix ~f:is_dash
    then List.map alist ~f:(fun (key, (data, _)) -> key, (data, `Full_match_required))
    else alist
  in
  match
    List.filter alist ~f:(function
      | key, (_, `Full_match_required) -> String.( = ) key prefix
      | key, (_, `Prefix) -> String.is_prefix key ~prefix)
  with
  | (key, (data, _name_matching)) :: [] -> Ok (key, data)
  | [] ->
    Error
      (sprintf
         ((Format
             ( String_literal
                 ( "unknown "
                 , Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__508_ ->
                         Key_type.to_string _custom_printf__508_)
                     , Char_literal (' ', String (No_padding, End_of_format)) ) )
             , "unknown %{Key_type} %s" )
          : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
          [@merlin.hide])
         key_type
         prefix)
  | matches ->
    (match List.find matches ~f:(fun (key, _) -> String.( = ) key prefix) with
     | Some (key, (data, _name_matching)) -> Ok (key, data)
     | None ->
       let matching_keys = List.map ~f:fst matches in
       Error
         (sprintf
            ((Format
                ( Custom
                    ( Custom_succ Custom_zero
                    , (fun () _custom_printf__509_ ->
                        Key_type.to_string _custom_printf__509_)
                    , Char_literal
                        ( ' '
                        , String
                            ( No_padding
                            , String_literal
                                ( " is an ambiguous prefix: "
                                , String (No_padding, End_of_format) ) ) ) )
                , "%{Key_type} %s is an ambiguous prefix: %s" )
             : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
             [@merlin.hide])
            key_type
            prefix
            (String.concat ~sep:", " matching_keys)))
;;

module Base_info = struct
  type t = Stable.Base_info.Model.t =
    { summary : string
    ; readme : string option [@sexp.option]
    ; anons : Anons.t
    ; flags : Flag_info.t list
    }
  [@@deriving compare, fields ~getters, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__510_ b__511_ ->
         if Stdlib.( == ) a__510_ b__511_
         then 0
         else (
           match compare_string a__510_.summary b__511_.summary with
           | 0 ->
             (match
                compare_option
                  (fun a__512_ (b__513_ [@merlin.hide]) ->
                     (compare_string a__512_ b__513_ [@merlin.hide]))
                  a__510_.readme
                  b__511_.readme
              with
              | 0 ->
                (match Anons.compare a__510_.anons b__511_.anons with
                 | 0 ->
                   compare_list
                     (fun a__514_ (b__515_ [@merlin.hide]) ->
                        (Flag_info.compare a__514_ b__515_ [@merlin.hide]))
                     a__510_.flags
                     b__511_.flags
                 | n -> n)
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let flags _r__ = _r__.flags
    let _ = flags
    let anons _r__ = _r__.anons
    let _ = anons
    let readme _r__ = _r__.readme
    let _ = readme
    let summary _r__ = _r__.summary
    let _ = summary

    let t_of_sexp =
      (let error_source__517_ = "shape.ml.before-ppx.Base_info.t" in
       fun x__518_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__517_
           ~fields:
             (Field
                { name = "summary"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "readme"
                      ; kind = Sexp_option
                      ; conv = string_of_sexp
                      ; rest =
                          Field
                            { name = "anons"
                            ; kind = Required
                            ; conv = Anons.t_of_sexp
                            ; rest =
                                Field
                                  { name = "flags"
                                  ; kind = Required
                                  ; conv = list_of_sexp Flag_info.t_of_sexp
                                  ; rest = Empty
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "summary" -> 0
             | "readme" -> 1
             | "anons" -> 2
             | "flags" -> 3
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (summary, (readme, (anons, (flags, ())))) ->
             ({ summary; readme; anons; flags } : t))
           x__518_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { summary = summary__520_
           ; readme = readme__522_
           ; anons = anons__526_
           ; flags = flags__528_
           } ->
         let bnds__519_ = ([] : _ Stdlib.List.t) in
         let bnds__519_ =
           let arg__529_ = sexp_of_list Flag_info.sexp_of_t flags__528_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "flags"; arg__529_ ] :: bnds__519_
            : _ Stdlib.List.t)
         in
         let bnds__519_ =
           let arg__527_ = Anons.sexp_of_t anons__526_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "anons"; arg__527_ ] :: bnds__519_
            : _ Stdlib.List.t)
         in
         let bnds__519_ =
           match readme__522_ with
           | Stdlib.Option.None -> bnds__519_
           | Stdlib.Option.Some v__523_ ->
             let arg__525_ = sexp_of_string v__523_ in
             let bnd__524_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__525_ ]
             in
             (bnd__524_ :: bnds__519_ : _ Stdlib.List.t)
         in
         let bnds__519_ =
           let arg__521_ = sexp_of_string summary__520_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__521_ ] :: bnds__519_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__519_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let find_flag t prefix =
    match String.is_prefix prefix ~prefix:"-" with
    | false ->
      Error
        (Error.create_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Flags must begin with '-'"
                ; Ppx_sexp_conv_lib.Conv.sexp_of_string prefix
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
    | true ->
      Or_error.Let_syntax.Let_syntax.bind
        (Or_error.combine_errors
           (List.map t.flags ~f:(fun (flag_info : Flag_info.t) ->
              Or_error.Let_syntax.Let_syntax.bind
                (Flag_info.flag_name flag_info)
                ~f:(fun flag_name ->
                  Ok
                    (List.map (flag_name :: flag_info.aliases) ~f:(fun key ->
                       key, (flag_info, `Prefix)))))))
        ~f:(fun choices ->
          Or_error.map
            ~f:snd
            (Result.map_error
               ~f:Error.of_string
               (lookup_expand (List.concat choices) prefix Flag)))
  ;;

  let get_usage t =
    match t.anons with
    | Usage usage -> usage
    | Grammar grammar -> Anons.Grammar.usage grammar
  ;;
end

module Group_info = struct
  type 'a t = 'a Stable.Group_info.Model.t =
    { summary : string
    ; readme : string option [@sexp.option]
    ; subcommands : (string * 'a) List.t Lazy.t
    }
  [@@deriving compare, fields ~getters, sexp]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__532_ b__533_ ->
      if Stdlib.( == ) a__532_ b__533_
      then 0
      else (
        match compare_string a__532_.summary b__533_.summary with
        | 0 ->
          (match
             compare_option
               (fun a__534_ (b__535_ [@merlin.hide]) ->
                  (compare_string a__534_ b__535_ [@merlin.hide]))
               a__532_.readme
               b__533_.readme
           with
           | 0 ->
             Lazy.compare
               (fun a__536_ (b__537_ [@merlin.hide]) ->
                  (List.compare
                     (fun a__538_ (b__539_ [@merlin.hide]) ->
                        ((let t__540_, t__541_ = a__538_ in
                          let t__542_, t__543_ = b__539_ in
                          match compare_string t__540_ t__542_ with
                          | 0 -> _cmp__a t__541_ t__543_
                          | n -> n)
                        [@merlin.hide]))
                     a__536_
                     b__537_ [@merlin.hide]))
               a__532_.subcommands
               b__533_.subcommands
           | n -> n)
        | n -> n)
    ;;

    let _ = compare
    let subcommands _r__ = _r__.subcommands
    let _ = subcommands
    let readme _r__ = _r__.readme
    let _ = readme
    let summary _r__ = _r__.summary
    let _ = summary

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      let error_source__546_ = "shape.ml.before-ppx.Group_info.t" in
      fun _of_a__544_ x__552_ ->
        Sexplib0.Sexp_conv_record.record_of_sexp
          ~caller:error_source__546_
          ~fields:
            (Field
               { name = "summary"
               ; kind = Required
               ; conv = string_of_sexp
               ; rest =
                   Field
                     { name = "readme"
                     ; kind = Sexp_option
                     ; conv = string_of_sexp
                     ; rest =
                         Field
                           { name = "subcommands"
                           ; kind = Required
                           ; conv =
                               Lazy.t_of_sexp
                                 (List.t_of_sexp (function
                                    | Sexplib0.Sexp.List [ arg0__547_; arg1__548_ ] ->
                                      let res0__549_ = string_of_sexp arg0__547_
                                      and res1__550_ = _of_a__544_ arg1__548_ in
                                      res0__549_, res1__550_
                                    | sexp__551_ ->
                                      Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                                        error_source__546_
                                        2
                                        sexp__551_))
                           ; rest = Empty
                           }
                     }
               })
          ~index_of_field:(function
            | "summary" -> 0
            | "readme" -> 1
            | "subcommands" -> 2
            | _ -> -1)
          ~allow_extra_fields:false
          ~create:(fun (summary, (readme, (subcommands, ()))) ->
            ({ summary; readme; subcommands } : _ t))
          x__552_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__553_
        { summary = summary__555_
        ; readme = readme__557_
        ; subcommands = subcommands__561_
        } ->
      let bnds__554_ = ([] : _ Stdlib.List.t) in
      let bnds__554_ =
        let arg__562_ =
          Lazy.sexp_of_t
            (List.sexp_of_t (fun (arg0__563_, arg1__564_) ->
               let res0__565_ = sexp_of_string arg0__563_
               and res1__566_ = _of_a__553_ arg1__564_ in
               Sexplib0.Sexp.List [ res0__565_; res1__566_ ]))
            subcommands__561_
        in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "subcommands"; arg__562_ ] :: bnds__554_
         : _ Stdlib.List.t)
      in
      let bnds__554_ =
        match readme__557_ with
        | Stdlib.Option.None -> bnds__554_
        | Stdlib.Option.Some v__558_ ->
          let arg__560_ = sexp_of_string v__558_ in
          let bnd__559_ = Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__560_ ] in
          (bnd__559_ :: bnds__554_ : _ Stdlib.List.t)
      in
      let bnds__554_ =
        let arg__556_ = sexp_of_string summary__555_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__556_ ] :: bnds__554_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__554_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let find_subcommand t prefix =
    match String.is_prefix prefix ~prefix:"-" with
    | true ->
      Error
        (Error.create_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Subcommands must not begin with '-'"
                ; Ppx_sexp_conv_lib.Conv.sexp_of_string prefix
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
    | false ->
      let choices =
        List.map (force t.subcommands) ~f:(fun (key, a) -> key, (a, `Prefix))
      in
      Or_error.map
        ~f:snd
        (Result.map_error ~f:Error.of_string (lookup_expand choices prefix Subcommand))
  ;;

  let map = Stable.Group_info.Model.map
end

module Exec_info = struct
  type t = Stable.Exec_info.Model.t =
    { summary : string
    ; readme : string option [@sexp.option]
    ; working_dir : string
    ; path_to_exe : string
    ; child_subcommand : string list
    }
  [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__567_ b__568_ ->
         if Stdlib.( == ) a__567_ b__568_
         then 0
         else (
           match compare_string a__567_.summary b__568_.summary with
           | 0 ->
             (match
                compare_option
                  (fun a__569_ (b__570_ [@merlin.hide]) ->
                     (compare_string a__569_ b__570_ [@merlin.hide]))
                  a__567_.readme
                  b__568_.readme
              with
              | 0 ->
                (match compare_string a__567_.working_dir b__568_.working_dir with
                 | 0 ->
                   (match compare_string a__567_.path_to_exe b__568_.path_to_exe with
                    | 0 ->
                      compare_list
                        (fun a__571_ (b__572_ [@merlin.hide]) ->
                           (compare_string a__571_ b__572_ [@merlin.hide]))
                        a__567_.child_subcommand
                        b__568_.child_subcommand
                    | n -> n)
                 | n -> n)
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (let error_source__574_ = "shape.ml.before-ppx.Exec_info.t" in
       fun x__575_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__574_
           ~fields:
             (Field
                { name = "summary"
                ; kind = Required
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "readme"
                      ; kind = Sexp_option
                      ; conv = string_of_sexp
                      ; rest =
                          Field
                            { name = "working_dir"
                            ; kind = Required
                            ; conv = string_of_sexp
                            ; rest =
                                Field
                                  { name = "path_to_exe"
                                  ; kind = Required
                                  ; conv = string_of_sexp
                                  ; rest =
                                      Field
                                        { name = "child_subcommand"
                                        ; kind = Required
                                        ; conv = list_of_sexp string_of_sexp
                                        ; rest = Empty
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "summary" -> 0
             | "readme" -> 1
             | "working_dir" -> 2
             | "path_to_exe" -> 3
             | "child_subcommand" -> 4
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               (summary, (readme, (working_dir, (path_to_exe, (child_subcommand, ()))))) ->
             ({ summary; readme; working_dir; path_to_exe; child_subcommand } : t))
           x__575_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { summary = summary__577_
           ; readme = readme__579_
           ; working_dir = working_dir__583_
           ; path_to_exe = path_to_exe__585_
           ; child_subcommand = child_subcommand__587_
           } ->
         let bnds__576_ = ([] : _ Stdlib.List.t) in
         let bnds__576_ =
           let arg__588_ = sexp_of_list sexp_of_string child_subcommand__587_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "child_subcommand"; arg__588_ ]
            :: bnds__576_
            : _ Stdlib.List.t)
         in
         let bnds__576_ =
           let arg__586_ = sexp_of_string path_to_exe__585_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "path_to_exe"; arg__586_ ]
            :: bnds__576_
            : _ Stdlib.List.t)
         in
         let bnds__576_ =
           let arg__584_ = sexp_of_string working_dir__583_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "working_dir"; arg__584_ ]
            :: bnds__576_
            : _ Stdlib.List.t)
         in
         let bnds__576_ =
           match readme__579_ with
           | Stdlib.Option.None -> bnds__576_
           | Stdlib.Option.Some v__580_ ->
             let arg__582_ = sexp_of_string v__580_ in
             let bnd__581_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "readme"; arg__582_ ]
             in
             (bnd__581_ :: bnds__576_ : _ Stdlib.List.t)
         in
         let bnds__576_ =
           let arg__578_ = sexp_of_string summary__577_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "summary"; arg__578_ ] :: bnds__576_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__576_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Fully_forced = struct
  type t = Stable.Fully_forced.Model.t =
    | Basic of Base_info.t
    | Group of t Group_info.t
    | Exec of Exec_info.t * t
  [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let rec compare =
      (fun a__589_ b__590_ ->
         if Stdlib.( == ) a__589_ b__590_
         then 0
         else (
           match a__589_, b__590_ with
           | Basic _a__591_, Basic _b__592_ -> Base_info.compare _a__591_ _b__592_
           | Basic _, _ -> -1
           | _, Basic _ -> 1
           | Group _a__593_, Group _b__594_ ->
             Group_info.compare
               (fun a__595_ (b__596_ [@merlin.hide]) ->
                  (compare a__595_ b__596_ [@merlin.hide]))
               _a__593_
               _b__594_
           | Group _, _ -> -1
           | _, Group _ -> 1
           | Exec (_a__597_, _a__599_), Exec (_b__598_, _b__600_) ->
             (match Exec_info.compare _a__597_ _b__598_ with
              | 0 -> compare _a__599_ _b__600_
              | n -> n))
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let rec t_of_sexp =
      (let error_source__603_ = "shape.ml.before-ppx.Fully_forced.t" in
       function
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("basic" | "Basic") as _tag__606_) :: sexp_args__607_) as
         _sexp__605_ ->
         (match sexp_args__607_ with
          | arg0__608_ :: [] ->
            let res0__609_ = Base_info.t_of_sexp arg0__608_ in
            Basic res0__609_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__603_
              _tag__606_
              _sexp__605_)
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("group" | "Group") as _tag__611_) :: sexp_args__612_) as
         _sexp__610_ ->
         (match sexp_args__612_ with
          | arg0__613_ :: [] ->
            let res0__614_ = Group_info.t_of_sexp t_of_sexp arg0__613_ in
            Group res0__614_
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__603_
              _tag__611_
              _sexp__610_)
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom (("exec" | "Exec") as _tag__616_) :: sexp_args__617_) as
         _sexp__615_ ->
         (match sexp_args__617_ with
          | [ arg0__618_; arg1__619_ ] ->
            let res0__620_ = Exec_info.t_of_sexp arg0__618_
            and res1__621_ = t_of_sexp arg1__619_ in
            Exec (res0__620_, res1__621_)
          | _ ->
            Sexplib0.Sexp_conv_error.stag_incorrect_n_args
              error_source__603_
              _tag__616_
              _sexp__615_)
       | Sexplib0.Sexp.Atom ("basic" | "Basic") as sexp__604_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__603_ sexp__604_
       | Sexplib0.Sexp.Atom ("group" | "Group") as sexp__604_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__603_ sexp__604_
       | Sexplib0.Sexp.Atom ("exec" | "Exec") as sexp__604_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__603_ sexp__604_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__602_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__603_ sexp__602_
       | Sexplib0.Sexp.List [] as sexp__602_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__603_ sexp__602_
       | sexp__602_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__603_ sexp__602_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let rec sexp_of_t =
      (function
       | Basic arg0__622_ ->
         let res0__623_ = Base_info.sexp_of_t arg0__622_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Basic"; res0__623_ ]
       | Group arg0__624_ ->
         let res0__625_ = Group_info.sexp_of_t sexp_of_t arg0__624_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__625_ ]
       | Exec (arg0__626_, arg1__627_) ->
         let res0__628_ = Exec_info.sexp_of_t arg0__626_
         and res1__629_ = sexp_of_t arg1__627_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__628_; res1__629_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let expanded_subcommands t =
    let rec expand = function
      | Exec (_, t) -> expand t
      | Basic _ -> [ [] ]
      | Group { subcommands; _ } ->
        List.concat_map (Lazy.force subcommands) ~f:(fun (name, t) ->
          List.map ~f:(fun path -> name :: path) (expand t))
    in
    List.rev (expand t)
  ;;
end

module Sexpable = struct
  type t = Stable.Sexpable.Model.t =
    | Base of Base_info.t
    | Group of t Group_info.t
    | Exec of Exec_info.t
    | Lazy of t Lazy.t
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let rec sexp_of_t =
      (function
       | Base arg0__630_ ->
         let res0__631_ = Base_info.sexp_of_t arg0__630_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__631_ ]
       | Group arg0__632_ ->
         let res0__633_ = Group_info.sexp_of_t sexp_of_t arg0__632_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Group"; res0__633_ ]
       | Exec arg0__634_ ->
         let res0__635_ = Exec_info.sexp_of_t arg0__634_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exec"; res0__635_ ]
       | Lazy arg0__636_ ->
         let res0__637_ = Lazy.sexp_of_t sexp_of_t arg0__636_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Lazy"; res0__637_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let extraction_var = Env_var.to_string COMMAND_OUTPUT_HELP_SEXP

  module Versioned = Stable.Sexpable.Versioned

  let supported_versions =
    let f i supported _ = Set.add supported i in
    Versioned.Variants.fold ~init:(Set.empty (module Int)) ~v1:(f 1) ~v2:(f 2) ~v3:(f 3)
  ;;

  let of_versioned = Versioned.to_latest
  let to_versioned t ~version_to_use = Versioned.of_latest t ~version_to_use
end

type t =
  | Basic of Base_info.t
  | Group of t Group_info.t
  | Exec of Exec_info.t * (unit -> t)
  | Lazy of t Lazy.t

let rec fully_forced : t -> Fully_forced.t = function
  | Basic b -> Basic b
  | Group g -> Group (Group_info.map g ~f:fully_forced)
  | Exec (e, f) -> Exec (e, fully_forced (f ()))
  | Lazy thunk -> fully_forced (Lazy.force thunk)
;;

let rec get_summary = function
  | Basic b -> b.summary
  | Group g -> g.summary
  | Exec (e, _) -> e.summary
  | Lazy thunk -> get_summary (Lazy.force thunk)
;;

let help_text = `Use_Command_unix

module Private = struct
  module Key_type = Key_type

  let abs_path = Stable.Exec_info.abs_path
  let help_screen_compare = Flag_info.help_screen_compare
  let word_wrap = Flag_help_display.word_wrap_and_strip
  let lookup_expand = lookup_expand
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
