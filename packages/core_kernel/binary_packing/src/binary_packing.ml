let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"binary_packing.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "binary_packing.ml.before-ppx"
;;

open! Core
open! Import
module Core_char = Char
module Char = Stdlib.Char
module Int32 = Stdlib.Int32
module Int64 = Stdlib.Int64

let arch_sixtyfour = Sys.word_size_in_bits = 64
let signed_max = Int32.to_int Int32.max_int
let unsigned_max = Int64.to_int 0xffff_ffffL

type endian =
  [ `Big_endian
  | `Little_endian
  ]
[@@deriving compare, hash, sexp]

include struct
  let _ = fun (_ : endian) -> ()

  let compare_endian =
    (fun a__001_ b__002_ ->
       if Stdlib.( == ) a__001_ b__002_
       then 0
       else (
         match a__001_, b__002_ with
         | `Big_endian, `Big_endian -> 0
         | `Little_endian, `Little_endian -> 0
         | x, y -> Stdlib.compare x y)
     : endian -> (endian[@merlin.hide]) -> int)
  ;;

  let _ = compare_endian

  let hash_fold_endian
    : Ppx_hash_lib.Std.Hash.state -> endian -> Ppx_hash_lib.Std.Hash.state
    =
    fun hsv arg ->
    match arg with
    | `Big_endian -> Ppx_hash_lib.Std.Hash.fold_int hsv 75664794
    | `Little_endian -> Ppx_hash_lib.Std.Hash.fold_int hsv 720314340
  ;;

  let _ = hash_fold_endian

  let hash_endian : endian -> Ppx_hash_lib.Std.Hash.hash_value =
    let func arg =
      Ppx_hash_lib.Std.Hash.get_hash_value
        (let hsv = Ppx_hash_lib.Std.Hash.create () in
         hash_fold_endian hsv arg)
    in
    fun x -> func x
  ;;

  let _ = hash_endian

  let __endian_of_sexp__ =
    (let error_source__008_ = "binary_packing.ml.before-ppx.endian" in
     function
     | Sexplib0.Sexp.Atom atom__004_ as _sexp__006_ ->
       (match atom__004_ with
        | "Big_endian" -> `Big_endian
        | "Little_endian" -> `Little_endian
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__004_ :: _) as _sexp__006_ ->
       (match atom__004_ with
        | "Big_endian" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__008_ _sexp__006_
        | "Little_endian" ->
          Sexplib0.Sexp_conv_error.ptag_no_args error_source__008_ _sexp__006_
        | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__005_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var error_source__008_ sexp__005_
     | Sexplib0.Sexp.List [] as sexp__005_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var error_source__008_ sexp__005_
     : Sexplib0.Sexp.t -> endian)
  ;;

  let _ = __endian_of_sexp__

  let endian_of_sexp =
    (let error_source__010_ = "binary_packing.ml.before-ppx.endian" in
     fun sexp__009_ ->
       try __endian_of_sexp__ sexp__009_ with
       | Sexplib0.Sexp_conv_error.No_variant_match ->
         Sexplib0.Sexp_conv_error.no_matching_variant_found error_source__010_ sexp__009_
     : Sexplib0.Sexp.t -> endian)
  ;;

  let _ = endian_of_sexp

  let sexp_of_endian =
    (function
     | `Big_endian -> Sexplib0.Sexp.Atom "Big_endian"
     | `Little_endian -> Sexplib0.Sexp.Atom "Little_endian"
     : endian -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_endian
end [@@ocaml.doc "@inline"] [@@merlin.hide]

exception Binary_packing_invalid_byte_number of int * int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Binary_packing_invalid_byte_number]
      (function
      | Binary_packing_invalid_byte_number (arg0__011_, arg1__012_) ->
        let res0__013_ = sexp_of_int arg0__011_
        and res1__014_ = sexp_of_int arg1__012_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Binary_packing_invalid_byte_number"
          ; res0__013_
          ; res1__014_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let offset ~len ~byte_order byte_nr =
  if byte_nr >= len || byte_nr < 0
  then raise (Binary_packing_invalid_byte_number (byte_nr, len));
  match byte_order with
  | `Little_endian -> len - 1 - byte_nr
  | `Big_endian -> byte_nr
;;

exception Pack_unsigned_8_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_unsigned_8_argument_out_of_range]
      (function
      | Pack_unsigned_8_argument_out_of_range arg0__015_ ->
        let res0__016_ = sexp_of_int arg0__015_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_unsigned_8_argument_out_of_range"
          ; res0__016_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pack_unsigned_8 ~buf ~pos n =
  if n > 0xFF || n < 0
  then raise (Pack_unsigned_8_argument_out_of_range n)
  else Bytes.set buf pos (Char.unsafe_chr n)
;;

let unpack_unsigned_8 ~buf ~pos = Char.code (Bytes.get buf pos)

exception Pack_signed_8_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_signed_8_argument_out_of_range]
      (function
      | Pack_signed_8_argument_out_of_range arg0__017_ ->
        let res0__018_ = sexp_of_int arg0__017_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_signed_8_argument_out_of_range"
          ; res0__018_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pack_signed_8 ~buf ~pos n =
  if n > 0x7F || n < -0x80
  then raise (Pack_signed_8_argument_out_of_range n)
  else Bytes.set buf pos (Char.unsafe_chr n)
;;

let unpack_signed_8 ~buf ~pos =
  let n = unpack_unsigned_8 ~buf ~pos in
  if n >= 0x80 then -(0x100 - n) else n
;;

exception Pack_unsigned_16_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_unsigned_16_argument_out_of_range]
      (function
      | Pack_unsigned_16_argument_out_of_range arg0__019_ ->
        let res0__020_ = sexp_of_int arg0__019_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_unsigned_16_argument_out_of_range"
          ; res0__020_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pack_unsigned_16 ~byte_order ~buf ~pos n =
  if n >= 0x10000 || n < 0
  then raise (Pack_unsigned_16_argument_out_of_range n)
  else (
    Bytes.set
      buf
      (pos + offset ~len:2 ~byte_order 0)
      (Char.unsafe_chr (0xFF land (n asr 8)));
    Bytes.set buf (pos + offset ~len:2 ~byte_order 1) (Char.unsafe_chr (0xFF land n)))
;;

let pack_unsigned_16_big_endian ~buf ~pos n =
  if n >= 0x10000 || n < 0
  then raise (Pack_unsigned_16_argument_out_of_range n)
  else (
    Bytes.set buf pos (Char.unsafe_chr (0xFF land (n lsr 8)));
    Bytes.set buf (pos + 1) (Char.unsafe_chr (0xFF land n)))
;;

let pack_unsigned_16_little_endian ~buf ~pos n =
  if n >= 0x10000 || n < 0
  then raise (Pack_unsigned_16_argument_out_of_range n)
  else (
    Bytes.set buf (pos + 1) (Char.unsafe_chr (0xFF land (n lsr 8)));
    Bytes.set buf pos (Char.unsafe_chr (0xFF land n)))
;;

exception Pack_signed_16_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_signed_16_argument_out_of_range]
      (function
      | Pack_signed_16_argument_out_of_range arg0__021_ ->
        let res0__022_ = sexp_of_int arg0__021_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_signed_16_argument_out_of_range"
          ; res0__022_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pack_signed_16 ~byte_order ~buf ~pos n =
  if n > 0x7FFF || n < -0x8000
  then raise (Pack_signed_16_argument_out_of_range n)
  else (
    Bytes.set
      buf
      (pos + offset ~len:2 ~byte_order 0)
      (Char.unsafe_chr (0xFF land (n asr 8)));
    Bytes.set buf (pos + offset ~len:2 ~byte_order 1) (Char.unsafe_chr (0xFF land n)))
;;

let pack_signed_16_big_endian ~buf ~pos n =
  if n > 0x7FFF || n < -0x8000
  then raise (Pack_signed_16_argument_out_of_range n)
  else (
    Bytes.set buf pos (Char.unsafe_chr (0xFF land (n asr 8)));
    Bytes.set buf (pos + 1) (Char.unsafe_chr (0xFF land n)))
;;

let pack_signed_16_little_endian ~buf ~pos n =
  if n > 0x7FFF || n < -0x8000
  then raise (Pack_signed_16_argument_out_of_range n)
  else (
    Bytes.set buf (pos + 1) (Char.unsafe_chr (0xFF land (n asr 8)));
    Bytes.set buf pos (Char.unsafe_chr (0xFF land n)))
;;

let unpack_unsigned_16 ~byte_order ~buf ~pos =
  let b1 = Char.code (Bytes.get buf (pos + offset ~len:2 ~byte_order 0)) lsl 8 in
  let b2 = Char.code (Bytes.get buf (pos + offset ~len:2 ~byte_order 1)) in
  b1 lor b2
;;

let unpack_signed_16 ~byte_order ~buf ~pos =
  let n = unpack_unsigned_16 ~byte_order ~buf ~pos in
  if n >= 0x8000 then -(0x10000 - n) else n
;;

let unpack_unsigned_16_big_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf pos) lsl 8 in
  let b2 = Char.code (Bytes.get buf (pos + 1)) in
  b1 lor b2
;;

let unpack_unsigned_16_little_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf (pos + 1)) lsl 8 in
  let b2 = Char.code (Bytes.get buf pos) in
  b1 lor b2
