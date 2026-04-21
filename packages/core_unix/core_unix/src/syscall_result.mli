[@@@ocaml.text
  " Representation of Unix system call results\n\n\
  \    Almost no Unix system call returns a negative integer in case of success.\n\n\
  \    We can use this to encode the result of a system call as either a positive integer\n\
  \    value or [-errno].  This allows us to avoid exceptions for dealing with errors \
   such as\n\
  \    [EAGAIN].  Indeed, in some context we issue a system call in a tight loop that will\n\
  \    often fail with [EAGAIN] and using exceptions to return it is costly. "]

open! Import

type 'a t = private int
[@@ocaml.doc
  " There is no [[@@deriving sexp_of]] on purpose as it could only print the ['a] value as\n\
  \    an integer.  Use [[%sexp_of: Int.t]] or [[%sexp_of: Unit.t]]. "]
[@@ocaml.doc " exposed only as a performance hack "]

module type S = Syscall_result_intf.S with type 'a syscall_result := 'a t
module type Arg = Syscall_result_intf.Arg

module Make : functor (M : Arg) -> functor () -> S with type ok_value := M.t
module Int : S with type ok_value := int
module Unit : S with type ok_value := unit
module File_descr : S with type ok_value := File_descr.t

val create_error : Unix_error.t -> _ t
val unit : Unit.t
val is_ok : _ t -> bool
val is_error : _ t -> bool
val error_exn : _ t -> Unix_error.t

val ignore_ok_value : _ t -> Unit.t [@@ocaml.doc " Keep only the error. "]
