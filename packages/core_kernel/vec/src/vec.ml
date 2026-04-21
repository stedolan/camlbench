let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"vec.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "vec.ml.before-ppx"
;;

open! Core

module With_integer_index = struct
  module Kernel : sig
    type 'a t

    val length : _ t -> int
    val capacity : _ t -> int
    val create : ?initial_capacity:int -> unit -> _ t
    val unsafe_create_uninitialized : len:int -> 'a t
    val init : int -> f:(int -> 'a) -> 'a t
    val unsafe_get : 'a t -> int -> 'a
    val unsafe_set : 'a t -> int -> 'a -> unit

    val unsafe_blit
      :  src:'a t
      -> src_pos:int
      -> dst:'a t
      -> dst_pos:int
      -> len:int
      -> unit

    val invariant : 'a Invariant.t -> 'a t Invariant.t
    val max_index : _ t -> int
    val grow_capacity_once : _ t -> unit
    val grow_capacity_to_at_least : _ t -> capacity:int -> unit
    val unsafe_clear_pointer_at : _ t -> int -> unit
    val set_length : _ t -> int -> unit
    val copy : 'a t -> 'a t
    val sort : ?pos:int -> ?len:int -> 'a t -> compare:('a -> 'a -> int) -> unit

    module Expert : sig
      val unsafe_inner : 'a t -> Obj.t Uniform_array.t
    end

    module With_structure_details : sig
      type nonrec 'a t = 'a t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end = struct
    type 'a t =
      { mutable arr : Obj.t Uniform_array.t
      ; mutable length : int
      ; mutable capacity : int
            [@ocaml.doc
              " Invariant: [capacity = Uniform_array.length arr].\n\
              \          We maintain it here to eliminate an indirection when accessing \
               long arrays. "]
      }
    [@@deriving fields ~getters ~setters]

    include struct
      let _ = fun (_ : 'a t) -> ()
      let capacity _r__ = _r__.capacity
      let _ = capacity
      let set_capacity _r__ v__ = _r__.capacity <- v__
      let _ = set_capacity
      let length _r__ = _r__.length
      let _ = length
      let set_length _r__ v__ = _r__.length <- v__
      let _ = set_length
      let arr _r__ = _r__.arr
      let _ = arr
      let set_arr _r__ v__ = _r__.arr <- v__
      let _ = set_arr
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let length t = t.length

    let check_capacity capacity =
      if capacity < 0 then invalid_argf "Vec: negative capacity %d" capacity ()
    ;;

    let create ?(initial_capacity = 7) () =
      check_capacity initial_capacity;
      { arr = Uniform_array.unsafe_create_uninitialized ~len:initial_capacity
      ; length = 0
      ; capacity = initial_capacity
      }
    ;;

    let unsafe_create_uninitialized ~len:n =
      check_capacity n;
      { arr = Uniform_array.unsafe_create_uninitialized ~len:n; length = n; capacity = n }
    ;;

    let init n ~f =
      check_capacity n;
      { arr = Uniform_array.init n ~f:(fun i -> Obj.magic (f i))
      ; length = n
      ; capacity = n
      }
    ;;

    let copy t =
      { arr = Uniform_array.copy t.arr; length = t.length; capacity = t.capacity }
    ;;

    let unsafe_get (type a) (t : a t) i : a = Obj.magic (Uniform_array.unsafe_get t.arr i)
    [@@inline always]
    ;;

    let unsafe_set (type a) (t : a t) i (element : a) =
      Uniform_array.unsafe_set t.arr i (Obj.repr element)
    [@@inline always]
    ;;

    let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
      Uniform_array.unsafe_blit ~src:src.arr ~src_pos ~dst:dst.arr ~dst_pos ~len
    [@@inline always]
    ;;

    module With_structure_details = struct
      type nonrec 'a t = 'a t

      let sexp_of_t (type a) (sexp_of_a : a -> Sexp.t) (t : a t) =
        let { arr; length; capacity } = t in
        let elements =
          Uniform_array.init (Uniform_array.length arr) ~f:(fun i ->
            let element = Uniform_array.get arr i in
            if i < length
            then sexp_of_a (Obj.magic element)
            else (
              let imm : int = Obj.magic element in
              Sexp.Atom (sprintf "_%d" imm)))
        in
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "elements"
              ; ((fun x__001_ -> Uniform_array.sexp_of_t Sexp.sexp_of_t x__001_)
                   [@merlin.hide])
                  elements
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "length"
              ; (sexp_of_int [@merlin.hide]) length
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "capacity"
              ; (sexp_of_int [@merlin.hide]) capacity
              ]
          ]
      ;;
    end

    let invariant (type a) (a_inv : a Invariant.t) (t : a t) =
      Invariant.invariant
        { Ppx_here_lib.pos_fname = "vec.ml.before-ppx"
        ; pos_lnum = 116
        ; pos_cnum = 3760
        ; pos_bol = 3734
        }
        t
        ((fun x__002_ ->
           With_structure_details.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__002_)
           [@merlin.hide])
        (fun () ->
           let { capacity; length; arr } = t in
           if capacity <> Uniform_array.length t.arr
           then
             raise_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                        "capacity should equal Option_array length"
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "capacity"
                        ; (sexp_of_int [@merlin.hide]) capacity
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "Uniform_array.length t.arr"
                        ; (sexp_of_int [@merlin.hide]) (Uniform_array.length t.arr)
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
           if capacity < 0
           then
             raise_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Conv.sexp_of_string "negative capacity"
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "capacity"
                        ; (sexp_of_int [@merlin.hide]) capacity
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
           if length > capacity
           then
             raise_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                        "length shouldn't be more than capacity"
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "length"
                        ; (sexp_of_int [@merlin.hide]) length
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "capacity"
                        ; (sexp_of_int [@merlin.hide]) capacity
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail]));
           for pos = 0 to length - 1 do
             a_inv (Obj.magic (Uniform_array.get arr pos))
           done;
           for pos = length to capacity - 1 do
             assert (Obj.is_int (Uniform_array.get arr pos))
           done)
    ;;

    let max_index t = t.length - 1 [@@inline always]

    let grow_capacity_to_exactly t ~capacity =
      let arr = Uniform_array.unsafe_create_uninitialized ~len:capacity in
      for i = 0 to max_index t do
        Uniform_array.unsafe_set arr i (Uniform_array.unsafe_get t.arr i)
      done;
      t.arr <- arr;
      t.capacity <- capacity
    ;;

    let growth_factor = 2

    let grow_capacity_once t =
      grow_capacity_to_exactly t ~capacity:(Int.max 1 t.capacity * growth_factor)
    ;;

    let grow_capacity_to_at_least t ~capacity:target_capacity =
      assert (growth_factor = 2);
      if t.capacity < target_capacity
      then
        grow_capacity_to_exactly t ~capacity:(Int.ceil_pow2 (Int.max 1 target_capacity))
    ;;

    let unsafe_clear_pointer_at t pos = Uniform_array.unsafe_clear_if_pointer t.arr pos
    [@@inline always]
    ;;

    let sort (type a) ?pos ?len t ~(compare : a -> a -> int) =
      let compare : Obj.t -> Obj.t -> int = Obj.magic compare in
      let pos, len =
        Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
      in
      Uniform_array.sort ~pos ~len t.arr ~compare
    ;;

    module Expert = struct
      let unsafe_inner t = t.arr [@@inline always]
    end
  end

  include Kernel

  let is_sorted t ~compare =
    let i = ref (length t - 1) in
    let result = ref true in
    while !i > 0 && !result do
      let elt_i = unsafe_get t !i in
      let elt_i_minus_1 = unsafe_get t (!i - 1) in
      if compare elt_i_minus_1 elt_i > 0 then result := false;
      decr i
    done;
    !result
  ;;

  let next_free_index = length

  let raise__bad_index t i ~op =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "tried to access vec out of bounds"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "t"
               ; ((fun x__003_ ->
                    With_structure_details.sexp_of_t
                      (fun _ -> Sexplib0.Sexp.Atom "_")
                      x__003_) [@merlin.hide])
                   t
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "i"; (sexp_of_int [@merlin.hide]) i ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "op"; (sexp_of_string [@merlin.hide]) op ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let check_index t i ~op = if i < 0 || i >= length t then raise__bad_index t i ~op
  [@@inline always]
  ;;

  let get t i =
    check_index t i ~op:"get";
    unsafe_get t i
  ;;

  let maybe_get t i = if i < 0 || i >= length t then None else Some (unsafe_get t i)

  let maybe_get_local t i =
    if i < 0 || i >= length t then None else Some { Gel.g = unsafe_get t i }
  ;;

  let set t i element =
    check_index t i ~op:"set";
    unsafe_set t i element
  ;;

  let push_back__we_know_we_have_space t element =
    let length = length t in
    unsafe_set t length element;
    set_length t (length + 1)
  [@@inline always]
  ;;

  let push_back_index t element =
    let length = length t in
    if length = capacity t then grow_capacity_once t;
    push_back__we_know_we_have_space t element;
    length
  ;;

  let push_back t element =
    let (_ : int) = push_back_index t element in
    ()
  [@@inline always]
  ;;

  let remove_exn t i =
    if i < 0 || i >= length t then raise__bad_index t i ~op:"remove_exn";
    let new_length = length t - 1 in
    unsafe_blit ~src:t ~src_pos:(i + 1) ~dst:t ~dst_pos:i ~len:(length t - i - 1);
    set_length t new_length
  ;;

  let unsafe_peek_back_exn t = unsafe_get t (max_index t) [@@inline always]

  let peek_back_exn t =
    let length = length t in
    if length <= 0 then raise__bad_index t length ~op:"peek_back";
    unsafe_peek_back_exn t
  ;;

  let peek_back t = if length t <= 0 then None else Some (unsafe_peek_back_exn t)

  let pop_back_unit_exn t =
    let pos = max_index t in
    unsafe_clear_pointer_at t pos;
    set_length t pos
  [@@inline always]
  ;;

  let pop_back_exn t =
    let e = peek_back_exn t in
    pop_back_unit_exn t;
    e
  ;;

  let grow_to_unchecked t ~len ~default =
    grow_capacity_to_at_least t ~capacity:len;
    for i = length t to len - 1 do
      unsafe_set t i default
    done;
    set_length t len
  [@@inline never]
  ;;

  let grow_to t ~len ~default = if len > length t then grow_to_unchecked t ~len ~default
  [@@inline always]
  ;;

  let grow_to_include t idx ~default = grow_to t ~len:(idx + 1) ~default

  let grow_to' t ~len ~default =
    if len > length t
    then (
      grow_capacity_to_at_least t ~capacity:len;
      for i = length t to len - 1 do
        unsafe_set t i (default i)
      done;
      set_length t len)
  ;;

  let grow_to_include' t idx ~default = grow_to' t ~len:(idx + 1) ~default

  let shrink_to t ~len =
    if len < 0
    then raise__bad_index t len ~op:"shrink_to"
    else if len < length t
    then (
      for i = len to max_index t do
        unsafe_clear_pointer_at t i
      done;
      set_length t len)
  ;;

  let shrink_to_imm (t : 'a t) (_ : 'a Type_immediacy.Always.t) ~len =
    if len < 0
    then raise__bad_index t len ~op:"shrink_to_imm"
    else if len < length t
    then set_length t len
  ;;

  let iteri t ~f =
    for i = 0 to max_index t do
      f i (unsafe_get t i)
    done
  ;;

  let iter t ~f =
    for i = 0 to max_index t do
      f (unsafe_get t i)
    done
  ;;

  let to_list t =
    let result = ref [] in
    for i = max_index t downto 0 do
      result := unsafe_get t i :: !result
    done;
    !result
  ;;

  let to_local_list t =
    let rec aux t i acc = if i < 0 then acc else aux t (i - 1) (unsafe_get t i :: acc) in
    aux t (max_index t) []
  ;;

  let to_alist t =
    let result = ref [] in
    for i = max_index t downto 0 do
      result := (i, unsafe_get t i) :: !result
    done;
    !result
  ;;

  let to_sequence_mutable t =
    Sequence.unfold_step ~init:0 ~f:(fun i ->
      if i >= length t then Done else Yield { value = unsafe_get t i; state = i + 1 })
  ;;

  let to_sequence t = to_sequence_mutable (copy t)

  let of_list xs =
    let t = create ~initial_capacity:(List.length xs) () in
    List.iter xs ~f:(push_back t);
    t
  ;;

  let of_array arr = init (Array.length arr) ~f:(fun i -> arr.(i))

  let of_sequence seq =
    let t = create () in
    Sequence.iter seq ~f:(push_back t);
    t
  ;;

  let foldi t ~init ~f =
    let r = ref init in
    for i = 0 to max_index t do
      r := f i !r (unsafe_get t i)
    done;
    !r
  ;;

  let fold t ~init ~f =
    let r = ref init in
    for i = 0 to max_index t do
      r := f !r (unsafe_get t i)
    done;
    !r
  ;;

  let foldi_local_accum t ~init:acc ~f =
    let rec aux t i ~acc ~f =
      if i >= length t
      then acc
      else (
        let acc = f i acc (unsafe_get t i) in
        aux t (i + 1) ~acc ~f)
    in
    aux t 0 ~acc ~f
  ;;

  include Blit.Make1 (struct
      type nonrec 'a t = 'a t

      let create_like ~len _t = Kernel.unsafe_create_uninitialized ~len
      let length = length
      let unsafe_blit = unsafe_blit
    end)

  let take_while_len t ~f =
    let rec loop i =
      if i >= length t || not (f (get t i)) then i else (loop [@tailcall]) (i + 1)
    in
    (loop 0 [@nontail])
  [@@ocaml.doc " Returns the length of the longest prefix for which [f] is true. "]
  ;;

  let take_while t ~f =
    let len = take_while_len t ~f in
    sub t ~pos:0 ~len
  ;;

  module Inplace = struct
    let sub t ~pos ~len =
      Ordered_collection_common.check_pos_len_exn ~pos ~len ~total_length:(length t);
      if pos <> 0 then blit ~src:t ~src_pos:pos ~dst:t ~dst_pos:0 ~len;
      shrink_to t ~len
    ;;

    let take_while t ~f =
      let to_len = take_while_len t ~f in
      shrink_to t ~len:to_len
    ;;

    let filter t ~f =
      let dest = ref 0 in
      for i = 0 to max_index t do
        let x = unsafe_get t i in
        if f x
        then (
          if !dest < i then unsafe_set t !dest x;
          incr dest)
      done;
      let dest = !dest in
      shrink_to t ~len:dest
    ;;

    let map t ~f =
      for i = 0 to max_index t do
        unsafe_set t i (f (unsafe_get t i))
      done
    ;;

    let mapi t ~f =
      for i = 0 to max_index t do
        unsafe_set t i (f i (unsafe_get t i))
      done
    ;;
  end

  let rec forall2__same_length t1 t2 ~f i length =
    if i >= length
    then true
    else
      f (unsafe_get t1 i) (unsafe_get t2 i)
      && forall2__same_length t1 t2 ~f (i + 1) length
  ;;

  let equal equal t t' =
    if length t <> length t'
    then false
    else forall2__same_length t t' ~f:equal 0 (length t)
  ;;

  let clear t = if length t > 0 then shrink_to t ~len:0

  let clear_imm (t : 'a t) (proof : 'a Type_immediacy.Always.t) =
    if length t > 0 then shrink_to_imm t proof ~len:0
  ;;

  let sexp_of_t (type a) (sexp_of_a : a -> Sexp.t) t =
    let t = to_list t in
    ((fun x__004_ -> sexp_of_list sexp_of_a x__004_) [@merlin.hide]) t
  ;;

  let is_empty t = length t = 0

  let exists t ~f =
    let i = ref 0 in
    let n = length t in
    let result = ref false in
    while !i < n && not !result do
      if f (unsafe_get t !i) then result := true else incr i
    done;
    !result
  ;;

  let for_all t ~f =
    let i = ref 0 in
    let n = length t in
    let result = ref true in
    while !i < n && !result do
      if f (unsafe_get t !i) then incr i else result := false
    done;
    !result
  ;;

  let mem t a ~equal = (exists [@inlined hint]) t ~f:(equal a) [@nontail]
  let count t ~f = Container.count ~fold t ~f
  let sum module_ t ~f = Container.sum ~fold module_ t ~f

  let rec find' t ~f ~max_index i =
    if i > max_index
    then None
    else (
      let x = unsafe_get t i in
      if f x then Some x else find' t ~f ~max_index (i + 1))
  ;;

  let raise__not_found () =
    raise
      (Base.Not_found_s
         (let ppx_sexp_message () =
            Ppx_sexp_conv_lib.Conv.sexp_of_string "Vec.find_exn: not found"
              [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
          in
          (ppx_sexp_message () [@nontail])))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let rec find_exn' t ~f ~max_index i =
    if i > max_index
    then raise__not_found ()
    else (
      let x = unsafe_get t i in
      if f x then x else find_exn' t ~f ~max_index (i + 1))
  ;;

  let find t ~f = find' t ~f ~max_index:(max_index t) 0
  let find_exn t ~f = find_exn' t ~f ~max_index:(max_index t) 0

  let rec findi' t ~f ~max_index i =
    if i > max_index
    then None
    else (
      let x = unsafe_get t i in
      if f x then Some (i, x) else findi' t ~f ~max_index (i + 1))
  ;;

  let findi t ~f = findi' t ~f ~max_index:(max_index t) 0

  let find_and_remove t ~f =
    match findi t ~f with
    | None -> None
    | Some (i, found) ->
      remove_exn t i;
      Some found
  ;;

  let rec find_map' t ~f ~max_index i =
    if i > max_index
    then None
    else (
      match f (unsafe_get t i) with
      | None -> find_map' t ~f ~max_index (i + 1)
      | some -> some)
  ;;

  let find_map t ~f = find_map' t ~f ~max_index:(max_index t) 0

  let rec fold_result' t ~f ~acc ~max_index i =
    if i > max_index
    then Ok acc
    else (
      match f acc (unsafe_get t i) with
      | Ok acc -> fold_result' t ~f ~max_index (i + 1) ~acc
      | err -> err)
  ;;

  let fold_result t ~init ~f = fold_result' t ~f ~acc:init ~max_index:(max_index t) 0

  let rec fold_until' t ~f ~acc ~finish ~max_index i =
    if i > max_index
    then finish acc
    else (
      match (f acc (unsafe_get t i) : _ Continue_or_stop.t) with
      | Stop s -> s
      | Continue acc -> fold_until' t ~f ~max_index (i + 1) ~acc ~finish)
  ;;

  let fold_until t ~init ~f ~finish =
    fold_until' t ~f ~acc:init ~finish ~max_index:(max_index t) 0
  ;;

  let max_elt t ~compare =
    if is_empty t
    then None
    else (
      let max = ref (unsafe_get t 0) in
      for i = 1 to max_index t do
        let x = unsafe_get t i in
        let max' = !max in
        max := if compare max' x < 0 then x else max'
      done;
      Some !max)
  ;;

  let min_elt t ~compare =
    if is_empty t
    then None
    else (
      let min = ref (unsafe_get t 0) in
      for i = 1 to max_index t do
        let x = unsafe_get t i in
        let min' = !min in
        min := if compare min' x > 0 then x else min'
      done;
      Some !min)
  ;;

  let to_array t = Array.init (length t) ~f:(unsafe_get t)

  let t_of_sexp a_of_sexp t =
    of_list (((fun x__005_ -> list_of_sexp a_of_sexp x__005_) [@merlin.hide]) t)
  ;;

  let compare cmp t1 t2 =
    let len1 = length t1 in
    let len2 = length t2 in
    let min_len = Int.min len1 len2 in
    let result = ref 0 in
    let i = ref 0 in
    while !i < min_len && !result = 0 do
      result := cmp (unsafe_get t1 !i) (unsafe_get t2 !i);
      i := !i + 1
    done;
    if !result = 0 then Int.compare len1 len2 else !result
  ;;

  let unsafe_swap t i j =
    let e = unsafe_get t i in
    unsafe_set t i (unsafe_get t j);
    unsafe_set t j e
  ;;

  let swap t i j =
    check_index t i ~op:"swap";
    check_index t j ~op:"swap";
    unsafe_swap t i j
  ;;

  let swap_to_last_and_pop t i =
    check_index t i ~op:"swap_to_last_and_pop";
    unsafe_swap t i (max_index t);
    pop_back_exn t
  ;;

  module Stable = struct
    module V1 = struct
      type nonrec 'a t = 'a t [@@deriving compare, sexp]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let compare
          : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
          =
          fun _cmp__a a__006_ b__007_ ->
          compare
            (fun a__008_ (b__009_ [@merlin.hide]) ->
               (_cmp__a a__008_ b__009_ [@merlin.hide]))
            a__006_
            b__007_
        ;;

        let _ = compare

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun _of_a__010_ x__012_ -> t_of_sexp _of_a__010_ x__012_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__013_ x__014_ -> sexp_of_t _of_a__013_ x__014_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Bin_prot.Utils.Make_iterable_binable1 (struct
          type nonrec 'a t = 'a t
          type 'a el = 'a [@@deriving bin_io]

          include struct
            let _ = fun (_ : 'a el) -> ()

            let bin_shape_el =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "vec.ml.before-ppx:668:8")
                  [ ( Bin_prot.Shape.Tid.of_string "el"
                    , [ Bin_prot.Shape.Vid.of_string "a" ]
                    , Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "vec.ml.before-ppx:668:21")
                        (Bin_prot.Shape.Vid.of_string "a") )
                  ]
              in
              fun a ->
                (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ a ]
            ;;

            let _ = bin_shape_el

            let bin_size_el : 'a. 'a Bin_prot.Size.sizer -> 'a el Bin_prot.Size.sizer =
              fun _size_of_a -> _size_of_a
            ;;

            let _ = bin_size_el

            let bin_write_el : 'a. 'a Bin_prot.Write.writer -> 'a el Bin_prot.Write.writer
              =
              fun _write_a -> _write_a
            ;;

            let _ = bin_write_el

            let bin_writer_el =
              (fun bin_writer_a ->
                 { size = (fun v -> bin_size_el bin_writer_a.size v)
                 ; write = (fun v -> bin_write_el bin_writer_a.write v)
                 }
               : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_el

            let __bin_read_el__
              : 'a. 'a Bin_prot.Read.reader -> (int -> 'a el) Bin_prot.Read.reader
              =
              fun _of__a _buf ~pos_ref _vint ->
              Bin_prot.Common.raise_read_error
                (Bin_prot.Common.ReadError.Silly_type
                   "vec.ml.before-ppx.With_integer_index.Stable.V1.el")
                !pos_ref
            ;;

            let _ = __bin_read_el__

            let bin_read_el : 'a. 'a Bin_prot.Read.reader -> 'a el Bin_prot.Read.reader =
              fun _of__a -> _of__a
            ;;

            let _ = bin_read_el

            let bin_reader_el =
              (fun bin_reader_a ->
                 { read =
                     (fun buf ~pos_ref -> (bin_read_el bin_reader_a.read) buf ~pos_ref)
                 ; vtag_read =
                     (fun buf ~pos_ref vtag ->
                       (__bin_read_el__ bin_reader_a.read) buf ~pos_ref vtag)
                 }
               : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
            ;;

            let _ = bin_reader_el

            let bin_el =
              (fun bin_a ->
                 { writer = bin_writer_el bin_a.writer
                 ; reader = bin_reader_el bin_a.reader
                 ; shape = bin_shape_el bin_a.shape
                 }
               : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
            ;;

            let _ = bin_el
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          let caller_identity =
            Bin_prot.Shape.Uuid.of_string "2ec1d047-7cf8-49bc-991b-0badd17d8359"
          ;;

          let module_name = Some "Vec"
          let init ~len ~next = init len ~f:(fun _ -> next ())
          let iter = iter
          let length = length
        end)
    end
  end
end

include With_integer_index

module type S = Vec_intf.S

module Make (M : Intable.S) = struct
  include With_integer_index

  let unsafe_get t index = unsafe_get t (M.to_int_exn index) [@@inline always]
  let get t index = get t (M.to_int_exn index)
  let maybe_get t index = maybe_get t (M.to_int_exn index)
  let maybe_get_local t index = maybe_get_local t (M.to_int_exn index)
  let unsafe_set t index = unsafe_set t (M.to_int_exn index) [@@inline always]
  let set t index = set t (M.to_int_exn index)
  let next_free_index t = M.of_int_exn (next_free_index t)

  let foldi t ~init ~f =
    (foldi [@inlined hint]) t ~init ~f:((fun int accum x -> f (M.of_int_exn int) accum x)
      [@inline])
    [@nontail]
  ;;

  let foldi_local_accum t ~init ~f =
    (foldi_local_accum [@inlined hint]) t ~init ~f:((fun int accum x ->
      f (M.of_int_exn int) accum x) [@inline])
    [@nontail]
  ;;

  let iteri t ~f =
    (iteri [@inlined hint]) t ~f:((fun int x -> f (M.of_int_exn int) x) [@inline])
    [@nontail]
  ;;

  let push_back_index t element = M.of_int_exn (push_back_index t element)

  let to_alist t =
    let result = ref [] in
    for i = max_index t downto 0 do
      let m = M.of_int_exn i in
      result := (m, unsafe_get t m) :: !result
    done;
    !result
  ;;

  let grow_to_include t idx ~default = grow_to_include t (M.to_int_exn idx) ~default

  let grow_to' t ~len ~default =
    grow_to' t ~len ~default:((fun idx -> default (M.of_int_exn idx)) [@inline])
  ;;

  let grow_to_include' t idx ~default =
    grow_to_include' t (M.to_int_exn idx) ~default:((fun idx ->
      default (M.of_int_exn idx)) [@inline])
  ;;

  module Inplace = struct
    include Inplace

    let sub t ~pos ~len = sub t ~pos:(M.to_int_exn pos) ~len
    let mapi t ~f = mapi t ~f:((fun int x -> f (M.of_int_exn int) x) [@inline]) [@nontail]
  end

  let swap t index1 index2 = swap t (M.to_int_exn index1) (M.to_int_exn index2)
  let swap_to_last_and_pop t index = swap_to_last_and_pop t (M.to_int_exn index)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