;;

let unpack_signed_16_big_endian ~buf ~pos =
  let n = unpack_unsigned_16_big_endian ~buf ~pos in
  if n >= 0x8000 then -(0x10000 - n) else n
;;

let unpack_signed_16_little_endian ~buf ~pos =
  let n = unpack_unsigned_16_little_endian ~buf ~pos in
  if n >= 0x8000 then -(0x10000 - n) else n
;;

exception Pack_unsigned_32_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_unsigned_32_argument_out_of_range]
      (function
      | Pack_unsigned_32_argument_out_of_range arg0__023_ ->
        let res0__024_ = sexp_of_int arg0__023_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_unsigned_32_argument_out_of_range"
          ; res0__024_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let check_unsigned_32_in_range n =
  if arch_sixtyfour
  then (
    if n > unsigned_max || n < 0 then raise (Pack_unsigned_32_argument_out_of_range n))
  else if n < 0
  then raise (Pack_unsigned_32_argument_out_of_range n)
;;

let pack_unsigned_32_int ~byte_order ~buf ~pos n =
  assert (Sys.word_size_in_bits = 64);
  check_unsigned_32_in_range n;
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 0)
    (Char.unsafe_chr (0xFF land (n asr 24)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 1)
    (Char.unsafe_chr (0xFF land (n asr 16)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 2)
    (Char.unsafe_chr (0xFF land (n asr 8)));
  Bytes.set buf (pos + offset ~len:4 ~byte_order 3) (Char.unsafe_chr (0xFF land n))
;;

let pack_unsigned_32_int_big_endian ~buf ~pos n =
  check_unsigned_32_in_range n;
  Bytes.set buf pos (Char.unsafe_chr (0xFF land (n lsr 24)));
  Bytes.set buf (pos + 3) (Char.unsafe_chr (0xFF land n));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (n lsr 16)));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (n lsr 8)))
