[@@@ocaml.text " Utilities for printing debug messages. "]

open! Import

val eprint : string -> unit
[@@ocaml.doc
  " [eprint message] prints to stderr [message], followed by a newline and flush.  This is\n\
  \    the same as [prerr_endline]. "]

val eprints : string -> 'a -> ('a -> Sexp.t) -> unit
[@@ocaml.doc
  " [eprints message a sexp_of_a] prints to stderr [message] and [a] as a sexp, followed\n\
  \    by a newline and flush. "]

val eprint_s : Sexp.t -> unit
[@@ocaml.doc
  " [eprint_s sexp] prints [sexp] to stderr, followed by a newline and a flush. "]

val eprintf : ('r, unit, string, unit) format4 -> 'r
[@@ocaml.doc
  " [eprintf message arg1 ... argn] prints to stderr [message], with sprintf-style format\n\
  \    characters instantiated, followed by a newline and flush. "]

module Make : functor () -> sig
  val check_invariant : bool ref
  [@@ocaml.doc " Whether the invariants are called on each invocation. "]

  val show_messages : bool ref
  [@@ocaml.doc " If true, you get a message on stderr every time [debug] is called. "]

  val debug
    :  't Invariant.t
    -> module_name:(string[@ocaml.doc " module_name appears on messages "])
    -> (string[@ocaml.doc " string name of function [f], also appears on messages "])
    -> ('t list
       [@ocaml.doc " args of type [t], to have invariant checked iff [check_invariant] "])
    -> ('args[@ocaml.doc " arguments to the function we're debugging "])
    -> ('args -> Sexp.t)
    -> ('result -> Sexp.t)
    -> ((unit -> 'result)[@ocaml.doc " should call [f] with ['args], exn's re-raised "])
    -> 'result
  [@@ocaml.doc
    " We avoid labels so that the applications are more concise -- see example above. "]
end
[@@ocaml.doc
  " [Debug.Make] produces a [debug] function used to wrap a function to display arguments\n\
  \    before calling and display results after returning.  Intended usage is:\n\n\
  \    {[\n\
  \      module Foo = struct\n\
  \        type t = ...\n\
  \        let invariant = ...\n\
  \          let bar t x y : Result.t = ...\n\
  \      end\n\
  \      module Foo_debug = struct\n\
  \        open Foo\n\
  \        include Debug.Make ()\n\
  \        let debug x = debug invariant ~module_name:\"Foo\" x\n\
  \        let bar t x y =\n\
  \          debug \"bar\" [t] (t, x, y) [%sexp_of: t * X.t * Y.t] [%sexp_of: Result.t]\n\
  \            (fun () -> bar t x y)\n\
  \      end\n\
  \    ]}\n"]

val am : Source_code_position.t -> unit
[@@ocaml.doc
  " [am], [ams], and [amf] output a source code position and backtrace to stderr.  [amf]\n\
  \    accepts a printf-style format string.  [ams] accepts a message, value, and sexp\n\
  \    converter for that value.  Typical usage looks like:\n\n\
  \    {[\n\
  \      ...;\n\
  \    Debug.am [%here];\n\
  \      ...;\n\
  \      Debug.amf [%here] \"hello (%s, %s)\" (X.to_string x) (Y.to_string y);\n\
  \      ...;\n\
  \      Debug.ams [%here] \"hello\" (x, y) [%sexp_of: X.t * Y.t];\n\
  \      ...;\n\
  \    ]}\n\n\
  \    The [am*] functions output source code positions in the standard format\n\
  \    \"FILE:LINE:COL\", which means that one can use a tool like emacs grep-mode on a \
   buffer\n\
  \    containing debug messages to step through one's code by stepping through the\n\
  \    messages. "]

val ams : Source_code_position.t -> string -> 'a -> ('a -> Sexp.t) -> unit
val amf : Source_code_position.t -> ('r, unit, string, unit) format4 -> 'r

val should_print_backtrace : bool ref
[@@ocaml.doc
  " [should_print_backtrace] governs whether the [am*] functions print a backtrace. "]
