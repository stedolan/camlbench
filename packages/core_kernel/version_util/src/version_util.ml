let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"version_util.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "version_util.ml.before-ppx"
;;

open! Core

external generated_build_info : unit -> string = "generated_build_info"
external generated_hg_version : unit -> string = "generated_hg_version"

module Version_util_section = Section.Make (struct
    let name = "version_util"
    let length_including_start_marker = 4096
    let start_marker = (Sys.opaque_identity ( ^ )) "rUb71QgfHXXwnBWBoJfb0Sa3R60vihdV" ":"
  end)
[@@ocaml.doc
  " Make sure to update [bin/generate_static_string_c_code.sh] too if you are changing\n\
  \    these constants. "]

module Build_info_section = Section.Make (struct
    let name = "build info"
    let length_including_start_marker = 4096
    let start_marker = (Sys.opaque_identity ( ^ )) "vNxXpiccvPI9MHVFJuNwNxj8eu9W5KCB" ":"
  end)
[@@ocaml.doc
  " Make sure to update [bin/generate_static_string_c_code.sh] too if you are changing\n\
  \    these constants. "]

let parse_generated_hg_version = function
  | "" -> [ "NO_VERSION_UTIL" ]
  | generated_hg_version ->
    List.map
      ~f:(fun line ->
        match String.rsplit2 line ~on:' ' with
        | None -> line
        | Some (repo, rev_status) ->
          String.concat
            [ repo
            ; "_"
            ; String.prefix rev_status 12
            ; (if String.length rev_status mod 2 = 1
               then String.suffix rev_status 1
               else "")
            ])
      (String.split
         ~on:'\n'
         (Version_util_section.chop_start_marker_if_exists
            (String.chop_suffix_if_exists ~suffix:"\n" generated_hg_version)))
;;

let version_list = parse_generated_hg_version (generated_hg_version ())
let version = String.concat version_list ~sep:" "

module Version = struct
  type t =
    { repo : string
    ; version : string
    }
  [@@deriving compare, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ ->
         if Stdlib.( == ) a__001_ b__002_
         then 0
         else (
           match compare_string a__001_.repo b__002_.repo with
           | 0 -> compare_string a__001_.version b__002_.version
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let sexp_of_t =
      (fun { repo = repo__004_; version = version__006_ } ->
         let bnds__003_ = ([] : _ Stdlib.List.t) in
         let bnds__003_ =
           let arg__007_ = sexp_of_string version__006_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "version"; arg__007_ ] :: bnds__003_
            : _ Stdlib.List.t)
         in
         let bnds__003_ =
           let arg__005_ = sexp_of_string repo__004_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "repo"; arg__005_ ] :: bnds__003_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__003_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let parse1 version =
    match String.rsplit2 version ~on:'_' with
    | None ->
      error_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Could not parse version"
             ; Ppx_sexp_conv_lib.Conv.sexp_of_string version
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
    | Some (repo, version) -> Ok { repo; version }
  ;;

  let parse_list l =
    if List.exists l ~f:(String.( = ) "NO_VERSION_UTIL")
    then Ok None
    else
      Or_error.map ~f:(fun x -> Some x) (Or_error.combine_errors (List.map l ~f:parse1))
  ;;

  let parse_lines versions = parse_list (String.split_lines versions)
  let current_version () = ok_exn (parse_list version_list)

  let present = function
    | None ->
      error_s
        (Ppx_sexp_conv_lib.Conv.sexp_of_string "executable built without version util")
    | Some x -> Ok x
  ;;

  let parse_list_present x = Or_error.bind ~f:present (parse_list x)
  let parse_lines_present x = Or_error.bind ~f:present (parse_lines x)
  let current_version_present () = present (current_version ())
end

