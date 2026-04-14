[@@@ocaml.text
  " Quickcheck is a library that uses predicate-based tests and pseudo-random inputs to\n\
  \    automate testing.\n\n\
  \    For examples see {e lib/base_quickcheck/examples}.\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"quickcheck_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "quickcheck_intf.ml.before-ppx"
;;

open! Import
open Base_quickcheck

module type Generator = sig
  [@@@ocaml.text
    " An ['a t] a generates values of type ['a] with a specific probability \
     distribution.\n\n\
    \      Generators are constructed as functions that produce a value from a splittable\n\
    \      pseudorandom number generator (see [Splittable_random]), with a [~size] \
     argument\n\
    \      threaded through to bound the size of the result value and the depth of \
     recursion.\n\n\
    \      There is no prescribed semantics for [size] other than that it must be \
     non-negative.\n\
    \      Non-recursive generators are free to ignore it, and recursive generators need \
     only\n\
    \      make sure it decreases in recursive calls and that recursion bottoms out at \
     0. "]

  type +'a t = 'a Generator.t

  val create : (size:int -> random:Splittable_random.t -> 'a) -> 'a t
  val generate : 'a t -> size:int -> random:Splittable_random.t -> 'a

  include
    Monad.S with type 'a t := 'a t
  [@@ocaml.doc
    " Generators form a monad.  [t1 >>= fun x -> t2] replaces each value [x] in [t1] with\n\
    \      the values in [t2]; each value's probability is the product of its \
     probability in\n\
    \      [t1] and [t2].\n\n\
    \      This can be used to form distributions of related values.  For instance, the\n\
    \      following expression creates a distribution of pairs [x,y] where [x <= y]:\n\n\
    \      {[\n\
    \        Int.gen\n\
    \        >>= fun x ->\n\
    \        Int.gen_incl x Int.max_value\n\
    \        >>| fun y ->\n\
    \        x, y\n\
    \      ]}\n\
    \  "]

  include Applicative.S with type 'a t := 'a t

  val size : int t [@@ocaml.doc " [size = create (fun ~size _ -> size)] "]

  val with_size : 'a t -> size:int -> 'a t
  [@@ocaml.doc
    " [with_size t ~size = create (fun ~size:_ random -> generate t ~size random)] "]

  val bool : bool t
  val char : char t
  val char_digit : char t
  val char_lowercase : char t
  val char_uppercase : char t
  val char_alpha : char t
  val char_alphanum : char t
  val char_print : char t
  val char_whitespace : char t
  val singleton : 'a -> 'a t
  val doubleton : 'a -> 'a -> 'a t

  val of_list : 'a list -> 'a t
  [@@ocaml.doc
    " Produce any of the given values, weighted equally.\n\n\
    \      [of_list [ v1 ; ... ; vN ] = union [ singleton v1 ; ... ; singleton vN ]] "]

  val union : 'a t list -> 'a t
  [@@ocaml.doc
    " Combine arbitrary generators, weighted equally.\n\n\
    \      [ union [ g1 ; ... ; gN ] = weighted_union [ (1.0, g1) ; ... ; (1.0, gN) ] ] "]

  val of_sequence : p:float -> 'a Sequence.t -> 'a t
  [@@ocaml.doc
    " Generator for the values from a potentially infinite sequence.  Chooses each value\n\
    \      with probability [p], or continues with probability [1-p].  Must satisfy [0. \
     < p &&\n\
    \      p <= 1.]. "]

  val tuple2 : 'a t -> 'b t -> ('a * 'b) t
  val tuple3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val tuple4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t
  val tuple5 : 'a t -> 'b t -> 'c t -> 'd t -> 'e t -> ('a * 'b * 'c * 'd * 'e) t

  val tuple6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> ('a * 'b * 'c * 'd * 'e * 'f) t

  val variant2 : 'a t -> 'b t -> [ `A of 'a | `B of 'b ] t
  val variant3 : 'a t -> 'b t -> 'c t -> [ `A of 'a | `B of 'b | `C of 'c ] t

  val variant4
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd ] t

  val variant5
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e ] t

  val variant6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e | `F of 'f ] t

  val geometric : int -> p:float -> int t
  [@@ocaml.doc
    " [geometric init ~p] produces a geometric distribution (think \"radioactive decay\")\n\
    \      that produces [init] with probability [p], and otherwise effectively \
     recursively\n\
    \      chooses from [geometric (init+1) ~p]. The implementation can be more \
     efficient than\n\
    \      actual recursion. Must satisfy [0. <= p && p <= 1.]. "]

  val small_non_negative_int : int t
  [@@ocaml.doc
    " [small_non_negative_int] produces a non-negative int of a tractable size, e.g.\n\
    \      allocating a value of this size should not run out of memory. "]

  val small_positive_int : int t
  [@@ocaml.doc
    " [small_positive_int] produces a positive int of a tractable size, e.g. allocating a\n\
    \      value of this size should not run out of memory. "]

  val fn : 'a Observer.t -> 'b t -> ('a -> 'b) t
  [@@ocaml.doc
    " Generators for functions; take observers for inputs and a generator for outputs. "]

  val fn2 : 'a Observer.t -> 'b Observer.t -> 'c t -> ('a -> 'b -> 'c) t

  val fn3
    :  'a Observer.t
    -> 'b Observer.t
    -> 'c Observer.t
    -> 'd t
    -> ('a -> 'b -> 'c -> 'd) t

  val fn4
    :  'a Observer.t
    -> 'b Observer.t
    -> 'c Observer.t
    -> 'd Observer.t
    -> 'e t
    -> ('a -> 'b -> 'c -> 'd -> 'e) t

  val fn5
    :  'a Observer.t
    -> 'b Observer.t
    -> 'c Observer.t
    -> 'd Observer.t
    -> 'e Observer.t
    -> 'f t
    -> ('a -> 'b -> 'c -> 'd -> 'e -> 'f) t

  val fn6
    :  'a Observer.t
    -> 'b Observer.t
    -> 'c Observer.t
    -> 'd Observer.t
    -> 'e Observer.t
    -> 'f Observer.t
    -> 'g t
    -> ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g) t

  val compare_fn : 'a Observer.t -> ('a -> 'a -> int) t
  [@@ocaml.doc
    " Generator for comparison functions; result is guaranteed to be a partial order. "]

  val equal_fn : 'a Observer.t -> ('a -> 'a -> bool) t
  [@@ocaml.doc
    " Generator for equality functions; result is guaranteed to be an equivalence\n\
    \      relation. "]

  val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
  [@@ocaml.doc
    " [filter_map t ~f] produces [y] for every [x] in [t] such that [f x = Some y]. "]

  val filter : 'a t -> f:('a -> bool) -> 'a t
  [@@ocaml.doc " [filter t ~f] produces every [x] in [t] such that [f x = true]. "]

  val recursive_union : 'a t list -> f:('a t -> 'a t list) -> 'a t
  [@@ocaml.doc
    " Generator for recursive data type with multiple clauses. At size 0, chooses only\n\
    \      among the non-recursive cases; at sizes greater than 0, chooses among \
     non-recursive\n\
    \      and recursive cases, calling the recursive cases with decremented size.\n\n\
    \      {[\n\
    \        type tree = Leaf | Node of tree * int * tree;;\n\
    \        recursive_union [return Leaf] ~f:(fun self ->\n\
    \          [let%map left = self\n\
    \           and int = Int.gen\n\
    \           and right = self\n\
    \           in Node (left, int, right)])\n\
    \      ]} "]

  val weighted_recursive_union
    :  (float * 'a t) list
    -> f:('a t -> (float * 'a t) list)
    -> 'a t
  [@@ocaml.doc
    " Like [recursive_union], with the addition of non-uniform weights for each clause. "]

  val fixed_point : ('a t -> 'a t) -> 'a t
  [@@ocaml.doc
    " Fixed-point generator. Use [size] to bound the size of the value and the depth of\n\
    \      the recursion. There is no prescribed semantics for [size] except that it \
     must be\n\
    \      non-negative. For example, the following produces a naive generator for natural\n\
    \      numbers:\n\n\
    \      {[\n\
    \        fixed_point (fun self ->\n\
    \          match%bind size with\n\
    \          | 0 -> singleton 0\n\
    \          | n -> with_size self ~size:(n-1) >>| Int.succ)\n\
    \      ]}\n\
    \  "]

  val weighted_union : (float * 'a t) list -> 'a t
  [@@ocaml.doc
    " [weighted_union alist] produces a generator that combines the distributions of each\n\
    \      [t] in [alist] with the associated weights, which must be finite positive \
     floating\n\
    \      point values. "]

  val of_fun : (unit -> 'a t) -> 'a t
  [@@ocaml.doc
    " [of_fun f] produces a generator that lazily applies [f].\n\n\
    \      It is recommended that [f] not be memoized.  Instead, spread out the work of\n\
    \      generating a whole distribution over many [of_fun] calls combined with\n\
    \      [weighted_union].  This allows lazily generated generators to be garbage \
     collected\n\
    \      after each test and the relevant portions cheaply recomputed in subsequent \
     tests,\n\
    \      rather than accumulating without bound over time. "]

  val list : 'a t -> 'a list t
  [@@ocaml.doc
    " Generators for lists, choosing each element independently from the given element\n\
    \      generator. [list] and [list_non_empty] distribute [size] among the list \
     length and\n\
    \      the sizes of each element. [list_non_empty] never generates the empty list.\n\
    \      [list_with_length] generates lists of the given length, and distributes \
     [size] among\n\
    \      the sizes of the elements. "]

  val list_non_empty : 'a t -> 'a list t
  val list_with_length : int -> 'a t -> 'a list t
end

module type Deriving_hash = sig
  type t [@@deriving hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Observer = sig
  [@@@ocaml.text
    " An ['a Quickcheck.Observer.t] represents a hash function on ['a].  Observers are\n\
    \      used to construct distributions of random functions; see \
     [Quickcheck.Generator.fn].\n\n\
    \      Like generators, observers have a [~size] argument that is threaded through \
     to bound\n\
    \      the depth of recursion in potentially infinite cases.  For finite values, \
     [size] can\n\
    \      be ignored.\n\n\
    \      For hashable types, one can construct an observer using [of_hash].  For other \
     types,\n\
    \      use the built-in observers and observer combinators below, or use [create] \
     directly.\n\
    \  "]

  type -'a t = 'a Observer.t

  val create : ('a -> size:int -> hash:Hash.state -> Hash.state) -> 'a t
  val observe : 'a t -> 'a -> size:int -> hash:Hash.state -> Hash.state

  val of_hash : (module Deriving_hash with type t = 'a) -> 'a t
  [@@ocaml.doc " [of_hash] creates an observer for any hashable type. "]

  val bool : bool t
  val char : char t

  val doubleton : ('a -> bool) -> 'a t
  [@@ocaml.doc
    " [doubleton f] maps values to two \"buckets\" (as described in [t] above),\n\
    \      depending on whether they satisfy [f]. "]

  val enum : int -> f:('a -> int) -> 'a t
  [@@ocaml.doc
    " [enum n ~f] maps values to [n] buckets, where [f] produces the index for a bucket\n\
    \      from [0] to [n-1] for each value. "]

  val of_list : 'a list -> equal:('a -> 'a -> bool) -> 'a t
  [@@ocaml.doc
    " [of_list list ~equal] maps values in [list] to separate buckets, and compares\n\
    \      observed values to the elements of [list] using [equal]. "]

  val fixed_point : ('a t -> 'a t) -> 'a t
  [@@ocaml.doc
    " Fixed point observer for recursive types. For example:\n\n\
    \      {[\n\
    \        let sexp_obs =\n\
    \          fixed_point (fun sexp_t ->\n\
    \            unmap (variant2 string (list sexp_t))\n\
    \              ~f:(function\n\
    \                | Sexp.Atom atom -> `A atom\n\
    \                | Sexp.List list -> `B list))\n\
    \      ]}\n\
    \  "]

  val variant2 : 'a t -> 'b t -> [ `A of 'a | `B of 'b ] t
  val variant3 : 'a t -> 'b t -> 'c t -> [ `A of 'a | `B of 'b | `C of 'c ] t

  val variant4
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd ] t

  val variant5
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e ] t

  val variant6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e | `F of 'f ] t

  val of_predicate : 'a t -> 'a t -> f:('a -> bool) -> 'a t
  [@@ocaml.doc
    " [of_predicate t1 t2 ~f] combines [t1] and [t2], where [t1] observes values that\n\
    \      satisfy [f] and [t2] observes values that do not satisfy [f]. "]

  val comparison : compare:('a -> 'a -> int) -> eq:'a -> lt:'a t -> gt:'a t -> 'a t
  [@@ocaml.doc
    " [comparison ~compare ~eq ~lt ~gt] combines observers [lt] and [gt], where [lt]\n\
    \      observes values less than [eq] according to [compare], and [gt] observes values\n\
    \      greater than [eq] according to [compare]. "]

  val singleton : unit -> _ t [@@ocaml.doc " maps all values to a single bucket. "]

  val unmap : 'a t -> f:('b -> 'a) -> 'b t
  [@@ocaml.doc " [unmap t ~f] applies [f] to values before observing them using [t]. "]

  val tuple2 : 'a t -> 'b t -> ('a * 'b) t
  val tuple3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val tuple4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t
  val tuple5 : 'a t -> 'b t -> 'c t -> 'd t -> 'e t -> ('a * 'b * 'c * 'd * 'e) t

  val tuple6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> ('a * 'b * 'c * 'd * 'e * 'f) t

  val fn : 'a Generator.t -> 'b t -> ('a -> 'b) t
  [@@ocaml.doc
    " Observer for function type.  [fn gen t] observes a function by generating random\n\
    \      inputs from [gen], applying the function, and observing the output using [t]. "]

  val of_fun : (unit -> 'a t) -> 'a t
  [@@ocaml.doc
    " [of_fun f] produces an observer that lazily applies [f].\n\n\
    \      It is recommended that [f] should not do a lot of expensive work and should \
     not be\n\
    \      memoized.  Instead, spread out the work of generating an observer over many \
     [of_fun]\n\
    \      calls combined with, e.g., [variant] or [tuple].  This allows lazily generated\n\
    \      observers to be garbage collected after each test and the relevant portions \
     cheaply\n\
    \      recomputed in subsequent tests, rather than accumulating without bound over \
     time. "]
end

module type Shrinker = sig
  [@@@ocaml.text
    " A ['a Quickcheck.Shrinker.t] takes a value of type ['a] and produces similar values\n\
    \      that are smaller by some metric.\n\n\
    \      The defined shrinkers generally try to make a single change for each value \
     based on\n\
    \      the assumption that the first resulting value that preserves the desired \
     property\n\
    \      will be used to create another sequence of shrunk values.\n\n\
    \      Within [Quickcheck.test] the shrinker is used as described above.\n\n\
    \      Shrinkers aim to aid understanding of what's causing an error by reducing the \
     input\n\
    \      down to just the elements making it fail.  The default shrinkers remove \
     elements of\n\
    \      compound structures, but leave atomic values alone.  For example, the default \
     list\n\
    \      shrinker tries removing elements from the list, but the default int shrinker \
     does\n\
    \      nothing.  This default strikes a balance between performance and precision.\n\
    \      Individual tests can use different shrinking behavior as necessary.\n\n\
    \      See lib/base_quickcheck/examples/shrinker_example.ml for some example \
     shrinkers.\n\
    \  "]

  type 'a t = 'a Shrinker.t

  val shrink : 'a t -> 'a -> 'a Sequence.t
  val create : ('a -> 'a Sequence.t) -> 'a t
  val empty : unit -> 'a t
  val bool : bool t
  val char : char t
  val map : 'a t -> f:('a -> 'b) -> f_inverse:('b -> 'a) -> 'b t
  val filter : 'a t -> f:('a -> bool) -> 'a t

  val filter_map : 'a t -> f:('a -> 'b option) -> f_inverse:('b -> 'a) -> 'b t
  [@@ocaml.doc
    " Filters and maps according to [f], and provides input to [t] via [f_inverse]. Only\n\
    \      the [f] direction produces options, intentionally. "]

  val tuple2 : 'a t -> 'b t -> ('a * 'b) t
  val tuple3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val tuple4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t
  val tuple5 : 'a t -> 'b t -> 'c t -> 'd t -> 'e t -> ('a * 'b * 'c * 'd * 'e) t

  val tuple6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> ('a * 'b * 'c * 'd * 'e * 'f) t

  val variant2 : 'a t -> 'b t -> [ `A of 'a | `B of 'b ] t
  val variant3 : 'a t -> 'b t -> 'c t -> [ `A of 'a | `B of 'b | `C of 'c ] t

  val variant4
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd ] t

  val variant5
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e ] t

  val variant6
    :  'a t
    -> 'b t
    -> 'c t
    -> 'd t
    -> 'e t
    -> 'f t
    -> [ `A of 'a | `B of 'b | `C of 'c | `D of 'd | `E of 'e | `F of 'f ] t

  val fixed_point : ('a t -> 'a t) -> 'a t
  [@@ocaml.doc
    " [fixed_point] assists with shrinking structures recursively. Its advantage over\n\
    \      directly using [rec] in the definition of the shrinker is that it causes lazy\n\
    \      evaluation where possible. "]
