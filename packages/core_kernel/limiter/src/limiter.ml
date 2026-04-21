let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"limiter.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "limiter.ml.before-ppx"
;;

open! Core
open! Import

module Infinite_or_finite = struct
  module T = struct
    type 'a t =
      | Infinite
      | Finite of 'a
    [@@deriving sexp, bin_io]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun (type a__011_) ->
        (let error_source__004_ = "limiter.ml.before-ppx.Infinite_or_finite.T.t" in
         fun _of_a__001_ -> function
           | Sexplib0.Sexp.Atom ("infinite" | "Infinite") -> Infinite
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("finite" | "Finite") as _tag__007_)
               :: sexp_args__008_) as _sexp__006_ ->
             (match sexp_args__008_ with
              | arg0__009_ :: [] ->
                let res0__010_ = _of_a__001_ arg0__009_ in
                Finite res0__010_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__004_
                  _tag__007_
                  _sexp__006_)
           | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("infinite" | "Infinite") :: _) as
             sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_no_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.Atom ("finite" | "Finite") as sexp__005_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__004_ sexp__005_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__003_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__004_
               sexp__003_
           | Sexplib0.Sexp.List [] as sexp__003_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__004_ sexp__003_
           | sexp__003_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__004_ sexp__003_
         : (Sexplib0.Sexp.t -> a__011_) -> Sexplib0.Sexp.t -> a__011_ t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun (type a__015_) ->
        (fun _of_a__012_ -> function
           | Infinite -> Sexplib0.Sexp.Atom "Infinite"
           | Finite arg0__013_ ->
             let res0__014_ = _of_a__012_ arg0__013_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Finite"; res0__014_ ]
         : (a__015_ -> Sexplib0.Sexp.t) -> a__015_ t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "limiter.ml.before-ppx:6:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , Bin_prot.Shape.variant
                  [ "Infinite", []
                  ; ( "Finite"
                    , [ Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string "limiter.ml.before-ppx:8:18")
                          (Bin_prot.Shape.Vid.of_string "a")
                      ] )
                  ] )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a -> function
        | Finite v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (_size_of_a v1)
        | Infinite -> 1
      ;;

      let _ = bin_size_t

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos -> function
        | Infinite -> Bin_prot.Write.bin_write_int_8bit buf ~pos 0
        | Finite v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          _write_a buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a ->
           { size = (fun v -> bin_size_t bin_writer_a.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
        =
        fun _of__a _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "limiter.ml.before-ppx.Infinite_or_finite.T.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 -> Infinite
        | 1 ->
          let arg_1 = _of__a buf ~pos_ref in
          Finite arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag
               "limiter.ml.before-ppx.Infinite_or_finite.T.t")
            !pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a ->
           { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a ->
           { writer = bin_writer_t bin_a.writer
           ; reader = bin_reader_t bin_a.reader
           ; shape = bin_shape_t bin_a.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  include T

  let compare compare t1 t2 =
    match t1, t2 with
    | Infinite, Infinite -> 0
    | Infinite, Finite _ -> 1
    | Finite _, Infinite -> -1
    | Finite a, Finite b -> compare a b
  ;;
end

module Iofm : sig
  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val infinite : unit -> 'a t
  val finite : 'a -> 'a t
  val is_infinite : 'a t -> bool
  val is_finite : 'a t -> bool
  val set_infinite : 'a t -> unit
  val set_finite : 'a t -> 'a -> unit
  val get_finite_exn : 'a t -> 'a
  val to_ordinary : 'a t -> 'a Infinite_or_finite.t
  val of_ordinary : 'a Infinite_or_finite.t -> 'a t
end = struct
  type 'a t = 'a Moption.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__016_ x__017_ -> Moption.sexp_of_t _of_a__016_ x__017_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let infinite () = Moption.create ()

  let finite v =
    let t = Moption.create () in
    Moption.set_some t v;
    t
  ;;

  let is_infinite = Moption.is_none
  let is_finite = Moption.is_some
  let set_infinite = Moption.set_none
  let set_finite = Moption.set_some
  let get_finite_exn = Moption.get_some_exn

  let to_ordinary t : _ Infinite_or_finite.t =
    if Moption.is_none t then Infinite else Finite (Moption.get_some_exn t)
  [@@inline always]
  ;;

  let of_ordinary (ext : _ Infinite_or_finite.t) =
    match ext with
    | Infinite -> infinite ()
    | Finite v -> finite v
  [@@inline always]
  ;;
end
[@@ocaml.doc
  " Mutable version of Infinite_or_finite, for internal use, to avoid allocation "]

open Infinite_or_finite.T

module Float_types : sig
  module Tokens_per_sec : sig
    type t = private float

    val create : float -> t
    [@@ocaml.doc
      " This is the only entry-point to the interface, as all arguments in the mli are\n\
      \        \"*_per_sec\".  "]

    val to_span : t -> tokens:int -> Time_ns.Span.t
  end

  module Tokens_per_ns : sig
    type t = private float [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_tokens_per_sec : t -> Tokens_per_sec.t
    val of_tokens_per_sec : Tokens_per_sec.t -> t
    val to_tokens : t -> Time_ns.Span.t -> int
  end
end = struct
  module Tokens_per_sec = struct
    type t = float

    let create x = x
    let to_span t ~tokens = Time_ns.Span.of_sec (Float.of_int tokens /. t)
  end

  module Tokens_per_ns = struct
    type t = float [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()
      let sexp_of_t = (sexp_of_float : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_tokens_per_sec x = x *. 1E9
    let of_tokens_per_sec x = x /. 1E9
    let to_tokens t span = Float.iround_down_exn (t *. Time_ns.Span.to_ns span)
  end
end
[@@ocaml.doc
  " Collect all the \"dimensional analysis\"-type things in one place.  Not every possible\n\
  \    function is exposed here, just the ones that are actually used.\n\n\
  \    These types are not exposed in the mli. "]

open Float_types

module Try_take_result = struct
  type t =
    | Taken
    | Unable
    | Asked_for_more_than_bucket_limit
end

module Try_return_to_bucket_result = struct
  type t =
    | Returned_to_bucket
    | Unable
end

module Tokens_may_be_available_result = struct
  type t =
    | At of Time_ns.t
    | Never_because_greater_than_bucket_limit
    | When_return_to_hopper_is_called
end

module Try_reconfigure_result = struct
  type t =
    | Reconfigured
    | Unable
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | Reconfigured -> Sexplib0.Sexp.Atom "Reconfigured"
       | Unable -> Sexplib0.Sexp.Atom "Unable"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Time_ns = struct
  include Time_ns

  let sexp_of_t = Time_ns.Alternate_sexp.sexp_of_t
end

type t =
  { start_time : Time_ns.t
  ; mutable time : Time_ns.t
        [@ocaml.doc
          " The current time of the rate limiter.  Note that when this is moved forward,\n\
          \      [in_hopper] must be updated accordingly. "]
  ; time_in_token_space : int Iofm.t
        [@ocaml.doc
          " the amount of time that has passed expressed in token terms, since \
           start_time. "]
  ; mutable in_bucket : int [@ocaml.doc " number of tokens in the bucket "]
  ; in_hopper : int Iofm.t [@ocaml.doc " number of tokens in the hopper.  May be [inf] "]
  ; mutable in_flight : int
        [@ocaml.doc
          " Everything that has been taken from bucket but not returned to hopper "]
  ; mutable bucket_limit : int [@ocaml.doc " maximum size allowable in the bucket "]
  ; in_flight_limit : int Iofm.t [@ocaml.doc " maximum size allowable in flight "]
  ; mutable hopper_to_bucket_rate_per_ns : Tokens_per_ns.t Iofm.t
        [@ocaml.doc " rate at which tokens \"fall\" from the hopper into the bucket "]
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : t) -> ()

  let sexp_of_t =
    (fun { start_time = start_time__019_
         ; time = time__021_
         ; time_in_token_space = time_in_token_space__023_
         ; in_bucket = in_bucket__025_
         ; in_hopper = in_hopper__027_
         ; in_flight = in_flight__029_
         ; bucket_limit = bucket_limit__031_
         ; in_flight_limit = in_flight_limit__033_
         ; hopper_to_bucket_rate_per_ns = hopper_to_bucket_rate_per_ns__035_
         } ->
       let bnds__018_ = ([] : _ Stdlib.List.t) in
       let bnds__018_ =
         let arg__036_ =
           Iofm.sexp_of_t Tokens_per_ns.sexp_of_t hopper_to_bucket_rate_per_ns__035_
         in
         (Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "hopper_to_bucket_rate_per_ns"; arg__036_ ]
          :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__034_ = Iofm.sexp_of_t sexp_of_int in_flight_limit__033_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "in_flight_limit"; arg__034_ ]
          :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__032_ = sexp_of_int bucket_limit__031_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "bucket_limit"; arg__032_ ]
          :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__030_ = sexp_of_int in_flight__029_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "in_flight"; arg__030_ ] :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__028_ = Iofm.sexp_of_t sexp_of_int in_hopper__027_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "in_hopper"; arg__028_ ] :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__026_ = sexp_of_int in_bucket__025_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "in_bucket"; arg__026_ ] :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__024_ = Iofm.sexp_of_t sexp_of_int time_in_token_space__023_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "time_in_token_space"; arg__024_ ]
          :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__022_ = Time_ns.sexp_of_t time__021_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "time"; arg__022_ ] :: bnds__018_
          : _ Stdlib.List.t)
       in
       let bnds__018_ =
         let arg__020_ = Time_ns.sexp_of_t start_time__019_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "start_time"; arg__020_ ] :: bnds__018_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__018_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let fill_rate_is_positive_or_zero fill_rate =
  Iofm.is_infinite fill_rate
  || Float.( >= ) (Iofm.get_finite_exn fill_rate : Tokens_per_ns.t :> float) Float.zero
