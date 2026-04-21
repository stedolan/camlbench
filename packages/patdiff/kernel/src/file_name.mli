[@@@ocaml.text
  " Used to determine which name to use for a file, depending on the operation. "]

open! Core
open! Import

type t =
  | Real of
      { real_name : string
      ; alt_name : string option
      }
  [@ocaml.doc
    " A name corresponding to a real file on disk.  [alt_name] is used to display\n\
    \      the file name and for file extension heuristics. "]
  | Fake of string [@ocaml.doc " A name not necessarily corresponding to a real file. "]
[@@deriving compare, equal]

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val real_name_exn : t -> string
[@@ocaml.doc
  " The name used to access the file system.  May differ from the name used for\n\
  \    display. "]

val display_name : t -> string
[@@ocaml.doc
  " The name used for display.  Also used for file extension heuristics.\n\n\
  \    If [t] has an [alt_name], then that is used.  Otherwise, the real name is used. "]

val to_string_hum : t -> string [@@ocaml.doc " Equivalent to {!display_name}. "]

val append : t -> string -> t
[@@ocaml.doc " Append a path component to each of [real_name], [alt_name]. "]

val dev_null : t
