let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"compare.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "compare.ml.before-ppx"
;;

open Core
module Unix = Core_unix
module Compare_core = Patdiff.Compare_core
module Configuration = Patdiff.Configuration
module Format = Patdiff.Format
module Output = Patdiff.Output
module Pcre = Re.Pcre

let summary =
  {|Compare two files (or process a diff read in on stdin) using the
patience diff algorithm.

If you don't supply any arguments to patdiff, it will read diff-like
text from stdin and color it in the normal patdiff way.

The file ~/.patdiff is used as a config file if it exists.  You can
write a sample config with the -make-config flag.|}
;;

module Args = struct
  type compare_flags =
    { unrefined_opt : bool option
    ; produce_unified_lines_opt : bool option
    ; float_tolerance_opt : Percent.t option option
    ; keep_ws_opt : bool option
    ; interleave_opt : bool option
    ; assume_text_opt : bool option
    ; split_long_lines_opt : bool option
    ; shallow_opt : bool option
    ; quiet_opt : bool option
    ; double_check_opt : bool option
    ; mask_uniques_opt : bool option
    ; output : Output.t option
    ; context_opt : int option
    ; line_big_enough_opt : int option
    ; word_big_enough_opt : int option
    ; config_opt : string option
    ; prev_file : string
    ; next_file : string
    ; prev_alt_opt : string option option
    ; next_alt_opt : string option option
    ; include_ : Re.re list
    ; exclude : Re.re list
    ; location_style : Format.Location_style.t option
    ; warn_if_no_trailing_newline_in_both : bool option
    ; find_moves_opt : bool option
    }

  type t =
    | Compare of compare_flags
    | Make_config of string
end

let files_from_anons = function
  | Some (prev_file, next_file) -> prev_file, next_file
  | None ->
    let temp_txt_file prefix =
      let file, oc = Filename_unix.open_temp_file prefix ".txt" in
      at_exit (fun () ->
        try Unix.unlink file with
        | _ -> ());
      file, oc
    in
    let prev_file, prev_oc = temp_txt_file "patdiff_prev_" in
    let next_file, next_oc = temp_txt_file "patdiff_next_" in
    let add_prefixes = [ "+"; ">" ] in
    let remove_prefixes = [ "-"; "<" ] in
    let begins_with line prefixes =
      List.exists prefixes ~f:(fun prefix -> String.is_prefix line ~prefix)
    in
    let maybe_remove line prefixes =
      let begins_with =
        List.find prefixes ~f:(fun prefix -> String.is_prefix line ~prefix)
      in
      match begins_with with
      | None -> line
      | Some prefix -> " " ^ String.chop_prefix_exn line ~prefix
    in
    let process line begins_with_prefixes maybe_remove_prefixes oc =
      if not (begins_with line begins_with_prefixes)
      then (
        Out_channel.output_string oc (maybe_remove line maybe_remove_prefixes);
        Out_channel.newline oc)
    in
    In_channel.iter_lines In_channel.stdin ~f:(fun line ->
      process line add_prefixes remove_prefixes prev_oc;
      process line remove_prefixes add_prefixes next_oc);
    Out_channel.close prev_oc;
    Out_channel.close next_oc;
    prev_file, next_file
;;

let override config (args : Args.compare_flags) =
  Configuration.override
    config
    ?output:args.output
    ?unrefined:args.unrefined_opt
    ?produce_unified_lines:args.produce_unified_lines_opt
    ?float_tolerance:args.float_tolerance_opt
    ?keep_ws:args.keep_ws_opt
    ?find_moves:args.find_moves_opt
    ?split_long_lines:args.split_long_lines_opt
    ?interleave:args.interleave_opt
    ?assume_text:args.assume_text_opt
    ?context:args.context_opt
    ?line_big_enough:args.line_big_enough_opt
    ?word_big_enough:args.word_big_enough_opt
    ?shallow:args.shallow_opt
    ?quiet:args.quiet_opt
    ?double_check:args.double_check_opt
    ?mask_uniques:args.mask_uniques_opt
    ?prev_alt:args.prev_alt_opt
    ?next_alt:args.next_alt_opt
    ?location_style:args.location_style
    ?warn_if_no_trailing_newline_in_both:args.warn_if_no_trailing_newline_in_both
;;

