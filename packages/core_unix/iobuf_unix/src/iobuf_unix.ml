let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"iobuf_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "iobuf_unix.ml.before-ppx"
;;

open! Core
open! Iobuf
module Unix = Core_unix
module File_descr = Unix.File_descr
module Syscall_result = Unix.Syscall_result

type ok_or_eof =
  | Ok
  | Eof
[@@deriving compare, sexp_of]

include struct
  let _ = fun (_ : ok_or_eof) -> ()

  let compare_ok_or_eof =
    (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
     : ok_or_eof -> (ok_or_eof[@merlin.hide]) -> int)
  ;;

  let _ = compare_ok_or_eof

  let sexp_of_ok_or_eof =
    (function
     | Ok -> Sexplib0.Sexp.Atom "Ok"
     | Eof -> Sexplib0.Sexp.Atom "Eof"
     : ok_or_eof -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_ok_or_eof
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let input t ch =
  match Bigstring_unix.input ch (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t) with
  | n ->
    unsafe_advance t n;
    Ok
  | exception Bigstring_unix.IOError (n, End_of_file) ->
    unsafe_advance t n;
    Eof
;;

let read t fd =
  match Bigstring_unix.read fd (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t) with
  | n ->
    unsafe_advance t n;
    Ok
  | exception Bigstring_unix.IOError (n, End_of_file) ->
    unsafe_advance t n;
    Eof
;;

let read_assume_fd_is_nonblocking t fd =
  let nread =
    Bigstring_unix.read_assume_fd_is_nonblocking
      fd
      (Expert.buf t)
      ~pos:(Expert.lo t)
      ~len:(length t)
  in
  if Syscall_result.Int.is_ok nread
  then unsafe_advance t (Syscall_result.Int.ok_exn nread);
  Syscall_result.ignore_ok_value nread
;;

let pread_assume_fd_is_nonblocking t fd ~offset =
  let nread =
    Bigstring_unix.pread_assume_fd_is_nonblocking
      fd
      ~offset
      (Expert.buf t)
      ~pos:(Expert.lo t)
      ~len:(length t)
  in
  unsafe_advance t nread
;;

let recvfrom_assume_fd_is_nonblocking t fd =
  let nread, sockaddr =
    Bigstring_unix.recvfrom_assume_fd_is_nonblocking
      fd
      (Expert.buf t)
      ~pos:(Expert.lo t)
      ~len:(length t)
  in
  unsafe_advance t nread;
  sockaddr
;;

module Recvmmsg_context = struct
  type t = unit

  let create = ignore
end

let recvmmsg_assume_fd_is_nonblocking =
  Or_error.unimplemented "Iobuf.recvmmsg_assume_fd_is_nonblocking"
;;

let unsafe_sent t result =
  if Syscall_result.Int.is_ok result
  then (
    unsafe_advance t (Syscall_result.Int.ok_exn result);
    Syscall_result.unit)
  else Syscall_result.Int.reinterpret_error_exn result
;;

let send_nonblocking_no_sigpipe () =
  match Bigstring_unix.send_nonblocking_no_sigpipe with
  | Error _ as e -> e
  | Ok send ->
    Ok
      (fun t fd ->
        unsafe_sent t (send fd (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t)))
;;

let sendto_nonblocking_no_sigpipe () =
  match Bigstring_unix.sendto_nonblocking_no_sigpipe with
  | Error _ as e -> e
  | Ok sendto ->
    Ok
      (fun t fd addr ->
        unsafe_sent t (sendto fd (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t) addr))
;;

module Peek = struct
  let output t ch =
    Bigstring_unix.output ch (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t)
  ;;

  let write t fd =
    Bigstring_unix.write fd (Expert.buf t) ~pos:(Expert.lo t) ~len:(length t)
  ;;

  let write_assume_fd_is_nonblocking t fd =
    Bigstring_unix.unsafe_write_assume_fd_is_nonblocking
      fd
      (Expert.buf t)
      ~pos:(Expert.lo t)
      ~len:(length t)
  ;;
end

let output t ch =
  let nwritten = Peek.output t ch in
  unsafe_advance t nwritten
;;

let write t fd =
  let nwritten = Peek.write t fd in
  unsafe_advance t nwritten
;;

let write_assume_fd_is_nonblocking t fd =
  let nwritten = Peek.write_assume_fd_is_nonblocking t fd in
  unsafe_advance t nwritten
;;

let pwrite_assume_fd_is_nonblocking t fd ~offset =
  let nwritten =
    Bigstring_unix.pwrite_assume_fd_is_nonblocking
      fd
      ~offset
      (Expert.buf t)
      ~pos:(Expert.lo t)
      ~len:(length t)
  in
  unsafe_advance t nwritten
;;

module Expert = struct
  external unsafe_pokef_float
    :  (read_write, _) t
    -> c_format:string
    -> max_length:int
    -> (float[@unboxed])
    -> int
    = "iobuf_unsafe_pokef_double_bytecode" "iobuf_unsafe_pokef_double"
  [@@noalloc]

  let fillf_float t ~c_format value =
    let limit = length t in
    let result = unsafe_pokef_float t ~c_format ~max_length:(length t) value in
    if result >= limit
    then `Truncated
    else if result < 0
    then `Format_error
    else (
      unsafe_advance t result;
      `Ok)
  ;;

  let to_iovec_shared ?pos ?len t =
    let pos, len =
      Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
    in
    Unix.IOVec.of_bigstring (Expert.buf t) ~pos:(Expert.lo t + pos) ~len
  ;;
end

module In_channel_optimized = struct
  let next_newline buf =
    let len = Iobuf.length buf in
    Iobuf.Unsafe.Peek.index_or_neg ~pos:0 buf ~len '\n'
  ;;

  let present_line ~fix_win_eol ~acc ~f buf ~len =
    let len_of_line =
      if
        fix_win_eol
        && len > 0
        && Char.equal '\r' (Iobuf.Unsafe.Peek.char ~pos:(len - 1) buf)
      then len - 1
      else len
    in
    Iobuf.unsafe_resize buf ~len:len_of_line;
    f acc buf
  ;;

  let rec fold_full_lines_in_buf ~fix_win_eol ~acc ~f buf =
    let len = next_newline buf in
    if len >= 0
    then (
      let hi = Iobuf.Expert.hi buf in
      let lo = Iobuf.Expert.lo buf in
      let next_line_starts_at = lo + len + 1 in
      let acc = present_line ~acc ~f ~fix_win_eol buf ~len in
      Iobuf.Expert.set_lo buf next_line_starts_at;
      Iobuf.Expert.set_hi buf hi;
      fold_full_lines_in_buf ~fix_win_eol ~acc ~f buf)
    else acc
  ;;

  let fold_lines_raw ?(fix_win_eol = true) ?(buf = Iobuf.create ~len:1024) ch ~init ~f =
    Iobuf.reset buf;
    let acc = ref init in
    while
      let result = input buf ch in
      Iobuf.flip_lo buf;
      acc := fold_full_lines_in_buf ~fix_win_eol ~acc:!acc ~f buf;
      let length = Iobuf.length buf in
      let capacity = Iobuf.capacity buf in
      if length = capacity
      then (
        let new_capacity = max 1024 (capacity * 2) in
        let str = Bigstring.create new_capacity in
        Iobuf.Consume.To_bigstring.blito ~src:(Iobuf.read_only buf) ~dst:str ();
        Iobuf.Expert.reinitialize_of_bigstring ~pos:0 ~len:new_capacity buf str;
        Iobuf.resize buf ~len:length);
      Iobuf.compact buf;
      match result with
      | Ok -> true
      | Eof -> false
    do
      ()
    done;
    if Iobuf.length buf < Iobuf.capacity buf
    then (
      Iobuf.flip_lo buf;
      acc := present_line ~fix_win_eol ~acc:!acc ~f buf ~len:(Iobuf.length buf));
    !acc
  ;;

  let fold_lines ?fix_win_eol ?buf ch ~init ~f =
    fold_lines_raw ?fix_win_eol ?buf ch ~init ~f:(fun acc buf ->
      f acc (Iobuf.Unsafe.Peek.stringo buf ~pos:0))
  ;;

  let iter_lines ?fix_win_eol ?buf ch ~f =
    fold_lines ?fix_win_eol ?buf ch ~init:() ~f:(fun () s -> f s)
  ;;

  let input_lines ?fix_win_eol ?buf ch =
    let v = Queue.create () in
    iter_lines ?fix_win_eol ?buf ch ~f:(fun str -> Queue.enqueue v str);
    Queue.to_array v
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
