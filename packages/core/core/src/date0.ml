let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"date0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "date0.ml.before-ppx"
;;

open! Import
open Std_internal
open Digit_string_helpers

let is_leap_year ~year = (year mod 4 = 0 && not (year mod 100 = 0)) || year mod 400 = 0

module Stable = struct
  module V1 = struct
    module Without_comparable = struct
      module T : sig
        type t
        [@@immediate]
        [@@deriving bin_io ~localize, compare, equal, hash, typerep, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S_local with type t := t
          include Ppx_compare_lib.Comparable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
          include Typerep_lib.Typerepable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val create_exn : y:int -> m:Month.Stable.V1.t -> d:int -> t
        val year : t -> int
        val month : t -> Month.Stable.V1.t
        val day : t -> int
        val days_in_month : year:int -> month:Month.t -> int
        val to_int : t -> int
        val of_int_exn : int -> t
        val of_int_unchecked : int -> t
        val invalid_value__for_internal_use_only : t
      end = struct
        type t = int
        [@@deriving
          compare
        , equal
        , hash
        , typerep
        , bin_shape ~basetype:"899ee3e0-490a-11e6-a10a-a3734f733566"
        , stable_witness]

        include struct
          [@@@ocaml.warning "-60"]

          let _ = fun (_ : t) -> ()

          let compare =
            (fun a__001_ b__002_ -> compare_int a__001_ b__002_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__003_ b__004_ -> equal_int a__003_ b__004_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_int hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash_int in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash

          module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
              type nonrec t = t

              let name = "date0.ml.before-ppx.Stable.V1.Without_comparable.T.t"
              let _ = name
            end)

          let typename_of_t = Typename_of_t.typename_of_t
          let _ = typename_of_t

          let typerep_of_t =
            let name_of_t = Typename_of_t.named in
            Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_int))
          ;;

          let _ = typerep_of_t

          let bin_shape_t =
            (Bin_prot.Shape.basetype
               (Bin_prot.Shape.Uuid.of_string "899ee3e0-490a-11e6-a10a-a3734f733566"))
              []
          ;;

          let _ = bin_shape_t

          let stable_witness =
            (Ppx_stable_witness_runtime.Stable_witness.assert_stable
             : t Ppx_stable_witness_runtime.Stable_witness.t)

          and __stable_witness_checks_for_t__ () =
            let _ : int Ppx_stable_witness_runtime.Stable_witness.t =
              stable_witness_int
            in
            ()
          ;;

          let _ = stable_witness
          and _ = __stable_witness_checks_for_t__
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let create0 ~year ~month ~day =
          (year lsl 16) lor (Month.to_int month lsl 8) lor day
        ;;

        let of_int_unchecked t = t
        let year t = t lsr 16
        let month t = Month.of_int_exn ((t lsr 8) land 0xff)
        let day t = t land 0xff

        let days_in_month ~year ~month =
          match (month : Month.t) with
          | Jan | Mar | May | Jul | Aug | Oct | Dec -> 31
          | Apr | Jun | Sep | Nov -> 30
          | Feb -> if is_leap_year ~year then 29 else 28
        ;;

        let create_exn ~y:year ~m:month ~d:day =
          let invalid ~year ~month ~day msg =
            invalid_argf
              ((Format
                  ( String_literal
                      ( "Date.create_exn ~y:"
                      , Int
                          ( Int_d
                          , No_padding
                          , No_precision
                          , String_literal
                              ( " ~m:"
                              , Custom
                                  ( Custom_succ Custom_zero
                                  , (fun () _custom_printf__005_ ->
                                      Month.to_string _custom_printf__005_)
                                  , String_literal
                                      ( " ~d:"
                                      , Int
                                          ( Int_d
                                          , No_padding
                                          , No_precision
                                          , String_literal
                                              ( " error: "
                                              , String (No_padding, End_of_format) ) ) )
                                  ) ) ) )
                  , "Date.create_exn ~y:%d ~m:%{Month} ~d:%d error: %s" )
               : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
               [@merlin.hide])
              year
              month
              day
              msg
              ()
          in
          if year < 0 || year > 9999
          then invalid ~year ~month ~day "year outside of [0..9999]";
          if day <= 0 then invalid ~year ~month ~day "day <= 0";
          let days_in_month = days_in_month ~year ~month in
          if day > days_in_month
          then invalid ~year ~month ~day (sprintf "%d day month violation" days_in_month);
          create0 ~year ~month ~day
        ;;

        let bin_read_t buf ~pos_ref =
          let year = Int.bin_read_t buf ~pos_ref in
          let month = Month.Stable.V1.bin_read_t buf ~pos_ref in
          let day = Int.bin_read_t buf ~pos_ref in
          create0 ~year ~month ~day
        ;;

        let __bin_read_t__ _buf ~pos_ref =
          Bin_prot.Common.raise_variant_wrong_type "Date.t" !pos_ref
        ;;

        let bin_reader_t =
          { Bin_prot.Type_class.read = bin_read_t; vtag_read = __bin_read_t__ }
        ;;

        let bin_size_t__local t =
          Int.bin_size_t (year t) + Month.bin_size_t (month t) + Int.bin_size_t (day t)
        ;;

        let bin_size_t t = bin_size_t__local t

        let bin_write_t__local buf ~pos t =
          let pos = Int.bin_write_t buf ~pos (year t) in
          let pos = Month.bin_write_t buf ~pos (month t) in
          Int.bin_write_t buf ~pos (day t)
        ;;

        let bin_write_t buf ~pos t = bin_write_t__local buf ~pos t
        let bin_writer_t = { Bin_prot.Type_class.size = bin_size_t; write = bin_write_t }

        let bin_t =
          { Bin_prot.Type_class.reader = bin_reader_t
          ; writer = bin_writer_t
          ; shape = bin_shape_t
          }
        ;;

        let to_int t = t
        let of_int_exn n = create_exn ~y:(year n) ~m:(month n) ~d:(day n)
        let invalid_value__for_internal_use_only = 0

        let () =
          Ppx_inline_test_lib.test
            ~config:(module Inline_test_config)
            ~descr:(lazy "invalid value")
            ~tags:[]
            ~filename:"date0.ml.before-ppx"
            ~line_number:134
            ~start_pos:8
            ~end_pos:123
            (fun () ->
               Exn.does_raise (fun () : t ->
                 of_int_exn invalid_value__for_internal_use_only))
        ;;
      end

      include T

      let to_string_iso8601_extended t =
        let buf = Bytes.create 10 in
        write_4_digit_int buf ~pos:0 (year t);
        Bytes.set buf 4 '-';
        write_2_digit_int buf ~pos:5 (Month.to_int (month t));
        Bytes.set buf 7 '-';
        write_2_digit_int buf ~pos:8 (day t);
        Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf
      [@@ocaml.doc " YYYY-MM-DD "]
      ;;

      let to_string = to_string_iso8601_extended

      let to_string_iso8601_basic t =
        let buf = Bytes.create 8 in
        write_4_digit_int buf ~pos:0 (year t);
        write_2_digit_int buf ~pos:4 (Month.to_int (month t));
        write_2_digit_int buf ~pos:6 (day t);
        Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf
      [@@ocaml.doc " YYYYMMDD "]
      ;;

      let to_string_american t =
        let buf = Bytes.create 10 in
        write_2_digit_int buf ~pos:0 (Month.to_int (month t));
        Bytes.set buf 2 '/';
        write_2_digit_int buf ~pos:3 (day t);
        Bytes.set buf 5 '/';
        write_4_digit_int buf ~pos:6 (year t);
        Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf
      [@@ocaml.doc " MM/DD/YYYY "]
      ;;

      let parse_year4 str pos = read_4_digit_int str ~pos
      let parse_month str pos = Month.of_int_exn (read_2_digit_int str ~pos)
      let parse_day str pos = read_2_digit_int str ~pos

      let of_string_iso8601_basic str ~pos =
        if pos + 8 > String.length str
        then invalid_arg "Date.of_string_iso8601_basic: pos + 8 > string length";
        create_exn
          ~y:(parse_year4 str pos)
          ~m:(parse_month str (pos + 4))
          ~d:(parse_day str (pos + 6))
      [@@ocaml.doc " YYYYMMDD "]
      ;;

      let of_string s =
        let invalid () = failwith ("invalid date: " ^ s) in
        let ensure b = if not b then invalid () in
        let month_num ~year ~month ~day =
          create_exn ~y:(parse_year4 s year) ~m:(parse_month s month) ~d:(parse_day s day)
        in
        let month_abrv ~year ~month ~day =
          create_exn
            ~y:(parse_year4 s year)
            ~m:(Month.of_string (String.sub s ~pos:month ~len:3))
            ~d:(parse_day s day)
        in
        if String.contains s '/'
        then (
          let y, m, d =
            match String.split s ~on:'/' with
            | [ a; b; c ] -> if String.length a = 4 then a, b, c else c, a, b
            | _ -> invalid ()
          in
          let year = Int.of_string y in
          let year =
            if year >= 100 then year else if year < 75 then 2000 + year else 1900 + year
          in
          let month = Month.of_int_exn (Int.of_string m) in
          let day = Int.of_string d in
          create_exn ~y:year ~m:month ~d:day)
        else if String.contains s '-'
        then (
          ensure (String.length s = 10 && Char.( = ) s.[4] '-' && Char.( = ) s.[7] '-');
          month_num ~year:0 ~month:5 ~day:8)
        else if String.contains s ' '
        then
          if String.length s = 11 && Char.( = ) s.[2] ' ' && Char.( = ) s.[6] ' '
          then month_abrv ~day:0 ~month:3 ~year:7
          else (
            ensure (String.length s = 11 && Char.( = ) s.[4] ' ' && Char.( = ) s.[8] ' ');
            month_abrv ~day:9 ~month:5 ~year:0)
        else if String.length s = 9
        then month_abrv ~day:0 ~month:2 ~year:5
        else if String.length s = 8
        then month_num ~year:0 ~month:4 ~day:6
        else invalid ()
      ;;

      let of_string s =
        try of_string s with
        | exn -> invalid_argf "Date.of_string (%s): %s" s (Exn.to_string exn) ()
      ;;

      module Sexpable = struct
        module Old_date = struct
          type t =
            { y : int
            ; m : int
            ; d : int
            }
          [@@deriving sexp]

          include struct
            let _ = fun (_ : t) -> ()

            let t_of_sexp =
              (let error_source__007_ =
                 "date0.ml.before-ppx.Stable.V1.Without_comparable.Sexpable.Old_date.t"
               in
               fun x__008_ ->
                 Sexplib0.Sexp_conv_record.record_of_sexp
                   ~caller:error_source__007_
                   ~fields:
                     (Field
                        { name = "y"
                        ; kind = Required
                        ; conv = int_of_sexp
                        ; rest =
                            Field
                              { name = "m"
                              ; kind = Required
                              ; conv = int_of_sexp
                              ; rest =
                                  Field
                                    { name = "d"
                                    ; kind = Required
                                    ; conv = int_of_sexp
                                    ; rest = Empty
                                    }
                              }
                        })
                   ~index_of_field:(function
                     | "y" -> 0
                     | "m" -> 1
                     | "d" -> 2
                     | _ -> -1)
                   ~allow_extra_fields:false
                   ~create:(fun (y, (m, (d, ()))) -> ({ y; m; d } : t))
                   x__008_
               : Sexplib0.Sexp.t -> t)
            ;;

            let _ = t_of_sexp

            let sexp_of_t =
              (fun { y = y__010_; m = m__012_; d = d__014_ } ->
                 let bnds__009_ = ([] : _ Stdlib.List.t) in
                 let bnds__009_ =
                   let arg__015_ = sexp_of_int d__014_ in
                   (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "d"; arg__015_ ] :: bnds__009_
                    : _ Stdlib.List.t)
                 in
                 let bnds__009_ =
                   let arg__013_ = sexp_of_int m__012_ in
                   (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "m"; arg__013_ ] :: bnds__009_
                    : _ Stdlib.List.t)
                 in
                 let bnds__009_ =
                   let arg__011_ = sexp_of_int y__010_ in
                   (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "y"; arg__011_ ] :: bnds__009_
                    : _ Stdlib.List.t)
                 in
                 Sexplib0.Sexp.List bnds__009_
               : t -> Sexplib0.Sexp.t)
            ;;

            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          let to_date t = T.create_exn ~y:t.y ~m:(Month.of_int_exn t.m) ~d:t.d
        end

        let t_of_sexp = function
          | Sexp.Atom s -> of_string s
          | Sexp.List _ as sexp -> Old_date.to_date (Old_date.t_of_sexp sexp)
        ;;

        let t_of_sexp s =
          try t_of_sexp s with
          | Of_sexp_error _ as exn -> raise exn
          | Invalid_argument a -> of_sexp_error a s
        ;;

        let sexp_of_t t = Sexp.Atom (to_string t)

        let t_sexp_grammar =
          let open Sexplib in
          Sexp_grammar.tag
            (Sexp_grammar.coerce String.t_sexp_grammar : t Sexp_grammar.t)
            ~key:Sexp_grammar.type_name_tag
            ~value:(Atom "Core.Date.t")
        ;;
      end

      include Sexpable
      include (val Comparator.Stable.V1.make ~compare ~sexp_of_t)
    end

    include Without_comparable
    include Comparable.Stable.V1.With_stable_witness.Make (Without_comparable)
    include Hashable.Stable.V1.With_stable_witness.Make (Without_comparable)
    include Diffable.Atomic.Make (Without_comparable)
  end

  module Option = struct
    module V1 = struct
      type t = int
      [@@deriving
        bin_io ~localize
      , bin_shape ~basetype:"826a3e79-3321-451a-9707-ed6c03b84e2f"
      , compare
      , equal
      , hash
      , typerep
      , stable_witness]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "date0.ml.before-ppx:291:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_int ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_int__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_int__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_int__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_int
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

        let bin_shape_t =
          (Bin_prot.Shape.basetype
             (Bin_prot.Shape.Uuid.of_string "826a3e79-3321-451a-9707-ed6c03b84e2f"))
            []
        ;;

        let _ = bin_shape_t

        let compare =
          (fun a__016_ b__017_ -> compare_int a__016_ b__017_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__018_ b__019_ -> equal_int a__018_ b__019_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_int hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash_int in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "date0.ml.before-ppx.Stable.Option.V1.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_int))
        ;;

        let _ = typerep_of_t

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : int Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_int in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let none =
        let open V1 in
        to_int invalid_value__for_internal_use_only
      ;;

      let is_none t = t = none
      let is_some t = not (is_none t)
      let some_is_representable _ = true
      let some t = V1.to_int t
      let unchecked_value = V1.of_int_unchecked
      let to_option t = if is_some t then Some (unchecked_value t) else None

      let of_option opt =
        match opt with
        | None -> none
        | Some v -> some v
      ;;

      let value_exn t =
        if is_some t
        then unchecked_value t
        else
          raise_s
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Conv.sexp_of_string "date0.ml.before-ppx:318:31"
                 ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Date.Option.value_exn none"
                 ]
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
      ;;

      let value t ~default = Bool.select (is_none t) default (unchecked_value t)
      let sexp_of_t t = Option.sexp_of_t V1.sexp_of_t (to_option t)
      let t_of_sexp sexp = of_option ((Option.t_of_sexp V1.t_of_sexp) sexp)

      let t_sexp_grammar =
        Sexplib.Sexp_grammar.coerce
          ((Option.t_sexp_grammar V1.t_sexp_grammar
           : V1.t Option.t Sexplib0.Sexp_grammar.t)
           [@merlin.hide])
      ;;

      let of_int_exn t = if t = none then none else some (V1.of_int_exn t)
      let to_int t = t
    end
  end
