let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"union_find.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "union_find.ml.before-ppx"
;;

open! Import

type 'a root =
  { mutable value : 'a
  ; mutable rank : int
  }

type 'a t = { mutable node : 'a node }

and 'a node =
  | Inner of 'a t
  | Root of 'a root

let invariant _ t =
  let rec loop t depth =
    match t.node with
    | Inner t -> loop t (depth + 1)
    | Root r -> assert (depth <= r.rank)
  in
  loop t 0
;;

let create v = { node = Root { value = v; rank = 0 } }

let rec compress t ~inner_node ~inner ~descendants =
  match t.node with
  | Root r ->
    List.iter descendants ~f:(fun t -> t.node <- inner_node);
    t, r
  | Inner t' as node ->
    compress t' ~inner_node:node ~inner:t ~descendants:(inner :: descendants)
;;

let representative t =
  match t.node with
  | Root r -> t, r
  | Inner t' as node -> compress t' ~inner_node:node ~inner:t ~descendants:[]
;;

let root t =
  match t.node with
  | Root r -> r
  | _ -> snd (representative t)
;;

let rank t = (root t).rank
let get t = (root t).value
let set t v = (root t).value <- v
let same_class t1 t2 = phys_equal (root t1) (root t2)

let union t1 t2 =
  let t1, r1 = representative t1 in
  let t2, r2 = representative t2 in
  if phys_equal r1 r2
  then ()
  else (
    let n1 = r1.rank in
    let n2 = r2.rank in
    if n1 < n2
    then t1.node <- Inner t2
    else (
      t2.node <- Inner t1;
      if n1 = n2 then r1.rank <- r1.rank + 1))
;;

let is_compressed t =
  invariant ignore t;
  match t.node with
  | Root _ -> true
  | Inner t ->
    (match t.node with
     | Root _ -> true
     | Inner _ -> false)
;;

module Private = struct
  let is_compressed = is_compressed
  let rank = rank
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
