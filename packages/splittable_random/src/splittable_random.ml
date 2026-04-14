[@@@ocaml.text
  " This module implements \"Fast Splittable Pseudorandom Number Generators\" by Steele \
   et.\n\
  \    al. (1).  The paper's algorithm provides decent randomness for most purposes, but\n\
  \    sacrifices cryptographic-quality randomness in favor of performance.  The original\n\
  \    implementation was tested with DieHarder and BigCrush; see the paper for details.\n\n\
  \    Our implementation is a port from Java to OCaml of the paper's algorithm.  Other \
   than\n\
  \    the choice of initial seed for [create], our port should be faithful.  We have not\n\
  \    re-run the DieHarder or BigCrush tests on our implementation.  Our port is also \
   not as\n\
  \    performant as the original; two factors that hurt us are boxed [int64] values and \
   lack\n\
  \    of a POPCNT primitive.\n\n\
  \    (1) \
   http://2014.splashcon.org/event/oopsla2014-fast-splittable-pseudorandom-number-generators\n\
  \    (also mirrored at http://gee.cs.oswego.edu/dl/papers/oopsla14.pdf)\n\n\
  \    Beware when implementing this interface; it is easy to implement a [split] \
   operation\n\
  \    whose output is not as \"independent\" as it seems (2).  This bug caused problems \
   for\n\
  \    Haskell's Quickcheck library for a long time.\n\n\
  \    (2) Schaathun, \"Evaluation of splittable pseudo-random generators\", JFP 2015.\n\
  \    http://www.hg.schaathun.net/research/Papers/hgs2015jfp.pdf\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"splittable_random.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "splittable_random.ml.before-ppx"
;;

open! Base
open Int64.O

let is_odd x = x lor 1L = x
let popcount = Int64.popcount

type t =
  { mutable seed : int64
  ; odd_gamma : int64
  }

type state = t

let golden_gamma = 0x9e37_79b9_7f4a_7c15L
let of_int seed = { seed = Int64.of_int seed; odd_gamma = golden_gamma }
let copy { seed; odd_gamma } = { seed; odd_gamma }
let mix_bits z n = z lxor (z lsr n)

let mix64 z =
  let z = mix_bits z 33 * 0xff51_afd7_ed55_8ccdL in
  let z = mix_bits z 33 * 0xc4ce_b9fe_1a85_ec53L in
  mix_bits z 33
;;

let mix64_variant13 z =
  let z = mix_bits z 30 * 0xbf58_476d_1ce4_e5b9L in
  let z = mix_bits z 27 * 0x94d0_49bb_1331_11ebL in
  mix_bits z 31
;;

let mix_odd_gamma z =
  let z = mix64_variant13 z lor 1L in
  let n = popcount (z lxor (z lsr 1)) in
  if Int.( < ) n 24 then z lxor 0xaaaa_aaaa_aaaa_aaaaL else z
;;

let () =
  Ppx_inline_test_lib.test_unit
    ~config:(module Inline_test_config)
    ~descr:(lazy "odd gamma")
    ~tags:[]
    ~filename:"splittable_random.ml.before-ppx"
    ~line_number:66
    ~start_pos:0
    ~end_pos:247
    (fun () ->
       for input = -1_000_000 to 1_000_000 do
         let output = mix_odd_gamma (Int64.of_int input) in
         if not (is_odd output)
         then
           Error.raise_s
             (let ppx_sexp_message () =
                Ppx_sexp_conv_lib.Sexp.List
                  [ Ppx_sexp_conv_lib.Conv.sexp_of_string "gamma value is not odd"
                  ; Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Sexp.Atom "input"
                      ; (sexp_of_int [@merlin.hide]) input
                      ]
                  ; Ppx_sexp_conv_lib.Sexp.List
                      [ Ppx_sexp_conv_lib.Sexp.Atom "output"
                      ; (sexp_of_int64 [@merlin.hide]) output
                      ]
                  ]
                  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
              in
              (ppx_sexp_message () [@nontail]))
       done;
       ())
;;

let next_seed t =
  let next = t.seed + t.odd_gamma in
  t.seed <- next;
  next
;;

