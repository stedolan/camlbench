let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unpack_buffer.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unpack_buffer.ml.before-ppx"
;;

open! Import

let debug = ref false

module Unpack_one = struct
  type ('a, 'state) unpack_result =
    [ `Ok of 'a * int
    | `Not_enough_data of 'state * int
    | `Invalid_data of Error.t
    ]

  type ('a, 'state) unpack =
    state:'state -> buf:Bigstring.t -> pos:int -> len:int -> ('a, 'state) unpack_result

  type 'a t =
    | T :
        { initial_state : 'state
        ; unpack : ('a, 'state) unpack
        }
        -> 'a t

  let create ~initial_state ~unpack = T { initial_state; unpack }

  include Monad.Make (struct
      type nonrec 'a t = 'a t

      let return v =
        T
          { initial_state = ()
          ; unpack = (fun ~state:() ~buf:_ ~pos:_ ~len:_ -> `Ok (v, 0))
          }
      ;;

      let map' (t : 'a t) ~f =
        let (T { initial_state; unpack }) = t in
        T
          { initial_state
          ; unpack =
              (fun ~state ~buf ~pos ~len ->
                match unpack ~state ~buf ~pos ~len with
                | (`Invalid_data _ | `Not_enough_data _) as x -> x
                | `Ok (a, pos) -> `Ok (f a, pos))
          }
      ;;

      let map = `Custom map'

      let bind =
        let module State = struct
          type ('sa, 'b) t =
            | A : 'sa -> ('sa, _) t
            | B : 'sb * ('b, 'sb) unpack -> (_, 'b) t
        end
        in
        let open State in
        let do_b ~na sb (ub : (_, _) unpack) ~buf ~pos ~len =
          match ub ~state:sb ~buf ~pos ~len with
          | `Invalid_data _ as x -> x
          | `Not_enough_data (sb, nb) -> `Not_enough_data (B (sb, ub), nb + na)
          | `Ok (b, nb) -> `Ok (b, na + nb)
        in
        fun (T a) ~f ->
          let do_a sa ~buf ~pos ~len =
            match a.unpack ~state:sa ~buf ~pos ~len with
            | `Invalid_data _ as x -> x
            | `Not_enough_data (sa, n) -> `Not_enough_data (A sa, n)
            | `Ok (a, na) ->
              let (T b) = f a in
              do_b ~na b.initial_state b.unpack ~buf ~pos:(pos + na) ~len:(len - na)
          in
          T
            { initial_state = A a.initial_state
            ; unpack =
                (fun ~state ~buf ~pos ~len ->
                  match state with
                  | A sa -> do_a sa ~buf ~pos ~len
                  | B (sb, ub) -> do_b ~na:0 sb ub ~buf ~pos ~len)
            }
      ;;
    end)

  let create_bin_prot_internal bin_prot_reader ~reader_expects_size_header =
    let header_length = Bin_prot.Utils.size_header_length in
    let not_enough_data = `Not_enough_data ((), 0) in
    let pos_ref = ref 0 in
    let invalid_data message a sexp_of_a =
      `Invalid_data (Error.create message a sexp_of_a)
    in
    let read bin_reader buf ~pos ~len =
      pos_ref := pos;
      let result = bin_reader buf ~pos_ref in
      if !pos_ref <> pos + len
      then
        invalid_data
          "pos_ref <> pos + len"
          (!pos_ref, pos, len)
          ((fun (arg0__001_, arg1__002_, arg2__003_) ->
             let res0__004_ = sexp_of_int arg0__001_
             and res1__005_ = sexp_of_int arg1__002_
             and res2__006_ = sexp_of_int arg2__003_ in
             Sexplib0.Sexp.List [ res0__004_; res1__005_; res2__006_ ]) [@merlin.hide])
      else `Ok result
    in
    T
      { initial_state = ()
      ; unpack =
          (fun ~state:() ~buf ~pos ~len ->
            if header_length > len
            then not_enough_data
            else (
              match
                read Bin_prot.Utils.bin_read_size_header buf ~pos ~len:header_length
              with
              | `Invalid_data _ as x -> x
              | `Ok element_length ->
                if element_length < 0
                then
                  invalid_data
                    "negative element length %d"
                    element_length
                    (sexp_of_int [@merlin.hide])
                else if element_length > len - header_length
                then not_enough_data
                else (
                  let pos =
                    match reader_expects_size_header with
                    | true -> pos
                    | false -> pos + header_length
                  in
                  let len =
                    match reader_expects_size_header with
                    | true -> header_length + element_length
                    | false -> element_length
                  in
                  match read bin_prot_reader.Bin_prot.Type_class.read buf ~pos ~len with
                  | `Invalid_data _ as x -> x
                  | `Ok result -> `Ok (result, header_length + element_length))))
      }
  ;;

  let create_bin_prot bin_prot_reader =
    create_bin_prot_internal bin_prot_reader ~reader_expects_size_header:false
  ;;

  let bin_blob =
    create_bin_prot_internal
      Bin_prot.Blob.Opaque.Bigstring.bin_reader_t
      ~reader_expects_size_header:true
  ;;

  let sexp =
    let module Parse_pos = Sexp.Parse_pos in
    let initial_state ~pos ~len buf =
      Sexp.parse_bigstring buf ~len ~parse_pos:(Parse_pos.create ~buf_pos:pos ())
    in
    T
      { initial_state
      ; unpack =
          (fun ~state ~buf ~pos ~len ->
            try
              match state ~pos ~len buf with
              | Cont (_state, k) -> `Not_enough_data (k, len)
              | Done (sexp, parse_pos) -> `Ok (sexp, parse_pos.Parse_pos.buf_pos - pos)
            with
            | exn -> `Invalid_data (Error.of_exn exn))
      }
  ;;

  let char =
    T
      { initial_state = ()
      ; unpack =
          (fun ~state:() ~buf ~pos ~len ->
            if len < 1 then `Not_enough_data ((), 0) else `Ok (Bigstring.get buf pos, 1))
      }
  ;;

  module type Equal = sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val equal : t -> t -> bool
  end

  let expect (type a) (T u) ((module E) : (module Equal with type t = a)) expected =
    T
      { initial_state = u.initial_state
      ; unpack =
          (fun ~state ~buf ~pos ~len ->
            match u.unpack ~state ~buf ~pos ~len with
            | (`Invalid_data _ | `Not_enough_data _) as x -> x
            | `Ok (parsed, n) ->
              if E.equal expected parsed
              then `Ok ((), n)
              else
                `Invalid_data
                  (Error.create "parsed does not match expected" () (fun () ->
                     Ppx_sexp_conv_lib.Sexp.List
                       [ Ppx_sexp_conv_lib.Sexp.List
                           [ Ppx_sexp_conv_lib.Sexp.Atom "parsed"
                           ; (E.sexp_of_t [@merlin.hide]) parsed
                           ]
                       ; Ppx_sexp_conv_lib.Sexp.List
                           [ Ppx_sexp_conv_lib.Sexp.Atom "expected"
                           ; (E.sexp_of_t [@merlin.hide]) expected
                           ]
                       ])))
      }
  ;;

  let expect_char = expect char (module Char)
  let newline = expect_char '\n'
