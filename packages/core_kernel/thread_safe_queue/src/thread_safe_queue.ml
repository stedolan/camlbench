let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"thread_safe_queue.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "thread_safe_queue.ml.before-ppx"
;;

open! Core
open! Import

module Elt = struct
  type 'a t =
    { mutable value : 'a Uopt.t
    ; mutable next : ('a t Uopt.t[@sexp.opaque])
    }
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__001_ { value = value__003_; next = next__005_ } ->
      let bnds__002_ = ([] : _ Stdlib.List.t) in
      let bnds__002_ =
        let arg__006_ = Sexplib0.Sexp_conv.sexp_of_opaque next__005_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next"; arg__006_ ] :: bnds__002_
         : _ Stdlib.List.t)
      in
      let bnds__002_ =
        let arg__004_ = Uopt.sexp_of_t _of_a__001_ value__003_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "value"; arg__004_ ] :: bnds__002_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__002_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create () = { value = Uopt.none; next = Uopt.none }
end

type 'a t =
  { mutable length : int
  ; mutable front : 'a Elt.t
  ; mutable back : 'a Elt.t
  ; mutable unused_elts : 'a Elt.t Uopt.t
  }
[@@deriving fields ~getters ~iterators:iter, sexp_of]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()
  let unused_elts _r__ = _r__.unused_elts
  let _ = unused_elts
  let set_unused_elts _r__ v__ = _r__.unused_elts <- v__
  let _ = set_unused_elts
  let back _r__ = _r__.back
  let _ = back
  let set_back _r__ v__ = _r__.back <- v__
  let _ = set_back
  let front _r__ = _r__.front
  let _ = front
  let set_front _r__ v__ = _r__.front <- v__
  let _ = set_front
  let length _r__ = _r__.length
  let _ = length
  let set_length _r__ v__ = _r__.length <- v__
  let _ = set_length

  module Fields = struct
    let unused_elts =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "unused_elts"
         ; getter = unused_elts
         ; setter = Some set_unused_elts
         ; fset = (fun _r__ v__ -> { _r__ with unused_elts = v__ })
         }
       : ([< `Read | `Set_and_create ], _, 'a Elt.t Uopt.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = unused_elts

    let back =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "back"
         ; getter = back
         ; setter = Some set_back
         ; fset = (fun _r__ v__ -> { _r__ with back = v__ })
         }
       : ([< `Read | `Set_and_create ], _, 'a Elt.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = back

    let front =
      (Fieldslib.Field.Field
         { Fieldslib.Field.For_generated_code.force_variance =
             (fun (_ : [< `Read | `Set_and_create ]) -> ())
         ; name = "front"
         ; getter = front
         ; setter = Some set_front
         ; fset = (fun _r__ v__ -> { _r__ with front = v__ })
         }
       : ([< `Read | `Set_and_create ], _, 'a Elt.t) Fieldslib.Field.t_with_perm)
    ;;

    let _ = front

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
          ~front:front_fun__
          ~back:back_fun__
          ~unused_elts:unused_elts_fun__
      =
      (length_fun__ length : unit);
      (front_fun__ front : unit);
      (back_fun__ back : unit);
      (unused_elts_fun__ unused_elts : unit)
    ;;

    let _ = iter
  end

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun _of_a__007_
      { length = length__009_
      ; front = front__011_
      ; back = back__013_
      ; unused_elts = unused_elts__015_
      } ->
    let bnds__008_ = ([] : _ Stdlib.List.t) in
    let bnds__008_ =
      let arg__016_ = Uopt.sexp_of_t (Elt.sexp_of_t _of_a__007_) unused_elts__015_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unused_elts"; arg__016_ ] :: bnds__008_
       : _ Stdlib.List.t)
    in
    let bnds__008_ =
      let arg__014_ = Elt.sexp_of_t _of_a__007_ back__013_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "back"; arg__014_ ] :: bnds__008_
       : _ Stdlib.List.t)
    in
    let bnds__008_ =
      let arg__012_ = Elt.sexp_of_t _of_a__007_ front__011_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "front"; arg__012_ ] :: bnds__008_
       : _ Stdlib.List.t)
    in
    let bnds__008_ =
      let arg__010_ = sexp_of_int length__009_ in
      (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__010_ ] :: bnds__008_
       : _ Stdlib.List.t)
    in
    Sexplib0.Sexp.List bnds__008_
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let invariant _invariant_a t =
  Invariant.invariant
    { Ppx_here_lib.pos_fname = "thread_safe_queue.ml.before-ppx"
    ; pos_lnum = 40
    ; pos_cnum = 1588
    ; pos_bol = 1566
    }
    t
    ((fun x__017_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__017_) [@merlin.hide])
    (fun () ->
       let check f = Invariant.check_field t f in
       Fields.iter
         ~length:(check (fun length -> assert (length >= 0)))
         ~front:
           (check (fun front ->
              let i = ref t.length in
              let r = ref front in
              while !i > 0 do
                decr i;
                let elt = !r in
                r := Uopt.value_exn elt.Elt.next;
                assert (Uopt.is_some elt.value)
              done;
              assert (phys_equal !r t.back)))
         ~back:(check (fun back -> assert (Uopt.is_none back.Elt.value)))
         ~unused_elts:
           (check (fun unused_elts ->
              let r = ref unused_elts in
              while Uopt.is_some !r do
                let elt = Uopt.value_exn !r in
                r := elt.Elt.next;
                assert (Uopt.is_none elt.value)
              done)))
;;

let create () =
  let elt = Elt.create () in
  { front = elt; back = elt; length = 0; unused_elts = Uopt.none }
;;

let get_unused_elt t =
  if Uopt.is_some t.unused_elts
  then (
    let elt = Uopt.unsafe_value t.unused_elts in
    t.unused_elts <- elt.next;
    elt)
  else Elt.create ()
[@@inline never] [@@specialise never] [@@local never]
;;

let enqueue (type a) (t : a t) (a : a) =
  let new_back = get_unused_elt t in
  t.length <- t.length + 1;
  t.back.value <- Uopt.some a;
  t.back.next <- Uopt.some new_back;
  t.back <- new_back
[@@inline never] [@@specialise never] [@@local never]
;;

let return_unused_elt t (elt : _ Elt.t) =
  elt.value <- Uopt.none;
  elt.next <- t.unused_elts;
  t.unused_elts <- Uopt.some elt;
  ()
[@@inline never] [@@specialise never] [@@local never]
;;

let raise_dequeue_empty t =
  failwiths
    ~here:
      { Ppx_here_lib.pos_fname = "thread_safe_queue.ml.before-ppx"
      ; pos_lnum = 108
      ; pos_cnum = 3944
      ; pos_bol = 3926
      }
    "Thread_safe_queue.dequeue_exn of empty queue"
    t
    ((fun x__018_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__018_) [@merlin.hide])
[@@inline never] [@@specialise never] [@@local never]
;;

let dequeue_exn t =
  if t.length = 0 then raise_dequeue_empty t;
  let elt = t.front in
  let a = elt.value in
  t.front <- Uopt.unsafe_value elt.next;
  t.length <- t.length - 1;
  return_unused_elt t elt;
  Uopt.unsafe_value a
[@@inline never] [@@specialise never] [@@local never]
;;

let clear_internal_pool t = t.unused_elts <- Uopt.none

module Private = struct
  module Uopt = Uopt
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
