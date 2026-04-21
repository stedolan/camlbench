let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"format.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "format.ml.before-ppx"
;;

open! Core
open! Import

module Color = struct
  module RGB6 : sig
    type t = private
      { r : int
      ; g : int
      ; b : int
      }
    [@@deriving compare, quickcheck, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create_exn : r:int -> g:int -> b:int -> t
  end = struct
    type t =
      { r : int
      ; g : int
      ; b : int
      }
    [@@deriving compare, quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__001_ b__002_ ->
           if Stdlib.( == ) a__001_ b__002_
           then 0
           else (
             match compare_int a__001_.r b__002_.r with
             | 0 ->
               (match compare_int a__001_.g b__002_.g with
                | 0 -> compare_int a__001_.b b__002_.b
                | n -> n)
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__012_ ~random:_random__013_ ->
             { r =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_int
                   ~size:_size__012_
                   ~random:_random__013_
             ; g =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_int
                   ~size:_size__012_
                   ~random:_random__013_
             ; b =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_int
                   ~size:_size__012_
                   ~random:_random__013_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__006_ ~size:_size__010_ ~hash:_hash__011_ ->
             let { r = _x__007_; g = _x__008_; b = _x__009_ } = _x__006_ in
             let _hash__011_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_int
                 _x__007_
                 ~size:_size__010_
                 ~hash:_hash__011_
             in
             let _hash__011_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_int
                 _x__008_
                 ~size:_size__010_
                 ~hash:_hash__011_
             in
             let _hash__011_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_int
                 _x__009_
                 ~size:_size__010_
                 ~hash:_hash__011_
             in
             _hash__011_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun { r = _x__003_; g = _x__004_; b = _x__005_ } ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_int
                      _x__003_)
                   ~f:(fun _x__003_ -> { r = _x__003_; g = _x__004_; b = _x__005_ })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_int
                      _x__004_)
                   ~f:(fun _x__004_ -> { r = _x__003_; g = _x__004_; b = _x__005_ })
               ; Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_int
                      _x__005_)
                   ~f:(fun _x__005_ -> { r = _x__003_; g = _x__004_; b = _x__005_ })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__015_ = "format.ml.before-ppx.Color.RGB6.t" in
         fun x__016_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__015_
             ~fields:
               (Field
                  { name = "r"
                  ; kind = Required
                  ; conv = int_of_sexp
                  ; rest =
                      Field
                        { name = "g"
                        ; kind = Required
                        ; conv = int_of_sexp
                        ; rest =
                            Field
                              { name = "b"
                              ; kind = Required
                              ; conv = int_of_sexp
                              ; rest = Empty
                              }
                        }
                  })
             ~index_of_field:(function
               | "r" -> 0
               | "g" -> 1
               | "b" -> 2
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (r, (g, (b, ()))) -> ({ r; g; b } : t))
             x__016_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { r = r__018_; g = g__020_; b = b__022_ } ->
           let bnds__017_ = ([] : _ Stdlib.List.t) in
           let bnds__017_ =
             let arg__023_ = sexp_of_int b__022_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "b"; arg__023_ ] :: bnds__017_
              : _ Stdlib.List.t)
           in
           let bnds__017_ =
             let arg__021_ = sexp_of_int g__020_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "g"; arg__021_ ] :: bnds__017_
              : _ Stdlib.List.t)
           in
           let bnds__017_ =
             let arg__019_ = sexp_of_int r__018_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "r"; arg__019_ ] :: bnds__017_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__017_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create_exn ~r ~g ~b =
      let check x = 0 <= x && x < 6 in
      if not (check r && check g && check b)
      then invalid_arg "RGB6 (r, g, b) -- expected (0 <= r, g, b < 6)";
      { r; g; b }
    ;;
  end

  module Gray24 : sig
    type t = private { level : int } [@@deriving compare, sexp, quickcheck]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
      include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create_exn : level:int -> t
  end = struct
    type t = { level : int } [@@deriving compare, quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__024_ b__025_ ->
           if Stdlib.( == ) a__024_ b__025_
           then 0
           else compare_int a__024_.level b__025_.level
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
          (fun ~size:_size__031_ ~random:_random__032_ ->
             { level =
                 Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                   quickcheck_generator_int
                   ~size:_size__031_
                   ~random:_random__032_
             })
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__027_ ~size:_size__029_ ~hash:_hash__030_ ->
             let { level = _x__028_ } = _x__027_ in
             let _hash__030_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 quickcheck_observer_int
                 _x__028_
                 ~size:_size__029_
                 ~hash:_hash__030_
             in
             _hash__030_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
          (fun { level = _x__026_ } ->
             Ppx_quickcheck_runtime.Base.Sequence.round_robin
               [ Ppx_quickcheck_runtime.Base.Sequence.map
                   (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                      quickcheck_shrinker_int
                      _x__026_)
                   ~f:(fun _x__026_ -> { level = _x__026_ })
               ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__034_ = "format.ml.before-ppx.Color.Gray24.t" in
         fun x__035_ ->
           Sexplib0.Sexp_conv_record.record_of_sexp
             ~caller:error_source__034_
             ~fields:
               (Field
                  { name = "level"; kind = Required; conv = int_of_sexp; rest = Empty })
             ~index_of_field:(function
               | "level" -> 0
               | _ -> -1)
             ~allow_extra_fields:false
             ~create:(fun (level, ()) -> ({ level } : t))
             x__035_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun { level = level__037_ } ->
           let bnds__036_ = ([] : _ Stdlib.List.t) in
           let bnds__036_ =
             let arg__038_ = sexp_of_int level__037_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "level"; arg__038_ ] :: bnds__036_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__036_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create_exn ~level =
      if not (0 <= level && level < 24)
      then invalid_arg "Gray24 level -- expected (0 <= level < 24)";
      { level }
    ;;
  end

  module T = struct
    type t =
      | Black
      | Red
      | Green
      | Yellow
      | Blue
      | Magenta
      | Cyan
      | White
      | Default
      | Gray
      | Bright_black
      | Bright_red
      | Bright_green
      | Bright_yellow
      | Bright_blue
      | Bright_magenta
      | Bright_cyan
      | Bright_white
      | RGB6 of RGB6.t
      | Gray24 of Gray24.t
    [@@deriving compare, quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__039_ b__040_ ->
           if Stdlib.( == ) a__039_ b__040_
           then 0
           else (
             match a__039_, b__040_ with
             | Black, Black -> 0
             | Black, _ -> -1
             | _, Black -> 1
             | Red, Red -> 0
             | Red, _ -> -1
             | _, Red -> 1
             | Green, Green -> 0
             | Green, _ -> -1
             | _, Green -> 1
             | Yellow, Yellow -> 0
             | Yellow, _ -> -1
             | _, Yellow -> 1
             | Blue, Blue -> 0
             | Blue, _ -> -1
             | _, Blue -> 1
             | Magenta, Magenta -> 0
             | Magenta, _ -> -1
             | _, Magenta -> 1
             | Cyan, Cyan -> 0
             | Cyan, _ -> -1
             | _, Cyan -> 1
             | White, White -> 0
             | White, _ -> -1
             | _, White -> 1
             | Default, Default -> 0
             | Default, _ -> -1
             | _, Default -> 1
             | Gray, Gray -> 0
             | Gray, _ -> -1
             | _, Gray -> 1
             | Bright_black, Bright_black -> 0
             | Bright_black, _ -> -1
             | _, Bright_black -> 1
             | Bright_red, Bright_red -> 0
             | Bright_red, _ -> -1
             | _, Bright_red -> 1
             | Bright_green, Bright_green -> 0
             | Bright_green, _ -> -1
             | _, Bright_green -> 1
             | Bright_yellow, Bright_yellow -> 0
             | Bright_yellow, _ -> -1
             | _, Bright_yellow -> 1
             | Bright_blue, Bright_blue -> 0
             | Bright_blue, _ -> -1
             | _, Bright_blue -> 1
             | Bright_magenta, Bright_magenta -> 0
             | Bright_magenta, _ -> -1
             | _, Bright_magenta -> 1
             | Bright_cyan, Bright_cyan -> 0
             | Bright_cyan, _ -> -1
             | _, Bright_cyan -> 1
             | Bright_white, Bright_white -> 0
             | Bright_white, _ -> -1
             | _, Bright_white -> 1
             | RGB6 _a__041_, RGB6 _b__042_ -> RGB6.compare _a__041_ _b__042_
             | RGB6 _, _ -> -1
             | _, RGB6 _ -> 1
             | Gray24 _a__043_, Gray24 _b__044_ -> Gray24.compare _a__043_ _b__044_)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
          [ ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__052_ ~random:_random__053_ -> Black) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__054_ ~random:_random__055_ -> Red) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__056_ ~random:_random__057_ -> Green) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__058_ ~random:_random__059_ -> Yellow) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__060_ ~random:_random__061_ -> Blue) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__062_ ~random:_random__063_ -> Magenta) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__064_ ~random:_random__065_ -> Cyan) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__066_ ~random:_random__067_ -> White) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__068_ ~random:_random__069_ -> Default) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__070_ ~random:_random__071_ -> Gray) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__072_ ~random:_random__073_ -> Bright_black) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__074_ ~random:_random__075_ -> Bright_red) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__076_ ~random:_random__077_ -> Bright_green) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__078_ ~random:_random__079_ -> Bright_yellow) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__080_ ~random:_random__081_ -> Bright_blue) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__082_ ~random:_random__083_ -> Bright_magenta) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__084_ ~random:_random__085_ -> Bright_cyan) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__086_ ~random:_random__087_ -> Bright_white) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__088_ ~random:_random__089_ ->
                   RGB6
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        RGB6.quickcheck_generator
                        ~size:_size__088_
                        ~random:_random__089_)) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__090_ ~random:_random__091_ ->
                   Gray24
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        Gray24.quickcheck_generator
                        ~size:_size__090_
                        ~random:_random__091_)) )
          ]
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__047_ ~size:_size__048_ ~hash:_hash__049_ ->
             match _x__047_ with
             | Black ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 0
               in
               _hash__049_
             | Red ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 1
               in
               _hash__049_
             | Green ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 2
               in
               _hash__049_
             | Yellow ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 3
               in
               _hash__049_
             | Blue ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 4
               in
               _hash__049_
             | Magenta ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 5
               in
               _hash__049_
             | Cyan ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 6
               in
               _hash__049_
             | White ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 7
               in
               _hash__049_
             | Default ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 8
               in
               _hash__049_
             | Gray ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 9
               in
               _hash__049_
             | Bright_black ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 10
               in
               _hash__049_
             | Bright_red ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 11
               in
               _hash__049_
             | Bright_green ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 12
               in
               _hash__049_
             | Bright_yellow ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 13
               in
               _hash__049_
             | Bright_blue ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 14
               in
               _hash__049_
             | Bright_magenta ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 15
               in
               _hash__049_
             | Bright_cyan ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 16
               in
               _hash__049_
             | Bright_white ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 17
               in
               _hash__049_
             | RGB6 _x__050_ ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 18
               in
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   RGB6.quickcheck_observer
                   _x__050_
                   ~size:_size__048_
                   ~hash:_hash__049_
               in
               _hash__049_
             | Gray24 _x__051_ ->
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__049_ 19
               in
               let _hash__049_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Gray24.quickcheck_observer
                   _x__051_
                   ~size:_size__048_
                   ~hash:_hash__049_
               in
               _hash__049_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
          | Black -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Red -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Green -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Yellow -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Blue -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Magenta -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Cyan -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | White -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Default -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Gray -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_black -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_red -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_green -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_yellow -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_blue -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_magenta -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_cyan -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Bright_white -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | RGB6 _x__045_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     RGB6.quickcheck_shrinker
                     _x__045_)
                  ~f:(fun _x__045_ -> RGB6 _x__045_)
              ]
          | Gray24 _x__046_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     Gray24.quickcheck_shrinker
                     _x__046_)
                  ~f:(fun _x__046_ -> Gray24 _x__046_)
              ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__094_ = "format.ml.before-ppx.Color.T.t" in
         function
         | Sexplib0.Sexp.Atom ("black" | "Black") -> Black
         | Sexplib0.Sexp.Atom ("red" | "Red") -> Red
         | Sexplib0.Sexp.Atom ("green" | "Green") -> Green
         | Sexplib0.Sexp.Atom ("yellow" | "Yellow") -> Yellow
         | Sexplib0.Sexp.Atom ("blue" | "Blue") -> Blue
         | Sexplib0.Sexp.Atom ("magenta" | "Magenta") -> Magenta
         | Sexplib0.Sexp.Atom ("cyan" | "Cyan") -> Cyan
         | Sexplib0.Sexp.Atom ("white" | "White") -> White
         | Sexplib0.Sexp.Atom ("default" | "Default") -> Default
         | Sexplib0.Sexp.Atom ("gray" | "Gray") -> Gray
         | Sexplib0.Sexp.Atom ("bright_black" | "Bright_black") -> Bright_black
         | Sexplib0.Sexp.Atom ("bright_red" | "Bright_red") -> Bright_red
         | Sexplib0.Sexp.Atom ("bright_green" | "Bright_green") -> Bright_green
         | Sexplib0.Sexp.Atom ("bright_yellow" | "Bright_yellow") -> Bright_yellow
         | Sexplib0.Sexp.Atom ("bright_blue" | "Bright_blue") -> Bright_blue
         | Sexplib0.Sexp.Atom ("bright_magenta" | "Bright_magenta") -> Bright_magenta
         | Sexplib0.Sexp.Atom ("bright_cyan" | "Bright_cyan") -> Bright_cyan
         | Sexplib0.Sexp.Atom ("bright_white" | "Bright_white") -> Bright_white
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("rGB6" | "RGB6") as _tag__097_) :: sexp_args__098_) as
           _sexp__096_ ->
           (match sexp_args__098_ with
            | arg0__099_ :: [] ->
              let res0__100_ = RGB6.t_of_sexp arg0__099_ in
              RGB6 res0__100_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__094_
                _tag__097_
                _sexp__096_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("gray24" | "Gray24") as _tag__102_) :: sexp_args__103_)
           as _sexp__101_ ->
           (match sexp_args__103_ with
            | arg0__104_ :: [] ->
              let res0__105_ = Gray24.t_of_sexp arg0__104_ in
              Gray24 res0__105_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__094_
                _tag__102_
                _sexp__101_)
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("black" | "Black") :: _) as sexp__095_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("red" | "Red") :: _) as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("green" | "Green") :: _) as sexp__095_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("yellow" | "Yellow") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("blue" | "Blue") :: _) as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("magenta" | "Magenta") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cyan" | "Cyan") :: _) as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("white" | "White") :: _) as sexp__095_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("default" | "Default") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("gray" | "Gray") :: _) as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_black" | "Bright_black") :: _)
           as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_red" | "Bright_red") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_green" | "Bright_green") :: _)
           as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_yellow" | "Bright_yellow") :: _)
           as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_blue" | "Bright_blue") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom ("bright_magenta" | "Bright_magenta") :: _) as sexp__095_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_cyan" | "Bright_cyan") :: _) as
           sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bright_white" | "Bright_white") :: _)
           as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.Atom ("rGB6" | "RGB6") as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.Atom ("gray24" | "Gray24") as sexp__095_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__094_ sexp__095_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__093_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__094_ sexp__093_
         | Sexplib0.Sexp.List [] as sexp__093_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__094_ sexp__093_
         | sexp__093_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__094_ sexp__093_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Black -> Sexplib0.Sexp.Atom "Black"
         | Red -> Sexplib0.Sexp.Atom "Red"
         | Green -> Sexplib0.Sexp.Atom "Green"
         | Yellow -> Sexplib0.Sexp.Atom "Yellow"
         | Blue -> Sexplib0.Sexp.Atom "Blue"
         | Magenta -> Sexplib0.Sexp.Atom "Magenta"
         | Cyan -> Sexplib0.Sexp.Atom "Cyan"
         | White -> Sexplib0.Sexp.Atom "White"
         | Default -> Sexplib0.Sexp.Atom "Default"
         | Gray -> Sexplib0.Sexp.Atom "Gray"
         | Bright_black -> Sexplib0.Sexp.Atom "Bright_black"
         | Bright_red -> Sexplib0.Sexp.Atom "Bright_red"
         | Bright_green -> Sexplib0.Sexp.Atom "Bright_green"
         | Bright_yellow -> Sexplib0.Sexp.Atom "Bright_yellow"
         | Bright_blue -> Sexplib0.Sexp.Atom "Bright_blue"
         | Bright_magenta -> Sexplib0.Sexp.Atom "Bright_magenta"
         | Bright_cyan -> Sexplib0.Sexp.Atom "Bright_cyan"
         | Bright_white -> Sexplib0.Sexp.Atom "Bright_white"
         | RGB6 arg0__106_ ->
           let res0__107_ = RGB6.sexp_of_t arg0__106_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "RGB6"; res0__107_ ]
         | Gray24 arg0__108_ ->
           let res0__109_ = Gray24.sexp_of_t arg0__108_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Gray24"; res0__109_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  include T
  include Comparable.Make (T)

  let rgb6_exn (r, g, b) = RGB6 (RGB6.create_exn ~r ~g ~b)
  let gray24_exn level = Gray24 (Gray24.create_exn ~level)
