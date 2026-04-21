let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patience_diff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patience_diff.ml.before-ppx"
;;

open! Core
include Patience_diff_intf
module Hunk = Hunk
module Hunks = Hunks
module Matching_block = Matching_block
module Range = Range
module Move_id = Move_id

let ( <|> ) ar (i, j) = if j <= i then [||] else Array.slice ar i j

let create_hunk prev_start prev_stop next_start next_stop ranges : _ Hunk.t =
  { prev_start = prev_start + 1
  ; prev_size = prev_stop - prev_start
  ; next_start = next_start + 1
  ; next_size = next_stop - next_start
  ; ranges = List.rev ranges
  }
;;

module Ordered_sequence : sig
  type elt = int * int [@@deriving compare]

  include sig
    [@@@ocaml.warning "-32"]

    val compare_elt : elt -> (elt[@merlin.hide]) -> int
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = private elt array [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : (int * int) list -> t
  val is_empty : t -> bool
end = struct
  type elt = int * int [@@deriving sexp_of]

  include struct
    let _ = fun (_ : elt) -> ()

    let sexp_of_elt =
      (fun (arg0__001_, arg1__002_) ->
         let res0__003_ = sexp_of_int arg0__001_
         and res1__004_ = sexp_of_int arg1__002_ in
         Sexplib0.Sexp.List [ res0__003_; res1__004_ ]
       : elt -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_elt
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let compare_elt a b =
    Comparable.lexicographic
      [ (fun (_, y0) (_, y1) -> Int.compare y0 y1)
      ; (fun (x0, _) (x1, _) -> Int.compare x0 x1)
      ]
      a
      b
  ;;

  type t = elt array [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun x__005_ -> sexp_of_array sexp_of_elt x__005_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create l =
    let t = Array.of_list l in
    Array.sort t ~compare:compare_elt;
    t
  ;;

  let is_empty = Array.is_empty
end

module Patience : sig
  val longest_increasing_subsequence : Ordered_sequence.t -> (int * int) list
end = struct
  module Pile = struct
    type 'a t = 'a Stack.t

    let create x =
      let t = Stack.create () in
      Stack.push t x;
      t
    ;;

    let top t = Option.value_exn (Stack.top t)
    let put_on_top t x = Stack.push t x
  end

  module Piles = struct
    type 'a t = 'a Pile.t Deque.t

    let empty () : 'a t = Deque.create ~never_shrink:true ()

    let get_ith_pile t i dir =
      let get index offset =
        Option.bind (index t) ~f:(fun index -> Deque.get_opt t (index + offset))
      in
      match dir with
      | `From_left -> get Deque.front_index i
      | `From_right -> get Deque.back_index (-i)
    ;;

    let new_rightmost_pile t pile = Deque.enqueue_back t pile
  end

  module Backpointers = struct
    type 'a tag = 'a t

    and 'a t =
      { value : 'a
      ; tag : 'a tag option
      }

    let to_list t =
      let rec to_list acc t =
        match t.tag with
        | None -> t.value :: acc
        | Some t' -> to_list (t.value :: acc) t'
      in
      to_list [] t
    ;;
  end

  module Play_patience : sig
    val play_patience
      :  Ordered_sequence.t
      -> get_tag:
           (pile_opt:int option
            -> piles:Ordered_sequence.elt Backpointers.t Piles.t
            -> Ordered_sequence.elt Backpointers.tag option)
      -> Ordered_sequence.elt Backpointers.t Piles.t
  end = struct
    let optimized_findi_from_left piles x =
      let last_pile = Piles.get_ith_pile piles 0 `From_right in
      let x_pile = Pile.create { Backpointers.value = x, 0; tag = None } in
      let compare_top_values pile1 pile2 =
        let top pile = fst (Pile.top pile).Backpointers.value in
        Int.compare (top pile1) (top pile2)
      in
      Option.Let_syntax.Let_syntax.bind last_pile ~f:(fun last_pile ->
        if compare_top_values last_pile x_pile < 0
        then None
        else
          Deque.binary_search
            piles
            `First_strictly_greater_than
            x_pile
            ~compare:compare_top_values)
    ;;

    let play_patience ar ~get_tag =
      let ar = (ar : Ordered_sequence.t :> Ordered_sequence.elt array) in
      if Array.length ar = 0 then raise (Invalid_argument "Patience_diff.play_patience");
      let piles = Piles.empty () in
      Array.iter ar ~f:(fun x ->
        let pile_opt = optimized_findi_from_left piles (fst x) in
        let tagged_x = { Backpointers.value = x; tag = get_tag ~pile_opt ~piles } in
        match pile_opt with
        | None -> Piles.new_rightmost_pile piles (Pile.create tagged_x)
        | Some i ->
          let pile = Deque.get piles i in
          Pile.put_on_top pile tagged_x);
      piles
    ;;
  end

  let longest_increasing_subsequence ar =
    if Ordered_sequence.is_empty ar
    then []
    else
      let module P = Play_patience in
      let get_tag ~pile_opt ~piles =
        match pile_opt with
        | None -> Option.map ~f:Pile.top (Piles.get_ith_pile piles 0 `From_right)
        | Some i ->
          if i = 0
          then None
          else
            Option.some
              (Pile.top (Option.value_exn (Piles.get_ith_pile piles (i - 1) `From_left)))
      in
      let piles = P.play_patience ar ~get_tag in
      Backpointers.to_list
        (Pile.top (Option.value_exn (Piles.get_ith_pile piles 0 `From_right)))
  ;;
end

let compare_int_pair = Tuple.T2.compare ~cmp1:Int.compare ~cmp2:Int.compare

let _longest_increasing_subsequence ar =
  let ar = (ar : Ordered_sequence.t :> (int * int) array) in
  let len = Array.length ar in
  if len <= 1
  then Array.to_list ar
  else (
    let maxlen = ref 0 in
    let m = Array.create ~len:(len + 1) (-1) in
    let pred = Array.create ~len:(len + 1) (-1) in
    for i = 0 to len - 1 do
      let p =
        Option.value
          ~default:0
          (Array.binary_search
             ~compare:Ordered_sequence.compare_elt
             ar
             `First_greater_than_or_equal_to
             ar.(i)
             ~len:(max (!maxlen - 1) 0)
             ~pos:1)
      in
      pred.(i) <- m.(p);
      if p = !maxlen || compare_int_pair ar.(i) ar.(p + 1) < 0
      then (
        m.(p + 1) <- i;
        if p + 1 > !maxlen then maxlen := p + 1)
    done;
    let rec loop ac p = if p = -1 then ac else loop (ar.(p) :: ac) pred.(p) in
    loop [] m.(!maxlen))
;;

let should_discard_if_other_side_equal ~big_enough = 100 / big_enough
let switch_to_plain_diff_numerator = 1
let switch_to_plain_diff_denominator = 10

module Make (Elt : Hashtbl.Key) = struct
  module Table = Hashtbl.Make (Elt)

  type elt = Elt.t

  module Line_metadata = struct
    type t =
      | Unique_in_a of { index_in_a : int }
      | Unique_in_a_b of
          { index_in_a : int
          ; index_in_b : int
          }
      | Not_unique of { occurrences_in_a : int }
  end

  let unique_lcs (alpha, alo, ahi) (bravo, blo, bhi) =
    let unique : (elt, Line_metadata.t) Table.hashtbl =
      Table.create ~size:(Int.min (ahi - alo) (bhi - blo)) ()
    in
    for x's_pos_in_a = alo to ahi - 1 do
      let x = alpha.(x's_pos_in_a) in
      match Hashtbl.find unique x with
      | None ->
        Hashtbl.set unique ~key:x ~data:(Unique_in_a { index_in_a = x's_pos_in_a })
      | Some (Unique_in_a _) ->
        Hashtbl.set unique ~key:x ~data:(Not_unique { occurrences_in_a = 2 })
      | Some (Not_unique { occurrences_in_a = n }) ->
        Hashtbl.set unique ~key:x ~data:(Not_unique { occurrences_in_a = n + 1 })
      | Some (Unique_in_a_b _) -> assert false
    done;
    let num_pairs = ref 0 in
    let intersection_size = ref 0 in
    for x's_pos_in_b = blo to bhi - 1 do
      let x = bravo.(x's_pos_in_b) in
      Option.iter
        ~f:(fun pos ->
          match pos with
          | Not_unique { occurrences_in_a = n } ->
            if n > 0
            then (
              Hashtbl.set unique ~key:x ~data:(Not_unique { occurrences_in_a = n - 1 });
              incr intersection_size)
          | Unique_in_a { index_in_a = x's_pos_in_a } ->
            incr num_pairs;
            incr intersection_size;
            Hashtbl.set
              unique
              ~key:x
              ~data:
                (Unique_in_a_b { index_in_a = x's_pos_in_a; index_in_b = x's_pos_in_b })
          | Unique_in_a_b _ ->
            decr num_pairs;
            Hashtbl.set unique ~key:x ~data:(Not_unique { occurrences_in_a = 0 }))
        (Hashtbl.find unique x)
    done;
    if
      !num_pairs * switch_to_plain_diff_denominator
      < !intersection_size * switch_to_plain_diff_numerator
    then `Not_enough_unique_tokens
    else (
      let a_b =
        let unique =
          Hashtbl.filter_map unique ~f:(function
            | Not_unique _ | Unique_in_a _ -> None
            | Unique_in_a_b { index_in_a = i_a; index_in_b = i_b } -> Some (i_a, i_b))
        in
        Ordered_sequence.create (Hashtbl.data unique)
      in
      `Computed_lcs (Patience.longest_increasing_subsequence a_b))
  ;;

  let matches alpha bravo =
    let matches_ref_length = ref 0 in
    let matches_ref = ref [] in
    let add_match m =
      incr matches_ref_length;
      matches_ref := m :: !matches_ref
    in
    let rec recurse_matches alo blo ahi bhi =
      let old_length = !matches_ref_length in
      if not (alo >= ahi || blo >= bhi)
      then
        if Elt.compare alpha.(alo) bravo.(blo) = 0
        then (
          let alo = ref alo in
          let blo = ref blo in
          while !alo < ahi && !blo < bhi && Elt.compare alpha.(!alo) bravo.(!blo) = 0 do
            add_match (!alo, !blo);
            incr alo;
            incr blo
          done;
          recurse_matches !alo !blo ahi bhi)
        else if Elt.compare alpha.(ahi - 1) bravo.(bhi - 1) = 0
        then (
          let nahi = ref (ahi - 1) in
          let nbhi = ref (bhi - 1) in
          while
            !nahi > alo
            && !nbhi > blo
            && Elt.compare alpha.(!nahi - 1) bravo.(!nbhi - 1) = 0
          do
            decr nahi;
            decr nbhi
          done;
          recurse_matches alo blo !nahi !nbhi;
          for i = 0 to ahi - !nahi - 1 do
            add_match (!nahi + i, !nbhi + i)
          done)
        else (
          let last_a_pos = ref (alo - 1) in
          let last_b_pos = ref (blo - 1) in
          let plain_diff () =
            Plain_diff.iter_matches
              ~hashable:(module Elt)
              (Array.sub alpha ~pos:alo ~len:(ahi - alo))
              (Array.sub bravo ~pos:blo ~len:(bhi - blo))
              ~f:(fun (i1, i2) -> add_match (alo + i1, blo + i2))
          in
          match unique_lcs (alpha, alo, ahi) (bravo, blo, bhi) with
          | `Not_enough_unique_tokens -> plain_diff ()
          | `Computed_lcs lcs ->
            List.iter
              ~f:(fun (apos, bpos) ->
                if !last_a_pos + 1 <> apos || !last_b_pos + 1 <> bpos
                then recurse_matches (!last_a_pos + 1) (!last_b_pos + 1) apos bpos;
                last_a_pos := apos;
                last_b_pos := bpos;
                add_match (apos, bpos))
              lcs;
            if !matches_ref_length > old_length
            then recurse_matches (!last_a_pos + 1) (!last_b_pos + 1) ahi bhi
            else plain_diff ())
    in
    recurse_matches 0 0 (Array.length alpha) (Array.length bravo);
    List.rev !matches_ref
  ;;

  let collapse_sequences matches =
    let collapsed = ref [] in
    let start_a = ref None in
    let start_b = ref None in
    let length = ref 0 in
    List.iter matches ~f:(fun (i_a, i_b) ->
      match !start_a, !start_b with
      | Some start_a_val, Some start_b_val
        when i_a = start_a_val + !length && i_b = start_b_val + !length -> incr length
      | _ ->
        (match !start_a, !start_b with
         | Some start_a_val, Some start_b_val ->
           let matching_block =
             { Matching_block.prev_start = start_a_val
             ; next_start = start_b_val
             ; length = !length
             }
           in
           collapsed := matching_block :: !collapsed
         | _ -> ());
        start_a := Some i_a;
        start_b := Some i_b;
        length := 1);
    (match !start_a, !start_b with
     | Some start_a_val, Some start_b_val when !length <> 0 ->
       let matching_block =
         { Matching_block.prev_start = start_a_val
         ; next_start = start_b_val
         ; length = !length
         }
       in
       collapsed := matching_block :: !collapsed
     | _ -> ());
    List.rev !collapsed
  ;;

  let should_discard_match ~big_enough ~left_change ~right_change ~block_len =
    block_len < big_enough
    && ((left_change > block_len && right_change > block_len)
        || (left_change >= block_len + should_discard_if_other_side_equal ~big_enough
            && right_change = block_len)
        || (right_change >= block_len + should_discard_if_other_side_equal ~big_enough
            && left_change = block_len))
  ;;

  let change_between
        (left_matching_block : Matching_block.t)
        (right_matching_block : Matching_block.t)
    =
    max
      (right_matching_block.prev_start - left_matching_block.prev_start)
      (right_matching_block.next_start - left_matching_block.next_start)
    - left_matching_block.length
  ;;

  let basic_semantic_cleanup ~big_enough matching_blocks =
    if big_enough <= 1
    then matching_blocks
    else (
      match matching_blocks with
      | [] -> []
      | first_block :: other_blocks ->
        let final_ans, final_pending =
          List.fold
            other_blocks
            ~init:([], first_block)
            ~f:(fun (ans, pending) current_block ->
              let rec loop ans pending =
                match ans with
                | [] -> ans, pending
                | hd :: tl ->
                  if
                    should_discard_match
                      ~big_enough
                      ~left_change:(change_between hd pending)
                      ~right_change:(change_between pending current_block)
                      ~block_len:pending.length
                  then loop tl hd
                  else ans, pending
              in
              let updated_ans, updated_pending = loop ans pending in
              updated_pending :: updated_ans, current_block)
        in
        List.rev (final_pending :: final_ans))
  ;;

  let advanced_semantic_cleanup ~big_enough matching_blocks =
    if big_enough <= 1
    then matching_blocks
    else (
      match matching_blocks with
      | [] -> []
      | first_block :: [] -> [ first_block ]
      | first_block :: second_block :: other_blocks ->
        let final_ans, final_pendingA, final_pendingB =
          List.fold
            other_blocks
            ~init:([], first_block, second_block)
            ~f:(fun (ans, pendingA, pendingB) current_block ->
              let rec loop ans pendingA pendingB =
                match ans with
                | [] -> ans, pendingA, pendingB
                | hd :: tl ->
                  if
                    should_discard_match
                      ~big_enough
                      ~left_change:(change_between hd pendingA)
                      ~right_change:(change_between pendingB current_block)
                      ~block_len:
                        (pendingB.length
                         + min
                             (pendingB.prev_start - pendingA.prev_start)
                             (pendingB.next_start - pendingA.next_start))
                  then loop tl hd pendingA
                  else ans, pendingA, pendingB
              in
              let updated_ans, updated_pendingA, updated_pendingB =
                loop ans pendingA pendingB
              in
              updated_pendingA :: updated_ans, updated_pendingB, current_block)
        in
        basic_semantic_cleanup
          ~big_enough
          (List.rev (final_pendingB :: final_pendingA :: final_ans)))
  ;;

  let semantic_cleanup ~big_enough matching_blocks =
    advanced_semantic_cleanup
      ~big_enough
      (basic_semantic_cleanup ~big_enough matching_blocks)
  ;;

  let combine_equalities ~prev ~next ~matches =
    match matches with
    | [] -> []
    | first_block :: tl ->
      (fun (ans, pending) -> List.rev (pending :: ans))
        (List.fold tl ~init:([], first_block) ~f:(fun (ans, pending) block ->
           let rec loop ans ~(pending : Matching_block.t) ~(new_block : Matching_block.t) =
             if pending.length = 0
             then ans, pending, new_block
             else (
               let advance_in_prev =
                 Elt.compare
                   prev.(pending.prev_start + pending.length - 1)
                   prev.(new_block.prev_start - 1)
                 = 0
               in
               let advance_in_next =
                 Elt.compare
                   next.(pending.next_start + pending.length - 1)
                   next.(new_block.next_start - 1)
                 = 0
               in
               if advance_in_prev && advance_in_next
               then
                 loop
                   ans
                   ~pending:
                     { prev_start = pending.prev_start
                     ; next_start = pending.next_start
                     ; length = pending.length - 1
                     }
                   ~new_block:
                     { prev_start = new_block.prev_start - 1
                     ; next_start = new_block.next_start - 1
                     ; length = new_block.length + 1
                     }
               else ans, pending, new_block)
           in
           let updated_ans, updated_pending, updated_new_block =
             loop ans ~pending ~new_block:block
           in
           if updated_pending.length = 0 || updated_pending.length = 1
           then (
             let new_ans =
               if updated_pending.length = 0
               then updated_ans
               else updated_pending :: updated_ans
             in
             new_ans, updated_new_block)
           else pending :: ans, block))
  ;;

  let align_diffs
        ~prev_elts
        ~prev_scorable
        ~next_elts
        ~next_scorable
        ~max_slide
        ~score
        blocks
    =
    if max_slide = 0
    then blocks
    else (
      match blocks with
      | [] -> []
      | (first_block : Matching_block.t) :: tl ->
        let score_elt_and_prev arr kind i =
          let i0 = i - 1 in
          let i1 = i in
          if i0 < 0 || i1 >= Array.length arr then 100 else score kind arr.(i0) arr.(i1)
        in
        let score' arr ~left ~right =
          score_elt_and_prev arr `right right + score_elt_and_prev arr `left (left + 1)
        in
        let score ~prev_left ~prev_right ~next_left ~next_right =
          match prev_left + 1 = prev_right, next_left + 1 = next_right with
          | true, true -> 0
          | true, false -> score' next_scorable ~left:next_left ~right:next_right
          | false, true -> score' prev_scorable ~left:prev_left ~right:prev_right
          | false, false ->
            min
              (score' prev_scorable ~left:prev_left ~right:prev_right)
              (score' next_scorable ~left:next_left ~right:next_right)
        in
        let rec align_consecutive_blocks acc (left_block : Matching_block.t) right_blocks =
          let best_score = ref 0 in
          let offset_of_best_score = ref 0 in
          let score_initial
                (left_block : Matching_block.t)
                (right_block : Matching_block.t)
            =
            best_score
            := score
                 ~prev_left:(left_block.prev_start + left_block.length - 1)
                 ~prev_right:right_block.prev_start
                 ~next_left:(left_block.next_start + left_block.length - 1)
                 ~next_right:right_block.next_start
          in
          let rec try_to_slide_left
                    ~i
                    (left_block : Matching_block.t)
                    (right_block : Matching_block.t)
            =
            let offset_into_left = left_block.length - i in
            if offset_into_left < 0
            then ()
            else if i > max_slide
            then ()
            else (
              let prev_left = left_block.prev_start + offset_into_left - 1 in
              let prev_right = right_block.prev_start - i in
              let next_left = left_block.next_start + offset_into_left - 1 in
              let next_right = right_block.next_start - i in
              if Elt.compare next_elts.(next_left + 1) next_elts.(next_right) <> 0
              then ()
              else if Elt.compare prev_elts.(prev_left + 1) prev_elts.(prev_right) <> 0
              then ()
              else (
                let score = score ~prev_left ~prev_right ~next_left ~next_right in
                if score > !best_score
                then (
                  best_score := score;
                  offset_of_best_score := -i);
                try_to_slide_left ~i:(i + 1) left_block right_block))
          in
          let rec try_to_slide_right
                    ~i
                    (left_block : Matching_block.t)
                    (right_block : Matching_block.t)
            =
            let offset_into_left = left_block.length + i - 1 in
            if i > right_block.length
            then ()
            else if i > max_slide
            then ()
            else (
              let prev_left = left_block.prev_start + offset_into_left in
              let prev_right = right_block.prev_start + i in
              let next_left = left_block.next_start + offset_into_left in
              let next_right = right_block.next_start + i in
              if Elt.compare next_elts.(next_left) next_elts.(next_right - 1) <> 0
              then ()
              else if Elt.compare prev_elts.(prev_left) prev_elts.(prev_right - 1) <> 0
              then ()
              else (
                let score = score ~prev_left ~prev_right ~next_left ~next_right in
                if score > !best_score
                then (
                  best_score := score;
                  offset_of_best_score := i);
                try_to_slide_right ~i:(i + 1) left_block right_block))
          in
          match right_blocks with
          | [] -> List.rev (left_block :: acc)
          | right_block :: rest ->
            (match left_block.length with
             | 0 -> align_consecutive_blocks acc right_block rest
             | _ ->
               score_initial left_block right_block;
               try_to_slide_left ~i:1 left_block right_block;
               try_to_slide_right ~i:1 left_block right_block;
               (match !offset_of_best_score with
                | 0 -> align_consecutive_blocks (left_block :: acc) right_block rest
                | slide ->
                  let new_left = { left_block with length = left_block.length + slide } in
                  let new_right : Matching_block.t =
                    { prev_start = right_block.prev_start + slide
                    ; next_start = right_block.next_start + slide
                    ; length = right_block.length - slide
                    }
                  in
                  let acc = if new_left.length > 0 then new_left :: acc else acc in
                  align_consecutive_blocks acc new_right rest))
        in
        align_consecutive_blocks [] first_block tl)
  ;;

  let get_matching_blocks
        ~transform
        ?(big_enough = 1)
        ?(max_slide = 0)
        ?(score = fun _ _ _ -> 100)
        ~prev:prev_scorable
        ~next:next_scorable
        ()
    =
    let prev = Array.map prev_scorable ~f:transform in
    let next = Array.map next_scorable ~f:transform in
    let matches = collapse_sequences (matches prev next) in
    let matches = combine_equalities ~prev ~next ~matches in
    let last_match =
      { Matching_block.prev_start = Array.length prev
      ; next_start = Array.length next
      ; length = 0
      }
    in
    align_diffs
      ~prev_elts:prev
      ~prev_scorable
      ~next_elts:next
      ~next_scorable
      ~max_slide
      ~score
      (semantic_cleanup ~big_enough (List.append matches [ last_match ]))
  ;;

  let get_ranges_rev ~transform ~big_enough ?max_slide ?score ~prev ~next () =
    let rec aux (matching_blocks : Matching_block.t list) i j l : _ Range.t list =
      match matching_blocks with
      | current_block :: remaining_blocks ->
        let prev_index, next_index, size =
          current_block.prev_start, current_block.next_start, current_block.length
        in
        if prev_index < i || next_index < j
        then aux remaining_blocks i j l
        else (
          let range_opt : _ Range.t option =
            if i < prev_index && j < next_index
            then (
              let prev_range = prev <|> (i, prev_index) in
              let next_range = next <|> (j, next_index) in
              Some (Replace (prev_range, next_range, None)))
            else if i < prev_index
            then (
              let prev_range = prev <|> (i, prev_index) in
              Some (Prev (prev_range, None)))
            else if j < next_index
            then (
              let next_range = next <|> (j, next_index) in
              Some (Next (next_range, None)))
            else None
          in
          let l =
            match range_opt with
            | Some range -> range :: l
            | None -> l
          in
          let prev_stop, next_stop = prev_index + size, next_index + size in
          let l =
            if size = 0
            then l
            else (
              let prev_range = prev <|> (prev_index, prev_stop) in
              let next_range = next <|> (next_index, next_stop) in
              let range = Array.map2_exn prev_range next_range ~f:(fun x y -> x, y) in
              Same range :: l)
          in
          aux remaining_blocks prev_stop next_stop l)
      | [] -> List.rev l
    in
    let matching_blocks =
      get_matching_blocks ~transform ~big_enough ?max_slide ?score ~prev ~next ()
    in
    aux matching_blocks 0 0 []
  ;;

  let get_hunks ~transform ~context ?(big_enough = 1) ?max_slide ?score ~prev ~next () =
    let ranges = get_ranges_rev ~transform ~big_enough ?max_slide ?score ~prev ~next () in
    let a = prev in
    let b = next in
    if context < 0
    then (
      let singleton_hunk =
        create_hunk 0 (Array.length a) 0 (Array.length b) (List.rev ranges)
      in
      [ singleton_hunk ])
    else (
      let rec aux ranges_remaining curr_ranges alo ahi blo bhi acc_hunks =
        match (ranges_remaining : _ Range.t list) with
        | [] ->
          let new_hunk = create_hunk alo ahi blo bhi curr_ranges in
          let acc_hunks = new_hunk :: acc_hunks in
          List.rev acc_hunks
        | Same range :: [] ->
          let stop = min (Array.length range) context in
          let new_range = Range.Same (range <|> (0, stop)) in
          let curr_ranges = new_range :: curr_ranges in
          let ahi = ahi + stop in
          let bhi = bhi + stop in
          let new_hunk = create_hunk alo ahi blo bhi curr_ranges in
          let acc_hunks = new_hunk :: acc_hunks in
          List.rev acc_hunks
        | Same range :: rest ->
          let size = Array.length range in
          if size > context * 2
          then (
            let new_range = Range.Same (range <|> (0, context)) in
            let curr_ranges = new_range :: curr_ranges in
            let ahi = ahi + context in
            let bhi = bhi + context in
            let new_hunk = create_hunk alo ahi blo bhi curr_ranges in
            let acc_hunks = new_hunk :: acc_hunks in
            let alo = ahi + size - (2 * context) in
            let ahi = alo in
            let blo = bhi + size - (2 * context) in
            let bhi = blo in
            let rest = Range.Same (range <|> (size - context, size)) :: rest in
            aux rest [] alo ahi blo bhi acc_hunks)
          else (
            let curr_ranges = Range.Same range :: curr_ranges in
            let ahi = ahi + size in
            let bhi = bhi + size in
            aux rest curr_ranges alo ahi blo bhi acc_hunks)
        | range :: rest ->
          let curr_ranges = range :: curr_ranges in
          let ahi, bhi =
            match range with
            | Same _ -> assert false
            | Unified _ -> assert false
            | Prev (_, Some _) | Next (_, Some _) | Replace (_, _, Some _) -> assert false
            | Next (range, None) ->
              let stop = bhi + Array.length range in
              ahi, stop
            | Prev (range, None) ->
              let stop = ahi + Array.length range in
              stop, bhi
            | Replace (a_range, b_range, None) ->
              let prev_stop = ahi + Array.length a_range in
              let next_stop = bhi + Array.length b_range in
              prev_stop, next_stop
          in
          aux rest curr_ranges alo ahi blo bhi acc_hunks
      in
      let ranges, alo, ahi, blo, bhi =
        match ranges with
        | Same range :: rest ->
          let stop = Array.length range in
          let start = max 0 (stop - context) in
          let new_range = Range.Same (range <|> (start, stop)) in
          new_range :: rest, start, start, start, start
        | rest -> rest, 0, 0, 0, 0
      in
      aux ranges [] alo ahi blo bhi [])
  ;;

  let match_ratio a b =
    float (2 * List.length (matches a b)) /. float (Array.length a + Array.length b)
  ;;

  let collapse_multi_sequences matches =
    let collapsed = ref [] in
    let value_exn x = Option.value_exn x in
    if List.is_empty matches
    then []
    else (
      let start = Array.create ~len:(List.length (List.hd_exn matches)) None in
      let length = ref 0 in
      List.iter matches ~f:(fun il ->
        if
          Array.for_all start ~f:Option.is_some
          && List.for_all
               ~f:(fun x -> x)
               (List.mapi il ~f:(fun i x -> x = value_exn start.(i) + !length))
        then incr length
        else (
          if Array.for_all start ~f:Option.is_some
          then
            collapsed
            := (Array.to_list (Array.map start ~f:value_exn), !length) :: !collapsed;
          List.iteri il ~f:(fun i x -> start.(i) <- Some x);
          length := 1));
      if Array.for_all start ~f:Option.is_some && !length <> 0
      then
        collapsed := (Array.to_list (Array.map start ~f:value_exn), !length) :: !collapsed;
      List.rev !collapsed)
  ;;

  type 'a segment =
    | Same of 'a array
    | Different of 'a array array

  type 'a merged_array = 'a segment list

  let array_mapi2 ar1 ar2 ~f =
    Array.mapi ~f:(fun i (x, y) -> f i x y) (Array.zip_exn ar1 ar2)
  ;;

  let merge ar =
    if Array.length ar = 0
    then []
    else if Array.length ar = 1
    then [ Same ar.(0) ]
    else (
      let matches's = Array.map (ar <|> (1, Array.length ar)) ~f:(matches ar.(0)) in
      let len = Array.length ar in
      let hashtbl = Int.Table.create () ~size:0 in
      Array.iteri matches's ~f:(fun i matches ->
        List.iter matches ~f:(fun (a, b) ->
          match Hashtbl.find hashtbl a with
          | None -> Hashtbl.set hashtbl ~key:a ~data:[ i, b ]
          | Some l -> Hashtbl.set hashtbl ~key:a ~data:((i, b) :: l)));
      let list =
        List.sort
          ~compare:(List.compare Int.compare)
          (List.filter_map
             ~f:(fun (a, l) ->
               if List.length l = len - 1
               then Some (a :: List.map ~f:snd (List.sort l ~compare:compare_int_pair))
               else None)
             (Hashtbl.to_alist hashtbl))
      in
      let matching_blocks = collapse_multi_sequences list in
      let last_pos = Array.create ~len:(Array.length ar) 0 in
      let merged_array = ref [] in
      List.iter matching_blocks ~f:(fun (l, len) ->
        let ar' = Array.of_list l in
        if Array.compare Int.compare last_pos ar' <> 0
        then
          merged_array
          := Different (array_mapi2 last_pos ar' ~f:(fun i n m -> ar.(i) <|> (n, m)))
             :: !merged_array;
        merged_array := Same (ar.(0) <|> (ar'.(0), ar'.(0) + len)) :: !merged_array;
        Array.iteri last_pos ~f:(fun i _ -> last_pos.(i) <- ar'.(i) + len));
      let trailing_lines =
        Array.existsi last_pos ~f:(fun i last_pos -> Array.length ar.(i) > last_pos)
      in
      if trailing_lines
      then
        merged_array
        := Different
             (Array.mapi last_pos ~f:(fun i n -> ar.(i) <|> (n, Array.length ar.(i))))
           :: !merged_array;
      List.rev !merged_array)
  ;;
end

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"patience_diff.ml.before-ppx"
    ~line_number:1046
    ~start_pos:0
    ~end_pos:1590
    (fun () ->
       let module M = struct
         module P = Make (Int)

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<check [||] [||] ~expect:[]; check [|0|] [|0|][...]>>")
             ~tags:[]
             ~filename:"patience_diff.ml.before-ppx"
             ~line_number:1050
             ~start_pos:4
             ~end_pos:254
             (fun () ->
                (let check a b ~expect =
                   (fun ?(here = []) ?message ?equal ~expect got ->
                      let pos = "patience_diff.ml.before-ppx:1051:45" in
                      let sexpifier =
                        (fun x__019_ ->
                        sexp_of_list
                          (fun (arg0__015_, arg1__016_) ->
                             let res0__017_ = sexp_of_int arg0__015_
                             and res1__018_ = sexp_of_int arg1__016_ in
                             Sexplib0.Sexp.List [ res0__017_; res1__018_ ])
                          x__019_)
                        [@merlin.hide]
                      in
                      let comparator =
                        (fun (a__007_ : (int * int) list)
                          ((b__008_ : (int * int) list) [@merlin.hide]) ->
                        (compare_list
                           (fun a__009_ (b__010_ [@merlin.hide]) ->
                              ((let t__011_, t__012_ = a__009_ in
                                let t__013_, t__014_ = b__010_ in
                                match compare_int t__011_ t__013_ with
                                | 0 -> compare_int t__012_ t__014_
                                | n -> n)
                              [@merlin.hide]))
                           a__007_
                           b__008_ [@merlin.hide]))
                        [@merlin.hide]
                      in
                      Ppx_assert_lib.Runtime.test_result
                        ~pos
                        ~sexpifier
                        ~comparator
                        ~here
                        ?message
                        ?equal
                        ~expect
                        ~got)
                     (P.matches a b)
                     ~expect
                 in
                 check [||] [||] ~expect:[];
                 check [| 0 |] [| 0 |] ~expect:[ 0, 0 ];
                 check [| 0; 1; 1; 2 |] [| 3; 1; 4; 5 |] ~expect:[ 1, 1 ]);
                ())
         ;;

         let rec is_increasing a = function
           | [] -> true
           | hd :: tl -> Int.compare a hd <= 0 && is_increasing hd tl
         ;;

         let check_lis a =
           let b = Patience.longest_increasing_subsequence (Ordered_sequence.create a) in
           if
             is_increasing (-1) (List.map b ~f:fst)
             && is_increasing (-1) (List.map b ~f:snd)
           then ()
           else
             failwiths
               ~here:
                 { Ppx_here_lib.pos_fname = "patience_diff.ml.before-ppx"
                 ; pos_lnum = 1070
                 ; pos_cnum = 41339
                 ; pos_bol = 41323
                 }
               "invariant failure"
               (a, b)
               ((fun (arg0__028_, arg1__029_) ->
                  let res0__030_ =
                    sexp_of_list
                      (fun (arg0__020_, arg1__021_) ->
                         let res0__022_ = sexp_of_int arg0__020_
                         and res1__023_ = sexp_of_int arg1__021_ in
                         Sexplib0.Sexp.List [ res0__022_; res1__023_ ])
                      arg0__028_
                  and res1__031_ =
                    sexp_of_list
                      (fun (arg0__024_, arg1__025_) ->
                         let res0__026_ = sexp_of_int arg0__024_
                         and res1__027_ = sexp_of_int arg1__025_ in
                         Sexplib0.Sexp.List [ res0__026_; res1__027_ ])
                      arg1__029_
                  in
                  Sexplib0.Sexp.List [ res0__030_; res1__031_ ]) [@merlin.hide])
         ;;

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<check_lis [(2, 0); (5, 1); (6, 2); (3, 3); (0[...]>>")
             ~tags:[]
             ~filename:"patience_diff.ml.before-ppx"
             ~line_number:1076
             ~start_pos:4
             ~end_pos:76
             (fun () ->
                check_lis [ 2, 0; 5, 1; 6, 2; 3, 3; 0, 4; 4, 5; 1, 6 ];
                ())
         ;;

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<check_lis [(0, 0); (2, 0); (5, 1); (6, 2); (3[...]>>")
             ~tags:[]
             ~filename:"patience_diff.ml.before-ppx"
             ~line_number:1077
             ~start_pos:4
             ~end_pos:82
             (fun () ->
                check_lis [ 0, 0; 2, 0; 5, 1; 6, 2; 3, 3; 0, 4; 4, 5; 1, 6 ];
                ())
         ;;

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<check_lis [(5, 1); (6, 2); (3, 3); (0, 4); (4[...]>>")
             ~tags:[]
             ~filename:"patience_diff.ml.before-ppx"
             ~line_number:1078
             ~start_pos:4
             ~end_pos:70
             (fun () ->
                check_lis [ 5, 1; 6, 2; 3, 3; 0, 4; 4, 5; 1, 6 ];
                ())
         ;;

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "<<check [|0;1;2;3;4;5;6|] [|2;5;6;3;0;4;1|]>>")
             ~tags:[]
             ~filename:"patience_diff.ml.before-ppx"
             ~line_number:1080
             ~start_pos:4
             ~end_pos:470
             (fun () ->
                (let check a b =
                   let matches = P.matches a b in
                   if
                     is_increasing (-1) (List.map matches ~f:fst)
                     && is_increasing (-1) (List.map matches ~f:snd)
                   then ()
                   else
                     failwiths
                       ~here:
                         { Ppx_here_lib.pos_fname = "patience_diff.ml.before-ppx"
                         ; pos_lnum = 1088
                         ; pos_cnum = 41957
                         ; pos_bol = 41939
                         }
                       "invariant failure"
                       (a, b, matches)
                       ((fun (arg0__036_, arg1__037_, arg2__038_) ->
                          let res0__039_ = sexp_of_array sexp_of_int arg0__036_
                          and res1__040_ = sexp_of_array sexp_of_int arg1__037_
                          and res2__041_ =
                            sexp_of_list
                              (fun (arg0__032_, arg1__033_) ->
                                 let res0__034_ = sexp_of_int arg0__032_
                                 and res1__035_ = sexp_of_int arg1__033_ in
                                 Sexplib0.Sexp.List [ res0__034_; res1__035_ ])
                              arg2__038_
                          in
                          Sexplib0.Sexp.List [ res0__039_; res1__040_; res2__041_ ])
                          [@merlin.hide])
                 in
                 check [| 0; 1; 2; 3; 4; 5; 6 |] [| 2; 5; 6; 3; 0; 4; 1 |]);
                ())
         ;;
       end
       in
       ())
;;

module String = Make (String)

module Stable = struct
  module Matching_block = Matching_block.Stable
  module Range = Range.Stable
  module Hunk = Hunk.Stable
  module Hunks = Hunks.Stable
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