;;

let pack_unsigned_32_int_little_endian ~buf ~pos n =
  check_unsigned_32_in_range n;
  Bytes.set buf (pos + 3) (Char.unsafe_chr (0xFF land (n lsr 24)));
  Bytes.set buf pos (Char.unsafe_chr (0xFF land n));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (n lsr 16)));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (n lsr 8)))
;;

exception Pack_signed_32_argument_out_of_range of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_signed_32_argument_out_of_range]
      (function
      | Pack_signed_32_argument_out_of_range arg0__025_ ->
        let res0__026_ = sexp_of_int arg0__025_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_signed_32_argument_out_of_range"
          ; res0__026_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let check_signed_32_in_range n =
  if arch_sixtyfour
  then
    if n > signed_max || n < -(signed_max + 1)
    then raise (Pack_signed_32_argument_out_of_range n)
;;

let pack_signed_32_int ~byte_order ~buf ~pos n =
  assert (Sys.word_size_in_bits = 64);
  check_signed_32_in_range n;
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 0)
    (Char.unsafe_chr (0xFF land (n asr 24)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 1)
    (Char.unsafe_chr (0xFF land (n asr 16)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 2)
    (Char.unsafe_chr (0xFF land (n asr 8)));
  Bytes.set buf (pos + offset ~len:4 ~byte_order 3) (Char.unsafe_chr (0xFF land n))
;;

let pack_signed_32_int_big_endian ~buf ~pos n =
  check_signed_32_in_range n;
  Bytes.set buf pos (Char.unsafe_chr (0xFF land (n asr 24)));
  Bytes.set buf (pos + 3) (Char.unsafe_chr (0xFF land n));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (n asr 16)));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (n asr 8)))
