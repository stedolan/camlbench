let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"gel.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "gel.ml.before-ppx"
;;

open! Base

type 'a t = { g : 'a } [@@unboxed]

let create g = { g } [@@inline]
let g { g } = g [@@inline]
let map { g } ~f = { g = f g } [@@inline]
let compare compare_g { g = a } { g = b } = compare_g a b [@@inline]
let hash_fold_t hash_fold_g hash_state { g } = hash_fold_g hash_state g [@@inline]
let sexp_of_t sexp_of_g { g } = sexp_of_g g [@@inline]
let t_of_sexp g_of_sexp sexp = { g = g_of_sexp sexp } [@@inline]
let globalize _ { g } = { g } [@@inline]
let equal equal_g { g = a } { g = b } = equal_g a b [@@inline]

let _drop_some_proof : 'a t option -> 'a option =
  fun x ->
  match x with
  | None -> None
  | Some { g } -> Some g
;;

external drop_some : 'a t option -> 'a option = "%identity"
external drop_ok : ('a t, 'b) Result.t -> ('a, 'b) Result.t = "%identity"
external drop_error : ('a, 'b t) Result.t -> ('a, 'b) Result.t = "%identity"

let _inject_some : 'a option -> 'a t option =
  fun x ->
  match x with
  | None -> None
  | Some y -> Some { g = y }
;;

external inject_some : 'a option -> 'a t option = "%identity"
external inject_ok : ('a, 'b) Result.t -> ('a t, 'b) Result.t = "%identity"
external inject_error : ('a, 'b) Result.t -> ('a, 'b t) Result.t = "%identity"
external inject_result : ('a, 'b) Result.t -> ('a t, 'b t) Result.t = "%identity"

include
  Bin_prot.Utils.Make_binable1_without_uuid [@alert "-legacy"] [@inlined hint] (struct
    module Binable = struct
      type 'a t = 'a [@@deriving bin_io]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "gel.ml.before-ppx:53:4")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "gel.ml.before-ppx:53:16")
                    (Bin_prot.Shape.Vid.of_string "a") )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a -> _size_of_a
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a -> _write_a
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          (fun bin_writer_a ->
             { size = (fun v -> bin_size_t bin_writer_a.size v)
             ; write = (fun v -> bin_write_t bin_writer_a.write v)
             }
           : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__
          : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
          =
          fun _of__a _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Silly_type "gel.ml.before-ppx.Binable.t")
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a -> _of__a
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          (fun bin_reader_a ->
             { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
             ; vtag_read =
                 (fun buf ~pos_ref vtag ->
                   (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
             }
           : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          (fun bin_a ->
             { writer = bin_writer_t bin_a.writer
             ; reader = bin_reader_t bin_a.reader
             ; shape = bin_shape_t bin_a.shape
             }
           : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type nonrec 'a t = 'a t

    let of_binable g = { g } [@@inline]
    let to_binable { g } = g [@@inline]
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
