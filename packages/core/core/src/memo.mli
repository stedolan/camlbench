open! Import

[@@@ocaml.text
  " Memoization of OCaml functions of a single argument.\n\n\
  \    The default caching policy is to remember everything for the lifetime of the \
   returned\n\
  \    closure, but [cache_size_bound] allows one to specify an upper bound on cache size.\n\
  \    Whenever a cache entry must be forgotten in order to obey this bound, we pick the\n\
  \    least-recently-used one. The functions raise exceptions if [cache_size_bound] is\n\
  \    negative or zero.\n\n\
  \    As you can tell from the type, the function that is memoized is the function of the\n\
  \    first argument. To memoize a function with multiple arguments, pack them up in a\n\
  \    tuple. See ../test/src/memo_argument.mlt for some examples.\n\n\
  \    This module does not detect or prevent infinite loops (e.g., due to a recursive \
   call\n\
  \    that repeats an argument).\n\n\
  \    The implementation is not thread-safe.\n"]

type ('a, 'b) fn = 'a -> 'b
[@@ocaml.doc " A type definition to indicate that the expected use outputs a function "]

val general
  :  ?hashable:'a Hashtbl.Hashable.t
  -> ?cache_size_bound:int
  -> ('a -> 'b)
  -> ('a, 'b) fn
[@@ocaml.doc
  " Returns a memoized version of a function with a single argument.\n\n\
  \    Of course, if the supplied function is recursive, only the outer calls are \
   memoized;\n\
  \    recursive calls are not. For that, see [recursive] below.\n"]

val recursive
  :  hashable:'a Hashtbl.Hashable.t
  -> ?cache_size_bound:int
  -> (('a -> 'b) -> 'a -> 'b)
  -> ('a, 'b) fn
[@@ocaml.doc
  " [recursive] is like [general] but can be used to memoize recursive functions in such a\n\
  \    way that the recursive calls are memoized as well.\n\n\
  \    As a concrete example, consider the following definition of the Fibonacci \
   function.\n\n\
  \    {[ let rec fib x = if x < 2 then x else fib (x - 1) + fib (x - 2) ]}\n\n\
  \    We can create a memoized version of this by first creating a non-recursive \
   version of\n\
  \    [fib] called [fib_nonrecursive], where the recursive knot has been untied.\n\n\
  \    {[ let fib_nonrecursive fib x = if x < 2 then x else fib (x - 1) + fib (x - 2) ]}\n\n\
  \    Here, rather than recursively calling itself, the function calls a function \
   provided\n\
  \    to it as an argument.\n\n\
  \    We can now use [recursive] to retie the recursive knot, injecting memoization at \
   that\n\
  \    point.\n\n\
  \    {[ let fib = Memo.recursive ~hashable:Int.hashable fib_nonrecursive ]}\n\
  \    Note that calling [recursive ~hashable f_nonrecursive] does the partial \
   application,\n\
  \    [f_nonrecursive f], at the time it is called, so that any side-effects or expensive\n\
  \    computations that happen at the partial application stage happen just once, not \
   once\n\
  \    per evaluation.\n\n\
  \    [recursive] does not detect or prevent infinite loops, e.g., [Memo.recursive \
   ~hashable\n\
  \    (fun f x -> f x)] will just run until it overflows the stack.\n\n\
  \    Finally, note that [recursive] keeps memory around between invocations of the \
   produced\n\
  \    function, which may not be what you want if you're only trying to optimize \
   recursive\n\
  \    calls.  You can achieve this with [recursive] by eta-expanding.\n\n\
  \    {[ let fib x = Memo.recursive ~hashable:Int.hashable fib_nonrecursive x ]}\n\n\
  \    Note that the above would be a mistake when using [general], since it would \
   completely\n\
  \    obviate the point of the call, but makes sense for [recursive], since it would \
   still\n\
  \    optimize recursive calls within one outer invocation.\n"]

val unit : (unit -> 'a) -> (unit, 'a) fn
[@@ocaml.doc " efficient special case for argument type [unit] "]

val of_comparable
  :  (module Comparable.S_plain with type t = 'a)
  -> ('a -> 'b)
  -> ('a, 'b) fn
[@@ocaml.doc " Use a comparable instead of hashable type "]
