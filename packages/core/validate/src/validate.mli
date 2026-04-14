[@@@ocaml.text
  " A module for organizing validations of data structures.\n\n\
  \    Allows standardized ways of checking for conditions, and keeps track of the \
   location\n\
  \    of errors by keeping a path to each error found. Thus, if you were validating the\n\
  \    following datastructure:\n\n\
  \    {[\n\
  \      { foo = 3;\n\
  \        bar = { snoo = 34.5;\n\
  \                blue = Snoot -6; }\n\
  \      }\n\
  \    ]}\n\n\
  \    One might end up with an error with the error path:\n\n\
  \    {v bar.blue.Snoot : value -6 <= bound 0 v}\n\n\
  \    By convention, the validations for a type defined in module [M] appear in module \
   [M],\n\
  \    and have their name prefixed by [validate_]. E.g., [Int.validate_positive].\n\n\
  \    Here's an example of how you would use [validate] with a record:\n\n\
  \    {[\n\
  \      type t =\n\
  \        { foo: int;\n\
  \          bar: float;\n\
  \        }\n\
  \      [@@deriving fields ~iterators:to_list]\n\n\
  \      let validate t =\n\
  \        let module V = Validate in\n\
  \        let w check = V.field check t in\n\
  \        Fields.to_list\n\
  \          ~foo:(w Int.validate_positive)\n\
  \          ~bar:(w Float.validate_non_negative)\n\
  \        |> V.of_list\n\
  \    ]}\n\n\n\
  \    And here's an example of how you would use it with a variant type:\n\n\
  \    {[\n\
  \      type t =\n\
  \        | Foo of int\n\
  \        | Bar of (float * int)\n\
  \        | Snoo of Floogle.t\n\n\
  \      let validate = function\n\
  \        | Foo i -> V.name \"Foo\" (Int.validate_positive i)\n\
  \        | Bar p -> V.name \"Bar\" (V.pair\n\
  \                                   ~fst:Float.validate_positive\n\
  \                                   ~snd:Int.validate_non_negative p)\n\
  \        | Snoo floogle -> V.name \"Snoo\" (Floogle.validate floogle)\n\
  \    ]} "]

open Base

type t
[@@ocaml.doc
  " The result of a validation.  This effectively contains the list of errors, qualified\n\
  \    by their location path "]

type 'a check = 'a -> t [@@ocaml.doc " To make function signatures easier to read. "]

val pass : t [@@ocaml.doc " A result containing no errors. "]

val fail : string -> t [@@ocaml.doc " A result containing a single error. "]

val fails : string -> 'a -> ('a -> Sexp.t) -> t

val fail_s : Sexp.t -> t [@@ocaml.doc " This can be used with the [%sexp] extension. "]

val failf : ('a, unit, string, t) format4 -> 'a
[@@ocaml.doc
  " Like [sprintf] or [failwithf] but produces a [t] instead of a string or exception. "]

val combine : t -> t -> t

val of_list : t list -> t [@@ocaml.doc " Combines multiple results, merging errors. "]

val name : string -> t -> t [@@ocaml.doc " Extends location path by one name. "]

val name_list : string -> t list -> t

val fail_fn : string -> _ check
[@@ocaml.doc
  " [fail_fn err] returns a function that always returns fail, with [err] as the error\n\
  \    message.  (Note that there is no [pass_fn] so as to discourage people from ignoring\n\
  \    the type of the value being passed unconditionally irrespective of type.) "]

val pass_bool : bool check [@@ocaml.doc " Checks for unconditionally passing a bool. "]

val pass_unit : unit check [@@ocaml.doc " Checks for unconditionally passing a unit. "]

val protect : 'a check -> 'a check
[@@ocaml.doc
  " [protect f x] applies the validation [f] to [x], catching any exceptions and returning\n\
  \    them as errors. "]

val try_with : (unit -> unit) -> t
[@@ocaml.doc
  " [try_with f] runs [f] catching any exceptions and returning them as errors. "]

val result : t -> unit Or_error.t

val errors : t -> string list
[@@ocaml.doc
  " Returns a list of formatted error strings, which include both the error message and\n\
  \    the path to the error. "]

val maybe_raise : t -> unit
[@@ocaml.doc
  " If the result contains any errors, then raises an exception with a formatted error\n\
  \    message containing a message for every error. "]

val valid_or_error : 'a check -> 'a -> 'a Or_error.t
[@@ocaml.doc " Returns an error if validation fails. "]

val field : 'a check -> 'record -> ([> `Read ], 'record, 'a) Field.t_with_perm -> t
[@@ocaml.doc
  " Used for validating an individual field. Should be used with [Fields.to_list]. "]

val field_direct
  :  'a check
  -> ([> `Read ], 'record, 'a) Field.t_with_perm
  -> 'record
  -> 'a
  -> t
[@@ocaml.doc
  " Used for validating an individual field. Should be used with \
   [Fields.Direct.to_list]. "]

val field_folder
  :  'a check
  -> 'record
  -> t list
  -> ([> `Read ], 'record, 'a) Field.t_with_perm
  -> t list
[@@ocaml.doc " Creates a function for use in a [Fields.fold]. "]

val field_direct_folder
  :  'a check
  -> (t list -> ([> `Read ], 'record, 'a) Field.t_with_perm -> 'record -> 'a -> t list)
       Staged.t
[@@ocaml.doc " Creates a function for use in a [Fields.Direct.fold]. "]

val all : 'a check list -> 'a check
[@@ocaml.doc
  " Combines a list of validation functions into one that does all validations. "]

val of_result : ('a -> (unit, string) Result.t) -> 'a check
[@@ocaml.doc
  " Creates a validation function from a function that produces a [Result.t]. "]

val of_error : ('a -> unit Or_error.t) -> 'a check

val booltest : ('a -> bool) -> if_false:string -> 'a check
[@@ocaml.doc " Creates a validation function from a function that produces a bool. "]

val pair : fst:'a check -> snd:'b check -> ('a * 'b) check
[@@ocaml.doc " Validation functions for particular data types. "]

val list_indexed : 'a check -> 'a list check
[@@ocaml.doc
  " Validates a list, naming each element by its position in the list (where the first\n\
  \    position is 1, not 0). "]

val list : name:('a -> string) -> 'a check -> 'a list check
[@@ocaml.doc
  " Validates a list, naming each element using a user-defined function for computing the\n\
  \    name. "]

val first_failure : t -> t -> t
val of_error_opt : string option -> t

val alist : name:('a -> string) -> 'b check -> ('a * 'b) list check
[@@ocaml.doc
  " Validates an association list, naming each element using a user-defined function for\n\
  \    computing the name. "]

val bounded
  :  name:('a -> string)
  -> lower:'a Maybe_bound.t
  -> upper:'a Maybe_bound.t
  -> compare:('a -> 'a -> int)
  -> 'a check

module Infix : sig
  val ( ++ ) : t -> t -> t [@@ocaml.doc " Infix operator for [combine] above. "]
end
