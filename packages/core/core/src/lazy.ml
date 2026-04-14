let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"lazy.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "lazy.ml.before-ppx"
;;

open! Import
open Base_quickcheck.Export

module Stable = struct
  module V1 = struct
    open Sexplib.Std

    type 'a t = 'a lazy_t
    [@@deriving bin_io ~localize, quickcheck, sexp, sexp_grammar, typerep, stable_witness]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "lazy.ml.before-ppx:8:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_lazy_t
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "lazy.ml.before-ppx:8:16")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local v -> bin_size_lazy_t__local _size_of_a__local v
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_lazy_t _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
        =
        fun _write_a__local buf ~pos v ->
        bin_write_lazy_t__local _write_a__local buf ~pos v
      ;;

      let _ = bin_write_t__local

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_lazy_t _write_a buf ~pos v
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
        fun _of__a buf ~pos_ref vint -> (__bin_read_lazy_t__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_lazy_t _of__a) buf ~pos_ref
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

      let quickcheck_generator _generator__003_ =
        quickcheck_generator_lazy_t _generator__003_
      ;;

      let _ = quickcheck_generator
      let quickcheck_observer _observer__002_ = quickcheck_observer_lazy_t _observer__002_
      let _ = quickcheck_observer
      let quickcheck_shrinker _shrinker__001_ = quickcheck_shrinker_lazy_t _shrinker__001_
      let _ = quickcheck_shrinker

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__004_ x__006_ -> lazy_t_of_sexp _of_a__004_ x__006_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__007_ x__008_ -> sexp_of_lazy_t _of_a__007_ x__008_
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar -> lazy_t_sexp_grammar _'a_sexp_grammar
      ;;

      let _ = t_sexp_grammar

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
          type nonrec 'a t = 'a t

          let name = "lazy.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t
        =
        fun (type a) ->
        fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_a in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_lazy_t _of_a)))
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
          -> 'a lazy_t Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_lazy_t
        and _ : 'a Ppx_stable_witness_runtime.Stable_witness.t = __'a_stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let map = Base.Lazy.map
    let compare = Base.Lazy.compare
    let compare__local = Base.Lazy.compare__local
    let equal = Base.Lazy.equal
  end
end

module type Base_mask = module type of Base.Lazy with type 'a t := 'a Stable.V1.t

include Stable.V1
include (Base.Lazy : Base_mask)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
