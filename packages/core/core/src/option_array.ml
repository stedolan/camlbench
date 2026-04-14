let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"option_array.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "option_array.ml.before-ppx"
;;

open! Import
include Base.Option_array

include
  Binable.Of_binable1_without_uuid [@alert "-legacy"]
    (struct
      type 'a t = 'a option array [@@deriving sexp, bin_io]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun _of_a__001_ x__003_ -> array_of_sexp (option_of_sexp _of_a__001_) x__003_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__004_ x__005_ -> sexp_of_array (sexp_of_option _of_a__004_) x__005_
        ;;

        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "option_array.ml.before-ppx:7:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , bin_shape_array
                    (bin_shape_option
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "option_array.ml.before-ppx:7:18")
                          (Bin_prot.Shape.Vid.of_string "a"))) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> bin_size_array (bin_size_option _size_of_a) v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v ->
          bin_write_array (bin_write_option _write_a) buf ~pos v
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
          fun _of__a buf ~pos_ref vint ->
          (__bin_read_array__ (bin_read_option _of__a)) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref ->
          (bin_read_array (bin_read_option _of__a)) buf ~pos_ref
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
    end)
    (struct
      type nonrec 'a t = 'a t

      let to_binable = to_array
      let of_binable = of_array
    end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
