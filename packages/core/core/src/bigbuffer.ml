let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"bigbuffer.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "bigbuffer.ml.before-ppx"
;;

open! Import
open Bigstring
include Bigbuffer_internal

let __internal (t : t) = t
let length t = t.pos

let create n =
  let n = max 1 n in
  let bstr = Bigstring.create n in
  { bstr; pos = 0; len = n; init = bstr }
;;

let contents buf = Bigstring.to_string buf.bstr ~len:buf.pos
let contents_bytes buf = Bigstring.to_bytes buf.bstr ~len:buf.pos
let big_contents buf = subo ~len:buf.pos buf.bstr
let volatile_contents buf = buf.bstr

let add_char buf c =
  let pos = buf.pos in
  if pos >= buf.len then resize buf 1;
  buf.bstr.{pos} <- c;
  buf.pos <- pos + 1
;;

module To_bytes =
  Test_blit.Make_distinct_and_test
    (struct
      type t = char

      let equal = Char.equal
      let of_bool b = if b then 'a' else 'b'
    end)
    (struct
      type nonrec t = t [@@deriving sexp_of]

      include struct
        let _ = fun (_ : t) -> ()
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let create ~len =
        let t = create len in
        for _ = 1 to len do
          add_char t 'a'
        done;
        t
      ;;

      let length = length
      let set t i c = Bigstring.set t.bstr i c
      let get t i = Bigstring.get t.bstr i
    end)
    (struct
      include Bytes

      let create ~len = create len

      let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
        Bigstring.To_bytes.unsafe_blit ~src:src.bstr ~src_pos ~dst ~dst_pos ~len
      ;;
    end)

include To_bytes
module To_string = Blit.Make_to_string (Bigbuffer_internal) (To_bytes)

let nth buf pos =
  if pos < 0 || pos >= buf.pos then invalid_arg "Bigbuffer.nth" else buf.bstr.{pos}
;;

let clear buf = buf.pos <- 0

let reset buf =
  buf.pos <- 0;
  buf.bstr <- buf.init;
  buf.len <- Bigstring.length buf.bstr
;;

let add_substring buf src ~pos:src_pos ~len =
  if src_pos < 0 || len < 0 || src_pos > String.length src - len
  then invalid_arg "Bigbuffer.add_substring";
  let new_pos = buf.pos + len in
  if new_pos > buf.len then resize buf len;
  Bigstring.From_string.blit ~src ~src_pos ~len ~dst:buf.bstr ~dst_pos:buf.pos;
  buf.pos <- new_pos
;;

let add_subbytes buf src ~pos:src_pos ~len =
  if src_pos < 0 || len < 0 || src_pos > Bytes.length src - len
  then invalid_arg "Bigbuffer.add_subbytes";
  let new_pos = buf.pos + len in
  if new_pos > buf.len then resize buf len;
  Bigstring.From_bytes.blit ~src ~src_pos ~len ~dst:buf.bstr ~dst_pos:buf.pos;
  buf.pos <- new_pos
;;

let add_bigstring buf src =
  let len = Bigstring.length src in
  let new_pos = buf.pos + len in
  if new_pos > buf.len then resize buf len;
  Bigstring.blito ~src ~src_len:len ~dst:buf.bstr ~dst_pos:buf.pos ();
  buf.pos <- new_pos
;;

let add_string buf src =
  let len = String.length src in
  let new_pos = buf.pos + len in
  if new_pos > buf.len then resize buf len;
  Bigstring.From_string.blito ~src ~src_len:len ~dst:buf.bstr ~dst_pos:buf.pos ();
  buf.pos <- new_pos
;;

let add_bytes buf src =
  let len = Bytes.length src in
  let new_pos = buf.pos + len in
  if new_pos > buf.len then resize buf len;
  Bigstring.From_bytes.blito ~src ~src_len:len ~dst:buf.bstr ~dst_pos:buf.pos ();
  buf.pos <- new_pos
;;

