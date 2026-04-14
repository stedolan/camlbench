let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bigbuffer_internal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bigbuffer_internal.ml.before-ppx"
;;

open! Import

type t =
  { mutable bstr : Bigstring.t
  ; mutable pos : int
  ; mutable len : int
  ; init : Bigstring.t
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : t) -> ()

  let sexp_of_t =
    (fun { bstr = bstr__002_; pos = pos__004_; len = len__006_; init = init__008_ } ->
       let bnds__001_ = ([] : _ Stdlib.List.t) in
       let bnds__001_ =
         let arg__009_ = Bigstring.sexp_of_t init__008_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "init"; arg__009_ ] :: bnds__001_
          : _ Stdlib.List.t)
       in
       let bnds__001_ =
         let arg__007_ = sexp_of_int len__006_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "len"; arg__007_ ] :: bnds__001_
          : _ Stdlib.List.t)
       in
       let bnds__001_ =
         let arg__005_ = sexp_of_int pos__004_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos"; arg__005_ ] :: bnds__001_
          : _ Stdlib.List.t)
       in
       let bnds__001_ =
         let arg__003_ = Bigstring.sexp_of_t bstr__002_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "bstr"; arg__003_ ] :: bnds__001_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__001_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let resize buf more =
  let min_len = buf.len + more in
  let new_len = min_len + min_len in
  let new_buf = Bigstring.create new_len in
  Bigstring.blito ~src:buf.bstr ~src_len:buf.pos ~dst:new_buf ();
  buf.bstr <- new_buf;
  buf.len <- new_len
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
