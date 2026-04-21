[@@@ocaml.text
  " [module Flags] implements Unix-style sets of flags that are represented as an [int]\n\
  \    with various bits set, one bit for each flag.  E.g. [Linux_ext.Epoll.Flag].\n\n\
  \    [Flags] defines a module type [Flags.S], the interface for a flags, and a functor\n\
  \    [Flags.Make] for creating a flags implementation. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"flags_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "flags_intf.ml.before-ppx"
;;

open! Core

module type S = sig
  type t [@@deriving sexp, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t [@@ocaml.doc " consistent with subset "]

  val to_flag_list : t -> t * string list
  val of_int : int -> t
  val to_int_exn : t -> int
  val empty : t

  val ( + ) : t -> t -> t [@@ocaml.doc " set union, bitwise or "]

  val ( - ) : t -> t -> t
  [@@ocaml.doc
    " set difference.  Although we use operators [+] and [-], they do not satisfy the\n\
    \      usual arithmetic equations, e.g. [x - y = x + (empty - y)] does not hold. "]

  val intersect : t -> t -> t [@@ocaml.doc " bitwise and "]

  val complement : t -> t [@@ocaml.doc " bitwise not "]

  val is_empty : t -> bool
  val do_intersect : t -> t -> bool
  val are_disjoint : t -> t -> bool

  val is_subset : t -> of_:t -> bool
  [@@ocaml.doc " [is_subset t ~of_] is [t = intersect t of_] "]

  module Unstable : sig
    type nonrec t = t [@@deriving bin_io, compare, equal, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
[@@ocaml.doc
  " [module type S] is the interface for a set of flags.  Values of [type t] are set of\n\
  \    flags, and the various functions operate on sets of flags.  There is a finite \
   universe\n\
  \    of flags (in particular 63 flags, one for each bit).\n\n\
  \    [sexp_of_t] and [t_of_sexp] use the flag names supplied to [Flags.Make]. "]

module type S_binable = sig
  type t [@@deriving bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S with type t := t
end
[@@ocaml.doc " Same as [module type S], but [type t] is binable. "]

module type Make_arg = sig
  val known : (Int63.t * string) list
  [@@ocaml.doc
    " An entry [flag, name] in [known] means that the bit(s) in [flag] is (are) called\n\
    \      [name]; i.e. if [bit_and flags flag = flag], then the bit(s) is (are) set and \
     [name]\n\
    \      will appear in [sexp_of_t flags].  [known] is only used to make [sexp_of_t]'s \
     output\n\
    \      human readable.\n\n\
    \      The flags in the output of [sexp_of_t] will occur in the same order as they \
     appear\n\
    \      in [known].\n\n\
    \      It is allowed to have a single flag with multiple bits set.\n\n\
    \      It is an error if different flags intersect, and [allow_intersecting = \
     false]. "]

  val remove_zero_flags : bool
  [@@ocaml.doc
    " If [remove_zero_flags], then all flags with value zero will be automatically removed\n\
    \      from [known].  If [not remove_zero_flags], then it is an error for [known] to \
     contain\n\
    \      any flags with value zero.\n\n\
    \      About this existence of this option: it seems better to make it an option here\n\
    \      rather than do the filtering at the functor call site.  It also makes clear to\n\
    \      callers that they need to think about zero flags, and clear what they can do \
     if they\n\
    \      encounter them. "]

  val allow_intersecting : bool
  [@@ocaml.doc
    " [allow_intersecting] says whether to allow intersecting [known] flags.  It is\n\
    \      common to do [allow_intersecting = false], however in some situations, e.g.\n\
    \      Unix open flags, the flags intersect. "]

  val should_print_error : bool
  [@@ocaml.doc
    " [should_print_error] says whether to print an error message if there is an error in\n\
    \      the known flags.  It is typical to use [should_print_error = true] because\n\
    \      [Flags.Make] is applied at the module level, where the exception raised isn't\n\
    \      displayed nicely. "]
end

module type Flags = sig
  module type Make_arg = Make_arg
  module type S = S
  module type S_binable = S_binable

  val create : bit:int -> Int63.t
  [@@ocaml.doc
    " [create ~bit:n] creates a flag with the [n]th bit set.  [n] must be between 0 and\n\
    \      62.\n\n\
    \      Typically a flag has one bit set; [create] is useful in exactly those cases.  \
     For\n\
    \      flags with multiple bits one can either define the Int63.t directly or create \
     it in\n\
    \      terms of simpler flags, using [+] and [-]. "]

  module Make : functor (M : Make_arg) -> S with type t = Int63.t
  [@@ocaml.doc
    " [Flags.Make] builds a new flags module.  If there is an error in the [known] flags,\n\
    \      it behaves as per [on_error].\n\n\
    \      We expose [type t = int] in the result of [Flags.Make] so that one can easily \
     use\n\
    \      flag constants as values of the flag type without having to coerce them.  It is\n\
    \      typical to hide the [t = int] in another signature [S]. "]

  module Make_binable : functor (M : Make_arg) -> S_binable with type t = Int63.t
  [@@ocaml.doc " Similar to [Flags.Make], but the resulting [type t] is binable. "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