end

module Style = struct
  module T = struct
    type t =
      | Bold
      | Underline
      | Emph
      | Blink
      | Dim
      | Inverse
      | Hide
      | Reset
      | Foreground of Color.t
      | Fg of Color.t
      | Background of Color.t
      | Bg of Color.t
    [@@deriving compare, quickcheck, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__110_ b__111_ ->
           if Stdlib.( == ) a__110_ b__111_
           then 0
           else (
             match a__110_, b__111_ with
             | Bold, Bold -> 0
             | Bold, _ -> -1
             | _, Bold -> 1
             | Underline, Underline -> 0
             | Underline, _ -> -1
             | _, Underline -> 1
             | Emph, Emph -> 0
             | Emph, _ -> -1
             | _, Emph -> 1
             | Blink, Blink -> 0
             | Blink, _ -> -1
             | _, Blink -> 1
             | Dim, Dim -> 0
             | Dim, _ -> -1
             | _, Dim -> 1
             | Inverse, Inverse -> 0
             | Inverse, _ -> -1
             | _, Inverse -> 1
             | Hide, Hide -> 0
             | Hide, _ -> -1
             | _, Hide -> 1
             | Reset, Reset -> 0
             | Reset, _ -> -1
             | _, Reset -> 1
             | Foreground _a__112_, Foreground _b__113_ -> Color.compare _a__112_ _b__113_
             | Foreground _, _ -> -1
             | _, Foreground _ -> 1
             | Fg _a__114_, Fg _b__115_ -> Color.compare _a__114_ _b__115_
             | Fg _, _ -> -1
             | _, Fg _ -> 1
             | Background _a__116_, Background _b__117_ -> Color.compare _a__116_ _b__117_
             | Background _, _ -> -1
             | _, Background _ -> 1
             | Bg _a__118_, Bg _b__119_ -> Color.compare _a__118_ _b__119_)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let quickcheck_generator =
        Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
          [ ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__131_ ~random:_random__132_ -> Bold) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__133_ ~random:_random__134_ -> Underline) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__135_ ~random:_random__136_ -> Emph) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__137_ ~random:_random__138_ -> Blink) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__139_ ~random:_random__140_ -> Dim) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__141_ ~random:_random__142_ -> Inverse) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__143_ ~random:_random__144_ -> Hide) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__145_ ~random:_random__146_ -> Reset) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__147_ ~random:_random__148_ ->
                   Foreground
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        Color.quickcheck_generator
                        ~size:_size__147_
                        ~random:_random__148_)) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__149_ ~random:_random__150_ ->
                   Fg
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        Color.quickcheck_generator
                        ~size:_size__149_
                        ~random:_random__150_)) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__151_ ~random:_random__152_ ->
                   Background
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        Color.quickcheck_generator
                        ~size:_size__151_
                        ~random:_random__152_)) )
          ; ( 1.
            , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                (fun ~size:_size__153_ ~random:_random__154_ ->
                   Bg
                     (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                        Color.quickcheck_generator
                        ~size:_size__153_
                        ~random:_random__154_)) )
          ]
      ;;

      let _ = quickcheck_generator

      let quickcheck_observer =
        Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
          (fun _x__124_ ~size:_size__125_ ~hash:_hash__126_ ->
             match _x__124_ with
             | Bold ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 0
               in
               _hash__126_
             | Underline ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 1
               in
               _hash__126_
             | Emph ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 2
               in
               _hash__126_
             | Blink ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 3
               in
               _hash__126_
             | Dim ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 4
               in
               _hash__126_
             | Inverse ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 5
               in
               _hash__126_
             | Hide ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 6
               in
               _hash__126_
             | Reset ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 7
               in
               _hash__126_
             | Foreground _x__127_ ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 8
               in
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Color.quickcheck_observer
                   _x__127_
                   ~size:_size__125_
                   ~hash:_hash__126_
               in
               _hash__126_
             | Fg _x__128_ ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 9
               in
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Color.quickcheck_observer
                   _x__128_
                   ~size:_size__125_
                   ~hash:_hash__126_
               in
               _hash__126_
             | Background _x__129_ ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 10
               in
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Color.quickcheck_observer
                   _x__129_
                   ~size:_size__125_
                   ~hash:_hash__126_
               in
               _hash__126_
             | Bg _x__130_ ->
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base.hash_fold_int _hash__126_ 11
               in
               let _hash__126_ =
                 Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                   Color.quickcheck_observer
                   _x__130_
                   ~size:_size__125_
                   ~hash:_hash__126_
               in
               _hash__126_)
      ;;

      let _ = quickcheck_observer

      let quickcheck_shrinker =
        Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
          | Bold -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Underline -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Emph -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Blink -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Dim -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Inverse -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Hide -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Reset -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
          | Foreground _x__120_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     Color.quickcheck_shrinker
                     _x__120_)
                  ~f:(fun _x__120_ -> Foreground _x__120_)
              ]
          | Fg _x__121_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     Color.quickcheck_shrinker
                     _x__121_)
                  ~f:(fun _x__121_ -> Fg _x__121_)
              ]
          | Background _x__122_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     Color.quickcheck_shrinker
                     _x__122_)
                  ~f:(fun _x__122_ -> Background _x__122_)
              ]
          | Bg _x__123_ ->
            Ppx_quickcheck_runtime.Base.Sequence.round_robin
              [ Ppx_quickcheck_runtime.Base.Sequence.map
                  (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                     Color.quickcheck_shrinker
                     _x__123_)
                  ~f:(fun _x__123_ -> Bg _x__123_)
              ])
      ;;

      let _ = quickcheck_shrinker

      let t_of_sexp =
        (let error_source__157_ = "format.ml.before-ppx.Style.T.t" in
         function
         | Sexplib0.Sexp.Atom ("bold" | "Bold") -> Bold
         | Sexplib0.Sexp.Atom ("underline" | "Underline") -> Underline
         | Sexplib0.Sexp.Atom ("emph" | "Emph") -> Emph
         | Sexplib0.Sexp.Atom ("blink" | "Blink") -> Blink
         | Sexplib0.Sexp.Atom ("dim" | "Dim") -> Dim
         | Sexplib0.Sexp.Atom ("inverse" | "Inverse") -> Inverse
         | Sexplib0.Sexp.Atom ("hide" | "Hide") -> Hide
         | Sexplib0.Sexp.Atom ("reset" | "Reset") -> Reset
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("foreground" | "Foreground") as _tag__160_)
             :: sexp_args__161_) as _sexp__159_ ->
           (match sexp_args__161_ with
            | arg0__162_ :: [] ->
              let res0__163_ = Color.t_of_sexp arg0__162_ in
              Foreground res0__163_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__157_
                _tag__160_
                _sexp__159_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("fg" | "Fg") as _tag__165_) :: sexp_args__166_) as
           _sexp__164_ ->
           (match sexp_args__166_ with
            | arg0__167_ :: [] ->
              let res0__168_ = Color.t_of_sexp arg0__167_ in
              Fg res0__168_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__157_
                _tag__165_
                _sexp__164_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("background" | "Background") as _tag__170_)
             :: sexp_args__171_) as _sexp__169_ ->
           (match sexp_args__171_ with
            | arg0__172_ :: [] ->
              let res0__173_ = Color.t_of_sexp arg0__172_ in
              Background res0__173_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__157_
                _tag__170_
                _sexp__169_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("bg" | "Bg") as _tag__175_) :: sexp_args__176_) as
           _sexp__174_ ->
           (match sexp_args__176_ with
            | arg0__177_ :: [] ->
              let res0__178_ = Color.t_of_sexp arg0__177_ in
              Bg res0__178_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__157_
                _tag__175_
                _sexp__174_)
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("bold" | "Bold") :: _) as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("underline" | "Underline") :: _) as
           sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("emph" | "Emph") :: _) as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("blink" | "Blink") :: _) as sexp__158_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("dim" | "Dim") :: _) as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("inverse" | "Inverse") :: _) as
           sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("hide" | "Hide") :: _) as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("reset" | "Reset") :: _) as sexp__158_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.Atom ("foreground" | "Foreground") as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.Atom ("fg" | "Fg") as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.Atom ("background" | "Background") as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.Atom ("bg" | "Bg") as sexp__158_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__157_ sexp__158_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__156_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__157_ sexp__156_
         | Sexplib0.Sexp.List [] as sexp__156_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__157_ sexp__156_
         | sexp__156_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__157_ sexp__156_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | Bold -> Sexplib0.Sexp.Atom "Bold"
         | Underline -> Sexplib0.Sexp.Atom "Underline"
         | Emph -> Sexplib0.Sexp.Atom "Emph"
         | Blink -> Sexplib0.Sexp.Atom "Blink"
         | Dim -> Sexplib0.Sexp.Atom "Dim"
         | Inverse -> Sexplib0.Sexp.Atom "Inverse"
         | Hide -> Sexplib0.Sexp.Atom "Hide"
         | Reset -> Sexplib0.Sexp.Atom "Reset"
         | Foreground arg0__179_ ->
           let res0__180_ = Color.sexp_of_t arg0__179_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Foreground"; res0__180_ ]
         | Fg arg0__181_ ->
           let res0__182_ = Color.sexp_of_t arg0__181_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Fg"; res0__182_ ]
         | Background arg0__183_ ->
           let res0__184_ = Color.sexp_of_t arg0__183_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Background"; res0__184_ ]
         | Bg arg0__185_ ->
           let res0__186_ = Color.sexp_of_t arg0__185_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Bg"; res0__186_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  include T
  include Comparable.Make (T)