end

module Without_comparable = Stable.V1.Without_comparable
include Without_comparable
module C = Comparable.Make_binable_using_comparator (Without_comparable)
include C

include Diffable.Atomic.Make (struct
    include Without_comparable
    include C
  end)

module O = struct
  include (C : Comparable.Infix with type t := t)
end

include (
  Hashable.Make_binable (struct
    include T
    include Sexpable
    include Binable

    let compare (a : t) (b : t) = compare a b
  end) :
    Hashable.S_binable with type t := t)

include Pretty_printer.Register (struct
    type nonrec t = t

    let module_name = "Core.Date"
    let to_string = to_string
  end)

let unix_epoch = create_exn ~y:1970 ~m:Jan ~d:1

module Days : sig
    type date = t
    type t [@@immediate]

    val of_date : date -> t
    val to_date : t -> date
    val diff : t -> t -> int
    val add_days : t -> int -> t
    val unix_epoch : t
  end
  with type date := t = struct
  open Int

  type t = int

  let of_year y = (365 * y) + (y / 4) - (y / 100) + (y / 400)

  let of_date date =
    let m = (Month.to_int (month date) + 9) % 12 in
    let y = year date - (m / 10) in
    of_year y + (((m * 306) + 5) / 10) + (day date - 1)
  ;;

  let c_10_000 = Int63.of_int 10_000
  let c_14_780 = Int63.of_int 14_780
  let c_3_652_425 = Int63.of_int 3_652_425

  let to_date days =
    let y =
      let open Int63 in
      to_int_exn (((c_10_000 * of_int days) + c_14_780) / c_3_652_425)
    in
    let ddd = days - of_year y in
    let y, ddd =
      if ddd < 0
      then (
        let y = y - 1 in
        y, days - of_year y)
      else y, ddd
    in
    let mi = ((100 * ddd) + 52) / 3_060 in
    let y = y + ((mi + 2) / 12) in
    let m = ((mi + 2) % 12) + 1 in
    let d = ddd - (((mi * 306) + 5) / 10) + 1 in
    create_exn ~y ~m:(Month.of_int_exn m) ~d
  ;;

  let unix_epoch = of_date unix_epoch
  let add_days t days = t + days
  let diff t1 t2 = t1 - t2
