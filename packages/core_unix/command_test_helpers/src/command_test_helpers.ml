let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"command_test_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "command_test_helpers.ml.before-ppx"
;;

open! Core
open! Import
module Unix = Core_unix

let default_command_name = "CMD"

let parse_command_line_raw ~path ~summary ?readme param args =
  let name, path =
    match path with
    | None | Some [] -> default_command_name, []
    | Some (hd :: tl) -> hd, tl
  in
  let argv = (name :: path) @ args in
  let value = ref None in
  let command =
    List.fold_right
      path
      ~f:(fun subcommand acc -> Command.group ~summary:"" [ subcommand, acc ])
      ~init:
        (Command.basic
           ~summary
           ?readme
           (Command.Let_syntax.Let_syntax.map
              (let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
               param)
              ~f:(fun x () -> value := Some x)))
  in
  Command_unix.run ~argv command;
  match !value with
  | None -> Error `Aborted_command_line_parsing__exit_code_already_printed
  | Some x -> Ok x
;;

let parse_command_line ?path ?(summary = default_command_name ^ " SUMMARY") ?readme param =
  stage (fun ?(on_error = ignore) ?(on_success = ignore) args ->
    let result = parse_command_line_raw ~path ~summary ?readme param args in
    match result with
    | Error `Aborted_command_line_parsing__exit_code_already_printed -> on_error ()
    | Ok x -> on_success x)
;;

