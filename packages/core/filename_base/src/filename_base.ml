let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"filename_base.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "filename_base.ml.before-ppx"
;;

open! Base

include (
  String :
  sig
    type t = string [@@deriving compare, hash, sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Comparable.S
      with type t := t
      with type comparator_witness = String.comparator_witness

    val comparator : (t, comparator_witness) Comparator.t
  end)

include struct
  open Stdlib.Filename

  let check_suffix = check_suffix
  let chop_extension = chop_extension
  let chop_suffix = chop_suffix
  let chop_suffix_opt = chop_suffix_opt
  let current_dir_name = current_dir_name
  let is_implicit = is_implicit
  let is_relative = is_relative
  let parent_dir_name = parent_dir_name
  let dir_sep = dir_sep
  let quote = quote
  let temp_dir_name = get_temp_dir_name ()
  let dirname = dirname
  let basename = basename
end

let is_absolute p = not (is_relative p)

let concat p1 p2 =
  if String.is_empty p1
  then
    Printf.failwithf
      "Filename.concat called with an empty string as its first argument (second \
       argument: %s)"
      p2
      ();
  let rec collapse_trailing s =
    match String.rsplit2 s ~on:'/' with
    | Some ("", ("." | "")) -> ""
    | Some (s, ("." | "")) -> collapse_trailing s
    | None | Some _ -> s
  in
  let rec collapse_leading s =
    match String.lsplit2 s ~on:'/' with
    | Some (("." | ""), s) -> collapse_leading s
    | Some _ | None -> s
  in
  collapse_trailing p1 ^ "/" ^ collapse_leading p2
;;

let to_absolute_exn p ~relative_to =
  if is_relative relative_to
  then
    Printf.failwithf
      "Filename.to_absolute_exn called with a [relative_to] that is a relative path: %s"
      relative_to
      ()
  else if is_absolute p
  then p
  else concat relative_to p
;;

let split s = dirname s, basename s
let max_pathname_component_size = 255

let is_posix_pathname_component s =
  let module S = String in
  s <> "."
  && s <> ".."
  && (let open Int in
      0 < S.length s)
  && (let open Int in
      S.length s <= max_pathname_component_size)
  && (not (S.contains s '/'))
  && not (S.contains s '\000')
;;

let root = "/"

let split_extension fn =
  let dir, fn =
    match String.rsplit2 ~on:'/' fn with
    | None -> None, fn
    | Some (path, fn) -> Some path, fn
  in
  let fn, ext =
    match String.rsplit2 ~on:'.' fn with
    | None -> fn, None
    | Some (base_fn, ext) -> base_fn, Some ext
  in
  let fn =
    match dir with
    | None -> fn
    | Some dir -> dir ^ "/" ^ fn
  in
  fn, ext
;;

let parts filename =
  let rec loop acc filename =
    match split filename with
    | ("." as base), "." -> base :: acc
    | ("/" as base), "/" -> base :: acc
    | rest, dir -> loop (dir :: acc) rest
  in
  loop [] filename
;;

let of_parts = function
  | [] -> failwith "Filename.of_parts: empty parts list"
  | root :: rest -> List.fold rest ~init:root ~f:Stdlib.Filename.concat
;;

let rec skip_common_prefix l1 l2 =
  match l1, l2 with
  | h1 :: t1, h2 :: t2 when String.equal h1 h2 -> skip_common_prefix t1 t2
  | _ -> l1, l2
;;

let of_absolute_exn a ~relative_to:b =
  if is_relative a
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Filename.of_absolute_exn: first argument must be an absolute path"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "first_arg"
               ; (sexp_of_string [@merlin.hide]) a
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  if is_relative b
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Filename.of_absolute_exn: [~relative_to] must be an absolute path"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "relative_to"
               ; (sexp_of_string [@merlin.hide]) b
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  let a_parts = parts a in
  let b_parts = parts b in
  let a_suffix, b_suffix = skip_common_prefix a_parts b_parts in
  let go_up = List.map ~f:(fun _ -> parent_dir_name) b_suffix in
  match go_up @ a_suffix with
  | [] -> current_dir_name
  | relpath -> of_parts relpath
;;

let arg_type = `Use_Filename_unix
let create_arg_type = `Use_Filename_unix
let open_temp_file = `Use_Filename_unix
let open_temp_file_fd = `Use_Filename_unix
let realpath = `Use_Filename_unix
let temp_dir = `Use_Filename_unix
let temp_file = `Use_Filename_unix
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
