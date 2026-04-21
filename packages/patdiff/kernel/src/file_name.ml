let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"file_name.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "file_name.ml.before-ppx"
;;

open! Core
open! Import

type t =
  | Real of
      { real_name : string
      ; alt_name : string option
      }
  | Fake of string
[@@deriving compare, equal]

include struct
  let _ = fun (_ : t) -> ()

  let compare =
    (fun a__001_ b__002_ ->
       if Stdlib.( == ) a__001_ b__002_
       then 0
       else (
         match a__001_, b__002_ with
         | Real _a__003_, Real _b__004_ ->
           (match compare_string _a__003_.real_name _b__004_.real_name with
            | 0 ->
              compare_option
                (fun a__005_ (b__006_ [@merlin.hide]) ->
                   (compare_string a__005_ b__006_ [@merlin.hide]))
                _a__003_.alt_name
                _b__004_.alt_name
            | n -> n)
         | Real _, _ -> -1
         | _, Real _ -> 1
         | Fake _a__007_, Fake _b__008_ -> compare_string _a__007_ _b__008_)
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare

  let equal =
    (fun a__009_ b__010_ ->
       if Stdlib.( == ) a__009_ b__010_
       then true
       else (
         match a__009_, b__010_ with
         | Real _a__011_, Real _b__012_ ->
           Stdlib.( && )
             (equal_string _a__011_.real_name _b__012_.real_name)
             (equal_option
                (fun a__013_ (b__014_ [@merlin.hide]) ->
                   (equal_string a__013_ b__014_ [@merlin.hide]))
                _a__011_.alt_name
                _b__012_.alt_name)
         | Real _, _ -> false
         | _, Real _ -> false
         | Fake _a__015_, Fake _b__016_ -> equal_string _a__015_ _b__016_)
     : t -> (t[@merlin.hide]) -> bool)
  ;;

  let _ = equal
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let real_name_exn = function
  | Real { real_name; alt_name = _ } -> real_name
  | Fake _ ->
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Conv.sexp_of_string "File_name.real_name_exn got a fake file"
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let display_name = function
  | Real { real_name; alt_name } -> Option.value alt_name ~default:real_name
  | Fake name -> name
;;

let to_string_hum = display_name

let append t part =
  match t with
  | Real { real_name; alt_name } ->
    Real
      { real_name = Filename.concat real_name part
      ; alt_name = Option.map alt_name ~f:(fun name -> Filename.concat name part)
      }
  | Fake name -> Fake (Filename.concat name part)
;;

let dev_null = Real { real_name = "/dev/null"; alt_name = None }
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
