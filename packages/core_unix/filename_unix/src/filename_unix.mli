[@@@ocaml.text " Warning! this library assumes we are in a POSIX compliant OS. "]

open! Core
open! Import

val realpath : string -> string
[@@ocaml.doc
  " [realpath path] @return the canonicalized absolute pathname of [path].\n\
  \    @raise Unix_error on errors. "]

val open_temp_file
  :  ?close_on_exec:(bool[@ocaml.doc " default true "])
  -> ?perm:int
  -> ?in_dir:string
  -> string
  -> string
  -> string * Out_channel.t
[@@ocaml.doc
  " Same as {!temp_file}, but returns both the name of a fresh\n\
  \    temporary file, and an output channel opened (atomically) on\n\
  \    this file.  This function is more secure than [temp_file]: there\n\
  \    is no risk that the temporary file will be modified (e.g. replaced\n\
  \    by a symbolic link) before the program opens it. "]

val open_temp_file_fd
  :  ?close_on_exec:(bool[@ocaml.doc " default false "])
  -> ?perm:int
  -> ?in_dir:string
  -> string
  -> string
  -> string * Unix.file_descr
[@@ocaml.doc
  " Similar to {!open_temp_file}, but returns a Unix file descriptor\n\
  \    open in read&write mode instead of an [Out_channel.t]. "]

val temp_file : ?perm:int -> ?in_dir:string -> string -> string -> string
[@@ocaml.doc
  " [temp_file ?perm ?in_dir_name prefix suffix]\n\n\
  \    Returns the name of a fresh temporary file in the temporary directory. The base \
   name\n\
  \    of the temporary file is formed by concatenating prefix, then [.tmp.], then a \
   6-digit\n\
  \    hex number, then suffix. The temporary file is created empty. The file is \
   guaranteed\n\
  \    to be fresh, i.e. not already existing in the directory.\n\n\
  \    @param in_dir the directory in which to create the temporary file.  The default is\n\
  \    [temp_dir_name]\n\n\
  \    @param perm the permission of the temporary file. The default value is [0o600]\n\
  \    (readable and writable only by the file owner)\n\n\
  \    Note that prefix and suffix will be changed when necessary to make the final \
   filename\n\
  \    valid POSIX.\n\n\
  \    [temp_dir] is the same as [temp_file] but creates a temporary directory. "]

val temp_dir : ?perm:int -> ?in_dir:string -> string -> string -> string

val create_arg_type
  :  ?key:'a Univ_map.Multi.Key.t
  -> (string -> 'a)
  -> 'a Core.Command.Arg_type.t
[@@ocaml.doc
  " [create_arg_type]'s resulting [Arg_type.t] does bash autocompletion, via [compgen]. "]

val arg_type : string Core.Command.Arg_type.t
[@@ocaml.doc " [arg_type] is [create_arg_type Fn.id] "]