end

let add_days t days = Days.to_date (Days.add_days (Days.of_date t) days)
let diff t1 t2 = Days.diff (Days.of_date t1) (Days.of_date t2)

let add_months t n =
  let total_months = Month.to_int (month t) + n in
  let y = year t + (total_months /% 12) in
  let m = total_months % 12 in
  let y, m = if Int.( = ) m 0 then y - 1, m + 12 else y, m in
  let m = Month.of_int_exn m in
  let rec try_create d =
    try create_exn ~y ~m ~d with
    | _exn ->
      assert (Int.( >= ) d 1);
      try_create (d - 1)
  in
  try_create (day t)
;;

let add_years t n = add_months t (n * 12)

let day_of_week =
  let table = [| 0; 3; 2; 5; 0; 3; 5; 1; 4; 6; 2; 4 |] in
  fun t ->
    let m = Month.to_int (month t) in
    let y = if Int.( < ) m 3 then year t - 1 else year t in
    Day_of_week.of_int_exn
      ((y + (y / 4) - (y / 100) + (y / 400) + table.(m - 1) + day t) % 7)
;;

let non_leap_year_table = [| 0; 31; 59; 90; 120; 151; 181; 212; 243; 273; 304; 334 |]
let leap_year_table = [| 0; 31; 60; 91; 121; 152; 182; 213; 244; 274; 305; 335 |]

