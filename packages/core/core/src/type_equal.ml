let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"type_equal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "type_equal.ml.before-ppx"
;;

include Base.Type_equal

module Id = struct
  include Id

  module Uid = struct
    module Upstream = Base.Type_equal.Id.Uid
    include Base.Type_equal.Id.Uid

    include
      Comparable.Extend_plain
        (Upstream)
        (struct
          type t = Base.Type_equal.Id.Uid.t [@@deriving sexp_of]

          include struct
            let _ = fun (_ : t) -> ()
            let sexp_of_t = (Base.Type_equal.Id.Uid.sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)

    include Hashable.Make_plain (Upstream)
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
