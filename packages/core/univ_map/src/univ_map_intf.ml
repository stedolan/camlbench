[@@@ocaml.text
  " Universal/heterogeneous maps, useful for storing values of arbitrary type in a single\n\
  \    map.\n\n\
  \    In order to recover a value, it must be looked up with exactly the [Key.t] it was\n\
  \    stored in. In other words, given different [Key.t]s from the same [string], one \
   will\n\
  \    not be able to recover the key stored in the other one.\n\n\
  \    This is similar to [Univ] in spirit.\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"univ_map_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "univ_map_intf.ml.before-ppx"
;;

open! Base

module type Key = sig
  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val type_id : 'a t -> 'a Type_equal.Id.t
  [@@ocaml.doc
    " For correct behavior of the map, [type_id] must return the same [Type_equal.Id] on\n\
    \      different calls on the same input. "]
end

module type Data = sig
  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Data1 = sig
  type ('s, 'a) t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('s -> Sexplib0.Sexp.t)
      -> ('a -> Sexplib0.Sexp.t)
      -> ('s, 'a) t
      -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type S1 = sig
  type 's t
  [@@ocaml.doc " The ['s] parameter is shared across all values stored in the map. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('s -> Sexplib0.Sexp.t) -> 's t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Key : Key

  type ('s, 'a) data

  val invariant : _ t -> unit
  val empty : _ t
  val singleton : 'a Key.t -> ('s, 'a) data -> 's t
  val is_empty : _ t -> bool
  val set : 's t -> key:'a Key.t -> data:('s, 'a) data -> 's t
  val mem : _ t -> _ Key.t -> bool
  val mem_by_id : _ t -> Type_equal.Id.Uid.t -> bool
  val find : 's t -> 'a Key.t -> ('s, 'a) data option
  val find_exn : 's t -> 'a Key.t -> ('s, 'a) data
  val add : 's t -> key:'a Key.t -> data:('s, 'a) data -> [ `Ok of 's t | `Duplicate ]
  val add_exn : 's t -> key:'a Key.t -> data:('s, 'a) data -> 's t

  val change
    :  's t
    -> 'a Key.t
    -> f:(('s, 'a) data option -> ('s, 'a) data option)
    -> 's t

  val change_exn : 's t -> 'a Key.t -> f:(('s, 'a) data -> ('s, 'a) data) -> 's t
  val update : 's t -> 'a Key.t -> f:(('s, 'a) data option -> ('s, 'a) data) -> 's t
  val remove : 's t -> 'a Key.t -> 's t
  val remove_by_id : 's t -> Type_equal.Id.Uid.t -> 's t

  module Packed : sig
    type 's t = T : 'a Key.t * ('s, 'a) data -> 's t
  end

  val key_id_set : 's t -> Set.M(Type_equal.Id.Uid).t
  val to_alist : 's t -> 's Packed.t list
  val of_alist_exn : 's Packed.t list -> 's t
  val find_packed_by_id : 's t -> Type_equal.Id.Uid.t -> 's Packed.t option
  val find_packed_by_id_exn : 's t -> Type_equal.Id.Uid.t -> 's Packed.t
  val type_equal : ('s t, 's Packed.t Map.M(Type_equal.Id.Uid).t) Type_equal.t
end

module type S = sig
  type t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Key : Key

  type 'a data

  include Invariant.S with type t := t

  val empty : t
  val singleton : 'a Key.t -> 'a data -> t
  val is_empty : t -> bool
  val set : t -> key:'a Key.t -> data:'a data -> t
  val mem : t -> 'a Key.t -> bool
  val mem_by_id : t -> Type_equal.Id.Uid.t -> bool
  val find : t -> 'a Key.t -> 'a data option
  val find_exn : t -> 'a Key.t -> 'a data
  val add : t -> key:'a Key.t -> data:'a data -> [ `Ok of t | `Duplicate ]
  val add_exn : t -> key:'a Key.t -> data:'a data -> t
  val change : t -> 'a Key.t -> f:('a data option -> 'a data option) -> t
  val change_exn : t -> 'a Key.t -> f:('a data -> 'a data) -> t
  val update : t -> 'a Key.t -> f:('a data option -> 'a data) -> t
  val remove : t -> 'a Key.t -> t
  val remove_by_id : t -> Type_equal.Id.Uid.t -> t

  module Packed : sig
    type 's t1 = T : 'a Key.t * 'a data -> 's t1
    type t = unit t1
  end

  val key_id_set : t -> Set.M(Type_equal.Id.Uid).t

  val to_alist : t -> Packed.t list
  [@@ocaml.doc
    " [to_alist t] returns all values in [t], in increasing order of key type-id name. "]

  val of_alist_exn : Packed.t list -> t
  val find_packed_by_id : t -> Type_equal.Id.Uid.t -> Packed.t option
  val find_packed_by_id_exn : t -> Type_equal.Id.Uid.t -> Packed.t
  val type_equal : (t, Packed.t Map.M(Type_equal.Id.Uid).t) Type_equal.t
end

module type Univ_map = sig
  module type S = S
  module type S1 = S1
  module type Key = Key
  module type Data = Data

  module Type_id_key : Key with type 'a t = 'a Type_equal.Id.t
  include S with type 'a data = 'a and module Key := Type_id_key

  module Key = Type_equal.Id
  [@@ocaml.doc
    " This binding is convenient because existing call sites often refer to\n\
    \      [Univ_map.Key.create].\n\
    \  "]

  module Make : functor (Key : Key) -> functor (Data : Data) ->
    S with type 'a data = 'a Data.t and module Key = Key

  module Make1 : functor (Key : Key) -> functor (Data : Data1) ->
    S1 with type ('s, 'a) data = ('s, 'a) Data.t and module Key = Key

  module Merge : functor
      (Key : Key)
      -> functor
      (Input1_data : Data)
      -> functor
      (Input2_data : Data)
      -> functor
      (Output_data : Data)
      -> sig
    type f =
      { f :
          'a.
          key:'a Key.t
          -> [ `Left of 'a Input1_data.t
             | `Right of 'a Input2_data.t
             | `Both of 'a Input1_data.t * 'a Input2_data.t
             ]
          -> 'a Output_data.t option
      }

    val merge
      :  Make(Key)(Input1_data).t
      -> Make(Key)(Input2_data).t
      -> f:f
      -> Make(Key)(Output_data).t
    [@@ocaml.doc " The analogue of the normal [Map.merge] function.  "]
  end

  module Merge1 : functor
      (Key : Key)
      -> functor
      (Input1_data : Data1)
      -> functor
      (Input2_data : Data1)
      -> functor
      (Output_data : Data1)
      -> sig
    type ('s1, 's2, 's3) f =
      { f :
          'a.
          key:'a Key.t
          -> [ `Left of ('s1, 'a) Input1_data.t
             | `Right of ('s2, 'a) Input2_data.t
             | `Both of ('s1, 'a) Input1_data.t * ('s2, 'a) Input2_data.t
             ]
          -> ('s3, 'a) Output_data.t option
      }

    val merge
      :  's1 Make1(Key)(Input1_data).t
      -> 's2 Make1(Key)(Input2_data).t
      -> f:('s1, 's2, 's3) f
      -> 's3 Make1(Key)(Output_data).t
    [@@ocaml.doc " The analogue of the normal [Map.merge] function.  "]
  end

  module With_default : sig
    module Key : sig
      type 'a t

      val create : default:'a -> name:string -> ('a -> Sexp.t) -> 'a t
      val id : 'a t -> 'a Type_equal.Id.t
    end

    val set : t -> key:'a Key.t -> data:'a -> t
    val find : t -> 'a Key.t -> 'a
    val change : t -> 'a Key.t -> f:('a -> 'a) -> t
  end
  [@@ocaml.doc
    " keys with associated default values, so that [find] is no longer partial "]

  module With_fold : sig
    module Key : sig
      type ('a, 'b) t

      val create
        :  init:'b
        -> f:('b -> 'a -> 'b)
        -> name:string
        -> ('b -> Sexp.t)
        -> ('a, 'b) t

      val id : ('a, 'b) t -> 'b Type_equal.Id.t
    end

    val set : t -> key:('a, 'b) Key.t -> data:'b -> t
    [@@ocaml.doc " reset the accumulator "]

    val find : t -> ('a, 'b) Key.t -> 'b [@@ocaml.doc " the current accumulator "]

    val add : t -> key:('a, 'b) Key.t -> data:'a -> t
    [@@ocaml.doc " fold value into accumulator "]

    val change : t -> ('a, 'b) Key.t -> f:('b -> 'b) -> t
    [@@ocaml.doc " accumulator update "]
  end
  [@@ocaml.doc
    " keys that map to an accumulator value with an associated fold operation "]

  module Multi : sig
    module Key : sig
      type 'a t

      val create : name:string -> ('a -> Sexp.t) -> 'a t
      val id : 'a t -> 'a list Type_equal.Id.t
    end

    val set : t -> key:'a Key.t -> data:'a list -> t
    val find : t -> 'a Key.t -> 'a list
    val add : t -> key:'a Key.t -> data:'a -> t
    val change : t -> 'a Key.t -> f:('a list -> 'a list) -> t
  end
  [@@ocaml.doc " list-accumulating keys with a default value of the empty list "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
