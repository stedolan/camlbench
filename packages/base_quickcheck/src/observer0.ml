open! Base

type 'a t = 'a -> size:int -> hash:Hash.state -> Hash.state

let create f : _ t = f

let observe (t : _ t) x ~size ~hash =
  if size < 0
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Base_quickcheck.Observer.observe: size < 0"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "size"; (sexp_of_int [@merlin.hide]) size ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  else t x ~size ~hash
;;

let opaque _ ~size:_ ~hash = hash
