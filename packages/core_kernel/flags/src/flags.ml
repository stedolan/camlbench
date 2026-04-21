let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"flags.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "flags.ml.before-ppx"
;;

open! Core
open Poly
include Flags_intf

let raise_invalid_bit n =
  failwiths
    ~here:
      { Ppx_here_lib.pos_fname = "flags.ml.before-ppx"
      ; pos_lnum = 9
      ; pos_cnum = 253
      ; pos_bol = 243
      }
    "Flags.create got invalid ~bit (must be between 0 and 62)"
    n
    (sexp_of_int [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let create ~bit:n =
  if n < 0 || n > 62 then raise_invalid_bit n;
  Int63.shift_left Int63.one n
;;

module Make (M : Make_arg) = struct
  type t = Int63.t [@@deriving bin_io, hash, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "flags.ml.before-ppx:21:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], Int63.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = Int63.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = Int63.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Int63.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = Int63.bin_read_t
    let _ = bin_read_t

    let bin_reader_t =
      ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Int63.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int63.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "flags.ml.before-ppx.Make.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Int63.typerep_of_t))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_int = Int63.of_int
  let to_int_exn = Int63.to_int_exn
  let empty = Int63.zero
  let is_empty t = t = empty
  let ( + ) a b = Int63.bit_or a b
  let ( - ) a b = Int63.bit_and a (Int63.bit_not b)
  let intersect = Int63.bit_and
  let all = List.fold M.known ~init:empty ~f:(fun acc (flag, _) -> acc + flag)
  let complement a = all - a
  let is_subset t ~of_ = Int63.( = ) t (intersect t of_)
  let do_intersect t1 t2 = Int63.( <> ) (Int63.bit_and t1 t2) Int63.zero
  let are_disjoint t1 t2 = Int63.( = ) (Int63.bit_and t1 t2) Int63.zero

  let error message a sexp_of_a =
    let e = Error.create message a sexp_of_a in
    if M.should_print_error then eprintf "%s\n%!" (Sexp.to_string_hum (Error.sexp_of_t e));
    Error.raise e
  ;;

  let known =
    if M.remove_zero_flags
    then List.filter ~f:(fun (n, _) -> not (Int63.equal n Int63.zero)) M.known
    else M.known
  ;;

  let any_intersecting flags =
    let rec loop l acc =
      match l with
      | [] -> false
      | (flag, _) :: l -> if do_intersect flag acc then true else loop l (acc + flag)
    in
    loop flags empty
  ;;

  let () =
    if not M.allow_intersecting
    then
      if any_intersecting known
      then (
        let rec check l ac =
          match l with
          | [] -> ac
          | (flag, name) :: l ->
            let bad = List.filter l ~f:(fun (flag', _) -> do_intersect flag flag') in
            let ac = if List.is_empty bad then ac else (flag, name, bad) :: ac in
            check l ac
        in
        let bad = check known [] in
        assert (not (List.is_empty bad));
        error "Flags.Make got intersecting flags" bad ((fun x__011_ ->
          sexp_of_list
            (fun (arg0__005_, arg1__006_, arg2__007_) ->
               let res0__008_ = Int63.sexp_of_t arg0__005_
               and res1__009_ = sexp_of_string arg1__006_
               and res2__010_ =
                 sexp_of_list
                   (fun (arg0__001_, arg1__002_) ->
                      let res0__003_ = Int63.sexp_of_t arg0__001_
                      and res1__004_ = sexp_of_string arg1__002_ in
                      Sexplib0.Sexp.List [ res0__003_; res1__004_ ])
                   arg2__007_
               in
               Sexplib0.Sexp.List [ res0__008_; res1__009_; res2__010_ ])
            x__011_) [@merlin.hide]))
  ;;

  let () =
    let bad = List.filter known ~f:(fun (flag, _) -> flag = Int63.zero) in
    if not (List.is_empty bad)
    then
      error "Flag.Make got flags with no bits set" bad ((fun x__016_ ->
        sexp_of_list
          (fun (arg0__012_, arg1__013_) ->
             let res0__014_ = Int63.sexp_of_t arg0__012_
             and res1__015_ = sexp_of_string arg1__013_ in
             Sexplib0.Sexp.List [ res0__014_; res1__015_ ])
          x__016_) [@merlin.hide])
  ;;

  type sexp_format = string list [@@deriving sexp]

  include struct
    let _ = fun (_ : sexp_format) -> ()

    let sexp_format_of_sexp =
      (fun x__018_ -> list_of_sexp string_of_sexp x__018_
       : Sexplib0.Sexp.t -> sexp_format)
    ;;

    let _ = sexp_format_of_sexp

    let sexp_of_sexp_format =
      (fun x__019_ -> sexp_of_list sexp_of_string x__019_
       : sexp_format -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_sexp_format
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type sexp_format_with_unrecognized_bits = string list * [ `unrecognized_bits of string ]
  [@@deriving sexp]

  include struct
    let _ = fun (_ : sexp_format_with_unrecognized_bits) -> ()

    let sexp_format_with_unrecognized_bits_of_sexp =
      (let error_source__029_ =
         "flags.ml.before-ppx.Make.sexp_format_with_unrecognized_bits"
       in
       function
       | Sexplib0.Sexp.List [ arg0__031_; arg1__032_ ] ->
         let res0__033_ = list_of_sexp string_of_sexp arg0__031_
         and res1__034_ =
           let sexp__030_ = arg1__032_ in
           try
             match sexp__030_ with
             | Sexplib0.Sexp.Atom atom__022_ as _sexp__024_ ->
               (match atom__022_ with
                | "unrecognized_bits" ->
                  Sexplib0.Sexp_conv_error.ptag_takes_args error_source__029_ _sexp__024_
                | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
             | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__022_ :: sexp_args__025_) as
               _sexp__024_ ->
               (match atom__022_ with
                | "unrecognized_bits" as _tag__026_ ->
                  (match sexp_args__025_ with
                   | arg0__027_ :: [] ->
                     let res0__028_ = string_of_sexp arg0__027_ in
                     `unrecognized_bits res0__028_
                   | _ ->
                     Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                       error_source__029_
                       _tag__026_
                       _sexp__024_)
                | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
             | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__023_ ->
               Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                 error_source__029_
                 sexp__023_
             | Sexplib0.Sexp.List [] as sexp__023_ ->
               Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                 error_source__029_
                 sexp__023_
           with
           | Sexplib0.Sexp_conv_error.No_variant_match ->
             Sexplib0.Sexp_conv_error.no_matching_variant_found
               error_source__029_
               sexp__030_
         in
         res0__033_, res1__034_
       | sexp__035_ ->
         Sexplib0.Sexp_conv_error.tuple_of_size_n_expected error_source__029_ 2 sexp__035_
       : Sexplib0.Sexp.t -> sexp_format_with_unrecognized_bits)
    ;;

    let _ = sexp_format_with_unrecognized_bits_of_sexp

    let sexp_of_sexp_format_with_unrecognized_bits =
      (fun (arg0__037_, arg1__038_) ->
         let res0__039_ = sexp_of_list sexp_of_string arg0__037_
         and res1__040_ =
           let (`unrecognized_bits v__036_) = arg1__038_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "unrecognized_bits"; sexp_of_string v__036_ ]
         in
         Sexplib0.Sexp.List [ res0__039_; res1__040_ ]
       : sexp_format_with_unrecognized_bits -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_sexp_format_with_unrecognized_bits
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_flag_list =
    let known = List.rev known in
    fun t ->
      List.fold known ~init:(t, []) ~f:(fun (t, flag_names) (flag, flag_name) ->
        if Int63.bit_and t flag = flag
        then t - flag, flag_name :: flag_names
        else t, flag_names)
  ;;

  let sexp_of_t t =
    let to_unsigned_hex_string x =
      Int64.Hex.to_string
        (let open Int64 in
         max_value land Int63.to_int64 x)
    in
    let leftover, flag_names = to_flag_list t in
    if leftover = empty
    then (sexp_of_sexp_format [@merlin.hide]) flag_names
    else
      (sexp_of_sexp_format_with_unrecognized_bits [@merlin.hide])
        (flag_names, `unrecognized_bits (to_unsigned_hex_string leftover))
  ;;

  let known_by_name =
    String.Table.of_alist_exn (List.map known ~f:(fun (mask, name) -> name, mask))
  ;;

  let t_of_sexp (sexp : Sexp.t) =
    let of_unsigned_hex_string s = Int63.of_int64_trunc (Int64.Hex.of_string s) in
    let restore_int_of_flags_sexp flags =
      List.fold ((sexp_format_of_sexp [@merlin.hide]) flags) ~init:empty ~f:(fun t name ->
        match Hashtbl.find known_by_name name with
        | Some mask -> t + mask
        | None -> of_sexp_error (sprintf "Flags.t_of_sexp got unknown name: %s" name) sexp)
    in
    match sexp with
    | Sexp.List [ Sexp.List flags; Sexp.List unrecognized ] ->
      (match unrecognized with
       | [ Sexp.Atom "unrecognized_bits"; Sexp.Atom num ] ->
         restore_int_of_flags_sexp (Sexp.List flags) + of_unsigned_hex_string num
       | _ ->
         raise_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Of_sexp_error: sexp format does not match any recognized format"
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "sexp"
                    ; (Sexp.sexp_of_t [@merlin.hide]) sexp
                    ]
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
    | Sexp.List flags -> restore_int_of_flags_sexp (Sexp.List flags)
    | Sexp.Atom _ ->
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Of_sexp_error: list needed"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "sexp"
                 ; (Sexp.sexp_of_t [@merlin.hide]) sexp
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]))
  ;;

  let compare t u =
    let flip_top_bit i = Int63.( + ) i Int63.min_value in
    Int63.compare (flip_top_bit t) (flip_top_bit u)
  ;;

  include Comparable.Make (struct
      type nonrec t = t [@@deriving sexp, compare, hash]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let compare =
          (fun a__042_ b__043_ -> compare a__042_ b__043_ : t -> (t[@merlin.hide]) -> int)
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

  let equal = Int63.( = )
  let ( = ) = Int63.( = )
  let ( <> ) = Int63.( <> )

  module Unstable = struct
    type nonrec t = t [@@deriving bin_io, compare, equal, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "flags.ml.before-ppx:161:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__044_ b__045_ -> compare a__044_ b__045_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__046_ b__047_ -> equal a__046_ b__047_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Make_binable = Make

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
