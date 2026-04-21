[@@@ocaml.text
  " A polymorphic hashtbl that uses {!Pool} to avoid allocation.\n\n\
  \    This uses the standard linked-chain hashtable algorithm, albeit with links \
   performed\n\
  \    through a pool and hence avoiding [caml_modify] (for table manipulation), even when\n\
  \    hashing object keys/values.\n\n\
  \    This implementation is worth exploring for your application if profiling \
   demonstrates\n\
  \    that garbage collection and the [caml_modify] write barrier are a significant \
   part of\n\
  \    your execution time. "]

open! Core
open! Import
include Hashtbl_intf.Hashtbl

val resize : (_, _) t -> int -> unit
[@@ocaml.doc
  " [resize t size] ensures that [t] can hold at least [size] entries without resizing\n\
  \    (again), provided that [t] has growth enabled.  This is useful for sizing global\n\
  \    tables during application initialization, to avoid subsequent, expensive growth\n\
  \    online.  See {!Immediate.String.resize}, for example. "]

val on_grow
  :  before:(unit -> 'a)
  -> after:('a -> old_capacity:int -> new_capacity:int -> unit)
  -> unit
[@@ocaml.doc
  " [on_grow ~before ~after] allows you to connect higher level loggers to the point where\n\
  \    these hashtbls grow.  [before] is called before the table grows, and [after] \
   after it.\n\
  \    This permits you to e.g. measure the time elapsed between the two.\n\n\
  \    This is only meant for debugging and profiling, e.g. note that once a callback is\n\
  \    installed, there is no way to remove it. "]