end

module Rule = struct
  module Affix = struct
    type t =
      { text : string
      ; styles : Style.t list
      }
    [@@deriving compare, sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__187_ b__188_ ->
           if Stdlib.( == ) a__187_ b__188_
           then 0
           else (
             match compare_string a__187_.text b__188_.text with
             | 0 ->
               compare_list
                 (fun a__189_ (b__190_ [@merlin.hide]) ->
                    (Style.compare a__189_ b__190_ [@merlin.hide]))
                 a__187_.styles
                 b__188_.styles
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let sexp_of_t =
        (fun { text = text__192_; styles = styles__194_ } ->
           let bnds__191_ = ([] : _ Stdlib.List.t) in
           let bnds__191_ =
             let arg__195_ = sexp_of_list Style.sexp_of_t styles__194_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "styles"; arg__195_ ] :: bnds__191_
              : _ Stdlib.List.t)
           in
           let bnds__191_ =
             let arg__193_ = sexp_of_string text__192_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "text"; arg__193_ ] :: bnds__191_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__191_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create ?(styles = []) text = { text; styles }
    let blank = create ""
    let strip_styles t = { t with styles = [] }
  end

  type t =
    { pre : Affix.t
    ; suf : Affix.t
    ; styles : Style.t list
    }
  [@@deriving compare, fields ~iterators:map, sexp_of]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__196_ b__197_ ->
         if Stdlib.( == ) a__196_ b__197_
         then 0
         else (
           match Affix.compare a__196_.pre b__197_.pre with
           | 0 ->
             (match Affix.compare a__196_.suf b__197_.suf with
              | 0 ->
                compare_list
                  (fun a__198_ (b__199_ [@merlin.hide]) ->
                     (Style.compare a__198_ b__199_ [@merlin.hide]))
                  a__196_.styles
                  b__197_.styles
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let styles _r__ = _r__.styles
    let _ = styles
    let suf _r__ = _r__.suf
    let _ = suf
    let pre _r__ = _r__.pre
    let _ = pre

    module Fields = struct
      let styles =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "styles"
           ; getter = styles
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with styles = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Style.t list) Fieldslib.Field.t_with_perm)
      ;;

      let _ = styles

      let suf =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "suf"
           ; getter = suf
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with suf = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Affix.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = suf

      let pre =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "pre"
           ; getter = pre
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with pre = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Affix.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = pre

      let map ~pre:pre_fun__ ~suf:suf_fun__ ~styles:styles_fun__ =
        { pre = pre_fun__ pre; suf = suf_fun__ suf; styles = styles_fun__ styles }
      ;;

      let _ = map
    end

    let sexp_of_t =
      (fun { pre = pre__201_; suf = suf__203_; styles = styles__205_ } ->
         let bnds__200_ = ([] : _ Stdlib.List.t) in
         let bnds__200_ =
           let arg__206_ = sexp_of_list Style.sexp_of_t styles__205_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "styles"; arg__206_ ] :: bnds__200_
            : _ Stdlib.List.t)
         in
         let bnds__200_ =
           let arg__204_ = Affix.sexp_of_t suf__203_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "suf"; arg__204_ ] :: bnds__200_
            : _ Stdlib.List.t)
         in
         let bnds__200_ =
           let arg__202_ = Affix.sexp_of_t pre__201_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pre"; arg__202_ ] :: bnds__200_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__200_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create ?(pre = Affix.blank) ?(suf = Affix.blank) styles = { pre; suf; styles }
  let blank = create []
  let unstyled_prefix text = { blank with pre = Affix.create text }

  let strip_styles t =
    let f f field = f (Field.get field t) in
    Fields.map
      ~pre:(f Affix.strip_styles)
      ~suf:(f Affix.strip_styles)
      ~styles:(f (const []))
  ;;
