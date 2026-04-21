let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"syslog.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "syslog.ml.before-ppx"
;;

open! Import

module Open_option = struct
  type t =
    | PID
    | CONS
    | ODELAY
    | NDELAY
    | NOWAIT
    | PERROR
  [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__003_ = "syslog.ml.before-ppx.Open_option.t" in
       function
       | Sexplib0.Sexp.Atom ("pID" | "PID") -> PID
       | Sexplib0.Sexp.Atom ("cONS" | "CONS") -> CONS
       | Sexplib0.Sexp.Atom ("oDELAY" | "ODELAY") -> ODELAY
       | Sexplib0.Sexp.Atom ("nDELAY" | "NDELAY") -> NDELAY
       | Sexplib0.Sexp.Atom ("nOWAIT" | "NOWAIT") -> NOWAIT
       | Sexplib0.Sexp.Atom ("pERROR" | "PERROR") -> PERROR
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pID" | "PID") :: _) as sexp__004_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cONS" | "CONS") :: _) as sexp__004_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("oDELAY" | "ODELAY") :: _) as sexp__004_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nDELAY" | "NDELAY") :: _) as sexp__004_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nOWAIT" | "NOWAIT") :: _) as sexp__004_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pERROR" | "PERROR") :: _) as sexp__004_
         -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
       | Sexplib0.Sexp.List [] as sexp__002_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
       | sexp__002_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | PID -> Sexplib0.Sexp.Atom "PID"
       | CONS -> Sexplib0.Sexp.Atom "CONS"
       | ODELAY -> Sexplib0.Sexp.Atom "ODELAY"
       | NDELAY -> Sexplib0.Sexp.Atom "NDELAY"
       | NOWAIT -> Sexplib0.Sexp.Atom "NOWAIT"
       | PERROR -> Sexplib0.Sexp.Atom "PERROR"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  external to_int : t -> int = "core_syslog_open_option_to_int"

  let collect_mask i t = to_int t lor i
  let mask ts = List.fold ~f:collect_mask ~init:0 ts
end

