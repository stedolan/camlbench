let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"configuration.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "configuration.ml.before-ppx"
;;

open! Core
open! Import
include Patdiff_kernel.Configuration

module On_disk = struct
  module Affix = struct
    type t =
      { text : string option [@sexp.option]
      ; style : Format.Style.t list option [@sexp.option]
      }
    [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__008_ ~random:_random__009_ ->
             { text =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__008_
                   ~random:_random__009_
             ; style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option
                      (quickcheck_generator_list Format.Style.quickcheck_generator))
                   ~size:_size__008_
                   ~random:_random__009_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__003_ ~size:_size__006_ ~hash:_hash__007_ ->
             let { text = _x__004_; style = _x__005_ } = _x__003_ in
             let _hash__007_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__004_
                 ~size:_size__006_
                 ~hash:_hash__007_
             in
             let _hash__007_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option
                    (quickcheck_observer_list Format.Style.quickcheck_observer))
                 _x__005_
                 ~size:_size__006_
                 ~hash:_hash__007_
             in
             _hash__007_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun { text = _x__001_; style = _x__002_ } ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__001_)
                   ~f:(fun _x__001_ -> { text = _x__001_; style = _x__002_ })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option
                         (quickcheck_shrinker_list Format.Style.quickcheck_shrinker))
                      _x__002_)
                   ~f:(fun _x__002_ -> { text = _x__001_; style = _x__002_ })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__011_ = "configuration.ml.before-ppx.On_disk.Affix.t" in
         fun x__012_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__011_
             ~fields:
               (Field
                  { name = "text"
                  ; kind = Sexp_option
                  ; conv = string_of_sexp
                  ; rest =
                      Field
                        { name = "style"
                        ; kind = Sexp_option
                        ; conv = list_of_sexp Format.Style.t_of_sexp
                        ; rest = Empty
                        }
                  })
             ~index_of_field:(function
               | "text" -> 0
               | "style" -> 1
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (text, (style, ())) -> ({ text; style } : t))
             x__012_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { text = text__014_; style = style__018_ } ->
           let bnds__013_ = ([] : _ Stdlib.List.t) in
           let bnds__013_ =
             match style__018_ with
             | Stdlib.Option.None -> bnds__013_
             | Stdlib.Option.Some v__019_ ->
               let arg__021_ = sexp_of_list Format.Style.sexp_of_t v__019_ in
               let bnd__020_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style"; arg__021_ ]
               in
               (bnd__020_ :: bnds__013_ : _ Stdlib.List.t)
           in
           let bnds__013_ =
             match text__014_ with
             | Stdlib.Option.None -> bnds__013_
             | Stdlib.Option.Some v__015_ ->
               let arg__017_ = sexp_of_string v__015_ in
               let bnd__016_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "text"; arg__017_ ]
               in
               (bnd__016_ :: bnds__013_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__013_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let blank = { text = None; style = None }
    let get_text t = Option.value t.text ~default:""

    let length t_opt =
      let f t = String.length (get_text t) in
      Option.value_map t_opt ~default:0 ~f
    ;;

    let to_internal t ~min_width =
      let text = sprintf "%*s" min_width (get_text t) in
      let styles = Option.value ~default:[] t.style in
      Format.Rule.Affix.create ~styles text
    ;;
  end

  module Rule = struct
    type t =
      { prefix : Affix.t option [@sexp.option]
      ; suffix : Affix.t option [@sexp.option]
      ; style : Format.Style.t list option [@sexp.option]
      }
    [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__031_ ~random:_random__032_ ->
             { prefix =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Affix.quickcheck_generator)
                   ~size:_size__031_
                   ~random:_random__032_
             ; suffix =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Affix.quickcheck_generator)
                   ~size:_size__031_
                   ~random:_random__032_
             ; style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option
                      (quickcheck_generator_list Format.Style.quickcheck_generator))
                   ~size:_size__031_
                   ~random:_random__032_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__025_ ~size:_size__029_ ~hash:_hash__030_ ->
             let { prefix = _x__026_; suffix = _x__027_; style = _x__028_ } = _x__025_ in
             let _hash__030_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Affix.quickcheck_observer)
                 _x__026_
                 ~size:_size__029_
                 ~hash:_hash__030_
             in
             let _hash__030_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Affix.quickcheck_observer)
                 _x__027_
                 ~size:_size__029_
                 ~hash:_hash__030_
             in
             let _hash__030_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option
                    (quickcheck_observer_list Format.Style.quickcheck_observer))
                 _x__028_
                 ~size:_size__029_
                 ~hash:_hash__030_
             in
             _hash__030_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun { prefix = _x__022_; suffix = _x__023_; style = _x__024_ } ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Affix.quickcheck_shrinker)
                      _x__022_)
                   ~f:(fun _x__022_ ->
                     { prefix = _x__022_; suffix = _x__023_; style = _x__024_ })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Affix.quickcheck_shrinker)
                      _x__023_)
                   ~f:(fun _x__023_ ->
                     { prefix = _x__022_; suffix = _x__023_; style = _x__024_ })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option
                         (quickcheck_shrinker_list Format.Style.quickcheck_shrinker))
                      _x__024_)
                   ~f:(fun _x__024_ ->
                     { prefix = _x__022_; suffix = _x__023_; style = _x__024_ })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__034_ = "configuration.ml.before-ppx.On_disk.Rule.t" in
         fun x__035_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__034_
             ~fields:
               (Field
                  { name = "prefix"
                  ; kind = Sexp_option
                  ; conv = Affix.t_of_sexp
                  ; rest =
                      Field
                        { name = "suffix"
                        ; kind = Sexp_option
                        ; conv = Affix.t_of_sexp
                        ; rest =
                            Field
                              { name = "style"
                              ; kind = Sexp_option
                              ; conv = list_of_sexp Format.Style.t_of_sexp
                              ; rest = Empty
                              }
                        }
                  })
             ~index_of_field:(function
               | "prefix" -> 0
               | "suffix" -> 1
               | "style" -> 2
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (prefix, (suffix, (style, ()))) ->
               ({ prefix; suffix; style } : t))
             x__035_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { prefix = prefix__037_; suffix = suffix__041_; style = style__045_ } ->
           let bnds__036_ = ([] : _ Stdlib.List.t) in
           let bnds__036_ =
             match style__045_ with
             | Stdlib.Option.None -> bnds__036_
             | Stdlib.Option.Some v__046_ ->
               let arg__048_ = sexp_of_list Format.Style.sexp_of_t v__046_ in
               let bnd__047_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style"; arg__048_ ]
               in
               (bnd__047_ :: bnds__036_ : _ Stdlib.List.t)
           in
           let bnds__036_ =
             match suffix__041_ with
             | Stdlib.Option.None -> bnds__036_
             | Stdlib.Option.Some v__042_ ->
               let arg__044_ = Affix.sexp_of_t v__042_ in
               let bnd__043_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix"; arg__044_ ]
               in
               (bnd__043_ :: bnds__036_ : _ Stdlib.List.t)
           in
           let bnds__036_ =
             match prefix__037_ with
             | Stdlib.Option.None -> bnds__036_
             | Stdlib.Option.Some v__038_ ->
               let arg__040_ = Affix.sexp_of_t v__038_ in
               let bnd__039_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix"; arg__040_ ]
               in
               (bnd__039_ :: bnds__036_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__036_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let blank = { prefix = None; suffix = None; style = None }

    let to_internal t =
      let f = Affix.to_internal ~min_width:0 in
      let default = Format.Rule.Affix.blank in
      let affix opt = Option.value_map ~default ~f opt in
      let pre = affix t.prefix in
      let suf = affix t.suffix in
      let style = Option.value ~default:[] t.style in
      Format.Rule.create ~pre ~suf style
    ;;
  end

  module Hunk = struct
    type t = Rule.t [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()
      let quickcheck_generator = Rule.quickcheck_generator
      let _ = quickcheck_generator
      let quickcheck_observer = Rule.quickcheck_observer
      let _ = quickcheck_observer
      let quickcheck_shrinker = Rule.quickcheck_shrinker
      let _ = quickcheck_shrinker
      let t_of_sexp = (Rule.t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (Rule.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_internal t =
      let get_affix a = Option.value a ~default:Affix.blank in
      let prefix = get_affix t.Rule.prefix in
      let suffix = get_affix t.Rule.suffix in
      let prefix_text = Option.value prefix.Affix.text ~default:"@@ " in
      let suffix_text = Option.value suffix.Affix.text ~default:" @@" in
      let t =
        { t with
          Rule.prefix = Some { prefix with Affix.text = Some prefix_text }
        ; Rule.suffix = Some { suffix with Affix.text = Some suffix_text }
        }
      in
      Rule.to_internal t
    ;;
  end

  module Header = struct
    type t = Rule.t [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()
      let quickcheck_generator = Rule.quickcheck_generator
      let _ = quickcheck_generator
      let quickcheck_observer = Rule.quickcheck_observer
      let _ = quickcheck_observer
      let quickcheck_shrinker = Rule.quickcheck_shrinker
      let _ = quickcheck_shrinker
      let t_of_sexp = (Rule.t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (Rule.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_internal t ~default =
      let get_affix a = Option.value a ~default:Affix.blank in
      let prefix = get_affix t.Rule.prefix in
      let prefix_text = Option.value prefix.Affix.text ~default in
      let t =
        { t with Rule.prefix = Some { prefix with Affix.text = Some prefix_text } }
      in
      Rule.to_internal t
    ;;
  end

  module Line_rule = struct
    type t =
      { prefix : Affix.t option [@sexp.option]
      ; suffix : Affix.t option [@sexp.option]
      ; style : Format.Style.t list option [@sexp.option]
      ; word_same : Format.Style.t list option [@sexp.option]
      }
    [@@deriving sexp, quickcheck]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__052_ = "configuration.ml.before-ppx.On_disk.Line_rule.t" in
         fun x__053_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__052_
             ~fields:
               (Field
                  { name = "prefix"
                  ; kind = Sexp_option
                  ; conv = Affix.t_of_sexp
                  ; rest =
                      Field
                        { name = "suffix"
                        ; kind = Sexp_option
                        ; conv = Affix.t_of_sexp
                        ; rest =
                            Field
                              { name = "style"
                              ; kind = Sexp_option
                              ; conv = list_of_sexp Format.Style.t_of_sexp
                              ; rest =
                                  Field
                                    { name = "word_same"
                                    ; kind = Sexp_option
                                    ; conv = list_of_sexp Format.Style.t_of_sexp
                                    ; rest = Empty
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "prefix" -> 0
               | "suffix" -> 1
               | "style" -> 2
               | "word_same" -> 3
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (prefix, (suffix, (style, (word_same, ())))) ->
               ({ prefix; suffix; style; word_same } : t))
             x__053_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { prefix = prefix__055_
             ; suffix = suffix__059_
             ; style = style__063_
             ; word_same = word_same__067_
             } ->
           let bnds__054_ = ([] : _ Stdlib.List.t) in
           let bnds__054_ =
             match word_same__067_ with
             | Stdlib.Option.None -> bnds__054_
             | Stdlib.Option.Some v__068_ ->
               let arg__070_ = sexp_of_list Format.Style.sexp_of_t v__068_ in
               let bnd__069_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_same"; arg__070_ ]
               in
               (bnd__069_ :: bnds__054_ : _ Stdlib.List.t)
           in
           let bnds__054_ =
             match style__063_ with
             | Stdlib.Option.None -> bnds__054_
             | Stdlib.Option.Some v__064_ ->
               let arg__066_ = sexp_of_list Format.Style.sexp_of_t v__064_ in
               let bnd__065_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style"; arg__066_ ]
               in
               (bnd__065_ :: bnds__054_ : _ Stdlib.List.t)
           in
           let bnds__054_ =
             match suffix__059_ with
             | Stdlib.Option.None -> bnds__054_
             | Stdlib.Option.Some v__060_ ->
               let arg__062_ = Affix.sexp_of_t v__060_ in
               let bnd__061_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix"; arg__062_ ]
               in
               (bnd__061_ :: bnds__054_ : _ Stdlib.List.t)
           in
           let bnds__054_ =
             match prefix__055_ with
             | Stdlib.Option.None -> bnds__054_
             | Stdlib.Option.Some v__056_ ->
               let arg__058_ = Affix.sexp_of_t v__056_ in
               let bnd__057_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix"; arg__058_ ]
               in
               (bnd__057_ :: bnds__054_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__054_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__082_ ~random:_random__083_ ->
             { prefix =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Affix.quickcheck_generator)
                   ~size:_size__082_
                   ~random:_random__083_
             ; suffix =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Affix.quickcheck_generator)
                   ~size:_size__082_
                   ~random:_random__083_
             ; style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option
                      (quickcheck_generator_list Format.Style.quickcheck_generator))
                   ~size:_size__082_
                   ~random:_random__083_
             ; word_same =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option
                      (quickcheck_generator_list Format.Style.quickcheck_generator))
                   ~size:_size__082_
                   ~random:_random__083_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__075_ ~size:_size__080_ ~hash:_hash__081_ ->
             let { prefix = _x__076_
                 ; suffix = _x__077_
                 ; style = _x__078_
                 ; word_same = _x__079_
                 }
               =
               _x__075_
             in
             let _hash__081_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Affix.quickcheck_observer)
                 _x__076_
                 ~size:_size__080_
                 ~hash:_hash__081_
             in
             let _hash__081_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Affix.quickcheck_observer)
                 _x__077_
                 ~size:_size__080_
                 ~hash:_hash__081_
             in
             let _hash__081_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option
                    (quickcheck_observer_list Format.Style.quickcheck_observer))
                 _x__078_
                 ~size:_size__080_
                 ~hash:_hash__081_
             in
             let _hash__081_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option
                    (quickcheck_observer_list Format.Style.quickcheck_observer))
                 _x__079_
                 ~size:_size__080_
                 ~hash:_hash__081_
             in
             _hash__081_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun
              { prefix = _x__071_
              ; suffix = _x__072_
              ; style = _x__073_
              ; word_same = _x__074_
              }
             ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Affix.quickcheck_shrinker)
                      _x__071_)
                   ~f:(fun _x__071_ ->
                     { prefix = _x__071_
                     ; suffix = _x__072_
                     ; style = _x__073_
                     ; word_same = _x__074_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Affix.quickcheck_shrinker)
                      _x__072_)
                   ~f:(fun _x__072_ ->
                     { prefix = _x__071_
                     ; suffix = _x__072_
                     ; style = _x__073_
                     ; word_same = _x__074_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option
                         (quickcheck_shrinker_list Format.Style.quickcheck_shrinker))
                      _x__073_)
                   ~f:(fun _x__073_ ->
                     { prefix = _x__071_
                     ; suffix = _x__072_
                     ; style = _x__073_
                     ; word_same = _x__074_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option
                         (quickcheck_shrinker_list Format.Style.quickcheck_shrinker))
                      _x__074_)
                   ~f:(fun _x__074_ ->
                     { prefix = _x__071_
                     ; suffix = _x__072_
                     ; style = _x__073_
                     ; word_same = _x__074_
                     })
               ])
      ;;

      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let default = { prefix = None; suffix = None; style = None; word_same = None }
  end

  module V3 = struct
    type t =
      { dont_produce_unified_lines : bool option [@sexp.option]
      ; dont_overwrite_word_old_word_new : bool option [@sexp.option]
      ; config_path : string option [@sexp.option]
      ; context : int option [@sexp.option]
      ; line_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; word_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; keep_whitespace : bool option [@sexp.option]
      ; find_moves : bool option [@sexp.option]
      ; split_long_lines : bool option [@sexp.option]
      ; interleave : bool option [@sexp.option]
      ; assume_text : bool option [@sexp.option]
      ; quiet : bool option [@sexp.option]
      ; shallow : bool option [@sexp.option]
      ; double_check : bool option [@sexp.option]
      ; mask_uniques : bool option [@sexp.option]
      ; output : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ]
            [@default `ansi] [@sexp_drop_default.equal]
      ; alt_old : string option [@sexp.option]
      ; alt_new : string option [@sexp.option]
      ; header_old : Header.t option [@sexp.option]
      ; header_new : Header.t option [@sexp.option]
      ; hunk : Hunk.t option [@sexp.option]
      ; line_same : Line_rule.t option [@sexp.option]
      ; line_old : Line_rule.t option [@sexp.option]
      ; line_new : Line_rule.t option [@sexp.option]
      ; line_unified : Line_rule.t option [@sexp.option]
      ; line_from_old : Line_rule.t option [@sexp.option]
      ; line_to_new : Line_rule.t option [@sexp.option]
      ; line_removed_in_move : Line_rule.t option [@sexp.option]
      ; line_added_in_move : Line_rule.t option [@sexp.option]
      ; line_unified_in_move : Line_rule.t option [@sexp.option]
      ; word_old : Rule.t option [@sexp.option]
      ; word_new : Rule.t option [@sexp.option]
      ; location_style : Format.Location_style.t
            [@default Format.Location_style.Diff] [@sexp_drop_default.equal]
      ; warn_if_no_trailing_newline_in_both : bool
            [@default warn_if_no_trailing_newline_in_both_default]
            [@sexp_drop_default.equal]
      }
    [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__175_ ~random:_random__176_ ->
             { dont_produce_unified_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; dont_overwrite_word_old_word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; config_path =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__175_
                   ~random:_random__176_
             ; context =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_int)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__175_
                   ~random:_random__176_
             ; word_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__175_
                   ~random:_random__176_
             ; keep_whitespace =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; find_moves =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; split_long_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; interleave =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; assume_text =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; quiet =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; shallow =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; double_check =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; mask_uniques =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__175_
                   ~random:_random__176_
             ; output =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
                      [ ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__163_ ~random:_random__164_ -> `ascii) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__165_ ~random:_random__166_ -> `html) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__167_ ~random:_random__168_ -> `ansi) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__173_ ~random:_random__174_ ->
                               `unrefined
                                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator
                                  .generate
                                    (Ppx_quickcheck_runtime.Base_quickcheck.Generator
                                     .weighted_union
                                       [ ( 1.
                                         , Ppx_quickcheck_runtime.Base_quickcheck
                                           .Generator
                                           .create
                                             (fun
                                                 ~size:_size__169_
                                                  ~random:_random__170_
                                                -> `ansi) )
                                       ; ( 1.
                                         , Ppx_quickcheck_runtime.Base_quickcheck
                                           .Generator
                                           .create
                                             (fun
                                                 ~size:_size__171_
                                                  ~random:_random__172_
                                                -> `html) )
                                       ])
                                    ~size:_size__173_
                                    ~random:_random__174_)) )
                      ])
                   ~size:_size__175_
                   ~random:_random__176_
             ; alt_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__175_
                   ~random:_random__176_
             ; alt_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__175_
                   ~random:_random__176_
             ; header_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; header_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; hunk =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Hunk.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_same =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_unified =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_from_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_to_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_removed_in_move =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_added_in_move =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; line_unified_in_move =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; word_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__175_
                   ~random:_random__176_
             ; location_style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   Format.Location_style.quickcheck_generator
                   ~size:_size__175_
                   ~random:_random__176_
             ; warn_if_no_trailing_newline_in_both =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_bool
                   ~size:_size__175_
                   ~random:_random__176_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__119_ ~size:_size__161_ ~hash:_hash__162_ ->
             let { dont_produce_unified_lines = _x__120_
                 ; dont_overwrite_word_old_word_new = _x__121_
                 ; config_path = _x__122_
                 ; context = _x__123_
                 ; line_big_enough = _x__124_
                 ; word_big_enough = _x__125_
                 ; keep_whitespace = _x__126_
                 ; find_moves = _x__127_
                 ; split_long_lines = _x__128_
                 ; interleave = _x__129_
                 ; assume_text = _x__130_
                 ; quiet = _x__131_
                 ; shallow = _x__132_
                 ; double_check = _x__133_
                 ; mask_uniques = _x__134_
                 ; output = _x__135_
                 ; alt_old = _x__136_
                 ; alt_new = _x__137_
                 ; header_old = _x__138_
                 ; header_new = _x__139_
                 ; hunk = _x__140_
                 ; line_same = _x__141_
                 ; line_old = _x__142_
                 ; line_new = _x__143_
                 ; line_unified = _x__144_
                 ; line_from_old = _x__145_
                 ; line_to_new = _x__146_
                 ; line_removed_in_move = _x__147_
                 ; line_added_in_move = _x__148_
                 ; line_unified_in_move = _x__149_
                 ; word_old = _x__150_
                 ; word_new = _x__151_
                 ; location_style = _x__152_
                 ; warn_if_no_trailing_newline_in_both = _x__153_
                 }
               =
               _x__119_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__120_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__121_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__122_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__123_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__124_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__125_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__126_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__127_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__128_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__129_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__130_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__131_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__132_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__133_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__134_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
                    (fun _x__154_ ~size:_size__155_ ~hash:_hash__156_ ->
                       match _x__154_ with
                       | `ascii ->
                         let _hash__156_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int _hash__156_ 640502097
                         in
                         _hash__156_
                       | `html ->
                         let _hash__156_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__156_
                             (-988375701)
                         in
                         _hash__156_
                       | `ansi ->
                         let _hash__156_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__156_
                             (-1066299709)
                         in
                         _hash__156_
                       | `unrefined _x__160_ ->
                         let _hash__156_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__156_
                             (-482951906)
                         in
                         let _hash__156_ =
                           Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                             (Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
                                (fun _x__157_ ~size:_size__158_ ~hash:_hash__159_ ->
                                   match _x__157_ with
                                   | `ansi ->
                                     let _hash__159_ =
                                       Ppx_quickcheck_runtime.Base.hash_fold_int
                                         _hash__159_
                                         (-1066299709)
                                     in
                                     _hash__159_
                                   | `html ->
                                     let _hash__159_ =
                                       Ppx_quickcheck_runtime.Base.hash_fold_int
                                         _hash__159_
                                         (-988375701)
                                     in
                                     _hash__159_))
                             _x__160_
                             ~size:_size__155_
                             ~hash:_hash__156_
                         in
                         _hash__156_))
                 _x__135_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__136_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__137_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__138_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__139_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Hunk.quickcheck_observer)
                 _x__140_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__141_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__142_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__143_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__144_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__145_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__146_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__147_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__148_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__149_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__150_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__151_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 Format.Location_style.quickcheck_observer
                 _x__152_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             let _hash__162_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_bool
                 _x__153_
                 ~size:_size__161_
                 ~hash:_hash__162_
             in
             _hash__162_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun
              { dont_produce_unified_lines = _x__084_
              ; dont_overwrite_word_old_word_new = _x__085_
              ; config_path = _x__086_
              ; context = _x__087_
              ; line_big_enough = _x__088_
              ; word_big_enough = _x__089_
              ; keep_whitespace = _x__090_
              ; find_moves = _x__091_
              ; split_long_lines = _x__092_
              ; interleave = _x__093_
              ; assume_text = _x__094_
              ; quiet = _x__095_
              ; shallow = _x__096_
              ; double_check = _x__097_
              ; mask_uniques = _x__098_
              ; output = _x__099_
              ; alt_old = _x__100_
              ; alt_new = _x__101_
              ; header_old = _x__102_
              ; header_new = _x__103_
              ; hunk = _x__104_
              ; line_same = _x__105_
              ; line_old = _x__106_
              ; line_new = _x__107_
              ; line_unified = _x__108_
              ; line_from_old = _x__109_
              ; line_to_new = _x__110_
              ; line_removed_in_move = _x__111_
              ; line_added_in_move = _x__112_
              ; line_unified_in_move = _x__113_
              ; word_old = _x__114_
              ; word_new = _x__115_
              ; location_style = _x__116_
              ; warn_if_no_trailing_newline_in_both = _x__117_
              }
             ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__084_)
                   ~f:(fun _x__084_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__085_)
                   ~f:(fun _x__085_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__086_)
                   ~f:(fun _x__086_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__087_)
                   ~f:(fun _x__087_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__088_)
                   ~f:(fun _x__088_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__089_)
                   ~f:(fun _x__089_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__090_)
                   ~f:(fun _x__090_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__091_)
                   ~f:(fun _x__091_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__092_)
                   ~f:(fun _x__092_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__093_)
                   ~f:(fun _x__093_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__094_)
                   ~f:(fun _x__094_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__095_)
                   ~f:(fun _x__095_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__096_)
                   ~f:(fun _x__096_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__097_)
                   ~f:(fun _x__097_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__098_)
                   ~f:(fun _x__098_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
                         | `ascii -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `html -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `ansi -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `unrefined _x__118_ ->
                           Ppx_quickcheck_runtime.Base.Sequence.round_robin
                             [ Ppx_quickcheck_runtime.Base.Sequence.map
                                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker
                                     .create
                                       (function
                                       | `ansi ->
                                         Ppx_quickcheck_runtime.Base.Sequence.round_robin
                                           []
                                       | `html ->
                                         Ppx_quickcheck_runtime.Base.Sequence.round_robin
                                           []))
                                    _x__118_)
                                 ~f:(fun _x__118_ -> `unrefined _x__118_)
                             ]))
                      _x__099_)
                   ~f:(fun _x__099_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__100_)
                   ~f:(fun _x__100_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__101_)
                   ~f:(fun _x__101_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__102_)
                   ~f:(fun _x__102_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__103_)
                   ~f:(fun _x__103_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Hunk.quickcheck_shrinker)
                      _x__104_)
                   ~f:(fun _x__104_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__105_)
                   ~f:(fun _x__105_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__106_)
                   ~f:(fun _x__106_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__107_)
                   ~f:(fun _x__107_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__108_)
                   ~f:(fun _x__108_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__109_)
                   ~f:(fun _x__109_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__110_)
                   ~f:(fun _x__110_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__111_)
                   ~f:(fun _x__111_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__112_)
                   ~f:(fun _x__112_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__113_)
                   ~f:(fun _x__113_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__114_)
                   ~f:(fun _x__114_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__115_)
                   ~f:(fun _x__115_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      Format.Location_style.quickcheck_shrinker
                      _x__116_)
                   ~f:(fun _x__116_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_bool
                      _x__117_)
                   ~f:(fun _x__117_ ->
                     { dont_produce_unified_lines = _x__084_
                     ; dont_overwrite_word_old_word_new = _x__085_
                     ; config_path = _x__086_
                     ; context = _x__087_
                     ; line_big_enough = _x__088_
                     ; word_big_enough = _x__089_
                     ; keep_whitespace = _x__090_
                     ; find_moves = _x__091_
                     ; split_long_lines = _x__092_
                     ; interleave = _x__093_
                     ; assume_text = _x__094_
                     ; quiet = _x__095_
                     ; shallow = _x__096_
                     ; double_check = _x__097_
                     ; mask_uniques = _x__098_
                     ; output = _x__099_
                     ; alt_old = _x__100_
                     ; alt_new = _x__101_
                     ; header_old = _x__102_
                     ; header_new = _x__103_
                     ; hunk = _x__104_
                     ; line_same = _x__105_
                     ; line_old = _x__106_
                     ; line_new = _x__107_
                     ; line_unified = _x__108_
                     ; line_from_old = _x__109_
                     ; line_to_new = _x__110_
                     ; line_removed_in_move = _x__111_
                     ; line_added_in_move = _x__112_
                     ; line_unified_in_move = _x__113_
                     ; word_old = _x__114_
                     ; word_new = _x__115_
                     ; location_style = _x__116_
                     ; warn_if_no_trailing_newline_in_both = _x__117_
                     })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let default__179_ : bool = warn_if_no_trailing_newline_in_both_default
         and default__180_ : Format.Location_style.t = Format.Location_style.Diff
         and default__181_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ] =
           `ansi
         in
         let error_source__178_ = "configuration.ml.before-ppx.On_disk.V3.t" in
         fun x__197_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__178_
             ~fields:
               (Field
                  { name = "dont_produce_unified_lines"
                  ; kind = Sexp_option
                  ; conv = bool_of_sexp
                  ; rest =
                      Field
                        { name = "dont_overwrite_word_old_word_new"
                        ; kind = Sexp_option
                        ; conv = bool_of_sexp
                        ; rest =
                            Field
                              { name = "config_path"
                              ; kind = Sexp_option
                              ; conv = string_of_sexp
                              ; rest =
                                  Field
                                    { name = "context"
                                    ; kind = Sexp_option
                                    ; conv = int_of_sexp
                                    ; rest =
                                        Field
                                          { name = "line_big_enough"
                                          ; kind = Sexp_option
                                          ; conv = int_of_sexp
                                          ; rest =
                                              Field
                                                { name = "word_big_enough"
                                                ; kind = Sexp_option
                                                ; conv = int_of_sexp
                                                ; rest =
                                                    Field
                                                      { name = "keep_whitespace"
                                                      ; kind = Sexp_option
                                                      ; conv = bool_of_sexp
                                                      ; rest =
                                                          Field
                                                            { name = "find_moves"
                                                            ; kind = Sexp_option
                                                            ; conv = bool_of_sexp
                                                            ; rest =
                                                                Field
                                                                  { name =
                                                                      "split_long_lines"
                                                                  ; kind = Sexp_option
                                                                  ; conv = bool_of_sexp
                                                                  ; rest =
                                                                      Field
                                                                        { name =
                                                                            "interleave"
                                                                        ; kind =
                                                                            Sexp_option
                                                                        ; conv =
                                                                            bool_of_sexp
                                                                        ; rest =
                                                                            Field
                                                                              { name =
                                                                                  "assume_text"
                                                                              ; kind =
                                                                                  Sexp_option
                                                                              ; conv =
                                                                                  bool_of_sexp
                                                                              ; rest =
                                                                                  Field
                                                                                    { name =
                                                                                        "quiet"
                                                                                    ; kind =
                                                                                        Sexp_option
                                                                                    ; conv =
                                                                                        bool_of_sexp
                                                                                    ; rest =
                                                                                        Field
                                                                                          { 
                                                                                          name =
                                                                                          "shallow"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "double_check"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "mask_uniques"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "output"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__181_)
                                                                                          ; 
                                                                                          conv =
                                                                                          (fun 
                                                                                          sexp__196_ ->
                                                                                          try
                                                                                          match
                                                                                          sexp__196_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__183_
                                                                                          as
                                                                                          _sexp__185_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__183_
                                                                                          with
                                                                                          | 
                                                                                          "ascii"
                                                                                          ->
                                                                                          
                                                                                          `ascii
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          `html
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          `ansi
                                                                                          | 
                                                                                          "unrefined"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_takes_args
                                                                                          error_source__178_
                                                                                          _sexp__185_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__183_
                                                                                          :: 
                                                                                          sexp_args__186_
                                                                                          )
                                                                                          as
                                                                                          _sexp__185_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__183_
                                                                                          with
                                                                                          | 
                                                                                          "unrefined"
                                                                                          as
                                                                                          _tag__187_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          sexp_args__186_
                                                                                          with
                                                                                          | 
                                                                                          arg0__194_
                                                                                          :: 
                                                                                          []
                                                                                          ->
                                                                                          
                                                                                          let res0__195_
                                                                                          =
                                                                                          let sexp__193_
                                                                                          =
                                                                                          arg0__194_
                                                                                          in
                                                                                          try
                                                                                          match
                                                                                          sexp__193_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__189_
                                                                                          as
                                                                                          _sexp__191_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__189_
                                                                                          with
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          `ansi
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          `html
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__189_
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          _sexp__191_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__189_
                                                                                          with
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__178_
                                                                                          _sexp__191_
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__178_
                                                                                          _sexp__191_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          _
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          sexp__190_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .nested_list_invalid_poly_var
                                                                                          error_source__178_
                                                                                          sexp__190_
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          []
                                                                                          as
                                                                                          sexp__190_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .empty_list_invalid_poly_var
                                                                                          error_source__178_
                                                                                          sexp__190_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .No_variant_match
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_matching_variant_found
                                                                                          error_source__178_
                                                                                          sexp__193_
                                                                                          in
                                                                                          `unrefined
                                                                                          res0__195_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_incorrect_n_args
                                                                                          error_source__178_
                                                                                          _tag__187_
                                                                                          _sexp__185_)
                                                                                          | 
                                                                                          "ascii"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__178_
                                                                                          _sexp__185_
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__178_
                                                                                          _sexp__185_
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__178_
                                                                                          _sexp__185_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          _
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          sexp__184_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .nested_list_invalid_poly_var
                                                                                          error_source__178_
                                                                                          sexp__184_
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          []
                                                                                          as
                                                                                          sexp__184_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .empty_list_invalid_poly_var
                                                                                          error_source__178_
                                                                                          sexp__184_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .No_variant_match
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_matching_variant_found
                                                                                          error_source__178_
                                                                                          sexp__196_)
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "hunk"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Hunk
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_same"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_unified"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_from_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_to_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_removed_in_move"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_added_in_move"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_unified_in_move"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "location_style"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__180_)
                                                                                          ; 
                                                                                          conv =
                                                                                          Format
                                                                                          .Location_style
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "warn_if_no_trailing_newline_in_both"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__179_)
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "dont_produce_unified_lines" -> 0
               | "dont_overwrite_word_old_word_new" -> 1
               | "config_path" -> 2
               | "context" -> 3
               | "line_big_enough" -> 4
               | "word_big_enough" -> 5
               | "keep_whitespace" -> 6
               | "find_moves" -> 7
               | "split_long_lines" -> 8
               | "interleave" -> 9
               | "assume_text" -> 10
               | "quiet" -> 11
               | "shallow" -> 12
               | "double_check" -> 13
               | "mask_uniques" -> 14
               | "output" -> 15
               | "alt_old" -> 16
               | "alt_new" -> 17
               | "header_old" -> 18
               | "header_new" -> 19
               | "hunk" -> 20
               | "line_same" -> 21
               | "line_old" -> 22
               | "line_new" -> 23
               | "line_unified" -> 24
               | "line_from_old" -> 25
               | "line_to_new" -> 26
               | "line_removed_in_move" -> 27
               | "line_added_in_move" -> 28
               | "line_unified_in_move" -> 29
               | "word_old" -> 30
               | "word_new" -> 31
               | "location_style" -> 32
               | "warn_if_no_trailing_newline_in_both" -> 33
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:
               (fun
                 ( dont_produce_unified_lines
                 , ( dont_overwrite_word_old_word_new
                   , ( config_path
                     , ( context
                       , ( line_big_enough
                         , ( word_big_enough
                           , ( keep_whitespace
                             , ( find_moves
                               , ( split_long_lines
                                 , ( interleave
                                   , ( assume_text
                                     , ( quiet
                                       , ( shallow
                                         , ( double_check
                                           , ( mask_uniques
                                             , ( output
                                               , ( alt_old
                                                 , ( alt_new
                                                   , ( header_old
                                                     , ( header_new
                                                       , ( hunk
                                                         , ( line_same
                                                           , ( line_old
                                                             , ( line_new
                                                               , ( line_unified
                                                                 , ( line_from_old
                                                                   , ( line_to_new
                                                                     , ( line_removed_in_move
                                                                       , ( line_added_in_move
                                                                         , ( line_unified_in_move
                                                                           , ( word_old
                                                                             , ( word_new
                                                                               , ( location_style
                                                                                 , ( warn_if_no_trailing_newline_in_both
                                                                                   , () )
                                                                                 ) ) ) )
                                                                         ) ) ) ) ) ) ) )
                                                         ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
                         ) ) ) ) ) ->
               ({ dont_produce_unified_lines
                ; dont_overwrite_word_old_word_new
                ; config_path
                ; context
                ; line_big_enough
                ; word_big_enough
                ; keep_whitespace
                ; find_moves
                ; split_long_lines
                ; interleave
                ; assume_text
                ; quiet
                ; shallow
                ; double_check
                ; mask_uniques
                ; output
                ; alt_old
                ; alt_new
                ; header_old
                ; header_new
                ; hunk
                ; line_same
                ; line_old
                ; line_new
                ; line_unified
                ; line_from_old
                ; line_to_new
                ; line_removed_in_move
                ; line_added_in_move
                ; line_unified_in_move
                ; word_old
                ; word_new
                ; location_style
                ; warn_if_no_trailing_newline_in_both
                }
                : t))
             x__197_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (let default__260_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ] =
           `ansi
         and default__330_ : Format.Location_style.t = Format.Location_style.Diff
         and default__335_ : bool = warn_if_no_trailing_newline_in_both_default in
         fun { dont_produce_unified_lines = dont_produce_unified_lines__199_
             ; dont_overwrite_word_old_word_new = dont_overwrite_word_old_word_new__203_
             ; config_path = config_path__207_
             ; context = context__211_
             ; line_big_enough = line_big_enough__215_
             ; word_big_enough = word_big_enough__219_
             ; keep_whitespace = keep_whitespace__223_
             ; find_moves = find_moves__227_
             ; split_long_lines = split_long_lines__231_
             ; interleave = interleave__235_
             ; assume_text = assume_text__239_
             ; quiet = quiet__243_
             ; shallow = shallow__247_
             ; double_check = double_check__251_
             ; mask_uniques = mask_uniques__255_
             ; output = output__261_
             ; alt_old = alt_old__265_
             ; alt_new = alt_new__269_
             ; header_old = header_old__273_
             ; header_new = header_new__277_
             ; hunk = hunk__281_
             ; line_same = line_same__285_
             ; line_old = line_old__289_
             ; line_new = line_new__293_
             ; line_unified = line_unified__297_
             ; line_from_old = line_from_old__301_
             ; line_to_new = line_to_new__305_
             ; line_removed_in_move = line_removed_in_move__309_
             ; line_added_in_move = line_added_in_move__313_
             ; line_unified_in_move = line_unified_in_move__317_
             ; word_old = word_old__321_
             ; word_new = word_new__325_
             ; location_style = location_style__331_
             ; warn_if_no_trailing_newline_in_both =
                 warn_if_no_trailing_newline_in_both__336_
             } ->
           let bnds__198_ = ([] : _ Stdlib.List.t) in
           let bnds__198_ =
             if
               (fun (a__339_ : bool) ((b__340_ : bool) [@merlin.hide]) ->
                  (equal_bool a__339_ b__340_ [@merlin.hide]))
                 default__335_
                 warn_if_no_trailing_newline_in_both__336_
             then bnds__198_
             else (
               let arg__338_ = sexp_of_bool warn_if_no_trailing_newline_in_both__336_ in
               let bnd__337_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "warn_if_no_trailing_newline_in_both"; arg__338_ ]
               in
               (bnd__337_ :: bnds__198_ : _ Stdlib.List.t))
           in
           let bnds__198_ =
             if
               (fun (a__341_ : Format.Location_style.t)
                 ((b__342_ : Format.Location_style.t) [@merlin.hide]) ->
                  (Format.Location_style.equal a__341_ b__342_ [@merlin.hide]))
                 default__330_
                 location_style__331_
             then bnds__198_
             else (
               let arg__333_ = Format.Location_style.sexp_of_t location_style__331_ in
               let bnd__332_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "location_style"; arg__333_ ]
               in
               (bnd__332_ :: bnds__198_ : _ Stdlib.List.t))
           in
           let bnds__198_ =
             match word_new__325_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__326_ ->
               let arg__328_ = Rule.sexp_of_t v__326_ in
               let bnd__327_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_new"; arg__328_ ]
               in
               (bnd__327_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match word_old__321_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__322_ ->
               let arg__324_ = Rule.sexp_of_t v__322_ in
               let bnd__323_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_old"; arg__324_ ]
               in
               (bnd__323_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_unified_in_move__317_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__318_ ->
               let arg__320_ = Line_rule.sexp_of_t v__318_ in
               let bnd__319_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "line_unified_in_move"; arg__320_ ]
               in
               (bnd__319_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_added_in_move__313_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__314_ ->
               let arg__316_ = Line_rule.sexp_of_t v__314_ in
               let bnd__315_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_added_in_move"; arg__316_ ]
               in
               (bnd__315_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_removed_in_move__309_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__310_ ->
               let arg__312_ = Line_rule.sexp_of_t v__310_ in
               let bnd__311_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "line_removed_in_move"; arg__312_ ]
               in
               (bnd__311_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_to_new__305_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__306_ ->
               let arg__308_ = Line_rule.sexp_of_t v__306_ in
               let bnd__307_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_to_new"; arg__308_ ]
               in
               (bnd__307_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_from_old__301_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__302_ ->
               let arg__304_ = Line_rule.sexp_of_t v__302_ in
               let bnd__303_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_from_old"; arg__304_ ]
               in
               (bnd__303_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_unified__297_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__298_ ->
               let arg__300_ = Line_rule.sexp_of_t v__298_ in
               let bnd__299_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_unified"; arg__300_ ]
               in
               (bnd__299_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_new__293_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__294_ ->
               let arg__296_ = Line_rule.sexp_of_t v__294_ in
               let bnd__295_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_new"; arg__296_ ]
               in
               (bnd__295_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_old__289_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__290_ ->
               let arg__292_ = Line_rule.sexp_of_t v__290_ in
               let bnd__291_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_old"; arg__292_ ]
               in
               (bnd__291_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_same__285_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__286_ ->
               let arg__288_ = Line_rule.sexp_of_t v__286_ in
               let bnd__287_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same"; arg__288_ ]
               in
               (bnd__287_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match hunk__281_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__282_ ->
               let arg__284_ = Hunk.sexp_of_t v__282_ in
               let bnd__283_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hunk"; arg__284_ ]
               in
               (bnd__283_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match header_new__277_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__278_ ->
               let arg__280_ = Header.sexp_of_t v__278_ in
               let bnd__279_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_new"; arg__280_ ]
               in
               (bnd__279_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match header_old__273_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__274_ ->
               let arg__276_ = Header.sexp_of_t v__274_ in
               let bnd__275_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_old"; arg__276_ ]
               in
               (bnd__275_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match alt_new__269_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__270_ ->
               let arg__272_ = sexp_of_string v__270_ in
               let bnd__271_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_new"; arg__272_ ]
               in
               (bnd__271_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match alt_old__265_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__266_ ->
               let arg__268_ = sexp_of_string v__266_ in
               let bnd__267_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_old"; arg__268_ ]
               in
               (bnd__267_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             if
               (fun (a__343_ :
                      [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ])
                 ((b__344_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ])
                  [@merlin.hide]) ->
                  (if Stdlib.( == ) a__343_ b__344_
                   then true
                   else (
                     match a__343_, b__344_ with
                     | `ascii, `ascii -> true
                     | `html, `html -> true
                     | `ansi, `ansi -> true
                     | `unrefined _left__345_, `unrefined _right__346_ ->
                       if Stdlib.( == ) _left__345_ _right__346_
                       then true
                       else (
                         match _left__345_, _right__346_ with
                         | `ansi, `ansi -> true
                         | `html, `html -> true
                         | x, y -> Stdlib.( = ) x y)
                     | x, y -> Stdlib.( = ) x y))
                  [@merlin.hide])
                 default__260_
                 output__261_
             then bnds__198_
             else (
               let arg__264_ =
                 (function
                   | `ascii -> Sexplib0.Sexp.Atom "ascii"
                   | `html -> Sexplib0.Sexp.Atom "html"
                   | `ansi -> Sexplib0.Sexp.Atom "ansi"
                   | `unrefined v__262_ ->
                     Sexplib0.Sexp.List
                       [ Sexplib0.Sexp.Atom "unrefined"
                       ; (match v__262_ with
                          | `ansi -> Sexplib0.Sexp.Atom "ansi"
                          | `html -> Sexplib0.Sexp.Atom "html")
                       ])
                   output__261_
               in
               let bnd__263_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "output"; arg__264_ ]
               in
               (bnd__263_ :: bnds__198_ : _ Stdlib.List.t))
           in
           let bnds__198_ =
             match mask_uniques__255_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__256_ ->
               let arg__258_ = sexp_of_bool v__256_ in
               let bnd__257_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mask_uniques"; arg__258_ ]
               in
               (bnd__257_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match double_check__251_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__252_ ->
               let arg__254_ = sexp_of_bool v__252_ in
               let bnd__253_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "double_check"; arg__254_ ]
               in
               (bnd__253_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match shallow__247_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__248_ ->
               let arg__250_ = sexp_of_bool v__248_ in
               let bnd__249_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shallow"; arg__250_ ]
               in
               (bnd__249_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match quiet__243_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__244_ ->
               let arg__246_ = sexp_of_bool v__244_ in
               let bnd__245_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "quiet"; arg__246_ ]
               in
               (bnd__245_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match assume_text__239_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__240_ ->
               let arg__242_ = sexp_of_bool v__240_ in
               let bnd__241_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "assume_text"; arg__242_ ]
               in
               (bnd__241_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match interleave__235_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__236_ ->
               let arg__238_ = sexp_of_bool v__236_ in
               let bnd__237_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "interleave"; arg__238_ ]
               in
               (bnd__237_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match split_long_lines__231_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__232_ ->
               let arg__234_ = sexp_of_bool v__232_ in
               let bnd__233_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "split_long_lines"; arg__234_ ]
               in
               (bnd__233_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match find_moves__227_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__228_ ->
               let arg__230_ = sexp_of_bool v__228_ in
               let bnd__229_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "find_moves"; arg__230_ ]
               in
               (bnd__229_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match keep_whitespace__223_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__224_ ->
               let arg__226_ = sexp_of_bool v__224_ in
               let bnd__225_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keep_whitespace"; arg__226_ ]
               in
               (bnd__225_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match word_big_enough__219_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__220_ ->
               let arg__222_ = sexp_of_int v__220_ in
               let bnd__221_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_big_enough"; arg__222_ ]
               in
               (bnd__221_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match line_big_enough__215_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__216_ ->
               let arg__218_ = sexp_of_int v__216_ in
               let bnd__217_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_big_enough"; arg__218_ ]
               in
               (bnd__217_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match context__211_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__212_ ->
               let arg__214_ = sexp_of_int v__212_ in
               let bnd__213_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "context"; arg__214_ ]
               in
               (bnd__213_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match config_path__207_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__208_ ->
               let arg__210_ = sexp_of_string v__208_ in
               let bnd__209_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config_path"; arg__210_ ]
               in
               (bnd__209_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match dont_overwrite_word_old_word_new__203_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__204_ ->
               let arg__206_ = sexp_of_bool v__204_ in
               let bnd__205_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_overwrite_word_old_word_new"; arg__206_ ]
               in
               (bnd__205_ :: bnds__198_ : _ Stdlib.List.t)
           in
           let bnds__198_ =
             match dont_produce_unified_lines__199_ with
             | Stdlib.Option.None -> bnds__198_
             | Stdlib.Option.Some v__200_ ->
               let arg__202_ = sexp_of_bool v__200_ in
               let bnd__201_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_produce_unified_lines"; arg__202_ ]
               in
               (bnd__201_ :: bnds__198_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__198_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module V2 = struct
    type t =
      { dont_produce_unified_lines : bool option [@sexp.option]
      ; dont_overwrite_word_old_word_new : bool option [@sexp.option]
      ; config_path : string option [@sexp.option]
      ; context : int option [@sexp.option]
      ; line_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; word_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; keep_whitespace : bool option [@sexp.option]
      ; split_long_lines : bool option [@sexp.option]
      ; interleave : bool option [@sexp.option]
      ; assume_text : bool option [@sexp.option]
      ; quiet : bool option [@sexp.option]
      ; shallow : bool option [@sexp.option]
      ; double_check : bool option [@sexp.option]
      ; mask_uniques : bool option [@sexp.option]
      ; output : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ]
            [@default `ansi] [@sexp_drop_default.equal]
      ; alt_old : string option [@sexp.option]
      ; alt_new : string option [@sexp.option]
      ; header_old : Header.t option [@sexp.option]
      ; header_new : Header.t option [@sexp.option]
      ; hunk : Hunk.t option [@sexp.option]
      ; line_same : Line_rule.t option [@sexp.option]
      ; line_old : Line_rule.t option [@sexp.option]
      ; line_new : Line_rule.t option [@sexp.option]
      ; line_unified : Line_rule.t option [@sexp.option]
      ; word_old : Rule.t option [@sexp.option]
      ; word_new : Rule.t option [@sexp.option]
      ; location_style : Format.Location_style.t
            [@default Format.Location_style.Diff] [@sexp_drop_default.equal]
      ; warn_if_no_trailing_newline_in_both : bool
            [@default warn_if_no_trailing_newline_in_both_default]
            [@sexp_drop_default.equal]
      }
    [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__426_ ~random:_random__427_ ->
             { dont_produce_unified_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; dont_overwrite_word_old_word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; config_path =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__426_
                   ~random:_random__427_
             ; context =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_int)
                   ~size:_size__426_
                   ~random:_random__427_
             ; line_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__426_
                   ~random:_random__427_
             ; word_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__426_
                   ~random:_random__427_
             ; keep_whitespace =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; split_long_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; interleave =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; assume_text =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; quiet =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; shallow =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; double_check =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; mask_uniques =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__426_
                   ~random:_random__427_
             ; output =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
                      [ ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__414_ ~random:_random__415_ -> `ascii) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__416_ ~random:_random__417_ -> `html) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__418_ ~random:_random__419_ -> `ansi) )
                      ; ( 1.
                        , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                            (fun ~size:_size__424_ ~random:_random__425_ ->
                               `unrefined
                                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator
                                  .generate
                                    (Ppx_quickcheck_runtime.Base_quickcheck.Generator
                                     .weighted_union
                                       [ ( 1.
                                         , Ppx_quickcheck_runtime.Base_quickcheck
                                           .Generator
                                           .create
                                             (fun
                                                 ~size:_size__420_
                                                  ~random:_random__421_
                                                -> `ansi) )
                                       ; ( 1.
                                         , Ppx_quickcheck_runtime.Base_quickcheck
                                           .Generator
                                           .create
                                             (fun
                                                 ~size:_size__422_
                                                  ~random:_random__423_
                                                -> `html) )
                                       ])
                                    ~size:_size__424_
                                    ~random:_random__425_)) )
                      ])
                   ~size:_size__426_
                   ~random:_random__427_
             ; alt_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__426_
                   ~random:_random__427_
             ; alt_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__426_
                   ~random:_random__427_
             ; header_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; header_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; hunk =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Hunk.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; line_same =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; line_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; line_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; line_unified =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; word_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__426_
                   ~random:_random__427_
             ; location_style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   Format.Location_style.quickcheck_generator
                   ~size:_size__426_
                   ~random:_random__427_
             ; warn_if_no_trailing_newline_in_both =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_bool
                   ~size:_size__426_
                   ~random:_random__427_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__376_ ~size:_size__412_ ~hash:_hash__413_ ->
             let { dont_produce_unified_lines = _x__377_
                 ; dont_overwrite_word_old_word_new = _x__378_
                 ; config_path = _x__379_
                 ; context = _x__380_
                 ; line_big_enough = _x__381_
                 ; word_big_enough = _x__382_
                 ; keep_whitespace = _x__383_
                 ; split_long_lines = _x__384_
                 ; interleave = _x__385_
                 ; assume_text = _x__386_
                 ; quiet = _x__387_
                 ; shallow = _x__388_
                 ; double_check = _x__389_
                 ; mask_uniques = _x__390_
                 ; output = _x__391_
                 ; alt_old = _x__392_
                 ; alt_new = _x__393_
                 ; header_old = _x__394_
                 ; header_new = _x__395_
                 ; hunk = _x__396_
                 ; line_same = _x__397_
                 ; line_old = _x__398_
                 ; line_new = _x__399_
                 ; line_unified = _x__400_
                 ; word_old = _x__401_
                 ; word_new = _x__402_
                 ; location_style = _x__403_
                 ; warn_if_no_trailing_newline_in_both = _x__404_
                 }
               =
               _x__376_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__377_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__378_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__379_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__380_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__381_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__382_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__383_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__384_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__385_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__386_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__387_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__388_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__389_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__390_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
                    (fun _x__405_ ~size:_size__406_ ~hash:_hash__407_ ->
                       match _x__405_ with
                       | `ascii ->
                         let _hash__407_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int _hash__407_ 640502097
                         in
                         _hash__407_
                       | `html ->
                         let _hash__407_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__407_
                             (-988375701)
                         in
                         _hash__407_
                       | `ansi ->
                         let _hash__407_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__407_
                             (-1066299709)
                         in
                         _hash__407_
                       | `unrefined _x__411_ ->
                         let _hash__407_ =
                           Ppx_quickcheck_runtime.Base.hash_fold_int
                             _hash__407_
                             (-482951906)
                         in
                         let _hash__407_ =
                           Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                             (Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
                                (fun _x__408_ ~size:_size__409_ ~hash:_hash__410_ ->
                                   match _x__408_ with
                                   | `ansi ->
                                     let _hash__410_ =
                                       Ppx_quickcheck_runtime.Base.hash_fold_int
                                         _hash__410_
                                         (-1066299709)
                                     in
                                     _hash__410_
                                   | `html ->
                                     let _hash__410_ =
                                       Ppx_quickcheck_runtime.Base.hash_fold_int
                                         _hash__410_
                                         (-988375701)
                                     in
                                     _hash__410_))
                             _x__411_
                             ~size:_size__406_
                             ~hash:_hash__407_
                         in
                         _hash__407_))
                 _x__391_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__392_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__393_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__394_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__395_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Hunk.quickcheck_observer)
                 _x__396_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__397_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__398_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__399_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__400_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__401_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__402_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 Format.Location_style.quickcheck_observer
                 _x__403_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             let _hash__413_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_bool
                 _x__404_
                 ~size:_size__412_
                 ~hash:_hash__413_
             in
             _hash__413_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun
              { dont_produce_unified_lines = _x__347_
              ; dont_overwrite_word_old_word_new = _x__348_
              ; config_path = _x__349_
              ; context = _x__350_
              ; line_big_enough = _x__351_
              ; word_big_enough = _x__352_
              ; keep_whitespace = _x__353_
              ; split_long_lines = _x__354_
              ; interleave = _x__355_
              ; assume_text = _x__356_
              ; quiet = _x__357_
              ; shallow = _x__358_
              ; double_check = _x__359_
              ; mask_uniques = _x__360_
              ; output = _x__361_
              ; alt_old = _x__362_
              ; alt_new = _x__363_
              ; header_old = _x__364_
              ; header_new = _x__365_
              ; hunk = _x__366_
              ; line_same = _x__367_
              ; line_old = _x__368_
              ; line_new = _x__369_
              ; line_unified = _x__370_
              ; word_old = _x__371_
              ; word_new = _x__372_
              ; location_style = _x__373_
              ; warn_if_no_trailing_newline_in_both = _x__374_
              }
             ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__347_)
                   ~f:(fun _x__347_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__348_)
                   ~f:(fun _x__348_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__349_)
                   ~f:(fun _x__349_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__350_)
                   ~f:(fun _x__350_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__351_)
                   ~f:(fun _x__351_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__352_)
                   ~f:(fun _x__352_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__353_)
                   ~f:(fun _x__353_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__354_)
                   ~f:(fun _x__354_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__355_)
                   ~f:(fun _x__355_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__356_)
                   ~f:(fun _x__356_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__357_)
                   ~f:(fun _x__357_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__358_)
                   ~f:(fun _x__358_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__359_)
                   ~f:(fun _x__359_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__360_)
                   ~f:(fun _x__360_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
                         | `ascii -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `html -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `ansi -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
                         | `unrefined _x__375_ ->
                           Ppx_quickcheck_runtime.Base.Sequence.round_robin
                             [ Ppx_quickcheck_runtime.Base.Sequence.map
                                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                                    (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker
                                     .create
                                       (function
                                       | `ansi ->
                                         Ppx_quickcheck_runtime.Base.Sequence.round_robin
                                           []
                                       | `html ->
                                         Ppx_quickcheck_runtime.Base.Sequence.round_robin
                                           []))
                                    _x__375_)
                                 ~f:(fun _x__375_ -> `unrefined _x__375_)
                             ]))
                      _x__361_)
                   ~f:(fun _x__361_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__362_)
                   ~f:(fun _x__362_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__363_)
                   ~f:(fun _x__363_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__364_)
                   ~f:(fun _x__364_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__365_)
                   ~f:(fun _x__365_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Hunk.quickcheck_shrinker)
                      _x__366_)
                   ~f:(fun _x__366_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__367_)
                   ~f:(fun _x__367_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__368_)
                   ~f:(fun _x__368_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__369_)
                   ~f:(fun _x__369_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__370_)
                   ~f:(fun _x__370_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__371_)
                   ~f:(fun _x__371_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__372_)
                   ~f:(fun _x__372_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      Format.Location_style.quickcheck_shrinker
                      _x__373_)
                   ~f:(fun _x__373_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_bool
                      _x__374_)
                   ~f:(fun _x__374_ ->
                     { dont_produce_unified_lines = _x__347_
                     ; dont_overwrite_word_old_word_new = _x__348_
                     ; config_path = _x__349_
                     ; context = _x__350_
                     ; line_big_enough = _x__351_
                     ; word_big_enough = _x__352_
                     ; keep_whitespace = _x__353_
                     ; split_long_lines = _x__354_
                     ; interleave = _x__355_
                     ; assume_text = _x__356_
                     ; quiet = _x__357_
                     ; shallow = _x__358_
                     ; double_check = _x__359_
                     ; mask_uniques = _x__360_
                     ; output = _x__361_
                     ; alt_old = _x__362_
                     ; alt_new = _x__363_
                     ; header_old = _x__364_
                     ; header_new = _x__365_
                     ; hunk = _x__366_
                     ; line_same = _x__367_
                     ; line_old = _x__368_
                     ; line_new = _x__369_
                     ; line_unified = _x__370_
                     ; word_old = _x__371_
                     ; word_new = _x__372_
                     ; location_style = _x__373_
                     ; warn_if_no_trailing_newline_in_both = _x__374_
                     })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let default__430_ : bool = warn_if_no_trailing_newline_in_both_default
         and default__431_ : Format.Location_style.t = Format.Location_style.Diff
         and default__432_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ] =
           `ansi
         in
         let error_source__429_ = "configuration.ml.before-ppx.On_disk.V2.t" in
         fun x__448_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__429_
             ~fields:
               (Field
                  { name = "dont_produce_unified_lines"
                  ; kind = Sexp_option
                  ; conv = bool_of_sexp
                  ; rest =
                      Field
                        { name = "dont_overwrite_word_old_word_new"
                        ; kind = Sexp_option
                        ; conv = bool_of_sexp
                        ; rest =
                            Field
                              { name = "config_path"
                              ; kind = Sexp_option
                              ; conv = string_of_sexp
                              ; rest =
                                  Field
                                    { name = "context"
                                    ; kind = Sexp_option
                                    ; conv = int_of_sexp
                                    ; rest =
                                        Field
                                          { name = "line_big_enough"
                                          ; kind = Sexp_option
                                          ; conv = int_of_sexp
                                          ; rest =
                                              Field
                                                { name = "word_big_enough"
                                                ; kind = Sexp_option
                                                ; conv = int_of_sexp
                                                ; rest =
                                                    Field
                                                      { name = "keep_whitespace"
                                                      ; kind = Sexp_option
                                                      ; conv = bool_of_sexp
                                                      ; rest =
                                                          Field
                                                            { name = "split_long_lines"
                                                            ; kind = Sexp_option
                                                            ; conv = bool_of_sexp
                                                            ; rest =
                                                                Field
                                                                  { name = "interleave"
                                                                  ; kind = Sexp_option
                                                                  ; conv = bool_of_sexp
                                                                  ; rest =
                                                                      Field
                                                                        { name =
                                                                            "assume_text"
                                                                        ; kind =
                                                                            Sexp_option
                                                                        ; conv =
                                                                            bool_of_sexp
                                                                        ; rest =
                                                                            Field
                                                                              { name =
                                                                                  "quiet"
                                                                              ; kind =
                                                                                  Sexp_option
                                                                              ; conv =
                                                                                  bool_of_sexp
                                                                              ; rest =
                                                                                  Field
                                                                                    { name =
                                                                                        "shallow"
                                                                                    ; kind =
                                                                                        Sexp_option
                                                                                    ; conv =
                                                                                        bool_of_sexp
                                                                                    ; rest =
                                                                                        Field
                                                                                          { 
                                                                                          name =
                                                                                          "double_check"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "mask_uniques"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "output"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__432_)
                                                                                          ; 
                                                                                          conv =
                                                                                          (fun 
                                                                                          sexp__447_ ->
                                                                                          try
                                                                                          match
                                                                                          sexp__447_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__434_
                                                                                          as
                                                                                          _sexp__436_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__434_
                                                                                          with
                                                                                          | 
                                                                                          "ascii"
                                                                                          ->
                                                                                          
                                                                                          `ascii
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          `html
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          `ansi
                                                                                          | 
                                                                                          "unrefined"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_takes_args
                                                                                          error_source__429_
                                                                                          _sexp__436_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__434_
                                                                                          :: 
                                                                                          sexp_args__437_
                                                                                          )
                                                                                          as
                                                                                          _sexp__436_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__434_
                                                                                          with
                                                                                          | 
                                                                                          "unrefined"
                                                                                          as
                                                                                          _tag__438_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          sexp_args__437_
                                                                                          with
                                                                                          | 
                                                                                          arg0__445_
                                                                                          :: 
                                                                                          []
                                                                                          ->
                                                                                          
                                                                                          let res0__446_
                                                                                          =
                                                                                          let sexp__444_
                                                                                          =
                                                                                          arg0__445_
                                                                                          in
                                                                                          try
                                                                                          match
                                                                                          sexp__444_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__440_
                                                                                          as
                                                                                          _sexp__442_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__440_
                                                                                          with
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          `ansi
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          `html
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .Atom
                                                                                          atom__440_
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          _sexp__442_
                                                                                          ->
                                                                                          
                                                                                          (
                                                                                          match
                                                                                          atom__440_
                                                                                          with
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__429_
                                                                                          _sexp__442_
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__429_
                                                                                          _sexp__442_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          _
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          sexp__441_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .nested_list_invalid_poly_var
                                                                                          error_source__429_
                                                                                          sexp__441_
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          []
                                                                                          as
                                                                                          sexp__441_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .empty_list_invalid_poly_var
                                                                                          error_source__429_
                                                                                          sexp__441_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .No_variant_match
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_matching_variant_found
                                                                                          error_source__429_
                                                                                          sexp__444_
                                                                                          in
                                                                                          `unrefined
                                                                                          res0__446_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_incorrect_n_args
                                                                                          error_source__429_
                                                                                          _tag__438_
                                                                                          _sexp__436_)
                                                                                          | 
                                                                                          "ascii"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__429_
                                                                                          _sexp__436_
                                                                                          | 
                                                                                          "html"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__429_
                                                                                          _sexp__436_
                                                                                          | 
                                                                                          "ansi"
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .ptag_no_args
                                                                                          error_source__429_
                                                                                          _sexp__436_
                                                                                          | _
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_variant_match
                                                                                          ())
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          (
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          _
                                                                                          :: 
                                                                                          _
                                                                                          )
                                                                                          as
                                                                                          sexp__435_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .nested_list_invalid_poly_var
                                                                                          error_source__429_
                                                                                          sexp__435_
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          []
                                                                                          as
                                                                                          sexp__435_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .empty_list_invalid_poly_var
                                                                                          error_source__429_
                                                                                          sexp__435_
                                                                                          with
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .No_variant_match
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .no_matching_variant_found
                                                                                          error_source__429_
                                                                                          sexp__447_)
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "hunk"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Hunk
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_same"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_unified"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "location_style"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__431_)
                                                                                          ; 
                                                                                          conv =
                                                                                          Format
                                                                                          .Location_style
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "warn_if_no_trailing_newline_in_both"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__430_)
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "dont_produce_unified_lines" -> 0
               | "dont_overwrite_word_old_word_new" -> 1
               | "config_path" -> 2
               | "context" -> 3
               | "line_big_enough" -> 4
               | "word_big_enough" -> 5
               | "keep_whitespace" -> 6
               | "split_long_lines" -> 7
               | "interleave" -> 8
               | "assume_text" -> 9
               | "quiet" -> 10
               | "shallow" -> 11
               | "double_check" -> 12
               | "mask_uniques" -> 13
               | "output" -> 14
               | "alt_old" -> 15
               | "alt_new" -> 16
               | "header_old" -> 17
               | "header_new" -> 18
               | "hunk" -> 19
               | "line_same" -> 20
               | "line_old" -> 21
               | "line_new" -> 22
               | "line_unified" -> 23
               | "word_old" -> 24
               | "word_new" -> 25
               | "location_style" -> 26
               | "warn_if_no_trailing_newline_in_both" -> 27
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:
               (fun
                 ( dont_produce_unified_lines
                 , ( dont_overwrite_word_old_word_new
                   , ( config_path
                     , ( context
                       , ( line_big_enough
                         , ( word_big_enough
                           , ( keep_whitespace
                             , ( split_long_lines
                               , ( interleave
                                 , ( assume_text
                                   , ( quiet
                                     , ( shallow
                                       , ( double_check
                                         , ( mask_uniques
                                           , ( output
                                             , ( alt_old
                                               , ( alt_new
                                                 , ( header_old
                                                   , ( header_new
                                                     , ( hunk
                                                       , ( line_same
                                                         , ( line_old
                                                           , ( line_new
                                                             , ( line_unified
                                                               , ( word_old
                                                                 , ( word_new
                                                                   , ( location_style
                                                                     , ( warn_if_no_trailing_newline_in_both
                                                                       , () ) ) ) ) ) ) )
                                                         ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
                         ) ) ) ) ) ->
               ({ dont_produce_unified_lines
                ; dont_overwrite_word_old_word_new
                ; config_path
                ; context
                ; line_big_enough
                ; word_big_enough
                ; keep_whitespace
                ; split_long_lines
                ; interleave
                ; assume_text
                ; quiet
                ; shallow
                ; double_check
                ; mask_uniques
                ; output
                ; alt_old
                ; alt_new
                ; header_old
                ; header_new
                ; hunk
                ; line_same
                ; line_old
                ; line_new
                ; line_unified
                ; word_old
                ; word_new
                ; location_style
                ; warn_if_no_trailing_newline_in_both
                }
                : t))
             x__448_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (let default__507_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ] =
           `ansi
         and default__557_ : Format.Location_style.t = Format.Location_style.Diff
         and default__562_ : bool = warn_if_no_trailing_newline_in_both_default in
         fun { dont_produce_unified_lines = dont_produce_unified_lines__450_
             ; dont_overwrite_word_old_word_new = dont_overwrite_word_old_word_new__454_
             ; config_path = config_path__458_
             ; context = context__462_
             ; line_big_enough = line_big_enough__466_
             ; word_big_enough = word_big_enough__470_
             ; keep_whitespace = keep_whitespace__474_
             ; split_long_lines = split_long_lines__478_
             ; interleave = interleave__482_
             ; assume_text = assume_text__486_
             ; quiet = quiet__490_
             ; shallow = shallow__494_
             ; double_check = double_check__498_
             ; mask_uniques = mask_uniques__502_
             ; output = output__508_
             ; alt_old = alt_old__512_
             ; alt_new = alt_new__516_
             ; header_old = header_old__520_
             ; header_new = header_new__524_
             ; hunk = hunk__528_
             ; line_same = line_same__532_
             ; line_old = line_old__536_
             ; line_new = line_new__540_
             ; line_unified = line_unified__544_
             ; word_old = word_old__548_
             ; word_new = word_new__552_
             ; location_style = location_style__558_
             ; warn_if_no_trailing_newline_in_both =
                 warn_if_no_trailing_newline_in_both__563_
             } ->
           let bnds__449_ = ([] : _ Stdlib.List.t) in
           let bnds__449_ =
             if
               (fun (a__566_ : bool) ((b__567_ : bool) [@merlin.hide]) ->
                  (equal_bool a__566_ b__567_ [@merlin.hide]))
                 default__562_
                 warn_if_no_trailing_newline_in_both__563_
             then bnds__449_
             else (
               let arg__565_ = sexp_of_bool warn_if_no_trailing_newline_in_both__563_ in
               let bnd__564_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "warn_if_no_trailing_newline_in_both"; arg__565_ ]
               in
               (bnd__564_ :: bnds__449_ : _ Stdlib.List.t))
           in
           let bnds__449_ =
             if
               (fun (a__568_ : Format.Location_style.t)
                 ((b__569_ : Format.Location_style.t) [@merlin.hide]) ->
                  (Format.Location_style.equal a__568_ b__569_ [@merlin.hide]))
                 default__557_
                 location_style__558_
             then bnds__449_
             else (
               let arg__560_ = Format.Location_style.sexp_of_t location_style__558_ in
               let bnd__559_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "location_style"; arg__560_ ]
               in
               (bnd__559_ :: bnds__449_ : _ Stdlib.List.t))
           in
           let bnds__449_ =
             match word_new__552_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__553_ ->
               let arg__555_ = Rule.sexp_of_t v__553_ in
               let bnd__554_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_new"; arg__555_ ]
               in
               (bnd__554_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match word_old__548_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__549_ ->
               let arg__551_ = Rule.sexp_of_t v__549_ in
               let bnd__550_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_old"; arg__551_ ]
               in
               (bnd__550_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match line_unified__544_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__545_ ->
               let arg__547_ = Line_rule.sexp_of_t v__545_ in
               let bnd__546_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_unified"; arg__547_ ]
               in
               (bnd__546_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match line_new__540_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__541_ ->
               let arg__543_ = Line_rule.sexp_of_t v__541_ in
               let bnd__542_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_new"; arg__543_ ]
               in
               (bnd__542_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match line_old__536_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__537_ ->
               let arg__539_ = Line_rule.sexp_of_t v__537_ in
               let bnd__538_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_old"; arg__539_ ]
               in
               (bnd__538_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match line_same__532_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__533_ ->
               let arg__535_ = Line_rule.sexp_of_t v__533_ in
               let bnd__534_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same"; arg__535_ ]
               in
               (bnd__534_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match hunk__528_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__529_ ->
               let arg__531_ = Hunk.sexp_of_t v__529_ in
               let bnd__530_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hunk"; arg__531_ ]
               in
               (bnd__530_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match header_new__524_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__525_ ->
               let arg__527_ = Header.sexp_of_t v__525_ in
               let bnd__526_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_new"; arg__527_ ]
               in
               (bnd__526_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match header_old__520_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__521_ ->
               let arg__523_ = Header.sexp_of_t v__521_ in
               let bnd__522_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_old"; arg__523_ ]
               in
               (bnd__522_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match alt_new__516_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__517_ ->
               let arg__519_ = sexp_of_string v__517_ in
               let bnd__518_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_new"; arg__519_ ]
               in
               (bnd__518_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match alt_old__512_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__513_ ->
               let arg__515_ = sexp_of_string v__513_ in
               let bnd__514_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_old"; arg__515_ ]
               in
               (bnd__514_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             if
               (fun (a__570_ :
                      [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ])
                 ((b__571_ : [ `ascii | `html | `ansi | `unrefined of [ `ansi | `html ] ])
                  [@merlin.hide]) ->
                  (if Stdlib.( == ) a__570_ b__571_
                   then true
                   else (
                     match a__570_, b__571_ with
                     | `ascii, `ascii -> true
                     | `html, `html -> true
                     | `ansi, `ansi -> true
                     | `unrefined _left__572_, `unrefined _right__573_ ->
                       if Stdlib.( == ) _left__572_ _right__573_
                       then true
                       else (
                         match _left__572_, _right__573_ with
                         | `ansi, `ansi -> true
                         | `html, `html -> true
                         | x, y -> Stdlib.( = ) x y)
                     | x, y -> Stdlib.( = ) x y))
                  [@merlin.hide])
                 default__507_
                 output__508_
             then bnds__449_
             else (
               let arg__511_ =
                 (function
                   | `ascii -> Sexplib0.Sexp.Atom "ascii"
                   | `html -> Sexplib0.Sexp.Atom "html"
                   | `ansi -> Sexplib0.Sexp.Atom "ansi"
                   | `unrefined v__509_ ->
                     Sexplib0.Sexp.List
                       [ Sexplib0.Sexp.Atom "unrefined"
                       ; (match v__509_ with
                          | `ansi -> Sexplib0.Sexp.Atom "ansi"
                          | `html -> Sexplib0.Sexp.Atom "html")
                       ])
                   output__508_
               in
               let bnd__510_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "output"; arg__511_ ]
               in
               (bnd__510_ :: bnds__449_ : _ Stdlib.List.t))
           in
           let bnds__449_ =
             match mask_uniques__502_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__503_ ->
               let arg__505_ = sexp_of_bool v__503_ in
               let bnd__504_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mask_uniques"; arg__505_ ]
               in
               (bnd__504_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match double_check__498_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__499_ ->
               let arg__501_ = sexp_of_bool v__499_ in
               let bnd__500_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "double_check"; arg__501_ ]
               in
               (bnd__500_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match shallow__494_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__495_ ->
               let arg__497_ = sexp_of_bool v__495_ in
               let bnd__496_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shallow"; arg__497_ ]
               in
               (bnd__496_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match quiet__490_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__491_ ->
               let arg__493_ = sexp_of_bool v__491_ in
               let bnd__492_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "quiet"; arg__493_ ]
               in
               (bnd__492_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match assume_text__486_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__487_ ->
               let arg__489_ = sexp_of_bool v__487_ in
               let bnd__488_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "assume_text"; arg__489_ ]
               in
               (bnd__488_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match interleave__482_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__483_ ->
               let arg__485_ = sexp_of_bool v__483_ in
               let bnd__484_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "interleave"; arg__485_ ]
               in
               (bnd__484_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match split_long_lines__478_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__479_ ->
               let arg__481_ = sexp_of_bool v__479_ in
               let bnd__480_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "split_long_lines"; arg__481_ ]
               in
               (bnd__480_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match keep_whitespace__474_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__475_ ->
               let arg__477_ = sexp_of_bool v__475_ in
               let bnd__476_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keep_whitespace"; arg__477_ ]
               in
               (bnd__476_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match word_big_enough__470_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__471_ ->
               let arg__473_ = sexp_of_int v__471_ in
               let bnd__472_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_big_enough"; arg__473_ ]
               in
               (bnd__472_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match line_big_enough__466_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__467_ ->
               let arg__469_ = sexp_of_int v__467_ in
               let bnd__468_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_big_enough"; arg__469_ ]
               in
               (bnd__468_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match context__462_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__463_ ->
               let arg__465_ = sexp_of_int v__463_ in
               let bnd__464_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "context"; arg__465_ ]
               in
               (bnd__464_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match config_path__458_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__459_ ->
               let arg__461_ = sexp_of_string v__459_ in
               let bnd__460_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config_path"; arg__461_ ]
               in
               (bnd__460_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match dont_overwrite_word_old_word_new__454_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__455_ ->
               let arg__457_ = sexp_of_bool v__455_ in
               let bnd__456_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_overwrite_word_old_word_new"; arg__457_ ]
               in
               (bnd__456_ :: bnds__449_ : _ Stdlib.List.t)
           in
           let bnds__449_ =
             match dont_produce_unified_lines__450_ with
             | Stdlib.Option.None -> bnds__449_
             | Stdlib.Option.Some v__451_ ->
               let arg__453_ = sexp_of_bool v__451_ in
               let bnd__452_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_produce_unified_lines"; arg__453_ ]
               in
               (bnd__452_ :: bnds__449_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__449_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_v3
          { dont_produce_unified_lines
          ; dont_overwrite_word_old_word_new
          ; config_path
          ; context
          ; line_big_enough
          ; word_big_enough
          ; keep_whitespace
          ; split_long_lines
          ; interleave
          ; assume_text
          ; quiet
          ; shallow
          ; double_check
          ; mask_uniques
          ; output
          ; alt_old
          ; alt_new
          ; header_old
          ; header_new
          ; hunk
          ; line_same
          ; line_old
          ; line_new
          ; line_unified
          ; word_old
          ; word_new
          ; location_style
          ; warn_if_no_trailing_newline_in_both
          }
      =
      { V3.dont_produce_unified_lines
      ; dont_overwrite_word_old_word_new
      ; config_path
      ; context
      ; line_big_enough
      ; word_big_enough
      ; keep_whitespace
      ; find_moves = Some false
      ; split_long_lines
      ; interleave
      ; assume_text
      ; quiet
      ; shallow
      ; double_check
      ; mask_uniques
      ; output
      ; alt_old
      ; alt_new
      ; header_old
      ; header_new
      ; hunk
      ; line_same
      ; line_old
      ; line_new
      ; line_unified
      ; line_from_old = None
      ; line_to_new = None
      ; line_removed_in_move = None
      ; line_added_in_move = None
      ; line_unified_in_move = None
      ; word_old
      ; word_new
      ; location_style
      ; warn_if_no_trailing_newline_in_both
      }
    ;;
  end

  module V1 = struct
    type t =
      { dont_produce_unified_lines : bool option [@sexp.option]
      ; dont_overwrite_word_old_word_new : bool option [@sexp.option]
      ; config_path : string option [@sexp.option]
      ; context : int option [@sexp.option]
      ; line_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; word_big_enough : (int[@generator Int.gen_incl 1 10_000]) option [@sexp.option]
      ; unrefined : bool option [@sexp.option]
      ; keep_whitespace : bool option [@sexp.option]
      ; split_long_lines : bool option [@sexp.option]
      ; interleave : bool option [@sexp.option]
      ; assume_text : bool option [@sexp.option]
      ; quiet : bool option [@sexp.option]
      ; shallow : bool option [@sexp.option]
      ; double_check : bool option [@sexp.option]
      ; mask_uniques : bool option [@sexp.option]
      ; html : bool option [@sexp.option]
      ; alt_old : string option [@sexp.option]
      ; alt_new : string option [@sexp.option]
      ; header_old : Header.t option [@sexp.option]
      ; header_new : Header.t option [@sexp.option]
      ; hunk : Hunk.t option [@sexp.option]
      ; line_same : Line_rule.t option [@sexp.option]
      ; line_old : Line_rule.t option [@sexp.option]
      ; line_new : Line_rule.t option [@sexp.option]
      ; line_unified : Line_rule.t option [@sexp.option]
      ; word_old : Rule.t option [@sexp.option]
      ; word_new : Rule.t option [@sexp.option]
      ; location_style : Format.Location_style.t
            [@default Format.Location_style.Diff] [@sexp_drop_default.equal]
      ; warn_if_no_trailing_newline_in_both : bool
            [@default warn_if_no_trailing_newline_in_both_default]
            [@sexp_drop_default.equal]
      }
    [@@deriving quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__635_ ~random:_random__636_ ->
             { dont_produce_unified_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; dont_overwrite_word_old_word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; config_path =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__635_
                   ~random:_random__636_
             ; context =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_int)
                   ~size:_size__635_
                   ~random:_random__636_
             ; line_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__635_
                   ~random:_random__636_
             ; word_big_enough =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option (Int.gen_incl 1 10_000))
                   ~size:_size__635_
                   ~random:_random__636_
             ; unrefined =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; keep_whitespace =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; split_long_lines =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; interleave =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; assume_text =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; quiet =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; shallow =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; double_check =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; mask_uniques =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; html =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_bool)
                   ~size:_size__635_
                   ~random:_random__636_
             ; alt_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__635_
                   ~random:_random__636_
             ; alt_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option quickcheck_generator_string)
                   ~size:_size__635_
                   ~random:_random__636_
             ; header_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; header_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Header.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; hunk =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Hunk.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; line_same =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; line_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; line_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; line_unified =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Line_rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; word_old =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; word_new =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   (quickcheck_generator_option Rule.quickcheck_generator)
                   ~size:_size__635_
                   ~random:_random__636_
             ; location_style =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   Format.Location_style.quickcheck_generator
                   ~size:_size__635_
                   ~random:_random__636_
             ; warn_if_no_trailing_newline_in_both =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_bool
                   ~size:_size__635_
                   ~random:_random__636_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__603_ ~size:_size__633_ ~hash:_hash__634_ ->
             let { dont_produce_unified_lines = _x__604_
                 ; dont_overwrite_word_old_word_new = _x__605_
                 ; config_path = _x__606_
                 ; context = _x__607_
                 ; line_big_enough = _x__608_
                 ; word_big_enough = _x__609_
                 ; unrefined = _x__610_
                 ; keep_whitespace = _x__611_
                 ; split_long_lines = _x__612_
                 ; interleave = _x__613_
                 ; assume_text = _x__614_
                 ; quiet = _x__615_
                 ; shallow = _x__616_
                 ; double_check = _x__617_
                 ; mask_uniques = _x__618_
                 ; html = _x__619_
                 ; alt_old = _x__620_
                 ; alt_new = _x__621_
                 ; header_old = _x__622_
                 ; header_new = _x__623_
                 ; hunk = _x__624_
                 ; line_same = _x__625_
                 ; line_old = _x__626_
                 ; line_new = _x__627_
                 ; line_unified = _x__628_
                 ; word_old = _x__629_
                 ; word_new = _x__630_
                 ; location_style = _x__631_
                 ; warn_if_no_trailing_newline_in_both = _x__632_
                 }
               =
               _x__603_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__604_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__605_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__606_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__607_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__608_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_int)
                 _x__609_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__610_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__611_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__612_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__613_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__614_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__615_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__616_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__617_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__618_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_bool)
                 _x__619_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__620_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option quickcheck_observer_string)
                 _x__621_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__622_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Header.quickcheck_observer)
                 _x__623_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Hunk.quickcheck_observer)
                 _x__624_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__625_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__626_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__627_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Line_rule.quickcheck_observer)
                 _x__628_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__629_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 (quickcheck_observer_option Rule.quickcheck_observer)
                 _x__630_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 Format.Location_style.quickcheck_observer
                 _x__631_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             let _hash__634_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_bool
                 _x__632_
                 ~size:_size__633_
                 ~hash:_hash__634_
             in
             _hash__634_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun
              { dont_produce_unified_lines = _x__574_
              ; dont_overwrite_word_old_word_new = _x__575_
              ; config_path = _x__576_
              ; context = _x__577_
              ; line_big_enough = _x__578_
              ; word_big_enough = _x__579_
              ; unrefined = _x__580_
              ; keep_whitespace = _x__581_
              ; split_long_lines = _x__582_
              ; interleave = _x__583_
              ; assume_text = _x__584_
              ; quiet = _x__585_
              ; shallow = _x__586_
              ; double_check = _x__587_
              ; mask_uniques = _x__588_
              ; html = _x__589_
              ; alt_old = _x__590_
              ; alt_new = _x__591_
              ; header_old = _x__592_
              ; header_new = _x__593_
              ; hunk = _x__594_
              ; line_same = _x__595_
              ; line_old = _x__596_
              ; line_new = _x__597_
              ; line_unified = _x__598_
              ; word_old = _x__599_
              ; word_new = _x__600_
              ; location_style = _x__601_
              ; warn_if_no_trailing_newline_in_both = _x__602_
              }
             ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__574_)
                   ~f:(fun _x__574_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__575_)
                   ~f:(fun _x__575_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__576_)
                   ~f:(fun _x__576_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__577_)
                   ~f:(fun _x__577_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__578_)
                   ~f:(fun _x__578_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_int)
                      _x__579_)
                   ~f:(fun _x__579_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__580_)
                   ~f:(fun _x__580_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__581_)
                   ~f:(fun _x__581_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__582_)
                   ~f:(fun _x__582_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__583_)
                   ~f:(fun _x__583_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__584_)
                   ~f:(fun _x__584_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__585_)
                   ~f:(fun _x__585_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__586_)
                   ~f:(fun _x__586_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__587_)
                   ~f:(fun _x__587_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__588_)
                   ~f:(fun _x__588_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_bool)
                      _x__589_)
                   ~f:(fun _x__589_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__590_)
                   ~f:(fun _x__590_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option quickcheck_shrinker_string)
                      _x__591_)
                   ~f:(fun _x__591_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__592_)
                   ~f:(fun _x__592_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Header.quickcheck_shrinker)
                      _x__593_)
                   ~f:(fun _x__593_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Hunk.quickcheck_shrinker)
                      _x__594_)
                   ~f:(fun _x__594_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__595_)
                   ~f:(fun _x__595_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__596_)
                   ~f:(fun _x__596_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__597_)
                   ~f:(fun _x__597_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Line_rule.quickcheck_shrinker)
                      _x__598_)
                   ~f:(fun _x__598_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__599_)
                   ~f:(fun _x__599_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      (quickcheck_shrinker_option Rule.quickcheck_shrinker)
                      _x__600_)
                   ~f:(fun _x__600_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      Format.Location_style.quickcheck_shrinker
                      _x__601_)
                   ~f:(fun _x__601_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_bool
                      _x__602_)
                   ~f:(fun _x__602_ ->
                     { dont_produce_unified_lines = _x__574_
                     ; dont_overwrite_word_old_word_new = _x__575_
                     ; config_path = _x__576_
                     ; context = _x__577_
                     ; line_big_enough = _x__578_
                     ; word_big_enough = _x__579_
                     ; unrefined = _x__580_
                     ; keep_whitespace = _x__581_
                     ; split_long_lines = _x__582_
                     ; interleave = _x__583_
                     ; assume_text = _x__584_
                     ; quiet = _x__585_
                     ; shallow = _x__586_
                     ; double_check = _x__587_
                     ; mask_uniques = _x__588_
                     ; html = _x__589_
                     ; alt_old = _x__590_
                     ; alt_new = _x__591_
                     ; header_old = _x__592_
                     ; header_new = _x__593_
                     ; hunk = _x__594_
                     ; line_same = _x__595_
                     ; line_old = _x__596_
                     ; line_new = _x__597_
                     ; line_unified = _x__598_
                     ; word_old = _x__599_
                     ; word_new = _x__600_
                     ; location_style = _x__601_
                     ; warn_if_no_trailing_newline_in_both = _x__602_
                     })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let default__639_ : bool = warn_if_no_trailing_newline_in_both_default
         and default__640_ : Format.Location_style.t = Format.Location_style.Diff in
         let error_source__638_ = "configuration.ml.before-ppx.On_disk.V1.t" in
         fun x__641_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__638_
             ~fields:
               (Field
                  { name = "dont_produce_unified_lines"
                  ; kind = Sexp_option
                  ; conv = bool_of_sexp
                  ; rest =
                      Field
                        { name = "dont_overwrite_word_old_word_new"
                        ; kind = Sexp_option
                        ; conv = bool_of_sexp
                        ; rest =
                            Field
                              { name = "config_path"
                              ; kind = Sexp_option
                              ; conv = string_of_sexp
                              ; rest =
                                  Field
                                    { name = "context"
                                    ; kind = Sexp_option
                                    ; conv = int_of_sexp
                                    ; rest =
                                        Field
                                          { name = "line_big_enough"
                                          ; kind = Sexp_option
                                          ; conv = int_of_sexp
                                          ; rest =
                                              Field
                                                { name = "word_big_enough"
                                                ; kind = Sexp_option
                                                ; conv = int_of_sexp
                                                ; rest =
                                                    Field
                                                      { name = "unrefined"
                                                      ; kind = Sexp_option
                                                      ; conv = bool_of_sexp
                                                      ; rest =
                                                          Field
                                                            { name = "keep_whitespace"
                                                            ; kind = Sexp_option
                                                            ; conv = bool_of_sexp
                                                            ; rest =
                                                                Field
                                                                  { name =
                                                                      "split_long_lines"
                                                                  ; kind = Sexp_option
                                                                  ; conv = bool_of_sexp
                                                                  ; rest =
                                                                      Field
                                                                        { name =
                                                                            "interleave"
                                                                        ; kind =
                                                                            Sexp_option
                                                                        ; conv =
                                                                            bool_of_sexp
                                                                        ; rest =
                                                                            Field
                                                                              { name =
                                                                                  "assume_text"
                                                                              ; kind =
                                                                                  Sexp_option
                                                                              ; conv =
                                                                                  bool_of_sexp
                                                                              ; rest =
                                                                                  Field
                                                                                    { name =
                                                                                        "quiet"
                                                                                    ; kind =
                                                                                        Sexp_option
                                                                                    ; conv =
                                                                                        bool_of_sexp
                                                                                    ; rest =
                                                                                        Field
                                                                                          { 
                                                                                          name =
                                                                                          "shallow"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "double_check"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "mask_uniques"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "html"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "alt_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          string_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "hunk"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Hunk
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_same"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_unified"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_old"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_new"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Rule
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "location_style"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__640_)
                                                                                          ; 
                                                                                          conv =
                                                                                          Format
                                                                                          .Location_style
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "warn_if_no_trailing_newline_in_both"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__639_)
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "dont_produce_unified_lines" -> 0
               | "dont_overwrite_word_old_word_new" -> 1
               | "config_path" -> 2
               | "context" -> 3
               | "line_big_enough" -> 4
               | "word_big_enough" -> 5
               | "unrefined" -> 6
               | "keep_whitespace" -> 7
               | "split_long_lines" -> 8
               | "interleave" -> 9
               | "assume_text" -> 10
               | "quiet" -> 11
               | "shallow" -> 12
               | "double_check" -> 13
               | "mask_uniques" -> 14
               | "html" -> 15
               | "alt_old" -> 16
               | "alt_new" -> 17
               | "header_old" -> 18
               | "header_new" -> 19
               | "hunk" -> 20
               | "line_same" -> 21
               | "line_old" -> 22
               | "line_new" -> 23
               | "line_unified" -> 24
               | "word_old" -> 25
               | "word_new" -> 26
               | "location_style" -> 27
               | "warn_if_no_trailing_newline_in_both" -> 28
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:
               (fun
                 ( dont_produce_unified_lines
                 , ( dont_overwrite_word_old_word_new
                   , ( config_path
                     , ( context
                       , ( line_big_enough
                         , ( word_big_enough
                           , ( unrefined
                             , ( keep_whitespace
                               , ( split_long_lines
                                 , ( interleave
                                   , ( assume_text
                                     , ( quiet
                                       , ( shallow
                                         , ( double_check
                                           , ( mask_uniques
                                             , ( html
                                               , ( alt_old
                                                 , ( alt_new
                                                   , ( header_old
                                                     , ( header_new
                                                       , ( hunk
                                                         , ( line_same
                                                           , ( line_old
                                                             , ( line_new
                                                               , ( line_unified
                                                                 , ( word_old
                                                                   , ( word_new
                                                                     , ( location_style
                                                                       , ( warn_if_no_trailing_newline_in_both
                                                                         , () ) ) ) ) ) )
                                                             ) ) ) ) ) ) ) ) ) ) ) ) ) )
                                 ) ) ) ) ) ) ) ) ) ->
               ({ dont_produce_unified_lines
                ; dont_overwrite_word_old_word_new
                ; config_path
                ; context
                ; line_big_enough
                ; word_big_enough
                ; unrefined
                ; keep_whitespace
                ; split_long_lines
                ; interleave
                ; assume_text
                ; quiet
                ; shallow
                ; double_check
                ; mask_uniques
                ; html
                ; alt_old
                ; alt_new
                ; header_old
                ; header_new
                ; hunk
                ; line_same
                ; line_old
                ; line_new
                ; line_unified
                ; word_old
                ; word_new
                ; location_style
                ; warn_if_no_trailing_newline_in_both
                }
                : t))
             x__641_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (let default__752_ : Format.Location_style.t = Format.Location_style.Diff
         and default__757_ : bool = warn_if_no_trailing_newline_in_both_default in
         fun { dont_produce_unified_lines = dont_produce_unified_lines__643_
             ; dont_overwrite_word_old_word_new = dont_overwrite_word_old_word_new__647_
             ; config_path = config_path__651_
             ; context = context__655_
             ; line_big_enough = line_big_enough__659_
             ; word_big_enough = word_big_enough__663_
             ; unrefined = unrefined__667_
             ; keep_whitespace = keep_whitespace__671_
             ; split_long_lines = split_long_lines__675_
             ; interleave = interleave__679_
             ; assume_text = assume_text__683_
             ; quiet = quiet__687_
             ; shallow = shallow__691_
             ; double_check = double_check__695_
             ; mask_uniques = mask_uniques__699_
             ; html = html__703_
             ; alt_old = alt_old__707_
             ; alt_new = alt_new__711_
             ; header_old = header_old__715_
             ; header_new = header_new__719_
             ; hunk = hunk__723_
             ; line_same = line_same__727_
             ; line_old = line_old__731_
             ; line_new = line_new__735_
             ; line_unified = line_unified__739_
             ; word_old = word_old__743_
             ; word_new = word_new__747_
             ; location_style = location_style__753_
             ; warn_if_no_trailing_newline_in_both =
                 warn_if_no_trailing_newline_in_both__758_
             } ->
           let bnds__642_ = ([] : _ Stdlib.List.t) in
           let bnds__642_ =
             if
               (fun (a__761_ : bool) ((b__762_ : bool) [@merlin.hide]) ->
                  (equal_bool a__761_ b__762_ [@merlin.hide]))
                 default__757_
                 warn_if_no_trailing_newline_in_both__758_
             then bnds__642_
             else (
               let arg__760_ = sexp_of_bool warn_if_no_trailing_newline_in_both__758_ in
               let bnd__759_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "warn_if_no_trailing_newline_in_both"; arg__760_ ]
               in
               (bnd__759_ :: bnds__642_ : _ Stdlib.List.t))
           in
           let bnds__642_ =
             if
               (fun (a__763_ : Format.Location_style.t)
                 ((b__764_ : Format.Location_style.t) [@merlin.hide]) ->
                  (Format.Location_style.equal a__763_ b__764_ [@merlin.hide]))
                 default__752_
                 location_style__753_
             then bnds__642_
             else (
               let arg__755_ = Format.Location_style.sexp_of_t location_style__753_ in
               let bnd__754_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "location_style"; arg__755_ ]
               in
               (bnd__754_ :: bnds__642_ : _ Stdlib.List.t))
           in
           let bnds__642_ =
             match word_new__747_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__748_ ->
               let arg__750_ = Rule.sexp_of_t v__748_ in
               let bnd__749_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_new"; arg__750_ ]
               in
               (bnd__749_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match word_old__743_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__744_ ->
               let arg__746_ = Rule.sexp_of_t v__744_ in
               let bnd__745_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_old"; arg__746_ ]
               in
               (bnd__745_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match line_unified__739_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__740_ ->
               let arg__742_ = Line_rule.sexp_of_t v__740_ in
               let bnd__741_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_unified"; arg__742_ ]
               in
               (bnd__741_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match line_new__735_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__736_ ->
               let arg__738_ = Line_rule.sexp_of_t v__736_ in
               let bnd__737_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_new"; arg__738_ ]
               in
               (bnd__737_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match line_old__731_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__732_ ->
               let arg__734_ = Line_rule.sexp_of_t v__732_ in
               let bnd__733_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_old"; arg__734_ ]
               in
               (bnd__733_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match line_same__727_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__728_ ->
               let arg__730_ = Line_rule.sexp_of_t v__728_ in
               let bnd__729_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same"; arg__730_ ]
               in
               (bnd__729_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match hunk__723_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__724_ ->
               let arg__726_ = Hunk.sexp_of_t v__724_ in
               let bnd__725_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hunk"; arg__726_ ]
               in
               (bnd__725_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match header_new__719_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__720_ ->
               let arg__722_ = Header.sexp_of_t v__720_ in
               let bnd__721_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_new"; arg__722_ ]
               in
               (bnd__721_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match header_old__715_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__716_ ->
               let arg__718_ = Header.sexp_of_t v__716_ in
               let bnd__717_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_old"; arg__718_ ]
               in
               (bnd__717_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match alt_new__711_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__712_ ->
               let arg__714_ = sexp_of_string v__712_ in
               let bnd__713_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_new"; arg__714_ ]
               in
               (bnd__713_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match alt_old__707_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__708_ ->
               let arg__710_ = sexp_of_string v__708_ in
               let bnd__709_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alt_old"; arg__710_ ]
               in
               (bnd__709_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match html__703_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__704_ ->
               let arg__706_ = sexp_of_bool v__704_ in
               let bnd__705_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "html"; arg__706_ ]
               in
               (bnd__705_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match mask_uniques__699_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__700_ ->
               let arg__702_ = sexp_of_bool v__700_ in
               let bnd__701_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mask_uniques"; arg__702_ ]
               in
               (bnd__701_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match double_check__695_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__696_ ->
               let arg__698_ = sexp_of_bool v__696_ in
               let bnd__697_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "double_check"; arg__698_ ]
               in
               (bnd__697_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match shallow__691_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__692_ ->
               let arg__694_ = sexp_of_bool v__692_ in
               let bnd__693_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shallow"; arg__694_ ]
               in
               (bnd__693_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match quiet__687_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__688_ ->
               let arg__690_ = sexp_of_bool v__688_ in
               let bnd__689_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "quiet"; arg__690_ ]
               in
               (bnd__689_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match assume_text__683_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__684_ ->
               let arg__686_ = sexp_of_bool v__684_ in
               let bnd__685_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "assume_text"; arg__686_ ]
               in
               (bnd__685_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match interleave__679_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__680_ ->
               let arg__682_ = sexp_of_bool v__680_ in
               let bnd__681_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "interleave"; arg__682_ ]
               in
               (bnd__681_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match split_long_lines__675_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__676_ ->
               let arg__678_ = sexp_of_bool v__676_ in
               let bnd__677_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "split_long_lines"; arg__678_ ]
               in
               (bnd__677_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match keep_whitespace__671_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__672_ ->
               let arg__674_ = sexp_of_bool v__672_ in
               let bnd__673_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keep_whitespace"; arg__674_ ]
               in
               (bnd__673_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match unrefined__667_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__668_ ->
               let arg__670_ = sexp_of_bool v__668_ in
               let bnd__669_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unrefined"; arg__670_ ]
               in
               (bnd__669_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match word_big_enough__663_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__664_ ->
               let arg__666_ = sexp_of_int v__664_ in
               let bnd__665_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_big_enough"; arg__666_ ]
               in
               (bnd__665_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match line_big_enough__659_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__660_ ->
               let arg__662_ = sexp_of_int v__660_ in
               let bnd__661_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_big_enough"; arg__662_ ]
               in
               (bnd__661_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match context__655_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__656_ ->
               let arg__658_ = sexp_of_int v__656_ in
               let bnd__657_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "context"; arg__658_ ]
               in
               (bnd__657_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match config_path__651_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__652_ ->
               let arg__654_ = sexp_of_string v__652_ in
               let bnd__653_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config_path"; arg__654_ ]
               in
               (bnd__653_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match dont_overwrite_word_old_word_new__647_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__648_ ->
               let arg__650_ = sexp_of_bool v__648_ in
               let bnd__649_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_overwrite_word_old_word_new"; arg__650_ ]
               in
               (bnd__649_ :: bnds__642_ : _ Stdlib.List.t)
           in
           let bnds__642_ =
             match dont_produce_unified_lines__643_ with
             | Stdlib.Option.None -> bnds__642_
             | Stdlib.Option.Some v__644_ ->
               let arg__646_ = sexp_of_bool v__644_ in
               let bnd__645_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "dont_produce_unified_lines"; arg__646_ ]
               in
               (bnd__645_ :: bnds__642_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__642_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_v2
          { dont_produce_unified_lines
          ; dont_overwrite_word_old_word_new
          ; config_path
          ; context
          ; line_big_enough
          ; word_big_enough
          ; unrefined
          ; keep_whitespace
          ; split_long_lines
          ; interleave
          ; assume_text
          ; quiet
          ; shallow
          ; double_check
          ; mask_uniques
          ; html
          ; alt_old
          ; alt_new
          ; header_old
          ; header_new
          ; hunk
          ; line_same
          ; line_old
          ; line_new
          ; line_unified
          ; word_old
          ; word_new
          ; location_style
          ; warn_if_no_trailing_newline_in_both
          }
      =
      { V2.dont_produce_unified_lines
      ; dont_overwrite_word_old_word_new
      ; config_path
      ; context
      ; line_big_enough
      ; word_big_enough
      ; keep_whitespace
      ; split_long_lines
      ; interleave
      ; assume_text
      ; quiet
      ; shallow
      ; double_check
      ; mask_uniques
      ; output =
          (match
             Option.value ~default:false html, Option.value ~default:false unrefined
           with
           | true, true -> `unrefined `html
           | true, false -> `html
           | false, true -> `unrefined `ansi
           | false, false -> `ansi)
      ; alt_old
      ; alt_new
      ; header_old
      ; header_new
      ; hunk
      ; line_same
      ; line_old
      ; line_new
      ; line_unified
      ; word_old
      ; word_new
      ; location_style
      ; warn_if_no_trailing_newline_in_both
      }
    ;;
  end

  module V0 = struct
    module Line_changed = struct
      type t =
        { prefix_old : Affix.t
        ; prefix_new : Affix.t
        }
      [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__766_ =
             "configuration.ml.before-ppx.On_disk.V0.Line_changed.t"
           in
           fun x__767_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__766_
               ~fields:
                 (Field
                    { name = "prefix_old"
                    ; kind = Required
                    ; conv = Affix.t_of_sexp
                    ; rest =
                        Field
                          { name = "prefix_new"
                          ; kind = Required
                          ; conv = Affix.t_of_sexp
                          ; rest = Empty
                          }
                    })
               ~index_of_field:(function
                 | "prefix_old" -> 0
                 | "prefix_new" -> 1
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (prefix_old, (prefix_new, ())) ->
                 ({ prefix_old; prefix_new } : t))
               x__767_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { prefix_old = prefix_old__769_; prefix_new = prefix_new__771_ } ->
             let bnds__768_ = ([] : _ Stdlib.List.t) in
             let bnds__768_ =
               let arg__772_ = Affix.sexp_of_t prefix_new__771_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_new"; arg__772_ ]
                :: bnds__768_
                : _ Stdlib.List.t)
             in
             let bnds__768_ =
               let arg__770_ = Affix.sexp_of_t prefix_old__769_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_old"; arg__770_ ]
                :: bnds__768_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__768_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Word_same = struct
      type t =
        { style_old : Format.Style.t list
        ; style_new : Format.Style.t list
        }
      [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__774_ =
             "configuration.ml.before-ppx.On_disk.V0.Word_same.t"
           in
           fun x__775_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__774_
               ~fields:
                 (Field
                    { name = "style_old"
                    ; kind = Required
                    ; conv = list_of_sexp Format.Style.t_of_sexp
                    ; rest =
                        Field
                          { name = "style_new"
                          ; kind = Required
                          ; conv = list_of_sexp Format.Style.t_of_sexp
                          ; rest = Empty
                          }
                    })
               ~index_of_field:(function
                 | "style_old" -> 0
                 | "style_new" -> 1
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:(fun (style_old, (style_new, ())) ->
                 ({ style_old; style_new } : t))
               x__775_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { style_old = style_old__777_; style_new = style_new__779_ } ->
             let bnds__776_ = ([] : _ Stdlib.List.t) in
             let bnds__776_ =
               let arg__780_ = sexp_of_list Format.Style.sexp_of_t style_new__779_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_new"; arg__780_ ]
                :: bnds__776_
                : _ Stdlib.List.t)
             in
             let bnds__776_ =
               let arg__778_ = sexp_of_list Format.Style.sexp_of_t style_old__777_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_old"; arg__778_ ]
                :: bnds__776_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__776_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Word_changed = struct
      type t =
        { style_old : Format.Style.t list
        ; style_new : Format.Style.t list
        ; prefix_old : Affix.t option [@sexp.option]
        ; suffix_old : Affix.t option [@sexp.option]
        ; prefix_new : Affix.t option [@sexp.option]
        ; suffix_new : Affix.t option [@sexp.option]
        }
      [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__782_ =
             "configuration.ml.before-ppx.On_disk.V0.Word_changed.t"
           in
           fun x__783_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__782_
               ~fields:
                 (Field
                    { name = "style_old"
                    ; kind = Required
                    ; conv = list_of_sexp Format.Style.t_of_sexp
                    ; rest =
                        Field
                          { name = "style_new"
                          ; kind = Required
                          ; conv = list_of_sexp Format.Style.t_of_sexp
                          ; rest =
                              Field
                                { name = "prefix_old"
                                ; kind = Sexp_option
                                ; conv = Affix.t_of_sexp
                                ; rest =
                                    Field
                                      { name = "suffix_old"
                                      ; kind = Sexp_option
                                      ; conv = Affix.t_of_sexp
                                      ; rest =
                                          Field
                                            { name = "prefix_new"
                                            ; kind = Sexp_option
                                            ; conv = Affix.t_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "suffix_new"
                                                  ; kind = Sexp_option
                                                  ; conv = Affix.t_of_sexp
                                                  ; rest = Empty
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "style_old" -> 0
                 | "style_new" -> 1
                 | "prefix_old" -> 2
                 | "suffix_old" -> 3
                 | "prefix_new" -> 4
                 | "suffix_new" -> 5
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( style_old
                   , ( style_new
                     , (prefix_old, (suffix_old, (prefix_new, (suffix_new, ())))) ) ) ->
                 ({ style_old; style_new; prefix_old; suffix_old; prefix_new; suffix_new }
                  : t))
               x__783_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { style_old = style_old__785_
               ; style_new = style_new__787_
               ; prefix_old = prefix_old__789_
               ; suffix_old = suffix_old__793_
               ; prefix_new = prefix_new__797_
               ; suffix_new = suffix_new__801_
               } ->
             let bnds__784_ = ([] : _ Stdlib.List.t) in
             let bnds__784_ =
               match suffix_new__801_ with
               | Stdlib.Option.None -> bnds__784_
               | Stdlib.Option.Some v__802_ ->
                 let arg__804_ = Affix.sexp_of_t v__802_ in
                 let bnd__803_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix_new"; arg__804_ ]
                 in
                 (bnd__803_ :: bnds__784_ : _ Stdlib.List.t)
             in
             let bnds__784_ =
               match prefix_new__797_ with
               | Stdlib.Option.None -> bnds__784_
               | Stdlib.Option.Some v__798_ ->
                 let arg__800_ = Affix.sexp_of_t v__798_ in
                 let bnd__799_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_new"; arg__800_ ]
                 in
                 (bnd__799_ :: bnds__784_ : _ Stdlib.List.t)
             in
             let bnds__784_ =
               match suffix_old__793_ with
               | Stdlib.Option.None -> bnds__784_
               | Stdlib.Option.Some v__794_ ->
                 let arg__796_ = Affix.sexp_of_t v__794_ in
                 let bnd__795_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix_old"; arg__796_ ]
                 in
                 (bnd__795_ :: bnds__784_ : _ Stdlib.List.t)
             in
             let bnds__784_ =
               match prefix_old__789_ with
               | Stdlib.Option.None -> bnds__784_
               | Stdlib.Option.Some v__790_ ->
                 let arg__792_ = Affix.sexp_of_t v__790_ in
                 let bnd__791_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_old"; arg__792_ ]
                 in
                 (bnd__791_ :: bnds__784_ : _ Stdlib.List.t)
             in
             let bnds__784_ =
               let arg__788_ = sexp_of_list Format.Style.sexp_of_t style_new__787_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_new"; arg__788_ ]
                :: bnds__784_
                : _ Stdlib.List.t)
             in
             let bnds__784_ =
               let arg__786_ = sexp_of_list Format.Style.sexp_of_t style_old__785_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_old"; arg__786_ ]
                :: bnds__784_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__784_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Old_header = struct
      type t =
        { style_old : Format.Style.t list option [@sexp.option]
        ; style_new : Format.Style.t list option [@sexp.option]
        ; prefix_old : Affix.t option [@sexp.option]
        ; suffix_old : Affix.t option [@sexp.option]
        ; prefix_new : Affix.t option [@sexp.option]
        ; suffix_new : Affix.t option [@sexp.option]
        }
      [@@deriving sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let t_of_sexp =
          (let error_source__806_ =
             "configuration.ml.before-ppx.On_disk.V0.Old_header.t"
           in
           fun x__807_ ->
             Sexplib0.Sexp_conv_record.record_of_sexp
               ~caller:error_source__806_
               ~fields:
                 (Field
                    { name = "style_old"
                    ; kind = Sexp_option
                    ; conv = list_of_sexp Format.Style.t_of_sexp
                    ; rest =
                        Field
                          { name = "style_new"
                          ; kind = Sexp_option
                          ; conv = list_of_sexp Format.Style.t_of_sexp
                          ; rest =
                              Field
                                { name = "prefix_old"
                                ; kind = Sexp_option
                                ; conv = Affix.t_of_sexp
                                ; rest =
                                    Field
                                      { name = "suffix_old"
                                      ; kind = Sexp_option
                                      ; conv = Affix.t_of_sexp
                                      ; rest =
                                          Field
                                            { name = "prefix_new"
                                            ; kind = Sexp_option
                                            ; conv = Affix.t_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "suffix_new"
                                                  ; kind = Sexp_option
                                                  ; conv = Affix.t_of_sexp
                                                  ; rest = Empty
                                                  }
                                            }
                                      }
                                }
                          }
                    })
               ~index_of_field:(function
                 | "style_old" -> 0
                 | "style_new" -> 1
                 | "prefix_old" -> 2
                 | "suffix_old" -> 3
                 | "prefix_new" -> 4
                 | "suffix_new" -> 5
                 | _ -> -1)
               ~allow_extra_fields:false
               ~create:
                 (fun
                   ( style_old
                   , ( style_new
                     , (prefix_old, (suffix_old, (prefix_new, (suffix_new, ())))) ) ) ->
                 ({ style_old; style_new; prefix_old; suffix_old; prefix_new; suffix_new }
                  : t))
               x__807_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (fun { style_old = style_old__809_
               ; style_new = style_new__813_
               ; prefix_old = prefix_old__817_
               ; suffix_old = suffix_old__821_
               ; prefix_new = prefix_new__825_
               ; suffix_new = suffix_new__829_
               } ->
             let bnds__808_ = ([] : _ Stdlib.List.t) in
             let bnds__808_ =
               match suffix_new__829_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__830_ ->
                 let arg__832_ = Affix.sexp_of_t v__830_ in
                 let bnd__831_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix_new"; arg__832_ ]
                 in
                 (bnd__831_ :: bnds__808_ : _ Stdlib.List.t)
             in
             let bnds__808_ =
               match prefix_new__825_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__826_ ->
                 let arg__828_ = Affix.sexp_of_t v__826_ in
                 let bnd__827_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_new"; arg__828_ ]
                 in
                 (bnd__827_ :: bnds__808_ : _ Stdlib.List.t)
             in
             let bnds__808_ =
               match suffix_old__821_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__822_ ->
                 let arg__824_ = Affix.sexp_of_t v__822_ in
                 let bnd__823_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suffix_old"; arg__824_ ]
                 in
                 (bnd__823_ :: bnds__808_ : _ Stdlib.List.t)
             in
             let bnds__808_ =
               match prefix_old__817_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__818_ ->
                 let arg__820_ = Affix.sexp_of_t v__818_ in
                 let bnd__819_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prefix_old"; arg__820_ ]
                 in
                 (bnd__819_ :: bnds__808_ : _ Stdlib.List.t)
             in
             let bnds__808_ =
               match style_new__813_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__814_ ->
                 let arg__816_ = sexp_of_list Format.Style.sexp_of_t v__814_ in
                 let bnd__815_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_new"; arg__816_ ]
                 in
                 (bnd__815_ :: bnds__808_ : _ Stdlib.List.t)
             in
             let bnds__808_ =
               match style_old__809_ with
               | Stdlib.Option.None -> bnds__808_
               | Stdlib.Option.Some v__810_ ->
                 let arg__812_ = sexp_of_list Format.Style.sexp_of_t v__810_ in
                 let bnd__811_ =
                   Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "style_old"; arg__812_ ]
                 in
                 (bnd__811_ :: bnds__808_ : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__808_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type t =
      { config_path : string option [@sexp.option]
      ; context : int option [@sexp.option]
      ; line_big_enough : int option [@sexp.option]
      ; word_big_enough : int option [@sexp.option]
      ; unrefined : bool option [@sexp.option]
      ; keep_whitespace : bool option [@sexp.option]
      ; split_long_lines : bool option [@sexp.option]
      ; interleave : bool option [@sexp.option]
      ; assume_text : bool option [@sexp.option]
      ; shallow : bool option [@sexp.option]
      ; quiet : bool option [@sexp.option]
      ; double_check : bool option [@sexp.option]
      ; hide_uniques : bool option [@sexp.option]
      ; header : Old_header.t option [@sexp.option]
      ; line_same : Format.Style.t list option [@sexp.option]
      ; line_same_prefix : Affix.t option [@sexp.option]
      ; line_changed : Line_changed.t option [@sexp.option]
      ; word_same : Word_same.t option [@sexp.option]
      ; word_changed : Word_changed.t option [@sexp.option]
      ; chunk : Hunk.t option [@sexp.option]
      ; location_style : Format.Location_style.t
            [@default Format.Location_style.Diff] [@sexp_drop_default.equal]
      ; warn_if_no_trailing_newline_in_both : bool
            [@default warn_if_no_trailing_newline_in_both_default]
            [@sexp_drop_default.equal]
      }
    [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let default__835_ : bool = warn_if_no_trailing_newline_in_both_default
         and default__836_ : Format.Location_style.t = Format.Location_style.Diff in
         let error_source__834_ = "configuration.ml.before-ppx.On_disk.V0.t" in
         fun x__837_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__834_
             ~fields:
               (Field
                  { name = "config_path"
                  ; kind = Sexp_option
                  ; conv = string_of_sexp
                  ; rest =
                      Field
                        { name = "context"
                        ; kind = Sexp_option
                        ; conv = int_of_sexp
                        ; rest =
                            Field
                              { name = "line_big_enough"
                              ; kind = Sexp_option
                              ; conv = int_of_sexp
                              ; rest =
                                  Field
                                    { name = "word_big_enough"
                                    ; kind = Sexp_option
                                    ; conv = int_of_sexp
                                    ; rest =
                                        Field
                                          { name = "unrefined"
                                          ; kind = Sexp_option
                                          ; conv = bool_of_sexp
                                          ; rest =
                                              Field
                                                { name = "keep_whitespace"
                                                ; kind = Sexp_option
                                                ; conv = bool_of_sexp
                                                ; rest =
                                                    Field
                                                      { name = "split_long_lines"
                                                      ; kind = Sexp_option
                                                      ; conv = bool_of_sexp
                                                      ; rest =
                                                          Field
                                                            { name = "interleave"
                                                            ; kind = Sexp_option
                                                            ; conv = bool_of_sexp
                                                            ; rest =
                                                                Field
                                                                  { name = "assume_text"
                                                                  ; kind = Sexp_option
                                                                  ; conv = bool_of_sexp
                                                                  ; rest =
                                                                      Field
                                                                        { name = "shallow"
                                                                        ; kind =
                                                                            Sexp_option
                                                                        ; conv =
                                                                            bool_of_sexp
                                                                        ; rest =
                                                                            Field
                                                                              { name =
                                                                                  "quiet"
                                                                              ; kind =
                                                                                  Sexp_option
                                                                              ; conv =
                                                                                  bool_of_sexp
                                                                              ; rest =
                                                                                  Field
                                                                                    { name =
                                                                                        "double_check"
                                                                                    ; kind =
                                                                                        Sexp_option
                                                                                    ; conv =
                                                                                        bool_of_sexp
                                                                                    ; rest =
                                                                                        Field
                                                                                          { 
                                                                                          name =
                                                                                          "hide_uniques"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "header"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Old_header
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_same"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          list_of_sexp
                                                                                          Format
                                                                                          .Style
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_same_prefix"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Affix
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "line_changed"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Line_changed
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_same"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Word_same
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "word_changed"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Word_changed
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "chunk"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Hunk
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "location_style"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__836_)
                                                                                          ; 
                                                                                          conv =
                                                                                          Format
                                                                                          .Location_style
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "warn_if_no_trailing_newline_in_both"
                                                                                          ; 
                                                                                          kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__835_)
                                                                                          ; 
                                                                                          conv =
                                                                                          bool_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                          }
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  })
             ~index_of_field:(function
               | "config_path" -> 0
               | "context" -> 1
               | "line_big_enough" -> 2
               | "word_big_enough" -> 3
               | "unrefined" -> 4
               | "keep_whitespace" -> 5
               | "split_long_lines" -> 6
               | "interleave" -> 7
               | "assume_text" -> 8
               | "shallow" -> 9
               | "quiet" -> 10
               | "double_check" -> 11
               | "hide_uniques" -> 12
               | "header" -> 13
               | "line_same" -> 14
               | "line_same_prefix" -> 15
               | "line_changed" -> 16
               | "word_same" -> 17
               | "word_changed" -> 18
               | "chunk" -> 19
               | "location_style" -> 20
               | "warn_if_no_trailing_newline_in_both" -> 21
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:
               (fun
                 ( config_path
                 , ( context
                   , ( line_big_enough
                     , ( word_big_enough
                       , ( unrefined
                         , ( keep_whitespace
                           , ( split_long_lines
                             , ( interleave
                               , ( assume_text
                                 , ( shallow
                                   , ( quiet
                                     , ( double_check
                                       , ( hide_uniques
                                         , ( header
                                           , ( line_same
                                             , ( line_same_prefix
                                               , ( line_changed
                                                 , ( word_same
                                                   , ( word_changed
                                                     , ( chunk
                                                       , ( location_style
                                                         , ( warn_if_no_trailing_newline_in_both
                                                           , () ) ) ) ) ) ) ) ) ) ) ) ) )
                                 ) ) ) ) ) ) ) ) ) ->
               ({ config_path
                ; context
                ; line_big_enough
                ; word_big_enough
                ; unrefined
                ; keep_whitespace
                ; split_long_lines
                ; interleave
                ; assume_text
                ; shallow
                ; quiet
                ; double_check
                ; hide_uniques
                ; header
                ; line_same
                ; line_same_prefix
                ; line_changed
                ; word_same
                ; word_changed
                ; chunk
                ; location_style
                ; warn_if_no_trailing_newline_in_both
                }
                : t))
             x__837_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (let default__920_ : Format.Location_style.t = Format.Location_style.Diff
         and default__925_ : bool = warn_if_no_trailing_newline_in_both_default in
         fun { config_path = config_path__839_
             ; context = context__843_
             ; line_big_enough = line_big_enough__847_
             ; word_big_enough = word_big_enough__851_
             ; unrefined = unrefined__855_
             ; keep_whitespace = keep_whitespace__859_
             ; split_long_lines = split_long_lines__863_
             ; interleave = interleave__867_
             ; assume_text = assume_text__871_
             ; shallow = shallow__875_
             ; quiet = quiet__879_
             ; double_check = double_check__883_
             ; hide_uniques = hide_uniques__887_
             ; header = header__891_
             ; line_same = line_same__895_
             ; line_same_prefix = line_same_prefix__899_
             ; line_changed = line_changed__903_
             ; word_same = word_same__907_
             ; word_changed = word_changed__911_
             ; chunk = chunk__915_
             ; location_style = location_style__921_
             ; warn_if_no_trailing_newline_in_both =
                 warn_if_no_trailing_newline_in_both__926_
             } ->
           let bnds__838_ = ([] : _ Stdlib.List.t) in
           let bnds__838_ =
             if
               (fun (a__929_ : bool) ((b__930_ : bool) [@merlin.hide]) ->
                  (equal_bool a__929_ b__930_ [@merlin.hide]))
                 default__925_
                 warn_if_no_trailing_newline_in_both__926_
             then bnds__838_
             else (
               let arg__928_ = sexp_of_bool warn_if_no_trailing_newline_in_both__926_ in
               let bnd__927_ =
                 Sexplib0.Sexp.List
                   [ Sexplib0.Sexp.Atom "warn_if_no_trailing_newline_in_both"; arg__928_ ]
               in
               (bnd__927_ :: bnds__838_ : _ Stdlib.List.t))
           in
           let bnds__838_ =
             if
               (fun (a__931_ : Format.Location_style.t)
                 ((b__932_ : Format.Location_style.t) [@merlin.hide]) ->
                  (Format.Location_style.equal a__931_ b__932_ [@merlin.hide]))
                 default__920_
                 location_style__921_
             then bnds__838_
             else (
               let arg__923_ = Format.Location_style.sexp_of_t location_style__921_ in
               let bnd__922_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "location_style"; arg__923_ ]
               in
               (bnd__922_ :: bnds__838_ : _ Stdlib.List.t))
           in
           let bnds__838_ =
             match chunk__915_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__916_ ->
               let arg__918_ = Hunk.sexp_of_t v__916_ in
               let bnd__917_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "chunk"; arg__918_ ]
               in
               (bnd__917_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match word_changed__911_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__912_ ->
               let arg__914_ = Word_changed.sexp_of_t v__912_ in
               let bnd__913_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_changed"; arg__914_ ]
               in
               (bnd__913_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match word_same__907_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__908_ ->
               let arg__910_ = Word_same.sexp_of_t v__908_ in
               let bnd__909_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_same"; arg__910_ ]
               in
               (bnd__909_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match line_changed__903_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__904_ ->
               let arg__906_ = Line_changed.sexp_of_t v__904_ in
               let bnd__905_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_changed"; arg__906_ ]
               in
               (bnd__905_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match line_same_prefix__899_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__900_ ->
               let arg__902_ = Affix.sexp_of_t v__900_ in
               let bnd__901_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same_prefix"; arg__902_ ]
               in
               (bnd__901_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match line_same__895_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__896_ ->
               let arg__898_ = sexp_of_list Format.Style.sexp_of_t v__896_ in
               let bnd__897_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same"; arg__898_ ]
               in
               (bnd__897_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match header__891_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__892_ ->
               let arg__894_ = Old_header.sexp_of_t v__892_ in
               let bnd__893_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header"; arg__894_ ]
               in
               (bnd__893_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match hide_uniques__887_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__888_ ->
               let arg__890_ = sexp_of_bool v__888_ in
               let bnd__889_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hide_uniques"; arg__890_ ]
               in
               (bnd__889_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match double_check__883_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__884_ ->
               let arg__886_ = sexp_of_bool v__884_ in
               let bnd__885_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "double_check"; arg__886_ ]
               in
               (bnd__885_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match quiet__879_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__880_ ->
               let arg__882_ = sexp_of_bool v__880_ in
               let bnd__881_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "quiet"; arg__882_ ]
               in
               (bnd__881_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match shallow__875_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__876_ ->
               let arg__878_ = sexp_of_bool v__876_ in
               let bnd__877_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shallow"; arg__878_ ]
               in
               (bnd__877_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match assume_text__871_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__872_ ->
               let arg__874_ = sexp_of_bool v__872_ in
               let bnd__873_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "assume_text"; arg__874_ ]
               in
               (bnd__873_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match interleave__867_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__868_ ->
               let arg__870_ = sexp_of_bool v__868_ in
               let bnd__869_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "interleave"; arg__870_ ]
               in
               (bnd__869_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match split_long_lines__863_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__864_ ->
               let arg__866_ = sexp_of_bool v__864_ in
               let bnd__865_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "split_long_lines"; arg__866_ ]
               in
               (bnd__865_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match keep_whitespace__859_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__860_ ->
               let arg__862_ = sexp_of_bool v__860_ in
               let bnd__861_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keep_whitespace"; arg__862_ ]
               in
               (bnd__861_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match unrefined__855_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__856_ ->
               let arg__858_ = sexp_of_bool v__856_ in
               let bnd__857_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unrefined"; arg__858_ ]
               in
               (bnd__857_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match word_big_enough__851_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__852_ ->
               let arg__854_ = sexp_of_int v__852_ in
               let bnd__853_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_big_enough"; arg__854_ ]
               in
               (bnd__853_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match line_big_enough__847_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__848_ ->
               let arg__850_ = sexp_of_int v__848_ in
               let bnd__849_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_big_enough"; arg__850_ ]
               in
               (bnd__849_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match context__843_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__844_ ->
               let arg__846_ = sexp_of_int v__844_ in
               let bnd__845_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "context"; arg__846_ ]
               in
               (bnd__845_ :: bnds__838_ : _ Stdlib.List.t)
           in
           let bnds__838_ =
             match config_path__839_ with
             | Stdlib.Option.None -> bnds__838_
             | Stdlib.Option.Some v__840_ ->
               let arg__842_ = sexp_of_string v__840_ in
               let bnd__841_ =
                 Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config_path"; arg__842_ ]
               in
               (bnd__841_ :: bnds__838_ : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__838_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_v1 t =
      { V1.config_path = t.config_path
      ; context = t.context
      ; line_big_enough = t.line_big_enough
      ; word_big_enough = t.word_big_enough
      ; unrefined = t.unrefined
      ; dont_produce_unified_lines = None
      ; dont_overwrite_word_old_word_new = None
      ; keep_whitespace = t.keep_whitespace
      ; interleave = t.interleave
      ; assume_text = t.assume_text
      ; split_long_lines = t.split_long_lines
      ; quiet = t.quiet
      ; shallow = t.shallow
      ; double_check = t.double_check
      ; mask_uniques = t.hide_uniques
      ; html = None
      ; alt_old = None
      ; alt_new = None
      ; header_old =
          Option.map t.header ~f:(fun header ->
            { Rule.style = header.Old_header.style_old
            ; prefix = header.Old_header.prefix_old
            ; suffix = header.Old_header.suffix_old
            })
      ; header_new =
          Option.map t.header ~f:(fun header ->
            { Rule.style = header.Old_header.style_new
            ; prefix = header.Old_header.prefix_new
            ; suffix = header.Old_header.suffix_new
            })
      ; hunk = t.chunk
      ; line_same =
          Some
            { Line_rule.default with
              Line_rule.style = t.line_same
            ; prefix = t.line_same_prefix
            ; word_same =
                Option.map t.word_same ~f:(fun word_same -> word_same.Word_same.style_old)
            }
      ; line_old =
          Option.map t.line_changed ~f:(fun line_changed ->
            { Line_rule.default with
              Line_rule.style =
                Option.map t.word_changed ~f:(fun word_changed ->
                  word_changed.Word_changed.style_old)
            ; Line_rule.prefix = Some line_changed.Line_changed.prefix_old
            ; word_same =
                Option.map t.word_same ~f:(fun word_same -> word_same.Word_same.style_old)
            })
      ; line_new =
          Option.map t.line_changed ~f:(fun line_changed ->
            { Line_rule.default with
              Line_rule.style =
                Option.map t.word_changed ~f:(fun word_changed ->
                  word_changed.Word_changed.style_new)
            ; Line_rule.prefix = Some line_changed.Line_changed.prefix_new
            ; word_same =
                Option.map t.word_same ~f:(fun word_same -> word_same.Word_same.style_new)
            })
      ; line_unified = None
      ; word_old = None
      ; word_new = None
      ; location_style = t.location_style
      ; warn_if_no_trailing_newline_in_both = t.warn_if_no_trailing_newline_in_both
      }
    ;;
  end

  type t = V3.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (V3.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let t_of_sexp sexp =
    match V3.t_of_sexp sexp with
    | v3 -> v3
    | exception as_v3_exn ->
      (match V2.t_of_sexp sexp with
       | v2 -> V2.to_v3 v2
       | exception as_v2_exn ->
         (match V1.t_of_sexp sexp with
          | v1 -> V2.to_v3 (V1.to_v2 v1)
          | exception as_v1_exn ->
            (match V0.t_of_sexp sexp with
             | v0 -> V2.to_v3 (V1.to_v2 (V0.to_v1 v0))
             | exception as_v0_exn ->
               raise_s
                 (let ppx_sexp_message () =
                    Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                          "Patdiff.Configuration.On_disk.t_of_sexp: invalid config"
                      ; Ppx_sexp_conv_lib.Sexp.List
                          [ Ppx_sexp_conv_lib.Sexp.Atom "as_v3_exn"
                          ; (sexp_of_exn [@merlin.hide]) as_v3_exn
                          ]
                      ; Ppx_sexp_conv_lib.Sexp.List
                          [ Ppx_sexp_conv_lib.Sexp.Atom "as_v2_exn"
                          ; (sexp_of_exn [@merlin.hide]) as_v2_exn
                          ]
                      ; Ppx_sexp_conv_lib.Sexp.List
                          [ Ppx_sexp_conv_lib.Sexp.Atom "as_v1_exn"
                          ; (sexp_of_exn [@merlin.hide]) as_v1_exn
                          ]
                      ; Ppx_sexp_conv_lib.Sexp.List
                          [ Ppx_sexp_conv_lib.Sexp.Atom "as_v0_exn"
                          ; (sexp_of_exn [@merlin.hide]) as_v0_exn
                          ]
                      ]
                      [@@ocaml.inline never]
                      [@@ocaml.local never]
                      [@@ocaml.specialise never]
                  in
                  (ppx_sexp_message () [@nontail])))))
  ;;
end

let parse
      ({ dont_produce_unified_lines
       ; dont_overwrite_word_old_word_new
       ; config_path = _
       ; context
       ; line_big_enough
       ; word_big_enough
       ; keep_whitespace
       ; find_moves
       ; split_long_lines
       ; interleave
       ; assume_text
       ; quiet
       ; shallow
       ; double_check
       ; mask_uniques
       ; output
       ; alt_old
       ; alt_new
       ; header_old
       ; header_new
       ; hunk
       ; line_same
       ; line_old
       ; line_new
       ; line_unified
       ; line_from_old
       ; line_to_new
       ; line_removed_in_move
       ; line_added_in_move
       ; line_unified_in_move
       ; word_old
       ; word_new
       ; location_style
       ; warn_if_no_trailing_newline_in_both
       } :
        On_disk.t)
  =
  let default_true = Option.value ~default:true in
  let default_false = Option.value ~default:false in
  let default_rule = Option.value ~default:On_disk.Line_rule.default in
  let line_same = default_rule line_same in
  let line_prev = default_rule line_old in
  let line_next = default_rule line_new in
  let line_unified = default_rule line_unified in
  let line_from_prev = default_rule line_from_old in
  let line_to_next = default_rule line_to_new in
  let line_removed_in_move = default_rule line_removed_in_move in
  let line_added_in_move = default_rule line_added_in_move in
  let line_unified_in_move = default_rule line_unified_in_move in
  let min_width =
    Option.value_exn
      (List.max_elt
         ~compare:Int.compare
         (List.map
            ~f:(fun line -> On_disk.Affix.length line.prefix)
            [ line_same
            ; line_prev
            ; line_next
            ; line_unified
            ; line_from_prev
            ; line_to_next
            ; line_removed_in_move
            ; line_added_in_move
            ]))
  in
  let create_line (line : On_disk.Line_rule.t) =
    Format.Rule.create
      (Option.value ~default:[] line.style)
      ~pre:
        (On_disk.Affix.to_internal
           ~min_width
           (Option.value ~default:On_disk.Affix.blank line.prefix))
  in
  let create_word_same (line : On_disk.Line_rule.t) =
    Format.Rule.create (Option.value ~default:[] line.word_same)
  in
  let create_word ~(line_rule : On_disk.Line_rule.t) opt =
    let rule =
      if default_false dont_overwrite_word_old_word_new
      then Option.value ~default:On_disk.Rule.blank opt
      else { On_disk.Rule.blank with style = line_rule.style }
    in
    On_disk.Rule.to_internal rule
  in
  let create_header h_opt prefix =
    On_disk.Header.to_internal
      (Option.value ~default:On_disk.Rule.blank h_opt)
      ~default:prefix
  in
  create_exn
    ~rules:
      { Format.Rules.line_same = create_line line_same
      ; line_prev = create_line line_prev
      ; line_next = create_line line_next
      ; line_unified = create_line line_unified
      ; word_same_prev = create_word_same line_prev
      ; word_same_next = create_word_same line_next
      ; word_same_unified = create_word_same line_unified
      ; word_same_unified_in_move =
          Format.Rule.create
            (Option.value_map
               ~default:[]
               ~f:(fun rule -> Option.value ~default:[] rule.style)
               line_to_new)
      ; word_prev = create_word ~line_rule:line_prev word_old
      ; word_next = create_word ~line_rule:line_next word_new
      ; hunk = On_disk.Hunk.to_internal (Option.value hunk ~default:On_disk.Rule.blank)
      ; header_prev = create_header header_old "---"
      ; header_next = create_header header_new "+++"
      ; moved_from_prev = create_line line_from_prev
      ; moved_to_next = create_line line_to_next
      ; removed_in_move = create_line line_removed_in_move
      ; added_in_move = create_line line_added_in_move
      ; line_unified_in_move = create_line line_unified_in_move
      }
    ~output:
      (match output with
       | `ascii -> Output.Ascii
       | `unrefined `html | `html -> Html
       | `unrefined `ansi | `ansi -> Ansi)
    ~context:(Option.value ~default:(-1) context)
    ~word_big_enough:(Option.value ~default:default_word_big_enough word_big_enough)
    ~line_big_enough:(Option.value ~default:default_line_big_enough line_big_enough)
    ~unrefined:
      (match output with
       | `unrefined _ | `ascii -> true
       | _ -> false)
    ~produce_unified_lines:(not (default_false dont_produce_unified_lines))
    ~float_tolerance:None
    ~keep_ws:(default_false keep_whitespace)
    ~find_moves:(default_false find_moves)
    ~split_long_lines:(default_false split_long_lines)
    ~interleave:(default_true interleave)
    ~assume_text:(default_false assume_text)
    ~shallow:(default_false shallow)
    ~quiet:(default_false quiet)
    ~double_check:(default_false double_check)
    ~mask_uniques:(default_false mask_uniques)
    ~prev_alt:alt_old
    ~next_alt:alt_new
    ~location_style
    ~warn_if_no_trailing_newline_in_both
;;

let dark_bg =
  lazy
    (let sexp =
       Sexp.of_string
         {|
((context 8)
 (line_same ())
 (line_changed
  ((prefix_old ((text "-|") (style (Bold (Fg Red)))))
   (prefix_new ((text "+|") (style (Bold (Fg Green)))))))
 (word_same ((style_old ())
             (style_new ())))
 (word_changed ((style_old (Bold Underline (Fg Red)))
                (style_new ((Fg Green)))))
 (chunk
  ((prefix ((text "@@@@@@@@@@ ") (style (Bold (Fg blue)))))
   (suffix ((text " @@@@@@@@@@") (style (Bold (Fg blue)))))
   (style (Bold (Fg blue)))))
 )|}
     in
     parse
       (On_disk.V2.to_v3
          (On_disk.V1.to_v2 (On_disk.V0.to_v1 (On_disk.V0.t_of_sexp sexp)))))
;;

let light_bg =
  lazy
    (let sexp =
       Sexp.of_string
         {|
((context 8)
 (line_same (dim))
 (line_changed ((prefix_old ((text "-|") (style (bold (fg red)))))
                (prefix_new ((text "+|") (style (bold (fg green)))))))
 (word_same ((style_old ((bg white)))
             (style_new ((bg yellow)))))
 (word_changed ((style_old ((bg white) bold))
                (style_new ((bg yellow) bold))))
 )|}
     in
     parse
       (On_disk.V2.to_v3
          (On_disk.V1.to_v2 (On_disk.V0.to_v1 (On_disk.V0.t_of_sexp sexp)))))
;;

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"configuration.ml.before-ppx"
    ~line_number:717
    ~start_pos:0
    ~end_pos:243
    (fun () ->
       let module M = struct
         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<ignore (dark : t); ignore (light : t)>>")
             ~tags:[]
             ~filename:"configuration.ml.before-ppx"
             ~line_number:720
             ~start_pos:4
             ~end_pos:151
             (fun () ->
                (let dark = Lazy.force dark_bg in
                 let light = Lazy.force light_bg in
                 ignore (dark : t);
                 ignore (light : t));
                ())
         ;;
       end
       in
       ())
;;

let load_sexp_conv f conv = Result.try_with (fun () -> Sexp.load_sexp_conv_exn f conv)

let rec load_exn' ~set config_file =
  let config =
    match load_sexp_conv config_file On_disk.V3.t_of_sexp with
    | Ok c -> c
    | Error exn ->
      (match load_sexp_conv config_file On_disk.V2.t_of_sexp with
       | Ok c -> On_disk.V2.to_v3 c
       | Error _ ->
         let as_old_config =
           match load_sexp_conv config_file On_disk.V1.t_of_sexp with
           | Ok c -> Ok (On_disk.V2.to_v3 (On_disk.V1.to_v2 c))
           | Error _ ->
             (match load_sexp_conv config_file On_disk.V0.t_of_sexp with
              | Ok c -> Ok (On_disk.V2.to_v3 (On_disk.V1.to_v2 (On_disk.V0.to_v1 c)))
              | Error _ -> Error exn)
         in
         (match as_old_config with
          | Error _another_exn -> raise exn
          | Ok c ->
            (let new_file = config_file ^ ".new" in
             match Sys_unix.file_exists new_file with
             | `Yes | `Unknown -> ()
             | `No ->
               (try Sexp.save_hum new_file (On_disk.V3.sexp_of_t c) with
                | _ -> ()));
            c))
  in
  match config.config_path with
  | Some config_path ->
    if Set.mem set config_path
    then failwith "Cycle detected! file redirects to itself"
    else load_exn' ~set:(Set.add set config_path) config_path
  | None -> parse config
;;

let load_exn config_file = load_exn' ~set:String.Set.empty config_file

let load ?(quiet_errors = false) config_file =
  try Some (load_exn config_file) with
  | e ->
    if not quiet_errors
    then eprintf "Note: error loading %S: %s\n%!" config_file (Exn.to_string e);
    None
;;

let default_string =
  sprintf
    {|;; -*- scheme -*-
;; patdiff Configuration file

(
 (context %d)

 (line_same
  ((prefix ((text " |") (style ((bg bright_black) (fg black)))))))

 (line_old
  ((prefix ((text "-|") (style ((bg red)(fg black)))))
   (style ((fg red)))
   (word_same (dim))))

 (line_new
  ((prefix ((text "+|") (style ((bg green)(fg black)))))
   (style ((fg green)))))

 (line_unified
  ((prefix ((text "!|") (style ((bg yellow)(fg black)))))))

 (header_old
  ((prefix ((text "------ ") (style ((fg red)))))
   (style (bold))))

 (header_new
  ((prefix ((text "++++++ ") (style ((fg green)))))
   (style (bold))))

 (hunk
  ((prefix ((text "@|") (style ((bg bright_black) (fg black)))))
   (suffix ((text " ============================================================") (style ())))
   (style (bold))))

 (line_from_old
  ((prefix ((text "<|") (style ((bg magenta)(fg black)))))
   (style ((fg magenta)))))

 (line_to_new
  ((prefix ((text ">|") (style ((bg cyan)(fg black)))))
   (style ((fg cyan)))))

 (line_removed_in_move
  ((prefix ((text ">|") (style ((bg red)(fg black)))))
   (style ((fg red)))))

 (line_added_in_move
  ((prefix ((text ">|") (style ((bg green)(fg black)))))
   (style ((fg green)))))

 (line_unified_in_move
  ((prefix ((text ">|") (style ((bg yellow)(fg black)))))))
)|}
    default_context
;;

let () =
  Ppx_inline_test_lib.test_unit
    ~config:(module Inline_test_config)
    ~descr:(lazy "default Config.t sexp matches default Configuration.t")
    ~tags:[]
    ~filename:"configuration.ml.before-ppx"
    ~line_number:835
    ~start_pos:0
    ~end_pos:204
    (fun () ->
       (let default_from_disk =
          parse ((On_disk.t_of_sexp [@merlin.hide]) (Sexp.of_string default_string))
        in
        (fun ?(here = []) ?message ?equal t1 t2 ->
           let pos = "configuration.ml.before-ppx:837:13" in
           let sexpifier = (sexp_of_t [@merlin.hide]) in
           let comparator =
             (fun (a__933_ : t) ((b__934_ : t) [@merlin.hide]) ->
             (compare a__933_ b__934_ [@merlin.hide]))
             [@merlin.hide]
           in
           Ppx_assert_lib.Runtime.test_eq
             ~pos
             ~sexpifier
             ~comparator
             ~here
             ?message
             ?equal
             t1
             t2)
          default
          default_from_disk);
       ())
;;

let get_config ?filename () =
  let file =
    match filename with
    | Some "" -> None
    | Some f -> Some f
    | None ->
      Option.bind (Sys.getenv "HOME") ~f:(fun home ->
        let f = home ^/ ".patdiff" in
        match Sys_unix.file_exists f with
        | `Yes -> Some f
        | `No | `Unknown -> None)
  in
  match Option.bind file ~f:load with
  | Some c -> c
  | None -> default
;;

let save_default ~filename = Out_channel.write_all filename ~data:default_string

include struct
  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "default config parses")
      ~tags:[]
      ~filename:"configuration.ml.before-ppx"
      ~line_number:865
      ~start_pos:2
      ~end_pos:81
      (fun () ->
         ignore (get_config ~filename:"" () : t);
         ())
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "v1 html and unrefined propagate")
      ~tags:[]
      ~filename:"configuration.ml.before-ppx"
      ~line_number:867
      ~start_pos:2
      ~end_pos:550
      (fun () ->
         Quickcheck.test On_disk.V1.quickcheck_generator ~f:(fun v1 ->
           let { On_disk.V1.unrefined = unrefined_g; html = html_g; _ } = v1 in
           let config : t = parse (On_disk.t_of_sexp (On_disk.V1.sexp_of_t v1)) in
           (fun ?(here = []) ?message ?equal t1 t2 ->
              let pos = "configuration.ml.before-ppx:871:17" in
              let sexpifier = (Output.sexp_of_t [@merlin.hide]) in
              let comparator =
                (fun (a__935_ : Output.t) ((b__936_ : Output.t) [@merlin.hide]) ->
                (Output.compare a__935_ b__936_ [@merlin.hide]))
                [@merlin.hide]
              in
              Ppx_assert_lib.Runtime.test_eq
                ~pos
                ~sexpifier
                ~comparator
                ~here
                ?message
                ?equal
                t1
                t2)
             (output config)
             (match html_g with
              | Some true -> Html
              | None | Some false -> Ansi);
           (fun ?(here = []) ?message ?equal t1 t2 ->
              let pos = "configuration.ml.before-ppx:876:17" in
              let sexpifier = (sexp_of_bool [@merlin.hide]) in
              let comparator =
                (fun (a__937_ : bool) ((b__938_ : bool) [@merlin.hide]) ->
                (compare_bool a__937_ b__938_ [@merlin.hide]))
                [@merlin.hide]
              in
              Ppx_assert_lib.Runtime.test_eq
                ~pos
                ~sexpifier
                ~comparator
                ~here
                ?message
                ?equal
                t1
                t2)
             (unrefined config)
             (match unrefined_g with
              | None -> false
              | Some b -> b));
         ())
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:
        (lazy
          "v2 output field flows into both output and unrefined, needed so that 'refined \
           ascii', that would violate the invariant, is not a thing")
      ~tags:[]
      ~filename:"configuration.ml.before-ppx"
      ~line_number:883
      ~start_pos:2
      ~end_pos:665
      (fun () ->
         Quickcheck.test On_disk.V2.quickcheck_generator ~f:(fun v2 ->
           let { On_disk.V2.output = output_g; _ } = v2 in
           let config : t = parse (On_disk.t_of_sexp (On_disk.V2.sexp_of_t v2)) in
           (fun ?(here = []) ?message ?equal t1 t2 ->
              let pos = "configuration.ml.before-ppx:889:17" in
              let sexpifier =
                (fun (arg0__945_, arg1__946_) ->
                let res0__947_ = Output.sexp_of_t arg0__945_
                and res1__948_ = sexp_of_bool arg1__946_ in
                Sexplib0.Sexp.List [ res0__947_; res1__948_ ])
                [@merlin.hide]
              in
              let comparator =
                (fun (a__939_ : Output.t * bool)
                  ((b__940_ : Output.t * bool) [@merlin.hide]) ->
                ((let t__941_, t__942_ = a__939_ in
                  let t__943_, t__944_ = b__940_ in
                  match Output.compare t__941_ t__943_ with
                  | 0 -> compare_bool t__942_ t__944_
                  | n -> n)
                [@merlin.hide]))
                [@merlin.hide]
              in
              Ppx_assert_lib.Runtime.test_eq
                ~pos
                ~sexpifier
                ~comparator
                ~here
                ?message
                ?equal
                t1
                t2)
             (output config, unrefined config)
             (match output_g with
              | `html -> Html, false
              | `ansi -> Ansi, false
              | `ascii -> Ascii, true
              | `unrefined `html -> Html, true
              | `unrefined `ansi -> Ansi, true));
         ())
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
