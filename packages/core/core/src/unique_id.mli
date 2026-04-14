[@@@ocaml.text " Functors for creating modules that mint unique identifiers. "]

open! Import
open Unique_id_intf

module type Id = Id

module Int : () -> Id with type t = private int
[@@ocaml.doc
  " An abstract unique identifier based on ordinary OCaml integers.  Be careful, this may\n\
  \    easily overflow on 32-bit platforms!  [Int63] is a safer choice for portability.\n\n\
  \    [Int] is useful when one is passing unique ids to C and needs a guarantee as to \
   their\n\
  \    representation.  [Int] is always represented as an integer, while [Int63] is \
   either an\n\
  \    integer (on 64-bit machines) or a pointer (on 32-bit machines).\n\n\
  \    The generated ids will therefore be fast to generate and not use much memory.  If \
   you\n\
  \    do not have very stringent requirements on the size, speed, and ordering of your \
   IDs\n\
  \    then you should use the UUIDM library instead, which will give you a truly unique \
   id,\n\
  \    even amongst different runs and different machines. "]

module Int63 : () -> Id with type t = private Int63.t
[@@ocaml.doc " An abstract unique identifier based on 63 bit integers. "]
