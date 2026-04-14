let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"tuple_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "tuple_helpers.ml.before-ppx"
;;

open! Base
open Printf

let module_name ~size = sprintf "Tuple%i" size
let diff_module_name = "Diff"
let entry_diff_module_name = "Entry_diff"
let for_inlined_tuple_module_name = "For_inlined_tuple"
let nums ~size = List.init size ~f:(( + ) 1)
let var i = sprintf "'a%i" i
let diff_var i = var i ^ "_diff"
let create_arg i = sprintf "t%i" i
let gel i = sprintf "%s Gel.t" (var i)
let vars ~size = List.map (nums ~size) ~f:var
let diff_vars ~size = vars ~size @ List.map (nums ~size) ~f:diff_var

let type_ ~name ~vars ~size =
  sprintf "(%s) %s" (String.concat (vars ~size) ~sep:", ") name
;;

let t_type = type_ ~name:"t" ~vars
let derived_on_type = type_ ~name:"derived_on" ~vars

let entry_diff_type =
  type_
    ~name:
      (Ppx_string_runtime.For_string.concat
         [ entry_diff_module_name; Ppx_string_runtime.For_string.of_string ".t" ]
       [@merlin.hide])
    ~vars:diff_vars
;;

let diff_type = type_ ~name:"t" ~vars:diff_vars
let diff_type_reference = type_ ~name:(sprintf "%s.t" diff_module_name) ~vars:diff_vars
let variant_name = sprintf "T%i"

let type_declaration ~size =
  let tuple = String.concat (vars ~size) ~sep:" * " in
  (Ppx_string_runtime.For_string.concat
     [ Ppx_string_runtime.For_string.of_string "type "
     ; t_type ~size
     ; Ppx_string_runtime.For_string.of_string " = "
     ; tuple
     ; Ppx_string_runtime.For_string.of_string " [@@deriving sexp, bin_io]"
     ] [@merlin.hide])
;;

let diff_type_declarations ~size ~signature =
  let maybe_private = if signature then " private" else "" in
  let variants ~size =
    String.concat
      ~sep:"\n"
      (List.map (nums ~size) ~f:(fun i ->
         sprintf "| %s of %s" (variant_name i) (diff_var i)))
  in
  let maybe_open_entry_diff =
    if signature
    then ""
    else
      Ppx_string_runtime.For_string.concat
        [ Ppx_string_runtime.For_string.of_string "open "; entry_diff_module_name ]
      [@merlin.hide]
  in
  (Ppx_string_runtime.For_string.concat
     [ Ppx_string_runtime.For_string.of_string "\n      type "
     ; derived_on_type ~size
     ; Ppx_string_runtime.For_string.of_string " = "
     ; t_type ~size
     ; Ppx_string_runtime.For_string.of_string "\n\n      module "
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string " "
     ; (if signature then ": sig" else "= struct")
     ; Ppx_string_runtime.For_string.of_string "\n        type "
     ; diff_type ~size
     ; Ppx_string_runtime.For_string.of_string " =\n          "
     ; variants ~size
     ; Ppx_string_runtime.For_string.of_string
         "\n        [@@deriving variants, sexp, bin_io, quickcheck]\n      end\n      "
     ; maybe_open_entry_diff
     ; Ppx_string_runtime.For_string.of_string "\n\n      type "
     ; diff_type ~size
     ; Ppx_string_runtime.For_string.of_string " ="
     ; maybe_private
     ; Ppx_string_runtime.For_string.of_string " "
     ; entry_diff_type ~size
     ; Ppx_string_runtime.For_string.of_string
         " list [@@deriving sexp, bin_io, quickcheck]\n\n"
     ] [@merlin.hide])
;;

