let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"bus.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "bus.ml.before-ppx"
;;

open! Core

module State = struct
  type t =
    | Closed
    | Write_in_progress
    | Ok_to_write
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | Closed -> Sexplib0.Sexp.Atom "Closed"
       | Write_in_progress -> Sexplib0.Sexp.Atom "Write_in_progress"
       | Ok_to_write -> Sexplib0.Sexp.Atom "Ok_to_write"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let is_closed = function
    | Closed -> true
    | Write_in_progress -> false
    | Ok_to_write -> false
  ;;
end

module Callback_arity = struct
  type _ t =
    | Arity1 : ('a -> unit) t
    | Arity1_local : ('a -> unit) t
    | Arity2 : ('a -> 'b -> unit) t
    | Arity3 : ('a -> 'b -> 'c -> unit) t
    | Arity4 : ('a -> 'b -> 'c -> 'd -> unit) t
    | Arity5 : ('a -> 'b -> 'c -> 'd -> 'e -> unit) t
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : _ t) -> ()

    let sexp_of_t
      : 'a__001_. ('a__001_ -> Sexplib0.Sexp.t) -> 'a__001_ t -> Sexplib0.Sexp.t
      =
      fun (type a__003_) ->
      (fun _of_a__002_ -> function
         | Arity1 -> Sexplib0.Sexp.Atom "Arity1"
         | Arity1_local -> Sexplib0.Sexp.Atom "Arity1_local"
         | Arity2 -> Sexplib0.Sexp.Atom "Arity2"
         | Arity3 -> Sexplib0.Sexp.Atom "Arity3"
         | Arity4 -> Sexplib0.Sexp.Atom "Arity4"
         | Arity5 -> Sexplib0.Sexp.Atom "Arity5"
       : (a__003_ -> Sexplib0.Sexp.t) -> a__003_ t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let uses_local_args : type a. a t -> bool = function
    | Arity1 -> false
    | Arity1_local -> true
    | Arity2 -> false
    | Arity3 -> false
    | Arity4 -> false
    | Arity5 -> false
  ;;
end

module Last_value : sig
  type 'callback t

  val create_exn : 'callback Callback_arity.t -> 'callback t
  val set1 : ('a -> unit) t -> 'a -> unit
  val set2 : ('a -> 'b -> unit) t -> 'a -> 'b -> unit
  val set3 : ('a -> 'b -> 'c -> unit) t -> 'a -> 'b -> 'c -> unit
  val set4 : ('a -> 'b -> 'c -> 'd -> unit) t -> 'a -> 'b -> 'c -> 'd -> unit
  val set5 : ('a -> 'b -> 'c -> 'd -> 'e -> unit) t -> 'a -> 'b -> 'c -> 'd -> 'e -> unit
  val send : 'callback t -> 'callback -> unit
end = struct
  type _ tuple =
    | Tuple1 : { mutable arg1 : 'a } -> ('a -> unit) tuple
    | Tuple2 :
        { mutable arg1 : 'a
        ; mutable arg2 : 'b
        }
        -> ('a -> 'b -> unit) tuple
    | Tuple3 :
        { mutable arg1 : 'a
        ; mutable arg2 : 'b
        ; mutable arg3 : 'c
        }
        -> ('a -> 'b -> 'c -> unit) tuple
    | Tuple4 :
        { mutable arg1 : 'a
        ; mutable arg2 : 'b
        ; mutable arg3 : 'c
        ; mutable arg4 : 'd
        }
        -> ('a -> 'b -> 'c -> 'd -> unit) tuple
    | Tuple5 :
        { mutable arg1 : 'a
        ; mutable arg2 : 'b
        ; mutable arg3 : 'c
        ; mutable arg4 : 'd
        ; mutable arg5 : 'e
        }
        -> ('a -> 'b -> 'c -> 'd -> 'e -> unit) tuple

  type 'callback t = 'callback tuple option ref

  let create_exn (type callback) (arity : callback Callback_arity.t) : callback t =
    if Callback_arity.uses_local_args arity
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Cannot save last value when using local args"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "arity"
                 ; ((fun x__004_ ->
                      Callback_arity.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__004_)
                      [@merlin.hide])
                     arity
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    ref None
  ;;

  let set1 t a =
    match !t with
    | None -> t := Some (Tuple1 { arg1 = a })
    | Some (Tuple1 args) -> args.arg1 <- a
  ;;

  let set2 t a b =
    match !t with
    | None -> t := Some (Tuple2 { arg1 = a; arg2 = b })
    | Some (Tuple2 args) ->
      args.arg1 <- a;
      args.arg2 <- b
  ;;

  let set3 t a b c =
    match !t with
    | None -> t := Some (Tuple3 { arg1 = a; arg2 = b; arg3 = c })
    | Some (Tuple3 args) ->
      args.arg1 <- a;
      args.arg2 <- b;
      args.arg3 <- c
  ;;

  let set4 t a b c d =
    match !t with
    | None -> t := Some (Tuple4 { arg1 = a; arg2 = b; arg3 = c; arg4 = d })
    | Some (Tuple4 args) ->
      args.arg1 <- a;
      args.arg2 <- b;
      args.arg3 <- c;
      args.arg4 <- d
  ;;

  let set5 t arg1 arg2 arg3 arg4 arg5 =
    match !t with
    | None -> t := Some (Tuple5 { arg1; arg2; arg3; arg4; arg5 })
    | Some (Tuple5 args) ->
      args.arg1 <- arg1;
      args.arg2 <- arg2;
      args.arg3 <- arg3;
      args.arg4 <- arg4;
      args.arg5 <- arg5
  ;;

  let send (type callback) (t : callback t) (callback : callback) : unit =
    match !t with
    | None -> ()
    | Some (Tuple1 { arg1 }) -> callback arg1
    | Some (Tuple2 { arg1; arg2 }) -> callback arg1 arg2
    | Some (Tuple3 { arg1; arg2; arg3 }) -> callback arg1 arg2 arg3
    | Some (Tuple4 { arg1; arg2; arg3; arg4 }) -> callback arg1 arg2 arg3 arg4
    | Some (Tuple5 { arg1; arg2; arg3; arg4; arg5 }) -> callback arg1 arg2 arg3 arg4 arg5
  ;;
end

module On_subscription_after_first_write = struct
  type t =
    | Allow
    | Allow_and_send_last_value
    | Raise
  [@@deriving enumerate, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let all = ([ Allow; Allow_and_send_last_value; Raise ] : t list)
    let _ = all

    let sexp_of_t =
      (function
       | Allow -> Sexplib0.Sexp.Atom "Allow"
       | Allow_and_send_last_value -> Sexplib0.Sexp.Atom "Allow_and_send_last_value"
       | Raise -> Sexplib0.Sexp.Atom "Raise"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let allow_subscription_after_first_write = function
    | Allow -> true
    | Allow_and_send_last_value -> true
    | Raise -> false
  ;;

  let save_last_value_exn t callback_arity =
    match t with
    | Allow_and_send_last_value -> Some (Last_value.create_exn callback_arity)
    | Allow -> None
    | Raise -> None
  ;;
end

module Bus_id = Unique_id.Int63 ()

module Subscriber = struct
  type 'callback t =
    { bus_id : Bus_id.t
    ; callback : 'callback
    ; extract_exn : bool
    ; mutable subscribers_index : int
    ; on_callback_raise : (Error.t -> unit) option
    ; on_close : (unit -> unit) option
    ; subscribed_from : Source_code_position.t
    }
  [@@deriving fields ~iterators:iter]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'callback t) -> ()
    let subscribed_from _r__ = _r__.subscribed_from
    let _ = subscribed_from
    let on_close _r__ = _r__.on_close
    let _ = on_close
    let on_callback_raise _r__ = _r__.on_callback_raise
    let _ = on_callback_raise
    let subscribers_index _r__ = _r__.subscribers_index
    let _ = subscribers_index
    let set_subscribers_index _r__ v__ = _r__.subscribers_index <- v__
    let _ = set_subscribers_index
    let extract_exn _r__ = _r__.extract_exn
    let _ = extract_exn
    let callback _r__ = _r__.callback
    let _ = callback
    let bus_id _r__ = _r__.bus_id
    let _ = bus_id

    module Fields = struct
      let subscribed_from =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "subscribed_from"
           ; getter = subscribed_from
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with subscribed_from = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , Source_code_position.t )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = subscribed_from

      let on_close =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "on_close"
           ; getter = on_close
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with on_close = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , (unit -> unit) option )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = on_close

      let on_callback_raise =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "on_callback_raise"
           ; getter = on_callback_raise
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with on_callback_raise = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , (Error.t -> unit) option )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = on_callback_raise

      let subscribers_index =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "subscribers_index"
           ; getter = subscribers_index
           ; setter = Some set_subscribers_index
           ; fset = (fun _r__ v__ -> { _r__ with subscribers_index = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = subscribers_index

      let extract_exn =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "extract_exn"
           ; getter = extract_exn
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with extract_exn = v__ })
           }
         : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
      ;;

      let _ = extract_exn

      let callback =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "callback"
           ; getter = callback
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with callback = v__ })
           }
         : ([< `Read | `Set_and_create ], _, 'callback) Fieldslib.Field.t_with_perm)
      ;;

      let _ = callback

      let bus_id =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "bus_id"
           ; getter = bus_id
           ; setter = None
           ; fset = (fun _r__ v__ -> { _r__ with bus_id = v__ })
           }
         : ([< `Read | `Set_and_create ], _, Bus_id.t) Fieldslib.Field.t_with_perm)
      ;;

      let _ = bus_id

      let iter
            ~bus_id:bus_id_fun__
            ~callback:callback_fun__
            ~extract_exn:extract_exn_fun__
            ~subscribers_index:subscribers_index_fun__
            ~on_callback_raise:on_callback_raise_fun__
            ~on_close:on_close_fun__
            ~subscribed_from:subscribed_from_fun__
        =
        (bus_id_fun__ bus_id : unit);
        (callback_fun__ callback : unit);
        (extract_exn_fun__ extract_exn : unit);
        (subscribers_index_fun__ subscribers_index : unit);
        (on_callback_raise_fun__ on_callback_raise : unit);
        (on_close_fun__ on_close : unit);
        (subscribed_from_fun__ subscribed_from : unit)
      ;;

      let _ = iter
    end
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let is_subscribed t ~to_ = t.subscribers_index >= 0 && Bus_id.equal t.bus_id to_

  let sexp_of_t
        _
        { callback = _
        ; bus_id = _
        ; extract_exn
        ; subscribers_index
        ; on_callback_raise
        ; on_close = _
        ; subscribed_from
        }
    : Sexp.t
    =
    List
      [ Atom "Bus.Subscriber.t"
      ; (let ppx_sexp_message () =
           match
             match
               ( (if Ppx_inline_test_lib.am_running then None else Some subscribers_index)
               , match
                   ( on_callback_raise
                   , match
                       ( (if extract_exn then Some true else None)
                       , [ Ppx_sexp_conv_lib.Sexp.List
                             [ Ppx_sexp_conv_lib.Sexp.Atom "subscribed_from"
                             ; (Source_code_position.sexp_of_t [@merlin.hide])
                                 subscribed_from
                             ]
                         ] )
                     with
                     | None, tl -> tl
                     | Some v, tl ->
                       Ppx_sexp_conv_lib.Sexp.List
                         [ Ppx_sexp_conv_lib.Sexp.Atom "extract_exn"
                         ; (sexp_of_bool [@merlin.hide]) v
                         ]
                       :: tl )
                 with
                 | None, tl -> tl
                 | Some v, tl ->
                   Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "on_callback_raise"
                     ; ((fun _ ->
                          Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore)
                          [@merlin.hide])
                         v
                     ]
                   :: tl )
             with
             | None, tl -> tl
             | Some v, tl ->
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "subscribers_index"
                 ; (sexp_of_int [@merlin.hide]) v
                 ]
               :: tl
           with
           | h :: [] -> h
           | ([] | _ :: _ :: _) as res -> Ppx_sexp_conv_lib.Sexp.List res
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
      ]
  ;;

  let invariant invariant_a t =
    Invariant.invariant
      { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
      ; pos_lnum = 209
      ; pos_cnum = 5661
      ; pos_bol = 5637
      }
      t
      ((fun x__005_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__005_)
         [@merlin.hide])
      (fun () ->
         let check f = Invariant.check_field t f in
         Fields.iter
           ~bus_id:ignore
           ~callback:(check invariant_a)
           ~extract_exn:ignore
           ~subscribers_index:ignore
           ~on_callback_raise:ignore
           ~on_close:ignore
           ~subscribed_from:ignore)
  ;;

  let create
        subscribed_from
        ~callback
        ~bus_id
        ~extract_exn
        ~subscribers_index
        ~on_callback_raise
        ~on_close
    =
    { bus_id
    ; callback
    ; extract_exn
    ; subscribers_index
    ; on_callback_raise
    ; on_close
    ; subscribed_from
    }
  ;;
end

type ('callback, 'phantom) t =
  { bus_id : Bus_id.t
  ; name : Info.t option
  ; callback_arity : 'callback Callback_arity.t
  ; created_from : Source_code_position.t
  ; on_subscription_after_first_write : On_subscription_after_first_write.t
  ; on_callback_raise : Error.t -> unit
  ; last_value : 'callback Last_value.t option
  ; mutable state : State.t
  ; mutable write_ever_called : bool
  ; mutable num_subscribers : int
  ; mutable subscribers : 'callback Subscriber.t Option_array.t
  ; mutable callbacks : 'callback Option_array.t
  ; mutable unsubscribes_during_write : 'callback Subscriber.t list
  }
[@@deriving fields ~getters ~iterators:iter]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : ('callback, 'phantom) t) -> ()
  let unsubscribes_during_write _r__ = _r__.unsubscribes_during_write
  let _ = unsubscribes_during_write
  let set_unsubscribes_during_write _r__ v__ = _r__.unsubscribes_during_write <- v__
  let _ = set_unsubscribes_during_write
  let callbacks _r__ = _r__.callbacks
  let _ = callbacks
  let set_callbacks _r__ v__ = _r__.callbacks <- v__
  let _ = set_callbacks
  let subscribers _r__ = _r__.subscribers
  let _ = subscribers
  let set_subscribers _r__ v__ = _r__.subscribers <- v__
  let _ = set_subscribers
  let num_subscribers _r__ = _r__.num_subscribers
  let _ = num_subscribers
  let set_num_subscribers _r__ v__ = _r__.num_subscribers <- v__
  let _ = set_num_subscribers
  let write_ever_called _r__ = _r__.write_ever_called
  let _ = write_ever_called
  let set_write_ever_called _r__ v__ = _r__.write_ever_called <- v__
  let _ = set_write_ever_called
  let state _r__ = _r__.state
  let _ = state
  let set_state _r__ v__ = _r__.state <- v__
  let _ = set_state
  let last_value _r__ = _r__.last_value
  let _ = last_value
  let on_callback_raise _r__ = _r__.on_callback_raise
  let _ = on_callback_raise
  let on_subscription_after_first_write _r__ = _r__.on_subscription_after_first_write
  let _ = on_subscription_after_first_write
  let created_from _r__ = _r__.created_from
  let _ = created_from
  let callback_arity _r__ = _r__.callback_arity
  let _ = callback_arity
  let name _r__ = _r__.name
  let _ = name
  let bus_id _r__ = _r__.bus_id
  let _ = bus_id

  module Fields = struct
    let unsubscribes_during_write =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "unsubscribes_during_write"
         ; getter = unsubscribes_during_write
         ; setter = Some set_unsubscribes_during_write
         ; fset = (fun _r__ v__ -> { _r__ with unsubscribes_during_write = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'callback Subscriber.t list )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = unsubscribes_during_write

    let callbacks =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "callbacks"
         ; getter = callbacks
         ; setter = Some set_callbacks
         ; fset = (fun _r__ v__ -> { _r__ with callbacks = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'callback Option_array.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = callbacks

    let subscribers =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "subscribers"
         ; getter = subscribers
         ; setter = Some set_subscribers
         ; fset = (fun _r__ v__ -> { _r__ with subscribers = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'callback Subscriber.t Option_array.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = subscribers

    let num_subscribers =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "num_subscribers"
         ; getter = num_subscribers
         ; setter = Some set_num_subscribers
         ; fset = (fun _r__ v__ -> { _r__ with num_subscribers = v__ })
         }
       : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
    ;;

    let _ = num_subscribers

    let write_ever_called =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "write_ever_called"
         ; getter = write_ever_called
         ; setter = Some set_write_ever_called
         ; fset = (fun _r__ v__ -> { _r__ with write_ever_called = v__ })
         }
       : ([< `Read | `Set_and_create ], _, bool) Fieldslib.Field.t_with_perm)
    ;;

    let _ = write_ever_called

    let state =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "state"
         ; getter = state
         ; setter = Some set_state
         ; fset = (fun _r__ v__ -> { _r__ with state = v__ })
         }
       : ([< `Read | `Set_and_create ], _, State.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = state

    let last_value =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "last_value"
         ; getter = last_value
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with last_value = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'callback Last_value.t option )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = last_value

    let on_callback_raise =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "on_callback_raise"
         ; getter = on_callback_raise
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with on_callback_raise = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Error.t -> unit) Fieldslib.Field.t_with_perm)
    ;;

    let _ = on_callback_raise

    let on_subscription_after_first_write =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "on_subscription_after_first_write"
         ; getter = on_subscription_after_first_write
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with on_subscription_after_first_write = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , On_subscription_after_first_write.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = on_subscription_after_first_write

    let created_from =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "created_from"
         ; getter = created_from
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with created_from = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , Source_code_position.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = created_from

    let callback_arity =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "callback_arity"
         ; getter = callback_arity
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with callback_arity = v__ })
         }
       : ( [< `Read | `Set_and_create ]
           , _
           , 'callback Callback_arity.t )
           Fieldslib.Field.t_with_perm)
    ;;

    let _ = callback_arity

    let name =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "name"
         ; getter = name
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with name = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Info.t option) Fieldslib.Field.t_with_perm)
    ;;

    let _ = name

    let bus_id =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "bus_id"
         ; getter = bus_id
         ; setter = None
         ; fset = (fun _r__ v__ -> { _r__ with bus_id = v__ })
         }
       : ([< `Read | `Set_and_create ], _, Bus_id.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = bus_id

    let iter
          ~bus_id:bus_id_fun__
          ~name:name_fun__
          ~callback_arity:callback_arity_fun__
          ~created_from:created_from_fun__
          ~on_subscription_after_first_write:on_subscription_after_first_write_fun__
          ~on_callback_raise:on_callback_raise_fun__
          ~last_value:last_value_fun__
          ~state:state_fun__
          ~write_ever_called:write_ever_called_fun__
          ~num_subscribers:num_subscribers_fun__
          ~subscribers:subscribers_fun__
          ~callbacks:callbacks_fun__
          ~unsubscribes_during_write:unsubscribes_during_write_fun__
      =
      (bus_id_fun__ bus_id : unit);
      (name_fun__ name : unit);
      (callback_arity_fun__ callback_arity : unit);
      (created_from_fun__ created_from : unit);
      (on_subscription_after_first_write_fun__ on_subscription_after_first_write : unit);
      (on_callback_raise_fun__ on_callback_raise : unit);
      (last_value_fun__ last_value : unit);
      (state_fun__ state : unit);
      (write_ever_called_fun__ write_ever_called : unit);
      (num_subscribers_fun__ num_subscribers : unit);
      (subscribers_fun__ subscribers : unit);
      (callbacks_fun__ callbacks : unit);
      (unsubscribes_during_write_fun__ unsubscribes_during_write : unit)
    ;;

    let _ = iter
  end
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sexp_of_t
      _
      _
      { bus_id = _
      ; callback_arity
      ; callbacks = _
      ; created_from
      ; last_value = _
      ; name
      ; num_subscribers
      ; on_subscription_after_first_write
      ; on_callback_raise = _
      ; state
      ; subscribers
      ; write_ever_called
      ; unsubscribes_during_write = _
      }
  =
  let subscribers =
    Array.init num_subscribers ~f:(fun i -> Option_array.get_some_exn subscribers i)
  in
  let ppx_sexp_message () =
    match
      match
        ( name
        , [ Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "callback_arity"
              ; ((fun x__006_ ->
                   Callback_arity.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__006_)
                   [@merlin.hide])
                  callback_arity
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "created_from"
              ; (Source_code_position.sexp_of_t [@merlin.hide]) created_from
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "on_subscription_after_first_write"
              ; (On_subscription_after_first_write.sexp_of_t [@merlin.hide])
                  on_subscription_after_first_write
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "state"
              ; (State.sexp_of_t [@merlin.hide]) state
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "write_ever_called"
              ; (sexp_of_bool [@merlin.hide]) write_ever_called
              ]
          ; Ppx_sexp_conv_lib.Sexp.List
              [ Ppx_sexp_conv_lib.Sexp.Atom "subscribers"
              ; ((fun x__007_ ->
                   Array.sexp_of_t
                     (Subscriber.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_"))
                     x__007_) [@merlin.hide])
                  subscribers
              ]
          ] )
      with
      | None, tl -> tl
      | Some v, tl ->
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.Atom "name"; (Info.sexp_of_t [@merlin.hide]) v ]
        :: tl
    with
    | h :: [] -> h
    | ([] | _ :: _ :: _) as res -> Ppx_sexp_conv_lib.Sexp.List res
      [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  in
  (ppx_sexp_message () [@nontail])
;;

type ('callback, 'phantom) bus = ('callback, 'phantom) t [@@deriving sexp_of]

include struct
  let _ = fun (_ : ('callback, 'phantom) bus) -> ()

  let sexp_of_bus
    :  'callback 'phantom.
       ('callback -> Sexplib0.Sexp.t)
    -> ('phantom -> Sexplib0.Sexp.t)
    -> ('callback, 'phantom) bus
    -> Sexplib0.Sexp.t
    =
    fun _of_callback__008_ _of_phantom__009_ x__010_ ->
    sexp_of_t _of_callback__008_ _of_phantom__009_ x__010_
  ;;

  let _ = sexp_of_bus
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let read_only t = (t :> (_, read) t)

let invariant invariant_a _ t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
    ; pos_lnum = 298
    ; pos_cnum = 8072
    ; pos_bol = 8050
    }
    t
    ((fun x__011_ ->
       sexp_of_t
         (fun _ -> Sexplib0.Sexp.Atom "_")
         (fun _ -> Sexplib0.Sexp.Atom "_")
         x__011_) [@merlin.hide])
    (fun () ->
       let check f = Invariant.check_field t f in
       Fields.iter
         ~bus_id:ignore
         ~name:ignore
         ~callbacks:
           (check (fun callbacks ->
              assert (Option_array.length callbacks = Option_array.length t.subscribers);
              for i = 0 to Option_array.length callbacks - 1 do
                if i < t.num_subscribers
                then invariant_a (Option_array.get_some_exn callbacks i)
                else assert (Option_array.is_none callbacks i)
              done))
         ~callback_arity:ignore
         ~created_from:ignore
         ~num_subscribers:(check (fun num_subscribers -> assert (num_subscribers >= 0)))
         ~on_subscription_after_first_write:ignore
         ~on_callback_raise:ignore
         ~last_value:ignore
         ~state:ignore
         ~write_ever_called:ignore
         ~subscribers:
           (check (fun subscribers ->
              for i = 0 to Option_array.length subscribers - 1 do
                if i < t.num_subscribers
                then (
                  let subscriber = Option_array.get_some_exn subscribers i in
                  Subscriber.invariant invariant_a subscriber;
                  assert (i = subscriber.subscribers_index))
                else assert (Option_array.is_none subscribers i)
              done))
         ~unsubscribes_during_write:ignore)
;;

let is_closed t = State.is_closed t.state

module Read_write = struct
  type 'callback t = ('callback, read_write) bus [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'callback t) -> ()

    let sexp_of_t
      : 'callback. ('callback -> Sexplib0.Sexp.t) -> 'callback t -> Sexplib0.Sexp.t
      =
      fun _of_callback__012_ x__013_ ->
      sexp_of_bus _of_callback__012_ sexp_of_read_write x__013_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let invariant invariant_a t = invariant invariant_a ignore t
end

module Read_only = struct
  type 'callback t = ('callback, read) bus [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'callback t) -> ()

    let sexp_of_t
      : 'callback. ('callback -> Sexplib0.Sexp.t) -> 'callback t -> Sexplib0.Sexp.t
      =
      fun _of_callback__014_ x__015_ ->
      sexp_of_bus _of_callback__014_ sexp_of_read x__015_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let invariant invariant_a t = invariant invariant_a ignore t
