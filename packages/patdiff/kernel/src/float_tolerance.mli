open Core
open Import

val apply
  :  string Patience_diff.Hunks.t
  -> Percent.t
  -> context:int
  -> string Patience_diff.Hunks.t
[@@ocaml.doc
  " [apply hunks tolerance ~context] converts diff ranges into context if the diff looks\n\
  \    like floating point numbers that changed by less than [tolerance].  If necessary,\n\
  \    narrows or splits the resulting hunks to limit context to [context] lines.\n\n\
  \    Float tolerance must be applied before refinement. "]
