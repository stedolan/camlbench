let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"byte_units.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "byte_units.ml.before-ppx"
;;

open! Import
open Std_internal
module Repr = Int63
module T = Byte_units0
include (T : module type of T with module Repr := Repr)
include Comparable.Make_plain (T)
include Hashable.Make_plain (T)

module Infix = struct
  let ( - ) a b = of_repr (Repr.( - ) (to_repr a) (to_repr b))
  let ( + ) a b = of_repr (Repr.( + ) (to_repr a) (to_repr b))
  let ( // ) a b = Repr.( // ) (to_repr a) (to_repr b)
  let ( / ) t s = of_repr (Float.int63_round_nearest_exn (Repr.to_float (to_repr t) /. s))
  let ( * ) t s = of_repr (Float.int63_round_nearest_exn (Repr.to_float (to_repr t) *. s))
end

include Infix

let abs t = of_repr (Repr.abs (to_repr t))
let neg t = of_repr (Repr.neg (to_repr t))
let sign t = Repr.sign (to_repr t)
let zero = of_repr Repr.zero
let min_value = of_repr Repr.min_value
let max_value = of_repr Repr.max_value
let scale = Infix.( * )
let iscale t s = of_repr (Repr.( * ) (to_repr t) (Repr.of_int s))
let bytes_int_exn = T.bytes_int_exn
let bytes_int63 = to_repr
let bytes_int64 t = Repr.to_int64 (to_repr t)
let bytes_float t = Repr.to_float (to_repr t)
let of_bytes_int b = of_repr (Repr.of_int b)
let of_bytes_int63 = of_repr
let of_bytes_int64_exn b = of_repr (Repr.of_int64_exn b)
let of_bytes_float_exn b = of_repr (Repr.of_float b)

let (bytes
     [@deprecated
       "[since 2019-01] Use [bytes_int_exn], [bytes_int63], [bytes_int64] or \
        [bytes_float] as appropriate."])
  =
  bytes_float
;;

let (of_bytes
     [@deprecated
       "[since 2019-01] Use [of_bytes_int], [of_bytes_int63], [of_bytes_int64_exn] or \
        [of_bytes_float_exn] as appropriate."])
  =
  of_bytes_float_exn
;;

let kilobyte : t = of_bytes_int 1024
let megabyte = iscale kilobyte 1024
let gigabyte = iscale megabyte 1024
let terabyte = iscale gigabyte 1024
let petabyte = iscale terabyte 1024
let exabyte = iscale petabyte 1024

let word =
  let module W = Word_size in
  match W.word_size with
  | W.W32 -> of_bytes_int 4
  | W.W64 -> of_bytes_int 8
;;

let kilobytes t : float = Infix.( // ) t kilobyte
let megabytes t = Infix.( // ) t megabyte
let gigabytes t = Infix.( // ) t gigabyte
let terabytes t = Infix.( // ) t terabyte
let petabytes t = Infix.( // ) t petabyte
let exabytes t = Infix.( // ) t exabyte
let words_int_exn t = Repr.to_int_exn (Repr.( / ) (to_repr t) (to_repr word))
let words_float t = Infix.( // ) t word
let of_kilobytes t : t = Infix.( * ) kilobyte t
let of_megabytes t = Infix.( * ) megabyte t
let of_gigabytes t = Infix.( * ) gigabyte t
let of_terabytes t = Infix.( * ) terabyte t
let of_petabytes t = Infix.( * ) petabyte t
let of_exabytes t = Infix.( * ) exabyte t
let of_words_int t = iscale word t
let of_words_float_exn t = Infix.( * ) word t

let (words [@deprecated "[since 2019-01] Use [words_int_exn] or [words_float]"]) =
  words_float
;;

let (of_words [@deprecated "[since 2019-01] Use [of_words_int] or [of_words_float_exn]"]) =
  of_words_float_exn
;;

let of_string s =
  let length = String.length s in
  if Int.( < ) length 2
  then invalid_argf "'%s' passed to Byte_units.of_string - too short" s ();
  let base_str = String.sub s ~pos:0 ~len:(Int.( - ) length 1) in
  let ext_char = Char.lowercase s.[Int.( - ) length 1] in
  let base =
    try Float.of_string base_str with
    | _ ->
      invalid_argf
        "'%s' passed to Byte_units.of_string - %s cannot be converted to float "
        s
        base_str
        ()
  in
  match ext_char with
  | 'b' -> of_bytes_float_exn base
  | 'k' -> of_kilobytes base
  | 'm' -> of_megabytes base
  | 'g' -> of_gigabytes base
  | 't' -> of_terabytes base
  | 'p' -> of_petabytes base
  | 'e' -> of_exabytes base
  | 'w' -> of_words_float_exn base
  | ext ->
    invalid_argf "'%s' passed to Byte_units.of_string - illegal extension %c" s ext ()
;;

let arg_type = Command.Arg_type.create of_string

let largest_measure t =
  let t_abs = of_repr (Repr.abs (to_repr t)) in
  if t_abs >= exabyte
  then `Exabytes
  else if t_abs >= petabyte
  then `Petabytes
  else if t_abs >= terabyte
  then `Terabytes
  else if t_abs >= gigabyte
  then `Gigabytes
  else if t_abs >= megabyte
  then `Megabytes
  else if t_abs >= kilobyte
  then `Kilobytes
  else `Bytes
;;

let gen_incl lo hi =
  Quickcheck.Generator.map ~f:of_repr (Repr.gen_incl (to_repr lo) (to_repr hi))
;;

let gen_uniform_incl lo hi =
  Quickcheck.Generator.map ~f:of_repr (Repr.gen_uniform_incl (to_repr lo) (to_repr hi))
;;

module Stable = struct
  module Of_sexp_v1_v2 : sig
    val t_of_sexp : Sexp.t -> t
  end = struct
    let no_match () = failwith "Not a recognized [Byte_units.t] representation"

    let of_value_sexp_and_unit_name val_sexp = function
      | "Bytes" ->
        (try of_bytes_int63 (Int63.t_of_sexp val_sexp) with
         | _ -> of_bytes_float_exn (Float.t_of_sexp val_sexp))
      | "Kilobytes" -> of_kilobytes (float_of_sexp val_sexp)
      | "Megabytes" -> of_megabytes (float_of_sexp val_sexp)
      | "Gigabytes" -> of_gigabytes (float_of_sexp val_sexp)
      | "Terabytes" -> of_terabytes (float_of_sexp val_sexp)
      | "Petabytes" -> of_petabytes (float_of_sexp val_sexp)
      | "Exabytes" -> of_exabytes (float_of_sexp val_sexp)
      | "Words" -> of_words_float_exn (float_of_sexp val_sexp)
      | _ -> no_match ()
    ;;

    let t_of_sexp = function
      | Sexp.Atom str -> of_string str
      | Sexp.List [ Sexp.Atom unit_name; value ] ->
        of_value_sexp_and_unit_name value unit_name
      | _ -> no_match ()
    ;;

    let t_of_sexp sexp =
      try t_of_sexp sexp with
      | exn -> raise (Sexp.Of_sexp_error (exn, sexp))
    ;;
  end

  module V1 = struct
    type nonrec t = t [@@deriving compare, hash, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__001_ b__002_ -> compare a__001_ b__002_ : t -> (t[@merlin.hide]) -> int)
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

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "byte_units.ml.before-ppx.Stable.V1.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_binable = bytes_float
    let of_binable = of_bytes_float_exn

    include
      Binable0.Of_binable_without_uuid [@alert "-legacy"]
        (Float)
        (struct
          type nonrec t = t

          let to_binable = to_binable
          let of_binable = of_binable
        end)

    let stable_witness : t Stable_witness.t =
      Stable_witness.of_serializable stable_witness_float of_binable to_binable
    ;;

    include Of_sexp_v1_v2

    let sexp_of_t t =
      match largest_measure t with
      | `Bytes ->
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.Atom "Bytes"
          ; (sexp_of_float [@merlin.hide]) (bytes_float t)
          ]
      | `Kilobytes ->
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.Atom "Kilobytes"
          ; (sexp_of_float [@merlin.hide]) (kilobytes t)
          ]
      | `Megabytes ->
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.Atom "Megabytes"
          ; (sexp_of_float [@merlin.hide]) (megabytes t)
          ]
      | `Gigabytes | `Terabytes | `Petabytes | `Exabytes ->
        Ppx_sexp_conv_lib.Sexp.List
          [ Ppx_sexp_conv_lib.Sexp.Atom "Gigabytes"
          ; (sexp_of_float [@merlin.hide]) (gigabytes t)
          ]
    ;;

    let to_string t = String.lowercase (to_string t)
    let of_string = of_string

    let () =
      match Ppx_inline_test_lib.testing with
      | `Not_testing -> ()
      | `Testing _ ->
        let module Ppx_expect_test_block =
          Ppx_expect_runtime.Make_test_block (Expect_test_config)
        in
        Ppx_expect_test_block.run_suite
          ~filename_rel_to_project_root:"byte_units.ml.before-ppx"
          ~line_number:217
          ~location:{ start_bol = 6858; start_pos = 6862; end_pos = 7562 }
          ~trailing_loc:{ start_bol = 7528; start_pos = 7562; end_pos = 7562 }
          ~body_loc:{ start_bol = 6858; start_pos = 6862; end_pos = 7562 }
          ~formatting_flexibility:
            (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
               Ppx_expect_runtime.Expect_node_formatting.default)
          ~expected_exn:None
          ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 9)
          ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 10)
          ~description:None
          ~tags:[ "no-js" ]
          ~inline_test_config:(module Inline_test_config)
          ~expectations:
            ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 8
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 9.536743164m "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7528; start_pos = 7543; end_pos = 7561 } ))
                   ~node_loc:{ start_bol = 7528; start_pos = 7534; end_pos = 7562 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 7
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 976.5625k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7450; start_pos = 7465; end_pos = 7480 } ))
                   ~node_loc:{ start_bol = 7450; start_pos = 7456; end_pos = 7481 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 6
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 97.65625k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7373; start_pos = 7388; end_pos = 7403 } ))
                   ~node_loc:{ start_bol = 7373; start_pos = 7379; end_pos = 7404 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 5
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 9.765625k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7297; start_pos = 7312; end_pos = 7327 } ))
                   ~node_loc:{ start_bol = 7297; start_pos = 7303; end_pos = 7328 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 4
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 1.464844k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7222; start_pos = 7237; end_pos = 7252 } ))
                   ~node_loc:{ start_bol = 7222; start_pos = 7228; end_pos = 7253 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 3
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 1.000977k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7148; start_pos = 7163; end_pos = 7178 } ))
                   ~node_loc:{ start_bol = 7148; start_pos = 7154; end_pos = 7179 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 2
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 1k "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7081; start_pos = 7096; end_pos = 7104 } ))
                   ~node_loc:{ start_bol = 7081; start_pos = 7087; end_pos = 7105 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 1
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 1023b "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 7011; start_pos = 7026; end_pos = 7037 } ))
                   ~node_loc:{ start_bol = 7011; start_pos = 7017; end_pos = 7038 } )
             ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 0
               , Ppx_expect_runtime.Test_node.Create.expect
                   ~formatting_flexibility:
                     (Ppx_expect_runtime.Expect_node_formatting.Flexibility
                      .Flexible_modulo
                        Ppx_expect_runtime.Expect_node_formatting.default)
                   ~located_payload:
                     (Some
                        ( { contents = " 1000b "
                          ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                          }
                        , { start_bol = 6941; start_pos = 6956; end_pos = 6967 } ))
                   ~node_loc:{ start_bol = 6941; start_pos = 6947; end_pos = 6968 } )
             ]
            [@merlin.hide])
          (fun () ->
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__003_ -> to_string _custom_printf__003_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1000);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 0) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__004_ -> to_string _custom_printf__004_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1023);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 1) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__005_ -> to_string _custom_printf__005_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1024);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 2) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__006_ -> to_string _custom_printf__006_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1025);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 3) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__007_ -> to_string _custom_printf__007_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1500);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 4) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__008_ -> to_string _custom_printf__008_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 10000);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 5) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__009_ -> to_string _custom_printf__009_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 100000);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 6) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__010_ -> to_string _custom_printf__010_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 1000000);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 7) [@merlin.hide];
             printf
               ((Format
                   ( Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__011_ -> to_string _custom_printf__011_)
                       , End_of_format )
                   , "%{}" )
                : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
                [@merlin.hide])
               (of_bytes_int 10000000);
             Ppx_expect_test_block.run_test
               ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 8) [@merlin.hide])
    ;;

    let t_of_sexp sexp =
      match sexp with
      | Sexp.Atom s ->
        (try of_string s with
         | Invalid_argument msg -> of_sexp_error msg sexp)
      | Sexp.List _ -> t_of_sexp sexp
    ;;
  end

  module V2 = struct
    type nonrec t = t [@@deriving compare, equal, hash, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__012_ b__013_ -> compare a__012_ b__013_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__014_ b__015_ -> equal a__014_ b__015_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "byte_units.ml.before-ppx.Stable.V2.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let to_binable = bytes_int63
    let of_binable = of_bytes_int63

    include
      Binable0.Of_binable_without_uuid [@alert "-legacy"]
        (Int63.Stable.V1)
        (struct
          type nonrec t = t

          let to_binable = to_binable
          let of_binable = of_binable
        end)

    let stable_witness : t Stable_witness.t =
      Stable_witness.of_serializable Int63.Stable.V1.stable_witness of_binable to_binable
    ;;

    include Of_sexp_v1_v2

    let sexp_of_t t =
      Ppx_sexp_conv_lib.Sexp.List
        [ Ppx_sexp_conv_lib.Sexp.Atom "Bytes"
        ; (Int63.sexp_of_t [@merlin.hide]) (bytes_int63 t)
        ]
    ;;
  end
end

let to_string_hum = to_string_hum

module Short = struct
  type nonrec t = t

  let to_string t =
    let to_units_str to_unit ext =
      let f = to_unit t in
      let f_abs = Float.abs f in
      if Float.Robustly_comparable.( >=. ) f_abs 100.
      then sprintf "%.0f%c" f ext
      else if Float.Robustly_comparable.( >=. ) f_abs 10.
      then sprintf "%.1f%c" f ext
      else sprintf "%.2f%c" f ext
    in
    match largest_measure t with
    | `Bytes -> sprintf "%dB" (bytes_int_exn t)
    | `Kilobytes -> to_units_str kilobytes 'K'
    | `Megabytes -> to_units_str megabytes 'M'
    | `Gigabytes -> to_units_str gigabytes 'G'
    | `Terabytes -> to_units_str terabytes 'T'
    | `Petabytes -> to_units_str petabytes 'P'
    | `Exabytes -> to_units_str exabytes 'E'
  ;;

  let sexp_of_t t = Sexp.Atom (to_string t)

  let () =
    match Ppx_inline_test_lib.testing with
    | `Not_testing -> ()
    | `Testing _ ->
      let module Ppx_expect_test_block =
        Ppx_expect_runtime.Make_test_block (Expect_test_config)
      in
      Ppx_expect_test_block.run_suite
        ~filename_rel_to_project_root:"byte_units.ml.before-ppx"
        ~line_number:300
        ~location:{ start_bol = 9241; start_pos = 9243; end_pos = 10226 }
        ~trailing_loc:{ start_bol = 10220; start_pos = 10226; end_pos = 10226 }
        ~body_loc:{ start_bol = 9241; start_pos = 9243; end_pos = 10226 }
        ~formatting_flexibility:
          (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
             Ppx_expect_runtime.Expect_node_formatting.default)
        ~expected_exn:None
        ~trailing_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 24)
        ~exn_test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 25)
        ~description:None
        ~tags:[]
        ~inline_test_config:(module Inline_test_config)
        ~expectations:
          ([ ( Ppx_expect_runtime.Expectation_id.of_int_exn 23
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 2.60E "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 10193; start_pos = 10206; end_pos = 10217 } ))
                 ~node_loc:{ start_bol = 10193; start_pos = 10197; end_pos = 10218 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 22
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 88.8P "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 10105; start_pos = 10118; end_pos = 10129 } ))
                 ~node_loc:{ start_bol = 10105; start_pos = 10109; end_pos = 10130 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 21
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 90.9T "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 10018; start_pos = 10031; end_pos = 10042 } ))
                 ~node_loc:{ start_bol = 10018; start_pos = 10022; end_pos = 10043 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 20
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 931G "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9935; start_pos = 9948; end_pos = 9958 } ))
                 ~node_loc:{ start_bol = 9935; start_pos = 9939; end_pos = 9959 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 19
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 9.31G "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9853; start_pos = 9866; end_pos = 9877 } ))
                 ~node_loc:{ start_bol = 9853; start_pos = 9857; end_pos = 9878 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 18
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 9.54M "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9773; start_pos = 9786; end_pos = 9797 } ))
                 ~node_loc:{ start_bol = 9773; start_pos = 9777; end_pos = 9798 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 17
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 977K "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9704; start_pos = 9717; end_pos = 9727 } ))
                 ~node_loc:{ start_bol = 9704; start_pos = 9708; end_pos = 9728 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 16
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 97.7K "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9635; start_pos = 9648; end_pos = 9659 } ))
                 ~node_loc:{ start_bol = 9635; start_pos = 9639; end_pos = 9660 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 15
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 9.77K "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9567; start_pos = 9580; end_pos = 9591 } ))
                 ~node_loc:{ start_bol = 9567; start_pos = 9571; end_pos = 9592 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 14
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 1.00K "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9500; start_pos = 9513; end_pos = 9524 } ))
                 ~node_loc:{ start_bol = 9500; start_pos = 9504; end_pos = 9525 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 13
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 1.00K "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9434; start_pos = 9447; end_pos = 9458 } ))
                 ~node_loc:{ start_bol = 9434; start_pos = 9438; end_pos = 9459 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 12
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 1023B "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9368; start_pos = 9381; end_pos = 9392 } ))
                 ~node_loc:{ start_bol = 9368; start_pos = 9372; end_pos = 9393 } )
           ; ( Ppx_expect_runtime.Expectation_id.of_int_exn 11
             , Ppx_expect_runtime.Test_node.Create.expect
                 ~formatting_flexibility:
                   (Ppx_expect_runtime.Expect_node_formatting.Flexibility.Flexible_modulo
                      Ppx_expect_runtime.Expect_node_formatting.default)
                 ~located_payload:
                   (Some
                      ( { contents = " 1000B "
                        ; tag = (T (Tag "") : Ppx_expect_runtime.Delimiter.t)
                        }
                      , { start_bol = 9302; start_pos = 9315; end_pos = 9326 } ))
                 ~node_loc:{ start_bol = 9302; start_pos = 9306; end_pos = 9327 } )
           ]
          [@merlin.hide])
        (fun () ->
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__016_ -> to_string _custom_printf__016_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 1000);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 11) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__017_ -> to_string _custom_printf__017_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 1023);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 12) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__018_ -> to_string _custom_printf__018_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 1024);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 13) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__019_ -> to_string _custom_printf__019_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 1025);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 14) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__020_ -> to_string _custom_printf__020_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 10000);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 15) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__021_ -> to_string _custom_printf__021_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 100000);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 16) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__022_ -> to_string _custom_printf__022_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 1000000);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 17) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__023_ -> to_string _custom_printf__023_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_int 10000000);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 18) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__024_ -> to_string _custom_printf__024_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_float_exn 10000000000.);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 19) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__025_ -> to_string _custom_printf__025_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_float_exn 1000000000000.);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 20) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__026_ -> to_string _custom_printf__026_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_float_exn 100000000000000.);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 21) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__027_ -> to_string _custom_printf__027_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_float_exn 100000000000000000.);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 22) [@merlin.hide];
           printf
             ((Format
                 ( Custom
                     ( Custom_succ Custom_zero
                     , (fun () _custom_printf__028_ -> to_string _custom_printf__028_)
                     , End_of_format )
                 , "%{}" )
              : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
              [@merlin.hide])
             (of_bytes_float_exn 3000000000000000000.);
           Ppx_expect_test_block.run_test
             ~test_id:(Ppx_expect_runtime.Expectation_id.of_int_exn 23) [@merlin.hide];
           ())
  ;;
end

let to_string_short = Short.to_string

let (create
     [@deprecated
       "[since 2019-01] Use [of_bytes], [of_kilobytes], [of_megabytes], etc as \
        appropriate."])
  =
  fun units value ->
  match units with
  | `Bytes -> of_bytes_float_exn value
  | `Kilobytes -> of_kilobytes value
  | `Megabytes -> of_megabytes value
  | `Gigabytes -> of_gigabytes value
  | `Words -> of_words_float_exn value
;;

include
  Quickcheckable.Of_quickcheckable
    (Repr)
    (struct
      type nonrec t = t

      let of_quickcheckable = of_repr
      let to_quickcheckable = to_repr
    end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
