[@@@ocaml.text
  "\n\n\
  \   Outside of Core Time appears to be a single module with a number of submodules:\n\n\
  \   - Time\n\
  \   - Span\n\
  \   - Ofday\n\
  \   - Zone\n\n\
  \   The reality under the covers isn't as simple for a three reasons:\n\n\
  \   - We want as much Time functionality available to Core as possible, and Core modules\n\
  \     shouldn't rely on Unix functions.  Some functions in Time require Unix, which \
   creates\n\
  \     one split.\n\n\
  \   - We want some functionality to be functorized so that code can be shared\n\
  \     between Time and Time_ns.\n\n\
  \   - Time has internal circular dependencies.  For instance, Ofday.now relies on\n\
  \     Time.now, but Time also wants to expose Time.to_date_ofday, which relies on Ofday.\n\
  \     We use a stack of modules to break the cycle.\n\n\
  \   This leads to the following modules within Core:\n\n\
  \   Core.Span  - the core type of span\n\
  \   Core.Ofday - the core type of ofday, which is really a constrained span\n\
  \   Core.Date  - the core type of date\n\
  \   Core.Zone  - the base functor for creating a Zone type\n\
  \   Core.Time_float0 - contains the base Time.t type and lays out the basic\n\
  \   relationship between Time, Span, Ofday, and Zone\n\
  \   Core.Time_float  - ties Time, Span, Ofday, Zone, and Date together and provides\n\
  \   the higher level functions for them that don't rely on Unix\n\
  \   Core.Time    - re-exposes Time_float\n\n\
  \   Core.Zone_cache   - implements a caching layer between the Unix filesystem and Zones\n\
  \   Core.Core_date    - adds the Unix dependent functions to Date\n\
  \   Core.Core_time    - adds the Unix dependent functions to Time\n\n\
  \   Core          - renames the Core_{base} modules to {base} for ease of access in\n\
  \   modules outside of Core\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_functor.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_functor.ml.before-ppx"
;;

open! Core
open! Import
open! Int.Replace_polymorphic_compare
include Time_functor_intf

module Make
    (Time0 : Time_float.S_kernel_without_zone)
    (Time : Time_float.S_kernel with module Time := Time0) =
struct
  module Span = struct
    include Time.Span

    let arg_type = Core.Command.Arg_type.create of_string
  end

  module Zone = struct
    include Time.Zone
    include (Timezone : Timezone.Extend_zone with type t := t)

    let arg_type = Core.Command.Arg_type.create of_string
  end

  module Ofday = struct
    include Time.Ofday

    let arg_type = Core.Command.Arg_type.create of_string
    let now ~zone = Time.to_ofday ~zone (Time.now ())

    module Zoned = struct
      type t =
        { ofday : Time.Ofday.t
        ; zone : Zone.t
        }
      [@@deriving bin_io, fields ~getters, compare, equal, hash]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_functor.ml.before-ppx:72:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.record
                    [ "ofday", Time.Ofday.bin_shape_t; "zone", Zone.bin_shape_t ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t : t Bin_prot.Size.sizer = function
          | { ofday = v1; zone = v2 } ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (Time.Ofday.bin_size_t v1) in
            Bin_prot.Common.( + ) size (Zone.bin_size_t v2)
        ;;

        let _ = bin_size_t

        let bin_write_t : t Bin_prot.Write.writer =
          fun buf ~pos -> function
          | { ofday = v1; zone = v2 } ->
            let pos = Time.Ofday.bin_write_t buf ~pos v1 in
            Zone.bin_write_t buf ~pos v2
        ;;

        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "time_functor.ml.before-ppx.Make.Ofday.Zoned.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          let v_ofday = Time.Ofday.bin_read_t buf ~pos_ref in
          let v_zone = Zone.bin_read_t buf ~pos_ref in
          { ofday = v_ofday; zone = v_zone }
        ;;

        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
        let zone _r__ = _r__.zone
        let _ = zone
        let ofday _r__ = _r__.ofday
        let _ = ofday

        let compare =
          (fun a__001_ b__002_ ->
             if Stdlib.( == ) a__001_ b__002_
             then 0
             else (
               match Time.Ofday.compare a__001_.ofday b__002_.ofday with
               | 0 -> Zone.compare a__001_.zone b__002_.zone
               | n -> n)
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__003_ b__004_ ->
             if Stdlib.( == ) a__003_ b__004_
             then true
             else
               Stdlib.( && )
                 (Time.Ofday.equal a__003_.ofday b__004_.ofday)
                 (Zone.equal a__003_.zone b__004_.zone)
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg ->
          let hsv =
            let hsv = hsv in
            Time.Ofday.hash_fold_t hsv arg.ofday
          in
          Zone.hash_fold_t hsv arg.zone
        ;;

        let _ = hash_fold_t

        let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func arg =
            Ppx_hash_lib.Std.Hash.get_hash_value
              (let hsv = Ppx_hash_lib.Std.Hash.create () in
               hash_fold_t hsv arg)
          in
          fun x -> func x
        ;;

        let _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      type sexp_repr = Time.Ofday.t * Zone.t [@@deriving sexp]

      include struct
        let _ = fun (_ : sexp_repr) -> ()

        let sexp_repr_of_sexp =
          (let error_source__011_ =
             "time_functor.ml.before-ppx.Make.Ofday.Zoned.sexp_repr"
           in
           function
           | Sexplib0.Sexp.List [ arg0__006_; arg1__007_ ] ->
             let res0__008_ = Time.Ofday.t_of_sexp arg0__006_
             and res1__009_ = Zone.t_of_sexp arg1__007_ in
             res0__008_, res1__009_
           | sexp__010_ ->
             Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
               error_source__011_
               2
               sexp__010_
           : Sexplib0.Sexp.t -> sexp_repr)
        ;;

        let _ = sexp_repr_of_sexp

        let sexp_of_sexp_repr =
          (fun (arg0__012_, arg1__013_) ->
             let res0__014_ = Time.Ofday.sexp_of_t arg0__012_
             and res1__015_ = Zone.sexp_of_t arg1__013_ in
             Sexplib0.Sexp.List [ res0__014_; res1__015_ ]
           : sexp_repr -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_sexp_repr
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let sexp_of_t t = (sexp_of_sexp_repr [@merlin.hide]) (t.ofday, t.zone)

      let t_of_sexp sexp =
        let ofday, zone = (sexp_repr_of_sexp [@merlin.hide]) sexp in
        { ofday; zone }
      ;;

      let to_time t date = Time.of_date_ofday ~zone:(zone t) date (ofday t)
      let create ofday zone = { ofday; zone }
      let create_local ofday = create ofday (Lazy.force Zone.local)

      let of_string string : t =
        match String.split string ~on:' ' with
        | [ ofday; zone ] ->
          { ofday = Time.Ofday.of_string ofday; zone = Zone.of_string zone }
        | _ -> failwithf "Ofday.Zoned.of_string %s" string ()
      ;;

      let to_string (t : t) : string =
        String.concat [ Time.Ofday.to_string t.ofday; " "; Zone.to_string t.zone ]
      ;;

      let to_string_trimmed (t : t) : string =
        String.concat [ Time.Ofday.to_string_trimmed t.ofday; " "; Zone.to_string t.zone ]
      ;;

      let arg_type = Core.Command.Arg_type.create of_string

      module With_nonchronological_compare = struct
        type nonrec t = t [@@deriving bin_io, compare, equal, sexp, hash]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "time_functor.ml.before-ppx:109:8")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t
          let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
          let _ = bin_size_t
          let bin_write_t : t Bin_prot.Write.writer = bin_write_t
          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t
          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
          let _ = __bin_read_t__
          let bin_read_t : t Bin_prot.Read.reader = bin_read_t
          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let compare =
            (fun a__016_ b__017_ -> compare a__016_ b__017_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__018_ b__019_ -> equal a__018_ b__019_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_t hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include Pretty_printer.Register (struct
          type nonrec t = t

          let to_string = to_string
          let module_name = "Time_float_unix.Ofday.Zoned"
        end)
    end
  end

  include (
    Time :
      module type of Time
      with module Zone := Time.Zone
       and module Ofday := Time.Ofday
       and module Span := Time.Span)

  let of_tm tm ~zone =
    let { Unix.tm_year
        ; tm_mon
        ; tm_mday
        ; tm_hour
        ; tm_min
        ; tm_sec
        ; tm_isdst = _
        ; tm_wday = _
        ; tm_yday = _
        }
      =
      tm
    in
    let date =
      Date.create_exn ~y:(tm_year + 1900) ~m:(Month.of_int_exn (tm_mon + 1)) ~d:tm_mday
    in
    let ofday = Ofday.create ~hr:tm_hour ~min:tm_min ~sec:tm_sec () in
    of_date_ofday ~zone date ofday
  ;;

  let of_date_ofday_zoned date ofday_zoned = Ofday.Zoned.to_time ofday_zoned date

  let to_date_ofday_zoned t ~zone =
    let date, ofday = to_date_ofday t ~zone in
    date, Ofday.Zoned.create ofday zone
  ;;

  let to_ofday_zoned t ~zone =
    let ofday = to_ofday t ~zone in
    Ofday.Zoned.create ofday zone
  ;;

  let of_string_fix_proto utc str =
    try
      let expect_length = 21 in
      let expect_dash = 8 in
      if Char.( <> ) str.[expect_dash] '-'
      then failwithf "no dash in position %d" expect_dash ();
      let zone =
        match utc with
        | `Utc -> Zone.utc
        | `Local -> Lazy.force Zone.local
      in
      if Int.( > ) (String.length str) expect_length then failwithf "input too long" ();
      of_date_ofday
        ~zone
        (Date.of_string_iso8601_basic str ~pos:0)
        (Ofday.of_string_iso8601_extended str ~pos:(expect_dash + 1))
    with
    | exn -> invalid_argf "Time.of_string_fix_proto %s: %s" str (Exn.to_string exn) ()
  ;;

  let to_string_fix_proto utc t =
    let zone =
      match utc with
      | `Utc -> Zone.utc
      | `Local -> Lazy.force Zone.local
    in
    let date, sec = to_date_ofday t ~zone in
    Date.to_string_iso8601_basic date ^ "-" ^ Ofday.to_millisecond_string sec
  ;;

  let format t s ~zone =
    let epoch_time =
      Span.to_sec
        (Date_and_ofday.to_synthetic_span_since_epoch
           (Zone.date_and_ofday_of_absolute_time zone t))
    in
    Unix.strftime (Unix.gmtime epoch_time) s
  ;;

  let parse ?allow_trailing_input s ~fmt ~zone =
    of_tm ~zone (Unix.strptime ?allow_trailing_input ~fmt s)
  ;;

  let pause_for span =
    let time_remaining =
      let span = Span.min span (Span.scale Span.day 100.) in
      Unix.nanosleep (Span.to_sec span)
    in
    if Float.( > ) time_remaining 0.0
    then `Remaining (Span.of_sec time_remaining)
    else `Ok
  ;;

  let rec pause span =
    match pause_for span with
    | `Remaining span -> pause span
    | `Ok -> ()
  [@@ocaml.doc " Pause and don't allow events to interrupt. "]
  ;;

  let interruptible_pause = pause_for
  [@@ocaml.doc " Pause but allow events to interrupt. "]
  ;;

  let rec pause_forever () =
    pause (Span.of_day 1.0);
    pause_forever ()
  ;;

  let to_string t = to_string_abs t ~zone:(Lazy.force Zone.local)

  let ensure_colon_in_offset offset =
    if Char.( = ) offset.[1] ':' || Char.( = ) offset.[2] ':'
    then offset
    else (
      let offset_length = String.length offset in
      if Int.( < ) offset_length 3 || Int.( > ) offset_length 4
      then failwithf "invalid offset %s" offset ()
      else
        String.concat
          [ String.slice offset 0 (offset_length - 2)
          ; ":"
          ; String.slice offset (offset_length - 2) offset_length
          ])
  ;;

  exception Time_string_not_absolute of string [@@deriving sexp]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add
        [%extension_constructor Time_string_not_absolute]
        (function
        | Time_string_not_absolute arg0__021_ ->
          let res0__022_ = sexp_of_string arg0__021_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom
                "time_functor.ml.before-ppx.Make.Time_string_not_absolute"
            ; res0__022_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_string_gen ~if_no_timezone s =
    let default_zone () =
      match if_no_timezone with
      | `Fail -> raise (Time_string_not_absolute s)
      | `Local -> Lazy.force Zone.local
      | `Use_this_one zone -> zone
    in
    of_string_gen ~default_zone ~find_zone:Zone.find_exn s
  ;;

  let of_string_abs s = of_string_gen ~if_no_timezone:`Fail s
  let of_string s = of_string_gen ~if_no_timezone:`Local s
  let arg_type = Core.Command.Arg_type.create of_string_abs

  include Pretty_printer.Register (struct
      type nonrec t = t

      let to_string = to_string
      let module_name = "Time_float_unix"
    end)

  let sexp_zone = ref Zone.local
  let get_sexp_zone () = Lazy.force !sexp_zone
  let set_sexp_zone zone = sexp_zone := lazy zone

  let t_of_sexp_gen ~if_no_timezone sexp =
    try
      match sexp with
      | Sexp.List [ Sexp.Atom date; Sexp.Atom ofday; Sexp.Atom tz ] ->
        of_date_ofday
          ~zone:(Zone.find_exn tz)
          (Date.of_string date)
          (Ofday.of_string ofday)
      | Sexp.List [ Sexp.Atom date; Sexp.Atom ofday_and_possibly_zone ] ->
        of_string_gen ~if_no_timezone (date ^ " " ^ ofday_and_possibly_zone)
      | Sexp.Atom datetime -> of_string_gen ~if_no_timezone datetime
      | _ -> of_sexp_error "Time.t_of_sexp" sexp
    with
    | Of_sexp_error _ as e -> raise e
    | e -> of_sexp_error (sprintf "Time.t_of_sexp: %s" (Exn.to_string e)) sexp
  ;;

  let t_of_sexp sexp =
    t_of_sexp_gen sexp ~if_no_timezone:(`Use_this_one (Lazy.force !sexp_zone))
  ;;

  let t_sexp_grammar : t Sexplib.Sexp_grammar.t =
    { untyped =
        Union
          [ String
          ; List (Cons (String, Cons (String, Empty)))
          ; List (Cons (String, Cons (String, Cons (String, Empty))))
          ]
    }
  ;;

  let t_of_sexp_abs sexp = t_of_sexp_gen sexp ~if_no_timezone:`Fail

  let sexp_of_t_abs t ~zone =
    Sexp.List (List.map (Time.to_string_abs_parts ~zone t) ~f:(fun s -> Sexp.Atom s))
  ;;

  let sexp_of_t t = sexp_of_t_abs ~zone:(Lazy.force !sexp_zone) t

  module type C =
    Comparable.Map_and_set_binable
    with type t := t
     and type comparator_witness := comparator_witness

  let make_comparable ?(sexp_of_t = sexp_of_t) ?(t_of_sexp = t_of_sexp) () : (module C) =
    (module struct
      module C = struct
        type nonrec t = t [@@deriving bin_io]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "time_functor.ml.before-ppx:329:8")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t
          let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
          let _ = bin_size_t
          let bin_write_t : t Bin_prot.Write.writer = bin_write_t
          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t
          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
          let _ = __bin_read_t__
          let bin_read_t : t Bin_prot.Read.reader = bin_read_t
          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        type nonrec comparator_witness = comparator_witness

        let comparator = comparator
        let sexp_of_t = sexp_of_t
        let t_of_sexp = t_of_sexp
      end

      include C
      module Map = Map.Make_binable_using_comparator (C)
      module Set = Set.Make_binable_using_comparator (C)
    end)
  ;;

  include
    (val make_comparable () ~t_of_sexp:(fun sexp ->
           match
             Option.try_with (fun () ->
               of_span_since_epoch (Span.of_sec (Float.t_of_sexp sexp)))
           with
           | Some t -> t
           | None -> t_of_sexp sexp))

  let () =
    Ppx_inline_test_lib.test
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<Set.equal (Set.of_list [epoch])   (Set.t_of_s[...]>>")
      ~tags:[]
      ~filename:"time_functor.ml.before-ppx"
      ~line_number:358
      ~start_pos:2
      ~end_pos:163
      (fun () ->
         Set.equal
           (Set.of_list [ epoch ])
           (Set.t_of_sexp
              (Sexp.List [ Float.sexp_of_t (Span.to_sec (to_span_since_epoch epoch)) ])))
  ;;

  include Hashable.Make_binable (struct
      type nonrec t = t [@@deriving bin_io, compare, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_functor.ml.before-ppx:366:4")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let compare =
          (fun a__023_ b__024_ -> compare a__023_ b__024_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

  module Exposed_for_tests = struct
    let ensure_colon_in_offset = ensure_colon_in_offset
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
