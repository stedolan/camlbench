let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bounded_int_table.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bounded_int_table.ml.before-ppx"
;;

open! Core

module Entry = struct
  type ('key, 'data) t =
    { mutable key : 'key
    ; mutable data : 'data
    ; mutable defined_entries_index : int
    }
  [@@deriving fields ~getters, sexp_of]

  include struct
    let _ = fun (_ : ('key, 'data) t) -> ()
    let defined_entries_index _r__ = _r__.defined_entries_index
    let _ = defined_entries_index
    let data _r__ = _r__.data
    let _ = data
    let key _r__ = _r__.key
    let _ = key

    let sexp_of_t
      :  'key 'data.
         ('key -> Sexplib0.Sexp.t)
      -> ('data -> Sexplib0.Sexp.t)
      -> ('key, 'data) t
      -> Sexplib0.Sexp.t
      =
      fun _of_key__001_
        _of_data__002_
        { key = key__004_
        ; data = data__006_
        ; defined_entries_index = defined_entries_index__008_
        } ->
      let bnds__003_ = ([] : _ Stdlib.List.t) in
      let bnds__003_ =
        let arg__009_ = sexp_of_int defined_entries_index__008_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "defined_entries_index"; arg__009_ ]
         :: bnds__003_
         : _ Stdlib.List.t)
      in
      let bnds__003_ =
        let arg__007_ = _of_data__002_ data__006_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "data"; arg__007_ ] :: bnds__003_
         : _ Stdlib.List.t)
      in
      let bnds__003_ =
        let arg__005_ = _of_key__001_ key__004_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "key"; arg__005_ ] :: bnds__003_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__003_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

type ('key, 'data) t_detailed =
  { num_keys : int
  ; sexp_of_key : ('key -> Sexp.t) option
  ; key_to_int : 'key -> int
  ; mutable length : int
  ; entries_by_key : ('key, 'data) Entry.t option array
  ; defined_entries : ('key, 'data) Entry.t option array
  }
[@@deriving fields ~getters, sexp_of]

include struct
  let _ = fun (_ : ('key, 'data) t_detailed) -> ()
  let defined_entries _r__ = _r__.defined_entries
  let _ = defined_entries
  let entries_by_key _r__ = _r__.entries_by_key
  let _ = entries_by_key
  let length _r__ = _r__.length
  let _ = length
  let key_to_int _r__ = _r__.key_to_int
  let _ = key_to_int
  let sexp_of_key _r__ = _r__.sexp_of_key
  let _ = sexp_of_key
  let num_keys _r__ = _r__.num_keys
  let _ = num_keys

  let sexp_of_t_detailed
    :  'key 'data.
       ('key -> Sexplib0.Sexp.t)
    -> ('data -> Sexplib0.Sexp.t)
    -> ('key, 'data) t_detailed
    -> Sexplib0.Sexp.t
    =
    fun _of_key__010_
      _of_data__011_
      { num_keys = num_keys__013_
      ; sexp_of_key = sexp_of_key__015_
      ; key_to_int = key_to_int__017_
      ; length = length__019_
      ; entries_by_key = entries_by_key__021_
      ; defined_entries = defined_entries__023_
      } ->
    let bnds__012_ = ([] : _ Stdlib.List.t) in
    let bnds__012_ =
      let arg__024_ =
        sexp_of_array
          (sexp_of_option (Entry.sexp_of_t _of_key__010_ _of_data__011_))
          defined_entries__023_
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "defined_entries"; arg__024_ ]
       :: bnds__012_
       : _ Stdlib.List.t)
    in
    let bnds__012_ =
      let arg__022_ =
        sexp_of_array
          (sexp_of_option (Entry.sexp_of_t _of_key__010_ _of_data__011_))
          entries_by_key__021_
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "entries_by_key"; arg__022_ ] :: bnds__012_
       : _ Stdlib.List.t)
    in
    let bnds__012_ =
      let arg__020_ = sexp_of_int length__019_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__020_ ] :: bnds__012_
       : _ Stdlib.List.t)
    in
    let bnds__012_ =
      let arg__018_ =
        let _ = key_to_int__017_ in
        Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "key_to_int"; arg__018_ ] :: bnds__012_
       : _ Stdlib.List.t)
    in
    let bnds__012_ =
      let arg__016_ =
        sexp_of_option
          (fun _ -> Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore)
          sexp_of_key__015_
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sexp_of_key"; arg__016_ ] :: bnds__012_
       : _ Stdlib.List.t)
    in
    let bnds__012_ =
      let arg__014_ = sexp_of_int num_keys__013_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "num_keys"; arg__014_ ] :: bnds__012_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__012_
  ;;

  let _ = sexp_of_t_detailed
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type ('a, 'b) t = ('a, 'b) t_detailed
type ('a, 'b) table = ('a, 'b) t