module Expert = struct
  let get_version_util ~contents_of_exe =
    Option.Let_syntax.Let_syntax.map
      (Version_util_section.get ~contents_of_exe)
      ~f:(fun section -> String.concat ~sep:" " (parse_generated_hg_version section))
  ;;

  let text (versions_opt : Version.t list option) =
    match versions_opt with
    | None -> "NO_VERSION_UTIL"
    | Some versions ->
      if List.is_empty versions
      then failwith "version_util must include at least one repository";
      if
        List.contains_dup ~compare:String.compare (List.map versions ~f:(fun v -> v.repo))
      then failwith "version_util must not contain duplicate repositories";
      String.concat
        (List.map
           ~f:(fun { repo; version } ->
             if not (String.mem repo '/')
             then
               failwith
                 (Ppx_string_runtime.For_string.concat
                    [ repo
                    ; Ppx_string_runtime.For_string.of_string
                        " doesn't look like a repo url"
                    ] [@merlin.hide]);
             (let version' = String.chop_suffix_if_exists version ~suffix:"+" in
              if
                (String.length version' = 40 || String.length version' = 64)
                && String.for_all version' ~f:Char.is_hex_digit_lower
              then ()
              else
                failwith
                  (Ppx_string_runtime.For_string.concat
                     [ version
                     ; Ppx_string_runtime.For_string.of_string
                         " doesn't look like a full hg version"
                     ] [@merlin.hide]));
             repo ^ " " ^ version ^ "\n")
           (List.sort ~compare:Version.compare versions))
  ;;

  let raw_text v = Version_util_section.Expert.pad_with_at_least_one_nul_byte_exn (text v)

  let replace_version_util ~contents_of_exe versions_opt =
    Version_util_section.replace ~contents_of_exe ~data:(text versions_opt)
  ;;

  let parse_generated_hg_version = parse_generated_hg_version

  module Experimental = struct
    let get_build_info = Build_info_section.get

    let remove_build_info ~contents_of_exe =
      Build_info_section.replace ~contents_of_exe ~data:"NO_BUILD_INFO"
    ;;
  end

  module For_tests = struct
    let count_section_occurrences ~contents_of_exe =
      Version_util_section.count_occurrences ~contents_of_exe
      + Build_info_section.count_occurrences ~contents_of_exe
    ;;
  end
end

