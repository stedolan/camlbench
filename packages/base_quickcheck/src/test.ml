open! Base
include Test_intf

module Config = struct
  module Seed = struct
    type t =
      | Nondeterministic
      | Deterministic of string
    [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()

      let sexp_of_t =
        (function
         | Nondeterministic -> Sexplib0.Sexp.Atom "Nondeterministic"
         | Deterministic arg0__001_ ->
           let res0__002_ = sexp_of_string arg0__001_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Deterministic"; res0__002_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Potentially_infinite_sequence = struct
    type 'a t = 'a Sequence.t

    let sexp_of_t sexp_of_elt sequence =
      let prefix, suffix = Sequence.split_n sequence 100 in
      let prefix = List.map prefix ~f:sexp_of_elt in
      let suffix =
        match Sequence.is_empty suffix with
        | true -> []
        | false ->
          [ (let ppx_sexp_message () =
               Ppx_sexp_conv_lib.Conv.sexp_of_string "..."
                 [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
             in
             (ppx_sexp_message () [@nontail]))
          ]
      in
      Sexp.List (prefix @ suffix)
    ;;
  end

  type t =
    { seed : Seed.t
    ; test_count : int
    ; shrink_count : int
    ; sizes : int Potentially_infinite_sequence.t
    }
  [@@deriving fields ~getters, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sizes _r__ = _r__.sizes
    let _ = sizes
    let shrink_count _r__ = _r__.shrink_count
    let _ = shrink_count
    let test_count _r__ = _r__.test_count
    let _ = test_count
    let seed _r__ = _r__.seed
    let _ = seed

    let sexp_of_t =
      (fun { seed = seed__004_
           ; test_count = test_count__006_
           ; shrink_count = shrink_count__008_
           ; sizes = sizes__010_
           } ->
         let bnds__003_ = ([] : _ Stdlib.List.t) in
         let bnds__003_ =
           let arg__011_ =
             Potentially_infinite_sequence.sexp_of_t sexp_of_int sizes__010_
           in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sizes"; arg__011_ ] :: bnds__003_
            : _ Stdlib.List.t)
         in
         let bnds__003_ =
           let arg__009_ = sexp_of_int shrink_count__008_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "shrink_count"; arg__009_ ]
            :: bnds__003_
            : _ Stdlib.List.t)
         in
         let bnds__003_ =
           let arg__007_ = sexp_of_int test_count__006_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "test_count"; arg__007_ ]
            :: bnds__003_
            : _ Stdlib.List.t)
         in
         let bnds__003_ =
           let arg__005_ = Seed.sexp_of_t seed__004_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "seed"; arg__005_ ] :: bnds__003_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__003_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let default_config : Config.t =
  { seed = Deterministic "an arbitrary but deterministic string"
  ; test_count =
      (match Word_size.word_size with
       | W64 -> 10_000
       | W32 -> 1_000)
  ; shrink_count = 10_000
  ; sizes = Sequence.cycle_list_exn (List.range 0 ~start:`inclusive 30 ~stop:`inclusive)
  }
;;

let lazy_nondeterministic_state = lazy (Random.State.make_self_init ())

let initial_random_state ~config =
  match Config.seed config with
  | Nondeterministic -> Splittable_random.create (force lazy_nondeterministic_state)
  | Deterministic string -> Splittable_random.of_int (String.hash string)
;;

let one_size_per_test ~(config : Config.t) =
  Sequence.unfold ~init:(config.sizes, 0) ~f:(fun (sizes, number_of_size_values) ->
    match number_of_size_values >= config.test_count with
    | true -> None
    | false ->
      (match Sequence.next sizes with
       | Some (size, remaining_sizes) ->
         Some (size, (remaining_sizes, number_of_size_values + 1))
       | None ->
         raise_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Base_quickcheck.Test.run: insufficient size values for test count"
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "test_count"
                    ; (sexp_of_int [@merlin.hide]) config.test_count
                    ]
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "number_of_size_values"
                    ; (sexp_of_int [@merlin.hide]) number_of_size_values
                    ]
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail]))))
;;

let shrink_error ~shrinker ~config ~f input error =
  let rec loop ~shrink_count ~alternates input error =
    match shrink_count with
    | 0 -> input, error
    | _ ->
      let shrink_count = shrink_count - 1 in
      (match Sequence.next alternates with
       | None -> input, error
       | Some (alternate, alternates) ->
         (match f alternate with
          | Ok () -> loop ~shrink_count ~alternates input error
          | Error error ->
            let alternates = Shrinker.shrink shrinker alternate in
            loop ~shrink_count ~alternates alternate error))
  in
  let shrink_count = Config.shrink_count config in
  let alternates = Shrinker.shrink shrinker input in
  loop ~shrink_count ~alternates input error
;;

let input_sequence ~config ~examples ~generator =
  let random = initial_random_state ~config in
  Sequence.append
    (Sequence.of_list examples)
    (Sequence.map
       ~f:(fun size -> Generator.generate generator ~size ~random)
       (one_size_per_test ~config))
;;

let with_sample ~f ?(config = default_config) ?(examples = []) generator =
  let sequence = input_sequence ~config ~examples ~generator in
  f sequence
;;

let result (type a) ~f ?(config = default_config) ?(examples = []) m =
  let ((module M) : (module S with type t = a)) = m in
  with_sample M.quickcheck_generator ~config ~examples ~f:(fun sequence ->
    match
      Sequence.fold_result sequence ~init:() ~f:(fun () input ->
        match f input with
        | Ok () -> Ok ()
        | Error error -> Error (input, error))
    with
    | Ok () -> Ok ()
    | Error (input, error) ->
      let shrinker = M.quickcheck_shrinker in
      let input, error = shrink_error ~shrinker ~config ~f input error in
      Error (input, error))
;;

let run (type a) ~f ?config ?examples ((module M) : (module S with type t = a)) =
  let f x =
    Or_error.try_with_join ~backtrace:(Backtrace.Exn.am_recording ()) (fun () -> f x)
  in
  match result ~f ?config ?examples (module M) with
  | Ok () -> Ok ()
  | Error (input, error) ->
    Or_error.error_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Base_quickcheck.Test.run: test failed"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "input"; (M.sexp_of_t [@merlin.hide]) input ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "error"
               ; (Error.sexp_of_t [@merlin.hide]) error
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let with_sample_exn ~f ?config ?examples generator =
  let f x = Or_error.try_with (fun () -> f x) in
  Or_error.ok_exn (with_sample ~f ?config ?examples generator)
;;

let run_exn ~f ?config ?examples testable =
  let f x =
    Or_error.try_with ~backtrace:(Backtrace.Exn.am_recording ()) (fun () -> f x)
  in
  Or_error.ok_exn (run ~f ?config ?examples testable)
;;
