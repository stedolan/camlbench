open! Import0

type 'a t = 'a Stdlib.Queue.t

let create = Stdlib.Queue.create
let clear = Stdlib.Queue.clear
let copy = Stdlib.Queue.copy
let is_empty = Stdlib.Queue.is_empty
let length = Stdlib.Queue.length
let peek = Stdlib.Queue.peek
let pop = Stdlib.Queue.pop
let push = Stdlib.Queue.push
let transfer = Stdlib.Queue.transfer

let iter t ~(f : _ -> _) =
  let caml_iter : ('a -> unit) -> 'a t -> unit =
    fun f q -> Stdlib.Queue.iter f q
  in
  caml_iter f t
;;

let fold t ~init ~(f : _ -> _ -> _) =
  let caml_fold : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b =
    fun f acc q -> Stdlib.Queue.fold f acc q
  in
  caml_fold f init t
;;
