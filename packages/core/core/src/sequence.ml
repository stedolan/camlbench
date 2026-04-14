let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"sequence.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "sequence.ml.before-ppx"
;;

open! Import
include Base.Sequence

include Bin_prot.Utils.Make_binable1_without_uuid [@alert "-legacy"] (struct
    module Binable = struct
      type 'a t = 'a list [@@deriving bin_io]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:6:4")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , bin_shape_list
                    (Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:6:16")
                       (Bin_prot.Shape.Vid.of_string "a")) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> bin_size_list _size_of_a v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v -> bin_write_list _write_a buf ~pos v
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
          fun _of__a buf ~pos_ref vint -> (__bin_read_list__ _of__a) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref -> (bin_read_list _of__a) buf ~pos_ref
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

    type 'a t = 'a Base.Sequence.t

    let of_binable = Base.Sequence.of_list
    let to_binable = Base.Sequence.to_list
  end)

module Step = struct
  include Step

  type ('a, 's) t = ('a, 's) Step.t =
    | Done
    | Skip of { state : 's }
    | Yield of
        { value : 'a
        ; state : 's
        }
  [@@deriving bin_io]

  include struct
    let _ = fun (_ : ('a, 's) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:18:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "s" ]
            , Bin_prot.Shape.variant
                [ "Done", []
                ; ( "Skip"
                  , [ Bin_prot.Shape.record
                        [ ( "state"
                          , Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "sequence.ml.before-ppx:20:24")
                              (Bin_prot.Shape.Vid.of_string "s") )
                        ]
                    ] )
                ; ( "Yield"
                  , [ Bin_prot.Shape.record
                        [ ( "value"
                          , Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "sequence.ml.before-ppx:22:18")
                              (Bin_prot.Shape.Vid.of_string "a") )
                        ; ( "state"
                          , Bin_prot.Shape.var
                              (Bin_prot.Shape.Location.of_string
                                 "sequence.ml.before-ppx:23:18")
                              (Bin_prot.Shape.Vid.of_string "s") )
                        ]
                    ] )
                ] )
          ]
      in
      fun a s ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; s ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a 's.
         'a Bin_prot.Size.sizer
      -> 's Bin_prot.Size.sizer
      -> ('a, 's) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_s -> function
      | Skip { state = v1 } ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_s v1)
      | Yield { value = v1; state = v2 } ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
        Bin_prot.Common.( + ) size (_size_of_s v2)
      | Done -> 1
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a 's.
         'a Bin_prot.Write.writer
      -> 's Bin_prot.Write.writer
      -> ('a, 's) t Bin_prot.Write.writer
      =
      fun _write_a _write_s buf ~pos -> function
      | Done -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
      | Skip { state = v1 } ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
        _write_s buf ~pos v1
      | Yield { value = v1; state = v2 } ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
        let pos = _write_a buf ~pos v1 in
        _write_s buf ~pos v2
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a bin_writer_s ->
         { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_s.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_s.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a 's.
         'a Bin_prot.Read.reader
      -> 's Bin_prot.Read.reader
      -> (int -> ('a, 's) t) Bin_prot.Read.reader
      =
      fun _of__a _of__s _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "sequence.ml.before-ppx.Step.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 's.
         'a Bin_prot.Read.reader
      -> 's Bin_prot.Read.reader
      -> ('a, 's) t Bin_prot.Read.reader
      =
      fun _of__a _of__s buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 -> Done
      | 1 ->
        let v_state = _of__s buf ~pos_ref in
        Skip { state = v_state }
      | 2 ->
        let v_value = _of__a buf ~pos_ref in
        let v_state = _of__s buf ~pos_ref in
        Yield { value = v_value; state = v_state }
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag "sequence.ml.before-ppx.Step.t")
          !pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a bin_reader_s ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a.read bin_reader_s.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read bin_reader_s.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a bin_s ->
         { writer = bin_writer_t bin_a.writer bin_s.writer
         ; reader = bin_reader_t bin_a.reader bin_s.reader
         ; shape = bin_shape_t bin_a.shape bin_s.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Merge_with_duplicates_element = struct
  include Merge_with_duplicates_element

  type ('a, 'b) t = ('a, 'b) Merge_with_duplicates_element.t =
    | Left of 'a
    | Right of 'b
    | Both of 'a * 'b
  [@@deriving bin_io]

  include struct
    let _ = fun (_ : ('a, 'b) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:31:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "b" ]
            , Bin_prot.Shape.variant
                [ ( "Left"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:32:14")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ] )
                ; ( "Right"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:33:15")
                        (Bin_prot.Shape.Vid.of_string "b")
                    ] )
                ; ( "Both"
                  , [ Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:34:14")
                        (Bin_prot.Shape.Vid.of_string "a")
                    ; Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "sequence.ml.before-ppx:34:19")
                        (Bin_prot.Shape.Vid.of_string "b")
                    ] )
                ] )
          ]
      in
      fun a b ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; b ]
    ;;

    let _ = bin_shape_t

    let bin_size_t
      :  'a 'b.
         'a Bin_prot.Size.sizer
      -> 'b Bin_prot.Size.sizer
      -> ('a, 'b) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_b -> function
      | Left v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_a v1)
      | Right v1 ->
        let size = 1 in
        Bin_prot.Common.( + ) size (_size_of_b v1)
      | Both (v1, v2) ->
        let size = 1 in
        let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
        Bin_prot.Common.( + ) size (_size_of_b v2)
    ;;

    let _ = bin_size_t

    let bin_write_t
      :  'a 'b.
         'a Bin_prot.Write.writer
      -> 'b Bin_prot.Write.writer
      -> ('a, 'b) t Bin_prot.Write.writer
      =
      fun _write_a _write_b buf ~pos -> function
      | Left v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
        _write_a buf ~pos v1
      | Right v1 ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
        _write_b buf ~pos v1
      | Both (v1, v2) ->
        let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 2 in
        let pos = _write_a buf ~pos v1 in
        _write_b buf ~pos v2
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a bin_writer_b ->
         { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_b.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_b.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a 'b.
         'a Bin_prot.Read.reader
      -> 'b Bin_prot.Read.reader
      -> (int -> ('a, 'b) t) Bin_prot.Read.reader
      =
      fun _of__a _of__b _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type
        "sequence.ml.before-ppx.Merge_with_duplicates_element.t"
        !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 'b.
         'a Bin_prot.Read.reader
      -> 'b Bin_prot.Read.reader
      -> ('a, 'b) t Bin_prot.Read.reader
      =
      fun _of__a _of__b buf ~pos_ref ->
      match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
      | 0 ->
        let arg_1 = _of__a buf ~pos_ref in
        Left arg_1
      | 1 ->
        let arg_1 = _of__b buf ~pos_ref in
        Right arg_1
      | 2 ->
        let arg_1 = _of__a buf ~pos_ref in
        let arg_2 = _of__b buf ~pos_ref in
        Both (arg_1, arg_2)
      | _ ->
        Bin_prot.Common.raise_read_error
          (Bin_prot.Common.ReadError.Sum_tag
             "sequence.ml.before-ppx.Merge_with_duplicates_element.t")
          !pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a bin_reader_b ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a.read bin_reader_b.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read bin_reader_b.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a bin_b ->
         { writer = bin_writer_t bin_a.writer bin_b.writer
         ; reader = bin_reader_t bin_a.reader bin_b.reader
         ; shape = bin_shape_t bin_a.shape bin_b.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Heap = sig
  type 'a t

  val create : compare:('a -> 'a -> int) -> 'a t
  val add : 'a t -> 'a -> 'a t
  val pop_min : 'a t -> ('a * 'a t) option
end

let merge_all ((module Heap) : (module Heap)) seqs ~compare =
  let module Merge_all_state = struct
    type 'a t =
      { heap : ('a * 'a Base.Sequence.t) Heap.t
      ; not_yet_in_heap : 'a Base.Sequence.t list
      }
    [@@deriving fields ~iterators:create]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()
      let not_yet_in_heap _r__ = _r__.not_yet_in_heap
      let _ = not_yet_in_heap
      let heap _r__ = _r__.heap
      let _ = heap

      module Fields = struct
        let not_yet_in_heap =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "not_yet_in_heap"
             ; getter = not_yet_in_heap
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with not_yet_in_heap = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , 'a Base.Sequence.t list )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = not_yet_in_heap

        let heap =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "heap"
             ; getter = heap
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with heap = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , ('a * 'a Base.Sequence.t) Heap.t )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = heap
        let create ~heap ~not_yet_in_heap = { heap; not_yet_in_heap }
        let _ = create
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create = Fields.create
  end
  in
  unfold_step
    ~init:
      (Merge_all_state.create
         ~heap:(Heap.create ~compare:(fun a b -> Base.Comparable.lift compare ~f:fst a b))
         ~not_yet_in_heap:seqs)
    ~f:(fun { heap; not_yet_in_heap } ->
      match not_yet_in_heap with
      | seq :: not_yet_in_heap ->
        (match Expert.next_step seq with
         | Done -> Skip { state = { not_yet_in_heap; heap } }
         | Skip { state = seq } ->
           Skip { state = { not_yet_in_heap = seq :: not_yet_in_heap; heap } }
         | Yield { value = elt; state = seq } ->
           Skip { state = { not_yet_in_heap; heap = Heap.add heap (elt, seq) } })
      | [] ->
        (match Heap.pop_min heap with
         | None -> Done
         | Some ((elt, seq), heap) ->
           Yield { value = elt; state = { heap; not_yet_in_heap = [ seq ] } }))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
