[@@@ocaml.text " Utility functions for dealing with the environment. "]

open! Core
open! Import
module Unix := Core_unix

val parse_ssh_client : unit -> [ `From of Unix.Inet_addr.t | `Nowhere ] Or_error.t
[@@ocaml.doc
  " [parse_ssh_client] reads the [SSH_CLIENT] environment variable, retrieving the IP from\n\
  \    which you are currently sshing. "]

[@@@ocaml.text "/*"]

module Private : sig
  val parse_ssh_client_var
    :  string option
    -> [ `From of Unix.Inet_addr.t | `Nowhere ] Or_error.t
end