end

type ('a, 'state) alive =
  { mutable state : 'state
  ; mutable state_is_initial : bool
  ; initial_state : 'state
  ; unpack : (('a, 'state) Unpack_one.unpack[@sexp.opaque])
  ; mutable buf : Bigstring.t
  ; mutable pos : int
  ; mutable len : int
  }
[@@deriving sexp_of]

include struct
  let _ = fun (_ : ('a, 'state) alive) -> ()

  let sexp_of_alive
    :  'a 'state.
       ('a -> Sexplib0.Sexp.t)
    -> ('state -> Sexplib0.Sexp.t)
    -> ('a, 'state) alive
    -> Sexplib0.Sexp.t
    =
    fun _of_a__007_
      _of_state__008_
      { state = state__010_
      ; state_is_initial = state_is_initial__012_
      ; initial_state = initial_state__014_
      ; unpack = unpack__016_
      ; buf = buf__018_
      ; pos = pos__020_
      ; len = len__022_
      } ->
    let bnds__009_ = ([] : _ Stdlib.List.t) in
    let bnds__009_ =
      let arg__023_ = sexp_of_int len__022_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "len"; arg__023_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__021_ = sexp_of_int pos__020_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos"; arg__021_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__019_ = Bigstring.sexp_of_t buf__018_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buf"; arg__019_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__017_ = Sexplib0.Sexp_conv.sexp_of_opaque unpack__016_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unpack"; arg__017_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__015_ = _of_state__008_ initial_state__014_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "initial_state"; arg__015_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__013_ = sexp_of_bool state_is_initial__012_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "state_is_initial"; arg__013_ ]
       :: bnds__009_
       : _ Stdlib.List.t)
    in
    let bnds__009_ =
      let arg__011_ = _of_state__008_ state__010_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "state"; arg__011_ ] :: bnds__009_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__009_
  ;;

  let _ = sexp_of_alive
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type 'a alive_or_dead =
  | Alive : ('a, _) alive -> 'a alive_or_dead
  | Dead of Error.t
[@@deriving sexp_of]

include struct
  let _ = fun (_ : 'a alive_or_dead) -> ()

  let sexp_of_alive_or_dead
    : 'a. ('a -> Sexplib0.Sexp.t) -> 'a alive_or_dead -> Sexplib0.Sexp.t
    =
    fun (type a__029_) ->
    (fun _of_a__024_ -> function
       | Alive arg0__025_ ->
         let res0__026_ =
           sexp_of_alive _of_a__024_ (fun _ -> Sexplib0.Sexp.Atom "_") arg0__025_
         in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Alive"; res0__026_ ]
       | Dead arg0__027_ ->
         let res0__028_ = Error.sexp_of_t arg0__027_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Dead"; res0__028_ ]
     : (a__029_ -> Sexplib0.Sexp.t) -> a__029_ alive_or_dead -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_alive_or_dead
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type 'a t = { mutable alive_or_dead : 'a alive_or_dead } [@@deriving sexp_of]

include struct
  let _ = fun (_ : 'a t) -> ()

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__030_ { alive_or_dead = alive_or_dead__032_ } ->
    let bnds__031_ = ([] : _ Stdlib.List.t) in
    let bnds__031_ =
      let arg__033_ = sexp_of_alive_or_dead _of_a__030_ alive_or_dead__032_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "alive_or_dead"; arg__033_ ] :: bnds__031_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__031_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let invariant _ t =
  try
    match t.alive_or_dead with
    | Dead _ -> ()
    | Alive alive ->
      assert (alive.pos >= 0);
      assert (alive.len >= 0);
      if alive.len = 0 then assert (alive.pos = 0);
      if alive.state_is_initial then assert (phys_equal alive.state alive.initial_state);
      assert (alive.pos + alive.len <= Bigstring.length alive.buf)
  with
  | exn ->
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "unpack_buffer.ml.before-ppx"
        ; pos_lnum = 231
        ; pos_cnum = 7235
        ; pos_bol = 7208
        }
      "invariant failed"
      (exn, t)
      ((fun (arg0__034_, arg1__035_) ->
         let res0__036_ = sexp_of_exn arg0__034_
         and res1__037_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__035_ in
         Sexplib0.Sexp.List [ res0__036_; res1__037_ ]) [@merlin.hide])
