[@@@ocaml.text
  " Manipulating version util and build info \"sections\" of data stored in executables. "]

open! Core

module Make : functor
    (M : sig
       val name : string
       val start_marker : string
       val length_including_start_marker : int
     end)
    -> sig
  val get : contents_of_exe:string -> string option
  [@@ocaml.doc
    " Extract the first section from an executable, including the start marker. Returns\n\
    \        [None] if there are no matching sections. "]

  val replace : contents_of_exe:string -> data:string -> string option
  [@@ocaml.doc
    " Find all occurrences of the section and replace their payloads with new [data].\n\
    \        Returns [None] if there are no occurrences. "]

  val chop_start_marker_if_exists : string -> string
  [@@ocaml.doc " An alias for [String.chop_prefix_if_exists ~prefix:M.start_marker]. "]

  val count_occurrences : contents_of_exe:string -> int
  [@@ocaml.doc " How many times does the marker appear in the executable? "]

  module Expert : sig
    val start_marker : string
    [@@ocaml.doc
      " The start marker, as passed via the functor's argument. It's in the [Expert]\n\
      \          module because one is not supposed to fiddle with start markers \
       directly. "]

    val pad_with_at_least_one_nul_byte_exn : string -> string
    [@@ocaml.doc
      " Pad a string with NUL bytes up to the length of the section's payload.\n\n\
      \          Raises if there is no space for a NUL byte or if the given string \
       contains a NUL\n\
      \          byte already. "]
  end
end
[@@ocaml.doc
  " Create a section. Each section has a fixed length and starts with a marker string. "]
