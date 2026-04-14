let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"optional_diff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "optional_diff.ml.before-ppx"
;;

module Diff = struct
  type 'a t = { diff : 'a } [@@unboxed]
end

type 'a t = 'a Diff.t option

let none = None
let return diff = Some { Diff.diff } [@@inline]

let map t ~f =
  match t with
  | Some { Diff.diff } -> Some { Diff.diff = (f [@inlined hint]) diff }
  | None -> None
[@@inline]
;;

let bind t ~f =
  match t with
  | Some { Diff.diff } -> (f [@inlined hint]) diff
  | None -> None
[@@inline]
;;

let both = `both_would_allocate__use_bind_instead
let ( >>| ) x f = map x ~f [@@inline]
let ( >>= ) x f = bind x ~f [@@inline]

module Optional_syntax = struct
  module Optional_syntax = struct
    let is_none t =
      match t with
      | None -> true
      | Some _ -> false
    [@@inline]
    ;;

    let unsafe_value t =
      match t with
      | Some { Diff.diff } -> diff
      | None -> failwith "[Optional_diff.unsafe_value] called on [Optional_diff.none]"
    [@@inline]
    ;;
  end
end

include Optional_syntax.Optional_syntax

let to_option t =
  match t with
  | None -> None
  | Some { Diff.diff } -> Some diff
[@@inline]
;;

module Let_syntax = struct
  let return = return

  module Let_syntax = struct
    let return = return
    let map = map
    let bind = bind
    let both = both

    module Open_on_rhs = struct end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
