let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "float_tolerance.ml.before-ppx"
;;

open! Core
open! Import
module Range = Patience_diff.Range
module Hunk = Patience_diff.Hunk
module Hunks = Patience_diff.Hunks

module String_with_floats = struct
  type t =
    { floats : float array
    ; without_floats : string
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__002_ = "float_tolerance.ml.before-ppx.String_with_floats.t" in
       fun x__003_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__002_
           ~fields:
             (Field
                { name = "floats"
                ; kind = Required
                ; conv = array_of_sexp float_of_sexp
                ; rest =
                    Field
                      { name = "without_floats"
                      ; kind = Required
                      ; conv = string_of_sexp
                      ; rest = Empty
                      }
                })
           ~index_of_field:(function
             | "floats" -> 0
             | "without_floats" -> 1
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (floats, (without_floats, ())) ->
             ({ floats; without_floats } : t))
           x__003_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { floats = floats__005_; without_floats = without_floats__007_ } ->
         let bnds__004_ = ([] : _ Stdlib.List.t) in
         let bnds__004_ =
           let arg__008_ = sexp_of_string without_floats__007_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "without_floats"; arg__008_ ]
            :: bnds__004_
            : _ Stdlib.List.t)
         in
         let bnds__004_ =
           let arg__006_ = sexp_of_array sexp_of_float floats__005_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "floats"; arg__006_ ] :: bnds__004_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__004_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let close_enough tolerance =
    let equal f f' =
      Float.( <= )
        (Float.abs (f -. f'))
        (Percent.apply tolerance (Float.min (Float.abs f) (Float.abs f')))
    in
    stage (fun t t' ->
      String.( = ) t.without_floats t'.without_floats
      && Array.equal equal t.floats t'.floats)
  ;;

  let float_regex =
    lazy
      (let open Re in
       let delim = set {| ;:,\|#&(){}[]<>~=+-*/|} in
       let prefix = group (alt [ start; char '$'; delim ]) in
       let float =
         group
           (seq
              [ opt (char '-')
              ; rep1 digit
              ; opt (seq [ char '.'; opt (rep1 digit) ])
              ; opt (seq [ set {|eE|}; opt (set {|+-|}); rep1 digit ])
              ])
       in
       let suffix =
         let suffix_with_delim = alt [ stop; char '%'; delim ] in
         let suffix_with_unit =
           let unit = alt [ str "bp"; str "s"; str "m"; str "ms" ] in
           seq [ unit; eow ]
         in
         group (alt [ suffix_with_delim; suffix_with_unit ])
       in
       compile (seq [ prefix; float; suffix ]))
  ;;

  let create s =
    let rec loop floats line =
      match Re.exec_opt (force float_regex) line with
      | None -> { floats = Array.of_list_rev floats; without_floats = line }
      | Some groups ->
        let float = Float.of_string (Re.Group.get groups 2) in
        let line =
          Re.replace (force float_regex) line ~all:false ~f:(fun groups ->
            let prefix = Re.Group.get groups 1 in
            let suffix = Re.Group.get groups 3 in
            prefix ^ suffix)
        in
        loop (float :: floats) line
    in
    loop [] s
  ;;

  include struct
    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
          ~line_number:68
          ~location:{ start_bol = 1933; start_pos = 1937; end_pos = 2107 }
          ~trailing_loc:{ start_bol = 2040; start_pos = 2107; end_pos = 2107 }
          ~body_loc:{ start_bol = 1933; start_pos = 1937; end_pos = 2107 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
          ~description:(Some "trailing [.]")
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
                        ( { contents = " (t ((floats (12)) (without_floats \"(foo )\"))) "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 2040; start_pos = 2055; end_pos = 2106 } ))
                   ~node_loc:{ start_bol = 2040; start_pos = 2046; end_pos = 2107 } )
             ]
            [@merlin.hide])
          (fun () ->
             let t = create "(foo 12.)" in
             print_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "t"; (sexp_of_t [@merlin.hide]) t ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
          ~line_number:74
          ~location:{ start_bol = 2116; start_pos = 2120; end_pos = 3270 }
          ~trailing_loc:{ start_bol = 3259; start_pos = 3270; end_pos = 3270 }
          ~body_loc:{ start_bol = 2116; start_pos = 2120; end_pos = 3270 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 4)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 5)
          ~description:(Some "scientific notation")
          ~tags:[]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 3
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents =
                              "\n\
                              \        ((t1 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t2 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t3 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t4 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t5 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t6 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t7 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\")))\n\
                              \         (t8 ((floats (-12345678910.11)) (without_floats \
                               \"(foo )\"))))\n\
                              \        "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 2695; start_pos = 2703; end_pos = 3269 } ))
                   ~node_loc:{ start_bol = 2680; start_pos = 2686; end_pos = 3270 } )
             ]
            [@merlin.hide])
          (fun () ->
             let t1 = create "(foo -12345678910.11)" in
             let t2 = create "(foo -1.234567891011e10)" in
             let t3 = create "(foo -1.234567891011e+10)" in
             let t4 = create "(foo -1.234567891011E10)" in
             let t5 = create "(foo -1.234567891011E+10)" in
             let t6 = create "(foo -123456789101.1e-1)" in
             let t7 = create "(foo -1234567891011.e-2)" in
             let t8 = create "(foo -1234567891011e-2)" in
             print_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t1"
                        ; (sexp_of_t [@merlin.hide]) t1
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t2"
                        ; (sexp_of_t [@merlin.hide]) t2
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t3"
                        ; (sexp_of_t [@merlin.hide]) t3
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t4"
                        ; (sexp_of_t [@merlin.hide]) t4
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t5"
                        ; (sexp_of_t [@merlin.hide]) t5
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t6"
                        ; (sexp_of_t [@merlin.hide]) t6
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t7"
                        ; (sexp_of_t [@merlin.hide]) t7
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "t8"
                        ; (sexp_of_t [@merlin.hide]) t8
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide])
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
          ~line_number:98
          ~location:{ start_bol = 3279; start_pos = 3283; end_pos = 3793 }
          ~trailing_loc:{ start_bol = 3782; start_pos = 3793; end_pos = 3793 }
          ~body_loc:{ start_bol = 3279; start_pos = 3283; end_pos = 3793 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 7)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 8)
          ~description:None
          ~tags:[]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 6
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents =
                              "\n\
                              \        ((prev\n\
                              \          ((floats (-18.8305 39.1095))\n\
                              \           (without_floats \"(dynamic (Ok ((price_range ( \
                               )))))\\n\")))\n\
                              \         (next\n\
                              \          ((floats (-18.772 38.988))\n\
                              \           (without_floats \"(dynamic (Ok ((price_range ( \
                               )))))\\n\"))))\n\
                              \        "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 3526; start_pos = 3534; end_pos = 3792 } ))
                   ~node_loc:{ start_bol = 3511; start_pos = 3517; end_pos = 3793 } )
             ]
            [@merlin.hide])
          (fun () ->
             let prev = create "(dynamic (Ok ((price_range (-18.8305 39.1095)))))\n" in
             let next = create "(dynamic (Ok ((price_range (-18.772 38.988)))))\n" in
             print_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "prev"
                        ; (sexp_of_t [@merlin.hide]) prev
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "next"
                        ; (sexp_of_t [@merlin.hide]) next
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 6) [@merlin.hide])
    ;;

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
          ~line_number:113
          ~location:{ start_bol = 3802; start_pos = 3806; end_pos = 4377 }
          ~trailing_loc:{ start_bol = 4366; start_pos = 4377; end_pos = 4377 }
          ~body_loc:{ start_bol = 3802; start_pos = 3806; end_pos = 4377 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 10)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 11)
          ~description:None
          ~tags:[]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 9
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents =
                              "\n\
                              \        ((prev\n\
                              \          ((floats (9 30 0 16 0 0))\n\
                              \           (without_floats \
                               \"(primary_exchange_core_session (:: ::))\")))\n\
                              \         (next\n\
                              \          ((floats (9 30 0 15 59 0))\n\
                              \           (without_floats \
                               \"(primary_exchange_core_session (:: ::))\"))))\n\
                              \        "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 4107; start_pos = 4115; end_pos = 4376 } ))
                   ~node_loc:{ start_bol = 4092; start_pos = 4098; end_pos = 4377 } )
             ]
            [@merlin.hide])
          (fun () ->
             let prev =
               create "(primary_exchange_core_session (09:30:00.000000 16:00:00.000000))"
             in
             let next =
               create "(primary_exchange_core_session (09:30:00.000000 15:59:00.000000))"
             in
             print_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "prev"
                        ; (sexp_of_t [@merlin.hide]) prev
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "next"
                        ; (sexp_of_t [@merlin.hide]) next
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 9) [@merlin.hide])
    ;;
  end