;;

let pack_signed_32_int_little_endian ~buf ~pos n =
  check_signed_32_in_range n;
  Bytes.set buf (pos + 3) (Char.unsafe_chr (0xFF land (n asr 24)));
  Bytes.set buf pos (Char.unsafe_chr (0xFF land n));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (n asr 16)));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (n asr 8)))
;;

let pack_signed_32 ~byte_order ~buf ~pos n =
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 0)
    (Char.unsafe_chr (0xFF land Int32.to_int (Int32.shift_right n 24)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 1)
    (Char.unsafe_chr (0xFF land Int32.to_int (Int32.shift_right n 16)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 2)
    (Char.unsafe_chr (0xFF land Int32.to_int (Int32.shift_right n 8)));
  Bytes.set
    buf
    (pos + offset ~len:4 ~byte_order 3)
    (Char.unsafe_chr (0xFF land Int32.to_int n))
;;

let unpack_signed_32 ~byte_order ~buf ~pos =
  let b1 =
    Int32.shift_left
      (Int32.of_int (Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 0))))
      24
  in
  let b2 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 1)) lsl 16 in
  let b3 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 2)) lsl 8 in
  let b4 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 3)) in
  Int32.logor b1 (Int32.of_int (b2 lor b3 lor b4))
;;

let unpack_unsigned_32_int ~byte_order ~buf ~pos =
  assert (Sys.word_size_in_bits = 64);
  let b1 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 0)) lsl 24 in
  let b2 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 1)) lsl 16 in
  let b3 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 2)) lsl 8 in
  let b4 = Char.code (Bytes.get buf (pos + offset ~len:4 ~byte_order 3)) in
  b1 lor b2 lor b3 lor b4
;;

let unpack_unsigned_32_int_big_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf pos) lsl 24 in
  let b4 = Char.code (Bytes.get buf (pos + 3)) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 1)) lsl 16 in
  let b3 = Char.code (Bytes.unsafe_get buf (pos + 2)) lsl 8 in
  b1 lor b2 lor b3 lor b4
;;

let unpack_unsigned_32_int_little_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf (pos + 3)) lsl 24 in
  let b4 = Char.code (Bytes.get buf pos) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 2)) lsl 16 in
  let b3 = Char.code (Bytes.unsafe_get buf (pos + 1)) lsl 8 in
  b1 lor b2 lor b3 lor b4
;;

let unpack_signed_32_int ~byte_order ~buf ~pos =
  let n = unpack_unsigned_32_int ~byte_order ~buf ~pos in
  if arch_sixtyfour && n > signed_max then -(((signed_max + 1) lsl 1) - n) else n
;;

let unpack_signed_32_int_big_endian ~buf ~pos =
  let n = unpack_unsigned_32_int_big_endian ~buf ~pos in
  if arch_sixtyfour && n > signed_max then n - (unsigned_max + 1) else n
;;

let unpack_signed_32_int_little_endian ~buf ~pos =
  let n = unpack_unsigned_32_int_little_endian ~buf ~pos in
  if arch_sixtyfour && n > signed_max then n - (unsigned_max + 1) else n
;;

let pack_signed_64 ~byte_order ~buf ~pos v =
  let top3 = Int64.to_int (Int64.shift_right v 40) in
  let mid3 = Int64.to_int (Int64.shift_right v 16) in
  let bot2 = Int64.to_int v in
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 0)
    (Char.unsafe_chr (0xFF land (top3 lsr 16)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 1)
    (Char.unsafe_chr (0xFF land (top3 lsr 8)));
  Bytes.set buf (pos + offset ~len:8 ~byte_order 2) (Char.unsafe_chr (0xFF land top3));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 3)
    (Char.unsafe_chr (0xFF land (mid3 lsr 16)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 4)
    (Char.unsafe_chr (0xFF land (mid3 lsr 8)));
  Bytes.set buf (pos + offset ~len:8 ~byte_order 5) (Char.unsafe_chr (0xFF land mid3));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 6)
    (Char.unsafe_chr (0xFF land (bot2 lsr 8)));
  Bytes.set buf (pos + offset ~len:8 ~byte_order 7) (Char.unsafe_chr (0xFF land bot2))
;;

