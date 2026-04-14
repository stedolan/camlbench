let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"bool.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "bool.ml.before-ppx"
;;

open! Import

module Stable = struct
  module V1 = struct
    module T = struct
      include Base.Bool

      type t = bool [@@deriving compare, sexp, bin_io ~localize, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__001_ b__002_ -> compare_bool a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare
        let t_of_sexp = (bool_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_bool : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "bool.ml.before-ppx:8:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_bool ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_bool__local
        let _ = bin_size_t__local
        let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
        let _ = bin_size_t
        let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_bool__local
        let _ = bin_write_t__local
        let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_bool__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_bool
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
          let _ : bool Ppx_stable_witness_runtime.Stable_witness.t =
            stable_witness_bool
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
  end
end

include Stable.V1

type t = bool [@@deriving typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : t) -> ()

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
      type nonrec t = t

      let name = "bool.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t =
    let name_of_t = Typename_of_t.named in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_bool))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

include
  Identifiable.Extend
    (Base.Bool)
    (struct
      type nonrec t = t [@@deriving bin_io]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "bool.ml.before-ppx:24:6")
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

module Replace_polymorphic_compare = Base.Bool

include (
  Base.Bool :
    module type of struct
      include Base.Bool
    end
    with type t := t)

include Comparable.Validate (Base.Bool)

let of_string_hum =
  let table =
    lazy
      (let table = String.Caseless.Table.create () in
       List.iter
         ~f:(fun (bool, strings) ->
           List.iter strings ~f:(fun string ->
             Hashtbl.set table ~key:string ~data:bool;
             Hashtbl.set table ~key:(String.prefix string 1) ~data:bool))
         [ false, [ "false"; "no"; "0" ]; true, [ "true"; "yes"; "1" ] ];
       table)
  in
  let raise_invalid input =
    let expected_case_insensitive = String.Set.of_list (Hashtbl.keys (force table)) in
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Bool.of_string_hum: invalid input"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "input"
               ; (sexp_of_string [@merlin.hide]) input
               ]
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "expected_case_insensitive"
               ; (String.Set.sexp_of_t [@merlin.hide]) expected_case_insensitive
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  in
  fun string ->
    Hashtbl.find_and_call (force table) string ~if_found:Fn.id ~if_not_found:raise_invalid
;;

let quickcheck_generator = Base_quickcheck.Generator.bool
let quickcheck_observer = Base_quickcheck.Observer.bool
let quickcheck_shrinker = Base_quickcheck.Shrinker.bool
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
