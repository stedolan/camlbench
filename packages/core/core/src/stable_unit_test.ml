let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_unit_test.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_unit_test.ml.before-ppx"
;;

open! Import
open Std_internal
include Stable_unit_test_intf

module Make_sexp_deserialization_test (T : Stable_unit_test_intf.Arg) = struct
  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "sexp deserialization")
      ~tags:[]
      ~filename:"stable_unit_test.ml.before-ppx"
      ~line_number:6
      ~start_pos:2
      ~end_pos:772
      (fun () ->
         ok_exn
           (Or_error.combine_errors_unit
              (List.map T.tests ~f:(fun (t, sexp_as_string, _) ->
                 match
                   Or_error.try_with (fun () ->
                     (T.t_of_sexp [@merlin.hide]) (Sexp.of_string sexp_as_string))
                 with
                 | Error _ as error ->
                   Or_error.tag_arg
                     error
                     "could not deserialize sexp"
                     (sexp_as_string, `Expected t)
                     ((fun (arg0__002_, arg1__003_) ->
                        let res0__004_ = sexp_of_string arg0__002_
                        and res1__005_ =
                          let (`Expected v__001_) = arg1__003_ in
                          Sexplib0.Sexp.List
                            [ Sexplib0.Sexp.Atom "Expected"; T.sexp_of_t v__001_ ]
                        in
                        Sexplib0.Sexp.List [ res0__004_; res1__005_ ]) [@merlin.hide])
                 | Ok t' ->
                   if T.equal t t'
                   then Ok ()
                   else
                     Or_error.error
                       "sexp deserialization mismatch"
                       (`Expected t, `But_got t')
                       ((fun (arg0__008_, arg1__009_) ->
                          let res0__010_ =
                            let (`Expected v__006_) = arg0__008_ in
                            Sexplib0.Sexp.List
                              [ Sexplib0.Sexp.Atom "Expected"; T.sexp_of_t v__006_ ]
                          and res1__011_ =
                            let (`But_got v__007_) = arg1__009_ in
                            Sexplib0.Sexp.List
                              [ Sexplib0.Sexp.Atom "But_got"; T.sexp_of_t v__007_ ]
                          in
                          Sexplib0.Sexp.List [ res0__010_; res1__011_ ]) [@merlin.hide]))));
         ())
  ;;
end

module Make_sexp_serialization_test (T : Stable_unit_test_intf.Arg) = struct
  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "sexp serialization")
      ~tags:[]
      ~filename:"stable_unit_test.ml.before-ppx"
      ~line_number:32
      ~start_pos:2
      ~end_pos:583
      (fun () ->
         ok_exn
           (Or_error.combine_errors_unit
              (List.map T.tests ~f:(fun (t, sexp_as_string, _) ->
                 Or_error.try_with (fun () ->
                   let sexp = Sexp.of_string sexp_as_string in
                   let serialized_sexp = T.sexp_of_t t in
                   if Sexp.( <> ) serialized_sexp sexp
                   then
                     failwiths
                       ~here:
                         { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                         ; pos_lnum = 41
                         ; pos_cnum = 1381
                         ; pos_bol = 1360
                         }
                       "sexp serialization mismatch"
                       (`Expected sexp, `But_got serialized_sexp)
                       ((fun (arg0__014_, arg1__015_) ->
                          let res0__016_ =
                            let (`Expected v__012_) = arg0__014_ in
                            Sexplib0.Sexp.List
                              [ Sexplib0.Sexp.Atom "Expected"; Sexp.sexp_of_t v__012_ ]
                          and res1__017_ =
                            let (`But_got v__013_) = arg1__015_ in
                            Sexplib0.Sexp.List
                              [ Sexplib0.Sexp.Atom "But_got"; Sexp.sexp_of_t v__013_ ]
                          in
                          Sexplib0.Sexp.List [ res0__016_; res1__017_ ]) [@merlin.hide])))));
         ())
  ;;
end