let sexp_of_key t =
  match t.sexp_of_key with
  | Some f -> f
  | None -> fun key -> Int.sexp_of_t (t.key_to_int key)
;;

let invariant invariant_key invariant_data t =
  try
    let num_keys = t.num_keys in
    assert (num_keys = Array.length t.entries_by_key);
    assert (num_keys = Array.length t.defined_entries);
    assert (0 <= t.length && t.length <= num_keys);
    Array.iteri t.entries_by_key ~f:(fun i -> function
      | None -> ()
      | Some entry ->
        invariant_key entry.Entry.key;
        invariant_data entry.data;
        assert (i = t.key_to_int entry.key);
        (match t.defined_entries.(entry.defined_entries_index) with
         | None -> assert false
         | Some entry' -> assert (phys_equal entry entry')));
    Array.iteri t.defined_entries ~f:(fun i entry_opt ->
      match i < t.length, entry_opt with
      | false, None -> ()
      | true, Some entry -> assert (i = entry.Entry.defined_entries_index)
      | _ -> assert false);
    let get_entries array =
      let a = Array.filter_opt array in
      Array.sort a ~compare:(fun entry entry' ->
        Int.compare (t.key_to_int entry.Entry.key) (t.key_to_int entry'.key));
      a
    in
    let entries = get_entries t.entries_by_key in
    let entries' = get_entries t.defined_entries in
    assert (t.length = Array.length entries);
    assert (Array.equal phys_equal entries entries')
  with
  | exn ->
    let sexp_of_key = sexp_of_key t in
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
        ; pos_lnum = 76
        ; pos_cnum = 2589
        ; pos_bol = 2577
        }
      "invariant failed"
      (exn, t)
      ((fun (arg0__025_, arg1__026_) ->
         let res0__027_ = sexp_of_exn arg0__025_
         and res1__028_ =
           sexp_of_t_detailed sexp_of_key (fun _ -> Sexplib0.Sexp.Atom "_") arg1__026_
         in
         Sexplib0.Sexp.List [ res0__027_; res1__028_ ]) [@merlin.hide])
;;

let debug = ref false
let check_invariant t = if !debug then invariant ignore ignore t
let is_empty t = length t = 0

let create ?sexp_of_key ~num_keys ~key_to_int () =
  if num_keys < 0
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
        ; pos_lnum = 88
        ; pos_cnum = 2895
        ; pos_bol = 2872
        }
      "num_keys must be nonnegative"
      num_keys
      (sexp_of_int [@merlin.hide]);
  let t =
    { num_keys
    ; sexp_of_key
    ; key_to_int
    ; length = 0
    ; entries_by_key = Array.create ~len:num_keys None
    ; defined_entries = Array.create ~len:num_keys None
    }
  in
  check_invariant t;
  t
;;

let create_like
      { num_keys
      ; sexp_of_key
      ; key_to_int
      ; length = _
      ; entries_by_key = _
      ; defined_entries = _
      }
  =
  create ~num_keys ?sexp_of_key ~key_to_int ()
;;

let fold t ~init ~f =
  let rec loop i ac =
    if i = t.length
    then ac
    else (
      match t.defined_entries.(i) with
      | None -> assert false
      | Some entry -> loop (i + 1) (f ~key:entry.key ~data:entry.data ac))
  in
  loop 0 init
;;

let iteri t ~f = fold t ~init:() ~f:(fun ~key ~data () -> f ~key ~data)
let iter t ~f = iteri t ~f:(fun ~key:_ ~data -> f data)
let iter_keys t ~f = iteri t ~f:(fun ~key ~data:_ -> f key)
let map_entries t ~f = fold t ~init:[] ~f:(fun ~key ~data ac -> f ~key ~data :: ac)
let to_alist t = map_entries t ~f:(fun ~key ~data -> key, data)

let clear t =
  for i = 0 to t.length - 1 do
    match t.defined_entries.(i) with
    | None -> assert false
    | Some entry ->
      t.defined_entries.(i) <- None;
      t.entries_by_key.(t.key_to_int entry.key) <- None
  done;
  t.length <- 0
;;

module Serialized = struct
  type ('key, 'data) t =
    { num_keys : int
    ; alist : ('key * 'data) list
    }
  [@@deriving bin_io, sexp]

  include struct
    let _ = fun (_ : ('key, 'data) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "bounded_int_table.ml.before-ppx:144:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "key"; Bin_prot.Shape.Vid.of_string "data" ]
            , Bin_prot.Shape.record
                [ "num_keys", bin_shape_int
                ; ( "alist"
                  , bin_shape_list
                      (Bin_prot.Shape.tuple
                         [ Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "bounded_int_table.ml.before-ppx:146:15")
                             (Bin_prot.Shape.Vid.of_string "key")
                         ; Bin_prot.Shape.var
                             (Bin_prot.Shape.Location.of_string
                                "bounded_int_table.ml.before-ppx:146:22")
                             (Bin_prot.Shape.Vid.of_string "data")
                         ]) )
                ] )
          ]
      in
      fun key data ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ key; data ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'key 'data.
         'key Bin_prot.Size.sizer
      -> 'data Bin_prot.Size.sizer
      -> ('key, 'data) t Bin_prot.Size.sizer
      =
      fun _size_of_key _size_of_data -> function
      | { num_keys = v1; alist = v2 } ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (bin_size_int v1) in
        Bin_prot.Common.( + )
          size
          (bin_size_list
             (function
               | v1, v2 ->
                 let size = 0 in
                 let size = Bin_prot.Common.( + ) size (_size_of_key v1) in
                 Bin_prot.Common.( + ) size (_size_of_data v2))
             v2)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'key 'data.
         'key Bin_prot.Write.writer
      -> 'data Bin_prot.Write.writer
      -> ('key, 'data) t Bin_prot.Write.writer
      =
      fun _write_key _write_data buf ~pos -> function
      | { num_keys = v1; alist = v2 } ->
        let pos = bin_write_int buf ~pos v1 in
        bin_write_list
          (fun buf ~pos -> function
             | v1, v2 ->
               let pos = _write_key buf ~pos v1 in
               _write_data buf ~pos v2)
          buf
          ~pos
          v2
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_key bin_writer_data ->
         { size = (fun v -> bin_size_t bin_writer_key.size bin_writer_data.size v)
         ; write = (fun v -> bin_write_t bin_writer_key.write bin_writer_data.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'key 'data.
         'key Bin_prot.Read.reader
      -> 'data Bin_prot.Read.reader
      -> (int -> ('key, 'data) t) Bin_prot.Read.reader
      =
      fun _of__key _of__data _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "bounded_int_table.ml.before-ppx.Serialized.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'key 'data.
         'key Bin_prot.Read.reader
      -> 'data Bin_prot.Read.reader
      -> ('key, 'data) t Bin_prot.Read.reader
      =
      fun _of__key _of__data buf ~pos_ref ->
      let v_num_keys = bin_read_int buf ~pos_ref in
      let v_alist =
        (bin_read_list (fun buf ~pos_ref ->
           let v1 = _of__key buf ~pos_ref in
           let v2 = _of__data buf ~pos_ref in
           v1, v2))
          buf
          ~pos_ref
      in
      { num_keys = v_num_keys; alist = v_alist }
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_key bin_reader_data ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_key.read bin_reader_data.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_key.read bin_reader_data.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_key bin_data ->
         { writer = bin_writer_t bin_key.writer bin_data.writer
         ; reader = bin_reader_t bin_key.reader bin_data.reader
         ; shape = bin_shape_t bin_key.shape bin_data.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let t_of_sexp
      :  'key 'data.
         (Sexplib0.Sexp.t -> 'key)
      -> (Sexplib0.Sexp.t -> 'data)
      -> Sexplib0.Sexp.t
      -> ('key, 'data) t
      =
      let error_source__032_ = "bounded_int_table.ml.before-ppx.Serialized.t" in
      fun _of_key__029_ _of_data__030_ x__038_ ->
        Sexplib0.Sexp_conv_record.record_of_sexp
          ~caller:error_source__032_
          ~fields:
            (Field
               { name = "num_keys"
               ; kind = Required
               ; conv = int_of_sexp
               ; rest =
                   Field
                     { name = "alist"
                     ; kind = Required
                     ; conv =
                         list_of_sexp (function
                           | Sexplib0.Sexp.List [ arg0__033_; arg1__034_ ] ->
                             let res0__035_ = _of_key__029_ arg0__033_
                             and res1__036_ = _of_data__030_ arg1__034_ in
                             res0__035_, res1__036_
                           | sexp__037_ ->
                             Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                               error_source__032_
                               2
                               sexp__037_)
                     ; rest = Empty
                     }
               })
          ~index_of_field:(function
            | "num_keys" -> 0
            | "alist" -> 1
            | _ -> -1)
          ~allow_extra_fields:false
          ~create:(fun (num_keys, (alist, ())) -> ({ num_keys; alist } : (_, _) t))
          x__038_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'key 'data.
         ('key -> Sexplib0.Sexp.t)
      -> ('data -> Sexplib0.Sexp.t)
      -> ('key, 'data) t
      -> Sexplib0.Sexp.t
      =
      fun _of_key__039_
        _of_data__040_
        { num_keys = num_keys__042_; alist = alist__044_ } ->
      let bnds__041_ = ([] : _ Stdlib.List.t) in
      let bnds__041_ =
        let arg__045_ =
          sexp_of_list
            (fun (arg0__046_, arg1__047_) ->
               let res0__048_ = _of_key__039_ arg0__046_
               and res1__049_ = _of_data__040_ arg1__047_ in
               Sexplib0.Sexp.List [ res0__048_; res1__049_ ])
            alist__044_
        in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alist"; arg__045_ ] :: bnds__041_
         : _ Stdlib.List.t)
      in
      let bnds__041_ =
        let arg__043_ = sexp_of_int num_keys__042_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "num_keys"; arg__043_ ] :: bnds__041_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__041_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let to_serialized t = { Serialized.num_keys = t.num_keys; alist = to_alist t }

let sexp_of_t sexp_of_key sexp_of_data t =
  Serialized.sexp_of_t sexp_of_key sexp_of_data (to_serialized t)
;;

let keys t = map_entries t ~f:(fun ~key ~data:_ -> key)
let data t = map_entries t ~f:(fun ~key:_ ~data -> data)

let entry_opt t key =
  let index = t.key_to_int key in
  try t.entries_by_key.(index) with
  | _ ->
    let sexp_of_key = sexp_of_key t in
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
        ; pos_lnum = 166
        ; pos_cnum = 4828
        ; pos_bol = 4816
        }
      "key's index out of range"
      (key, index, `Should_be_between_0_and (t.num_keys - 1))
      ((fun (arg0__051_, arg1__052_, arg2__053_) ->
         let res0__054_ = sexp_of_key arg0__051_
         and res1__055_ = sexp_of_int arg1__052_
         and res2__056_ =
           let (`Should_be_between_0_and v__050_) = arg2__053_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "Should_be_between_0_and"; sexp_of_int v__050_ ]
         in
         Sexplib0.Sexp.List [ res0__054_; res1__055_; res2__056_ ]) [@merlin.hide])
;;

let find t key =
  match entry_opt t key with
  | None -> None
  | Some e -> Some (Entry.data e)
;;

let find_exn t key =
  match entry_opt t key with
  | Some entry -> Entry.data entry
  | None ->
    let sexp_of_key = sexp_of_key t in
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
        ; pos_lnum = 184
        ; pos_cnum = 5264
        ; pos_bol = 5252
        }
      "Bounded_int_table.find_exn got unknown key"
      (key, t)
      ((fun (arg0__057_, arg1__058_) ->
         let res0__059_ = sexp_of_key arg0__057_
         and res1__060_ =
           sexp_of_t sexp_of_key (fun _ -> Sexplib0.Sexp.Atom "_") arg1__058_
         in
         Sexplib0.Sexp.List [ res0__059_; res1__060_ ]) [@merlin.hide])
