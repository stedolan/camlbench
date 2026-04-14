let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"bytes.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "bytes.ml.before-ppx"
;;

open! Import
open Base_quickcheck.Export

module Stable = struct
  module V1 = struct
    include Base.Bytes

    type t = bytes [@@deriving bin_io ~localize, quickcheck, typerep, stable_witness]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "bytes.ml.before-ppx:8:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_bytes ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_bytes__local
      let _ = bin_size_t__local
      let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t
      let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_bytes__local
      let _ = bin_write_t__local
      let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_bytes__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_bytes
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
      let quickcheck_generator = quickcheck_generator_bytes
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_bytes
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_bytes
      let _ = quickcheck_shrinker

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "bytes.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_bytes))
      ;;

      let _ = typerep_of_t

      let stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : bytes Ppx_stable_witness_runtime.Stable_witness.t =
          stable_witness_bytes
        in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

include Stable.V1
include Comparable.Validate (Base.Bytes)

include Hexdump.Of_indexable (struct
    type t = bytes

    let length = length
    let get = get
  end)

let gen' char_gen = Quickcheck.Generator.map ~f:of_string (String.gen' char_gen)

let gen_with_length len char_gen =
  Quickcheck.Generator.map ~f:of_string (String.gen_with_length len char_gen)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
