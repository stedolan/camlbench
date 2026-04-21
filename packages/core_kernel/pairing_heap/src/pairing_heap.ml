let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"pairing_heap.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "pairing_heap.ml.before-ppx"
;;

open! Core
module Pool = Tuple_pool
module Pointer = Pool.Pointer

module Node : sig
  type 'a t = private int

  module Id : sig
    type t

    val of_int : int -> t
    val equal : t -> t -> bool
  end

  module Pool : sig
    type 'a node = 'a t
    type 'a t

    val create : min_size:int -> 'a t
    val is_full : 'a t -> bool
    val length : 'a t -> int
    val grow : 'a t -> 'a t
    val copy : 'a t -> 'a node -> 'a node * 'a t
  end

  val allocate : 'a -> pool:'a Pool.t -> id:Id.t -> 'a t
  [@@ocaml.doc
    " [allocate v ~pool] allocates a new node from the pool with no child or sibling "]

  val free : 'a t -> pool:'a Pool.t -> unit
  [@@ocaml.doc
    " [free t ~pool] frees [t] for reuse.  It is an error to access [t] after this. "]

  val empty : unit -> 'a t [@@ocaml.doc " a special [t] that represents the empty node "]

  val is_empty : 'a t -> bool
  val equal : 'a t -> 'a t -> bool

  val value_exn : 'a t -> pool:'a Pool.t -> 'a
  [@@ocaml.doc " [value_exn t ~pool] return the value of [t], raise if [is_empty t] "]

  val id : 'a t -> pool:'a Pool.t -> Id.t
  val child : 'a t -> pool:'a Pool.t -> 'a t
  val sibling : 'a t -> pool:'a Pool.t -> 'a t

  val prev : 'a t -> pool:'a Pool.t -> 'a t
  [@@ocaml.doc
    " [prev t] is either the parent of [t] or the sibling immediately left of [t] "]

  val add_child : 'a t -> child:'a t -> pool:'a Pool.t -> unit
  [@@ocaml.doc
    " [add_child t ~child ~pool] Add a child to [t], preserving existing children as\n\
    \      siblings of [child]. [t] and [child] should not be empty and [child] should \
     have no\n\
    \      sibling and have no prev node. "]

  val disconnect_sibling : 'a t -> pool:'a Pool.t -> 'a t
  [@@ocaml.doc " disconnect and return the sibling "]

  val disconnect_child : 'a t -> pool:'a Pool.t -> 'a t
  [@@ocaml.doc " disconnect and return the child "]

  val detach : 'a t -> pool:'a Pool.t -> unit
  [@@ocaml.doc
    " [detach t ~pool] removes [t] from the tree, adjusting pointers around it. After\n\
    \      [detach], [t] is the root of a standalone heap, which is detached from the \
     original\n\
    \      heap. "]
