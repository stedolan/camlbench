let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"enum_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "enum_intf.ml.before-ppx"
;;

open! Base

module type Sexp_of = sig
  type t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Single = sig
  [@@@ocaml.text
    " These functions take single values of ['a] instead of enumerating all of them. "]

  type 'a t

  val to_string_hum : 'a t -> 'a -> string
  [@@ocaml.doc
    " Map a constructor name to a command-line string: downcase the name and convert [_] \
     to\n\
    \      [-]. "]

  val check_field_name : 'a t -> 'a -> (_, _, _) Field.t_with_perm -> unit
end

module type S = Command.Enumerable_sexpable
module type S_to_string = Command.Enumerable_stringable

module type Enum = sig
  module type S = S

  type 'a t = (module S with type t = 'a)

  include Single with type 'a t := 'a t

  val enum : 'a t -> (string * 'a) list
  val assert_alphabetic_order_exn : Source_code_position.t -> 'a t -> unit

  type ('a, 'b) make_param =
    ?case_sensitive:bool
    -> ?represent_choice_with:
         (string
         [@ocaml.doc
           " If [represent_choice_with] is not passed, the documentation will be:\n\n\
           \        {v\n\
           \          -flag (choice1|choice2|...)     [doc]\n\
           \        v}\n\n\
           \        If there are many choices, this can cause this and other flags to \
            have the\n\
           \        documentation aligned very far to the right. To avoid that, the\n\
           \        [represent_choice_with] flag can be passed as a shorter reference to \
            the possible\n\
           \        choices. Example:\n\n\
           \        {v\n\
           \          -flag CHOICE     [doc], CHOICE can be (choice1|choice2|...)\n\
           \        v}\n\n\
           \        [Command] does a much better job of aligning this.\n\
           \    "])
    -> ?list_values_in_help:bool
    -> ?aliases:string list
    -> ?key:'a Univ_map.Multi.Key.t
    -> string
    -> doc:string
    -> 'a t
    -> 'b Command.Param.t

  val make_param : f:('a Command.Arg_type.t -> 'b Command.Flag.t) -> ('a, 'b) make_param

  val make_param_one_of_flags
    :  ?if_nothing_chosen:
         (('a, 'a) Command.Param.If_nothing_chosen.t[@ocaml.doc " Default: Raise "])
    -> ?aliases:('a -> string list)
    -> doc:('a -> string)
    -> 'a t
    -> 'a Command.Param.t

  val make_param_optional_with_default_doc : default:'a -> ('a, 'a) make_param

  val make_param_optional_comma_separated
    :  ?allow_empty:bool
    -> ?strip_whitespace:bool
    -> ?unique_values:bool
    -> ('a, 'a list option) make_param

  val make_param_optional_comma_separated_with_default_doc
    :  ?allow_empty:bool
    -> ?strip_whitespace:bool
    -> ?unique_values:bool
    -> default:'a list
    -> ('a, 'a list) make_param

  val arg_type
    :  ?case_sensitive:bool
    -> ?key:'a Univ_map.Multi.Key.t
    -> ?list_values_in_help:bool
    -> 'a t
    -> 'a Command.Arg_type.t

  val command_friendly_name : string -> string
  [@@ocaml.doc
    " Transform a string to be accepted by [Command]. This is the transformation that is\n\
    \      applied throughout this module.\n\n\
    \      The transformations are:\n\
    \      + Single quotes get removed (since it's annoying to have to quote them when \
     running\n\
    \      commands manually)\n\
    \      + Underscores get turned into dashes (just to hopefully have a uniform \
     convention\n\
    \      between the two)\n\
    \      + Other characters get lowercased\n\n\
    \      Note that this is *not* actually a complete list of transformations needed to \
     make\n\
    \      an arbitrary string \"command-friendly\": for example, double quotes are left\n\
    \      alone. This is because the expectation is that the string came from something \
     like a\n\
    \      [[@@deriving sexp]] on a variant type, and while single quotes can appear in \
     ocaml\n\
    \      variants, double quotes cannot. "]

  module Make_stringable : functor (M : S) -> Stringable.S with type t := M.t
  [@@ocaml.doc
    " Defines [to_string] and [of_string] functions for [M], based on [M.sexp_of_t] and\n\
    \      [M.all]. The sexp representation of [M.t] must be a sexp atom. "]

  module Make_of_string : functor (M : S_to_string) -> sig
    val of_string : String.t -> M.t
  end
  [@@ocaml.doc
    " Defines an [of_string] function for [M], using [M.all] and [M.to_string]. Does not\n\
    \      require [M] to be sexpable. "]

  module Make_to_string : functor (M : Sexp_of) -> sig
    val to_string : M.t -> String.t
  end
  [@@ocaml.doc
    " Defines [to_string] for [M], based on [M.sexp_of_t]. The sexp representation of\n\
    \      [M.t] must be a sexp atom. "]

  module Single : sig
    module type S = Sexp_of

    type 'a t = (module S with type t = 'a)

    include Single with type 'a t := 'a t
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