let ordinal_date t =
  let table =
    if is_leap_year ~year:(year t) then leap_year_table else non_leap_year_table
  in
  let offset = table.(Month.to_int (month t) - 1) in
  day t + offset
;;

let last_week_of_year y =
  let first_of_year = create_exn ~y ~m:Jan ~d:1 in
  let is t day = Day_of_week.equal (day_of_week t) day in
  if is first_of_year Thu || (is_leap_year ~year:y && is first_of_year Wed)
  then 53
  else 52
;;

let call_with_week_and_year t ~f =
  let ordinal = ordinal_date t in
  let weekday = Day_of_week.iso_8601_weekday_number (day_of_week t) in
  let week = (ordinal - weekday + 10) / 7 in
  let year = year t in
  if Int.( < ) week 1
  then f ~week:(last_week_of_year (year - 1)) ~year:(year - 1)
  else if Int.( > ) week (last_week_of_year year)
  then f ~week:1 ~year:(year + 1)
  else f ~week ~year
;;

let week_number_and_year t = call_with_week_and_year t ~f:(fun ~week ~year -> week, year)
let week_number t = call_with_week_and_year t ~f:(fun ~week ~year:_ -> week)
let is_weekend t = Day_of_week.is_sun_or_sat (day_of_week t)
let is_weekday t = not (is_weekend t)
let is_business_day t ~is_holiday = is_weekday t && not (is_holiday t)

