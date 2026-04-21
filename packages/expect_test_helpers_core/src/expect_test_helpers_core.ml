let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"expect_test_helpers_core.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "expect_test_helpers_core.ml.before-ppx"
;;

open! Core
include Expect_test_helpers_base
include Expect_test_helpers_core_intf

module Allocation_limit = struct
  include Allocation_limit

  let is_ok t ~major_words_allocated ~minor_words_allocated =
    match t with
    | Major_words n -> major_words_allocated <= n
    | Minor_words n -> major_words_allocated = 0 && minor_words_allocated <= n
  ;;

  let show_major_words = function
    | Major_words _ -> true
    | Minor_words _ -> false
  ;;
end

module type Int63able = sig
  type t

  val to_int63 : t -> Int63.t
  val of_int63_exn : Int63.t -> t
end

let print_and_check_stable_internal
      (type a)
      ?cr
      ?hide_positions
      ?max_binable_length
      here
      ((module M) : (module Stable_without_comparator with type t = a))
      (int63able : (module Int63able with type t = a) option)
      list
  =
  let module M = struct
    include M

    let equal (_x__001_ : t) _x__002_ =
      (match
         (fun (a__003_ : t) ((b__004_ : t) [@merlin.hide]) ->
            (compare a__003_ b__004_ [@merlin.hide]))
           _x__001_
           _x__002_
       with
       | 0 -> true
       | _ -> false)
      [@merlin.hide]
    ;;
  end
  in
  print_s
    ?hide_positions
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Sexp.Atom "bin_shape_digest"
         ; (sexp_of_string [@merlin.hide])
             (Bin_prot.Shape.eval_to_digest_string M.bin_shape_t)
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]));
  let sexp_m =
    ((module struct
       type t = M.t
       type repr = Sexp.t [@@deriving sexp_of]

       include struct
         let _ = fun (_ : repr) -> ()
         let sexp_of_repr = (Sexp.sexp_of_t : repr -> Sexplib0.Sexp.t)
         let _ = sexp_of_repr
       end [@@ocaml.doc "@inline"] [@@merlin.hide]

       let to_repr = M.sexp_of_t
       let of_repr = M.t_of_sexp
       let repr_name = "sexp"
     end)
     : (module With_round_trip with type t = a))
  in
  let bin_io_m =
    ((module struct
       type t = M.t
       type repr = string [@@deriving sexp_of]

       include struct
         let _ = fun (_ : repr) -> ()
         let sexp_of_repr = (sexp_of_string : repr -> Sexplib0.Sexp.t)
         let _ = sexp_of_repr
       end [@@ocaml.doc "@inline"] [@@merlin.hide]

       let to_repr = Binable.to_string (module M)
       let of_repr = Binable.of_string (module M)
       let repr_name = "bin-io"
     end)
     : (module With_round_trip with type t = a))
  in
  let int63able_m =
    Option.Let_syntax.Let_syntax.map int63able ~f:(fun (module I) ->
      ((module struct
         type t = M.t
         type repr = Int63.t [@@deriving sexp_of]

         include struct
           let _ = fun (_ : repr) -> ()
           let sexp_of_repr = (Int63.sexp_of_t : repr -> Sexplib0.Sexp.t)
           let _ = sexp_of_repr
         end [@@ocaml.doc "@inline"] [@@merlin.hide]

         let to_repr = I.to_int63
         let of_repr = I.of_int63_exn
         let repr_name = "int63"
       end)
       : (module With_round_trip with type t = a)))
  in
  print_and_check_round_trip
    ?cr
    ?hide_positions
    here
    (module M)
    (List.concat [ [ sexp_m; bin_io_m ]; Option.to_list int63able_m ])
    list;
  Option.iter max_binable_length ~f:(fun max_binable_length ->
    require_does_not_raise ?cr ?hide_positions here (fun () ->
      List.iter list ~f:(fun original ->
        let bin_io = Binable.to_string (module M) original in
        let bin_io_length = String.length bin_io in
        require
          ?cr
          ?hide_positions
          here
          (bin_io_length <= max_binable_length)
          ~if_false_then_print_s:
            (lazy
              (let ppx_sexp_message () =
                 Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                       "bin-io serialization exceeds max binable length"
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "original"
                       ; (M.sexp_of_t [@merlin.hide]) original
                       ]
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "bin_io"
                       ; (sexp_of_string [@merlin.hide]) bin_io
                       ]
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "bin_io_length"
                       ; (sexp_of_int [@merlin.hide]) bin_io_length
                       ]
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "max_binable_length"
                       ; (sexp_of_int [@merlin.hide]) max_binable_length
                       ]
                   ]
                   [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
               in
               (ppx_sexp_message () [@nontail]))))))
