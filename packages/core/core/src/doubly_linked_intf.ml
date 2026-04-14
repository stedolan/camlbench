[@@@ocaml.text
  " Doubly-linked lists.\n\n\
  \    Compared to other doubly-linked lists, in this one:\n\n\
  \    1. Calls to modification functions ([insert*], [move*], ...) detect if the list is\n\
  \    being iterated over ([iter], [fold], ...), and if so raise an exception.  For \
   example,\n\
  \    a use like the following would raise:\n\n\
  \    {[\n\
  \      iter t ~f:(fun _ -> ... remove t e ...)\n\
  \    ]}\n\n\
  \    2. There is a designated \"front\" and \"back\" of each list, rather than viewing \
   each\n\
  \    element as an equal in a ring.\n\n\
  \    3. Elements know which list they're in. Each operation that takes an [Elt.t] also\n\
  \    takes a [t], first checks that the [Elt] belongs to the [t], and if not, raises.\n\n\
  \    4. Related to (3), lists cannot be split, though a sort of splicing is available as\n\
  \    [transfer]. In other words, no operation will cause one list to become two. This\n\
  \    makes this module unsuitable for maintaining the faces of a planar graph under edge\n\
  \    insertion and deletion, for example.\n\n\
  \    5. Another property permitted by (3) and (4) is that [length] is O(1). "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"doubly_linked_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "doubly_linked_intf.ml.before-ppx"
;;

open! Import

module type S = sig
  module Elt : sig
    type 'a t

    val value : 'a t -> 'a

    val equal : 'a t -> 'a t -> bool [@@ocaml.doc " pointer equality "]

    val set : 'a t -> 'a -> unit
    val sexp_of_t : ('a -> Base.Sexp.t) -> 'a t -> Base.Sexp.t
  end

  type 'a t [@@deriving compare, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Container.S1 with type 'a t := 'a t
  include Invariant.S1 with type 'a t := 'a t

  [@@@ocaml.text " {2 Creating doubly-linked lists} "]

  val create : unit -> 'a t

  val of_list : 'a list -> 'a t
  [@@ocaml.doc
    " [of_list l] returns a doubly-linked list [t] with the same elements as [l] and in\n\
    \      the same order (i.e., the first element of [l] is the first element of [t]). \
     It is\n\
    \      always the case that [l = to_list (of_list l)]. "]

  val of_array : 'a array -> 'a t

  [@@@ocaml.text " {2 Predicates} "]

  val equal : 'a t -> 'a t -> bool [@@ocaml.doc " pointer equality "]

  val is_first : 'a t -> 'a Elt.t -> bool
  val is_last : 'a t -> 'a Elt.t -> bool
  val mem_elt : 'a t -> 'a Elt.t -> bool

  [@@@ocaml.text " {2 Constant-time extraction of first and last elements} "]

  val first_elt : 'a t -> 'a Elt.t option
  val last_elt : 'a t -> 'a Elt.t option
  val first : 'a t -> 'a option
  val last : 'a t -> 'a option
  val first_exn : 'a t -> 'a
  val last_exn : 'a t -> 'a

  [@@@ocaml.text " {2 Constant-time retrieval of next or previous element} "]

  val next : 'a t -> 'a Elt.t -> 'a Elt.t option
  val prev : 'a t -> 'a Elt.t -> 'a Elt.t option

  [@@@ocaml.text " {2 Constant-time insertion of a new element} "]

  val insert_before : 'a t -> 'a Elt.t -> 'a -> 'a Elt.t
  val insert_after : 'a t -> 'a Elt.t -> 'a -> 'a Elt.t
  val insert_first : 'a t -> 'a -> 'a Elt.t
  val insert_last : 'a t -> 'a -> 'a Elt.t

  [@@@ocaml.text
    " {2 Constant-time move of an element from and to positions in the same list}\n\n\
    \      An exception is raised if [elt] is equal to [anchor]. "]

  val move_to_front : 'a t -> 'a Elt.t -> unit
  val move_to_back : 'a t -> 'a Elt.t -> unit
  val move_after : 'a t -> 'a Elt.t -> anchor:'a Elt.t -> unit
  val move_before : 'a t -> 'a Elt.t -> anchor:'a Elt.t -> unit

  [@@@ocaml.text " {2 Constant-time removal of an element} "]

  val remove : 'a t -> 'a Elt.t -> unit
  val remove_first : 'a t -> 'a option
  val remove_last : 'a t -> 'a option
  val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
  val foldi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc

  val fold_elt : 'a t -> init:'acc -> f:('acc -> 'a Elt.t -> 'acc) -> 'acc
  [@@ocaml.doc
    " [fold_elt t ~init ~f] is the same as fold, except [f] is called with the ['a\n\
    \      Elt.t]'s from the list instead of the contained ['a] values.\n\n\
    \      Note that like other iteration functions, it is an error to mutate [t] inside \
     the\n\
    \      fold. If you'd like to call [remove] on any of the ['a Elt.t]'s, use\n\
    \      [filter_inplace]. "]

  val foldi_elt : 'a t -> init:'acc -> f:(int -> 'acc -> 'a Elt.t -> 'acc) -> 'acc
  val iter_elt : 'a t -> f:('a Elt.t -> unit) -> unit
  val iteri_elt : 'a t -> f:(int -> 'a Elt.t -> unit) -> unit
  val fold_right : 'a t -> init:'acc -> f:('a -> 'acc -> 'acc) -> 'acc
  val fold_right_elt : 'a t -> init:'acc -> f:('a Elt.t -> 'acc -> 'acc) -> 'acc

  val find_elt : 'a t -> f:('a -> bool) -> 'a Elt.t option
  [@@ocaml.doc
    " [find_elt t ~f] finds the first element in [t] that satisfies [f], by testing each\n\
    \      of element of [t] in turn until [f] succeeds. "]

  val findi_elt : 'a t -> f:(int -> 'a -> bool) -> (int * 'a Elt.t) option

  val clear : 'a t -> unit
  [@@ocaml.doc " [clear t] removes all elements from the list in constant time. "]

  val copy : 'a t -> 'a t

  val transfer : src:'a t -> dst:'a t -> unit
  [@@ocaml.doc
    " [transfer ~src ~dst] has the same behavior as\n\
    \      [iter src ~f:(insert_last dst); clear src] except that it runs in constant \
     time.\n\n\
    \      If [s = to_list src] and [d = to_list dst], then after [transfer ~src ~dst]:\n\n\
    \      [to_list src = []]\n\n\
    \      [to_list dst = d @ s] "]

  [@@@ocaml.text " {2 Linear-time mapping of lists (creates a new list)} "]

  val map : 'a t -> f:('a -> 'b) -> 'b t
  val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
  val filter : 'a t -> f:('a -> bool) -> 'a t
  val filteri : 'a t -> f:(int -> 'a -> bool) -> 'a t
  val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
  val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t

  [@@@ocaml.text " {2 Linear-time partition of lists (creates two new lists)} "]

  val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t
  val partitioni_tf : 'a t -> f:(int -> 'a -> bool) -> 'a t * 'a t
  val partition_map : 'a t -> f:('a -> ('b, 'c) Either.t) -> 'b t * 'c t
  val partition_mapi : 'a t -> f:(int -> 'a -> ('b, 'c) Either.t) -> 'b t * 'c t

  [@@@ocaml.text " {2 Linear-time in-place mapping of lists} "]

  val map_inplace : 'a t -> f:('a -> 'a) -> unit
  [@@ocaml.doc " [map_inplace t ~f] replaces all values [v] with [f v] "]

  val mapi_inplace : 'a t -> f:(int -> 'a -> 'a) -> unit

  val filter_inplace : 'a t -> f:('a -> bool) -> unit
  [@@ocaml.doc
    " [filter_inplace t ~f] removes all elements of [t] that don't satisfy [f]. "]

  val filteri_inplace : 'a t -> f:(int -> 'a -> bool) -> unit

  val filter_map_inplace : 'a t -> f:('a -> 'a option) -> unit
  [@@ocaml.doc
    " If [f] returns [None], the element is removed, else the value is replaced with the\n\
    \      contents of the [Some] "]

  val filter_mapi_inplace : 'a t -> f:(int -> 'a -> 'a option) -> unit

  val unchecked_iter : 'a t -> f:('a -> unit) -> unit
  [@@ocaml.doc
    " [unchecked_iter t ~f] behaves like [iter t ~f] except that [f] is allowed to modify\n\
    \      [t]. Adding or removing elements before the element currently being visited \
     has no\n\
    \      effect on the traversal. Elements added after the element currently being \
     visited\n\
    \      will be traversed. Elements deleted after the element currently being visited \
     will\n\
    \      not be traversed. Deleting the element currently being visited is an error \
     that is\n\
    \      not detected (presumably leading to an infinite loop). "]

  val to_sequence : 'a t -> 'a Sequence.t
  [@@ocaml.doc
    " A sequence of values from the doubly-linked list. It makes an intermediate copy of\n\
    \      the list so that the returned sequence is immune to any subsequent mutation \
     of the\n\
    \      original list. "]
end

module type Doubly_linked = sig
  module type S = S

  include S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
