let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"list.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "list.ml.before-ppx"
;;

include List0 [@@ocaml.doc " @inline "]

let stable_dedup_staged (type a) ~(compare : a -> a -> int)
  : (a list -> a list) Base.Staged.t
  =
  let module Set = Set.Make (struct
      type t = a

      let compare = compare
      let t_of_sexp _ = assert false
      let sexp_of_t _ = assert false
    end)
  in
  (Base.Staged.stage Set.stable_dedup_list [@alert "-deprecated"])
;;

let zip_with_remainder =
  let rec zip_with_acc_and_remainder acc xs ys =
    match xs, ys with
    | [], [] -> rev acc, None
    | fst, [] -> rev acc, Some (Either.First fst)
    | [], snd -> rev acc, Some (Either.Second snd)
    | x :: xs, y :: ys -> zip_with_acc_and_remainder ((x, y) :: acc) xs ys
  in
  fun xs ys -> zip_with_acc_and_remainder [] xs ys
;;

type sexp_thunk = unit -> Base.Sexp.t

let sexp_of_sexp_thunk x = x ()

exception Duplicate_found of sexp_thunk * Base.String.t [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Duplicate_found]
      (function
      | Duplicate_found (arg0__001_, arg1__002_) ->
        let res0__003_ = sexp_of_sexp_thunk arg0__001_
        and res1__004_ = Base.String.sexp_of_t arg1__002_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "list.ml.before-ppx.Duplicate_found"
          ; res0__003_
          ; res1__004_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let exn_if_dup ~compare ?(context = "exn_if_dup") t ~to_sexp =
  match find_a_dup ~compare t with
  | None -> ()
  | Some dup -> raise (Duplicate_found ((fun () -> to_sexp dup), context))
;;

let slice a start stop =
  Ordered_collection_common.slice ~length_fun:(length :> _ -> _) ~sub_fun:sub a start stop
;;

module Stable = struct
  module V1 = struct
    type nonrec 'a t = 'a t
    [@@deriving sexp, sexp_grammar, bin_io ~localize, compare, equal, hash]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__005_ x__007_ -> t_of_sexp _of_a__005_ x__007_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__008_ x__009_ -> sexp_of_t _of_a__008_ x__009_
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
        fun _'a_sexp_grammar -> t_sexp_grammar _'a_sexp_grammar
      ;;

      let _ = t_sexp_grammar

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "list.ml.before-ppx:51:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "a" ]
              , bin_shape_t
                  (Bin_prot.Shape.var
                     (Bin_prot.Shape.Location.of_string "list.ml.before-ppx:51:23")
                     (Bin_prot.Shape.Vid.of_string "a")) )
            ]
        in
        fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
        =
        fun _size_of_a__local v -> bin_size_t__local _size_of_a__local v
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
        fun _size_of_a v -> bin_size_t _size_of_a v
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
        =
        fun _write_a__local buf ~pos v -> bin_write_t__local _write_a__local buf ~pos v
      ;;

      let _ = bin_write_t__local

      let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
        fun _write_a buf ~pos v -> bin_write_t _write_a buf ~pos v
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_a ->
           { size = (fun v -> bin_size_t bin_writer_a.size v)
           ; write = (fun v -> bin_write_t bin_writer_a.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
        =
        fun _of__a buf ~pos_ref vint -> (__bin_read_t__ _of__a) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t__

      let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
        fun _of__a buf ~pos_ref -> (bin_read_t _of__a) buf ~pos_ref
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_a ->
           { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_a ->
           { writer = bin_writer_t bin_a.writer
           ; reader = bin_reader_t bin_a.reader
           ; shape = bin_shape_t bin_a.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__010_ b__011_ ->
        compare
          (fun a__012_ (b__013_ [@merlin.hide]) ->
             (_cmp__a a__012_ b__013_ [@merlin.hide]))
          a__010_
          b__011_
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__014_ b__015_ ->
        equal
          (fun a__016_ (b__017_ [@merlin.hide]) ->
             (_cmp__a a__016_ b__017_ [@merlin.hide]))
          a__014_
          b__015_
      ;;

      let _ = equal

      let hash_fold_t
        :  'a.
           (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
        =
        fun _hash_fold_a hsv arg ->
        hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
      ;;

      let _ = hash_fold_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let stable_witness = List0.stable_witness [@@alert "-for_internal_use_only"]
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
