[@@@ocaml.text
  " Witnesses that express whether a type's values are always, sometimes, or never\n\
  \    immediate.\n\n\
  \    A value is immediate when it is internally represented unboxed, using one word of\n\
  \    memory rather than a pointer to a heap-allocated block.\n\n\
  \    Some examples:\n\n\
  \    - All [int] values are by definition immediate, i.e., unboxed, and so [int]\n\
  \      is always immediate.\n\n\
  \    - A ['a list] is either [[]], which is internally represented as 0 (immediate), \
   or a\n\
  \      non-empty list, which is represented as a pointer to a heap block (boxed), which\n\
  \      contains the first element and the pointer to the rest of the list.  Therefore \
   ['a\n\
  \      list] is sometimes immediate.\n\n\
  \    - All values of type ['a ref] are represented as a pointer to a heap block \
   containing\n\
  \      the actual values ['a].  Therefore ['a ref] is never immediate.\n\n\
  \    The witness values can be used to perform safe optimizations such as allowing a \
   more\n\
  \    efficient ['a array] blit operations if ['a] is always immediate.  These \
   witnesses can\n\
  \    also be used to perform safe conversions between immediate values of type ['a] and\n\
  \    [int] instead of using [Obj.magic].\n\n\
  \    {2 Converting between values and ints}\n\n\
  \    Consider an arbitrary type ['a] for which you have built a type-immediacy witness\n\
  \    using this interface. Let's call it [w : 'a t].\n\n\
  \    You can use the two following functions and [w] to cast back and forth values from\n\
  \    the type ['a] to the type [int]:\n\n\
  \    {[\n\
  \      val int_as_value : 'a t -> int -> 'a option\n\
  \      val value_as_int : 'a t -> 'a  -> int option\n\
  \    ]}\n\n\
  \    For the rest of this section, we will assume [int_as_value] and [value_as_int]\n\
  \    partially applied to [w].\n\n\
  \    Consider the following cases:\n\n\
  \    {ul {- let [v] be an immediate value.\n\n\
  \    Let [i] be the [int] that internally represents [v].  Then, [value_as_int v] \
   returns\n\
  \    [Some i].\n\n\
  \    We can also recover [v] by using the conversions that go the other way.  In\n\
  \    particular, [int_as_value i] returns [Some v].}}\n\n\
  \    {ul {- let [v] be a boxed value that cannot be converted to an [int].\n\n\
  \    [value_as_int v] returns [None] because there does not exist an int s.t. \
   [int_as_value\n\
  \    i] evaluates to [Some v].}}\n\n\
  \    {ul {- let [i] be an int that does not represent any value of type ['a]\n\n\
  \    [int_as_value i] returns [None].}}\n\n\
  \    {2 Faster *_exn functions and functions with boolean results}\n\n\
  \    [value_is_int v]     is a faster equivalent to [Option.is_some   (value_as_int v)].\n\
  \    [value_as_int_exn v] is a faster equivalent to [Option.value_exn (value_as_int \
   v)].\n\n\
  \    [int_is_value i]     is a faster equivalent to [Option.is_some   (int_as_value i)].\n\
  \    [int_as_value_exn i] is a faster equivalent to [Option.value_exn (int_as_value \
   i)].\n\n\
  \    These are lightweight functions that avoid allocating the option.  [value_is_int]\n\
  \    (resp [int_is_value]) can be used with [value_as_int_exn] (resp \
   [int_as_value_exn]) to\n\
  \    avoid both allocation or using a [try with] statement, paying only some small \
   amount\n\
  \    of CPU time for calling [value_is_int] (resp [int_is_value]):\n\n\
  \    {[\n\
  \      match value_as_int v with\n\
  \      | Some v -> some v\n\
  \      | None -> none\n\
  \    ]}\n\n\
  \    VS\n\n\
  \    {[\n\
  \      if value_is_int v\n\
  \      then some (value_as_int_exn v)\n\
  \      else none\n\
  \    ]}\n\n\
  \    {2 Example}\n\n\
  \    Consider the following type:\n\n\
  \    {[\n\
  \      type test =\n\
  \        | A\n\
  \        | B\n\
  \        | C of int\n\
  \      with typerep\n\
  \    ]}\n\n\
  \    Type [test] is sometimes immediate, as [A] is represented as [0], [B] as [1], and \
   [C]\n\
  \    is a boxed value.  We can construct a witness of type [test Sometimes.t] by using\n\
  \    [Sometimes.of_typerep] or [of_typerep] and extracting the witness.  Let's call the\n\
  \    witness [w] here.  We can now use it to safely convert between values of [test] and\n\
  \    [int]:\n\n\
  \    [Sometimes.value_as_int w A]      evaluates to [Some 0]\n\
  \    [Sometimes.value_as_int w B]      evaluates to [Some 1]\n\
  \    [Sometimes.value_as_int w (C 1)]  evaluates to [None]\n\n\
  \    [Sometimes.int_as_value w 0]      evaluates to [Some A]\n\
  \    [Sometimes.int_as_value w 1]      evaluates to [Some B]\n\
  \    [Sometimes.int_as_value w n]      evaluates to [None] for all other values n\n\n\
  \    Consider this other example:\n\n\
  \    {[\n\
  \      type test = bool with typerep\n\
  \    ]}\n\n\
  \    Type [test] is always immediate, since [true] is represented as [1] and [false] as\n\
  \    [0].  We can construct a witness of type [test Always.t] by using \
   [Always.of_typerep]\n\
  \    or [of_typerep] and extracting the witness.  Let's call the witness [w]:\n\n\
  \    [Always.value_as_int w false]      evaluates to [Some 0]\n\
  \    [Always.value_as_int w true]       evaluates to [Some 1]\n\n\
  \    [Always.value_as_int_exn w false]  evaluates to [0]\n\
  \    [Always.value_as_int_exn w true]   evaluates to [1]\n\n\
  \    [Always.int_as_value w 0]          evaluates to [Some false]\n\
  \    [Always.int_as_value w 1]          evaluates to [Some true]\n\
  \    [Always.int_as_value w (-1)]       evaluates to [None]\n\n\
  \    [Always.int_as_value_exn w 0]      evaluates to [false]\n\
  \    [Always.int_as_value_exn w 1]      evaluates to [true]\n\
  \    [Always.int_as_value_exn w (-1)]   raises\n\n\
  \    {2 N-ary types that are immediate independently of their type arguments}\n\n\
  \    We also provide [For_all_parameters_S*] functors.  Those are useful when one has a\n\
  \    type with type parameters, but knows that values of that type will always be \
   immediate\n\
  \    (for example) no matter what the actual parameter is.  They can use\n\
  \    [Always.For_all_parameters_S*] to obtain access to a polymorphic witness.\n\n\
  \    An exception is raised on functor application if such witness cannot be obtained.\n\
  \    That happens either because the witness depends on the actual type parameter, or\n\
  \    because the type has a different witness (e.g. [Sometimes] instead of [Always]).\n"]