let of_seed_and_gamma ~seed ~gamma =
  let seed = mix64 seed in
  let odd_gamma = mix_odd_gamma gamma in
  { seed; odd_gamma }
;;

let random_int64 random_state =
  Random.State.int64_incl random_state Int64.min_value Int64.max_value
;;

let create random_state =
  let seed = random_int64 random_state in
  let gamma = random_int64 random_state in
  of_seed_and_gamma ~seed ~gamma
;;

let split t =
  let seed = next_seed t in
  let gamma = next_seed t in
  of_seed_and_gamma ~seed ~gamma
;;

let next_int64 t = mix64 (next_seed t)

let perturb t salt =
  let next = t.seed + mix64 (Int64.of_int salt) in
  t.seed <- next
;;

let bool state = is_odd (next_int64 state)

let remainder_is_unbiased ~draw ~remainder ~draw_maximum ~remainder_maximum =
  let open Int64.O in
  draw - remainder <= draw_maximum - remainder_maximum
;;

let () =
  Ppx_inline_test_lib.test_unit
    ~config:(module Inline_test_config)
    ~descr:(lazy "remainder_is_unbiased")
    ~tags:[]
    ~filename:"splittable_random.ml.before-ppx"
    ~line_number:121
    ~start_pos:0
    ~end_pos:633
    (fun () ->
       (let draw_maximum = 104L in
        let remainder_maximum = 9L in
        let is_unbiased draw =
          let remainder = Int64.rem draw (Int64.succ remainder_maximum) in
          remainder_is_unbiased ~draw ~remainder ~draw_maximum ~remainder_maximum
        in
        for i = 0 to 99 do
          (fun ?(here = []) ?message ?equal ~expect got ->
             let pos = "splittable_random.ml.before-ppx:130:19" in
             let sexpifier = (sexp_of_bool [@merlin.hide]) in
             let comparator =
               (fun (a__001_ : bool) ((b__002_ : bool) [@merlin.hide]) ->
               (compare_bool a__001_ b__002_ [@merlin.hide]))
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
            (is_unbiased (Int64.of_int i))
            ~expect:true
            ~message:(Int.to_string i)
        done;
        for i = 100 to 104 do
          (fun ?(here = []) ?message ?equal ~expect got ->
             let pos = "splittable_random.ml.before-ppx:136:19" in
             let sexpifier = (sexp_of_bool [@merlin.hide]) in
             let comparator =
               (fun (a__003_ : bool) ((b__004_ : bool) [@merlin.hide]) ->
               (compare_bool a__003_ b__004_ [@merlin.hide]))
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
            (is_unbiased (Int64.of_int i))
            ~expect:false
            ~message:(Int.to_string i)
        done);
       ())
;;

let int64 =
  let open Int64.O in
  let rec between state ~lo ~hi =
    let draw = next_int64 state in
    if lo <= draw && draw <= hi then draw else between state ~lo ~hi
  in
  let rec non_negative_up_to state maximum =
    let draw = next_int64 state land Int64.max_value in
    let remainder = Int64.rem draw (Int64.succ maximum) in
    if
      remainder_is_unbiased
        ~draw
        ~remainder
        ~draw_maximum:Int64.max_value
        ~remainder_maximum:maximum
    then remainder
    else non_negative_up_to state maximum
  in
  fun state ~lo ~hi ->
    if lo > hi
    then
      Error.raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "int64: crossed bounds"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lo"; (sexp_of_int64 [@merlin.hide]) lo ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hi"; (sexp_of_int64 [@merlin.hide]) hi ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    let diff = hi - lo in
    if diff = Int64.max_value
    then (next_int64 state land Int64.max_value) + lo
    else if diff >= 0L
    then non_negative_up_to state diff + lo
    else between state ~lo ~hi
;;

let int state ~lo ~hi =
  let lo = Int64.of_int lo in
  let hi = Int64.of_int hi in
  Int64.to_int_trunc (int64 state ~lo ~hi)
;;

let int32 state ~lo ~hi =
  let lo = Int64.of_int32 lo in
  let hi = Int64.of_int32 hi in
  Int64.to_int32_trunc (int64 state ~lo ~hi)
;;

let nativeint state ~lo ~hi =
  let lo = Int64.of_nativeint lo in
  let hi = Int64.of_nativeint hi in
  Int64.to_nativeint_trunc (int64 state ~lo ~hi)
;;

let int63 state ~lo ~hi =
  let lo = Int63.to_int64 lo in
  let hi = Int63.to_int64 hi in
  Int63.of_int64_trunc (int64 state ~lo ~hi)
;;

let double_ulp = 2. **. -53.

let () =
  Ppx_inline_test_lib.test_unit
    ~config:(module Inline_test_config)
    ~descr:(lazy "double_ulp")
    ~tags:[]
    ~filename:"splittable_random.ml.before-ppx"
    ~line_number:204
    ~start_pos:0
    ~end_pos:438
    (fun () ->
       (let open Float.O in
        match Word_size.word_size with
        | W64 ->
          assert (1.0 -. double_ulp < 1.0);
          assert (1.0 -. (double_ulp /. 2.0) = 1.0)
        | W32 ->
          assert (1.0 -. double_ulp < 1.0);
          assert (1.0 -. (double_ulp /. 2.0) <= 1.0));
       ())
;;

let unit_float_from_int64 int64 = Int64.to_float (int64 lsr 11) *. double_ulp

let () =
  Ppx_inline_test_lib.test_unit
    ~config:(module Inline_test_config)
    ~descr:(lazy "unit_float_from_int64")
    ~tags:[]
    ~filename:"splittable_random.ml.before-ppx"
    ~line_number:219
    ~start_pos:0
    ~end_pos:262
    (fun () ->
       (let open Float.O in
        assert (unit_float_from_int64 0x0000_0000_0000_0000L = 0.);
        assert (unit_float_from_int64 0xffff_ffff_ffff_ffffL < 1.0);
        assert (unit_float_from_int64 0xffff_ffff_ffff_ffffL = 1.0 -. double_ulp));
       ())
;;

let unit_float state = unit_float_from_int64 (next_int64 state)

let float =
  let rec finite_float state ~lo ~hi =
    let range = hi -. lo in
    if Float.is_finite range
    then lo +. (unit_float state *. range)
    else (
      let mid = (hi +. lo) /. 2. in
      if bool state
      then finite_float state ~lo ~hi:mid
      else finite_float state ~lo:mid ~hi)
  in
  fun state ~lo ~hi ->
    if not (Float.is_finite lo && Float.is_finite hi)
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "float: bounds are not finite numbers"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lo"; (sexp_of_float [@merlin.hide]) lo ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hi"; (sexp_of_float [@merlin.hide]) hi ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    if Float.( > ) lo hi
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "float: bounds are crossed"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lo"; (sexp_of_float [@merlin.hide]) lo ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hi"; (sexp_of_float [@merlin.hide]) hi ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    finite_float state ~lo ~hi
;;

let () =
  if Ppx_bench_lib.Benchmark_accumulator.add_environment_var
  then
    Ppx_bench_lib.Benchmark_accumulator.add_bench
      ~name:"unit_float_from_int64"
      ~code:"let int64 = 1L in fun () -> unit_float_from_int64 int64"
      ~type_conv_path:"splittable_random.ml.before-ppx"
      ~filename:"splittable_random.ml.before-ppx"
      ~line:263
      ~startpos:0
      ~endpos:99
      (let f `init =
         let int64 = 1L in
         fun () -> unit_float_from_int64 int64
       in
       if false then Ppx_bench_lib.Export.ignore (f `init ()) else ();
       Ppx_bench_lib.Benchmark_accumulator.Entry.Regular_thunk f)
;;

module Log_uniform = struct
  module Make (M : sig
      include Int.S

      val uniform : state -> lo:t -> hi:t -> t
    end) : sig
    val log_uniform : state -> lo:M.t -> hi:M.t -> M.t
  end = struct
    open M

    let bits_to_represent t =
      assert (t >= zero);
      let t = ref t in
      let n = ref 0 in
      while !t > zero do
        t := shift_right !t 1;
        Int.incr n
      done;
      !n
    ;;

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "bits_to_represent")
        ~tags:[]
        ~filename:"splittable_random.ml.before-ppx"
        ~line_number:289
        ~start_pos:4
        ~end_pos:475
        (fun () ->
           (let test n expect =
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "splittable_random.ml.before-ppx:290:41" in
                 let sexpifier = (sexp_of_int [@merlin.hide]) in
                 let comparator =
                   (fun (a__005_ : int) ((b__006_ : int) [@merlin.hide]) ->
                   (compare_int a__005_ b__006_ [@merlin.hide]))
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
                (bits_to_represent n)
                ~expect
            in
            test (M.of_int_exn 0) 0;
            test (M.of_int_exn 1) 1;
            test (M.of_int_exn 2) 2;
            test (M.of_int_exn 3) 2;
            test (M.of_int_exn 4) 3;
            test (M.of_int_exn 5) 3;
            test (M.of_int_exn 6) 3;
            test (M.of_int_exn 7) 3;
            test (M.of_int_exn 8) 4;
            test (M.of_int_exn 100) 7;
            test M.max_value (Int.pred M.num_bits));
           ())
    ;;

    let min_represented_by_n_bits n =
      if Int.equal n 0 then zero else shift_left one (Int.pred n)
    ;;

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "min_represented_by_n_bits")
        ~tags:[]
        ~filename:"splittable_random.ml.before-ppx"
        ~line_number:308
        ~start_pos:4
        ~end_pos:392
        (fun () ->
           (let test n expect =
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "splittable_random.ml.before-ppx:309:41" in
                 let sexpifier = (M.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__007_ : M.t) ((b__008_ : M.t) [@merlin.hide]) ->
                   (M.compare a__007_ b__008_ [@merlin.hide]))
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
                (min_represented_by_n_bits n)
                ~expect
            in
            test 0 (M.of_int_exn 0);
            test 1 (M.of_int_exn 1);
            test 2 (M.of_int_exn 2);
            test 3 (M.of_int_exn 4);
            test 4 (M.of_int_exn 8);
            test 7 (M.of_int_exn 64);
            test (Int.pred M.num_bits) (M.shift_right_logical M.min_value 1));
           ())
    ;;

    let max_represented_by_n_bits n = pred (shift_left one n)

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "max_represented_by_n_bits")
        ~tags:[]
        ~filename:"splittable_random.ml.before-ppx"
        ~line_number:321
        ~start_pos:4
        ~end_pos:368
        (fun () ->
           (let test n expect =
              (fun ?(here = []) ?message ?equal ~expect got ->
                 let pos = "splittable_random.ml.before-ppx:322:41" in
                 let sexpifier = (M.sexp_of_t [@merlin.hide]) in
                 let comparator =
                   (fun (a__009_ : M.t) ((b__010_ : M.t) [@merlin.hide]) ->
                   (M.compare a__009_ b__010_ [@merlin.hide]))
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
                (max_represented_by_n_bits n)
                ~expect
            in
            test 0 (M.of_int_exn 0);
            test 1 (M.of_int_exn 1);
            test 2 (M.of_int_exn 3);
            test 3 (M.of_int_exn 7);
            test 4 (M.of_int_exn 15);
            test 7 (M.of_int_exn 127);
            test (Int.pred M.num_bits) M.max_value);
           ())
    ;;

    let log_uniform state ~lo ~hi =
      let min_bits = bits_to_represent lo in
      let max_bits = bits_to_represent hi in
      let bits = int state ~lo:min_bits ~hi:max_bits in
      uniform
        state
        ~lo:(max lo (min_represented_by_n_bits bits))
        ~hi:(min hi (max_represented_by_n_bits bits))
    ;;
  end

  module For_int = Make (struct
      include Int

      let uniform = int
    end)

  module For_int32 = Make (struct
      include Int32

      let uniform = int32
    end)

  module For_int63 = Make (struct
      include Int63

      let uniform = int63
    end)

  module For_int64 = Make (struct
      include Int64

      let uniform = int64
    end)

  module For_nativeint = Make (struct
      include Nativeint

      let uniform = nativeint
    end)

  let int = For_int.log_uniform
  let int32 = For_int32.log_uniform
  let int63 = For_int63.log_uniform
  let int64 = For_int64.log_uniform
  let nativeint = For_nativeint.log_uniform
end

module State = struct
  type t = state

  let create = create
  let of_int = of_int
  let perturb = perturb
  let copy = copy
  let split = split
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