end

let start_write_failing t =
  match t.state with
  | Closed ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
        ; pos_lnum = 349
        ; pos_cnum = 9853
        ; pos_bol = 9833
        }
      "[Bus.write] called on closed bus"
      t
      ((fun x__016_ ->
         sexp_of_t
           (fun _ -> Sexplib0.Sexp.Atom "_")
           (fun _ -> Sexplib0.Sexp.Atom "_")
           x__016_) [@merlin.hide])
  | Write_in_progress ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
        ; pos_lnum = 352
        ; pos_cnum = 9970
        ; pos_bol = 9958
        }
      "[Bus.write] called from callback on the same bus"
      t
      ((fun x__017_ ->
         sexp_of_t
           (fun _ -> Sexplib0.Sexp.Atom "_")
           (fun _ -> Sexplib0.Sexp.Atom "_")
           x__017_) [@merlin.hide])
  | Ok_to_write -> assert false
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let capacity t = Option_array.length t.subscribers

let maybe_shrink_capacity t =
  if t.num_subscribers * 4 <= capacity t
  then (
    let desired_capacity = t.num_subscribers in
    let copy_and_shrink array =
      let new_array = Option_array.create ~len:desired_capacity in
      Option_array.blit
        ~src:array
        ~src_pos:0
        ~dst:new_array
        ~dst_pos:0
        ~len:t.num_subscribers;
      new_array
    in
    t.subscribers <- copy_and_shrink t.subscribers;
    t.callbacks <- copy_and_shrink t.callbacks)
