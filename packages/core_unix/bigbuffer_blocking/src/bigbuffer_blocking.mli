[@@@ocaml.text " Extends {{!Core.Bigbuffer}[Core.Bigbuffer]}. "]

open! Core
open! Import
open! Core.Bigbuffer

val add_channel : t -> In_channel.t -> int -> unit
[@@ocaml.doc
  " [add_channel b ic n] reads exactly [n] characters from the input channel [ic] and\n\
  \    stores them at the end of buffer [b].  Raises [End_of_file] if the channel contains\n\
  \    fewer than [n] characters. "]

val output_buffer : Out_channel.t -> t -> unit
[@@ocaml.doc
  " [output_buffer oc b] writes the current contents of buffer [b] on the output channel\n\
  \    [oc]. "]

val md5 : t -> Md5.t [@@ocaml.doc " Digest the current contents of the buffer. "]