;;

let mem t key = is_some (entry_opt t key)

let add_assuming_not_there t ~key ~data =
  let defined_entries_index = t.length in
  let entry_opt = Some { Entry.key; data; defined_entries_index } in
  t.entries_by_key.(t.key_to_int key) <- entry_opt;
  t.defined_entries.(defined_entries_index) <- entry_opt;
  t.length <- t.length + 1;
  check_invariant t
;;

let find_or_add t key ~default =
  match entry_opt t key with
  | Some e -> Entry.data e
  | None ->
    let data = default () in
    add_assuming_not_there t ~key ~data;
    data
;;

let set t ~key ~data =
  match entry_opt t key with
  | None -> add_assuming_not_there t ~key ~data
  | Some entry ->
    entry.key <- key;
    entry.data <- data
;;

let add t ~key ~data =
  match entry_opt t key with
  | Some entry -> `Duplicate entry.Entry.data
  | None ->
    add_assuming_not_there t ~key ~data;
    `Ok
;;

let add_exn t ~key ~data =
  match add t ~key ~data with
  | `Ok -> ()
  | `Duplicate _ ->
    let sexp_of_key = sexp_of_key t in
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
        ; pos_lnum = 233
        ; pos_cnum = 6477
        ; pos_bol = 6465
        }
      "Bounded_int_table.add_exn of key whose index is already present"
      (key, t.key_to_int key)
      ((fun (arg0__061_, arg1__062_) ->
         let res0__063_ = sexp_of_key arg0__061_
         and res1__064_ = sexp_of_int arg1__062_ in
         Sexplib0.Sexp.List [ res0__063_; res1__064_ ]) [@merlin.hide])
