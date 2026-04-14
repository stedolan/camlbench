let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"quickcheck.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "quickcheck.ml.before-ppx"
;;

open! Import
open Quickcheck_intf
open Base_quickcheck
module Float = Base.Float
module Int = Base.Int
module List = Base.List
module Option = Base.Option
module Set = Base.Set
module Sexp = Base.Sexp

module Polymorphic_types = struct
  type ('a, 'b) variant2 =
    [ `A of 'a
    | `B of 'b
    ]
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b) variant2) -> ()

    let quickcheck_generator_variant2 _generator__012_ _generator__013_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__014_ ~random:_random__015_ ->
                 `A
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__012_
                      ~size:_size__014_
                      ~random:_random__015_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__016_ ~random:_random__017_ ->
                 `B
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__013_
                      ~size:_size__016_
                      ~random:_random__017_)) )
        ]
    ;;

    let _ = quickcheck_generator_variant2

    let quickcheck_observer_variant2 _observer__005_ _observer__006_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__007_ ~size:_size__008_ ~hash:_hash__009_ ->
           match _x__007_ with
           | `A _x__010_ ->
             let _hash__009_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__009_ 65 in
             let _hash__009_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__005_
                 _x__010_
                 ~size:_size__008_
                 ~hash:_hash__009_
             in
             _hash__009_
           | `B _x__011_ ->
             let _hash__009_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__009_ 66 in
             let _hash__009_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__006_
                 _x__011_
                 ~size:_size__008_
                 ~hash:_hash__009_
             in
             _hash__009_)
    ;;

    let _ = quickcheck_observer_variant2

    let quickcheck_shrinker_variant2 _shrinker__001_ _shrinker__002_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | `A _x__003_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__001_
                   _x__003_)
                ~f:(fun _x__003_ -> `A _x__003_)
            ]
        | `B _x__004_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__002_
                   _x__004_)
                ~f:(fun _x__004_ -> `B _x__004_)
            ])
    ;;

    let _ = quickcheck_shrinker_variant2
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c) variant3 =
    [ `A of 'a
    | `B of 'b
    | `C of 'c
    ]
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c) variant3) -> ()

    let quickcheck_generator_variant3 _generator__033_ _generator__034_ _generator__035_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__036_ ~random:_random__037_ ->
                 `A
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__033_
                      ~size:_size__036_
                      ~random:_random__037_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__038_ ~random:_random__039_ ->
                 `B
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__034_
                      ~size:_size__038_
                      ~random:_random__039_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__040_ ~random:_random__041_ ->
                 `C
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__035_
                      ~size:_size__040_
                      ~random:_random__041_)) )
        ]
    ;;

    let _ = quickcheck_generator_variant3

    let quickcheck_observer_variant3 _observer__024_ _observer__025_ _observer__026_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__027_ ~size:_size__028_ ~hash:_hash__029_ ->
           match _x__027_ with
           | `A _x__030_ ->
             let _hash__029_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__029_ 65 in
             let _hash__029_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__024_
                 _x__030_
                 ~size:_size__028_
                 ~hash:_hash__029_
             in
             _hash__029_
           | `B _x__031_ ->
             let _hash__029_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__029_ 66 in
             let _hash__029_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__025_
                 _x__031_
                 ~size:_size__028_
                 ~hash:_hash__029_
             in
             _hash__029_
           | `C _x__032_ ->
             let _hash__029_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__029_ 67 in
             let _hash__029_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__026_
                 _x__032_
                 ~size:_size__028_
                 ~hash:_hash__029_
             in
             _hash__029_)
    ;;

    let _ = quickcheck_observer_variant3

    let quickcheck_shrinker_variant3 _shrinker__018_ _shrinker__019_ _shrinker__020_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | `A _x__021_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__018_
                   _x__021_)
                ~f:(fun _x__021_ -> `A _x__021_)
            ]
        | `B _x__022_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__019_
                   _x__022_)
                ~f:(fun _x__022_ -> `B _x__022_)
            ]
        | `C _x__023_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__020_
                   _x__023_)
                ~f:(fun _x__023_ -> `C _x__023_)
            ])
    ;;

    let _ = quickcheck_shrinker_variant3
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd) variant4 =
    [ `A of 'a
    | `B of 'b
    | `C of 'c
    | `D of 'd
    ]
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd) variant4) -> ()

    let quickcheck_generator_variant4
          _generator__061_
          _generator__062_
          _generator__063_
          _generator__064_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__065_ ~random:_random__066_ ->
                 `A
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__061_
                      ~size:_size__065_
                      ~random:_random__066_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__067_ ~random:_random__068_ ->
                 `B
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__062_
                      ~size:_size__067_
                      ~random:_random__068_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__069_ ~random:_random__070_ ->
                 `C
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__063_
                      ~size:_size__069_
                      ~random:_random__070_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__071_ ~random:_random__072_ ->
                 `D
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__064_
                      ~size:_size__071_
                      ~random:_random__072_)) )
        ]
    ;;

    let _ = quickcheck_generator_variant4

    let quickcheck_observer_variant4
          _observer__050_
          _observer__051_
          _observer__052_
          _observer__053_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__054_ ~size:_size__055_ ~hash:_hash__056_ ->
           match _x__054_ with
           | `A _x__057_ ->
             let _hash__056_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__056_ 65 in
             let _hash__056_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__050_
                 _x__057_
                 ~size:_size__055_
                 ~hash:_hash__056_
             in
             _hash__056_
           | `B _x__058_ ->
             let _hash__056_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__056_ 66 in
             let _hash__056_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__051_
                 _x__058_
                 ~size:_size__055_
                 ~hash:_hash__056_
             in
             _hash__056_
           | `C _x__059_ ->
             let _hash__056_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__056_ 67 in
             let _hash__056_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__052_
                 _x__059_
                 ~size:_size__055_
                 ~hash:_hash__056_
             in
             _hash__056_
           | `D _x__060_ ->
             let _hash__056_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__056_ 68 in
             let _hash__056_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__053_
                 _x__060_
                 ~size:_size__055_
                 ~hash:_hash__056_
             in
             _hash__056_)
    ;;

    let _ = quickcheck_observer_variant4

    let quickcheck_shrinker_variant4
          _shrinker__042_
          _shrinker__043_
          _shrinker__044_
          _shrinker__045_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | `A _x__046_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__042_
                   _x__046_)
                ~f:(fun _x__046_ -> `A _x__046_)
            ]
        | `B _x__047_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__043_
                   _x__047_)
                ~f:(fun _x__047_ -> `B _x__047_)
            ]
        | `C _x__048_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__044_
                   _x__048_)
                ~f:(fun _x__048_ -> `C _x__048_)
            ]
        | `D _x__049_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__045_
                   _x__049_)
                ~f:(fun _x__049_ -> `D _x__049_)
            ])
    ;;

    let _ = quickcheck_shrinker_variant4
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd, 'e) variant5 =
    [ `A of 'a
    | `B of 'b
    | `C of 'c
    | `D of 'd
    | `E of 'e
    ]
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e) variant5) -> ()

    let quickcheck_generator_variant5
          _generator__096_
          _generator__097_
          _generator__098_
          _generator__099_
          _generator__100_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__101_ ~random:_random__102_ ->
                 `A
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__096_
                      ~size:_size__101_
                      ~random:_random__102_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__103_ ~random:_random__104_ ->
                 `B
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__097_
                      ~size:_size__103_
                      ~random:_random__104_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__105_ ~random:_random__106_ ->
                 `C
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__098_
                      ~size:_size__105_
                      ~random:_random__106_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__107_ ~random:_random__108_ ->
                 `D
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__099_
                      ~size:_size__107_
                      ~random:_random__108_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__109_ ~random:_random__110_ ->
                 `E
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__100_
                      ~size:_size__109_
                      ~random:_random__110_)) )
        ]
    ;;

    let _ = quickcheck_generator_variant5

    let quickcheck_observer_variant5
          _observer__083_
          _observer__084_
          _observer__085_
          _observer__086_
          _observer__087_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__088_ ~size:_size__089_ ~hash:_hash__090_ ->
           match _x__088_ with
           | `A _x__091_ ->
             let _hash__090_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__090_ 65 in
             let _hash__090_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__083_
                 _x__091_
                 ~size:_size__089_
                 ~hash:_hash__090_
             in
             _hash__090_
           | `B _x__092_ ->
             let _hash__090_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__090_ 66 in
             let _hash__090_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__084_
                 _x__092_
                 ~size:_size__089_
                 ~hash:_hash__090_
             in
             _hash__090_
           | `C _x__093_ ->
             let _hash__090_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__090_ 67 in
             let _hash__090_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__085_
                 _x__093_
                 ~size:_size__089_
                 ~hash:_hash__090_
             in
             _hash__090_
           | `D _x__094_ ->
             let _hash__090_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__090_ 68 in
             let _hash__090_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__086_
                 _x__094_
                 ~size:_size__089_
                 ~hash:_hash__090_
             in
             _hash__090_
           | `E _x__095_ ->
             let _hash__090_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__090_ 69 in
             let _hash__090_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__087_
                 _x__095_
                 ~size:_size__089_
                 ~hash:_hash__090_
             in
             _hash__090_)
    ;;

    let _ = quickcheck_observer_variant5

    let quickcheck_shrinker_variant5
          _shrinker__073_
          _shrinker__074_
          _shrinker__075_
          _shrinker__076_
          _shrinker__077_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | `A _x__078_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__073_
                   _x__078_)
                ~f:(fun _x__078_ -> `A _x__078_)
            ]
        | `B _x__079_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__074_
                   _x__079_)
                ~f:(fun _x__079_ -> `B _x__079_)
            ]
        | `C _x__080_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__075_
                   _x__080_)
                ~f:(fun _x__080_ -> `C _x__080_)
            ]
        | `D _x__081_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__076_
                   _x__081_)
                ~f:(fun _x__081_ -> `D _x__081_)
            ]
        | `E _x__082_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__077_
                   _x__082_)
                ~f:(fun _x__082_ -> `E _x__082_)
            ])
    ;;

    let _ = quickcheck_shrinker_variant5
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd, 'e, 'f) variant6 =
    [ `A of 'a
    | `B of 'b
    | `C of 'c
    | `D of 'd
    | `E of 'e
    | `F of 'f
    ]
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e, 'f) variant6) -> ()

    let quickcheck_generator_variant6
          _generator__138_
          _generator__139_
          _generator__140_
          _generator__141_
          _generator__142_
          _generator__143_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
        [ ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__144_ ~random:_random__145_ ->
                 `A
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__138_
                      ~size:_size__144_
                      ~random:_random__145_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__146_ ~random:_random__147_ ->
                 `B
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__139_
                      ~size:_size__146_
                      ~random:_random__147_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__148_ ~random:_random__149_ ->
                 `C
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__140_
                      ~size:_size__148_
                      ~random:_random__149_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__150_ ~random:_random__151_ ->
                 `D
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__141_
                      ~size:_size__150_
                      ~random:_random__151_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__152_ ~random:_random__153_ ->
                 `E
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__142_
                      ~size:_size__152_
                      ~random:_random__153_)) )
        ; ( 1.
          , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
              (fun ~size:_size__154_ ~random:_random__155_ ->
                 `F
                   (Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
                      _generator__143_
                      ~size:_size__154_
                      ~random:_random__155_)) )
        ]
    ;;

    let _ = quickcheck_generator_variant6

    let quickcheck_observer_variant6
          _observer__123_
          _observer__124_
          _observer__125_
          _observer__126_
          _observer__127_
          _observer__128_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__129_ ~size:_size__130_ ~hash:_hash__131_ ->
           match _x__129_ with
           | `A _x__132_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 65 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__123_
                 _x__132_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_
           | `B _x__133_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 66 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__124_
                 _x__133_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_
           | `C _x__134_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 67 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__125_
                 _x__134_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_
           | `D _x__135_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 68 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__126_
                 _x__135_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_
           | `E _x__136_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 69 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__127_
                 _x__136_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_
           | `F _x__137_ ->
             let _hash__131_ = Ppx_quickcheck_runtime.Base.hash_fold_int _hash__131_ 70 in
             let _hash__131_ =
               Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
                 _observer__128_
                 _x__137_
                 ~size:_size__130_
                 ~hash:_hash__131_
             in
             _hash__131_)
    ;;

    let _ = quickcheck_observer_variant6

    let quickcheck_shrinker_variant6
          _shrinker__111_
          _shrinker__112_
          _shrinker__113_
          _shrinker__114_
          _shrinker__115_
          _shrinker__116_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
        | `A _x__117_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__111_
                   _x__117_)
                ~f:(fun _x__117_ -> `A _x__117_)
            ]
        | `B _x__118_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__112_
                   _x__118_)
                ~f:(fun _x__118_ -> `B _x__118_)
            ]
        | `C _x__119_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__113_
                   _x__119_)
                ~f:(fun _x__119_ -> `C _x__119_)
            ]
        | `D _x__120_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__114_
                   _x__120_)
                ~f:(fun _x__120_ -> `D _x__120_)
            ]
        | `E _x__121_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__115_
                   _x__121_)
                ~f:(fun _x__121_ -> `E _x__121_)
            ]
        | `F _x__122_ ->
          Ppx_quickcheck_runtime.Base.Sequence.round_robin
            [ Ppx_quickcheck_runtime.Base.Sequence.map
                (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                   _shrinker__116_
                   _x__122_)
                ~f:(fun _x__122_ -> `F _x__122_)
            ])
    ;;

    let _ = quickcheck_shrinker_variant6
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b) tuple2 = 'a * 'b [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b) tuple2) -> ()

    let quickcheck_generator_tuple2 _generator__167_ _generator__168_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
        (fun ~size:_size__169_ ~random:_random__170_ ->
           ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__167_
               ~size:_size__169_
               ~random:_random__170_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__168_
               ~size:_size__169_
               ~random:_random__170_ ))
    ;;

    let _ = quickcheck_generator_tuple2

    let quickcheck_observer_tuple2 _observer__160_ _observer__161_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__162_ ~size:_size__165_ ~hash:_hash__166_ ->
           let _x__163_, _x__164_ = _x__162_ in
           let _hash__166_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__160_
               _x__163_
               ~size:_size__165_
               ~hash:_hash__166_
           in
           let _hash__166_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__161_
               _x__164_
               ~size:_size__165_
               ~hash:_hash__166_
           in
           _hash__166_)
    ;;

    let _ = quickcheck_observer_tuple2

    let quickcheck_shrinker_tuple2 _shrinker__156_ _shrinker__157_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (fun (_x__158_, _x__159_) ->
        Ppx_quickcheck_runtime.Base.Sequence.round_robin
          [ Ppx_quickcheck_runtime.Base.Sequence.map
              (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                 _shrinker__156_
                 _x__158_)
              ~f:(fun _x__158_ -> _x__158_, _x__159_)
          ; Ppx_quickcheck_runtime.Base.Sequence.map
              (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                 _shrinker__157_
                 _x__159_)
              ~f:(fun _x__159_ -> _x__158_, _x__159_)
          ])
    ;;

    let _ = quickcheck_shrinker_tuple2
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c) tuple3 = 'a * 'b * 'c [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c) tuple3) -> ()

    let quickcheck_generator_tuple3 _generator__186_ _generator__187_ _generator__188_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
        (fun ~size:_size__189_ ~random:_random__190_ ->
           ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__186_
               ~size:_size__189_
               ~random:_random__190_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__187_
               ~size:_size__189_
               ~random:_random__190_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__188_
               ~size:_size__189_
               ~random:_random__190_ ))
    ;;

    let _ = quickcheck_generator_tuple3

    let quickcheck_observer_tuple3 _observer__177_ _observer__178_ _observer__179_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__180_ ~size:_size__184_ ~hash:_hash__185_ ->
           let _x__181_, _x__182_, _x__183_ = _x__180_ in
           let _hash__185_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__177_
               _x__181_
               ~size:_size__184_
               ~hash:_hash__185_
           in
           let _hash__185_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__178_
               _x__182_
               ~size:_size__184_
               ~hash:_hash__185_
           in
           let _hash__185_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__179_
               _x__183_
               ~size:_size__184_
               ~hash:_hash__185_
           in
           _hash__185_)
    ;;

    let _ = quickcheck_observer_tuple3

    let quickcheck_shrinker_tuple3 _shrinker__171_ _shrinker__172_ _shrinker__173_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
        (fun (_x__174_, _x__175_, _x__176_) ->
           Ppx_quickcheck_runtime.Base.Sequence.round_robin
             [ Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__171_
                    _x__174_)
                 ~f:(fun _x__174_ -> _x__174_, _x__175_, _x__176_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__172_
                    _x__175_)
                 ~f:(fun _x__175_ -> _x__174_, _x__175_, _x__176_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__173_
                    _x__176_)
                 ~f:(fun _x__176_ -> _x__174_, _x__175_, _x__176_)
             ])
    ;;

    let _ = quickcheck_shrinker_tuple3
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd) tuple4 = 'a * 'b * 'c * 'd [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd) tuple4) -> ()

    let quickcheck_generator_tuple4
          _generator__210_
          _generator__211_
          _generator__212_
          _generator__213_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
        (fun ~size:_size__214_ ~random:_random__215_ ->
           ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__210_
               ~size:_size__214_
               ~random:_random__215_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__211_
               ~size:_size__214_
               ~random:_random__215_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__212_
               ~size:_size__214_
               ~random:_random__215_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__213_
               ~size:_size__214_
               ~random:_random__215_ ))
    ;;

    let _ = quickcheck_generator_tuple4

    let quickcheck_observer_tuple4
          _observer__199_
          _observer__200_
          _observer__201_
          _observer__202_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__203_ ~size:_size__208_ ~hash:_hash__209_ ->
           let _x__204_, _x__205_, _x__206_, _x__207_ = _x__203_ in
           let _hash__209_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__199_
               _x__204_
               ~size:_size__208_
               ~hash:_hash__209_
           in
           let _hash__209_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__200_
               _x__205_
               ~size:_size__208_
               ~hash:_hash__209_
           in
           let _hash__209_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__201_
               _x__206_
               ~size:_size__208_
               ~hash:_hash__209_
           in
           let _hash__209_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__202_
               _x__207_
               ~size:_size__208_
               ~hash:_hash__209_
           in
           _hash__209_)
    ;;

    let _ = quickcheck_observer_tuple4

    let quickcheck_shrinker_tuple4
          _shrinker__191_
          _shrinker__192_
          _shrinker__193_
          _shrinker__194_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
        (fun (_x__195_, _x__196_, _x__197_, _x__198_) ->
           Ppx_quickcheck_runtime.Base.Sequence.round_robin
             [ Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__191_
                    _x__195_)
                 ~f:(fun _x__195_ -> _x__195_, _x__196_, _x__197_, _x__198_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__192_
                    _x__196_)
                 ~f:(fun _x__196_ -> _x__195_, _x__196_, _x__197_, _x__198_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__193_
                    _x__197_)
                 ~f:(fun _x__197_ -> _x__195_, _x__196_, _x__197_, _x__198_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__194_
                    _x__198_)
                 ~f:(fun _x__198_ -> _x__195_, _x__196_, _x__197_, _x__198_)
             ])
    ;;

    let _ = quickcheck_shrinker_tuple4
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd, 'e) tuple5 = 'a * 'b * 'c * 'd * 'e [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e) tuple5) -> ()

    let quickcheck_generator_tuple5
          _generator__239_
          _generator__240_
          _generator__241_
          _generator__242_
          _generator__243_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
        (fun ~size:_size__244_ ~random:_random__245_ ->
           ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__239_
               ~size:_size__244_
               ~random:_random__245_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__240_
               ~size:_size__244_
               ~random:_random__245_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__241_
               ~size:_size__244_
               ~random:_random__245_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__242_
               ~size:_size__244_
               ~random:_random__245_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__243_
               ~size:_size__244_
               ~random:_random__245_ ))
    ;;

    let _ = quickcheck_generator_tuple5

    let quickcheck_observer_tuple5
          _observer__226_
          _observer__227_
          _observer__228_
          _observer__229_
          _observer__230_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__231_ ~size:_size__237_ ~hash:_hash__238_ ->
           let _x__232_, _x__233_, _x__234_, _x__235_, _x__236_ = _x__231_ in
           let _hash__238_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__226_
               _x__232_
               ~size:_size__237_
               ~hash:_hash__238_
           in
           let _hash__238_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__227_
               _x__233_
               ~size:_size__237_
               ~hash:_hash__238_
           in
           let _hash__238_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__228_
               _x__234_
               ~size:_size__237_
               ~hash:_hash__238_
           in
           let _hash__238_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__229_
               _x__235_
               ~size:_size__237_
               ~hash:_hash__238_
           in
           let _hash__238_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__230_
               _x__236_
               ~size:_size__237_
               ~hash:_hash__238_
           in
           _hash__238_)
    ;;

    let _ = quickcheck_observer_tuple5

    let quickcheck_shrinker_tuple5
          _shrinker__216_
          _shrinker__217_
          _shrinker__218_
          _shrinker__219_
          _shrinker__220_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
        (fun (_x__221_, _x__222_, _x__223_, _x__224_, _x__225_) ->
           Ppx_quickcheck_runtime.Base.Sequence.round_robin
             [ Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__216_
                    _x__221_)
                 ~f:(fun _x__221_ -> _x__221_, _x__222_, _x__223_, _x__224_, _x__225_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__217_
                    _x__222_)
                 ~f:(fun _x__222_ -> _x__221_, _x__222_, _x__223_, _x__224_, _x__225_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__218_
                    _x__223_)
                 ~f:(fun _x__223_ -> _x__221_, _x__222_, _x__223_, _x__224_, _x__225_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__219_
                    _x__224_)
                 ~f:(fun _x__224_ -> _x__221_, _x__222_, _x__223_, _x__224_, _x__225_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__220_
                    _x__225_)
                 ~f:(fun _x__225_ -> _x__221_, _x__222_, _x__223_, _x__224_, _x__225_)
             ])
    ;;

    let _ = quickcheck_shrinker_tuple5
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('a, 'b, 'c, 'd, 'e, 'f) tuple6 = 'a * 'b * 'c * 'd * 'e * 'f
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e, 'f) tuple6) -> ()

    let quickcheck_generator_tuple6
          _generator__273_
          _generator__274_
          _generator__275_
          _generator__276_
          _generator__277_
          _generator__278_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
        (fun ~size:_size__279_ ~random:_random__280_ ->
           ( Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__273_
               ~size:_size__279_
               ~random:_random__280_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__274_
               ~size:_size__279_
               ~random:_random__280_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__275_
               ~size:_size__279_
               ~random:_random__280_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__276_
               ~size:_size__279_
               ~random:_random__280_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__277_
               ~size:_size__279_
               ~random:_random__280_
           , Ppx_quickcheck_runtime.Base_quickcheck.Generator.generate
               _generator__278_
               ~size:_size__279_
               ~random:_random__280_ ))
    ;;

    let _ = quickcheck_generator_tuple6

    let quickcheck_observer_tuple6
          _observer__258_
          _observer__259_
          _observer__260_
          _observer__261_
          _observer__262_
          _observer__263_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
        (fun _x__264_ ~size:_size__271_ ~hash:_hash__272_ ->
           let _x__265_, _x__266_, _x__267_, _x__268_, _x__269_, _x__270_ = _x__264_ in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__258_
               _x__265_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__259_
               _x__266_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__260_
               _x__267_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__261_
               _x__268_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__262_
               _x__269_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           let _hash__272_ =
             Ppx_quickcheck_runtime.Base_quickcheck.Observer.observe
               _observer__263_
               _x__270_
               ~size:_size__271_
               ~hash:_hash__272_
           in
           _hash__272_)
    ;;

    let _ = quickcheck_observer_tuple6

    let quickcheck_shrinker_tuple6
          _shrinker__246_
          _shrinker__247_
          _shrinker__248_
          _shrinker__249_
          _shrinker__250_
          _shrinker__251_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create
        (fun (_x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_) ->
           Ppx_quickcheck_runtime.Base.Sequence.round_robin
             [ Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__246_
                    _x__252_)
                 ~f:(fun _x__252_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__247_
                    _x__253_)
                 ~f:(fun _x__253_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__248_
                    _x__254_)
                 ~f:(fun _x__254_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__249_
                    _x__255_)
                 ~f:(fun _x__255_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__250_
                    _x__256_)
                 ~f:(fun _x__256_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ; Ppx_quickcheck_runtime.Base.Sequence.map
                 (Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.shrink
                    _shrinker__251_
                    _x__257_)
                 ~f:(fun _x__257_ ->
                   _x__252_, _x__253_, _x__254_, _x__255_, _x__256_, _x__257_)
             ])
    ;;

    let _ = quickcheck_shrinker_tuple6
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type (-'a, -'b, 'r) fn2 = 'a -> 'b -> 'r [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'r) fn2) -> ()

    let quickcheck_generator_fn2 _observer__287_ _observer__288_ _generator__289_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
        _observer__287_
        (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
           _observer__288_
           _generator__289_)
    ;;

    let _ = quickcheck_generator_fn2

    let quickcheck_observer_fn2 _generator__284_ _generator__285_ _observer__286_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
        _generator__284_
        (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
           _generator__285_
           _observer__286_)
    ;;

    let _ = quickcheck_observer_fn2

    let quickcheck_shrinker_fn2 _shrinker__281_ _shrinker__282_ _shrinker__283_ =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.atomic
    ;;

    let _ = quickcheck_shrinker_fn2
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type (-'a, -'b, -'c, 'r) fn3 = 'a -> 'b -> 'c -> 'r [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'r) fn3) -> ()

    let quickcheck_generator_fn3
          _observer__298_
          _observer__299_
          _observer__300_
          _generator__301_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
        _observer__298_
        (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
           _observer__299_
           (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
              _observer__300_
              _generator__301_))
    ;;

    let _ = quickcheck_generator_fn3

    let quickcheck_observer_fn3
          _generator__294_
          _generator__295_
          _generator__296_
          _observer__297_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
        _generator__294_
        (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
           _generator__295_
           (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
              _generator__296_
              _observer__297_))
    ;;

    let _ = quickcheck_observer_fn3

    let quickcheck_shrinker_fn3
          _shrinker__290_
          _shrinker__291_
          _shrinker__292_
          _shrinker__293_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.atomic
    ;;

    let _ = quickcheck_shrinker_fn3
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type (-'a, -'b, -'c, -'d, 'r) fn4 = 'a -> 'b -> 'c -> 'd -> 'r [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'r) fn4) -> ()

    let quickcheck_generator_fn4
          _observer__312_
          _observer__313_
          _observer__314_
          _observer__315_
          _generator__316_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
        _observer__312_
        (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
           _observer__313_
           (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
              _observer__314_
              (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                 _observer__315_
                 _generator__316_)))
    ;;

    let _ = quickcheck_generator_fn4

    let quickcheck_observer_fn4
          _generator__307_
          _generator__308_
          _generator__309_
          _generator__310_
          _observer__311_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
        _generator__307_
        (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
           _generator__308_
           (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
              _generator__309_
              (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                 _generator__310_
                 _observer__311_)))
    ;;

    let _ = quickcheck_observer_fn4

    let quickcheck_shrinker_fn4
          _shrinker__302_
          _shrinker__303_
          _shrinker__304_
          _shrinker__305_
          _shrinker__306_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.atomic
    ;;

    let _ = quickcheck_shrinker_fn4
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type (-'a, -'b, -'c, -'d, -'e, 'r) fn5 = 'a -> 'b -> 'c -> 'd -> 'e -> 'r
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e, 'r) fn5) -> ()

    let quickcheck_generator_fn5
          _observer__329_
          _observer__330_
          _observer__331_
          _observer__332_
          _observer__333_
          _generator__334_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
        _observer__329_
        (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
           _observer__330_
           (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
              _observer__331_
              (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                 _observer__332_
                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                    _observer__333_
                    _generator__334_))))
    ;;

    let _ = quickcheck_generator_fn5

    let quickcheck_observer_fn5
          _generator__323_
          _generator__324_
          _generator__325_
          _generator__326_
          _generator__327_
          _observer__328_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
        _generator__323_
        (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
           _generator__324_
           (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
              _generator__325_
              (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                 _generator__326_
                 (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                    _generator__327_
                    _observer__328_))))
    ;;

    let _ = quickcheck_observer_fn5

    let quickcheck_shrinker_fn5
          _shrinker__317_
          _shrinker__318_
          _shrinker__319_
          _shrinker__320_
          _shrinker__321_
          _shrinker__322_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.atomic
    ;;

    let _ = quickcheck_shrinker_fn5
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type (-'a, -'b, -'c, -'d, -'e, -'f, 'r) fn6 = 'a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'r
  [@@deriving quickcheck]

  include struct
    let _ = fun (_ : ('a, 'b, 'c, 'd, 'e, 'f, 'r) fn6) -> ()

    let quickcheck_generator_fn6
          _observer__349_
          _observer__350_
          _observer__351_
          _observer__352_
          _observer__353_
          _observer__354_
          _generator__355_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
        _observer__349_
        (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
           _observer__350_
           (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
              _observer__351_
              (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                 _observer__352_
                 (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                    _observer__353_
                    (Ppx_quickcheck_runtime.Base_quickcheck.Generator.fn
                       _observer__354_
                       _generator__355_)))))
    ;;

    let _ = quickcheck_generator_fn6

    let quickcheck_observer_fn6
          _generator__342_
          _generator__343_
          _generator__344_
          _generator__345_
          _generator__346_
          _generator__347_
          _observer__348_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
        _generator__342_
        (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
           _generator__343_
           (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
              _generator__344_
              (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                 _generator__345_
                 (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                    _generator__346_
                    (Ppx_quickcheck_runtime.Base_quickcheck.Observer.fn
                       _generator__347_
                       _observer__348_)))))
    ;;

    let _ = quickcheck_observer_fn6

    let quickcheck_shrinker_fn6
          _shrinker__335_
          _shrinker__336_
          _shrinker__337_
          _shrinker__338_
          _shrinker__339_
          _shrinker__340_
          _shrinker__341_
      =
      Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.atomic
    ;;

    let _ = quickcheck_shrinker_fn6
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Observer = struct
  include Observer

  let of_hash (type a) ((module M) : (module Deriving_hash with type t = a)) =
    of_hash_fold M.hash_fold_t
  ;;

  let variant2 = Polymorphic_types.quickcheck_observer_variant2
  let variant3 = Polymorphic_types.quickcheck_observer_variant3
  let variant4 = Polymorphic_types.quickcheck_observer_variant4
  let variant5 = Polymorphic_types.quickcheck_observer_variant5
  let variant6 = Polymorphic_types.quickcheck_observer_variant6
  let tuple2 = Polymorphic_types.quickcheck_observer_tuple2
  let tuple3 = Polymorphic_types.quickcheck_observer_tuple3
  let tuple4 = Polymorphic_types.quickcheck_observer_tuple4
  let tuple5 = Polymorphic_types.quickcheck_observer_tuple5
  let tuple6 = Polymorphic_types.quickcheck_observer_tuple6
  let of_predicate a b ~f = unmap (variant2 a b) ~f:(fun x -> if f x then `A x else `B x)
  let singleton () = opaque
  let doubleton f = of_predicate (singleton ()) (singleton ()) ~f
  let enum _ ~f = unmap int ~f

  let of_list list ~equal =
    let f x =
      match List.findi list ~f:(fun _ y -> equal x y) with
      | None -> failwith "Quickcheck.Observer.of_list: value not found"
      | Some (i, _) -> i
    in
    enum (List.length list) ~f
  ;;

  let of_fun f = create (fun x ~size ~hash -> observe (f ()) x ~size ~hash)

  let comparison ~compare ~eq ~lt ~gt =
    unmap
      (variant3 lt (singleton ()) gt)
      ~f:(fun x ->
        let c = compare x eq in
        if c < 0 then `A x else if c > 0 then `C x else `B x)
  ;;
end

module Generator = struct
  include Generator
  open Let_syntax

  let singleton = return

  let doubleton x y =
    create (fun ~size:_ ~random -> if Splittable_random.bool random then x else y)
  ;;

  let of_fun f = create (fun ~size ~random -> generate (f ()) ~size ~random)

  let of_sequence ~p seq =
    if Float.( <= ) p 0. || Float.( > ) p 1.
    then
      failwith (Printf.sprintf "Generator.of_sequence: probability [%f] out of bounds" p);
    Sequence.delayed_fold
      seq
      ~init:()
      ~finish:(fun () -> failwith "Generator.of_sequence: ran out of values")
      ~f:(fun () x ~k -> weighted_union [ p, singleton x; 1. -. p, of_fun k ])
  ;;

  let geometric = Generator.int_geometric
  let small_non_negative_int = small_positive_or_zero_int
  let small_positive_int = small_strictly_positive_int
  let list_with_length length t = list_with_length t ~length
  let variant2 = Polymorphic_types.quickcheck_generator_variant2
  let variant3 = Polymorphic_types.quickcheck_generator_variant3
  let variant4 = Polymorphic_types.quickcheck_generator_variant4
  let variant5 = Polymorphic_types.quickcheck_generator_variant5
  let variant6 = Polymorphic_types.quickcheck_generator_variant6
  let tuple2 = Polymorphic_types.quickcheck_generator_tuple2
  let tuple3 = Polymorphic_types.quickcheck_generator_tuple3
  let tuple4 = Polymorphic_types.quickcheck_generator_tuple4
  let tuple5 = Polymorphic_types.quickcheck_generator_tuple5
  let tuple6 = Polymorphic_types.quickcheck_generator_tuple6
  let fn2 = Polymorphic_types.quickcheck_generator_fn2
  let fn3 = Polymorphic_types.quickcheck_generator_fn3
  let fn4 = Polymorphic_types.quickcheck_generator_fn4
  let fn5 = Polymorphic_types.quickcheck_generator_fn5
  let fn6 = Polymorphic_types.quickcheck_generator_fn6

  let compare_fn dom =
    fn dom int
    >>| fun get_index x y ->
    (fun (a__356_ : int) ((b__357_ : int) [@merlin.hide]) ->
       (compare_int a__356_ b__357_ [@merlin.hide]))
      (get_index x)
      (get_index y)
  ;;

  let equal_fn dom = compare_fn dom >>| fun cmp x y -> Int.( = ) (cmp x y) 0
end

module Shrinker = struct
  include Shrinker

  let empty () = atomic
  let variant2 = Polymorphic_types.quickcheck_shrinker_variant2
  let variant3 = Polymorphic_types.quickcheck_shrinker_variant3
  let variant4 = Polymorphic_types.quickcheck_shrinker_variant4
  let variant5 = Polymorphic_types.quickcheck_shrinker_variant5
  let variant6 = Polymorphic_types.quickcheck_shrinker_variant6
  let tuple2 = Polymorphic_types.quickcheck_shrinker_tuple2
  let tuple3 = Polymorphic_types.quickcheck_shrinker_tuple3
  let tuple4 = Polymorphic_types.quickcheck_shrinker_tuple4
  let tuple5 = Polymorphic_types.quickcheck_shrinker_tuple5
  let tuple6 = Polymorphic_types.quickcheck_shrinker_tuple6
end

module Let_syntax = struct
  module Let_syntax = struct
    include Generator
    module Open_on_rhs = Generator
  end

  include Generator.Monad_infix

  let return = Generator.return
end

module Configure (Config : Quickcheck_config) = struct
  include Config

  let nondeterministic_state = lazy (Random.State.make_self_init ())

  let random_state_of_seed seed =
    match seed with
    | `Nondeterministic -> Splittable_random.create (force nondeterministic_state)
    | `Deterministic str -> Splittable_random.of_int (hash_string str)
  ;;

  let make_seed seed : Test.Config.Seed.t =
    match seed with
    | `Nondeterministic -> Nondeterministic
    | `Deterministic string -> Deterministic string
  ;;

  let make_shrink_count = function
    | `Exhaustive -> Int.max_value
    | `Limit n -> n
  ;;

  let make_config ~seed ~sizes ~trials ~shrink_attempts : Test.Config.t =
    { seed = make_seed (Option.value seed ~default:default_seed)
    ; sizes = Option.value sizes ~default:default_sizes
    ; test_count = Option.value trials ~default:default_trial_count
    ; shrink_count =
        make_shrink_count (Option.value shrink_attempts ~default:default_shrink_attempts)
    }
  ;;

  let make_test_m (type a) ~gen ~shrinker ~sexp_of : (module Test.S with type t = a) =
    let module M = struct
      type t = a

      let quickcheck_generator = gen
      let quickcheck_shrinker = Option.value shrinker ~default:Shrinker.atomic

      let sexp_of_t =
        Option.value sexp_of ~default:((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      ;;
    end
    in
    (module M)
  ;;

  let random_value ?(seed = default_seed) ?(size = 30) gen =
    let random = random_state_of_seed seed in
    Generator.generate gen ~size ~random
  ;;

  let random_sequence ?seed ?sizes gen =
    let config =
      make_config ~seed ~sizes ~trials:(Some Int.max_value) ~shrink_attempts:None
    in
    let return = ref Sequence.empty in
    Test.with_sample_exn ~config gen ~f:(fun sequence -> return := sequence);
    !return
  ;;

  let iter ?seed ?sizes ?trials gen ~f =
    let config = make_config ~seed ~sizes ~trials ~shrink_attempts:None in
    Test.with_sample_exn ~config gen ~f:(fun sequence -> Sequence.iter sequence ~f)
  ;;

  let test ?seed ?sizes ?trials ?shrinker ?shrink_attempts ?sexp_of ?examples gen ~f =
    let config = make_config ~seed ~sizes ~trials ~shrink_attempts in
    let test_m = make_test_m ~gen ~shrinker ~sexp_of in
    Test.run_exn ~config ?examples ~f test_m
  ;;

  let test_or_error
        ?seed
        ?sizes
        ?trials
        ?shrinker
        ?shrink_attempts
        ?sexp_of
        ?examples
        gen
        ~f
    =
    let config = make_config ~seed ~sizes ~trials ~shrink_attempts in
    let test_m = make_test_m ~gen ~shrinker ~sexp_of in
    Test.run ~config ?examples ~f test_m
  ;;

  let test_distinct_values
        (type key)
        ?seed
        ?sizes
        ?sexp_of
        gen
        ~trials
        ~distinct_values
        ~compare
    =
    let module M = struct
      type t = key

      let compare : t -> t -> int = compare

      let sexp_of_t =
        match sexp_of with
        | Some sexp_of -> sexp_of
        | None -> sexp_of_opaque
      ;;

      include (val Comparator.make ~compare ~sexp_of_t)
    end
    in
    let fail set =
      let expect_count = distinct_values in
      let actual_count = Set.length set in
      let values =
        match sexp_of with
        | None -> None
        | Some sexp_of_elt ->
          Some
            (((fun x__358_ -> sexp_of_list sexp_of_elt x__358_) [@merlin.hide])
               (Set.to_list set))
      in
      raise_s
        (let ppx_sexp_message () =
           match
             Ppx_sexp_conv_lib.Conv.sexp_of_string "insufficient distinct values"
             :: Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "trials"
                  ; (sexp_of_int [@merlin.hide]) trials
                  ]
             :: Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "expect_count"
                  ; (sexp_of_int [@merlin.hide]) expect_count
                  ]
             :: Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "actual_count"
                  ; (sexp_of_int [@merlin.hide]) actual_count
                  ]
             ::
             (match values, [] with
              | None, tl -> tl
              | Some v, tl ->
                Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "values"
                  ; (Sexp.sexp_of_t [@merlin.hide]) v
                  ]
                :: tl)
           with
           | h :: [] -> h
           | ([] | _ :: _ :: _) as res -> Ppx_sexp_conv_lib.Sexp.List res
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    in
    with_return (fun r ->
      let set = ref (Set.empty (module M)) in
      iter ?seed ?sizes ~trials gen ~f:(fun elt ->
        set := Set.add !set elt;
        if Set.length !set >= distinct_values then r.return ());
      fail !set)
  ;;

  let test_can_generate
        ?seed
        ?sizes
        ?(trials = default_can_generate_trial_count)
        ?sexp_of
        gen
        ~f
    =
    let r = ref [] in
    let f_and_enqueue return x = if f x then return `Can_generate else r := x :: !r in
    match
      With_return.with_return (fun return ->
        iter ?seed ?sizes ~trials gen ~f:(f_and_enqueue return.return);
        `Cannot_generate)
    with
    | `Can_generate -> ()
    | `Cannot_generate ->
      (match sexp_of with
       | None -> failwith "cannot generate"
       | Some sexp_of_value ->
         Error.raise_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string "cannot generate"
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "attempts"
                    ; ((fun x__359_ -> sexp_of_list sexp_of_value x__359_) [@merlin.hide])
                        !r
                    ]
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
  ;;
end

include Configure (struct
    let default_seed = `Deterministic "an arbitrary but deterministic string"

    let default_trial_count =
      match Word_size.word_size with
      | W64 -> 10_000
      | W32 -> 1_000
    ;;

    let default_can_generate_trial_count = 10_000
    let default_shrink_attempts = `Limit 1000
    let default_sizes = Sequence.cycle_list_exn (List.range 0 30 ~stop:`inclusive)
  end)

module type S = S
module type S1 = S1
module type S2 = S2
module type S_int = S_int
module type S_range = S_range

type nonrec seed = seed
type nonrec shrink_attempts = shrink_attempts

module type Quickcheck_config = Quickcheck_config
module type Quickcheck_configured = Quickcheck_configured

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
