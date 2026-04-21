let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"enum.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "enum.ml.before-ppx"
;;

open! Base
include Enum_intf

let command_friendly_name s =
  String.filter_map s ~f:(function
    | '\'' -> None
    | '_' -> Some '-'
    | c -> Some (Char.lowercase c))
;;

let atom_of_sexp_exn : Sexp.t -> string = function
  | Atom s -> s
  | List _ as sexp ->
    raise_s
      (Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Enum.t expects atomic sexps."
         ; (Sexp.sexp_of_t [@merlin.hide]) sexp
         ])
;;

module Single = struct
  module type S = Sexp_of

  type 'a t = (module S with type t = 'a)

  let sexp_of (type a) ((module M) : a t) (a : a) = M.sexp_of_t a
  let atom_exn m a = atom_of_sexp_exn (sexp_of m a)
  let to_string_hum m a = command_friendly_name (atom_exn m a)

  let check_field_name t a field =
    (fun ?(here = []) ?message ?equal t1 t2 ->
       let pos = "enum.ml.before-ppx:26:15" in
       let sexpifier = (sexp_of_string [@merlin.hide]) in
       let comparator =
         (fun (a__001_ : string) ((b__002_ : string) [@merlin.hide]) ->
         (compare_string a__001_ b__002_ [@merlin.hide]))
         [@merlin.hide]
       in
       Ppx_assert_lib.Runtime.test_eq
         ~pos
         ~sexpifier
         ~comparator
         ~here
         ?message
         ?equal
         t1
         t2)
      (to_string_hum t a)
      (command_friendly_name (Field.name field))
  ;;
end

type 'a t = (module S with type t = 'a)

let to_string_hum (type a) ((module M) : a t) a = Single.to_string_hum (module M) a

let check_field_name (type a) ((module M) : a t) a field =
  Single.check_field_name (module M) a field
;;

let enum (type a) ((module M) : a t) =
  List.map M.all ~f:(fun a -> to_string_hum (module M) a, a)
;;

let assert_alphabetic_order_exn here (type a) ((module M) : a t) =
  let as_strings = List.map M.all ~f:(Single.atom_exn (module M)) in
  (fun ?(here = []) ?message ?equal ~expect got ->
     let pos = "enum.ml.before-ppx:44:17" in
     let sexpifier =
       (fun x__007_ -> sexp_of_list sexp_of_string x__007_) [@merlin.hide]
     in
     let comparator =
       (fun (a__003_ : string list) ((b__004_ : string list) [@merlin.hide]) ->
       (compare_list
          (fun a__005_ (b__006_ [@merlin.hide]) ->
             (compare_string a__005_ b__006_ [@merlin.hide]))
          a__003_
          b__004_ [@merlin.hide]))
       [@merlin.hide]
     in
     Ppx_assert_lib.Runtime.test_result
       ~pos
       ~sexpifier
       ~comparator
       ~here
       ?message
       ?equal
       ~expect
       ~got)
    ~here:[ here ]
    ~message:"This enumerable type is intended to be defined in alphabetic order"
    ~expect:(List.sort as_strings ~compare:String.compare)
    as_strings
;;

module Rewrite_sexp_of (S : S) : S with type t = S.t = struct
  include S

  let sexp_of_t t = Parsexp.Single.parse_string_exn (to_string_hum (module S) t)
end

let arg_type
      (type t)
      ?case_sensitive
      ?key
      ?list_values_in_help
      ((module S) : (module S with type t = t))
  =
  Command.Arg_type.enumerated_sexpable
    ?key
    ?list_values_in_help
    ?case_sensitive
    (module Rewrite_sexp_of (S))
;;

module Make_param = struct
  type 'a t =
    { arg_type : 'a Command.Arg_type.t
    ; doc : string
    }

  let create ?case_sensitive ?key ?represent_choice_with ?list_values_in_help ~doc m =
    let doc =
      match represent_choice_with with
      | None -> " " ^ doc
      | Some represent_choice_with -> represent_choice_with ^ " " ^ doc
    in
    { arg_type = arg_type ?case_sensitive ?key ?list_values_in_help m; doc }
  ;;
end

type ('a, 'b) make_param =
  ?case_sensitive:bool
  -> ?represent_choice_with:string
  -> ?list_values_in_help:bool
  -> ?aliases:string list
  -> ?key:'a Univ_map.Multi.Key.t
  -> string
  -> doc:string
  -> 'a t
  -> 'b Command.Param.t

let make_param
      ~f
      ?case_sensitive
      ?represent_choice_with
      ?list_values_in_help
      ?aliases
      ?key
      flag_name
      ~doc
      m
  =
  let { Make_param.arg_type; doc } =
    Make_param.create
      ?case_sensitive
      ?key
      ?represent_choice_with
      ?list_values_in_help
      ~doc
      m
  in
  Command.Param.flag ?aliases flag_name ~doc (f arg_type)
