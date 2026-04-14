let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"tuple.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "tuple.ml.before-ppx"
;;

open! Import

module type T = sig
  type t
end

module Make (T1 : T) (T2 : T) = struct
  type t = T1.t * T2.t
end

module T2 = struct
  type ('a, 'b) t = 'a * 'b [@@deriving sexp, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : ('a, 'b) t) -> ()

    let t_of_sexp
      :  'a 'b.
         (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'b)
      -> Sexplib0.Sexp.t
      -> ('a, 'b) t
      =
      let error_source__009_ = "tuple.ml.before-ppx.T2.t" in
      fun _of_a__001_ _of_b__002_ -> function
        | Sexplib0.Sexp.List [ arg0__004_; arg1__005_ ] ->
          let res0__006_ = _of_a__001_ arg0__004_
          and res1__007_ = _of_b__002_ arg1__005_ in
          res0__006_, res1__007_
        | sexp__008_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__009_
            2
            sexp__008_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a 'b.
         ('a -> Sexplib0.Sexp.t)
      -> ('b -> Sexplib0.Sexp.t)
      -> ('a, 'b) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a__010_ _of_b__011_ (arg0__012_, arg1__013_) ->
      let res0__014_ = _of_a__010_ arg0__012_
      and res1__015_ = _of_b__011_ arg1__013_ in
      Sexplib0.Sexp.List [ res0__014_; res1__015_ ]
    ;;

    let _ = sexp_of_t

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make2 (struct
        type nonrec ('a, 'b) t = ('a, 'b) t

        let name = "tuple.ml.before-ppx.T2.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t
      :  'a 'b.
         'a Typerep_lib.Std.Typerep.t
      -> 'b Typerep_lib.Std.Typerep.t
      -> ('a, 'b) t Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (type b) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) (_of_b : b Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a _of_b in
      Typerep_lib.Std.Typerep.Named
        (name_of_t, Some (lazy (typerep_of_tuple2 _of_a _of_b)))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create a b = a, b

  let curry f =
    ();
    fun a b -> f (a, b)
  ;;

  let uncurry f =
    ();
    fun (a, b) -> f a b
  ;;

  [%%if flambda_backend]

  external get1 : (('a, _) t[@local_opt]) -> ('a[@local_opt]) = "%field0_immut"
  external get2 : ((_, 'a) t[@local_opt]) -> ('a[@local_opt]) = "%field1_immut"

  [%%else]

  external get1 : (('a, _) t[@local_opt]) -> ('a[@local_opt]) = "%field0"
  external get2 : ((_, 'a) t[@local_opt]) -> ('a[@local_opt]) = "%field1"

  [%%endif]

  let map (x, y) ~f = f x, f y
  let map_fst (x, y) ~f = f x, y
  let map_snd (x, y) ~f = x, f y
  let map_both (x, y) ~f1 ~f2 = f1 x, f2 y
  let map2 (x1, y1) (x2, y2) ~f = f x1 x2, f y1 y2

  let compare ~cmp1 ~cmp2 (x, y) (x', y') =
    match cmp1 x x' with
    | 0 -> cmp2 y y'
    | i -> i
  ;;

  let equal ~eq1 ~eq2 (x, y) (x', y') = eq1 x x' && eq2 y y'
  let swap (a, b) = b, a

  include Comparator.Derived2 (struct
      type nonrec ('a, 'b) t = ('a, 'b) t [@@deriving sexp_of]

      include struct
        let _ = fun (_ : ('a, 'b) t) -> ()

        let sexp_of_t
          :  'a 'b.
             ('a -> Sexplib0.Sexp.t)
          -> ('b -> Sexplib0.Sexp.t)
          -> ('a, 'b) t
          -> Sexplib0.Sexp.t
          =
          fun _of_a__016_ _of_b__017_ x__018_ -> sexp_of_t _of_a__016_ _of_b__017_ x__018_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let compare cmp1 cmp2 = compare ~cmp1 ~cmp2
    end)
end

module T3 = struct
  type ('a, 'b, 'c) t = 'a * 'b * 'c [@@deriving sexp, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : ('a, 'b, 'c) t) -> ()

    let t_of_sexp
      :  'a 'b 'c.
         (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'b)
      -> (Sexplib0.Sexp.t -> 'c)
      -> Sexplib0.Sexp.t
      -> ('a, 'b, 'c) t
      =
      let error_source__030_ = "tuple.ml.before-ppx.T3.t" in
      fun _of_a__019_ _of_b__020_ _of_c__021_ -> function
        | Sexplib0.Sexp.List [ arg0__023_; arg1__024_; arg2__025_ ] ->
          let res0__026_ = _of_a__019_ arg0__023_
          and res1__027_ = _of_b__020_ arg1__024_
          and res2__028_ = _of_c__021_ arg2__025_ in
          res0__026_, res1__027_, res2__028_
        | sexp__029_ ->
          Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
            error_source__030_
            3
            sexp__029_
    ;;

    let _ = t_of_sexp

    let sexp_of_t
      :  'a 'b 'c.
         ('a -> Sexplib0.Sexp.t)
      -> ('b -> Sexplib0.Sexp.t)
      -> ('c -> Sexplib0.Sexp.t)
      -> ('a, 'b, 'c) t
      -> Sexplib0.Sexp.t
      =
      fun _of_a__031_ _of_b__032_ _of_c__033_ (arg0__034_, arg1__035_, arg2__036_) ->
      let res0__037_ = _of_a__031_ arg0__034_
      and res1__038_ = _of_b__032_ arg1__035_
      and res2__039_ = _of_c__033_ arg2__036_ in
      Sexplib0.Sexp.List [ res0__037_; res1__038_; res2__039_ ]
    ;;

    let _ = sexp_of_t

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make3 (struct
        type nonrec ('a, 'b, 'c) t = ('a, 'b, 'c) t

        let name = "tuple.ml.before-ppx.T3.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t
      :  'a 'b 'c.
         'a Typerep_lib.Std.Typerep.t
      -> 'b Typerep_lib.Std.Typerep.t
      -> 'c Typerep_lib.Std.Typerep.t
      -> ('a, 'b, 'c) t Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (type b) ->
      fun (type c) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t)
        (_of_b : b Typerep_lib.Std.Typerep.t)
        (_of_c : c Typerep_lib.Std.Typerep.t) ->
      let name_of_t = Typename_of_t.named _of_a _of_b _of_c in
      Typerep_lib.Std.Typerep.Named
        (name_of_t, Some (lazy (typerep_of_tuple3 _of_a _of_b _of_c)))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create a b c = a, b, c

  let curry f =
    ();
    fun a b c -> f (a, b, c)
  ;;

  let uncurry f =
    ();
    fun (a, b, c) -> f a b c
  ;;

  let map (x, y, z) ~f = f x, f y, f z
  let map_fst (x, y, z) ~f = f x, y, z
  let map_snd (x, y, z) ~f = x, f y, z
  let map_trd (x, y, z) ~f = x, y, f z
  let map_all (x, y, z) ~f1 ~f2 ~f3 = f1 x, f2 y, f3 z
  let map2 (x1, y1, z1) (x2, y2, z2) ~f = f x1 x2, f y1 y2, f z1 z2

  [%%if flambda_backend]

  external get1 : (('a, _, _) t[@local_opt]) -> ('a[@local_opt]) = "%field0_immut"
  external get2 : ((_, 'a, _) t[@local_opt]) -> ('a[@local_opt]) = "%field1_immut"

  [%%else]

  external get1 : (('a, _, _) t[@local_opt]) -> ('a[@local_opt]) = "%field0"
  external get2 : ((_, 'a, _) t[@local_opt]) -> ('a[@local_opt]) = "%field1"

  [%%endif]

  let get3 (_, _, a) = a

  let compare ~cmp1 ~cmp2 ~cmp3 (x, y, z) (x', y', z') =
    let c1 = cmp1 x x' in
    if c1 <> 0
    then c1
    else (
      let c2 = cmp2 y y' in
      if c2 <> 0 then c2 else cmp3 z z')
  ;;

  let equal ~eq1 ~eq2 ~eq3 (x, y, z) (x', y', z') = eq1 x x' && eq2 y y' && eq3 z z'
end

module type Comparable_sexpable = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t
end

module type Hashable_sexpable = sig
  type t [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Hashable.S with type t := t
end

module type Hasher_sexpable = sig
  type t [@@deriving compare, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Sexpable (S1 : Sexpable.S) (S2 : Sexpable.S) = struct
  type t = S1.t * S2.t [@@deriving sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__046_ = "tuple.ml.before-ppx.Sexpable.t" in
       function
       | Sexplib0.Sexp.List [ arg0__041_; arg1__042_ ] ->
         let res0__043_ = S1.t_of_sexp arg0__041_
         and res1__044_ = S2.t_of_sexp arg1__042_ in
         res0__043_, res1__044_
       | sexp__045_ ->
         Sexplib0.Sexp_conv_error.tuple_of_size_n_expected error_source__046_ 2 sexp__045_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun (arg0__047_, arg1__048_) ->
         let res0__049_ = S1.sexp_of_t arg0__047_
         and res1__050_ = S2.sexp_of_t arg1__048_ in
         Sexplib0.Sexp.List [ res0__049_; res1__050_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Binable (B1 : Binable.S) (B2 : Binable.S) = struct
  type t = B1.t * B2.t [@@deriving bin_io]

  include struct
    let _ = fun (_ : t) -> ()

    let bin_shape_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "tuple.ml.before-ppx:131:2")
          [ ( Bin_prot.Shape.Tid.of_string "t"
            , []
            , Bin_prot.Shape.tuple [ B1.bin_shape_t; B2.bin_shape_t ] )
          ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
    ;;

    let _ = bin_shape_t

    let bin_size_t : t Bin_prot.Size.sizer = function
      | v1, v2 ->
        let size = 0 in
        let size = Bin_prot.Common.( + ) size (B1.bin_size_t v1) in
        Bin_prot.Common.( + ) size (B2.bin_size_t v2)
    ;;

    let _ = bin_size_t

    let bin_write_t : t Bin_prot.Write.writer =
      fun buf ~pos -> function
      | v1, v2 ->
        let pos = B1.bin_write_t buf ~pos v1 in
        B2.bin_write_t buf ~pos v2
    ;;

    let _ = bin_write_t

    let bin_writer_t =
      ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_t

    let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
      fun _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_variant_wrong_type "tuple.ml.before-ppx.Binable.t" !pos_ref
    ;;

    let _ = __bin_read_t__

    let bin_read_t : t Bin_prot.Read.reader =
      fun buf ~pos_ref ->
      let v1 = B1.bin_read_t buf ~pos_ref in
      let v2 = B2.bin_read_t buf ~pos_ref in
      v1, v2
    ;;

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

module Comparator (S1 : Comparator.S) (S2 : Comparator.S) = struct
  include Make (S1) (S2)

  type comparator_witness =
    (S1.comparator_witness, S2.comparator_witness) T2.comparator_witness

  let comparator = T2.comparator S1.comparator S2.comparator
end

module Comparable_plain (S1 : Comparable.S_plain) (S2 : Comparable.S_plain) = struct
  module T = struct
    include Comparator (S1) (S2)

    let sexp_of_t = comparator.sexp_of_t
  end

  include T
  include Comparable.Make_plain_using_comparator (T)
end

module Comparable (S1 : Comparable_sexpable) (S2 : Comparable_sexpable) = struct
  module T = struct
    include Sexpable (S1) (S2)

    let compare (s1, s2) (s1', s2') =
      match S1.compare s1 s1' with
      | 0 -> S2.compare s2 s2'
      | x -> x
    ;;
  end

  include T
  include Comparable.Make (T)
end

module Hasher (H1 : Hasher_sexpable) (H2 : Hasher_sexpable) = struct
  module T = struct
    type t = H1.t * H2.t [@@deriving compare, hash, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__051_ b__052_ ->
           let t__053_, t__054_ = a__051_ in
           let t__055_, t__056_ = b__052_ in
           match H1.compare t__053_ t__055_ with
           | 0 -> H2.compare t__054_ t__056_
           | n -> n
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let e0, e1 = arg in
        let hsv = H1.hash_fold_t hsv e0 in
        let hsv = H2.hash_fold_t hsv e1 in
        hsv
      ;;

      let _ = hash_fold_t

      let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func arg =
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg)
        in
        fun x -> func x
      ;;

      let _ = hash

      let t_of_sexp =
        (let error_source__063_ = "tuple.ml.before-ppx.Hasher.T.t" in
         function
         | Sexplib0.Sexp.List [ arg0__058_; arg1__059_ ] ->
           let res0__060_ = H1.t_of_sexp arg0__058_
           and res1__061_ = H2.t_of_sexp arg1__059_ in
           res0__060_, res1__061_
         | sexp__062_ ->
           Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
             error_source__063_
             2
             sexp__062_
         : Sexplib0.Sexp.t -> t)
      ;;

      let _ = t_of_sexp

      let sexp_of_t =
        (fun (arg0__064_, arg1__065_) ->
           let res0__066_ = H1.sexp_of_t arg0__064_
           and res1__067_ = H2.sexp_of_t arg1__065_ in
           Sexplib0.Sexp.List [ res0__066_; res1__067_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  include T
  include Hashable.Make (T)
end

module Hasher_sexpable_of_hashable_sexpable (S : Hashable_sexpable) :
  Hasher_sexpable with type t = S.t = struct
  include S

  let hash_fold_t state t = hash_fold_int state (hash t)
end

module Hashable_t (S1 : Hashable_sexpable) (S2 : Hashable_sexpable) =
  Hasher
    (Hasher_sexpable_of_hashable_sexpable
       (S1))
       (Hasher_sexpable_of_hashable_sexpable (S2))

module Hashable = Hashable_t

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