end

let needleman_wunsch xs ys ~equal =
  let min3 a b c = Int.min (Int.min a b) c in
  let rows = Array.length xs in
  let cols = Array.length ys in
  let a =
    let rows = rows + 1 in
    let cols = cols + 1 in
    Array.init rows ~f:(fun _ -> Array.create ~len:cols Int.max_value)
  in
  for i = 0 to rows do
    a.(i).(0) <- i
  done;
  for j = 0 to cols do
    a.(0).(j) <- j
  done;
  for i = 1 to rows do
    for j = 1 to cols do
      a.(i).(j)
      <- min3
           (a.(i - 1).(j) + 1)
           (a.(i).(j - 1) + 1)
           (a.(i - 1).(j - 1) + if equal xs.(i - 1) ys.(j - 1) then 0 else 1)
    done
  done;
  a
;;

type partial_range_indexes =
  | Matching of (int * int) list
  | Nonmatching of int list * int list

let recover_ranges xs ys a =
  let smallest a b c = if a < b then if a < c then 0 else 2 else if b < c then 1 else 2 in
  let cons_minus_one car cdr ~if_unequal_to =
    if car = if_unequal_to then cdr else (car - 1) :: cdr
  in
  let rec traceback a i j acc =
    if i <= 0 || j <= 0
    then
      if i <= 0 && j <= 0
      then acc
      else (
        let is' = List.range 0 i in
        let js' = List.range 0 j in
        match acc with
        | [] | Matching _ :: _ -> Nonmatching (is', js') :: acc
        | Nonmatching (is, js) :: acc -> Nonmatching (is' @ is, js' @ js) :: acc)
    else (
      let i', j', matched =
        match smallest a.(i - 1).(j) a.(i - 1).(j - 1) a.(i).(j - 1) with
        | 0 -> i - 1, j, false
        | 1 -> i - 1, j - 1, a.(i).(j) = a.(i - 1).(j - 1)
        | 2 -> i, j - 1, false
        | _ -> failwith "smallest only returns 0, 1, or 2."
      in
      let acc =
        if matched
        then (
          match acc with
          | [] | Nonmatching _ :: _ -> Matching [ i - 1, j - 1 ] :: acc
          | Matching ijs :: acc -> Matching ((i - 1, j - 1) :: ijs) :: acc)
        else (
          match acc with
          | [] | Matching _ :: _ ->
            Nonmatching
              ( cons_minus_one i [] ~if_unequal_to:i'
              , cons_minus_one j [] ~if_unequal_to:j' )
            :: acc
          | Nonmatching (is, js) :: acc ->
            Nonmatching
              ( cons_minus_one i is ~if_unequal_to:i'
              , cons_minus_one j js ~if_unequal_to:j' )
            :: acc)
      in
      traceback a i' j' acc)
  in
  let elts_of_indices is xs = Array.map ~f:(Array.get xs) (Array.of_list is) in
  List.map
    ~f:(function
      | Matching ijs ->
        let xys = Array.map ~f:(fun (i, j) -> xs.(i), ys.(j)) (Array.of_list ijs) in
        Range.Same xys
      | Nonmatching (is, []) -> Prev (elts_of_indices is xs, None)
      | Nonmatching ([], js) -> Next (elts_of_indices js ys, None)
      | Nonmatching (is, js) ->
        Replace (elts_of_indices is xs, elts_of_indices js ys, None))
    (traceback a (Array.length xs) (Array.length ys) [])
;;

let () =
  match Ppx_inline_test_lib.testing with
  | `Not_testing -> ()
  | `Testing _ ->
    let module Ppx_expect_test_block =
      Ppx_expect_runtime.Make_test_block (Expect_test_config)
    in
    Ppx_expect_test_block.run_suite
      ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
      ~line_number:229
      ~location:{ start_bol = 7765; start_pos = 7765; end_pos = 8138 }
      ~trailing_loc:{ start_bol = 8096; start_pos = 8138; end_pos = 8138 }
      ~body_loc:{ start_bol = 7765; start_pos = 7765; end_pos = 8138 }
      ~formatting_flexibility:
        (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
           Ppx_expect_runtime.Expect_node_formatting.default)
      ~expected_exn:None
      ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 14)
      ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 15)
      ~description:(Some "recover_ranges")
      ~tags:[]
      ~inline_test_config:(module Inline_test_config)
      ~expectations:
        ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 13
           , Ppx_expect_runtime.Test_node.Create.expect
               ~formatting_flexibility:
                 (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                    Ppx_expect_runtime.Expect_node_formatting.default)
               ~located_payload:
                 (Some
                    ( { contents = " ((Replace (a b) (z) ())) "
                      ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                      }
                    , { start_bol = 8096; start_pos = 8107; end_pos = 8137 } ))
               ~node_loc:{ start_bol = 8096; start_pos = 8098; end_pos = 8138 } )
         ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 12
           , Ppx_expect_runtime.Test_node.Create.expect
               ~formatting_flexibility:
                 (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                    Ppx_expect_runtime.Expect_node_formatting.default)
               ~located_payload:
                 (Some
                    ( { contents = " ((0 1) (1 1) (2 2)) "
                      ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                      }
                    , { start_bol = 7960; start_pos = 7971; end_pos = 7996 } ))
               ~node_loc:{ start_bol = 7960; start_pos = 7962; end_pos = 7997 } )
         ]
        [@merlin.hide])
      (fun () ->
         let prev = [| "a"; "b" |] in
         let next = [| "z" |] in
         let a = needleman_wunsch prev next ~equal:String.equal in
         print_s
           (((fun x__009_ -> sexp_of_array (sexp_of_array sexp_of_int) x__009_)
               [@merlin.hide])
              a);
         Ppx_expect_test_block.run_test
           ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 12) [@merlin.hide];
         let ranges = recover_ranges prev next a in
         print_s
           (((fun x__010_ -> sexp_of_list (Range.sexp_of_t sexp_of_string) x__010_)
               [@merlin.hide])
              ranges);
         Ppx_expect_test_block.run_test
           ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 13) [@merlin.hide])