let rec diff_weekend_days t1 t2 =
  if t1 < t2
  then -diff_weekend_days t2 t1
  else (
    let diff = diff t1 t2 in
    let d1 = day_of_week t1 in
    let d2 = day_of_week t2 in
    let num_satsun_crossings =
      if Int.( < ) (Day_of_week.to_int d1) (Day_of_week.to_int d2)
      then 1 + (diff / 7)
      else diff / 7
    in
    (num_satsun_crossings * 2)
    + (if Day_of_week.( = ) d2 Day_of_week.Sun then 1 else 0)
    + if Day_of_week.( = ) d1 Day_of_week.Sun then -1 else 0)
;;

let diff_weekdays t1 t2 = diff t1 t2 - diff_weekend_days t1 t2

let add_days_skipping t ~skip n =
  let step = if Int.( >= ) n 0 then 1 else -1 in
  let rec loop t k =
    let t_next = add_days t step in
    if skip t then loop t_next k else if Int.( = ) k 0 then t else loop t_next (k - 1)
  in
  loop t (abs n)
;;

let rec first_day_satisfying t ~step ~condition =
  if condition t then t else first_day_satisfying (add_days t step) ~step ~condition
;;

let next_day_satisfying t ~step ~condition =
  let next_day = add_days t step in
  first_day_satisfying next_day ~step ~condition