module Make_bin_io_test (T : Stable_unit_test_intf.Arg) = struct
  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "bin_io")
      ~tags:[]
      ~filename:"stable_unit_test.ml.before-ppx"
      ~line_number:50
      ~start_pos:2
      ~end_pos:850
      (fun () ->
         List.iter T.tests ~f:(fun (t, _, expected_bin_io) ->
           let binable_m = ((module T) : (module Binable.S with type t = T.t)) in
           let to_bin_string t = Binable.to_string binable_m t in
           let serialized_bin_io = to_bin_string t in
           if String.( <> ) serialized_bin_io expected_bin_io
           then
             failwiths
               ~here:
                 { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                 ; pos_lnum = 58
                 ; pos_cnum = 2022
                 ; pos_bol = 2006
                 }
               "bin_io serialization mismatch"
               (t, `Expected expected_bin_io, `But_got serialized_bin_io)
               ((fun (arg0__020_, arg1__021_, arg2__022_) ->
                  let res0__023_ = T.sexp_of_t arg0__020_
                  and res1__024_ =
                    let (`Expected v__018_) = arg1__021_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "Expected"; sexp_of_string v__018_ ]
                  and res2__025_ =
                    let (`But_got v__019_) = arg2__022_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "But_got"; sexp_of_string v__019_ ]
                  in
                  Sexplib0.Sexp.List [ res0__023_; res1__024_; res2__025_ ])
                  [@merlin.hide]);
           let t' = Binable.of_string binable_m serialized_bin_io in
           if not (T.equal t t')
           then
             failwiths
               ~here:
                 { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                 ; pos_lnum = 66
                 ; pos_cnum = 2356
                 ; pos_bol = 2340
                 }
               "bin_io deserialization mismatch"
               (`Expected t, `But_got t')
               ((fun (arg0__028_, arg1__029_) ->
                  let res0__030_ =
                    let (`Expected v__026_) = arg0__028_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "Expected"; T.sexp_of_t v__026_ ]
                  and res1__031_ =
                    let (`But_got v__027_) = arg1__029_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "But_got"; T.sexp_of_t v__027_ ]
                  in
                  Sexplib0.Sexp.List [ res0__030_; res1__031_ ]) [@merlin.hide]));
         ())
  ;;
end

module Make (T : Stable_unit_test_intf.Arg) = struct
  include Make_sexp_deserialization_test (T)
  include Make_sexp_serialization_test (T)
  include Make_bin_io_test (T)
end