module Build_info = struct
  module Application_specific_fields = struct
    type t = Sexp.t String.Map.t [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (fun x__010_ -> String.Map.t_of_sexp Sexp.t_of_sexp x__010_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun x__011_ -> String.Map.sexp_of_t Sexp.sexp_of_t x__011_
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Time_with_limited_parsing = struct
    type t = Time_float.t * Sexp.t

    let t_of_sexp sexp =
      let str = string_of_sexp sexp in
      try
        match String.chop_suffix str ~suffix:"Z" with
        | None -> failwith "zone must be Z"
        | Some rest ->
          (match String.lsplit2 rest ~on:' ' with
           | None -> failwith "time must contain one space between date and ofday"
           | Some (date, ofday) ->
             let date = Date.t_of_sexp (sexp_of_string date) in
             let ofday = Time_float.Ofday.t_of_sexp (sexp_of_string ofday) in
             Time_float.of_date_ofday date ofday ~zone:Time_float.Zone.utc, sexp)
      with
      | Sexplib.Conv.Of_sexp_error (e, _) | e ->
        raise (Sexplib.Conv.Of_sexp_error (e, sexp))
    ;;

    let sexp_of_t_ref = ref (fun (_, sexp) -> sexp)
    let sexp_of_t time = !sexp_of_t_ref time
    let epoch : t = Time_float.epoch, Atom "1970-01-01 00:00:00Z"
  end

  type t =
    { username : string option [@sexp.option]
    ; hostname : string option [@sexp.option]
    ; kernel : string option [@sexp.option]
    ; build_time : Time_with_limited_parsing.t option [@sexp.option]
    ; x_library_inlining : bool
    ; portable_int63 : bool
    ; dynlinkable_code : bool
    ; risk_system : bool [@sexp.default false]
    ; ocaml_version : string
    ; executable_path : string
    ; build_system : string
    ; allowed_projections : string list option [@sexp.option]
    ; with_fdo : (string * Md5.t option) option [@sexp.option]
    ; application_specific_fields : Application_specific_fields.t option [@sexp.option]
    }
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let default__019_ : bool = false in
       let error_source__013_ = "version_util.ml.before-ppx.Build_info.t" in
       fun x__020_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__013_
           ~fields:
             (Field
                { name = "username"
                ; kind = Sexp_option
                ; conv = string_of_sexp
                ; rest =
                    Field
                      { name = "hostname"
                      ; kind = Sexp_option
                      ; conv = string_of_sexp
                      ; rest =
                          Field
                            { name = "kernel"
                            ; kind = Sexp_option
                            ; conv = string_of_sexp
                            ; rest =
                                Field
                                  { name = "build_time"
                                  ; kind = Sexp_option
                                  ; conv = Time_with_limited_parsing.t_of_sexp
                                  ; rest =
                                      Field
                                        { name = "x_library_inlining"
                                        ; kind = Required
                                        ; conv = bool_of_sexp
                                        ; rest =
                                            Field
                                              { name = "portable_int63"
                                              ; kind = Required
                                              ; conv = bool_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "dynlinkable_code"
                                                    ; kind = Required
                                                    ; conv = bool_of_sexp
                                                    ; rest =
                                                        Field
                                                          { name = "risk_system"
                                                          ; kind =
                                                              Default
                                                                (fun () -> default__019_)
                                                          ; conv = bool_of_sexp
                                                          ; rest =
                                                              Field
                                                                { name = "ocaml_version"
                                                                ; kind = Required
                                                                ; conv = string_of_sexp
                                                                ; rest =
                                                                    Field
                                                                      { name =
                                                                          "executable_path"
                                                                      ; kind = Required
                                                                      ; conv =
                                                                          string_of_sexp
                                                                      ; rest =
                                                                          Field
                                                                            { name =
                                                                                "build_system"
                                                                            ; kind =
                                                                                Required
                                                                            ; conv =
                                                                                string_of_sexp
                                                                            ; rest =
                                                                                Field
                                                                                  { name =
                                                                                      "allowed_projections"
                                                                                  ; kind =
                                                                                      Sexp_option
                                                                                  ; conv =
                                                                                      list_of_sexp
                                                                                        string_of_sexp
                                                                                  ; rest =
                                                                                      Field
                                                                                        { name =
                                                                                          "with_fdo"
                                                                                        ; kind =
                                                                                          Sexp_option
                                                                                        ; conv =
                                                                                          (function
                                                                                          | 
                                                                                          Sexplib0
                                                                                          .Sexp
                                                                                          .List
                                                                                          [ 
                                                                                          arg0__014_
                                                                                          ; 
                                                                                          arg1__015_
                                                                                          ]
                                                                                          ->
                                                                                          
                                                                                          let res0__016_
                                                                                          =
                                                                                          string_of_sexp
                                                                                          arg0__014_
                                                                                          and res1__017_
                                                                                          =
                                                                                          option_of_sexp
                                                                                          Md5
                                                                                          .t_of_sexp
                                                                                          arg1__015_
                                                                                          in
                                                                                          ( 
                                                                                          res0__016_
                                                                                        , res1__017_
                                                                                          )
                                                                                          | sexp__018_
                                                                                          ->
                                                                                          
                                                                                          Sexplib0
                                                                                          .Sexp_conv_error
                                                                                          .tuple_of_size_n_expected
                                                                                          error_source__013_
                                                                                          2
                                                                                          sexp__018_)
                                                                                        ; rest =
                                                                                          Field
                                                                                          { 
                                                                                          name =
                                                                                          "application_specific_fields"
                                                                                          ; 
                                                                                          kind =
                                                                                          Sexp_option
                                                                                          ; 
                                                                                          conv =
                                                                                          Application_specific_fields
                                                                                          .t_of_sexp
                                                                                          ; 
                                                                                          rest =
                                                                                          Empty
                                                                                          }
                                                                                        }
                                                                                  }
                                                                            }
                                                                      }
                                                                }
                                                          }
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "username" -> 0
             | "hostname" -> 1
             | "kernel" -> 2
             | "build_time" -> 3
             | "x_library_inlining" -> 4
             | "portable_int63" -> 5
             | "dynlinkable_code" -> 6
             | "risk_system" -> 7
             | "ocaml_version" -> 8
             | "executable_path" -> 9
             | "build_system" -> 10
             | "allowed_projections" -> 11
             | "with_fdo" -> 12
             | "application_specific_fields" -> 13
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:
             (fun
               ( username
               , ( hostname
                 , ( kernel
                   , ( build_time
                     , ( x_library_inlining
                       , ( portable_int63
                         , ( dynlinkable_code
                           , ( risk_system
                             , ( ocaml_version
                               , ( executable_path
                                 , ( build_system
                                   , ( allowed_projections
                                     , (with_fdo, (application_specific_fields, ())) ) )
                                 ) ) ) ) ) ) ) ) ) ) ->
             ({ username
              ; hostname
              ; kernel
              ; build_time
              ; x_library_inlining
              ; portable_int63
              ; dynlinkable_code
              ; risk_system
              ; ocaml_version
              ; executable_path
              ; build_system
              ; allowed_projections
              ; with_fdo
              ; application_specific_fields
              }
              : t))
           x__020_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { username = username__022_
           ; hostname = hostname__026_
           ; kernel = kernel__030_
           ; build_time = build_time__034_
           ; x_library_inlining = x_library_inlining__038_
           ; portable_int63 = portable_int63__040_
           ; dynlinkable_code = dynlinkable_code__042_
           ; risk_system = risk_system__044_
           ; ocaml_version = ocaml_version__046_
           ; executable_path = executable_path__048_
           ; build_system = build_system__050_
           ; allowed_projections = allowed_projections__052_
           ; with_fdo = with_fdo__056_
           ; application_specific_fields = application_specific_fields__064_
           } ->
         let bnds__021_ = ([] : _ Stdlib.List.t) in
         let bnds__021_ =
           match application_specific_fields__064_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__065_ ->
             let arg__067_ = Application_specific_fields.sexp_of_t v__065_ in
             let bnd__066_ =
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "application_specific_fields"; arg__067_ ]
             in
             (bnd__066_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match with_fdo__056_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__057_ ->
             let arg__059_ =
               let arg0__060_, arg1__061_ = v__057_ in
               let res0__062_ = sexp_of_string arg0__060_
               and res1__063_ = sexp_of_option Md5.sexp_of_t arg1__061_ in
               Sexplib0.Sexp.List [ res0__062_; res1__063_ ]
             in
             let bnd__058_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "with_fdo"; arg__059_ ]
             in
             (bnd__058_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match allowed_projections__052_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__053_ ->
             let arg__055_ = sexp_of_list sexp_of_string v__053_ in
             let bnd__054_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "allowed_projections"; arg__055_ ]
             in
             (bnd__054_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__051_ = sexp_of_string build_system__050_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "build_system"; arg__051_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__049_ = sexp_of_string executable_path__048_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "executable_path"; arg__049_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__047_ = sexp_of_string ocaml_version__046_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ocaml_version"; arg__047_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__045_ = sexp_of_bool risk_system__044_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "risk_system"; arg__045_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__043_ = sexp_of_bool dynlinkable_code__042_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "dynlinkable_code"; arg__043_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__041_ = sexp_of_bool portable_int63__040_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "portable_int63"; arg__041_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           let arg__039_ = sexp_of_bool x_library_inlining__038_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "x_library_inlining"; arg__039_ ]
            :: bnds__021_
            : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match build_time__034_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__035_ ->
             let arg__037_ = Time_with_limited_parsing.sexp_of_t v__035_ in
             let bnd__036_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "build_time"; arg__037_ ]
             in
             (bnd__036_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match kernel__030_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__031_ ->
             let arg__033_ = sexp_of_string v__031_ in
             let bnd__032_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "kernel"; arg__033_ ]
             in
             (bnd__032_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match hostname__026_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__027_ ->
             let arg__029_ = sexp_of_string v__027_ in
             let bnd__028_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hostname"; arg__029_ ]
             in
             (bnd__028_ :: bnds__021_ : _ Stdlib.List.t)
         in
         let bnds__021_ =
           match username__022_ with
           | Stdlib.Option.None -> bnds__021_
           | Stdlib.Option.Some v__023_ ->
             let arg__025_ = sexp_of_string v__023_ in
             let bnd__024_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "username"; arg__025_ ]
             in
             (bnd__024_ :: bnds__021_ : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__021_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Structured = struct
    type nonrec t =
      | Not_supported
      | Unset
      | Set of (string * Sexp.t * t)

    let t =
      Exn.handle_uncaught_and_exit (fun () ->
        match generated_build_info () with
        | "" -> Not_supported
        | non_empty_string ->
          (match Build_info_section.chop_start_marker_if_exists non_empty_string with
           | "NO_BUILD_INFO" -> Unset
           | str ->
             let sexp = Sexp.of_string str in
             let t = t_of_sexp sexp in
             Set (str, sexp, t)))
    ;;
  end

  let dummy : t =
    { username = None
    ; hostname = None
    ; kernel = None
    ; build_time = Some Time_with_limited_parsing.epoch
    ; x_library_inlining = false
    ; portable_int63 = true
    ; dynlinkable_code = false
    ; risk_system = false
    ; ocaml_version = ""
    ; executable_path = ""
    ; build_system = ""
    ; allowed_projections = None
    ; with_fdo = None
    ; application_specific_fields = None
    }
  ;;

  let build_system_supports_version_util =
    match Structured.t with
    | Not_supported -> false
    | Unset | Set _ -> true
  ;;

  let build_info_status =
    match Structured.t with
    | Not_supported -> `Not_supported
    | Unset -> `Unset
    | Set _ -> `Set
  ;;

  let build_info, build_info_as_sexp, t =
    match Structured.t with
    | Not_supported | Unset ->
      let t = dummy in
      let sexp = sexp_of_t t in
      let str = Sexp.to_string_mach sexp in
      str, sexp, t
    | Set tuple -> tuple
  ;;

  let { username
      ; hostname
      ; kernel
      ; build_time = build_time_and_sexp
      ; x_library_inlining
      ; portable_int63 = _
      ; dynlinkable_code
      ; risk_system = _
      ; ocaml_version
      ; executable_path
      ; build_system
      ; allowed_projections
      ; with_fdo
      ; application_specific_fields
      }
    =
    t
  ;;

  let build_time =
    match build_time_and_sexp with
    | None -> None
    | Some (time, _sexp) -> Some time
  ;;

  let reprint_build_info sexp_of_time =
    Ref.set_temporarily
      Time_with_limited_parsing.sexp_of_t_ref
      (fun (time, _) -> sexp_of_time time)
      ~f:(fun () -> Sexp.to_string (sexp_of_t t))
  ;;
end

include Build_info

let compiled_for_speed = x_library_inlining && not dynlinkable_code

module For_tests = struct
  let build_info_status = Build_info.build_info_status
  let parse_generated_hg_version = parse_generated_hg_version
end

let arg_spec =
  [ ( "-version"
    , Arg.Unit
        (fun () ->
          List.iter version_list ~f:print_endline;
          exit 0)
    , " Print the hg revision of this build and exit" )
  ; ( "-build_info"
    , Arg.Unit
        (fun () ->
          print_endline build_info;
          exit 0)
    , " Print build info as sexp and exit" )
  ]
;;

module Private__For_version_util_async = struct
  let version_util_start_marker = Version_util_section.Expert.start_marker
  let parse_generated_hg_version = parse_generated_hg_version
  let raw_text = Expert.raw_text
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