;;

let add_subscriber t (subscriber : _ Subscriber.t) ~at_subscribers_index =
  subscriber.subscribers_index <- at_subscribers_index;
  Option_array.set_some t.subscribers at_subscribers_index subscriber;
  Option_array.set_some t.callbacks at_subscribers_index subscriber.callback
;;

let remove_subscriber t (subscriber : _ Subscriber.t) =
  let subscribers_index = subscriber.subscribers_index in
  subscriber.subscribers_index <- -1;
  Option_array.set_none t.subscribers subscribers_index;
  Option_array.set_none t.callbacks subscribers_index
;;

let unsubscribe_assuming_valid_subscriber t (subscriber : _ Subscriber.t) =
  let subscriber_index = subscriber.subscribers_index in
  let last_subscriber_index = t.num_subscribers - 1 in
  remove_subscriber t subscriber;
  if subscriber_index < last_subscriber_index
  then (
    let last_subscriber = Option_array.get_some_exn t.subscribers last_subscriber_index in
    remove_subscriber t last_subscriber;
    add_subscriber t last_subscriber ~at_subscribers_index:subscriber_index);
  t.num_subscribers <- t.num_subscribers - 1;
  maybe_shrink_capacity t
;;

let unsubscribe t subscriber =
  if Subscriber.is_subscribed subscriber ~to_:t.bus_id
  then (
    match t.state with
    | Write_in_progress ->
      t.unsubscribes_during_write <- subscriber :: t.unsubscribes_during_write
    | Closed -> ()
    | Ok_to_write -> unsubscribe_assuming_valid_subscriber t subscriber)
