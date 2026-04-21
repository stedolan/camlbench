let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"weak_hashtbl.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "weak_hashtbl.ml.before-ppx"
;;

open! Base

type ('a, 'b) t =
  { entry_by_key : ('a, 'b Weak_pointer.t) Hashtbl.t
  ; keys_with_unused_data : 'a Thread_safe_queue.t
  ; mutable thread_safe_run_when_unused_data : unit -> unit
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : ('a, 'b) t) -> ()

  let sexp_of_t
    :  'a 'b.
       ('a -> Sexplib0.Sexp.t)
    -> ('b -> Sexplib0.Sexp.t)
    -> ('a, 'b) t
    -> Sexplib0.Sexp.t
    =
    fun _of_a__001_
      _of_b__002_
      { entry_by_key = entry_by_key__004_
      ; keys_with_unused_data = keys_with_unused_data__006_
      ; thread_safe_run_when_unused_data = thread_safe_run_when_unused_data__008_
      } ->
    let bnds__003_ = ([] : _ Stdlib.List.t) in
    let bnds__003_ =
      let arg__009_ =
        let _ = thread_safe_run_when_unused_data__008_ in
        Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
      in
      (Sexplib0.Sexp.List
         [ Sexplib0.Sexp.Atom "thread_safe_run_when_unused_data"; arg__009_ ]
       :: bnds__003_
       : _ Stdlib.List.t)
    in
    let bnds__003_ =
      let arg__007_ =
        Thread_safe_queue.sexp_of_t _of_a__001_ keys_with_unused_data__006_
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keys_with_unused_data"; arg__007_ ]
       :: bnds__003_
       : _ Stdlib.List.t)
    in
    let bnds__003_ =
      let arg__005_ =
        Hashtbl.sexp_of_t
          _of_a__001_
          (Weak_pointer.sexp_of_t _of_b__002_)
          entry_by_key__004_
      in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "entry_by_key"; arg__005_ ] :: bnds__003_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__003_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Using_hashable = struct
  let create ?growth_allowed ?size hashable =
    { entry_by_key = Hashtbl.create ?growth_allowed ?size (Base.Hashable.to_key hashable)
    ; keys_with_unused_data = Thread_safe_queue.create ()
    ; thread_safe_run_when_unused_data = ignore
    }
  ;;
end

let create ?growth_allowed ?size m =
  Using_hashable.create ?growth_allowed ?size (Hashable.of_key m)
;;

let set_run_when_unused_data t ~thread_safe_f =
  t.thread_safe_run_when_unused_data <- thread_safe_f
;;

let remove t key = Hashtbl.remove t.entry_by_key key
let clear t = Hashtbl.clear t.entry_by_key

let reclaim_space_for_keys_with_unused_data t =
  while Thread_safe_queue.length t.keys_with_unused_data > 0 do
    let key = Thread_safe_queue.dequeue_exn t.keys_with_unused_data in
    match Hashtbl.find t.entry_by_key key with
    | None -> ()
    | Some entry -> if Weak_pointer.is_none entry then remove t key
  done
;;

let get_entry t key =
  Hashtbl.find_or_add t.entry_by_key key ~default:(fun () -> Weak_pointer.create ())
;;

let mem t key =
  match Hashtbl.find t.entry_by_key key with
  | None -> false
  | Some entry -> Weak_pointer.is_some entry
;;

let key_is_using_space t key = Hashtbl.mem t.entry_by_key key

let set_data t key entry (data : _ Heap_block.t) =
  Weak_pointer.set entry data;
  let cleanup () =
    Exn.handle_uncaught_and_exit (fun () ->
      Thread_safe_queue.enqueue t.keys_with_unused_data key;
      t.thread_safe_run_when_unused_data ())
  in
  try Stdlib.Gc.finalise_last cleanup data with
  | Invalid_argument _ -> ()
;;

let replace t ~key ~data = set_data t key (get_entry t key) data

let add_exn t ~key ~data =
  let entry = get_entry t key in
  if Weak_pointer.is_some entry
  then
    Error.raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Weak_hashtbl.add_exn of key in use"
           ; ((fun x__010_ ->
                sexp_of_t
                  (fun _ -> Sexplib0.Sexp.Atom "_")
                  (fun _ -> Sexplib0.Sexp.Atom "_")
                  x__010_) [@merlin.hide])
               t
           ; Ppx_sexp_conv_lib.Conv.sexp_of_string "weak_hashtbl.ml.before-ppx:74:71"
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  set_data t key entry data
;;

let find t key =
  match Hashtbl.find t.entry_by_key key with
  | None -> None
  | Some entry -> Weak_pointer.get entry
;;

let find_or_add t key ~default =
  let entry = get_entry t key in
  match Weak_pointer.get entry with
  | Some v -> v
  | None ->
    let data = default () in
    set_data t key entry data;
    data
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
