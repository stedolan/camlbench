let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"balanced_reducer.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "balanced_reducer.ml.before-ppx"
;;

open! Base

type 'a t =
  { data : 'a Option_array.t
  ; num_leaves : int
  ; num_leaves_not_in_bottom_level : int
  ; reduce : 'a -> 'a -> 'a
  ; sexp_of_a : 'a -> Sexp.t
  }

let length t = t.num_leaves
let parent_index ~child_index = (child_index - 1) / 2
let left_child_index ~parent_index = (parent_index * 2) + 1
let right_child_index ~left_child_index = left_child_index + 1
let num_branches t = t.num_leaves - 1
let index_is_leaf t i = i >= num_branches t

let leaf_index t i =
  let rotated_index =
    let offset_from_start_of_leaves_in_array = i + t.num_leaves_not_in_bottom_level in
    if offset_from_start_of_leaves_in_array < t.num_leaves
    then offset_from_start_of_leaves_in_array
    else offset_from_start_of_leaves_in_array - t.num_leaves
  in
  rotated_index + num_branches t
;;

let get_leaf t i = Option_array.get t.data (leaf_index t i)
let to_list t = List.init (length t) ~f:(fun i -> get_leaf t i)

let sexp_of_t sexp_of_a t =
  ((fun x__001_ -> sexp_of_list (sexp_of_option sexp_of_a) x__001_) [@merlin.hide])
    (to_list t)
;;

let invariant invariant_a t =
  let data = t.data in
  for i = 0 to Option_array.length data - 1 do
    match Option_array.get data i with
    | None -> ()
    | Some a -> invariant_a a
  done;
  for i = 0 to num_branches t - 1 do
    let left = left_child_index ~parent_index:i in
    let right = right_child_index ~left_child_index:left in
    let left_is_none = Option_array.is_none data left in
    let right_is_none = Option_array.is_none data right in
    if Option_array.is_some data i
    then assert (not (left_is_none || right_is_none))
    else
      assert (
        index_is_leaf t left || index_is_leaf t right || left_is_none || right_is_none)
  done
;;

let create_exn
      ?(sexp_of_a = (fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      ()
      ~len:num_leaves
      ~reduce
  =
  if num_leaves < 1
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "non-positive number of leaves in balanced reducer"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "num_leaves"
               ; (sexp_of_int [@merlin.hide]) num_leaves
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  let num_branches = num_leaves - 1 in
  let num_leaves_not_in_bottom_level = Int.ceil_pow2 num_leaves - num_leaves in
  let data = Option_array.create ~len:(num_branches + num_leaves) in
  { data; num_leaves; num_leaves_not_in_bottom_level; reduce; sexp_of_a }
;;

let validate_index t i =
  if i < 0
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "attempt to access negative index in balanced reducer"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "index"; (sexp_of_int [@merlin.hide]) i ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  let length = t.num_leaves in
  if i >= length
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "attempt to access out of bounds index in balanced reducer"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "index"; (sexp_of_int [@merlin.hide]) i ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "length"
               ; (sexp_of_int [@merlin.hide]) length
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let set_exn t i a =
  validate_index t i;
  let data = t.data in
  let i = ref (leaf_index t i) in
  Option_array.set_some data !i a;
  while !i <> 0 do
    let parent = parent_index ~child_index:!i in
    if Option_array.is_none data parent
    then i := 0
    else (
      Option_array.unsafe_set_none data parent;
      i := parent)
  done
;;

let get_exn t i =
  validate_index t i;
  Option_array.get_some_exn t.data (leaf_index t i)
;;

let rec compute_exn t i =
  if Option_array.is_some t.data i
  then Option_array.unsafe_get_some_exn t.data i
  else (
    let left = left_child_index ~parent_index:i in
    let right = right_child_index ~left_child_index:left in
    if left >= Option_array.length t.data
    then (
      let sexp_of_a = t.sexp_of_a in
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "attempt to compute balanced reducer with unset elements"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "balanced_reducer"
                 ; ((fun x__002_ -> sexp_of_t sexp_of_a x__002_) [@merlin.hide]) t
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail])));
    let a = t.reduce (compute_exn t left) (compute_exn t right) in
    Option_array.unsafe_set_some t.data i a;
    a)
;;

let compute_exn t = compute_exn t 0
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