;;

let create (Unpack_one.T { initial_state; unpack }) =
  { alive_or_dead =
      Alive
        { state = initial_state
        ; state_is_initial = true
        ; initial_state
        ; unpack
        ; buf = Bigstring.create 1
        ; pos = 0
        ; len = 0
        }
  }
;;

let create_bin_prot bin_prot_reader = create (Unpack_one.create_bin_prot bin_prot_reader)

let is_empty t =
  match t.alive_or_dead with
  | Dead error -> Error error
  | Alive alive -> Ok (alive.state_is_initial && alive.len = 0)
;;

let is_available t len =
  let input_start = t.pos + t.len in
  let available = Bigstring.length t.buf - input_start in
  available >= len
;;

let ensure_available t len =
  if not (is_available t len)
  then (
    let new_buf = Bigstring.create (max (t.len + len) (2 * Bigstring.length t.buf)) in
    Bigstring.blito ~src:t.buf ~src_pos:t.pos ~src_len:t.len ~dst:new_buf ();
    t.pos <- 0;
    t.buf <- new_buf;
    assert (is_available t len))
;;

let feed_gen buf_length (blit_buf_to_bigstring : (_, _) Blit.blito) ?pos ?len t buf =
  if !debug then invariant ignore t;
  match t.alive_or_dead with
  | Dead e -> Error e
  | Alive t ->
    let src_pos, src_len =
      Ordered_collection_common.get_pos_len_exn
        ()
        ?pos
        ?len
        ~total_length:(buf_length buf)
    in
    ensure_available t src_len;
    blit_buf_to_bigstring
      ~src:buf
      ~src_pos
      ~src_len
      ~dst:t.buf
      ~dst_pos:(t.pos + t.len)
      ();
    t.len <- t.len + src_len;
    Ok ()
