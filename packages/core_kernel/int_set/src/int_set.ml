let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"int_set.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "int_set.ml.before-ppx"
;;

open! Core
open! Import

module Range : sig
  type t = private
    { lo : int
    ; hi : int
    }

  val make : int -> int -> t [@@ocaml.doc " Create [t] from a range "]

  val to_string : t -> string

  val merge : t -> t -> [ `Ok of t | `Lt_and_not_adjacent | `Gt_and_not_adjacent ]
  [@@ocaml.doc " [merge s t] merges mergeable ranges "]

  val contains : int -> t -> bool
end = struct
  type t =
    { lo : int
    ; hi : int
    }

  let make x y = if x <= y then { lo = x; hi = y } else { lo = y; hi = x }
  let to_string t = if t.lo = t.hi then Int.to_string t.lo else sprintf "%d-%d" t.lo t.hi

  let compare r1 r2 =
    if r1.hi < r2.lo - 1
    then `Lt_and_not_adjacent
    else if r1.lo > r2.hi + 1
    then `Gt_and_not_adjacent
    else `Mergeable
  ;;

  let merge r1 r2 =
    match compare r1 r2 with
    | `Lt_and_not_adjacent -> `Lt_and_not_adjacent
    | `Gt_and_not_adjacent -> `Gt_and_not_adjacent
    | `Mergeable -> `Ok { lo = Int.min r1.lo r2.lo; hi = Int.max r1.hi r2.hi }
  ;;

  let contains i r = r.lo <= i && i <= r.hi
end

type t = Range.t list

let empty = []
let to_string t = String.concat ~sep:"," (List.rev_map t ~f:Range.to_string)

let add_range t x y =
  let rec loop ranges to_add =
    match ranges with
    | r :: rest ->
      (match Range.merge to_add r with
       | `Lt_and_not_adjacent -> r :: loop rest to_add
       | `Gt_and_not_adjacent -> to_add :: r :: rest
       | `Ok merged -> loop rest merged)
    | [] -> [ to_add ]
  in
  loop t (Range.make x y)
;;

let add t i = add_range t i i
let mem t i = List.exists t ~f:(fun x -> Range.contains i x)
let ranges t = List.map t ~f:(fun { Range.lo; hi } -> lo, hi)

let max t =
  match t with
  | [] -> None
  | { Range.hi; lo = _ } :: _ -> Some hi
;;

let min t =
  match List.last t with
  | None -> None
  | Some { Range.lo; hi = _ } -> Some lo
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