let for_inlined_tuple_type_declaration ~size =
  Ppx_string_runtime.For_string.concat
    [ Ppx_string_runtime.For_string.of_string " type "
    ; t_type ~size
    ; Ppx_string_runtime.For_string.of_string " = "
    ; String.concat ~sep:" * " (List.map (nums ~size) ~f:gel)
    ; Ppx_string_runtime.For_string.of_string " [@@deriving sexp, bin_io]"
    ] [@merlin.hide]
;;

let for_inlined_tuple_diff_type_declarations ~size =
  Ppx_string_runtime.For_string.concat
    [ Ppx_string_runtime.For_string.of_string "\n      type "
    ; derived_on_type ~size
    ; Ppx_string_runtime.For_string.of_string " = "
    ; t_type ~size
    ; Ppx_string_runtime.For_string.of_string "\n\n      type "
    ; diff_type ~size
    ; Ppx_string_runtime.For_string.of_string " = "
    ; diff_type_reference ~size
    ; Ppx_string_runtime.For_string.of_string " [@@deriving sexp, bin_io, quickcheck]\n  "
    ] [@merlin.hide]
;;

let tuple_mli size =
  let nums = nums ~size in
  let derived_on_type = derived_on_type ~size in
  let diff_type = diff_type ~size in
  let get_functions =
    String.concat
      ~sep:"\n -> "
      (List.map nums ~f:(fun i ->
         (Ppx_string_runtime.For_string.concat
            [ Ppx_string_runtime.For_string.of_string "(from: "
            ; var i
            ; Ppx_string_runtime.For_string.of_string " -> to_: "
            ; var i
            ; Ppx_string_runtime.For_string.of_string " -> local_ "
            ; diff_var i
            ; Ppx_string_runtime.For_string.of_string " Optional_diff.t)"
            ] [@merlin.hide])))
  in
  let apply_functions' =
    List.map nums ~f:(fun i ->
      (Ppx_string_runtime.For_string.concat
         [ Ppx_string_runtime.For_string.of_string "("
         ; var i
         ; Ppx_string_runtime.For_string.of_string " -> "
         ; diff_var i
         ; Ppx_string_runtime.For_string.of_string " -> "
         ; var i
         ; Ppx_string_runtime.For_string.of_string ")"
         ] [@merlin.hide]))
  in
  let apply_functions = String.concat ~sep:"\n -> " apply_functions' in
  let of_list_functions' =
    List.map nums ~f:(fun i ->
      (Ppx_string_runtime.For_string.concat
         [ Ppx_string_runtime.For_string.of_string "("
         ; diff_var i
         ; Ppx_string_runtime.For_string.of_string " list -> local_ "
         ; diff_var i
         ; Ppx_string_runtime.For_string.of_string " Optional_diff.t)"
         ] [@merlin.hide]))
  in
  let of_list_and_apply_functions =
    String.concat
      ~sep:"\n -> "
      (List.concat_map
         ~f:(fun (x, y) -> [ x; y ])
         (List.zip_exn of_list_functions' apply_functions'))
  in
  let function_declarations ~local =
    let derived_on_type =
      if local then sprintf "local_ %s" derived_on_type else derived_on_type
    in
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "\n        val get : "
       ; get_functions
       ; Ppx_string_runtime.For_string.of_string " -> from: "
       ; derived_on_type
       ; Ppx_string_runtime.For_string.of_string " -> to_: "
       ; derived_on_type
       ; Ppx_string_runtime.For_string.of_string " -> local_ "
       ; diff_type
       ; Ppx_string_runtime.For_string.of_string
           " Optional_diff.t\n\n        val apply_exn : "
       ; apply_functions
       ; Ppx_string_runtime.For_string.of_string " -> "
       ; derived_on_type
       ; Ppx_string_runtime.For_string.of_string " -> "
       ; diff_type
       ; Ppx_string_runtime.For_string.of_string " -> "
       ; derived_on_type
       ; Ppx_string_runtime.For_string.of_string "\n\n        val of_list_exn : "
       ; of_list_and_apply_functions
       ; Ppx_string_runtime.For_string.of_string " -> "
       ; diff_type
       ; Ppx_string_runtime.For_string.of_string " list -> local_ "
       ; diff_type
       ; Ppx_string_runtime.For_string.of_string " Optional_diff.t\n         "
       ] [@merlin.hide])
  in
  let create_args ~optional =
    String.concat
      ~sep:" -> "
      (List.map nums ~f:(fun i ->
         if optional
         then
           Ppx_string_runtime.For_string.concat
             [ Ppx_string_runtime.For_string.of_string "?"
             ; create_arg i
             ; Ppx_string_runtime.For_string.of_string ":"
             ; diff_var i
             ] [@merlin.hide]
         else
           Ppx_string_runtime.For_string.concat
             [ create_arg i
             ; Ppx_string_runtime.For_string.of_string ":"
             ; diff_var i
             ; Ppx_string_runtime.For_string.of_string " option"
             ] [@merlin.hide]))
  in
  let create_of_variants_args =
    String.concat
      ~sep:" -> "
      (List.map nums ~f:(fun i ->
         (Ppx_string_runtime.For_string.concat
            [ create_arg i
            ; Ppx_string_runtime.For_string.of_string ":local_ (("
            ; diff_var i
            ; Ppx_string_runtime.For_string.of_string ", "
            ; entry_diff_type ~size
            ; Ppx_string_runtime.For_string.of_string ") Of_variant.t) "
            ] [@merlin.hide])))
  in
  (Ppx_string_runtime.For_string.concat
     [ Ppx_string_runtime.For_string.of_string "\n    module "
     ; module_name ~size
     ; Ppx_string_runtime.For_string.of_string " : sig\n      "
     ; type_declaration ~size
     ; Ppx_string_runtime.For_string.of_string "\n      module "
     ; diff_module_name
     ; Ppx_string_runtime.For_string.of_string " : sig\n        "
     ; diff_type_declarations ~size ~signature:true
     ; Ppx_string_runtime.For_string.of_string "\n\n        "
     ; function_declarations ~local:false
     ; Ppx_string_runtime.For_string.of_string "\n\n        val singleton : "
     ; entry_diff_type ~size
     ; Ppx_string_runtime.For_string.of_string " -> "
     ; diff_type
     ; Ppx_string_runtime.For_string.of_string "\n\n        val create : "
     ; create_args ~optional:true
     ; Ppx_string_runtime.For_string.of_string " -> unit -> "
     ; diff_type
     ; Ppx_string_runtime.For_string.of_string "\n\n        val create_of_variants : "
     ; create_of_variants_args
     ; Ppx_string_runtime.For_string.of_string " -> "
     ; diff_type
     ; Ppx_string_runtime.For_string.of_string "\n      end\n\n      module "
     ; for_inlined_tuple_module_name
     ; Ppx_string_runtime.For_string.of_string " : sig\n        "
     ; for_inlined_tuple_type_declaration ~size
     ; Ppx_string_runtime.For_string.of_string "\n\n        module "
     ; diff_module_name
     ; Ppx_string_runtime.For_string.of_string " : sig\n          "
     ; for_inlined_tuple_diff_type_declarations ~size
     ; Ppx_string_runtime.For_string.of_string "\n          "
     ; function_declarations ~local:true
     ; Ppx_string_runtime.For_string.of_string
         "\n        end\n      end\n    end\n       "
     ] [@merlin.hide])
