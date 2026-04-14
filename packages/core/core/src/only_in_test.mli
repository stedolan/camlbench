[@@@ocaml.text
  " This module can be used to safely expose functions and values in signatures\n\
  \    that should only be used in unit tests.\n\n\
  \    Under the hood, ['a t = 'a Lazy.t] and the only thing that ever forces them\n\
  \    is the [force] function below which should only be called in unit tests.\n\n\
  \    For example, suppose in some module, [type t] is actually an [int].  You\n\
  \    want to keep the type definition opaque, but use the underlying\n\
  \    representation in unit tests.  You could write in the ml:\n\n\
  \    {[\n\
  \      let test_to_int t = Only_in_test.return t\n\
  \      let test_of_int n = Only_in_test.return n]}\n\n\
  \    You would then expose in the mli:\n\n\
  \    {[\n\
  \      type t\n\
  \      val test_to_int : t -> int Only_in_test.t\n\
  \      val test_of_int : int -> t Only_in_test.t]}\n\n\
  \    Finally, if you have specific values that you might want to use in unit\n\
  \    tests, but that have top-level side-effects or take too long to compute, you\n\
  \    can delay the side-effects or computation until the unit tests are run by\n\
  \    writing, e.g.:\n\n\
  \    [let (test_special_value : t Only_in_test.t) =\n\
  \    Only_in_test.of_thunk (fun () ->  factorial 100)]\n\n\
  \    instead of\n\n\
  \    [let (test_special_value : t Only_in_test.t) =\n\
  \    Only_in_test.return (factorial 100)]\n"]

open! Import

type 'a t

include Monad.S with type 'a t := 'a t

val of_thunk : (unit -> 'a) -> 'a t
val force : 'a t -> 'a
