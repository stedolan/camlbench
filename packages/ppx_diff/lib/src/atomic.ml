let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"atomic.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "atomic.ml.before-ppx"
;;

open Base

module Make_base_diff (M : sig
    type t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  let get ~from ~to_ =
    if phys_equal from to_ || M.equal from to_
    then Optional_diff.none
    else Optional_diff.return to_
  [@@inline]
  ;;

  let apply_exn _ t = t [@@inline]

  let of_list_exn = function
    | [] -> Optional_diff.none
    | _ :: _ as l -> Optional_diff.return (List.last_exn l)
  [@@inline]
  ;;
end

module Make_diff_plain (M : sig
    type t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  type derived_on = M.t
  type t = M.t [@@deriving equal]

  include struct
    let _ = fun (_ : t) -> ()

    let equal =
      (fun a__001_ b__002_ -> M.equal a__001_ b__002_ : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Make_base_diff (M)
end

module Make_diff (M : sig
    type t [@@deriving sexp, bin_io, equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  type derived_on = M.t
  type t = M.t [@@deriving sexp, bin_io, equal]

  include struct
    let _ = fun (_ : t) -> ()
    let t_of_sexp = (M.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (M.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "atomic.ml.before-ppx:36:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], M.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t : t Bin_prot.Size.sizer = M.bin_size_t
    let _ = bin_size_t
    let bin_write_t : t Bin_prot.Write.writer = M.bin_write_t
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = M.__bin_read_t__
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = M.bin_read_t
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
      (fun a__004_ b__005_ -> M.equal a__004_ b__005_ : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Make_base_diff (M)
end

module Make_plain (M : sig
    type t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  module Diff = Make_diff_plain (M)
end

module Make (M : sig
    type t [@@deriving equal, sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end) =
struct
  module Diff = Make_diff (M)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
