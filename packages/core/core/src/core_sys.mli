open! Import

include module type of struct
  include Base.Sys
end

val quote : string -> string
[@@ocaml.doc
  " [quote s] quotes the string in a format suitable for the shell of the current system\n\
  \    (e.g. suitable for [command]).  On Unix, this function only quotes as necessary, \
   which\n\
  \    makes its output more legible than [Filename.quote].\n\n\
  \    WARNING: This may not work with some shells, but should work with sh, bash, and \
   zsh.\n"]

val concat_quoted : string list -> string
[@@ocaml.doc
  " Converts a list of tokens to a command line fragment that can be passed to the shell\n\
  \    of the current system. Each token is escaped as appropriate using [quote]. "]

val c_int_size : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val catch_break : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val chdir : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val command : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val command_exn : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val executable_name : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val execution_mode : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val file_exists : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val file_exists_exn : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val fold_dir : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val getcwd : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val home_directory : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val is_directory : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val is_directory_exn : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val is_file : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val is_file_exn : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val ls_dir : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val override_argv : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val readdir : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val remove : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val rename : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val unsafe_getenv : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]
val unsafe_getenv_exn : [ `Use_Sys_unix ] [@@deprecated "[since 2021-04] Use [Sys_unix]"]

exception Break [@deprecated "[since 2021-04] Use [Sys_unix]"]

[@@@ocaml.text "/*"]

module Private : sig
  val unix_quote : string -> string
end
