let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"ref.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "ref.ml.before-ppx"
;;

open! Import
open Base_quickcheck.Export

module T = struct
  include Base.Ref

  include (
  struct
    type 'a t = 'a ref [@@deriving bin_io ~localize, quickcheck, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "ref.ml.before-ppx:9:6")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_ref
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "ref.ml.before-ppx:9:18")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local v -> bin_size_ref__local _size_of_a__local v
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_ref _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
        =
        fun _write_a__local buf ~pos v -> bin_write_ref__local _write_a__local buf ~pos v
      ;;

      let _ = bin_write_t__local

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_ref _write_a buf ~pos v
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
        fun _of__a buf ~pos_ref vint -> (__bin_read_ref__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_ref _of__a) buf ~pos_ref
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
        quickcheck_generator_ref _generator__003_
      ;;

      let _ = quickcheck_generator
      let quickcheck_observer _observer__002_ = quickcheck_observer_ref _observer__002_
      let _ = quickcheck_observer
      let quickcheck_shrinker _shrinker__001_ = quickcheck_shrinker_ref _shrinker__001_
      let _ = quickcheck_shrinker

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
          type nonrec 'a t = 'a t

          let name = "ref.ml.before-ppx.T.t"
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
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_ref _of_a)))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end :
    sig
      type 'a t = 'a ref [@@deriving bin_io ~localize, quickcheck, typerep]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S_local1 with type 'a t := 'a t
        include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
        include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type 'a t := 'a t)
end

include T

module Permissioned = struct
  include T

  type ('a, -'perms) t = 'a T.t [@@deriving bin_io ~localize, sexp]

  include struct
    let _ = fun (_ : ('a, 'perms) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "ref.ml.before-ppx:22:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "perms" ]
            , T.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "ref.ml.before-ppx:22:25")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a perms ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; perms ]
    ;;

    let _ = bin_shape_t

    let bin_size_t__local
      :  'a 'perms.
         'a Bin_prot.Size.sizer_local
      -> 'perms Bin_prot.Size.sizer_local
      -> ('a, 'perms) t Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local _size_of_perms__local v ->
      T.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_t__local

    let bin_size_t
      :  'a 'perms.
         'a Bin_prot.Size.sizer
      -> 'perms Bin_prot.Size.sizer
      -> ('a, 'perms) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_perms v -> T.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_t

    let bin_write_t__local
      :  'a 'perms.
         'a Bin_prot.Write.writer_local
      -> 'perms Bin_prot.Write.writer_local
      -> ('a, 'perms) t Bin_prot.Write.writer_local
      =
      fun _write_a__local _write_perms__local buf ~pos v ->
      T.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_t__local

    let bin_write_t
      :  'a 'perms.
         'a Bin_prot.Write.writer
      -> 'perms Bin_prot.Write.writer
      -> ('a, 'perms) t Bin_prot.Write.writer
      =
      fun _write_a _write_perms buf ~pos v -> T.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a bin_writer_perms ->
         { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_perms.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_perms.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a 'perms.
         'a Bin_prot.Read.reader
      -> 'perms Bin_prot.Read.reader
      -> (int -> ('a, 'perms) t) Bin_prot.Read.reader
      =
      fun _of__a _of__perms buf ~pos_ref vint ->
      (T.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 'perms.
         'a Bin_prot.Read.reader
      -> 'perms Bin_prot.Read.reader
      -> ('a, 'perms) t Bin_prot.Read.reader
      =
      fun _of__a _of__perms buf ~pos_ref -> (T.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a bin_reader_perms ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a.read bin_reader_perms.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read bin_reader_perms.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a bin_perms ->
         { writer = bin_writer_t bin_a.writer bin_perms.writer
         ; reader = bin_reader_t bin_a.reader bin_perms.reader
         ; shape = bin_shape_t bin_a.shape bin_perms.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let t_of_sexp
      :  'a 'perms.
         (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'perms)
      -> Sexplib0.Sexp.t
      -> ('a, 'perms) t
      =
      fun _of_a__004_ _of_perms__005_ x__007_ -> T.t_of_sexp _of_a__004_ x__007_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a 'perms.
         ('a -> Sexplib0.Sexp.t)
      -> ('perms -> Sexplib0.Sexp.t)
      -> ('a, 'perms) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a__008_ _of_perms__009_ x__010_ -> T.sexp_of_t _of_a__008_ x__010_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let read_only = Fn.id
  let of_ref = Fn.id
  let to_ref = Fn.id
  let set = ( := )
  let get = ( ! )
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
