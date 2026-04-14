[@@@ocaml.text
  " Purely functional command line parsing.\n\n\
  \    Here is a simple example:\n\n\
  \    {[\n\
  \      let () =\n\
  \        let open Command.Let_syntax in\n\
  \        Command.basic\n\
  \          ~summary:\"cook eggs\"\n\
  \          (let%map_open num_eggs =\n\
  \             flag \"num-eggs\" (required int) ~doc:\"COUNT cook this many eggs\"\n\
  \           and style =\n\
  \             flag \"style\" (required (Arg_type.create Egg_style.of_string))\n\
  \               ~doc:\"OVER-EASY|SUNNY-SIDE-UP style of eggs\"\n\
  \           and recipient =\n\
  \             anon (\"recipient\" %: string)\n\
  \           in\n\
  \           fun () ->\n\
  \             (* TODO: implement egg-cooking in ocaml *)\n\
  \             failwith \"no eggs today\")\n\
  \        |> Command.run\n\
  \    ]}\n\n\
  \    {b Note}: {{!Core.Command.Param}[Command.Param]} has replaced\n\
  \    {{!Core.Command.Spec}[Command.Spec] (DEPRECATED)} and should be used in all new\n\
  \    code. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"command_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "command_intf.ml.before-ppx"
;;

open! Base
open! Import

type env =
  [ `Replace of (string * string) list
  | `Extend of (string * string) list
  | `Override of (string * string option) list
  | `Replace_raw of string list
  ]

module type Version_util = sig
  module Time : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val version_list : string list
  val reprint_build_info : (Time.t -> Sexp.t) -> string
end

module type For_unix = sig
  type env_var

  module Version_util : Version_util

  module Pid : sig
    type t

    val to_int : t -> int
  end

  module Signal : sig
    type t
  end

  module Thread : sig
    type t

    val create
      :  on_uncaught_exn:[ `Kill_whole_process | `Print_to_stderr ]
      -> ('a -> unit)
      -> 'a
      -> t

    val join : t -> unit
  end

  module Unix : sig
    module File_descr : sig
      type t
    end

    val getpid : unit -> Pid.t
    val close : ?restart:bool -> File_descr.t -> unit
    val in_channel_of_descr : File_descr.t -> In_channel.t
    val putenv : key:env_var -> data:string -> unit
    val unsetenv : env_var -> unit
    val unsafe_getenv : env_var -> string option

    type env :=
      [ `Replace of (env_var * string) list
      | `Extend of (env_var * string) list
      | `Override of (env_var * string option) list
      | `Replace_raw of string list
      ]

    val exec
      :  prog:string
      -> argv:string list
      -> ?use_path:bool
      -> ?env:env
      -> unit
      -> Nothing.t

    module Process_info : sig
      type t =
        { pid : Pid.t
        ; stdin : File_descr.t
        ; stdout : File_descr.t
        ; stderr : File_descr.t
        }
    end

    val create_process_env
      :  ?working_dir:string
      -> ?prog_search_path:string list
      -> ?argv0:string
      -> prog:string
      -> args:string list
      -> env:env
      -> unit
      -> Process_info.t

    val wait : Pid.t -> unit
  end
end
[@@ocaml.doc
  " [For_unix] is the subset of Core's interface that [Command] needs, in particular to\n\
  \    implement the [shape] and [run] functions.  [Core.Private.Command] is a functor\n\
  \    taking a module matching [For_unix] and is applied in Core to construct\n\
  \    [Core.Command].  We use a functor in this way so that [Command]'s internal data\n\
  \    types can remain hidden. "]

module type Enumerable_sexpable = sig
  type t [@@deriving enumerate, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_enumerate_lib.Enumerable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Enumerable_stringable = sig
  type t [@@deriving enumerate]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_enumerate_lib.Enumerable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string : t -> string
end

module type Command = sig
  module type Enumerable_sexpable = Enumerable_sexpable
  module type Enumerable_stringable = Enumerable_stringable

  module Auto_complete : sig
    type t = Univ_map.t -> part:string -> string list
    [@@ocaml.doc
      " In addition to the argument prefix, an auto-completion spec has access to any\n\
      \        previously parsed arguments in the form of a heterogeneous map into which \
       those\n\
      \        arguments may register themselves by providing a [Univ_map.Multi.Key] \
       using the\n\
      \        [~key] argument to [Arg_type.create]. "]

    module For_escape : sig
      type t = Univ_map.t -> part:string list -> string list
      [@@ocaml.doc
        " For the [escape] flag, it's more useful if the auto-completion spec has access\n\
        \          to all past arguments after the flag, hence the [part:string list] \
         argument. "]
    end
  end
  [@@ocaml.doc " Specifications for command-line auto-completion. "]

  module Arg_type : sig
    type 'a t [@@ocaml.doc " The type of a command line argument. "]

    val create
      :  ?complete:Auto_complete.t
      -> ?key:'a Univ_map.Multi.Key.t
      -> (string -> 'a)
      -> 'a t
    [@@ocaml.doc
      " An argument type includes information about how to parse values of that type from\n\
      \        the command line, and (optionally) how to autocomplete partial arguments \
       of that\n\
      \        type via bash's programmable tab-completion.\n\n\
      \        If the [of_string] function raises an exception, command line parsing \
       will be\n\
      \        aborted and the exception propagated up to top-level and printed along with\n\
      \        command-line help. "]

    val parse : 'a t -> string -> 'a Or_error.t
    [@@ocaml.doc
      " Apply the parse function to the given string the same way it would apply to an\n\
      \        argument, catching any exceptions thrown. "]

    val map : ?key:'b Univ_map.Multi.Key.t -> 'a t -> f:('a -> 'b) -> 'b t
    [@@ocaml.doc " Transforms the result of a [t] using [f]. "]

    val of_lazy : ?key:'a Univ_map.Multi.Key.t -> 'a t Lazy.t -> 'a t
    [@@ocaml.doc " Defers construction of the arg type until it is needed. "]

    val of_map
      :  ?accept_unique_prefixes:
           (bool
           [@ocaml.doc
             " Defaults to [true]. Automatically parses a prefix of a valid key if it's\n\
             \          unambiguous. "])
      -> ?case_sensitive:
           (bool
           [@ocaml.doc
             " Defaults to [true]. If [false], map keys must all be distinct when \
              lowercased."])
      -> ?list_values_in_help:
           (bool
           [@ocaml.doc
             " Defaults to [true]. If you set it to false the accepted values won't be \
              listed\n\
             \          in the command help. "])
      -> ?auto_complete:
           (Auto_complete.t
           [@ocaml.doc
             " Defaults to bash completion on the string prefix. This allows users to \
              specify\n\
             \          arbitrary auto-completion for [t]. "])
      -> ?key:'a Univ_map.Multi.Key.t
      -> 'a Map.M(String).t
      -> 'a t
    [@@ocaml.doc " An auto-completing [Arg_type] over a finite set of values. "]

    val of_alist_exn
      :  ?accept_unique_prefixes:bool
      -> ?case_sensitive:
           (bool
           [@ocaml.doc
             " Defaults to [true]. If [false], map keys must all be distinct when \
              lowercased."])
      -> ?list_values_in_help:(bool[@ocaml.doc " default: true "])
      -> ?auto_complete:Auto_complete.t
      -> ?key:'a Univ_map.Multi.Key.t
      -> (string * 'a) list
      -> 'a t
    [@@ocaml.doc " Convenience wrapper for [of_map]. Raises on duplicate keys. "]

    val enumerated
      :  ?accept_unique_prefixes:bool
      -> ?case_sensitive:
           (bool
           [@ocaml.doc
             " Defaults to [true]. If [false], map keys must all be distinct when \
              lowercased."])
      -> ?list_values_in_help:(bool[@ocaml.doc " default: true "])
      -> ?auto_complete:Auto_complete.t
      -> ?key:'a Univ_map.Multi.Key.t
      -> (module Enumerable_stringable with type t = 'a)
      -> 'a t
    [@@ocaml.doc
      " Convenience wrapper for [of_alist_exn] to use with [ppx_enumerate] using\n\
      \        [to_string]. Raises on duplicate [to_string]ed values. "]

    val enumerated_sexpable
      :  ?accept_unique_prefixes:bool
      -> ?case_sensitive:
           (bool
           [@ocaml.doc
             " Defaults to [true]. If [false], map keys must all be distinct when \
              lowercased."])
      -> ?list_values_in_help:(bool[@ocaml.doc " default: true "])
      -> ?auto_complete:Auto_complete.t
      -> ?key:'a Univ_map.Multi.Key.t
      -> (module Enumerable_sexpable with type t = 'a)
      -> 'a t
    [@@ocaml.doc
      " Convenience wrapper for [of_alist_exn] to use with [ppx_enumerate] using\n\
      \        [sexp_of_t] to turn the value into a string. Raises on duplicate \
       [to_string]ed\n\
      \        values. "]

    val comma_separated
      :  ?allow_empty:(bool[@ocaml.doc " default: [false] "])
      -> ?key:'a list Univ_map.Multi.Key.t
      -> ?strip_whitespace:(bool[@ocaml.doc " default: [false] "])
      -> ?unique_values:(bool[@ocaml.doc " default: [false] "])
      -> 'a t
      -> 'a list t
    [@@ocaml.doc
      " [comma_separated t] accepts comma-separated lists of arguments parsed by [t].\n\n\
      \        If [strip_whitespace = true], whitespace is stripped from each \
       comma-separated\n\
      \        string before it is parsed by [t].\n\n\
      \        If [allow_empty = true] then the empty string (or just whitespace, if\n\
      \        [strip_whitespace = true]) results in an empty list, and if [allow_empty \
       = false]\n\
      \        then the empty string will fail to parse. (Note that there is currently \
       no way for\n\
      \        [comma_separated] to produce a list whose only element is the empty \
       string.)\n\n\
      \        If [unique_values = true] no autocompletion will be offered for arguments \
       already\n\
      \        supplied in the fragment to complete. "]

    module Export : sig
      val string : string t

      val int : int t
      [@@ocaml.doc
        " Beware that an anonymous argument of type [int] cannot be specified as negative,\n\
        \          as it is ambiguous whether -1 is a negative number or a flag.  (The \
         same applies\n\
        \          to [float], [time_span], etc.)  You can use the special built-in \
         \"-anon\" flag to\n\
        \          force a string starting with a hyphen to be interpreted as an \
         anonymous argument\n\
        \          rather than as a flag, or you can just make it a parameter to a flag \
         to avoid the\n\
        \          issue. "]

      val char : char t
      val float : float t
      val bool : bool t
      val sexp : Sexp.t t
      val sexp_conv : ?complete:Auto_complete.t -> (Sexp.t -> 'a) -> 'a t
    end
    [@@ocaml.doc " Values to include in other namespaces. "]

    val auto_complete : _ t -> Auto_complete.t
  end
  [@@ocaml.doc " Argument types. "]

  module Flag : sig
    type 'a t

    val required : 'a Arg_type.t -> 'a t
    [@@ocaml.doc " Required flags must be passed exactly once. "]

    val optional : 'a Arg_type.t -> 'a option t
    [@@ocaml.doc " Optional flags may be passed at most once. "]

    val optional_with_default : 'a -> 'a Arg_type.t -> 'a t
    [@@ocaml.doc
      " [optional_with_default] flags may be passed at most once, and default to a given\n\
      \        value. "]

    val listed : 'a Arg_type.t -> 'a list t
    [@@ocaml.doc " [listed] flags may be passed zero or more times. "]

    val one_or_more_as_pair : 'a Arg_type.t -> ('a * 'a list) t
    [@@ocaml.doc " [one_or_more_as_pair] flags must be passed one or more times. "]

    val one_or_more_as_list : 'a Arg_type.t -> 'a list t
    [@@ocaml.doc " Like [one_or_more_as_pair], but returns the flag values as a list. "]

    val no_arg : bool t
    [@@ocaml.doc
      " [no_arg] flags may be passed at most once.  The boolean returned is true iff the\n\
      \        flag is passed on the command line. "]

    val no_arg_register : key:'a Univ_map.With_default.Key.t -> value:'a -> bool t
    [@@ocaml.doc
      " [no_arg_register ~key ~value] is like [no_arg], but associates [value] with [key]\n\
      \        in the autocomplete environment. "]

    val no_arg_some : 'a -> 'a option t
    [@@ocaml.doc
      " [no_arg_some value] is like [no_arg], but will return [Some value] if the flag is\n\
      \        passed on the command line, and return [None] otherwise. "]

    val no_arg_required : 'a -> 'a t
    [@@ocaml.doc
      " [no_arg_required value] is like [no_arg], but the argument is required.\n\
      \        This is useful in combination with [choose_one_non_optional]. "]

    val no_arg_abort : exit:(unit -> Nothing.t) -> unit t
    [@@ocaml.doc
      " [no_arg_abort ~exit] is like [no_arg], but aborts command-line parsing by calling\n\
      \        [exit].  This flag type is useful for \"help\"-style flags that just \
       print something\n\
      \        and exit. "]

    val escape : string list option t
    [@@ocaml.doc
      " [escape] flags may be passed at most once.  They cause the command line parser to\n\
      \        abort and pass through all remaining command line arguments as the value \
       of the\n\
      \        flag.\n\n\
      \        A standard choice of flag name to use with [escape] is [\"--\"]. "]

    val escape_with_autocomplete
      :  complete:Auto_complete.For_escape.t
      -> string list option t

    val map_flag : 'a t -> f:('a -> 'b) -> 'b t
    [@@ocaml.doc
      " [map_flag flag ~f] transforms the parsed result of [flag] by applying [f]. "]
  end
  [@@ocaml.doc " Command-line flag specifications. "]

  module Anons : sig
    [@@@ocaml.text " A specification of some number of anonymous arguments. "]

    type +'a t

    val ( %: ) : string -> 'a Arg_type.t -> 'a t
    [@@ocaml.doc
      " [(name %: typ)] specifies a required anonymous argument of type [typ].\n\n\
      \        The [name] must not be surrounded by whitespace; if it is, an exn will be \
       raised.\n\n\
      \        If the [name] is surrounded by a special character pair (<>, \\{\\}, \
       \\[\\] or (),)\n\
      \        [name] will remain as-is, otherwise, [name] will be uppercased.\n\n\
      \        In the situation where [name] is only prefixed or only suffixed by one of \
       the\n\
      \        special character pairs, or different pairs are used (e.g., \"<ARG\\]\"), \
       an exn will\n\
      \        be raised.\n\n\
      \        The (possibly transformed) [name] is mentioned in the generated help for \
       the\n\
      \        command. "]

    val sequence : 'a t -> 'a list t
    [@@ocaml.doc
      " [sequence anons] specifies a sequence of anonymous arguments.  An exception will \
       be\n\
      \        raised if [anons] matches anything other than a fixed number of anonymous \
       arguments.\n\
      \    "]

    val non_empty_sequence_as_pair : 'a t -> ('a * 'a list) t
    [@@ocaml.doc
      " [non_empty_sequence_as_pair anons] and [non_empty_sequence_as_list anons] are like\n\
      \        [sequence anons] except that an exception will be raised if there is not \
       at least\n\
      \        one anonymous argument given. "]

    val non_empty_sequence_as_list : 'a t -> 'a list t

    val maybe : 'a t -> 'a option t
    [@@ocaml.doc
      " [(maybe anons)] indicates that some anonymous arguments are optional. "]

    val maybe_with_default : 'a -> 'a t -> 'a t
    [@@ocaml.doc
      " [(maybe_with_default default anons)] indicates an optional anonymous argument \
       with a\n\
      \        default value. "]

    [@@@ocaml.text
      " [t2], [t3], and [t4] each concatenate multiple anonymous argument specs into a\n\
      \        single one. The purpose of these combinators is to allow for optional \
       sequences of\n\
      \        anonymous arguments.  Consider a command with usage:\n\n\
      \        {v\n\
      \        main.exe FOO [BAR BAZ]\n\
      \       v}\n\n\
      \        where the second and third anonymous arguments must either both be there \
       or both not\n\
      \        be there.  This can be expressed as:\n\n\
      \        {[\n\
      \          t2 (\"FOO\" %: foo) (maybe (t2 (\"BAR\" %: bar) (\"BAZ\" %: baz)))]\n\
      \        ]}\n\n\
      \        Sequences of 5 or more anonymous arguments can be built up using\n\
      \        nested tuples:\n\n\
      \        {[\n\
      \          maybe (t3 a b (t3 c d e))\n\
      \        ]}\n\
      \    "]

    val t2 : 'a t -> 'b t -> ('a * 'b) t
    val t3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
    val t4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t

    val map_anons : 'a t -> f:('a -> 'b) -> 'b t
    [@@ocaml.doc
      " [map_anons anons ~f] transforms the parsed result of [anons] by applying [f]. "]
  end
  [@@ocaml.doc " Anonymous command-line argument specification. "]

  module Param : sig
    module type S = sig
      type +'a t

      include
        Applicative.S with type 'a t := 'a t
      [@@ocaml.doc
        " [Command.Param] is intended to be used with the [[%map_open]] syntax defined in\n\
        \          [ppx_let], like so:\n\
        \          {[\n\
        \            let command =\n\
        \              Command.basic ~summary:\"...\"\n\
        \                (let%map_open count = anon (\"COUNT\" %: int)\n\
        \                 and port = flag \"port\" (optional int) ~doc:\"N listen on \
         this port\"\n\
        \                 and person = person_param\n\
        \                 in\n\
        \                 (* ... Command-line validation code, if any, goes here ... *)\n\
        \                 fun () ->\n\
        \                   (* The body of the command *)\n\
        \                   do_stuff count port person)\n\
        \          ]}\n\n\
        \          One can also use [[%map_open]] to define composite command line \
         parameters, like\n\
        \          [person_param] in the previous snippet:\n\n\
        \          {[\n\
        \            type person = { name : string; age : int }\n\n\
        \            let person_param : person Command.Param.t =\n\
        \              (let%map_open name =\n\
        \                 flag \"name\" (required string) ~doc:\"X name of the person\"\n\
        \               and age = flag \"age\" (required int) ~doc:\"N how many years \
         old\"\n\
        \               in\n\
        \               {name; age})\n\
        \          ]}\n\n\
        \          The right-hand sides of [[%map_open]] definitions have \
         [Command.Param] in scope.\n\n\
        \          See example/command/main.ml for more examples.\n\
        \      "]

      [@@@ocaml.text " {2 Various internal values} "]

      val help : string Lazy.t t [@@ocaml.doc " The help text for the command. "]

      val path : string list t [@@ocaml.doc " The subcommand path of the command. "]

      val args : string list t [@@ocaml.doc " The arguments passed to the command. "]

      val flag
        :  ?aliases:string list
        -> ?full_flag_required:unit
        -> string
        -> 'a Flag.t
        -> doc:string
        -> 'a t
      [@@ocaml.doc
        " [flag name spec ~doc] specifies a command that, among other things, takes a flag\n\
        \          named [name] on its command line.  [doc] indicates the meaning of the \
         flag.\n\n\
        \          All flags must have a dash at the beginning of the name.  If [name] \
         is not\n\
        \          prefixed by \"-\", it will be normalized to [\"-\" ^ name].\n\n\
        \          Unless [full_flag_required] is used, one doesn't have to pass [name] \
         exactly on\n\
        \          the command line, but only an unambiguous prefix of [name] (i.e., a \
         prefix which\n\
        \          is not a prefix of any other flag's name).\n\n\
        \          NOTE: the [doc] for a flag which takes an argument should be of the \
         form\n\
        \          [arg_name ^ \" \" ^ description] where [arg_name] describes the \
         argument and\n\
        \          [description] describes the meaning of the flag.\n\n\
        \          NOTE: flag names (including aliases) containing underscores will be \
         rejected.\n\
        \          Use dashes instead.\n\n\
        \          NOTE: \"-\" by itself is an invalid flag name and will be rejected.\n\
        \      "]

      val flag_optional_with_default_doc
        :  ?aliases:string list
        -> ?full_flag_required:unit
        -> string
        -> 'a Arg_type.t
        -> ('a -> Sexp.t)
        -> default:'a
        -> doc:string
        -> 'a t
      [@@ocaml.doc
        " [flag_optional_with_default_doc name arg_type sexp_of_default ~default ~doc] is\n\
        \          a shortcut for [flag], where:\n\
        \          + The [Flag.t] is [optional_with_default default arg_type]\n\
        \          + The [doc] is passed through with an explanation of what the default \
         value\n\
        \          appended. "]

      val anon : 'a Anons.t -> 'a t
      [@@ocaml.doc
        " [anon spec] specifies a command that, among other things, takes the anonymous\n\
        \          arguments specified by [spec]. "]

      val escape_anon : final_anon:'a Anons.t -> ('a * string list) t
      [@@ocaml.doc
        " [escape_anon ~final_anon] parses [anon] and then stops parsing. Remaining\n\
        \          command line arguments are collected in the [string list], even if \
         they start\n\
        \          with dashes.\n\n\
        \          See [escape] for the flag version of this behavior.\n\n\
        \          The final anon is required to indicate when to stop parsing. "]

      module If_nothing_chosen : sig
        type (_, _) t =
          | Default_to : 'a -> ('a, 'a) t
          | Raise : ('a, 'a) t
          | Return_none : ('a, 'a option) t
      end

      val choose_one
        :  'a option t list
        -> if_nothing_chosen:('a, 'b) If_nothing_chosen.t
        -> 'b t
      [@@ocaml.doc
        " [choose_one clauses ~if_nothing_chosen] expresses a sum type.  It raises if more\n\
        \          than one of [clauses] is [Some _].  When [if_nothing_chosen = Raise], \
         it also\n\
        \          raises if none of [clauses] is [Some _]. "]

      val choose_one_non_optional
        :  'a t list
        -> if_nothing_chosen:('a, 'b) If_nothing_chosen.t
        -> 'b t
      [@@ocaml.doc
        " [choose_one_non_optional clauses ~if_nothing_chosen] expresses a sum type.\n\
        \          It raises if more than one of the [clauses] has any flags given on the\n\
        \          command-line, and returns the value parsed from the clause that's \
         given.\n\n\
        \          When [if_nothing_chosen = Raise], it also raises if none of the \
         [clauses] are\n\
        \          given. "]

      val and_arg_names : 'a t -> ('a * string list) t
      [@@ocaml.doc
        " [and_arg_names t] returns both the value of [t] and the names of the arguments\n\
        \          that went into [t]. Useful for errors that reference multiple params. "]

      val and_arg_name : 'a t -> ('a * string) t
      [@@ocaml.doc " Like [and_arg_names], but asserts that there is exactly one name. "]

      val arg_names : 'a t -> string list
    end

    include S [@@ocaml.doc " @inline "]

    val optional_to_required : 'a option t -> 'a t
    [@@ocaml.doc
      " If [None] is returned, then the param acts as a required flag that was omitted.\n\
      \        This is intended to be used with [choose_one_non_optional]. "]

    [@@@ocaml.text
      " Values included for convenience so you can specify all command line parameters\n\
      \        inside a single local open of [Param]. "]

    module Arg_type : module type of Arg_type with type 'a t = 'a Arg_type.t
    include module type of Arg_type.Export
    include module type of Flag with type 'a t := 'a Flag.t
    include module type of Anons with type 'a t := 'a Anons.t

    val parse : 'a t -> string list -> 'a Or_error.t
    [@@ocaml.doc
      " [parse t cmdline] will attempt to parse [t] out of [cmdline]. Beware there is\n\
      \        nothing stopping effectful operations in [t] from being performed. "]
  end
  [@@ocaml.doc
    " Command-line parameter specification.\n\n\
    \      This module replaces {{!Core.Command.Spec}[Command.Spec]}, and should be used\n\
    \      in all new code.  Its types and compositional rules are much easier to\n\
    \      understand. "]

  module Let_syntax : sig
      type 'a t [@@ocaml.doc " Substituted below. "]

      val return : 'a -> 'a t

      include Applicative.Applicative_infix with type 'a t := 'a t

      module Let_syntax : sig
          type 'a t [@@ocaml.doc " Substituted below. "]

          val return : 'a -> 'a t
          val map : 'a t -> f:('a -> 'b) -> 'b t
          val both : 'a t -> 'b t -> ('a * 'b) t

          module Open_on_rhs = Param
        end
        with type 'a t := 'a Param.t
    end
    with type 'a t := 'a Param.t

  module Spec : sig
    [@@@ocaml.text " {2 Command parameters} "]

    type 'a param = 'a Param.t
    [@@ocaml.doc
      " Specification of an individual parameter to the command's main function. "]
    [@@deprecated "[since 2019-03] use [Command.Param.t] instead"]

    include Param.S with type 'a t := 'a Param.t

    val const : 'a -> 'a Param.t
    [@@ocaml.doc " Superceded by [return], preserved for backwards compatibility. "]
    [@@deprecated
      "[since 2018-10] use [Command.Param.return] instead of [Command.Spec.const]"]

    val pair : 'a Param.t -> 'b Param.t -> ('a * 'b) Param.t
    [@@ocaml.doc " Superceded by [both], preserved for backwards compatibility. "]
    [@@deprecated
      "[since 2018-10] use [Command.Param.both] instead of [Command.Spec.pair]"]

    [@@@ocaml.text " {2 Command specifications} "]

    type (-'main_in, +'main_out) t
    [@@ocaml.doc " Composable command-line specifications. "]
    [@@ocaml.doc
      " Ultimately one forms a basic command by combining a spec of type [('main, unit ->\n\
      \        unit) t] with a main function of type ['main]; see the [basic] function \
       below.\n\
      \        Combinators in this library incrementally build up the type of main \
       according to\n\
      \        what command-line parameters it expects, so the resulting type of [main] is\n\
      \        something like:\n\n\
      \        [arg1 -> ... -> argN -> unit -> unit]\n\n\
      \        It may help to think of [('a, 'b) t] as a function space ['a -> 'b] \
       embellished with\n\
      \        information about:\n\n\
      \        {ul {- how to parse the command line}\n\
      \        {- what the command does and how to call it}\n\
      \        {- how to autocomplete a partial command line}}\n\n\
      \        One can view a value of type [('main_in, 'main_out) t] as a function that \
       transforms\n\
      \        a main function from type ['main_in] to ['main_out], typically by \
       supplying some\n\
      \        arguments.  E.g., a value of type [Spec.t] might have type:\n\n\
      \        {[\n\
      \          (arg1 -> ... -> argN -> 'r, 'r) Spec.t\n\
      \        ]}\n\n\
      \        Such a value can transform a main function of type [arg1 -> ... -> argN \
       -> 'r] by\n\
      \        supplying it argument values of type [arg1], ..., [argn], leaving a main \
       function\n\
      \        whose type is ['r].  In the end, [Command.basic] takes a completed spec \
       where\n\
      \        ['r = unit -> unit], and hence whose type looks like:\n\n\
      \        {[\n\
      \          (arg1 -> ... -> argN -> unit -> unit, unit -> unit) Spec.t\n\
      \        ]}\n\n\
      \        A value of this type can fully apply a main function of type [arg1 -> ... \
       -> argN ->\n\
      \        unit -> unit] to all its arguments.\n\n\
      \        The final unit argument allows the implementation to distinguish between \
       the phases\n\
      \        of (1) parsing the command line and (2) running the body of the command.  \
       Exceptions\n\
      \        raised in phase (1) lead to a help message being displayed alongside the \
       exception.\n\
      \        Exceptions raised in phase (2) are displayed without any command line \
       help.\n\n\
      \        The view of [('main_in, main_out) Spec.t] as a function from ['main_in] to\n\
      \        ['main_out] is directly reflected by the [step] function, whose type is:\n\n\
      \        {[\n\
      \          val step : ('m1 -> 'm2) -> ('m1, 'm2) t\n\
      \        ]}\n\
      \    "]

    [@@@ocaml.text
      " [spec1 ++ spec2 ++ ... ++ specN] composes [spec1] through [specN].\n\n\
      \        For example, if [spec_a] and [spec_b] have types:\n\n\
      \        {[\n\
      \          spec_a: (a1 -> ... -> aN -> 'ra, 'ra) Spec.t;\n\
      \          spec_b: (b1 -> ... -> bM -> 'rb, 'rb) Spec.t\n\
      \        ]}\n\n\
      \        then [spec_a ++ spec_b] has the following type:\n\n\
      \        {[\n\
      \          (a1 -> ... -> aN -> b1 -> ... -> bM -> 'rb, 'rb) Spec.t\n\
      \        ]}\n\n\
      \        So, [spec_a ++ spec_b] transforms a main function by first supplying \
       [spec_a]'s\n\
      \        arguments of type [a1], ..., [aN], and then supplying [spec_b]'s \
       arguments of type\n\
      \        [b1], ..., [bm].\n\n\
      \        One can understand [++] as function composition by thinking of the type \
       of specs\n\
      \        as concrete function types, representing the transformation of a main \
       function:\n\n\
      \        {[\n\
      \          spec_a: \\/ra. (a1 -> ... -> aN -> 'ra) -> 'ra;\n\
      \          spec_b: \\/rb. (b1 -> ... -> bM -> 'rb) -> 'rb\n\
      \        ]}\n\n\
      \        Under this interpretation, the composition of [spec_a] and [spec_b] has \
       type:\n\n\
      \        {[\n\
      \          spec_a ++ spec_b : \\/rc. (a1 -> ... -> aN -> b1 -> ... -> bM -> 'rc) \
       -> 'rc\n\
      \        ]}\n\n\
      \        And the implementation is just function composition:\n\n\
      \        {[\n\
      \          sa ++ sb = fun main -> sb (sa main)\n\
      \        ]}\n\
      \    "]

    val empty : ('m, 'm) t [@@ocaml.doc " The empty command-line spec. "]

    val ( ++ ) : ('m1, 'm2) t -> ('m2, 'm3) t -> ('m1, 'm3) t
    [@@ocaml.doc " Command-line spec composition. "]

    val ( +> ) : ('m1, 'a -> 'm2) t -> 'a Param.t -> ('m1, 'm2) t
    [@@ocaml.doc " Adds a rightmost parameter onto the type of main. "]

    val ( +< ) : ('m1, 'm2) t -> 'a Param.t -> ('a -> 'm1, 'm2) t
    [@@ocaml.doc
      " Adds a leftmost parameter onto the type of main.\n\n\
      \        This function should only be used as a workaround in situations where the \
       order of\n\
      \        composition is at odds with the order of anonymous arguments because you're\n\
      \        factoring out some common spec. "]

    val step : ('m1 -> 'm2) -> ('m1, 'm2) t
    [@@ocaml.doc
      " Combinator for patching up how parameters are obtained or presented.\n\n\
      \        Here are a couple examples of some of its many uses:\n\
      \        {ul\n\
      \        {li {i introducing labeled arguments}\n\
      \        {v step (fun m v -> m ~foo:v)\n\
      \               +> flag \"-foo\" no_arg : (foo:bool -> 'm, 'm) t v}}\n\
      \        {li {i prompting for missing values}\n\
      \        {v step (fun m user -> match user with\n\
      \                 | Some user -> m user\n\
      \                 | None -> print_string \"enter username: \"; m (read_line ()))\n\
      \               +> flag \"-user\" (optional string) ~doc:\"USER to frobnicate\"\n\
      \               : (string -> 'm, 'm) t v}}\n\
      \        }\n\n\
      \        A use of [step] might look something like:\n\n\
      \        {[\n\
      \          step (fun main -> let ... in main x1 ... xN) : (arg1 -> ... -> argN -> \
       'r, 'r) t\n\
      \        ]}\n\n\
      \        Thus, [step] allows one to write arbitrary code to decide how to \
       transform a main\n\
      \        function.  As a simple example:\n\n\
      \        {[\n\
      \          step (fun main -> main 13.) : (float -> 'r, 'r) t\n\
      \        ]}\n\n\
      \        This spec is identical to [const 13.]; it transforms a main function by \
       supplying\n\
      \        it with a single float argument, [13.].  As another example:\n\n\
      \        {[\n\
      \          step (fun m v -> m ~foo:v) : (foo:'foo -> 'r, 'foo -> 'r) t\n\
      \        ]}\n\n\
      \        This spec transforms a main function that requires a labeled argument into\n\
      \        a main function that requires the argument unlabeled, making it easily \
       composable\n\
      \        with other spec combinators.\n\n\
      \    "]

    val wrap : (run:('m1 -> 'r1) -> main:'m2 -> 'r2) -> ('m1, 'r1) t -> ('m2, 'r2) t
    [@@ocaml.doc
      " Combinator for defining a class of commands with common behavior.\n\n\
      \        Here are two examples of command classes defined using [wrap]:\n\
      \        {ul\n\
      \        {li {i print top-level exceptions to stderr}\n\
      \        {v wrap (fun ~run ~main ->\n\
      \                 Exn.handle_uncaught ~exit:true (fun () -> run main)\n\
      \               ) : ('m, unit) t -> ('m, unit) t\n\
      \             v}}\n\
      \        {li {i iterate over lines from stdin}\n\
      \        {v wrap (fun ~run ~main ->\n\
      \                 In_channel.iter_lines stdin ~f:(fun line -> run (main line))\n\
      \               ) : ('m, unit) t -> (string -> 'm, unit) t\n\
      \             v}}\n\
      \        }\n\
      \    "]

    module Arg_type : module type of Arg_type with type 'a t = 'a Arg_type.t
    include module type of Arg_type.Export

    type 'a flag = 'a Flag.t [@@ocaml.doc " A flag specification. "]

    include module type of Flag with type 'a t := 'a flag

    val flags_of_args_exn
      :  (Stdlib.Arg.key * Stdlib.Arg.spec * Stdlib.Arg.doc) list
      -> ('a, 'a) t
    [@@ocaml.doc
      " [flags_of_args_exn args] creates a spec from [Caml.Arg.t]s, for compatibility with\n\
      \        OCaml's base libraries.  Fails if it encounters an arg that cannot be \
       converted.\n\n\
      \        NOTE: There is a difference in side effect ordering between [Caml.Arg] and\n\
      \        [Command].  In the [Arg] module, flag handling functions embedded in \
       [Caml.Arg.t]\n\
      \        values will be run in the order that flags are passed on the command \
       line.  In the\n\
      \        [Command] module, using [flags_of_args_exn flags], they are evaluated in \
       the order\n\
      \        that the [Caml.Arg.t] values appear in [args].  "]
    [@@deprecated "[since 2018-10] switch to Command.Param"]

    type 'a anons = 'a Anons.t
    [@@ocaml.doc " A specification of some number of anonymous arguments. "]

    include module type of Anons with type 'a t := 'a anons

    [@@@ocaml.text
      " Conversions to and from new-style [Param] command line specifications. "]

    val to_param : ('a, 'r) t -> 'a -> 'r Param.t
    val of_param : 'r Param.t -> ('r -> 'm, 'm) t
  end
  [@@ocaml.doc
    " The old interface for command-line specifications -- {b Do Not Use}.\n\n\
    \      This interface should not be used. See the {{!Core.Command.Param}[Param]}\n\
    \      module for the new way to do things. "]

  type t [@@ocaml.doc " Commands which can be combined into a hierarchy of subcommands. "]

  type ('main, 'result) basic_spec_command =
    summary:string
    -> ?readme:(unit -> string)
    -> ('main, unit -> 'result) Spec.t
    -> 'main
    -> t

  val basic_spec : ('main, unit) basic_spec_command
  [@@ocaml.doc
    " [basic_spec ~summary ?readme spec main] is a basic command that executes a function\n\
    \      [main] which is passed parameters parsed from the command line according to \
     [spec].\n\
    \      [summary] is to contain a short one-line description of its behavior.  \
     [readme] is to\n\
    \      contain any longer description of its behavior that will go on that command's \
     help\n\
    \      screen. "]

  type 'result basic_command =
    summary:string -> ?readme:(unit -> string) -> (unit -> 'result) Param.t -> t

  val basic : unit basic_command
  [@@ocaml.doc
    " Same general behavior as [basic_spec], but takes a command line specification \
     built up\n\
    \      using [Params] instead of [Spec]. "]

  val basic_or_error : unit Or_error.t basic_command
  [@@ocaml.doc
    " [basic_or_error] is like [basic], except that the main function it expects may\n\
    \      return an error, in which case it prints out the error message and shuts down \
     with\n\
    \      exit code 1. "]

  val group
    :  summary:string
    -> ?readme:(unit -> string)
    -> ?preserve_subcommand_order:unit
    -> ?body:(path:string list -> unit)
    -> (string * t) list
    -> t
  [@@ocaml.doc
    " [group ~summary subcommand_alist] is a compound command with named subcommands, as\n\
    \      found in [subcommand_alist].  [summary] is to contain a short one-line \
     description of\n\
    \      the command group.  [readme] is to contain any longer description of its \
     behavior that\n\
    \      will go on that command's help screen.\n\n\
    \      NOTE: subcommand names containing underscores will be rejected; use dashes \
     instead.\n\n\
    \      [body] is called when no additional arguments are passed -- in particular, \
     when no\n\
    \      subcommand is passed.  Its [path] argument is the subcommand path by which \
     the group\n\
    \      command was reached. "]

  val lazy_group
    :  summary:string
    -> ?readme:(unit -> string)
    -> ?preserve_subcommand_order:unit
    -> ?body:(path:string list -> unit)
    -> (string * t) list Lazy.t
    -> t
  [@@ocaml.doc
    " [lazy_group] is the same as [group], except that the list of subcommands may be\n\
    \      generated lazily. "]

  val exec
    :  summary:string
    -> ?readme:(unit -> string)
    -> ?child_subcommand:string list
    -> ?env:env
    -> path_to_exe:
         [ `Absolute of string
         | `Relative_to_argv0 of string
         | `Relative_to_me of string
         ]
    -> unit
    -> t
  [@@ocaml.doc
    " [exec ~summary ~path_to_exe] runs [exec] on the executable at [path_to_exe]. If\n\
    \      [path_to_exe] is [`Absolute path] then [path] is executed without any further\n\
    \      qualification.  If it is [`Relative_to_me path] then [Filename.dirname\n\
    \      Sys.executable_name ^ \"/\" ^ path] is executed instead.  All of the usual \
     caveats about\n\
    \      [Sys.executable_name] apply: specifically, it may only return an absolute \
     path in\n\
    \      Linux.  On other operating systems it will return [Sys.argv.(0)].  If it is\n\
    \      [`Relative_to_argv0 path] then [Sys.argv.(0) ^ \"/\" ^ path] is executed.\n\n\
    \      The [child_subcommand] argument allows referencing a subcommand one or more \
     levels\n\
    \      below the top-level of the child executable. It should {e not} be used to \
     pass flags\n\
    \      or anonymous arguments to the child.\n\n\
    \      Care has been taken to support nesting multiple executables built with \
     Command.  In\n\
    \      particular, recursive help and autocompletion should work as expected.\n\n\
    \      NOTE: Non-Command executables can be used with this function but will still be\n\
    \      executed when [help -recursive] is called or autocompletion is attempted \
     (despite the\n\
    \      fact that neither will be particularly helpful in this case).  This means \
     that if you\n\
    \      have a shell script called \"reboot-everything.sh\" that takes no arguments \
     and reboots\n\
    \      everything no matter how it is called, you shouldn't use it with [exec].\n\n\
    \      Additionally, no loop detection is attempted, so if you nest an executable \
     within\n\
    \      itself, [help -recursive] and autocompletion will hang forever (although \
     actually\n\
    \      running the subcommand will work). "]

  val of_lazy : t Lazy.t -> t
  [@@ocaml.doc
    " [of_lazy thunk] constructs a lazy command that is forced only when necessary to \
     run it\n\
    \      or extract its shape. "]

  val summary : t -> string [@@ocaml.doc " Extracts the summary string for a command. "]

  module Shape = Shape

  val exit : int -> _
  [@@ocaml.doc
    " call this instead of [Core.exit] if in command-related code that you want to run in\n\
    \      tests.  For example, in the body of [Command.Param.no_arg_abort] "]

  module For_telemetry : sig
    val normalized_path : unit -> string list option
    [@@ocaml.doc
      " Returns the command and the list of subcommands. Arguments to the [Command.t] are\n\
      \        not included.\n\n\
      \        If a subcommand was specified as a unique prefix [normalized_path] will \
       contain\n\
      \        the full subcommand name.\n\n\
      \        If the entry point to the program was not through [Command] returns [None].\n\
      \    "]

    val normalized_args : unit -> string list option
    [@@ocaml.doc
      " Returns the full list of arguments that were parsed by [Command].\n\n\
      \        If a flag name was specified as a unique prefix [normalized_args] will \
       contain the\n\
      \        full flag name.\n\n\
      \        If the entry point to the program was not through [Command] returns [None].\n\
      \    "]
  end

  module Deprecated : sig
    module Spec : sig
      val no_arg : hook:(unit -> unit) -> bool Spec.flag
      val escape : hook:(string list -> unit) -> string list option Spec.flag
      val ad_hoc : usage_arg:string -> string list Spec.anons
    end

    val summary : t -> string

    val help_recursive
      :  cmd:string
      -> with_flags:bool
      -> expand_dots:bool
      -> t
      -> string
      -> (string * string) list

    val get_flag_names : t -> string list
  end
  [@@ocaml.doc
    " [Deprecated] should be used only by [Deprecated_command].  At some point\n\
    \      it will go away. "]

  [@@@ocaml.text " Deprecated values that moved from [Core.Command] to [Command_unix]. "]

  val run : [ `Use_Command_unix ] [@@deprecated "[since 2021-03] Use [Command_unix]"]

  module Path : sig end [@@deprecated "[since 2021-03] Use [Command_unix]"]

  val shape : [ `Use_Command_unix ] [@@deprecated "[since 2021-03] Use [Command_unix]"]

  [@@@ocaml.text "/*"]

  module Private : sig
    val abs_path : dir:string -> string -> string
    val word_wrap : string -> int -> string list

    module Anons : sig
      val normalize : string -> string
    end

    module Path : sig
      type t

      val empty : t
      val create : path_to_exe:string -> t
      val append : t -> subcommand:string -> t
      val parts : t -> string list
      val replace_first : t -> from:string -> to_:string -> t
      val to_string : t -> string
      val to_string_dots : t -> string
    end

    module Cmdline : sig
      type t [@@deriving compare]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val of_list : string list -> t
      val extend : t -> extend:(string list -> string list) -> path:Path.t -> t
    end

    module Spec : sig
      val flags_of_args_exn : (string * Stdlib.Arg.spec * string) list -> ('a, 'a) Spec.t
      val to_string_for_choose_one : _ Param.t -> string
    end

    module For_unix : functor (M : For_unix with type env_var := string) -> sig
      val shape : t -> Shape.t

      val help_for_shape
        :  Shape.t
        -> Path.t
        -> expand_dots:bool
        -> flags:bool
        -> recursive:bool
        -> string

      val run
        :  ?add_validate_parsing_flag:
             (bool
             [@ocaml.doc
               " When [add_validate_parsing_flag] is true a new flag `-validate-parsing` \
                is\n\
               \            added to all subcommands. When this flag is passed the \
                command will exit\n\
               \            immediately if parsing is succesfull and return 0. This flag \
                does not take any\n\
               \            steps to stop side effects from occurring. "])
        -> ?verbose_on_parse_error:bool
        -> ?version:string
        -> ?build_info:string
        -> ?argv:string list
        -> ?extend:(string list -> string list)
        -> ?when_parsing_succeeds:(unit -> unit)
        -> ?complete_subcommands:
             ((path:string list -> part:string -> string list list -> string list option)
             [@ocaml.doc
               " [complete_subcommands ~path ~part options] allows users to provide a \
                custom\n\
               \            tab completion handler to an invocation of [run]. By \
                default, completion is\n\
               \            performed via standard bash completion.\n\n\
               \            One may use this to, e.g. use a fuzzy finder for completion.\n\n\
               \            Imagine a command whose structure is \"subcommand1 \
                subcommand2\",\n\n\
               \            [path] represents the subcommand invocations interpreted \
                thusfar in being\n\
               \            matched.\n\n\
               \            [part] is the portion of the auto-completion that is being \
                matched upon.\n\n\
               \            If a user attempts to complete \"exe subcommand1 s<TAB>\", \
                they will get\n\
               \            [\"subcommand1\"] in [path] and \"s\" in [part].\n\n\
               \            [options] are the valid subcommand invocations to present to \
                the user.\n\n\
               \            [complete_subcommands] should return the selection made, if \
                any. "])
        -> t
        -> unit

      val deprecated_run
        :  t
        -> cmd:string
        -> args:string list
        -> is_help:bool
        -> is_help_rec:bool
        -> is_help_rec_flags:bool
        -> is_expand_dots:bool
        -> unit
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