let parse_command_line_or_error
      ?path
      ?(summary = default_command_name ^ " SUMMARY")
      ?readme
      param
  =
  stage (fun args ->
    match parse_command_line_raw ~path ~summary ?readme param args with
    | Error `Aborted_command_line_parsing__exit_code_already_printed ->
      Or_error.error_string
        "Aborted command line parsing -- exit code has already been printed."
    | Ok param -> Ok param)
;;

let cannot_validate_exec_error (exec_info : Command.Shape.Exec_info.t) =
  let s =
    "[Exec _] commands are not validated to avoid unexpected external dependencies."
  in
  let exec_info = { exec_info with working_dir = "ELIDED-IN-TEST" } in
  error_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string s
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "exec_info"
             ; (Command.Shape.Exec_info.sexp_of_t [@merlin.hide]) exec_info
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
;;

module Validate_command_line = struct
  let unit_anon = Command.Anons.map_anons ~f:ignore

  let filter_map_or_error_option xs ~f =
    Or_error.map ~f:List.filter_opt (Or_error.combine_errors (List.map xs ~f))
  ;;

  let rec of_nested_anon : Command.Shape.Anons.Grammar.t -> _ = function
    | Ad_hoc s ->
      error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unable to check [Ad_hoc _] grammar."
             ; Ppx_sexp_conv_lib.Conv.sexp_of_string s
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | Zero -> Ok None
    | One s -> Ok (Some (Command.Anons.( %: ) s (Command.Arg_type.create ignore)))
    | Many g ->
      Or_error.Let_syntax.Let_syntax.bind (of_nested_anon g) ~f:(fun anon ->
        Ok (Option.map anon ~f:(Command.Anons.sequence >> unit_anon)))
    | Maybe g ->
      Or_error.Let_syntax.Let_syntax.bind (of_nested_anon g) ~f:(fun anon ->
        Ok (Option.map anon ~f:(Command.Anons.maybe >> unit_anon)))
    | Concat gs ->
      Or_error.Let_syntax.Let_syntax.bind
        (filter_map_or_error_option gs ~f:of_nested_anon)
        ~f:(fun anons ->
          Ok (List.reduce anons ~f:(fun a b -> unit_anon (Command.Anons.t2 a b))))
  ;;

  let require_grammar : Command.Shape.Anons.t -> _ = function
    | Usage s ->
      error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unable to check [Usage _]."
             ; Ppx_sexp_conv_lib.Conv.sexp_of_string s
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | Grammar grammar -> Ok grammar
  ;;

  let param_of_anons anons =
    Or_error.Let_syntax.Let_syntax.bind (require_grammar anons) ~f:(fun grammar ->
      Or_error.Let_syntax.Let_syntax.bind (of_nested_anon grammar) ~f:(fun anon ->
        match anon with
        | None -> Ok (Command.Param.return ())
        | Some anon -> Ok (Command.Param.anon anon)))
  ;;

  let param_of_user_flag flag_info ~flag_name =
    let __let_syntax__007_ = Command.Shape.Flag_info.num_occurrences flag_info
    [@@ppxlib.do_not_enter_value]
    and __let_syntax__008_ =
      Command.Shape.Flag_info.requires_arg flag_info
        [@@ppxlib.do_not_enter_value]
    in
    Or_error.Let_syntax.Let_syntax.bind
      (Or_error.Let_syntax.Let_syntax.both __let_syntax__007_ __let_syntax__008_)
      ~f:(fun (num_occurrences, requires_arg) ->
        let ({ aliases; doc; _ } : Command.Shape.Flag_info.t) = flag_info in
        Or_error.Let_syntax.Let_syntax.bind
          (let unit_flag = Command.Param.map_flag ~f:ignore in
           let make_flag f = Ok (unit_flag (f Command.Param.string)) in
           match requires_arg, num_occurrences with
           | true, { at_least_once = true; at_most_once = true } ->
             make_flag Command.Flag.required
           | true, { at_least_once = true; at_most_once = false } ->
             make_flag Command.Flag.one_or_more_as_pair
           | true, { at_least_once = false; at_most_once = false } ->
             make_flag Command.Flag.listed
           | true, { at_least_once = false; at_most_once = true } ->
             make_flag Command.Flag.optional
           | false, { at_least_once = false; at_most_once = true } ->
             Ok (unit_flag Command.Flag.no_arg)
           | false, _ ->
             error_s
               (let ppx_sexp_message () =
                  Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Unexpected combination."
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "requires_arg"
                        ; (sexp_of_bool [@merlin.hide]) requires_arg
                        ]
                    ; Ppx_sexp_conv_lib.Sexp.List
                        [ Ppx_sexp_conv_lib.Sexp.Atom "num_occurrences"
                        ; (Command.Shape.Num_occurrences.sexp_of_t [@merlin.hide])
                            num_occurrences
                        ]
                    ]
                    [@@ocaml.inline never]
                    [@@ocaml.local never]
                    [@@ocaml.specialise never]
                in
                (ppx_sexp_message () [@nontail])))
          ~f:(fun flag -> Ok (Command.Param.flag flag_name flag ~aliases ~doc)))
  ;;

  let param_of_flag flag_info =
    Or_error.Let_syntax.Let_syntax.bind
      (Command.Shape.Flag_info.flag_name flag_info)
      ~f:(function
      | "-help" | "-version" -> Ok None
      | flag_name ->
        Or_error.Let_syntax.Let_syntax.bind
          (param_of_user_flag flag_info ~flag_name)
          ~f:(fun param -> Ok (Some param)))
  ;;

  let unit_param = Command.Param.map ~f:ignore

  let param_of_flags flags =
    Or_error.Let_syntax.Let_syntax.bind
      (filter_map_or_error_option flags ~f:param_of_flag)
      ~f:(fun params ->
        Or_error.return
          (Option.value
             ~default:(Command.Param.return ())
             (List.reduce params ~f:(fun a b -> unit_param (Command.Param.both a b)))))
  ;;

  let param_of_basic ({ summary; readme; anons; flags } : Command.Shape.Base_info.t) =
    let __let_syntax__013_ = param_of_anons anons [@@ppxlib.do_not_enter_value]
    and __let_syntax__014_ = param_of_flags flags [@@ppxlib.do_not_enter_value] in
    Or_error.Let_syntax.Let_syntax.bind
      (Or_error.Let_syntax.Let_syntax.both __let_syntax__013_ __let_syntax__014_)
      ~f:(fun (anons, flags) ->
        Ok
          (Command.basic
             ~summary
             ?readme:(Option.map readme ~f:const)
             (let __let_syntax__016_ =
                let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
                anons
              [@@ppxlib.do_not_enter_value]
              and __let_syntax__017_ =
                let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
                flags
                  [@@ppxlib.do_not_enter_value]
              in
              Command.Let_syntax.Let_syntax.map
                (Command.Let_syntax.Let_syntax.both __let_syntax__016_ __let_syntax__017_)
                ~f:(fun ((), ()) () -> ()))))
  ;;

  let command_of_shape (shape : Command.Shape.t) =
    let rec of_shape : Command.Shape.t -> _ = function
      | Basic base_info -> param_of_basic base_info
      | Exec (exec_info, _) -> cannot_validate_exec_error exec_info
      | Group group_info -> of_group group_info
      | Lazy shape -> of_shape (force shape)
    and of_group ({ summary; readme; subcommands } : _ Command.Shape.Group_info.t) =
      Or_error.Let_syntax.Let_syntax.bind
        (filter_map_or_error_option (force subcommands) ~f:(function
           | ("help" | "version"), _ -> Ok None
           | name, user_subcommand ->
             Or_error.Let_syntax.Let_syntax.bind
               (of_shape user_subcommand)
               ~f:(fun command -> Ok (Some (name, command)))))
        ~f:(fun subcommands ->
          Ok (Command.group subcommands ~summary ?readme:(Option.map readme ~f:const)))
    in
    of_shape shape
  ;;

  let f shape =
    Or_error.Let_syntax.Let_syntax.bind (command_of_shape shape) ~f:(fun command ->
      Ok
        (fun args ->
          Or_error.try_with (fun () ->
            Command_unix.run command ~argv:(default_command_name :: args))))
  ;;
end

module Validate_command = struct
  let rec error_if_would_exec (shape : Command.Shape.t) args =
    match shape with
    | Basic (_ : Command.Shape.Base_info.t) -> None
    | Exec (exec_info, (_ : unit -> Command.Shape.t)) ->
      Result.error (cannot_validate_exec_error exec_info)
    | Group group_info ->
      (match args with
       | [] -> None
       | arg :: args ->
         (match Command.Shape.Group_info.find_subcommand group_info arg with
          | Ok shape -> error_if_would_exec shape args
          | Error (_ : Error.t) -> None))
    | Lazy lazy_shape -> error_if_would_exec (force lazy_shape) args
  ;;

  let built_in_args =
    lazy
      (let multi_dash_allowed =
         let one_or_two_dashes_allowed x = [ "-" ^ x; "--" ^ x ] in
         List.Let_syntax.Let_syntax.bind
           [ "help"; "build-info"; "version" ]
           ~f:(fun arg -> one_or_two_dashes_allowed arg)
       in
       String.Set.of_list ("-?" :: multi_dash_allowed))
  ;;

  let raise_built_in_args_out_of_sync () =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Conv.sexp_of_string
           "BUG: Unexpected non-local exit from command parsing. Ask a \
            [Command_test_helpers] dev if [built_in_args] is out of sync."
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  ;;

  let is_built_in_command_that_exits_before_parsing_succeeds args =
    List.exists args ~f:(Set.mem (force built_in_args))
  ;;

  let f command args =
    match error_if_would_exec (Command_unix.shape command) args with
    | Some error -> Error error
    | None ->
      Or_error.try_with (fun () ->
        with_return (fun { return } ->
          Command_unix.run
            command
            ~argv:(default_command_name :: args)
            ~when_parsing_succeeds:return;
          match is_built_in_command_that_exits_before_parsing_succeeds args with
          | true -> ()
          | false -> raise_built_in_args_out_of_sync ()))
  ;;
end

let validate_command = Validate_command.f
let validate_command_line = Validate_command_line.f

let with_env ~var ~value ~f =
  let prev = Sys.getenv var in
  Unix.putenv ~key:var ~data:value;
  Exn.protect ~f ~finally:(fun () ->
    match prev with
    | None -> Unix.unsetenv var
    | Some value -> Unix.putenv ~key:var ~data:value)
;;

let complete_command ?complete_subcommands ?which_arg cmd ~args =
  let which_arg =
    match which_arg with
    | Some n -> n + 1
    | None -> List.length args
  in
  with_env ~var:"COMP_CWORD" ~value:(Int.to_string which_arg) ~f:(fun () ->
    Command_unix.run ?complete_subcommands ~argv:("__exe_name__" :: args) cmd)
;;

let complete ?which_arg param ~args =
  complete_command
    ?which_arg
    ~args
    (Command.basic ~summary:"SUMMARY" (Command.Param.map param ~f:(fun (_ : _) () -> ())))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
