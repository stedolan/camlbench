[@@@ocaml.text " Boolean expressions. "]

open! Import

[@@@ocaml.text
  " A blang is a boolean expression built up by applying the usual boolean operations to\n\
  \    properties that evaluate to true or false in some context.\n\n\
  \    {2 Usage}\n\n\
  \    For example, imagine writing a config file for an application that filters a \
   stream of\n\
  \    integers. Your goal is to keep only those integers that are multiples of either \
   -3 or\n\
  \    5. Using [Blang] for this task, the code might look like:\n\n\
  \    {[\n\
  \      module Property = struct\n\
  \        type t =\n\
  \          | Multiple_of of int\n\
  \          | Positive\n\
  \          | Negative\n\
  \        [@@deriving sexp]\n\n\
  \        let eval t num =\n\
  \          match t with\n\
  \          | Multiple_of n -> num % n = 0\n\
  \          | Positive      -> num > 0\n\
  \          | Negative      -> num < 0\n\
  \      end\n\n\
  \      type config = {\n\
  \        keep : Property.t Blang.t;\n\
  \      } [@@deriving sexp]\n\n\
  \      let config = {\n\
  \        keep =\n\
  \          Blang.t_of_sexp\n\
  \            Property.t_of_sexp\n\
  \            (Sexp.of_string\n\
  \               \"(or (and negative (multiple_of 3)) (and positive (multiple_of 5)))\";\n\
  \      }\n\n\
  \      let keep config num : bool =\n\
  \        Blang.eval config.keep (fun p -> Property.eval p num)\n\
  \    ]}\n\n\
  \    Note how [positive] and [negative] and [multiple_of] become operators in a small,\n\
  \    newly-defined boolean expression language that allows you to write statements like\n\
  \    [(and negative (multiple_of 3))].\n\n\
  \    {2 Blang sexp syntax}\n\n\
  \    The blang sexp syntax is almost exactly the derived one, except that:\n\n\
  \    1. Base properties are not marked explicitly.  Thus, if your base\n\
  \    property type has elements FOO, BAR, etc., then you could write\n\
  \    the following Blang s-expressions:\n\n\
  \    {v\n\
  \        FOO\n\
  \        (and FOO BAR)\n\
  \        (if FOO BAR BAZ)\n\
  \    v}\n\n\
  \    and so on.  Note that this gets in the way of using the blang\n\
  \    \"keywords\" in your value language.\n\n\
  \    2. [And] and [Or] take a variable number of arguments, so that one can\n\
  \    (and probably should) write\n\n\
  \    {v (and FOO BAR BAZ QUX) v}\n\n\
  \    instead of\n\n\
  \    {v (and FOO (and BAR (and BAZ QUX))) v}\n\n\
  \    If you want to see the derived sexp, use [Raw.sexp_of_t].\n"]

open Std_internal

type +'a t = private
  | True
  | False
  | And of 'a t * 'a t
  | Or of 'a t * 'a t
  | Not of 'a t
  | If of 'a t * 'a t * 'a t
  | Base of 'a
[@@ocaml.doc
  " Note that the sexps are not directly inferred from the type below -- there are lots of\n\
  \    fancy shortcuts.  Also, the sexps for ['a] must not look anything like blang sexps.\n\
  \    Otherwise [t_of_sexp] will fail.  The directly inferred sexps are available via\n\
  \    [Raw.sexp_of_t]. "]
