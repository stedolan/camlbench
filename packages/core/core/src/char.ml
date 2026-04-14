let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"char.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "char.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    module T = struct
      include Base.Char

      type t = char [@@deriving bin_io, sexp, sexp_grammar, stable_witness, typerep]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "char.ml.before-ppx:8:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_char ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_char
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_char
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_char__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_char
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
        let t_of_sexp = (char_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_char : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
        let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = char_sexp_grammar
        let _ = t_sexp_grammar

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : char Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_char
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__

        module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
            type nonrec t = t

            let name = "char.ml.before-ppx.Stable.V1.T.t"
            let _ = name
          end)

        let typename_of_t = Typename_of_t.typename_of_t
        let _ = typename_of_t

        let typerep_of_t =
          let name_of_t = Typename_of_t.named in
          Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_char))
        ;;

        let _ = typerep_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
  end
end

type t = char [@@deriving typerep, bin_io ~localize]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "char.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_char))
  ;;

  let _ = typerep_of_t

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "char.ml.before-ppx:16:0")
        [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_char ]
    in
    (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
  ;;

  let _ = bin_shape_t
  let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_char__local
  let _ = bin_size_t__local
  let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
  let _ = bin_size_t
  let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_char__local
  let _ = bin_write_t__local
  let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
  let _ = bin_write_t

  let bin_writer_t =
    ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
  ;;

  let _ = bin_writer_t
  let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_char__
  let _ = __bin_read_t__
  let bin_read_t : t Bin_prot.Read.reader = bin_read_char
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

include
  Identifiable.Extend
    (Base.Char)
    (struct
      type t = char [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "char.ml.before-ppx:22:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_char ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_char
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_char
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_char__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_char
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

include (
  Base.Char :
    module type of struct
      include Base.Char
    end
    with type t := t)

module Caseless = struct
  module T = struct
    include Caseless

    type t = char [@@deriving bin_io ~localize]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "char.ml.before-ppx:38:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_char ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_char__local
      let _ = bin_size_t__local
      let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t
      let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_char__local
      let _ = bin_write_t__local
      let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_char__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_char
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

module Replace_polymorphic_compare = Base.Char

let quickcheck_generator = Base_quickcheck.Generator.char
let quickcheck_observer = Base_quickcheck.Observer.char
let quickcheck_shrinker = Base_quickcheck.Shrinker.char
let gen_digit = Base_quickcheck.Generator.char_digit
let gen_lowercase = Base_quickcheck.Generator.char_lowercase
let gen_uppercase = Base_quickcheck.Generator.char_uppercase
let gen_alpha = Base_quickcheck.Generator.char_alpha
let gen_alphanum = Base_quickcheck.Generator.char_alphanum
let gen_print = Base_quickcheck.Generator.char_print
let gen_whitespace = Base_quickcheck.Generator.char_whitespace
let gen_uniform_inclusive = Base_quickcheck.Generator.char_uniform_inclusive
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
