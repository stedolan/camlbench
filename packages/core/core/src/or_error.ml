let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"or_error.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "or_error.ml.before-ppx"
;;

open! Import
include Base.Or_error

type 'a t = ('a, Error.t) Result.t [@@deriving bin_io, diff ~extra_derive:[ sexp ]]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:4:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , (Result.bin_shape_t
               (Bin_prot.Shape.var
                  (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:4:13")
                  (Bin_prot.Shape.Vid.of_string "a")))
              Error.bin_shape_t )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a v -> Result.bin_size_t _size_of_a Error.bin_size_t v
  ;;

  let _ = bin_size_t

  let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
    fun _write_a buf ~pos v -> Result.bin_write_t _write_a Error.bin_write_t buf ~pos v
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
    fun _of__a buf ~pos_ref vint ->
    (Result.__bin_read_t__ _of__a Error.bin_read_t) buf ~pos_ref vint
  ;;

  let _ = __bin_read_t__

  let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref -> (Result.bin_read_t _of__a Error.bin_read_t) buf ~pos_ref
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

  module Diff = struct
    open! Diffable.For_ppx

    [@@@ocaml.warning "-34"]

    type 'a derived_on = 'a t

    type ('a, 'a_diff) t = ('a, Error.t, 'a_diff, Error.Diff.t) Result.Diff.t
    [@@deriving bin_io, sexp]

    include struct
      let _ = fun (_ : ('a, 'a_diff) t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:4:0")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a"
                ; Bin_prot.Shape.Vid.of_string "a_diff"
                ]
              , (((Result.Diff.bin_shape_t
                     (Bin_prot.Shape.var
                        (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:4:0")
                        (Bin_prot.Shape.Vid.of_string "a")))
                    Error.bin_shape_t)
                   (Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:4:0")
                      (Bin_prot.Shape.Vid.of_string "a_diff")))
                  Error.Diff.bin_shape_t )
            ]
        in
        fun a a_diff ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; a_diff ]
      ;;

      let _ = bin_shape_t

      let bin_size_t
        :  'a 'a_diff.
           'a Bin_prot.Size.sizer
        -> 'a_diff Bin_prot.Size.sizer
        -> ('a, 'a_diff) t Bin_prot.Size.sizer
        =
        fun _size_of_a _size_of_a_diff v ->
        Result.Diff.bin_size_t
          _size_of_a
          Error.bin_size_t
          _size_of_a_diff
          Error.Diff.bin_size_t
          v
      ;;

      let _ = bin_size_t

      let bin_write_t
        :  'a 'a_diff.
           'a Bin_prot.Write.writer
        -> 'a_diff Bin_prot.Write.writer
        -> ('a, 'a_diff) t Bin_prot.Write.writer
        =
        fun _write_a _write_a_diff buf ~pos v ->
        Result.Diff.bin_write_t
          _write_a
          Error.bin_write_t
          _write_a_diff
          Error.Diff.bin_write_t
          buf
          ~pos
          v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a bin_writer_a_diff ->
           { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_a_diff.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_a_diff.write v)
           }
         : _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer
           -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        :  'a 'a_diff.
           'a Bin_prot.Read.reader
        -> 'a_diff Bin_prot.Read.reader
        -> (int -> ('a, 'a_diff) t) Bin_prot.Read.reader
        =
        fun _of__a _of__a_diff buf ~pos_ref vint ->
        (Result.Diff.__bin_read_t__
           _of__a
           Error.bin_read_t
           _of__a_diff
           Error.Diff.bin_read_t)
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        :  'a 'a_diff.
           'a Bin_prot.Read.reader
        -> 'a_diff Bin_prot.Read.reader
        -> ('a, 'a_diff) t Bin_prot.Read.reader
        =
        fun _of__a _of__a_diff buf ~pos_ref ->
        (Result.Diff.bin_read_t _of__a Error.bin_read_t _of__a_diff Error.Diff.bin_read_t)
          buf
          ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a bin_reader_a_diff ->
           { read =
               (fun buf ~pos_ref ->
                 (bin_read_t bin_reader_a.read bin_reader_a_diff.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read bin_reader_a_diff.read)
                   buf
                   ~pos_ref
                   vtag)
           }
         : _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader
           -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a bin_a_diff ->
           { writer = bin_writer_t bin_a.writer bin_a_diff.writer
           ; reader = bin_reader_t bin_a.reader bin_a_diff.reader
           ; shape = bin_shape_t bin_a.shape bin_a_diff.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let t_of_sexp
        :  'a 'a_diff.
           (Sexplib0.Sexp.t -> 'a)
        -> (Sexplib0.Sexp.t -> 'a_diff)
        -> Sexplib0.Sexp.t
        -> ('a, 'a_diff) t
        =
        fun _of_a__001_ _of_a_diff__002_ x__004_ ->
        Result.Diff.t_of_sexp
          _of_a__001_
          Error.t_of_sexp
          _of_a_diff__002_
          Error.Diff.t_of_sexp
          x__004_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        :  'a 'a_diff.
           ('a -> Sexplib0.Sexp.t)
        -> ('a_diff -> Sexplib0.Sexp.t)
        -> ('a, 'a_diff) t
        -> Sexplib0.Sexp.t
        =
        fun _of_a__005_ _of_a_diff__006_ x__007_ ->
        Result.Diff.sexp_of_t
          _of_a__005_
          Error.sexp_of_t
          _of_a_diff__006_
          Error.Diff.sexp_of_t
          x__007_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let get
      :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> from:'a derived_on
      -> to_:'a derived_on
      -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
      =
      fun _get_a -> Result.Diff.get _get_a Error.Diff.get
    ;;

    let _ = get

    let apply_exn
      : ('a -> 'a_diff -> 'a) -> 'a derived_on -> ('a, 'a_diff) t -> 'a derived_on
      =
      fun _apply_a_exn -> Result.Diff.apply_exn _apply_a_exn Error.Diff.apply_exn
    ;;

    let _ = apply_exn

    let of_list_exn
      :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
      -> ('a -> 'a_diff -> 'a)
      -> ('a, 'a_diff) t list
      -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
      =
      fun _of_list_a_exn _apply_a_exn ->
      Result.Diff.of_list_exn
        _of_list_a_exn
        _apply_a_exn
        Error.Diff.of_list_exn
        Error.Diff.apply_exn
    ;;

    let _ = of_list_exn
  end
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Expect_test_config = struct
  module IO = Base.Or_error

  let run f = ok_exn (f ())
  let sanitize s = s
  let upon_unreleasable_issue = Expect_test_config.upon_unreleasable_issue
end

module Expect_test_config_with_unit_expect = Expect_test_config

module Stable = struct
  module V1 = struct
    type 'a t = ('a, Error.Stable.V1.t) Result.Stable.V1.t
    [@@deriving bin_io, compare, sexp, stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:18:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , (Result.Stable.V1.bin_shape_t
                   (Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:18:17")
                      (Bin_prot.Shape.Vid.of_string "a")))
                  Error.Stable.V1.bin_shape_t )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v ->
        Result.Stable.V1.bin_size_t _size_of_a Error.Stable.V1.bin_size_t v
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v ->
        Result.Stable.V1.bin_write_t _write_a Error.Stable.V1.bin_write_t buf ~pos v
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
        (Result.Stable.V1.__bin_read_t__ _of__a Error.Stable.V1.bin_read_t)
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        (Result.Stable.V1.bin_read_t _of__a Error.Stable.V1.bin_read_t) buf ~pos_ref
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

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__008_ b__009_ ->
        Result.Stable.V1.compare
          (fun a__010_ (b__011_ [@merlin.hide]) ->
             (_cmp__a a__010_ b__011_ [@merlin.hide]))
          (fun a__012_ (b__013_ [@merlin.hide]) ->
             (Error.Stable.V1.compare a__012_ b__013_ [@merlin.hide]))
          a__008_
          b__009_
      ;;

      let _ = compare

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__014_ x__016_ ->
        Result.Stable.V1.t_of_sexp _of_a__014_ Error.Stable.V1.t_of_sexp x__016_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__017_ x__018_ ->
        Result.Stable.V1.sexp_of_t _of_a__017_ Error.Stable.V1.sexp_of_t x__018_
      ;;

      let _ = sexp_of_t

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
          -> Error.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t
          -> ('a, Error.Stable.V1.t) Result.Stable.V1.t
               Ppx_stable_witness_runtime.Stable_witness.t
          =
          Result.Stable.V1.stable_witness
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness
        and _ : Error.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
          Error.Stable.V1.stable_witness
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let map x ~f = Result.Stable.V1.map x ~f1:f ~f2:Fn.id
  end

  module V2 = struct
    type 'a t = ('a, Error.Stable.V2.t) Result.Stable.V1.t
    [@@deriving bin_io, compare, equal, sexp, sexp_grammar, stable_witness, diff]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:25:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , (Result.Stable.V1.bin_shape_t
                   (Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:25:17")
                      (Bin_prot.Shape.Vid.of_string "a")))
                  Error.Stable.V2.bin_shape_t )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v ->
        Result.Stable.V1.bin_size_t _size_of_a Error.Stable.V2.bin_size_t v
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v ->
        Result.Stable.V1.bin_write_t _write_a Error.Stable.V2.bin_write_t buf ~pos v
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
        (Result.Stable.V1.__bin_read_t__ _of__a Error.Stable.V2.bin_read_t)
          buf
          ~pos_ref
          vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        (Result.Stable.V1.bin_read_t _of__a Error.Stable.V2.bin_read_t) buf ~pos_ref
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

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__019_ b__020_ ->
        Result.Stable.V1.compare
          (fun a__021_ (b__022_ [@merlin.hide]) ->
             (_cmp__a a__021_ b__022_ [@merlin.hide]))
          (fun a__023_ (b__024_ [@merlin.hide]) ->
             (Error.Stable.V2.compare a__023_ b__024_ [@merlin.hide]))
          a__019_
          b__020_
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__025_ b__026_ ->
        Result.Stable.V1.equal
          (fun a__027_ (b__028_ [@merlin.hide]) ->
             (_cmp__a a__027_ b__028_ [@merlin.hide]))
          (fun a__029_ (b__030_ [@merlin.hide]) ->
             (Error.Stable.V2.equal a__029_ b__030_ [@merlin.hide]))
          a__025_
          b__026_
      ;;

      let _ = equal

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__031_ x__033_ ->
        Result.Stable.V1.t_of_sexp _of_a__031_ Error.Stable.V2.t_of_sexp x__033_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__034_ x__035_ ->
        Result.Stable.V1.sexp_of_t _of_a__034_ Error.Stable.V2.sexp_of_t x__035_
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar ->
        Result.Stable.V1.t_sexp_grammar _'a_sexp_grammar Error.Stable.V2.t_sexp_grammar
      ;;

      let _ = t_sexp_grammar

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
          -> Error.Stable.V2.t Ppx_stable_witness_runtime.Stable_witness.t
          -> ('a, Error.Stable.V2.t) Result.Stable.V1.t
               Ppx_stable_witness_runtime.Stable_witness.t
          =
          Result.Stable.V1.stable_witness
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness
        and _ : Error.Stable.V2.t Ppx_stable_witness_runtime.Stable_witness.t =
          Error.Stable.V2.stable_witness
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__

      module Diff = struct
        open! Diffable.For_ppx

        [@@@ocaml.warning "-34"]

        type 'a derived_on = 'a t

        type ('a, 'a_diff) t =
          ('a, Error.Stable.V2.t, 'a_diff, Error.Stable.V2.Diff.t) Result.Stable.V1.Diff.t
        [@@deriving bin_io, sexp]

        include struct
          let _ = fun (_ : ('a, 'a_diff) t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "or_error.ml.before-ppx:25:4")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , [ Bin_prot.Shape.Vid.of_string "a"
                    ; Bin_prot.Shape.Vid.of_string "a_diff"
                    ]
                  , (((Result.Stable.V1.Diff.bin_shape_t
                         (Bin_prot.Shape.var
                            (Bin_prot.Shape.Location.of_string
                               "or_error.ml.before-ppx:25:4")
                            (Bin_prot.Shape.Vid.of_string "a")))
                        Error.Stable.V2.bin_shape_t)
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "or_error.ml.before-ppx:25:4")
                          (Bin_prot.Shape.Vid.of_string "a_diff")))
                      Error.Stable.V2.Diff.bin_shape_t )
                ]
            in
            fun a a_diff ->
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t"))
                [ a; a_diff ]
          ;;

          let _ = bin_shape_t

          let bin_size_t
            :  'a 'a_diff.
               'a Bin_prot.Size.sizer
            -> 'a_diff Bin_prot.Size.sizer
            -> ('a, 'a_diff) t Bin_prot.Size.sizer
            =
            fun _size_of_a _size_of_a_diff v ->
            Result.Stable.V1.Diff.bin_size_t
              _size_of_a
              Error.Stable.V2.bin_size_t
              _size_of_a_diff
              Error.Stable.V2.Diff.bin_size_t
              v
          ;;

          let _ = bin_size_t

          let bin_write_t
            :  'a 'a_diff.
               'a Bin_prot.Write.writer
            -> 'a_diff Bin_prot.Write.writer
            -> ('a, 'a_diff) t Bin_prot.Write.writer
            =
            fun _write_a _write_a_diff buf ~pos v ->
            Result.Stable.V1.Diff.bin_write_t
              _write_a
              Error.Stable.V2.bin_write_t
              _write_a_diff
              Error.Stable.V2.Diff.bin_write_t
              buf
              ~pos
              v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            (fun bin_writer_a bin_writer_a_diff ->
               { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_a_diff.size v)
               ; write =
                   (fun v -> bin_write_t bin_writer_a.write bin_writer_a_diff.write v)
               }
             : _ Bin_prot.Type_class.writer
               -> _ Bin_prot.Type_class.writer
               -> _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__
            :  'a 'a_diff.
               'a Bin_prot.Read.reader
            -> 'a_diff Bin_prot.Read.reader
            -> (int -> ('a, 'a_diff) t) Bin_prot.Read.reader
            =
            fun _of__a _of__a_diff buf ~pos_ref vint ->
            (Result.Stable.V1.Diff.__bin_read_t__
               _of__a
               Error.Stable.V2.bin_read_t
               _of__a_diff
               Error.Stable.V2.Diff.bin_read_t)
              buf
              ~pos_ref
              vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t
            :  'a 'a_diff.
               'a Bin_prot.Read.reader
            -> 'a_diff Bin_prot.Read.reader
            -> ('a, 'a_diff) t Bin_prot.Read.reader
            =
            fun _of__a _of__a_diff buf ~pos_ref ->
            (Result.Stable.V1.Diff.bin_read_t
               _of__a
               Error.Stable.V2.bin_read_t
               _of__a_diff
               Error.Stable.V2.Diff.bin_read_t)
              buf
              ~pos_ref
          ;;

          let _ = bin_read_t

          let bin_reader_t =
            (fun bin_reader_a bin_reader_a_diff ->
               { read =
                   (fun buf ~pos_ref ->
                     (bin_read_t bin_reader_a.read bin_reader_a_diff.read) buf ~pos_ref)
               ; vtag_read =
                   (fun buf ~pos_ref vtag ->
                     (__bin_read_t__ bin_reader_a.read bin_reader_a_diff.read)
                       buf
                       ~pos_ref
                       vtag)
               }
             : _ Bin_prot.Type_class.reader
               -> _ Bin_prot.Type_class.reader
               -> _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            (fun bin_a bin_a_diff ->
               { writer = bin_writer_t bin_a.writer bin_a_diff.writer
               ; reader = bin_reader_t bin_a.reader bin_a_diff.reader
               ; shape = bin_shape_t bin_a.shape bin_a_diff.shape
               }
             : _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t
               -> _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let t_of_sexp
            :  'a 'a_diff.
               (Sexplib0.Sexp.t -> 'a)
            -> (Sexplib0.Sexp.t -> 'a_diff)
            -> Sexplib0.Sexp.t
            -> ('a, 'a_diff) t
            =
            fun _of_a__036_ _of_a_diff__037_ x__039_ ->
            Result.Stable.V1.Diff.t_of_sexp
              _of_a__036_
              Error.Stable.V2.t_of_sexp
              _of_a_diff__037_
              Error.Stable.V2.Diff.t_of_sexp
              x__039_
          ;;

          let _ = t_of_sexp

          let sexp_of_t
            :  'a 'a_diff.
               ('a -> Sexplib0.Sexp.t)
            -> ('a_diff -> Sexplib0.Sexp.t)
            -> ('a, 'a_diff) t
            -> Sexplib0.Sexp.t
            =
            fun _of_a__040_ _of_a_diff__041_ x__042_ ->
            Result.Stable.V1.Diff.sexp_of_t
              _of_a__040_
              Error.Stable.V2.sexp_of_t
              _of_a_diff__041_
              Error.Stable.V2.Diff.sexp_of_t
              x__042_
          ;;

          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let get
          :  (from:'a -> to_:'a -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> from:'a derived_on
          -> to_:'a derived_on
          -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
          =
          fun _get_a -> Result.Stable.V1.Diff.get _get_a Error.Stable.V2.Diff.get
        ;;

        let _ = get

        let apply_exn
          : ('a -> 'a_diff -> 'a) -> 'a derived_on -> ('a, 'a_diff) t -> 'a derived_on
          =
          fun _apply_a_exn ->
          Result.Stable.V1.Diff.apply_exn _apply_a_exn Error.Stable.V2.Diff.apply_exn
        ;;

        let _ = apply_exn

        let of_list_exn
          :  ('a_diff list -> ('a_diff Optional_diff.t[@jane.erasable.mode local]))
          -> ('a -> 'a_diff -> 'a)
          -> ('a, 'a_diff) t list
          -> (('a, 'a_diff) t Optional_diff.t[@jane.erasable.mode local])
          =
          fun _of_list_a_exn _apply_a_exn ->
          Result.Stable.V1.Diff.of_list_exn
            _of_list_a_exn
            _apply_a_exn
            Error.Stable.V2.Diff.of_list_exn
            Error.Stable.V2.Diff.apply_exn
        ;;

        let _ = of_list_exn
      end
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let map x ~f = Result.Stable.V1.map x ~f1:f ~f2:Fn.id
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
