let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"diff_input.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "diff_input.ml.before-ppx"
;;

open! Core
open! Import

type t =
  { name : string
  ; text : string
  }
[@@deriving fields ~getters ~iterators:create]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()
  let text _r__ = _r__.text
  let _ = text
  let name _r__ = _r__.name
  let _ = name

  module Fields = struct
    let text =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "text"
         ; getter = text
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with text = v__ })
         }
       : ([< `Read | `Set_and_create ], _, string) Fieldslib.Field.t_with_perm)
    ;;

    let _ = text

    let name =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "name"
         ; getter = name
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with name = v__ })
         }
       : ([< `Read | `Set_and_create ], _, string) Fieldslib.Field.t_with_perm)
    ;;

    let _ = name
    let create ~name ~text = { name; text }
    let _ = create
  end
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
