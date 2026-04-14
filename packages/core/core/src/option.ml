let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"option.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "option.ml.before-ppx"
;;

open! Import
include Base.Option

type 'a t = 'a option [@@deriving bin_io ~localize, typerep, stable_witness]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "option.ml.before-ppx:4:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , bin_shape_option
              (Bin_prot.Shape.var
                 (Bin_prot.Shape.Location.of_string "option.ml.before-ppx:4:12")
                 (Bin_prot.Shape.Vid.of_string "a")) )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t__local
    : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
    =
    fun _size_of_a__local v -> bin_size_option__local _size_of_a__local v
  ;;

  let _ = bin_size_t__local

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a v -> bin_size_option _size_of_a v
  ;;

  let _ = bin_size_t

  let bin_write_t__local
    : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
    =
    fun _write_a__local buf ~pos v -> bin_write_option__local _write_a__local buf ~pos v
  ;;

  let _ = bin_write_t__local

  let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
    fun _write_a buf ~pos v -> bin_write_option _write_a buf ~pos v
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
    fun _of__a buf ~pos_ref vint -> (__bin_read_option__ _of__a) buf ~pos_ref vint
  ;;

  let _ = __bin_read_t__

  let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref -> (bin_read_option _of__a) buf ~pos_ref
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

      let name = "option.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t =
    fun (type a) ->
    fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
    let name_of_t = Typename_of_t.named _of_a in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_option _of_a)))
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
      -> 'a option Ppx_stable_witness_runtime.Stable_witness.t
      =
      stable_witness_option
    and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
    ()
  ;;

  let _ = stable_witness
  and _ = __stable_witness_checks_for_t__
end [@@ocaml.doc "@inline"] [@@merlin.hide]

include Comparator.Derived (struct
    type nonrec 'a t = 'a t [@@deriving sexp_of, compare]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__001_ x__002_ -> sexp_of_t _of_a__001_ x__002_
      ;;

      let _ = sexp_of_t

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__003_ b__004_ ->
        compare
          (fun a__005_ (b__006_ [@merlin.hide]) ->
             (_cmp__a a__005_ b__006_ [@merlin.hide]))
          a__003_
          b__004_
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

let validate ~none ~some t =
  let module V = Validate in
  match t with
  | None -> V.name "none" (V.protect none ())
  | Some x -> V.name "some" (V.protect some x)
;;

let quickcheck_generator = Base_quickcheck.Generator.option
let quickcheck_observer = Base_quickcheck.Observer.option
let quickcheck_shrinker = Base_quickcheck.Shrinker.option

module Stable = struct
  module V1 = struct
    type nonrec 'a t = 'a t
    [@@deriving
      bin_io ~localize, compare, equal, hash, sexp, sexp_grammar, stable_witness]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "option.ml.before-ppx:23:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_t
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "option.ml.before-ppx:23:23")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local v -> bin_size_t__local _size_of_a__local v
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_t _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
        =
        fun _write_a__local buf ~pos v -> bin_write_t__local _write_a__local buf ~pos v
      ;;

      let _ = bin_write_t__local

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
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
        fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
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
        fun _cmp__a a__007_ b__008_ ->
        compare
          (fun a__009_ (b__010_ [@merlin.hide]) ->
             (_cmp__a a__009_ b__010_ [@merlin.hide]))
          a__007_
          b__008_
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__011_ b__012_ ->
        equal
          (fun a__013_ (b__014_ [@merlin.hide]) ->
             (_cmp__a a__013_ b__014_ [@merlin.hide]))
          a__011_
          b__012_
      ;;

      let _ = equal

      let hash_fold_t
        :  'a.
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
      ;;

      let _ = hash_fold_t

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__015_ x__017_ -> t_of_sexp _of_a__015_ x__017_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__018_ x__019_ -> sexp_of_t _of_a__018_ x__019_
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar -> t_sexp_grammar _'a_sexp_grammar
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
          -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Optional_syntax = struct
  module Optional_syntax = struct
    let is_none = is_none

    module Unchecked_some = struct
      type 'a t = Unchecked_some of 'a [@@ocaml.boxed] [@@ocaml.warning "-37"]
    end

    let unsafe_value (type a) (t : a t) : a =
      let (Unchecked_some value) = (Obj.magic t : a Unchecked_some.t) in
      value
    ;;
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
