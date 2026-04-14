let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"import.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "import.ml.before-ppx"
;;

module Applicative = Base.Applicative
module Avltree = Base.Avltree
module Backtrace = Base.Backtrace
module Binary_search = Base.Binary_search
module Comparisons = Base.Comparisons
module Continue_or_stop = Base.Continue_or_stop
module Equal = Base.Equal
module Exn = Base.Exn
module Floatable = Base.Floatable
module Formatter = Base.Formatter
module Hash = Base.Hash
module Hasher = Base.Hasher
module Intable = Base.Intable
module Int_conversions = Base.Int_conversions
module Int_math = Base.Int_math
module Invariant = Base.Invariant
module Monad = Base.Monad
module Poly = Base.Poly
module Pretty_printer = Base.Pretty_printer
module Random = Base.Random
module Staged = Base.Staged
module Stringable = Base.Stringable
module Sys = Base.Sys
module With_return = Base.With_return
module Word_size = Base.Word_size
include Base.Export
include Stdio
include Base_for_tests
include Bin_prot.Std
include Stable_witness.Export
module Field = Fieldslib.Field

module From_sexplib : sig
  type bigstring = Sexplib.Conv.bigstring [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_bigstring : bigstring -> Sexplib0.Sexp.t
    val bigstring_of_sexp : Sexplib0.Sexp.t -> bigstring
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type mat = Sexplib.Conv.mat [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_mat : mat -> Sexplib0.Sexp.t
    val mat_of_sexp : Sexplib0.Sexp.t -> mat
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type vec = Sexplib.Conv.vec [@@deriving sexp]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_vec : vec -> Sexplib0.Sexp.t
    val vec_of_sexp : Sexplib0.Sexp.t -> vec
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val sexp_of_opaque : _ -> Base.Sexp.t
  val opaque_of_sexp : Base.Sexp.t -> _
  val sexp_of_pair : ('a -> Base.Sexp.t) -> ('b -> Base.Sexp.t) -> 'a * 'b -> Base.Sexp.t
  val pair_of_sexp : (Base.Sexp.t -> 'a) -> (Base.Sexp.t -> 'b) -> Base.Sexp.t -> 'a * 'b

  exception Of_sexp_error of exn * Base.Sexp.t

  val of_sexp_error : string -> Base.Sexp.t -> _
  val of_sexp_error_exn : exn -> Base.Sexp.t -> _
end =
  Sexplib.Conv

include From_sexplib

include (
struct
  type 'a sexp_opaque = 'a [@@deriving bin_io, compare, hash, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a sexp_opaque) -> ()

    let bin_shape_sexp_opaque =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "import.ml.before-ppx:68:4")
          [ ( Bin_prot.Shape.Tid.of_string "sexp_opaque"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Bin_prot.Shape.var
                (Bin_prot.Shape.Location.of_string "import.ml.before-ppx:68:26")
                (Bin_prot.Shape.Vid.of_string "a") )
          ]
      in
      fun a ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "sexp_opaque")) [ a ]
    ;;

    let _ = bin_shape_sexp_opaque

    let bin_size_sexp_opaque
      : 'a. 'a Bin_prot.Size.sizer -> 'a sexp_opaque Bin_prot.Size.sizer
      =
      fun _size_of_a -> _size_of_a
    ;;

    let _ = bin_size_sexp_opaque

    let bin_write_sexp_opaque
      : 'a. 'a Bin_prot.Write.writer -> 'a sexp_opaque Bin_prot.Write.writer
      =
      fun _write_a -> _write_a
    ;;

    let _ = bin_write_sexp_opaque

    let bin_writer_sexp_opaque =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_sexp_opaque bin_writer_a.size v)
         ; write = (fun v -> bin_write_sexp_opaque bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_sexp_opaque

    let __bin_read_sexp_opaque__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a sexp_opaque) Bin_prot.Read.reader
      =
      fun _of__a _buf ~pos_ref _vint ->
      Bin_prot.Common.raise_read_error
        (Bin_prot.Common.ReadError.Silly_type "import.ml.before-ppx.sexp_opaque")
        !pos_ref
    ;;

    let _ = __bin_read_sexp_opaque__

    let bin_read_sexp_opaque
      : 'a. 'a Bin_prot.Read.reader -> 'a sexp_opaque Bin_prot.Read.reader
      =
      fun _of__a -> _of__a
    ;;

    let _ = bin_read_sexp_opaque

    let bin_reader_sexp_opaque =
      (fun bin_reader_a ->
         { read =
             (fun buf ~pos_ref -> (bin_read_sexp_opaque bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_sexp_opaque__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_sexp_opaque

    let bin_sexp_opaque =
      (fun bin_a ->
         { writer = bin_writer_sexp_opaque bin_a.writer
         ; reader = bin_reader_sexp_opaque bin_a.reader
         ; shape = bin_shape_sexp_opaque bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_sexp_opaque

    let compare_sexp_opaque
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a sexp_opaque
      -> ('a sexp_opaque[@merlin.hide])
      -> int
      =
      fun _cmp__a a__001_ b__002_ -> _cmp__a a__001_ b__002_
    ;;

    let _ = compare_sexp_opaque

    let hash_fold_sexp_opaque
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a sexp_opaque
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg -> _hash_fold_a hsv arg
    ;;

    let _ = hash_fold_sexp_opaque

    module Typename_of_sexp_opaque = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a sexp_opaque

        let name = "import.ml.before-ppx.sexp_opaque"
        let _ = name
      end)

    let typename_of_sexp_opaque = Typename_of_sexp_opaque.typename_of_t
    let _ = typename_of_sexp_opaque

    let typerep_of_sexp_opaque
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a sexp_opaque Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_sexp_opaque = Typename_of_sexp_opaque.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_sexp_opaque, Some (lazy _of_a))
    ;;

    let _ = typerep_of_sexp_opaque
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end :
  sig
    type 'a sexp_opaque [@@deriving bin_io, compare, hash, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_sexp_opaque : Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_sexp_opaque
        :  'a Bin_prot.Size.sizer
        -> 'a sexp_opaque Bin_prot.Size.sizer

      val bin_write_sexp_opaque
        :  'a Bin_prot.Write.writer
        -> 'a sexp_opaque Bin_prot.Write.writer

      val bin_writer_sexp_opaque
        :  'a Bin_prot.Type_class.writer
        -> 'a sexp_opaque Bin_prot.Type_class.writer

      val bin_read_sexp_opaque
        :  'a Bin_prot.Read.reader
        -> 'a sexp_opaque Bin_prot.Read.reader

      val __bin_read_sexp_opaque__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a sexp_opaque) Bin_prot.Read.reader

      val bin_reader_sexp_opaque
        :  'a Bin_prot.Type_class.reader
        -> 'a sexp_opaque Bin_prot.Type_class.reader

      val bin_sexp_opaque
        :  'a Bin_prot.Type_class.t
        -> 'a sexp_opaque Bin_prot.Type_class.t

      val compare_sexp_opaque
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a sexp_opaque
        -> ('a sexp_opaque[@merlin.hide])
        -> int

      val hash_fold_sexp_opaque
        :  (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a sexp_opaque
        -> Ppx_hash_lib.Std.Hash.state

      val typerep_of_sexp_opaque
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a sexp_opaque Typerep_lib.Std.Typerep.t

      val typename_of_sexp_opaque
        :  'a Typerep_lib.Std.Typename.t
        -> 'a sexp_opaque Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  with type 'a sexp_opaque := 'a)

include (
  Typerep_lib.Std :
    module type of struct
      include Typerep_lib.Std
    end
    with module Type_equal := Typerep_lib.Std.Type_equal)

module Variant = Variantslib.Variant

let with_return = With_return.with_return

let am_running_test =
  try
    ignore (Stdlib.Sys.getenv "TESTING_FRAMEWORK" : string);
    true
  with
  | Stdlib.Not_found -> false
;;

type 'a identity = 'a

module Not_found = struct
  exception
    Not_found = Not_found
        [@deprecated
          {|[since 2018-02] Instead of raising [Not_found], consider using [raise_s] with an
informative error message.  If code needs to distinguish [Not_found] from other
exceptions, please change it to handle both [Not_found] and [Not_found_s].  Then, instead
of raising [Not_found], raise [Not_found_s] with an informative error message.|}]

  exception Not_found_s = Base.Not_found_s
end

include Not_found

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
