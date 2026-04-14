[@@@ocaml.text
  " Provides generic signatures for container data structures.\n\n\
  \    These signatures include functions ([iter], [fold], [exists], [for_all], ...) \
   that you\n\
  \    would expect to find in any container. Used by including [Container.S0] or\n\
  \    [Container.S1] in the signature for every container-like data structure ([Array],\n\
  \    [List], [String], ...) to ensure a consistent interface.\n\n\
  \    These signatures extend signatures exported by {!Base.Container_intf}.\n"]

include Container_intf.Container [@@ocaml.doc " @inline "]