open! Import

type 'a t

module Always : sig
  type 'a t

  val of_typerep : 'a Typerep.t -> 'a t option
  val of_typerep_exn : Source_code_position.t -> 'a Typerep.t -> 'a t
  val int_as_value : 'a t -> int -> 'a option
  val int_as_value_exn : 'a t -> int -> 'a
  val int_is_value : 'a t -> int -> bool
  val value_as_int : 'a t -> 'a -> int

  module For_all_parameters_S1 : functor (X : Typerepable.S1) -> sig
    val witness : unit -> _ X.t t
  end

  module For_all_parameters_S2 : functor (X : Typerepable.S2) -> sig
    val witness : unit -> (_, _) X.t t
  end

  module For_all_parameters_S3 : functor (X : Typerepable.S3) -> sig
    val witness : unit -> (_, _, _) X.t t
  end

  module For_all_parameters_S4 : functor (X : Typerepable.S4) -> sig
    val witness : unit -> (_, _, _, _) X.t t
  end

  module For_all_parameters_S5 : functor (X : Typerepable.S5) -> sig
    val witness : unit -> (_, _, _, _, _) X.t t
  end

  val int : int t
  val char : char t
  val bool : bool t
  val unit : unit t
end

module Sometimes : sig
  type 'a t

  val of_typerep : 'a Typerep.t -> 'a t option
  val of_typerep_exn : Source_code_position.t -> 'a Typerep.t -> 'a t
  val int_as_value : 'a t -> int -> 'a option
  val int_as_value_exn : 'a t -> int -> 'a
  val int_is_value : 'a t -> int -> bool
  val value_as_int : 'a t -> 'a -> int option
  val value_as_int_exn : 'a t -> 'a -> int
  val value_is_int : 'a t -> 'a -> bool

  module For_all_parameters_S1 : functor (X : Typerepable.S1) -> sig
    val witness : unit -> _ X.t t
  end

  module For_all_parameters_S2 : functor (X : Typerepable.S2) -> sig
    val witness : unit -> (_, _) X.t t
  end

  module For_all_parameters_S3 : functor (X : Typerepable.S3) -> sig
    val witness : unit -> (_, _, _) X.t t
  end

  module For_all_parameters_S4 : functor (X : Typerepable.S4) -> sig
    val witness : unit -> (_, _, _, _) X.t t
  end

  module For_all_parameters_S5 : functor (X : Typerepable.S5) -> sig
    val witness : unit -> (_, _, _, _, _) X.t t
  end

  val option : _ option t
  val list : _ list t
end

module Never : sig
  type 'a t

  val of_typerep : 'a Typerep.t -> 'a t option
  val of_typerep_exn : Source_code_position.t -> 'a Typerep.t -> 'a t

  module For_all_parameters_S1 : functor (X : Typerepable.S1) -> sig
    val witness : unit -> _ X.t t
  end

  module For_all_parameters_S2 : functor (X : Typerepable.S2) -> sig
    val witness : unit -> (_, _) X.t t
  end

  module For_all_parameters_S3 : functor (X : Typerepable.S3) -> sig
    val witness : unit -> (_, _, _) X.t t
  end

  module For_all_parameters_S4 : functor (X : Typerepable.S4) -> sig
    val witness : unit -> (_, _, _, _) X.t t
  end

  module For_all_parameters_S5 : functor (X : Typerepable.S5) -> sig
    val witness : unit -> (_, _, _, _, _) X.t t
  end

  val int32 : int32 t
  val int64 : int64 t
  val nativeint : nativeint t
  val float : float t
  val string : string t
  val bytes : bytes t
  val array : _ array t
  val ref_ : _ ref t
  val tuple2 : (_ * _) t
  val tuple3 : (_ * _ * _) t
  val tuple4 : (_ * _ * _ * _) t
  val tuple5 : (_ * _ * _ * _ * _) t
end

val of_typerep : 'a Typerep.t -> 'a t

type 'a dest =
  | Always of 'a Always.t
  | Sometimes of 'a Sometimes.t
  | Never of 'a Never.t
  | Unknown

val dest : 'a t -> 'a dest
val int_as_value : 'a t -> int -> 'a option
val int_as_value_exn : 'a t -> int -> 'a
val int_is_value : 'a t -> int -> bool
val value_as_int : 'a t -> 'a -> int option
val value_as_int_exn : 'a t -> 'a -> int
val value_is_int : 'a t -> 'a -> bool
