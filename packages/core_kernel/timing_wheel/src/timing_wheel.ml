let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timing_wheel.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timing_wheel.ml.before-ppx"
;;

open! Core
open! Import
open! Timing_wheel_intf
module Pool = Tuple_pool
module Time_ns = Core_private.Time_ns_alternate_sexp

let sexp_of_t_style : [ `Pretty | `Internal ] ref = ref `Pretty
let max_time = Time_ns.max_value_representable
let min_time = Time_ns.epoch

module Num_key_bits : sig
  type t = private int [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable with type t := t
  include Invariant.S with type t := t

  val zero : t
  val max_value : t
  val to_int : t -> int
  val of_int : int -> t
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val pow2 : t -> Int63.t
end = struct
  include Int

  let min_value = 0

  let max_value = Int63.num_bits - 1
  [@@ocaml.doc " We support all non-negative [Time_ns.t] values. "]
  ;;

  let invariant t =
    assert (t >= min_value);
    assert (t <= max_value)
  ;;

  let of_int i =
    invariant i;
    i
  ;;

  let ( + ) t1 t2 =
    let t = t1 + t2 in
    invariant t;
    t
  ;;

  let ( - ) t1 t2 =
    let t = t1 - t2 in
    invariant t;
    t
  ;;

  let pow2 t = Int63.shift_left Int63.one t
end

module Level_bits = struct
  type t = Num_key_bits.t list [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ ->
         compare_list
           (fun a__003_ (b__004_ [@merlin.hide]) ->
              (Num_key_bits.compare a__003_ b__004_ [@merlin.hide]))
           a__001_
           b__002_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let t_of_sexp =
      (fun x__006_ -> list_of_sexp Num_key_bits.t_of_sexp x__006_ : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__007_ -> sexp_of_list Num_key_bits.sexp_of_t x__007_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let max_num_bits = (Num_key_bits.max_value :> int)
  let num_bits_internal t = List.fold t ~init:Num_key_bits.zero ~f:Num_key_bits.( + )
  let num_bits t = (num_bits_internal t :> int)

  let invariant t =
    assert (not (List.is_empty t));
    List.iter t ~f:(fun num_key_bits ->
      Num_key_bits.invariant num_key_bits;
      assert (Num_key_bits.( > ) num_key_bits Num_key_bits.zero));
    Num_key_bits.invariant (num_bits_internal t)
  ;;

  let t_of_sexp sexp =
    let t = (t_of_sexp [@merlin.hide]) sexp in
    invariant t;
    t
  ;;

  let create_exn ?(extend_to_max_num_bits = false) ints =
    if List.is_empty ints then failwith "Level_bits.create_exn requires a nonempty list";
    if List.exists ints ~f:(fun bits -> bits <= 0)
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Level_bits.create_exn got nonpositive num bits"
             ; ((fun x__008_ -> sexp_of_list sexp_of_int x__008_) [@merlin.hide]) ints
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    let num_bits = List.fold ints ~init:0 ~f:( + ) in
    if num_bits > max_num_bits
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Level_bits.create_exn got too many bits"
             ; ((fun x__009_ -> sexp_of_list sexp_of_int x__009_) [@merlin.hide]) ints
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "got"
                 ; (sexp_of_int [@merlin.hide]) num_bits
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "max_num_bits"
                 ; (sexp_of_int [@merlin.hide]) max_num_bits
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    let ints =
      if extend_to_max_num_bits
      then ints @ List.init (max_num_bits - num_bits) ~f:(const 1)
      else ints
    in
    List.map ints ~f:Num_key_bits.of_int
  ;;

  let default = create_exn [ 11; 10; 10; 10; 10; 10; 1 ]

  let trim t ~max_num_bits =
    if Num_key_bits.( <= ) (num_bits_internal t) max_num_bits
    then t
    else (
      let rec loop t ~remaining =
        match t with
        | [] -> []
        | b :: t ->
          if Num_key_bits.( >= ) b remaining
          then [ remaining ]
          else b :: loop t ~remaining:(Num_key_bits.( - ) remaining b)
      in
      loop t ~remaining:max_num_bits)
  ;;
end

module Alarm_precision : sig
  include Alarm_precision

  val num_key_bits : t -> Num_key_bits.t
  val interval_num : t -> Time_ns.t -> Int63.t
  val interval_num_start : t -> Int63.t -> Time_ns.t
end = struct
  type t = int
  [@@ocaml.doc " [t] is represented as the log2 of a number of nanoseconds. "]
  [@@deriving compare, hash]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__010_ b__011_ -> compare_int a__010_ b__011_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> hash_fold_int hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = hash_int in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let equal (_x__012_ : t) _x__013_ =
    (match
       (fun (a__014_ : t) ((b__015_ : t) [@merlin.hide]) ->
          (compare a__014_ b__015_ [@merlin.hide]))
         _x__012_
         _x__013_
     with
     | 0 -> true
     | _ -> false)
    [@merlin.hide]
  ;;

  let num_key_bits t = Num_key_bits.of_int t

  let to_span t =
    if t < 0
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "[Alarm_precision.to_span] of negative power of two nanoseconds"
             ; (sexp_of_int [@merlin.hide]) t
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    Time_ns.Span.of_int63_ns
      ((let open Int63 in
        shift_left one)
         t)
  ;;

  let sexp_of_t t = (Time_ns.Span.sexp_of_t [@merlin.hide]) (to_span t)
  let one_nanosecond = 0
  let about_one_microsecond = 10
  let about_one_millisecond = 20
  let about_one_second = 30
  let about_one_day = 46
  let mul t ~pow2 = t + pow2
  let div t ~pow2 = t - pow2
  let interval_num t time = Int63.shift_right (Time_ns.to_int63_ns_since_epoch time) t

  let interval_num_start t interval_num =
    Time_ns.of_int63_ns_since_epoch (Int63.shift_left interval_num t)
  ;;

  let of_span_floor_pow2_ns span =
    if Time_ns.Span.( <= ) span Time_ns.Span.zero
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "[Alarm_precision.of_span_floor_pow2_ns] got non-positive span"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "span"
                 ; (Time_ns.Span.sexp_of_t [@merlin.hide]) span
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    Int63.floor_log2 (Time_ns.Span.to_int63_ns span)
  ;;

  let of_span = of_span_floor_pow2_ns

  module Unstable = struct
    module T = struct
      type nonrec t = t [@@deriving compare]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__016_ b__017_ -> compare a__016_ b__017_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_binable = of_span_floor_pow2_ns
      let to_binable = to_span
      let of_sexpable = of_span_floor_pow2_ns
      let to_sexpable = to_span
    end

    include T
    include Binable.Of_binable_without_uuid [@alert "-legacy"] (Time_ns.Span) (T)
    include Sexpable.Of_sexpable (Time_ns.Span) (T)
  end
end

module Config = struct
  let level_bits_default = Level_bits.default

  type t =
    { alarm_precision : Alarm_precision.Unstable.t
    ; level_bits : Level_bits.t [@default level_bits_default]
    ; capacity : int option [@sexp.option]
    }
  [@@deriving fields ~getters ~iterators:iter, sexp]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()
    let capacity _r__ = _r__.capacity
    let _ = capacity
    let level_bits _r__ = _r__.level_bits
    let _ = level_bits
    let alarm_precision _r__ = _r__.alarm_precision
    let _ = alarm_precision

    module Fields = struct
      let capacity =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "capacity"
           ; getter = capacity
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with capacity = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int option) Fieldslib.Field.t_with_perm)
      ;;

      let _ = capacity

      let level_bits =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "level_bits"
           ; getter = level_bits
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with level_bits = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Level_bits.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = level_bits

      let alarm_precision =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "alarm_precision"
           ; getter = alarm_precision
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with alarm_precision = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , Alarm_precision.Unstable.t )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = alarm_precision

      let iter
            ~alarm_precision:alarm_precision_fun__
            ~level_bits:level_bits_fun__
            ~capacity:capacity_fun__
        =
        (alarm_precision_fun__ alarm_precision : unit);
        (level_bits_fun__ level_bits : unit);
        (capacity_fun__ capacity : unit)
      ;;

      let _ = iter
    end

    let t_of_sexp =
      (let default__020_ : Level_bits.t = level_bits_default in
       let error_source__019_ = "timing_wheel.ml.before-ppx.Config.t" in
       fun x__021_ ->
         Sexplib0.Sexp_conv_record.record_of_sexp
           ~caller:error_source__019_
           ~fields:
             (Field
                { name = "alarm_precision"
                ; kind = Required
                ; conv = Alarm_precision.Unstable.t_of_sexp
                ; rest =
                    Field
                      { name = "level_bits"
                      ; kind = Default (fun () -> default__020_)
                      ; conv = Level_bits.t_of_sexp
                      ; rest =
                          Field
                            { name = "capacity"
                            ; kind = Sexp_option
                            ; conv = int_of_sexp
                            ; rest = Empty
                            }
                      }
                })
           ~index_of_field:(function
             | "alarm_precision" -> 0
             | "level_bits" -> 1
             | "capacity" -> 2
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (alarm_precision, (level_bits, (capacity, ()))) ->
             ({ alarm_precision; level_bits; capacity } : t))
           x__021_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun { alarm_precision = alarm_precision__023_
           ; level_bits = level_bits__025_
           ; capacity = capacity__027_
           } ->
         let bnds__022_ = ([] : _ Stdlib.List.t) in
         let bnds__022_ =
           match capacity__027_ with
           | Stdlib.Option.None -> bnds__022_
           | Stdlib.Option.Some v__028_ ->
             let arg__030_ = sexp_of_int v__028_ in
             let bnd__029_ =
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "capacity"; arg__030_ ]
             in
             (bnd__029_ :: bnds__022_ : _ Stdlib.List.t)
         in
         let bnds__022_ =
           let arg__026_ = Level_bits.sexp_of_t level_bits__025_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "level_bits"; arg__026_ ]
            :: bnds__022_
            : _ Stdlib.List.t)
         in
         let bnds__022_ =
           let arg__024_ = Alarm_precision.Unstable.sexp_of_t alarm_precision__023_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alarm_precision"; arg__024_ ]
            :: bnds__022_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__022_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let alarm_precision t = Alarm_precision.to_span t.alarm_precision

  let max_num_level_bits alarm_precision =
    Num_key_bits.( - )
      Num_key_bits.max_value
      (Alarm_precision.num_key_bits alarm_precision)
  ;;

  let invariant t =
    Invariant.invariant
      { Ppx_here_lib.pos_fname = "timing_wheel.ml.before-ppx"
      ; pos_lnum = 256
      ; pos_cnum = 8310
      ; pos_bol = 8286
      }
      t
      (sexp_of_t [@merlin.hide])
      (fun () ->
         assert (
           Num_key_bits.( <= )
             (Level_bits.num_bits_internal t.level_bits)
             (max_num_level_bits t.alarm_precision));
         let check f = Invariant.check_field t f in
         Fields.iter
           ~alarm_precision:ignore
           ~capacity:ignore
           ~level_bits:(check Level_bits.invariant))
  ;;

  let create ?capacity ?(level_bits = level_bits_default) ~alarm_precision () =
    let level_bits =
      Level_bits.trim level_bits ~max_num_bits:(max_num_level_bits alarm_precision)
    in
    { alarm_precision; level_bits; capacity }
  ;;

  let microsecond_precision () =
    create
      ()
      ~alarm_precision:Alarm_precision.about_one_microsecond
      ~level_bits:(Level_bits.create_exn [ 10; 10; 6; 6; 5 ])
  ;;

  let durations t =
    List.folding_map
      t.level_bits
      ~init:(Num_key_bits.to_int (Alarm_precision.num_key_bits t.alarm_precision))
      ~f:(fun num_bits_accum level_num_bits ->
        let num_bits_accum = num_bits_accum + Num_key_bits.to_int level_num_bits in
        let duration =
          Time_ns.Span.of_int63_ns
            (if num_bits_accum = Int63.num_bits - 1
             then Int63.max_value
             else Int63.shift_left Int63.one num_bits_accum)
        in
        num_bits_accum, duration)
  ;;
end

module Priority_queue : sig
  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a priority_queue = 'a t

  module Key : Interval_num

  module Elt : sig
    type 'a t
    [@@ocaml.doc " An [Elt.t] represents an element that was added to a timing wheel. "]
    [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val at : 'a priority_queue -> 'a t -> Time_ns.t
    val key : 'a priority_queue -> 'a t -> Key.t
    val value : 'a priority_queue -> 'a t -> 'a
    val null : unit -> 'a t
  end

  module Internal_elt : sig
    module Pool : sig
      type 'a t
    end

    type 'a t

    val key : 'a Pool.t -> 'a t -> Key.t
    val max_alarm_time : 'a Pool.t -> 'a t -> with_key:Key.t -> Time_ns.t
    val min_alarm_time : 'a Pool.t -> 'a t -> with_key:Key.t -> Time_ns.t
    val is_null : _ t -> bool
    val to_external : 'a t -> 'a Elt.t
  end

  val pool : 'a t -> 'a Internal_elt.Pool.t

  include Invariant.S1 with type 'a t := 'a t

  val create : ?capacity:int -> ?level_bits:Level_bits.t -> unit -> 'a t
  [@@ocaml.doc
    " [create ?level_bits ()] creates a new empty timing wheel, [t], with [length t = 0]\n\
    \      and [min_allowed_key t = 0]. "]

  val length : _ t -> int
  [@@ocaml.doc " [length t] returns the number of elements in the timing wheel. "]

  val min_allowed_key : _ t -> Key.t
  [@@ocaml.doc
    " [min_allowed_key t] is the minimum key that can be stored in [t].  This only\n\
    \      indicates the possibility; there need not be an element [elt] in [t] with \
     [Elt.key\n\
    \      elt = min_allowed_key t].  This is not the same as the \"min_key\" operation \
     in a\n\
    \      typical priority queue.\n\n\
    \      [min_allowed_key t] can increase over time, via calls to\n\
    \      [increase_min_allowed_key]. "]

  val max_allowed_key : _ t -> Key.t
  [@@ocaml.doc
    " [max_allowed_key t] is the maximum allowed key that can be stored in [t].  As\n\
    \      [min_allowed_key] increases, so does [max_allowed_key]; however it is not the \
     case\n\
    \      that [max_allowed_key t - min_allowed_key t] is a constant.  It is guaranteed \
     that\n\
    \      [max_allowed_key t >= min_allowed_key t + 2^B - 1],\n\
    \      where [B] is the sum of the b_i in [level_bits]. "]

  val min_elt_ : 'a t -> 'a Internal_elt.t
  val internal_add : 'a t -> key:Key.t -> at:Time_ns.t -> 'a -> 'a Internal_elt.t

  val remove : 'a t -> 'a Elt.t -> unit
  [@@ocaml.doc
    " [remove t elt] removes [elt] from [t].  It is an error if [elt] is not currently\n\
    \      in [t], and this error may or may not be detected. "]

  val change : 'a t -> 'a Elt.t -> key:Key.t -> at:Time_ns.t -> unit

  val clear : _ t -> unit [@@ocaml.doc " [clear t] removes all elts from [t]. "]

  val mem : 'a t -> 'a Elt.t -> bool

  module Increase_min_allowed_key_result : sig
    type t =
      | Max_allowed_key_did_not_change
      | Max_allowed_key_maybe_changed
  end

  val increase_min_allowed_key
    :  'a t
    -> key:Key.t
    -> handle_removed:('a Elt.t -> unit)
    -> Increase_min_allowed_key_result.t
  [@@ocaml.doc
    " [increase_min_allowed_key t ~key ~handle_removed] increases the minimum allowed\n\
    \      key in [t] to [key], and removes all elements with keys less than [key], \
     applying\n\
    \      [handle_removed] to each element that is removed.  If [key <= min_allowed_key \
     t],\n\
    \      then [increase_min_allowed_key] does nothing.  Otherwise, if\n\
    \      [increase_min_allowed_key] returns successfully, [min_allowed_key t = key].\n\n\
    \      [increase_min_allowed_key] takes time proportional to [key - min_allowed_key \
     t],\n\
    \      although possibly less time.\n\n\
    \      Behavior is unspecified if [handle_removed] accesses [t] in any way other than\n\
    \      [Elt] functions. "]

  val iter : 'a t -> f:('a Elt.t -> unit) -> unit

  val fire_past_alarms
    :  'a t
    -> handle_fired:('a Elt.t -> unit)
    -> key:Key.t
    -> now:Time_ns.t
    -> unit
end = struct
  module Pool = Pool.Unsafe
  [@@ocaml.doc
    " Each slot in a level is a (possibly null) pointer to a circular doubly-linked list\n\
    \      of elements.  We pool the elements so that we can reuse them after they are \
     removed\n\
    \      from the timing wheel (either via [remove] or [increase_min_allowed_key]).  In\n\
    \      addition to storing the [key], [at], and [value] in the element, we store the\n\
    \      [level_index] so that we can quickly get to the level holding an element when \
     we\n\
    \      [remove] it.\n\n\
    \      We distinguish between [External_elt] and [Internal_elt], which are the same\n\
    \      underneath.  We maintain the invariant that an [Internal_elt] is either \
     [null] or a\n\
    \      valid pointer.  On the other hand, [External_elt]s are returned to user code, \
     so\n\
    \      there is no guarantee of validity -- we always validate an [External_elt] \
     before\n\
    \      doing anything with it.\n\n\
    \      It is therefore OK to use [Pool.Unsafe], because we will never attempt to \
     access a\n\
    \      slot of an invalid pointer. "]

  module Pointer = Pool.Pointer

  module Key : sig
    include
      Timing_wheel_intf.Interval_num
    [@@ocaml.doc
      " [Interval_num] is the public API.  Everything following in the signature is\n\
      \        for internal use. "]

    val add_clamp_to_max : t -> Span.t -> t
    [@@ocaml.doc " [add_clamp_to_max] doesn't work at all with negative spans "]

    val succ_clamp_to_max : t -> t

    module Slots_mask : sig
      type t = private Int63.t [@@deriving compare, sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val create : level_bits:Num_key_bits.t -> t
      val next_slot : t -> int -> int
    end
    [@@ocaml.doc
      " [Slots_mask] is used to quickly determine a key's slot in a given level. "]

    module Min_key_in_same_slot_mask : sig
      type t = private Int63.t [@@deriving compare, sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Equal.S with type t := t

      val create : bits_per_slot:Num_key_bits.t -> t
    end
    [@@ocaml.doc
      " [Min_key_in_same_slot_mask] is used to quickly determine the minimum key in the\n\
      \        same slot as a given key. "]

    val num_keys : Num_key_bits.t -> Span.t
    val min_key_in_same_slot : t -> Min_key_in_same_slot_mask.t -> t
    val slot : t -> bits_per_slot:Num_key_bits.t -> slots_mask:Slots_mask.t -> int
  end = struct
    module Slots_mask = struct
      type t = Int63.t [@@deriving compare, sexp_of]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__031_ b__032_ -> Int63.compare a__031_ b__032_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let sexp_of_t = (Int63.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let create ~level_bits = Int63.( - ) (Num_key_bits.pow2 level_bits) Int63.one
      let next_slot t slot = (slot + 1) land Int63.to_int_exn t
    end

    let num_keys num_bits = Num_key_bits.pow2 num_bits

    module Min_key_in_same_slot_mask = struct
      include Int63

      let create ~bits_per_slot = bit_not (Num_key_bits.pow2 bits_per_slot - one)
    end

    module Span = struct
      include Int63

      let to_int63 t = t
      let of_int63 i = i
      let scale_int t i = t * of_int i
    end

    include Int63

    let of_int63 i = i
    let to_int63 t = t
    let add t i = t + i
    let add_clamp_to_max t i = if t > max_value - i then max_value else t + i
    let succ_clamp_to_max t = if t = max_value then max_value else succ t
    let sub t i = t - i
    let diff t1 t2 = t1 - t2

    let slot t ~(bits_per_slot : Num_key_bits.t) ~slots_mask =
      to_int_exn (bit_and (shift_right t (bits_per_slot :> int)) slots_mask)
    ;;

    let min_key_in_same_slot t min_key_in_same_slot_mask =
      bit_and t min_key_in_same_slot_mask
    ;;
  end

  module Min_key_in_same_slot_mask = Key.Min_key_in_same_slot_mask
  module Slots_mask = Key.Slots_mask

  module External_elt = struct
    type 'a pool_slots =
      ( Key.t
        , Time_ns.t
        , 'a
        , int
        , 'a pool_slots Pointer.t
        , 'a pool_slots Pointer.t )
        Pool.Slots.t6
    [@@ocaml.doc
      " The [pool_slots] here has nothing to do with the slots in a level array.  This is\n\
      \        for the slots in the pool tuple representing a level element. "]
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a pool_slots) -> ()

      let rec sexp_of_pool_slots
        : 'a. ('a -> Sexplib0.Sexp.t) -> 'a pool_slots -> Sexplib0.Sexp.t
        =
        fun _of_a__033_ x__034_ ->
        Pool.Slots.sexp_of_t6
          Key.sexp_of_t
          Time_ns.sexp_of_t
          _of_a__033_
          sexp_of_int
          (Pointer.sexp_of_t (sexp_of_pool_slots _of_a__033_))
          (Pointer.sexp_of_t (sexp_of_pool_slots _of_a__033_))
          x__034_
      ;;

      let _ = sexp_of_pool_slots
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a t = 'a pool_slots Pointer.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__035_ x__036_ ->
        Pointer.sexp_of_t (sexp_of_pool_slots _of_a__035_) x__036_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let null = Pointer.null
  end

  module Internal_elt : sig
    module Pool : sig
      type 'a t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Invariant.S1 with type 'a t := 'a t

      val create : ?capacity:int -> unit -> _ t
      val is_full : _ t -> bool
      val grow : ?capacity:int -> 'a t -> 'a t
    end

    type 'a t = private 'a External_elt.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val null : unit -> _ t
    val is_null : _ t -> bool
    val is_valid : 'a Pool.t -> 'a t -> bool

    [@@@ocaml.text " Dealing with [External_elt]s. "]

    val external_is_valid : 'a Pool.t -> 'a External_elt.t -> bool
    val to_external : 'a t -> 'a External_elt.t
    val of_external_exn : 'a Pool.t -> 'a External_elt.t -> 'a t
    val equal : 'a t -> 'a t -> bool
    val invariant : 'a Pool.t -> ('a -> unit) -> 'a t -> unit

    val create
      :  'a Pool.t
      -> key:
           (Key.t
           [@ocaml.doc
             " [at] is used when the priority queue is used to implement a timing \
              wheel.  If\n\
             \          unused, it will be [Time_ns.epoch]. "])
      -> at:Time_ns.t
      -> value:'a
      -> level_index:int
      -> 'a t
    [@@ocaml.doc " [create] returns an element whose [next] and [prev] are [null]. "]

    val free : 'a Pool.t -> 'a t -> unit

    [@@@ocaml.text " accessors "]

    val key : 'a Pool.t -> 'a t -> Key.t
    val at : 'a Pool.t -> 'a t -> Time_ns.t
    val level_index : 'a Pool.t -> 'a t -> int
    val next : 'a Pool.t -> 'a t -> 'a t
    val value : 'a Pool.t -> 'a t -> 'a

    [@@@ocaml.text " mutators "]

    val set_key : 'a Pool.t -> 'a t -> Key.t -> unit
    val set_at : 'a Pool.t -> 'a t -> Time_ns.t -> unit
    val set_level_index : 'a Pool.t -> 'a t -> int -> unit

    val insert_at_end : 'a Pool.t -> 'a t -> to_add:'a t -> unit
    [@@ocaml.doc
      " [insert_at_end pool t ~to_add] treats [t] as the head of the list and adds \
       [to_add]\n\
      \        to the end of it. "]

    val link_to_self : 'a Pool.t -> 'a t -> unit
    [@@ocaml.doc
      " [link_to_self pool t] makes [t] be a singleton circular doubly-linked list. "]

    val unlink : 'a Pool.t -> 'a t -> unit
    [@@ocaml.doc
      " [unlink p t] unlinks [t] from the circularly doubly-linked list that it is in.  It\n\
      \        changes the pointers of [t]'s [prev] and [next] elts, but not [t]'s \
       [prev] and\n\
      \        [next] pointers.  [unlink] is meaningless if [t] is a singleton. "]

    val iter : 'a Pool.t -> 'a t -> f:('a t -> unit) -> unit
    [@@ocaml.doc
      " Iterators.  [iter p t ~init ~f] visits each element in the doubly-linked list\n\
      \        containing [t], starting at [t], and following [next] pointers.  [length] \
       counts\n\
      \        by visiting each element in the list. "]

    val length : 'a Pool.t -> 'a t -> int

    val max_alarm_time : 'a Pool.t -> 'a t -> with_key:Key.t -> Time_ns.t
    [@@ocaml.doc
      " [max_alarm_time t elt ~with_key] finds the max [at] in [elt]'s list among the elts\n\
      \        whose key is [with_key], returning [Time_ns.epoch] if the list is empty. "]

    val min_alarm_time : 'a Pool.t -> 'a t -> with_key:Key.t -> Time_ns.t
  end = struct
    type 'a pool_slots = 'a External_elt.pool_slots [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a pool_slots) -> ()

      let sexp_of_pool_slots
        : 'a. ('a -> Sexplib0.Sexp.t) -> 'a pool_slots -> Sexplib0.Sexp.t
        =
        fun _of_a__037_ x__038_ -> External_elt.sexp_of_pool_slots _of_a__037_ x__038_
      ;;

      let _ = sexp_of_pool_slots
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a t = 'a External_elt.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__039_ x__040_ -> External_elt.sexp_of_t _of_a__039_ x__040_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let null = Pointer.null
    let is_null = Pointer.is_null
    let equal t1 t2 = Pointer.phys_equal t1 t2

    let create pool ~key ~at ~value ~level_index =
      Pool.new6 pool key at value level_index (null ()) (null ())
    ;;

    let free = Pool.free
    let key p t = Pool.get p t Pool.Slot.t0
    let set_key p t k = Pool.set p t Pool.Slot.t0 k
    let at p t = Pool.get p t Pool.Slot.t1
    let set_at p t x = Pool.set p t Pool.Slot.t1 x
    let value p t = Pool.get p t Pool.Slot.t2
    let level_index p t = Pool.get p t Pool.Slot.t3
    let set_level_index p t i = Pool.set p t Pool.Slot.t3 i
    let prev p t = Pool.get p t Pool.Slot.t4
    let set_prev p t x = Pool.set p t Pool.Slot.t4 x
    let next p t = Pool.get p t Pool.Slot.t5
    let set_next p t x = Pool.set p t Pool.Slot.t5 x
    let is_valid p t = Pool.pointer_is_valid p t
    let external_is_valid = is_valid

    let invariant pool invariant_a t =
      Invariant.invariant
        { Ppx_here_lib.pos_fname = "timing_wheel.ml.before-ppx"
        ; pos_lnum = 645
        ; pos_cnum = 23101
        ; pos_bol = 23075
        }
        t
        ((fun x__041_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__041_)
           [@merlin.hide])
        (fun () ->
           assert (is_valid pool t);
           invariant_a (value pool t);
           let n = next pool t in
           assert (is_null n || Pointer.phys_equal t (prev pool n));
           let p = prev pool t in
           assert (is_null p || Pointer.phys_equal t (next pool p)))
    ;;

    module Pool = struct
      type 'a t = 'a pool_slots Pool.t [@@deriving sexp_of]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__042_ x__043_ ->
          Pool.sexp_of_t (sexp_of_pool_slots _of_a__042_) x__043_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let invariant _invariant_a t = Pool.invariant ignore t
      let create ?(capacity = 1) () = Pool.create Pool.Slots.t6 ~capacity
      let grow = Pool.grow
      let is_full = Pool.is_full
    end

    let to_external t = t

    let of_external_exn pool t =
      if is_valid pool t
      then t
      else
        raise_s
          (let ppx_sexp_message () =
             Ppx_sexp_conv_lib.Conv.sexp_of_string "Timing_wheel got invalid alarm"
               [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
           in
           (ppx_sexp_message () [@nontail]))
    ;;

    let unlink pool t =
      set_next pool (prev pool t) (next pool t);
      set_prev pool (next pool t) (prev pool t)
    ;;

    let link pool prev next =
      set_next pool prev next;
      set_prev pool next prev
    ;;

    let link_to_self pool t = link pool t t

    let insert_at_end pool t ~to_add =
      let prev = prev pool t in
      link pool prev to_add;
      link pool to_add t
    ;;

    let iter pool first ~f =
      let current = ref first in
      let continue = ref true in
      while !continue do
        let next = next pool !current in
        f !current;
        if phys_equal next first then continue := false else current := next
      done
    ;;

    let length pool first =
      let r = ref 0 in
      let current = ref first in
      let continue = ref true in
      while !continue do
        incr r;
        let next = next pool !current in
        if phys_equal next first then continue := false else current := next
      done;
      !r
    ;;

    let max_alarm_time pool first ~with_key =
      let max_alarm_time = ref Time_ns.epoch in
      let current = ref first in
      let continue = ref true in
      while !continue do
        let next = next pool !current in
        if Key.equal (key pool !current) with_key
        then max_alarm_time := Time_ns.max (at pool !current) !max_alarm_time;
        if phys_equal next first then continue := false else current := next
      done;
      !max_alarm_time
    ;;

    let min_alarm_time pool first ~with_key =
      let min_alarm_time = ref Time_ns.max_value_representable in
      let current = ref first in
      let continue = ref true in
      while !continue do
        let next = next pool !current in
        if Key.equal (key pool !current) with_key
        then min_alarm_time := Time_ns.min (at pool !current) !min_alarm_time;
        if phys_equal next first then continue := false else current := next
      done;
      !min_alarm_time
    ;;
  end

  module Level = struct
    type 'a t =
      { index : int
      ; bits : Num_key_bits.t
      ; slots_mask : Slots_mask.t
      ; bits_per_slot : Num_key_bits.t
      ; keys_per_slot : Key.Span.t
      ; min_key_in_same_slot_mask : Min_key_in_same_slot_mask.t
      ; diff_max_min_allowed_key : Key.Span.t
      ; mutable length : int
      ; mutable min_allowed_key : Key.t
      ; mutable max_allowed_key : Key.t
      ; slots : ('a Internal_elt.t array[@sexp.opaque])
      }
    [@@ocaml.doc
      " For given level, one can break the bits into a key into three regions:\n\n\
      \        {v\n\
      \         | higher levels | this level | lower levels |\n\
      \        v}\n\n\
      \        \"Lower levels\" is [bits_per_slot] bits wide.  \"This level\" is [bits] \
       wide. "]
    [@@deriving fields ~getters ~iterators:iter, sexp_of]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'a t) -> ()
      let slots _r__ = _r__.slots
      let _ = slots
      let max_allowed_key _r__ = _r__.max_allowed_key
      let _ = max_allowed_key
      let set_max_allowed_key _r__ v__ = _r__.max_allowed_key <- v__
      let _ = set_max_allowed_key
      let min_allowed_key _r__ = _r__.min_allowed_key
      let _ = min_allowed_key
      let set_min_allowed_key _r__ v__ = _r__.min_allowed_key <- v__
      let _ = set_min_allowed_key
      let length _r__ = _r__.length
      let _ = length
      let set_length _r__ v__ = _r__.length <- v__
      let _ = set_length
      let diff_max_min_allowed_key _r__ = _r__.diff_max_min_allowed_key
      let _ = diff_max_min_allowed_key
      let min_key_in_same_slot_mask _r__ = _r__.min_key_in_same_slot_mask
      let _ = min_key_in_same_slot_mask
      let keys_per_slot _r__ = _r__.keys_per_slot
      let _ = keys_per_slot
      let bits_per_slot _r__ = _r__.bits_per_slot
      let _ = bits_per_slot
      let slots_mask _r__ = _r__.slots_mask
      let _ = slots_mask
      let bits _r__ = _r__.bits
      let _ = bits
      let index _r__ = _r__.index
      let _ = index

      module Fields = struct
        let slots =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "slots"
             ; getter = slots
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with slots = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , ('a Internal_elt.t array[@sexp.opaque]) )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = slots

        let max_allowed_key =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "max_allowed_key"
             ; getter = max_allowed_key
             ; setter = Some set_max_allowed_key
             ; fset = (fun _r__ v__ -> { _r__ with max_allowed_key = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Key.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = max_allowed_key

        let min_allowed_key =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "min_allowed_key"
             ; getter = min_allowed_key
             ; setter = Some set_min_allowed_key
             ; fset = (fun _r__ v__ -> { _r__ with min_allowed_key = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Key.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = min_allowed_key

        let length =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "length"
             ; getter = length
             ; setter = Some set_length
             ; fset = (fun _r__ v__ -> { _r__ with length = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = length

        let diff_max_min_allowed_key =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "diff_max_min_allowed_key"
             ; getter = diff_max_min_allowed_key
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with diff_max_min_allowed_key = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Key.Span.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = diff_max_min_allowed_key

        let min_key_in_same_slot_mask =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "min_key_in_same_slot_mask"
             ; getter = min_key_in_same_slot_mask
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with min_key_in_same_slot_mask = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , Min_key_in_same_slot_mask.t )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = min_key_in_same_slot_mask

        let keys_per_slot =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "keys_per_slot"
             ; getter = keys_per_slot
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with keys_per_slot = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Key.Span.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = keys_per_slot

        let bits_per_slot =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "bits_per_slot"
             ; getter = bits_per_slot
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with bits_per_slot = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Num_key_bits.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = bits_per_slot

        let slots_mask =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "slots_mask"
             ; getter = slots_mask
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with slots_mask = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Slots_mask.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = slots_mask

        let bits =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "bits"
             ; getter = bits
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with bits = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Num_key_bits.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = bits

        let index =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "index"
             ; getter = index
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with index = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = index

        let iter
              ~index:index_fun__
              ~bits:bits_fun__
              ~slots_mask:slots_mask_fun__
              ~bits_per_slot:bits_per_slot_fun__
              ~keys_per_slot:keys_per_slot_fun__
              ~min_key_in_same_slot_mask:min_key_in_same_slot_mask_fun__
              ~diff_max_min_allowed_key:diff_max_min_allowed_key_fun__
              ~length:length_fun__
              ~min_allowed_key:min_allowed_key_fun__
              ~max_allowed_key:max_allowed_key_fun__
              ~slots:slots_fun__
          =
          (index_fun__ index : unit);
          (bits_fun__ bits : unit);
          (slots_mask_fun__ slots_mask : unit);
          (bits_per_slot_fun__ bits_per_slot : unit);
          (keys_per_slot_fun__ keys_per_slot : unit);
          (min_key_in_same_slot_mask_fun__ min_key_in_same_slot_mask : unit);
          (diff_max_min_allowed_key_fun__ diff_max_min_allowed_key : unit);
          (length_fun__ length : unit);
          (min_allowed_key_fun__ min_allowed_key : unit);
          (max_allowed_key_fun__ max_allowed_key : unit);
          (slots_fun__ slots : unit)
        ;;

        let _ = iter
      end

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__044_
          { index = index__046_
          ; bits = bits__048_
          ; slots_mask = slots_mask__050_
          ; bits_per_slot = bits_per_slot__052_
          ; keys_per_slot = keys_per_slot__054_
          ; min_key_in_same_slot_mask = min_key_in_same_slot_mask__056_
          ; diff_max_min_allowed_key = diff_max_min_allowed_key__058_
          ; length = length__060_
          ; min_allowed_key = min_allowed_key__062_
          ; max_allowed_key = max_allowed_key__064_
          ; slots = slots__066_
          } ->
        let bnds__045_ = ([] : _ Stdlib.List.t) in
        let bnds__045_ =
          let arg__067_ = Sexplib0.Sexp_conv.sexp_of_opaque slots__066_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "slots"; arg__067_ ] :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__065_ = Key.sexp_of_t max_allowed_key__064_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_allowed_key"; arg__065_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__063_ = Key.sexp_of_t min_allowed_key__062_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "min_allowed_key"; arg__063_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__061_ = sexp_of_int length__060_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__061_ ] :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__059_ = Key.Span.sexp_of_t diff_max_min_allowed_key__058_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "diff_max_min_allowed_key"; arg__059_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__057_ =
            Min_key_in_same_slot_mask.sexp_of_t min_key_in_same_slot_mask__056_
          in
          (Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "min_key_in_same_slot_mask"; arg__057_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__055_ = Key.Span.sexp_of_t keys_per_slot__054_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "keys_per_slot"; arg__055_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__053_ = Num_key_bits.sexp_of_t bits_per_slot__052_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "bits_per_slot"; arg__053_ ]
           :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__051_ = Slots_mask.sexp_of_t slots_mask__050_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "slots_mask"; arg__051_ ] :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__049_ = Num_key_bits.sexp_of_t bits__048_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "bits"; arg__049_ ] :: bnds__045_
           : _ Stdlib.List.t)
        in
        let bnds__045_ =
          let arg__047_ = sexp_of_int index__046_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "index"; arg__047_ ] :: bnds__045_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__045_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let slot t ~key = Key.slot key ~bits_per_slot:t.bits_per_slot ~slots_mask:t.slots_mask
    let next_slot t slot = Slots_mask.next_slot t.slots_mask slot

    let min_key_in_same_slot t ~key =
      Key.min_key_in_same_slot key t.min_key_in_same_slot_mask
    ;;

    let compute_min_allowed_key t ~prev_level_max_allowed_key =
      if Key.equal prev_level_max_allowed_key Key.max_value
      then Key.max_value
      else min_key_in_same_slot t ~key:(Key.succ prev_level_max_allowed_key)
    ;;
  end

  type 'a t =
    { mutable length : int
    ; mutable pool : 'a Internal_elt.Pool.t
    ; mutable min_elt : 'a Internal_elt.t
    ; mutable elt_key_lower_bound : Key.t
    ; levels : 'a Level.t array
    }
  [@@deriving fields ~getters ~iterators:iter, sexp_of]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a t) -> ()
    let levels _r__ = _r__.levels
    let _ = levels
    let elt_key_lower_bound _r__ = _r__.elt_key_lower_bound
    let _ = elt_key_lower_bound
    let set_elt_key_lower_bound _r__ v__ = _r__.elt_key_lower_bound <- v__
    let _ = set_elt_key_lower_bound
    let min_elt _r__ = _r__.min_elt
    let _ = min_elt
    let set_min_elt _r__ v__ = _r__.min_elt <- v__
    let _ = set_min_elt
    let pool _r__ = _r__.pool
    let _ = pool
    let set_pool _r__ v__ = _r__.pool <- v__
    let _ = set_pool
    let length _r__ = _r__.length
    let _ = length
    let set_length _r__ v__ = _r__.length <- v__
    let _ = set_length

    module Fields = struct
      let levels =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "levels"
           ; getter = levels
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with levels = v__ })
           }
         : ([< `Read | `Set_and_create ], _, 'a Level.t array) Fieldslib.Field.t_with_perm)
      ;;

      let _ = levels

      let elt_key_lower_bound =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "elt_key_lower_bound"
           ; getter = elt_key_lower_bound
           ; setter = Some set_elt_key_lower_bound
           ; fset = (fun _r__ v__ -> { _r__ with elt_key_lower_bound = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Key.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = elt_key_lower_bound

      let min_elt =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "min_elt"
           ; getter = min_elt
           ; setter = Some set_min_elt
           ; fset = (fun _r__ v__ -> { _r__ with min_elt = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , 'a Internal_elt.t )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = min_elt

      let pool =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "pool"
           ; getter = pool
           ; setter = Some set_pool
           ; fset = (fun _r__ v__ -> { _r__ with pool = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , 'a Internal_elt.Pool.t )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = pool

      let length =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "length"
           ; getter = length
           ; setter = Some set_length
           ; fset = (fun _r__ v__ -> { _r__ with length = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = length

      let iter
            ~length:length_fun__
            ~pool:pool_fun__
            ~min_elt:min_elt_fun__
            ~elt_key_lower_bound:elt_key_lower_bound_fun__
            ~levels:levels_fun__
        =
        (length_fun__ length : unit);
        (pool_fun__ pool : unit);
        (min_elt_fun__ min_elt : unit);
        (elt_key_lower_bound_fun__ elt_key_lower_bound : unit);
        (levels_fun__ levels : unit)
      ;;

      let _ = iter
    end

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__068_
        { length = length__070_
        ; pool = pool__072_
        ; min_elt = min_elt__074_
        ; elt_key_lower_bound = elt_key_lower_bound__076_
        ; levels = levels__078_
        } ->
      let bnds__069_ = ([] : _ Stdlib.List.t) in
      let bnds__069_ =
        let arg__079_ = sexp_of_array (Level.sexp_of_t _of_a__068_) levels__078_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "levels"; arg__079_ ] :: bnds__069_
         : _ Stdlib.List.t)
      in
      let bnds__069_ =
        let arg__077_ = Key.sexp_of_t elt_key_lower_bound__076_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "elt_key_lower_bound"; arg__077_ ]
         :: bnds__069_
         : _ Stdlib.List.t)
      in
      let bnds__069_ =
        let arg__075_ = Internal_elt.sexp_of_t _of_a__068_ min_elt__074_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "min_elt"; arg__075_ ] :: bnds__069_
         : _ Stdlib.List.t)
      in
      let bnds__069_ =
        let arg__073_ = Internal_elt.Pool.sexp_of_t _of_a__068_ pool__072_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pool"; arg__073_ ] :: bnds__069_
         : _ Stdlib.List.t)
      in
      let bnds__069_ =
        let arg__071_ = sexp_of_int length__070_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__071_ ] :: bnds__069_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__069_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a priority_queue = 'a t

  module Elt = struct
    type 'a t = 'a External_elt.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__080_ x__081_ -> External_elt.sexp_of_t _of_a__080_ x__081_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let null = External_elt.null
    let at p t = Internal_elt.at p.pool (Internal_elt.of_external_exn p.pool t)
    let key p t = Internal_elt.key p.pool (Internal_elt.of_external_exn p.pool t)
    let value p t = Internal_elt.value p.pool (Internal_elt.of_external_exn p.pool t)
  end

  let sexp_of_t_internal = sexp_of_t
  let is_empty t = length t = 0
  let num_levels t = Array.length t.levels
  let min_allowed_key t = Level.min_allowed_key t.levels.(0)
  let max_allowed_key t = Level.max_allowed_key t.levels.(num_levels t - 1)

  let internal_iter t ~f =
    if t.length > 0
    then (
      let pool = t.pool in
      let levels = t.levels in
      for level_index = 0 to Array.length levels - 1 do
        let level = levels.(level_index) in
        if level.length > 0
        then (
          let slots = level.slots in
          for slot_index = 0 to Array.length slots - 1 do
            let elt = slots.(slot_index) in
            if not (Internal_elt.is_null elt) then Internal_elt.iter pool elt ~f
          done)
      done)
  ;;

  let iter t ~f = internal_iter t ~f:(f : _ Elt.t -> unit :> _ Internal_elt.t -> unit)

  module Pretty = struct
    module Elt = struct
      type 'a t =
        { key : Key.t
        ; value : 'a
        }
      [@@deriving sexp_of]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__082_ { key = key__084_; value = value__086_ } ->
          let bnds__083_ = ([] : _ Stdlib.List.t) in
          let bnds__083_ =
            let arg__087_ = _of_a__082_ value__086_ in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "value"; arg__087_ ] :: bnds__083_
             : _ Stdlib.List.t)
          in
          let bnds__083_ =
            let arg__085_ = Key.sexp_of_t key__084_ in
            (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "key"; arg__085_ ] :: bnds__083_
             : _ Stdlib.List.t)
          in
          Sexplib0.Sexp.List bnds__083_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type 'a t =
      { min_allowed_key : Key.t
      ; max_allowed_key : Key.t
      ; elts : 'a Elt.t list
      }
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__088_
          { min_allowed_key = min_allowed_key__090_
          ; max_allowed_key = max_allowed_key__092_
          ; elts = elts__094_
          } ->
        let bnds__089_ = ([] : _ Stdlib.List.t) in
        let bnds__089_ =
          let arg__095_ = sexp_of_list (Elt.sexp_of_t _of_a__088_) elts__094_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "elts"; arg__095_ ] :: bnds__089_
           : _ Stdlib.List.t)
        in
        let bnds__089_ =
          let arg__093_ = Key.sexp_of_t max_allowed_key__092_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_allowed_key"; arg__093_ ]
           :: bnds__089_
           : _ Stdlib.List.t)
        in
        let bnds__089_ =
          let arg__091_ = Key.sexp_of_t min_allowed_key__090_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "min_allowed_key"; arg__091_ ]
           :: bnds__089_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__089_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  let pretty t =
    let pool = t.pool in
    { Pretty.min_allowed_key = min_allowed_key t
    ; max_allowed_key = max_allowed_key t
    ; elts =
        (let r = ref [] in
         internal_iter t ~f:(fun elt ->
           r
           := { Pretty.Elt.key = Internal_elt.key pool elt
              ; value = Internal_elt.value pool elt
              }
              :: !r);
         List.rev !r)
    }
  ;;

  let sexp_of_t sexp_of_a t =
    match !sexp_of_t_style with
    | `Internal ->
      ((fun x__096_ -> sexp_of_t_internal sexp_of_a x__096_) [@merlin.hide]) t
    | `Pretty ->
      ((fun x__097_ -> Pretty.sexp_of_t sexp_of_a x__097_) [@merlin.hide]) (pretty t)
  ;;

  let compute_diff_max_min_allowed_key ~level_bits ~bits_per_slot =
    let bits = Num_key_bits.( + ) level_bits bits_per_slot in
    if Num_key_bits.equal bits Num_key_bits.max_value
    then Key.Span.max_value
    else Key.Span.pred (Key.num_keys bits)
  ;;

  let invariant invariant_a t : unit =
    let pool = t.pool in
    let level_invariant level =
      Invariant.invariant
        { Ppx_here_lib.pos_fname = "timing_wheel.ml.before-ppx"
        ; pos_lnum = 893
        ; pos_cnum = 31687
        ; pos_bol = 31661
        }
        level
        ((fun x__098_ -> Level.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__098_)
           [@merlin.hide])
        (fun () ->
           let check f = Invariant.check_field level f in
           Level.Fields.iter
             ~index:(check (fun index -> assert (index >= 0)))
             ~bits:
               (check (fun bits -> assert (Num_key_bits.( > ) bits Num_key_bits.zero)))
             ~slots_mask:
               (check
                  ((fun ?(here = []) ?message ?equal ~expect got ->
                      let pos = "timing_wheel.ml.before-ppx:900:31" in
                      let sexpifier = (Slots_mask.sexp_of_t [@merlin.hide]) in
                      let comparator =
                        (fun (a__099_ : Slots_mask.t)
                          ((b__100_ : Slots_mask.t) [@merlin.hide]) ->
                        (Slots_mask.compare a__099_ b__100_ [@merlin.hide]))
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
                     ~expect:(Slots_mask.create ~level_bits:level.bits)))
             ~bits_per_slot:
               (check (fun bits_per_slot ->
                  assert (Num_key_bits.( >= ) bits_per_slot Num_key_bits.zero)))
             ~keys_per_slot:
               (check (fun keys_per_slot ->
                  (fun ?(here = []) ?message ?equal ~expect got ->
                     let pos = "timing_wheel.ml.before-ppx:907:30" in
                     let sexpifier = (Key.Span.sexp_of_t [@merlin.hide]) in
                     let comparator =
                       (fun (a__101_ : Key.Span.t)
                         ((b__102_ : Key.Span.t) [@merlin.hide]) ->
                       (Key.Span.compare a__101_ b__102_ [@merlin.hide]))
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
                    keys_per_slot
                    ~expect:(Key.num_keys level.bits_per_slot)))
             ~min_key_in_same_slot_mask:
               (check (fun min_key_in_same_slot_mask ->
                  assert (
                    Min_key_in_same_slot_mask.equal
                      min_key_in_same_slot_mask
                      (Min_key_in_same_slot_mask.create
                         ~bits_per_slot:level.bits_per_slot))))
             ~diff_max_min_allowed_key:
               (check
                  ((fun ?(here = []) ?message ?equal ~expect got ->
                      let pos = "timing_wheel.ml.before-ppx:918:31" in
                      let sexpifier = (Key.Span.sexp_of_t [@merlin.hide]) in
                      let comparator =
                        (fun (a__103_ : Key.Span.t)
                          ((b__104_ : Key.Span.t) [@merlin.hide]) ->
                        (Key.Span.compare a__103_ b__104_ [@merlin.hide]))
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
                     ~expect:
                       (compute_diff_max_min_allowed_key
                          ~level_bits:level.bits
                          ~bits_per_slot:level.bits_per_slot)))
             ~length:
               (check (fun length ->
                  assert (
                    length
                    = Array.fold level.slots ~init:0 ~f:(fun n elt ->
                      if Internal_elt.is_null elt
                      then n
                      else n + Internal_elt.length pool elt))))
             ~min_allowed_key:
               (check (fun min_allowed_key ->
                  assert (Key.( >= ) min_allowed_key Key.zero);
                  if Key.( < ) min_allowed_key Key.max_value
                  then
                    (fun ?(here = []) ?message ?equal ~expect got ->
                       let pos = "timing_wheel.ml.before-ppx:936:32" in
                       let sexpifier = (Key.Span.sexp_of_t [@merlin.hide]) in
                       let comparator =
                         (fun (a__105_ : Key.Span.t)
                           ((b__106_ : Key.Span.t) [@merlin.hide]) ->
                         (Key.Span.compare a__105_ b__106_ [@merlin.hide]))
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
                      (Key.rem min_allowed_key level.keys_per_slot)
                      ~expect:Key.Span.zero))
             ~max_allowed_key:
               (check (fun max_allowed_key ->
                  (fun ?(here = []) ?message ?equal ~expect got ->
                     let pos = "timing_wheel.ml.before-ppx:941:30" in
                     let sexpifier = (Key.sexp_of_t [@merlin.hide]) in
                     let comparator =
                       (fun (a__107_ : Key.t) ((b__108_ : Key.t) [@merlin.hide]) ->
                       (Key.compare a__107_ b__108_ [@merlin.hide]))
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
                    max_allowed_key
                    ~expect:
                      (Key.add_clamp_to_max
                         level.min_allowed_key
                         level.diff_max_min_allowed_key)))
             ~slots:
               (check (fun slots ->
                  Array.iter slots ~f:(fun elt ->
                    if not (Internal_elt.is_null elt)
                    then (
                      Internal_elt.invariant pool invariant_a elt;
                      Internal_elt.iter pool elt ~f:(fun elt ->
                        assert (
                          Key.( >= ) (Internal_elt.key pool elt) level.min_allowed_key);
                        assert (
                          Key.( <= ) (Internal_elt.key pool elt) level.max_allowed_key);
                        assert (
                          Key.( >= ) (Internal_elt.key pool elt) t.elt_key_lower_bound);
                        assert (Internal_elt.level_index pool elt = level.index);
                        invariant_a (Internal_elt.value pool elt)))))))
    in
    Invariant.invariant
      { Ppx_here_lib.pos_fname = "timing_wheel.ml.before-ppx"
      ; pos_lnum = 960
      ; pos_cnum = 34788
      ; pos_bol = 34764
      }
      t
      ((fun x__109_ -> sexp_of_t_internal (fun _ -> Sexplib0.Sexp.Atom "_") x__109_)
         [@merlin.hide])
      (fun () ->
         let check f = Invariant.check_field t f in
         assert (Key.( >= ) (min_allowed_key t) Key.zero);
         assert (Key.( >= ) (max_allowed_key t) (min_allowed_key t));
         Fields.iter
           ~length:(check (fun length -> assert (length >= 0)))
           ~pool:(check (Internal_elt.Pool.invariant ignore))
           ~min_elt:
             (check (fun elt_ ->
                if not (Internal_elt.is_null elt_)
                then (
                  assert (Internal_elt.is_valid t.pool elt_);
                  assert (Key.equal t.elt_key_lower_bound (Internal_elt.key t.pool elt_)))))
           ~elt_key_lower_bound:
             (check (fun elt_key_lower_bound ->
                assert (Key.( >= ) elt_key_lower_bound (min_allowed_key t));
                assert (Key.( <= ) elt_key_lower_bound (max_allowed_key t));
                if not (Internal_elt.is_null t.min_elt)
                then
                  assert (
                    Key.equal elt_key_lower_bound (Internal_elt.key t.pool t.min_elt))))
           ~levels:
             (check (fun levels ->
                assert (num_levels t > 0);
                Array.iteri levels ~f:(fun level_index level ->
                  assert (level_index = Level.index level);
                  level_invariant level;
                  if level_index > 0
                  then (
                    let prev_level = levels.(level_index - 1) in
                    let module L = Level in
                    (fun ?(here = []) ?message ?equal ~expect got ->
                       let pos = "timing_wheel.ml.before-ppx:990:32" in
                       let sexpifier = (Key.Span.sexp_of_t [@merlin.hide]) in
                       let comparator =
                         (fun (a__110_ : Key.Span.t)
                           ((b__111_ : Key.Span.t) [@merlin.hide]) ->
                         (Key.Span.compare a__110_ b__111_ [@merlin.hide]))
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
                      (L.keys_per_slot level)
                      ~expect:(Key.Span.succ prev_level.diff_max_min_allowed_key);
                    (fun ?(here = []) ?message ?equal ~expect got ->
                       let pos = "timing_wheel.ml.before-ppx:993:32" in
                       let sexpifier = (Key.sexp_of_t [@merlin.hide]) in
                       let comparator =
                         (fun (a__112_ : Key.t) ((b__113_ : Key.t) [@merlin.hide]) ->
                         (Key.compare a__112_ b__113_ [@merlin.hide]))
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
                      level.min_allowed_key
                      ~expect:
                        (Level.compute_min_allowed_key
                           level
                           ~prev_level_max_allowed_key:prev_level.max_allowed_key))))))
  ;;

  let min_elt_ t =
    if is_empty t
    then Internal_elt.null ()
    else if not (Internal_elt.is_null t.min_elt)
    then t.min_elt
    else (
      let pool = t.pool in
      let min_elt_already_found = ref (Internal_elt.null ()) in
      let min_key_already_found = ref Key.max_value in
      let level_index = ref 0 in
      let num_levels = num_levels t in
      while !level_index < num_levels do
        let level = t.levels.(!level_index) in
        if Key.( > ) (Level.min_allowed_key level) !min_key_already_found
        then level_index := num_levels
        else if level.length = 0
        then incr level_index
        else (
          let slots = level.slots in
          let slot_min_key =
            ref
              (Level.min_key_in_same_slot
                 level
                 ~key:(Key.max level.min_allowed_key t.elt_key_lower_bound))
          in
          let slot = ref (Level.slot level ~key:!slot_min_key) in
          while
            Internal_elt.is_null slots.(!slot)
            && Key.( < ) !slot_min_key !min_key_already_found
          do
            slot := Level.next_slot level !slot;
            slot_min_key := Key.add !slot_min_key level.keys_per_slot
          done;
          let first = slots.(!slot) in
          if not (Internal_elt.is_null first)
          then (
            let continue = ref true in
            let current = ref first in
            while !continue do
              let current_key = Internal_elt.key pool !current in
              if Key.( <= ) current_key !min_key_already_found
              then (
                min_elt_already_found := !current;
                min_key_already_found := current_key);
              let next = Internal_elt.next pool !current in
              if phys_equal next first || !level_index = 0
              then continue := false
              else current := next
            done);
          incr level_index)
      done;
      t.min_elt <- !min_elt_already_found;
      t.elt_key_lower_bound <- !min_key_already_found;
      t.min_elt)
  [@@ocaml.doc
    " [min_elt_] returns [null] if it can't find the desired element.  We wrap it up\n\
    \      afterwards to return an [option]. "]
  ;;

  let raise_add_elt_key_out_of_bounds t key =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Priority_queue.add_elt key out of bounds"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "key"; (Key.sexp_of_t [@merlin.hide]) key ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "min_allowed_key t"
               ; (Key.sexp_of_t [@merlin.hide]) (min_allowed_key t)
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "max_allowed_key t"
               ; (Key.sexp_of_t [@merlin.hide]) (max_allowed_key t)
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "priority_queue"
               ; ((fun x__114_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__114_)
                    [@merlin.hide])
                   t
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let raise_add_elt_key_out_of_level_bounds key level =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Priority_queue.add_elt key out of level bounds"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "key"; (Key.sexp_of_t [@merlin.hide]) key ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "level"
               ; ((fun x__115_ ->
                    Level.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__115_)
                    [@merlin.hide])
                   level
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let add_elt t elt =
    let pool = t.pool in
    let key = Internal_elt.key pool elt in
    if not (Key.( >= ) key (min_allowed_key t) && Key.( <= ) key (max_allowed_key t))
    then raise_add_elt_key_out_of_bounds t key;
    let level_index =
      let level_index = ref 0 in
      while Key.( > ) key (Level.max_allowed_key t.levels.(!level_index)) do
        incr level_index
      done;
      !level_index
    in
    let level = t.levels.(level_index) in
    if not (Key.( >= ) key level.min_allowed_key && Key.( <= ) key level.max_allowed_key)
    then raise_add_elt_key_out_of_level_bounds key level;
    level.length <- level.length + 1;
    Internal_elt.set_level_index pool elt level_index;
    let slot = Level.slot level ~key in
    let slots = level.slots in
    let first = slots.(slot) in
    if not (Internal_elt.is_null first)
    then Internal_elt.insert_at_end pool first ~to_add:elt
    else (
      slots.(slot) <- elt;
      Internal_elt.link_to_self pool elt)
  ;;

  let internal_add_elt t elt =
    let key = Internal_elt.key t.pool elt in
    if Key.( < ) key t.elt_key_lower_bound
    then (
      t.min_elt <- elt;
      t.elt_key_lower_bound <- key);
    add_elt t elt;
    t.length <- t.length + 1
  ;;

  let raise_got_invalid_key t key =
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.add_at_interval_num got invalid interval num"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "interval_num"
               ; (Key.sexp_of_t [@merlin.hide]) key
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "min_allowed_alarm_interval_num"
               ; (Key.sexp_of_t [@merlin.hide]) (min_allowed_key t)
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "max_allowed_alarm_interval_num"
               ; (Key.sexp_of_t [@merlin.hide]) (max_allowed_key t)
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let ensure_valid_key t ~key =
    if Key.( < ) key (min_allowed_key t) || Key.( > ) key (max_allowed_key t)
    then raise_got_invalid_key t key
  ;;

  let internal_add t ~key ~at value =
    ensure_valid_key t ~key;
    if Internal_elt.Pool.is_full t.pool then t.pool <- Internal_elt.Pool.grow t.pool;
    let elt = Internal_elt.create t.pool ~key ~at ~value ~level_index:(-1) in
    internal_add_elt t elt;
    elt
  ;;

  let remove_or_re_add_elts t (level : _ Level.t) first ~t_min_allowed_key ~handle_removed
    =
    let pool = t.pool in
    let current = ref first in
    let continue = ref true in
    while !continue do
      let next = Internal_elt.next pool !current in
      level.length <- level.length - 1;
      if Key.( >= ) (Internal_elt.key pool !current) t_min_allowed_key
      then add_elt t !current
      else (
        t.length <- t.length - 1;
        handle_removed (Internal_elt.to_external !current);
        Internal_elt.free pool !current);
      if phys_equal next first then continue := false else current := next
    done
  [@@ocaml.doc
    " [remove_or_re_add_elts] visits each element in the circular doubly-linked list\n\
    \      [first].  If the element's key is [>= t_min_allowed_key], then it adds the \
     element\n\
    \      back at a lower level.  If not, then it calls [handle_removed] and [free]s the\n\
    \      element. "]
  ;;

  let increase_level_min_allowed_key
        t
        (level : _ Level.t)
        ~prev_level_max_allowed_key
        ~t_min_allowed_key
        ~handle_removed
    =
    let desired_min_allowed_key =
      Level.compute_min_allowed_key level ~prev_level_max_allowed_key
    in
    let level_min_allowed_key =
      Level.min_key_in_same_slot
        level
        ~key:
          (Key.min
             desired_min_allowed_key
             (Key.max level.min_allowed_key t.elt_key_lower_bound))
    in
    let level_min_allowed_key = ref level_min_allowed_key in
    let slot = ref (Level.slot level ~key:!level_min_allowed_key) in
    let keys_per_slot = level.keys_per_slot in
    let slots = level.slots in
    while Key.( < ) !level_min_allowed_key desired_min_allowed_key do
      if level.length = 0
      then level_min_allowed_key := desired_min_allowed_key
      else (
        let first = slots.(!slot) in
        if not (Internal_elt.is_null first)
        then (
          slots.(!slot) <- Internal_elt.null ();
          remove_or_re_add_elts t level first ~t_min_allowed_key ~handle_removed);
        slot := Level.next_slot level !slot;
        level_min_allowed_key := Key.add_clamp_to_max !level_min_allowed_key keys_per_slot)
    done;
    level.min_allowed_key <- desired_min_allowed_key;
    level.max_allowed_key
    <- Key.add_clamp_to_max desired_min_allowed_key level.diff_max_min_allowed_key
  [@@ocaml.doc
    " [increase_level_min_allowed_key] increases the [min_allowed_key] of [level] to as\n\
    \      large a value as possible, but no more than [max_level_min_allowed_key].\n\
    \      [t_min_allowed_key] is the minimum allowed key for the entire timing wheel.  As\n\
    \      elements are encountered, they are removed from the timing wheel if their key \
     is\n\
    \      smaller than [t_min_allowed_key], or added at a lower level if not. "]
  ;;

  module Increase_min_allowed_key_result = struct
    type t =
      | Max_allowed_key_did_not_change
      | Max_allowed_key_maybe_changed
  end

  let increase_min_allowed_key t ~key ~handle_removed : Increase_min_allowed_key_result.t =
    if Key.( <= ) key (min_allowed_key t)
    then Max_allowed_key_did_not_change
    else (
      let level_index = ref 0 in
      let result = ref Increase_min_allowed_key_result.Max_allowed_key_maybe_changed in
      let prev_level_max_allowed_key = ref (Key.pred key) in
      let levels = t.levels in
      let num_levels = num_levels t in
      while !level_index < num_levels do
        let level = levels.(!level_index) in
        let min_allowed_key_before = level.min_allowed_key in
        increase_level_min_allowed_key
          t
          level
          ~prev_level_max_allowed_key:!prev_level_max_allowed_key
          ~t_min_allowed_key:key
          ~handle_removed;
        if Key.equal (Level.min_allowed_key level) min_allowed_key_before
        then (
          level_index := num_levels;
          result := Max_allowed_key_did_not_change)
        else (
          level_index := !level_index + 1;
          prev_level_max_allowed_key := Level.max_allowed_key level)
      done;
      if Key.( > ) key t.elt_key_lower_bound
      then (
        t.min_elt <- Internal_elt.null ();
        t.elt_key_lower_bound <- min_allowed_key t);
      !result)
  ;;

  let create ?capacity ?level_bits () =
    let level_bits =
      match level_bits with
      | Some l -> l
      | None -> Level_bits.default
    in
    let _, _, levels =
      List.foldi
        level_bits
        ~init:(Num_key_bits.zero, Key.zero, [])
        ~f:
          (fun
            index
            (bits_per_slot, max_level_min_allowed_key, levels)
            (level_bits : Num_key_bits.t)
          ->
          let keys_per_slot = Key.num_keys bits_per_slot in
          let diff_max_min_allowed_key =
            compute_diff_max_min_allowed_key ~level_bits ~bits_per_slot
          in
          let min_key_in_same_slot_mask =
            Min_key_in_same_slot_mask.create ~bits_per_slot
          in
          let min_allowed_key =
            Key.min_key_in_same_slot max_level_min_allowed_key min_key_in_same_slot_mask
          in
          let max_allowed_key =
            Key.add_clamp_to_max min_allowed_key diff_max_min_allowed_key
          in
          let level =
            { Level.index
            ; bits = level_bits
            ; slots_mask = Slots_mask.create ~level_bits
            ; bits_per_slot
            ; keys_per_slot
            ; min_key_in_same_slot_mask
            ; diff_max_min_allowed_key
            ; length = 0
            ; min_allowed_key
            ; max_allowed_key
            ; slots =
                Array.create
                  ~len:(Int63.to_int_exn (Num_key_bits.pow2 level_bits))
                  (Internal_elt.null ())
            }
          in
          ( Num_key_bits.( + ) level_bits bits_per_slot
          , Key.succ_clamp_to_max max_allowed_key
          , level :: levels ))
    in
    { length = 0
    ; pool = Internal_elt.Pool.create ?capacity ()
    ; min_elt = Internal_elt.null ()
    ; elt_key_lower_bound = Key.zero
    ; levels = Array.of_list_rev levels
    }
  ;;

  let mem t elt = Internal_elt.external_is_valid t.pool elt

  let internal_remove t elt =
    let pool = t.pool in
    if Internal_elt.equal elt t.min_elt then t.min_elt <- Internal_elt.null ();
    t.length <- t.length - 1;
    let level = t.levels.(Internal_elt.level_index pool elt) in
    level.length <- level.length - 1;
    let slots = level.slots in
    let slot = Level.slot level ~key:(Internal_elt.key pool elt) in
    let first = slots.(slot) in
    if phys_equal elt (Internal_elt.next pool elt)
    then slots.(slot) <- Internal_elt.null ()
    else (
      if phys_equal elt first then slots.(slot) <- Internal_elt.next pool elt;
      Internal_elt.unlink pool elt)
  ;;

  let remove t elt =
    let pool = t.pool in
    let elt = Internal_elt.of_external_exn pool elt in
    internal_remove t elt;
    Internal_elt.free pool elt
  ;;

  let fire_past_alarms t ~handle_fired ~key ~now =
    let level = t.levels.(0) in
    if level.length > 0
    then (
      let slot = Level.slot level ~key in
      let slots = level.slots in
      let pool = t.pool in
      let first = ref slots.(slot) in
      if not (Internal_elt.is_null !first)
      then (
        let current = ref !first in
        let continue = ref true in
        while !continue do
          let elt = !current in
          let next = Internal_elt.next pool elt in
          if phys_equal next !first then continue := false else current := next;
          if Time_ns.( <= ) (Internal_elt.at pool elt) now
          then (
            handle_fired (Internal_elt.to_external elt);
            internal_remove t elt;
            Internal_elt.free pool elt;
            first := slots.(slot))
        done))
  ;;

  let change t elt ~key ~at =
    ensure_valid_key t ~key;
    let pool = t.pool in
    let elt = Internal_elt.of_external_exn pool elt in
    internal_remove t elt;
    Internal_elt.set_key pool elt key;
    Internal_elt.set_at pool elt at;
    internal_add_elt t elt
  ;;

  let clear t =
    if not (is_empty t)
    then (
      t.length <- 0;
      let pool = t.pool in
      let free_elt elt = Internal_elt.free pool elt in
      let levels = t.levels in
      for level_index = 0 to Array.length levels - 1 do
        let level = levels.(level_index) in
        if level.length > 0
        then (
          level.length <- 0;
          let slots = level.slots in
          for slot_index = 0 to Array.length slots - 1 do
            let elt = slots.(slot_index) in
            if not (Internal_elt.is_null elt)
            then (
              Internal_elt.iter pool elt ~f:free_elt;
              slots.(slot_index) <- Internal_elt.null ())
          done)
      done)
  ;;
end
[@@ocaml.doc
  " Timing wheel is implemented as a priority queue in which the keys are\n\
  \    non-negative integers corresponding to the intervals of time.  The priority queue \
   is\n\
  \    unlike a typical priority queue in that rather than having a \"delete min\" \
   operation,\n\
  \    it has a nondecreasing minimum allowed key, which corresponds to the current time,\n\
  \    and an [increase_min_allowed_key] operation, which implements [advance_clock].\n\
  \    [increase_min_allowed_key] as a side effect removes all elements from the timing\n\
  \    wheel whose key is smaller than the new minimum, which implements firing the alarms\n\
  \    whose time has expired.\n\n\
  \    Adding elements to and removing elements from a timing wheel takes constant time,\n\
  \    unlike a heap-based priority queue which takes log(N), where N is the number of\n\
  \    elements in the heap.  [increase_min_allowed_key] takes time proportional to the\n\
  \    amount of increase in the min-allowed key, as compared to log(N) for a heap.  It is\n\
  \    these performance differences that motivate the existence of timing wheels and make\n\
  \    them a good choice for maintaing a set of alarms.  With a timing wheel, one can\n\
  \    support any number of alarms paying constant overhead per alarm, while paying a\n\
  \    small constant overhead per unit of time passed.\n\n\
  \    As the minimum allowed key increases, the timing wheel does a lazy radix sort of \
   the\n\
  \    element keys, with level 0 handling the least significant [b_0] bits in a key, and\n\
  \    each subsequent level [i] handling the next most significant [b_i] bits.  The \
   levels\n\
  \    hold increasingly larger ranges of keys, where the union of all the levels can hold\n\
  \    any key from [min_allowed_key t] to [max_allowed_key t].  When a key is added to \
   the\n\
  \    timing wheel, it is added at the lowest possible level that can store the key.  As\n\
  \    the minimum allowed key increases, timing-wheel elements move down levels until \
   they\n\
  \    reach level 0, and then are eventually removed.  "]

module Internal_elt = Priority_queue.Internal_elt
module Key = Priority_queue.Key
module Interval_num = Key

let min_interval_num = Interval_num.zero

type 'a t =
  { config : Config.t
  ; start : Time_ns.t
  ; max_interval_num : Interval_num.t
  ; mutable now : Time_ns.t
  ; mutable now_interval_num_start : Time_ns.t
  ; mutable max_allowed_alarm_time : Time_ns.t
  ; priority_queue : 'a Priority_queue.t
  }
[@@deriving fields ~getters ~iterators:iter, sexp_of]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()
  let priority_queue _r__ = _r__.priority_queue
  let _ = priority_queue
  let max_allowed_alarm_time _r__ = _r__.max_allowed_alarm_time
  let _ = max_allowed_alarm_time
  let set_max_allowed_alarm_time _r__ v__ = _r__.max_allowed_alarm_time <- v__
  let _ = set_max_allowed_alarm_time
  let now_interval_num_start _r__ = _r__.now_interval_num_start
  let _ = now_interval_num_start
  let set_now_interval_num_start _r__ v__ = _r__.now_interval_num_start <- v__
  let _ = set_now_interval_num_start
  let now _r__ = _r__.now
  let _ = now
  let set_now _r__ v__ = _r__.now <- v__
  let _ = set_now
  let max_interval_num _r__ = _r__.max_interval_num
  let _ = max_interval_num
  let start _r__ = _r__.start
  let _ = start
  let config _r__ = _r__.config
  let _ = config

  module Fields = struct
    let priority_queue =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "priority_queue"
         ; getter = priority_queue
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with priority_queue = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'a Priority_queue.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = priority_queue

    let max_allowed_alarm_time =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "max_allowed_alarm_time"
         ; getter = max_allowed_alarm_time
         ; setter = Some set_max_allowed_alarm_time
         ; fset = (fun _r__ v__ -> { _r__ with max_allowed_alarm_time = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Time_ns.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = max_allowed_alarm_time

    let now_interval_num_start =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "now_interval_num_start"
         ; getter = now_interval_num_start
         ; setter = Some set_now_interval_num_start
         ; fset = (fun _r__ v__ -> { _r__ with now_interval_num_start = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Time_ns.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = now_interval_num_start

    let now =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "now"
         ; getter = now
         ; setter = Some set_now
         ; fset = (fun _r__ v__ -> { _r__ with now = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Time_ns.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = now

    let max_interval_num =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "max_interval_num"
         ; getter = max_interval_num
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with max_interval_num = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Interval_num.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = max_interval_num

    let start =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "start"
         ; getter = start
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with start = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Time_ns.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = start

    let config =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "config"
         ; getter = config
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with config = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Config.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = config

    let iter
          ~config:config_fun__
          ~start:start_fun__
          ~max_interval_num:max_interval_num_fun__
          ~now:now_fun__
          ~now_interval_num_start:now_interval_num_start_fun__
          ~max_allowed_alarm_time:max_allowed_alarm_time_fun__
          ~priority_queue:priority_queue_fun__
      =
      (config_fun__ config : unit);
      (start_fun__ start : unit);
      (max_interval_num_fun__ max_interval_num : unit);
      (now_fun__ now : unit);
      (now_interval_num_start_fun__ now_interval_num_start : unit);
      (max_allowed_alarm_time_fun__ max_allowed_alarm_time : unit);
      (priority_queue_fun__ priority_queue : unit)
    ;;

    let _ = iter
  end

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__116_
      { config = config__118_
      ; start = start__120_
      ; max_interval_num = max_interval_num__122_
      ; now = now__124_
      ; now_interval_num_start = now_interval_num_start__126_
      ; max_allowed_alarm_time = max_allowed_alarm_time__128_
      ; priority_queue = priority_queue__130_
      } ->
    let bnds__117_ = ([] : _ Stdlib.List.t) in
    let bnds__117_ =
      let arg__131_ = Priority_queue.sexp_of_t _of_a__116_ priority_queue__130_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "priority_queue"; arg__131_ ] :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__129_ = Time_ns.sexp_of_t max_allowed_alarm_time__128_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_allowed_alarm_time"; arg__129_ ]
       :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__127_ = Time_ns.sexp_of_t now_interval_num_start__126_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "now_interval_num_start"; arg__127_ ]
       :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__125_ = Time_ns.sexp_of_t now__124_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "now"; arg__125_ ] :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__123_ = Interval_num.sexp_of_t max_interval_num__122_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_interval_num"; arg__123_ ]
       :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__121_ = Time_ns.sexp_of_t start__120_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "start"; arg__121_ ] :: bnds__117_
       : _ Stdlib.List.t)
    in
    let bnds__117_ =
      let arg__119_ = Config.sexp_of_t config__118_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config"; arg__119_ ] :: bnds__117_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__117_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type 'a timing_wheel = 'a t
type 'a t_now = 'a t

let sexp_of_t_now _ t = (Time_ns.sexp_of_t [@merlin.hide]) t.now
let alarm_precision t = Config.alarm_precision t.config

module Alarm = struct
  type 'a t = 'a Priority_queue.Elt.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__132_ x__133_ -> Priority_queue.Elt.sexp_of_t _of_a__132_ x__133_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let null = Priority_queue.Elt.null
  let at tw t = Priority_queue.Elt.at tw.priority_queue t
  let value tw t = Priority_queue.Elt.value tw.priority_queue t
  let interval_num tw t = Priority_queue.Elt.key tw.priority_queue t
end

let sexp_of_t_internal = sexp_of_t
let iter t ~f = Priority_queue.iter t.priority_queue ~f

module Pretty = struct
  module Alarm = struct
    type 'a t =
      { at : Time_ns.t
      ; value : 'a
      }
    [@@deriving fields ~getters, sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()
      let value _r__ = _r__.value
      let _ = value
      let at _r__ = _r__.at
      let _ = at

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__134_ { at = at__136_; value = value__138_ } ->
        let bnds__135_ = ([] : _ Stdlib.List.t) in
        let bnds__135_ =
          let arg__139_ = _of_a__134_ value__138_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "value"; arg__139_ ] :: bnds__135_
           : _ Stdlib.List.t)
        in
        let bnds__135_ =
          let arg__137_ = Time_ns.sexp_of_t at__136_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "at"; arg__137_ ] :: bnds__135_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__135_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create t alarm = { at = Alarm.at t alarm; value = Alarm.value t alarm }
    let compare t1 t2 = Time_ns.compare (at t1) (at t2)
  end

  type 'a t =
    { config : Config.t
    ; start : Time_ns.t
    ; max_interval_num : Interval_num.t
    ; now : Time_ns.t
    ; alarms : 'a Alarm.t list
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__140_
        { config = config__142_
        ; start = start__144_
        ; max_interval_num = max_interval_num__146_
        ; now = now__148_
        ; alarms = alarms__150_
        } ->
      let bnds__141_ = ([] : _ Stdlib.List.t) in
      let bnds__141_ =
        let arg__151_ = sexp_of_list (Alarm.sexp_of_t _of_a__140_) alarms__150_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alarms"; arg__151_ ] :: bnds__141_
         : _ Stdlib.List.t)
      in
      let bnds__141_ =
        let arg__149_ = Time_ns.sexp_of_t now__148_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "now"; arg__149_ ] :: bnds__141_
         : _ Stdlib.List.t)
      in
      let bnds__141_ =
        let arg__147_ = Interval_num.sexp_of_t max_interval_num__146_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max_interval_num"; arg__147_ ]
         :: bnds__141_
         : _ Stdlib.List.t)
      in
      let bnds__141_ =
        let arg__145_ = Time_ns.sexp_of_t start__144_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "start"; arg__145_ ] :: bnds__141_
         : _ Stdlib.List.t)
      in
      let bnds__141_ =
        let arg__143_ = Config.sexp_of_t config__142_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "config"; arg__143_ ] :: bnds__141_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__141_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let pretty
      ({ config
       ; start
       ; max_interval_num
       ; now
       ; now_interval_num_start = _
       ; max_allowed_alarm_time = _
       ; priority_queue = _
       } as t)
  =
  let r = ref [] in
  iter t ~f:(fun a -> r := Pretty.Alarm.create t a :: !r);
  let alarms = List.sort !r ~compare:Pretty.Alarm.compare in
  { Pretty.config; start; max_interval_num; now; alarms }
;;

let sexp_of_t sexp_of_a t =
  match !sexp_of_t_style with
  | `Internal -> sexp_of_t_internal sexp_of_a t
  | `Pretty ->
    ((fun x__152_ -> Pretty.sexp_of_t sexp_of_a x__152_) [@merlin.hide]) (pretty t)
;;

let length t = Priority_queue.length t.priority_queue
let is_empty t = length t = 0

let raise_next_alarm_fires_at_exn_of_empty_timing_wheel t =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel.next_alarm_fires_at_exn of empty timing wheel"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "timing_wheel"
             ; ((fun x__153_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__153_)
                  [@merlin.hide])
                 t
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let raise_next_alarm_fires_at_with_all_alarms_in_max_interval t =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel.next_alarm_fires_at_exn with all alarms in max interval"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "timing_wheel"
             ; ((fun x__154_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__154_)
                  [@merlin.hide])
                 t
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let pool t = Priority_queue.pool t.priority_queue

let interval_num_internal ~time ~alarm_precision =
  Interval_num.of_int63 (Alarm_precision.interval_num alarm_precision time)
;;

let interval_num_unchecked t time =
  interval_num_internal ~time ~alarm_precision:t.config.alarm_precision
;;

let interval_num t time =
  if Time_ns.( < ) time min_time
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.interval_num got time too far in the past"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "time"
               ; (Time_ns.sexp_of_t [@merlin.hide]) time
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  interval_num_unchecked t time
;;

let interval_num_start_unchecked t interval_num =
  Alarm_precision.interval_num_start
    t.config.alarm_precision
    (Interval_num.to_int63 interval_num)
;;

let raise_interval_num_start_got_too_small interval_num =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel.interval_num_start got too small interval_num"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "interval_num"
             ; (Interval_num.sexp_of_t [@merlin.hide]) interval_num
             ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "min_interval_num"
             ; (Interval_num.sexp_of_t [@merlin.hide]) min_interval_num
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let raise_interval_num_start_got_too_large t interval_num =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel.interval_num_start got too large interval_num"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "interval_num"
             ; (Interval_num.sexp_of_t [@merlin.hide]) interval_num
             ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "t.max_interval_num"
             ; (Interval_num.sexp_of_t [@merlin.hide]) t.max_interval_num
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let interval_num_start t interval_num =
  if Interval_num.( < ) interval_num min_interval_num
  then raise_interval_num_start_got_too_small interval_num;
  if Interval_num.( > ) interval_num t.max_interval_num
  then raise_interval_num_start_got_too_large t interval_num;
  interval_num_start_unchecked t interval_num
;;

let next_alarm_fires_at_internal t key = interval_num_start t (Key.succ key)

let next_alarm_fires_at t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt
  then None
  else (
    let key = Internal_elt.key (pool t) elt in
    if Interval_num.equal key t.max_interval_num
    then None
    else Some (next_alarm_fires_at_internal t key))
;;

let next_alarm_fires_at_exn t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt then raise_next_alarm_fires_at_exn_of_empty_timing_wheel t;
  let key = Internal_elt.key (pool t) elt in
  if Interval_num.equal key t.max_interval_num
  then raise_next_alarm_fires_at_with_all_alarms_in_max_interval t;
  next_alarm_fires_at_internal t key
;;

let compute_max_allowed_alarm_time t =
  let max_allowed_key = Priority_queue.max_allowed_key t.priority_queue in
  if Interval_num.( >= ) max_allowed_key t.max_interval_num
  then max_time
  else
    Time_ns.add
      (interval_num_start_unchecked t max_allowed_key)
      (Time_ns.Span.( - ) (alarm_precision t) Time_ns.Span.nanosecond)
;;

let now_interval_num t = Priority_queue.min_allowed_key t.priority_queue
let min_allowed_alarm_interval_num = now_interval_num
let max_allowed_alarm_interval_num t = interval_num t (max_allowed_alarm_time t)
let interval_start t time = interval_num_start_unchecked t (interval_num t time)

let invariant invariant_a t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "timing_wheel.ml.before-ppx"
    ; pos_lnum = 1604
    ; pos_cnum = 57951
    ; pos_bol = 57929
    }
    t
    ((fun x__155_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__155_) [@merlin.hide])
    (fun () ->
       let check f = Invariant.check_field t f in
       Fields.iter
         ~config:(check Config.invariant)
         ~start:
           (check (fun start ->
              assert (Time_ns.( >= ) start min_time);
              assert (Time_ns.( <= ) start max_time)))
         ~max_interval_num:
           (check (fun max_interval_num ->
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "timing_wheel.ml.before-ppx:1614:26" in
                 let sexpifier = (Interval_num.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__156_ : Interval_num.t)
                     ((b__157_ : Interval_num.t) [@merlin.hide]) ->
                   (Interval_num.compare a__156_ b__157_ [@merlin.hide]))
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
                ~expect:max_interval_num
                (interval_num t max_time);
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "timing_wheel.ml.before-ppx:1617:26" in
                 let sexpifier = (Interval_num.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__158_ : Interval_num.t)
                     ((b__159_ : Interval_num.t) [@merlin.hide]) ->
                   (Interval_num.compare a__158_ b__159_ [@merlin.hide]))
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
                ~expect:max_interval_num
                (interval_num t (interval_num_start t max_interval_num))))
         ~now:
           (check (fun now ->
              assert (Time_ns.( >= ) now t.start);
              assert (Time_ns.( <= ) now max_time);
              assert (
                Interval_num.equal
                  (interval_num t t.now)
                  (Priority_queue.min_allowed_key t.priority_queue))))
         ~now_interval_num_start:
           (check (fun now_interval_num_start ->
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "timing_wheel.ml.before-ppx:1630:26" in
                 let sexpifier = (Time_ns.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__160_ : Time_ns.t) ((b__161_ : Time_ns.t) [@merlin.hide]) ->
                   (Time_ns.compare a__160_ b__161_ [@merlin.hide]))
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
                now_interval_num_start
                ~expect:(interval_num_start t (now_interval_num t))))
         ~max_allowed_alarm_time:
           (check (fun max_allowed_alarm_time ->
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "timing_wheel.ml.before-ppx:1635:26" in
                 let sexpifier = (Time_ns.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__162_ : Time_ns.t) ((b__163_ : Time_ns.t) [@merlin.hide]) ->
                   (Time_ns.compare a__162_ b__163_ [@merlin.hide]))
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
                max_allowed_alarm_time
                ~expect:(compute_max_allowed_alarm_time t)))
         ~priority_queue:(check (Priority_queue.invariant invariant_a));
       iter t ~f:(fun alarm ->
         assert (
           Interval_num.equal
             (Alarm.interval_num t alarm)
             (interval_num t (Alarm.at t alarm)));
         assert (
           Time_ns.( >= ) (interval_start t (Alarm.at t alarm)) (interval_start t (now t)));
         assert (
           Time_ns.( > ) (Alarm.at t alarm) (Time_ns.sub (now t) (alarm_precision t)))))
;;

let debug = false

let advance_clock t ~to_ ~handle_fired =
  if Time_ns.( > ) to_ (now t)
  then (
    t.now <- to_;
    let key = interval_num_unchecked t to_ in
    t.now_interval_num_start <- interval_num_start_unchecked t key;
    match
      Priority_queue.increase_min_allowed_key
        t.priority_queue
        ~key
        ~handle_removed:handle_fired
    with
    | Max_allowed_key_did_not_change ->
      if debug
      then
        assert (Time_ns.( = ) t.max_allowed_alarm_time (compute_max_allowed_alarm_time t))
    | Max_allowed_key_maybe_changed ->
      t.max_allowed_alarm_time <- compute_max_allowed_alarm_time t)
;;

let advance_clock_stop_at_next_alarm t ~to_ ~handle_fired =
  let min_elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null min_elt
  then advance_clock t ~to_ ~handle_fired:(fun _ -> assert false)
  else (
    let key = Internal_elt.key (pool t) min_elt in
    if Time_ns.( < ) to_ (interval_num_start t key)
    then advance_clock t ~to_ ~handle_fired:(fun _ -> assert false)
    else (
      let to_ =
        Time_ns.min to_ (Internal_elt.min_alarm_time (pool t) min_elt ~with_key:key)
      in
      advance_clock t ~to_ ~handle_fired))
;;

let create ~config ~start =
  if Time_ns.( < ) start Time_ns.epoch
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.create got start before the epoch"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "start"
               ; (Time_ns.sexp_of_t [@merlin.hide]) start
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  let t =
    { config
    ; start
    ; max_interval_num =
        interval_num_internal ~time:max_time ~alarm_precision:config.alarm_precision
    ; now = Time_ns.min_value_for_1us_rounding
    ; now_interval_num_start = Time_ns.min_value_for_1us_rounding
    ; max_allowed_alarm_time = max_time
    ; priority_queue =
        Priority_queue.create ?capacity:config.capacity ~level_bits:config.level_bits ()
    }
  in
  t.max_allowed_alarm_time <- compute_max_allowed_alarm_time t;
  advance_clock t ~to_:start ~handle_fired:(fun _ -> assert false);
  t
;;

let add_at_interval_num t ~at value =
  Internal_elt.to_external
    (Priority_queue.internal_add
       t.priority_queue
       ~key:at
       ~at:(interval_num_start t at)
       value)
;;

let raise_that_far_in_the_future t at =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel cannot schedule alarm that far in the future"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "at"; (Time_ns.sexp_of_t [@merlin.hide]) at ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "max_allowed_alarm_time"
             ; (Time_ns.sexp_of_t [@merlin.hide]) t.max_allowed_alarm_time
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let raise_before_start_of_current_interval t at =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             "Timing_wheel cannot schedule alarm before start of current interval"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "at"; (Time_ns.sexp_of_t [@merlin.hide]) at ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "now_interval_num_start"
             ; (Time_ns.sexp_of_t [@merlin.hide]) t.now_interval_num_start
             ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let ensure_can_schedule_alarm t ~at =
  if Time_ns.( > ) at t.max_allowed_alarm_time then raise_that_far_in_the_future t at;
  if Time_ns.( < ) at t.now_interval_num_start
  then raise_before_start_of_current_interval t at
;;

let add t ~at value =
  ensure_can_schedule_alarm t ~at;
  Internal_elt.to_external
    (Priority_queue.internal_add
       t.priority_queue
       ~key:(interval_num_unchecked t at)
       ~at
       value)
;;

let remove t alarm = Priority_queue.remove t.priority_queue alarm
let clear t = Priority_queue.clear t.priority_queue
let mem t alarm = Priority_queue.mem t.priority_queue alarm

let reschedule_gen t alarm ~key ~at =
  if not (mem t alarm)
  then failwith "Timing_wheel cannot reschedule alarm not in timing wheel";
  ensure_can_schedule_alarm t ~at;
  Priority_queue.change t.priority_queue alarm ~key ~at
;;

let reschedule t alarm ~at = reschedule_gen t alarm ~key:(interval_num_unchecked t at) ~at

let reschedule_at_interval_num t alarm ~at =
  reschedule_gen t alarm ~key:at ~at:(interval_num_start t at)
;;

let min_alarm_interval_num t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt then None else Some (Internal_elt.key (pool t) elt)
;;

let min_alarm_interval_num_exn t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.min_alarm_interval_num_exn of empty timing_wheel"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "timing_wheel"
               ; ((fun x__164_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__164_)
                    [@merlin.hide])
                   t
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  else Internal_elt.key (pool t) elt
;;

let max_alarm_time_in_list t elt =
  let pool = pool t in
  Internal_elt.max_alarm_time pool elt ~with_key:(Internal_elt.key pool elt)
;;

let min_alarm_time_in_list t elt =
  let pool = pool t in
  Internal_elt.min_alarm_time pool elt ~with_key:(Internal_elt.key pool elt)
;;

let max_alarm_time_in_min_interval t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt then None else Some (max_alarm_time_in_list t elt)
;;

let min_alarm_time_in_min_interval t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt then None else Some (min_alarm_time_in_list t elt)
;;

let max_alarm_time_in_min_interval_exn t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.max_alarm_time_in_min_interval_exn of empty timing wheel"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "timing_wheel"
               ; ((fun x__165_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__165_)
                    [@merlin.hide])
                   t
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  max_alarm_time_in_list t elt
;;

let min_alarm_time_in_min_interval_exn t =
  let elt = Priority_queue.min_elt_ t.priority_queue in
  if Internal_elt.is_null elt
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Timing_wheel.max_alarm_time_in_min_interval_exn of empty timing wheel"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "timing_wheel"
               ; ((fun x__166_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__166_)
                    [@merlin.hide])
                   t
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  min_alarm_time_in_list t elt
;;

let fire_past_alarms t ~handle_fired =
  Priority_queue.fire_past_alarms
    t.priority_queue
    ~handle_fired
    ~key:(now_interval_num t)
    ~now:t.now
;;

module Private = struct
  module Num_key_bits = Num_key_bits

  let interval_num_internal = interval_num_internal
  let max_time = max_time
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