let compare_main (args : Args.compare_flags) =
  let config = Configuration.get_config ?filename:args.config_opt () in
  let config = override config args in
  let prev_file = args.prev_file in
  let next_file = args.next_file in
  let prev_exists = Sys_unix.file_exists_exn prev_file in
  let next_exists = Sys_unix.file_exists_exn next_file in
  if (not prev_exists) && not next_exists
  then failwithf "Both files, %s and %s, do not exist" prev_file next_file ();
  let is_dir = Sys_unix.is_directory_exn in
  let if_not_diffing_two_dirs () =
    match args with
    | { include_ = []; exclude = []; _ } -> ()
    | _ -> failwith "Can only specify -include or -exclude when diffing two dirs"
  in
  match is_dir prev_file, is_dir next_file with
  | true, false | false, true ->
    let dir, file =
      if is_dir prev_file then prev_file, next_file else next_file, prev_file
    in
    if not (Sys_unix.file_exists_exn file)
    then failwithf "%s is a directory, while %s does not exist" dir file ()
    else failwithf "%s is a directory, while %s is a file" dir file ()
  | true, true ->
    let file_filter =
      match args with
      | { include_ = []; exclude = []; _ } -> None
      | { include_; exclude; _ } ->
        Some
          (fun (s, stat) ->
            match stat.Unix.st_kind with
            | Unix.S_REG ->
              List.for_all exclude ~f:(fun rex -> not (Pcre.pmatch s ~rex))
              && (List.is_empty include_
                  || List.exists include_ ~f:(fun rex -> Pcre.pmatch s ~rex))
            | _ -> true)
    in
    Compare_core.diff_dirs ~prev_dir:prev_file ~next_dir:next_file config ~file_filter
  | false, false ->
    if_not_diffing_two_dirs ();
    let prev_file = if prev_exists then prev_file else "/dev/null" in
    let next_file = if next_exists then next_file else "/dev/null" in
    Compare_core.diff_files ~prev_file ~next_file config
;;

let main arg =
  match arg with
  | Args.Make_config file -> Make_config.main file
  | Args.Compare compare_args ->
    exit
      (match compare_main compare_args with
       | `Same -> 0
       | `Different -> 1)
;;

