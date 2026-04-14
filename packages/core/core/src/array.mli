[@@@ocaml.text
  " Fixed-length, mutable vector of elements with O(1) [get] and [set] operations.\n\n\
  \    This module extends {{!Base.Array}[Base.Array]}. "]

open Import
open Perms.Export

[@@@ocaml.text " {2 The [Array] type} "]

type 'a t = 'a Base.Array.t [@@deriving bin_io ~localize, quickcheck, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text " {2 The signature included from [Base.Array]} "]

include module type of struct
    include Base.Array
  end
  with type 'a t := 'a t
[@@ocaml.doc " @inline "]

[@@@ocaml.text
  " {2 Extensions}\n\n\
  \    We add extensions for [Int] and [Float] arrays to make them bin-able, comparable,\n\
  \    sexpable, and blit-able (via [Blit.S]). [Permissioned] provides fine-grained access\n\
  \    control for arrays.\n\n\
  \    Operations supporting \"normalized\" indexes are also available.\n"]

module Int : sig
  type nonrec t = int t [@@deriving bin_io ~localize, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Blit.S with type t := t

  external unsafe_blit
    :  src:(t[@local_opt])
    -> src_pos:int
    -> dst:(t[@local_opt])
    -> dst_pos:int
    -> len:int
    -> unit
    = "core_array_unsafe_int_blit"
  [@@noalloc]
end

module Float : sig
  type nonrec t = float t [@@deriving bin_io ~localize, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Blit.S with type t := t

  external unsafe_blit
    :  src:(t[@local_opt])
    -> src_pos:int
    -> dst:(t[@local_opt])
    -> dst_pos:int
    -> len:int
    -> unit
    = "core_array_unsafe_float_blit"
  [@@noalloc]
end

val normalize : 'a t -> int -> int
[@@ocaml.doc
  " [normalize array index] returns a new index into the array such that if the index is\n\
  \    less than zero, the returned index will \"wrap around\" -- i.e., \
   [array.(normalize array\n\
  \    (-1))] returns the last element of the array. "]

val slice : 'a t -> int -> int -> 'a t
[@@ocaml.doc
  " [slice t start stop] returns a new array including elements [t.(start)] through\n\
  \    [t.(stop-1)], normalized Python-style with the exception that [stop = 0] is \
   treated as\n\
  \    [stop = length t]. "]

val nget : 'a t -> int -> 'a [@@ocaml.doc " Array access with [normalize]d index. "]

val nset : 'a t -> int -> 'a -> unit
[@@ocaml.doc " Array modification with [normalize]d index. "]

module Permissioned : sig
  type ('a, -'perms) t
  [@@ocaml.doc
    " The meaning of the ['perms] parameter is as usual (see the [Perms] module for more\n\
    \      details) with the non-obvious difference that you don't need any permissions to\n\
    \      extract the length of an array.  This was done for simplicity because some\n\
    \      information about the length of an array can leak out even if you only have \
     write\n\
    \      permissions since you can catch out-of-bounds errors.\n\
    \  "]
  [@@deriving bin_io ~localize, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local2 with type ('a, -'perms) t := ('a, 'perms) t
    include Ppx_compare_lib.Comparable.S2 with type ('a, -'perms) t := ('a, 'perms) t
    include Sexplib0.Sexpable.S2 with type ('a, -'perms) t := ('a, 'perms) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Int : sig
    type nonrec -'perms t = (int, 'perms) t [@@deriving bin_io ~localize, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type -'perms t := 'perms t
      include Ppx_compare_lib.Comparable.S1 with type -'perms t := 'perms t
      include Sexplib0.Sexpable.S1 with type -'perms t := 'perms t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Blit.S_permissions with type 'perms t := 'perms t

    external unsafe_blit
      :  src:([> read ] t[@local_opt])
      -> src_pos:int
      -> dst:([> write ] t[@local_opt])
      -> dst_pos:int
      -> len:int
      -> unit
      = "core_array_unsafe_int_blit"
    [@@noalloc]
  end

  module Float : sig
    type nonrec -'perms t = (float, 'perms) t [@@deriving bin_io ~localize, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type -'perms t := 'perms t
      include Ppx_compare_lib.Comparable.S1 with type -'perms t := 'perms t
      include Sexplib0.Sexpable.S1 with type -'perms t := 'perms t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Blit.S_permissions with type 'perms t := 'perms t

    external get
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> float
      = "%floatarray_safe_get"

    external set
      :  ([> write ] t[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_safe_set"

    external unsafe_get
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> float
      = "%floatarray_unsafe_get"

    external unsafe_set
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_unsafe_set"

    external unsafe_blit
      :  src:([> read ] t[@local_opt])
      -> src_pos:int
      -> dst:([> write ] t[@local_opt])
      -> dst_pos:int
      -> len:int
      -> unit
      = "core_array_unsafe_float_blit"
    [@@noalloc]
  end

  val of_array_id : 'a array -> ('a, [< read_write ]) t
  [@@ocaml.doc
    " [of_array_id] and [to_array_id] return the same underlying array.  On the other\n\
    \      hand, [to_array] (inherited from [Container.S1_permissions] below) makes a \
     copy.\n\n\
    \      To create a new (possibly immutable) copy of an array [a], use [copy \
     (of_array_id\n\
    \      a)].  More generally, any function that takes a (possibly mutable) [t] can be \
     called\n\
    \      on an array by calling [of_array_id] on it first.\n\n\
    \      There is a conceptual type equality between ['a Array.t] and\n\
    \      [('a, read_write) Array.Permissioned.t].  The reason for not exposing this as \
     an\n\
    \      actual type equality is that we also want:\n\n\
    \      {ul\n\
    \      {- The type equality ['a Array.t = 'a array] for interoperability with code \
     which\n\
    \      does not use Core.}\n\
    \      {- The type [('a, 'perms) Array.Permissioned.t] to be abstract, so that the\n\
    \      permission phantom type will have an effect.}\n\
    \      }\n\n\
    \      Since we don't control the definition of ['a array], this would require a type\n\
    \      [('a, 'perms) Array.Permissioned.t] which is abstract, except that\n\
    \      [('a, read_write) Array.Permissioned.t] is concrete, which is not possible.\n\
    \  "]

  val to_array_id : ('a, [> read_write ]) t -> 'a array

  val to_sequence_immutable : ('a, [> immutable ]) t -> 'a Sequence.t
  [@@ocaml.doc
    " [to_sequence_immutable t] converts [t] to a sequence. Unlike [to_sequence],\n\
    \      [to_sequence_immutable] does not need to copy [t] since it is immutable. "]

  include
    Indexed_container.S1_with_creators_permissions
    with type ('a, 'perms) t := ('a, 'perms) t

  include Blit.S1_permissions with type ('a, 'perms) t := ('a, 'perms) t
  include Binary_searchable.S1_permissions with type ('a, 'perms) t := ('a, 'perms) t

  [@@@ocaml.text
    " These functions are in [Container.S1_permissions], but they are re-exposed here so\n\
    \      that their types can be changed to make them more permissive (see comment \
     above). "]

  val length : (_, _) t -> int
  val is_empty : (_, _) t -> bool

  [@@@ocaml.text " counterparts of regular array functions above "]

  external get
    :  (('a, [> read ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    = "%array_safe_get"

  external set
    :  (('a, [> write ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    -> unit
    = "%array_safe_set"

  external unsafe_get
    :  (('a, [> read ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    = "%array_unsafe_get"

  external unsafe_set
    :  (('a, [> write ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    -> unit
    = "%array_unsafe_set"

  val create : len:int -> 'a -> ('a, [< _ perms ]) t
  val create_local : len:int -> 'a -> ('a, [< _ perms ]) t
  val create_float_uninitialized : len:int -> (float, [< _ perms ]) t
  val init : int -> f:(int -> 'a) -> ('a, [< _ perms ]) t
  val make_matrix : dimx:int -> dimy:int -> 'a -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val copy_matrix
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val append : ('a, [> read ]) t -> ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val concat : ('a, [> read ]) t list -> ('a, [< _ perms ]) t
  val copy : ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val fill : ('a, [> write ]) t -> pos:int -> len:int -> 'a -> unit
  val of_list : 'a list -> ('a, [< _ perms ]) t
  val map : ('a, [> read ]) t -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t

  val folding_map
    :  ('a, [> read ]) t
    -> init:'b
    -> f:('b -> 'a -> 'b * 'c)
    -> ('c, [< _ perms ]) t

  val fold_map
    :  ('a, [> read ]) t
    -> init:'b
    -> f:('b -> 'a -> 'b * 'c)
    -> 'b * ('c, [< _ perms ]) t

  val iteri : ('a, [> read ]) t -> f:(int -> 'a -> unit) -> unit
  val foldi : ('a, [> read ]) t -> init:'b -> f:(int -> 'b -> 'a -> 'b) -> 'b

  val folding_mapi
    :  ('a, [> read ]) t
    -> init:'b
    -> f:(int -> 'b -> 'a -> 'b * 'c)
    -> ('c, [< _ perms ]) t

  val fold_mapi
    :  ('a, [> read ]) t
    -> init:'b
    -> f:(int -> 'b -> 'a -> 'b * 'c)
    -> 'b * ('c, [< _ perms ]) t

  val fold_right : ('a, [> read ]) t -> f:('a -> 'b -> 'b) -> init:'b -> 'b

  val sort
    :  ?pos:int
    -> ?len:int
    -> ('a, [> read_write ]) t
    -> compare:('a -> 'a -> int)
    -> unit

  val stable_sort : ('a, [> read_write ]) t -> compare:('a -> 'a -> int) -> unit
  val is_sorted : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> bool
  val is_sorted_strictly : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> bool

  val merge
    :  ('a, [> read ]) t
    -> ('a, [> read ]) t
    -> compare:('a -> 'a -> int)
    -> ('a, [< _ perms ]) t

  val concat_map
    :  ('a, [> read ]) t
    -> f:('a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t

  val concat_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t

  val partition_tf
    :  ('a, [> read ]) t
    -> f:('a -> bool)
    -> ('a, [< _ perms ]) t * ('a, [< _ perms ]) t

  val partitioni_tf
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> bool)
    -> ('a, [< _ perms ]) t * ('a, [< _ perms ]) t

  val cartesian_product
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> ('a * 'b, [< _ perms ]) t

  val transpose
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t option

  val transpose_exn
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val normalize : (_, _) t -> int -> int
  val slice : ('a, [> read ]) t -> int -> int -> ('a, [< _ perms ]) t
  val nget : ('a, [> read ]) t -> int -> 'a
  val nset : ('a, [> write ]) t -> int -> 'a -> unit
  val filter_opt : ('a option, [> read ]) t -> ('a, [< _ perms ]) t
  val filter_map : ('a, [> read ]) t -> f:('a -> 'b option) -> ('b, [< _ perms ]) t

  val filter_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> 'b option)
    -> ('b, [< _ perms ]) t

  val for_alli : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val existsi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val counti : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> int
  val iter2_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> f:('a -> 'b -> unit) -> unit

  val map2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> f:('a -> 'b -> 'c)
    -> ('c, [< _ perms ]) t

  val fold2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> init:'c
    -> f:('c -> 'a -> 'b -> 'c)
    -> 'c

  val for_all2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> f:('a -> 'b -> bool)
    -> bool

  val exists2_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> f:('a -> 'b -> bool) -> bool
  val filter : ('a, [> read ]) t -> f:('a -> bool) -> ('a, [< _ perms ]) t
  val filteri : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> ('a, [< _ perms ]) t
  val swap : ('a, [> read_write ]) t -> int -> int -> unit
  val rev_inplace : ('a, [> read_write ]) t -> unit
  val of_list_rev : 'a list -> ('a, [< _ perms ]) t
  val of_list_map : 'a list -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_mapi : 'a list -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_rev_map : 'a list -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_rev_mapi : 'a list -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val map_inplace : ('a, [> read_write ]) t -> f:('a -> 'a) -> unit
  val find_exn : ('a, [> read ]) t -> f:('a -> bool) -> 'a
  val find_map_exn : ('a, [> read ]) t -> f:('a -> 'b option) -> 'b
  val findi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> (int * 'a) option
  val findi_exn : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> int * 'a
  val find_mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b option) -> 'b option
  val find_mapi_exn : ('a, [> read ]) t -> f:(int -> 'a -> 'b option) -> 'b

  val find_consecutive_duplicate
    :  ('a, [> read ]) t
    -> equal:('a -> 'a -> bool)
    -> ('a * 'a) option

  val reduce : ('a, [> read ]) t -> f:('a -> 'a -> 'a) -> 'a option
  val reduce_exn : ('a, [> read ]) t -> f:('a -> 'a -> 'a) -> 'a

  val permute
    :  ?random_state:Random.State.t
    -> ?pos:int
    -> ?len:int
    -> ('a, [> read_write ]) t
    -> unit

  val zip : ('a, [> read ]) t -> ('b, [> read ]) t -> ('a * 'b, [< _ perms ]) t option
  val zip_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> ('a * 'b, [< _ perms ]) t
  val unzip : ('a * 'b, [> read ]) t -> ('a, [< _ perms ]) t * ('b, [< _ perms ]) t
  val sorted_copy : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> ('a, [< _ perms ]) t
  val last : ('a, [> read ]) t -> 'a
  val equal : ('a -> 'a -> bool) -> ('a, [> read ]) t -> ('a, [> read ]) t -> bool
  val to_sequence : ('a, [> read ]) t -> 'a Sequence.t
  val to_sequence_mutable : ('a, [> read ]) t -> 'a Sequence.t
end
[@@ocaml.doc
  " The [Permissioned] module gives the ability to restrict permissions on an array, so\n\
  \    you can give a function read-only access to an array, create an immutable array, \
   etc.\n"]