end

module type S = sig
  type t

  val quickcheck_generator : t Generator.t
  val quickcheck_observer : t Observer.t
  val quickcheck_shrinker : t Shrinker.t
end

module type S1 = sig
  type 'a t

  val quickcheck_generator : 'a Generator.t -> 'a t Generator.t
  val quickcheck_observer : 'a Observer.t -> 'a t Observer.t
  val quickcheck_shrinker : 'a Shrinker.t -> 'a t Shrinker.t
end

module type S2 = sig
  type ('a, 'b) t

  val quickcheck_generator : 'a Generator.t -> 'b Generator.t -> ('a, 'b) t Generator.t
  val quickcheck_observer : 'a Observer.t -> 'b Observer.t -> ('a, 'b) t Observer.t
  val quickcheck_shrinker : 'a Shrinker.t -> 'b Shrinker.t -> ('a, 'b) t Shrinker.t
end

module type S_range = sig
  include S

  val gen_incl : t -> t -> t Generator.t
  [@@ocaml.doc
    " [gen_incl lower_bound upper_bound] produces values between [lower_bound] and\n\
    \      [upper_bound], inclusive.  It uses an ad hoc distribution that stresses \
     boundary\n\
    \      conditions more often than a uniform distribution, while still able to \
     produce any\n\
    \      value in the range.  Raises if [lower_bound > upper_bound]. "]

  val gen_uniform_incl : t -> t -> t Generator.t
  [@@ocaml.doc
    " [gen_uniform_incl lower_bound upper_bound] produces a generator for values uniformly\n\
    \      distributed between [lower_bound] and [upper_bound], inclusive.  Raises if\n\
    \      [lower_bound > upper_bound]. "]
