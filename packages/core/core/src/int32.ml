let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"int32.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "int32.ml.before-ppx"
;;

open! Import

module Binable = struct
  type t = int32 [@@deriving bin_io ~localize]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int32.ml.before-ppx:4:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int32 ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_int32__local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_int32__local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int32__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_int32
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

include Binable
include Identifiable.Extend (Base.Int32) (Binable)
include Base.Int32
include Comparable.Validate_with_zero (Base.Int32)

type t = int32 [@@deriving typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "int32.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_int32))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Binary = struct
  include Binary

  type nonrec t = t [@@deriving typerep, bin_io ~localize]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "int32.ml.before-ppx.Binary.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
    ;;

    let _ = typerep_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int32.ml.before-ppx:17:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_t__local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_t__local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Hex = struct
  include Hex

  type nonrec t = t [@@deriving typerep, bin_io ~localize]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "int32.ml.before-ppx.Hex.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
    ;;

    let _ = typerep_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int32.ml.before-ppx:23:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_t__local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_t__local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let quickcheck_generator = Base_quickcheck.Generator.int32
let quickcheck_observer = Base_quickcheck.Observer.int32
let quickcheck_shrinker = Base_quickcheck.Shrinker.int32
let gen_incl = Base_quickcheck.Generator.int32_inclusive
let gen_uniform_incl = Base_quickcheck.Generator.int32_uniform_inclusive
let gen_log_incl = Base_quickcheck.Generator.int32_log_inclusive
let gen_log_uniform_incl = Base_quickcheck.Generator.int32_log_uniform_inclusive
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
