[@@@ocaml.text
  " Use the Test module to run randomized tests. Each randomized test needs a generator, a\n\
  \    shrinker, and a property to test. "]

include Test_intf.Test [@@ocaml.doc " @inline "]