;;

let print_and_check_stable_type
      (type a)
      ?cr
      ?hide_positions
      ?max_binable_length
      here
      ((module M) : (module Stable_without_comparator with type t = a))
      list
  =
  print_and_check_stable_internal
    ?cr
    ?hide_positions
    ?max_binable_length
    here
    (module M)
    None
    list
;;

let print_and_check_stable_int63able_type
      (type a)
      ?cr
      ?hide_positions
      ?max_binable_length
      here
      ((module M) : (module Stable_int63able with type t = a))
      list
  =
  print_and_check_stable_internal
    ?cr
    ?hide_positions
    ?max_binable_length
    here
    (module M)
    (Some (module M))
    list
;;

let require_allocation_does_not_exceed_private
      ?(cr = CR.CR)
      ?hide_positions
      ?(print_limit = 1_000)
      allocation_limit
      here
      f
  =
  let ( x
      , { Gc.For_testing.Allocation_report.major_words_allocated; minor_words_allocated }
      , allocs )
    =
    Gc.For_testing.measure_and_log_allocation f
  in
  require
    here
    ~cr
    ?hide_positions
    (Allocation_limit.is_ok
       allocation_limit
       ~major_words_allocated
       ~minor_words_allocated)
    ~if_false_then_print_s:
      (lazy
        (let minor_words_allocated, major_words_allocated =
           if CR.hide_unstable_output cr
           then None, None
           else if
             major_words_allocated > 0
             || Allocation_limit.show_major_words allocation_limit
           then Some minor_words_allocated, Some major_words_allocated
           else Some minor_words_allocated, None
         in
         if not (CR.hide_unstable_output cr)
         then (
           let allocs =
             if List.length allocs > print_limit
             then (
               Printf.printf "Cutting off list of allocations after %d\n" print_limit;
               List.take allocs print_limit)
             else allocs
           in
           List.iter allocs ~f:(fun { size_in_words; is_major; backtrace } ->
             Printf.printf
               "Allocation of %d %s words occurred at:\n%s\n"
               size_in_words
               (if is_major then "major" else "minor")
               backtrace));
         let ppx_sexp_message () =
           match
             Ppx_sexp_conv_lib.Conv.sexp_of_string "allocation exceeded limit"
             :: Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "allocation_limit"
                  ; (Allocation_limit.sexp_of_t [@merlin.hide]) allocation_limit
                  ]
             ::
             (match
                ( minor_words_allocated
                , match major_words_allocated, [] with
                  | None, tl -> tl
                  | Some v, tl ->
                    Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Sexp.Atom "major_words_allocated"
                      ; (sexp_of_int [@merlin.hide]) v
                      ]
                    :: tl )
              with
              | None, tl -> tl
              | Some v, tl ->
                Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Sexp.Atom "minor_words_allocated"
                  ; (sexp_of_int [@merlin.hide]) v
                  ]
                :: tl)
           with
           | h :: [] -> h
           | ([] | _ :: _ :: _) as res -> Ppx_sexp_conv_lib.Sexp.List res
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])));
  x
;;

let require_allocation_does_not_exceed
      ?print_limit
      ?hide_positions
      allocation_limit
      here
      f
  =
  require_allocation_does_not_exceed_private
    ?print_limit
    ?hide_positions
    allocation_limit
    here
    f
;;

let require_no_allocation ?print_limit ?hide_positions here f =
  require_allocation_does_not_exceed ?print_limit ?hide_positions (Minor_words 0) here f
;;

