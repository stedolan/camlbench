let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"nano_mutex.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "nano_mutex.ml.before-ppx"
;;

open! Core
open! Import

let ok_exn = Or_error.ok_exn

module Blocker : sig
  type t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : unit -> t
  val critical_section : t -> f:(unit -> 'a) -> 'a
  val wait : t -> unit
  val signal : t -> unit
  val save_unused : t -> unit
end = struct
  module Condition = Condition
  module Mutex = Error_checking_mutex

  type t =
    { mutex : (Mutex.t[@sexp.opaque])
    ; condition : (Condition.t[@sexp.opaque])
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun { mutex = mutex__002_; condition = condition__004_ } ->
         let bnds__001_ = ([] : _ Stdlib.List.t) in
         let bnds__001_ =
           let arg__005_ = Sexplib0.Sexp_conv.sexp_of_opaque condition__004_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "condition"; arg__005_ ] :: bnds__001_
            : _ Stdlib.List.t)
         in
         let bnds__001_ =
           let arg__003_ = Sexplib0.Sexp_conv.sexp_of_opaque mutex__002_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mutex"; arg__003_ ] :: bnds__001_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__001_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let unused : t Thread_safe_queue.t = Thread_safe_queue.create ()
  let save_unused t = Thread_safe_queue.enqueue unused t

  let create () =
    if Thread_safe_queue.length unused > 0
    then Thread_safe_queue.dequeue_exn unused
    else { mutex = Mutex.create (); condition = Condition.create () }
  ;;

  let critical_section t ~f = Mutex.critical_section t.mutex ~f
  let wait t = Condition.wait t.condition t.mutex
  let signal t = Condition.signal t.condition
end

module Thread_id_option : sig
  type t [@@deriving equal, sexp_of] [@@immediate]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Equal.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val none : t
  val some : int -> t
  val is_none : t -> bool
  val is_some : t -> bool
end = struct
  type t = int [@@deriving equal, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let equal =
      (fun a__006_ b__007_ -> equal_int a__006_ b__007_ : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let none = -1
  let is_none t = t = none [@@inline always]
  let is_some t = t <> none [@@inline always]
  let some int = int [@@inline always]

  let sexp_of_t t =
    if t = none
    then Ppx_sexp_conv_lib.Conv.sexp_of_string "None"
    else (sexp_of_t [@merlin.hide]) t
  ;;
end

type t =
  { mutable id_of_thread_holding_lock : Thread_id_option.t
  ; mutable num_using_blocker : int
  ; mutable blocker : Blocker.t Uopt.t
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : t) -> ()

  let sexp_of_t =
    (fun { id_of_thread_holding_lock = id_of_thread_holding_lock__009_
         ; num_using_blocker = num_using_blocker__011_
         ; blocker = blocker__013_
         } ->
       let bnds__008_ = ([] : _ Stdlib.List.t) in
       let bnds__008_ =
         let arg__014_ = Uopt.sexp_of_t Blocker.sexp_of_t blocker__013_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "blocker"; arg__014_ ] :: bnds__008_
          : _ Stdlib.List.t)
       in
       let bnds__008_ =
         let arg__012_ = sexp_of_int num_using_blocker__011_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "num_using_blocker"; arg__012_ ]
          :: bnds__008_
          : _ Stdlib.List.t)
       in
       let bnds__008_ =
         let arg__010_ = Thread_id_option.sexp_of_t id_of_thread_holding_lock__009_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "id_of_thread_holding_lock"; arg__010_ ]
          :: bnds__008_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__008_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let invariant t =
  try
    assert (t.num_using_blocker >= 0);
    if t.num_using_blocker = 0 then assert (Uopt.is_none t.blocker)
  with
  | exn ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "nano_mutex.ml.before-ppx"
        ; pos_lnum = 107
        ; pos_cnum = 4377
        ; pos_bol = 4350
        }
      "invariant failed"
      (exn, t)
      ((fun (arg0__015_, arg1__016_) ->
         let res0__017_ = sexp_of_exn arg0__015_
         and res1__018_ = sexp_of_t arg1__016_ in
         Sexplib0.Sexp.List [ res0__017_; res1__018_ ]) [@merlin.hide])
;;

let equal (t : t) t' = phys_equal t t'

let create () =
  { id_of_thread_holding_lock = Thread_id_option.none
  ; num_using_blocker = 0
  ; blocker = Uopt.none
  }
;;

let is_locked t = Thread_id_option.is_some t.id_of_thread_holding_lock
let current_thread_id () = Thread.id (Thread.self ())

let current_thread_has_lock t =
  Thread_id_option.equal
    t.id_of_thread_holding_lock
    (Thread_id_option.some (current_thread_id ()))
;;