;;

let feed ?pos ?len t buf = feed_gen Bigstring.length Bigstring.blito ?pos ?len t buf

let feed_string ?pos ?len t buf =
  feed_gen String.length Bigstring.From_string.blito ?pos ?len t buf
;;

let feed_bytes ?pos ?len t buf =
  feed_gen Bytes.length Bigstring.From_bytes.blito ?pos ?len t buf
;;

let error t e =
  t.alive_or_dead <- Dead e;
  Error e
;;

let consume alive ~num_bytes =
  alive.pos <- alive.pos + num_bytes;
  alive.len <- alive.len - num_bytes
;;

let rec unpack_iter_loop t alive ~f =
  if alive.len = 0
  then (
    alive.pos <- 0;
    Ok ())
  else (
    match
      alive.unpack ~buf:alive.buf ~pos:alive.pos ~len:alive.len ~state:alive.state
    with
    | exception exn ->
      error t (Error.create "unpack error" exn (Exn.sexp_of_t [@merlin.hide]))
    | unpack_result ->
      (match unpack_result with
       | `Invalid_data e -> error t (Error.tag e ~tag:"invalid data")
       | `Ok (one, num_bytes) ->
         if num_bytes < 0 || num_bytes > alive.len
         then
           error
             t
             (Error.create
                "unpack consumed invalid amount"
                num_bytes
                (sexp_of_int [@merlin.hide]))
         else if num_bytes = 0 && alive.state_is_initial
         then
           error
             t
             (Error.of_string
                "unpack returned a value but consumed 0 bytes without partially unpacked \
                 data")
         else (
           consume alive ~num_bytes;
           alive.state <- alive.initial_state;
           alive.state_is_initial <- true;
           match f one with
           | exception exn ->
             error
               t
               (Error.create
                  "~f supplied to Unpack_buffer.unpack_iter raised"
                  exn
                  (sexp_of_exn [@merlin.hide]))
           | _ -> unpack_iter_loop t alive ~f)
       | `Not_enough_data (state, num_bytes) ->
         if num_bytes < 0 || num_bytes > alive.len
         then
           error
             t
             (Error.create
                "partial unpack consumed invalid amount"
                num_bytes
                (sexp_of_int [@merlin.hide]))
         else (
           consume alive ~num_bytes;
           alive.state <- state;
           alive.state_is_initial <- false;
           if alive.len > 0
           then
             Bigstring.blito
               ~src:alive.buf
               ~src_pos:alive.pos
               ~src_len:alive.len
               ~dst:alive.buf
               ();
           alive.pos <- 0;
           Ok ())))
;;

let unpack_iter t ~f =
  if !debug then invariant ignore t;
  match t.alive_or_dead with
  | Dead e -> Error e
  | Alive alive -> unpack_iter_loop t alive ~f
;;

let unpack_into t q = unpack_iter t ~f:(Queue.enqueue q)
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
