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

let default_context = 16
let default_line_big_enough = 3
let default_word_big_enough = 7
let too_short_to_split = 2
let warn_if_no_trailing_newline_in_both_default = true

type t =
  { output : Output.t
  ; rules : Format.Rules.t
  ; float_tolerance : Percent.t option
  ; produce_unified_lines : bool
  ; unrefined : bool
  ; keep_ws : bool
  ; find_moves : bool
  ; split_long_lines : bool
  ; interleave : bool
  ; assume_text : bool
  ; context : int
  ; line_big_enough : int
  ; word_big_enough : int
  ; shallow : bool
  ; quiet : bool
  ; double_check : bool
  ; mask_uniques : bool
  ; prev_alt : string option
  ; next_alt : string option
  ; location_style : Format.Location_style.t
  ; warn_if_no_trailing_newline_in_both : bool
        [@default warn_if_no_trailing_newline_in_both_default] [@sexp_drop_default.equal]
  }
[@@deriving compare, fields ~iterators:(iter, map), sexp_of]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  let compare =
    (fun a__001_ b__002_ ->
       if Stdlib.( == ) a__001_ b__002_
       then 0
       else (
         match Output.compare a__001_.output b__002_.output with
         | 0 ->
           (match Format.Rules.compare a__001_.rules b__002_.rules with
            | 0 ->
              (match
                 compare_option
                   (fun a__003_ (b__004_ [@merlin.hide]) ->
                      (Percent.compare a__003_ b__004_ [@merlin.hide]))
                   a__001_.float_tolerance
                   b__002_.float_tolerance
               with
               | 0 ->
                 (match
                    compare_bool
                      a__001_.produce_unified_lines
                      b__002_.produce_unified_lines
                  with
                  | 0 ->
                    (match compare_bool a__001_.unrefined b__002_.unrefined with
                     | 0 ->
                       (match compare_bool a__001_.keep_ws b__002_.keep_ws with
                        | 0 ->
                          (match compare_bool a__001_.find_moves b__002_.find_moves with
                           | 0 ->
                             (match
                                compare_bool
                                  a__001_.split_long_lines
                                  b__002_.split_long_lines
                              with
                              | 0 ->
                                (match
                                   compare_bool a__001_.interleave b__002_.interleave
                                 with
                                 | 0 ->
                                   (match
                                      compare_bool a__001_.assume_text b__002_.assume_text
                                    with
                                    | 0 ->
                                      (match
                                         compare_int a__001_.context b__002_.context
                                       with
                                       | 0 ->
                                         (match
                                            compare_int
                                              a__001_.line_big_enough
                                              b__002_.line_big_enough
                                          with
                                          | 0 ->
                                            (match
                                               compare_int
                                                 a__001_.word_big_enough
                                                 b__002_.word_big_enough
                                             with
                                             | 0 ->
                                               (match
                                                  compare_bool
                                                    a__001_.shallow
                                                    b__002_.shallow
                                                with
                                                | 0 ->
                                                  (match
                                                     compare_bool
                                                       a__001_.quiet
                                                       b__002_.quiet
                                                   with
                                                   | 0 ->
                                                     (match
                                                        compare_bool
                                                          a__001_.double_check
                                                          b__002_.double_check
                                                      with
                                                      | 0 ->
                                                        (match
                                                           compare_bool
                                                             a__001_.mask_uniques
                                                             b__002_.mask_uniques
                                                         with
                                                         | 0 ->
                                                           (match
                                                              compare_option
                                                                (fun a__005_
                                                                  (b__006_ [@merlin.hide]) ->
                                                                   (compare_string
                                                                      a__005_
                                                                      b__006_
                                                                    [@merlin.hide]))
                                                                a__001_.prev_alt
                                                                b__002_.prev_alt
                                                            with
                                                            | 0 ->
                                                              (match
                                                                 compare_option
                                                                   (fun a__007_
                                                                     (b__008_
                                                                      [@merlin.hide]) ->
                                                                      (compare_string
                                                                         a__007_
                                                                         b__008_
                                                                       [@merlin.hide]))
                                                                   a__001_.next_alt
                                                                   b__002_.next_alt
                                                               with
                                                               | 0 ->
                                                                 (match
                                                                    Format.Location_style
                                                                    .compare
                                                                      a__001_
                                                                        .location_style
                                                                      b__002_
                                                                        .location_style
                                                                  with
                                                                  | 0 ->
                                                                    compare_bool
                                                                      a__001_
                                                                        .warn_if_no_trailing_newline_in_both
                                                                      b__002_
                                                                        .warn_if_no_trailing_newline_in_both
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
               | n -> n)
            | n -> n)
         | n -> n)
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare
  let warn_if_no_trailing_newline_in_both _r__ = _r__.warn_if_no_trailing_newline_in_both
  let _ = warn_if_no_trailing_newline_in_both
  let location_style _r__ = _r__.location_style
  let _ = location_style
  let next_alt _r__ = _r__.next_alt
  let _ = next_alt
  let prev_alt _r__ = _r__.prev_alt
  let _ = prev_alt
  let mask_uniques _r__ = _r__.mask_uniques
  let _ = mask_uniques
  let double_check _r__ = _r__.double_check
  let _ = double_check
  let quiet _r__ = _r__.quiet
  let _ = quiet
  let shallow _r__ = _r__.shallow
  let _ = shallow
  let word_big_enough _r__ = _r__.word_big_enough
  let _ = word_big_enough
  let line_big_enough _r__ = _r__.line_big_enough
  let _ = line_big_enough
  let context _r__ = _r__.context
  let _ = context
  let assume_text _r__ = _r__.assume_text
  let _ = assume_text
  let interleave _r__ = _r__.interleave
  let _ = interleave
  let split_long_lines _r__ = _r__.split_long_lines
  let _ = split_long_lines
  let find_moves _r__ = _r__.find_moves
  let _ = find_moves
  let keep_ws _r__ = _r__.keep_ws
  let _ = keep_ws
  let unrefined _r__ = _r__.unrefined
  let _ = unrefined
  let produce_unified_lines _r__ = _r__.produce_unified_lines
  let _ = produce_unified_lines
  let float_tolerance _r__ = _r__.float_tolerance
  let _ = float_tolerance
  let rules _r__ = _r__.rules
  let _ = rules
  let output _r__ = _r__.output
  let _ = output

  module Fields = struct
    let warn_if_no_trailing_newline_in_both =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "warn_if_no_trailing_newline_in_both"
         ; getter = warn_if_no_trailing_newline_in_both
         ; setter = None
         ; fset =
             (fun _r__ v__ -> { _r__ with warn_if_no_trailing_newline_in_both = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = warn_if_no_trailing_newline_in_both

    let location_style =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "location_style"
         ; getter = location_style
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with location_style = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , Format.Location_style.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = location_style

    let next_alt =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "next_alt"
         ; getter = next_alt
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with next_alt = v__ })
         }
       : ([< `Read | `Set_and_create ], _, string option) Fieldslib.Field.t_with_perm)
    ;;

    let _ = next_alt

    let prev_alt =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "prev_alt"
         ; getter = prev_alt
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with prev_alt = v__ })
         }
       : ([< `Read | `Set_and_create ], _, string option) Fieldslib.Field.t_with_perm)
    ;;

    let _ = prev_alt

    let mask_uniques =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "mask_uniques"
         ; getter = mask_uniques
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with mask_uniques = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = mask_uniques

    let double_check =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "double_check"
         ; getter = double_check
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with double_check = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = double_check

    let quiet =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "quiet"
         ; getter = quiet
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with quiet = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = quiet

    let shallow =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "shallow"
         ; getter = shallow
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with shallow = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = shallow

    let word_big_enough =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "word_big_enough"
         ; getter = word_big_enough
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with word_big_enough = v__ })
         }
       : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
    ;;

    let _ = word_big_enough

    let line_big_enough =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "line_big_enough"
         ; getter = line_big_enough
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with line_big_enough = v__ })
         }
       : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
    ;;

    let _ = line_big_enough

    let context =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "context"
         ; getter = context
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with context = v__ })
         }
       : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
    ;;

    let _ = context

    let assume_text =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "assume_text"
         ; getter = assume_text
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with assume_text = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = assume_text

    let interleave =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "interleave"
         ; getter = interleave
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with interleave = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = interleave

    let split_long_lines =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "split_long_lines"
         ; getter = split_long_lines
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with split_long_lines = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = split_long_lines

    let find_moves =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "find_moves"
         ; getter = find_moves
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with find_moves = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = find_moves

    let keep_ws =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "keep_ws"
         ; getter = keep_ws
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with keep_ws = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = keep_ws

    let unrefined =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "unrefined"
         ; getter = unrefined
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with unrefined = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = unrefined

    let produce_unified_lines =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "produce_unified_lines"
         ; getter = produce_unified_lines
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with produce_unified_lines = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = produce_unified_lines

    let float_tolerance =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "float_tolerance"
         ; getter = float_tolerance
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with float_tolerance = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Percent.t option) Fieldslib.Field.t_with_perm)
    ;;

    let _ = float_tolerance

    let rules =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "rules"
         ; getter = rules
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with rules = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Format.Rules.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = rules

    let output =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "output"
         ; getter = output
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with output = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Output.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = output

    let map
          ~output:output_fun__
          ~rules:rules_fun__
          ~float_tolerance:float_tolerance_fun__
          ~produce_unified_lines:produce_unified_lines_fun__
          ~unrefined:unrefined_fun__
          ~keep_ws:keep_ws_fun__
          ~find_moves:find_moves_fun__
          ~split_long_lines:split_long_lines_fun__
          ~interleave:interleave_fun__
          ~assume_text:assume_text_fun__
          ~context:context_fun__
          ~line_big_enough:line_big_enough_fun__
          ~word_big_enough:word_big_enough_fun__
          ~shallow:shallow_fun__
          ~quiet:quiet_fun__
          ~double_check:double_check_fun__
          ~mask_uniques:mask_uniques_fun__
          ~prev_alt:prev_alt_fun__
          ~next_alt:next_alt_fun__
          ~location_style:location_style_fun__
          ~warn_if_no_trailing_newline_in_both:warn_if_no_trailing_newline_in_both_fun__
      =
      { output = output_fun__ output
      ; rules = rules_fun__ rules
      ; float_tolerance = float_tolerance_fun__ float_tolerance
      ; produce_unified_lines = produce_unified_lines_fun__ produce_unified_lines
      ; unrefined = unrefined_fun__ unrefined
      ; keep_ws = keep_ws_fun__ keep_ws
      ; find_moves = find_moves_fun__ find_moves
      ; split_long_lines = split_long_lines_fun__ split_long_lines
      ; interleave = interleave_fun__ interleave
      ; assume_text = assume_text_fun__ assume_text
      ; context = context_fun__ context
      ; line_big_enough = line_big_enough_fun__ line_big_enough
      ; word_big_enough = word_big_enough_fun__ word_big_enough
      ; shallow = shallow_fun__ shallow
      ; quiet = quiet_fun__ quiet
      ; double_check = double_check_fun__ double_check
      ; mask_uniques = mask_uniques_fun__ mask_uniques
      ; prev_alt = prev_alt_fun__ prev_alt
      ; next_alt = next_alt_fun__ next_alt
      ; location_style = location_style_fun__ location_style
      ; warn_if_no_trailing_newline_in_both =
          warn_if_no_trailing_newline_in_both_fun__ warn_if_no_trailing_newline_in_both
      }
    ;;

    let _ = map

    let iter
          ~output:output_fun__
          ~rules:rules_fun__
          ~float_tolerance:float_tolerance_fun__
          ~produce_unified_lines:produce_unified_lines_fun__
          ~unrefined:unrefined_fun__
          ~keep_ws:keep_ws_fun__
          ~find_moves:find_moves_fun__
          ~split_long_lines:split_long_lines_fun__
          ~interleave:interleave_fun__
          ~assume_text:assume_text_fun__
          ~context:context_fun__
          ~line_big_enough:line_big_enough_fun__
          ~word_big_enough:word_big_enough_fun__
          ~shallow:shallow_fun__
          ~quiet:quiet_fun__
          ~double_check:double_check_fun__
          ~mask_uniques:mask_uniques_fun__
          ~prev_alt:prev_alt_fun__
          ~next_alt:next_alt_fun__
          ~location_style:location_style_fun__
          ~warn_if_no_trailing_newline_in_both:warn_if_no_trailing_newline_in_both_fun__
      =
      (output_fun__ output : unit);
      (rules_fun__ rules : unit);
      (float_tolerance_fun__ float_tolerance : unit);
      (produce_unified_lines_fun__ produce_unified_lines : unit);
      (unrefined_fun__ unrefined : unit);
      (keep_ws_fun__ keep_ws : unit);
      (find_moves_fun__ find_moves : unit);
      (split_long_lines_fun__ split_long_lines : unit);
      (interleave_fun__ interleave : unit);
      (assume_text_fun__ assume_text : unit);
      (context_fun__ context : unit);
      (line_big_enough_fun__ line_big_enough : unit);
      (word_big_enough_fun__ word_big_enough : unit);
      (shallow_fun__ shallow : unit);
      (quiet_fun__ quiet : unit);
      (double_check_fun__ double_check : unit);
      (mask_uniques_fun__ mask_uniques : unit);
      (prev_alt_fun__ prev_alt : unit);
      (next_alt_fun__ next_alt : unit);
      (location_style_fun__ location_style : unit);
      (warn_if_no_trailing_newline_in_both_fun__ warn_if_no_trailing_newline_in_both
       : unit)
    ;;

    let _ = iter
  end

  let sexp_of_t =
    (let default__051_ : bool = warn_if_no_trailing_newline_in_both_default in
     fun { output = output__010_
         ; rules = rules__012_
         ; float_tolerance = float_tolerance__014_
         ; produce_unified_lines = produce_unified_lines__016_
         ; unrefined = unrefined__018_
         ; keep_ws = keep_ws__020_
         ; find_moves = find_moves__022_
         ; split_long_lines = split_long_lines__024_
         ; interleave = interleave__026_
         ; assume_text = assume_text__028_
         ; context = context__030_
         ; line_big_enough = line_big_enough__032_
         ; word_big_enough = word_big_enough__034_
         ; shallow = shallow__036_
         ; quiet = quiet__038_
         ; double_check = double_check__040_
         ; mask_uniques = mask_uniques__042_
         ; prev_alt = prev_alt__044_
         ; next_alt = next_alt__046_
         ; location_style = location_style__048_
         ; warn_if_no_trailing_newline_in_both = warn_if_no_trailing_newline_in_both__052_
         } ->
       let bnds__009_ = ([] : _ Stdlib.List.t) in
       let bnds__009_ =
         if
           (fun (a__055_ : bool) ((b__056_ : bool) [@merlin.hide]) ->
              (equal_bool a__055_ b__056_ [@merlin.hide]))
             default__051_
             warn_if_no_trailing_newline_in_both__052_
         then bnds__009_
         else (
           let arg__054_ = sexp_of_bool warn_if_no_trailing_newline_in_both__052_ in
           let bnd__053_ =
             Sexplib0.Sexp.List
               [ Sexplib0.Sexp.Atom "warn_if_no_trailing_newline_in_both"; arg__054_ ]
           in
           (bnd__053_ :: bnds__009_ : _ Stdlib.List.t))
       in
       let bnds__009_ =
         let arg__049_ = Format.Location_style.sexp_of_t location_style__048_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "location_style"; arg__049_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__047_ = sexp_of_option sexp_of_string next_alt__046_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_alt"; arg__047_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__045_ = sexp_of_option sexp_of_string prev_alt__044_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_alt"; arg__045_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__043_ = sexp_of_bool mask_uniques__042_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mask_uniques"; arg__043_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__041_ = sexp_of_bool double_check__040_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "double_check"; arg__041_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__039_ = sexp_of_bool quiet__038_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "quiet"; arg__039_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__037_ = sexp_of_bool shallow__036_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shallow"; arg__037_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__035_ = sexp_of_int word_big_enough__034_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "word_big_enough"; arg__035_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__033_ = sexp_of_int line_big_enough__032_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "line_big_enough"; arg__033_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__031_ = sexp_of_int context__030_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "context"; arg__031_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__029_ = sexp_of_bool assume_text__028_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "assume_text"; arg__029_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__027_ = sexp_of_bool interleave__026_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "interleave"; arg__027_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__025_ = sexp_of_bool split_long_lines__024_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "split_long_lines"; arg__025_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__023_ = sexp_of_bool find_moves__022_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "find_moves"; arg__023_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__021_ = sexp_of_bool keep_ws__020_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keep_ws"; arg__021_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__019_ = sexp_of_bool unrefined__018_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unrefined"; arg__019_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__017_ = sexp_of_bool produce_unified_lines__016_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "produce_unified_lines"; arg__017_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__015_ = sexp_of_option Percent.sexp_of_t float_tolerance__014_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "float_tolerance"; arg__015_ ]
          :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__013_ = Format.Rules.sexp_of_t rules__012_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "rules"; arg__013_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       let bnds__009_ =
         let arg__011_ = Output.sexp_of_t output__010_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "output"; arg__011_ ] :: bnds__009_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__009_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let invariant t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "configuration.ml.before-ppx"
    ; pos_lnum = 51
    ; pos_cnum = 1770
    ; pos_bol = 1748
    }
    t
    (sexp_of_t [@merlin.hide])
    (fun () ->
       let check f field = Invariant.check_field t f field in
       Fields.iter
         ~output:
           (check (fun output ->
              if Output.implies_unrefined output
              then
                (fun ?(here = []) ?message ?equal t1 t2 ->
                   let pos = "configuration.ml.before-ppx:57:27" in
                   let sexpifier = (sexp_of_bool [@merlin.hide]) in
                   let comparator =
                     (fun (a__057_ : bool) ((b__058_ : bool) [@merlin.hide]) ->
                     (compare_bool a__057_ b__058_ [@merlin.hide]))
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
                  t.unrefined
                  true
                  ~message:"output implies unrefined"))
         ~rules:ignore
         ~float_tolerance:ignore
         ~produce_unified_lines:ignore
         ~unrefined:ignore
         ~keep_ws:ignore
         ~find_moves:ignore
         ~interleave:ignore
         ~assume_text:ignore
         ~split_long_lines:ignore
         ~context:ignore
         ~line_big_enough:
           (check (fun line_big_enough ->
              (fun ?(here = []) ?message predicate t ->
                 let pos = "configuration.ml.before-ppx:70:24" in
                 let sexpifier = (sexp_of_int [@merlin.hide]) in
                 Ppx_assert_lib.Runtime.test_pred
                   ~pos
                   ~sexpifier
                   ~here
                   ?message
                   predicate
                   t)
                Int.is_positive
                line_big_enough
                ~message:"line_big_enough must be positive"))
         ~word_big_enough:
           (check (fun word_big_enough ->
              (fun ?(here = []) ?message predicate t ->
                 let pos = "configuration.ml.before-ppx:76:24" in
                 let sexpifier = (sexp_of_int [@merlin.hide]) in
                 Ppx_assert_lib.Runtime.test_pred
                   ~pos
                   ~sexpifier
                   ~here
                   ?message
                   predicate
                   t)
                Int.is_positive
                word_big_enough
                ~message:"word_big_enough must be positive"))
         ~shallow:ignore
         ~quiet:ignore
         ~double_check:ignore
         ~mask_uniques:ignore
         ~prev_alt:ignore
         ~next_alt:ignore
         ~location_style:ignore
         ~warn_if_no_trailing_newline_in_both:ignore)
;;

let create_exn
      ~output
      ~rules
      ~float_tolerance
      ~produce_unified_lines
      ~unrefined
      ~keep_ws
      ~find_moves
      ~split_long_lines
      ~interleave
      ~assume_text
      ~context
      ~line_big_enough
      ~word_big_enough
      ~shallow
      ~quiet
      ~double_check
      ~mask_uniques
      ~prev_alt
      ~next_alt
      ~location_style
      ~warn_if_no_trailing_newline_in_both
  =
  let t =
    { output
    ; rules
    ; float_tolerance
    ; produce_unified_lines
    ; unrefined
    ; keep_ws
    ; find_moves
    ; split_long_lines
    ; interleave
    ; assume_text
    ; context
    ; line_big_enough
    ; word_big_enough
    ; shallow
    ; quiet
    ; double_check
    ; mask_uniques
    ; prev_alt
    ; next_alt
    ; location_style
    ; warn_if_no_trailing_newline_in_both
    }
  in
  invariant t;
  t
;;

let override
      ?output
      ?rules
      ?float_tolerance
      ?produce_unified_lines
      ?unrefined
      ?keep_ws
      ?find_moves
      ?split_long_lines
      ?interleave
      ?assume_text
      ?context
      ?line_big_enough
      ?word_big_enough
      ?shallow
      ?quiet
      ?double_check
      ?mask_uniques
      ?prev_alt
      ?next_alt
      ?location_style
      ?warn_if_no_trailing_newline_in_both
      t
  =
  let output = Option.value ~default:t.output output in
  let unrefined =
    Option.value ~default:t.unrefined unrefined || Output.implies_unrefined output
  in
  let t =
    let value value field = Option.value value ~default:(Field.get field t) in
    Fields.map
      ~output:(const output)
      ~rules:(value rules)
      ~float_tolerance:(value float_tolerance)
      ~produce_unified_lines:(value produce_unified_lines)
      ~unrefined:(const unrefined)
      ~keep_ws:(value keep_ws)
      ~find_moves:(value find_moves)
      ~interleave:(value interleave)
      ~assume_text:(value assume_text)
      ~split_long_lines:(value split_long_lines)
      ~context:(value context)
      ~line_big_enough:(value line_big_enough)
      ~word_big_enough:(value word_big_enough)
      ~shallow:(value shallow)
      ~quiet:(value quiet)
      ~double_check:(value double_check)
      ~mask_uniques:(value mask_uniques)
      ~prev_alt:(value prev_alt)
      ~next_alt:(value next_alt)
      ~location_style:(value location_style)
      ~warn_if_no_trailing_newline_in_both:(value warn_if_no_trailing_newline_in_both)
  in
  invariant t;
  t
;;

let default =
  { output = Ansi
  ; rules =
      { line_same =
          Format.Rule.create
            []
            ~pre:(Format.Rule.Affix.create " |" ~styles:[ Bg Bright_black; Fg Black ])
      ; line_prev =
          Format.Rule.create
            [ Fg Red ]
            ~pre:(Format.Rule.Affix.create "-|" ~styles:[ Bg Red; Fg Black ])
      ; line_next =
          Format.Rule.create
            [ Fg Green ]
            ~pre:(Format.Rule.Affix.create "+|" ~styles:[ Bg Green; Fg Black ])
      ; line_unified =
          Format.Rule.create
            []
            ~pre:(Format.Rule.Affix.create "!|" ~styles:[ Bg Yellow; Fg Black ])
      ; word_same_prev = Format.Rule.create [ Dim ]
      ; word_same_next = Format.Rule.blank
      ; word_same_unified = Format.Rule.blank
      ; word_same_unified_in_move = Format.Rule.create [ Fg Cyan ]
      ; word_prev = Format.Rule.create [ Fg Red ]
      ; word_next = Format.Rule.create [ Fg Green ]
      ; hunk =
          Format.Rule.create
            [ Bold ]
            ~pre:(Format.Rule.Affix.create "@|" ~styles:[ Bg Bright_black; Fg Black ])
            ~suf:
              (Format.Rule.Affix.create
                 " ============================================================")
      ; header_prev =
          Format.Rule.create
            [ Bold ]
            ~pre:(Format.Rule.Affix.create "------ " ~styles:[ Fg Red ])
      ; header_next =
          Format.Rule.create
            [ Bold ]
            ~pre:(Format.Rule.Affix.create "++++++ " ~styles:[ Fg Green ])
      ; moved_from_prev =
          Format.Rule.create
            [ Fg Magenta ]
            ~pre:(Format.Rule.Affix.create "<|" ~styles:[ Bg Magenta; Fg Black ])
      ; moved_to_next =
          Format.Rule.create
            [ Fg Cyan ]
            ~pre:(Format.Rule.Affix.create ">|" ~styles:[ Bg Cyan; Fg Black ])
      ; removed_in_move =
          Format.Rule.create
            [ Fg Red ]
            ~pre:(Format.Rule.Affix.create ">|" ~styles:[ Bg Red; Fg Black ])
      ; added_in_move =
          Format.Rule.create
            [ Fg Green ]
            ~pre:(Format.Rule.Affix.create ">|" ~styles:[ Bg Green; Fg Black ])
      ; line_unified_in_move =
          Format.Rule.create
            []
            ~pre:(Format.Rule.Affix.create ">|" ~styles:[ Bg Yellow; Fg Black ])
      }
  ; float_tolerance = None
  ; produce_unified_lines = true
  ; unrefined = false
  ; keep_ws = false
  ; find_moves = false
  ; split_long_lines = false
  ; interleave = true
  ; assume_text = false
  ; context = default_context
  ; line_big_enough = default_line_big_enough
  ; word_big_enough = default_word_big_enough
  ; shallow = false
  ; quiet = false
  ; double_check = false
  ; mask_uniques = false
  ; prev_alt = None
  ; next_alt = None
  ; location_style = Diff
  ; warn_if_no_trailing_newline_in_both = warn_if_no_trailing_newline_in_both_default
  }
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
