let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"array.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "array.ml.before-ppx"
;;

open! Import
open Base_quickcheck.Export
open Perms.Export
module Array = Base.Array
module Core_sequence = Sequence

include (
  Base.Array :
  sig
    type 'a t = 'a array [@@deriving sexp, compare ~localize, globalize, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Comparable.S_local1 with type 'a t := 'a t

      val globalize : ('a -> 'a) -> 'a t -> 'a t
      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

type 'a t = 'a array [@@deriving bin_io ~localize, quickcheck, typerep]

include struct
  [@@@ocaml.warning "-60"]

  let _ = fun (_ : 'a t) -> ()

  let bin_shape_t =
    let _group =
      Bin_prot.Shape.group
        (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:13:0")
        [ ( Bin_prot.Shape.Tid.of_string "t"
          , [ Bin_prot.Shape.Vid.of_string "a" ]
          , bin_shape_array
              (Bin_prot.Shape.var
                 (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:13:12")
                 (Bin_prot.Shape.Vid.of_string "a")) )
        ]
    in
    fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a ]
  ;;

  let _ = bin_shape_t

  let bin_size_t__local
    : 'a. 'a Bin_prot.Size.sizer_local -> 'a t Bin_prot.Size.sizer_local
    =
    fun _size_of_a__local v -> bin_size_array__local _size_of_a__local v
  ;;

  let _ = bin_size_t__local

  let bin_size_t : 'a. 'a Bin_prot.Size.sizer -> 'a t Bin_prot.Size.sizer =
    fun _size_of_a v -> bin_size_array _size_of_a v
  ;;

  let _ = bin_size_t

  let bin_write_t__local
    : 'a. 'a Bin_prot.Write.writer_local -> 'a t Bin_prot.Write.writer_local
    =
    fun _write_a__local buf ~pos v -> bin_write_array__local _write_a__local buf ~pos v
  ;;

  let _ = bin_write_t__local

  let bin_write_t : 'a. 'a Bin_prot.Write.writer -> 'a t Bin_prot.Write.writer =
    fun _write_a buf ~pos v -> bin_write_array _write_a buf ~pos v
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

  let __bin_read_t__ : 'a. 'a Bin_prot.Read.reader -> (int -> 'a t) Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref vint -> (__bin_read_array__ _of__a) buf ~pos_ref vint
  ;;

  let _ = __bin_read_t__

  let bin_read_t : 'a. 'a Bin_prot.Read.reader -> 'a t Bin_prot.Read.reader =
    fun _of__a buf ~pos_ref -> (bin_read_array _of__a) buf ~pos_ref
  ;;

  let _ = bin_read_t

  let bin_reader_t =
    (fun bin_reader_a ->
       { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_a.read) buf ~pos_ref)
       ; vtag_read =
           (fun buf ~pos_ref vtag -> (__bin_read_t__ bin_reader_a.read) buf ~pos_ref vtag)
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
  let quickcheck_generator _generator__003_ = quickcheck_generator_array _generator__003_
  let _ = quickcheck_generator
  let quickcheck_observer _observer__002_ = quickcheck_observer_array _observer__002_
  let _ = quickcheck_observer
  let quickcheck_shrinker _shrinker__001_ = quickcheck_shrinker_array _shrinker__001_
  let _ = quickcheck_shrinker

  module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
      type nonrec 'a t = 'a t

      let name = "array.ml.before-ppx.t"
      let _ = name
    end)

  let typename_of_t = Typename_of_t.typename_of_t
  let _ = typename_of_t

  let typerep_of_t : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a t Typerep_lib.Std.Typerep.t =
    fun (type a) ->
    fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
    let name_of_t = Typename_of_t.named _of_a in
    Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_array _of_a)))
  ;;

  let _ = typerep_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module Private = Base.Array.Private

module T = struct
  include Base.Array

  let normalize t i = Ordered_collection_common.normalize ~length_fun:length t i

  let slice t start stop =
    Ordered_collection_common.slice ~length_fun:length ~sub_fun:sub t start stop
  ;;

  let nget t i = t.(normalize t i)
  let nset t i v = t.(normalize t i) <- v

  module Sequence = struct
    open Base.Array

    let length = length
    let get = get
    let set = set
  end

  module Int = struct
    type t_ = int array [@@deriving bin_io ~localize, compare, sexp]

    include struct
      let _ = fun (_ : t_) -> ()

      let bin_shape_t_ =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:41:4")
            [ Bin_prot.Shape.Tid.of_string "t_", [], bin_shape_array bin_shape_int ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t_")) []
      ;;

      let _ = bin_shape_t_

      let bin_size_t___local : t_ Bin_prot.Size.sizer_local =
        fun v -> bin_size_array__local bin_size_int__local v
      ;;

      let _ = bin_size_t___local
      let bin_size_t_ = (bin_size_t___local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t_

      let bin_write_t___local : t_ Bin_prot.Write.writer_local =
        fun buf ~pos v -> bin_write_array__local bin_write_int__local buf ~pos v
      ;;

      let _ = bin_write_t___local
      let bin_write_t_ = (bin_write_t___local :> _ Bin_prot.Write.writer)
      let _ = bin_write_t_

      let bin_writer_t_ =
        ({ size = bin_size_t_; write = bin_write_t_ } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t_

      let __bin_read_t___ : (int -> t_) Bin_prot.Read.reader =
        fun buf ~pos_ref vint -> (__bin_read_array__ bin_read_int) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t___

      let bin_read_t_ : t_ Bin_prot.Read.reader =
        fun buf ~pos_ref -> (bin_read_array bin_read_int) buf ~pos_ref
      ;;

      let _ = bin_read_t_

      let bin_reader_t_ =
        ({ read = bin_read_t_; vtag_read = __bin_read_t___ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t_

      let bin_t_ =
        ({ writer = bin_writer_t_; reader = bin_reader_t_; shape = bin_shape_t_ }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t_

      let compare_t_ =
        (fun a__004_ b__005_ ->
           compare_array
             (fun a__006_ (b__007_ [@merlin.hide]) ->
                (compare_int a__006_ b__007_ [@merlin.hide]))
             a__004_
             b__005_
         : t_ -> (t_[@merlin.hide]) -> int)
      ;;

      let _ = compare_t_

      let t__of_sexp =
        (fun x__009_ -> array_of_sexp int_of_sexp x__009_ : Sexplib0.Sexp.t -> t_)
      ;;

      let _ = t__of_sexp

      let sexp_of_t_ =
        (fun x__010_ -> sexp_of_array sexp_of_int x__010_ : t_ -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t_
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Unsafe_blit = struct
      external unsafe_blit
        :  src:(t_[@local_opt])
        -> src_pos:int
        -> dst:(t_[@local_opt])
        -> dst_pos:int
        -> len:int
        -> unit
        = "core_array_unsafe_int_blit"
      [@@noalloc]
    end

    include
      Test_blit.Make_and_test
        (struct
          type t = int

          let equal = ( = )
          let of_bool b = if b then 1 else 0
        end)
        (struct
          type t = t_ [@@deriving sexp_of]

          include struct
            let _ = fun (_ : t) -> ()
            let sexp_of_t = (sexp_of_t_ : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          include Sequence

          let create ~len = create ~len 0

          include Unsafe_blit
        end)

    include Unsafe_blit
  end

  module Float = struct
    type t_ = float array [@@deriving bin_io ~localize, compare, sexp]

    include struct
      let _ = fun (_ : t_) -> ()

      let bin_shape_t_ =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:77:4")
            [ Bin_prot.Shape.Tid.of_string "t_", [], bin_shape_array bin_shape_float ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t_")) []
      ;;

      let _ = bin_shape_t_

      let bin_size_t___local : t_ Bin_prot.Size.sizer_local =
        fun v -> bin_size_array__local bin_size_float__local v
      ;;

      let _ = bin_size_t___local
      let bin_size_t_ = (bin_size_t___local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_t_

      let bin_write_t___local : t_ Bin_prot.Write.writer_local =
        fun buf ~pos v -> bin_write_array__local bin_write_float__local buf ~pos v
      ;;

      let _ = bin_write_t___local
      let bin_write_t_ = (bin_write_t___local :> _ Bin_prot.Write.writer)
      let _ = bin_write_t_

      let bin_writer_t_ =
        ({ size = bin_size_t_; write = bin_write_t_ } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t_

      let __bin_read_t___ : (int -> t_) Bin_prot.Read.reader =
        fun buf ~pos_ref vint -> (__bin_read_array__ bin_read_float) buf ~pos_ref vint
      ;;

      let _ = __bin_read_t___

      let bin_read_t_ : t_ Bin_prot.Read.reader =
        fun buf ~pos_ref -> (bin_read_array bin_read_float) buf ~pos_ref
      ;;

      let _ = bin_read_t_

      let bin_reader_t_ =
        ({ read = bin_read_t_; vtag_read = __bin_read_t___ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t_

      let bin_t_ =
        ({ writer = bin_writer_t_; reader = bin_reader_t_; shape = bin_shape_t_ }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t_

      let compare_t_ =
        (fun a__011_ b__012_ ->
           compare_array
             (fun a__013_ (b__014_ [@merlin.hide]) ->
                (compare_float a__013_ b__014_ [@merlin.hide]))
             a__011_
             b__012_
         : t_ -> (t_[@merlin.hide]) -> int)
      ;;

      let _ = compare_t_

      let t__of_sexp =
        (fun x__016_ -> array_of_sexp float_of_sexp x__016_ : Sexplib0.Sexp.t -> t_)
      ;;

      let _ = t__of_sexp

      let sexp_of_t_ =
        (fun x__017_ -> sexp_of_array sexp_of_float x__017_ : t_ -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t_
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Unsafe_blit = struct
      external unsafe_blit
        :  src:(t_[@local_opt])
        -> src_pos:int
        -> dst:(t_[@local_opt])
        -> dst_pos:int
        -> len:int
        -> unit
        = "core_array_unsafe_float_blit"
      [@@noalloc]
    end

    external get : (t_[@local_opt]) -> (int[@local_opt]) -> float = "%floatarray_safe_get"

    external set
      :  (t_[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_safe_set"

    external unsafe_get
      :  (t_[@local_opt])
      -> (int[@local_opt])
      -> float
      = "%floatarray_unsafe_get"

    external unsafe_set
      :  (t_[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_unsafe_set"

    include
      Test_blit.Make_and_test
        (struct
          type t = float

          let equal = Base.Float.equal
          let of_bool b = if b then 1. else 0.
        end)
        (struct
          type t = t_ [@@deriving sexp_of]

          include struct
            let _ = fun (_ : t) -> ()
            let sexp_of_t = (sexp_of_t_ : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          include Sequence

          let create ~len = create ~len 0.

          include Unsafe_blit
        end)

    include Unsafe_blit
  end
end

module type Permissioned = sig
  type ('a, -'perms) t

  include
    Indexed_container.S1_with_creators_permissions
    with type ('a, 'perms) t := ('a, 'perms) t

  include Blit.S1_permissions with type ('a, 'perms) t := ('a, 'perms) t
  include Binary_searchable.S1_permissions with type ('a, 'perms) t := ('a, 'perms) t

  external length : (('a, _) t[@local_opt]) -> int = "%array_length"
  val is_empty : (_, _) t -> bool

  external get
    :  (('a, [> read ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    = "%array_safe_get"

  external set
    :  (('a, [> write ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    -> unit
    = "%array_safe_set"

  external unsafe_get
    :  (('a, [> read ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    = "%array_unsafe_get"

  external unsafe_set
    :  (('a, [> write ]) t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    -> unit
    = "%array_unsafe_set"

  val create_float_uninitialized : len:int -> (float, [< _ perms ]) t
  val create : len:int -> 'a -> ('a, [< _ perms ]) t
  val create_local : len:int -> 'a -> ('a, [< _ perms ]) t
  val init : int -> f:(int -> 'a) -> ('a, [< _ perms ]) t
  val make_matrix : dimx:int -> dimy:int -> 'a -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val copy_matrix
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val append : ('a, [> read ]) t -> ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val concat : ('a, [> read ]) t list -> ('a, [< _ perms ]) t
  val copy : ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val fill : ('a, [> write ]) t -> pos:int -> len:int -> 'a -> unit
  val of_list : 'a list -> ('a, [< _ perms ]) t
  val map : ('a, [> read ]) t -> f:('a -> 'b) -> ('b, [< _ perms ]) t

  val folding_map
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:('acc -> 'a -> 'acc * 'b)
    -> ('b, [< _ perms ]) t

  val fold_map
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:('acc -> 'a -> 'acc * 'b)
    -> 'acc * ('b, [< _ perms ]) t

  val mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val iteri : ('a, [> read ]) t -> f:(int -> 'a -> unit) -> unit
  val foldi : ('a, [> read ]) t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc

  val folding_mapi
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:(int -> 'acc -> 'a -> 'acc * 'b)
    -> ('b, [< _ perms ]) t

  val fold_mapi
    :  ('a, [> read ]) t
    -> init:'acc
    -> f:(int -> 'acc -> 'a -> 'acc * 'b)
    -> 'acc * ('b, [< _ perms ]) t

  val fold_right : ('a, [> read ]) t -> f:('a -> 'acc -> 'acc) -> init:'acc -> 'acc

  val sort
    :  ?pos:int
    -> ?len:int
    -> ('a, [> read_write ]) t
    -> compare:('a -> 'a -> int)
    -> unit

  val stable_sort : ('a, [> read_write ]) t -> compare:('a -> 'a -> int) -> unit
  val is_sorted : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> bool
  val is_sorted_strictly : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> bool

  val merge
    :  ('a, [> read ]) t
    -> ('a, [> read ]) t
    -> compare:('a -> 'a -> int)
    -> ('a, [< _ perms ]) t

  val concat_map
    :  ('a, [> read ]) t
    -> f:('a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t

  val concat_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> ('b, [> read ]) t)
    -> ('b, [< _ perms ]) t

  val partition_tf
    :  ('a, [> read ]) t
    -> f:('a -> bool)
    -> ('a, [< _ perms ]) t * ('a, [< _ perms ]) t

  val partitioni_tf
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> bool)
    -> ('a, [< _ perms ]) t * ('a, [< _ perms ]) t

  val cartesian_product
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> ('a * 'b, [< _ perms ]) t

  val transpose
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t option

  val transpose_exn
    :  (('a, [> read ]) t, [> read ]) t
    -> (('a, [< _ perms ]) t, [< _ perms ]) t

  val normalize : ('a, _) t -> int -> int
  val slice : ('a, [> read ]) t -> int -> int -> ('a, [< _ perms ]) t
  val nget : ('a, [> read ]) t -> int -> 'a
  val nset : ('a, [> write ]) t -> int -> 'a -> unit
  val filter_opt : ('a option, [> read ]) t -> ('a, [< _ perms ]) t
  val filter_map : ('a, [> read ]) t -> f:('a -> 'b option) -> ('b, [< _ perms ]) t

  val filter_mapi
    :  ('a, [> read ]) t
    -> f:(int -> 'a -> 'b option)
    -> ('b, [< _ perms ]) t

  val for_alli : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val existsi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> bool
  val counti : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> int
  val iter2_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> f:('a -> 'b -> unit) -> unit

  val map2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> f:('a -> 'b -> 'c)
    -> ('c, [< _ perms ]) t

  val fold2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> init:'acc
    -> f:('acc -> 'a -> 'b -> 'acc)
    -> 'acc

  val for_all2_exn
    :  ('a, [> read ]) t
    -> ('b, [> read ]) t
    -> f:('a -> 'b -> bool)
    -> bool

  val exists2_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> f:('a -> 'b -> bool) -> bool
  val filter : ('a, [> read ]) t -> f:('a -> bool) -> ('a, [< _ perms ]) t
  val filteri : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> ('a, [< _ perms ]) t
  val swap : ('a, [> read_write ]) t -> int -> int -> unit
  val rev_inplace : ('a, [> read_write ]) t -> unit
  val rev : ('a, [> read ]) t -> ('a, [< _ perms ]) t
  val of_list_rev : 'a list -> ('a, [< _ perms ]) t
  val of_list_map : 'a list -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_mapi : 'a list -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_rev_map : 'a list -> f:('a -> 'b) -> ('b, [< _ perms ]) t
  val of_list_rev_mapi : 'a list -> f:(int -> 'a -> 'b) -> ('b, [< _ perms ]) t
  val map_inplace : ('a, [> read_write ]) t -> f:('a -> 'a) -> unit
  val find_exn : ('a, [> read ]) t -> f:('a -> bool) -> 'a
  val find_map_exn : ('a, [> read ]) t -> f:('a -> 'b option) -> 'b
  val findi : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> (int * 'a) option
  val findi_exn : ('a, [> read ]) t -> f:(int -> 'a -> bool) -> int * 'a
  val find_mapi : ('a, [> read ]) t -> f:(int -> 'a -> 'b option) -> 'b option
  val find_mapi_exn : ('a, [> read ]) t -> f:(int -> 'a -> 'b option) -> 'b

  val find_consecutive_duplicate
    :  ('a, [> read ]) t
    -> equal:('a -> 'a -> bool)
    -> ('a * 'a) option

  val reduce : ('a, [> read ]) t -> f:('a -> 'a -> 'a) -> 'a option
  val reduce_exn : ('a, [> read ]) t -> f:('a -> 'a -> 'a) -> 'a

  val permute
    :  ?random_state:Random.State.t
    -> ?pos:int
    -> ?len:int
    -> ('a, [> read_write ]) t
    -> unit

  val random_element : ?random_state:Random.State.t -> ('a, [> read ]) t -> 'a option
  val random_element_exn : ?random_state:Random.State.t -> ('a, [> read ]) t -> 'a
  val zip : ('a, [> read ]) t -> ('b, [> read ]) t -> ('a * 'b, [< _ perms ]) t option
  val zip_exn : ('a, [> read ]) t -> ('b, [> read ]) t -> ('a * 'b, [< _ perms ]) t
  val unzip : ('a * 'b, [> read ]) t -> ('a, [< _ perms ]) t * ('b, [< _ perms ]) t
  val sorted_copy : ('a, [> read ]) t -> compare:('a -> 'a -> int) -> ('a, [< _ perms ]) t
  val last : ('a, [> read ]) t -> 'a
  val equal : ('a -> 'a -> bool) -> ('a, [> read ]) t -> ('a, [> read ]) t -> bool
  val equal__local : ('a -> 'a -> bool) -> ('a, [> read ]) t -> ('a, [> read ]) t -> bool
  val to_sequence : ('a, [> read ]) t -> 'a Sequence.t
  val to_sequence_mutable : ('a, [> read ]) t -> 'a Sequence.t
end

module Permissioned : sig
  type ('a, -'perms) t = 'a array [@@deriving bin_io ~localize, compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local2 with type ('a, -'perms) t := ('a, 'perms) t
    include Ppx_compare_lib.Comparable.S2 with type ('a, -'perms) t := ('a, 'perms) t
    include Sexplib0.Sexpable.S2 with type ('a, -'perms) t := ('a, 'perms) t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Int : sig
    type nonrec -'perms t = (int, 'perms) t [@@deriving bin_io ~localize, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type -'perms t := 'perms t
      include Ppx_compare_lib.Comparable.S1 with type -'perms t := 'perms t
      include Sexplib0.Sexpable.S1 with type -'perms t := 'perms t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Blit.S_permissions with type 'perms t := 'perms t

    external unsafe_blit
      :  src:([> read ] t[@local_opt])
      -> src_pos:int
      -> dst:([> write ] t[@local_opt])
      -> dst_pos:int
      -> len:int
      -> unit
      = "core_array_unsafe_int_blit"
    [@@noalloc]
  end

  module Float : sig
    type nonrec -'perms t = (float, 'perms) t [@@deriving bin_io ~localize, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type -'perms t := 'perms t
      include Ppx_compare_lib.Comparable.S1 with type -'perms t := 'perms t
      include Sexplib0.Sexpable.S1 with type -'perms t := 'perms t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Blit.S_permissions with type 'perms t := 'perms t

    external get
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> float
      = "%floatarray_safe_get"

    external set
      :  ([> write ] t[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_safe_set"

    external unsafe_get
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> float
      = "%floatarray_unsafe_get"

    external unsafe_set
      :  ([> read ] t[@local_opt])
      -> (int[@local_opt])
      -> (float[@local_opt])
      -> unit
      = "%floatarray_unsafe_set"

    external unsafe_blit
      :  src:([> read ] t[@local_opt])
      -> src_pos:int
      -> dst:([> write ] t[@local_opt])
      -> dst_pos:int
      -> len:int
      -> unit
      = "core_array_unsafe_float_blit"
    [@@noalloc]
  end

  val of_array_id : 'a array -> ('a, [< read_write ]) t
  val to_array_id : ('a, [> read_write ]) t -> 'a array
  val to_sequence_immutable : ('a, [> immutable ]) t -> 'a Sequence.t

  include Permissioned with type ('a, 'perms) t := ('a, 'perms) t
end = struct
  type ('a, -'perms) t = 'a array [@@deriving bin_io ~localize, compare, sexp, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : ('a, 'perms) t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:421:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , [ Bin_prot.Shape.Vid.of_string "a"; Bin_prot.Shape.Vid.of_string "perms" ]
            , bin_shape_array
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:421:25")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a perms ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ a; perms ]
    ;;

    let _ = bin_shape_t

    let bin_size_t__local
      :  'a 'perms.
         'a Bin_prot.Size.sizer_local
      -> 'perms Bin_prot.Size.sizer_local
      -> ('a, 'perms) t Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local _size_of_perms__local v ->
      bin_size_array__local _size_of_a__local v
    ;;

    let _ = bin_size_t__local

    let bin_size_t
      :  'a 'perms.
         'a Bin_prot.Size.sizer
      -> 'perms Bin_prot.Size.sizer
      -> ('a, 'perms) t Bin_prot.Size.sizer
      =
      fun _size_of_a _size_of_perms v -> bin_size_array _size_of_a v
    ;;

    let _ = bin_size_t

    let bin_write_t__local
      :  'a 'perms.
         'a Bin_prot.Write.writer_local
      -> 'perms Bin_prot.Write.writer_local
      -> ('a, 'perms) t Bin_prot.Write.writer_local
      =
      fun _write_a__local _write_perms__local buf ~pos v ->
      bin_write_array__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_t__local

    let bin_write_t
      :  'a 'perms.
         'a Bin_prot.Write.writer
      -> 'perms Bin_prot.Write.writer
      -> ('a, 'perms) t Bin_prot.Write.writer
      =
      fun _write_a _write_perms buf ~pos v -> bin_write_array _write_a buf ~pos v
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      (fun bin_writer_a bin_writer_perms ->
         { size = (fun v -> bin_size_t bin_writer_a.size bin_writer_perms.size v)
         ; write = (fun v -> bin_write_t bin_writer_a.write bin_writer_perms.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__
      :  'a 'perms.
         'a Bin_prot.Read.reader
      -> 'perms Bin_prot.Read.reader
      -> (int -> ('a, 'perms) t) Bin_prot.Read.reader
      =
      fun _of__a _of__perms buf ~pos_ref vint ->
      (__bin_read_array__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_t__

    let bin_read_t
      :  'a 'perms.
         'a Bin_prot.Read.reader
      -> 'perms Bin_prot.Read.reader
      -> ('a, 'perms) t Bin_prot.Read.reader
      =
      fun _of__a _of__perms buf ~pos_ref -> (bin_read_array _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_t

    let bin_reader_t =
      (fun bin_reader_a bin_reader_perms ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_t bin_reader_a.read bin_reader_perms.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_t__ bin_reader_a.read bin_reader_perms.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_t

    let bin_t =
      (fun bin_a bin_perms ->
         { writer = bin_writer_t bin_a.writer bin_perms.writer
         ; reader = bin_reader_t bin_a.reader bin_perms.reader
         ; shape = bin_shape_t bin_a.shape bin_perms.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_t

    let compare
      :  'a 'perms.
         ('a -> ('a[@merlin.hide]) -> int)
      -> ('perms -> ('perms[@merlin.hide]) -> int)
      -> ('a, 'perms) t
      -> (('a, 'perms) t[@merlin.hide])
      -> int
      =
      fun _cmp__a _cmp__perms a__018_ b__019_ ->
      compare_array
        (fun a__020_ (b__021_ [@merlin.hide]) -> (_cmp__a a__020_ b__021_ [@merlin.hide]))
        a__018_
        b__019_
    ;;

    let _ = compare

    let t_of_sexp
      :  'a 'perms.
         (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'perms)
      -> Sexplib0.Sexp.t
      -> ('a, 'perms) t
      =
      fun _of_a__022_ _of_perms__023_ x__025_ -> array_of_sexp _of_a__022_ x__025_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a 'perms.
         ('a -> Sexplib0.Sexp.t)
      -> ('perms -> Sexplib0.Sexp.t)
      -> ('a, 'perms) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a__026_ _of_perms__027_ x__028_ -> sexp_of_array _of_a__026_ x__028_
    ;;

    let _ = sexp_of_t

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make2 (struct
        type nonrec ('a, 'perms) t = ('a, 'perms) t

        let name = "array.ml.before-ppx.Permissioned.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t
      :  'a 'perms.
         'a Typerep_lib.Std.Typerep.t
      -> 'perms Typerep_lib.Std.Typerep.t
      -> ('a, 'perms) t Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (type perms) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t)
        (_of_perms : perms Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a _of_perms in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_array _of_a)))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Int = struct
    include T.Int

    type -'perms t = t_ [@@deriving bin_io ~localize, compare, sexp]

    include struct
      let _ = fun (_ : 'perms t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:426:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "perms" ]
              , bin_shape_t_ )
            ]
        in
        fun perms ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ perms ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'perms. 'perms Bin_prot.Size.sizer_local -> 'perms t Bin_prot.Size.sizer_local
        =
        fun _size_of_perms__local -> bin_size_t___local
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'perms. 'perms Bin_prot.Size.sizer -> 'perms t Bin_prot.Size.sizer =
        fun _size_of_perms -> bin_size_t_
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        :  'perms.
           'perms Bin_prot.Write.writer_local
        -> 'perms t Bin_prot.Write.writer_local
        =
        fun _write_perms__local -> bin_write_t___local
      ;;

      let _ = bin_write_t__local

      let bin_write_t
        : 'perms. 'perms Bin_prot.Write.writer -> 'perms t Bin_prot.Write.writer
        =
        fun _write_perms -> bin_write_t_
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_perms ->
           { size = (fun v -> bin_size_t bin_writer_perms.size v)
           ; write = (fun v -> bin_write_t bin_writer_perms.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        : 'perms. 'perms Bin_prot.Read.reader -> (int -> 'perms t) Bin_prot.Read.reader
        =
        fun _of__perms -> __bin_read_t___
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        : 'perms. 'perms Bin_prot.Read.reader -> 'perms t Bin_prot.Read.reader
        =
        fun _of__perms -> bin_read_t_
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_perms ->
           { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_perms.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_perms.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_perms ->
           { writer = bin_writer_t bin_perms.writer
           ; reader = bin_reader_t bin_perms.reader
           ; shape = bin_shape_t bin_perms.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        :  'perms.
           ('perms -> ('perms[@merlin.hide]) -> int)
        -> 'perms t
        -> ('perms t[@merlin.hide])
        -> int
        =
        fun _cmp__perms a__029_ b__030_ -> compare_t_ a__029_ b__030_
      ;;

      let _ = compare

      let t_of_sexp : 'perms. (Sexplib0.Sexp.t -> 'perms) -> Sexplib0.Sexp.t -> 'perms t =
        fun _of_perms__031_ -> t__of_sexp
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'perms. ('perms -> Sexplib0.Sexp.t) -> 'perms t -> Sexplib0.Sexp.t =
        fun _of_perms__033_ -> sexp_of_t_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Float = struct
    include T.Float

    type -'perms t = t_ [@@deriving bin_io ~localize, compare, sexp]

    include struct
      let _ = fun (_ : 'perms t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:432:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , [ Bin_prot.Shape.Vid.of_string "perms" ]
              , bin_shape_t_ )
            ]
        in
        fun perms ->
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) [ perms ]
      ;;

      let _ = bin_shape_t

      let bin_size_t__local
        : 'perms. 'perms Bin_prot.Size.sizer_local -> 'perms t Bin_prot.Size.sizer_local
        =
        fun _size_of_perms__local -> bin_size_t___local
      ;;

      let _ = bin_size_t__local

      let bin_size_t : 'perms. 'perms Bin_prot.Size.sizer -> 'perms t Bin_prot.Size.sizer =
        fun _size_of_perms -> bin_size_t_
      ;;

      let _ = bin_size_t

      let bin_write_t__local
        :  'perms.
           'perms Bin_prot.Write.writer_local
        -> 'perms t Bin_prot.Write.writer_local
        =
        fun _write_perms__local -> bin_write_t___local
      ;;

      let _ = bin_write_t__local

      let bin_write_t
        : 'perms. 'perms Bin_prot.Write.writer -> 'perms t Bin_prot.Write.writer
        =
        fun _write_perms -> bin_write_t_
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        (fun bin_writer_perms ->
           { size = (fun v -> bin_size_t bin_writer_perms.size v)
           ; write = (fun v -> bin_write_t bin_writer_perms.write v)
           }
         : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__
        : 'perms. 'perms Bin_prot.Read.reader -> (int -> 'perms t) Bin_prot.Read.reader
        =
        fun _of__perms -> __bin_read_t___
      ;;

      let _ = __bin_read_t__

      let bin_read_t
        : 'perms. 'perms Bin_prot.Read.reader -> 'perms t Bin_prot.Read.reader
        =
        fun _of__perms -> bin_read_t_
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        (fun bin_reader_perms ->
           { read = (fun buf ~pos_ref -> (bin_read_t bin_reader_perms.read) buf ~pos_ref)
           ; vtag_read =
               (fun buf ~pos_ref vtag ->
                 (__bin_read_t__ bin_reader_perms.read) buf ~pos_ref vtag)
           }
         : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        (fun bin_perms ->
           { writer = bin_writer_t bin_perms.writer
           ; reader = bin_reader_t bin_perms.reader
           ; shape = bin_shape_t bin_perms.shape
           }
         : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare
        :  'perms.
           ('perms -> ('perms[@merlin.hide]) -> int)
        -> 'perms t
        -> ('perms t[@merlin.hide])
        -> int
        =
        fun _cmp__perms a__034_ b__035_ -> compare_t_ a__034_ b__035_
      ;;

      let _ = compare

      let t_of_sexp : 'perms. (Sexplib0.Sexp.t -> 'perms) -> Sexplib0.Sexp.t -> 'perms t =
        fun _of_perms__036_ -> t__of_sexp
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'perms. ('perms -> Sexplib0.Sexp.t) -> 'perms t -> Sexplib0.Sexp.t =
        fun _of_perms__038_ -> sexp_of_t_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  let to_array_id = Fn.id
  let of_array_id = Fn.id

  include (T : Permissioned with type ('a, 'b) t := ('a, 'b) t) [@ocaml.warning "-3"]

  let to_array = copy
  let to_sequence_immutable = to_sequence_mutable
end

module type S = sig
  type 'a t

  include Binary_searchable.S1 with type 'a t := 'a t
  include Indexed_container.S1_with_creators with type 'a t := 'a t

  external length : ('a t[@local_opt]) -> int = "%array_length"
  external get : ('a t[@local_opt]) -> (int[@local_opt]) -> 'a = "%array_safe_get"
  external set : ('a t[@local_opt]) -> (int[@local_opt]) -> 'a -> unit = "%array_safe_set"

  external unsafe_get
    :  ('a t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    = "%array_unsafe_get"

  external unsafe_set
    :  ('a t[@local_opt])
    -> (int[@local_opt])
    -> 'a
    -> unit
    = "%array_unsafe_set"

  val create : len:int -> 'a -> 'a t
  val create_local : len:int -> 'a -> 'a t
  val create_float_uninitialized : len:int -> float t
  val init : int -> f:(int -> 'a) -> 'a t
  val make_matrix : dimx:int -> dimy:int -> 'a -> 'a t t
  val copy_matrix : 'a t t -> 'a t t
  val append : 'a t -> 'a t -> 'a t
  val concat : 'a t list -> 'a t
  val copy : 'a t -> 'a t
  val fill : 'a t -> pos:int -> len:int -> 'a -> unit

  include Blit.S1 with type 'a t := 'a t

  val of_list : 'a list -> 'a t
  val map : 'a t -> f:('a -> 'b) -> 'b t
  val folding_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'b t
  val fold_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t
  val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
  val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
  val foldi : 'a t -> init:'b -> f:(int -> 'b -> 'a -> 'b) -> 'b
  val folding_mapi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'b t
  val fold_mapi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'acc * 'b t
  val fold_right : 'a t -> f:('a -> 'acc -> 'acc) -> init:'acc -> 'acc
  val sort : ?pos:int -> ?len:int -> 'a t -> compare:('a -> 'a -> int) -> unit
  val stable_sort : 'a t -> compare:('a -> 'a -> int) -> unit
  val is_sorted : 'a t -> compare:('a -> 'a -> int) -> bool
  val is_sorted_strictly : 'a t -> compare:('a -> 'a -> int) -> bool
  val merge : 'a t -> 'a t -> compare:('a -> 'a -> int) -> 'a t
  val concat_map : 'a t -> f:('a -> 'b t) -> 'b t
  val concat_mapi : 'a t -> f:(int -> 'a -> 'b t) -> 'b t
  val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t
  val partitioni_tf : 'a t -> f:(int -> 'a -> bool) -> 'a t * 'a t
  val cartesian_product : 'a t -> 'b t -> ('a * 'b) t
  val transpose : 'a t t -> 'a t t option
  val transpose_exn : 'a t t -> 'a t t
  val normalize : 'a t -> int -> int
  val slice : 'a t -> int -> int -> 'a t
  val nget : 'a t -> int -> 'a
  val nset : 'a t -> int -> 'a -> unit
  val filter_opt : 'a option t -> 'a t
  val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
  val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t
  val for_alli : 'a t -> f:(int -> 'a -> bool) -> bool
  val existsi : 'a t -> f:(int -> 'a -> bool) -> bool
  val counti : 'a t -> f:(int -> 'a -> bool) -> int
  val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit
  val map2_exn : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
  val fold2_exn : 'a t -> 'b t -> init:'acc -> f:('acc -> 'a -> 'b -> 'acc) -> 'acc
  val for_all2_exn : 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
  val exists2_exn : 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
  val filter : 'a t -> f:('a -> bool) -> 'a t
  val filteri : 'a t -> f:(int -> 'a -> bool) -> 'a t
  val swap : 'a t -> int -> int -> unit
  val rev_inplace : 'a t -> unit
  val rev : 'a t -> 'a t
  val of_list_rev : 'a list -> 'a t
  val of_list_map : 'a list -> f:('a -> 'b) -> 'b t
  val of_list_mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b t
  val of_list_rev_map : 'a list -> f:('a -> 'b) -> 'b t
  val of_list_rev_mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b t
  val map_inplace : 'a t -> f:('a -> 'a) -> unit
  val find_exn : 'a t -> f:('a -> bool) -> 'a
  val find_map_exn : 'a t -> f:('a -> 'b option) -> 'b
  val findi : 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
  val findi_exn : 'a t -> f:(int -> 'a -> bool) -> int * 'a
  val find_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b option
  val find_mapi_exn : 'a t -> f:(int -> 'a -> 'b option) -> 'b
  val find_consecutive_duplicate : 'a t -> equal:('a -> 'a -> bool) -> ('a * 'a) option
  val reduce : 'a t -> f:('a -> 'a -> 'a) -> 'a option
  val reduce_exn : 'a t -> f:('a -> 'a -> 'a) -> 'a
  val permute : ?random_state:Random.State.t -> ?pos:int -> ?len:int -> 'a t -> unit
  val random_element : ?random_state:Random.State.t -> 'a t -> 'a option
  val random_element_exn : ?random_state:Random.State.t -> 'a t -> 'a
  val zip : 'a t -> 'b t -> ('a * 'b) t option
  val zip_exn : 'a t -> 'b t -> ('a * 'b) t
  val unzip : ('a * 'b) t -> 'a t * 'b t
  val sorted_copy : 'a t -> compare:('a -> 'a -> int) -> 'a t
  val last : 'a t -> 'a
  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val equal__local : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val to_sequence : 'a t -> 'a Core_sequence.t
  val to_sequence_mutable : 'a t -> 'a Core_sequence.t
end

include (T : S with type 'a t := 'a array) [@ocaml.warning "-3"]

let invariant invariant_a t = iter t ~f:invariant_a
let max_length = Sys.max_array_length

module Int = struct
  include T.Int

  type t = t_ [@@deriving bin_io ~localize, compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:559:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t_ ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_t___local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_t___local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t___
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_t_
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
      (fun a__039_ b__040_ -> compare_t_ a__039_ b__040_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let t_of_sexp = (t__of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_t_ : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Float = struct
  include T.Float

  type t = t_ [@@deriving bin_io ~localize, compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "array.ml.before-ppx:565:2")
          [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t_ ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t
    let bin_size_t__local : t Bin_prot.Size.sizer_local = bin_size_t___local
    let _ = bin_size_t__local
    let bin_size_t = (bin_size_t__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_t
    let bin_write_t__local : t Bin_prot.Write.writer_local = bin_write_t___local
    let _ = bin_write_t__local
    let bin_write_t = (bin_write_t__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t
    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t___
    let _ = __bin_read_t__
    let bin_read_t : t Bin_prot.Read.reader = bin_read_t_
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
      (fun a__042_ b__043_ -> compare_t_ a__042_ b__043_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let t_of_sexp = (t__of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_t_ : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module _ (M : S) : sig
  type ('a, -'perm) t_

  include Permissioned with type ('a, 'perm) t := ('a, 'perm) t_
end = struct
  include M

  type ('a, -'perm) t_ = 'a t
end

module _ (M : Permissioned) : sig
  type 'a t_

  include S with type 'a t := 'a t_
end = struct
  include M

  type 'a t_ = ('a, read_write) t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