;;

let tuple_ml size =
  let nums = nums ~size in
  let get = sprintf "get%i" in
  let apply = sprintf "apply%i_exn" in
  let of_list = sprintf "of_list%i_exn" in
  let maybe_gel s i ~gel =
    let base = sprintf "%s%i" s i in
    if not gel then base else sprintf "{Gel.g = %s}" base
  in
  let from = maybe_gel "from_" in
  let to_ = maybe_gel "to_" in
  let derived_on = maybe_gel "derived_on" in
  let t = maybe_gel "t" in
  let apply_diff n =
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string " let "
       ; t n ~gel:false
       ; Ppx_string_runtime.For_string.of_string
           ", diff =\n           match diff with\n          | "
       ; variant_name n
       ; Ppx_string_runtime.For_string.of_string " d :: tl -> "
       ; apply n
       ; Ppx_string_runtime.For_string.of_string " "
       ; derived_on n ~gel:false
       ; Ppx_string_runtime.For_string.of_string " d, tl\n          | _ -> "
       ; derived_on n ~gel:false
       ; Ppx_string_runtime.For_string.of_string ", diff\n         in\n         "
       ] [@merlin.hide])
  in
  let get_diff n =
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string
           " let diff =\n            match%optional.Optional_diff "
       ; get n
       ; Ppx_string_runtime.For_string.of_string " ~from:"
       ; from n ~gel:false
       ; Ppx_string_runtime.For_string.of_string " ~to_:"
       ; to_ n ~gel:false
       ; Ppx_string_runtime.For_string.of_string
           " with\n            | None -> diff\n            | Some d -> "
       ; variant_name n
       ; Ppx_string_runtime.For_string.of_string " d :: diff\n          in\n       "
       ] [@merlin.hide])
  in
  let of_sexp_functions =
    String.concat
      ~sep:" "
      (List.map nums ~f:(sprintf "a%i_of_sexp")
       @ List.map nums ~f:(sprintf "a%i_diff_of_sexp"))
  in
  let create_args ~optional =
    String.concat
      ~sep:" "
      (List.map nums ~f:(fun i ->
         (Ppx_string_runtime.For_string.concat
            [ (if optional then "?" else "~"); create_arg i ] [@merlin.hide])))
  in
  let create_function ~value option_or_optional_diff =
    let maybe_add_diff i =
      let maybe_add i =
        match option_or_optional_diff with
        | `option ->
          Ppx_string_runtime.For_string.concat
            [ Ppx_string_runtime.For_string.of_string " match "
            ; value i
            ; Ppx_string_runtime.For_string.of_string
                " with\n               | None -> diff\n               | Some d -> "
            ; variant_name i
            ; Ppx_string_runtime.For_string.of_string " d :: diff\n           "
            ] [@merlin.hide]
        | `optional_diff ->
          Ppx_string_runtime.For_string.concat
            [ Ppx_string_runtime.For_string.of_string " match%optional.Optional_diff "
            ; value i
            ; Ppx_string_runtime.For_string.of_string
                " with\n               | None -> diff\n               | Some d -> "
            ; variant_name i
            ; Ppx_string_runtime.For_string.of_string " d :: diff\n            "
            ] [@merlin.hide]
      in
      (Ppx_string_runtime.For_string.concat
         [ Ppx_string_runtime.For_string.of_string "let diff =\n            "
         ; maybe_add i
         ; Ppx_string_runtime.For_string.of_string "\n          in\n        "
         ] [@merlin.hide])
    in
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "let diff = [] in\n      "
       ; String.concat ~sep:"\n" (List.rev_map nums ~f:maybe_add_diff)
       ; Ppx_string_runtime.For_string.of_string "\n      diff"
       ] [@merlin.hide])
  in
  let diff_of_list i =
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "\n      | "
       ; variant_name i
       ; Ppx_string_runtime.For_string.of_string
           " d :: tl ->\n\
           \        let ds, tl = List.split_while tl ~f:(function\n\
           \          | "
       ; variant_name i
       ; Ppx_string_runtime.For_string.of_string
           " _ -> true\n\
           \          | _ -> false)\n\
           \        in\n\
           \        let ds = List.map ds ~f:(function\n\
           \          | "
       ; variant_name i
       ; Ppx_string_runtime.For_string.of_string
           " x -> x\n\
           \          | _ -> assert false)\n\
           \        in\n\
           \        (match%optional.Optional_diff "
       ; of_list i
       ; Ppx_string_runtime.For_string.of_string
           " (d :: ds) with\n         | None -> loop acc tl\n         | Some d -> loop ("
       ; variant_name i
       ; Ppx_string_runtime.For_string.of_string " d :: acc) tl)\n         "
       ] [@merlin.hide])
  in
  let function_implementations ~local =
    let maybe_local = if local then "local_ " else "" in
    let gel = local in
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "\n        let get "
       ; String.concat ~sep:" " (List.map nums ~f:get)
       ; Ppx_string_runtime.For_string.of_string
           " ~from ~to_ =\n\
           \          if Base.phys_equal from to_\n\
           \          then local_ Optional_diff.none\n\
           \          else (\n\
           \            let "
       ; String.concat ~sep:", " (List.map nums ~f:(from ~gel))
       ; Ppx_string_runtime.For_string.of_string " = from in\n            let "
       ; String.concat ~sep:", " (List.map nums ~f:(to_ ~gel))
       ; Ppx_string_runtime.For_string.of_string
           " = to_ in\n            let diff = [] in\n            "
       ; String.concat ~sep:"" (List.rev_map nums ~f:get_diff)
       ; Ppx_string_runtime.For_string.of_string
           "\n\
           \            match diff with\n\
           \            | [] -> local_ Optional_diff.none\n\
           \            | _ :: _ -> local_ Optional_diff.return diff)\n\n\n\
           \        let apply_exn "
       ; String.concat ~sep:" " (List.map nums ~f:apply)
       ; Ppx_string_runtime.For_string.of_string " derived_on diff =\n          let "
       ; String.concat ~sep:", " (List.map nums ~f:(derived_on ~gel))
       ; Ppx_string_runtime.For_string.of_string " = derived_on in\n          "
       ; String.concat ~sep:"" (List.map nums ~f:apply_diff)
       ; Ppx_string_runtime.For_string.of_string
           "\n          match diff with\n          | [] -> "
       ; maybe_local
       ; String.concat ~sep:"," (List.map nums ~f:(t ~gel))
       ; Ppx_string_runtime.For_string.of_string "\n          | _ :: _ -> "
       ; maybe_local
       ; Ppx_string_runtime.For_string.of_string
           "failwith \"BUG: non-empty diff after apply\"\n        "
       ] [@merlin.hide])
  in
  let of_list_and_apply_functions =
    String.concat
      ~sep:" "
      (List.concat_map nums ~f:(fun x -> [ of_list x; sprintf "_%s" (apply x) ]))
  in
  let of_list_function =
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "\n      let of_list_exn "
       ; of_list_and_apply_functions
       ; Ppx_string_runtime.For_string.of_string
           " ts =\n\
           \        match ts with\n\
           \        | [] -> local_ Optional_diff.none\n\
           \        | _ :: _ ->\n\
           \          match List.concat ts |> List.stable_sort ~compare:compare_rank with\n\
           \          | [] -> local_ Optional_diff.return []\n\
           \          | _ :: _ as diff ->\n\
           \            let rec loop acc = function\n\
           \              | [] -> List.rev acc\n\
           \               "
       ; String.concat ~sep:"\n" (List.map nums ~f:diff_of_list)
       ; Ppx_string_runtime.For_string.of_string
           "\n\
           \            in\n\
           \            local_ Optional_diff.return (loop [] diff)\n\
           \         "
       ] [@merlin.hide])
  in
  let create_arg_of_variant i =
    (Ppx_string_runtime.For_string.concat
       [ Ppx_string_runtime.For_string.of_string "("
       ; create_arg i
       ; Ppx_string_runtime.For_string.of_string " "
       ; entry_diff_module_name
       ; Ppx_string_runtime.For_string.of_string ".Variants."
       ; create_arg i
       ; Ppx_string_runtime.For_string.of_string ")"
       ] [@merlin.hide])
  in
  (Ppx_string_runtime.For_string.concat
     [ Ppx_string_runtime.For_string.of_string "\n    module "
     ; module_name ~size
     ; Ppx_string_runtime.For_string.of_string " = struct\n      "
     ; type_declaration ~size
     ; Ppx_string_runtime.For_string.of_string "\n      module "
     ; diff_module_name
     ; Ppx_string_runtime.For_string.of_string " = struct\n        "
     ; diff_type_declarations ~size ~signature:false
     ; Ppx_string_runtime.For_string.of_string
         "\n\n        let compare_rank t1 t2 =\n          Int.compare ("
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string ".Variants.to_rank t1) ("
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string
         ".Variants.to_rank t2)\n\
         \        ;;\n\n\
         \        let equal_rank t1 t2 =\n\
         \          Int.equal ("
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string ".Variants.to_rank t1) ("
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string
         ".Variants.to_rank t2)\n        ;;\n\n        "
     ; function_implementations ~local:false
     ; Ppx_string_runtime.For_string.of_string "\n\n        "
     ; of_list_function
     ; Ppx_string_runtime.For_string.of_string
         "\n\n        let singleton entry_diff = [entry_diff]\n\n        let t_of_sexp "
     ; of_sexp_functions
     ; Ppx_string_runtime.For_string.of_string " sexp =\n          let l = t_of_sexp "
     ; of_sexp_functions
     ; Ppx_string_runtime.For_string.of_string
         " sexp |> List.sort ~compare:compare_rank in\n\
         \          match List.find_consecutive_duplicate l ~equal:equal_rank with\n\
         \          | None -> l\n\
         \          | Some (dup, _) ->\n\
         \           failwith (\"Duplicate entry in tuple diff: \" ^ "
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string
         ".Variants.to_name dup)\n\n        let create "
     ; create_args ~optional:true
     ; Ppx_string_runtime.For_string.of_string " () =\n          "
     ; create_function ~value:create_arg `option
     ; Ppx_string_runtime.For_string.of_string "\n\n        let create_of_variants "
     ; create_args ~optional:false
     ; Ppx_string_runtime.For_string.of_string " =\n           "
     ; create_function ~value:create_arg_of_variant `optional_diff
     ; Ppx_string_runtime.For_string.of_string "\n      end\n\n      module "
     ; for_inlined_tuple_module_name
     ; Ppx_string_runtime.For_string.of_string " = struct\n        "
     ; for_inlined_tuple_type_declaration ~size
     ; Ppx_string_runtime.For_string.of_string "\n\n        module "
     ; diff_module_name
     ; Ppx_string_runtime.For_string.of_string " = struct\n          "
     ; for_inlined_tuple_diff_type_declarations ~size
     ; Ppx_string_runtime.For_string.of_string "\n          open "
     ; diff_module_name
     ; Ppx_string_runtime.For_string.of_string "\n          open "
     ; entry_diff_module_name
     ; Ppx_string_runtime.For_string.of_string "\n          "
     ; function_implementations ~local:true
     ; Ppx_string_runtime.For_string.of_string
         "\n\n\
         \          let of_list_exn = of_list_exn\n\
         \        end\n\
         \      end\n\
         \    end\n\
         \       "
     ] [@merlin.hide])
;;

let max_supported =
  ( 6
  , { Ppx_here_lib.pos_fname = "tuple_helpers.ml.before-ppx"
    ; pos_lnum = 334
    ; pos_cnum = 11220
    ; pos_bol = 11197
    } )
;;

let l = List.range ~start:`inclusive ~stop:`inclusive 2 (fst max_supported)
let tuples_mli () = String.concat ~sep:"\n\n" (List.map l ~f:tuple_mli)
let tuples_ml () = String.concat ~sep:"\n\n" (List.map l ~f:tuple_ml)
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
