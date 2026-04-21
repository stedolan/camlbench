[@@@ocaml.text
  " A hash-heap is a combination of a heap and a hashtable that supports\n\
  \    constant time lookup, and log(n) time removal and replacement of\n\
  \    elements in addition to the normal heap operations. "]

include Hash_heap_intf.Hash_heap
