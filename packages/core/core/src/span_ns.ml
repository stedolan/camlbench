let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"span_ns.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "span_ns.ml.before-ppx"
;;

open! Import
open Std_internal
open! Int63.O
module Rounding_direction = Time_ns_intf.Rounding_direction

let module_name = "Core.Time_ns.Span"

type underlying = Int63.t

let arch_sixtyfour = Int.equal Sys.word_size_in_bits 64
let round_nearest_ns = Float.int63_round_nearest_exn
let float x = Int63.to_float x [@@inline]

module T = struct
  type t = Int63.t [@@deriving hash, bin_io, quickcheck, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Int63.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int63.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:16:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], Int63.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = Int63.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = Int63.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Int63.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = Int63.bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t
    let quickcheck_generator = Int63.quickcheck_generator
    let _ = quickcheck_generator
    let quickcheck_observer = Int63.quickcheck_observer
    let _ = quickcheck_observer
    let quickcheck_shrinker = Int63.quickcheck_shrinker
    let _ = quickcheck_shrinker

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "span_ns.ml.before-ppx.T.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Int63.typerep_of_t))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Replace_polymorphic_compare = Int63.Replace_polymorphic_compare

  let zero = Int63.zero
end

include T
open Replace_polymorphic_compare

module Parts = struct
  type t =
    { sign : Sign.t
    ; hr : int
    ; min : int
    ; sec : int
    ; ms : int
    ; us : int
    ; ns : int
    }
  [@@deriving compare, sexp, sexp_grammar]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ ->
         if Stdlib.( == ) a__001_ b__002_
         then 0
         else (
           match Sign.compare a__001_.sign b__002_.sign with
           | 0 ->
             (match compare_int a__001_.hr b__002_.hr with
              | 0 ->
                (match compare_int a__001_.min b__002_.min with
                 | 0 ->
                   (match compare_int a__001_.sec b__002_.sec with
                    | 0 ->
                      (match compare_int a__001_.ms b__002_.ms with
                       | 0 ->
                         (match compare_int a__001_.us b__002_.us with
                          | 0 -> compare_int a__001_.ns b__002_.ns
                          | n -> n)
                       | n -> n)
                    | n -> n)
                 | n -> n)
              | n -> n)
           | n -> n)
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (let error_source__004_ = "span_ns.ml.before-ppx.Parts.t" in
       fun x__005_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__004_
           ~fields:
             (Field
                { name = "sign"
                ; kind = Required
                ; conv = Sign.t_of_sexp
                ; rest =
                    Field
                      { name = "hr"
                      ; kind = Required
                      ; conv = int_of_sexp
                      ; rest =
                          Field
                            { name = "min"
                            ; kind = Required
                            ; conv = int_of_sexp
                            ; rest =
                                Field
                                  { name = "sec"
                                  ; kind = Required
                                  ; conv = int_of_sexp
                                  ; rest =
                                      Field
                                        { name = "ms"
                                        ; kind = Required
                                        ; conv = int_of_sexp
                                        ; rest =
                                            Field
                                              { name = "us"
                                              ; kind = Required
                                              ; conv = int_of_sexp
                                              ; rest =
                                                  Field
                                                    { name = "ns"
                                                    ; kind = Required
                                                    ; conv = int_of_sexp
                                                    ; rest = Empty
                                                    }
                                              }
                                        }
                                  }
                            }
                      }
                })
           ~index_of_field:(function
             | "sign" -> 0
             | "hr" -> 1
             | "min" -> 2
             | "sec" -> 3
             | "ms" -> 4
             | "us" -> 5
             | "ns" -> 6
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (sign, (hr, (min, (sec, (ms, (us, (ns, ()))))))) ->
             ({ sign; hr; min; sec; ms; us; ns } : t))
           x__005_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { sign = sign__007_
           ; hr = hr__009_
           ; min = min__011_
           ; sec = sec__013_
           ; ms = ms__015_
           ; us = us__017_
           ; ns = ns__019_
           } ->
         let bnds__006_ = ([] : _ Stdlib.List.t) in
         let bnds__006_ =
           let arg__020_ = sexp_of_int ns__019_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ns"; arg__020_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__018_ = sexp_of_int us__017_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "us"; arg__018_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__016_ = sexp_of_int ms__015_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "ms"; arg__016_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__014_ = sexp_of_int sec__013_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sec"; arg__014_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__012_ = sexp_of_int min__011_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "min"; arg__012_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__010_ = sexp_of_int hr__009_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hr"; arg__010_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         let bnds__006_ =
           let arg__008_ = Sign.sexp_of_t sign__007_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sign"; arg__008_ ] :: bnds__006_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__006_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
      { untyped =
          Lazy
            (lazy
              (List
                 (Fields
                    { allow_extra_fields = false
                    ; fields =
                        [ No_tag
                            { name = "sign"
                            ; required = true
                            ; args = Cons (Sign.t_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "hr"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "min"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "sec"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "ms"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "us"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ; No_tag
                            { name = "ns"
                            ; required = true
                            ; args = Cons (int_sexp_grammar.untyped, Empty)
                            }
                        ]
                    })))
      }
    ;;

    let _ = t_sexp_grammar
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let next t = Int63.succ t
let prev t = Int63.pred t
let nanosecond = Int63.of_int 1

let microsecond =
  let open Int63 in
  of_int 1000 * nanosecond
;;

let millisecond =
  let open Int63 in
  of_int 1000 * microsecond
;;

let second =
  let open Int63 in
  of_int 1000 * millisecond
;;

let minute =
  let open Int63 in
  of_int 60 * second
;;

let hour =
  let open Int63 in
  of_int 60 * minute
;;

let day =
  let open Int63 in
  of_int 24 * hour
;;

let float_microsecond = float microsecond
let float_millisecond = float millisecond
let float_second = float second
let float_minute = float minute
let float_hour = float hour
let float_day = float day
let ns_per_us = 1. /. float_microsecond
let ns_per_ms = 1. /. float_millisecond
let ns_per_sec = 1. /. float_second
let ns_per_min = 1. /. float_minute
let ns_per_hr = 1. /. float_hour
let ns_per_day = 1. /. float_day

let max_value_for_1us_rounding =
  let open Int63 in
  of_int 135 * of_int 365 * day
;;

let min_value_for_1us_rounding = Int63.neg max_value_for_1us_rounding

let create
      ?sign:(sign_ = Sign.Pos)
      ?day:(days = 0)
      ?(hr = 0)
      ?min:(minutes = 0)
      ?(sec = 0)
      ?(ms = 0)
      ?(us = 0)
      ?(ns = 0)
      ()
  =
  let open Int63 in
  let t =
    (of_int days * day)
    + (of_int hr * hour)
    + (of_int minutes * minute)
    + (of_int sec * second)
    + (of_int ms * millisecond)
    + (of_int us * microsecond)
    + (of_int ns * nanosecond)
  in
  match sign_ with
  | Neg -> neg t
  | Pos | Zero -> t
;;

let to_parts t =
  let open Int63 in
  let mag = abs t in
  { Parts.sign = (if t < zero then Neg else if t > zero then Pos else Zero)
  ; hr = to_int_exn (mag / hour)
  ; min = to_int_exn (rem mag hour / minute)
  ; sec = to_int_exn (rem mag minute / second)
  ; ms = to_int_exn (rem mag second / millisecond)
  ; us = to_int_exn (rem mag millisecond / microsecond)
  ; ns = to_int_exn (rem mag microsecond / nanosecond)
  }
;;

let of_parts { Parts.sign; hr; min; sec; ms; us; ns } =
  create ~sign ~hr ~min ~sec ~ms ~us ~ns ()
;;

let of_ns f = round_nearest_ns f
let of_int63_ns i = i

let of_int_us i =
  let open Int63 in
  of_int i * microsecond
;;

let of_int_ms i =
  let open Int63 in
  of_int i * millisecond
;;

let of_int_sec i =
  let open Int63 in
  of_int i * second
;;

let of_int_min i =
  let open Int63 in
  of_int i * minute
;;

let of_int_hr i =
  let open Int63 in
  of_int i * hour
;;

let of_int_day i =
  let open Int63 in
  of_int i * day
;;

let of_us f = round_nearest_ns (f *. float_microsecond)
let of_ms f = round_nearest_ns (f *. float_millisecond)
let of_sec f = round_nearest_ns (f *. float_second) [@@inline]
let of_min f = round_nearest_ns (f *. float_minute)
let of_hr f = round_nearest_ns (f *. float_hour)
let of_day f = round_nearest_ns (f *. float_day)

let of_sec_with_microsecond_precision sec =
  let us = round_nearest_ns (sec *. 1e6) in
  of_int63_ns
    (let open Int63 in
     us * of_int 1000)
;;

let of_int63_seconds x = x * second
let of_int32_seconds x = of_int63_seconds (Int63.of_int32 x)
let to_ns t = float t
let to_int63_ns t = t
let to_us t = float t /. float_microsecond [@@inline]
let to_ms t = float t /. float_millisecond [@@inline]
let to_sec t = float t /. float_second [@@inline]
let to_min t = float t /. float_minute [@@inline]
let to_hr t = float t /. float_hour [@@inline]
let to_day t = float t /. float_day [@@inline]
let to_us_approx t = float t *. ns_per_us [@@inline]
let to_ms_approx t = float t *. ns_per_ms [@@inline]
let to_sec_approx t = float t *. ns_per_sec [@@inline]
let to_min_approx t = float t *. ns_per_min [@@inline]
let to_hr_approx t = float t *. ns_per_hr [@@inline]
let to_day_approx t = float t *. ns_per_day [@@inline]

let to_int_us t =
  let open Int63 in
  to_int_exn (t / microsecond)
;;

let to_int_ms t =
  let open Int63 in
  to_int_exn (t / millisecond)
;;

let to_int_sec t =
  let open Int63 in
  to_int_exn (t / second)
;;

let to_int63_seconds_round_down_exn t = t /% second
let of_int_ns i = of_int63_ns (Int63.of_int i)

let to_int_ns =
  if arch_sixtyfour
  then fun t -> Int63.to_int_exn (to_int63_ns t)
  else fun _ -> failwith "Time_ns.Span.to_int_ns: unsupported on 32bit machines"
;;

let ( + ) t u = Int63.( + ) t u
let ( - ) t u = Int63.( - ) t u
let abs = Int63.abs
let neg = Int63.neg
let scale t f = round_nearest_ns (float t *. f)
let scale_int63 t i = Int63.( * ) t i
let scale_int t i = scale_int63 t (Int63.of_int i)
let div = Int63.( /% )
let ( / ) t f = round_nearest_ns (float t /. f)
let ( // ) = Int63.( // )
let to_proportional_float t = Int63.to_float t

let of_unit_of_time u =
  match (u : Unit_of_time.t) with
  | Nanosecond -> nanosecond
  | Microsecond -> microsecond
  | Millisecond -> millisecond
  | Second -> second
  | Minute -> minute
  | Hour -> hour
  | Day -> day
;;

let to_unit_of_time t : Unit_of_time.t =
  let abs_t = abs t in
  if abs_t >= day
  then Day
  else if abs_t >= hour
  then Hour
  else if abs_t >= minute
  then Minute
  else if abs_t >= second
  then Second
  else if abs_t >= millisecond
  then Millisecond
  else if abs_t >= microsecond
  then Microsecond
  else Nanosecond
;;

let to_span_float_round_nearest t = Span_float.of_sec (to_sec t)
let of_span_float_round_nearest s = of_sec (Span_float.to_sec s) [@@inline]
let round_up t ~to_multiple_of = Int63.round_up ~to_multiple_of t
let round_down t ~to_multiple_of = Int63.round_down ~to_multiple_of t
let round_nearest t ~to_multiple_of = Int63.round_nearest ~to_multiple_of t
let round_towards_zero t ~to_multiple_of = Int63.round_towards_zero ~to_multiple_of t

let round t ~dir ~to_multiple_of =
  match (dir : Rounding_direction.t) with
  | Nearest -> round_nearest t ~to_multiple_of
  | Down -> round_down t ~to_multiple_of
  | Up -> round_up t ~to_multiple_of
  | Zero -> round_towards_zero t ~to_multiple_of
;;

module Stable0 = struct
  module V1 = struct
    module T = struct
      type nonrec t = t [@@deriving bin_io, compare, hash, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:219:6")
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
          (fun a__021_ b__022_ -> compare a__021_ b__022_ : t -> (t[@merlin.hide]) -> int)
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

        let equal =
          (fun a__023_ b__024_ -> equal a__023_ b__024_ : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let stable_witness : t Stable_witness.t = Stable_witness.assert_stable

      let sexp_of_t t =
        Time_float.Stable.Span.V1.sexp_of_t (to_span_float_round_nearest t)
      ;;

      let t_of_sexp s =
        of_span_float_round_nearest (Time_float.Stable.Span.V1.t_of_sexp s)
      ;;

      let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
        Sexplib0.Sexp_grammar.coerce Time_float.Stable.Span.V1.t_sexp_grammar
      ;;

      let of_int63_exn t = of_int63_ns t
      let to_int63 t = to_int63_ns t
    end

    include T
    include Comparator.Stable.V1.Make (T)
    include Diffable.Atomic.Make (T)
  end

  module V2 = struct
    module T = struct
      module T0 = struct
        type nonrec t = t [@@deriving bin_io, compare, hash, equal]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:247:8")
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
            (fun a__025_ b__026_ -> compare a__025_ b__026_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

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

          let equal =
            (fun a__027_ b__028_ -> equal a__027_ b__028_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let stable_witness : t Stable_witness.t = Int63.Stable.V1.stable_witness
        let of_int63_exn t = of_int63_ns t
        let to_int63 t = to_int63_ns t

        module To_string = struct
          let number_of_digits_to_write ~span_part_magnitude =
            let open Int.O in
            if span_part_magnitude = 0
            then 0
            else if span_part_magnitude < 10
            then 1
            else if span_part_magnitude < 100
            then 2
            else if span_part_magnitude < 1_000
            then 3
            else if span_part_magnitude < 10_000
            then 4
            else if span_part_magnitude < 100_000
            then 5
            else assert false
          ;;

          let number_of_decimal_places_to_write ~billionths =
            let open Int.O in
            assert (billionths >= 0 && billionths <= 999_999_999);
            if billionths = 0
            then 0
            else if billionths % 10 <> 0
            then 9
            else if billionths % 100 <> 0
            then 8
            else if billionths % 1_000 <> 0
            then 7
            else if billionths % 10_000 <> 0
            then 6
            else if billionths % 100_000 <> 0
            then 5
            else if billionths % 1_000_000 <> 0
            then 4
            else if billionths % 10_000_000 <> 0
            then 3
            else if billionths % 100_000_000 <> 0
            then 2
            else 1
          ;;

          let write_char buf ~pos char =
            let open Int.O in
            Bytes.unsafe_set buf pos char;
            pos + 1
          ;;

          let write_2_chars buf ~pos char1 char2 =
            let open Int.O in
            Bytes.unsafe_set buf pos char1;
            Bytes.unsafe_set buf (pos + 1) char2;
            pos + 2
          ;;

          let write_digits buf ~pos ~digits int =
            let open Int.O in
            Digit_string_helpers.write_int63 buf ~pos ~digits (Int63.of_int int);
            pos + digits
          ;;

          let write_decimals buf ~pos ~decimals ~billionths =
            let open Int.O in
            Digit_string_helpers.write_int63
              buf
              ~pos
              ~digits:decimals
              (Int63.of_int (billionths / Int.pow 10 (9 - decimals)));
            pos + decimals
          ;;

          let write_if_non_empty buf ~pos ~digits int suffix =
            let open Int.O in
            if digits = 0
            then pos
            else (
              let pos = write_digits buf ~pos ~digits int in
              let pos = write_char buf ~pos suffix in
              pos)
          ;;

          let nanos_of_millisecond = Int63.to_int_exn (to_int63_ns millisecond)
          let nanos_of_microsecond = Int63.to_int_exn (to_int63_ns microsecond)
          let int63_60 = Int63.of_int 60
          let int63_24 = Int63.of_int 24

          module Decimal_unit = struct
            type t =
              | Second
              | Millisecond
              | Microsecond
              | Nanosecond
              | None
            [@@deriving compare, sexp_of]

            include struct
              let _ = fun (_ : t) -> ()

              let compare =
                (fun a__029_ b__030_ -> Stdlib.compare a__029_ b__030_
                 : t -> (t[@merlin.hide]) -> int)
              ;;

              let _ = compare

              let sexp_of_t =
                (function
                 | Second -> Sexplib0.Sexp.Atom "Second"
                 | Millisecond -> Sexplib0.Sexp.Atom "Millisecond"
                 | Microsecond -> Sexplib0.Sexp.Atom "Microsecond"
                 | Nanosecond -> Sexplib0.Sexp.Atom "Nanosecond"
                 | None -> Sexplib0.Sexp.Atom "None"
                 : t -> Sexplib0.Sexp.t)
              ;;

              let _ = sexp_of_t
            end [@@ocaml.doc "@inline"] [@@merlin.hide]

            let create ~s ~ns =
              let open Int.O in
              if s > 0
              then Second
              else if ns >= nanos_of_millisecond
              then Millisecond
              else if ns >= nanos_of_microsecond
              then Microsecond
              else if ns >= 1
              then Nanosecond
              else None
            ;;

            let integer t ~s ~ns =
              let open Int.O in
              match t with
              | Second -> s
              | Millisecond -> ns / nanos_of_millisecond
              | Microsecond -> ns / nanos_of_microsecond
              | Nanosecond -> ns
              | None -> 0
            ;;

            let billionths t ~ns =
              let open Int.O in
              match t with
              | Second -> ns
              | Millisecond -> ns % nanos_of_millisecond * 1_000
              | Microsecond -> ns % nanos_of_microsecond * 1_000_000
              | Nanosecond -> 0
              | None -> 0
            ;;

            let length t ~digits ~decimals =
              let open Int.O in
              let digits_len =
                match t with
                | Second -> digits + 1
                | Millisecond | Microsecond | Nanosecond -> digits + 2
                | None -> 0
              in
              let decimals_len = if decimals > 0 then decimals + 1 else 0 in
              digits_len + decimals_len
            ;;

            let write_suffix t buf ~pos =
              match t with
              | Second -> write_char buf ~pos 's'
              | Millisecond -> write_2_chars buf ~pos 'm' 's'
              | Microsecond -> write_2_chars buf ~pos 'u' 's'
              | Nanosecond -> write_2_chars buf ~pos 'n' 's'
              | None -> pos
            ;;

            let write t buf ~pos ~integer ~digits ~billionths ~decimals =
              let open Int.O in
              if digits = 0
              then pos
              else (
                let pos = write_digits buf ~pos integer ~digits in
                let pos =
                  if decimals = 0
                  then pos
                  else (
                    let pos = write_char buf ~pos '.' in
                    write_decimals buf ~pos ~billionths ~decimals)
                in
                write_suffix t buf ~pos)
            ;;
          end

          let to_string t =
            if equal t zero
            then "0s"
            else (
              let is_negative = t < zero in
              let seconds = Int63.( / ) (to_int63_ns t) (to_int63_ns second) in
              let ns =
                Int63.to_int_exn (Int63.rem (to_int63_ns t) (to_int63_ns second))
              in
              let seconds = Int63.abs seconds in
              let ns = Int.abs ns in
              let s = Int63.to_int_exn (Int63.rem seconds int63_60) in
              let minutes = Int63.( / ) seconds int63_60 in
              let m = Int63.to_int_exn (Int63.rem minutes int63_60) in
              let hours = Int63.( / ) minutes int63_60 in
              let h = Int63.to_int_exn (Int63.rem hours int63_24) in
              let d = Int63.to_int_exn (Int63.( / ) hours int63_24) in
              let open Int.O in
              let digits_of_d = number_of_digits_to_write ~span_part_magnitude:d in
              let digits_of_h = number_of_digits_to_write ~span_part_magnitude:h in
              let digits_of_m = number_of_digits_to_write ~span_part_magnitude:m in
              let decimal_unit = Decimal_unit.create ~s ~ns in
              let decimal_unit_integer = Decimal_unit.integer decimal_unit ~s ~ns in
              let decimal_unit_billionths = Decimal_unit.billionths decimal_unit ~ns in
              let digits_of_decimal_unit =
                number_of_digits_to_write ~span_part_magnitude:decimal_unit_integer
              in
              let decimals_of_decimal_unit =
                number_of_decimal_places_to_write ~billionths:decimal_unit_billionths
              in
              let string_length =
                let sign_len = if is_negative then 1 else 0 in
                let d_len = if digits_of_d > 0 then digits_of_d + 1 else 0 in
                let h_len = if digits_of_h > 0 then digits_of_h + 1 else 0 in
                let m_len = if digits_of_m > 0 then digits_of_m + 1 else 0 in
                let decimal_unit_len =
                  Decimal_unit.length
                    decimal_unit
                    ~digits:digits_of_decimal_unit
                    ~decimals:decimals_of_decimal_unit
                in
                sign_len + d_len + h_len + m_len + decimal_unit_len
              in
              assert (string_length > 0);
              let buf = Bytes.create string_length in
              let pos = 0 in
              let pos = if is_negative then write_char buf ~pos '-' else pos in
              let pos = write_if_non_empty buf ~pos ~digits:digits_of_d d 'd' in
              let pos = write_if_non_empty buf ~pos ~digits:digits_of_h h 'h' in
              let pos = write_if_non_empty buf ~pos ~digits:digits_of_m m 'm' in
              let pos =
                Decimal_unit.write
                  decimal_unit
                  buf
                  ~pos
                  ~integer:decimal_unit_integer
                  ~digits:digits_of_decimal_unit
                  ~billionths:decimal_unit_billionths
                  ~decimals:decimals_of_decimal_unit
              in
              assert (pos = string_length);
              Bytes.unsafe_to_string ~no_mutation_while_string_reachable:buf)
          ;;
        end

        let to_string = To_string.to_string

        module Of_string = struct
          let int63_10 = Int63.of_int 10

          let min_mult10_without_underflow =
            let open Int63 in
            min_value / int63_10
          ;;

          let invalid_string string ~reason =
            raise_s
              (let ppx_sexp_message () =
                 Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                       "Time_ns.Span.of_string: invalid string"
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "string"
                       ; (sexp_of_string [@merlin.hide]) string
                       ]
                   ; Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.Atom "reason"
                       ; (sexp_of_string [@merlin.hide]) reason
                       ]
                   ]
                   [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
               in
               (ppx_sexp_message () [@nontail]))
          [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
          ;;

          let add_without_underflow ~string x y =
            let open Int63.O in
            let sum = x + y in
            if sum > x
            then invalid_string string ~reason:"span would be outside of int63 range";
            sum
          ;;

          let add_neg_digit ~string int63 char =
            let open Int63.O in
            let digit = Int63.of_int (Char.get_digit_exn char) in
            if int63 < min_mult10_without_underflow
            then invalid_string string ~reason:"span would be outside of int63 range";
            add_without_underflow ~string (int63 * int63_10) (-digit)
          ;;

          let min_factor_of span = Int63.( / ) Int63.min_value (to_int63_ns span)
          let min_days_without_underflow = min_factor_of day
          let min_hours_without_underflow = min_factor_of hour
          let min_minutes_without_underflow = min_factor_of minute
          let min_seconds_without_underflow = min_factor_of second
          let min_milliseconds_without_underflow = min_factor_of millisecond
          let min_microseconds_without_underflow = min_factor_of microsecond
          let min_nanoseconds_without_underflow = min_factor_of nanosecond

          let min_without_underflow_of_unit_of_time unit_of_time =
            match (unit_of_time : Unit_of_time.t) with
            | Day -> min_days_without_underflow
            | Hour -> min_hours_without_underflow
            | Minute -> min_minutes_without_underflow
            | Second -> min_seconds_without_underflow
            | Millisecond -> min_milliseconds_without_underflow
            | Microsecond -> min_microseconds_without_underflow
            | Nanosecond -> min_nanoseconds_without_underflow
          ;;

          let negative_part
                string
                ~neg_integer
                ~decimal_pos
                ~end_pos
                ~unit_of_time
                ~round_ties_before_negating
            =
            let open Int.O in
            let scale = to_int63_ns (of_unit_of_time unit_of_time) in
            let min_without_underflow =
              min_without_underflow_of_unit_of_time unit_of_time
            in
            if Int63.( < ) neg_integer min_without_underflow
            then invalid_string string ~reason:"span would be outside of int63 range";
            let neg_integer_ns = Int63.( * ) neg_integer scale in
            let fraction_pos = decimal_pos + 1 in
            if fraction_pos >= end_pos
            then neg_integer_ns
            else (
              let decimal_ns =
                Digit_string_helpers.read_int63_decimal
                  string
                  ~pos:fraction_pos
                  ~scale
                  ~decimals:(end_pos - fraction_pos)
                  ~allow_underscore:true
                  ~round_ties:round_ties_before_negating
              in
              add_without_underflow ~string neg_integer_ns (Int63.( ~- ) decimal_ns))
          ;;

          let of_string string =
            let open Int.O in
            let neg_ns = ref Int63.zero in
            let pos = ref 0 in
            let len = String.length string in
            if len = 0 then invalid_string string ~reason:"empty string";
            let is_negative =
              match String.unsafe_get string !pos with
              | '-' ->
                incr pos;
                true
              | '+' ->
                incr pos;
                false
              | _ -> false
            in
            let round_ties_before_negating : Digit_string_helpers.Round.t =
              match is_negative with
              | false -> Toward_positive_infinity
              | true -> Toward_negative_infinity
            in
            while !pos < len do
              let has_digit = ref false in
              let neg_integer =
                let i = ref Int63.zero in
                let end_of_digits = ref false in
                while !pos < len && not !end_of_digits do
                  let c = String.unsafe_get string !pos in
                  match c with
                  | '0' .. '9' ->
                    i := add_neg_digit ~string !i c;
                    has_digit := true;
                    incr pos
                  | '_' -> incr pos
                  | _ -> end_of_digits := true
                done;
                !i
              in
              let decimal_pos = !pos in
              if !pos < len && Char.equal '.' (String.unsafe_get string !pos)
              then (
                incr pos;
                let end_of_decimals = ref false in
                while !pos < len && not !end_of_decimals do
                  match String.unsafe_get string !pos with
                  | '0' .. '9' ->
                    has_digit := true;
                    incr pos
                  | '_' -> incr pos
                  | _ -> end_of_decimals := true
                done);
              let end_pos = !pos in
              if not !has_digit
              then invalid_string string ~reason:"no digits before unit suffix";
              let unit_of_time : Unit_of_time.t =
                if !pos + 1 < len && Char.equal 's' (String.unsafe_get string (!pos + 1))
                then (
                  match String.unsafe_get string !pos with
                  | 'm' ->
                    pos := !pos + 2;
                    Millisecond
                  | 'u' ->
                    pos := !pos + 2;
                    Microsecond
                  | 'n' ->
                    pos := !pos + 2;
                    Nanosecond
                  | _ -> invalid_string string ~reason:"unparseable unit suffix")
                else if !pos < len
                then (
                  match String.unsafe_get string !pos with
                  | 'd' ->
                    incr pos;
                    Day
                  | 'h' ->
                    incr pos;
                    Hour
                  | 'm' ->
                    incr pos;
                    Minute
                  | 's' ->
                    incr pos;
                    Second
                  | _ -> invalid_string string ~reason:"unparseable unit suffix")
                else invalid_string string ~reason:"no unit suffix after digits"
              in
              let neg_nanos_of_part =
                negative_part
                  string
                  ~neg_integer
                  ~decimal_pos
                  ~end_pos
                  ~unit_of_time
                  ~round_ties_before_negating
              in
              neg_ns := add_without_underflow ~string !neg_ns neg_nanos_of_part
            done;
            let ns =
              if is_negative
              then !neg_ns
              else if Int63.( = ) !neg_ns Int63.min_value
              then invalid_string string ~reason:"span would be outside of int63 range"
              else Int63.( ~- ) !neg_ns
            in
            of_int63_ns ns
          ;;
        end

        let of_string = Of_string.of_string
        let sexp_of_t t = Sexp.Atom (to_string t)

        let t_of_sexp sexp =
          match sexp with
          | Sexp.Atom x ->
            (try of_string x with
             | exn -> of_sexp_error (Exn.to_string exn) sexp)
          | Sexp.List _ ->
            of_sexp_error "Time_ns.Span.Stable.V2.t_of_sexp: sexp must be an Atom" sexp
        ;;

        let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar
      end

      include T0
      include Comparator.Stable.V1.Make (T0)
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
    include Diffable.Atomic.Make (T)
  end
end

open struct
  module Stable = Stable0
end

let to_string = Stable.V2.to_string
let of_string = Stable.V2.of_string
let sexp_of_t = Stable.V2.sexp_of_t
let t_of_sexp = Stable.V2.t_of_sexp
let t_sexp_grammar = Stable.V2.t_sexp_grammar

module Alternate_sexp = struct
  type nonrec t = t [@@deriving sexp, sexp_grammar]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = t_sexp_grammar
    let _ = t_sexp_grammar
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

include Comparable.With_zero (struct
    type nonrec t = t [@@deriving compare, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__032_ b__033_ -> compare a__032_ b__033_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let zero = zero
  end)

let robust_comparison_tolerance = microsecond

let ( >=. ) t u =
  t
  >= let open Int63 in
     u - robust_comparison_tolerance
;;

let ( <=. ) t u =
  t
  <= let open Int63 in
     u + robust_comparison_tolerance
;;

let ( =. ) t u =
  (let open Int63 in
   abs (t - u))
  <= robust_comparison_tolerance
;;

let ( >. ) t u =
  t
  > let open Int63 in
    u + robust_comparison_tolerance
;;

let ( <. ) t u =
  t
  < let open Int63 in
    u - robust_comparison_tolerance
;;

let ( <>. ) t u =
  (let open Int63 in
   abs (t - u))
  > robust_comparison_tolerance
;;

let robustly_compare t u = if t <. u then -1 else if t >. u then 1 else 0

let to_string_hum
      ?(delimiter = '_')
      ?(decimals = 3)
      ?(align_decimal = false)
      ?unit_of_time
      t
  =
  let float, suffix =
    match Option.value unit_of_time ~default:(to_unit_of_time t) with
    | Day -> to_day t, "d"
    | Hour -> to_hr t, "h"
    | Minute -> to_min t, "m"
    | Second -> to_sec t, "s"
    | Millisecond -> to_ms t, "ms"
    | Microsecond -> to_us t, "us"
    | Nanosecond -> to_ns t, "ns"
  in
  let prefix =
    Float.to_string_hum float ~delimiter ~decimals ~strip_zero:(not align_decimal)
  in
  let suffix =
    if align_decimal && Int.( = ) (String.length suffix) 1 then suffix ^ " " else suffix
  in
  prefix ^ suffix
;;

let since_unix_epoch () = of_int63_ns (Time_now.nanoseconds_since_unix_epoch ())

let random ?state () =
  Int63.random ?state (max_value_for_1us_rounding + Int63.one)
  - Int63.random ?state (neg min_value_for_1us_rounding + Int63.one)
;;

let randomize ?(state = Random.State.default) t ~percent =
  Span_helpers.randomize t state ~percent ~scale
;;

let to_short_string t =
  let ({ sign; hr; min; sec; ms; us; ns } : Parts.t) = to_parts t in
  Span_helpers.short_string ~sign ~hr ~min ~sec ~ms ~us ~ns
;;

let gen_incl = Int63.gen_incl
let gen_uniform_incl = Int63.gen_uniform_incl

include Pretty_printer.Register (struct
    type nonrec t = t

    let to_string = to_string
    let module_name = module_name
  end)

include Hashable.Make_binable (struct
    type nonrec t = t [@@deriving bin_io, compare, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:806:2")
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__035_ b__036_ -> compare a__035_ b__036_ : t -> (t[@merlin.hide]) -> int)
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

type comparator_witness = Stable.V2.comparator_witness

include Comparable.Make_binable_using_comparator (struct
    type nonrec t = t [@@deriving bin_io, compare, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:812:2")
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__038_ b__039_ -> compare a__038_ b__039_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nonrec comparator_witness = comparator_witness

    let comparator = Stable.V2.comparator
  end)

include Diffable.Atomic.Make (struct
    type nonrec t = t [@@deriving bin_io, sexp, equal]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:819:2")
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
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let equal =
        (fun a__042_ b__043_ -> equal a__042_ b__043_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Replace_polymorphic_compare = T.Replace_polymorphic_compare
include Replace_polymorphic_compare

let half_microsecond = Int63.of_int 500

let nearest_microsecond t =
  let open Int63 in
  (to_int63_ns t + half_microsecond) /% of_int 1000
;;

let invalid_range_for_1us_rounding t =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Span.t exceeds limits"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "t"; (sexp_of_t [@merlin.hide]) t ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "min_value_for_1us_rounding"
             ; (sexp_of_t [@merlin.hide]) min_value_for_1us_rounding
             ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "max_value_for_1us_rounding"
             ; (sexp_of_t [@merlin.hide]) max_value_for_1us_rounding
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let check_range_for_1us_rounding t =
  if t < min_value_for_1us_rounding || t > max_value_for_1us_rounding
  then invalid_range_for_1us_rounding t
  else t
;;

let to_span_float_round_nearest_microsecond t =
  Span_float.of_us (Int63.to_float (nearest_microsecond (check_range_for_1us_rounding t)))
;;

let min_span_float_value_for_1us_rounding =
  to_span_float_round_nearest min_value_for_1us_rounding
;;

let max_span_float_value_for_1us_rounding =
  to_span_float_round_nearest max_value_for_1us_rounding
;;

let of_span_float_round_nearest_microsecond s =
  if
    Span_float.( > ) s max_span_float_value_for_1us_rounding
    || Span_float.( < ) s min_span_float_value_for_1us_rounding
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "span_ns.ml.before-ppx"
        ; pos_lnum = 862
        ; pos_cnum = 30080
        ; pos_bol = 30068
        }
      "Time_ns.Span does not support this span"
      s
      (Span_float.sexp_of_t [@merlin.hide]);
  of_sec_with_microsecond_precision (Span_float.to_sec s)
;;

let min_value_representable = of_int63_ns Int63.min_value
let max_value_representable = of_int63_ns Int63.max_value

module O = struct
  let ( / ) = ( / )
  let ( // ) = ( // )
  let ( + ) = ( + )
  let ( - ) = ( - )
  let ( >= ) = ( >= )
  let ( <= ) = ( <= )
  let ( = ) = ( = )
  let ( > ) = ( > )
  let ( < ) = ( < )
  let ( <> ) = ( <> )
  let ( ~- ) = neg
  let ( *. ) = scale
  let ( * ) = scale_int
end

module Private = struct
  let of_parts = of_parts
  let to_parts = to_parts
end

let min_value = min_value_for_1us_rounding
let max_value = max_value_for_1us_rounding
let of_span = of_span_float_round_nearest_microsecond
let to_span = to_span_float_round_nearest_microsecond

module Option = struct
  type span = t [@@deriving sexp]

  include struct
    let _ = fun (_ : span) -> ()
    let span_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> span)
    let _ = span_of_sexp
    let sexp_of_span = (sexp_of_t : span -> Sexplib0.Sexp.t)
    let _ = sexp_of_span
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type t = Int63.t [@@deriving bin_io, compare, equal, hash, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:905:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], Int63.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = Int63.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = Int63.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Int63.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = Int63.bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let compare =
      (fun a__045_ b__046_ -> Int63.compare a__045_ b__046_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__047_ b__048_ -> Int63.equal a__047_ b__048_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Int63.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int63.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "span_ns.ml.before-ppx.Option.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Int63.typerep_of_t))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let none = Int63.min_value

  let is_none t =
    let open Int63 in
    t = none
  ;;

  let is_some t =
    let open Int63 in
    t <> none
  ;;

  let some_is_representable span = is_some (to_int63_ns span)

  let raise_some_error span =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "span_ns.ml.before-ppx:914:22"
           ; Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Span.Option.some value not representable"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "span"; (sexp_of_span [@merlin.hide]) span ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let some span =
    if some_is_representable span then to_int63_ns span else raise_some_error span
  ;;

  let unchecked_value t = of_int63_ns t
  let value t ~default = Bool.select (is_none t) default (unchecked_value t)

  let value_exn t =
    if is_some t
    then unchecked_value t
    else
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "span_ns.ml.before-ppx:927:27"
             ; Ppx_sexp_conv_lib.Conv.sexp_of_string "Span.Option.value_exn none"
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  ;;

  let of_option = function
    | None -> none
    | Some t -> some t
  ;;

  let to_option t = if is_none t then None else Some (of_int63_ns t)

  module For_quickcheck = struct
    module Some = struct
      type t = span

      let quickcheck_generator =
        Quickcheck.Generator.filter quickcheck_generator ~f:some_is_representable
      ;;

      let quickcheck_observer = quickcheck_observer

      let quickcheck_shrinker =
        Base_quickcheck.Shrinker.filter quickcheck_shrinker ~f:some_is_representable
      ;;
    end

    type t = Some.t option [@@deriving quickcheck]

    include struct
      let _ = fun (_ : t) -> ()
      let quickcheck_generator = quickcheck_generator_option Some.quickcheck_generator
      let _ = quickcheck_generator
      let quickcheck_observer = quickcheck_observer_option Some.quickcheck_observer
      let _ = quickcheck_observer
      let quickcheck_shrinker = quickcheck_shrinker_option Some.quickcheck_shrinker
      let _ = quickcheck_shrinker
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  let quickcheck_generator =
    Quickcheck.Generator.map For_quickcheck.quickcheck_generator ~f:of_option
  ;;

  let quickcheck_observer =
    Quickcheck.Observer.unmap For_quickcheck.quickcheck_observer ~f:to_option
  ;;

  let quickcheck_shrinker =
    Quickcheck.Shrinker.map
      For_quickcheck.quickcheck_shrinker
      ~f:of_option
      ~f_inverse:to_option
  ;;

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unchecked_value
    end
  end

  module Stable = struct
    module V1 = struct
      module T = struct
        type nonrec t = t [@@deriving bin_io, compare, equal]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:980:8")
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
            (fun a__049_ b__050_ -> compare a__049_ b__050_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__051_ b__052_ -> equal a__051_ b__052_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let v1_some span =
          assert (some_is_representable span);
          to_int63_ns span
        ;;

        let sexp_of_t t =
          ((fun x__053_ -> sexp_of_option Stable.V1.sexp_of_t x__053_) [@merlin.hide])
            (to_option t)
        ;;

        let t_of_sexp s =
          of_option
            (((fun x__054_ -> option_of_sexp Stable.V1.t_of_sexp x__054_) [@merlin.hide])
               s)
        ;;

        let of_int63_exn i = if is_none i then none else v1_some (of_int63_ns i)
        let to_int63 t = t

        let stable_witness : t Stable_witness.t =
          Stable_witness.of_serializable
            Int63.Stable.V1.stable_witness
            of_int63_exn
            to_int63
        ;;
      end

      include T
      include Comparator.Stable.V1.Make (T)
      include Diffable.Atomic.Make (T)
    end

    module V2 = struct
      module T = struct
        type nonrec t = t [@@deriving bin_io, compare, equal]

        include struct
          let _ = fun (_ : t) -> ()

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:1007:8")
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
            (fun a__055_ b__056_ -> compare a__055_ b__056_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let equal =
            (fun a__057_ b__058_ -> equal a__057_ b__058_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let sexp_of_t t =
          Sexp.List
            (if is_none t then [] else [ Stable.V2.sexp_of_t (unchecked_value t) ])
        ;;

        let t_of_sexp sexp =
          let fail () =
            of_sexp_error
              "Time_ns.Span.Option.Stable.V2.t_of_sexp: sexp must be a List of 0-1 Atom"
              sexp
          in
          match sexp with
          | Sexp.Atom _ -> fail ()
          | Sexp.List list ->
            (match list with
             | [] -> none
             | Sexp.Atom x :: [] ->
               some
                 (try of_string x with
                  | exn -> of_sexp_error (Exn.to_string exn) sexp)
             | _ -> fail ())
        ;;

        let of_int63_exn i = i
        let to_int63 t = t

        let stable_witness : t Stable_witness.t =
          Stable_witness.of_serializable
            Int63.Stable.V1.stable_witness
            of_int63_exn
            to_int63
        ;;
      end

      include T
      include Comparator.Stable.V1.Make (T)
      include Diffable.Atomic.Make (T)
    end
  end

  let sexp_of_t = Stable.V2.sexp_of_t
  let t_of_sexp = Stable.V2.t_of_sexp

  include Identifiable.Make (struct
      type nonrec t = t [@@deriving sexp, compare, bin_io, hash]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let compare =
          (fun a__060_ b__061_ -> compare a__060_ b__061_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:1053:4")
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

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let module_name = "Core.Time_ns.Span.Option"

      include Sexpable.To_stringable (struct
          type nonrec t = t [@@deriving sexp]

          include struct
            let _ = fun (_ : t) -> ()
            let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
            let _ = t_of_sexp
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
    end)

  include Diffable.Atomic.Make (struct
      type nonrec t = t [@@deriving bin_io, sexp, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "span_ns.ml.before-ppx:1063:4")
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
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let equal =
          (fun a__064_ b__065_ -> equal a__064_ b__065_ : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

  include (Int63 : Comparisons.S with type t := t)
end

module Stable = struct
  include Stable0

  module Option = struct
    module V1 = Option.Stable.V1
    module V2 = Option.Stable.V2
  end
end

let arg_type = Command.Arg_type.create of_string
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
