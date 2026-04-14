let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"pid.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "pid.ml.before-ppx"
;;

module Stable = struct
  module V1 = struct
    module Without_containers = struct
      type nonrec t = Int.Stable.V1.t [@@deriving compare, equal, stable_witness]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__001_ b__002_ -> Int.Stable.V1.compare a__001_ b__002_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__003_ b__004_ -> Int.Stable.V1.equal a__003_ b__004_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let stable_witness =
          (Ppx_stable_witness_runtime.Stable_witness.assert_stable
           : t Ppx_stable_witness_runtime.Stable_witness.t)

        and __stable_witness_checks_for_t__ () =
          let _ : Int.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
            Int.Stable.V1.stable_witness
          in
          ()
        ;;

        let _ = stable_witness
        and _ = __stable_witness_checks_for_t__
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      exception Pid_must_be_positive of Int.Stable.V1.t [@@deriving sexp]

      include struct
        let () =
          Sexplib0.Sexp_conv.Exn_converter.add
            [%extension_constructor Pid_must_be_positive]
            (function
            | Pid_must_be_positive arg0__005_ ->
              let res0__006_ = Int.Stable.V1.sexp_of_t arg0__005_ in
              Sexplib0.Sexp.List
                [ Sexplib0.Sexp.Atom
                    "pid.ml.before-ppx.Stable.V1.Without_containers.Pid_must_be_positive"
                ; res0__006_
                ]
            | _ -> assert false)
        ;;
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let ensure i = if i <= 0 then raise (Pid_must_be_positive i) else i

      include
        Sexpable.Stable.Of_sexpable.V1
          (Int.Stable.V1)
          (struct
            type t = Int.Stable.V1.t

            let to_sexpable = Fn.id
            let of_sexpable = ensure
          end)

      include
        Binable.Stable.Of_binable.V1 [@alert "-legacy"]
          (Int.Stable.V1)
          (struct
            type t = Int.Stable.V1.t

            let to_binable = Fn.id
            let of_binable = ensure
          end)

      include (val Comparator.Stable.V1.make ~compare ~sexp_of_t)
    end

    include Comparable.Stable.V1.With_stable_witness.Make (Without_containers)
    include Without_containers
  end

  module Latest = V1
end

open! Import
include Stable.Latest.Without_containers

type t = int [@@deriving hash]

include struct
  let _ = fun (_ : t) -> ()

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    fun hsv arg -> hash_fold_int hsv arg

  and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
    let func = hash_int in
    fun x -> func x
  ;;

  let _ = hash_fold_t
  and _ = hash
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let of_int i = ensure i
let to_int = Fn.id
let of_string string = ensure (Int.of_string string)
let to_string = Int.to_string
let init = of_int 1

include
  Quickcheckable.Of_quickcheckable_filtered
    (Int)
    (struct
      type nonrec t = t

      let of_quickcheckable n = Option.some_if (n > 0) n
      let to_quickcheckable = to_int
    end)

include Identifiable.Make_using_comparator (struct
    type nonrec t = t [@@deriving bin_io, compare, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "pid.ml.before-ppx:62:2")
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
        (fun a__007_ b__008_ -> compare a__007_ b__008_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

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
    let of_string = of_string
    let to_string = to_string
    let module_name = "Core.Pid"
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