;;

let following_weekday t = next_day_satisfying t ~step:1 ~condition:is_weekday
let previous_weekday t = next_day_satisfying t ~step:(-1) ~condition:is_weekday
let round_forward_to_weekday t = first_day_satisfying t ~step:1 ~condition:is_weekday
let round_backward_to_weekday t = first_day_satisfying t ~step:(-1) ~condition:is_weekday

let round_forward_to_business_day t ~is_holiday =
  first_day_satisfying t ~step:1 ~condition:(is_business_day ~is_holiday)
;;

let round_backward_to_business_day t ~is_holiday =
  first_day_satisfying t ~step:(-1) ~condition:(is_business_day ~is_holiday)
;;

let add_weekdays t n = add_days_skipping t ~skip:is_weekend n
let add_weekdays_rounding_in_direction_of_step = add_weekdays

let add_weekdays_rounding_forward t n =
  add_days_skipping (round_forward_to_weekday t) ~skip:is_weekend n
;;

let add_weekdays_rounding_backward t n =
  add_days_skipping (round_backward_to_weekday t) ~skip:is_weekend n
;;

let add_business_days t ~is_holiday n =
  add_days_skipping t n ~skip:(fun d -> is_weekend d || is_holiday d)
;;

let add_business_days_rounding_in_direction_of_step = add_business_days

