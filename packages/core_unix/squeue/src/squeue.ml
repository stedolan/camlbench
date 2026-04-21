let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"squeue.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "squeue.ml.before-ppx"
;;

open! Core
open! Import
module Mutex = Error_checking_mutex
module Queue = Linked_queue

type 'a t =
  { ev_q : 'a Queue.t
  ; maxsize : int
  ; mutex : (Mutex.t[@sexp.opaque])
  ; not_empty : (Condition.t[@sexp.opaque])
  ; not_full : (Condition.t[@sexp.opaque])
  }
[@@ocaml.doc " Synchronized queue type "] [@@deriving sexp_of]

include struct
  let _ = fun (_ : 'a t) -> ()

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__001_
      { ev_q = ev_q__003_
      ; maxsize = maxsize__005_
      ; mutex = mutex__007_
      ; not_empty = not_empty__009_
      ; not_full = not_full__011_
      } ->
    let bnds__002_ = ([] : _ Stdlib.List.t) in
    let bnds__002_ =
      let arg__012_ = Sexplib0.Sexp_conv.sexp_of_opaque not_full__011_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "not_full"; arg__012_ ] :: bnds__002_
       : _ Stdlib.List.t)
    in
    let bnds__002_ =
      let arg__010_ = Sexplib0.Sexp_conv.sexp_of_opaque not_empty__009_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "not_empty"; arg__010_ ] :: bnds__002_
       : _ Stdlib.List.t)
    in
    let bnds__002_ =
      let arg__008_ = Sexplib0.Sexp_conv.sexp_of_opaque mutex__007_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "mutex"; arg__008_ ] :: bnds__002_
       : _ Stdlib.List.t)
    in
    let bnds__002_ =
      let arg__006_ = sexp_of_int maxsize__005_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "maxsize"; arg__006_ ] :: bnds__002_
       : _ Stdlib.List.t)
    in
    let bnds__002_ =
      let arg__004_ = Queue.sexp_of_t _of_a__001_ ev_q__003_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ev_q"; arg__004_ ] :: bnds__002_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__002_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let create maxsize =
  let ev_q = Queue.create () in
  let mutex = Mutex.create () in
  let not_empty = Condition.create () in
  let not_full = Condition.create () in
  { ev_q; mutex; not_empty; not_full; maxsize }
;;

let finally t =
  let len = Queue.length t.ev_q in
  if len <> 0 then Condition.signal t.not_empty;
  if len < t.maxsize then Condition.signal t.not_full;
  Mutex.unlock t.mutex
;;

let wrap q run =
  Mutex.lock q.mutex;
  Exn.protectx ~f:run q ~finally
;;

let clear q =
  let run q = Queue.clear q.ev_q in
  wrap q run
;;

let wait_not_full q =
  while Queue.length q.ev_q >= q.maxsize do
    Condition.wait q.not_full q.mutex
  done
;;

let wait_not_empty q =
  while Queue.is_empty q.ev_q do
    Condition.wait q.not_empty q.mutex
  done
;;

let push q x =
  let run q =
    wait_not_full q;
    Queue.enqueue q.ev_q x
  in
  wrap q run
[@@ocaml.doc " Pushes an event on the queue if there's room "]
;;

let push_uncond q x =
  let run q = Queue.enqueue q.ev_q x in
  wrap q run
[@@ocaml.doc
  " Pushes an event on the queue, unconditionally, may grow the queue past maxsize "]
;;

let push_or_drop q x =
  let run q =
    if Queue.length q.ev_q < q.maxsize
    then (
      Queue.enqueue q.ev_q x;
      true)
    else false
  in
  wrap q run
[@@ocaml.doc
  " Pushes an event on the queue if the queue is less than maxsize, otherwise drops it.\n\
  \    Returns true if the push was successful "]
;;

let length q =
  let run q = Queue.length q.ev_q in
  wrap q run
[@@ocaml.doc " computes the length of the queue "]
;;

let pop q =
  let run q =
    wait_not_empty q;
    Queue.dequeue_exn q.ev_q
  in
  wrap q run
[@@ocaml.doc
  " Pops an event off of the queue, blocking until\n    something is available "]
;;

let lpop q =
  let run q =
    wait_not_empty q;
    let el = Queue.dequeue_exn q.ev_q in
    let len = Queue.length q.ev_q in
    el, len
  in
  wrap q run
[@@ocaml.doc
  " Pops an event off of the queue, blocking until something is available.\n\
  \    Returns pair of the element found and the length of remaining queue "]
;;

let transfer_queue_in_uncond q in_q =
  if not (Queue.is_empty in_q)
  then (
    let run q = Queue.transfer ~src:in_q ~dst:q.ev_q in
    wrap q run)
;;

let transfer_queue_in q in_q =
  if not (Queue.is_empty in_q)
  then (
    let run q =
      wait_not_full q;
      Queue.transfer ~src:in_q ~dst:q.ev_q
    in
    wrap q run)
;;

let transfer_queue_nowait_nolock sq q = Queue.transfer ~src:sq.ev_q ~dst:q

let transfer_queue_nowait sq q =
  if not (Queue.is_empty sq.ev_q)
  then (
    let run sq = transfer_queue_nowait_nolock sq q in
    wrap sq run)
;;

let transfer_queue sq q =
  let run sq =
    wait_not_empty sq;
    transfer_queue_nowait_nolock sq q
  in
  wrap sq run
;;

let wait_not_empty sq =
  let run sq = wait_not_empty sq in
  wrap sq run
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
