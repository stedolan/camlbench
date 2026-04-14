let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"memo.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "memo.ml.before-ppx"
;;

open! Import
open Std_internal

type ('a, 'b) fn = 'a -> 'b

module Result = struct
  type 'a t =
    | Rval of 'a
    | Expt of exn

  let return = function
    | Rval v -> v
    | Expt e -> raise e
  ;;

  let capture f x =
    try Rval (f x) with
    | e -> Expt e
  ;;
end

let unit f =
  let l = Lazy.from_fun f in
  fun () -> Lazy.force l
;;

let unbounded (type a) ?(hashable = Hashtbl.Hashable.poly) f =
  let cache =
    let module A = Hashable.Make_plain_and_derive_hash_fold_t (struct
        type t = a

        let { Hashtbl.Hashable.hash; compare; sexp_of_t } = hashable
      end)
    in
    A.Table.create () ~size:0
  in
  let really_call_f arg = Result.capture f arg in
  fun arg -> Result.return (Hashtbl.findi_or_add cache arg ~default:really_call_f)
;;

let lru (type a) ?(hashable = Hashtbl.Hashable.poly) ~max_cache_size f =
  if max_cache_size <= 0
  then failwithf "Memo.lru: max_cache_size of %i <= 0" max_cache_size ();
  let module Cache = Hash_queue.Make (struct
      type t = a

      let { Hashtbl.Hashable.hash; compare; sexp_of_t } = hashable
    end)
  in
  let cache = Cache.create () in
  fun arg ->
    Result.return
      (match Cache.lookup_and_move_to_back cache arg with
       | Some result -> result
       | None ->
         let result = Result.capture f arg in
         Cache.enqueue_back_exn cache arg result;
         if Cache.length cache > max_cache_size
         then ignore (Cache.dequeue_front_exn cache : _ Result.t);
         result)
;;

let general ?hashable ?cache_size_bound f =
  match cache_size_bound with
  | None -> unbounded ?hashable f
  | Some n -> lru ?hashable ~max_cache_size:n f
;;

let recursive ~hashable ?cache_size_bound f_onestep =
  let rec memoized =
    lazy (general ~hashable ?cache_size_bound (f_onestep (fun x -> (force memoized) x)))
  in
  force memoized
;;

let of_comparable
      (type index)
      ((module M) : (module Comparable.S_plain with type t = index))
      f
  =
  let m = ref M.Map.empty in
  fun (x : M.t) ->
    let v =
      match Map.find !m x with
      | Some v -> v
      | None ->
        let v = Result.capture f x in
        m := Map.set !m ~key:x ~data:v;
        v
    in
    Result.return v
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
