let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"set_once.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "set_once.ml.before-ppx"
;;

module Stable = struct
  open Stable_internal

  module T = struct
    type 'a t =
      { mutable value : 'a Option.t
      ; mutable set_at : Source_code_position.Stable.V1.t
            [@compare.ignore] [@equal.ignore]
      }
    [@@deriving compare, equal]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__001_ b__002_ ->
        if Stdlib.( == ) a__001_ b__002_
        then 0
        else
          Option.compare
            (fun a__003_ (b__004_ [@merlin.hide]) ->
               (_cmp__a a__003_ b__004_ [@merlin.hide]))
            a__001_.value
            b__002_.value
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__005_ b__006_ ->
        if Stdlib.( == ) a__005_ b__006_
        then true
        else
          Option.equal
            (fun a__007_ (b__008_ [@merlin.hide]) ->
               (_cmp__a a__007_ b__008_ [@merlin.hide]))
            a__005_.value
            b__006_.value
      ;;

      let _ = equal
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module V1 = struct
    module Format = struct
      type 'a t = 'a option ref [@@deriving bin_io, sexp]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "set_once.ml.before-ppx:15:6")
              [ ( Bin_prot.Shape.Tid.of_string "t"
                , [ Bin_prot.Shape.Vid.of_string "a" ]
                , bin_shape_ref
                    (bin_shape_option
                       (Bin_prot.Shape.var
                          (Bin_prot.Shape.Location.of_string
                             "set_once.ml.before-ppx:15:18")
                          (Bin_prot.Shape.Vid.of_string "a"))) )
              ]
          in
          fun a ->
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
        ;;

        let _ = bin_shape_t

        let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
          fun _size_of_a v -> bin_size_ref (bin_size_option _size_of_a) v
        ;;

        let _ = bin_size_t

        let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
          fun _write_a buf ~pos v -> bin_write_ref (bin_write_option _write_a) buf ~pos v
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
          fun _of__a buf ~pos_ref vint ->
          (__bin_read_ref__ (bin_read_option _of__a)) buf ~pos_ref vint
        ;;

        let _ = __bin_read_t__

        let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
          fun _of__a buf ~pos_ref -> (bin_read_ref (bin_read_option _of__a)) buf ~pos_ref
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

        let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
          fun _of_a__009_ x__011_ -> ref_of_sexp (option_of_sexp _of_a__009_) x__011_
        ;;

        let _ = t_of_sexp

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__012_ x__013_ -> sexp_of_ref (sexp_of_option _of_a__012_) x__013_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T

    let of_format (v1 : 'a Format.t) : 'a t =
      { value = !v1
      ; set_at =
          { Ppx_here_lib.pos_fname = "set_once.ml.before-ppx"
          ; pos_lnum = 20
          ; pos_cnum = 469
          ; pos_bol = 399
          }
      }
    ;;

    let to_format (t : 'a t) : 'a Format.t = ref t.value

    include
      Binable.Of_binable1_without_uuid [@alert "-legacy"]
        (Format)
        (struct
          include T

          let of_binable = of_format
          let to_binable = to_format
        end)

    include
      Sexpable.Of_sexpable1
        (Format)
        (struct
          include T

          let of_sexpable = of_format
          let to_sexpable = to_format
        end)
  end
end

open! Import
module Unstable = Stable.V1
open Stable.T

type 'a t = 'a Stable.T.t [@@deriving compare, equal]

include struct
  let _ = fun (_ : 'a t) -> ()

  let compare
    : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
    =
    fun _cmp__a a__014_ b__015_ ->
    Stable.T.compare
      (fun a__016_ (b__017_ [@merlin.hide]) -> (_cmp__a a__016_ b__017_ [@merlin.hide]))
      a__014_
      b__015_
  ;;

  let _ = compare

  let equal
    : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
    =
    fun _cmp__a a__018_ b__019_ ->
    Stable.T.equal
      (fun a__020_ (b__021_ [@merlin.hide]) -> (_cmp__a a__020_ b__021_ [@merlin.hide]))
      a__018_
      b__019_
  ;;

  let _ = equal
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let sexp_of_t sexp_of_a { value; set_at } =
  match value with
  | None ->
    let ppx_sexp_message () =
      Ppx_sexp_conv_lib.Conv.sexp_of_string "unset"
        [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
    in
    (ppx_sexp_message () [@nontail])
  | Some value ->
    let ppx_sexp_message () =
      Ppx_sexp_conv_lib.Sexp.List
        [ Ppx_sexp_conv_lib.Sexp.List
            [ Ppx_sexp_conv_lib.Sexp.Atom "value"; (sexp_of_a [@merlin.hide]) value ]
        ; Ppx_sexp_conv_lib.Sexp.List
            [ Ppx_sexp_conv_lib.Sexp.Atom "set_at"
            ; Ppx_sexp_conv_lib.Conv.sexp_of_string
                (Source_code_position.to_string set_at)
            ]
        ]
        [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
    in
    (ppx_sexp_message () [@nontail])
;;

let invariant invariant_a t =
  match t.value with
  | None -> ()
  | Some a -> invariant_a a
;;

let create () =
  { value = None
  ; set_at =
      { Ppx_here_lib.pos_fname = "set_once.ml.before-ppx"
      ; pos_lnum = 64
      ; pos_cnum = 1390
      ; pos_bol = 1349
      }
  }
;;

let set_internal t here value =
  t.value <- Some value;
  t.set_at <- here
;;

let set_if_none t here value = if Option.is_none t.value then set_internal t here value

let set t here value =
  if Option.is_none t.value
  then (
    set_internal t here value;
    Ok ())
  else
    Or_error.error_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "[Set_once.set_exn] already set"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "setting_at"
               ; (Source_code_position.sexp_of_t [@merlin.hide]) here
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "previously_set_at"
               ; (Source_code_position.sexp_of_t [@merlin.hide]) t.set_at
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let set_exn t here value = Or_error.ok_exn (set t here value)
let get t = t.value

let get_exn (t : _ t) here =
  match t.value with
  | Some a -> a
  | None ->
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "[Set_once.get_exn] unset"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "at"
               ; (Source_code_position.sexp_of_t [@merlin.hide]) here
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
;;

let is_none t = Option.is_none t.value
let is_some t = Option.is_some t.value
let iter t ~f = Option.iter t.value ~f

module Optional_syntax = struct
  module Optional_syntax = struct
    let is_none = is_none

    let unsafe_value t =
      get_exn
        t
        { Ppx_here_lib.pos_fname = "set_once.ml.before-ppx"
        ; pos_lnum = 103
        ; pos_cnum = 2377
        ; pos_bol = 2342
        }
    ;;
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
