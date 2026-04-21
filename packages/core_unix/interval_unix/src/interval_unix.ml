let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"interval_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "interval_unix.ml.before-ppx"
;;

open! Core
module Interval = Interval_lib.Interval

module Stable = struct
  module V1 = struct
    module Time = struct
      module T = struct
        type t = Time_float_unix.Stable.V1.t Interval.Stable.V1.t
        [@@deriving sexp, bin_io, compare]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__002_ ->
               Interval.Stable.V1.t_of_sexp Time_float_unix.Stable.V1.t_of_sexp x__002_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__003_ ->
               Interval.Stable.V1.sexp_of_t Time_float_unix.Stable.V1.sexp_of_t x__003_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval_unix.ml.before-ppx:8:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Interval.Stable.V1.bin_shape_t Time_float_unix.Stable.V1.bin_shape_t )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> Interval.Stable.V1.bin_size_t Time_float_unix.Stable.V1.bin_size_t v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v ->
            Interval.Stable.V1.bin_write_t
              Time_float_unix.Stable.V1.bin_write_t
              buf
              ~pos
              v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (Interval.Stable.V1.__bin_read_t__ Time_float_unix.Stable.V1.bin_read_t)
              buf
              ~pos_ref
              vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            (Interval.Stable.V1.bin_read_t Time_float_unix.Stable.V1.bin_read_t)
              buf
              ~pos_ref
          ;;

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
            (fun a__004_ b__005_ ->
               Interval.Stable.V1.compare
                 (fun a__006_ (b__007_ [@merlin.hide]) ->
                    (Time_float_unix.Stable.V1.compare a__006_ b__007_ [@merlin.hide]))
                 a__004_
                 b__005_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end

    module Time_ns = struct
      module T = struct
        type t = Time_ns_unix.Stable.V1.t Interval.Stable.V1.t
        [@@deriving sexp, bin_io, compare]

        include struct
          let _ = fun (_ : t) -> ()

          let t_of_sexp =
            (fun x__009_ ->
               Interval.Stable.V1.t_of_sexp Time_ns_unix.Stable.V1.t_of_sexp x__009_
             : Sexplib0.Sexp.t -> t)
          ;;

          let _ = t_of_sexp

          let sexp_of_t =
            (fun x__010_ ->
               Interval.Stable.V1.sexp_of_t Time_ns_unix.Stable.V1.sexp_of_t x__010_
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "interval_unix.ml.before-ppx:18:8")
                [ ( Bin_prot.Shape.Tid.of_string "t"
                  , []
                  , Interval.Stable.V1.bin_shape_t Time_ns_unix.Stable.V1.bin_shape_t )
                ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t

          let bin_size_t : t Bin_prot.Size.sizer =
            fun v -> Interval.Stable.V1.bin_size_t Time_ns_unix.Stable.V1.bin_size_t v
          ;;

          let _ = bin_size_t

          let bin_write_t : t Bin_prot.Write.writer =
            fun buf ~pos v ->
            Interval.Stable.V1.bin_write_t Time_ns_unix.Stable.V1.bin_write_t buf ~pos v
          ;;

          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t

          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
            fun buf ~pos_ref vint ->
            (Interval.Stable.V1.__bin_read_t__ Time_ns_unix.Stable.V1.bin_read_t)
              buf
              ~pos_ref
              vint
          ;;

          let _ = __bin_read_t__

          let bin_read_t : t Bin_prot.Read.reader =
            fun buf ~pos_ref ->
            (Interval.Stable.V1.bin_read_t Time_ns_unix.Stable.V1.bin_read_t) buf ~pos_ref
          ;;

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
            (fun a__011_ b__012_ ->
               Interval.Stable.V1.compare
                 (fun a__013_ (b__014_ [@merlin.hide]) ->
                    (Time_ns_unix.Stable.V1.compare a__013_ b__014_ [@merlin.hide]))
                 a__011_
                 b__012_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Stable.V1.Make (T)
    end
  end
end

module type S_time = Interval_unix_intf.S_time

module type Time_bound = sig
  type t [@@deriving bin_io, sexp, compare, hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t

  module Ofday : sig
    type t
  end

  module Zone : sig
    type t

    val local : t Lazy.t
  end

  val occurrence
    :  [ `First_after_or_at | `Last_before_or_at ]
    -> t
    -> ofday:Ofday.t
    -> zone:Zone.t
    -> t
end

module Make_time (Time : Time_bound) = struct
  include Interval.Private.Make (Time)

  let create_ending_after ?zone (open_ofday, close_ofday) ~now =
    let zone =
      match zone with
      | None -> Lazy.force Time.Zone.local
      | Some z -> z
    in
    let close_time = Time.occurrence `First_after_or_at now ~zone ~ofday:close_ofday in
    let open_time =
      Time.occurrence `Last_before_or_at close_time ~zone ~ofday:open_ofday
    in
    create open_time close_time
  ;;

  let create_ending_before ?zone (open_ofday, close_ofday) ~ubound =
    let zone =
      match zone with
      | None -> Lazy.force Time.Zone.local
      | Some z -> z
    in
    let close_time = Time.occurrence `Last_before_or_at ubound ~zone ~ofday:close_ofday in
    let open_time =
      Time.occurrence `Last_before_or_at close_time ~zone ~ofday:open_ofday
    in
    create open_time close_time
  ;;
end

module Time = Make_time (Time_float_unix)
module Time_ns = Make_time (Time_ns_unix)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
