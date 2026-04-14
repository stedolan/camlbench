open! Base

type t = string [@@deriving compare, hash, sexp, sexp_grammar]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Comparable.S with type t := t with type comparator_witness = String.comparator_witness

val root : string [@@ocaml.doc "  The path of the root."]

[@@@ocaml.text " {2 Pathname resolution} "]

val is_posix_pathname_component : string -> bool
[@@ocaml.doc
  " [is_posix_pathname_component f]\n\
  \    @return true if [f] is a valid path component on a POSIX compliant OS\n\n\
  \    Note that this checks a path component, and not a full path.\n\n\
  \    http://www.opengroup.org/onlinepubs/000095399/basedefs/xbd_chap03.html#tag_03_169\n"]

val temp_dir_name : string
[@@ocaml.doc
  " The name of the temporary directory:\n\n\
  \    Under Unix, the value of the [TMPDIR] environment variable, or \"/tmp\" if the \
   variable\n\
  \    is not set.\n\n\
  \    Under Windows, the value of the [TEMP] environment variable, or \".\"  if the \
   variable\n\
  \    is not set. "]

val current_dir_name : string
[@@ocaml.doc " The conventional name for the current directory (e.g. [.] in Unix). "]

val parent_dir_name : string
[@@ocaml.doc
  " The conventional name for the parent of the current directory\n\
  \    (e.g. [..] in Unix). "]

val dir_sep : string [@@ocaml.doc " The directory separator (e.g. [/] in Unix). "]

val concat : string -> string -> string
[@@ocaml.doc
  " [concat p1 p2] returns a path equivalent to [p1 ^ \"/\" ^ p2].\n\
  \    In the resulting path p1 (resp. p2) has all its trailing (resp. leading)\n\
  \    \".\" and \"/\" removed. eg:\n\
  \    concat \"a/.\" \".//b\" => \"a/b\"\n\
  \    concat \".\" \"b\" => \"./b\"\n\
  \    concat \"a\" \".\" => \"a/.\"\n\
  \    concat \"a\" \"/b\" => \"a/b\"\n\n\
  \    @throws Failure if [p1] is empty.\n"]

val is_relative : string -> bool
[@@ocaml.doc
  " Return [true] if the file name is relative to the current\n\
  \    directory, [false] if it is absolute (i.e. in Unix, starts\n\
  \    with [/]). "]

val is_absolute : string -> bool

val is_implicit : string -> bool
[@@ocaml.doc
  " Return [true] if the file name is relative and does not start\n\
  \    with an explicit reference to the current directory ([./] or\n\
  \    [../] in Unix), [false] if it starts with an explicit reference\n\
  \    to the root directory or the current directory. "]

val check_suffix : string -> string -> bool
[@@ocaml.doc
  " [check_suffix name suff] returns [true] if the filename [name]\n\
  \    ends with the suffix [suff]. "]

val chop_suffix : string -> string -> string
[@@ocaml.doc
  " [chop_suffix name suff] removes the suffix [suff] from\n\
  \    the filename [name]. The behavior is undefined if [name] does not\n\
  \    end with the suffix [suff]. [chop_suffix_opt] is thus recommended\n\
  \    instead."]

val chop_suffix_opt : suffix:string -> string -> string option
[@@ocaml.doc
  " [chop_suffix_opt ~suffix filename] removes the suffix from\n\
  \    the [filename] if possible, or returns [None] if the\n\
  \    filename does not end with the suffix.\n"]

val chop_extension : string -> string
[@@ocaml.doc
  " Return the given file name without its extension. The extension\n\
  \    is the shortest suffix starting with a period and not including\n\
  \    a directory separator, [.xyz] for instance.\n\n\
  \    Raise [Invalid_argument] if the given name does not contain\n\
  \    an extension. "]

