[@@@ocaml.text
  " A hashtable that keeps a weak pointer to each key's data and uses a finalizer to\n\
  \    detect when the data is no longer referenced (by any non-weak pointers).\n\n\
  \    Once a key's data is finalized, the table will effectively behave as if the key \
   is not\n\
  \    in the table, e.g., [find] will return [None]. However, one must call\n\
  \    [reclaim_space_for_keys_with_unused_data] to actually reclaim the space used by the\n\
  \    table for such keys.\n\n\
  \    Unlike (OCaml's) [Weak.Make], which also describes itself as a \"weak hashtable,\"\n\
  \    [Weak_hashtbl] gives a dictionary-style structure.  In fact, OCaml's [Weak.Make] \
   may\n\
  \    better be described as a weak set.\n\n\
  \    There's a tricky type of bug one can write with this module, e.g.:\n\n\
  \    {[\n\
  \      type t =\n\
  \        { foo : string\n\
  \        ; bar : float Incr.t\n\
  \        }\n\n\
  \      let tbl = Weak_hashtbl.create ()\n\
  \      let x1 =\n\
  \        let t = Weak_hashtbl.find_or_add tbl key ~default:(fun () ->\n\
  \          (... some function that computes a t...))\n\
  \        in\n\
  \        t.bar\n\
  \    ]}\n\n\
  \    At this point, the data associated with [key] is unreachable (since all we did \
   with it\n\
  \    was project out field [bar]), so it may disappear from the table at any time. "]

open! Base

type ('a, 'b) t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t
    :  ('a -> Sexplib0.Sexp.t)
    -> ('b -> Sexplib0.Sexp.t)
    -> ('a, 'b) t
    -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create
  :  ?growth_allowed:(bool[@ocaml.doc " default is [true] "])
  -> ?size:(int[@ocaml.doc " default is [0] "])
  -> (module Hashtbl.Key.S with type t = 'a)
  -> ('a, 'b) t
[@@ocaml.doc
  " [growth_allowed] and [size] are both optionally passed on to the underlying call to\n\
  \    [Hashtbl.create]. "]

module Using_hashable : sig
  val create
    :  ?growth_allowed:(bool[@ocaml.doc " default is [true] "])
    -> ?size:(int[@ocaml.doc " default is [0] "])
    -> 'a Hashable.t
    -> ('a, 'b) t
end

val mem : ('a, _) t -> 'a -> bool
val find : ('a, 'b) t -> 'a -> 'b Heap_block.t option
val find_or_add : ('a, 'b) t -> 'a -> default:(unit -> 'b Heap_block.t) -> 'b Heap_block.t
val remove : ('a, 'b) t -> 'a -> unit
val clear : (_, _) t -> unit
val add_exn : ('a, 'b) t -> key:'a -> data:'b Heap_block.t -> unit
val replace : ('a, 'b) t -> key:'a -> data:'b Heap_block.t -> unit

val key_is_using_space : ('a, _) t -> 'a -> bool
[@@ocaml.doc
  " [key_is_using_space t key] returns [true] if [key] is using some space in [t].  [mem t\n\
  \    key] implies [key_is_using_space t key], but it is also possible that that\n\
  \    [key_is_using_space t key && not (mem t key)]. "]

val reclaim_space_for_keys_with_unused_data : (_, _) t -> unit
[@@ocaml.doc
  " [reclaim_space_for_keys_with_unused_data t] reclaims space for all keys in [t] whose\n\
  \    data has been detected (by a finalizer) to be unused.  Only [key]s such that\n\
  \    [key_is_using_space t key && not (mem t key)] will be reclaimed. "]

val set_run_when_unused_data : (_, _) t -> thread_safe_f:(unit -> unit) -> unit
[@@ocaml.doc
  " [set_run_when_unused_data t ~thread_safe_f] calls [thread_safe_f] in the finalizer\n\
  \    attached to each [data] in [t], after ensuring the entry being finalized will be\n\
  \    handled in the next call to [reclaim_space_for_keys_with_unused_data].  This can be\n\
  \    used to arrange to call [reclaim_space_for_keys_with_unused_data] at a convenient \
   time\n\
  \    in the future.  [thread_safe_f] must be thread safe -- it is {e not} safe for it to\n\
  \    call any [Weak_hashtbl] functions. "]
