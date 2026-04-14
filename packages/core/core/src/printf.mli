open! Import

include module type of struct
  include Base.Printf
end
[@@ocaml.doc " @inline "]

val eprintf : ('a, out_channel, unit) format -> 'a
val fprintf : out_channel -> ('a, out_channel, unit) format -> 'a

val kfprintf
  :  (out_channel -> 'a)
  -> out_channel
  -> ('b, out_channel, unit, 'a) format4
  -> 'b

val printf : ('a, out_channel, unit) format -> 'a

val exitf : ('a, unit, string, unit -> _) format4 -> 'a
[@@ocaml.doc " print to stderr; exit 1 "]

type printf = { printf : 'a. ('a, Buffer.t, unit) format -> 'a }

val collect_to_string : (printf -> unit) -> string
[@@ocaml.doc
  " [collect_to_string (fun { printf } -> ...)] lets you easily convert code that was\n\
  \    printing to stdout into code that produces a string.\n\n\
  \    For example, this original code...\n\
  \    {[\n\
  \      printf \"hello \";\n\
  \      (* long computation *)\n\
  \      printf \"%s%c\" \"world\" '!'\n\
  \    ]}\n\n\
  \    ... can be wrapped like so.\n\
  \    {[\n\
  \      Printf.collect_to_string (fun { printf } ->\n\
  \        printf \"hello \";\n\
  \        (* long computation *)\n\
  \        printf \"%s%c\" \"world\" '!')\n\
  \    ]}\n\n\
  \    The above is easier than manually editing many lines of the original:\n\
  \    {[\n\
  \      let hello = sprintf \"hello \" in\n\
  \      (* long computation *)\n\
  \      let world = sprintf \"%s%c\" \"world\" '!' in\n\
  \      hello ^ world\n\
  \    ]}\n"]