;;

let do_tolerance ~equal hunks =
  Hunks.concat_map_ranges hunks ~f:(fun range ->
    match (range : string Range.t) with
    | Same _ | Prev _ | Next _ -> [ range ]
    | Unified _ ->
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unexpected Unified range."
             ; ((fun x__011_ -> Range.sexp_of_t sexp_of_string x__011_) [@merlin.hide])
                 range
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | Replace (prev, next, _) ->
      recover_ranges
        prev
        next
        (needleman_wunsch
           (Array.map prev ~f:String_with_floats.create)
           (Array.map next ~f:String_with_floats.create)
           ~equal))
;;

module Context_limit : sig
  val enforce : context:int -> string Hunk.t -> string Hunk.t list
end = struct
  module Merged_with_position : sig
    module Position : sig
      type t =
        | Start
        | Middle
        | End
      [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type t = string Range.t * Position.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val f : string Range.t list -> t Sequence.t
  end = struct
    module Position = struct
      type t =
        | Start
        | Middle
        | End
      [@@deriving sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let sexp_of_t =
          (function
           | Start -> Sexplib0.Sexp.Atom "Start"
           | Middle -> Sexplib0.Sexp.Atom "Middle"
           | End -> Sexplib0.Sexp.Atom "End"
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    open Position

    type t = string Range.t * Position.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (fun (arg0__012_, arg1__013_) ->
           let res0__014_ = Range.sexp_of_t sexp_of_string arg0__012_
           and res1__015_ = Position.sexp_of_t arg1__013_ in
           Sexplib0.Sexp.List [ res0__014_; res1__015_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let f = function
      | [] -> Sequence.empty
      | car :: cdr ->
        Sequence.unfold_with_and_finish
          (Sequence.of_list cdr : string Range.t Sequence.t)
          ~init:(car, Start)
          ~running_step:(fun (car, pos) cadr ->
            match car, cadr with
            | Same car_lines, Same cadr_lines ->
              Skip { state = Same (Array.concat [ car_lines; cadr_lines ]), pos }
            | Unified _, _ | _, Unified _ ->
              raise_s
                (let ppx_sexp_message () =
                   Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unexpected unified range."
                     ; Ppx_sexp_conv_lib.Sexp.List
                         [ Ppx_sexp_conv_lib.Sexp.Atom "car"
                         ; ((fun x__016_ -> Range.sexp_of_t sexp_of_string x__016_)
                              [@merlin.hide])
                             car
                         ]
                     ; Ppx_sexp_conv_lib.Sexp.List
                         [ Ppx_sexp_conv_lib.Sexp.Atom "cadr"
                         ; ((fun x__017_ -> Range.sexp_of_t sexp_of_string x__017_)
                              [@merlin.hide])
                             cadr
                         ]
                     ]
                     [@@ocaml.inline never]
                     [@@ocaml.local never]
                     [@@ocaml.specialise never]
                 in
                 (ppx_sexp_message () [@nontail]))
            | (Prev _ | Next _ | Replace _), (Prev _ | Next _ | Replace _)
            | Same _, (Prev _ | Next _ | Replace _)
            | (Prev _ | Next _ | Replace _), Same _ ->
              Yield { value = car, pos; state = cadr, Middle })
          ~inner_finished:(fun (last, pos) ->
            match last, pos with
            | Unified _, _ ->
              raise_s
                (let ppx_sexp_message () =
                   Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unexpected unified range."
                     ; ((fun x__018_ -> Range.sexp_of_t sexp_of_string x__018_)
                          [@merlin.hide])
                         last
                     ]
                     [@@ocaml.inline never]
                     [@@ocaml.local never]
                     [@@ocaml.specialise never]
                 in
                 (ppx_sexp_message () [@nontail]))
            | _, End ->
              raise_s
                (let ppx_sexp_message () =
                   Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                         "Produced End in running step."
                     ; Ppx_sexp_conv_lib.Sexp.List
                         [ Ppx_sexp_conv_lib.Sexp.Atom "last"
                         ; ((fun x__019_ -> Range.sexp_of_t sexp_of_string x__019_)
                              [@merlin.hide])
                             last
                         ]
                     ]
                     [@@ocaml.inline never]
                     [@@ocaml.local never]
                     [@@ocaml.specialise never]
                 in
                 (ppx_sexp_message () [@nontail]))
            | Same _, Start -> None
            | (Prev _ | Next _ | Replace _), (Start | Middle) | Same _, Middle ->
              Some (last, End))
          ~finishing_step:(function
            | None -> Done
            | Some result -> Yield { value = result; state = None })
    ;;

    include struct
      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
            ~line_number:317
            ~location:{ start_bol = 10734; start_pos = 10740; end_pos = 11303 }
            ~trailing_loc:{ start_bol = 11290; start_pos = 11303; end_pos = 11303 }
            ~body_loc:{ start_bol = 10734; start_pos = 10740; end_pos = 11303 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 18)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 19)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 17
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents =
                                "\n\
                                \          (((Same ((same same))) Start) ((Next (new) \
                                 ()) Middle)\n\
                                \           ((Same ((same same) (same same))) Middle) \
                                 ((Next (new) ()) Middle)\n\
                                \           ((Same ((same same) (same same))) End))\n\
                                \          "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 11083; start_pos = 11093; end_pos = 11302 } ))
                     ~node_loc:{ start_bol = 11066; start_pos = 11074; end_pos = 11303 } )
               ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 16
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " () "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 10971; start_pos = 10988; end_pos = 10996 } ))
                     ~node_loc:{ start_bol = 10971; start_pos = 10979; end_pos = 10997 } )
               ]
              [@merlin.hide])
            (fun () ->
               let test ranges =
                 print_s
                   (((fun x__020_ -> Sequence.sexp_of_t sexp_of_t x__020_) [@merlin.hide])
                      (f ranges))
               in
               let same = Range.Same [| "same", "same" |] in
               let not_same = Range.Next ([| "new" |], None) in
               test [ same; same ];
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 16) [@merlin.hide];
               test [ same; not_same; same; same; not_same; same; same ];
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 17) [@merlin.hide])
      ;;
    end
  end

  module Drop_or_keep : sig
    type t =
      | Drop of int
      | Keep of string Range.t
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val f : context:int -> Merged_with_position.t Sequence.t -> t Sequence.t
  end = struct
    type t =
      | Drop of int
      | Keep of string Range.t
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (function
         | Drop arg0__021_ ->
           let res0__022_ = sexp_of_int arg0__021_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Drop"; res0__022_ ]
         | Keep arg0__023_ ->
           let res0__024_ = Range.sexp_of_t sexp_of_string arg0__023_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Keep"; res0__024_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let drop_from_start context lines =
      let extra_context = Array.length lines - context in
      if extra_context <= 0
      then Sequence.singleton (Keep (Same lines))
      else
        Sequence.of_list
          [ Drop extra_context
          ; Keep (Same (Array.sub ~pos:extra_context ~len:context lines))
          ]
    ;;

    let drop_from_end context lines =
      let extra_context = Array.length lines - context in
      if extra_context <= 0
      then Sequence.singleton (Keep (Same lines))
      else Sequence.singleton (Keep (Same (Array.sub ~pos:0 ~len:context lines)))
    ;;

    let drop_from_middle context lines =
      let extra_context = Array.length lines - (2 * context) in
      if extra_context <= 0
      then Sequence.singleton (Keep (Same lines))
      else (
        let start_next_context_at = Array.length lines - context in
        Sequence.of_list
          [ Keep (Same (Array.sub ~pos:0 ~len:context lines))
          ; Drop extra_context
          ; Keep (Same (Array.sub ~pos:start_next_context_at ~len:context lines))
          ])
    ;;

    let f ~context (ranges : Merged_with_position.t Sequence.t) =
      Sequence.bind ranges ~f:(fun (range, pos) ->
        match range with
        | Unified _ ->
          raise_s
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unexpected Unified range."
                 ; ((fun x__025_ -> Range.sexp_of_t sexp_of_string x__025_)
                      [@merlin.hide])
                     range
                 ]
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
        | Prev _ | Next _ | Replace _ -> Sequence.singleton (Keep range)
        | Same lines ->
          (match pos with
           | Start -> drop_from_start context lines
           | End -> drop_from_end context lines
           | Middle -> drop_from_middle context lines))
    ;;

    include struct
      let () =
        match Ppx_inline_test_lib.testing with
        | `Not_testing -> ()
        | `Testing _ ->
          let module Ppx_expect_test_block =
            Ppx_expect_runtime.Make_test_block (Expect_test_config)
          in
          Ppx_expect_test_block.run_suite
            ~filename_rel_to_project_root:"float_tolerance.ml.before-ppx"
            ~line_number:393
            ~location:{ start_bol = 13312; start_pos = 13318; end_pos = 14201 }
            ~trailing_loc:{ start_bol = 14188; start_pos = 14201; end_pos = 14201 }
            ~body_loc:{ start_bol = 13312; start_pos = 13318; end_pos = 14201 }
            ~formatting_flexibility:
              (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                 Ppx_expect_runtime.Expect_node_formatting.default)
            ~expected_exn:None
            ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 22)
            ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 23)
            ~description:None
            ~tags:[]
            ~inline_test_config:(module Inline_test_config)
            ~expectations:
              ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 21
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents =
                                "\n\
                                \          ((Drop 1) (Keep (Same ((same same)))) (Keep \
                                 (Next (new) ()))\n\
                                \           (Keep (Same ((same same) (same same)))) \
                                 (Keep (Next (new) ()))\n\
                                \           (Keep (Same ((same same)))) (Drop 1) (Keep \
                                 (Same ((same same))))\n\
                                \           (Keep (Next (new) ())) (Keep (Same ((same \
                                 same)))))\n\
                                \          "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 13891; start_pos = 13901; end_pos = 14200 } ))
                     ~node_loc:{ start_bol = 13874; start_pos = 13882; end_pos = 14201 } )
               ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 20
                 , Ppx_expect_runtime.Test_node.Create.expect
                     ~formatting_flexibility:
                       (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                        .Flexible_modulo
                          Ppx_expect_runtime.Expect_node_formatting.default)
                     ~located_payload:
                       (Some
                          ( { contents = " () "
                            ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                            }
                          , { start_bol = 13604; start_pos = 13621; end_pos = 13629 } ))
                     ~node_loc:{ start_bol = 13604; start_pos = 13612; end_pos = 13630 } )
               ]
              [@merlin.hide])
            (fun () ->
               let test ranges =
                 print_s
                   (((fun x__026_ -> Sequence.sexp_of_t sexp_of_t x__026_) [@merlin.hide])
                      (f ~context:1 (Merged_with_position.f ranges)))
               in
               let same = Range.Same [| "same", "same" |] in
               let not_same = Range.Next ([| "new" |], None) in
               test [ same; same ];
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 20) [@merlin.hide];
               test
                 [ same
                 ; same
                 ; not_same
                 ; same
                 ; same
                 ; not_same
                 ; same
                 ; same
                 ; same
                 ; not_same
                 ; same
                 ; same
                 ];
               Ppx_expect_test_block.run_test
                 ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 21) [@merlin.hide])
      ;;
    end
  end

  module Reconstruct_hunk : sig
    val f
      :  prev_start:int
      -> next_start:int
      -> Drop_or_keep.t Sequence.t
      -> string Hunk.t Sequence.t
  end = struct
    type t =
      { prev_start : int
      ; next_start : int
      ; ranges : string Range.t list
      }
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (fun { prev_start = prev_start__028_
             ; next_start = next_start__030_
             ; ranges = ranges__032_
             } ->
           let bnds__027_ = ([] : _ Stdlib.List.t) in
           let bnds__027_ =
             let arg__033_ = sexp_of_list (Range.sexp_of_t sexp_of_string) ranges__032_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ranges"; arg__033_ ] :: bnds__027_
              : _ Stdlib.List.t)
           in
           let bnds__027_ =
             let arg__031_ = sexp_of_int next_start__030_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_start"; arg__031_ ]
              :: bnds__027_
              : _ Stdlib.List.t)
           in
           let bnds__027_ =
             let arg__029_ = sexp_of_int prev_start__028_ in
             (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "prev_start"; arg__029_ ]
              :: bnds__027_
              : _ Stdlib.List.t)
           in
           Sexplib0.Sexp.List bnds__027_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_hunk t =
      { Hunk.prev_start = t.prev_start
      ; prev_size = List.sum (module Int) t.ranges ~f:Range.prev_size
      ; next_start = t.next_start
      ; next_size = List.sum (module Int) t.ranges ~f:Range.next_size
      ; ranges = List.rev t.ranges
      }
    ;;

    let f ~prev_start ~next_start drop_or_keeps =
      Sequence.unfold_with_and_finish
        drop_or_keeps
        ~init:{ prev_start; next_start; ranges = [] }
        ~running_step:(fun t drop_or_keep ->
          match (drop_or_keep : Drop_or_keep.t) with
          | Keep range -> Skip { state = { t with ranges = range :: t.ranges } }
          | Drop n ->
            let hunk = to_hunk t in
            let t =
              { prev_start = t.prev_start + hunk.prev_size + n
              ; next_start = t.next_start + hunk.next_size + n
              ; ranges = []
              }
            in
            if List.is_empty (Hunk.ranges hunk)
            then Skip { state = t }
            else Yield { value = hunk; state = t })
        ~inner_finished:(fun t -> if List.is_empty t.ranges then None else Some t)
        ~finishing_step:(function
          | None -> Done
          | Some t -> Yield { value = to_hunk t; state = None })
    ;;
  end

  let enforce ~context hunk =
    Sequence.to_list
      (Reconstruct_hunk.f
         ~prev_start:(Hunk.prev_start hunk)
         ~next_start:(Hunk.next_start hunk)
         (Drop_or_keep.f ~context (Merged_with_position.f (Hunk.ranges hunk))))
  ;;
end

let apply hunks tolerance ~context =
  let equal = unstage (String_with_floats.close_enough tolerance) in
  List.concat_map ~f:(Context_limit.enforce ~context) (do_tolerance ~equal hunks)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
