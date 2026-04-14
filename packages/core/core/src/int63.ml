let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"int63.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "int63.ml.before-ppx"
;;

open! Import

module Bin : Binable0.S with type t := Base.Int63.t = struct
  module Bin_emulated = struct
    type t = Base.Int63.Private.Emul.t

    include
      Binable0.Of_binable_without_uuid [@alert "-legacy"]
        (Int64)
        (struct
          type nonrec t = t

          let of_binable = Base.Int63.Private.Emul.W.wrap_exn
          let to_binable = Base.Int63.Private.Emul.W.unwrap
        end)
  end

  type 'a binable = (module Binable0.S with type t = 'a)

  let binable_of_repr : type a b. (a, b) Base.Int63.Private.Repr.t -> b binable = function
    | Base.Int63.Private.Repr.Int -> (module Int)
    | Base.Int63.Private.Repr.Int64 -> (module Bin_emulated)
  ;;

  let binable : Base.Int63.t binable = binable_of_repr Base.Int63.Private.repr

  include (val binable)

  let bin_shape_t = Bin_prot.Shape.bin_shape_int63
end

module Stable = struct
  module V1 = struct
    module T = struct
      type t = Base.Int63.t [@@deriving equal, hash, sexp, sexp_grammar]

      include struct
        let _ = fun (_ : t) -> ()

        let equal =
          (fun a__001_ b__002_ -> Base.Int63.equal a__001_ b__002_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Int63.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Int63.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (Base.Int63.t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (Base.Int63.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
        let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = Base.Int63.t_sexp_grammar
        let _ = t_sexp_grammar
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Bin

      include (
        Base.Int63 :
          Base.Comparable.S
          with type t := t
          with type comparator_witness = Base.Int63.comparator_witness)

      let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
  end
end

include struct
  type t = Base.Int63.t
end

let typerep_of_t = typerep_of_int63
let typename_of_t = typename_of_int63

include
  Identifiable.Extend
    (Base.Int63)
    (struct
      type nonrec t = t

      include Bin
    end)

module Replace_polymorphic_compare : Comparable.Comparisons with type t := t = Base.Int63
include Base.Int63
include Comparable.Validate_with_zero (Base.Int63)

module Binary = struct
  include Binary

  type nonrec t = t [@@deriving typerep, bin_io]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "int63.ml.before-ppx.Binary.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
    ;;

    let _ = typerep_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int63.ml.before-ppx:80:2")
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Hex = struct
  include Hex

  type nonrec t = t [@@deriving typerep, bin_io]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "int63.ml.before-ppx.Hex.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_t))
    ;;

    let _ = typerep_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "int63.ml.before-ppx:86:2")
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let quickcheck_generator = Base_quickcheck.Generator.int63
let quickcheck_observer = Base_quickcheck.Observer.int63
let quickcheck_shrinker = Base_quickcheck.Shrinker.int63
let gen_incl = Base_quickcheck.Generator.int63_inclusive
let gen_uniform_incl = Base_quickcheck.Generator.int63_uniform_inclusive
let gen_log_incl = Base_quickcheck.Generator.int63_log_inclusive
let gen_log_uniform_incl = Base_quickcheck.Generator.int63_log_uniform_inclusive
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