let add_business_days_rounding_forward t ~is_holiday n =
  add_days_skipping (round_forward_to_business_day ~is_holiday t) n ~skip:(fun d ->
    not (is_business_day ~is_holiday d))
;;

let add_business_days_rounding_backward t ~is_holiday n =
  add_days_skipping (round_backward_to_business_day ~is_holiday t) n ~skip:(fun d ->
    not (is_business_day ~is_holiday d))
;;

let dates_between ~min:t1 ~max:t2 =
  let rec loop t l = if t < t1 then l else loop (add_days t (-1)) (t :: l) in
  loop t2 []
;;

let weekdays_between ~min ~max =
  let all_dates = dates_between ~min ~max in
  Option.value_map (List.hd all_dates) ~default:[] ~f:(fun first_date ->
    let first_weekday = day_of_week first_date in
    let date_and_weekdays =
      List.mapi all_dates ~f:(fun i date -> date, Day_of_week.shift first_weekday i)
    in
    List.filter_map date_and_weekdays ~f:(fun (date, weekday) ->
      if Day_of_week.is_sun_or_sat weekday then None else Some date))
;;

let business_dates_between ~min ~max ~is_holiday =
  List.filter ~f:(fun d -> not (is_holiday d)) (weekdays_between ~min ~max)
;;

let first_strictly_after t ~on:dow =
  let dow = Day_of_week.to_int dow in
  let tplus1 = add_days t 1 in
  let cur = Day_of_week.to_int (day_of_week tplus1) in
  let diff = (dow + 7 - cur) mod 7 in
  add_days tplus1 diff
;;

module For_quickcheck = struct
  open Quickcheck

  let gen_uniform_incl d1 d2 =
    if d1 > d2
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Date.gen_uniform_incl: bounds are crossed"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lower_bound"
                 ; (sexp_of_t [@merlin.hide]) d1
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "upper_bound"
                 ; (sexp_of_t [@merlin.hide]) d2
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    Generator.map (Int.gen_uniform_incl 0 (diff d2 d1)) ~f:(fun days -> add_days d1 days)
  ;;

  let gen_incl d1 d2 =
    Generator.weighted_union
      [ 1., Generator.return d1; 1., Generator.return d2; 18., gen_uniform_incl d1 d2 ]
  ;;

  let quickcheck_generator = gen_incl (of_string "1900-01-01") (of_string "2100-01-01")
  let quickcheck_observer = Observer.create (fun t ~size:_ ~hash -> hash_fold_t hash t)
  let quickcheck_shrinker = Shrinker.empty ()
end

let quickcheck_generator = For_quickcheck.quickcheck_generator
let gen_incl = For_quickcheck.gen_incl
let gen_uniform_incl = For_quickcheck.gen_uniform_incl
let quickcheck_observer = For_quickcheck.quickcheck_observer
let quickcheck_shrinker = For_quickcheck.quickcheck_shrinker

module Private = struct
  let leap_year_table = leap_year_table
  let non_leap_year_table = non_leap_year_table
  let ordinal_date = ordinal_date
end

module Option = struct
  module Stable = Stable.Option
  include Stable.V1

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unchecked_value
    end
  end

  let quickcheck_generator =
    Quickcheck.Generator.map
      (Option.quickcheck_generator quickcheck_generator)
      ~f:of_option
  ;;

  let quickcheck_shrinker =
    Quickcheck.Shrinker.map
      (Option.quickcheck_shrinker quickcheck_shrinker)
      ~f:of_option
      ~f_inverse:to_option
  ;;

  let quickcheck_observer =
    Quickcheck.Observer.of_hash
      (module struct
        type nonrec t = t [@@deriving hash]

        include struct
          let _ = fun (_ : t) -> ()

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
      end)
  ;;

  include Comparable.Make_plain (struct
      type nonrec t = t [@@deriving compare, sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__020_ b__021_ -> compare a__020_ b__021_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