;;

let unsubscribe_after_finish_write t =
  List.iter t.unsubscribes_during_write ~f:(unsubscribe_assuming_valid_subscriber t);
  t.unsubscribes_during_write <- []
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let unsubscribe_all t =
  assert (is_closed t);
  for i = 0 to t.num_subscribers - 1 do
    let subscriber = Option_array.get_some_exn t.subscribers i in
    Option.iter subscriber.on_close ~f:(fun on_close -> on_close ());
    remove_subscriber t subscriber
  done;
  t.num_subscribers <- 0;
  maybe_shrink_capacity t
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let finish_write t =
  if not (List.is_empty t.unsubscribes_during_write) then unsubscribe_after_finish_write t;
  match t.state with
  | Closed -> unsubscribe_all t
  | Ok_to_write -> assert false
  | Write_in_progress -> t.state <- Ok_to_write
[@@inline always]
;;

let close t =
  match t.state with
  | Closed -> ()
  | Write_in_progress -> t.state <- Closed
  | Ok_to_write ->
    t.state <- Closed;
    unsubscribe_all t
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let call_on_callback_raise t error =
  try t.on_callback_raise error with
  | exn ->
    close t;
    raise exn
;;

let callback_raised t i exn =
  let subscriber = Option_array.get_some_exn t.subscribers (i - 1) in
  let error =
    match subscriber.extract_exn with
    | true -> Error.of_exn exn
    | false ->
      let backtrace = Backtrace.Exn.most_recent () in
      (Error.t_of_sexp [@merlin.hide])
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Bus subscriber raised"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "exn"; (sexp_of_exn [@merlin.hide]) exn ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "backtrace"
                 ; (Backtrace.sexp_of_t [@merlin.hide]) backtrace
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "subscriber"
                 ; ((fun x__018_ ->
                      Subscriber.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__018_)
                      [@merlin.hide])
                     subscriber
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  in
  match subscriber.on_callback_raise with
  | None -> call_on_callback_raise t error
  | Some f ->
    (try f error with
     | exn ->
       let backtrace = Backtrace.Exn.most_recent () in
       call_on_callback_raise
         t
         (let original_error = error in
          (Error.t_of_sexp [@merlin.hide])
            (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                     "Bus subscriber's [on_callback_raise] raised"
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "exn"
                     ; (sexp_of_exn [@merlin.hide]) exn
                     ]
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "backtrace"
                     ; (Backtrace.sexp_of_t [@merlin.hide]) backtrace
                     ]
                 ; Ppx_sexp_conv_lib.Sexp.List
                     [ Ppx_sexp_conv_lib.Sexp.Atom "original_error"
                     ; (Error.sexp_of_t [@merlin.hide]) original_error
                     ]
                 ]
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))))
;;