let print_and_check_comparable_sexps
      (type a)
      ?cr
      ?hide_positions
      here
      ((module M) : (module With_comparable with type t = a))
      list
  =
  let set = Set.of_list (module M) list in
  let set_sexp = (M.Set.sexp_of_t [@merlin.hide]) set in
  print_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Set"
         ; (Sexp.sexp_of_t [@merlin.hide]) set_sexp
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]));
  let sorted_list_sexp =
    ((fun x__006_ -> sexp_of_list M.sexp_of_t x__006_) [@merlin.hide])
      (List.sort list ~compare:M.compare)
  in
  require
    ?cr
    ?hide_positions
    here
    (Sexp.equal set_sexp sorted_list_sexp)
    ~if_false_then_print_s:
      (lazy
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "set sexp does not match sorted list sexp"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "set_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) set_sexp
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sorted_list_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) sorted_list_sexp
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])));
  let alist = List.mapi list ~f:(fun i x -> x, i) in
  let map = Map.of_alist_exn (module M) alist in
  let map_sexp =
    ((fun x__007_ -> M.Map.sexp_of_t sexp_of_int x__007_) [@merlin.hide]) map
  in
  print_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Map"
         ; (Sexp.sexp_of_t [@merlin.hide]) map_sexp
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]));
  let sorted_alist_sexp =
    ((fun x__012_ ->
       sexp_of_list
         (fun (arg0__008_, arg1__009_) ->
            let res0__010_ = M.sexp_of_t arg0__008_
            and res1__011_ = sexp_of_int arg1__009_ in
            Sexplib0.Sexp.List [ res0__010_; res1__011_ ])
         x__012_) [@merlin.hide])
      (List.sort alist ~compare:(fun (x, _) (y, _) -> M.compare x y))
  in
  require
    ?cr
    ?hide_positions
    here
    (Sexp.equal map_sexp sorted_alist_sexp)
    ~if_false_then_print_s:
      (lazy
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "map sexp does not match sorted alist sexp"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "map_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) map_sexp
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sorted_alist_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) sorted_alist_sexp
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])))
;;

let print_and_check_hashable_sexps
      (type a)
      ?cr
      ?hide_positions
      here
      ((module M) : (module With_hashable with type t = a))
      list
  =
  let hash_set = Hash_set.of_list (module M) list in
  let hash_set_sexp = (M.Hash_set.sexp_of_t [@merlin.hide]) hash_set in
  print_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Hash_set"
         ; (Sexp.sexp_of_t [@merlin.hide]) hash_set_sexp
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]));
  let sorted_list_sexp =
    ((fun x__013_ -> sexp_of_list M.sexp_of_t x__013_) [@merlin.hide])
      (List.sort list ~compare:M.compare)
  in
  require
    ?cr
    ?hide_positions
    here
    (Sexp.equal hash_set_sexp sorted_list_sexp)
    ~if_false_then_print_s:
      (lazy
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "hash_set sexp does not match sorted list sexp"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hash_set_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) hash_set_sexp
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sorted_list_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) sorted_list_sexp
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])));
  let alist = List.mapi list ~f:(fun i x -> x, i) in
  let table = Hashtbl.of_alist_exn (module M) alist in
  let table_sexp =
    ((fun x__014_ -> M.Table.sexp_of_t sexp_of_int x__014_) [@merlin.hide]) table
  in
  print_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Table"
         ; (Sexp.sexp_of_t [@merlin.hide]) table_sexp
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]));
  let sorted_alist_sexp =
    ((fun x__019_ ->
       sexp_of_list
         (fun (arg0__015_, arg1__016_) ->
            let res0__017_ = M.sexp_of_t arg0__015_
            and res1__018_ = sexp_of_int arg1__016_ in
            Sexplib0.Sexp.List [ res0__017_; res1__018_ ])
         x__019_) [@merlin.hide])
      (List.sort alist ~compare:(fun (x, _) (y, _) -> M.compare x y))
  in
  require
    ?cr
    ?hide_positions
    here
    (Sexp.equal table_sexp sorted_alist_sexp)
    ~if_false_then_print_s:
      (lazy
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "table sexp does not match sorted alist sexp"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "table_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) table_sexp
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sorted_alist_sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) sorted_alist_sexp
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])))
;;

let print_and_check_container_sexps (type a) ?cr ?hide_positions here m list =
  let ((module M) : (module With_containers with type t = a)) = m in
  print_and_check_comparable_sexps ?cr ?hide_positions here (module M) list;
  print_and_check_hashable_sexps ?cr ?hide_positions here (module M) list
;;

let remove_time_spans =
  let span_regex =
    lazy
      (let sign = Re.set "-+" in
       let part =
         let integer = Re.rep1 Re.digit in
         let decimal = Re.opt (Re.seq [ Re.char '.'; Re.rep1 Re.digit ]) in
         let suffixes = List.map ~f:Re.str [ "d"; "h"; "m"; "s"; "ms"; "us"; "ns" ] in
         Re.seq [ integer; decimal; Re.alt suffixes ]
       in
       Re.compile (Re.seq [ Re.opt sign; Re.word (Re.rep1 part) ]))
  in
  fun string -> Re.replace_string (force span_regex) ~by:"SPAN" string
;;

module Expect_test_helpers_core_private = struct
  let require_allocation_does_not_exceed = require_allocation_does_not_exceed_private
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