let pack_signed_64_big_endian ~buf ~pos v =
  Bytes.set
    buf
    pos
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 56))));
  Bytes.set buf (pos + 7) (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL v)));
  Bytes.unsafe_set
    buf
    (pos + 1)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 48))));
  Bytes.unsafe_set
    buf
    (pos + 2)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 40))));
  Bytes.unsafe_set
    buf
    (pos + 3)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 32))));
  Bytes.unsafe_set
    buf
    (pos + 4)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 24))));
  Bytes.unsafe_set
    buf
    (pos + 5)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 16))));
  Bytes.unsafe_set
    buf
    (pos + 6)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 8))))
;;

let pack_signed_64_little_endian ~buf ~pos v =
  Bytes.set buf pos (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL v)));
  Bytes.set
    buf
    (pos + 7)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 56))));
  Bytes.unsafe_set
    buf
    (pos + 1)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 8))));
  Bytes.unsafe_set
    buf
    (pos + 2)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 16))));
  Bytes.unsafe_set
    buf
    (pos + 3)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 24))));
  Bytes.unsafe_set
    buf
    (pos + 4)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 32))));
  Bytes.unsafe_set
    buf
    (pos + 5)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 40))));
  Bytes.unsafe_set
    buf
    (pos + 6)
    (Char.unsafe_chr (Int64.to_int (Int64.logand 0xFFL (Int64.shift_right_logical v 48))))
;;

let unpack_signed_64 ~byte_order ~buf ~pos =
  Int64.logor
    (Int64.logor
       (Int64.shift_left
          (Int64.of_int
             ((Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 0)) lsl 16)
              lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 1)) lsl 8)
              lor Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 2))))
          40)
       (Int64.shift_left
          (Int64.of_int
             ((Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 3)) lsl 16)
              lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 4)) lsl 8)
              lor Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 5))))
          16))
    (Int64.of_int
       ((Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 6)) lsl 8)
        lor Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 7))))
;;

let unpack_signed_64_big_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf pos)
  and b8 = Char.code (Bytes.get buf (pos + 7)) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 1))
  and b3 = Char.code (Bytes.unsafe_get buf (pos + 2))
  and b4 = Char.code (Bytes.unsafe_get buf (pos + 3))
  and b5 = Char.code (Bytes.unsafe_get buf (pos + 4))
  and b6 = Char.code (Bytes.unsafe_get buf (pos + 5))
  and b7 = Char.code (Bytes.unsafe_get buf (pos + 6)) in
  if arch_sixtyfour
  then (
    let i1 = Int64.of_int b1
    and i2 =
      Int64.of_int
        ((b2 lsl 48)
         lor (b3 lsl 40)
         lor (b4 lsl 32)
         lor (b5 lsl 24)
         lor (b6 lsl 16)
         lor (b7 lsl 8)
         lor b8)
    in
    let open Int64 in
    logor i2 (shift_left i1 56))
  else (
    let i1 = Int64.of_int ((b1 lsl 8) lor b2)
    and i2 = Int64.of_int ((b3 lsl 16) lor (b4 lsl 8) lor b5)
    and i3 = Int64.of_int ((b6 lsl 16) lor (b7 lsl 8) lor b8) in
    let open Int64 in
    logor i3 (logor (shift_left i2 24) (shift_left i1 48)))
;;

let unpack_signed_64_little_endian ~buf ~pos =
  let b1 = Char.code (Bytes.get buf pos)
  and b8 = Char.code (Bytes.get buf (pos + 7)) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 1))
  and b3 = Char.code (Bytes.unsafe_get buf (pos + 2))
  and b4 = Char.code (Bytes.unsafe_get buf (pos + 3))
  and b5 = Char.code (Bytes.unsafe_get buf (pos + 4))
  and b6 = Char.code (Bytes.unsafe_get buf (pos + 5))
  and b7 = Char.code (Bytes.unsafe_get buf (pos + 6)) in
  if arch_sixtyfour
  then (
    let i1 =
      Int64.of_int
        (b1
         lor (b2 lsl 8)
         lor (b3 lsl 16)
         lor (b4 lsl 24)
         lor (b5 lsl 32)
         lor (b6 lsl 40)
         lor (b7 lsl 48))
    and i2 = Int64.of_int b8 in
    let open Int64 in
    logor i1 (shift_left i2 56))
  else (
    let i1 = Int64.of_int (b1 lor (b2 lsl 8) lor (b3 lsl 16))
    and i2 = Int64.of_int (b4 lor (b5 lsl 8) lor (b6 lsl 16))
    and i3 = Int64.of_int (b7 lor (b8 lsl 8)) in
    let open Int64 in
    logor i1 (logor (shift_left i2 24) (shift_left i3 48)))