end

module type S_int = sig
  include S_range

  val gen_log_uniform_incl : t -> t -> t Generator.t
  [@@ocaml.doc
    " [gen_log_uniform_incl lower_bound upper_bound] produces a generator for values\n\
    \      between [lower_bound] and [upper_bound], inclusive, where the number of bits \
     used to\n\
    \      represent the value is uniformly distributed.  Raises if [(lower_bound < 0) ||\n\
    \      (lower_bound > upper_bound)]. "]

  val gen_log_incl : t -> t -> t Generator.t
  [@@ocaml.doc
    " [gen_log_incl lower_bound upper_bound] is like [gen_log_uniform_incl], but weighted\n\
    \      slightly more in favor of generating [lower_bound] and [upper_bound]\n\
    \      specifically. "]
end

type seed =
  [ `Deterministic of string
  | `Nondeterministic
  ]
[@@ocaml.doc
  " [seed] specifies how to initialize a pseudo-random number generator.  When multiple\n\
  \    tests share a deterministic seed, they each get a separate copy of the random\n\
  \    generator's state; random choices in one test do not affect those in another.  The\n\
  \    nondeterministic seed causes a fresh random state to be generated \
   nondeterministically\n\
  \    for each test. "]

type shrink_attempts =
  [ `Exhaustive
  | `Limit of int
  ]