;;

let in_system t =
  if Iofm.is_infinite t.in_hopper
  then Infinite
  else Finite (t.in_flight + Iofm.get_finite_exn t.in_hopper + t.in_bucket)
;;

let invariant t =
  if not (fill_rate_is_positive_or_zero t.hopper_to_bucket_rate_per_ns)
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "hopper_to_bucket_rate_per_ns must be >= 0"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "t.hopper_to_bucket_rate_per_ns"
               ; ((fun x__037_ -> Iofm.sexp_of_t Tokens_per_ns.sexp_of_t x__037_)
                    [@merlin.hide])
                   t.hopper_to_bucket_rate_per_ns
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  if t.in_bucket > t.bucket_limit
  then
    failwithf
      ((Format
          ( String_literal
              ( "amount in_bucket ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__039_ -> Int.to_string _custom_printf__039_)
                  , String_literal
                      ( ") cannot be greater than bucket_limit ("
                      , Custom
                          ( Custom_succ Custom_zero
                          , (fun () _custom_printf__038_ ->
                              Int.to_string _custom_printf__038_)
                          , Char_literal (')', End_of_format) ) ) ) )
          , "amount in_bucket (%{Int}) cannot be greater than bucket_limit (%{Int})" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      t.in_bucket
      t.bucket_limit
      ();
  if t.bucket_limit <= 0
  then
    failwithf
      ((Format
          ( String_literal
              ( "bucket_limit (burst_size) ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__040_ -> Int.to_string _custom_printf__040_)
                  , String_literal (") must be > 0", End_of_format) ) )
          , "bucket_limit (burst_size) (%{Int}) must be > 0" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      t.bucket_limit
      ();
  if t.in_bucket < 0
  then
    failwithf
      ((Format
          ( String_literal
              ( "in_bucket ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__041_ -> Int.to_string _custom_printf__041_)
                  , String_literal (") must be >= 0.", End_of_format) ) )
          , "in_bucket (%{Int}) must be >= 0." )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      t.in_bucket
      ();
  (match Iofm.to_ordinary t.in_hopper with
   | Infinite -> ()
   | Finite in_hopper ->
     if in_hopper < 0
     then
       failwithf
         ((Format
             ( String_literal
                 ( "in_hopper ("
                 , Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__042_ -> Int.to_string _custom_printf__042_)
                     , String_literal (") must be >= 0.", End_of_format) ) )
             , "in_hopper (%{Int}) must be >= 0." )
          : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
          [@merlin.hide])
         in_hopper
         ());
  if t.in_flight < 0
  then
    failwithf
      ((Format
          ( String_literal
              ( "in_flight ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__043_ -> Int.to_string _custom_printf__043_)
                  , String_literal (") must be >= 0.", End_of_format) ) )
          , "in_flight (%{Int}) must be >= 0." )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      t.in_flight
      ();
  match
    ( Iofm.to_ordinary t.hopper_to_bucket_rate_per_ns
    , Iofm.to_ordinary t.time_in_token_space )
  with
  | Infinite, Finite _ | Finite _, Infinite ->
    failwith
      "hopper_to_bucket_rate_per_sec can only be infinite if time_in_token_space is \
       infinite"
  | Infinite, Infinite | Finite _, Finite _ -> ()
;;

type limiter = t [@@deriving sexp_of]

include struct
  let _ = fun (_ : limiter) -> ()
  let sexp_of_limiter = (sexp_of_t : limiter -> Sexplib0.Sexp.t)
  let _ = sexp_of_limiter
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let create_exn
      ~now
      ~hopper_to_bucket_rate_per_sec
      ~bucket_limit
      ~in_flight_limit
      ~initial_bucket_level
      ~initial_hopper_level
  =
  let in_hopper = Iofm.of_ordinary initial_hopper_level in
  let time_in_token_space =
    match hopper_to_bucket_rate_per_sec with
    | Infinite -> Iofm.infinite ()
    | Finite _ -> Iofm.finite 0
  in
  let hopper_to_bucket_rate_per_ns =
    match hopper_to_bucket_rate_per_sec with
    | Infinite -> Iofm.infinite ()
    | Finite rate_per_sec ->
      Iofm.finite (Tokens_per_ns.of_tokens_per_sec (Tokens_per_sec.create rate_per_sec))
  in
  let t =
    { start_time = now
    ; time = now
    ; time_in_token_space
    ; in_bucket = initial_bucket_level
    ; in_hopper
    ; in_flight = 0
    ; bucket_limit
    ; in_flight_limit = Iofm.of_ordinary in_flight_limit
    ; hopper_to_bucket_rate_per_ns
    }
  in
  invariant t;
  t
;;

let move_from_hopper_to_bucket t max_move =
  let space_in_bucket = t.bucket_limit - t.in_bucket in
  let actual_move = Int.min max_move space_in_bucket in
  if actual_move > 0
  then (
    t.in_bucket <- t.in_bucket + actual_move;
    if Iofm.is_finite t.in_hopper
    then Iofm.set_finite t.in_hopper (Iofm.get_finite_exn t.in_hopper - actual_move))
;;

let update_time_in_token_space (t : t) =
  if Iofm.is_finite t.hopper_to_bucket_rate_per_ns
  then (
    let tokens_per_ns = Iofm.get_finite_exn t.hopper_to_bucket_rate_per_ns in
    let time_in_token_space =
      Tokens_per_ns.to_tokens tokens_per_ns (Time_ns.diff t.time t.start_time)
    in
    Iofm.set_finite t.time_in_token_space time_in_token_space)
;;

let advance_time =
  let update_tokens t =
    if Iofm.is_infinite t.time_in_token_space
    then (
      let max_move =
        if Iofm.is_infinite t.in_hopper
        then t.bucket_limit
        else Iofm.get_finite_exn t.in_hopper
      in
      move_from_hopper_to_bucket t max_move)
    else (
      let previous_time_in_token_space = Iofm.get_finite_exn t.time_in_token_space in
      update_time_in_token_space t;
      let new_time_in_token_space = Iofm.get_finite_exn t.time_in_token_space in
      let amount_that_could_fall =
        new_time_in_token_space - previous_time_in_token_space
      in
      let max_move =
        if Iofm.is_infinite t.in_hopper
        then amount_that_could_fall
        else Int.min (Iofm.get_finite_exn t.in_hopper) amount_that_could_fall
      in
      move_from_hopper_to_bucket t max_move)
  in
  fun t ~now ->
    if Time_ns.( > ) now t.time then t.time <- now;
    update_tokens t
;;

let can_put_n_tokens_in_flight t ~n =
  if Iofm.is_infinite t.in_flight_limit
  then true
  else t.in_flight + n <= Iofm.get_finite_exn t.in_flight_limit
;;

let try_take t ~now amount : Try_take_result.t =
  advance_time t ~now;
  if not (can_put_n_tokens_in_flight t ~n:amount)
  then Unable
  else if amount > t.bucket_limit
  then Asked_for_more_than_bucket_limit
  else if amount > t.in_bucket
  then Unable
  else (
    t.in_bucket <- t.in_bucket - amount;
    t.in_flight <- t.in_flight + amount;
    Taken)
;;

let return_to_hopper t ~now amount =
  if amount < 0
  then
    failwithf
      ((Format
          ( String_literal
              ( "return_to_hopper passed a negative amount ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__044_ -> Int.to_string _custom_printf__044_)
                  , Char_literal (')', End_of_format) ) )
          , "return_to_hopper passed a negative amount (%{Int})" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      amount
      ();
  if amount > t.in_flight
  then
    failwithf
      ((Format
          ( String_literal
              ( "return_to_hopper passed an amount ("
              , Custom
                  ( Custom_succ Custom_zero
                  , (fun () _custom_printf__046_ -> Int.to_string _custom_printf__046_)
                  , String_literal
                      ( ") > in_flight ("
                      , Custom
                          ( Custom_succ Custom_zero
                          , (fun () _custom_printf__045_ ->
                              Int.to_string _custom_printf__045_)
                          , Char_literal (')', End_of_format) ) ) ) )
          , "return_to_hopper passed an amount (%{Int}) > in_flight (%{Int})" )
       : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
       [@merlin.hide])
      amount
      t.in_flight
      ();
  advance_time t ~now;
  t.in_flight <- t.in_flight - amount;
  if Iofm.is_finite t.in_hopper
  then Iofm.set_finite t.in_hopper (Iofm.get_finite_exn t.in_hopper + amount)
;;

let try_return_to_bucket t ~now amount : Try_return_to_bucket_result.t =
  advance_time t ~now;
  let space_in_bucket = t.bucket_limit - t.in_bucket in
  if amount < 0 || amount > t.in_flight || amount > space_in_bucket
  then Unable
  else (
    t.in_flight <- t.in_flight - amount;
    t.in_bucket <- t.in_bucket + amount;
    Returned_to_bucket)
;;

let tokens_may_be_available_when t ~now amount : Tokens_may_be_available_result.t =
  if not (can_put_n_tokens_in_flight t ~n:amount)
  then When_return_to_hopper_is_called
  else if amount > t.bucket_limit
  then Never_because_greater_than_bucket_limit
  else (
    advance_time t ~now;
    let amount_missing = amount - t.in_bucket in
    if amount_missing <= 0
    then At t.time
    else if Iofm.is_infinite t.hopper_to_bucket_rate_per_ns
    then When_return_to_hopper_is_called
    else (
      let tokens_per_ns = Iofm.get_finite_exn t.hopper_to_bucket_rate_per_ns in
      let min_time_left =
        Tokens_per_sec.to_span
          (Tokens_per_ns.to_tokens_per_sec tokens_per_ns)
          ~tokens:amount_missing
      in
      let min_time : Tokens_may_be_available_result.t =
        At (Time_ns.add t.time min_time_left)
      in
      if Iofm.is_infinite t.in_hopper
      then min_time
      else if amount_missing > Iofm.get_finite_exn t.in_hopper
      then When_return_to_hopper_is_called
      else min_time))
;;

let in_bucket t ~now =
  advance_time t ~now;
  t.in_bucket
;;

let in_hopper t ~now =
  advance_time t ~now;
  Iofm.to_ordinary t.in_hopper
;;

let in_flight t ~now =
  advance_time t ~now;
  t.in_flight
;;

let in_limiter t ~now =
  match in_hopper t ~now with
  | Infinite -> Infinite
  | Finite in_hopper -> Finite (in_bucket t ~now + in_hopper)
;;

let in_system t ~now =
  advance_time t ~now;
  in_system t
;;

let bucket_limit t = t.bucket_limit

let hopper_to_bucket_rate_per_sec t =
  if Iofm.is_infinite t.hopper_to_bucket_rate_per_ns
  then Infinite
  else
    Finite
      (Tokens_per_ns.to_tokens_per_sec
         (Iofm.get_finite_exn t.hopper_to_bucket_rate_per_ns)
        :> float)
;;

module Token_bucket = struct
  type t = limiter [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (sexp_of_limiter : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create_exn
        ~now
        ~burst_size:bucket_limit
        ~sustained_rate_per_sec:fill_rate
        ?(initial_bucket_level = 0)
        ()
    =
    create_exn
      ~now
      ~bucket_limit
      ~in_flight_limit:Infinite
      ~hopper_to_bucket_rate_per_sec:(Finite fill_rate)
      ~initial_bucket_level
      ~initial_hopper_level:Infinite
  ;;

  let try_take = try_take

  module Starts_full = struct
    type nonrec t = t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create_exn ~now ~burst_size =
      create_exn ~now ~burst_size ~initial_bucket_level:burst_size ()
    ;;

    let try_reconfigure
          t
          ~burst_size:new_bucket_limit
          ~sustained_rate_per_sec:new_sustained_rate_per_sec
          ~allow_limit_decrease
      : Try_reconfigure_result.t
      =
      let used = t.bucket_limit - t.in_bucket in
      if
        ((not allow_limit_decrease) && t.bucket_limit > new_bucket_limit)
        || used > new_bucket_limit
      then Unable
      else (
        let hopper_to_bucket_rate_per_ns =
          Iofm.finite
            (Tokens_per_ns.of_tokens_per_sec
               (Tokens_per_sec.create new_sustained_rate_per_sec))
        in
        if not (fill_rate_is_positive_or_zero hopper_to_bucket_rate_per_ns)
        then Unable
        else (
          t.in_bucket <- new_bucket_limit - used;
          t.bucket_limit <- new_bucket_limit;
          t.hopper_to_bucket_rate_per_ns <- hopper_to_bucket_rate_per_ns;
          Reconfigured))
    ;;
  end
end

module Throttled_rate_limiter = struct
  type t = limiter [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (sexp_of_limiter : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create_exn ~now ~burst_size ~sustained_rate_per_sec:fill_rate ~max_concurrent_jobs =
    let bucket_limit = burst_size in
    let initial_bucket_level = Int.min bucket_limit max_concurrent_jobs in
    let initial_hopper_level =
      Finite (Int.max 0 (max_concurrent_jobs - initial_bucket_level))
    in
    create_exn
      ~now
      ~bucket_limit
      ~in_flight_limit:Infinite
      ~hopper_to_bucket_rate_per_sec:(Finite fill_rate)
      ~initial_bucket_level
      ~initial_hopper_level
  ;;

  let try_start_job t ~now =
    match try_take t ~now 1 with
    | Asked_for_more_than_bucket_limit -> assert false
    | Taken -> `Start
    | Unable ->
      (match tokens_may_be_available_when t ~now 1 with
       | Never_because_greater_than_bucket_limit -> assert false
       | When_return_to_hopper_is_called -> `Max_concurrent_jobs_running
       | At time -> `Unable_until_at_least time)
  ;;

  let finish_job t ~now = return_to_hopper t ~now 1
end

module Throttle = struct
  include Throttled_rate_limiter

  let create_exn ~now ~max_concurrent_jobs =
    let sustained_rate_unused = 1. in
    let t =
      create_exn
        ~now
        ~burst_size:max_concurrent_jobs
        ~sustained_rate_per_sec:sustained_rate_unused
        ~max_concurrent_jobs
    in
    Iofm.set_infinite t.hopper_to_bucket_rate_per_ns;
    Iofm.set_infinite t.time_in_token_space;
    t.in_bucket <- t.bucket_limit;
    t
  ;;

  let try_start_job t ~now =
    match try_start_job t ~now with
    | `Start -> `Start
    | `Max_concurrent_jobs_running -> `Max_concurrent_jobs_running
    | `Unable_until_at_least _ -> assert false
  ;;
end

module Expert = struct
  let create_exn = create_exn
  let try_take = try_take
  let return_to_hopper = return_to_hopper
  let try_return_to_bucket = try_return_to_bucket
  let tokens_may_be_available_when = tokens_may_be_available_when
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