let add_buffer buf_dst buf_src =
  let len = buf_src.pos in
  let dst_pos = buf_dst.pos in
  let new_pos = dst_pos + len in
  if new_pos > buf_dst.len then resize buf_dst len;
  Bigstring.blito ~src:buf_src.bstr ~src_len:len ~dst:buf_dst.bstr ~dst_pos ();
  buf_dst.pos <- new_pos
;;

let add_bin_prot t (writer : _ Bin_prot.Type_class.writer) x =
  let new_pos =
    match writer.write t.bstr ~pos:t.pos x with
    | pos -> pos
    | exception _ ->
      let size = writer.size x in
      if t.pos + size > t.len then resize t size;
      writer.write t.bstr ~pos:t.pos x
  in
  t.pos <- new_pos
;;

let closing = function
  | '(' -> ')'
  | '{' -> '}'
  | _ -> assert false
;;

let advance_to_closing opening closing k s start =
  let rec advance k i lim =
    if i >= lim
    then
      raise
        (Not_found_s
           (let ppx_sexp_message () =
              Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                    "Bigbuffer.add_substitute: cannot find closing delimiter"
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "opening"
                    ; (sexp_of_char [@merlin.hide]) opening
                    ]
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "closing"
                    ; (sexp_of_char [@merlin.hide]) closing
                    ]
                ; Ppx_sexp_conv_lib.Sexp.List
                    [ Ppx_sexp_conv_lib.Sexp.Atom "start"
                    ; (sexp_of_int [@merlin.hide]) start
                    ]
                ; Ppx_sexp_conv_lib.Conv.sexp_of_string s
                ]
                [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
            in
            (ppx_sexp_message () [@nontail])))
    else if Char.equal s.[i] opening
    then advance (k + 1) (i + 1) lim
    else if Char.equal s.[i] closing
    then if k = 0 then i else advance (k - 1) (i + 1) lim
    else advance k (i + 1) lim
  in
  advance k start (String.length s)
;;

let advance_to_non_alpha s start =
  let rec advance i lim =
    if i >= lim
    then lim
    else (
      match s.[i] with
      | 'a' .. 'z'
      | 'A' .. 'Z'
      | '0' .. '9'
      | '_'
      | '\233'
      | '\224'
      | '\225'
      | '\232'
      | '\249'
      | '\226'
      | '\234'
      | '\238'
      | '\244'
      | '\251'
      | '\235'
      | '\239'
      | '\252'
      | '\231'
      | '\201'
      | '\192'
      | '\193'
      | '\200'
      | '\217'
      | '\194'
      | '\202'
      | '\206'
      | '\212'
      | '\219'
      | '\203'
      | '\207'
      | '\220'
      | '\199' -> advance (i + 1) lim
      | _ -> i)
  in
  advance start (String.length s)
;;

let find_ident s start =
  match s.[start] with
  | ('(' | '{') as c ->
    let new_start = start + 1 in
    let stop = advance_to_closing c (closing c) 0 s new_start in
    String.sub s ~pos:new_start ~len:(stop - start - 1), stop + 1
  | _ ->
    let stop = advance_to_non_alpha s (start + 1) in
    String.sub s ~pos:start ~len:(stop - start), stop
;;

let add_substitute buf f s =
  let lim = String.length s in
  let rec subst previous i =
    if i < lim
    then (
      match s.[i] with
      | '$' as current when Char.equal previous '\\' ->
        add_char buf current;
        subst current (i + 1)
      | '$' ->
        let ident, next_i = find_ident s (i + 1) in
        add_string buf (f ident);
        subst ' ' next_i
      | current when Char.equal previous '\\' ->
        add_char buf '\\';
        add_char buf current;
        subst current (i + 1)
      | '\\' as current -> subst current (i + 1)
      | current ->
        add_char buf current;
        subst current (i + 1))
  in
  subst ' ' 0
;;

module Format = struct
  let formatter_of_buffer buf =
    Format.make_formatter (fun s pos len -> add_substring buf s ~pos ~len) ignore
  ;;

  let bprintf buf = Format.kfprintf ignore (formatter_of_buffer buf)
end

module Printf = struct
  let bprintf buf = Printf.ksprintf (add_string buf)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