;;

let make_param_optional_with_default_doc
      (type a)
      ~default
      ?case_sensitive
      ?represent_choice_with
      ?list_values_in_help
      ?aliases
      ?key
      flag_name
      ~doc
      (m : a t)
  =
  let { Make_param.arg_type; doc } =
    Make_param.create
      ?case_sensitive
      ?key
      ?represent_choice_with
      ?list_values_in_help
      ~doc
      m
  in
  Command.Param.flag_optional_with_default_doc
    ?aliases
    flag_name
    arg_type
    (fun default -> Sexp.Atom (to_string_hum m default))
    ~default
    ~doc
;;

let make_param_one_of_flags
      ?(if_nothing_chosen = Command.Param.If_nothing_chosen.Raise)
      ?aliases
      ~doc
      m
  =
  Command.Param.choose_one
    ~if_nothing_chosen
    (List.map (enum m) ~f:(fun (name, enum) ->
       let aliases = Option.map aliases ~f:(fun aliases -> aliases enum) in
       let doc = doc enum in
       Command.Param.flag ?aliases name (Command.Param.no_arg_some enum) ~doc))
;;

let comma_separated_extra_doc m =
  let options =
    String.concat
      ~sep:", "
      (List.sort
         ~compare:(fun (a__008_ : string) ((b__009_ : string) [@merlin.hide]) ->
           (compare_string a__008_ b__009_ [@merlin.hide]))
         (List.map ~f:fst (enum m)))
  in
  (Ppx_string_runtime.For_string.concat
     [ Ppx_string_runtime.For_string.of_string "(can be comma-separated values: "
     ; options
     ; Ppx_string_runtime.For_string.of_string ")"
     ] [@merlin.hide])
;;

let make_param_optional_comma_separated
      ?allow_empty
      ?strip_whitespace
      ?unique_values
      ?case_sensitive
      ?represent_choice_with
      ?list_values_in_help
      ?aliases
      ?key
      flag_name
      ~doc
      m
  =
  make_param
    ?case_sensitive
    ?represent_choice_with
    ?list_values_in_help
    ?aliases
    ?key
    flag_name
    m
    ~f:
      (Fn.compose
         Command.Param.optional
         (Command.Arg_type.comma_separated ?allow_empty ?strip_whitespace ?unique_values))
    ~doc:
      (Ppx_string_runtime.For_string.concat
         [ doc; Ppx_string_runtime.For_string.of_string " "; comma_separated_extra_doc m ]
       [@merlin.hide])
;;

let make_param_optional_comma_separated_with_default_doc
      ?allow_empty
      ?strip_whitespace
      ?unique_values
      (type a)
      ~default
      ?case_sensitive
      ?represent_choice_with
      ?list_values_in_help
      ?aliases
      ?key
      flag_name
      ~doc
      (m : a t)
  =
  let { Make_param.arg_type; doc } =
    Make_param.create
      ?case_sensitive
      ?represent_choice_with
      ?list_values_in_help
      ?key
      ~doc:
        (Ppx_string_runtime.For_string.concat
           [ doc
           ; Ppx_string_runtime.For_string.of_string " "
           ; comma_separated_extra_doc m
           ] [@merlin.hide])
      m
  in
  Command.Param.flag_optional_with_default_doc
    ?aliases
    flag_name
    (Command.Arg_type.comma_separated
       ?allow_empty
       ?strip_whitespace
       ?unique_values
       arg_type)
    (fun default ->
       Sexp.Atom (String.concat ~sep:"," (List.map ~f:(to_string_hum m) default)))
    ~default
    ~doc
;;

module Make_to_string (M : Sexp_of) : sig
  val to_string : M.t -> string
end = struct
  let to_string t =
    command_friendly_name (atom_of_sexp_exn ((M.sexp_of_t [@merlin.hide]) t))
  ;;
end

module Make_of_string (M : S_to_string) : sig
  val of_string : String.t -> M.t
end = struct
  let known_values =
    lazy
      (List.fold
         M.all
         ~init:(Map.empty (module String))
         ~f:(fun map t -> Map.set map ~key:(M.to_string t) ~data:t))
  ;;

  let of_string s =
    match Map.find (force known_values) s with
    | None ->
      let known_values = Map.keys (force known_values) in
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unknown value."
             ; Ppx_sexp_conv_lib.Conv.sexp_of_string s
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "known_values"
                 ; ((fun x__010_ -> sexp_of_list sexp_of_string x__010_) [@merlin.hide])
                     known_values
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | Some t -> t
  ;;
end

module Make_stringable (M : S) : Stringable.S with type t := M.t = struct
  include Make_to_string (M)

  include Make_of_string (struct
      type t = M.t

      let all = M.all
      let to_string = to_string
    end)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
