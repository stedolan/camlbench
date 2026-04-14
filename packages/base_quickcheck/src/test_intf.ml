open! Base

module type S = sig
  type t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val quickcheck_generator : t Generator.t
  val quickcheck_shrinker : t Shrinker.t
end

module type Test = sig
  module type S = S

  module Config : sig
    module Seed : sig
      type t =
        | Nondeterministic
        | Deterministic of string
      [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type t =
      { seed : Seed.t
            [@ocaml.doc
              " [seed] is used to initialize the pseudo-random state before running \
               tests of a\n\
              \          property. "]
      ; test_count : int
            [@ocaml.doc
              " [test_count] determines how many random values to test a property with. "]
      ; shrink_count : int
            [@ocaml.doc
              " [shrink_count] determines the maximum number of attempts to find a smaller\n\
              \          version of a value that fails a test. "]
      ; sizes : int Sequence.t
            [@ocaml.doc
              " [sizes] determines the progression of value sizes to generate while \
               testing.\n\
              \          Testing fails if [sizes] is not of length at least \
               [test_count]. "]
      }
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val default_config : Config.t
  [@@ocaml.doc
    " Defaults to a deterministic seed, [shrink_count] and [test_count] of 10_000 each,\n\
    \      and sizes ranging from 0 to 30. "]

  val run
    :  f:('a -> unit Or_error.t)
    -> ?config:(Config.t[@ocaml.doc " defaults to [default_config] "])
    -> ?examples:('a list[@ocaml.doc " defaults to the empty list "])
    -> (module S with type t = 'a)
    -> unit Or_error.t
  [@@ocaml.doc
    " Tests the property [f], failing if it raises or returns [Error _]. Tests [f] first\n\
    \      with any [examples], then with values from the given generator. Only random \
     values\n\
    \      count toward the [test_count] total, not values from [examples]. "]

  val run_exn
    :  f:('a -> unit)
    -> ?config:(Config.t[@ocaml.doc " defaults to [default_config] "])
    -> ?examples:('a list[@ocaml.doc " defaults to the empty list "])
    -> (module S with type t = 'a)
    -> unit
  [@@ocaml.doc " Like [run], but raises on failure. "]

  val result
    :  f:('a -> (unit, 'e) Result.t)
    -> ?config:(Config.t[@ocaml.doc " defaults to [default_config] "])
    -> ?examples:('a list[@ocaml.doc " defaults to the empty list "])
    -> (module S with type t = 'a)
    -> (unit, 'a * 'e) Result.t
  [@@ocaml.doc
    " Like [run], but does not catch exceptions raised by [f]. Allows arbitrary error\n\
    \      types and returns the input that failed along with the error. "]

  val with_sample
    :  f:('a Sequence.t -> unit Or_error.t)
    -> ?config:(Config.t[@ocaml.doc " defaults to [default_config] "])
    -> ?examples:('a list[@ocaml.doc " defaults to the empty list "])
    -> 'a Generator.t
    -> unit Or_error.t
  [@@ocaml.doc
    " Calls [f] with the sequence of values that [run] would get in the same\n\
    \      configuration. "]

  val with_sample_exn
    :  f:('a Sequence.t -> unit)
    -> ?config:(Config.t[@ocaml.doc " defaults to [default_config] "])
    -> ?examples:('a list[@ocaml.doc " defaults to the empty list "])
    -> 'a Generator.t
    -> unit
  [@@ocaml.doc " Like [with_sample], but raises on failure. "]
end
