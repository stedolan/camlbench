[@@@ocaml.text
  " A [Bounded_int_table] is a table whose keys can be mapped to integers in a fixed\n\
  \    range, 0 ... [num_keys] - 1, where [num_keys] is specified at table-creation \
   time. The\n\
  \    purpose of [Bounded_int_table] is to be faster than [Hashtbl] in situations where \
   one\n\
  \    is willing to pay a space cost for the speed.\n\n\
  \    [Bounded_int_table] presents a subset of the [Hashtbl] interface. The key type \
   can be\n\
  \    any type, but table creation requires a [key_to_int] function, which will be used\n\
  \    to extract the integer of all keys. If multiple keys map to the same integer, then\n\
  \    only one of them can be in the table at a time. Any operation that supplies a key\n\
  \    whose corresponding integer is outside the allowed range for the table will cause \
   an\n\
  \    exception.\n\n\
  \    A [Bounded_int_table] is implemented using two fixed-size arrays of size \
   [num_keys],\n\
  \    which are supplied at table-creation time. The space used does not depend on the\n\
  \    [length] of the table but rather only on [num_keys]. Operations that deal with a\n\
  \    single element ([find], [mem], [add], [remove], [set]) take constant time, and \
   perform\n\
  \    one or two array operations. Operations that deal with all of the keys defined in \
   the\n\
  \    table ([data], [fold], [iter], [keys], [to_alist]) take time proportional to the\n\
  \    [length] of the table, not [num_keys].\n"]

open! Core

type ('key, 'data) t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t
    :  ('key -> Sexplib0.Sexp.t)
    -> ('data -> Sexplib0.Sexp.t)
    -> ('key, 'data) t
    -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type ('a, 'b) table = ('a, 'b) t

include Invariant.S2 with type ('a, 'b) t := ('a, 'b) t

include
  Equal.S2 with type ('a, 'b) t := ('a, 'b) t
[@@ocaml.doc
  " Equality only requires the keys and values to be the same, not the bin or sexp\n\
  \    formatting or the integers the keys correspond to (see [key_to_int])."]

val create
  :  ?sexp_of_key:('key -> Sexp.t)
  -> num_keys:int
  -> key_to_int:('key -> int)
  -> unit
  -> ('key, 'data) t
[@@ocaml.doc
  " [create ~num_keys ~key_to_int] returns a table where the keys can map to 0\n\
  \    ... [num_keys] - 1, according to [key_to_int]. It is an error if [num_keys < 0].\n\n\
  \    [sexp_of_key], if supplied, will be used to display keys in error messages. "]

val num_keys : _ t -> int
val is_empty : _ t -> bool

[@@@ocaml.text " {2 Standard hashtbl functions} "]

val keys : ('key, _) t -> 'key list
val data : (_, 'data) t -> 'data list
val find : ('key, 'data) t -> 'key -> 'data option
val find_exn : ('key, 'data) t -> 'key -> 'data
val find_or_add : ('key, 'data) t -> 'key -> default:(unit -> 'data) -> 'data

val fold
  :  ('key, 'data) t
  -> init:'accum
  -> f:(key:'key -> data:'data -> 'accum -> 'accum)
  -> 'accum

val iter_keys : ('key, _) t -> f:('key -> unit) -> unit
val iter : (_, 'data) t -> f:('data -> unit) -> unit
val iteri : ('key, 'data) t -> f:(key:'key -> data:'data -> unit) -> unit

val filter_mapi
  :  ('key, 'data1) t
  -> f:(key:'key -> data:'data1 -> 'data2 option)
  -> ('key, 'data2) t

val filter_map : ('key, 'data1) t -> f:('data1 -> 'data2 option) -> ('key, 'data2) t
val filter_keys : ('key, 'data1) t -> f:('key -> bool) -> ('key, 'data1) t
val filter : ('key, 'data1) t -> f:('data1 -> bool) -> ('key, 'data1) t
val filteri : ('key, 'data1) t -> f:(key:'key -> data:'data1 -> bool) -> ('key, 'data1) t
val mapi : ('key, 'data1) t -> f:(key:'key -> data:'data1 -> 'data2) -> ('key, 'data2) t
val map : ('key, 'data1) t -> f:('data1 -> 'data2) -> ('key, 'data2) t
val for_alli : ('key, 'data) t -> f:(key:'key -> data:'data -> bool) -> bool
val existsi : ('key, 'data) t -> f:(key:'key -> data:'data -> bool) -> bool
val for_all : (_, 'data) t -> f:('data -> bool) -> bool
val exists : (_, 'data) t -> f:('data -> bool) -> bool
val length : (_, _) t -> int
val mem : ('key, _) t -> 'key -> bool
val remove : ('key, _) t -> 'key -> unit
val set : ('a, 'b) t -> key:'a -> data:'b -> unit
val add : ('a, 'b) t -> key:'a -> data:'b -> [ `Ok | `Duplicate of 'b ]
val add_exn : ('a, 'b) t -> key:'a -> data:'b -> unit
val to_alist : ('key, 'data) t -> ('key * 'data) list
val clear : (_, _) t -> unit

module With_key : functor
    (Key : sig
       type t [@@deriving bin_io, sexp]

       include sig
         [@@@ocaml.warning "-32"]

         include Bin_prot.Binable.S with type t := t
         include Sexplib0.Sexpable.S with type t := t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]

       val to_int : t -> int
     end)
    -> sig
  type 'data t = (Key.t, 'data) table
  [@@ocaml.doc
    " Serialization of a bounded int table using [bin_io] or [sexp] preserves [num_keys],\n\
    \      but only takes space proportional to the [length] of the table. "]
  [@@deriving bin_io, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'data t := 'data t
    include Sexplib0.Sexpable.S1 with type 'data t := 'data t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : num_keys:int -> 'data t

  val of_alist : (Key.t * 'data) list -> 'data t Or_error.t
  [@@ocaml.doc
    " [of_alist] returns a table whose maximum allowed key is the maximum key in the input\n\
    \      list. "]

  val of_alist_exn : (Key.t * 'data) list -> 'data t
end

val debug : bool ref
[@@ocaml.doc
  " set [debug := true] to turn on debugging, including potentially slow invariant\n\
  \    checking. "]