let unsafe_get_callback a i = Option_array.unsafe_get_some_assuming_some a i
[@@inline always]
;;

let write_non_optimized t callbacks a1 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write_local_non_optimized t callbacks a1 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write2_non_optimized t callbacks a1 a2 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1 a2
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write3_non_optimized t callbacks a1 a2 a3 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1 a2 a3
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write4_non_optimized t callbacks a1 a2 a3 a4 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1 a2 a3 a4
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write5_non_optimized t callbacks a1 a2 a3 a4 a5 =
  let len = t.num_subscribers in
  let i = ref 0 in
  while !i < len do
    try
      let callback = unsafe_get_callback callbacks !i in
      incr i;
      callback a1 a2 a3 a4 a5
    with
    | exn -> callback_raised t !i exn
  done;
  finish_write t
;;

let write t a1 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.set1 last_value a1);
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write_non_optimized [@inlined never]) t callbacks a1)
[@@inline always]
;;

let write_local t a1 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write_local_non_optimized [@inlined never]) t callbacks a1)
[@@inline always]
;;

let write2 t a1 a2 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.set2 last_value a1 a2);
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 a2 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write2_non_optimized [@inlined never]) t callbacks a1 a2)
[@@inline always]
;;

let write3 t a1 a2 a3 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.set3 last_value a1 a2 a3);
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 a2 a3 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write3_non_optimized [@inlined never]) t callbacks a1 a2 a3)
[@@inline always]
;;