module Make_unordered_container (T : Stable_unit_test_intf.Unordered_container_arg) =
struct
  module Test = Stable_unit_test_intf.Unordered_container_test

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "sexp")
      ~tags:[]
      ~filename:"stable_unit_test.ml.before-ppx"
      ~line_number:83
      ~start_pos:2
      ~end_pos:1290
      (fun () ->
         List.iter T.tests ~f:(fun (t, { Test.sexps; _ }) ->
           let sexps = List.map sexps ~f:Sexp.of_string in
           let serialized_elements =
             match T.sexp_of_t t with
             | Sexp.List sexps -> sexps
             | Sexp.Atom _ ->
               failwiths
                 ~here:
                   { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                   ; pos_lnum = 91
                   ; pos_cnum = 3153
                   ; pos_bol = 3135
                   }
                 "expected list when serializing unordered container"
                 t
                 T.sexp_of_t
           in
           let sorted_sexps = List.sort ~compare:Sexp.compare sexps in
           let sorted_serialized = List.sort ~compare:Sexp.compare serialized_elements in
           if not (List.equal Sexp.( = ) sorted_sexps sorted_serialized)
           then
             failwiths
               ~here:
                 { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                 ; pos_lnum = 101
                 ; pos_cnum = 3537
                 ; pos_bol = 3521
                 }
               "sexp serialization mismatch"
               (`Expected sexps, `But_got serialized_elements)
               ((fun (arg0__034_, arg1__035_) ->
                  let res0__036_ =
                    let (`Expected v__032_) = arg0__034_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "Expected"
                      ; sexp_of_list Sexp.sexp_of_t v__032_
                      ]
                  and res1__037_ =
                    let (`But_got v__033_) = arg1__035_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "But_got"
                      ; sexp_of_list Sexp.sexp_of_t v__033_
                      ]
                  in
                  Sexplib0.Sexp.List [ res0__036_; res1__037_ ]) [@merlin.hide]);
           let sexp_permutations = List.init 10 ~f:(fun _ -> List.permute sexps) in
           List.iter sexp_permutations ~f:(fun sexps ->
             let t' = T.t_of_sexp (Sexp.List sexps) in
             if not (T.equal t t')
             then
               failwiths
                 ~here:
                   { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                   ; pos_lnum = 111
                   ; pos_cnum = 3986
                   ; pos_bol = 3968
                   }
                 "sexp deserialization msimatch"
                 (`Expected t, `But_got t')
                 ((fun (arg0__040_, arg1__041_) ->
                    let res0__042_ =
                      let (`Expected v__038_) = arg0__040_ in
                      Sexplib0.Sexp.List
                        [ Sexplib0.Sexp.Atom "Expected"; T.sexp_of_t v__038_ ]
                    and res1__043_ =
                      let (`But_got v__039_) = arg1__041_ in
                      Sexplib0.Sexp.List
                        [ Sexplib0.Sexp.Atom "But_got"; T.sexp_of_t v__039_ ]
                    in
                    Sexplib0.Sexp.List [ res0__042_; res1__043_ ]) [@merlin.hide])));
         ())
  ;;

  let rec is_concatenation string strings =
    if String.is_empty string
    then List.for_all strings ~f:String.is_empty
    else (
      let rec loop rev_skipped strings =
        match strings with
        | [] -> false
        | prefix :: strings ->
          let continue () = loop (prefix :: rev_skipped) strings in
          (match String.chop_prefix ~prefix string with
           | None -> continue ()
           | Some string ->
             is_concatenation string (List.rev_append rev_skipped strings) || continue ())
      in
      loop [] strings)
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "bin_io")
      ~tags:[]
      ~filename:"stable_unit_test.ml.before-ppx"
      ~line_number:134
      ~start_pos:2
      ~end_pos:1294
      (fun () ->
         List.iter T.tests ~f:(fun (t, { Test.bin_io_header; bin_io_elements; _ }) ->
           let binable_m = ((module T) : (module Binable.S with type t = T.t)) in
           let elements = bin_io_elements in
           let bin_io_of_elements elements = bin_io_header ^ String.concat elements in
           let serialized = Binable.to_string binable_m t in
           let serialization_matches =
             match String.chop_prefix ~prefix:bin_io_header serialized with
             | None -> false
             | Some elements_string -> is_concatenation elements_string elements
           in
           if not serialization_matches
           then
             failwiths
               ~here:
                 { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                 ; pos_lnum = 148
                 ; pos_cnum = 5367
                 ; pos_bol = 5351
                 }
               "serialization mismatch"
               (`Expected (bin_io_header, elements), `But_got serialized)
               ((fun (arg0__050_, arg1__051_) ->
                  let res0__052_ =
                    let (`Expected v__044_) = arg0__050_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "Expected"
                      ; (let arg0__045_, arg1__046_ = v__044_ in
                         let res0__047_ = sexp_of_string arg0__045_
                         and res1__048_ = sexp_of_list sexp_of_string arg1__046_ in
                         Sexplib0.Sexp.List [ res0__047_; res1__048_ ])
                      ]
                  and res1__053_ =
                    let (`But_got v__049_) = arg1__051_ in
                    Sexplib0.Sexp.List
                      [ Sexplib0.Sexp.Atom "But_got"; sexp_of_string v__049_ ]
                  in
                  Sexplib0.Sexp.List [ res0__052_; res1__053_ ]) [@merlin.hide]);
           let permutatations = List.init 10 ~f:(fun _ -> List.permute elements) in
           List.iter permutatations ~f:(fun elements ->
             let t' = Binable.of_string binable_m (bin_io_of_elements elements) in
             if not (T.equal t t')
             then
               failwiths
                 ~here:
                   { Ppx_here_lib.pos_fname = "stable_unit_test.ml.before-ppx"
                   ; pos_lnum = 158
                   ; pos_cnum = 5854
                   ; pos_bol = 5836
                   }
                 "bin-io deserialization mismatch"
                 (`Expected t, `But_got t')
                 ((fun (arg0__056_, arg1__057_) ->
                    let res0__058_ =
                      let (`Expected v__054_) = arg0__056_ in
                      Sexplib0.Sexp.List
                        [ Sexplib0.Sexp.Atom "Expected"; T.sexp_of_t v__054_ ]
                    and res1__059_ =
                      let (`But_got v__055_) = arg1__057_ in
                      Sexplib0.Sexp.List
                        [ Sexplib0.Sexp.Atom "But_got"; T.sexp_of_t v__055_ ]
                    in
                    Sexplib0.Sexp.List [ res0__058_; res1__059_ ]) [@merlin.hide])));
         ())
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
