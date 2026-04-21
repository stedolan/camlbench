[@@@ocaml.text
  " Infix composition operators.\n\n\
  \    - [ a |> (f >> g) = a |> f |> g ]\n\
  \    - [ (f << g) a = f (g a) ] "]

val ( >> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
val ( << ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
