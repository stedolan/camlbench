let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"validate.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "validate.ml.before-ppx"
;;

open Base

type single_error =
  { path : string list
  ; error : Error.t
  }
[@@ocaml.doc
  " Each single_error is a path indicating the location within the datastructure in\n\
  \    question that is being validated, along with an error message. "]

type t = single_error list
type 'a check = 'a -> t

let pass : t = []

let fails message a sexp_of_a =
  [ { path = []; error = Error.create message a sexp_of_a } ]
;;

let fail message = [ { path = []; error = Error.of_string message } ]
let failf format = Printf.ksprintf fail format
let fail_s sexp = [ { path = []; error = Error.create_s sexp } ]
let combine t1 t2 = t1 @ t2
let of_list = List.concat

let name name t =
  match t with
  | [] -> []
  | _ -> List.map t ~f:(fun { path; error } -> { path = name :: path; error })
;;

let name_list n l = name n (of_list l)
let fail_fn message _ = fail message
let pass_bool (_ : bool) = pass
let pass_unit (_ : unit) = pass

let protect f v =
  try f v with
  | exn ->
    fail_s (Sexp.message "Exception raised during validation" [ "", sexp_of_exn exn ])
;;

let try_with f =
  protect
    (fun () ->
       f ();
       pass)
    ()
;;

let path_string path = String.concat ~sep:"." path

let errors t =
  List.map t ~f:(fun { path; error } ->
    Error.to_string_hum (Error.tag error ~tag:(path_string path)))
;;

let result_fail t =
  Or_error.error
    "validation errors"
    (List.map t ~f:(fun { path; error } -> path_string path, error))
    ((fun x__005_ ->
       List.sexp_of_t
         (fun (arg0__001_, arg1__002_) ->
            let res0__003_ = sexp_of_string arg0__001_
            and res1__004_ = Error.sexp_of_t arg1__002_ in
            Sexplib0.Sexp.List [ res0__003_; res1__004_ ])
         x__005_) [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let result t = if List.is_empty t then Ok () else result_fail t
[@@ocaml.doc
  " [result] is carefully implemented so that it can be inlined -- calling [result_fail],\n\
  \    which is not inlineable, is key to this. "]
;;

let maybe_raise t = Or_error.ok_exn (result t)
let valid_or_error check x = Or_error.map (result (protect check x)) ~f:(fun () -> x)

let field_direct check fld _record v =
  let result = protect check v in
  name (Field.name fld) result
;;

let field check record fld =
  let v = Field.get fld record in
  field_direct check fld record v
;;

let field_folder check record =
  ();
  fun acc fld -> field check record fld :: acc
;;

let field_direct_folder check =
  Staged.stage (fun acc fld record v ->
    match field_direct check fld record v with
    | [] -> acc
    | result -> result :: acc)
;;

let all checks v =
  let rec loop checks v errs =
    match checks with
    | [] -> errs
    | check :: checks ->
      (match protect check v with
       | [] -> loop checks v errs
       | err -> loop checks v (err :: errs))
  in
  of_list (List.rev (loop checks v []))
;;

let of_result f =
  protect (fun v ->
    match f v with
    | Ok () -> pass
    | Error error -> fail error)
;;

let of_error f =
  protect (fun v ->
    match f v with
    | Ok () -> pass
    | Error error -> [ { path = []; error } ])
;;

let booltest f ~if_false = protect (fun v -> if f v then pass else fail if_false)

let pair ~fst ~snd (fst_value, snd_value) =
  of_list [ name "fst" (protect fst fst_value); name "snd" (protect snd snd_value) ]
;;

let list_indexed check list =
  of_list
    (List.mapi list ~f:(fun i el -> name (Int.to_string (i + 1)) (protect check el)))
;;

let list ~name:extract_name check list =
  of_list
    (List.map list ~f:(fun el ->
       match protect check el with
       | [] -> []
       | t -> protect (fun t -> name (extract_name el) t) t))
;;

let alist ~name f list' = list (fun (_, x) -> f x) list' ~name:(fun (key, _) -> name key)
let first_failure t1 t2 = if List.is_empty t1 then t2 else t1

let of_error_opt = function
  | None -> pass
  | Some error -> fail error
;;

let bounded ~name ~lower ~upper ~compare x =
  match Maybe_bound.compare_to_interval_exn ~lower ~upper ~compare x with
  | In_range -> pass
  | Below_lower_bound ->
    (match lower with
     | Unbounded -> assert false
     | Incl incl -> fail (Printf.sprintf "value %s < bound %s" (name x) (name incl))
     | Excl excl -> fail (Printf.sprintf "value %s <= bound %s" (name x) (name excl)))
  | Above_upper_bound ->
    (match upper with
     | Unbounded -> assert false
     | Incl incl -> fail (Printf.sprintf "value %s > bound %s" (name x) (name incl))
     | Excl excl -> fail (Printf.sprintf "value %s >= bound %s" (name x) (name excl)))
;;

module Infix = struct
  let ( ++ ) t1 t2 = combine t1 t2
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
