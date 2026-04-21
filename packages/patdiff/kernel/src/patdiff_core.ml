let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patdiff_core.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patdiff_core.ml.before-ppx"
;;

open! Core
open! Import
include Patdiff_core_intf

include struct
  open Configuration

  let default_context = default_context
  let default_line_big_enough = default_line_big_enough
  let default_word_big_enough = default_word_big_enough
end

let ws_rex =
  Re.compile
    (let open Re in
     rep1 space)
;;

let ws_rex_anchored =
  Re.compile
    (let open Re in
     seq [ bol; rep space; eol ])
;;

let ws_sub = " "
let remove_ws s = String.strip (Re.replace_string ws_rex s ~by:ws_sub)
let is_ws = Re.execp ws_rex_anchored

let words_rex =
  let open Re in
  let delim = set {|"{}[]#,.;()_|} in
  let punct = rep1 (set {|=`+-/!@$%^&*:|<>|}) in
  let space = rep1 space in
  let ansi_sgr_sequence =
    let esc = char '\027' in
    seq [ esc; char '['; rep (alt [ char ';'; digit ]); char 'm' ]
  in
  compile (alt [ delim; punct; space; ansi_sgr_sequence ])
;;

let split s ~keep_ws =
  let s = if keep_ws then s else String.rstrip s in
  if String.is_empty s && keep_ws
  then [ "" ]
  else
    List.filter_map
      ~f:(fun token ->
        let string =
          match token with
          | `Delim d -> Re.Group.get d 0
          | `Text t -> t
        in
        if String.is_empty string then None else Some string)
      (Re.split_full words_rex s)
;;

let whitespace_ignorant_split s =
  if String.is_empty s
  then []
  else (
    let istext s = not (Re.execp ws_rex s) in
    List.map
      ~f:String.concat
      (List.group
         ~break:(fun split_result1 _ -> istext split_result1)
         (split s ~keep_ws:false)))
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
        ~filename_rel_to_project_root:"patdiff_core.ml.before-ppx"
        ~line_number:67
        ~location:{ start_bol = 2161; start_pos = 2163; end_pos = 2271 }
        ~trailing_loc:{ start_bol = 2247; start_pos = 2271; end_pos = 2271 }
        ~body_loc:{ start_bol = 2161; start_pos = 2163; end_pos = 2271 }
        ~formatting_flexibility:
          (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
             Ppx_expect_runtime.Expect_node_formatting.default)
        ~expected_exn:None
        ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1)
        ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2)
        ~description:None
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
                      ( { contents = " (\"\") "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 2247; start_pos = 2260; end_pos = 2270 } ))
                 ~node_loc:{ start_bol = 2247; start_pos = 2251; end_pos = 2271 } )
           ]
          [@merlin.hide])
        (fun () ->
           print_s
             (((fun x__001_ -> sexp_of_list sexp_of_string x__001_) [@merlin.hide])
                (split ~keep_ws:true ""));
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide])
  ;;
end

module Make (Output_impls : Output_impls) = struct
  module Output_ops = struct
    module Rule = struct
      let apply text ~rule ~output ~refined =
        let (module O) = Output_impls.implementation output in
        O.Rule.apply text ~rule ~refined
      ;;
    end

    module Rules = struct
      let to_string (rules : Format.Rules.t) output
        : string Patience_diff.Range.t -> string Patience_diff.Range.t
        =
        let apply text ~rule ~refined = Rule.apply text ~rule ~output ~refined in
        function
        | Same ar ->
          let formatted_ar =
            Array.map ar ~f:(fun (x, y) ->
              let app = apply ~rule:rules.line_same ~refined:false in
              app x, app y)
          in
          Same formatted_ar
        | Next (ar, move_kind) ->
          Next
            ( Array.map
                ar
                ~f:
                  (apply
                     ~refined:false
                     ~rule:
                       (match move_kind with
                        | Some (Move _) -> rules.moved_to_next
                        | Some (Within_move _) -> rules.added_in_move
                        | None -> rules.line_next))
            , move_kind )
        | Prev (ar, move_kind) ->
          Prev
            ( Array.map
                ar
                ~f:
                  (apply
                     ~refined:false
                     ~rule:
                       (match move_kind with
                        | Some (Move _) -> rules.moved_from_prev
                        | Some (Within_move _) -> rules.removed_in_move
                        | None -> rules.line_prev))
            , move_kind )
        | Unified (ar, move_id) ->
          Unified
            ( Array.map
                ar
                ~f:
                  (apply
                     ~refined:true
                     ~rule:
                       (match move_id with
                        | None -> rules.line_unified
                        | Some _ -> rules.line_unified_in_move))
            , move_id )
        | Replace (ar1, ar2, move_id) ->
          let prev_rule, next_rule =
            match move_id with
            | None -> rules.line_prev, rules.line_next
            | Some _ -> rules.removed_in_move, rules.added_in_move
          in
          let ar1 = Array.map ar1 ~f:(apply ~refined:true ~rule:prev_rule) in
          let ar2 = Array.map ar2 ~f:(apply ~refined:true ~rule:next_rule) in
          Replace (ar1, ar2, move_id)
      ;;

      let map_ranges (hunks : _ Patience_diff.Hunk.t list) ~f =
        List.map hunks ~f:(fun hunk -> { hunk with ranges = List.map hunk.ranges ~f })
      ;;

      let apply hunks ~rules ~output = map_ranges hunks ~f:(to_string rules output)
    end

    let print ~print_global_header ~file_names ~rules ~output ~print ~location_style hunks
      =
      let formatted_hunks = Rules.apply ~rules ~output hunks in
      let (module O) = Output_impls.implementation output in
      O.print
        ~print_global_header
        ~file_names
        ~rules
        ~print
        ~location_style
        formatted_hunks
    ;;
  end

  let indentation line =
    let rec loop line len i n =
      if i >= len
      then n, i
      else (
        match line.[i] with
        | ' ' -> loop line len (i + 1) (n + 1)
        | '\t' -> loop line len (i + 1) (n + 4)
        | _ -> n, i)
    in
    loop line (String.length line) 0 0
  ;;

  let score_line (side : [ `left | `right ]) line1 line2 : int =
    let i1, start_of_1 = indentation line1 in
    let i2, start_of_2 = indentation line2 in
    let some_lines_are_blank = String.length line1 = 0 || String.length line2 = 0 in
    let base_score =
      let i2 = if some_lines_are_blank then max i1 i2 else i2 in
      max (-90) (90 - (i2 * 2))
    in
    let decreasing_indentation_bonus =
      if some_lines_are_blank
      then 0
      else
        Int.clamp_exn
          ~min:(-2)
          ~max:3
          (if i1 = i2
           then (
             match side with
             | `left -> 1
             | `right -> 0)
           else i1 - i2)
    in
    let bonus_for_chars =
      let bonus n line sides str =
        let line, i =
          match line with
          | `above -> line1, start_of_1
          | `below -> line2, start_of_2
        in
        match sides, side with
        | `any, _ | `left, `left | `right, `right ->
          if String.is_substring_at line ~substring:str ~pos:i then n else 0
        | _ -> 0
      in
      bonus 1 `below `any "(("
      + bonus 3 `below `any "("
      + bonus 1 `above `right "}"
      + bonus (-1) `below `any "}"
      + bonus 1 `below `any "{"
      + bonus 5 `above `any "</"
      + bonus (-4) `below `left "</"
      + bonus 3 `below `any "<"
      + bonus 2 `below `any "*"
      + bonus 1 `below `any "-"
      + bonus 3 `above `right ";;"
      + bonus 1 `above `left ";;"
      + bonus 4 `below `left "let"
      + bonus (-1) `below `left "let%"
      + bonus 2 `below `left "let%test"
      + bonus 2 `below `left "let%expect"
      + bonus 2 `below `right "let"
      + bonus 1 `above `any "in"
      + bonus 4 `below `left "module"
      + bonus 3 `above `right "end"
      + bonus (min (-1) (-decreasing_indentation_bonus)) `below `any ";;"
      + bonus (min (-1) (-decreasing_indentation_bonus)) `below `any "end"
      + if start_of_2 >= String.length line2 then 2 else 0
    in
    base_score + decreasing_indentation_bonus + bonus_for_chars
  ;;

  module Range_info = struct
    module T = struct
      type t =
        { range_index : int
        ; size_of_range : int
        ; replace_id : int option
        }
      [@@deriving compare, hash, sexp_of, fields ~getters]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__002_ b__003_ ->
             if Stdlib.( == ) a__002_ b__003_
             then 0
             else (
               match compare_int a__002_.range_index b__003_.range_index with
               | 0 ->
                 (match compare_int a__002_.size_of_range b__003_.size_of_range with
                  | 0 ->
                    compare_option
                      (fun a__004_ (b__005_ [@merlin.hide]) ->
                         (compare_int a__004_ b__005_ [@merlin.hide]))
                      a__002_.replace_id
                      b__003_.replace_id
                  | n -> n)
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv =
              let hsv = hsv in
              hash_fold_int hsv arg.range_index
            in
            hash_fold_int hsv arg.size_of_range
          in
          hash_fold_option (fun hsv arg -> hash_fold_int hsv arg) hsv arg.replace_id
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

        let sexp_of_t =
          (fun { range_index = range_index__007_
               ; size_of_range = size_of_range__009_
               ; replace_id = replace_id__011_
               } ->
             let bnds__006_ = ([] : _ Stdlib.List.t) in
             let bnds__006_ =
               let arg__012_ = sexp_of_option sexp_of_int replace_id__011_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "replace_id"; arg__012_ ]
                :: bnds__006_
                : _ Stdlib.List.t)
             in
             let bnds__006_ =
               let arg__010_ = sexp_of_int size_of_range__009_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "size_of_range"; arg__010_ ]
                :: bnds__006_
                : _ Stdlib.List.t)
             in
             let bnds__006_ =
               let arg__008_ = sexp_of_int range_index__007_ in
               (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "range_index"; arg__008_ ]
                :: bnds__006_
                : _ Stdlib.List.t)
             in
             Sexplib0.Sexp.List bnds__006_
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
        let replace_id _r__ = _r__.replace_id
        let _ = replace_id
        let size_of_range _r__ = _r__.size_of_range
        let _ = size_of_range
        let range_index _r__ = _r__.range_index
        let _ = range_index
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let compare_by_size = Comparable.lift Int.compare ~f:size_of_range
    end

    include T
    include Hashable.Make_plain (T)
  end

  module Range_with_replaces_info = struct
    type t =
      { hunk_index : int
      ; range_type : [ `Original | `Former_replace of int | `Move ]
      }
  end

  let find_moves ~line_big_enough ~keep_ws (hunks : Hunks.t) =
    let minimum_match_perc = 0.7 in
    let minimum_lines = 3 in
    let all_ranges = Queue.create () in
    let replace_id = ref 0 in
    List.iteri hunks ~f:(fun hunk_index hunk ->
      List.iter hunk.ranges ~f:(fun range ->
        match range with
        | Replace (prev, next, None) ->
          Queue.enqueue
            all_ranges
            ( { Range_with_replaces_info.hunk_index
              ; range_type = `Former_replace !replace_id
              }
            , Patience_diff.Range.Prev (prev, None) );
          Queue.enqueue
            all_ranges
            ( { Range_with_replaces_info.hunk_index
              ; range_type = `Former_replace !replace_id
              }
            , Patience_diff.Range.Next (next, None) );
          Int.incr replace_id
        | _ ->
          Queue.enqueue
            all_ranges
            ({ Range_with_replaces_info.hunk_index; range_type = `Original }, range)));
    let prev_ranges = Queue.create () in
    let next_ranges =
      Pairing_heap.create ~cmp:(Comparable.lift Range_info.compare_by_size ~f:fst) ()
    in
    Queue.iteri all_ranges ~f:(fun range_index (replace_info, range) ->
      let replace_id =
        match replace_info.range_type with
        | `Former_replace id -> Some id
        | `Move | `Original -> None
      in
      match range with
      | Prev (range_contents, None) when Array.length range_contents >= minimum_lines ->
        Queue.enqueue
          prev_ranges
          ( { Range_info.range_index
            ; size_of_range = Array.sum (module Int) ~f:String.length range_contents
            ; replace_id
            }
          , range_contents )
      | Next (range_contents, None) when Array.length range_contents >= minimum_lines ->
        Pairing_heap.add
          next_ranges
          ( { Range_info.range_index
            ; size_of_range = Array.sum (module Int) ~f:String.length range_contents
            ; replace_id
            }
          , range_contents )
      | _ -> ());
    let prevs_used = Range_info.Table.create () in
    let nexts_to_replace = Range_info.Table.create () in
    let next_ranges =
      Array.init (Pairing_heap.length next_ranges) ~f:(fun _ ->
        Pairing_heap.pop_exn next_ranges)
    in
    let move_id = ref Patience_diff.Move_id.zero in
    Queue.iter prev_ranges ~f:(fun (prev_location, prev_contents) ->
      let starting_index =
        Option.value
          ~default:(Array.length next_ranges - 1)
          (Array.binary_search
             next_ranges
             ~compare:(fun (next_range_info, _next_contents) prev_range_info ->
               Range_info.compare_by_size next_range_info prev_range_info)
             `Last_less_than_or_equal_to
             prev_location)
      in
      let starting_index = if starting_index < 0 then 0 else starting_index in
      let left_index = ref starting_index in
      let right_index = ref (starting_index + 1) in
      let max_similarity range_a range_b =
        let a_size = Int.to_float range_a.Range_info.size_of_range in
        let b_size = Int.to_float range_b.Range_info.size_of_range in
        Float.min a_size b_size /. Float.max a_size b_size
      in
      let next_closest_range () =
        let left_range =
          if !left_index < 0 || !left_index >= Array.length next_ranges
          then None
          else Some next_ranges.(!left_index)
        in
        let right_range =
          if !right_index < 0 || !right_index >= Array.length next_ranges
          then None
          else Some next_ranges.(!right_index)
        in
        match left_range, right_range with
        | None, None -> None
        | Some left_range, None ->
          Int.decr left_index;
          Some left_range
        | None, Some right_range ->
          Int.incr right_index;
          Some right_range
        | Some (left_info, left_range), Some (right_info, right_range) ->
          if
            Float.compare
              (max_similarity left_info prev_location)
              (max_similarity right_info prev_location)
            >= 0
          then (
            Int.decr left_index;
            Some (left_info, left_range))
          else (
            Int.incr right_index;
            Some (right_info, right_range))
      in
      let rec find_best_next_range best_match_so_far =
        let finish () =
          match best_match_so_far with
          | None -> ()
          | Some (_, select_hunk) -> select_hunk ()
        in
        match next_closest_range () with
        | None -> finish ()
        | Some (next_location, next_contents) ->
          let max_similarity = max_similarity prev_location next_location in
          if
            (let open Float in
             max_similarity < minimum_match_perc)
            ||
            match best_match_so_far with
            | None -> false
            | Some (best_match_ratio, _) ->
              let open Float in
              max_similarity < best_match_ratio
          then finish ()
          else if
            Hashtbl.mem nexts_to_replace next_location
            ||
            match next_location.replace_id, prev_location.replace_id with
            | Some next_id, Some prev_id when next_id = prev_id -> true
            | _ -> false
          then find_best_next_range best_match_so_far
          else (
            let match_ratio =
              Patience_diff.String.match_ratio prev_contents next_contents
            in
            let select_hunk () =
              let hunk =
                let transform = if keep_ws then Fn.id else remove_ws in
                List.hd_exn
                  (Patience_diff.String.get_hunks
                     ~transform
                     ~context:(-1)
                     ~big_enough:line_big_enough
                     ~max_slide:100
                     ~score:score_line
                     ~prev:prev_contents
                     ~next:next_contents
                     ())
              in
              let move_index = !move_id in
              Hashtbl.add_exn prevs_used ~key:prev_location ~data:(move_index, None, None);
              move_id := Patience_diff.Move_id.succ !move_id;
              let num_ranges = List.length hunk.ranges in
              let range_index_is_on_edge range_index =
                range_index = 0 || range_index = num_ranges - 1
              in
              Hashtbl.add_exn
                nexts_to_replace
                ~key:next_location
                ~data:
                  (List.filter_mapi hunk.ranges ~f:(fun range_index_within_move range ->
                     match range with
                     | Same contents ->
                       Some
                         (Patience_diff.Range.Next
                            (Array.map ~f:snd contents, Some (Move move_index)))
                     | Replace (prev, next, _) ->
                       Some (Replace (prev, next, Some move_index))
                     | Prev (prev, _) ->
                       if range_index_is_on_edge range_index_within_move
                       then (
                         Hashtbl.update prevs_used prev_location ~f:(function
                           | Some (move_index, beg_lines, end_lines) ->
                             ( move_index
                             , (if range_index_within_move = 0
                                then Some (Array.length prev)
                                else beg_lines)
                             , if range_index_within_move = num_ranges - 1
                               then Some (Array.length prev)
                               else end_lines )
                           | None -> assert false);
                         None)
                       else Some (Prev (prev, Some (Within_move move_index)))
                     | Next (next, _) ->
                       Some
                         (Next
                            ( next
                            , if range_index_is_on_edge range_index_within_move
                              then None
                              else Some (Within_move move_index) ))
                     | Unified (contents, _) -> Some (Unified (contents, Some move_index))))
            in
            let best_match_so_far =
              match best_match_so_far with
              | None
                when let open Float in
                     match_ratio >= minimum_match_perc -> Some (match_ratio, select_hunk)
              | None -> None
              | Some (best_match_ratio, _) ->
                if
                  let open Float in
                  match_ratio > best_match_ratio
                then Some (match_ratio, select_hunk)
                else best_match_so_far
            in
            find_best_next_range best_match_so_far)
      in
      find_best_next_range None);
    let prevs_by_range_index =
      Int.Table.of_alist_exn
        (List.map
           ~f:(fun (range_info, move_info) ->
             range_info.Range_info.range_index, move_info)
           (Hashtbl.to_alist prevs_used))
    in
    let nexts_by_range_index =
      Int.Table.of_alist_exn
        (List.map
           ~f:(fun (range_info, ranges_to_insert) ->
             range_info.Range_info.range_index, ranges_to_insert)
           (Hashtbl.to_alist nexts_to_replace))
    in
    let ranges =
      List.concat
        (Queue.to_list
           (Queue.mapi all_ranges ~f:(fun range_index (range_data, range) ->
              match
                ( Hashtbl.find prevs_by_range_index range_index
                , Hashtbl.find nexts_by_range_index range_index )
              with
              | Some _, Some _ -> assert false
              | None, None -> [ range_data, range ]
              | Some (move_id, lines_to_trim_at_beg, lines_to_trim_at_end), None ->
                (match range with
                 | Patience_diff.Range.Prev (contents, None) ->
                   let lines_to_trim_at_beg =
                     Option.value lines_to_trim_at_beg ~default:0
                   in
                   let lines_to_trim_at_end =
                     Option.value lines_to_trim_at_end ~default:0
                   in
                   List.filter_opt
                     [ (if lines_to_trim_at_beg = 0
                        then None
                        else
                          Some
                            ( { range_data with range_type = `Original }
                            , Patience_diff.Range.Prev
                                (Array.sub contents ~pos:0 ~len:lines_to_trim_at_beg, None)
                            ))
                     ; Some
                         ( { range_data with range_type = `Move }
                         , Patience_diff.Range.Prev
                             ( Array.sub
                                 contents
                                 ~pos:lines_to_trim_at_beg
                                 ~len:
                                   (Array.length contents
                                    - lines_to_trim_at_beg
                                    - lines_to_trim_at_end)
                             , Some (Move move_id) ) )
                     ; (if lines_to_trim_at_end = 0
                        then None
                        else
                          Some
                            ( { range_data with range_type = `Original }
                            , Patience_diff.Range.Prev
                                ( Array.sub
                                    contents
                                    ~pos:(Array.length contents - lines_to_trim_at_end)
                                    ~len:lines_to_trim_at_end
                                , None ) ))
                     ]
                 | _ -> assert false)
              | None, Some ranges_to_replace ->
                let range_data = { range_data with range_type = `Move } in
                List.map ranges_to_replace ~f:(fun range -> range_data, range))))
    in
    let final_ranges = Queue.create () in
    let rec recover_replaces = function
      | ( { Range_with_replaces_info.range_type = `Former_replace _; hunk_index }
        , Patience_diff.Range.Prev (prev, None) )
        :: ( { Range_with_replaces_info.range_type = `Former_replace _; hunk_index = _ }
           , Next (next, None) )
        :: rest_ranges ->
        Queue.enqueue
          final_ranges
          ( { Range_with_replaces_info.range_type = `Original; hunk_index }
          , Patience_diff.Range.Replace (prev, next, None) );
        recover_replaces rest_ranges
      | range :: rest_ranges ->
        Queue.enqueue final_ranges range;
        recover_replaces rest_ranges
      | [] -> ()
    in
    recover_replaces ranges;
    let final_hunks =
      List.mapi hunks ~f:(fun hunk_index hunk ->
        let ranges =
          let hunk_ranges = Queue.create () in
          Queue.drain
            final_ranges
            ~f:(fun (_, range) -> Queue.enqueue hunk_ranges range)
            ~while_:(fun (range_data, _) ->
              range_data.Range_with_replaces_info.hunk_index = hunk_index);
          Queue.to_list hunk_ranges
        in
        { hunk with ranges })
    in
    final_hunks
  ;;

  let diff ~context ~line_big_enough ~keep_ws ~find_moves:should_find_moves ~prev ~next =
    let transform = if keep_ws then Fn.id else remove_ws in
    (fun hunks ->
       if should_find_moves then find_moves ~line_big_enough ~keep_ws hunks else hunks)
      (Patience_diff.String.get_hunks
         ~transform
         ~context
         ~big_enough:line_big_enough
         ~max_slide:100
         ~score:score_line
         ~prev
         ~next
         ())
  ;;

  type word_or_newline =
    [ `Newline of int * string option
    | `Word of string
    ]
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : word_or_newline) -> ()

    let sexp_of_word_or_newline =
      (function
       | `Newline v__013_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Newline"
           ; (let arg0__014_, arg1__015_ = v__013_ in
              let res0__016_ = sexp_of_int arg0__014_
              and res1__017_ = sexp_of_option sexp_of_string arg1__015_ in
              Sexplib0.Sexp.List [ res0__016_; res1__017_ ])
           ]
       | `Word v__018_ ->
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Word"; sexp_of_string v__018_ ]
       : word_or_newline -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_word_or_newline
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let explode ar ~keep_ws =
    let words = Array.to_list ar in
    let words =
      if keep_ws
      then List.map words ~f:(split ~keep_ws)
      else List.map words ~f:whitespace_ignorant_split
    in
    let to_words l = List.map l ~f:(fun s -> `Word s) in
    let words =
      List.concat_map words ~f:(fun x ->
        match x with
        | hd :: tl ->
          if keep_ws && (not (String.is_empty hd)) && is_ws hd
          then `Newline (1, Some hd) :: to_words tl
          else `Newline (1, None) :: `Word hd :: to_words tl
        | [] -> [ `Newline (1, None) ])
    in
    let words =
      List.fold_right words ~init:[] ~f:(fun x acc ->
        match acc with
        | `Word s :: tl -> x :: `Word s :: tl
        | `Newline (i, None) :: tl ->
          (match x with
           | `Word s -> `Word s :: `Newline (i, None) :: tl
           | `Newline (j, opt) -> `Newline (i + j, opt) :: tl)
        | `Newline (i, Some s1) :: tl ->
          (match x with
           | `Word s2 -> `Word s2 :: `Newline (i, Some s1) :: tl
           | `Newline (j, opt) ->
             let s1 = Option.value opt ~default:"" ^ s1 in
             `Newline (i + j, Some s1) :: tl)
        | [] -> [ x ])
    in
    let words =
      match words with
      | `Newline (i, opt) :: tl -> `Newline (i - 1, opt) :: tl
      | `Word _ :: _ | [] ->
        raise_s
          (let ppx_sexp_message () =
             Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                   "Expected words to start with a `Newline."
               ; Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Sexp.Atom "words"
                   ; ((fun x__019_ -> sexp_of_list sexp_of_word_or_newline x__019_)
                        [@merlin.hide])
                       words
                   ]
               ]
               [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
           in
           (ppx_sexp_message () [@nontail]))
    in
    let words =
      match words with
      | [] -> []
      | `Newline (0, None) :: [] -> []
      | list -> List.append list [ `Newline (1, None) ]
    in
    Array.of_list words
  ;;

  let collapse ranges ~rule_same ~rule_prev ~rule_next ~kind ~output =
    let flag = ref `Same in
    let segment = ref [] in
    let line = ref [] in
    let lines = ref [] in
    let apply ~rule = function
      | "" -> ""
      | s -> Output_ops.Rule.apply s ~rule ~output ~refined:false
    in
    let finish_segment () =
      let rule =
        match !flag with
        | `Same -> rule_same
        | `Prev -> rule_prev
        | `Next -> rule_next
      in
      let formatted_segment = apply ~rule (String.concat (List.rev !segment)) in
      line := formatted_segment :: !line;
      segment := []
    in
    let newline i =
      for _ = 1 to i do
        finish_segment ();
        lines := String.concat (List.rev !line) :: !lines;
        line := []
      done
    in
    let f range =
      let ar =
        match (range : _ Patience_diff.Range.t) with
        | Same ar ->
          flag := `Same;
          let f =
            match kind with
            | `Prev_only -> fst
            | `Next_only -> snd
            | `Unified -> snd
          in
          Array.map ar ~f
        | Prev (ar, _) ->
          flag := `Prev;
          ar
        | Next (ar, _) ->
          flag := `Next;
          ar
        | Replace _ | Unified _ -> assert false
      in
      Array.iter ar ~f:(function
        | `Newline (i, None) -> newline i
        | `Newline (i, Some s) ->
          newline i;
          segment := s :: !segment
        | `Word s -> segment := s :: !segment);
      finish_segment ()
    in
    List.iter ranges ~f;
    (match !line with
     | [] | "" :: [] -> ()
     | line ->
       let line = String.concat (List.rev line) in
       if is_ws line
       then ()
       else
         raise_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Invariant violated: [collapse] got a line not terminated with a \
                     newline"
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "line"
                    ; (sexp_of_string [@merlin.hide]) line
                    ]
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])));
    Array.of_list (List.rev !lines)
  ;;

  let diff_pieces ~prev_pieces ~next_pieces ~keep_ws ~word_big_enough =
    let context = -1 in
    let transform =
      if keep_ws
      then
        function
        | `Word s -> s
        | `Newline (lines, trailing_whitespace) ->
          Option.fold trailing_whitespace ~init:(String.make lines '\n') ~f:String.( ^ )
      else
        function
        | `Word s -> remove_ws s
        | `Newline (0, _) -> ""
        | `Newline (_, _) -> " "
    in
    Patience_diff.String.get_hunks
      ~transform
      ~context
      ~big_enough:word_big_enough
      ~max_slide:0
      ~prev:prev_pieces
      ~next:next_pieces
      ()
  ;;

  let ranges_are_just_whitespace (ranges : _ Patience_diff.Range.t list) =
    List.for_all ranges ~f:(function
      | Prev (piece_array, _) | Next (piece_array, _) ->
        Array.for_all piece_array ~f:(function
          | `Word s -> String.is_empty (remove_ws s)
          | `Newline _ -> true)
      | _ -> true)
  ;;

  let split_for_readability rangelist =
    let ans : _ Patience_diff.Range.t list list ref = ref [] in
    let pending_ranges : _ Patience_diff.Range.t list ref = ref [] in
    let append_range range = pending_ranges := range :: !pending_ranges in
    List.iter rangelist ~f:(fun range ->
      let split_was_executed =
        match (range : _ Patience_diff.Range.t) with
        | Next _ | Prev _ | Replace _ | Unified _ -> false
        | Same seq ->
          let first_newline =
            Array.find_mapi seq ~f:(fun i -> function
              | `Word _, _ | _, `Word _ | `Newline (0, _), _ | _, `Newline (0, _) -> None
              | `Newline first_nlA, `Newline first_nlB -> Some (i, first_nlA, first_nlB))
          in
          (match first_newline with
           | None -> false
           | Some (i, first_nlA, first_nlB) ->
             if Array.length seq - i <= Configuration.too_short_to_split
             then false
             else (
               append_range (Same (Array.sub seq ~pos:0 ~len:i));
               append_range (Same [| `Newline (1, None), `Newline (1, None) |]);
               ans := List.rev !pending_ranges :: !ans;
               pending_ranges := [];
               let suf = Array.sub seq ~pos:i ~len:(Array.length seq - i) in
               let decr_first (x, y) = x - 1, y in
               suf.(0) <- `Newline (decr_first first_nlA), `Newline (decr_first first_nlB);
               append_range (Same suf);
               true))
      in
      if not split_was_executed then append_range range);
    List.rev
      (match !pending_ranges with
       | [] -> !ans
       | _ :: _ as ranges -> List.rev ranges :: !ans)
  ;;

  let refine
        ~(rules : Format.Rules.t)
        ~produce_unified_lines
        ~output
        ~keep_ws
        ~split_long_lines
        ~interleave
        ~word_big_enough
        (hunks : string Patience_diff.Hunk.t list)
    =
    let rule_prev = rules.word_prev in
    let rule_next = rules.word_next in
    let collapse = collapse ~rule_prev ~rule_next ~output in
    let () =
      match output with
      | Ansi | Html -> ()
      | Ascii ->
        if produce_unified_lines
        then failwith "produce_unified_lines is not supported in Ascii mode"
    in
    let console_width =
      lazy
        (match Output_impls.console_width () with
         | Error _ -> 80
         | Ok width -> width)
    in
    let refine_range : _ Patience_diff.Range.t -> _ Patience_diff.Range.t list = function
      | Next (a, _) when (not keep_ws) && Array.for_all a ~f:is_ws ->
        [ Same (Array.zip_exn a a) ]
      | Prev (a, _) when (not keep_ws) && Array.for_all a ~f:is_ws -> []
      | (Next _ | Prev _ | Same _ | Unified _) as range -> [ range ]
      | Replace (prev_ar, next_ar, move_kind) ->
        let prev_pieces = explode prev_ar ~keep_ws in
        let next_pieces = explode next_ar ~keep_ws in
        let sub_diff = diff_pieces ~prev_pieces ~next_pieces ~keep_ws ~word_big_enough in
        let sub_diff = Patience_diff.Hunks.ranges sub_diff in
        let sub_diff_pieces =
          if not split_long_lines
          then [ sub_diff ]
          else (
            let max_len = Int.max 20 (force console_width - 2) in
            let get_new_len_so_far ~len_so_far tokens_arr =
              Array.fold ~init:len_so_far tokens_arr ~f:(fun len_so_far token ->
                match token with
                | `Newline _ -> 0
                | `Word word -> len_so_far + String.length word)
            in
            let rec split_lines len_so_far sub_diff rangeaccum rangelistaccum =
              match sub_diff with
              | [] ->
                (match rangeaccum with
                 | [] -> List.rev rangelistaccum
                 | _ -> List.rev (List.rev rangeaccum :: rangelistaccum))
              | range :: rest ->
                (match (range : _ Patience_diff.Range.t) with
                 | Same tokenpairs_arr ->
                   let range_of_tokens tokenpairs =
                     Patience_diff.Range.Same (Array.of_list tokenpairs)
                   in
                   let rec take_until_max len_so_far tokenpairs accum =
                     match tokenpairs with
                     | [] -> len_so_far, range_of_tokens (List.rev accum), [], false
                     | ((token, _) as tokenpair) :: rest ->
                       (match token with
                        | `Newline _ ->
                          0, range_of_tokens (List.rev (tokenpair :: accum)), rest, true
                        | `Word word ->
                          let wordlen = String.length word in
                          if wordlen + len_so_far > max_len && len_so_far > 0
                          then 0, range_of_tokens (List.rev accum), tokenpairs, false
                          else
                            take_until_max (wordlen + len_so_far) rest (tokenpair :: accum))
                   in
                   let make_newline () =
                     Patience_diff.Range.Same [| `Newline (1, None), `Newline (1, None) |]
                   in
                   let rec take_ranges_until_exhausted len_so_far tokenpairs accum =
                     match tokenpairs with
                     | [] -> len_so_far, List.rev accum
                     | _ ->
                       let new_len_so_far, new_range, new_tokenpairs, hit_newline =
                         take_until_max len_so_far tokenpairs []
                       in
                       let new_accum = `Range new_range :: accum in
                       let new_accum =
                         match new_tokenpairs with
                         | _ :: _ when not hit_newline ->
                           `Break :: `Range (make_newline ()) :: new_accum
                         | _ -> new_accum
                       in
                       take_ranges_until_exhausted new_len_so_far new_tokenpairs new_accum
                   in
                   let new_len_so_far, new_ranges =
                     take_ranges_until_exhausted
                       len_so_far
                       (Array.to_list tokenpairs_arr)
                       []
                   in
                   let rangeaccum, rangelistaccum =
                     List.fold
                       new_ranges
                       ~init:(rangeaccum, rangelistaccum)
                       ~f:(fun (rangeaccum, rangelistaccum) r ->
                         match r with
                         | `Break -> [], List.rev rangeaccum :: rangelistaccum
                         | `Range r -> r :: rangeaccum, rangelistaccum)
                   in
                   split_lines new_len_so_far rest rangeaccum rangelistaccum
                 | Next (tokens_arr, _) | Prev (tokens_arr, _) ->
                   let new_len_so_far = get_new_len_so_far ~len_so_far tokens_arr in
                   split_lines new_len_so_far rest (range :: rangeaccum) rangelistaccum
                 | Replace (prev_arr, next_arr, _move_kind) ->
                   let new_len_so_far =
                     Int.max
                       (get_new_len_so_far ~len_so_far prev_arr)
                       (get_new_len_so_far ~len_so_far next_arr)
                   in
                   split_lines new_len_so_far rest (range :: rangeaccum) rangelistaccum
                 | Unified _ -> assert false)
            in
            split_lines 0 sub_diff [] [])
        in
        let sub_diff_pieces =
          if interleave
          then List.concat_map sub_diff_pieces ~f:split_for_readability
          else sub_diff_pieces
        in
        List.concat_map sub_diff_pieces ~f:(fun sub_diff ->
          let sub_prev = Patience_diff.Range.prev_only sub_diff in
          let sub_next = Patience_diff.Range.next_only sub_diff in
          let all_same ranges =
            List.for_all ranges ~f:(fun range ->
              match (range : _ Patience_diff.Range.t) with
              | Same _ -> true
              | Prev (a, _) | Next (a, _) ->
                if keep_ws
                then false
                else
                  Array.for_all a ~f:(function
                    | `Newline _ -> true
                    | `Word _ -> false)
              | _ -> false)
          in
          let prev_all_same = all_same sub_prev in
          let next_all_same = all_same sub_next in
          let produce_unified_lines =
            produce_unified_lines
            && (((not (ranges_are_just_whitespace sub_prev)) && next_all_same)
                || ((not (ranges_are_just_whitespace sub_next)) && prev_all_same))
          in
          let prev_next_pairs =
            match prev_all_same, next_all_same with
            | true, true ->
              let kind = `Next_only in
              let rule_same =
                match move_kind with
                | None -> rules.word_same_unified
                | Some _ -> rules.word_same_unified_in_move
              in
              let next_ar = collapse sub_next ~rule_same ~kind in
              [ next_ar, next_ar ]
            | false, true ->
              let kind = `Prev_only in
              let rule_same =
                if produce_unified_lines
                then (
                  match move_kind with
                  | None -> rules.word_same_unified
                  | Some _ -> rules.word_same_unified_in_move)
                else rules.word_same_prev
              in
              let prev_ar = collapse sub_prev ~rule_same ~kind in
              let kind = `Next_only in
              let rule_same = rules.word_same_next in
              let next_ar = collapse sub_next ~rule_same ~kind in
              [ prev_ar, next_ar ]
            | true, false ->
              let kind = `Next_only in
              let rule_same =
                if produce_unified_lines
                then (
                  match move_kind with
                  | None -> rules.word_same_unified
                  | Some _ -> rules.word_same_unified_in_move)
                else rules.word_same_next
              in
              let next_ar = collapse sub_next ~rule_same ~kind in
              let kind = `Prev_only in
              let rule_same = rules.word_same_prev in
              let prev_ar = collapse sub_prev ~rule_same ~kind in
              [ prev_ar, next_ar ]
            | false, false ->
              let kind = `Prev_only in
              let rule_same = rules.word_same_prev in
              let prev_ar = collapse sub_prev ~rule_same ~kind in
              let kind = `Next_only in
              let rule_same = rules.word_same_next in
              let next_ar = collapse sub_next ~rule_same ~kind in
              [ prev_ar, next_ar ]
          in
          List.map prev_next_pairs ~f:(fun (prev_ar, next_ar) ->
            let range : _ Patience_diff.Range.t =
              match prev_all_same, next_all_same with
              | true, true -> Same (Array.map next_ar ~f:(fun x -> x, x))
              | _ ->
                (match prev_ar, next_ar with
                 | [| "" |], next_ar -> Replace ([||], next_ar, move_kind)
                 | prev_ar, [| "" |] -> Replace (prev_ar, [||], move_kind)
                 | prev_ar, next_ar ->
                   (match produce_unified_lines, prev_all_same, next_all_same with
                    | true, true, false -> Unified (next_ar, move_kind)
                    | true, false, true -> Unified (prev_ar, move_kind)
                    | false, _, _ | _, false, false ->
                      Replace (prev_ar, next_ar, move_kind)
                    | _ -> assert false))
            in
            range))
    in
    List.filter
      ~f:(not << Patience_diff.Hunk.all_same)
      (List.map
         ~f:(fun hunk ->
           { hunk with ranges = List.concat_map hunk.ranges ~f:refine_range })
         hunks)
  ;;

  let print ~file_names ~rules ~output ~location_style hunks =
    Output_ops.print
      hunks
      ~rules
      ~output
      ~file_names
      ~print:(Printf.printf "%s\n")
      ~location_style
      ~print_global_header:true
  ;;

  let output_to_string
        ?(print_global_header = false)
        ~file_names
        ~rules
        ~output
        ~location_style
        hunks
    =
    let buf = Queue.create () in
    Output_ops.print
      hunks
      ~file_names
      ~location_style
      ~output
      ~print_global_header
      ~print:(Queue.enqueue buf)
      ~rules;
    String.concat (Queue.to_list buf) ~sep:"\n"
  ;;

  let iter_ansi ~rules ~f_hunk_break ~f_line hunks =
    let hunks = Output_ops.Rules.apply hunks ~rules ~output:Ansi in
    Hunks.iter ~f_hunk_break ~f_line hunks
  ;;

  let patdiff
        ?(context = Configuration.default_context)
        ?(keep_ws = false)
        ?(find_moves = false)
        ?(rules = Format.Rules.default)
        ?(output = Output.Ansi)
        ?(produce_unified_lines = true)
        ?(split_long_lines = true)
        ?print_global_header
        ?(location_style = Format.Location_style.Diff)
        ?(interleave = true)
        ?float_tolerance
        ?(line_big_enough = Configuration.default_line_big_enough)
        ?(word_big_enough = Configuration.default_word_big_enough)
        ~(prev : Diff_input.t)
        ~(next : Diff_input.t)
        ()
    =
    let keep_ws = keep_ws || Should_keep_whitespace.for_diff ~prev ~next in
    let hunks =
      refine
        ~rules
        ~produce_unified_lines
        ~output
        ~keep_ws
        ~split_long_lines
        ~interleave
        ~word_big_enough
        (diff
           ~context
           ~keep_ws
           ~find_moves
           ~line_big_enough
           ~prev:(List.to_array (String.split_lines prev.text))
           ~next:(List.to_array (String.split_lines next.text)))
    in
    let hunks =
      match float_tolerance with
      | None -> hunks
      | Some tolerance -> Float_tolerance.apply hunks tolerance ~context
    in
    output_to_string
      ?print_global_header
      ~file_names:(Fake prev.name, Fake next.name)
      ~rules
      ~output
      ~location_style
      hunks
  ;;
end

module Without_unix = Make (struct
    let console_width () = Ok 80

    let implementation : Output.t -> (module Output.S) = function
      | Ansi -> (module Ansi_output)
      | Ascii -> (module Ascii_output)
      | Html -> (module Html_output.Without_mtime)
    ;;
  end)

module Private = struct
  module Make = Make
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
