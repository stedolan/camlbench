let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"uuid.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "uuid.ml.before-ppx"
;;

module Stable = struct
  open Core.Core_stable

  module V1 = struct
    module T = struct
      type t = string
      [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "uuid.ml.before-ppx:21:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_string
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_string
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_string__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_string
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

        let compare =
          (fun a__001_ b__002_ -> compare_string a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__003_ b__004_ -> equal_string a__003_ b__004_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_string hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash_string in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (string_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_string : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
        let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = string_sexp_grammar
        let _ = t_sexp_grammar

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : string Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_string
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include (val Comparator.V1.make ~compare ~sexp_of_t)
    end

    include T
    include Comparable.V1.With_stable_witness.Make (T)

    let for_testing = "5a863fc1-67b7-3a0a-dc90-aca2995afbf9"
    let to_string t = t
    let char_is_dash c = Core.Char.equal '-' c

    let is_valid_exn s =
      let open Core in
      assert (String.length s = 36);
      assert (String.count s ~f:char_is_dash = 4);
      assert (char_is_dash s.[8]);
      assert (char_is_dash s.[13]);
      assert (char_is_dash s.[18]);
      assert (char_is_dash s.[23])
    ;;

    let of_string s =
      try
        is_valid_exn s;
        s
      with
      | _ -> Core.failwithf "%s: not a valid UUID" s ()
    ;;
  end
end

open! Core

module T = struct
  type t = string [@@deriving bin_io, compare, hash]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "uuid.ml.before-ppx:68:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = bin_size_string
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = bin_write_string
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_string__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_string
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
      (fun a__006_ b__007_ -> compare_string a__006_ b__007_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> hash_fold_string hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = hash_string in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type comparator_witness = Stable.V1.comparator_witness

  let comparator = Stable.V1.comparator

  let next_counter =
    let counter = ref 0 in
    fun () ->
      incr counter;
      !counter
  ;;

  let set_all_dashes bytes =
    Bytes.set bytes 8 '-';
    Bytes.set bytes 13 '-';
    Bytes.set bytes 18 '-';
    Bytes.set bytes 23 '-'
  ;;

  let set_version bytes ~version = Bytes.set bytes 14 version
  let to_string = Stable.V1.to_string
  let of_string = Stable.V1.of_string

  let bottom_4_bits_to_hex_char v =
    let v = v land 0x0F in
    if v < 10 then Char.unsafe_of_int (48 + v) else Char.unsafe_of_int (87 + v)
  ;;

  let create_random =
    let bytes = Bytes.create 36 in
    fun random_state ->
      let at = ref 0 in
      for _ = 1 to 6 do
        let int = ref (Random.State.bits random_state) in
        for _ = 1 to 6 do
          Bytes.set bytes !at (bottom_4_bits_to_hex_char !int);
          incr at;
          int := !int lsr 4
        done
      done;
      set_all_dashes bytes;
      set_version bytes ~version:'4';
      Bytes.to_string bytes
  ;;

  let create ~hostname ~pid =
    let digest =
      let time = Time_ns.now () in
      let counter = next_counter () in
      let base =
        String.concat
          ~sep:"-"
          [ hostname
          ; Int.to_string pid
          ; Int.to_string (Time_ns.to_int_ns_since_epoch time)
          ; Int.to_string counter
          ]
      in
      Md5.to_hex (Md5.digest_string base)
    in
    let s = Bytes.create 36 in
    set_all_dashes s;
    Bytes.From_string.blit ~src:digest ~dst:s ~src_pos:0 ~dst_pos:0 ~len:8;
    Bytes.From_string.blit ~src:digest ~dst:s ~src_pos:8 ~dst_pos:9 ~len:4;
    Bytes.From_string.blit ~src:digest ~dst:s ~src_pos:12 ~dst_pos:14 ~len:4;
    Bytes.From_string.blit ~src:digest ~dst:s ~src_pos:16 ~dst_pos:19 ~len:4;
    Bytes.From_string.blit ~src:digest ~dst:s ~src_pos:20 ~dst_pos:24 ~len:12;
    set_version s ~version:'3';
    Bytes.to_string s
  ;;
end

include T

include Identifiable.Make_using_comparator (struct
    let module_name = "Uuid"

    include T
    include Sexpable.Of_stringable (T)
  end)

let invariant t = ignore (of_string t : t)
let nil = "00000000-0000-0000-0000-000000000000"

module Unstable = struct
  type nonrec t = t [@@deriving bin_io, compare, equal, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "uuid.ml.before-ppx:162:2")
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
      (fun a__008_ b__009_ -> compare a__008_ b__009_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__010_ b__011_ -> equal a__010_ b__011_ : t -> (t[@merlin.hide]) -> bool)
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

    let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type nonrec comparator_witness = comparator_witness

  let comparator = comparator
  let t_sexp_grammar = string_sexp_grammar
end

let arg_type = Command.Arg_type.create of_string

let sexp_of_t t =
  if am_running_test
  then Ppx_sexp_conv_lib.Conv.sexp_of_string "<uuid-omitted-in-test>"
  else (sexp_of_t [@merlin.hide]) t
;;

module Private = struct
  let create = create
  let is_valid_exn = Stable.V1.is_valid_exn
  let bottom_4_bits_to_hex_char = bottom_4_bits_to_hex_char
  let nil = nil
end

let quickcheck_shrinker : t Quickcheck.Shrinker.t = Quickcheck.Shrinker.empty ()
let quickcheck_observer : t Quickcheck.Observer.t = Quickcheck.Observer.of_hash (module T)

let quickcheck_generator : t Quickcheck.Generator.t =
  let open Quickcheck.Generator.Let_syntax in
  let gen_hex_digit : Char.t Quickcheck.Generator.t =
    Quickcheck.Generator.weighted_union
      [ 10.0, Char.gen_digit; 6.0, Char.gen_uniform_inclusive 'a' 'f' ]
  in
  let __let_syntax__013_ = String.gen_with_length 8 gen_hex_digit
  [@@ppxlib.do_not_enter_value]
  and __let_syntax__014_ = String.gen_with_length 4 gen_hex_digit
  [@@ppxlib.do_not_enter_value]
  and __let_syntax__015_ = String.gen_with_length 4 gen_hex_digit
  [@@ppxlib.do_not_enter_value]
  and __let_syntax__016_ = String.gen_with_length 4 gen_hex_digit
  [@@ppxlib.do_not_enter_value]
  and __let_syntax__017_ =
    String.gen_with_length 12 gen_hex_digit
      [@@ppxlib.do_not_enter_value]
  in
  Let_syntax.map
    (Let_syntax.both
       __let_syntax__013_
       (Let_syntax.both
          __let_syntax__014_
          (Let_syntax.both
             __let_syntax__015_
             (Let_syntax.both __let_syntax__016_ __let_syntax__017_))))
    ~f:(fun (first, (second, (third, (fourth, fifth)))) ->
      of_string (sprintf "%s-%s-%s-%s-%s" first second third fourth fifth))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
