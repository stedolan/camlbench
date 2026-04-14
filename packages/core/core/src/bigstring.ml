let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bigstring.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bigstring.ml.before-ppx"
;;

open! Import
open Std_internal
open Bigarray

module Stable = struct
  module V1 = struct
    include Base_bigstring

    module Z : sig
      type t = (char, int8_unsigned_elt, c_layout) Array1.t
      [@@deriving bin_io ~localize, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S_local with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end = struct
      type t = bigstring [@@deriving bin_io ~localize]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "bigstring.ml.before-ppx:13:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_bigstring ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_bigstring__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t

        let bin_write_t__local : t Bin_prot.Write.writer_local =
          bin_write_bigstring__local
        ;;

        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_bigstring__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_bigstring
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
    end

    include Z

    type t_frozen = t [@@deriving bin_io ~localize, stable_witness]

    include struct
      let _ = fun (_ : t_frozen) -> ()

      let bin_shape_t_frozen =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "bigstring.ml.before-ppx:22:4")
            [ Bin_prot.Shape.Tid.of_string "t_frozen", [], bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t_frozen")) []
      ;;

      let _ = bin_shape_t_frozen

      let bin_size_t_frozen__local : t_frozen Bin_prot.Size.sizer_local =
        bin_size_t__local
      ;;

      let _ = bin_size_t_frozen__local
      let bin_size_t_frozen = (bin_size_t_frozen__local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t_frozen

      let bin_write_t_frozen__local : t_frozen Bin_prot.Write.writer_local =
        bin_write_t__local
      ;;

      let _ = bin_write_t_frozen__local
      let bin_write_t_frozen = (bin_write_t_frozen__local :> _ Bin_prot.Write.writer)
      let _ = bin_write_t_frozen

      let bin_writer_t_frozen =
        ({ size = bin_size_t_frozen; write = bin_write_t_frozen }
         : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t_frozen
      let __bin_read_t_frozen__ : (int -> t_frozen) Bin_prot.Read.reader = __bin_read_t__
      let _ = __bin_read_t_frozen__
      let bin_read_t_frozen : t_frozen Bin_prot.Read.reader = bin_read_t
      let _ = bin_read_t_frozen

      let bin_reader_t_frozen =
        ({ read = bin_read_t_frozen; vtag_read = __bin_read_t_frozen__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t_frozen

      let bin_t_frozen =
        ({ writer = bin_writer_t_frozen
         ; reader = bin_reader_t_frozen
         ; shape = bin_shape_t_frozen
         }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t_frozen

      let stable_witness_t_frozen =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t_frozen Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t_frozen__ () =
        let _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness in
        ()
      ;;

      let _ = stable_witness_t_frozen
      and _ = __stable_witness_checks_for_t_frozen__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module T = Stable.V1
include T
module Unstable = T

let create size = create size

let sub_shared ?(pos = 0) ?len (bstr : t) =
  let len = get_opt_len bstr ~pos len in
  Array1.sub bstr pos len
;;

external unsafe_destroy : t -> unit = "bigstring_destroy_stub"
external unsafe_destroy_and_resize : t -> len:int -> t = "bigstring_realloc"

let read_bin_prot_verbose_errors t ?(pos = 0) ?len reader =
  let len = get_opt_len t len ~pos in
  let limit = pos + len in
  check_args ~loc:"read_bin_prot_verbose_errors" t ~pos ~len;
  let invalid_data message a sexp_of_a =
    `Invalid_data (Error.create message a sexp_of_a)
  in
  let read bin_reader ~pos ~len =
    if len > limit - pos
    then `Not_enough_data
    else (
      let pos_ref = ref pos in
      match
        try `Ok (bin_reader t ~pos_ref) with
        | exn -> `Invalid_data (Error.of_exn exn)
      with
      | `Invalid_data _ as x -> x
      | `Ok result ->
        let expected_pos = pos + len in
        if !pos_ref = expected_pos
        then `Ok (result, expected_pos)
        else
          invalid_data
            "pos_ref <> expected_pos"
            (!pos_ref, expected_pos)
            ((fun (arg0__001_, arg1__002_) ->
               let res0__003_ = sexp_of_int arg0__001_
               and res1__004_ = sexp_of_int arg1__002_ in
               Sexplib0.Sexp.List [ res0__003_; res1__004_ ]) [@merlin.hide]))
  in
  match
    read Bin_prot.Utils.bin_read_size_header ~pos ~len:Bin_prot.Utils.size_header_length
  with
  | (`Not_enough_data | `Invalid_data _) as x -> x
  | `Ok (element_length, pos) ->
    if element_length < 0
    then
      invalid_data
        "negative element length %d"
        element_length
        (sexp_of_int [@merlin.hide])
    else read reader.Bin_prot.Type_class.read ~pos ~len:element_length
;;

let read_bin_prot t ?pos ?len reader =
  match read_bin_prot_verbose_errors t ?pos ?len reader with
  | `Ok x -> Ok x
  | `Invalid_data e -> Error (Error.tag e ~tag:"Invalid data")
  | `Not_enough_data -> Or_error.error_string "not enough data"
;;

let write_bin_prot_known_size t ?(pos = 0) write ~size:data_len v =
  let total_len = data_len + Bin_prot.Utils.size_header_length in
  if pos < 0
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bigstring.ml.before-ppx"
        ; pos_lnum = 92
        ; pos_cnum = 2718
        ; pos_bol = 2698
        }
      "Bigstring.write_bin_prot: negative pos"
      pos
      (sexp_of_int [@merlin.hide]);
  if pos + total_len > length t
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bigstring.ml.before-ppx"
        ; pos_lnum = 96
        ; pos_cnum = 2853
        ; pos_bol = 2841
        }
      "Bigstring.write_bin_prot: not enough room"
      (`pos pos, `pos_after_writing (pos + total_len), `bigstring_length (length t))
      ((fun (arg0__008_, arg1__009_, arg2__010_) ->
         let res0__011_ =
           let (`pos v__005_) = arg0__008_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos"; sexp_of_int v__005_ ]
         and res1__012_ =
           let (`pos_after_writing v__006_) = arg1__009_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "pos_after_writing"; sexp_of_int v__006_ ]
         and res2__013_ =
           let (`bigstring_length v__007_) = arg2__010_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "bigstring_length"; sexp_of_int v__007_ ]
         in
         Sexplib0.Sexp.List [ res0__011_; res1__012_; res2__013_ ]) [@merlin.hide]);
  let pos_after_size_header = Bin_prot.Utils.bin_write_size_header t ~pos data_len in
  let pos_after_data = write t ~pos:pos_after_size_header v in
  if pos_after_data - pos <> total_len
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "bigstring.ml.before-ppx"
        ; pos_lnum = 106
        ; pos_cnum = 3323
        ; pos_bol = 3311
        }
      "Bigstring.write_bin_prot bug!"
      ( `pos_after_data pos_after_data
      , `start_pos pos
      , `bin_prot_size_header_length Bin_prot.Utils.size_header_length
      , `data_len data_len
      , `total_len total_len )
      ((fun (arg0__019_, arg1__020_, arg2__021_, arg3__022_, arg4__023_) ->
         let res0__024_ =
           let (`pos_after_data v__014_) = arg0__019_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos_after_data"; sexp_of_int v__014_ ]
         and res1__025_ =
           let (`start_pos v__015_) = arg1__020_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "start_pos"; sexp_of_int v__015_ ]
         and res2__026_ =
           let (`bin_prot_size_header_length v__016_) = arg2__021_ in
           Sexplib0.Sexp.List
             [ Sexplib0.Sexp.Atom "bin_prot_size_header_length"; sexp_of_int v__016_ ]
         and res3__027_ =
           let (`data_len v__017_) = arg3__022_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "data_len"; sexp_of_int v__017_ ]
         and res4__028_ =
           let (`total_len v__018_) = arg4__023_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "total_len"; sexp_of_int v__018_ ]
         in
         Sexplib0.Sexp.List [ res0__024_; res1__025_; res2__026_; res3__027_; res4__028_ ])
         [@merlin.hide]);
  pos_after_data
;;

let write_bin_prot t ?pos (writer : _ Bin_prot.Type_class.writer) v =
  let size = writer.size v in
  write_bin_prot_known_size t ?pos writer.write ~size v
;;

include Hexdump.Of_indexable (struct
    type nonrec t = t

    let length = length
    let get = get
  end)

let rec last_nonmatch_plus_one ~buf ~min_pos ~pos ~char =
  let pos' = pos - 1 in
  if pos' >= min_pos && Char.( = ) (get buf pos') char
  then last_nonmatch_plus_one ~buf ~min_pos ~pos:pos' ~char
  else pos
;;

let get_tail_padded_fixed_string ~padding t ~pos ~len () =
  let data_end =
    last_nonmatch_plus_one ~buf:t ~min_pos:pos ~pos:(pos + len) ~char:padding
  in
  get_string t ~pos ~len:(data_end - pos)
;;

let get_tail_padded_fixed_string_local ~padding t ~pos ~len () =
  let data_end =
    last_nonmatch_plus_one ~buf:t ~min_pos:pos ~pos:(pos + len) ~char:padding
  in
  let len = data_end - pos in
  Local.get_string t ~pos ~len
;;

let set_padded_fixed_string_failed ~head_or_tail ~value ~len =
  Printf.failwithf
    "Bigstring.set_%s_padded_fixed_string: %S is longer than %d"
    head_or_tail
    (globalize_string value)
    len
    ()
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let set_tail_padded_fixed_string ~padding t ~pos ~len value =
  let slen = String.length value in
  if slen > len then set_padded_fixed_string_failed ~head_or_tail:"tail" ~value ~len;
  From_string.blit ~src:value ~dst:t ~src_pos:0 ~dst_pos:pos ~len:slen;
  for i = pos + slen to pos + len - 1 do
    set t i padding
  done
;;

let rec first_nonmatch ~buf ~pos ~max_pos ~char =
  if pos <= max_pos && Char.( = ) (get buf pos) char
  then first_nonmatch ~buf ~pos:(Int.succ pos) ~max_pos ~char
  else pos
;;

let set_head_padded_fixed_string ~padding t ~pos ~len value =
  let slen = String.length value in
  if slen > len then set_padded_fixed_string_failed ~head_or_tail:"head" ~value ~len;
  From_string.blit ~src:value ~dst:t ~src_pos:0 ~dst_pos:(pos + len - slen) ~len:slen;
  for i = pos to pos + len - slen - 1 do
    set t i padding
  done
;;

let get_head_padded_fixed_string ~padding t ~pos ~len () =
  let data_begin = first_nonmatch ~buf:t ~pos ~max_pos:(pos + len - 1) ~char:padding in
  get_string t ~pos:data_begin ~len:(len - (data_begin - pos))
;;

let get_head_padded_fixed_string_local ~padding t ~pos ~len () =
  let data_begin = first_nonmatch ~buf:t ~pos ~max_pos:(pos + len - 1) ~char:padding in
  let len = len - (data_begin - pos) in
  Local.get_string t ~pos:data_begin ~len
;;

let quickcheck_generator = Base_quickcheck.Generator.bigstring
let quickcheck_observer = Base_quickcheck.Observer.bigstring
let quickcheck_shrinker = Base_quickcheck.Shrinker.bigstring
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
