let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"queue.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "queue.ml.before-ppx"
;;

open! Import
include Base.Queue

include Test_binary_searchable.Make1_and_test (struct
    type nonrec 'a t = 'a t

    let get = get
    let length = length

    module For_test = struct
      let of_array a =
        let r = create () in
        for i = 0 to Array.length a - 1 do
          enqueue r a.(i)
        done;
        for i = 0 to Array.length a - 1 do
          ignore (dequeue_exn r : bool);
          enqueue r a.(i)
        done;
        r
      ;;
    end
  end)

module Serialization_v1 = struct
  let sexp_of_t = sexp_of_t
  let t_of_sexp = t_of_sexp
  let t_sexp_grammar = t_sexp_grammar

  include Bin_prot.Utils.Make_iterable_binable1 (struct
      type nonrec 'a t = 'a t
      type 'a el = 'a [@@deriving bin_io]

      include struct
        let _ = fun (_ : 'a el) -> ()

        let bin_shape_el =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "queue.ml.before-ppx:35:4")
              [ ( Bin_prot.Shape.Tid.of_string "el"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "queue.ml.before-ppx:35:17")
                    (Bin_prot.Shape.Vid.of_string "a") )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "el")) [ a ]
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
            (Bin_prot.Common.ReadError.Silly_type
               "queue.ml.before-ppx.Serialization_v1.el")
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
        Bin_prot.Shape.Uuid.of_string "b4c84254-4992-11e6-9ba7-734e154027bd"
      ;;

      let module_name = Some "Core.Queue"
      let length = length
      let iter = iter
      let init ~len ~next = init len ~f:(fun _ -> next ())
    end)

  let stable_witness (_ : 'a Stable_witness.t) : 'a t Stable_witness.t =
    Stable_witness.assert_stable
  ;;
end

include Serialization_v1

module Stable = struct
  module V1 = struct
    type nonrec 'a t = 'a t [@@deriving compare, equal]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__001_ b__002_ ->
        compare
          (fun a__003_ (b__004_ [@merlin.hide]) ->
             (_cmp__a a__003_ b__004_ [@merlin.hide]))
          a__001_
          b__002_
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__005_ b__006_ ->
        equal
          (fun a__007_ (b__008_ [@merlin.hide]) ->
             (_cmp__a a__007_ b__008_ [@merlin.hide]))
          a__005_
          b__006_
      ;;

      let _ = equal
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Serialization_v1

    let map = map
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
