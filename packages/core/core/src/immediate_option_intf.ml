[@@@ocaml.text " A non-allocating alternative to the standard Option type. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"immediate_option_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "immediate_option_intf.ml.before-ppx"
;;

open! Import

module type S_without_immediate_plain = sig
  type value
  [@@ocaml.doc
    " The immediate value carried by the immediate option.\n\n\
    \      Given the presence of {!unchecked_value}, the [value] type should not have\n\
    \      operations that depend on the value's validity for memory safety.  In \
     particular,\n\
    \      [unchecked_value] is not called [unsafe_value] as it would be if it could \
     return a\n\
    \      value that later resulted in a segmentation fault.  For pointer-like values, \
     use\n\
    \      {!Ext.Nullable}, for example. "]

  type t
  [@@ocaml.doc
    " Represents [value option] without allocating a [Some] tag. The interface does not\n\
    \      enforce that [t] is immediate because some types, like [Int63.t], are only \
     immediate\n\
    \      on 64-bit platforms. For representations whose type is immediate, use [S] below\n\
    \      which adds the [[@@immediate]] annotation. "]

  [@@@ocaml.text
    " Constructors analogous to [None] and [Some].  If [not (some_is_representable x)]\n\
    \      then [some x] may raise or return [none]. "]

  val none : t
  val some : value -> t

  val some_is_representable : value -> bool
  [@@ocaml.doc
    " For some representations of immediate options, the encodings of [none] and [some]\n\
    \      overlap.  For these representations, [some_is_representable value = false] if\n\
    \      [value] cannot be represented as an option.  For example, [Int.Option] uses\n\
    \      [min_value] to represent [none].  For other representations, \
     [some_is_representable]\n\
    \      always returns [true]. "]

  val is_none : t -> bool
  val is_some : t -> bool

  val value : t -> default:value -> value
  [@@ocaml.doc " [value (some x) ~default = x] and [value none ~default = default]. "]

  val value_exn : t -> value
  [@@ocaml.doc
    " [value_exn (some x) = x].  [value_exn none] raises.  Unlike [Option.value_exn],\n\
    \      there is no [?message] argument, so that calls to [value_exn] that do not raise\n\
    \      also do not have to allocate. "]

  val unchecked_value : t -> value
  [@@ocaml.doc
    " [unchecked_value (some x) = x].  [unchecked_value none] returns an unspecified\n\
    \      value.  [unchecked_value t] is intended as an optimization of [value_exn t] \
     when\n\
    \      [is_some t] is known to be true. "]

  val to_option : t -> value option
  val of_option : value option -> t

  module Optional_syntax : Optional_syntax.S with type t := t with type value := value
end

module type S_without_immediate = sig
  type t [@@deriving compare, hash, sexp_of, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S_without_immediate_plain with type t := t
end

module type S_plain = sig
  type t [@@immediate]

  include S_without_immediate_plain with type t := t
end

module type S = sig
  type t [@@immediate]

  include S_without_immediate with type t := t
end

module type S_int63 = sig
  type t [@@immediate64]

  include S_without_immediate with type t := t
end

module type S_int63_plain = sig
  type t [@@immediate64]

  include S_without_immediate_plain with type t := t
end

module type Immediate_option = sig
  module type S = S [@@ocaml.doc " Always immediate. "]

  module type S_plain = S_plain

  module type S_int63 = S_int63 [@@ocaml.doc " Immediate only on 64-bit machines. "]

  module type S_int63_plain = S_int63_plain

  module type S_without_immediate = S_without_immediate [@@ocaml.doc " Never immediate. "]

  module type S_without_immediate_plain = S_without_immediate_plain
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
