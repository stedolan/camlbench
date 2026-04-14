[@@@ocaml.text
  " Extensible string buffers based on Bigstrings.\n\n\
  \    This module implements string buffers that automatically expand as necessary.  It\n\
  \    provides accumulative concatenation of strings in quasi-linear time (instead of\n\
  \    quadratic time when strings are concatenated pairwise).\n\n\
  \    This implementation uses Bigstrings instead of strings. This removes the 16MB limit\n\
  \    on buffer size (on 32-bit machines), and improves I/O-performance when \
   reading/writing\n\
  \    from/to channels.\n"]

open! Import
include Base.Buffer.S

val big_contents : t -> Bigstring.t
[@@ocaml.doc
  " Return a copy of the current contents of the buffer as a bigstring.\n\
  \    The buffer itself is unchanged. "]

val volatile_contents : t -> Bigstring.t
[@@ocaml.doc
  " Return the actual underlying bigstring used by this bigbuffer.\n\
  \    No copying is involved.  To be safe, use and finish with the returned value\n\
  \    before calling any other function in this module on the same [Bigbuffer.t]. "]

val add_bigstring : t -> Bigstring.t -> unit
[@@ocaml.doc
  " [add_bigstring b s] appends the bigstring [s] at the end of the buffer [b]. "]

val add_bin_prot : t -> 'a Bin_prot.Type_class.writer -> 'a -> unit
[@@ocaml.doc
  " [add_bin_prot b writer x] appends the bin-protted representation of [x] at the end of\n\
  \    the buffer [b]. "]

val add_substitute : t -> (string -> string) -> string -> unit
[@@ocaml.doc
  " [add_substitute b f s] appends the string pattern [s] at the end\n\
  \    of the buffer [b] with substitution.\n\
  \    The substitution process looks for variables into\n\
  \    the pattern and substitutes each variable name by its value, as\n\
  \    obtained by applying the mapping [f] to the variable name. Inside the\n\
  \    string pattern, a variable name immediately follows a non-escaped\n\
  \    [$] character and is one of the following:\n\
  \    - a non empty sequence of alphanumeric or [_] characters,\n\
  \    - an arbitrary sequence of characters enclosed by a pair of\n\
  \      matching parentheses or curly brackets.\n\n\
  \    An escaped [$] character is a [$] that immediately follows a backslash\n\
  \    character; it then stands for a plain [$].\n\
  \    Raise [Caml.Not_found] or [Not_found_s] if the closing character of a\n\
  \    parenthesized variable cannot be found. "]

[@@@ocaml.text " "]

module Format : sig
  open Format

  val formatter_of_buffer : t -> formatter
  val bprintf : t -> ('a, formatter, unit) format -> 'a
end

module Printf : sig
  val bprintf : t -> ('a, unit, string, unit) format4 -> 'a
end

[@@@ocaml.text "/*"]

val __internal : t -> Bigbuffer_internal.t
[@@ocaml.doc " For Core.Bigbuffer, not for users! "]
