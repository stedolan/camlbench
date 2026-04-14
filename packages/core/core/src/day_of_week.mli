[@@@ocaml.text
  " Provides a variant type for days of the week ([Mon], [Tue], etc.) and convenience\n\
  \    functions for converting these days into other formats, like sexp or string or ISO\n\
  \    8601 weekday number.\n"]

include Day_of_week_intf.Day_of_week [@@ocaml.doc " @inline "]
