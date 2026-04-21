let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"color_256.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "color_256.ml.before-ppx"
;;

module Stable = struct
  open! Core.Core_stable

  module V1 = struct
    type t = int [@@deriving sexp, compare, hash, equal]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let compare =
        (fun a__002_ b__003_ -> compare_int a__002_ b__003_
         : t -> (t[@merlin.hide]) -> int)
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

      let equal =
        (fun a__004_ b__005_ -> equal_int a__004_ b__005_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

open Core

type t = Stable.V1.t [@@deriving sexp_of, compare, hash, equal]

include struct
  let _ = fun (_ : t) -> ()
  let sexp_of_t = (Stable.V1.sexp_of_t : t -> Sexplib0.Sexp.t)
  let _ = sexp_of_t

  let compare =
    (fun a__006_ b__007_ -> Stable.V1.compare a__006_ b__007_
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    fun hsv arg -> Stable.V1.hash_fold_t hsv arg

  and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
    let func = Stable.V1.hash in
    fun x -> func x
  ;;

  let _ = hash_fold_t
  and _ = hash

  let equal =
    (fun a__008_ b__009_ -> Stable.V1.equal a__008_ b__009_
     : t -> (t[@merlin.hide]) -> bool)
  ;;

  let _ = equal
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type level_map_t =
  { zero_level : int
  ; half_level : int
  ; full_level : int
  ; normal_white_level : int
  ; bright_black_level : int
  ; gray_base : int
  ; gray_stride : int
  ; color_cube_map : int list
  ; interpolated_map : float list
  }

let level_map_8bit_per_channel =
  { zero_level = 0
  ; half_level = 128
  ; full_level = 255
  ; normal_white_level = 192
  ; bright_black_level = 128
  ; gray_base = 8
  ; gray_stride = 10
  ; color_cube_map = [ 0; 95; 135; 175; 215; 255 ]
  ; interpolated_map = [ 47.5; 115.; 155.; 195.; 235. ]
  }
;;

let level_map_1000_per_channel =
  { zero_level = 0
  ; half_level = 500
  ; full_level = 1000
  ; normal_white_level = 750
  ; bright_black_level = 500
  ; gray_base = 20
  ; gray_stride = 40
  ; color_cube_map = [ 0; 372; 529; 686; 843; 1000 ]
  ; interpolated_map = [ 186.; 450.5; 607.5; 764.5; 921.5 ]
  }
;;

let closest_cube_index v ~iterp_map =
  match
    List.findi iterp_map ~f:(fun _idx iterp_val -> Float.( < ) (Float.of_int v) iterp_val)
  with
  | Some (level, _) -> level
  | None -> 5
;;

let closest_8bit_cube_index =
  closest_cube_index ~iterp_map:level_map_8bit_per_channel.interpolated_map
;;

let closest_int1k_cube_index =
  closest_cube_index ~iterp_map:level_map_1000_per_channel.interpolated_map
;;

let to_int c = c

let of_int_exn i =
  if i < 0 || i > 255
  then
    failwithf
      "Attr.Color_256.of_int_exn: value %d is outside of the closed range [0-255]"
      i
      ()
  else i
;;

let of_rgb6_exn (r, g, b) =
  let in_vals = [ r; g; b ] in
  let scalers = [ 36; 6; 1 ] in
  of_int_exn
    (List.fold2_exn in_vals scalers ~init:16 ~f:(fun acc v s ->
       if v >= 0 && v <= 5
       then acc + (v * s)
       else
         failwithf
           "RGB value %d for 256-color palette is outside of the closed range [0-5]"
           v
           ()))
;;

let of_rgb rgb =
  of_rgb6_exn
    (Tuple3.map rgb ~f:(fun f ->
       closest_8bit_cube_index
         (Float.to_int
            (Float.round_nearest
               ((if Float.is_finite f then Float.clamp_exn ~min:0. ~max:1. f else 0.)
                *. 255.)))))
;;

let of_rgb_8bit rgb = of_rgb6_exn (Tuple3.map rgb ~f:closest_8bit_cube_index)
let of_rgb_int1k rgb = of_rgb6_exn (Tuple3.map rgb ~f:closest_int1k_cube_index)

let of_gray24_exn g =
  of_int_exn
    (if g >= 0 && g <= 23
     then g + 232
     else failwithf "Grayscale value %d for 256-color palette out of range [0-23]" g ())
;;

let to_rgb_ints (c : t) ~(level_map : level_map_t) : int * int * int =
  let bit_select v b v_set =
    if v land (1 lsl b) <> 0 then v_set else level_map.zero_level
  in
  let bit3_result v v_set = Tuple3.map (0, 1, 2) ~f:(fun b -> bit_select v b v_set) in
  let ival = to_int c in
  if ival < 7
  then bit3_result ival level_map.half_level
  else if ival = 7
  then
    ( level_map.normal_white_level
    , level_map.normal_white_level
    , level_map.normal_white_level )
  else if ival = 8
  then
    ( level_map.bright_black_level
    , level_map.bright_black_level
    , level_map.bright_black_level )
  else if ival < 16
  then bit3_result (ival - 8) level_map.full_level
  else if ival > 255
  then level_map.full_level, level_map.full_level, level_map.full_level
  else if ival >= 232
  then (
    let gr_val = ival - 232 in
    let gr_part = level_map.gray_base + (gr_val * level_map.gray_stride) in
    gr_part, gr_part, gr_part)
  else (
    let rgb_val = ival - 16 in
    let r = rgb_val / 36 in
    let g = rgb_val / 6 mod 6 in
    let b = rgb_val mod 6 in
    let r_part =
      Option.value ~default:level_map.full_level (List.nth level_map.color_cube_map r)
    in
    let g_part =
      Option.value ~default:level_map.full_level (List.nth level_map.color_cube_map g)
    in
    let b_part =
      Option.value ~default:level_map.full_level (List.nth level_map.color_cube_map b)
    in
    r_part, g_part, b_part)
;;

let to_rgb_bytes = to_rgb_ints ~level_map:level_map_8bit_per_channel

let to_rgb c =
  let i = to_int c in
  if i < 16
  then `Primary i
  else `RGB (Tuple3.map ~f:(fun rgb -> rgb // 255) (to_rgb_bytes c))
;;

let to_rgb_hex24 c =
  let r, g, b = to_rgb_bytes c in
  sprintf "#%2.2x%2.2x%2.2x" r g b
;;

let tuple3_fold_two
      (t1 : ('a, 'a, 'a) Tuple3.t)
      (t2 : ('b, 'b, 'b) Tuple3.t)
      ~(init : 'c)
      ~(f : 'a -> 'b -> 'c -> 'c)
  : 'c
  =
  f (trd3 t1) (trd3 t2) (f (snd3 t1) (snd3 t2) (f (fst3 t1) (fst3 t2) init))
;;

let to_luma c =
  let rgb_bytes = to_rgb_bytes c in
  let weights = 0.299, 0.587, 0.114 in
  Float.clamp_exn
    ~min:0.
    ~max:1.
    (tuple3_fold_two rgb_bytes weights ~init:0. ~f:(fun byte_c weight acc ->
       acc +. (Float.of_int byte_c *. weight))
     /. 255.0)
;;

let to_rgb_8bit = to_rgb_bytes
let to_rgb_int1k c = to_rgb_ints ~level_map:level_map_1000_per_channel c

let to_rgb6 c =
  let offset_ival = to_int c - 16 in
  if offset_ival < 0 || offset_ival > 215
  then Tuple3.map ~f:closest_8bit_cube_index (to_rgb_bytes c)
  else (
    let r = offset_ival / 36 in
    let g = offset_ival / 6 mod 6 in
    let b = offset_ival mod 6 in
    r, g, b)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