let write4 t a1 a2 a3 a4 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.set4 last_value a1 a2 a3 a4);
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 a2 a3 a4 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write4_non_optimized [@inlined never]) t callbacks a1 a2 a3 a4)
[@@inline always]
;;

let write5 t a1 a2 a3 a4 a5 =
  let callbacks = t.callbacks in
  t.write_ever_called <- true;
  match t.state with
  | Closed | Write_in_progress -> start_write_failing t
  | Ok_to_write ->
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.set5 last_value a1 a2 a3 a4 a5);
    if t.num_subscribers > 0
    then (
      t.state <- Write_in_progress;
      if t.num_subscribers = 1
      then (
        (try (unsafe_get_callback callbacks 0) a1 a2 a3 a4 a5 with
         | exn -> callback_raised t 1 exn);
        finish_write t)
      else (write5_non_optimized [@inlined never]) t callbacks a1 a2 a3 a4 a5)
[@@inline always]
;;

let allow_subscription_after_first_write t =
  On_subscription_after_first_write.allow_subscription_after_first_write
    t.on_subscription_after_first_write
;;

let create_exn
      ?name
      created_from
      callback_arity
      ~(on_subscription_after_first_write : On_subscription_after_first_write.t)
      ~on_callback_raise
  =
  let last_value =
    On_subscription_after_first_write.save_last_value_exn
      on_subscription_after_first_write
      callback_arity
  in
  { bus_id = Bus_id.create ()
  ; name
  ; callback_arity
  ; created_from
  ; num_subscribers = 0
  ; on_subscription_after_first_write
  ; on_callback_raise
  ; last_value
  ; subscribers = Option_array.create ~len:0
  ; callbacks = Option_array.create ~len:0
  ; state = Ok_to_write
  ; write_ever_called = false
  ; unsubscribes_during_write = []
  }
