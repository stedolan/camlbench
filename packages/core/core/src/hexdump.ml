let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hexdump.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hexdump.ml.before-ppx"
;;

open! Import
module Char = Base.Char
module Int = Base.Int
module String = Base.String
include Hexdump_intf

let bytes_per_line = 16
let default_max_lines = ref ((4096 / bytes_per_line) + 1)

module Of_indexable2 (T : Indexable2) = struct
  module Hexdump = struct
    include T

    let hex_of_pos pos = Printf.sprintf "%08x" pos

    let hex_of_char t ~start ~until offset =
      let pos = start + offset in
      if pos >= until then "  " else Printf.sprintf "%02x" (Char.to_int (get t pos))
    ;;

    let hex_of_line t ~start ~until =
      Printf.sprintf
        "%s %s %s %s %s %s %s %s  %s %s %s %s %s %s %s %s"
        (hex_of_char t ~start ~until 0)
        (hex_of_char t ~start ~until 1)
        (hex_of_char t ~start ~until 2)
        (hex_of_char t ~start ~until 3)
        (hex_of_char t ~start ~until 4)
        (hex_of_char t ~start ~until 5)
        (hex_of_char t ~start ~until 6)
        (hex_of_char t ~start ~until 7)
        (hex_of_char t ~start ~until 8)
        (hex_of_char t ~start ~until 9)
        (hex_of_char t ~start ~until 10)
        (hex_of_char t ~start ~until 11)
        (hex_of_char t ~start ~until 12)
        (hex_of_char t ~start ~until 13)
        (hex_of_char t ~start ~until 14)
        (hex_of_char t ~start ~until 15)
    ;;

    let printable_string t ~start ~until =
      String.init (until - start) ~f:(fun i ->
        let char = get t (start + i) in
        if Char.is_print char then char else '.')
    ;;

    let line t ~pos ~len ~line_index =
      let start = pos + (line_index * bytes_per_line) in
      let until = min (start + bytes_per_line) (pos + len) in
      Printf.sprintf
        "%s  %s  |%s|"
        (hex_of_pos start)
        (hex_of_line t ~start ~until)
        (printable_string t ~start ~until)
    ;;

    let to_sequence ?max_lines ?pos ?len t =
      let (pos : int), (len : int) =
        Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
      in
      let max_lines =
        match max_lines with
        | Some max_lines -> max_lines
        | None -> !default_max_lines
      in
      let max_lines = max max_lines 3 in
      let unabridged_lines =
        Int.round_up len ~to_multiple_of:bytes_per_line / bytes_per_line
      in
      let skip_from = (max_lines - 1) / 2 in
      let skip_to = unabridged_lines - (max_lines - skip_from) + 1 in
      Sequence.unfold_step ~init:0 ~f:(fun line_index ->
        if line_index >= unabridged_lines
        then Done
        else if line_index = skip_from && max_lines < unabridged_lines
        then Yield { value = "..."; state = skip_to }
        else Yield { value = line t ~pos ~len ~line_index; state = line_index + 1 })
    ;;

    let to_string_hum ?max_lines ?pos ?len t =
      String.concat ~sep:"\n" (Sequence.to_list (to_sequence ?max_lines ?pos ?len t))
    ;;

    let sexp_of_t _ _ t =
      ((fun x__001_ -> sexp_of_list sexp_of_string x__001_) [@merlin.hide])
        (Sequence.to_list (to_sequence t))
    ;;

    module Pretty = struct
      include T

      let printable =
        let rec printable_from t ~pos ~length =
          pos >= length
          || (Char.is_print (get t pos) && printable_from t ~pos:(pos + 1) ~length)
        in
        fun t -> printable_from t ~pos:0 ~length:(length t)
      ;;

      let to_string t = String.init (length t) ~f:(fun pos -> get t pos)

      let sexp_of_t sexp_of_a sexp_of_b t =
        if printable t
        then (sexp_of_string [@merlin.hide]) (to_string t)
        else ((fun x__002_ -> sexp_of_t sexp_of_a sexp_of_b x__002_) [@merlin.hide]) t
      ;;
    end
  end
end

module Of_indexable1 (T : Indexable1) = struct
  module M = Of_indexable2 (struct
      type ('a, _) t = 'a T.t

      let length = T.length
      let get = T.get
    end)

  module Hexdump = struct
    include T

    let sexp_of_t x t =
      M.Hexdump.sexp_of_t x ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide]) t
    ;;

    let to_sequence = M.Hexdump.to_sequence
    let to_string_hum = M.Hexdump.to_string_hum

    module Pretty = struct
      include T

      let sexp_of_t sexp_of_a t =
        ((fun x__003_ ->
           M.Hexdump.Pretty.sexp_of_t sexp_of_a (fun _ -> Sexplib0.Sexp.Atom "_") x__003_)
           [@merlin.hide])
          t
      ;;
    end
  end
end

module Of_indexable (T : Indexable) = struct
  module M = Of_indexable1 (struct
      type _ t = T.t

      let length = T.length
      let get = T.get
    end)

  module Hexdump = struct
    include T

    let sexp_of_t t =
      M.Hexdump.sexp_of_t ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide]) t
    ;;

    let to_sequence = M.Hexdump.to_sequence
    let to_string_hum = M.Hexdump.to_string_hum

    module Pretty = struct
      include T

      let sexp_of_t t =
        ((fun x__004_ ->
           M.Hexdump.Pretty.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__004_)
           [@merlin.hide])
          t
      ;;
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
