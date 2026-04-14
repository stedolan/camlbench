[@@@ocaml.text
  " This module extends {{!module:Base.Error}[Base.Error]} with [bin_io] and [diff]. "]

open! Import

include module type of struct
  include Base.Error
end
[@@ocaml.doc " @inline "]

include
  Info_intf.Extension with type t := t
[@@ocaml.doc " This include is the source of the bin_io and diff functions. "]

[@@@ocaml.text " @inline "]

[@@@ocaml.text
  " [Error.t] is {e not} wire-compatible with [Error.Stable.V1.t].  See info.mli for\n\
  \    details. "]

val failwiths
  :  ?strict:unit
  -> here:Lexing.position
  -> string
  -> 'a
  -> ('a -> Base.Sexp.t)
  -> _
[@@ocaml.doc
  " {[\n\
  \     failwiths ?strict ~here message a sexp_of_a\n\
  \     = Error.raise (Error.create ?strict ~here s a sexp_of_a)\n\
  \   ]}\n\n\
  \   As with [Error.create], [sexp_of_a a] is lazily computed when the error is converted\n\
  \   to a sexp. So if [a] is mutated in the time between the call to [failwiths] and the\n\
  \   sexp conversion, those mutations will be reflected in the error message. Use\n\
  \   [~strict:()] to force [sexp_of_a a] to be computed immediately.\n\n\
  \   In this signature we write [~here:Lexing.position] rather than\n\
  \   [~here:Source_code_position.t] to avoid a circular dependency. "]

val failwithp
  :  ?strict:unit
  -> Lexing.position
  -> string
  -> 'a
  -> ('a -> Base.Sexp.t)
  -> _
[@@deprecated "[since 2020-03] Use [failwiths] instead."]