;;

let pack_signed_64_int ~byte_order ~buf ~pos n =
  assert (Sys.word_size_in_bits = 64);
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 0)
    (Char.unsafe_chr (0xFF land (n asr 56)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 1)
    (Char.unsafe_chr (0xFF land (n asr 48)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 2)
    (Char.unsafe_chr (0xFF land (n asr 40)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 3)
    (Char.unsafe_chr (0xFF land (n asr 32)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 4)
    (Char.unsafe_chr (0xFF land (n asr 24)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 5)
    (Char.unsafe_chr (0xFF land (n asr 16)));
  Bytes.set
    buf
    (pos + offset ~len:8 ~byte_order 6)
    (Char.unsafe_chr (0xFF land (n asr 8)));
  Bytes.set buf (pos + offset ~len:8 ~byte_order 7) (Char.unsafe_chr (0xFF land n))
;;

let pack_signed_64_int_big_endian ~buf ~pos v =
  Bytes.set buf pos (Char.unsafe_chr (0xFF land (v asr 56)));
  Bytes.set buf (pos + 7) (Char.unsafe_chr (0xFF land v));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (v asr 48)));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (v asr 40)));
  Bytes.unsafe_set buf (pos + 3) (Char.unsafe_chr (0xFF land (v asr 32)));
  Bytes.unsafe_set buf (pos + 4) (Char.unsafe_chr (0xFF land (v asr 24)));
  Bytes.unsafe_set buf (pos + 5) (Char.unsafe_chr (0xFF land (v asr 16)));
  Bytes.unsafe_set buf (pos + 6) (Char.unsafe_chr (0xFF land (v asr 8)))
;;

let pack_signed_64_int_little_endian ~buf ~pos v =
  Bytes.set buf pos (Char.unsafe_chr (0xFF land v));
  Bytes.set buf (pos + 7) (Char.unsafe_chr (0xFF land (v asr 56)));
  Bytes.unsafe_set buf (pos + 1) (Char.unsafe_chr (0xFF land (v asr 8)));
  Bytes.unsafe_set buf (pos + 2) (Char.unsafe_chr (0xFF land (v asr 16)));
  Bytes.unsafe_set buf (pos + 3) (Char.unsafe_chr (0xFF land (v asr 24)));
  Bytes.unsafe_set buf (pos + 4) (Char.unsafe_chr (0xFF land (v asr 32)));
  Bytes.unsafe_set buf (pos + 5) (Char.unsafe_chr (0xFF land (v asr 40)));
  Bytes.unsafe_set buf (pos + 6) (Char.unsafe_chr (0xFF land (v asr 48)))
;;

let unpack_signed_64_int ~byte_order ~buf ~pos =
  assert (Sys.word_size_in_bits = 64);
  (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 0)) lsl 56)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 1)) lsl 48)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 2)) lsl 40)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 3)) lsl 32)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 4)) lsl 24)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 5)) lsl 16)
  lor (Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 6)) lsl 8)
  lor Char.code (Bytes.get buf (pos + offset ~len:8 ~byte_order 7))
;;

exception Unpack_signed_64_int_most_significant_byte_too_large of int [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Unpack_signed_64_int_most_significant_byte_too_large]
      (function
      | Unpack_signed_64_int_most_significant_byte_too_large arg0__027_ ->
        let res0__028_ = sexp_of_int arg0__027_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Unpack_signed_64_int_most_significant_byte_too_large"
          ; res0__028_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let check_highest_order_byte_range byte =
  if byte < 64 || byte >= 192
  then ()
  else raise (Unpack_signed_64_int_most_significant_byte_too_large byte)
;;

let unpack_signed_64_int_big_endian ~buf ~pos =
  assert (Sys.word_size_in_bits = 64);
  let b1 = Char.code (Bytes.get buf pos)
  and b8 = Char.code (Bytes.get buf (pos + 7)) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 1))
  and b3 = Char.code (Bytes.unsafe_get buf (pos + 2))
  and b4 = Char.code (Bytes.unsafe_get buf (pos + 3))
  and b5 = Char.code (Bytes.unsafe_get buf (pos + 4))
  and b6 = Char.code (Bytes.unsafe_get buf (pos + 5))
  and b7 = Char.code (Bytes.unsafe_get buf (pos + 6)) in
  check_highest_order_byte_range b1;
  (b1 lsl 56)
  lor (b2 lsl 48)
  lor (b3 lsl 40)
  lor (b4 lsl 32)
  lor (b5 lsl 24)
  lor (b6 lsl 16)
  lor (b7 lsl 8)
  lor b8
