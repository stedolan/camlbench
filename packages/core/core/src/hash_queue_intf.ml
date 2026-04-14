let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hash_queue_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hash_queue_intf.ml.before-ppx"
;;

open! Import

module type Key = Hashtbl.Key_plain
[@@ocaml.doc " The key is used for the hashtable of queue elements. "]

module type S1 = sig
  type 'key create_arg
  type 'key create_key

  type ('key, 'data) t
  [@@ocaml.doc " A hash-queue, where the values are of type ['data]. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('key -> Sexplib0.Sexp.t)
      -> ('data -> Sexplib0.Sexp.t)
      -> ('key, 'data) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Container.S1_phantom with type ('data, 'key) t := ('key, 'data) t

  [@@@ocaml.text " [invariant t] checks the invariants of the queue. "]

  val invariant : ('key, 'data) t -> unit

  val create
    :  ?growth_allowed:bool
    -> ?size:int
    -> 'key create_arg
    -> ('key create_key, 'data) t
  [@@ocaml.doc
    " [create ()] returns an empty queue.  The arguments [growth_allowed] and [size] are\n\
    \      referring to the underlying hashtable.\n\n\
    \      @param growth_allowed defaults to true\n\
    \      @param size initial size -- default to 16\n\
    \  "]

  val clear : ('key, 'data) t -> unit [@@ocaml.doc " Clears the queue. "]

  val copy : ('key, 'data) t -> ('key, 'data) t
  [@@ocaml.doc
    " Makes a fresh copy of the queue with identical contents to the original. "]

  [@@@ocaml.text " {2 Finding elements} "]

  val mem : ('key, 'data) t -> 'key -> bool
  [@@ocaml.doc " [mem q k] returns true iff there is some (k, v) in the queue. "]

  val lookup : ('key, 'data) t -> 'key -> 'data option
  [@@ocaml.doc
    " [lookup t k] returns the value of the key-value pair in the queue with\n\
    \      key k, if there is one. "]

  val lookup_exn : ('key, 'data) t -> 'key -> 'data

  [@@@ocaml.text
    " {2 Adding, removing, and replacing elements}\n\n\
    \      Note that even the non-[*_exn] versions can raise, but only if there is an \
     ongoing\n\
    \      iteration. "]

  val enqueue
    :  ('key, 'data) t
    -> [ `back | `front ]
    -> 'key
    -> 'data
    -> [ `Ok | `Key_already_present ]
  [@@ocaml.doc
    " [enqueue t back_or_front k v] adds the key-value pair (k, v) to the front or back of\n\
    \      the queue, returning [`Ok] if the pair was added, or [`Key_already_present] \
     if there\n\
    \      is already a (k, v') in the queue.\n\
    \  "]

  val enqueue_exn : ('key, 'data) t -> [ `back | `front ] -> 'key -> 'data -> unit
  [@@ocaml.doc " Like {!enqueue}, but it raises in the [`Key_already_present] case "]

  val enqueue_back : ('key, 'data) t -> 'key -> 'data -> [ `Ok | `Key_already_present ]
  [@@ocaml.doc
    " See {!enqueue}. [enqueue_back t k v] is the same as [enqueue t `back k v]  "]

  val enqueue_back_exn : ('key, 'data) t -> 'key -> 'data -> unit
  [@@ocaml.doc
    " See {!enqueue_exn}. [enqueue_back_exn t k v] is the same as [enqueue_exn t `back k \
     v] "]

  val enqueue_front : ('key, 'data) t -> 'key -> 'data -> [ `Ok | `Key_already_present ]
  [@@ocaml.doc
    " See {!enqueue}. [enqueue_front t k v] is the same as [enqueue t `front k v]  "]

  val enqueue_front_exn : ('key, 'data) t -> 'key -> 'data -> unit
  [@@ocaml.doc
    " See {!enqueue_exn}. [enqueue_front_exn t k v] is the same as [enqueue_exn t `front k\n\
    \      v] "]

  val lookup_and_move_to_back : ('key, 'data) t -> 'key -> 'data option
  [@@ocaml.doc
    " [lookup_and_move_to_back] finds the key-value pair (k, v) and moves it to the\n\
    \      back of the queue if it exists, otherwise returning [None].\n\n\
    \      The [_exn] versions of these functions raise if key-value pair does not exist.\n\
    \  "]

  val lookup_and_move_to_back_exn : ('key, 'data) t -> 'key -> 'data
  [@@ocaml.doc
    " Like {!lookup_and_move_to_back}, but raises instead of returning an option "]

  val lookup_and_move_to_front : ('key, 'data) t -> 'key -> 'data option
  [@@ocaml.doc
    " Like {!lookup_and_move_to_back}, but moves element to the front of the queue "]

  val lookup_and_move_to_front_exn : ('key, 'data) t -> 'key -> 'data
  [@@ocaml.doc
    " Like {!lookup_and_move_to_front}, but raises instead of returning an option "]

  val last : ('key, 'data) t -> 'data option
  [@@ocaml.doc " [last t] returns the last element of the queue, without removing it. "]

  val last_with_key : ('key, 'data) t -> ('key * 'data) option
  [@@ocaml.doc
    " [last_with_key t] returns the last element of the queue and its key, without\n\
    \      removing it. "]

  val first : ('key, 'data) t -> 'data option
  [@@ocaml.doc " [first t] returns the front element of the queue, without removing it. "]

  val first_with_key : ('key, 'data) t -> ('key * 'data) option
  [@@ocaml.doc
    " [first_with_key t] returns the front element of the queue and its key, without\n\
    \      removing it. "]

  val keys : ('key, 'data) t -> 'key list
  [@@ocaml.doc " [keys t] returns the keys in the order of the queue. "]

  val to_alist : ('key, 'data) t -> ('key * 'data) list
  [@@ocaml.doc
    " [to_alist t] returns the elements of the queue with their keys in the order of the\n\
    \      queue. "]

  val dequeue : ('key, 'data) t -> [ `back | `front ] -> 'data option
  [@@ocaml.doc
    " [dequeue t front_or_back] returns the front or back element of the queue. "]

  val dequeue_exn : ('key, 'data) t -> [ `back | `front ] -> 'data
  [@@ocaml.doc " Like {!dequeue}, but it raises if the queue is empty. "]

  val dequeue_back : ('key, 'data) t -> 'data option
  [@@ocaml.doc " [dequeue_back t] returns the back element of the queue. "]

  val dequeue_back_exn : ('key, 'data) t -> 'data
  [@@ocaml.doc " Like {!dequeue_back}, but it raises if the queue is empty. "]

  val dequeue_front : ('key, 'data) t -> 'data option
  [@@ocaml.doc " [dequeue_front t] returns the front element of the queue. "]

  val dequeue_front_exn : ('key, 'data) t -> 'data
  [@@ocaml.doc " Like {!dequeue_front}, but it raises if the queue is empty. "]

  val dequeue_with_key : ('key, 'data) t -> [ `back | `front ] -> ('key * 'data) option
  [@@ocaml.doc
    " [dequeue_with_key t] returns the front or back element of the queue and its key. "]

  val dequeue_with_key_exn : ('key, 'data) t -> [ `back | `front ] -> 'key * 'data
  [@@ocaml.doc " Like {!dequeue_with_key}, but it raises if the queue is empty. "]

  val dequeue_back_with_key : ('key, 'data) t -> ('key * 'data) option
  [@@ocaml.doc
    " [dequeue_back_with_key t] returns the back element of the queue and its key. "]

  val dequeue_back_with_key_exn : ('key, 'data) t -> 'key * 'data
  [@@ocaml.doc " Like {!dequeue_back_with_key}, but it raises if the queue is empty. "]

  val dequeue_front_with_key : ('key, 'data) t -> ('key * 'data) option
  [@@ocaml.doc
    " [dequeue_front_with_key t] returns the front element of the queue and its key. "]

  val dequeue_front_with_key_exn : ('key, 'data) t -> 'key * 'data
  [@@ocaml.doc " Like {!dequeue_front_with_key}, but it raises if the queue is empty. "]

  val dequeue_all : ('key, 'data) t -> f:('data -> unit) -> unit
  [@@ocaml.doc
    " [dequeue_all t ~f] dequeues every element of the queue and applies [f] to each one.\n\
    \      The dequeue order is from front to back. "]

  val remove : ('key, 'data) t -> 'key -> [ `Ok | `No_such_key ]
  [@@ocaml.doc " [remove q k] removes the key-value pair with key [k] from the queue. "]

  val remove_exn : ('key, 'data) t -> 'key -> unit

  val lookup_and_remove : ('key, 'data) t -> 'key -> 'data option
  [@@ocaml.doc " like {!remove}, but returns the removed element "]

  val replace : ('key, 'data) t -> 'key -> 'data -> [ `Ok | `No_such_key ]
  [@@ocaml.doc " [replace q k v] changes the value of key [k] in the queue to [v]. "]

  val replace_or_enqueue : ('key, 'data) t -> [ `back | `front ] -> 'key -> 'data -> unit
  [@@ocaml.doc
    " [replace_or_enqueue q back_or_front k v] changes the value of key [k] in the queue\n\
    \      to [v]. If the key [k] does not exist in the queue, it is added to the front \
     or back\n\
    \      with the value [v]. "]

  val replace_or_enqueue_front : ('key, 'data) t -> 'key -> 'data -> unit
  [@@ocaml.doc
    " See {!replace_or_enqueue}. [replace_or_enqueue_front t k v] is the same as\n\
    \      [replace_or_enqueue t `front k v] "]

  val replace_or_enqueue_back : ('key, 'data) t -> 'key -> 'data -> unit
  [@@ocaml.doc
    " See {!replace_or_enqueue}. [replace_or_enqueue_back t k v] is the same as\n\
    \      [replace_or_enqueue t `back k v] "]

  val replace_exn : ('key, 'data) t -> 'key -> 'data -> unit

  val drop : ?n:int -> ('key, 'data) t -> [ `back | `front ] -> unit
  [@@ocaml.doc
    " [drop ?n q back_or_front] drops [n] elements (default 1) from the back or front of\n\
    \      the queue. If the queue has fewer than [n] elements then it is cleared. "]

  val drop_front : ?n:int -> ('key, 'data) t -> unit
  [@@ocaml.doc " Equivalent to [drop ?n q `front]. "]

  val drop_back : ?n:int -> ('key, 'data) t -> unit
  [@@ocaml.doc " Equivalent to [drop ?n q `back]. "]

  [@@@ocaml.text " {2 Iterating over elements} "]

  val iteri : ('key, 'data) t -> f:(key:'key -> data:'data -> unit) -> unit
  [@@ocaml.doc " [iter t ~f] applies [f] to each key and element of the queue. "]

  val foldi
    :  ('key, 'data) t
    -> init:'acc
    -> f:('acc -> key:'key -> data:'data -> 'acc)
    -> 'acc
end

module type S0 = sig
  type ('key, 'data) hash_queue
  type key

  include
    S1
    with type 'key create_key := key
    with type 'key create_arg := unit
    with type ('key, 'data) t := ('key, 'data) hash_queue

  type 'data t = (key, 'data) hash_queue [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('data -> Sexplib0.Sexp.t) -> 'data t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type S_backend = sig
  include
    S1
    with type 'key create_arg := 'key Hashtbl.Hashable.t
    with type 'key create_key := 'key

  module type S = S0 with type ('key, 'data) hash_queue := ('key, 'data) t

  module Make : functor (Key : Key) -> S with type key = Key.t

  module Make_with_hashable : functor
      (T : sig
         module Key : Key

         val hashable : Key.t Hashtbl.Hashable.t
       end)
      -> S with type key = T.Key.t
end

module type Hash_queue = sig
  module type Key = Key
  module type S_backend = S_backend

  module Make_backend : functor (Table : Hashtbl_intf.Hashtbl) -> S_backend

  include S_backend [@@ocaml.doc " equivalent to [Make_backend (Hashtbl)] "]
end
[@@ocaml.doc
  " A hash-queue is a combination of a queue and a hashtable that\n\
  \    supports constant-time lookup and removal of queue elements in addition to\n\
  \    the usual queue operations (enqueue, dequeue). The queue elements are\n\
  \    key-value pairs. The hashtable has one entry for each element of the queue.\n\n\
  \    Calls to functions that would modify a hash-queue (e.g. [enqueue], [dequeue],\n\
  \    [remove], [replace]) detect if a client is in the middle of iterating over the\n\
  \    queue (e.g., [iter], [fold], [for_all], [exists]) and if so, raise an exception.\n"]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
