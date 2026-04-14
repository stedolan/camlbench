let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"linked_queue.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "linked_queue.ml.before-ppx"
;;

open! Import
module Queue = Base.Linked_queue
include Queue

include Bin_prot.Utils.Make_iterable_binable1 (struct
    type 'a t = 'a Queue.t
    type 'a el = 'a [@@deriving bin_io]

    include struct
      let _ = fun (_ : 'a el) -> ()

      let bin_shape_el =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "linked_queue.ml.before-ppx:7:2")
            [ ( Bin_prot.Shape.Tid.of_string "el"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.var
                  (Bin_prot.Shape.Location.of_string "linked_queue.ml.before-ppx:7:15")
                  (Bin_prot.Shape.Vid.of_string "a") )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ a ]
      ;;

      let _ = bin_shape_el

      let bin_size_el : 'a. 'a Bin_prot.Size.sizer -> 'a el Bin_prot.Size.sizer =
        fun _size_of_a -> _size_of_a
      ;;

      let _ = bin_size_el

      let bin_write_el : 'a. 'a Bin_prot.Write.writer -> 'a el Bin_prot.Write.writer =
        fun _write_a -> _write_a
      ;;

      let _ = bin_write_el

      let bin_writer_el =
        (fun bin_writer_a ->
           { size = (fun v -> bin_size_el bin_writer_a.size v)
           ; write = (fun v -> bin_write_el bin_writer_a.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_el

      let __bin_read_el__
        : 'a. 'a Bin_prot.Read.reader -> (int -> 'a el) Bin_prot.Read.reader
        =
        fun _of__a _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Silly_type "linked_queue.ml.before-ppx.el")
          !pos_ref
      ;;

      let _ = __bin_read_el__

      let bin_read_el : 'a. 'a Bin_prot.Read.reader -> 'a el Bin_prot.Read.reader =
        fun _of__a -> _of__a
      ;;

      let _ = bin_read_el

      let bin_reader_el =
        (fun bin_reader_a ->
           { read = (fun buf ~pos_ref -> (bin_read_el bin_reader_a.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_el__ bin_reader_a.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_el

      let bin_el =
        (fun bin_a ->
           { writer = bin_writer_el bin_a.writer
           ; reader = bin_reader_el bin_a.reader
           ; shape = bin_shape_el bin_a.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_el
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let caller_identity =
      Bin_prot.Shape.Uuid.of_string "800df9a0-4992-11e6-881d-ffe1a5c8aced"
    ;;

    let module_name = Some "Core.Linked_queue"
    let length = length
    let iter = iter

    let init ~len ~next =
      let t = create () in
      for _ = 1 to len do
        enqueue t (next ())
      done;
      t
    ;;
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