;;

let unpack_signed_64_int_little_endian ~buf ~pos =
  assert (Sys.word_size_in_bits = 64);
  let b1 = Char.code (Bytes.get buf pos)
  and b8 = Char.code (Bytes.get buf (pos + 7)) in
  let b2 = Char.code (Bytes.unsafe_get buf (pos + 1))
  and b3 = Char.code (Bytes.unsafe_get buf (pos + 2))
  and b4 = Char.code (Bytes.unsafe_get buf (pos + 3))
  and b5 = Char.code (Bytes.unsafe_get buf (pos + 4))
  and b6 = Char.code (Bytes.unsafe_get buf (pos + 5))
  and b7 = Char.code (Bytes.unsafe_get buf (pos + 6)) in
  check_highest_order_byte_range b8;
  b1
  lor (b2 lsl 8)
  lor (b3 lsl 16)
  lor (b4 lsl 24)
  lor (b5 lsl 32)
  lor (b6 lsl 40)
  lor (b7 lsl 48)
  lor (b8 lsl 56)
;;

let pack_float ~byte_order ~buf ~pos f =
  pack_signed_64 ~byte_order ~buf ~pos (Int64.bits_of_float f)
;;

let unpack_float ~byte_order ~buf ~pos =
  Int64.float_of_bits (unpack_signed_64 ~byte_order ~buf ~pos)
;;

let rec last_nonmatch_plus_one ~buf ~min_pos ~pos ~char =
  let pos' = pos - 1 in
  if pos' >= min_pos && Core_char.( = ) (Bytes.get buf pos') char
  then last_nonmatch_plus_one ~buf ~min_pos ~pos:pos' ~char
  else pos
;;

let unpack_tail_padded_fixed_string ?(padding = '\000') ~buf ~pos ~len () =
  let data_end =
    last_nonmatch_plus_one ~buf ~min_pos:pos ~pos:(pos + len) ~char:padding
  in
  Bytes.To_string.sub buf ~pos ~len:(data_end - pos)
;;

exception
  Pack_tail_padded_fixed_string_argument_too_long of
    [ `s of string ] * [ `longer_than ] * [ `len of int ]
[@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Pack_tail_padded_fixed_string_argument_too_long]
      (function
      | Pack_tail_padded_fixed_string_argument_too_long
          (arg0__031_, arg1__032_, arg2__033_) ->
        let res0__034_ =
          let (`s v__029_) = arg0__031_ in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "s"; sexp_of_string v__029_ ]
        and res1__035_ =
          let `longer_than = arg1__032_ in
          Sexplib0.Sexp.Atom "longer_than"
        and res2__036_ =
          let (`len v__030_) = arg2__033_ in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "len"; sexp_of_int v__030_ ]
        in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom
              "binary_packing.ml.before-ppx.Pack_tail_padded_fixed_string_argument_too_long"
          ; res0__034_
          ; res1__035_
          ; res2__036_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let pack_tail_padded_fixed_string ?(padding = '\000') ~buf ~pos ~len s =
  let slen = String.length s in
  if slen > len
  then
    raise (Pack_tail_padded_fixed_string_argument_too_long (`s s, `longer_than, `len len))
  else (
    Bytes.From_string.blit ~src:s ~dst:buf ~src_pos:0 ~dst_pos:pos ~len:slen;
    if slen < len
    then (
      let diff = len - slen in
      Bytes.fill buf ~pos:(pos + slen) ~len:diff padding))
;;

module Private = struct
  let last_nonmatch_plus_one = last_nonmatch_plus_one

  exception
    Unpack_signed_64_int_most_significant_byte_too_large = Unpack_signed_64_int_most_significant_byte_too_large
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
