let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"vec_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "vec_intf.ml.before-ppx"
;;

open! Core

module type S = sig
  type index
  type 'a t [@@deriving compare, equal, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Invariant.S1 with type 'a t := 'a t

  val create : ?initial_capacity:int -> unit -> 'a t

  val init : int -> f:(int -> 'a) -> 'a t
  [@@ocaml.doc
    " [init n ~f] returns a fresh vector of length [n], with element number [i]\n\
    \      initialized to the result of [f i]. In other words, [init n ~f] tabulates the\n\
    \      results of [f] applied to the integers [0] to [n-1].\n\n\
    \      Raise Invalid_argument if [n < 0].\n\
    \  "]

  val get : 'a t -> index -> 'a [@@ocaml.doc " Raises if the index is invalid. "]

  val maybe_get : 'a t -> index -> 'a option
  val maybe_get_local : 'a t -> index -> 'a Gel.t option

  val set : 'a t -> index -> 'a -> unit [@@ocaml.doc " Raises if the index is invalid. "]

  include Container.S1 with type 'a t := 'a t
  include Blit.S1 with type 'a t := 'a t

  val find_exn : 'a t -> f:('a -> bool) -> 'a
  [@@ocaml.doc " Finds the first 'a for which f is true *"]

  val sort : ?pos:int -> ?len:int -> 'a t -> compare:('a -> 'a -> int) -> unit
  [@@ocaml.doc
    " [sort] uses constant heap space.\n\
    \      To sort only part of the array, specify [pos] to be the index to start \
     sorting from\n\
    \      and [len] indicating how many elements to sort. "]

  val is_sorted : 'a t -> compare:('a -> 'a -> int) -> bool
  val next_free_index : 'a t -> index
  val push_back : 'a t -> 'a -> unit
  val push_back_index : 'a t -> 'a -> index

  val grow_to : 'a t -> len:int -> default:'a -> unit
  [@@ocaml.doc
    " Grows the vec to the specified length if it is currently shorter. Sets all new\n\
    \      indices to [default]. "]

  val grow_to_include : 'a t -> index -> default:'a -> unit
  [@@ocaml.doc " Equivalent to [grow_to t (index + 1) ~default]. "]

  val grow_to' : 'a t -> len:int -> default:(index -> 'a) -> unit
  [@@ocaml.doc
    " Grows the vec to the specified length if it is currently shorter. Sets all new\n\
    \      indices to [default idx]. "]

  val grow_to_include' : 'a t -> index -> default:(index -> 'a) -> unit
  [@@ocaml.doc " Equivalent to [grow_to' t (index + 1) ~default]. "]

  val shrink_to : 'a t -> len:int -> unit
  [@@ocaml.doc
    " Shortens the vec to the specified length if it is currently longer. Raises if [len <\n\
    \      0]. "]

  val remove_exn : 'a t -> int -> unit
  [@@ocaml.doc
    " [remove vec i] Removes the i-th element of the vector. This is not a fast\n\
    \      implementation, and runs in O(N) time. (ie: it calls caml_modify under the \
     hood)\n\
    \  "]

  val find_and_remove : 'a t -> f:('a -> bool) -> 'a option
  [@@ocaml.doc
    " Find the first element that satisfies [f]. If exists, remove the element from the\n\
    \      vector and return it. This is not a fast implementation, and runs in O(N) time.\n\
    \  "]

  val pop_back_exn : 'a t -> 'a
  val pop_back_unit_exn : 'a t -> unit
  val peek_back : 'a t -> 'a option
  val peek_back_exn : 'a t -> 'a
  val foldi : 'a t -> init:'accum -> f:(index -> 'accum -> 'a -> 'accum) -> 'accum

  val foldi_local_accum
    :  'a t
    -> init:'accum
    -> f:(index -> 'accum -> 'a -> 'accum)
    -> 'accum

  val iteri : 'a t -> f:(index -> 'a -> unit) -> unit
  val to_list : 'a t -> 'a list
  val to_local_list : 'a t -> 'a list
  val to_alist : 'a t -> (index * 'a) list

  val to_sequence : 'a t -> 'a Sequence.t
  [@@ocaml.doc
    " The input vec is copied internally so that future modifications of it do not change\n\
    \      the sequence. "]

  val to_sequence_mutable : 'a t -> 'a Sequence.t
  [@@ocaml.doc
    " The input vec is shared with the sequence and modifications of it will result in\n\
    \      modification of the sequence. "]

  val of_list : 'a list -> 'a t
  val of_array : 'a array -> 'a t
  val of_sequence : 'a Sequence.t -> 'a t

  val take_while : 'a t -> f:('a -> bool) -> 'a t
  [@@ocaml.doc
    " [take_while t ~f] returns a fresh vec containing the longest prefix of [t] for which\n\
    \      [f] is [true]. "]

  module Inplace : sig
    val sub : 'a t -> pos:index -> len:int -> unit
    [@@ocaml.doc " [sub] is like [Blit.sub], but modifies the vec in place. "]

    val take_while : 'a t -> f:('a -> bool) -> unit
    [@@ocaml.doc
      " [take_while t ~f] shortens the vec in place to the longest prefix of [t] for which\n\
      \        [f] is [true]. "]

    val filter : 'a t -> f:('a -> bool) -> unit
    [@@ocaml.doc
      " Remove all elements from [t] that don't satisfy [f]. Shortens the vec in place. "]

    val map : 'a t -> f:('a -> 'a) -> unit
    [@@ocaml.doc " Modifies a vec in place, applying [f] to every element of the vec. "]

    val mapi : 'a t -> f:(index -> 'a -> 'a) -> unit
    [@@ocaml.doc " Same as [map], but [f] also takes the index. "]
  end

  val capacity : _ t -> int
  [@@ocaml.doc " The number of elements we can hold without growing. "]

  val clear : _ t -> unit
  [@@ocaml.doc " [clear t] discards all elements from [t] in O(length) time. "]

  val clear_imm : 'a t -> 'a Type_immediacy.Always.t -> unit
  [@@ocaml.doc
    " [clear_imm t] discards all elements from ['a t] in O(1) time if ['a] is immediate. "]

  val copy : 'a t -> 'a t
  [@@ocaml.doc
    " [copy t] returns a copy of [t], that is, a fresh vec containing the same elements as\n\
    \      [t]. "]

  val exists : 'a t -> f:('a -> bool) -> bool
  [@@ocaml.doc
    " [exists t ~f] returns true if [f] evaluates true on any element, else false "]

  val swap : _ t -> index -> index -> unit
  [@@ocaml.doc " swap the values at the provided indices "]

  val swap_to_last_and_pop : 'a t -> index -> 'a
  [@@ocaml.doc
    " [swap_to_last_and_pop t i] is equivalent to [swap t i (length t - 1); pop_back_exn \
     t].\n\
    \      It raises if [i] is out of bounds. "]

  module With_structure_details : sig
    type nonrec 'a t = 'a t
    [@@ocaml.doc
      " [[%sexp_of : t]] above only prints the elements. This gives various data structure\n\
      \        details. "]
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val unsafe_get : 'a t -> index -> 'a
  val unsafe_set : 'a t -> index -> 'a -> unit

  module Expert : sig
    val unsafe_inner : 'a t -> Obj.t Uniform_array.t
  end

  module Stable : sig
    module V1 : sig
      type nonrec 'a t = 'a t [@@deriving bin_io, compare, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end
end

module type Vec = sig
  include
    S with type index := int
  [@@ocaml.doc
    " A growable array of ['a]. Designed for efficiency and simplicity.\n\n\
    \      This interface is generated lazily: if you need a standard function we haven't\n\
    \      added, feel free to add or ping the authors.\n\n\
    \      By default, [Vec] operations use integers as indices. The functor [Make] can \
     be used\n\
    \      to create a specialized version from any module implementing [Intable.S]. "]

  module type S = S

  module Make : functor (M : Intable.S) -> S with type index := M.t
  [@@ocaml.doc " Generate a specialised version of [Vec] with a custom index type. "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
