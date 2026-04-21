let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ansi_kernel.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ansi_kernel.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module Color_256 = struct
    module V1 = Color_256.Stable.V1
  end

  module Color = struct
    module V1 = struct
      type primary =
        [ `Black
        | `Red
        | `Green
        | `Yellow
        | `Blue
        | `Magenta
        | `Cyan
        | `White
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : primary) -> ()

        let __primary_of_sexp__ =
          (let error_source__006_ = "ansi_kernel.ml.before-ppx.Stable.Color.V1.primary" in
           function
           | Sexplib0.Sexp.Atom atom__002_ as _sexp__004_ ->
             (match atom__002_ with
              | "Black" -> `Black
              | "Red" -> `Red
              | "Green" -> `Green
              | "Yellow" -> `Yellow
              | "Blue" -> `Blue
              | "Magenta" -> `Magenta
              | "Cyan" -> `Cyan
              | "White" -> `White
              | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__002_ :: _) as _sexp__004_ ->
             (match atom__002_ with
              | "Black" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Red" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Green" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Yellow" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Blue" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Magenta" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "Cyan" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | "White" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__006_ _sexp__004_
              | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
               error_source__006_
               sexp__003_
           | Sexplib0.Sexp.List [] as sexp__003_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
               error_source__006_
               sexp__003_
           : Sexplib0.Sexp.t -> primary)
        ;;

        let _ = __primary_of_sexp__

        let primary_of_sexp =
          (let error_source__008_ = "ansi_kernel.ml.before-ppx.Stable.Color.V1.primary" in
           fun sexp__007_ ->
             try __primary_of_sexp__ sexp__007_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__008_
                 sexp__007_
           : Sexplib0.Sexp.t -> primary)
        ;;

        let _ = primary_of_sexp

        let sexp_of_primary =
          (function
           | `Black -> Sexplib0.Sexp.Atom "Black"
           | `Red -> Sexplib0.Sexp.Atom "Red"
           | `Green -> Sexplib0.Sexp.Atom "Green"
           | `Yellow -> Sexplib0.Sexp.Atom "Yellow"
           | `Blue -> Sexplib0.Sexp.Atom "Blue"
           | `Magenta -> Sexplib0.Sexp.Atom "Magenta"
           | `Cyan -> Sexplib0.Sexp.Atom "Cyan"
           | `White -> Sexplib0.Sexp.Atom "White"
           : primary -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_primary

        let compare_primary =
          (fun a__009_ b__010_ ->
             if Stdlib.( == ) a__009_ b__010_
             then 0
             else (
               match a__009_, b__010_ with
               | `Black, `Black -> 0
               | `Red, `Red -> 0
               | `Green, `Green -> 0
               | `Yellow, `Yellow -> 0
               | `Blue, `Blue -> 0
               | `Magenta, `Magenta -> 0
               | `Cyan, `Cyan -> 0
               | `White, `White -> 0
               | x, y -> Stdlib.compare x y)
           : primary -> (primary[@merlin.hide]) -> int)
        ;;

        let _ = compare_primary

        let hash_fold_primary
          : Ppx_hash_lib.Std.Hash.state -> primary -> Ppx_hash_lib.Std.Hash.state
          =
          fun hsv arg ->
          match arg with
          | `Black -> Ppx_hash_lib.Std.Hash.fold_int hsv (-937474657)
          | `Red -> Ppx_hash_lib.Std.Hash.fold_int hsv 4100401
          | `Green -> Ppx_hash_lib.Std.Hash.fold_int hsv 756711075
          | `Yellow -> Ppx_hash_lib.Std.Hash.fold_int hsv 82908052
          | `Blue -> Ppx_hash_lib.Std.Hash.fold_int hsv 737308346
          | `Magenta -> Ppx_hash_lib.Std.Hash.fold_int hsv (-605101559)
          | `Cyan -> Ppx_hash_lib.Std.Hash.fold_int hsv 749039939
          | `White -> Ppx_hash_lib.Std.Hash.fold_int hsv (-588596599)
        ;;

        let _ = hash_fold_primary

        let hash_primary : primary -> Ppx_hash_lib.Std.Hash.hash_value =
          let func arg =
            Ppx_hash_lib.Std.Hash.get_hash_value
              (let hsv = Ppx_hash_lib.Std.Hash.create () in
               hash_fold_primary hsv arg)
          in
          fun x -> func x
        ;;

        let _ = hash_primary

        let equal_primary =
          (fun a__011_ b__012_ ->
             if Stdlib.( == ) a__011_ b__012_
             then true
             else (
               match a__011_, b__012_ with
               | `Black, `Black -> true
               | `Red, `Red -> true
               | `Green, `Green -> true
               | `Yellow, `Yellow -> true
               | `Blue, `Blue -> true
               | `Magenta, `Magenta -> true
               | `Cyan, `Cyan -> true
               | `White, `White -> true
               | x, y -> Stdlib.( = ) x y)
           : primary -> (primary[@merlin.hide]) -> bool)
        ;;

        let _ = equal_primary
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      type t =
        [ primary
        | `Color_256 of Color_256.V1.t
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let __t_of_sexp__ =
          (let error_source__021_ = "ansi_kernel.ml.before-ppx.Stable.Color.V1.t" in
           fun sexp__013_ ->
             try (__primary_of_sexp__ sexp__013_ :> t) with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               (match sexp__013_ with
                | Sexplib0.Sexp.Atom atom__014_ as _sexp__016_ ->
                  (match atom__014_ with
                   | "Color_256" ->
                     Sexplib0.Sexp_conv_error.ptag_takes_args
                       error_source__021_
                       _sexp__016_
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__014_ :: sexp_args__017_) as
                  _sexp__016_ ->
                  (match atom__014_ with
                   | "Color_256" as _tag__018_ ->
                     (match sexp_args__017_ with
                      | arg0__019_ :: [] ->
                        let res0__020_ = Color_256.V1.t_of_sexp arg0__019_ in
                        `Color_256 res0__020_
                      | _ ->
                        Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                          error_source__021_
                          _tag__018_
                          _sexp__016_)
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__015_ ->
                  Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                    error_source__021_
                    sexp__015_
                | Sexplib0.Sexp.List [] as sexp__015_ ->
                  Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                    error_source__021_
                    sexp__015_)
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = __t_of_sexp__

        let t_of_sexp =
          (let error_source__023_ = "ansi_kernel.ml.before-ppx.Stable.Color.V1.t" in
           fun sexp__022_ ->
             try __t_of_sexp__ sexp__022_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__023_
                 sexp__022_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | #primary as v__024_ -> sexp_of_primary v__024_
           | `Color_256 v__025_ ->
             Sexplib0.Sexp.List
               [ Sexplib0.Sexp.Atom "Color_256"; Color_256.V1.sexp_of_t v__025_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__026_ b__027_ ->
             if Stdlib.( == ) a__026_ b__027_
             then 0
             else (
               match a__026_, b__027_ with
               | (#primary as _left__028_), (#primary as _right__029_) ->
                 compare_primary _left__028_ _right__029_
               | `Color_256 _left__030_, `Color_256 _right__031_ ->
                 Color_256.V1.compare _left__030_ _right__031_
               | x, y -> Stdlib.compare x y)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          match arg with
          | #primary as _v -> hash_fold_primary hsv _v
          | `Color_256 _v ->
            let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv (-782720297) in
            Color_256.V1.hash_fold_t hsv _v
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

        let equal =
          (fun a__032_ b__033_ ->
             if Stdlib.( == ) a__032_ b__033_
             then true
             else (
               match a__032_, b__033_ with
               | (#primary as _left__034_), (#primary as _right__035_) ->
                 equal_primary _left__034_ _right__035_
               | `Color_256 _left__036_, `Color_256 _right__037_ ->
                 Color_256.V1.equal _left__036_ _right__037_
               | x, y -> Stdlib.( = ) x y)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 = struct
      type primary =
        [ `Black
        | `Red
        | `Green
        | `Yellow
        | `Blue
        | `Magenta
        | `Cyan
        | `White
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : primary) -> ()

        let __primary_of_sexp__ =
          (let error_source__043_ = "ansi_kernel.ml.before-ppx.Stable.Color.V2.primary" in
           function
           | Sexplib0.Sexp.Atom atom__039_ as _sexp__041_ ->
             (match atom__039_ with
              | "Black" -> `Black
              | "Red" -> `Red
              | "Green" -> `Green
              | "Yellow" -> `Yellow
              | "Blue" -> `Blue
              | "Magenta" -> `Magenta
              | "Cyan" -> `Cyan
              | "White" -> `White
              | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__039_ :: _) as _sexp__041_ ->
             (match atom__039_ with
              | "Black" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Red" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Green" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Yellow" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Blue" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Magenta" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "Cyan" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | "White" ->
                Sexplib0.Sexp_conv_error.ptag_no_args error_source__043_ _sexp__041_
              | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__040_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
               error_source__043_
               sexp__040_
           | Sexplib0.Sexp.List [] as sexp__040_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
               error_source__043_
               sexp__040_
           : Sexplib0.Sexp.t -> primary)
        ;;

        let _ = __primary_of_sexp__

        let primary_of_sexp =
          (let error_source__045_ = "ansi_kernel.ml.before-ppx.Stable.Color.V2.primary" in
           fun sexp__044_ ->
             try __primary_of_sexp__ sexp__044_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__045_
                 sexp__044_
           : Sexplib0.Sexp.t -> primary)
        ;;

        let _ = primary_of_sexp

        let sexp_of_primary =
          (function
           | `Black -> Sexplib0.Sexp.Atom "Black"
           | `Red -> Sexplib0.Sexp.Atom "Red"
           | `Green -> Sexplib0.Sexp.Atom "Green"
           | `Yellow -> Sexplib0.Sexp.Atom "Yellow"
           | `Blue -> Sexplib0.Sexp.Atom "Blue"
           | `Magenta -> Sexplib0.Sexp.Atom "Magenta"
           | `Cyan -> Sexplib0.Sexp.Atom "Cyan"
           | `White -> Sexplib0.Sexp.Atom "White"
           : primary -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_primary

        let compare_primary =
          (fun a__046_ b__047_ ->
             if Stdlib.( == ) a__046_ b__047_
             then 0
             else (
               match a__046_, b__047_ with
               | `Black, `Black -> 0
               | `Red, `Red -> 0
               | `Green, `Green -> 0
               | `Yellow, `Yellow -> 0
               | `Blue, `Blue -> 0
               | `Magenta, `Magenta -> 0
               | `Cyan, `Cyan -> 0
               | `White, `White -> 0
               | x, y -> Stdlib.compare x y)
           : primary -> (primary[@merlin.hide]) -> int)
        ;;

        let _ = compare_primary

        let hash_fold_primary
          : Ppx_hash_lib.Std.Hash.state -> primary -> Ppx_hash_lib.Std.Hash.state
          =
          fun hsv arg ->
          match arg with
          | `Black -> Ppx_hash_lib.Std.Hash.fold_int hsv (-937474657)
          | `Red -> Ppx_hash_lib.Std.Hash.fold_int hsv 4100401
          | `Green -> Ppx_hash_lib.Std.Hash.fold_int hsv 756711075
          | `Yellow -> Ppx_hash_lib.Std.Hash.fold_int hsv 82908052
          | `Blue -> Ppx_hash_lib.Std.Hash.fold_int hsv 737308346
          | `Magenta -> Ppx_hash_lib.Std.Hash.fold_int hsv (-605101559)
          | `Cyan -> Ppx_hash_lib.Std.Hash.fold_int hsv 749039939
          | `White -> Ppx_hash_lib.Std.Hash.fold_int hsv (-588596599)
        ;;

        let _ = hash_fold_primary

        let hash_primary : primary -> Ppx_hash_lib.Std.Hash.hash_value =
          let func arg =
            Ppx_hash_lib.Std.Hash.get_hash_value
              (let hsv = Ppx_hash_lib.Std.Hash.create () in
               hash_fold_primary hsv arg)
          in
          fun x -> func x
        ;;

        let _ = hash_primary

        let equal_primary =
          (fun a__048_ b__049_ ->
             if Stdlib.( == ) a__048_ b__049_
             then true
             else (
               match a__048_, b__049_ with
               | `Black, `Black -> true
               | `Red, `Red -> true
               | `Green, `Green -> true
               | `Yellow, `Yellow -> true
               | `Blue, `Blue -> true
               | `Magenta, `Magenta -> true
               | `Cyan, `Cyan -> true
               | `White, `White -> true
               | x, y -> Stdlib.( = ) x y)
           : primary -> (primary[@merlin.hide]) -> bool)
        ;;

        let _ = equal_primary
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      type t =
        [ primary
        | `Color_256 of Color_256.V1.t
        | `Default_color
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let __t_of_sexp__ =
          (let error_source__055_ = "ansi_kernel.ml.before-ppx.Stable.Color.V2.t" in
           fun sexp__050_ ->
             try (__primary_of_sexp__ sexp__050_ :> t) with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               (match sexp__050_ with
                | Sexplib0.Sexp.Atom atom__051_ as _sexp__053_ ->
                  (match atom__051_ with
                   | "Default_color" -> `Default_color
                   | "Color_256" ->
                     Sexplib0.Sexp_conv_error.ptag_takes_args
                       error_source__055_
                       _sexp__053_
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__051_ :: sexp_args__054_) as
                  _sexp__053_ ->
                  (match atom__051_ with
                   | "Color_256" as _tag__056_ ->
                     (match sexp_args__054_ with
                      | arg0__057_ :: [] ->
                        let res0__058_ = Color_256.V1.t_of_sexp arg0__057_ in
                        `Color_256 res0__058_
                      | _ ->
                        Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                          error_source__055_
                          _tag__056_
                          _sexp__053_)
                   | "Default_color" ->
                     Sexplib0.Sexp_conv_error.ptag_no_args error_source__055_ _sexp__053_
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__052_ ->
                  Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                    error_source__055_
                    sexp__052_
                | Sexplib0.Sexp.List [] as sexp__052_ ->
                  Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                    error_source__055_
                    sexp__052_)
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = __t_of_sexp__

        let t_of_sexp =
          (let error_source__060_ = "ansi_kernel.ml.before-ppx.Stable.Color.V2.t" in
           fun sexp__059_ ->
             try __t_of_sexp__ sexp__059_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__060_
                 sexp__059_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | #primary as v__061_ -> sexp_of_primary v__061_
           | `Color_256 v__062_ ->
             Sexplib0.Sexp.List
               [ Sexplib0.Sexp.Atom "Color_256"; Color_256.V1.sexp_of_t v__062_ ]
           | `Default_color -> Sexplib0.Sexp.Atom "Default_color"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__063_ b__064_ ->
             if Stdlib.( == ) a__063_ b__064_
             then 0
             else (
               match a__063_, b__064_ with
               | (#primary as _left__065_), (#primary as _right__066_) ->
                 compare_primary _left__065_ _right__066_
               | `Color_256 _left__067_, `Color_256 _right__068_ ->
                 Color_256.V1.compare _left__067_ _right__068_
               | `Default_color, `Default_color -> 0
               | x, y -> Stdlib.compare x y)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          match arg with
          | #primary as _v -> hash_fold_primary hsv _v
          | `Color_256 _v ->
            let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv (-782720297) in
            Color_256.V1.hash_fold_t hsv _v
          | `Default_color -> Ppx_hash_lib.Std.Hash.fold_int hsv (-736598011)
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

        let equal =
          (fun a__069_ b__070_ ->
             if Stdlib.( == ) a__069_ b__070_
             then true
             else (
               match a__069_, b__070_ with
               | (#primary as _left__071_), (#primary as _right__072_) ->
                 equal_primary _left__071_ _right__072_
               | `Color_256 _left__073_, `Color_256 _right__074_ ->
                 Color_256.V1.equal _left__073_ _right__074_
               | `Default_color, `Default_color -> true
               | x, y -> Stdlib.( = ) x y)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_v1 (t : V1.t) = (t :> t)

      let to_v1 (t : t) ~foreground =
        match t with
        | #V1.t as t -> t
        | `Default_color -> if foreground then `White else `Black
      ;;

      let primary_of_v1 (t : V1.primary) : primary = t
      let primary_to_v1 (t : primary) : V1.primary = t
    end
  end

  module Attr = struct
    module V1 = struct
      type t =
        [ `Bright
        | `Dim
        | `Underscore
        | `Reverse
        | Color.V1.t
        | `Bg of Color.V1.t
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let __t_of_sexp__ =
          (let error_source__080_ = "ansi_kernel.ml.before-ppx.Stable.Attr.V1.t" in
           function
           | Sexplib0.Sexp.Atom atom__076_ as _sexp__078_ ->
             (match atom__076_ with
              | "Bright" -> `Bright
              | "Dim" -> `Dim
              | "Underscore" -> `Underscore
              | "Reverse" -> `Reverse
              | _ ->
                (try (Color.V1.__t_of_sexp__ _sexp__078_ :> t) with
                 | Sexplib0.Sexp_conv_error.No_variant_match ->
                   (match atom__076_ with
                    | "Bg" ->
                      Sexplib0.Sexp_conv_error.ptag_takes_args
                        error_source__080_
                        _sexp__078_
                    | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())))
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__076_ :: sexp_args__079_) as
             _sexp__078_ ->
             (try (Color.V1.__t_of_sexp__ _sexp__078_ :> t) with
              | Sexplib0.Sexp_conv_error.No_variant_match ->
                (match atom__076_ with
                 | "Bg" as _tag__081_ ->
                   (match sexp_args__079_ with
                    | arg0__082_ :: [] ->
                      let res0__083_ = Color.V1.t_of_sexp arg0__082_ in
                      `Bg res0__083_
                    | _ ->
                      Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                        error_source__080_
                        _tag__081_
                        _sexp__078_)
                 | "Bright" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__080_ _sexp__078_
                 | "Dim" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__080_ _sexp__078_
                 | "Underscore" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__080_ _sexp__078_
                 | "Reverse" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__080_ _sexp__078_
                 | _ -> Sexplib0.Sexp_conv_error.no_variant_match ()))
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__077_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
               error_source__080_
               sexp__077_
           | Sexplib0.Sexp.List [] as sexp__077_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
               error_source__080_
               sexp__077_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = __t_of_sexp__

        let t_of_sexp =
          (let error_source__085_ = "ansi_kernel.ml.before-ppx.Stable.Attr.V1.t" in
           fun sexp__084_ ->
             try __t_of_sexp__ sexp__084_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__085_
                 sexp__084_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | `Bright -> Sexplib0.Sexp.Atom "Bright"
           | `Dim -> Sexplib0.Sexp.Atom "Dim"
           | `Underscore -> Sexplib0.Sexp.Atom "Underscore"
           | `Reverse -> Sexplib0.Sexp.Atom "Reverse"
           | #Color.V1.t as v__086_ -> Color.V1.sexp_of_t v__086_
           | `Bg v__087_ ->
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Bg"; Color.V1.sexp_of_t v__087_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__088_ b__089_ ->
             if Stdlib.( == ) a__088_ b__089_
             then 0
             else (
               match a__088_, b__089_ with
               | `Bright, `Bright -> 0
               | `Dim, `Dim -> 0
               | `Underscore, `Underscore -> 0
               | `Reverse, `Reverse -> 0
               | (#Color.V1.t as _left__090_), (#Color.V1.t as _right__091_) ->
                 Color.V1.compare _left__090_ _right__091_
               | `Bg _left__092_, `Bg _right__093_ ->
                 Color.V1.compare _left__092_ _right__093_
               | x, y -> Stdlib.compare x y)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          match arg with
          | `Bright -> Ppx_hash_lib.Std.Hash.fold_int hsv (-856564646)
          | `Dim -> Ppx_hash_lib.Std.Hash.fold_int hsv 3405096
          | `Underscore -> Ppx_hash_lib.Std.Hash.fold_int hsv (-911610022)
          | `Reverse -> Ppx_hash_lib.Std.Hash.fold_int hsv (-397582078)
          | #Color.V1.t as _v -> Color.V1.hash_fold_t hsv _v
          | `Bg _v ->
            let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 14821 in
            Color.V1.hash_fold_t hsv _v
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

        let equal =
          (fun a__094_ b__095_ ->
             if Stdlib.( == ) a__094_ b__095_
             then true
             else (
               match a__094_, b__095_ with
               | `Bright, `Bright -> true
               | `Dim, `Dim -> true
               | `Underscore, `Underscore -> true
               | `Reverse, `Reverse -> true
               | (#Color.V1.t as _left__096_), (#Color.V1.t as _right__097_) ->
                 Color.V1.equal _left__096_ _right__097_
               | `Bg _left__098_, `Bg _right__099_ ->
                 Color.V1.equal _left__098_ _right__099_
               | x, y -> Stdlib.( = ) x y)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V2 = struct
      type t =
        [ `Bright
        | `Dim
        | `Underscore
        | `Reverse
        | Color.V2.t
        | `Bg of Color.V2.t
        ]
      [@@deriving sexp, compare, hash, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let __t_of_sexp__ =
          (let error_source__105_ = "ansi_kernel.ml.before-ppx.Stable.Attr.V2.t" in
           function
           | Sexplib0.Sexp.Atom atom__101_ as _sexp__103_ ->
             (match atom__101_ with
              | "Bright" -> `Bright
              | "Dim" -> `Dim
              | "Underscore" -> `Underscore
              | "Reverse" -> `Reverse
              | _ ->
                (try (Color.V2.__t_of_sexp__ _sexp__103_ :> t) with
                 | Sexplib0.Sexp_conv_error.No_variant_match ->
                   (match atom__101_ with
                    | "Bg" ->
                      Sexplib0.Sexp_conv_error.ptag_takes_args
                        error_source__105_
                        _sexp__103_
                    | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())))
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__101_ :: sexp_args__104_) as
             _sexp__103_ ->
             (try (Color.V2.__t_of_sexp__ _sexp__103_ :> t) with
              | Sexplib0.Sexp_conv_error.No_variant_match ->
                (match atom__101_ with
                 | "Bg" as _tag__106_ ->
                   (match sexp_args__104_ with
                    | arg0__107_ :: [] ->
                      let res0__108_ = Color.V2.t_of_sexp arg0__107_ in
                      `Bg res0__108_
                    | _ ->
                      Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                        error_source__105_
                        _tag__106_
                        _sexp__103_)
                 | "Bright" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__105_ _sexp__103_
                 | "Dim" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__105_ _sexp__103_
                 | "Underscore" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__105_ _sexp__103_
                 | "Reverse" ->
                   Sexplib0.Sexp_conv_error.ptag_no_args error_source__105_ _sexp__103_
                 | _ -> Sexplib0.Sexp_conv_error.no_variant_match ()))
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__102_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
               error_source__105_
               sexp__102_
           | Sexplib0.Sexp.List [] as sexp__102_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
               error_source__105_
               sexp__102_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = __t_of_sexp__

        let t_of_sexp =
          (let error_source__110_ = "ansi_kernel.ml.before-ppx.Stable.Attr.V2.t" in
           fun sexp__109_ ->
             try __t_of_sexp__ sexp__109_ with
             | Sexplib0.Sexp_conv_error.No_variant_match ->
               Sexplib0.Sexp_conv_error.no_matching_variant_found
                 error_source__110_
                 sexp__109_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let sexp_of_t =
          (function
           | `Bright -> Sexplib0.Sexp.Atom "Bright"
           | `Dim -> Sexplib0.Sexp.Atom "Dim"
           | `Underscore -> Sexplib0.Sexp.Atom "Underscore"
           | `Reverse -> Sexplib0.Sexp.Atom "Reverse"
           | #Color.V2.t as v__111_ -> Color.V2.sexp_of_t v__111_
           | `Bg v__112_ ->
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Bg"; Color.V2.sexp_of_t v__112_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t

        let compare =
          (fun a__113_ b__114_ ->
             if Stdlib.( == ) a__113_ b__114_
             then 0
             else (
               match a__113_, b__114_ with
               | `Bright, `Bright -> 0
               | `Dim, `Dim -> 0
               | `Underscore, `Underscore -> 0
               | `Reverse, `Reverse -> 0
               | (#Color.V2.t as _left__115_), (#Color.V2.t as _right__116_) ->
                 Color.V2.compare _left__115_ _right__116_
               | `Bg _left__117_, `Bg _right__118_ ->
                 Color.V2.compare _left__117_ _right__118_
               | x, y -> Stdlib.compare x y)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          match arg with
          | `Bright -> Ppx_hash_lib.Std.Hash.fold_int hsv (-856564646)
          | `Dim -> Ppx_hash_lib.Std.Hash.fold_int hsv 3405096
          | `Underscore -> Ppx_hash_lib.Std.Hash.fold_int hsv (-911610022)
          | `Reverse -> Ppx_hash_lib.Std.Hash.fold_int hsv (-397582078)
          | #Color.V2.t as _v -> Color.V2.hash_fold_t hsv _v
          | `Bg _v ->
            let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 14821 in
            Color.V2.hash_fold_t hsv _v
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

        let equal =
          (fun a__119_ b__120_ ->
             if Stdlib.( == ) a__119_ b__120_
             then true
             else (
               match a__119_, b__120_ with
               | `Bright, `Bright -> true
               | `Dim, `Dim -> true
               | `Underscore, `Underscore -> true
               | `Reverse, `Reverse -> true
               | (#Color.V2.t as _left__121_), (#Color.V2.t as _right__122_) ->
                 Color.V2.equal _left__121_ _right__122_
               | `Bg _left__123_, `Bg _right__124_ ->
                 Color.V2.equal _left__123_ _right__124_
               | x, y -> Stdlib.( = ) x y)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_v1 (t : V1.t) = (t :> t)

      let to_v1 (t : t) : V1.t =
        match t with
        | #Color.V2.t as fg -> Color.V2.to_v1 fg ~foreground:true
        | `Bg bg -> `Bg (Color.V2.to_v1 bg ~foreground:false)
        | (`Bright | `Dim | `Underscore | `Reverse) as t -> t
      ;;
    end
  end
end

open! Core
module Color_256 = Color_256

module Color = struct
  type primary = Stable.Color.V2.primary [@@deriving sexp_of, compare, hash, equal]

  include struct
    let _ = fun (_ : primary) -> ()
    let sexp_of_primary = (Stable.Color.V2.sexp_of_primary : primary -> Sexplib0.Sexp.t)
    let _ = sexp_of_primary

    let compare_primary =
      (fun a__125_ b__126_ -> Stable.Color.V2.compare_primary a__125_ b__126_
       : primary -> (primary[@merlin.hide]) -> int)
    ;;

    let _ = compare_primary

    let hash_fold_primary
      : Ppx_hash_lib.Std.Hash.state -> primary -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Stable.Color.V2.hash_fold_primary hsv arg

    and hash_primary : primary -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Stable.Color.V2.hash_primary in
      fun x -> func x
    ;;

    let _ = hash_fold_primary
    and _ = hash_primary

    let equal_primary =
      (fun a__127_ b__128_ -> Stable.Color.V2.equal_primary a__127_ b__128_
       : primary -> (primary[@merlin.hide]) -> bool)
    ;;

    let _ = equal_primary
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = Stable.Color.V2.t [@@deriving sexp_of, compare, hash, equal]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (Stable.Color.V2.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t

    let compare =
      (fun a__129_ b__130_ -> Stable.Color.V2.compare a__129_ b__130_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Stable.Color.V2.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Stable.Color.V2.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let equal =
      (fun a__131_ b__132_ -> Stable.Color.V2.equal a__131_ b__132_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_int_list = function
    | `Black -> [ 30 ]
    | `Red -> [ 31 ]
    | `Green -> [ 32 ]
    | `Yellow -> [ 33 ]
    | `Blue -> [ 34 ]
    | `Magenta -> [ 35 ]
    | `Cyan -> [ 36 ]
    | `White -> [ 37 ]
    | `Color_256 c -> [ 38; 5; Color_256.to_int c ]
    | `Default_color -> [ 39 ]
  ;;
end

module Attr = struct
  type t = Stable.Attr.V2.t [@@deriving sexp_of, compare, hash, equal]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (Stable.Attr.V2.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t

    let compare =
      (fun a__133_ b__134_ -> Stable.Attr.V2.compare a__133_ b__134_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Stable.Attr.V2.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Stable.Attr.V2.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let equal =
      (fun a__135_ b__136_ -> Stable.Attr.V2.equal a__135_ b__136_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_int_list = function
    | `Bright -> [ 1 ]
    | `Dim -> [ 2 ]
    | `Underscore -> [ 4 ]
    | `Reverse -> [ 7 ]
    | #Color.t as c -> Color.to_int_list c
    | `Bg bg ->
      (match Color.to_int_list bg with
       | ansi_code :: rest -> (ansi_code + 10) :: rest
       | [] -> [])
  ;;

  let list_to_string = function
    | [] -> ""
    | l ->
      sprintf
        "\027[%sm"
        (String.concat
           ~sep:";"
           (List.concat_map l ~f:(fun att -> List.map ~f:string_of_int (to_int_list att))))
  ;;
end

module With_all_attrs = struct
  type t =
    [ Attr.t
    | `Reset
    | `Blink
    | `Hidden
    ]
  [@@deriving sexp_of, compare, hash, equal]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | #Attr.t as v__137_ -> Attr.sexp_of_t v__137_
       | `Reset -> Sexplib0.Sexp.Atom "Reset"
       | `Blink -> Sexplib0.Sexp.Atom "Blink"
       | `Hidden -> Sexplib0.Sexp.Atom "Hidden"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let compare =
      (fun a__138_ b__139_ ->
         if Stdlib.( == ) a__138_ b__139_
         then 0
         else (
           match a__138_, b__139_ with
           | (#Attr.t as _left__140_), (#Attr.t as _right__141_) ->
             Attr.compare _left__140_ _right__141_
           | `Reset, `Reset -> 0
           | `Blink, `Blink -> 0
           | `Hidden, `Hidden -> 0
           | x, y -> Stdlib.compare x y)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg ->
      match arg with
      | #Attr.t as _v -> Attr.hash_fold_t hsv _v
      | `Reset -> Ppx_hash_lib.Std.Hash.fold_int hsv (-101336657)
      | `Blink -> Ppx_hash_lib.Std.Hash.fold_int hsv (-937074372)
      | `Hidden -> Ppx_hash_lib.Std.Hash.fold_int hsv 19559306
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

    let equal =
      (fun a__142_ b__143_ ->
         if Stdlib.( == ) a__142_ b__143_
         then true
         else (
           match a__142_, b__143_ with
           | (#Attr.t as _left__144_), (#Attr.t as _right__145_) ->
             Attr.equal _left__144_ _right__145_
           | `Reset, `Reset -> true
           | `Blink, `Blink -> true
           | `Hidden, `Hidden -> true
           | x, y -> Stdlib.( = ) x y)
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_int_list = function
    | `Reset -> [ 0 ]
    | `Blink -> [ 5 ]
    | `Hidden -> [ 8 ]
    | #Attr.t as attr -> Attr.to_int_list attr
  ;;

  let list_to_string = function
    | [] -> ""
    | l ->
      sprintf
        "\027[%sm"
        (String.concat
           ~sep:";"
           (List.concat_map l ~f:(fun att -> List.map ~f:string_of_int (to_int_list att))))
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
