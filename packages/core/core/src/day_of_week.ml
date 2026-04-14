let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"day_of_week.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "day_of_week.ml.before-ppx"
;;

open! Import

let failwithf = Printf.failwithf

module Stable = struct
  module V1 = struct
    module T = struct
      type t =
        | Sun
        | Mon
        | Tue
        | Wed
        | Thu
        | Fri
        | Sat
      [@@deriving
        bin_io ~localize
      , compare
      , enumerate
      , equal
      , hash
      , quickcheck
      , stable_witness
      , typerep]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "day_of_week.ml.before-ppx:8:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , []
                , Bin_prot.Shape.variant
                    [ "Sun", []
                    ; "Mon", []
                    ; "Tue", []
                    ; "Wed", []
                    ; "Thu", []
                    ; "Fri", []
                    ; "Sat", []
                    ] )
              ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t

        let bin_size_t__local : t Bin_prot.Size.sizer_local = function
          | Sun | Mon | Tue | Wed | Thu | Fri | Sat -> 1
        ;;

        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t

        let bin_write_t__local : t Bin_prot.Write.writer_local =
          fun buf ~pos -> function
          | Sun -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
          | Mon -> Bin_prot.Write.bin_write_int_8bit buf ~pos 1
          | Tue -> Bin_prot.Write.bin_write_int_8bit buf ~pos 2
          | Wed -> Bin_prot.Write.bin_write_int_8bit buf ~pos 3
          | Thu -> Bin_prot.Write.bin_write_int_8bit buf ~pos 4
          | Fri -> Bin_prot.Write.bin_write_int_8bit buf ~pos 5
          | Sat -> Bin_prot.Write.bin_write_int_8bit buf ~pos 6
        ;;

        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t

        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
          fun _buf ~pos_ref _vint ->
          Bin_prot.Common.raise_variant_wrong_type
            "day_of_week.ml.before-ppx.Stable.V1.T.t"
            !pos_ref
        ;;

        let _ = __bin_read_t__

        let bin_read_t : t Bin_prot.Read.reader =
          fun buf ~pos_ref ->
          match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
          | 0 -> Sun
          | 1 -> Mon
          | 2 -> Tue
          | 3 -> Wed
          | 4 -> Thu
          | 5 -> Fri
          | 6 -> Sat
          | _ ->
            Bin_prot.Common.raise_read_error
              (Bin_prot.Common.ReadError.Sum_tag "day_of_week.ml.before-ppx.Stable.V1.T.t")
              !pos_ref
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

        let compare =
          (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let all = ([ Sun; Mon; Tue; Wed; Thu; Fri; Sat ] : t list)
        let _ = all

        let equal =
          (fun a__003_ b__004_ -> Stdlib.( = ) a__003_ b__004_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          (fun hsv arg ->
             Ppx_hash_lib.Std.Hash.fold_int
               hsv
               (match arg with
                | Sun -> 0
                | Mon -> 1
                | Tue -> 2
                | Wed -> 3
                | Thu -> 4
                | Fri -> 5
                | Sat -> 6)
           : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state)
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

        let quickcheck_generator =
          Ppx_quickcheck_runtime.Base_quickcheck.Generator.weighted_union
            [ ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__008_ ~random:_random__009_ -> Sun) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__010_ ~random:_random__011_ -> Mon) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__012_ ~random:_random__013_ -> Tue) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__014_ ~random:_random__015_ -> Wed) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__016_ ~random:_random__017_ -> Thu) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__018_ ~random:_random__019_ -> Fri) )
            ; ( 1.
              , Ppx_quickcheck_runtime.Base_quickcheck.Generator.create
                  (fun ~size:_size__020_ ~random:_random__021_ -> Sat) )
            ]
        ;;

        let _ = quickcheck_generator

        let quickcheck_observer =
          Ppx_quickcheck_runtime.Base_quickcheck.Observer.create
            (fun _x__005_ ~size:_size__006_ ~hash:_hash__007_ ->
               match _x__005_ with
               | Sun ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 0
                 in
                 _hash__007_
               | Mon ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 1
                 in
                 _hash__007_
               | Tue ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 2
                 in
                 _hash__007_
               | Wed ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 3
                 in
                 _hash__007_
               | Thu ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 4
                 in
                 _hash__007_
               | Fri ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 5
                 in
                 _hash__007_
               | Sat ->
                 let _hash__007_ =
                   Ppx_quickcheck_runtime.Base.hash_fold_int _hash__007_ 6
                 in
                 _hash__007_)
        ;;

        let _ = quickcheck_observer

        let quickcheck_shrinker =
          Ppx_quickcheck_runtime.Base_quickcheck.Shrinker.create (function
            | Sun -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Mon -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Tue -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Wed -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Thu -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Fri -> Ppx_quickcheck_runtime.Base.Sequence.round_robin []
            | Sat -> Ppx_quickcheck_runtime.Base.Sequence.round_robin [])
        ;;

        let _ = quickcheck_shrinker

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)
        ;;

        let _ = stable_witness

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "day_of_week.ml.before-ppx.Stable.V1.T.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named
            ( name_of_t
            , Some
                (lazy
                  (let tag0 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Sun"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 0
                       ; ocaml_repr = 0
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Sun
                       }
                   in
                   let tag1 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Mon"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 1
                       ; ocaml_repr = 1
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Mon
                       }
                   in
                   let tag2 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Tue"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 2
                       ; ocaml_repr = 2
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Tue
                       }
                   in
                   let tag3 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Wed"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 3
                       ; ocaml_repr = 3
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Wed
                       }
                   in
                   let tag4 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Thu"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 4
                       ; ocaml_repr = 4
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Thu
                       }
                   in
                   let tag5 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Fri"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 5
                       ; ocaml_repr = 5
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Fri
                       }
                   in
                   let tag6 =
                     Typerep_lib.Std.Typerep.Tag.internal_use_only
                       { Typerep_lib.Std.Typerep.Tag_internal.label = "Sat"
                       ; rep = typerep_of_tuple0
                       ; arity = 0
                       ; args_labels = []
                       ; index = 6
                       ; ocaml_repr = 6
                       ; tyid = typename_of_tuple0
                       ; create = Typerep_lib.Std.Typerep.Tag_internal.Const Sat
                       }
                   in
                   let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
                   let tags =
                     [| Typerep_lib.Std.Typerep.Variant_internal.Tag tag0
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag1
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag2
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag3
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag4
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag5
                      ; Typerep_lib.Std.Typerep.Variant_internal.Tag tag6
                     |]
                   in
                   let polymorphic = false in
                   let value = function
                     | Sun ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag0, value_tuple0)
                     | Mon ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag1, value_tuple0)
                     | Tue ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag2, value_tuple0)
                     | Wed ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag3, value_tuple0)
                     | Thu ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag4, value_tuple0)
                     | Fri ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag5, value_tuple0)
                     | Sat ->
                       Typerep_lib.Std.Typerep.Variant_internal.Value (tag6, value_tuple0)
                   in
                   Typerep_lib.Std.Typerep.Variant
                     (Typerep_lib.Std.Typerep.Variant.internal_use_only
                        { Typerep_lib.Std.Typerep.Variant_internal.typename
                        ; Typerep_lib.Std.Typerep.Variant_internal.tags
                        ; Typerep_lib.Std.Typerep.Variant_internal.polymorphic
                        ; Typerep_lib.Std.Typerep.Variant_internal.value
                        }))) )
        ;;

        let _ = typerep_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let to_string t =
        match t with
        | Sun -> "SUN"
        | Mon -> "MON"
        | Tue -> "TUE"
        | Wed -> "WED"
        | Thu -> "THU"
        | Fri -> "FRI"
        | Sat -> "SAT"
      ;;

      let to_string_long t =
        match t with
        | Sun -> "Sunday"
        | Mon -> "Monday"
        | Tue -> "Tuesday"
        | Wed -> "Wednesday"
        | Thu -> "Thursday"
        | Fri -> "Friday"
        | Sat -> "Saturday"
      ;;

      let of_string_internal s =
        match String.uppercase s with
        | "SUN" | "SUNDAY" -> Sun
        | "MON" | "MONDAY" -> Mon
        | "TUE" | "TUESDAY" -> Tue
        | "WED" | "WEDNESDAY" -> Wed
        | "THU" | "THURSDAY" -> Thu
        | "FRI" | "FRIDAY" -> Fri
        | "SAT" | "SATURDAY" -> Sat
        | _ -> failwithf "Day_of_week.of_string: %S" s ()
      ;;

      let of_int_exn i =
        match i with
        | 0 -> Sun
        | 1 -> Mon
        | 2 -> Tue
        | 3 -> Wed
        | 4 -> Thu
        | 5 -> Fri
        | 6 -> Sat
        | _ -> failwithf "Day_of_week.of_int_exn: %d" i ()
      ;;

      let to_int t =
        match t with
        | Sun -> 0
        | Mon -> 1
        | Tue -> 2
        | Wed -> 3
        | Thu -> 4
        | Fri -> 5
        | Sat -> 6
      ;;

      let of_string s =
        try of_string_internal s with
        | _ ->
          (try of_int_exn (Int.of_string s) with
           | _ -> failwithf "Day_of_week.of_string: %S" s ())
      ;;

      include Sexpable.Stable.Of_stringable.V1 (struct
          type nonrec t = t

          let of_string = of_string
          let to_string = to_string
        end)

      let t_sexp_grammar =
        let open Sexplib0.Sexp_grammar in
        let atom name = No_tag { name; clause_kind = Atom_clause } in
        let unsuggested grammar =
          Tag { key = completion_suggested; value = Atom "false"; grammar }
        in
        let int_clause t = unsuggested (atom (Int.to_string (to_int t))) in
        let short_clause t = atom (to_string t) in
        let long_clause t = unsuggested (atom (to_string_long t)) in
        { untyped =
            Lazy
              (lazy
                (Variant
                   { case_sensitivity = Case_insensitive
                   ; clauses =
                       List.concat
                         [ List.map all ~f:int_clause
                         ; List.map all ~f:short_clause
                         ; List.map all ~f:long_clause
                         ]
                   }))
        }
      ;;
    end

    include T

    module Unstable = struct
      include T
      include (Comparable.Make_binable (T) : Comparable.S_binable with type t := t)
      include Hashable.Make_binable (T)
    end

    include Comparable.Stable.V1.With_stable_witness.Make (Unstable)
    include Hashable.Stable.V1.With_stable_witness.Make (Unstable)
  end
end

include Stable.V1.Unstable

let weekdays = [ Mon; Tue; Wed; Thu; Fri ]
let weekends = [ Sat; Sun ]

let of_int i =
  try Some (of_int_exn i) with
  | _ -> None
;;

let iso_8601_weekday_number t =
  match t with
  | Mon -> 1
  | Tue -> 2
  | Wed -> 3
  | Thu -> 4
  | Fri -> 5
  | Sat -> 6
  | Sun -> 7
;;

let num_days_in_week = 7
let shift t i = of_int_exn (Int.( % ) (to_int t + i) num_days_in_week)

let num_days ~from ~to_ =
  let d = to_int to_ - to_int from in
  if
    let open Int in
    d < 0
  then d + num_days_in_week
  else d
;;

let is_sun_or_sat t = t = Sun || t = Sat
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