[@@deriving bin_io ~localize, compare, equal, hash, sexp, sexp_grammar, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type +'a t := 'a t
  include Ppx_compare_lib.Comparable.S1 with type +'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type +'a t := 'a t
  include Ppx_hash_lib.Hashable.S1 with type +'a t := 'a t
  include Sexplib0.Sexpable.S1 with type +'a t := 'a t

  val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

  include Typerep_lib.Typerepable.S1 with type +'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Raw : sig
  type nonrec 'a t = 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " [Raw] provides the automatically derived [sexp_of_t], useful in debugging the actual\n\
  \    structure of the blang. "]

[@@@ocaml.text " {2 Smart constructors that simplify away constants whenever possible} "]

module type Constructors = sig
  val base : 'a -> 'a t
  val true_ : _ t
  val false_ : _ t

  val constant : bool -> _ t [@@ocaml.doc " [function true -> true_ | false -> false_] "]

  val not_ : 'a t -> 'a t

  val and_ : 'a t list -> 'a t [@@ocaml.doc " n-ary [And] "]

  val or_ : 'a t list -> 'a t [@@ocaml.doc " n-ary [Or] "]

  val if_ : 'a t -> 'a t -> 'a t -> 'a t [@@ocaml.doc " [if_ if then else] "]
end

include Constructors

module O : sig
  include Constructors

  val ( && ) : 'a t -> 'a t -> 'a t
  val ( || ) : 'a t -> 'a t -> 'a t

  val ( ==> ) : 'a t -> 'a t -> 'a t
  [@@ocaml.doc
    " [a ==> b] is \"a implies b\".  This is not [=>] to avoid making it look like a\n\
    \      comparison operator. "]

  val not : 'a t -> 'a t
end

val constant_value : 'a t -> bool option
[@@ocaml.doc " [constant_value t = Some b] iff [t = constant b] "]

[@@@ocaml.text
  " The following two functions are useful when one wants to pretend\n\
  \    that ['a t] has constructors [And] and [Or] of type ['a t list -> 'a t].\n\
  \    The pattern of use is\n\n\
  \    {[\n\
  \      match t with\n\
  \      | And (_, _) as t -> let ts = gather_conjuncts t in ...\n\
  \      | Or (_, _) as t -> let ts = gather_disjuncts t in ...\n\
  \      | ...\n\
  \    ]}\n\n\
  \    or, in case you also want to handle [True] (resp. [False]) as a special\n\
  \    case of conjunction (disjunction)\n\n\
  \    {[\n\
  \      match t with\n\
  \      | True | And (_, _) as t -> let ts = gather_conjuncts t in ...\n\
  \      | False | Or (_, _) as t -> let ts = gather_disjuncts t in ...\n\
  \      | ...\n\
  \    ]}\n"]

val gather_conjuncts : 'a t -> 'a t list
[@@ocaml.doc
  " [gather_conjuncts t] gathers up all toplevel conjuncts in [t].  For example,\n\
  \    {ul {- [gather_conjuncts (and_ ts) = ts] }\n\
  \    {- [gather_conjuncts (And (t1, t2)) = gather_conjuncts t1 @ gather_conjuncts t2] }\n\
  \    {- [gather_conjuncts True = [] ] }\n\
  \    {- [gather_conjuncts t = [t]] when [t] matches neither [And (_, _)] nor [True] } }\n"]

val gather_disjuncts : 'a t -> 'a t list
[@@ocaml.doc
  " [gather_disjuncts t] gathers up all toplevel disjuncts in [t].  For example,\n\
  \    {ul {- [gather_disjuncts (or_ ts) = ts] }\n\
  \    {- [gather_disjuncts (Or (t1, t2)) = gather_disjuncts t1 @ gather_disjuncts t2] }\n\
  \    {- [gather_disjuncts False = [] ] }\n\
  \    {- [gather_disjuncts t = [t]] when [t] matches neither [Or (_, _)] nor [False] } }\n"]

include Container.S1 with type 'a t := 'a t
include Quickcheckable.S1 with type 'a t := 'a t

include
  Monad with type 'a t := 'a t
[@@ocaml.doc
  " [Blang.t] sports a substitution monad:\n\
  \    {ul {- [return v] is [Base v] (think of [v] as a variable) }\n\
  \    {- [bind t f] replaces every [Base v] in [t] with [f v]\n\
  \    (think of [v] as a variable and [f] as specifying the term to\n\
  \    substitute for each variable) } }\n\n\
  \    Note: [bind t f] does short-circuiting, so [f] may not be called on every \
   variable in\n\
  \    [t]. "]

val values : 'a t -> 'a list
[@@ocaml.doc
  " [values t] forms the list containing every [v]\n\
  \    for which [Base v] is a subexpression of [t] "]

val eval : 'a t -> ('a -> bool) -> bool
[@@ocaml.doc
  " [eval t f] evaluates the proposition [t] relative to an environment\n\
  \    [f] that assigns truth values to base propositions. "]

val eval_set
  :  universe:('elt, 'comparator) Set.t Lazy.t
  -> ('a -> ('elt, 'comparator) Set.t)
  -> 'a t
  -> ('elt, 'comparator) Set.t
[@@ocaml.doc
  " [eval_set ~universe set_of_base expression] returns the subset of elements [e] in\n\
  \    [universe] that satisfy [eval expression (fun base -> Set.mem (set_of_base base) \
   e)].\n\n\
  \    [eval_set] assumes, but does not verify, that [set_of_base] always returns a \
   subset of\n\
  \    [universe]. If this doesn't hold, then [eval_set]'s result may contain elements not\n\
  \    in [universe].\n\n\
  \    [And set1 set2] represents the elements that are both in [set1] and [set2], thus in\n\
  \    the intersection of the two sets. Symmetrically, [Or set1 set2] represents the \
   union\n\
  \    of [set1] and [set2]. "]

val specialize : 'a t -> ('a -> [ `Known of bool | `Unknown ]) -> 'a t
[@@ocaml.doc
  " [specialize t f] partially evaluates [t] according to a\n\
  \    perhaps-incomplete assignment [f] of the values of base propositions.\n\
  \    The following laws (at least partially) characterize its behavior.\n\n\
  \    - [specialize t (fun _ -> `Unknown) = t]\n\n\
  \    - [specialize t (fun x -> `Known (f x)) = constant (eval t f)]\n\n\
  \    - [List.for_all (values (specialize t g)) ~f:(fun x -> g x = `Unknown)]\n\n\
  \    - {[\n\
  \      if\n\
  \        List.for_all (values t) ~f:(fun x ->\n\
  \          match g x with\n\
  \          | `Known b -> b = f x\n\
  \          | `Unknown -> true)\n\
  \      then\n\
  \        eval t f = eval (specialize t g) f\n\
  \    ]}\n"]

module type Monadic = sig
  module M : Monad.S

  val map : 'a t -> f:('a -> 'b M.t) -> 'b t M.t
  val bind : 'a t -> f:('a -> 'b t M.t) -> 'b t M.t
  val eval : 'a t -> f:('a -> bool M.t) -> bool M.t
end

module For_monad : functor (M : Monad.S) -> Monadic with module M := M
[@@ocaml.doc " Generalizes some of the blang operations above to work in a monad. "]

val invariant : 'a t -> unit

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t = private
      | True
      | False
      | And of 'a t * 'a t
      | Or of 'a t * 'a t
      | Not of 'a t
      | If of 'a t * 'a t * 'a t
      | Base of 'a
    [@@deriving
      sexp, sexp_grammar, bin_io ~localize, stable_witness, compare, equal, hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

      include Bin_prot.Binable.S_local1 with type 'a t := 'a t

      val stable_witness
        :  'a Ppx_stable_witness_runtime.Stable_witness.t
        -> 'a t Ppx_stable_witness_runtime.Stable_witness.t

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
