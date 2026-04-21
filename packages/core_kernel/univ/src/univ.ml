let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"univ.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "univ.ml.before-ppx"
;;

open! Core
open! Import
module Id = Type_equal.Id

module View = struct
  type t = T : 'a Id.t * 'a -> t
end

include View

let view = Fn.id
let create id value = T (id, value)
let type_id_name (T (id, _)) = Id.name id
let type_id_uid (T (id, _)) = Id.uid id
let sexp_of_t (T (id, value)) = Id.to_sexp id value
let does_match (T (id1, _)) id2 = Id.same id1 id2

let match_ (type a) (T (id1, value)) (id2 : a Id.t) =
  match Id.same_witness id1 id2 with
  | Some Type_equal.T -> Some (value : a)
  | None -> None
;;

let match_exn (type a) (T (id1, value) as t) (id2 : a Id.t) =
  match Id.same_witness id1 id2 with
  | Some Type_equal.T -> (value : a)
  | None ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "univ.ml.before-ppx"
        ; pos_lnum = 29
        ; pos_cnum = 690
        ; pos_bol = 678
        }
      "Univ.match_exn called with mismatched value and type id"
      (t, id2)
      ((fun (arg0__001_, arg1__002_) ->
         let res0__003_ = sexp_of_t arg0__001_
         and res1__004_ = Id.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__002_ in
         Sexplib0.Sexp.List [ res0__003_; res1__004_ ]) [@merlin.hide])
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
