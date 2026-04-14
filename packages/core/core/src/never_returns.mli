[@@@ocaml.text
  " [never_returns] should be used as the return type of functions that don't return and\n\
  \    might block forever, rather than ['a] or [_].  This forces callers of such \
   functions\n\
  \    to have a call to [never_returns] at the call site, which makes it clear to readers\n\
  \    what's going on. We do not intend to use this type for functions such as \
   [failwithf]\n\
  \    that always raise an exception. "]

open! Import

type never_returns = Nothing.t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_never_returns : never_returns -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val never_returns : never_returns -> _
