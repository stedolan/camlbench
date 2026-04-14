let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"heap_block.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "heap_block.ml.before-ppx"
;;

open! Base

type 'a t = 'a [@@deriving sexp_of]

include struct
  let _ = fun (_ : 'a t) -> ()

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__001_ -> _of_a__001_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

external is_heap_block : Stdlib.Obj.t -> bool = "core_heap_block_is_heap_block"
[@@noalloc]

let is_ok v = is_heap_block (Stdlib.Obj.repr v)
let create v = if is_ok v then Some v else None

let create_exn v =
  if is_ok v then v else failwith "Heap_block.create_exn called with non heap block"
;;

let value t = t

let bytes_per_word =
  (let open Word_size in
   num_bits word_size)
  / 8
;;

let bytes (type a) (t : a t) =
  (Stdlib.Obj.size (Stdlib.Obj.repr (t : a t)) + 1) * bytes_per_word
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
