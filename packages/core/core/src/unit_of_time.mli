[@@@ocaml.text
  " Represents a unit of time, e.g., that used by [Time.Span.to_string_hum]. Comparison\n\
  \    respects Nanosecond < Microsecond < Millisecond < Second < Minute < Hour < Day. "]

open! Import

type t =
  | Nanosecond
  | Microsecond
  | Millisecond
  | Second
  | Minute
  | Hour
  | Day
[@@deriving sexp, compare, enumerate, hash]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_enumerate_lib.Enumerable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]
