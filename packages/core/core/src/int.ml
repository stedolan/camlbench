let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"int.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "int.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    module T = struct
      include Base.Int

      type t = int [@@deriving hash, bin_io ~localize, sexp, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_int hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash_int in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "int.ml.before-ppx:8:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_int__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_int__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_int
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
        let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
  end
end

module Binable = struct
  type t = int [@@deriving bin_io ~localize]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int.ml.before-ppx:17:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_int__local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_int__local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_int
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
include Identifiable.Extend (Base.Int) (Binable)
module Replace_polymorphic_compare = Base.Int
include Base.Int
include Comparable.Validate_with_zero (Base.Int)

let sign = Sign.of_int

type t = int [@@deriving typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "int.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_int))
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

        let name = "int.ml.before-ppx.Binary.t"
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
          (Bin_prot.Shape.Location.of_string "int.ml.before-ppx:35:2")
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

        let name = "int.ml.before-ppx.Hex.t"
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
          (Bin_prot.Shape.Location.of_string "int.ml.before-ppx:41:2")
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

let quickcheck_generator = Base_quickcheck.Generator.int
let quickcheck_observer = Base_quickcheck.Observer.int
let quickcheck_shrinker = Base_quickcheck.Shrinker.int
let gen_incl = Base_quickcheck.Generator.int_inclusive
let gen_uniform_incl = Base_quickcheck.Generator.int_uniform_inclusive
let gen_log_incl = Base_quickcheck.Generator.int_log_inclusive
let gen_log_uniform_incl = Base_quickcheck.Generator.int_log_uniform_inclusive
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