let command =
  let flag_no_arg ?(inverted = false) name ~doc =
    let open Command.Param in
    map ~f:(fun b -> if b then Some (not inverted) else None) (flag name no_arg ~doc)
  in
  Command.basic
    ~summary
    ~readme:(fun () -> Readme.doc)
    (let __let_syntax__001_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       let __let_syntax__027_ =
         and_arg_name
           (flag
              "default"
              no_arg
              ~doc:" Use the default configuration instead of ~/.patdiff")
       [@@ppxlib.do_not_enter_value]
       and __let_syntax__028_ =
         and_arg_name
           (flag
              "file"
              (optional Filename_unix.arg_type)
              ~doc:"FILE Use FILE as configuration file instead of ~/.patdiff")
           [@@ppxlib.do_not_enter_value]
       in
       Command.Let_syntax.Let_syntax.map
         (Command.Let_syntax.Let_syntax.both __let_syntax__027_ __let_syntax__028_)
         ~f:(fun ((default, default_arg_name), (file, file_arg_name)) ->
           match file, default with
           | Some _, true ->
             failwith
               (Ppx_string_runtime.For_string.concat
                  [ Ppx_string_runtime.For_string.of_string "Cannot pass both ["
                  ; default_arg_name
                  ; Ppx_string_runtime.For_string.of_string "] and ["
                  ; file_arg_name
                  ; Ppx_string_runtime.For_string.of_string "]"
                  ] [@merlin.hide])
           | None, true -> Some ""
           | _, false -> file)
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__002_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "context"
         (optional int)
         ~doc:"NUM Show lines of unchanged context before and after changes"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__003_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       let __let_syntax__030_ =
         and_arg_name
           (flag
              "line-big-enough"
              (optional int)
              ~doc:
                "NUM Limit line-level semantic cleanup to the matches of length less \
                 than NUM lines")
       [@@ppxlib.do_not_enter_value]
       and __let_syntax__031_ =
         and_arg_name
           (flag
              "no-semantic-cleanup"
              no_arg
              ~doc:" Don't do any semantic cleanup; let small, spurious matches survive")
       [@@ppxlib.do_not_enter_value]
       and __let_syntax__032_ =
         and_arg_name
           (flag
              "word-big-enough"
              (optional int)
              ~doc:
                "NUM Limit word-level semantic cleanup to the matches of length less \
                 than NUM words")
           [@@ppxlib.do_not_enter_value]
       in
       Command.Let_syntax.Let_syntax.map
         (Command.Let_syntax.Let_syntax.both
            __let_syntax__030_
            (Command.Let_syntax.Let_syntax.both __let_syntax__031_ __let_syntax__032_))
         ~f:
           (fun
             ( line_big_enough
             , ((no_semantic_cleanup, no_semantic_cleanup_arg_name), word_big_enough) ) ->
           let check_conflict_with_no_semantic_cleanup (value, arg_name) =
             match value, no_semantic_cleanup with
             | Some _, true ->
               failwith
                 (Ppx_string_runtime.For_string.concat
                    [ Ppx_string_runtime.For_string.of_string "Cannot pass both ["
                    ; arg_name
                    ; Ppx_string_runtime.For_string.of_string "] and ["
                    ; no_semantic_cleanup_arg_name
                    ; Ppx_string_runtime.For_string.of_string "]"
                    ] [@merlin.hide])
             | None, true -> Some 1
             | _, false -> value
           in
           ( check_conflict_with_no_semantic_cleanup line_big_enough
           , check_conflict_with_no_semantic_cleanup word_big_enough ))
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__004_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg "unrefined" ~doc:" Don't highlight word differences between lines"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__005_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg "keep-whitespace" ~doc:" Consider whitespace when comparing lines"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__006_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         "split-long-lines"
         ~doc:" Split long lines into multiple displayed lines"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__007_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         ~inverted:true
         "no-interleave"
         ~doc:" Don't attempt to split up large hunks near equalities"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__008_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         "text"
         ~doc:" Treat all files as text (i.e. display diffs of binary file contents)"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__009_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       choose_one
         [ map
             ~f:(function
               | true -> Some (Some Output.Html)
               | _ -> None)
             (flag
                "html"
                no_arg
                ~doc:
                  " Output in HTML format instead of default (ASCII with ANSI escape \
                   codes)")
         ; map
             ~f:(function
               | true -> Some (Some Output.Ascii)
               | _ -> None)
             (flag
                "ascii"
                no_arg
                ~doc:" Output in ASCII with no ANSI escape codes (implies -unrefined)")
         ; map
             ~f:(function
               | true -> Some (Some Output.Ansi)
               | _ -> None)
             (flag "ansi" no_arg ~doc:" Output in ASCII with ANSI escape codes")
         ]
         ~if_nothing_chosen:(Default_to None)
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__010_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         ~inverted:true
         "dont-produce-unified-lines"
         ~doc:
           " Don't produce unified lines (this makes the diff unambiguous even if color \
            is stripped)"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__011_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg "quiet" ~doc:" Report only whether files differ, not the details"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__012_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         "shallow"
         ~doc:" When comparing directories, don't recurse into subdirs"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__013_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg "double-check" ~doc:" If files seem identical, double check with cmp"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__014_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         "mask-uniques"
         ~doc:" When comparing directories, don't compare against /dev/null"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__015_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "float-tolerance"
         (optional (Arg_type.map percent ~f:Option.some))
         ~doc:
           "PERCENT Consider strings equal if only difference is floats changing within \
            PERCENT"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__016_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "alt-prev"
         ~aliases:[ "alt-old" ]
         (optional (Arg_type.map Filename_unix.arg_type ~f:Option.some))
         ~doc:"NAME Mask prev filename with NAME"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__017_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "alt-next"
         ~aliases:[ "alt-new" ]
         (optional (Arg_type.map Filename_unix.arg_type ~f:Option.some))
         ~doc:"NAME Mask next filename with NAME"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__018_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag "make-config" (optional Filename_unix.arg_type) ~doc:Make_config.doc
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__019_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "include"
         (listed (Arg_type.map string ~f:Pcre.regexp))
         ~doc:"REGEXP include files matching this pattern when comparing two directories"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__020_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "exclude"
         (listed (Arg_type.map string ~f:Pcre.regexp))
         ~doc:
           "REGEXP exclude files matching this pattern when comparing two directories \
            (overrides include patterns)"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__021_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag "reverse" no_arg ~doc:" produce a diff that undoes the changes"
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__022_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "location-style"
         (optional (Arg_type.create Format.Location_style.of_string))
         ~doc:
           (let open Format.Location_style in
            sprintf
              "<%s> how to format location information in hunk headers"
              (String.concat ~sep:"|" (List.map all ~f:to_string)))
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__023_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag
         "warn-if-no-trailing-newline-in-both"
         (optional bool)
         ~doc:
           (sprintf
              "BOOL warn when neither file ends in a newline, even though this does not \
               constitute a diff (default: read from config, or %b)"
              Configuration.warn_if_no_trailing_newline_in_both_default)
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__024_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       flag_no_arg
         "find-moves"
         ~doc:
           "Try to find and render moves. If -dont-produce-unified-lines is set moves \
            will not be found."
     [@@ppxlib.do_not_enter_value]
     and __let_syntax__025_ =
       let open! Command.Let_syntax.Let_syntax.Open_on_rhs in
       anon
         (maybe
            (t2 ("FILE1" %: Filename_unix.arg_type) ("FILE2" %: Filename_unix.arg_type)))
         [@@ppxlib.do_not_enter_value]
     in
     Command.Let_syntax.Let_syntax.map
       (Command.Let_syntax.Let_syntax.both
          __let_syntax__001_
          (Command.Let_syntax.Let_syntax.both
             __let_syntax__002_
             (Command.Let_syntax.Let_syntax.both
                __let_syntax__003_
                (Command.Let_syntax.Let_syntax.both
                   __let_syntax__004_
                   (Command.Let_syntax.Let_syntax.both
                      __let_syntax__005_
                      (Command.Let_syntax.Let_syntax.both
                         __let_syntax__006_
                         (Command.Let_syntax.Let_syntax.both
                            __let_syntax__007_
                            (Command.Let_syntax.Let_syntax.both
                               __let_syntax__008_
                               (Command.Let_syntax.Let_syntax.both
                                  __let_syntax__009_
                                  (Command.Let_syntax.Let_syntax.both
                                     __let_syntax__010_
                                     (Command.Let_syntax.Let_syntax.both
                                        __let_syntax__011_
                                        (Command.Let_syntax.Let_syntax.both
                                           __let_syntax__012_
                                           (Command.Let_syntax.Let_syntax.both
                                              __let_syntax__013_
                                              (Command.Let_syntax.Let_syntax.both
                                                 __let_syntax__014_
                                                 (Command.Let_syntax.Let_syntax.both
                                                    __let_syntax__015_
                                                    (Command.Let_syntax.Let_syntax.both
                                                       __let_syntax__016_
                                                       (Command.Let_syntax.Let_syntax.both
                                                          __let_syntax__017_
                                                          (Command.Let_syntax.Let_syntax
                                                           .both
                                                             __let_syntax__018_
                                                             (Command.Let_syntax
                                                              .Let_syntax
                                                              .both
                                                                __let_syntax__019_
                                                                (Command.Let_syntax
                                                                 .Let_syntax
                                                                 .both
                                                                   __let_syntax__020_
                                                                   (Command.Let_syntax
                                                                    .Let_syntax
                                                                    .both
                                                                      __let_syntax__021_
                                                                      (Command.Let_syntax
                                                                       .Let_syntax
                                                                       .both
                                                                         __let_syntax__022_
                                                                         (Command
                                                                          .Let_syntax
                                                                          .Let_syntax
                                                                          .both
                                                                            __let_syntax__023_
                                                                            (Command
                                                                             .Let_syntax
                                                                             .Let_syntax
                                                                             .both
                                                                               __let_syntax__024_
                                                                               __let_syntax__025_))))))))))))))))))))))))
       ~f:
         (fun
           ( config_opt
           , ( context_opt
             , ( (line_big_enough_opt, word_big_enough_opt)
               , ( unrefined_opt
                 , ( keep_ws_opt
                   , ( split_long_lines_opt
                     , ( interleave_opt
                       , ( assume_text_opt
                         , ( output
                           , ( produce_unified_lines_opt
                             , ( quiet_opt
                               , ( shallow_opt
                                 , ( double_check_opt
                                   , ( mask_uniques_opt
                                     , ( float_tolerance_opt
                                       , ( prev_alt_opt
                                         , ( next_alt_opt
                                           , ( make_config
                                             , ( include_
                                               , ( exclude
                                                 , ( reverse
                                                   , ( location_style
                                                     , ( warn_if_no_trailing_newline_in_both
                                                       , (find_moves_opt, files) ) ) ) )
                                               ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )
           () ->
         let args =
           match make_config with
           | Some file -> Args.Make_config file
           | None ->
             let prev_file, next_file =
               let pair = files_from_anons files in
               if reverse then Tuple.T2.swap pair else pair
             in
             Args.Compare
               { config_opt
               ; context_opt
               ; line_big_enough_opt
               ; word_big_enough_opt
               ; unrefined_opt
               ; keep_ws_opt
               ; split_long_lines_opt
               ; interleave_opt
               ; assume_text_opt
               ; output
               ; produce_unified_lines_opt
               ; quiet_opt
               ; shallow_opt
               ; double_check_opt
               ; mask_uniques_opt
               ; float_tolerance_opt
               ; prev_alt_opt
               ; next_alt_opt
               ; include_
               ; exclude
               ; location_style
               ; warn_if_no_trailing_newline_in_both
               ; find_moves_opt =
                   (match produce_unified_lines_opt with
                    | None | Some true -> find_moves_opt
                    | Some false -> Some false)
               ; prev_file
               ; next_file
               }
         in
         main args))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