;;

let remove t key =
  (match entry_opt t key with
   | None -> ()
   | Some entry ->
     t.length <- t.length - 1;
     t.entries_by_key.(t.key_to_int key) <- None;
     let hole = entry.defined_entries_index in
     let last = t.length in
     if hole < last
     then (
       match t.defined_entries.(last) with
       | None ->
         let sexp_of_key = sexp_of_key t in
         failwiths
           ~here:
             { Ppx_here_lib.pos_fname = "bounded_int_table.ml.before-ppx"
             ; pos_lnum = 253
             ; pos_cnum = 7031
             ; pos_bol = 7014
             }
           "Bounded_int_table.remove bug"
           (key, last, t)
           ((fun (arg0__065_, arg1__066_, arg2__067_) ->
              let res0__068_ = sexp_of_key arg0__065_
              and res1__069_ = sexp_of_int arg1__066_
              and res2__070_ =
                sexp_of_t_detailed
                  sexp_of_key
                  (fun _ -> Sexplib0.Sexp.Atom "_")
                  arg2__067_
              in
              Sexplib0.Sexp.List [ res0__068_; res1__069_; res2__070_ ]) [@merlin.hide])
       | Some entry_to_put_in_hole as entry_to_put_in_hole_opt ->
         t.defined_entries.(hole) <- entry_to_put_in_hole_opt;
         entry_to_put_in_hole.defined_entries_index <- hole);
     t.defined_entries.(last) <- None);
  check_invariant t
