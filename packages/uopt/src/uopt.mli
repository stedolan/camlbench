[@@@ocaml.text
  " [Uopt.t] is an unboxed option: an [option]-like type that incurs no allocation,\n\
  \    without requiring a reserved value in the underlying type.\n\n\
  \    The downsides compared to [option] are that:\n\
  \    - [Uopt.t] cannot be nested, i.e. used as ['a Uopt.t Uopt.t], because trying to\n\
  \      create [Uopt.some Uopt.none] is not supported and would raise.\n\
  \    - it is unsafe to have values of type [float Uopt.t array], or any type which has \
   the\n\
  \      same memory representation, since the representation of the array would vary\n\
  \      depending on whether [none] or [some] is used to create the array.\n\
  \      Using [float Uopt.t Uniform_array.t] is fine.\n\
  \    - the implementation has unsafe code which has resulted in miscompilation in the \
   past.\n\n\
  \    As a result, we advise against using this in systems that are not high \
   performance.\n\n\
  \    When using Uopt, we recommend:\n\
  \    - not exposing Uopt in APIs for casual users, so you don't force other people to \
   learn\n\
  \      about this unnecessarily.\n\
  \    - not giving values of type [Uopt.t] (whether the type is abstract or not) to other\n\
  \      APIs, so they are free to use Uopt internally (and also for memory safety in the\n\
  \      cause of [float Uopt.t]).\n\
  \    - not returning values of type [Uopt.t] from your libraries when the type is \
   abstract,\n\
  \      so callers are free to use [Uopt.t] on abstract types. Returning explicit \
   [Uopt.t]\n\
  \      can be fine, although turning a type that's not Uopt into a type that is could \
   break\n\
  \      code.\n\n\
  \    Since ['a Uopt.t] is abstract, manipulation of an ['a Uopt.t array] does runtime\n\
  \    checks to see if this is a float array. This can be mostly avoided with\n\
  \    [Uniform_array.t], although array creation will still do such checks, and you may \
   want\n\
  \    to use the [set_with_caml_modify] kind of function to skip the immediacy checks. "]

open! Base

type +'a t [@@deriving sexp, globalize]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S1 with type +'a t := 'a t

  val globalize : ('a -> 'a) -> 'a t -> 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Invariant.S1 with type 'a t := 'a t

val none : _ t
val some : 'a -> 'a t
val is_none : _ t -> bool
val is_some : _ t -> bool
val value_exn : 'a t -> 'a
val value : 'a t -> default:'a -> 'a
val some_if : bool -> 'a -> 'a t

val unsafe_value : 'a t -> 'a
[@@ocaml.doc " It is safe to call [unsafe_value t] iff [is_some t]. "]

val to_option : 'a t -> 'a option
val of_option : 'a option -> 'a t

module Optional_syntax : sig
  module Optional_syntax : sig
    val is_none : _ t -> bool
    val unsafe_value : 'a t -> 'a
  end
end

module Local : sig
  val some : 'a -> 'a t
  val value : 'a t -> default:'a -> 'a
  val some_if : bool -> 'a -> 'a t
  val unsafe_value : 'a t -> 'a
  val to_option : 'a t -> 'a option
  val of_option : 'a option -> 'a t

  module Optional_syntax : sig
    module Optional_syntax : sig
      val is_none : _ t -> bool
      val unsafe_value : 'a t -> 'a
    end
  end
end
[@@ocaml.doc " Same as their global equivalents. "]