end = struct
  module Id = Int

  let dummy_id : Id.t = -1

  type 'a node =
    ('a, 'a node Pointer.t, 'a node Pointer.t, 'a node Pointer.t, Id.t) Pool.Slots.t5

  type 'a t = 'a node Pointer.t

  let empty = Pointer.null
  let is_empty = Pointer.is_null
  let equal = Pointer.phys_equal
  let value t ~pool = Pool.get pool t Pool.Slot.t0
  let child t ~pool = Pool.get pool t Pool.Slot.t1
  let sibling t ~pool = Pool.get pool t Pool.Slot.t2
  let prev t ~pool = Pool.get pool t Pool.Slot.t3
  let id t ~pool = Pool.get pool t Pool.Slot.t4
  let set_child t v ~pool = Pool.set pool t Pool.Slot.t1 v
  let set_sibling t v ~pool = Pool.set pool t Pool.Slot.t2 v
  let set_prev t v ~pool = Pool.set pool t Pool.Slot.t3 v

  let value_exn t ~pool =
    assert (not (is_empty t));
    value t ~pool
  ;;

  let allocate value ~pool ~id = Pool.new5 pool value (empty ()) (empty ()) (empty ()) id
  let free t ~pool = Pool.unsafe_free pool t

  let disconnect_sibling t ~pool =
    let sibling = sibling t ~pool in
    if not (is_empty sibling)
    then (
      set_sibling t (empty ()) ~pool;
      set_prev sibling (empty ()) ~pool);
    sibling
  ;;

  let disconnect_child t ~pool =
    let child = child t ~pool in
    if not (is_empty child)
    then (
      set_child t (empty ()) ~pool;
      set_prev child (empty ()) ~pool);
    child
  ;;

  let add_child t ~child:new_child ~pool =
    let current_child = disconnect_child t ~pool in
    set_sibling new_child current_child ~pool;
    if not (is_empty current_child) then set_prev current_child new_child ~pool;
    set_child t new_child ~pool;
    set_prev new_child t ~pool
  ;;

  let detach t ~pool =
    if not (is_empty t)
    then (
      let prev = prev t ~pool in
      if not (is_empty prev)
      then (
        let relation_to_prev = if equal t (child prev ~pool) then `child else `sibling in
        set_prev t (empty ()) ~pool;
        let sibling = disconnect_sibling t ~pool in
        (match relation_to_prev with
         | `child -> set_child prev sibling ~pool
         | `sibling -> set_sibling prev sibling ~pool);
        if not (is_empty sibling) then set_prev sibling prev ~pool))
  ;;

  module Pool = struct
    type 'a t = 'a node Pool.t
    type nonrec 'a node = 'a node Pointer.t

    let create (type a) ~min_size:capacity : a t =
      Pool.create
        Pool.Slots.t5
        ~capacity
        ~dummy:
          ( (Obj.magic None : a)
          , Pointer.null ()
          , Pointer.null ()
          , Pointer.null ()
          , dummy_id )
    ;;

    let is_full t = Pool.is_full t
    let length t = Pool.length t
    let grow t = Pool.grow t

    let copy t start =
      let t' = create ~min_size:(Pool.capacity t) in
      let copy_node node to_visit =
        if is_empty node
        then empty (), to_visit
        else (
          let new_node =
            allocate (value_exn node ~pool:t) ~pool:t' ~id:(id node ~pool:t)
          in
          let to_visit =
            (new_node, `child, child node ~pool:t)
            :: (new_node, `sibling, sibling node ~pool:t)
            :: to_visit
          in
          new_node, to_visit)
      in
      let rec loop to_visit =
        match to_visit with
        | [] -> ()
        | (node_to_update, slot, node_to_copy) :: rest ->
          let new_node, to_visit = copy_node node_to_copy rest in
          (match slot with
           | `child -> set_child node_to_update new_node ~pool:t'
           | `sibling -> set_sibling node_to_update new_node ~pool:t');
          if not (is_empty new_node) then set_prev new_node node_to_update ~pool:t';
          loop to_visit
      in
      let new_start, to_visit = copy_node start [] in
      loop to_visit;
      new_start, t'
    ;;
  end
end

type 'a t =
  { cmp : 'a -> 'a -> int
  ; mutable pool : 'a Node.Pool.t
  ; mutable root : 'a Node.t
  ; mutable num_of_allocated_nodes : int
  }

let invariant _ t =
  let rec loop to_visit =
    match to_visit with
    | [] -> ()
    | (node, expected_prev, maybe_parent_value) :: rest ->
      if not (Node.is_empty node)
      then (
        let this_value = Node.value_exn node ~pool:t.pool in
        assert (Node.equal (Node.prev node ~pool:t.pool) expected_prev);
        Option.iter maybe_parent_value ~f:(fun parent_value ->
          assert (t.cmp parent_value this_value <= 0));
        loop
          ((Node.child node ~pool:t.pool, node, Some this_value)
           :: (Node.sibling node ~pool:t.pool, node, maybe_parent_value)
           :: rest))
      else loop rest
  in
  assert (Node.is_empty t.root || Node.is_empty (Node.sibling t.root ~pool:t.pool));
  loop [ t.root, Node.empty (), None ]
;;

let create ?(min_size = 1) ~cmp () =
  { cmp
  ; pool = Node.Pool.create ~min_size
  ; root = Node.empty ()
  ; num_of_allocated_nodes = 0
  }
;;

let copy { cmp; pool; root; num_of_allocated_nodes } =
  let root, pool = Node.Pool.copy pool root in
  { cmp; pool; root; num_of_allocated_nodes }
;;

let allocate t v =
  if Node.Pool.is_full t.pool then t.pool <- Node.Pool.grow t.pool;
  t.num_of_allocated_nodes <- t.num_of_allocated_nodes + 1;
  Node.allocate v ~pool:t.pool ~id:(Node.Id.of_int t.num_of_allocated_nodes)
;;

let merge t root1 root2 =
  if Node.is_empty root1
  then root2
  else if Node.is_empty root2
  then root1
  else (
    let add_child t node ~child =
      Node.add_child node ~pool:t.pool ~child;
      node
    in
    let v1 = Node.value_exn root1 ~pool:t.pool in
    let v2 = Node.value_exn root2 ~pool:t.pool in
    if t.cmp v1 v2 < 0
    then add_child t root1 ~child:root2
    else add_child t root2 ~child:root1)
;;

let top_exn t =
  if Node.is_empty t.root
  then failwith "Heap.top_exn called on an empty heap"
  else Node.value_exn t.root ~pool:t.pool
;;

let top t = if Node.is_empty t.root then None else Some (top_exn t)

let add_node t v =
  let node = allocate t v in
  t.root <- merge t t.root node;
  node
;;

let add t v = ignore (add_node t v : _ Node.t)

let allocating_merge_pairs t head =
  let rec loop acc head =
    if Node.is_empty head
    then acc
    else (
      let next1 = Node.disconnect_sibling head ~pool:t.pool in
      if Node.is_empty next1
      then head :: acc
      else (
        let next2 = Node.disconnect_sibling next1 ~pool:t.pool in
        loop (merge t head next1 :: acc) next2))
  in
  match loop [] head with
  | [] -> Node.empty ()
  | h :: [] -> h
  | x :: xs -> List.fold xs ~init:x ~f:(fun acc heap -> merge t acc heap)
;;

let merge_pairs =
  let max_stack_depth = 1_000 in
  let rec loop t depth head =
    if depth >= max_stack_depth
    then allocating_merge_pairs t head
    else if Node.is_empty head
    then head
    else (
      let next1 = Node.disconnect_sibling head ~pool:t.pool in
      if Node.is_empty next1
      then head
      else (
        let next2 = Node.disconnect_sibling next1 ~pool:t.pool in
        merge t (merge t head next1) (loop t (depth + 1) next2)))
  in
  fun t head -> loop t 0 head
;;

let remove_non_empty t node =
  let pool = t.pool in
  Node.detach node ~pool;
  let merged_children = merge_pairs t (Node.disconnect_child node ~pool) in
  let new_root =
    if Node.equal t.root node then merged_children else merge t t.root merged_children
  in
  Node.free node ~pool;
  t.root <- new_root
;;

let remove_top t = if not (Node.is_empty t.root) then remove_non_empty t t.root

let rec remove_all_nodes_non_empty node ~pool =
  let child = Node.child node ~pool in
  let sibling = Node.sibling node ~pool in
  if not (Node.is_empty child)
  then remove_all_nodes_non_empty child ~pool
  else if not (Node.is_empty sibling)
  then remove_all_nodes_non_empty sibling ~pool
  else (
    let prev = Node.prev node ~pool in
    Node.detach node ~pool;
    Node.free node ~pool;
    if not (Node.is_empty prev) then remove_all_nodes_non_empty prev ~pool)
;;

let clear t =
  if not (Node.is_empty t.root)
  then (
    remove_all_nodes_non_empty t.root ~pool:t.pool;
    t.root <- Node.empty ())
;;

let pop_exn t =
  let r = top_exn t in
  remove_top t;
  r
;;

let pop t = if Node.is_empty t.root then None else Some (pop_exn t)

let pop_if t f =
  match top t with
  | None -> None
  | Some v ->
    if f v
    then (
      remove_top t;
      Some v)
    else None
;;

let pop_while t f =
  let rec loop t f acc =
    match pop_if t f with
    | None -> List.rev acc
    | Some x -> loop t f (x :: acc)
  in
  loop t f []
;;

let fold t ~init ~f =
  let pool = t.pool in
  let rec loop acc to_visit =
    match to_visit with
    | [] -> acc
    | node :: rest ->
      if Node.is_empty node
      then loop acc rest
      else (
        let to_visit = Node.sibling ~pool node :: Node.child ~pool node :: rest in
        loop (f acc (Node.value_exn ~pool node)) to_visit)
  in
  (loop init [ t.root ] [@nontail])
;;

let iter t ~f =
  let pool = t.pool in
  let rec loop to_visit =
    match to_visit with
    | [] -> ()
    | node :: rest ->
      if Node.is_empty node
      then loop rest
      else (
        f (Node.value_exn ~pool node);
        let to_visit = Node.sibling ~pool node :: Node.child ~pool node :: rest in
        loop to_visit)
  in
  (loop [ t.root ] [@nontail])
;;

let length t = Node.Pool.length t.pool

module C = Container.Make (struct
    type nonrec 'a t = 'a t

    let fold = fold
    let iter = `Custom iter
    let length = `Custom length
  end)

let is_empty t = Node.is_empty t.root
let mem = C.mem
let exists = C.exists
let for_all = C.for_all
let count = C.count
let sum = C.sum
let find = C.find
let find_map = C.find_map
let to_list = C.to_list
let to_array = C.to_array
let min_elt = C.min_elt
let max_elt = C.max_elt
let fold_result = C.fold_result
let fold_until = C.fold_until

let of_array arr ~cmp =
  let t = create ~min_size:(Array.length arr) ~cmp () in
  Array.iter arr ~f:(fun v -> add t v);
  t
;;

let of_list l ~cmp = of_array (Array.of_list l) ~cmp
let sexp_of_t f t = Array.sexp_of_t f (Array.sorted_copy ~compare:t.cmp (to_array t))

module Elt = struct
  type nonrec 'a t =
    { mutable node : 'a Node.t
    ; node_id : Node.Id.t
    ; heap : 'a t
    }

  let is_node_valid t = Node.Id.equal (Node.id ~pool:t.heap.pool t.node) t.node_id

  let value t =
    if is_node_valid t then Some (Node.value_exn t.node ~pool:t.heap.pool) else None
  ;;

  let value_exn t =
    if is_node_valid t
    then Node.value_exn t.node ~pool:t.heap.pool
    else failwith "Heap.value_exn: node was removed from the heap"
  ;;

  let sexp_of_t sexp_of_a t =
    ((fun x__001_ -> sexp_of_option sexp_of_a x__001_) [@merlin.hide]) (value t)
  ;;
end

let remove t (token : _ Elt.t) =
  if not (phys_equal t token.heap)
  then failwith "cannot remove from a different heap"
  else if not (Node.is_empty token.node)
  then (
    if Elt.is_node_valid token then remove_non_empty t token.node;
    token.node <- Node.empty ())
;;

let add_removable t v =
  let node = add_node t v in
  { Elt.node; heap = t; node_id = Node.id ~pool:t.pool node }
;;

let update t token v =
  remove t token;
  add_removable t v
;;

let find_elt =
  let rec loop t f nodes =
    match nodes with
    | [] -> None
    | node :: rest ->
      if Node.is_empty node
      then loop t f rest
      else if f (Node.value_exn node ~pool:t.pool)
      then Some { Elt.node; heap = t; node_id = Node.id ~pool:t.pool node }
      else
        loop t f (Node.sibling node ~pool:t.pool :: Node.child node ~pool:t.pool :: rest)
  in
  fun t ~f -> loop t f [ t.root ]
;;

module Unsafe = struct
  module Elt = struct
    type 'a heap = 'a t
    type 'a t = 'a Node.t

    let value t heap = Node.value_exn ~pool:heap.pool t
  end

  let add_removable = add_node
  let remove = remove_non_empty

  let update t elt v =
    remove t elt;
    add_removable t v
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