module type Quickcheck_config = sig
  val default_seed : seed
  [@@ocaml.doc
    " [default_seed] is used initialize the pseudo-random generator that chooses random\n\
    \      values from generators, in each test that is not provided its own seed. "]

  val default_sizes : int Sequence.t
  [@@ocaml.doc
    " [default_sizes] determines the default sequence of sizes used in generating\n\
    \      values. "]

  val default_trial_count : int
  [@@ocaml.doc
    " [default_trial_count] determines the number of trials per test, except in tests\n\
    \      that explicitly override it. "]

  val default_can_generate_trial_count : int
  [@@ocaml.doc
    " [default_can_generate_trial_count] determines the number of trials used in attempts\n\
    \      to generate satisfying values, except in tests that explicitly override it. "]

  val default_shrink_attempts : shrink_attempts
  [@@ocaml.doc
    " [default_shrink_attempts] determines the number of attempts at shrinking\n\
    \      when running [test] or [iter] with [~shrinker] and without\n\
    \      [~shrink_attempts] "]
end

module type Quickcheck_configured = sig
  include Quickcheck_config

  val random_value : ?seed:seed -> ?size:int -> 'a Generator.t -> 'a
  [@@ocaml.doc
    " [random_value gen] produces a single value chosen from [gen] using [seed]. "]

  val iter
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> ?trials:int
    -> 'a Generator.t
    -> f:('a -> unit)
    -> unit
  [@@ocaml.doc
    " [iter gen ~f] runs [f] on up to [trials] different values generated by [gen]. It\n\
    \      stops successfully after [trials] successful trials or if [gen] runs out of \
     values.\n\
    \      It raises an exception if [f] raises an exception. "]

  val test
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> ?trials:int
    -> ?shrinker:'a Shrinker.t
    -> ?shrink_attempts:shrink_attempts
    -> ?sexp_of:('a -> Base.Sexp.t)
    -> ?examples:'a list
    -> 'a Generator.t
    -> f:('a -> unit)
    -> unit
  [@@ocaml.doc
    " [test gen ~f] is like [iter], with optional concrete [examples] that are tested\n\
    \      before values from [gen], and additional information provided on failure. If \
     [f]\n\
    \      raises an exception and [sexp_of] is provided, the exception is re-raised \
     with a\n\
    \      description of the random input that triggered the failure. If [f] raises an\n\
    \      exception and [shrinker] is provided, it will be used to attempt to shrink \
     the value\n\
    \      that caused the exception with re-raising behaving the same as for unshrunk \
     inputs.\n\
    \  "]

  val test_or_error
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> ?trials:int
    -> ?shrinker:'a Shrinker.t
    -> ?shrink_attempts:shrink_attempts
    -> ?sexp_of:('a -> Base.Sexp.t)
    -> ?examples:'a list
    -> 'a Generator.t
    -> f:('a -> unit Or_error.t)
    -> unit Or_error.t
  [@@ocaml.doc
    " [test_or_error] is like [test], except failure is determined using [Or_error.t]. Any\n\
    \      exceptions raised by [f] are also treated as failures. "]

  val test_can_generate
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> ?trials:int
    -> ?sexp_of:('a -> Base.Sexp.t)
    -> 'a Generator.t
    -> f:('a -> bool)
    -> unit
  [@@ocaml.doc
    " [test_can_generate gen ~f] is useful for testing [gen] values, to make sure they can\n\
    \      generate useful examples. It tests [gen] by generating up to [trials] values \
     and\n\
    \      passing them to [f]. Once a value satisfies [f], the iteration stops. If no \
     values\n\
    \      satisfy [f], [test_can_generate] raises an exception. If [sexp_of] is \
     provided, the\n\
    \      exception includes all of the generated values. "]

  val test_distinct_values
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> ?sexp_of:('a -> Base.Sexp.t)
    -> 'a Generator.t
    -> trials:int
    -> distinct_values:int
    -> compare:('a -> 'a -> int)
    -> unit
  [@@ocaml.doc
    " [test_distinct_values gen] is useful for testing [gen] values, to make sure they\n\
    \      create sufficient distinct values. It tests [gen] by generating up to [trials]\n\
    \      values and making sure at least [distinct_values] of the resulting values are \
     unique\n\
    \      with respect to [compare]. If too few distinct values are generated,\n\
    \      [test_distinct_values] raises an exception. If [sexp_of] is provided, the \
     exception\n\
    \      includes the values generated. "]

  val random_sequence
    :  ?seed:seed
    -> ?sizes:int Sequence.t
    -> 'a Generator.t
    -> 'a Sequence.t
  [@@ocaml.doc
    " [random_sequence ~seed gen] produces a sequence of values chosen from [gen]. "]
end

module type Syntax = sig
  module Generator : Generator

  module Open_on_rhs :
    Generator
    with type 'a t := 'a Generator.t
     and module Let_syntax := Generator.Let_syntax

  include
    Monad.Syntax
    with type 'a t := 'a Generator.t
     and module Let_syntax.Let_syntax.Open_on_rhs = Open_on_rhs
end
[@@ocaml.doc
  " Includes [Let_syntax] from [Monad.Syntax]. Sets [Open_on_rhs] to be all of\n\
  \    [Generator], except that it does not shadow [Let_syntax] itself. Both [Generator] \
   and\n\
  \    [Open_on_rhs] are meant to be destructively assigned. "]

module type Quickcheck = sig
  type nonrec seed = seed
  type nonrec shrink_attempts = shrink_attempts

  module Generator : Generator
  module Observer : Observer
  module Shrinker : Shrinker

  module type S = S
  module type S1 = S1
  module type S2 = S2
  module type S_int = S_int
  module type S_range = S_range

  include Syntax with module Generator := Generator and module Open_on_rhs := Generator

  module type Quickcheck_config = Quickcheck_config
  module type Quickcheck_configured = Quickcheck_configured

  include Quickcheck_configured [@@ocaml.doc " with a default config "]

  module Configure : functor (Config : Quickcheck_config) -> Quickcheck_configured
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
