open Core

type 'a t = ( :: ) of 'a * 'a list
[@@ocaml.doc
  " A ['a t] represents a non-empty list, as evidenced by the fact that there is no [[]]\n\
  \    variant. The sexp representation is as a regular list (i.e., the same as the\n\
  \    [Stable.V3] module below).\n\n\
  \    For operations on a locally allocated ['a t], see [Local_nonempty_list].\n"]
[@@deriving
  compare, equal, sexp, sexp_grammar, hash, quickcheck, typerep, bin_io, globalize]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t

  val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
  include Bin_prot.Binable.S1 with type 'a t := 'a t

  val globalize : ('a -> 'a) -> 'a t -> 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Comparator.Derived with type 'a t := 'a t
include Container.S1 with type 'a t := 'a t
include Invariant.S1 with type 'a t := 'a t
include Monad.S_local with type 'a t := 'a t
include Indexed_container.S1 with type 'a t := 'a t

val create : 'a -> 'a list -> 'a t
val init : int -> f:(int -> 'a) -> 'a t
val of_list : 'a list -> 'a t option
val of_list_error : 'a list -> 'a t Or_error.t
val of_list_exn : 'a list -> 'a t
val singleton : 'a -> 'a t
val cons : 'a -> 'a t -> 'a t
val hd : 'a t -> 'a
val tl : 'a t -> 'a list
val nth : 'a t -> int -> 'a option
val nth_exn : 'a t -> int -> 'a
val reduce : 'a t -> f:('a -> 'a -> 'a) -> 'a
val reverse : 'a t -> 'a t
val append : 'a t -> 'a list -> 'a t
val unzip : ('a * 'b) t -> 'a t * 'b t
val zip : 'a t -> 'b t -> ('a * 'b) t List.Or_unequal_lengths.t
val zip_exn : 'a t -> 'b t -> ('a * 'b) t
val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t List.Or_unequal_lengths.t
val map2_exn : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
val filter : 'a t -> f:('a -> bool) -> 'a list
val filteri : 'a t -> f:(int -> 'a -> bool) -> 'a list
val filter_map : 'a t -> f:('a -> 'b option) -> 'b list
val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b list
val concat : 'a t t -> 'a t
val concat_map : 'a t -> f:('a -> 'b t) -> 'b t
val last : 'a t -> 'a
val drop_last : 'a t -> 'a list
val to_sequence : 'a t -> 'a Sequence.t
val sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
val stable_sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
val dedup_and_sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
val permute : ?random_state:Random.State.t -> 'a t -> 'a t
val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
val cartesian_product : 'a t -> 'b t -> ('a * 'b) t
val fold_nonempty : 'a t -> init:('a -> 'acc) -> f:('acc -> 'a -> 'acc) -> 'acc
val fold_right : 'a t -> init:'b -> f:('a -> 'b -> 'b) -> 'b
val folding_map : 'a t -> init:'b -> f:('b -> 'a -> 'b * 'c) -> 'c t
val fold_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

val min_elt' : 'a t -> compare:('a -> 'a -> int) -> 'a
[@@ocaml.doc
  " [min_elt'] and [max_elt'] differ from [min_elt] and [max_elt] (included in\n\
  \    [Container.S1]) in that they don't return options. "]

val max_elt' : 'a t -> compare:('a -> 'a -> int) -> 'a

val map_add_multi : ('k, 'v t, 'cmp) Map.t -> key:'k -> data:'v -> ('k, 'v t, 'cmp) Map.t
[@@ocaml.doc
  " Like [Map.add_multi], but comes with a guarantee that the range of the returned map is\n\
  \    all nonempty lists.\n"]

val map_of_alist_multi
  :  ('k * 'v) list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t
[@@ocaml.doc
  " Like [Map.of_alist_multi], but comes with a guarantee that the range of the returned\n\
  \    map is all nonempty lists.\n"]

val map_of_sequence_multi
  :  ('k * 'v) Sequence.t
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t
[@@ocaml.doc
  " Like [Map.of_sequence_multi], but comes with a guarantee that the range of the\n\
  \    returned map is all nonempty lists.\n"]

val map_of_list_with_key_multi
  :  'v list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> get_key:('v -> 'k)
  -> ('k, 'v t, 'cmp) Map.t
[@@ocaml.doc
  " Like [Map.of_list_with_key_multi], but comes with a guarantee that the range of the\n\
  \    returned map is all nonempty lists.\n"]

val combine_errors : ('ok, 'err) Result.t t -> ('ok t, 'err t) Result.t
[@@ocaml.doc " Like [Result.combine_errors] but for non-empty lists "]

val combine_errors_unit : (unit, 'err) Result.t t -> (unit, 'err t) Result.t
[@@ocaml.doc " Like [Result.combine_errors_unit] but for non-empty lists "]

val combine_or_errors : 'a Or_error.t t -> 'a t Or_error.t
[@@ocaml.doc " Like [Or_error.combine_errors] but for non-empty lists "]

val combine_or_errors_unit : unit Or_error.t t -> unit Or_error.t
[@@ocaml.doc " Like [Or_error.combine_errors_unit] but for non-empty lists "]

val validate_indexed : 'a Validate.check -> 'a t Validate.check
[@@ocaml.doc
  " validates a list, naming each element by its position in the list (where the first\n\
  \    position is 1, not 0). "]

val validate : name:('a -> string) -> 'a Validate.check -> 'a t Validate.check
[@@ocaml.doc
  " validates a list, naming each element using a user-defined function for computing the\n\
  \    name. "]

val flag : 'a Command.Param.Arg_type.t -> 'a t Command.Flag.t
[@@ocaml.doc
  " Returns a flag that must be passed one or more times.\n\
  \    See [Command.Param.one_or_more_as_pair]. "]

val comma_separated_argtype
  :  ?key:'a t Univ_map.Multi.Key.t
  -> ?strip_whitespace:bool
  -> ?unique_values:bool
  -> 'a Command.Param.Arg_type.t
  -> 'a t Command.Param.Arg_type.t
[@@ocaml.doc
  " Accepts comma-separated lists of arguments parsed by [t].\n\
  \    See [Command.Param.Arg_type.comma_separated]. "]

type 'a nonempty_list := 'a t

module Option : sig
  type 'a t = 'a list
  [@@deriving compare, equal, sexp, sexp_grammar, hash, quickcheck, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
    include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  [@@@ocaml.text " Constructors analogous to [None] and [Some]. "]

  val none : _ t
  val some : 'a nonempty_list -> 'a t
  val is_none : _ t -> bool
  val is_some : _ t -> bool

  val value : 'a t -> default:'a nonempty_list -> 'a nonempty_list
  [@@ocaml.doc " [value (some x) ~default = x] and [value none ~default = default]. "]

  val value_exn : 'a t -> 'a nonempty_list
  [@@ocaml.doc
    " [value_exn (some x) = x].  [value_exn none] raises.  Unlike [Option.value_exn],\n\
    \      there is no [?message] argument, so that calls to [value_exn] that do not raise\n\
    \      also do not have to allocate. "]

  val unchecked_value : 'a t -> 'a nonempty_list
  [@@ocaml.doc
    " [unchecked_value (some x) = x].  [unchecked_value none] returns an unspecified\n\
    \      value.  [unchecked_value t] is intended as an optimization of [value_exn t] \
     when\n\
    \      [is_some t] is known to be true. "]

  val to_option : 'a t -> 'a nonempty_list option
  val of_option : 'a nonempty_list option -> 'a t

  module Optional_syntax :
    Optional_syntax.S1 with type 'a t := 'a t and type 'a value := 'a nonempty_list
end
[@@ocaml.doc
  " This module provides 0-alloc versions of [to_list] and [of_list], via [some] and\n\
  \    allowing you to [match%optional] on a list, respectively. "]

module Reversed : sig
  type 'a t = ( :: ) of 'a * 'a Reversed_list.t

  val cons : 'a -> 'a t -> 'a t
  val to_rev_list : 'a t -> 'a Reversed_list.t
  val rev : 'a t -> 'a nonempty_list
  val rev_append : 'a t -> 'a list -> 'a nonempty_list
  val rev_map : 'a t -> f:('a -> 'b) -> 'b nonempty_list
  val rev_mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b nonempty_list

  module With_sexp_of : sig
    type nonrec 'a t = 'a t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Renders sexps without reversing the list. E.g. [1::2] is represented as [(1 2)]. "]

  module With_rev_sexp_of : sig
    type nonrec 'a t = 'a t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Renders sexps after reversing the list. E.g. [1::2] is represented as [(2 1)]. "]
end
[@@ocaml.doc " a non-empty version of Reversed_list.t "]

val rev' : 'a t -> 'a Reversed.t
val rev_append : 'a Reversed_list.t -> 'a t -> 'a t

module Unstable : sig
  type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Stable : sig
  module V3 : sig
    type nonrec 'a t = 'a t
    [@@deriving bin_io, compare, equal, sexp, sexp_grammar, hash, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Represents a [t] as an ordinary list for sexp and bin_io conversions, e.g. [1::2]\n\
    \      is represented as [(1 2)]. "]

  module V2 : sig
    type nonrec 'a t = 'a t
    [@@deriving bin_io, compare, equal, sexp, hash, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Represents a [t] as an ordinary list for sexp conversions, but uses a record [{hd :\n\
    \      'a; tl ; 'a list}] for bin_io conversions. "]

  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving bin_io, compare, equal, sexp, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Represents a [t] as an ordinary list for sexps, but as a pair for bin_io conversions\n\
    \      (i.e., a ['a t] is represented as the type ['a * 'a list]). "]
end