end

module Rules = struct
  type t =
    { line_same : Rule.t
    ; line_prev : Rule.t
    ; line_next : Rule.t
    ; line_unified : Rule.t
    ; word_same_prev : Rule.t
    ; word_same_next : Rule.t
    ; word_same_unified : Rule.t
    ; word_same_unified_in_move : Rule.t
    ; word_prev : Rule.t
    ; word_next : Rule.t
    ; hunk : Rule.t
    ; header_prev : Rule.t
    ; header_next : Rule.t
    ; moved_from_prev : Rule.t
    ; moved_to_next : Rule.t
    ; removed_in_move : Rule.t
    ; added_in_move : Rule.t
    ; line_unified_in_move : Rule.t
    }
  [@@deriving compare, fields ~iterators:map, sexp_of]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__207_ b__208_ ->
         if Stdlib.( == ) a__207_ b__208_
         then 0
         else (
           match Rule.compare a__207_.line_same b__208_.line_same with
           | 0 ->
             (match Rule.compare a__207_.line_prev b__208_.line_prev with
              | 0 ->
                (match Rule.compare a__207_.line_next b__208_.line_next with
                 | 0 ->
                   (match Rule.compare a__207_.line_unified b__208_.line_unified with
                    | 0 ->
                      (match
                         Rule.compare a__207_.word_same_prev b__208_.word_same_prev
                       with
                       | 0 ->
                         (match
                            Rule.compare a__207_.word_same_next b__208_.word_same_next
                          with
                          | 0 ->
                            (match
                               Rule.compare
                                 a__207_.word_same_unified
                                 b__208_.word_same_unified
                             with
                             | 0 ->
                               (match
                                  Rule.compare
                                    a__207_.word_same_unified_in_move
                                    b__208_.word_same_unified_in_move
                                with
                                | 0 ->
                                  (match
                                     Rule.compare a__207_.word_prev b__208_.word_prev
                                   with
                                   | 0 ->
                                     (match
                                        Rule.compare a__207_.word_next b__208_.word_next
                                      with
                                      | 0 ->
                                        (match Rule.compare a__207_.hunk b__208_.hunk with
                                         | 0 ->
                                           (match
                                              Rule.compare
                                                a__207_.header_prev
                                                b__208_.header_prev
                                            with
                                            | 0 ->
                                              (match
                                                 Rule.compare
                                                   a__207_.header_next
                                                   b__208_.header_next
                                               with
                                               | 0 ->
                                                 (match
                                                    Rule.compare
                                                      a__207_.moved_from_prev
                                                      b__208_.moved_from_prev
                                                  with
                                                  | 0 ->
                                                    (match
                                                       Rule.compare
                                                         a__207_.moved_to_next
                                                         b__208_.moved_to_next
                                                     with
                                                     | 0 ->
                                                       (match
                                                          Rule.compare
                                                            a__207_.removed_in_move
                                                            b__208_.removed_in_move
                                                        with
                                                        | 0 ->
                                                          (match
                                                             Rule.compare
                                                               a__207_.added_in_move
                                                               b__208_.added_in_move
                                                           with
                                                           | 0 ->
                                                             Rule.compare
                                                               a__207_
                                                                 .line_unified_in_move
                                                               b__208_
                                                                 .line_unified_in_move
                                                           | n -> n)
                                                        | n -> n)
                                                     | n -> n)
                                                  | n -> n)
                                               | n -> n)
                                            | n -> n)
                                         | n -> n)
                                      | n -> n)
                                   | n -> n)
                                | n -> n)
                             | n -> n)
                          | n -> n)
                       | n -> n)
                    | n -> n)
                 | n -> n)
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let line_unified_in_move _r__ = _r__.line_unified_in_move
    let _ = line_unified_in_move
    let added_in_move _r__ = _r__.added_in_move
    let _ = added_in_move
    let removed_in_move _r__ = _r__.removed_in_move
    let _ = removed_in_move
    let moved_to_next _r__ = _r__.moved_to_next
    let _ = moved_to_next
    let moved_from_prev _r__ = _r__.moved_from_prev
    let _ = moved_from_prev
    let header_next _r__ = _r__.header_next
    let _ = header_next
    let header_prev _r__ = _r__.header_prev
    let _ = header_prev
    let hunk _r__ = _r__.hunk
    let _ = hunk
    let word_next _r__ = _r__.word_next
    let _ = word_next
    let word_prev _r__ = _r__.word_prev
    let _ = word_prev
    let word_same_unified_in_move _r__ = _r__.word_same_unified_in_move
    let _ = word_same_unified_in_move
    let word_same_unified _r__ = _r__.word_same_unified
    let _ = word_same_unified
    let word_same_next _r__ = _r__.word_same_next
    let _ = word_same_next
    let word_same_prev _r__ = _r__.word_same_prev
    let _ = word_same_prev
    let line_unified _r__ = _r__.line_unified
    let _ = line_unified
    let line_next _r__ = _r__.line_next
    let _ = line_next
    let line_prev _r__ = _r__.line_prev
    let _ = line_prev
    let line_same _r__ = _r__.line_same
    let _ = line_same

    module Fields = struct
      let line_unified_in_move =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "line_unified_in_move"
           ; getter = line_unified_in_move
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with line_unified_in_move = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = line_unified_in_move

      let added_in_move =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "added_in_move"
           ; getter = added_in_move
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with added_in_move = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = added_in_move

      let removed_in_move =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "removed_in_move"
           ; getter = removed_in_move
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with removed_in_move = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = removed_in_move

      let moved_to_next =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "moved_to_next"
           ; getter = moved_to_next
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with moved_to_next = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = moved_to_next

      let moved_from_prev =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "moved_from_prev"
           ; getter = moved_from_prev
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with moved_from_prev = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = moved_from_prev

      let header_next =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "header_next"
           ; getter = header_next
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with header_next = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = header_next

      let header_prev =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "header_prev"
           ; getter = header_prev
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with header_prev = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = header_prev

      let hunk =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "hunk"
           ; getter = hunk
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with hunk = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = hunk

      let word_next =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_next"
           ; getter = word_next
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_next = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_next

      let word_prev =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_prev"
           ; getter = word_prev
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_prev = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_prev

      let word_same_unified_in_move =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_same_unified_in_move"
           ; getter = word_same_unified_in_move
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_same_unified_in_move = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_same_unified_in_move

      let word_same_unified =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_same_unified"
           ; getter = word_same_unified
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_same_unified = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_same_unified

      let word_same_next =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_same_next"
           ; getter = word_same_next
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_same_next = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_same_next

      let word_same_prev =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "word_same_prev"
           ; getter = word_same_prev
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with word_same_prev = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = word_same_prev

      let line_unified =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "line_unified"
           ; getter = line_unified
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with line_unified = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = line_unified

      let line_next =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "line_next"
           ; getter = line_next
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with line_next = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = line_next

      let line_prev =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "line_prev"
           ; getter = line_prev
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with line_prev = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = line_prev

      let line_same =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "line_same"
           ; getter = line_same
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with line_same = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Rule.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = line_same

      let map
            ~line_same:line_same_fun__
            ~line_prev:line_prev_fun__
            ~line_next:line_next_fun__
            ~line_unified:line_unified_fun__
            ~word_same_prev:word_same_prev_fun__
            ~word_same_next:word_same_next_fun__
            ~word_same_unified:word_same_unified_fun__
            ~word_same_unified_in_move:word_same_unified_in_move_fun__
            ~word_prev:word_prev_fun__
            ~word_next:word_next_fun__
            ~hunk:hunk_fun__
            ~header_prev:header_prev_fun__
            ~header_next:header_next_fun__
            ~moved_from_prev:moved_from_prev_fun__
            ~moved_to_next:moved_to_next_fun__
            ~removed_in_move:removed_in_move_fun__
            ~added_in_move:added_in_move_fun__
            ~line_unified_in_move:line_unified_in_move_fun__
        =
        { line_same = line_same_fun__ line_same
        ; line_prev = line_prev_fun__ line_prev
        ; line_next = line_next_fun__ line_next
        ; line_unified = line_unified_fun__ line_unified
        ; word_same_prev = word_same_prev_fun__ word_same_prev
        ; word_same_next = word_same_next_fun__ word_same_next
        ; word_same_unified = word_same_unified_fun__ word_same_unified
        ; word_same_unified_in_move =
            word_same_unified_in_move_fun__ word_same_unified_in_move
        ; word_prev = word_prev_fun__ word_prev
        ; word_next = word_next_fun__ word_next
        ; hunk = hunk_fun__ hunk
        ; header_prev = header_prev_fun__ header_prev
        ; header_next = header_next_fun__ header_next
        ; moved_from_prev = moved_from_prev_fun__ moved_from_prev
        ; moved_to_next = moved_to_next_fun__ moved_to_next
        ; removed_in_move = removed_in_move_fun__ removed_in_move
        ; added_in_move = added_in_move_fun__ added_in_move
        ; line_unified_in_move = line_unified_in_move_fun__ line_unified_in_move
        }
      ;;

      let _ = map
    end

    let sexp_of_t =
      (fun { line_same = line_same__210_
           ; line_prev = line_prev__212_
           ; line_next = line_next__214_
           ; line_unified = line_unified__216_
           ; word_same_prev = word_same_prev__218_
           ; word_same_next = word_same_next__220_
           ; word_same_unified = word_same_unified__222_
           ; word_same_unified_in_move = word_same_unified_in_move__224_
           ; word_prev = word_prev__226_
           ; word_next = word_next__228_
           ; hunk = hunk__230_
           ; header_prev = header_prev__232_
           ; header_next = header_next__234_
           ; moved_from_prev = moved_from_prev__236_
           ; moved_to_next = moved_to_next__238_
           ; removed_in_move = removed_in_move__240_
           ; added_in_move = added_in_move__242_
           ; line_unified_in_move = line_unified_in_move__244_
           } ->
         let bnds__209_ = ([] : _ Stdlib.List.t) in
         let bnds__209_ =
           let arg__245_ = Rule.sexp_of_t line_unified_in_move__244_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_unified_in_move"; arg__245_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__243_ = Rule.sexp_of_t added_in_move__242_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "added_in_move"; arg__243_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__241_ = Rule.sexp_of_t removed_in_move__240_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "removed_in_move"; arg__241_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__239_ = Rule.sexp_of_t moved_to_next__238_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "moved_to_next"; arg__239_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__237_ = Rule.sexp_of_t moved_from_prev__236_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "moved_from_prev"; arg__237_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__235_ = Rule.sexp_of_t header_next__234_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_next"; arg__235_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__233_ = Rule.sexp_of_t header_prev__232_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "header_prev"; arg__233_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__231_ = Rule.sexp_of_t hunk__230_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hunk"; arg__231_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__229_ = Rule.sexp_of_t word_next__228_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_next"; arg__229_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__227_ = Rule.sexp_of_t word_prev__226_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_prev"; arg__227_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__225_ = Rule.sexp_of_t word_same_unified_in_move__224_ in
           (Sexplib0.Sexp.List
              [ Sexplib0.Sexp.Atom "word_same_unified_in_move"; arg__225_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__223_ = Rule.sexp_of_t word_same_unified__222_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_same_unified"; arg__223_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__221_ = Rule.sexp_of_t word_same_next__220_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_same_next"; arg__221_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__219_ = Rule.sexp_of_t word_same_prev__218_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_same_prev"; arg__219_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__217_ = Rule.sexp_of_t line_unified__216_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_unified"; arg__217_ ]
            :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__215_ = Rule.sexp_of_t line_next__214_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_next"; arg__215_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__213_ = Rule.sexp_of_t line_prev__212_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_prev"; arg__213_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         let bnds__209_ =
           let arg__211_ = Rule.sexp_of_t line_same__210_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_same"; arg__211_ ] :: bnds__209_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__209_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let inner_line_change text color =
    let style =
      let open Style in
      [ Fg color ]
    in
    let pre =
      Rule.Affix.create
        ~styles:
          (let open Style in
           [ Bold; Fg color ])
        text
    in
    Rule.create ~pre style
  ;;

  let line_unified ~is_move =
    let pre =
      Rule.Affix.create
        ~styles:
          (let open Style in
           [ Bold; Fg Color.Yellow ])
        (if is_move then ">|" else "!|")
    in
    Rule.create ~pre []
  ;;

  let word_change color =
    Rule.create
      (let open Style in
       [ Fg color ])
  ;;

  let default =
    let open Rule in
    { line_same = unstyled_prefix "  "
    ; line_prev = inner_line_change "-|" Color.Red
    ; line_next = inner_line_change "+|" Color.Green
    ; line_unified = line_unified ~is_move:false
    ; word_same_prev = blank
    ; word_same_next = blank
    ; word_same_unified = blank
    ; word_same_unified_in_move = blank
    ; word_prev = word_change Color.Red
    ; word_next = word_change Color.Green
    ; hunk = blank
    ; header_prev = blank
    ; header_next = blank
    ; moved_from_prev = inner_line_change "<|" Color.Magenta
    ; moved_to_next = inner_line_change ">|" Color.Cyan
    ; removed_in_move = inner_line_change ">|" Color.Red
    ; added_in_move = inner_line_change ">|" Color.Green
    ; line_unified_in_move = line_unified ~is_move:true
    }
  ;;

  let strip_styles t =
    let f field = Rule.strip_styles (Field.get field t) in
    Fields.map
      ~line_same:f
      ~line_prev:f
      ~line_next:f
      ~line_unified:f
      ~word_same_prev:f
      ~word_same_next:f
      ~word_same_unified:f
      ~word_same_unified_in_move:f
      ~word_prev:f
      ~word_next:f
      ~hunk:f
      ~header_prev:f
      ~header_next:f
      ~moved_from_prev:f
      ~moved_to_next:f
      ~removed_in_move:f
      ~added_in_move:f
      ~line_unified_in_move:f
  ;;
end

module Location_style = struct
  type t =
    | Diff
    | Omake
    | None
    | Separator
  [@@deriving bin_io, compare, quickcheck, enumerate, equal, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "format.ml.before-ppx:219:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , []
            , Bin_prot.Shape.variant
                [ "Diff", []; "Omake", []; "None", []; "Separator", [] ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t

    let bin_size_t : t Bin_prot.Size.sizer = function
      | Diff | Omake | None | Separator -> 1
    ;;

    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos -> function
      | Diff -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | Omake -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
      | None -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
      | Separator -> Bin_prot.Write.bin_write_int_8bit buf ~pos 3
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "format.ml.before-ppx.Location_style.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> Diff
      | 1 -> Omake
      | 2 -> None
      | 3 -> Separator
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag "format.ml.before-ppx.Location_style.t")
          !pos_ref
    ;;

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
      (fun a__246_ b__247_ -> Stdlib.compare a__246_ b__247_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let quickcheck_generator =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__251_ ~random:_random__252_ -> Diff) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__253_ ~random:_random__254_ -> Omake) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__255_ ~random:_random__256_ -> None) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__257_ ~random:_random__258_ -> Separator) )
        ]
    ;;

    let _ = quickcheck_generator

    let quickcheck_observer =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__248_ ~size:_size__249_ ~hash:_hash__250_ ->
           match _x__248_ with
           | Diff ->
             let _hash__250_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__250_ 0 in
             _hash__250_
           | Omake ->
             let _hash__250_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__250_ 1 in
             _hash__250_
           | None ->
             let _hash__250_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__250_ 2 in
             _hash__250_
           | Separator ->
             let _hash__250_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__250_ 3 in
             _hash__250_)
    ;;

    let _ = quickcheck_observer

    let quickcheck_shrinker =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | Diff -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
        | Omake -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
        | None -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
        | Separator -> Ppx_quickcheck_runtime.Base.Sequence.round_robin [])
    ;;

    let _ = quickcheck_shrinker
    let all = ([ Diff; Omake; None; Separator ] : t list)
    let _ = all

    let equal =
      (fun a__259_ b__260_ -> Stdlib.( = ) a__259_ b__260_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal

    let t_of_sexp =
      (let error_source__263_ = "format.ml.before-ppx.Location_style.t" in
       function
       | Sexplib0.Sexp.Atom ("diff" | "Diff") -> Diff
       | Sexplib0.Sexp.Atom ("omake" | "Omake") -> Omake
       | Sexplib0.Sexp.Atom ("none" | "None") -> None
       | Sexplib0.Sexp.Atom ("separator" | "Separator") -> Separator
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("diff" | "Diff") :: _) as sexp__264_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__263_ sexp__264_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("omake" | "Omake") :: _) as sexp__264_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__263_ sexp__264_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("none" | "None") :: _) as sexp__264_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__263_ sexp__264_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("separator" | "Separator") :: _) as
         sexp__264_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__263_ sexp__264_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__262_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__263_ sexp__262_
       | Sexplib0.Sexp.List [] as sexp__262_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__263_ sexp__262_
       | sexp__262_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__263_ sexp__262_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | Diff -> Sexplib0.Sexp.Atom "Diff"
       | Omake -> Sexplib0.Sexp.Atom "Omake"
       | None -> Sexplib0.Sexp.Atom "None"
       | Separator -> Sexplib0.Sexp.Atom "Separator"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_string = function
    | Diff -> "diff"
    | Omake -> "omake"
    | None -> "none"
    | Separator -> "separator"
  ;;

  let of_string = function
    | "diff" -> Diff
    | "omake" -> Omake
    | "none" -> None
    | "separator" -> Separator
    | other ->
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "format.ml.before-ppx"
          ; pos_lnum = 238
          ; pos_cnum = 5557
          ; pos_bol = 5526
          }
        "invalid location style"
        other
        (sexp_of_string [@merlin.hide])
  ;;

  let omake_style_error_message_start ~file ~line =
    sprintf "File \"%s\", line %d, characters 0-1:" file line
  ;;

  let sprint t (hunk : string Patience_diff.Hunk.t) ~prev_filename ~rule =
    match t with
    | Diff ->
      rule
        (sprintf
           "-%i,%i +%i,%i"
           hunk.prev_start
           hunk.prev_size
           hunk.next_start
           hunk.next_size)
    | Omake ->
      let prev_start =
        with_return (fun r ->
          List.fold hunk.ranges ~init:hunk.prev_start ~f:(fun init -> function
            | Same s -> init + Array.length s
            | Prev _ | Next _ | Replace _ | Unified _ -> r.return init))
      in
      omake_style_error_message_start ~file:prev_filename ~line:prev_start
    | None -> rule ""
    | Separator -> rule "=== DIFF HUNK ==="
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
