let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"uchar.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "uchar.ml.before-ppx"
;;

module Stable = struct
  module V1 = struct
    module T = struct
      include (
        Base.Uchar :
        sig
          type t = Base.Uchar.t [@@deriving compare, equal, hash, sexp, sexp_grammar]

          include sig
            [@@@ocaml.warning "-32"]

            include Ppx_compare_lib.Comparable.S with type t := t
            include Ppx_compare_lib.Equal.S with type t := t
            include Ppx_hash_lib.Hashable.S with type t := t
            include Sexplib0.Sexpable.S with type t := t

            val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]

          include
            Base.Comparator.S
            with type t := t
             and type comparator_witness = Base.Uchar.comparator_witness
        end)

      let stable_witness : t Stable_witness.t = Stable_witness.assert_stable

      include
        Binable0.Stable.Of_binable.V2
          (Int)
          (struct
            type nonrec t = t

            let to_binable = Base.Uchar.to_scalar
            let of_binable = Base.Uchar.of_scalar_exn

            let caller_identity =
              Bin_prot.Shape.Uuid.of_string "324418b0-897e-11ee-a1ba-aaa233d0b6a7"
            ;;
          end)
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
    include Hashable.Stable.V1.With_stable_witness.Make (T)
  end
end

open! Import
include Stable.V1

include Hashable.Make_binable_with_hashable (struct
    module Key = Stable.V1

    let hashable = Key.hashable
  end)

include Comparable.Extend_binable (Base.Uchar) (Stable.V1)
include Base.Uchar

let quickcheck_generator =
  let open Base_quickcheck.Generator in
  let one_byte_utf8 = 0x0000, 0x007F in
  let two_bytes_utf8 = 0x0080, 0x07FF in
  let three_bytes_utf8_part1 = 0x0800, 0xD7FF in
  let three_bytes_utf8_part2 = 0xE000, 0xFFFF in
  let four_bytes_utf8 = 0x10000, 0x10FFFF in
  let range (start, until) = map (int_uniform_inclusive start until) ~f:of_scalar_exn in
  weighted_union
    [ 20., range one_byte_utf8
    ; 5., range two_bytes_utf8
    ; 5., range three_bytes_utf8_part1
    ; 5., range three_bytes_utf8_part2
    ; 10., range four_bytes_utf8
    ; 1., return min_value
    ; 1., return max_value
    ]
;;

let quickcheck_observer = Base_quickcheck.Observer.of_hash_fold hash_fold_t
let quickcheck_shrinker = Base_quickcheck.Shrinker.atomic
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