;;

let existsi t ~f =
  with_return (fun r ->
    iteri t ~f:(fun ~key ~data -> if f ~key ~data then r.return true);
    false)
;;

let exists t ~f = existsi t ~f:(fun ~key:_ ~data -> f data)
let for_alli t ~f = not (existsi t ~f:(fun ~key ~data -> not (f ~key ~data)))
let for_all t ~f = for_alli t ~f:(fun ~key:_ ~data -> f data)

let equal key_equal data_equal t1 t2 =
  length t1 = length t2
  && for_alli t1 ~f:(fun ~key ~data ->
    match entry_opt t2 key with
    | None -> false
    | Some entry -> key_equal key entry.Entry.key && data_equal data entry.Entry.data)
;;

module With_key (Key : sig
    type t [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_int : t -> int
  end) =
struct
  type 'data t = (Key.t, 'data) table
  type 'data table = 'data t

  let create ~num_keys =
    create ~sexp_of_key:Key.sexp_of_t ~num_keys ~key_to_int:Key.to_int ()
  ;;

  let of_alist_exn alist =
    let max_key =
      List.fold alist ~init:(-1) ~f:(fun max (key, _) -> Int.max max (Key.to_int key))
    in
    let t = create ~num_keys:(max_key + 1) in
    List.iter alist ~f:(fun (key, data) -> add_exn t ~key ~data);
    t
  ;;

  let of_alist alist = Or_error.try_with (fun () -> of_alist_exn alist)
  let sexp_of_t sexp_of_data = sexp_of_t Key.sexp_of_t sexp_of_data

  let of_serialized { Serialized.num_keys; alist } =
    let t = create ~num_keys in
    List.iter alist ~f:(fun (key, data) -> add_exn t ~key ~data);
    t
  ;;

  let t_of_sexp data_of_sexp sexp =
    of_serialized (Serialized.t_of_sexp Key.t_of_sexp data_of_sexp sexp)
  ;;

  include
    Binable.Of_binable1_without_uuid [@alert "-legacy"]
      (struct
        type 'data t = (Key.t, 'data) Serialized.t [@@deriving bin_io]

        include struct
          let _ = fun (_ : 'data t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string
                   "bounded_int_table.ml.before-ppx:320:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , [ Bin_prot.Shape.Vid.of_string "data" ]
                  , (Serialized.bin_shape_t Key.bin_shape_t)
                      (Bin_prot.Shape.var
                         (Bin_prot.Shape.Location.of_string
                            "bounded_int_table.ml.before-ppx:320:31")
                         (Bin_prot.Shape.Vid.of_string "data")) )
                ]
            in
            fun data ->
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ data ]
          ;;

          let _ = bin_shape_t

          let bin_size_t : 'data. 'data Bin_prot.Size.sizer -> 'data t Bin_prot.Size.sizer
            =
            fun _size_of_data v -> Serialized.bin_size_t Key.bin_size_t _size_of_data v
          ;;

          let _ = bin_size_t

          let bin_write_t
            : 'data. 'data Bin_prot.Write.writer -> 'data t Bin_prot.Write.writer
            =
            fun _write_data buf ~pos v ->
            Serialized.bin_write_t Key.bin_write_t _write_data buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            (fun bin_writer_data ->
               { size = (fun v -> bin_size_t bin_writer_data.size v)
               ; write = (fun v -> bin_write_t bin_writer_data.write v)
               }
             : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__
            : 'data. 'data Bin_prot.Read.reader -> (int -> 'data t) Bin_prot.Read.reader
            =
            fun _of__data buf ~pos_ref vint ->
            (Serialized.__bin_read_t__ Key.bin_read_t _of__data) buf ~pos_ref vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t
            : 'data. 'data Bin_prot.Read.reader -> 'data t Bin_prot.Read.reader
            =
            fun _of__data buf ~pos_ref ->
            (Serialized.bin_read_t Key.bin_read_t _of__data) buf ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            (fun bin_reader_data ->
               { read =
                   (fun buf ~pos_ref -> (bin_read_t bin_reader_data.read) buf ~pos_ref)
               ; vtag_read =
                   (fun buf ~pos_ref vtag ->
                     (__bin_read_t__ bin_reader_data.read) buf ~pos_ref vtag)
               }
             : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            (fun bin_data ->
               { writer = bin_writer_t bin_data.writer
               ; reader = bin_reader_t bin_data.reader
               ; shape = bin_shape_t bin_data.shape
               }
             : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)
      (struct
        type 'data t = 'data table

        let to_binable = to_serialized
        let of_binable = of_serialized
      end)
end

let filter_mapi t ~f =
  let result = create_like t in
  iteri t ~f:(fun ~key ~data ->
    match f ~key ~data with
    | None -> ()
    | Some data -> add_exn result ~key ~data);
  result
;;

let ignore_key f ~key:_ ~data = f data
let ignore_data f ~key ~data:_ = f key
let filter_map t ~f = filter_mapi t ~f:(ignore_key f)

let filteri t ~f =
  filter_mapi t ~f:(fun ~key ~data -> if f ~key ~data then Some data else None)
;;

let filter t ~f = filteri t ~f:(ignore_key f)
let filter_keys t ~f = filteri t ~f:(ignore_data f)
let mapi t ~f = filter_mapi t ~f:(fun ~key ~data -> Some (f ~key ~data))
let map t ~f = mapi t ~f:(ignore_key f)
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