val split_extension : string -> string * string option
[@@ocaml.doc
  " [split_extension fn] return the portion of the filename before the\n\
  \    extension and the (optional) extension.\n\
  \    Example:\n\
  \    split_extension \"/foo/my_file\" = (\"/foo/my_file\", None)\n\
  \    split_extension \"/foo/my_file.txt\" = (\"/foo/my_file\", Some \"txt\")\n\
  \    split_extension \"/home/c.falls/my_file\" = (\"/home/c.falls/my_file\", None)\n"]

val basename : string -> string
[@@ocaml.doc
  " Respects the posix semantic.\n\n\
  \    Split a file name into directory name / base file name.\n\
  \    [concat (dirname name) (basename name)] returns a file name\n\
  \    which is equivalent to [name]. Moreover, after setting the\n\
  \    current directory to [dirname name] (with {!Sys.chdir}),\n\
  \    references to [basename name] (which is a relative file name)\n\
  \    designate the same file as [name] before the call to {!Sys.chdir}.\n\n\
  \    The result is not specified if the argument is not a valid file name\n\
  \    (for example, under Unix if there is a NUL character in the string). "]

val dirname : string -> string [@@ocaml.doc " See {!Filename.basename}. "]

val to_absolute_exn : string -> relative_to:string -> string
[@@ocaml.doc
  " Returns the absolute path by prepending [relative_to] if the path is not already\n\
  \    absolute.\n\n\
  \    Using the result of [Core_unix.getcwd] as [relative_to] is often a reasonable \
   choice.\n\n\
  \    Note that [to_absolute_exn] may return a non-canonical path (e.g. \
   /foo/bar/../baz).\n\n\
  \    Raises if [relative_to] is a relative path.\n"]

val of_absolute_exn : string -> relative_to:string -> string
[@@ocaml.doc
  " Converts an absolute path to a relative one.\n\n\
  \    Raises if either argument is a relative path.\n"]

val split : string -> string * string
[@@ocaml.doc " [split filename] returns (dirname filename, basename filename) "]

val parts : string -> string list
[@@ocaml.doc
  " [parts filename] returns a list of path components in order.  For instance:\n\
  \    /tmp/foo/bar/baz -> [\"/\"; \"tmp\"; \"foo\"; \"bar\"; \"baz\"]. The first \
   component is always\n\
  \    either \".\" for relative paths or \"/\" for absolute ones. "]

val of_parts : string list -> string
[@@ocaml.doc
  " [of_parts parts] joins a list of path components into a path. It does roughly the\n\
  \    opposite of [parts], but they fail to be precisely mutually inverse because of\n\
  \    ambiguities like multiple consecutive slashes and . components.\n\n\
  \    Raises an error if given an empty list. "]

val quote : string -> string
[@@ocaml.doc
  " Return a quoted version of a file name, suitable for use as one argument in a command\n\
  \    line, escaping all meta-characters.\n\
  \    Warning: under Windows, the output is only suitable for use with programs that \
   follow\n\
  \    the standard Windows quoting conventions.\n\n\
  \    See [Sys.quote] for an alternative implementation that is more human readable but \
   less\n\
  \    portable.\n"]

val arg_type : [ `Use_Filename_unix ] [@@deprecated "[since 2021-04] Use [Filename_unix]"]

val create_arg_type : [ `Use_Filename_unix ]
[@@deprecated "[since 2021-04] Use [Filename_unix]"]

val open_temp_file : [ `Use_Filename_unix ]
[@@deprecated "[since 2021-04] Use [Filename_unix]"]

val open_temp_file_fd : [ `Use_Filename_unix ]
[@@deprecated "[since 2021-04] Use [Filename_unix]"]

val realpath : [ `Use_Filename_unix ] [@@deprecated "[since 2021-04] Use [Filename_unix]"]
val temp_dir : [ `Use_Filename_unix ] [@@deprecated "[since 2021-04] Use [Filename_unix]"]

val temp_file : [ `Use_Filename_unix ]
[@@deprecated "[since 2021-04] Use [Filename_unix]"]