module Facility = struct
  module T = struct
    type t =
      | KERN
      | USER
      | MAIL
      | DAEMON
      | AUTH
      | SYSLOG
      | LPR
      | NEWS
      | UUCP
      | CRON
      | AUTHPRIV
      | FTP
      | LOCAL0
      | LOCAL1
      | LOCAL2
      | LOCAL3
      | LOCAL4
      | LOCAL5
      | LOCAL6
      | LOCAL7
    [@@deriving sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__007_ = "syslog.ml.before-ppx.Facility.T.t" in
         function
         | Sexplib0.Sexp.Atom ("kERN" | "KERN") -> KERN
         | Sexplib0.Sexp.Atom ("uSER" | "USER") -> USER
         | Sexplib0.Sexp.Atom ("mAIL" | "MAIL") -> MAIL
         | Sexplib0.Sexp.Atom ("dAEMON" | "DAEMON") -> DAEMON
         | Sexplib0.Sexp.Atom ("aUTH" | "AUTH") -> AUTH
         | Sexplib0.Sexp.Atom ("sYSLOG" | "SYSLOG") -> SYSLOG
         | Sexplib0.Sexp.Atom ("lPR" | "LPR") -> LPR
         | Sexplib0.Sexp.Atom ("nEWS" | "NEWS") -> NEWS
         | Sexplib0.Sexp.Atom ("uUCP" | "UUCP") -> UUCP
         | Sexplib0.Sexp.Atom ("cRON" | "CRON") -> CRON
         | Sexplib0.Sexp.Atom ("aUTHPRIV" | "AUTHPRIV") -> AUTHPRIV
         | Sexplib0.Sexp.Atom ("fTP" | "FTP") -> FTP
         | Sexplib0.Sexp.Atom ("lOCAL0" | "LOCAL0") -> LOCAL0
         | Sexplib0.Sexp.Atom ("lOCAL1" | "LOCAL1") -> LOCAL1
         | Sexplib0.Sexp.Atom ("lOCAL2" | "LOCAL2") -> LOCAL2
         | Sexplib0.Sexp.Atom ("lOCAL3" | "LOCAL3") -> LOCAL3
         | Sexplib0.Sexp.Atom ("lOCAL4" | "LOCAL4") -> LOCAL4
         | Sexplib0.Sexp.Atom ("lOCAL5" | "LOCAL5") -> LOCAL5
         | Sexplib0.Sexp.Atom ("lOCAL6" | "LOCAL6") -> LOCAL6
         | Sexplib0.Sexp.Atom ("lOCAL7" | "LOCAL7") -> LOCAL7
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("kERN" | "KERN") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("uSER" | "USER") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mAIL" | "MAIL") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("dAEMON" | "DAEMON") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aUTH" | "AUTH") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("sYSLOG" | "SYSLOG") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lPR" | "LPR") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nEWS" | "NEWS") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("uUCP" | "UUCP") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cRON" | "CRON") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aUTHPRIV" | "AUTHPRIV") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("fTP" | "FTP") :: _) as sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL0" | "LOCAL0") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL1" | "LOCAL1") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL2" | "LOCAL2") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL3" | "LOCAL3") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL4" | "LOCAL4") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL5" | "LOCAL5") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL6" | "LOCAL6") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("lOCAL7" | "LOCAL7") :: _) as
           sexp__008_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__007_ sexp__008_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__006_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__007_ sexp__006_
         | Sexplib0.Sexp.List [] as sexp__006_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__007_ sexp__006_
         | sexp__006_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__007_ sexp__006_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | KERN -> Sexplib0.Sexp.Atom "KERN"
         | USER -> Sexplib0.Sexp.Atom "USER"
         | MAIL -> Sexplib0.Sexp.Atom "MAIL"
         | DAEMON -> Sexplib0.Sexp.Atom "DAEMON"
         | AUTH -> Sexplib0.Sexp.Atom "AUTH"
         | SYSLOG -> Sexplib0.Sexp.Atom "SYSLOG"
         | LPR -> Sexplib0.Sexp.Atom "LPR"
         | NEWS -> Sexplib0.Sexp.Atom "NEWS"
         | UUCP -> Sexplib0.Sexp.Atom "UUCP"
         | CRON -> Sexplib0.Sexp.Atom "CRON"
         | AUTHPRIV -> Sexplib0.Sexp.Atom "AUTHPRIV"
         | FTP -> Sexplib0.Sexp.Atom "FTP"
         | LOCAL0 -> Sexplib0.Sexp.Atom "LOCAL0"
         | LOCAL1 -> Sexplib0.Sexp.Atom "LOCAL1"
         | LOCAL2 -> Sexplib0.Sexp.Atom "LOCAL2"
         | LOCAL3 -> Sexplib0.Sexp.Atom "LOCAL3"
         | LOCAL4 -> Sexplib0.Sexp.Atom "LOCAL4"
         | LOCAL5 -> Sexplib0.Sexp.Atom "LOCAL5"
         | LOCAL6 -> Sexplib0.Sexp.Atom "LOCAL6"
         | LOCAL7 -> Sexplib0.Sexp.Atom "LOCAL7"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    external to_int : t -> int = "core_syslog_facility_to_int"
  end

  include T
  include Sexpable.To_stringable (T)

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<([%test_result : string]) ~expect:\"KERN\" (to_[...]>>")
      ~tags:[]
      ~filename:"syslog.ml.before-ppx"
      ~line_number:52
      ~start_pos:2
      ~end_pos:74
      (fun () ->
         (fun ?(here = []) ?message ?equal ~expect got ->
            let pos = "syslog.ml.before-ppx:52:35" in
            let sexpifier = (sexp_of_string [@merlin.hide]) in
            let comparator =
              (fun (a__009_ : string) ((b__010_ : string) [@merlin.hide]) ->
              (compare_string a__009_ b__010_ [@merlin.hide]))
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
           ~expect:"KERN"
           (to_string KERN);
         ())
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<([%test_result : t]) ~expect:LOCAL7 (of_strin[...]>>")
      ~tags:[]
      ~filename:"syslog.ml.before-ppx"
      ~line_number:53
      ~start_pos:2
      ~end_pos:73
      (fun () ->
         (fun ?(here = []) ?message ?equal ~expect got ->
            let pos = "syslog.ml.before-ppx:53:35" in
            let sexpifier = (sexp_of_t [@merlin.hide]) in
            let comparator =
              (fun (a__011_ : t) ((b__012_ : t) [@merlin.hide]) ->
              (compare a__011_ b__012_ [@merlin.hide]))
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
           ~expect:LOCAL7
           (of_string "LOCAL7");
         ())
  ;;
end

module Level = struct
  module T = struct
    type t =
      | EMERG
      | ALERT
      | CRIT
      | ERR
      | WARNING
      | NOTICE
      | INFO
      | DEBUG
    [@@deriving sexp, enumerate, compare]

    include struct
      let _ = fun (_ : t) -> ()

      let t_of_sexp =
        (let error_source__015_ = "syslog.ml.before-ppx.Level.T.t" in
         function
         | Sexplib0.Sexp.Atom ("eMERG" | "EMERG") -> EMERG
         | Sexplib0.Sexp.Atom ("aLERT" | "ALERT") -> ALERT
         | Sexplib0.Sexp.Atom ("cRIT" | "CRIT") -> CRIT
         | Sexplib0.Sexp.Atom ("eRR" | "ERR") -> ERR
         | Sexplib0.Sexp.Atom ("wARNING" | "WARNING") -> WARNING
         | Sexplib0.Sexp.Atom ("nOTICE" | "NOTICE") -> NOTICE
         | Sexplib0.Sexp.Atom ("iNFO" | "INFO") -> INFO
         | Sexplib0.Sexp.Atom ("dEBUG" | "DEBUG") -> DEBUG
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMERG" | "EMERG") :: _) as sexp__016_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("aLERT" | "ALERT") :: _) as sexp__016_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cRIT" | "CRIT") :: _) as sexp__016_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eRR" | "ERR") :: _) as sexp__016_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("wARNING" | "WARNING") :: _) as
           sexp__016_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("nOTICE" | "NOTICE") :: _) as
           sexp__016_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("iNFO" | "INFO") :: _) as sexp__016_ ->
           Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("dEBUG" | "DEBUG") :: _) as sexp__016_
           -> Sexplib0.Sexp_conv_error.stag_no_args error_source__015_ sexp__016_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__014_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__015_ sexp__014_
         | Sexplib0.Sexp.List [] as sexp__014_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__015_ sexp__014_
         | sexp__014_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__015_ sexp__014_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (function
         | EMERG -> Sexplib0.Sexp.Atom "EMERG"
         | ALERT -> Sexplib0.Sexp.Atom "ALERT"
         | CRIT -> Sexplib0.Sexp.Atom "CRIT"
         | ERR -> Sexplib0.Sexp.Atom "ERR"
         | WARNING -> Sexplib0.Sexp.Atom "WARNING"
         | NOTICE -> Sexplib0.Sexp.Atom "NOTICE"
         | INFO -> Sexplib0.Sexp.Atom "INFO"
         | DEBUG -> Sexplib0.Sexp.Atom "DEBUG"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
      let all = ([ EMERG; ALERT; CRIT; ERR; WARNING; NOTICE; INFO; DEBUG ] : t list)
      let _ = all

      let compare =
        (fun a__017_ b__018_ -> Stdlib.compare a__017_ b__018_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let compare a b = compare b a

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<([%test_result : int]) ~expect:1 (compare EME[...]>>")
        ~tags:[]
        ~filename:"syslog.ml.before-ppx"
        ~line_number:71
        ~start_pos:4
        ~end_pos:73
        (fun () ->
           (fun ?(here = []) ?message ?equal ~expect got ->
              let pos = "syslog.ml.before-ppx:71:37" in
              let sexpifier = (sexp_of_int [@merlin.hide]) in
              let comparator =
                (fun (a__019_ : int) ((b__020_ : int) [@merlin.hide]) ->
                (compare_int a__019_ b__020_ [@merlin.hide]))
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
             ~expect:1
             (compare EMERG DEBUG);
           ())
    ;;

    external to_int : t -> int = "core_syslog_level_to_int"

    let collect_mask i t = to_int t lor i
    let mask ts = List.fold ~f:collect_mask ~init:0 ts
  end

  include T
  include Sexpable.To_stringable (T)

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<([%test_result : string]) ~expect:\"EMERG\" (to[...]>>")
      ~tags:[]
      ~filename:"syslog.ml.before-ppx"
      ~line_number:82
      ~start_pos:2
      ~end_pos:76
      (fun () ->
         (fun ?(here = []) ?message ?equal ~expect got ->
            let pos = "syslog.ml.before-ppx:82:35" in
            let sexpifier = (sexp_of_string [@merlin.hide]) in
            let comparator =
              (fun (a__021_ : string) ((b__022_ : string) [@merlin.hide]) ->
              (compare_string a__021_ b__022_ [@merlin.hide]))
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
           ~expect:"EMERG"
           (to_string EMERG);
         ())
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<([%test_result : t]) ~expect:DEBUG (of_string[...]>>")
      ~tags:[]
      ~filename:"syslog.ml.before-ppx"
      ~line_number:83
      ~start_pos:2
      ~end_pos:71
      (fun () ->
         (fun ?(here = []) ?message ?equal ~expect got ->
            let pos = "syslog.ml.before-ppx:83:35" in
            let sexpifier = (sexp_of_t [@merlin.hide]) in
            let comparator =
              (fun (a__023_ : t) ((b__024_ : t) [@merlin.hide]) ->
              (compare a__023_ b__024_ [@merlin.hide]))
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
           ~expect:DEBUG
           (of_string "DEBUG");
         ())
  ;;
end

external core_syslog_openlog : string option -> int -> int -> unit = "core_syslog_openlog"
external core_syslog_syslog : int -> string -> unit = "core_syslog_syslog"
external core_syslog_closelog : unit -> unit = "core_syslog_closelog" [@@noalloc]
external core_syslog_setlogmask : int -> unit = "core_syslog_setlogmask" [@@noalloc]

let openlog ?id ?(options = []) ?(facility = Facility.USER) () =
  core_syslog_openlog id (Open_option.mask options) (Facility.to_int facility)
;;

let syslog ?(facility = Facility.USER) ?(level = Level.INFO) message =
  core_syslog_syslog (Level.to_int level lor Facility.to_int facility) message
;;

let syslogf ?facility ?level format =
  ksprintf (fun message -> syslog ?facility ?level message) format
;;

let logmask_range ?(to_level = Level.EMERG) from_level =
  List.fold Level.all ~init:0 ~f:(fun logmask level ->
    if Level.compare from_level level < 1 && Level.compare level to_level < 1
    then Level.to_int level lor logmask
    else logmask)
;;

let setlogmask ?(allowed_levels = []) ?(from_level = Level.DEBUG) ?to_level () =
  core_syslog_setlogmask (Level.mask allowed_levels lor logmask_range ?to_level from_level)
;;

let closelog = core_syslog_closelog
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
