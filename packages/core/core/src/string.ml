let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"string.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "string.ml.before-ppx"
;;

open! Import
include Base.String

module Stable = struct
  module V1 = struct
    module T = struct
      include Base.String

      type t = string [@@deriving bin_io ~localize, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:12:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_string__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_string__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
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
    end

    include T

    let to_string = Fn.id
    let of_string = Fn.id

    include Comparable.Stable.V1.With_stable_witness.Make (T)
    include Hashable.Stable.V1.With_stable_witness.Make (T)
    include Diffable.Atomic.Make (T)
  end

  module Make_utf (Utf : sig
      type t [@@deriving sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Base.Identifiable.S with type t := t

      val caller_identity : Bin_shape.Uuid.t
    end) =
  struct
    module V1 = struct
      module T = struct
        include Utf

        include
          Binable0.Of_binable_with_uuid
            (struct
              type t = string [@@deriving bin_io]

              include struct
                let _ = fun (_ : t) -> ()

                let bin_shape_t =
                  let _group =
                    Bin_prot.Shape.group
                      (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:40:14")
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
                  ({ size = bin_size_t; write = bin_write_t }
                   : _ Bin_prot.Type_class.writer)
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
              end [@@ocaml.doc "@inline"] [@@merlin.hide]
            end)
            (struct
              type t = Utf.t

              let of_binable = Utf.of_string
              let to_binable = Utf.to_string
              let caller_identity = Utf.caller_identity
            end)

        let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
      end

      include T
      include Comparable.Stable.V1.With_stable_witness.Make (T)
      include Hashable.Stable.V1.With_stable_witness.Make (T)
    end
  end

  module Utf8 = Make_utf (struct
      include Utf8

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "5bc29e13-1c6f-4b6d-b431-3befb256ebda"
      ;;
    end)

  module Utf16le = Make_utf (struct
      include Utf16le

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "7a4f8cac-8fff-11ee-bd11-aaa233d0b6a7"
      ;;
    end)

  module Utf16be = Make_utf (struct
      include Utf16be

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "7c3a50ce-8fff-11ee-94c6-aaa233d0b6a7"
      ;;
    end)

  module Utf32le = Make_utf (struct
      include Utf32le

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "961d2214-9252-11ee-9f77-aaa233d0b6a7"
      ;;
    end)

  module Utf32be = Make_utf (struct
      include Utf32be

      let caller_identity =
        Bin_prot.Shape.Uuid.of_string "9fcbae5c-9252-11ee-9f34-aaa233d0b6a7"
      ;;
    end)
end

module Caseless = struct
  module T = struct
    include Caseless

    type t = string [@@deriving bin_io ~localize]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:104:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_string__local
      let _ = bin_size_t__local
      let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t
      let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_string__local
      let _ = bin_write_t__local
      let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
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
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  include T
  include Comparable.Make_binable_using_comparator (T)
  include Hashable.Make_binable (T)
end

type t = string [@@deriving bin_io ~localize, typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:112:0")
        [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
  ;;

  let _ = bin_shape_t
  let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_string__local
  let _ = bin_size_t__local
  let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
  let _ = bin_size_t
  let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_string__local
  let _ = bin_write_t__local
  let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
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

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "string.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_string))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Identifiable.Extend
    (struct
      include Base.String

      let hashable = Stable.V1.hashable
    end)
    (struct
      type t = string [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:122:6")
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
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)

include Comparable.Validate (Base.String)

include Diffable.Atomic.Make (struct
    type nonrec t = t [@@deriving sexp, bin_io, equal]

    include struct
      let _ = fun (_ : t) -> ()
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "string.ml.before-ppx:128:2")
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

      let equal =
        (fun a__002_ b__003_ -> equal a__002_ b__003_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

include Hexdump.Of_indexable (struct
    type t = string

    let length = length
    let get = get
  end)

let quickcheck_generator = Base_quickcheck.Generator.string
let quickcheck_observer = Base_quickcheck.Observer.string
let quickcheck_shrinker = Base_quickcheck.Shrinker.string
let gen_nonempty = Base_quickcheck.Generator.string_non_empty
let gen' = Base_quickcheck.Generator.string_of
let gen_nonempty' = Base_quickcheck.Generator.string_non_empty_of

let gen_with_length length chars =
  Base_quickcheck.Generator.string_with_length_of chars ~length
;;

let take_while t ~f =
  match lfindi t ~f:(fun _ elt -> not (f elt)) with
  | None -> t
  | Some i -> sub t ~pos:0 ~len:i
;;

let rtake_while t ~f =
  match rfindi t ~f:(fun _ elt -> not (f elt)) with
  | None -> t
  | Some i -> sub t ~pos:(i + 1) ~len:(length t - i - 1)
;;

let normalize t i = Ordered_collection_common.normalize ~length_fun:length t i
[@@ocaml.doc " See {!Array.normalize} for the following 4 functions. "]
;;

let slice t start stop =
  Ordered_collection_common.slice ~length_fun:length ~sub_fun:sub t start stop
;;

let nget x i =
  let module String = Base.String in
  x.[normalize x i]
;;

module type Utf = sig
  include Utf

  include
    Identifiable.S with type t := t and type comparator_witness := comparator_witness

  include Quickcheckable.S with type t := t
end

module type Utf_as_string = Utf with type t = private string

module Extend_utf (Utf : Base.String.Utf) (B : Binable0.S with type t = Utf.t) :
  Utf with type t = Utf.t and type comparator_witness = Utf.comparator_witness = struct
  include Utf
  include B
  include Identifiable.Extend (Utf) (B)

  let quickcheck_observer =
    let open Base_quickcheck.Observer in
    unmap string ~f:Utf.to_string
  ;;

  let quickcheck_shrinker =
    let open Base_quickcheck in
    Shrinker.map
      (quickcheck_shrinker_list Uchar.quickcheck_shrinker)
      ~f:Utf.of_list
      ~f_inverse:Utf.to_list
  ;;

  let quickcheck_generator =
    let open Base_quickcheck in
    Generator.map ~f:Utf.of_list (Generator.list Uchar.quickcheck_generator)
  ;;
end

module Utf8 = Extend_utf (Utf8) (Stable.Utf8.V1)
module Utf16le = Extend_utf (Utf16le) (Stable.Utf16le.V1)
module Utf16be = Extend_utf (Utf16be) (Stable.Utf16be.V1)
module Utf32le = Extend_utf (Utf32le) (Stable.Utf32le.V1)
module Utf32be = Extend_utf (Utf32be) (Stable.Utf32be.V1)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
