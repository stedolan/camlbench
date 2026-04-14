[@@@ocaml.text
  " This module extends the {{!Base.Linked_queue}[Base.Linked_queue]} module with bin_io\n\
  \    support.  As a reminder, the [Base.Linked_queue] module is a wrapper around OCaml's\n\
  \    standard [Queue] module that follows Base idioms and adds some functions.\n\n\
  \    See also {!Core.Queue}, which has different performance characteristics. "]

type 'a t = 'a Base.Linked_queue.t [@@deriving bin_io]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of struct
    include Base.Linked_queue
  end
  with type 'a t := 'a t
[@@ocaml.doc " @inline "]
