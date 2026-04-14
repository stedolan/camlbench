open! Base

type 'a t = { g : 'a }
[@@ocaml.doc
  " A shim to mark non-record fields global. \"GEL\" stands for \"Global Even if inside a\n\
  \    Local\", but is kept short since we'll need this boilerplate a lot.\n\n\
  \    For example, if you have a list:\n\n\
  \    {[\n\
  \      type t = string list\n\
  \    ]}\n\n\
  \    and want to make it local, but still keep the strings global, you can write:\n\n\
  \    {[\n\
  \      type t = string Gel.t list\n\
  \    ]}\n\n\
  \    and it will be so, but with some extra boilerplate when using it.\n\n\
  \    This is for use with existing types that don't have the desired global_ annotation.\n\
  \    If you find yourself reaching for this for a new type you are defining, you can \
   avoid\n\
  \    the boilerplate. For example:\n\n\
  \    {[\n\
  \      type t =\n\
  \        { global_ foo : string\n\
  \        ; bar : int\n\
  \        }\n\n\
  \      type t =\n\
  \        | Foo of global_ string\n\
  \        | Bar of { global_ foo : string; bar : int }\n\
  \        | Baz of global_ string * int * global_ string\n\
  \    ]}\n"]
[@@unboxed]
[@@deriving bin_io, compare, equal, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val create : 'a -> 'a t
val g : 'a t -> 'a
val map : 'a t -> f:('a -> 'b) -> 'b t
val globalize : _ -> 'a t -> 'a t

val drop_some : 'a t option -> 'a option
[@@ocaml.doc
  " Removes a [Gel.t] from inside an option type with zero runtime cost. This is useful\n\
  \    when some other function returns an [X.t Gel.t option], you know [X.t] is\n\
  \    mode-crossing, and you want to drop the inner [Gel.t] without allocating another \
   local\n\
  \    option. "]

val drop_ok : ('a t, 'b) Result.t -> ('a, 'b) Result.t
[@@ocaml.doc " Like [drop_some], but for the [Ok _] branch of a result. "]

val drop_error : ('a, 'b t) Result.t -> ('a, 'b) Result.t
[@@ocaml.doc " Like [drop_some], but for the [Error _] branch of a result. "]

val inject_some : 'a option -> 'a t option
[@@ocaml.doc
  " Treat an existing global option as a local while maintaining the knowledge that the\n\
  \    data inside the option is global. Zero runtime cost.\n\n\
  \    \"Injects some gel between the option and its [Some _] case.\" "]

val inject_ok : ('a, 'b) Result.t -> ('a t, 'b) Result.t
[@@ocaml.doc " Like [inject_some], but for the [Ok _] case of a [result]. "]

val inject_error : ('a, 'b) Result.t -> ('a, 'b t) Result.t
[@@ocaml.doc " Like [inject_some], but for the [Error _] case of a [result]. "]

val inject_result : ('a, 'b) Result.t -> ('a t, 'b t) Result.t
[@@ocaml.doc " Like [inject_some], but for the contents of a [result]. "]