let error_recursive_lock t =
  Error
    (Error.create
       "attempt to lock mutex by thread already holding it"
       (current_thread_id (), t)
       ((fun (arg0__019_, arg1__020_) ->
          let res0__021_ = sexp_of_int arg0__019_
          and res1__022_ = sexp_of_t arg1__020_ in
          Sexplib0.Sexp.List [ res0__021_; res1__022_ ]) [@merlin.hide]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let try_lock t =
  let current_thread_id = Thread_id_option.some (current_thread_id ()) in
  if Thread_id_option.is_none t.id_of_thread_holding_lock
  then (
    t.id_of_thread_holding_lock <- current_thread_id;
    Ok `Acquired)
  else if Thread_id_option.equal current_thread_id t.id_of_thread_holding_lock
  then error_recursive_lock t
  else Ok `Not_acquired
;;

let try_lock_exn t = ok_exn (try_lock t)

let with_blocker0 t ~new_blocker =
  if Uopt.is_some t.blocker
  then Uopt.unsafe_value t.blocker
  else (
    t.blocker <- Uopt.some new_blocker;
    new_blocker)
[@@inline never] [@@specialise never] [@@local never]
;;

let with_blocker t f =
  t.num_using_blocker <- t.num_using_blocker + 1;
  let blocker =
    let __ppx_optional_e_0 = t.blocker in
    if false
    then (
      (match
         if Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
         then None
         else Some (Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
       with
       | Some blocker -> blocker
       | None ->
         let new_blocker = Blocker.create () in
         let blocker = with_blocker0 t ~new_blocker in
         if not (phys_equal blocker new_blocker) then Blocker.save_unused new_blocker;
         blocker)
      [@merlin.focus])
    else (
      (match Uopt.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
       | (false [@merlin.hide]) ->
         let blocker : _ =
           Uopt.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
         in
         blocker
       | (true [@merlin.hide]) ->
         let new_blocker = Blocker.create () in
         let blocker = with_blocker0 t ~new_blocker in
         if not (phys_equal blocker new_blocker) then Blocker.save_unused new_blocker;
         blocker)
      [@merlin.hide] [@ocaml.warning "-a"])
  in
  (protect
     ~f:(fun () -> (Blocker.critical_section blocker ~f:(fun () -> f blocker) [@nontail]))
     ~finally:(fun () ->
       t.num_using_blocker <- t.num_using_blocker - 1;
       if t.num_using_blocker = 0
       then (
         t.blocker <- Uopt.none;
         Blocker.save_unused blocker)) [@nontail])
;;

let rec lock t =
  let current_thread_id = Thread_id_option.some (current_thread_id ()) in
  if Thread_id_option.is_none t.id_of_thread_holding_lock
  then (
    t.id_of_thread_holding_lock <- current_thread_id;
    Ok ())
  else if Thread_id_option.equal current_thread_id t.id_of_thread_holding_lock
  then error_recursive_lock t
  else (
    with_blocker t (fun blocker -> if is_locked t then Blocker.wait blocker);
    lock t)
;;

let lock_exn t = ok_exn (lock t)

type message =
  { current_thread_id : int
  ; mutex : t
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : message) -> ()

  let sexp_of_message =
    (fun { current_thread_id = current_thread_id__024_; mutex = mutex__026_ } ->
       let bnds__023_ = ([] : _ Stdlib.List.t) in
       let bnds__023_ =
         let arg__027_ = sexp_of_t mutex__026_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mutex"; arg__027_ ] :: bnds__023_
          : _ Stdlib.List.t)
       in
       let bnds__023_ =
         let arg__025_ = sexp_of_int current_thread_id__024_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "current_thread_id"; arg__025_ ]
          :: bnds__023_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__023_
     : message -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_message
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let error_attempt_to_unlock_mutex_held_by_another_thread t =
  Error
    (Error.create
       "attempt to unlock mutex held by another thread"
       { current_thread_id = current_thread_id (); mutex = t }
       (sexp_of_message [@merlin.hide]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let error_attempt_to_unlock_an_unlocked_mutex t =
  Error
    (Error.create
       "attempt to unlock an unlocked mutex"
       { current_thread_id = current_thread_id (); mutex = t }
       (sexp_of_message [@merlin.hide]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let unlock t =
  let current_thread_id = current_thread_id () in
  if Thread_id_option.is_some t.id_of_thread_holding_lock
  then
    if
      Thread_id_option.equal
        t.id_of_thread_holding_lock
        (Thread_id_option.some current_thread_id)
    then (
      t.id_of_thread_holding_lock <- Thread_id_option.none;
      if Uopt.is_some t.blocker then with_blocker t Blocker.signal;
      Ok ())
    else error_attempt_to_unlock_mutex_held_by_another_thread t
  else error_attempt_to_unlock_an_unlocked_mutex t
;;

let unlock_exn t = ok_exn (unlock t)

let critical_section t ~f =
  lock_exn t;
  protect ~f ~finally:(fun () -> unlock_exn t)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
