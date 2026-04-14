let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"sexp.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "sexp.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    include struct
      type t = Base.Sexp.t
      [@@deriving compare ~localize, equal ~localize, globalize, hash]

      include struct
        let _ = fun (_ : t) -> ()

        let compare__local =
          (fun a__001_ b__002_ -> Base.Sexp.compare__local a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare__local
        let compare = (fun a b -> compare__local a b : t -> (t[@merlin.hide]) -> int)
        let _ = compare

        let equal__local =
          (fun a__003_ b__004_ -> Base.Sexp.equal__local a__003_ b__004_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal__local
        let equal = (fun a b -> equal__local a b : t -> (t[@merlin.hide]) -> bool)
        let _ = equal
        let globalize : t -> t = (Base.Sexp.globalize : t -> t)
        let _ = globalize

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Sexp.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Sexp.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    type t = Base.Sexp.t =
      | Atom of string
      | List of t list
    [@@deriving bin_io, stable_witness]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:11:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.variant
                  [ "Atom", [ bin_shape_string ]
                  ; ( "List"
                    , [ bin_shape_list
                          ((Bin_prot.Shape.rec_app (Bin_prot.Shape.Tid.of_string "t")) [])
                      ] )
                  ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let rec bin_size_t : t Bin_prot.Size.sizer = function
        | Atom v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_string v1)
        | List v1 ->
          let size = 1 in
          Bin_prot.Common.( + ) size (bin_size_list bin_size_t v1)
      ;;

      let _ = bin_size_t

      let rec bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | Atom v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
          bin_write_string buf ~pos v1
        | List v1 ->
          let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
          bin_write_list bin_write_t buf ~pos v1
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type "sexp.ml.before-ppx.Stable.V1.t" !pos_ref

      and bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
        | 0 ->
          let arg_1 = bin_read_string buf ~pos_ref in
          Atom arg_1
        | 1 ->
          let arg_1 = (bin_read_list bin_read_t) buf ~pos_ref in
          List arg_1
        | _ ->
          Bin_prot.Common.raise_read_error
            (Bin_prot.Common.ReadError.Sum_tag "sexp.ml.before-ppx.Stable.V1.t")
            !pos_ref
      ;;

      let _ = __bin_read_t__
      and _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let rec stable_witness =
        (Ppx_stable_witness_runtime.Stable_witness.assert_stable
         : t Ppx_stable_witness_runtime.Stable_witness.t)

      and __stable_witness_checks_for_t__ () =
        let _ : string Ppx_stable_witness_runtime.Stable_witness.t = stable_witness_string
        and _
          :  t Ppx_stable_witness_runtime.Stable_witness.t
          -> t list Ppx_stable_witness_runtime.Stable_witness.t
          =
          stable_witness_list
        and _ : t Ppx_stable_witness_runtime.Stable_witness.t = stable_witness in
        ()
      ;;

      let _ = stable_witness
      and _ = __stable_witness_checks_for_t__
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let t_sexp_grammar = Sexplib.Sexp.t_sexp_grammar
    let t_of_sexp = Sexplib.Sexp.t_of_sexp
    let sexp_of_t = Sexplib.Sexp.sexp_of_t
  end
end

include Stable.V1

include (
  Base.Sexp :
    module type of struct
      include Base.Sexp
    end
    with type t := t)

include (
  Sexplib.Sexp :
    module type of struct
      include Sexplib.Sexp
    end
    with type t := t)

module O = struct
  type sexp = Base.Sexp.t =
    | Atom of string
    | List of t list
end

module Sexp_maybe = struct
  type nonrec 'a t = ('a, t * Error.t) Result.t [@@deriving bin_io, compare, hash]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:45:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , (Result.bin_shape_t
                 (Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:45:22")
                    (Bin_prot.Shape.Vid.of_string "a")))
                (Bin_prot.Shape.tuple [ bin_shape_t; Error.bin_shape_t ]) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a v ->
      Result.bin_size_t
        _size_of_a
        (function
          | v1, v2 ->
            let size = 0 in
            let size = Bin_prot.Common.( + ) size (bin_size_t v1) in
            Bin_prot.Common.( + ) size (Error.bin_size_t v2))
        v
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos v ->
      Result.bin_write_t
        _write_a
        (fun buf ~pos -> function
           | v1, v2 ->
             let pos = bin_write_t buf ~pos v1 in
             Error.bin_write_t buf ~pos v2)
        buf
        ~pos
        v
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

    let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint ->
      (Result.__bin_read_t__ _of__a (fun buf ~pos_ref ->
         let v1 = bin_read_t buf ~pos_ref in
         let v2 = Error.bin_read_t buf ~pos_ref in
         v1, v2))
        buf
        ~pos_ref
        vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref ->
      (Result.bin_read_t _of__a (fun buf ~pos_ref ->
         let v1 = bin_read_t buf ~pos_ref in
         let v2 = Error.bin_read_t buf ~pos_ref in
         v1, v2))
        buf
        ~pos_ref
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
      fun _cmp__a a__006_ b__007_ ->
      Result.compare
        (fun a__008_ (b__009_ [@merlin.hide]) -> (_cmp__a a__008_ b__009_ [@merlin.hide]))
        (fun a__010_ (b__011_ [@merlin.hide]) ->
           ((let t__012_, t__013_ = a__010_ in
             let t__014_, t__015_ = b__011_ in
             match compare t__012_ t__014_ with
             | 0 -> Error.compare t__013_ t__015_
             | n -> n)
           [@merlin.hide]))
        a__006_
        b__007_
    ;;

    let _ = compare

    let hash_fold_t
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      Result.hash_fold_t
        (fun hsv arg -> _hash_fold_a hsv arg)
        (fun hsv arg ->
           let e0, e1 = arg in
           let hsv = hash_fold_t hsv e0 in
           let hsv = Error.hash_fold_t hsv e1 in
           hsv)
        hsv
        arg
    ;;

    let _ = hash_fold_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let sexp_of_t sexp_of_a t =
    match t with
    | Result.Ok a -> sexp_of_a a
    | Result.Error (sexp, err) ->
      List [ Atom "sexp_parse_error"; sexp; Error.sexp_of_t err ]
  ;;

  let t_of_sexp a_of_sexp sexp =
    match sexp with
    | List [ Atom "sexp_parse_error"; sexp; _ ] | sexp ->
      (try Result.Ok (a_of_sexp sexp) with
       | exn -> Result.Error (sexp, Error.of_exn exn))
  ;;

  let t_sexp_grammar (grammar : _ Sexplib.Sexp_grammar.t) : _ t Sexplib.Sexp_grammar.t =
    { untyped = Union [ grammar.untyped; Base.Sexp.t_sexp_grammar.untyped ] }
  ;;
end

module With_text = struct
  open Result.Export

  type 'a t =
    { value : 'a
    ; text : string
    }
  [@@deriving bin_io]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:69:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Bin_prot.Shape.record
                [ ( "value"
                  , Bin_prot.Shape.var
                      (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:70:14")
                      (Bin_prot.Shape.Vid.of_string "a") )
                ; "text", bin_shape_string
                ] )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
    ;;

    let _ = bin_shape_t

    let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
      fun _size_of_a -> function
      | { value = v1; text = v2 } ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (_size_of_a v1) in
        Bin_prot.Common.( + ) size (bin_size_string v2)
    ;;

    let _ = bin_size_t

    let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
      fun _write_a buf ~pos -> function
      | { value = v1; text = v2 } ->
        let pos = _write_a buf ~pos v1 in
        bin_write_string buf ~pos v2
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

    let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader
      =
      fun _of__a _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "sexp.ml.before-ppx.With_text.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref ->
      let v_value = _of__a buf ~pos_ref in
      let v_text = bin_read_string buf ~pos_ref in
      { value = v_value; text = v_text }
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let sexp_of_t _ t = Atom t.text

  let of_text value_of_sexp ?(filename = "") text =
    match Or_error.try_with (fun () -> of_string_conv text value_of_sexp) with
    | Ok (`Result value) -> Ok { value; text }
    | Error _ as err -> err
    | Ok (`Error (exn, annotated)) ->
      Error (Error.of_exn (Annotated.get_conv_exn annotated ~file:filename ~exc:exn))
  ;;

  let t_of_sexp a_of_sexp sexp =
    match sexp with
    | List _ ->
      of_sexp_error
        "With_text.t should be stored as an atom, but instead a list was found."
        sexp
    | Atom text -> Or_error.ok_exn (of_text a_of_sexp text)
  ;;

  let t_sexp_grammar _ = Sexplib.Sexp_grammar.coerce Base.String.t_sexp_grammar
  let text t = t.text
  let value t = t.value

  let of_value sexp_of_value value =
    let text = to_string_hum (sexp_of_value value) in
    { value; text }
  ;;
end

type 'a no_raise = 'a [@@deriving bin_io, sexp]

include struct
  let _ = fun (_ : 'a no_raise) -> ()

  let bin_shape_no_raise =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:104:0")
        [ ( Bin_prot.Shape.Tid.of_string "no_raise"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , Bin_prot.Shape.var
              (Bin_prot.Shape.Location.of_string "sexp.ml.before-ppx:104:19")
              (Bin_prot.Shape.Vid.of_string "a") )
        ]
    in
    fun a ->
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "no_raise")) [ a ]
  ;;

  let _ = bin_shape_no_raise

  let bin_size_no_raise : 'a. 'a Bin_prot.Size.sizer -> 'a no_raise Bin_prot.Size.sizer =
    fun _size_of_a -> _size_of_a
  ;;

  let _ = bin_size_no_raise

  let bin_write_no_raise
    : 'a. 'a Bin_prot.Write.writer -> 'a no_raise Bin_prot.Write.writer
    =
    fun _write_a -> _write_a
  ;;

  let _ = bin_write_no_raise

  let bin_writer_no_raise =
    (fun bin_writer_a ->
       { size = (fun v -> bin_size_no_raise bin_writer_a.size v)
       ; write = (fun v -> bin_write_no_raise bin_writer_a.write v)
       }
     : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_no_raise

  let __bin_read_no_raise__
    : 'a. 'a Bin_prot.Read.reader -> (int -> 'a no_raise) Bin_prot.Read.reader
    =
    fun _of__a _buf ~pos_ref _vint ->
    Bin_prot.Common.raise_read_error
      (Bin_prot.Common.ReadError.Silly_type "sexp.ml.before-ppx.no_raise")
      !pos_ref
  ;;

  let _ = __bin_read_no_raise__

  let bin_read_no_raise : 'a. 'a Bin_prot.Read.reader -> 'a no_raise Bin_prot.Read.reader =
    fun _of__a -> _of__a
  ;;

  let _ = bin_read_no_raise

  let bin_reader_no_raise =
    (fun bin_reader_a ->
       { read = (fun buf ~pos_ref -> (bin_read_no_raise bin_reader_a.read) buf ~pos_ref)
       ; vtag_read =
           (fun buf ~pos_ref vtag ->
             (__bin_read_no_raise__ bin_reader_a.read) buf ~pos_ref vtag)
       }
     : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
  ;;

  let _ = bin_reader_no_raise

  let bin_no_raise =
    (fun bin_a ->
       { writer = bin_writer_no_raise bin_a.writer
       ; reader = bin_reader_no_raise bin_a.reader
       ; shape = bin_shape_no_raise bin_a.shape
       }
     : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
  ;;

  let _ = bin_no_raise

  let no_raise_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a no_raise =
    fun _of_a__016_ -> _of_a__016_
  ;;

  let _ = no_raise_of_sexp

  let sexp_of_no_raise : 'a. ('a -> Sexplib0.Sexp.t) -> 'a no_raise -> Sexplib0.Sexp.t =
    fun _of_a__018_ -> _of_a__018_
  ;;

  let _ = sexp_of_no_raise
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sexp_of_no_raise sexp_of_a a =
  try sexp_of_a a with
  | exn ->
    (try List [ Atom "failure building sexp"; sexp_of_exn exn ] with
     | _ -> Atom "could not build sexp for exn raised when building sexp for value")
;;

include Comparable.Extend (Base.Sexp) (Base.Sexp)

let of_sexp_allow_extra_fields_recursively of_sexp sexp =
  let r = Sexplib.Conv.record_check_extra_fields in
  let prev = !r in
  Exn.protect
    ~finally:(fun () -> r := prev)
    ~f:(fun () ->
      r := false;
      of_sexp sexp)
;;

let quickcheck_generator = Base_quickcheck.Generator.sexp
let quickcheck_observer = Base_quickcheck.Observer.sexp
let quickcheck_shrinker = Base_quickcheck.Shrinker.sexp
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
