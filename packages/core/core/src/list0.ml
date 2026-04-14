let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"list0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "list0.ml.before-ppx"
;;

open! Import
open! Typerep_lib.Std
include Base.List

type 'a t = 'a list [@@deriving bin_io ~localize, typerep, stable_witness]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "list0.ml.before-ppx:5:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , bin_shape_list
              (Bin_prot.Shape.var
                 (Bin_prot.Shape.Location.of_string "list0.ml.before-ppx:5:12")
                 (Bin_prot.Shape.Vid.of_string "a")) )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t__local
    : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
    =
    fun _size_of_a__local v -> bin_size_list__local _size_of_a__local v
  ;;

  let _ = bin_size_t__local

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a v -> bin_size_list _size_of_a v
  ;;

  let _ = bin_size_t

  let bin_write_t__local
    : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
    =
    fun _write_a__local buf ~pos v -> bin_write_list__local _write_a__local buf ~pos v
  ;;

  let _ = bin_write_t__local

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

  let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader =
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
           (fun buf ~pos_ref vtag -> (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
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

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
      type nonrec 'a t = 'a t

      let name = "list0.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t =
    fun (type a) ->
    fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
    let name_of_t = Typename_of_t.named _of_a in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_list _of_a)))
  ;;

  let _ = typerep_of_t

  let stable_witness
        (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
    =
    (Ppx_stable_witness_runtime.Stable_witness.assert_stable
     : 'a t Ppx_stable_witness_runtime.Stable_witness.t)

  and __stable_witness_checks_for_t__
        (__'a_stable_witness : 'a Ppx_stable_witness_runtime.Stable_witness.t)
        ()
    =
    let _
      :  'a Ppx_stable_witness_runtime.Stable_witness.t
      -> 'a list Ppx_stable_witness_runtime.Stable_witness.t
      =
      stable_witness_list
    and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
    ()
  ;;

  let _ = stable_witness
  and _ = __stable_witness_checks_for_t__
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Assoc = struct
  include Assoc

  type ('a, 'b) t = ('a * 'b) list [@@deriving bin_io ~localize]

  include struct
    let _ = fun (_ : ('a, 'b) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "list0.ml.before-ppx:10:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "b" ]
            , bin_shape_list
                (Bin_prot.Shape.tuple
                   [ Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "list0.ml.before-ppx:10:21")
                       (Bin_prot.Shape.Vid.of_string "a")
                   ; Bin_prot.Shape.var
                       (Bin_prot.Shape.Location.of_string "list0.ml.before-ppx:10:26")
                       (Bin_prot.Shape.Vid.of_string "b")
                   ]) )
          ]
      in
      fun a b ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; b ]
    ;;

    let _ = bin_shape_t

    let bin_size_t__local
      :  'a 'b.
         'a Bin_prot.Size.sizer_local
      -> 'b Bin_prot.Size.sizer_local
      -> ('a, 'b) t Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local _size_of_b__local v ->
      bin_size_list__local
        (function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (_size_of_a__local v1) in
            Bin_prot.Common.( + ) size (_size_of_b__local v2))
        v
    ;;

    let _ = bin_size_t__local

    let bin_size_t
      :  'a 'b.
         'a Bin_prot.Size.sizer
      -> 'b Bin_prot.Size.sizer
      -> ('a, 'b) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_b v ->
      bin_size_list
        (function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
            Bin_prot.Common.( + ) size (_size_of_b v2))
        v
    ;;

    let _ = bin_size_t

    let bin_write_t__local
      :  'a 'b.
         'a Bin_prot.Write.writer_local
      -> 'b Bin_prot.Write.writer_local
      -> ('a, 'b) t Bin_prot.Write.writer_local
      =
      fun _write_a__local _write_b__local buf ~pos v ->
      bin_write_list__local
        (fun buf ~pos -> function
           | v1, v2 ->
             let pos = _write_a__local buf ~pos v1 in
             _write_b__local buf ~pos v2)
        buf
        ~pos
        v
    ;;

    let _ = bin_write_t__local

    let bin_write_t
      :  'a 'b.
         'a Bin_prot.Write.writer
      -> 'b Bin_prot.Write.writer
      -> ('a, 'b) t Bin_prot.Write.writer
      =
      fun _write_a _write_b buf ~pos v ->
      bin_write_list
        (fun buf ~pos -> function
           | v1, v2 ->
             let pos = _write_a buf ~pos v1 in
             _write_b buf ~pos v2)
        buf
        ~pos
        v
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
      fun _of__a _of__b buf ~pos_ref vint ->
      (__bin_read_list__ (fun buf ~pos_ref ->
         let v1 = _of__a buf ~pos_ref in
         let v2 = _of__b buf ~pos_ref in
         v1, v2))
        buf
        ~pos_ref
        vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 'b.
         'a Bin_prot.Read.reader
      -> 'b Bin_prot.Read.reader
      -> ('a, 'b) t Bin_prot.Read.reader
      =
      fun _of__a _of__b buf ~pos_ref ->
      (bin_read_list (fun buf ~pos_ref ->
         let v1 = _of__a buf ~pos_ref in
         let v2 = _of__b buf ~pos_ref in
         v1, v2))
        buf
        ~pos_ref
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

  let compare (type a) (type b) compare_a compare_b =
    fun (a__001_ : (a * b) list) ((b__002_ : (a * b) list) [@merlin.hide]) ->
    (compare_list
       (fun a__003_ (b__004_ [@merlin.hide]) ->
          ((let t__005_, t__006_ = a__003_ in
            let t__007_, t__008_ = b__004_ in
            match compare_a t__005_ t__007_ with
            | 0 -> compare_b t__006_ t__008_
            | n -> n)
          [@merlin.hide]))
       a__001_
       b__002_ [@merlin.hide])
  ;;
end

let to_string ~f t =
  Sexplib.Sexp.to_string (sexp_of_t (fun x -> Sexplib.Sexp.Atom x) (map t ~f))
;;

include Comparator.Derived (struct
    type nonrec 'a t = 'a t [@@deriving sexp_of, compare]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__009_ x__010_ -> sexp_of_t _of_a__009_ x__010_
      ;;

      let _ = sexp_of_t

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__011_ b__012_ ->
        compare
          (fun a__013_ (b__014_ [@merlin.hide]) ->
             (_cmp__a a__013_ b__014_ [@merlin.hide]))
          a__011_
          b__012_
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

let quickcheck_generator = Base_quickcheck.Generator.list
let gen_non_empty = Base_quickcheck.Generator.list_non_empty

let gen_with_length length quickcheck_generator =
  Base_quickcheck.Generator.list_with_length quickcheck_generator ~length
;;

let gen_filtered = Base_quickcheck.Generator.list_filtered
let gen_permutations = Base_quickcheck.Generator.list_permutations
let quickcheck_observer = Base_quickcheck.Observer.list
let quickcheck_shrinker = Base_quickcheck.Shrinker.list
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
