[@@@ocaml.text " System interface. "]

open! Core
open! Import

val executable_name : string
[@@ocaml.doc " The name of the file containing the executable currently running. "]

[@@@ocaml.text
  " For all of the following functions, [?follow_symlinks] defaults to [true]. "]

val file_exists
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> [ `Yes | `No | `Unknown ]
[@@ocaml.doc
  " [file_exists ~follow_symlinks path]\n\n\
  \    Test whether the file in [path] exists on the file system.\n\
  \    If [follow_symlinks] is [true] and [path] is a symlink the result concerns\n\
  \    the target of the symlink.\n\n\
  \    [`Unknown] is returned for files for which we cannot successfully determine\n\
  \    whether they are on the system or not (e.g. files in directories to which we\n\
  \    do not have read permission). "]

val file_exists_exn
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> bool
[@@ocaml.doc " Same as [file_exists] but blows up on [`Unknown] "]

val is_directory
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> [ `Yes | `No | `Unknown ]
[@@ocaml.doc " Returns [`Yes] if the file exists and is a directory"]

val is_file
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> [ `Yes | `No | `Unknown ]
[@@ocaml.doc " Returns [`Yes] if the file exists and is a regular file "]

val is_directory_exn
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> bool

val is_file_exn
  :  ?follow_symlinks:(bool[@ocaml.doc " defaults to true "])
  -> string
  -> bool

val remove : string -> unit
[@@ocaml.doc " Remove the given file name from the file system. "]

val rename : string -> string -> unit
[@@ocaml.doc
  " Rename a file.  [rename oldpath newpath] renames the file\n\
  \    called [oldpath], giving it [newpath] as its new name,\n\
  \    moving it between directories if needed.  If [newpath] already\n\
  \    exists, its contents will be replaced with those of [oldpath].\n\
  \    Depending on the operating system, the metadata (permissions,\n\
  \    owner, etc) of [newpath] can either be preserved or be replaced by\n\
  \    those of [oldpath]. "]

val unsafe_getenv : string -> string option
[@@ocaml.doc
  " Return the value associated to a variable in the process environment.\n\n\
  \    Unlike {!getenv}, this function returns the value even if the\n\
  \    process has special privileges. It is considered unsafe because the\n\
  \    programmer of a setuid or setgid program must be careful to avoid\n\
  \    using maliciously crafted environment variables in the search path\n\
  \    for executables, the locations for temporary files or logs, and the\n\
  \    like. "]

val unsafe_getenv_exn : string -> string

val command : string -> int
[@@ocaml.doc " Execute the given shell command and return its exit code. "]

val command_exn : string -> unit
[@@ocaml.doc
  " [command_exn command] runs [command] and then raises an exception if it\n\
  \    returns with nonzero exit status. "]

val chdir : string -> unit
[@@ocaml.doc " Change the current working directory of the process. "]

val getcwd : unit -> string
[@@ocaml.doc " Return the current working directory of the process. "]

val readdir : string -> string array
[@@ocaml.doc
  " Return the names of all files present in the given directory.  Names\n\
  \    denoting the current directory and the parent directory ([\".\"] and [\"..\"] in\n\
  \    Unix) are not returned.  Each string in the result is a file name rather\n\
  \    than a complete path.  There is no guarantee that the name strings in the\n\
  \    resulting array will appear in any specific order; they are not, in\n\
  \    particular, guaranteed to appear in alphabetical order. "]

val fold_dir : init:'acc -> f:('acc -> string -> 'acc) -> string -> 'acc
[@@ocaml.doc
  "\n\
  \   Call [readdir], and fold over the elements of the array.\n\
  \   @raise Sys_error _ if readdir fails.\n\
  \   As with [readdir], [\".\"] and [\"..\"] are not returned\n\
  \   raises the same exception than opendir and closedir.\n"]

val ls_dir : string -> string list
[@@ocaml.doc "\n   Same as [readdir], but return a list rather than an array.\n"]

exception
  Break
      [@ocaml.doc
        " Exception raised on interactive interrupt if {!Sys.catch_break} is on. "]

val catch_break : bool -> unit
[@@ocaml.doc
  " Warning: this function clobbers the Signal.int (SIGINT) handler.  SIGINT is the\n\
  \    signal that's sent to your program when you hit CTRL-C.\n\n\
  \    Warning: catch_break uses deep ocaml runtime magic to raise Sys.Break inside of the\n\
  \    main execution context.  Consider explicitly handling Signal.int instead.  If\n\
  \    all you want to do is terminate on CTRL-C you don't have to do any special setup,\n\
  \    that's the default behavior.\n\n\
  \    [catch_break] governs whether interactive interrupt (ctrl-C) terminates the\n\
  \    program or raises the [Break] exception.  Call [catch_break true] to enable\n\
  \    raising [Break], and [catch_break false] to let the system terminate the\n\
  \    program on user interrupt.\n"]

val with_async_exns : (unit -> 'a) -> 'a
[@@ocaml.doc
  " [with_async_exns f] runs [f] and returns its result, in addition to\n\
  \    causing any asynchronous [Break] or [Stack_overflow] exceptions\n\
  \    (e.g. from finalisers, signal handlers or the GC) to be raised from the\n\
  \    call site of [with_async_exns].\n"]

val execution_mode : unit -> [ `Bytecode | `Native ]
[@@ocaml.doc
  " [execution_mode] tests whether the code being executed was compiled natively\n\
  \    or to bytecode. "]

external c_int_size : unit -> int = "c_int_size"
[@@ocaml.doc
  " [c_int_size] returns the number of bits in a C [int], as specified in header\n\
  \    files. Note that this can be different from [word_size] and [Nativeint.num_bits]. \
   For\n\
  \    example, Linux x86-64 should have [word_size = 64], but [c_int_size () = 32]. "]
[@@noalloc]

val home_directory : unit -> string
[@@ocaml.doc
  " Return the home directory, using the [HOME] environment variable if that is defined,\n\
  \    and if not, using the effective user's information in the Unix password database. "]

[@@@ocaml.text " {6 Optimization} "]

val override_argv : string array -> unit
[@@ocaml.doc
  " [override_argv new_argv] makes subsequent calls to {!get_argv} return [new_argv].\n\n\
  \    Prior to OCaml version 4.09, this function has two noteworthy behaviors:\n\n\
  \    - it may raise if the length of [new_argv] is greater than the length of [argv] \
   before\n\
  \      the call;\n\
  \    - it re-uses and mutates the previous [argv] value instead of using the new one; \
   and\n\
  \    - it even mutates its length, which can be observed by inspecting the array \
   returned\n\
  \      by an earlier call to {!get_argv}.\n"]