;;

let can_subscribe t = allow_subscription_after_first_write t || not t.write_ever_called

let enlarge_capacity t =
  let capacity = capacity t in
  let new_capacity = Int.max 1 (capacity * 2) in
  let copy_and_double array =
    let new_array = Option_array.create ~len:new_capacity in
    Option_array.blit ~src:array ~src_pos:0 ~dst:new_array ~dst_pos:0 ~len:capacity;
    new_array
  in
  t.subscribers <- copy_and_double t.subscribers;
  t.callbacks <- copy_and_double t.callbacks
;;

let subscribe_exn
      ?(extract_exn = false)
      ?on_callback_raise
      ?on_close
      t
      subscribed_from
      ~f:callback
  =
  if not (can_subscribe t)
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
        ; pos_lnum = 767
        ; pos_cnum = 22333
        ; pos_bol = 22321
        }
      "Bus.subscribe_exn called after first write"
      (Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "subscribed_from"
             ; (Source_code_position.sexp_of_t [@merlin.hide]) subscribed_from
             ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "bus"
                 ; ((fun x__019_ ->
                      sexp_of_t
                        (fun _ -> Sexplib0.Sexp.Atom "_")
                        (fun _ -> Sexplib0.Sexp.Atom "_")
                        x__019_) [@merlin.hide])
                     t
                 ]
             ]
         ])
      (Sexp.sexp_of_t [@merlin.hide]);
  match t.state with
  | Closed ->
    Subscriber.create
      subscribed_from
      ~bus_id:t.bus_id
      ~callback
      ~extract_exn
      ~subscribers_index:(-1)
      ~on_callback_raise
      ~on_close
  | Ok_to_write | Write_in_progress ->
    let subscriber =
      Subscriber.create
        subscribed_from
        ~bus_id:t.bus_id
        ~callback
        ~extract_exn
        ~subscribers_index:t.num_subscribers
        ~on_callback_raise
        ~on_close
    in
    if capacity t = t.num_subscribers then enlarge_capacity t;
    add_subscriber t subscriber ~at_subscribers_index:t.num_subscribers;
    t.num_subscribers <- t.num_subscribers + 1;
    (match t.last_value with
     | None -> ()
     | Some last_value -> Last_value.send last_value callback);
    subscriber
;;

let iter_exn ?extract_exn t subscribed_from ~f =
  if not (can_subscribe t)
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
        ; pos_lnum = 811
        ; pos_cnum = 23943
        ; pos_bol = 23923
        }
      "Bus.iter_exn called after first write"
      t
      ((fun x__020_ ->
         sexp_of_t
           (fun _ -> Sexplib0.Sexp.Atom "_")
           (fun _ -> Sexplib0.Sexp.Atom "_")
           x__020_) [@merlin.hide]);
  ignore (subscribe_exn ?extract_exn t subscribed_from ~f : _ Subscriber.t)
;;

module Fold_arity = struct
  type (_, _, _) t =
    | Arity1 : ('a -> unit, 's -> 'a -> 's, 's) t
    | Arity2 : ('a -> 'b -> unit, 's -> 'a -> 'b -> 's, 's) t
    | Arity3 : ('a -> 'b -> 'c -> unit, 's -> 'a -> 'b -> 'c -> 's, 's) t
    | Arity4 : ('a -> 'b -> 'c -> 'd -> unit, 's -> 'a -> 'b -> 'c -> 'd -> 's, 's) t
    | Arity5 :
        ('a -> 'b -> 'c -> 'd -> 'e -> unit, 's -> 'a -> 'b -> 'c -> 'd -> 'e -> 's, 's) t
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : (_, _, _) t) -> ()

    let sexp_of_t
      :  'a__021_ 'b__022_ 'c__023_.
         ('a__021_ -> Sexplib0.Sexp.t)
      -> ('b__022_ -> Sexplib0.Sexp.t)
      -> ('c__023_ -> Sexplib0.Sexp.t)
      -> ('a__021_, 'b__022_, 'c__023_) t
      -> Sexplib0.Sexp.t
      =
      fun (type a__027_) ->
      fun (type b__028_) ->
      fun (type c__029_) ->
      (fun _of_a__024_ _of_b__025_ _of_c__026_ -> function
         | Arity1 -> Sexplib0.Sexp.Atom "Arity1"
         | Arity2 -> Sexplib0.Sexp.Atom "Arity2"
         | Arity3 -> Sexplib0.Sexp.Atom "Arity3"
         | Arity4 -> Sexplib0.Sexp.Atom "Arity4"
         | Arity5 -> Sexplib0.Sexp.Atom "Arity5"
       : (a__027_ -> Sexplib0.Sexp.t)
         -> (b__028_ -> Sexplib0.Sexp.t)
         -> (c__029_ -> Sexplib0.Sexp.t)
         -> (a__027_, b__028_, c__029_) t
         -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let fold_exn
      ?extract_exn
      (type c)
      (type f)
      (type s)
      (t : (c, _) t)
      subscribed_from
      (fold_arity : (c, f, s) Fold_arity.t)
      ~(init : s)
      ~(f : f)
  =
  let state = ref init in
  if not (can_subscribe t)
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
        ; pos_lnum = 841
        ; pos_cnum = 24810
        ; pos_bol = 24790
        }
      "Bus.fold_exn called after first write"
      t
      ((fun x__030_ ->
         sexp_of_t
           (fun _ -> Sexplib0.Sexp.Atom "_")
           (fun _ -> Sexplib0.Sexp.Atom "_")
           x__030_) [@merlin.hide]);
  iter_exn
    ?extract_exn
    t
    subscribed_from
    ~f:
      (match fold_arity with
       | Arity1 -> fun a1 -> state := f !state a1
       | Arity2 -> fun a1 a2 -> state := f !state a1 a2
       | Arity3 -> fun a1 a2 a3 -> state := f !state a1 a2 a3
       | Arity4 -> fun a1 a2 a3 a4 -> state := f !state a1 a2 a3 a4
       | Arity5 -> fun a1 a2 a3 a4 a5 -> state := f !state a1 a2 a3 a4 a5)
;;

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"bus.ml.before-ppx"
    ~line_number:855
    ~start_pos:0
    ~end_pos:1803
    (fun () ->
       let module M = struct
         let assert_no_allocation bus callback write =
           let bus_r = read_only bus in
           ignore
             (subscribe_exn
                bus_r
                { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                ; pos_lnum = 859
                ; pos_cnum = 25444
                ; pos_bol = 25410
                }
                ~f:callback
              : _ Subscriber.t);
           let starting_minor_words = Gc.minor_words () in
           let starting_major_words = Gc.major_words () in
           write ();
           let ending_minor_words = Gc.minor_words () in
           let ending_major_words = Gc.major_words () in
           (fun ?(here = []) ?message ?equal ~expect got ->
              let pos = "bus.ml.before-ppx:865:21" in
              let sexpifier = (sexp_of_int [@merlin.hide]) in
              let comparator =
                (fun (a__031_ : int) ((b__032_ : int) [@merlin.hide]) ->
                (compare_int a__031_ b__032_ [@merlin.hide]))
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
             (ending_minor_words - starting_minor_words)
             ~expect:0;
           (fun ?(here = []) ?message ?equal ~expect got ->
              let pos = "bus.ml.before-ppx:866:21" in
              let sexpifier = (sexp_of_int [@merlin.hide]) in
              let comparator =
                (fun (a__033_ : int) ((b__034_ : int) [@merlin.hide]) ->
                (compare_int a__033_ b__034_ [@merlin.hide]))
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
             (ending_major_words - starting_major_words)
             ~expect:0
         ;;

         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "write doesn't allocate when inlined")
             ~tags:[]
             ~filename:"bus.ml.before-ppx"
             ~line_number:872
             ~start_pos:4
             ~end_pos:945
             (fun () ->
                (let create created_from arity =
                   create_exn
                     created_from
                     arity
                     ~on_subscription_after_first_write:Raise
                     ~on_callback_raise:Error.raise
                 in
                 let bus1 =
                   create
                     { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                     ; pos_lnum = 880
                     ; pos_cnum = 26412
                     ; pos_bol = 26388
                     }
                     Arity1
                 in
                 let bus2 =
                   create
                     { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                     ; pos_lnum = 881
                     ; pos_cnum = 26454
                     ; pos_bol = 26430
                     }
                     Arity2
                 in
                 let bus3 =
                   create
                     { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                     ; pos_lnum = 882
                     ; pos_cnum = 26496
                     ; pos_bol = 26472
                     }
                     Arity3
                 in
                 let bus4 =
                   create
                     { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                     ; pos_lnum = 883
                     ; pos_cnum = 26538
                     ; pos_bol = 26514
                     }
                     Arity4
                 in
                 let bus5 =
                   create
                     { Ppx_here_lib.pos_fname = "bus.ml.before-ppx"
                     ; pos_lnum = 884
                     ; pos_cnum = 26580
                     ; pos_bol = 26556
                     }
                     Arity5
                 in
                 assert_no_allocation bus1 (fun () -> ()) (fun () -> write bus1 ());
                 assert_no_allocation bus2 (fun () () -> ()) (fun () -> write2 bus2 () ());
                 assert_no_allocation
                   bus3
                   (fun () () () -> ())
                   (fun () -> write3 bus3 () () ());
                 assert_no_allocation
                   bus4
                   (fun () () () () -> ())
                   (fun () -> write4 bus4 () () () ());
                 assert_no_allocation
                   bus5
                   (fun () () () () () -> ())
                   (fun () -> write5 bus5 () () () () ()));
                ())
         ;;
       end
       in
       ())
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
