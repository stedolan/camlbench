let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"std_internal.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "std_internal.ml.before-ppx"
;;

open! Import

include Core_pervasives [@@ocaml.doc
                          " [include]d first so that everything else shadows it "]

include Int.Replace_polymorphic_compare
include Base_quickcheck.Export
include Deprecate_pipe_bang
include Either.Export
include From_sexplib
include Interfaces
include List.Infix
include Never_returns
include Ordering.Export
include Perms.Export
include Result.Export

type -'a return = 'a With_return.return = private { return : 'b. 'a -> 'b } [@@unboxed]

exception
  C_malloc_exn of int * int
      [@ocaml.doc " Raised if malloc in C bindings fail (errno * size). "]

let () = Callback.register_exception "C_malloc_exn" (C_malloc_exn (0, 0))

exception Finally = Exn.Finally

let fst3 (x, _, _) = x
let snd3 (_, y, _) = y
let trd3 (_, _, z) = z

external phys_same : ('a[@local_opt]) -> ('b[@local_opt]) -> bool = "%eq"
[@@ocaml.doc
  " [phys_same] is like [phys_equal], but with a more general type.  [phys_same] is useful\n\
  \    when dealing with existential types, when one has a packed value and an unpacked \
   value\n\
  \    that one wants to check are physically equal.  One can't use [phys_equal] in such a\n\
  \    situation because the types are different. "]

let ( % ) = Int.( % )
let ( /% ) = Int.( /% )
let ( // ) = Int.( // )
let ( ==> ) a b = (not a) || b
let bprintf = Printf.bprintf
let const = Fn.const
let eprintf = Printf.eprintf
let error = Or_error.error
let error_s = Or_error.error_s
let failwithf = Base.Printf.failwithf
let failwiths = Error.failwiths
let force = Base.Lazy.force
let fprintf = Printf.fprintf
let invalid_argf = Base.Printf.invalid_argf
let ifprintf = Printf.ifprintf
let is_none = Option.is_none
let is_some = Option.is_some
let ksprintf = Printf.ksprintf
let ok_exn = Or_error.ok_exn
let phys_equal = Base.phys_equal
let print_s = Stdio.print_s
let eprint_s = Stdio.eprint_s
let printf = Printf.printf
let protect = Exn.protect
let protectx = Exn.protectx
let raise_s = Error.raise_s
let round = Float.round
let ( **. ) = Base.( **. )
let ( %. ) = Base.( %. )
let sprintf = Printf.sprintf
let stage = Staged.stage
let unstage = Staged.unstage
let with_return = With_return.with_return
let with_return_option = With_return.with_return_option

include Typerep_lib.Std_internal

include (
struct
  type 'a array = 'a Array.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a array) -> ()

    let bin_shape_array =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:85:4")
          [ ( Bin_prot.Shape.Tid.of_string "array"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Array.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:85:20")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "array")) [ a ]
    ;;

    let _ = bin_shape_array

    let bin_size_array__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a array Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local v -> Array.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_array__local

    let bin_size_array : 'a. 'a Bin_prot.Size.sizer -> 'a array Bin_prot.Size.sizer =
      fun _size_of_a v -> Array.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_array

    let bin_write_array__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a array Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos v ->
      Array.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_array__local

    let bin_write_array : 'a. 'a Bin_prot.Write.writer -> 'a array Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> Array.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_array

    let bin_writer_array =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_array bin_writer_a.size v)
         ; write = (fun v -> bin_write_array bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_array

    let __bin_read_array__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a array) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (Array.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_array__

    let bin_read_array : 'a. 'a Bin_prot.Read.reader -> 'a array Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (Array.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_array

    let bin_reader_array =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_array bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_array__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_array

    let bin_array =
      (fun bin_a ->
         { writer = bin_writer_array bin_a.writer
         ; reader = bin_reader_array bin_a.reader
         ; shape = bin_shape_array bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_array

    let compare_array__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a array
      -> ('a array[@merlin.hide])
      -> int
      =
      fun _cmp__a a__005_ b__006_ ->
      Array.compare__local
        (fun a__007_ (b__008_ [@merlin.hide]) -> (_cmp__a a__007_ b__008_ [@merlin.hide]))
        a__005_
        b__006_
    ;;

    let _ = compare_array__local

    let compare_array
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a array
      -> ('a array[@merlin.hide])
      -> int
      =
      fun _cmp__a a__001_ b__002_ ->
      Array.compare
        (fun a__003_ (b__004_ [@merlin.hide]) -> (_cmp__a a__003_ b__004_ [@merlin.hide]))
        a__001_
        b__002_
    ;;

    let _ = compare_array

    let equal_array__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a array
      -> ('a array[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__013_ b__014_ ->
      Array.equal__local
        (fun a__015_ (b__016_ [@merlin.hide]) -> (_cmp__a a__015_ b__016_ [@merlin.hide]))
        a__013_
        b__014_
    ;;

    let _ = equal_array__local

    let equal_array
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a array
      -> ('a array[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__009_ b__010_ ->
      Array.equal
        (fun a__011_ (b__012_ [@merlin.hide]) -> (_cmp__a a__011_ b__012_ [@merlin.hide]))
        a__009_
        b__010_
    ;;

    let _ = equal_array

    let globalize_array : 'a. ('a -> 'a) -> 'a array -> 'a array =
      fun (type a__017_) ->
      (fun _globalize_a__018_ x__019_ -> Array.globalize _globalize_a__018_ x__019_
       : (a__017_ -> a__017_) -> a__017_ array -> a__017_ array)
    ;;

    let _ = globalize_array

    let array_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a array =
      fun _of_a__021_ x__023_ -> Array.t_of_sexp _of_a__021_ x__023_
    ;;

    let _ = array_of_sexp

    let sexp_of_array : 'a. ('a -> Sexplib0.Sexp.t) -> 'a array -> Sexplib0.Sexp.t =
      fun _of_a__024_ x__025_ -> Array.sexp_of_t _of_a__024_ x__025_
    ;;

    let _ = sexp_of_array

    let array_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a array Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Array.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = array_sexp_grammar

    module Typename_of_array = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a array

        let name = "std_internal.ml.before-ppx.array"
        let _ = name
      end)

    let typename_of_array = Typename_of_array.typename_of_t
    let _ = typename_of_array

    let typerep_of_array
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a array Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_array = Typename_of_array.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_array, Some (lazy (Array.typerep_of_t _of_a)))
    ;;

    let _ = typerep_of_array
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type bool = Bool.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : bool) -> ()

    let bin_shape_bool =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:95:4")
          [ Bin_prot.Shape.Tid.of_string "bool", [], Bool.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "bool")) []
    ;;

    let _ = bin_shape_bool
    let bin_size_bool__local : bool Bin_prot.Size.sizer_local = Bool.bin_size_t__local
    let _ = bin_size_bool__local
    let bin_size_bool = (bin_size_bool__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_bool
    let bin_write_bool__local : bool Bin_prot.Write.writer_local = Bool.bin_write_t__local
    let _ = bin_write_bool__local
    let bin_write_bool = (bin_write_bool__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_bool

    let bin_writer_bool =
      ({ size = bin_size_bool; write = bin_write_bool } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_bool
    let __bin_read_bool__ : (int -> bool) Bin_prot.Read.reader = Bool.__bin_read_t__
    let _ = __bin_read_bool__
    let bin_read_bool : bool Bin_prot.Read.reader = Bool.bin_read_t
    let _ = bin_read_bool

    let bin_reader_bool =
      ({ read = bin_read_bool; vtag_read = __bin_read_bool__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_bool

    let bin_bool =
      ({ writer = bin_writer_bool; reader = bin_reader_bool; shape = bin_shape_bool }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_bool

    let compare_bool__local =
      (fun a__026_ b__027_ -> Bool.compare__local a__026_ b__027_
       : bool -> (bool[@merlin.hide]) -> int)
    ;;

    let _ = compare_bool__local

    let compare_bool =
      (fun a b -> compare_bool__local a b : bool -> (bool[@merlin.hide]) -> int)
    ;;

    let _ = compare_bool

    let hash_fold_bool
      : Ppx_hash_lib.Std.Hash.state -> bool -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Bool.hash_fold_t hsv arg

    and hash_bool : bool -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Bool.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_bool
    and _ = hash_bool

    let equal_bool__local =
      (fun a__028_ b__029_ -> Bool.equal__local a__028_ b__029_
       : bool -> (bool[@merlin.hide]) -> bool)
    ;;

    let _ = equal_bool__local

    let equal_bool =
      (fun a b -> equal_bool__local a b : bool -> (bool[@merlin.hide]) -> bool)
    ;;

    let _ = equal_bool
    let globalize_bool : bool -> bool = (Bool.globalize : bool -> bool)
    let _ = globalize_bool
    let bool_of_sexp = (Bool.t_of_sexp : Sexplib0.Sexp.t -> bool)
    let _ = bool_of_sexp
    let sexp_of_bool = (Bool.sexp_of_t : bool -> Sexplib0.Sexp.t)
    let _ = sexp_of_bool
    let bool_sexp_grammar : bool Sexplib0.Sexp_grammar.t = Bool.t_sexp_grammar
    let _ = bool_sexp_grammar

    module Typename_of_bool = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = bool

        let name = "std_internal.ml.before-ppx.bool"
        let _ = name
      end)

    let typename_of_bool = Typename_of_bool.typename_of_t
    let _ = typename_of_bool

    let typerep_of_bool =
      let name_of_bool = Typename_of_bool.named in
      Typerep_lib.Std.Typerep.Named (name_of_bool, Some (lazy Bool.typerep_of_t))
    ;;

    let _ = typerep_of_bool
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type char = Char.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : char) -> ()

    let bin_shape_char =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:106:4")
          [ Bin_prot.Shape.Tid.of_string "char", [], Char.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "char")) []
    ;;

    let _ = bin_shape_char
    let bin_size_char__local : char Bin_prot.Size.sizer_local = Char.bin_size_t__local
    let _ = bin_size_char__local
    let bin_size_char = (bin_size_char__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_char
    let bin_write_char__local : char Bin_prot.Write.writer_local = Char.bin_write_t__local
    let _ = bin_write_char__local
    let bin_write_char = (bin_write_char__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_char

    let bin_writer_char =
      ({ size = bin_size_char; write = bin_write_char } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_char
    let __bin_read_char__ : (int -> char) Bin_prot.Read.reader = Char.__bin_read_t__
    let _ = __bin_read_char__
    let bin_read_char : char Bin_prot.Read.reader = Char.bin_read_t
    let _ = bin_read_char

    let bin_reader_char =
      ({ read = bin_read_char; vtag_read = __bin_read_char__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_char

    let bin_char =
      ({ writer = bin_writer_char; reader = bin_reader_char; shape = bin_shape_char }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_char

    let compare_char__local =
      (fun a__032_ b__033_ -> Char.compare__local a__032_ b__033_
       : char -> (char[@merlin.hide]) -> int)
    ;;

    let _ = compare_char__local

    let compare_char =
      (fun a b -> compare_char__local a b : char -> (char[@merlin.hide]) -> int)
    ;;

    let _ = compare_char

    let hash_fold_char
      : Ppx_hash_lib.Std.Hash.state -> char -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Char.hash_fold_t hsv arg

    and hash_char : char -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Char.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_char
    and _ = hash_char

    let equal_char__local =
      (fun a__034_ b__035_ -> Char.equal__local a__034_ b__035_
       : char -> (char[@merlin.hide]) -> bool)
    ;;

    let _ = equal_char__local

    let equal_char =
      (fun a b -> equal_char__local a b : char -> (char[@merlin.hide]) -> bool)
    ;;

    let _ = equal_char
    let globalize_char : char -> char = (Char.globalize : char -> char)
    let _ = globalize_char
    let char_of_sexp = (Char.t_of_sexp : Sexplib0.Sexp.t -> char)
    let _ = char_of_sexp
    let sexp_of_char = (Char.sexp_of_t : char -> Sexplib0.Sexp.t)
    let _ = sexp_of_char
    let char_sexp_grammar : char Sexplib0.Sexp_grammar.t = Char.t_sexp_grammar
    let _ = char_sexp_grammar

    module Typename_of_char = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = char

        let name = "std_internal.ml.before-ppx.char"
        let _ = name
      end)

    let typename_of_char = Typename_of_char.typename_of_t
    let _ = typename_of_char

    let typerep_of_char =
      let name_of_char = Typename_of_char.named in
      Typerep_lib.Std.Typerep.Named (name_of_char, Some (lazy Char.typerep_of_t))
    ;;

    let _ = typerep_of_char
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type float = Float.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : float) -> ()

    let bin_shape_float =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:117:4")
          [ Bin_prot.Shape.Tid.of_string "float", [], Float.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "float")) []
    ;;

    let _ = bin_shape_float
    let bin_size_float__local : float Bin_prot.Size.sizer_local = Float.bin_size_t__local
    let _ = bin_size_float__local
    let bin_size_float = (bin_size_float__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_float

    let bin_write_float__local : float Bin_prot.Write.writer_local =
      Float.bin_write_t__local
    ;;

    let _ = bin_write_float__local
    let bin_write_float = (bin_write_float__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_float

    let bin_writer_float =
      ({ size = bin_size_float; write = bin_write_float } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_float
    let __bin_read_float__ : (int -> float) Bin_prot.Read.reader = Float.__bin_read_t__
    let _ = __bin_read_float__
    let bin_read_float : float Bin_prot.Read.reader = Float.bin_read_t
    let _ = bin_read_float

    let bin_reader_float =
      ({ read = bin_read_float; vtag_read = __bin_read_float__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_float

    let bin_float =
      ({ writer = bin_writer_float; reader = bin_reader_float; shape = bin_shape_float }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_float

    let compare_float__local =
      (fun a__038_ b__039_ -> Float.compare__local a__038_ b__039_
       : float -> (float[@merlin.hide]) -> int)
    ;;

    let _ = compare_float__local

    let compare_float =
      (fun a b -> compare_float__local a b : float -> (float[@merlin.hide]) -> int)
    ;;

    let _ = compare_float

    let hash_fold_float
      : Ppx_hash_lib.Std.Hash.state -> float -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Float.hash_fold_t hsv arg

    and hash_float : float -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Float.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_float
    and _ = hash_float

    let equal_float__local =
      (fun a__040_ b__041_ -> Float.equal__local a__040_ b__041_
       : float -> (float[@merlin.hide]) -> bool)
    ;;

    let _ = equal_float__local

    let equal_float =
      (fun a b -> equal_float__local a b : float -> (float[@merlin.hide]) -> bool)
    ;;

    let _ = equal_float
    let globalize_float : float -> float = (Float.globalize : float -> float)
    let _ = globalize_float
    let float_of_sexp = (Float.t_of_sexp : Sexplib0.Sexp.t -> float)
    let _ = float_of_sexp
    let sexp_of_float = (Float.sexp_of_t : float -> Sexplib0.Sexp.t)
    let _ = sexp_of_float
    let float_sexp_grammar : float Sexplib0.Sexp_grammar.t = Float.t_sexp_grammar
    let _ = float_sexp_grammar

    module Typename_of_float = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = float

        let name = "std_internal.ml.before-ppx.float"
        let _ = name
      end)

    let typename_of_float = Typename_of_float.typename_of_t
    let _ = typename_of_float

    let typerep_of_float =
      let name_of_float = Typename_of_float.named in
      Typerep_lib.Std.Typerep.Named (name_of_float, Some (lazy Float.typerep_of_t))
    ;;

    let _ = typerep_of_float
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type int = Int.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : int) -> ()

    let bin_shape_int =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:128:4")
          [ Bin_prot.Shape.Tid.of_string "int", [], Int.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "int")) []
    ;;

    let _ = bin_shape_int
    let bin_size_int__local : int Bin_prot.Size.sizer_local = Int.bin_size_t__local
    let _ = bin_size_int__local
    let bin_size_int = (bin_size_int__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_int
    let bin_write_int__local : int Bin_prot.Write.writer_local = Int.bin_write_t__local
    let _ = bin_write_int__local
    let bin_write_int = (bin_write_int__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_int

    let bin_writer_int =
      ({ size = bin_size_int; write = bin_write_int } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_int
    let __bin_read_int__ : (int -> int) Bin_prot.Read.reader = Int.__bin_read_t__
    let _ = __bin_read_int__
    let bin_read_int : int Bin_prot.Read.reader = Int.bin_read_t
    let _ = bin_read_int

    let bin_reader_int =
      ({ read = bin_read_int; vtag_read = __bin_read_int__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_int

    let bin_int =
      ({ writer = bin_writer_int; reader = bin_reader_int; shape = bin_shape_int }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_int

    let compare_int__local =
      (fun a__044_ b__045_ -> Int.compare__local a__044_ b__045_
       : int -> (int[@merlin.hide]) -> int)
    ;;

    let _ = compare_int__local

    let compare_int =
      (fun a b -> compare_int__local a b : int -> (int[@merlin.hide]) -> int)
    ;;

    let _ = compare_int

    let hash_fold_int : Ppx_hash_lib.Std.Hash.state -> int -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Int.hash_fold_t hsv arg

    and hash_int : int -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_int
    and _ = hash_int

    let equal_int__local =
      (fun a__046_ b__047_ -> Int.equal__local a__046_ b__047_
       : int -> (int[@merlin.hide]) -> bool)
    ;;

    let _ = equal_int__local
    let equal_int = (fun a b -> equal_int__local a b : int -> (int[@merlin.hide]) -> bool)
    let _ = equal_int
    let globalize_int : int -> int = (Int.globalize : int -> int)
    let _ = globalize_int
    let int_of_sexp = (Int.t_of_sexp : Sexplib0.Sexp.t -> int)
    let _ = int_of_sexp
    let sexp_of_int = (Int.sexp_of_t : int -> Sexplib0.Sexp.t)
    let _ = sexp_of_int
    let int_sexp_grammar : int Sexplib0.Sexp_grammar.t = Int.t_sexp_grammar
    let _ = int_sexp_grammar

    module Typename_of_int = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = int

        let name = "std_internal.ml.before-ppx.int"
        let _ = name
      end)

    let typename_of_int = Typename_of_int.typename_of_t
    let _ = typename_of_int

    let typerep_of_int =
      let name_of_int = Typename_of_int.named in
      Typerep_lib.Std.Typerep.Named (name_of_int, Some (lazy Int.typerep_of_t))
    ;;

    let _ = typerep_of_int
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type int32 = Int32.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : int32) -> ()

    let bin_shape_int32 =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:139:4")
          [ Bin_prot.Shape.Tid.of_string "int32", [], Int32.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "int32")) []
    ;;

    let _ = bin_shape_int32
    let bin_size_int32__local : int32 Bin_prot.Size.sizer_local = Int32.bin_size_t__local
    let _ = bin_size_int32__local
    let bin_size_int32 = (bin_size_int32__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_int32

    let bin_write_int32__local : int32 Bin_prot.Write.writer_local =
      Int32.bin_write_t__local
    ;;

    let _ = bin_write_int32__local
    let bin_write_int32 = (bin_write_int32__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_int32

    let bin_writer_int32 =
      ({ size = bin_size_int32; write = bin_write_int32 } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_int32
    let __bin_read_int32__ : (int -> int32) Bin_prot.Read.reader = Int32.__bin_read_t__
    let _ = __bin_read_int32__
    let bin_read_int32 : int32 Bin_prot.Read.reader = Int32.bin_read_t
    let _ = bin_read_int32

    let bin_reader_int32 =
      ({ read = bin_read_int32; vtag_read = __bin_read_int32__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_int32

    let bin_int32 =
      ({ writer = bin_writer_int32; reader = bin_reader_int32; shape = bin_shape_int32 }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_int32

    let compare_int32__local =
      (fun a__050_ b__051_ -> Int32.compare__local a__050_ b__051_
       : int32 -> (int32[@merlin.hide]) -> int)
    ;;

    let _ = compare_int32__local

    let compare_int32 =
      (fun a b -> compare_int32__local a b : int32 -> (int32[@merlin.hide]) -> int)
    ;;

    let _ = compare_int32

    let hash_fold_int32
      : Ppx_hash_lib.Std.Hash.state -> int32 -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Int32.hash_fold_t hsv arg

    and hash_int32 : int32 -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int32.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_int32
    and _ = hash_int32

    let equal_int32__local =
      (fun a__052_ b__053_ -> Int32.equal__local a__052_ b__053_
       : int32 -> (int32[@merlin.hide]) -> bool)
    ;;

    let _ = equal_int32__local

    let equal_int32 =
      (fun a b -> equal_int32__local a b : int32 -> (int32[@merlin.hide]) -> bool)
    ;;

    let _ = equal_int32
    let globalize_int32 : int32 -> int32 = (Int32.globalize : int32 -> int32)
    let _ = globalize_int32
    let int32_of_sexp = (Int32.t_of_sexp : Sexplib0.Sexp.t -> int32)
    let _ = int32_of_sexp
    let sexp_of_int32 = (Int32.sexp_of_t : int32 -> Sexplib0.Sexp.t)
    let _ = sexp_of_int32
    let int32_sexp_grammar : int32 Sexplib0.Sexp_grammar.t = Int32.t_sexp_grammar
    let _ = int32_sexp_grammar

    module Typename_of_int32 = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = int32

        let name = "std_internal.ml.before-ppx.int32"
        let _ = name
      end)

    let typename_of_int32 = Typename_of_int32.typename_of_t
    let _ = typename_of_int32

    let typerep_of_int32 =
      let name_of_int32 = Typename_of_int32.named in
      Typerep_lib.Std.Typerep.Named (name_of_int32, Some (lazy Int32.typerep_of_t))
    ;;

    let _ = typerep_of_int32
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type int64 = Int64.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : int64) -> ()

    let bin_shape_int64 =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:150:4")
          [ Bin_prot.Shape.Tid.of_string "int64", [], Int64.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "int64")) []
    ;;

    let _ = bin_shape_int64
    let bin_size_int64__local : int64 Bin_prot.Size.sizer_local = Int64.bin_size_t__local
    let _ = bin_size_int64__local
    let bin_size_int64 = (bin_size_int64__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_int64

    let bin_write_int64__local : int64 Bin_prot.Write.writer_local =
      Int64.bin_write_t__local
    ;;

    let _ = bin_write_int64__local
    let bin_write_int64 = (bin_write_int64__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_int64

    let bin_writer_int64 =
      ({ size = bin_size_int64; write = bin_write_int64 } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_int64
    let __bin_read_int64__ : (int -> int64) Bin_prot.Read.reader = Int64.__bin_read_t__
    let _ = __bin_read_int64__
    let bin_read_int64 : int64 Bin_prot.Read.reader = Int64.bin_read_t
    let _ = bin_read_int64

    let bin_reader_int64 =
      ({ read = bin_read_int64; vtag_read = __bin_read_int64__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_int64

    let bin_int64 =
      ({ writer = bin_writer_int64; reader = bin_reader_int64; shape = bin_shape_int64 }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_int64

    let compare_int64__local =
      (fun a__056_ b__057_ -> Int64.compare__local a__056_ b__057_
       : int64 -> (int64[@merlin.hide]) -> int)
    ;;

    let _ = compare_int64__local

    let compare_int64 =
      (fun a b -> compare_int64__local a b : int64 -> (int64[@merlin.hide]) -> int)
    ;;

    let _ = compare_int64

    let hash_fold_int64
      : Ppx_hash_lib.Std.Hash.state -> int64 -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Int64.hash_fold_t hsv arg

    and hash_int64 : int64 -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Int64.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_int64
    and _ = hash_int64

    let equal_int64__local =
      (fun a__058_ b__059_ -> Int64.equal__local a__058_ b__059_
       : int64 -> (int64[@merlin.hide]) -> bool)
    ;;

    let _ = equal_int64__local

    let equal_int64 =
      (fun a b -> equal_int64__local a b : int64 -> (int64[@merlin.hide]) -> bool)
    ;;

    let _ = equal_int64
    let globalize_int64 : int64 -> int64 = (Int64.globalize : int64 -> int64)
    let _ = globalize_int64
    let int64_of_sexp = (Int64.t_of_sexp : Sexplib0.Sexp.t -> int64)
    let _ = int64_of_sexp
    let sexp_of_int64 = (Int64.sexp_of_t : int64 -> Sexplib0.Sexp.t)
    let _ = sexp_of_int64
    let int64_sexp_grammar : int64 Sexplib0.Sexp_grammar.t = Int64.t_sexp_grammar
    let _ = int64_sexp_grammar

    module Typename_of_int64 = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = int64

        let name = "std_internal.ml.before-ppx.int64"
        let _ = name
      end)

    let typename_of_int64 = Typename_of_int64.typename_of_t
    let _ = typename_of_int64

    let typerep_of_int64 =
      let name_of_int64 = Typename_of_int64.named in
      Typerep_lib.Std.Typerep.Named (name_of_int64, Some (lazy Int64.typerep_of_t))
    ;;

    let _ = typerep_of_int64
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a lazy_t = 'a Lazy.t
  [@@deriving bin_io ~localize, compare ~localize, hash, sexp, sexp_grammar, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a lazy_t) -> ()

    let bin_shape_lazy_t =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:161:4")
          [ ( Bin_prot.Shape.Tid.of_string "lazy_t"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Lazy.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:161:21")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "lazy_t")) [ a ]
    ;;

    let _ = bin_shape_lazy_t

    let bin_size_lazy_t__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a lazy_t Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local v -> Lazy.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_lazy_t__local

    let bin_size_lazy_t : 'a. 'a Bin_prot.Size.sizer -> 'a lazy_t Bin_prot.Size.sizer =
      fun _size_of_a v -> Lazy.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_lazy_t

    let bin_write_lazy_t__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a lazy_t Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos v -> Lazy.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_lazy_t__local

    let bin_write_lazy_t : 'a. 'a Bin_prot.Write.writer -> 'a lazy_t Bin_prot.Write.writer
      =
      fun _write_a buf ~pos v -> Lazy.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_lazy_t

    let bin_writer_lazy_t =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_lazy_t bin_writer_a.size v)
         ; write = (fun v -> bin_write_lazy_t bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_lazy_t

    let __bin_read_lazy_t__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a lazy_t) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (Lazy.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_lazy_t__

    let bin_read_lazy_t : 'a. 'a Bin_prot.Read.reader -> 'a lazy_t Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (Lazy.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_lazy_t

    let bin_reader_lazy_t =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_lazy_t bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_lazy_t__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_lazy_t

    let bin_lazy_t =
      (fun bin_a ->
         { writer = bin_writer_lazy_t bin_a.writer
         ; reader = bin_reader_lazy_t bin_a.reader
         ; shape = bin_shape_lazy_t bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_lazy_t

    let compare_lazy_t__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a lazy_t
      -> ('a lazy_t[@merlin.hide])
      -> int
      =
      fun _cmp__a a__066_ b__067_ ->
      Lazy.compare__local
        (fun a__068_ (b__069_ [@merlin.hide]) -> (_cmp__a a__068_ b__069_ [@merlin.hide]))
        a__066_
        b__067_
    ;;

    let _ = compare_lazy_t__local

    let compare_lazy_t
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a lazy_t
      -> ('a lazy_t[@merlin.hide])
      -> int
      =
      fun _cmp__a a__062_ b__063_ ->
      Lazy.compare
        (fun a__064_ (b__065_ [@merlin.hide]) -> (_cmp__a a__064_ b__065_ [@merlin.hide]))
        a__062_
        b__063_
    ;;

    let _ = compare_lazy_t

    let hash_fold_lazy_t
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a lazy_t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      Lazy.hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_lazy_t

    let lazy_t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a lazy_t =
      fun _of_a__070_ x__072_ -> Lazy.t_of_sexp _of_a__070_ x__072_
    ;;

    let _ = lazy_t_of_sexp

    let sexp_of_lazy_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a lazy_t -> Sexplib0.Sexp.t =
      fun _of_a__073_ x__074_ -> Lazy.sexp_of_t _of_a__073_ x__074_
    ;;

    let _ = sexp_of_lazy_t

    let lazy_t_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a lazy_t Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Lazy.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = lazy_t_sexp_grammar

    module Typename_of_lazy_t = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a lazy_t

        let name = "std_internal.ml.before-ppx.lazy_t"
        let _ = name
      end)

    let typename_of_lazy_t = Typename_of_lazy_t.typename_of_t
    let _ = typename_of_lazy_t

    let typerep_of_lazy_t
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a lazy_t Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_lazy_t = Typename_of_lazy_t.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_lazy_t, Some (lazy (Lazy.typerep_of_t _of_a)))
    ;;

    let _ = typerep_of_lazy_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a list = 'a List.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , hash
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a list) -> ()

    let bin_shape_list =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:164:4")
          [ ( Bin_prot.Shape.Tid.of_string "list"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , List.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:164:19")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "list")) [ a ]
    ;;

    let _ = bin_shape_list

    let bin_size_list__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a list Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local v -> List.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_list__local

    let bin_size_list : 'a. 'a Bin_prot.Size.sizer -> 'a list Bin_prot.Size.sizer =
      fun _size_of_a v -> List.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_list

    let bin_write_list__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a list Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos v -> List.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_list__local

    let bin_write_list : 'a. 'a Bin_prot.Write.writer -> 'a list Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> List.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_list

    let bin_writer_list =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_list bin_writer_a.size v)
         ; write = (fun v -> bin_write_list bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_list

    let __bin_read_list__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a list) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (List.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_list__

    let bin_read_list : 'a. 'a Bin_prot.Read.reader -> 'a list Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (List.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_list

    let bin_reader_list =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_list bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_list__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_list

    let bin_list =
      (fun bin_a ->
         { writer = bin_writer_list bin_a.writer
         ; reader = bin_reader_list bin_a.reader
         ; shape = bin_shape_list bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_list

    let compare_list__local
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a list -> ('a list[@merlin.hide]) -> int
      =
      fun _cmp__a a__079_ b__080_ ->
      List.compare__local
        (fun a__081_ (b__082_ [@merlin.hide]) -> (_cmp__a a__081_ b__082_ [@merlin.hide]))
        a__079_
        b__080_
    ;;

    let _ = compare_list__local

    let compare_list
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a list -> ('a list[@merlin.hide]) -> int
      =
      fun _cmp__a a__075_ b__076_ ->
      List.compare
        (fun a__077_ (b__078_ [@merlin.hide]) -> (_cmp__a a__077_ b__078_ [@merlin.hide]))
        a__075_
        b__076_
    ;;

    let _ = compare_list

    let hash_fold_list
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a list
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      List.hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_list

    let equal_list__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a list
      -> ('a list[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__087_ b__088_ ->
      List.equal__local
        (fun a__089_ (b__090_ [@merlin.hide]) -> (_cmp__a a__089_ b__090_ [@merlin.hide]))
        a__087_
        b__088_
    ;;

    let _ = equal_list__local

    let equal_list
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a list
      -> ('a list[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__083_ b__084_ ->
      List.equal
        (fun a__085_ (b__086_ [@merlin.hide]) -> (_cmp__a a__085_ b__086_ [@merlin.hide]))
        a__083_
        b__084_
    ;;

    let _ = equal_list

    let globalize_list : 'a. ('a -> 'a) -> 'a list -> 'a list =
      fun (type a__091_) ->
      (fun _globalize_a__092_ x__093_ -> List.globalize _globalize_a__092_ x__093_
       : (a__091_ -> a__091_) -> a__091_ list -> a__091_ list)
    ;;

    let _ = globalize_list

    let list_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a list =
      fun _of_a__095_ x__097_ -> List.t_of_sexp _of_a__095_ x__097_
    ;;

    let _ = list_of_sexp

    let sexp_of_list : 'a. ('a -> Sexplib0.Sexp.t) -> 'a list -> Sexplib0.Sexp.t =
      fun _of_a__098_ x__099_ -> List.sexp_of_t _of_a__098_ x__099_
    ;;

    let _ = sexp_of_list

    let list_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a list Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> List.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = list_sexp_grammar

    module Typename_of_list = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a list

        let name = "std_internal.ml.before-ppx.list"
        let _ = name
      end)

    let typename_of_list = Typename_of_list.typename_of_t
    let _ = typename_of_list

    let typerep_of_list
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a list Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_list = Typename_of_list.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_list, Some (lazy (List.typerep_of_t _of_a)))
    ;;

    let _ = typerep_of_list
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type nativeint = Nativeint.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , hash
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : nativeint) -> ()

    let bin_shape_nativeint =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:175:4")
          [ Bin_prot.Shape.Tid.of_string "nativeint", [], Nativeint.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "nativeint")) []
    ;;

    let _ = bin_shape_nativeint

    let bin_size_nativeint__local : nativeint Bin_prot.Size.sizer_local =
      Nativeint.bin_size_t__local
    ;;

    let _ = bin_size_nativeint__local
    let bin_size_nativeint = (bin_size_nativeint__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_nativeint

    let bin_write_nativeint__local : nativeint Bin_prot.Write.writer_local =
      Nativeint.bin_write_t__local
    ;;

    let _ = bin_write_nativeint__local
    let bin_write_nativeint = (bin_write_nativeint__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_nativeint

    let bin_writer_nativeint =
      ({ size = bin_size_nativeint; write = bin_write_nativeint }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_nativeint

    let __bin_read_nativeint__ : (int -> nativeint) Bin_prot.Read.reader =
      Nativeint.__bin_read_t__
    ;;

    let _ = __bin_read_nativeint__
    let bin_read_nativeint : nativeint Bin_prot.Read.reader = Nativeint.bin_read_t
    let _ = bin_read_nativeint

    let bin_reader_nativeint =
      ({ read = bin_read_nativeint; vtag_read = __bin_read_nativeint__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_nativeint

    let bin_nativeint =
      ({ writer = bin_writer_nativeint
       ; reader = bin_reader_nativeint
       ; shape = bin_shape_nativeint
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_nativeint

    let compare_nativeint__local =
      (fun a__100_ b__101_ -> Nativeint.compare__local a__100_ b__101_
       : nativeint -> (nativeint[@merlin.hide]) -> int)
    ;;

    let _ = compare_nativeint__local

    let compare_nativeint =
      (fun a b -> compare_nativeint__local a b
       : nativeint -> (nativeint[@merlin.hide]) -> int)
    ;;

    let _ = compare_nativeint

    let equal_nativeint__local =
      (fun a__102_ b__103_ -> Nativeint.equal__local a__102_ b__103_
       : nativeint -> (nativeint[@merlin.hide]) -> bool)
    ;;

    let _ = equal_nativeint__local

    let equal_nativeint =
      (fun a b -> equal_nativeint__local a b
       : nativeint -> (nativeint[@merlin.hide]) -> bool)
    ;;

    let _ = equal_nativeint

    let globalize_nativeint : nativeint -> nativeint =
      (Nativeint.globalize : nativeint -> nativeint)
    ;;

    let _ = globalize_nativeint

    let hash_fold_nativeint
      : Ppx_hash_lib.Std.Hash.state -> nativeint -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Nativeint.hash_fold_t hsv arg

    and hash_nativeint : nativeint -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Nativeint.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_nativeint
    and _ = hash_nativeint

    let nativeint_of_sexp = (Nativeint.t_of_sexp : Sexplib0.Sexp.t -> nativeint)
    let _ = nativeint_of_sexp
    let sexp_of_nativeint = (Nativeint.sexp_of_t : nativeint -> Sexplib0.Sexp.t)
    let _ = sexp_of_nativeint

    let nativeint_sexp_grammar : nativeint Sexplib0.Sexp_grammar.t =
      Nativeint.t_sexp_grammar
    ;;

    let _ = nativeint_sexp_grammar

    module Typename_of_nativeint = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = nativeint

        let name = "std_internal.ml.before-ppx.nativeint"
        let _ = name
      end)

    let typename_of_nativeint = Typename_of_nativeint.typename_of_t
    let _ = typename_of_nativeint

    let typerep_of_nativeint =
      let name_of_nativeint = Typename_of_nativeint.named in
      Typerep_lib.Std.Typerep.Named (name_of_nativeint, Some (lazy Nativeint.typerep_of_t))
    ;;

    let _ = typerep_of_nativeint
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a option = 'a Option.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , hash
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a option) -> ()

    let bin_shape_option =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:186:4")
          [ ( Bin_prot.Shape.Tid.of_string "option"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Option.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:186:21")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "option")) [ a ]
    ;;

    let _ = bin_shape_option

    let bin_size_option__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a option Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local v -> Option.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_option__local

    let bin_size_option : 'a. 'a Bin_prot.Size.sizer -> 'a option Bin_prot.Size.sizer =
      fun _size_of_a v -> Option.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_option

    let bin_write_option__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a option Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos v ->
      Option.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_option__local

    let bin_write_option : 'a. 'a Bin_prot.Write.writer -> 'a option Bin_prot.Write.writer
      =
      fun _write_a buf ~pos v -> Option.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_option

    let bin_writer_option =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_option bin_writer_a.size v)
         ; write = (fun v -> bin_write_option bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_option

    let __bin_read_option__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a option) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (Option.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_option__

    let bin_read_option : 'a. 'a Bin_prot.Read.reader -> 'a option Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (Option.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_option

    let bin_reader_option =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_option bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_option__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_option

    let bin_option =
      (fun bin_a ->
         { writer = bin_writer_option bin_a.writer
         ; reader = bin_reader_option bin_a.reader
         ; shape = bin_shape_option bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_option

    let compare_option__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a option
      -> ('a option[@merlin.hide])
      -> int
      =
      fun _cmp__a a__110_ b__111_ ->
      Option.compare__local
        (fun a__112_ (b__113_ [@merlin.hide]) -> (_cmp__a a__112_ b__113_ [@merlin.hide]))
        a__110_
        b__111_
    ;;

    let _ = compare_option__local

    let compare_option
      :  'a.
         ('a -> ('a[@merlin.hide]) -> int)
      -> 'a option
      -> ('a option[@merlin.hide])
      -> int
      =
      fun _cmp__a a__106_ b__107_ ->
      Option.compare
        (fun a__108_ (b__109_ [@merlin.hide]) -> (_cmp__a a__108_ b__109_ [@merlin.hide]))
        a__106_
        b__107_
    ;;

    let _ = compare_option

    let equal_option__local
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a option
      -> ('a option[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__118_ b__119_ ->
      Option.equal__local
        (fun a__120_ (b__121_ [@merlin.hide]) -> (_cmp__a a__120_ b__121_ [@merlin.hide]))
        a__118_
        b__119_
    ;;

    let _ = equal_option__local

    let equal_option
      :  'a.
         ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a option
      -> ('a option[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__114_ b__115_ ->
      Option.equal
        (fun a__116_ (b__117_ [@merlin.hide]) -> (_cmp__a a__116_ b__117_ [@merlin.hide]))
        a__114_
        b__115_
    ;;

    let _ = equal_option

    let globalize_option : 'a. ('a -> 'a) -> 'a option -> 'a option =
      fun (type a__122_) ->
      (fun _globalize_a__123_ x__124_ -> Option.globalize _globalize_a__123_ x__124_
       : (a__122_ -> a__122_) -> a__122_ option -> a__122_ option)
    ;;

    let _ = globalize_option

    let hash_fold_option
      :  'a.
         (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a option
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      Option.hash_fold_t (fun hsv arg -> _hash_fold_a hsv arg) hsv arg
    ;;

    let _ = hash_fold_option

    let option_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a option =
      fun _of_a__126_ x__128_ -> Option.t_of_sexp _of_a__126_ x__128_
    ;;

    let _ = option_of_sexp

    let sexp_of_option : 'a. ('a -> Sexplib0.Sexp.t) -> 'a option -> Sexplib0.Sexp.t =
      fun _of_a__129_ x__130_ -> Option.sexp_of_t _of_a__129_ x__130_
    ;;

    let _ = sexp_of_option

    let option_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a option Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Option.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = option_sexp_grammar

    module Typename_of_option = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a option

        let name = "std_internal.ml.before-ppx.option"
        let _ = name
      end)

    let typename_of_option = Typename_of_option.typename_of_t
    let _ = typename_of_option

    let typerep_of_option
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a option Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_option = Typename_of_option.named _of_a in
      Typerep_lib.Std.Typerep.Named
        (name_of_option, Some (lazy (Option.typerep_of_t _of_a)))
    ;;

    let _ = typerep_of_option
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type ('ok, 'err) result = ('ok, 'err) Result.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , hash
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : ('ok, 'err) result) -> ()

    let bin_shape_result =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:197:4")
          [ ( Bin_prot.Shape.Tid.of_string "result"
            , [ Bin_prot.Shape.Vid.of_string "ok"; Bin_prot.Shape.Vid.of_string "err" ]
            , (Result.bin_shape_t
                 (Bin_prot.Shape.var
                    (Bin_prot.Shape.Location.of_string
                       "std_internal.ml.before-ppx:197:31")
                    (Bin_prot.Shape.Vid.of_string "ok")))
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:197:36")
                   (Bin_prot.Shape.Vid.of_string "err")) )
          ]
      in
      fun ok err ->
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "result"))
          [ ok; err ]
    ;;

    let _ = bin_shape_result

    let bin_size_result__local
      :  'ok 'err.
         'ok Bin_prot.Size.sizer_local
      -> 'err Bin_prot.Size.sizer_local
      -> ('ok, 'err) result Bin_prot.Size.sizer_local
      =
      fun _size_of_ok__local _size_of_err__local v ->
      Result.bin_size_t__local _size_of_ok__local _size_of_err__local v
    ;;

    let _ = bin_size_result__local

    let bin_size_result
      :  'ok 'err.
         'ok Bin_prot.Size.sizer
      -> 'err Bin_prot.Size.sizer
      -> ('ok, 'err) result Bin_prot.Size.sizer
      =
      fun _size_of_ok _size_of_err v -> Result.bin_size_t _size_of_ok _size_of_err v
    ;;

    let _ = bin_size_result

    let bin_write_result__local
      :  'ok 'err.
         'ok Bin_prot.Write.writer_local
      -> 'err Bin_prot.Write.writer_local
      -> ('ok, 'err) result Bin_prot.Write.writer_local
      =
      fun _write_ok__local _write_err__local buf ~pos v ->
      Result.bin_write_t__local _write_ok__local _write_err__local buf ~pos v
    ;;

    let _ = bin_write_result__local

    let bin_write_result
      :  'ok 'err.
         'ok Bin_prot.Write.writer
      -> 'err Bin_prot.Write.writer
      -> ('ok, 'err) result Bin_prot.Write.writer
      =
      fun _write_ok _write_err buf ~pos v ->
      Result.bin_write_t _write_ok _write_err buf ~pos v
    ;;

    let _ = bin_write_result

    let bin_writer_result =
      (fun bin_writer_ok bin_writer_err ->
         { size = (fun v -> bin_size_result bin_writer_ok.size bin_writer_err.size v)
         ; write = (fun v -> bin_write_result bin_writer_ok.write bin_writer_err.write v)
         }
       : _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer
         -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_result

    let __bin_read_result__
      :  'ok 'err.
         'ok Bin_prot.Read.reader
      -> 'err Bin_prot.Read.reader
      -> (int -> ('ok, 'err) result) Bin_prot.Read.reader
      =
      fun _of__ok _of__err buf ~pos_ref vint ->
      (Result.__bin_read_t__ _of__ok _of__err) buf ~pos_ref vint
    ;;

    let _ = __bin_read_result__

    let bin_read_result
      :  'ok 'err.
         'ok Bin_prot.Read.reader
      -> 'err Bin_prot.Read.reader
      -> ('ok, 'err) result Bin_prot.Read.reader
      =
      fun _of__ok _of__err buf ~pos_ref ->
      (Result.bin_read_t _of__ok _of__err) buf ~pos_ref
    ;;

    let _ = bin_read_result

    let bin_reader_result =
      (fun bin_reader_ok bin_reader_err ->
         { read =
             (fun buf ~pos_ref ->
               (bin_read_result bin_reader_ok.read bin_reader_err.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_result__ bin_reader_ok.read bin_reader_err.read)
                 buf
                 ~pos_ref
                 vtag)
         }
       : _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader
         -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_result

    let bin_result =
      (fun bin_ok bin_err ->
         { writer = bin_writer_result bin_ok.writer bin_err.writer
         ; reader = bin_reader_result bin_ok.reader bin_err.reader
         ; shape = bin_shape_result bin_ok.shape bin_err.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_result

    let compare_result__local
      :  'ok 'err.
         ('ok -> ('ok[@merlin.hide]) -> int)
      -> ('err -> ('err[@merlin.hide]) -> int)
      -> ('ok, 'err) result
      -> (('ok, 'err) result[@merlin.hide])
      -> int
      =
      fun _cmp__ok _cmp__err a__137_ b__138_ ->
      Result.compare__local
        (fun a__139_ (b__140_ [@merlin.hide]) ->
           (_cmp__ok a__139_ b__140_ [@merlin.hide]))
        (fun a__141_ (b__142_ [@merlin.hide]) ->
           (_cmp__err a__141_ b__142_ [@merlin.hide]))
        a__137_
        b__138_
    ;;

    let _ = compare_result__local

    let compare_result
      :  'ok 'err.
         ('ok -> ('ok[@merlin.hide]) -> int)
      -> ('err -> ('err[@merlin.hide]) -> int)
      -> ('ok, 'err) result
      -> (('ok, 'err) result[@merlin.hide])
      -> int
      =
      fun _cmp__ok _cmp__err a__131_ b__132_ ->
      Result.compare
        (fun a__133_ (b__134_ [@merlin.hide]) ->
           (_cmp__ok a__133_ b__134_ [@merlin.hide]))
        (fun a__135_ (b__136_ [@merlin.hide]) ->
           (_cmp__err a__135_ b__136_ [@merlin.hide]))
        a__131_
        b__132_
    ;;

    let _ = compare_result

    let equal_result__local
      :  'ok 'err.
         ('ok -> ('ok[@merlin.hide]) -> bool)
      -> ('err -> ('err[@merlin.hide]) -> bool)
      -> ('ok, 'err) result
      -> (('ok, 'err) result[@merlin.hide])
      -> bool
      =
      fun _cmp__ok _cmp__err a__149_ b__150_ ->
      Result.equal__local
        (fun a__151_ (b__152_ [@merlin.hide]) ->
           (_cmp__ok a__151_ b__152_ [@merlin.hide]))
        (fun a__153_ (b__154_ [@merlin.hide]) ->
           (_cmp__err a__153_ b__154_ [@merlin.hide]))
        a__149_
        b__150_
    ;;

    let _ = equal_result__local

    let equal_result
      :  'ok 'err.
         ('ok -> ('ok[@merlin.hide]) -> bool)
      -> ('err -> ('err[@merlin.hide]) -> bool)
      -> ('ok, 'err) result
      -> (('ok, 'err) result[@merlin.hide])
      -> bool
      =
      fun _cmp__ok _cmp__err a__143_ b__144_ ->
      Result.equal
        (fun a__145_ (b__146_ [@merlin.hide]) ->
           (_cmp__ok a__145_ b__146_ [@merlin.hide]))
        (fun a__147_ (b__148_ [@merlin.hide]) ->
           (_cmp__err a__147_ b__148_ [@merlin.hide]))
        a__143_
        b__144_
    ;;

    let _ = equal_result

    let globalize_result
      :  'ok 'err.
         ('ok -> 'ok)
      -> ('err -> 'err)
      -> ('ok, 'err) result
      -> ('ok, 'err) result
      =
      fun (type ok__155_) ->
      fun (type err__156_) ->
      (fun _globalize_ok__158_ _globalize_err__157_ x__159_ ->
         Result.globalize _globalize_ok__158_ _globalize_err__157_ x__159_
       : (ok__155_ -> ok__155_)
         -> (err__156_ -> err__156_)
         -> (ok__155_, err__156_) result
         -> (ok__155_, err__156_) result)
    ;;

    let _ = globalize_result

    let hash_fold_result
      :  'ok 'err.
         (Ppx_hash_lib.Std.Hash.state -> 'ok -> Ppx_hash_lib.Std.Hash.state)
      -> (Ppx_hash_lib.Std.Hash.state -> 'err -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> ('ok, 'err) result
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_ok _hash_fold_err hsv arg ->
      Result.hash_fold_t
        (fun hsv arg -> _hash_fold_ok hsv arg)
        (fun hsv arg -> _hash_fold_err hsv arg)
        hsv
        arg
    ;;

    let _ = hash_fold_result

    let result_of_sexp
      :  'ok 'err.
         (Sexplib0.Sexp.t -> 'ok)
      -> (Sexplib0.Sexp.t -> 'err)
      -> Sexplib0.Sexp.t
      -> ('ok, 'err) result
      =
      fun _of_ok__162_ _of_err__163_ x__165_ ->
      Result.t_of_sexp _of_ok__162_ _of_err__163_ x__165_
    ;;

    let _ = result_of_sexp

    let sexp_of_result
      :  'ok 'err.
         ('ok -> Sexplib0.Sexp.t)
      -> ('err -> Sexplib0.Sexp.t)
      -> ('ok, 'err) result
      -> Sexplib0.Sexp.t
      =
      fun _of_ok__166_ _of_err__167_ x__168_ ->
      Result.sexp_of_t _of_ok__166_ _of_err__167_ x__168_
    ;;

    let _ = sexp_of_result

    let result_sexp_grammar
      :  'ok 'err.
         'ok Sexplib0.Sexp_grammar.t
      -> 'err Sexplib0.Sexp_grammar.t
      -> ('ok, 'err) result Sexplib0.Sexp_grammar.t
      =
      fun _'ok_sexp_grammar _'err_sexp_grammar ->
      Result.t_sexp_grammar _'ok_sexp_grammar _'err_sexp_grammar
    ;;

    let _ = result_sexp_grammar

    module Typename_of_result = Typerep_lib.Std.Make_typename.Make2 (struct
        type nonrec ('ok, 'err) t = ('ok, 'err) result

        let name = "std_internal.ml.before-ppx.result"
        let _ = name
      end)

    let typename_of_result = Typename_of_result.typename_of_t
    let _ = typename_of_result

    let typerep_of_result
      :  'ok 'err.
         'ok Typerep_lib.Std.Typerep.t
      -> 'err Typerep_lib.Std.Typerep.t
      -> ('ok, 'err) result Typerep_lib.Std.Typerep.t
      =
      fun (type ok) ->
      fun (type err) ->
      fun (_of_ok : ok Typerep_lib.Std.Typerep.t)
        (_of_err : err Typerep_lib.Std.Typerep.t) ->
      let name_of_result = Typename_of_result.named _of_ok _of_err in
      Typerep_lib.Std.Typerep.Named
        (name_of_result, Some (lazy (Result.typerep_of_t _of_ok _of_err)))
    ;;

    let _ = typerep_of_result
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type string = String.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , hash
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : string) -> ()

    let bin_shape_string =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:208:4")
          [ Bin_prot.Shape.Tid.of_string "string", [], String.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "string")) []
    ;;

    let _ = bin_shape_string

    let bin_size_string__local : string Bin_prot.Size.sizer_local =
      String.bin_size_t__local
    ;;

    let _ = bin_size_string__local
    let bin_size_string = (bin_size_string__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_string

    let bin_write_string__local : string Bin_prot.Write.writer_local =
      String.bin_write_t__local
    ;;

    let _ = bin_write_string__local
    let bin_write_string = (bin_write_string__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_string

    let bin_writer_string =
      ({ size = bin_size_string; write = bin_write_string }
       : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_string
    let __bin_read_string__ : (int -> string) Bin_prot.Read.reader = String.__bin_read_t__
    let _ = __bin_read_string__
    let bin_read_string : string Bin_prot.Read.reader = String.bin_read_t
    let _ = bin_read_string

    let bin_reader_string =
      ({ read = bin_read_string; vtag_read = __bin_read_string__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_string

    let bin_string =
      ({ writer = bin_writer_string
       ; reader = bin_reader_string
       ; shape = bin_shape_string
       }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_string

    let compare_string__local =
      (fun a__169_ b__170_ -> String.compare__local a__169_ b__170_
       : string -> (string[@merlin.hide]) -> int)
    ;;

    let _ = compare_string__local

    let compare_string =
      (fun a b -> compare_string__local a b : string -> (string[@merlin.hide]) -> int)
    ;;

    let _ = compare_string

    let equal_string__local =
      (fun a__171_ b__172_ -> String.equal__local a__171_ b__172_
       : string -> (string[@merlin.hide]) -> bool)
    ;;

    let _ = equal_string__local

    let equal_string =
      (fun a b -> equal_string__local a b : string -> (string[@merlin.hide]) -> bool)
    ;;

    let _ = equal_string
    let globalize_string : string -> string = (String.globalize : string -> string)
    let _ = globalize_string

    let hash_fold_string
      : Ppx_hash_lib.Std.Hash.state -> string -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> String.hash_fold_t hsv arg

    and hash_string : string -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = String.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_string
    and _ = hash_string

    let string_of_sexp = (String.t_of_sexp : Sexplib0.Sexp.t -> string)
    let _ = string_of_sexp
    let sexp_of_string = (String.sexp_of_t : string -> Sexplib0.Sexp.t)
    let _ = sexp_of_string
    let string_sexp_grammar : string Sexplib0.Sexp_grammar.t = String.t_sexp_grammar
    let _ = string_sexp_grammar

    module Typename_of_string = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = string

        let name = "std_internal.ml.before-ppx.string"
        let _ = name
      end)

    let typename_of_string = Typename_of_string.typename_of_t
    let _ = typename_of_string

    let typerep_of_string =
      let name_of_string = Typename_of_string.named in
      Typerep_lib.Std.Typerep.Named (name_of_string, Some (lazy String.typerep_of_t))
    ;;

    let _ = typerep_of_string
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type bytes = Bytes.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : bytes) -> ()

    let bin_shape_bytes =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:219:4")
          [ Bin_prot.Shape.Tid.of_string "bytes", [], Bytes.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "bytes")) []
    ;;

    let _ = bin_shape_bytes
    let bin_size_bytes__local : bytes Bin_prot.Size.sizer_local = Bytes.bin_size_t__local
    let _ = bin_size_bytes__local
    let bin_size_bytes = (bin_size_bytes__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_bytes

    let bin_write_bytes__local : bytes Bin_prot.Write.writer_local =
      Bytes.bin_write_t__local
    ;;

    let _ = bin_write_bytes__local
    let bin_write_bytes = (bin_write_bytes__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_bytes

    let bin_writer_bytes =
      ({ size = bin_size_bytes; write = bin_write_bytes } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_bytes
    let __bin_read_bytes__ : (int -> bytes) Bin_prot.Read.reader = Bytes.__bin_read_t__
    let _ = __bin_read_bytes__
    let bin_read_bytes : bytes Bin_prot.Read.reader = Bytes.bin_read_t
    let _ = bin_read_bytes

    let bin_reader_bytes =
      ({ read = bin_read_bytes; vtag_read = __bin_read_bytes__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_bytes

    let bin_bytes =
      ({ writer = bin_writer_bytes; reader = bin_reader_bytes; shape = bin_shape_bytes }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_bytes

    let compare_bytes__local =
      (fun a__175_ b__176_ -> Bytes.compare__local a__175_ b__176_
       : bytes -> (bytes[@merlin.hide]) -> int)
    ;;

    let _ = compare_bytes__local

    let compare_bytes =
      (fun a b -> compare_bytes__local a b : bytes -> (bytes[@merlin.hide]) -> int)
    ;;

    let _ = compare_bytes

    let equal_bytes__local =
      (fun a__177_ b__178_ -> Bytes.equal__local a__177_ b__178_
       : bytes -> (bytes[@merlin.hide]) -> bool)
    ;;

    let _ = equal_bytes__local

    let equal_bytes =
      (fun a b -> equal_bytes__local a b : bytes -> (bytes[@merlin.hide]) -> bool)
    ;;

    let _ = equal_bytes
    let globalize_bytes : bytes -> bytes = (Bytes.globalize : bytes -> bytes)
    let _ = globalize_bytes
    let bytes_of_sexp = (Bytes.t_of_sexp : Sexplib0.Sexp.t -> bytes)
    let _ = bytes_of_sexp
    let sexp_of_bytes = (Bytes.sexp_of_t : bytes -> Sexplib0.Sexp.t)
    let _ = sexp_of_bytes
    let bytes_sexp_grammar : bytes Sexplib0.Sexp_grammar.t = Bytes.t_sexp_grammar
    let _ = bytes_sexp_grammar

    module Typename_of_bytes = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = bytes

        let name = "std_internal.ml.before-ppx.bytes"
        let _ = name
      end)

    let typename_of_bytes = Typename_of_bytes.typename_of_t
    let _ = typename_of_bytes

    let typerep_of_bytes =
      let name_of_bytes = Typename_of_bytes.named in
      Typerep_lib.Std.Typerep.Named (name_of_bytes, Some (lazy Bytes.typerep_of_t))
    ;;

    let _ = typerep_of_bytes
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a ref = 'a Ref.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : 'a ref) -> ()

    let bin_shape_ref =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:229:4")
          [ ( Bin_prot.Shape.Tid.of_string "ref"
            , [ Bin_prot.Shape.Vid.of_string "a" ]
            , Ref.bin_shape_t
                (Bin_prot.Shape.var
                   (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:229:18")
                   (Bin_prot.Shape.Vid.of_string "a")) )
          ]
      in
      fun a -> (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "ref")) [ a ]
    ;;

    let _ = bin_shape_ref

    let bin_size_ref__local
      : 'a. 'a Bin_prot.Size.sizer_local -> 'a ref Bin_prot.Size.sizer_local
      =
      fun _size_of_a__local v -> Ref.bin_size_t__local _size_of_a__local v
    ;;

    let _ = bin_size_ref__local

    let bin_size_ref : 'a. 'a Bin_prot.Size.sizer -> 'a ref Bin_prot.Size.sizer =
      fun _size_of_a v -> Ref.bin_size_t _size_of_a v
    ;;

    let _ = bin_size_ref

    let bin_write_ref__local
      : 'a. 'a Bin_prot.Write.writer_local -> 'a ref Bin_prot.Write.writer_local
      =
      fun _write_a__local buf ~pos v -> Ref.bin_write_t__local _write_a__local buf ~pos v
    ;;

    let _ = bin_write_ref__local

    let bin_write_ref : 'a. 'a Bin_prot.Write.writer -> 'a ref Bin_prot.Write.writer =
      fun _write_a buf ~pos v -> Ref.bin_write_t _write_a buf ~pos v
    ;;

    let _ = bin_write_ref

    let bin_writer_ref =
      (fun bin_writer_a ->
         { size = (fun v -> bin_size_ref bin_writer_a.size v)
         ; write = (fun v -> bin_write_ref bin_writer_a.write v)
         }
       : _ Bin_prot.Type_class.writer -> _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_ref

    let __bin_read_ref__
      : 'a. 'a Bin_prot.Read.reader -> (int -> 'a ref) Bin_prot.Read.reader
      =
      fun _of__a buf ~pos_ref vint -> (Ref.__bin_read_t__ _of__a) buf ~pos_ref vint
    ;;

    let _ = __bin_read_ref__

    let bin_read_ref : 'a. 'a Bin_prot.Read.reader -> 'a ref Bin_prot.Read.reader =
      fun _of__a buf ~pos_ref -> (Ref.bin_read_t _of__a) buf ~pos_ref
    ;;

    let _ = bin_read_ref

    let bin_reader_ref =
      (fun bin_reader_a ->
         { read = (fun buf ~pos_ref -> (bin_read_ref bin_reader_a.read) buf ~pos_ref)
         ; vtag_read =
             (fun buf ~pos_ref vtag ->
               (__bin_read_ref__ bin_reader_a.read) buf ~pos_ref vtag)
         }
       : _ Bin_prot.Type_class.reader -> _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_ref

    let bin_ref =
      (fun bin_a ->
         { writer = bin_writer_ref bin_a.writer
         ; reader = bin_reader_ref bin_a.reader
         ; shape = bin_shape_ref bin_a.shape
         }
       : _ Bin_prot.Type_class.t -> _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_ref

    let compare_ref__local
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a ref -> ('a ref[@merlin.hide]) -> int
      =
      fun _cmp__a a__185_ b__186_ ->
      Ref.compare__local
        (fun a__187_ (b__188_ [@merlin.hide]) -> (_cmp__a a__187_ b__188_ [@merlin.hide]))
        a__185_
        b__186_
    ;;

    let _ = compare_ref__local

    let compare_ref
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a ref -> ('a ref[@merlin.hide]) -> int
      =
      fun _cmp__a a__181_ b__182_ ->
      Ref.compare
        (fun a__183_ (b__184_ [@merlin.hide]) -> (_cmp__a a__183_ b__184_ [@merlin.hide]))
        a__181_
        b__182_
    ;;

    let _ = compare_ref

    let equal_ref__local
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a ref -> ('a ref[@merlin.hide]) -> bool
      =
      fun _cmp__a a__193_ b__194_ ->
      Ref.equal__local
        (fun a__195_ (b__196_ [@merlin.hide]) -> (_cmp__a a__195_ b__196_ [@merlin.hide]))
        a__193_
        b__194_
    ;;

    let _ = equal_ref__local

    let equal_ref
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a ref -> ('a ref[@merlin.hide]) -> bool
      =
      fun _cmp__a a__189_ b__190_ ->
      Ref.equal
        (fun a__191_ (b__192_ [@merlin.hide]) -> (_cmp__a a__191_ b__192_ [@merlin.hide]))
        a__189_
        b__190_
    ;;

    let _ = equal_ref

    let globalize_ref : 'a. ('a -> 'a) -> 'a ref -> 'a ref =
      fun (type a__197_) ->
      (fun _globalize_a__198_ x__199_ -> Ref.globalize _globalize_a__198_ x__199_
       : (a__197_ -> a__197_) -> a__197_ ref -> a__197_ ref)
    ;;

    let _ = globalize_ref

    let ref_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a ref =
      fun _of_a__201_ x__203_ -> Ref.t_of_sexp _of_a__201_ x__203_
    ;;

    let _ = ref_of_sexp

    let sexp_of_ref : 'a. ('a -> Sexplib0.Sexp.t) -> 'a ref -> Sexplib0.Sexp.t =
      fun _of_a__204_ x__205_ -> Ref.sexp_of_t _of_a__204_ x__205_
    ;;

    let _ = sexp_of_ref

    let ref_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a ref Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Ref.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = ref_sexp_grammar

    module Typename_of_ref = Typerep_lib.Std.Make_typename.Make1 (struct
        type nonrec 'a t = 'a ref

        let name = "std_internal.ml.before-ppx.ref"
        let _ = name
      end)

    let typename_of_ref = Typename_of_ref.typename_of_t
    let _ = typename_of_ref

    let typerep_of_ref
      : 'a. 'a Typerep_lib.Std.Typerep.t -> 'a ref Typerep_lib.Std.Typerep.t
      =
      fun (type a) ->
      fun (_of_a : a Typerep_lib.Std.Typerep.t) ->
      let name_of_ref = Typename_of_ref.named _of_a in
      Typerep_lib.Std.Typerep.Named (name_of_ref, Some (lazy (Ref.typerep_of_t _of_a)))
    ;;

    let _ = typerep_of_ref
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  type unit = Unit.t
  [@@deriving
    bin_io ~localize
  , compare ~localize
  , equal ~localize
  , globalize
  , hash
  , sexp
  , sexp_grammar
  , typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : unit) -> ()

    let bin_shape_unit =
      let _group =
        Bin_prot.Shape.group
          (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:239:4")
          [ Bin_prot.Shape.Tid.of_string "unit", [], Unit.bin_shape_t ]
      in
      (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "unit")) []
    ;;

    let _ = bin_shape_unit
    let bin_size_unit__local : unit Bin_prot.Size.sizer_local = Unit.bin_size_t__local
    let _ = bin_size_unit__local
    let bin_size_unit = (bin_size_unit__local :> _ Bin_prot.Size.sizer)
    let _ = bin_size_unit
    let bin_write_unit__local : unit Bin_prot.Write.writer_local = Unit.bin_write_t__local
    let _ = bin_write_unit__local
    let bin_write_unit = (bin_write_unit__local :> _ Bin_prot.Write.writer)
    let _ = bin_write_unit

    let bin_writer_unit =
      ({ size = bin_size_unit; write = bin_write_unit } : _ Bin_prot.Type_class.writer)
    ;;

    let _ = bin_writer_unit
    let __bin_read_unit__ : (int -> unit) Bin_prot.Read.reader = Unit.__bin_read_t__
    let _ = __bin_read_unit__
    let bin_read_unit : unit Bin_prot.Read.reader = Unit.bin_read_t
    let _ = bin_read_unit

    let bin_reader_unit =
      ({ read = bin_read_unit; vtag_read = __bin_read_unit__ }
       : _ Bin_prot.Type_class.reader)
    ;;

    let _ = bin_reader_unit

    let bin_unit =
      ({ writer = bin_writer_unit; reader = bin_reader_unit; shape = bin_shape_unit }
       : _ Bin_prot.Type_class.t)
    ;;

    let _ = bin_unit

    let compare_unit__local =
      (fun a__206_ b__207_ -> Unit.compare__local a__206_ b__207_
       : unit -> (unit[@merlin.hide]) -> int)
    ;;

    let _ = compare_unit__local

    let compare_unit =
      (fun a b -> compare_unit__local a b : unit -> (unit[@merlin.hide]) -> int)
    ;;

    let _ = compare_unit

    let equal_unit__local =
      (fun a__208_ b__209_ -> Unit.equal__local a__208_ b__209_
       : unit -> (unit[@merlin.hide]) -> bool)
    ;;

    let _ = equal_unit__local

    let equal_unit =
      (fun a b -> equal_unit__local a b : unit -> (unit[@merlin.hide]) -> bool)
    ;;

    let _ = equal_unit
    let globalize_unit : unit -> unit = (Unit.globalize : unit -> unit)
    let _ = globalize_unit

    let hash_fold_unit
      : Ppx_hash_lib.Std.Hash.state -> unit -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg -> Unit.hash_fold_t hsv arg

    and hash_unit : unit -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Unit.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_unit
    and _ = hash_unit

    let unit_of_sexp = (Unit.t_of_sexp : Sexplib0.Sexp.t -> unit)
    let _ = unit_of_sexp
    let sexp_of_unit = (Unit.sexp_of_t : unit -> Sexplib0.Sexp.t)
    let _ = sexp_of_unit
    let unit_sexp_grammar : unit Sexplib0.Sexp_grammar.t = Unit.t_sexp_grammar
    let _ = unit_sexp_grammar

    module Typename_of_unit = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = unit

        let name = "std_internal.ml.before-ppx.unit"
        let _ = name
      end)

    let typename_of_unit = Typename_of_unit.typename_of_t
    let _ = typename_of_unit

    let typerep_of_unit =
      let name_of_unit = Typename_of_unit.named in
      Typerep_lib.Std.Typerep.Named (name_of_unit, Some (lazy Unit.typerep_of_t))
    ;;

    let _ = typerep_of_unit
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include struct
    type float_array = float array [@@deriving bin_io ~localize]

    include struct
      let _ = fun (_ : float_array) -> ()

      let bin_shape_float_array =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "std_internal.ml.before-ppx:252:6")
            [ ( Bin_prot.Shape.Tid.of_string "float_array"
              , []
              , bin_shape_array bin_shape_float )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "float_array")) []
      ;;

      let _ = bin_shape_float_array

      let bin_size_float_array__local : float_array Bin_prot.Size.sizer_local =
        fun v -> bin_size_array__local bin_size_float__local v
      ;;

      let _ = bin_size_float_array__local
      let bin_size_float_array = (bin_size_float_array__local :> _ Bin_prot.Size.sizer)
      let _ = bin_size_float_array

      let bin_write_float_array__local : float_array Bin_prot.Write.writer_local =
        fun buf ~pos v -> bin_write_array__local bin_write_float__local buf ~pos v
      ;;

      let _ = bin_write_float_array__local

      let bin_write_float_array =
        (bin_write_float_array__local :> _ Bin_prot.Write.writer)
      ;;

      let _ = bin_write_float_array

      let bin_writer_float_array =
        ({ size = bin_size_float_array; write = bin_write_float_array }
         : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_float_array

      let __bin_read_float_array__ : (int -> float_array) Bin_prot.Read.reader =
        fun buf ~pos_ref vint -> (__bin_read_array__ bin_read_float) buf ~pos_ref vint
      ;;

      let _ = __bin_read_float_array__

      let bin_read_float_array : float_array Bin_prot.Read.reader =
        fun buf ~pos_ref -> (bin_read_array bin_read_float) buf ~pos_ref
      ;;

      let _ = bin_read_float_array

      let bin_reader_float_array =
        ({ read = bin_read_float_array; vtag_read = __bin_read_float_array__ }
         : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_float_array

      let bin_float_array =
        ({ writer = bin_writer_float_array
         ; reader = bin_reader_float_array
         ; shape = bin_shape_float_array
         }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_float_array
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end [@alert "-deprecated"]

  include (
  struct
    type float_array = Float.t array
    [@@deriving compare ~localize, sexp, sexp_grammar, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : float_array) -> ()

      let compare_float_array__local =
        (fun a__212_ b__213_ ->
           compare_array__local
             (fun a__214_ (b__215_ [@merlin.hide]) ->
                (Float.compare__local a__214_ b__215_ [@merlin.hide]))
             a__212_
             b__213_
         : float_array -> (float_array[@merlin.hide]) -> int)
      ;;

      let _ = compare_float_array__local

      let compare_float_array =
        (fun a b -> compare_float_array__local a b
         : float_array -> (float_array[@merlin.hide]) -> int)
      ;;

      let _ = compare_float_array

      let float_array_of_sexp =
        (fun x__217_ -> array_of_sexp Float.t_of_sexp x__217_
         : Sexplib0.Sexp.t -> float_array)
      ;;

      let _ = float_array_of_sexp

      let sexp_of_float_array =
        (fun x__218_ -> sexp_of_array Float.sexp_of_t x__218_
         : float_array -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_float_array

      let float_array_sexp_grammar : float_array Sexplib0.Sexp_grammar.t =
        { untyped = Lazy (lazy (array_sexp_grammar Float.t_sexp_grammar).untyped) }
      ;;

      let _ = float_array_sexp_grammar

      module Typename_of_float_array = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = float_array

          let name = "std_internal.ml.before-ppx.float_array"
          let _ = name
        end)

      let typename_of_float_array = Typename_of_float_array.typename_of_t
      let _ = typename_of_float_array

      let typerep_of_float_array =
        let name_of_float_array = Typename_of_float_array.named in
        Typerep_lib.Std.Typerep.Named
          (name_of_float_array, Some (lazy (typerep_of_array Float.typerep_of_t)))
      ;;

      let _ = typerep_of_float_array
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end :
    sig
      type float_array [@@deriving compare ~localize, sexp, sexp_grammar, typerep]

      include sig
        [@@@ocaml.warning "-32"]

        val compare_float_array : float_array -> (float_array[@merlin.hide]) -> int
        val compare_float_array__local : float_array -> (float_array[@merlin.hide]) -> int
        val sexp_of_float_array : float_array -> Sexplib0.Sexp.t
        val float_array_of_sexp : Sexplib0.Sexp.t -> float_array
        val float_array_sexp_grammar : float_array Sexplib0.Sexp_grammar.t
        val typerep_of_float_array : float_array Typerep_lib.Std.Typerep.t
        val typename_of_float_array : float_array Typerep_lib.Std.Typename.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
    with type float_array := float_array)
end :
  sig
    type 'a array
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_array : Bin_prot.Shape.t -> Bin_prot.Shape.t
      val bin_size_array : 'a Bin_prot.Size.sizer -> 'a array Bin_prot.Size.sizer

      val bin_size_array__local
        :  'a Bin_prot.Size.sizer_local
        -> 'a array Bin_prot.Size.sizer_local

      val bin_write_array : 'a Bin_prot.Write.writer -> 'a array Bin_prot.Write.writer

      val bin_write_array__local
        :  'a Bin_prot.Write.writer_local
        -> 'a array Bin_prot.Write.writer_local

      val bin_writer_array
        :  'a Bin_prot.Type_class.writer
        -> 'a array Bin_prot.Type_class.writer

      val bin_read_array : 'a Bin_prot.Read.reader -> 'a array Bin_prot.Read.reader

      val __bin_read_array__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a array) Bin_prot.Read.reader

      val bin_reader_array
        :  'a Bin_prot.Type_class.reader
        -> 'a array Bin_prot.Type_class.reader

      val bin_array : 'a Bin_prot.Type_class.t -> 'a array Bin_prot.Type_class.t

      val compare_array
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a array
        -> ('a array[@merlin.hide])
        -> int

      val compare_array__local
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a array
        -> ('a array[@merlin.hide])
        -> int

      val equal_array
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a array
        -> ('a array[@merlin.hide])
        -> bool

      val equal_array__local
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a array
        -> ('a array[@merlin.hide])
        -> bool

      val globalize_array : ('a -> 'a) -> 'a array -> 'a array
      val sexp_of_array : ('a -> Sexplib0.Sexp.t) -> 'a array -> Sexplib0.Sexp.t
      val array_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a array

      val array_sexp_grammar
        :  'a Sexplib0.Sexp_grammar.t
        -> 'a array Sexplib0.Sexp_grammar.t

      val typerep_of_array
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a array Typerep_lib.Std.Typerep.t

      val typename_of_array
        :  'a Typerep_lib.Std.Typename.t
        -> 'a array Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type bool
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_bool : Bin_prot.Shape.t
      val bin_size_bool : bool Bin_prot.Size.sizer
      val bin_size_bool__local : bool Bin_prot.Size.sizer_local
      val bin_write_bool : bool Bin_prot.Write.writer
      val bin_write_bool__local : bool Bin_prot.Write.writer_local
      val bin_writer_bool : bool Bin_prot.Type_class.writer
      val bin_read_bool : bool Bin_prot.Read.reader
      val __bin_read_bool__ : (int -> bool) Bin_prot.Read.reader
      val bin_reader_bool : bool Bin_prot.Type_class.reader
      val bin_bool : bool Bin_prot.Type_class.t
      val compare_bool : bool -> (bool[@merlin.hide]) -> int
      val compare_bool__local : bool -> (bool[@merlin.hide]) -> int
      val equal_bool : bool -> (bool[@merlin.hide]) -> bool
      val equal_bool__local : bool -> (bool[@merlin.hide]) -> bool
      val globalize_bool : bool -> bool

      val hash_fold_bool
        :  Ppx_hash_lib.Std.Hash.state
        -> bool
        -> Ppx_hash_lib.Std.Hash.state

      val hash_bool : bool -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_bool : bool -> Sexplib0.Sexp.t
      val bool_of_sexp : Sexplib0.Sexp.t -> bool
      val bool_sexp_grammar : bool Sexplib0.Sexp_grammar.t
      val typerep_of_bool : bool Typerep_lib.Std.Typerep.t
      val typename_of_bool : bool Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type char
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_char : Bin_prot.Shape.t
      val bin_size_char : char Bin_prot.Size.sizer
      val bin_size_char__local : char Bin_prot.Size.sizer_local
      val bin_write_char : char Bin_prot.Write.writer
      val bin_write_char__local : char Bin_prot.Write.writer_local
      val bin_writer_char : char Bin_prot.Type_class.writer
      val bin_read_char : char Bin_prot.Read.reader
      val __bin_read_char__ : (int -> char) Bin_prot.Read.reader
      val bin_reader_char : char Bin_prot.Type_class.reader
      val bin_char : char Bin_prot.Type_class.t
      val compare_char : char -> (char[@merlin.hide]) -> int
      val compare_char__local : char -> (char[@merlin.hide]) -> int
      val equal_char : char -> (char[@merlin.hide]) -> bool
      val equal_char__local : char -> (char[@merlin.hide]) -> bool
      val globalize_char : char -> char

      val hash_fold_char
        :  Ppx_hash_lib.Std.Hash.state
        -> char
        -> Ppx_hash_lib.Std.Hash.state

      val hash_char : char -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_char : char -> Sexplib0.Sexp.t
      val char_of_sexp : Sexplib0.Sexp.t -> char
      val char_sexp_grammar : char Sexplib0.Sexp_grammar.t
      val typerep_of_char : char Typerep_lib.Std.Typerep.t
      val typename_of_char : char Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type float
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_float : Bin_prot.Shape.t
      val bin_size_float : float Bin_prot.Size.sizer
      val bin_size_float__local : float Bin_prot.Size.sizer_local
      val bin_write_float : float Bin_prot.Write.writer
      val bin_write_float__local : float Bin_prot.Write.writer_local
      val bin_writer_float : float Bin_prot.Type_class.writer
      val bin_read_float : float Bin_prot.Read.reader
      val __bin_read_float__ : (int -> float) Bin_prot.Read.reader
      val bin_reader_float : float Bin_prot.Type_class.reader
      val bin_float : float Bin_prot.Type_class.t
      val compare_float : float -> (float[@merlin.hide]) -> int
      val compare_float__local : float -> (float[@merlin.hide]) -> int
      val equal_float : float -> (float[@merlin.hide]) -> bool
      val equal_float__local : float -> (float[@merlin.hide]) -> bool
      val globalize_float : float -> float

      val hash_fold_float
        :  Ppx_hash_lib.Std.Hash.state
        -> float
        -> Ppx_hash_lib.Std.Hash.state

      val hash_float : float -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_float : float -> Sexplib0.Sexp.t
      val float_of_sexp : Sexplib0.Sexp.t -> float
      val float_sexp_grammar : float Sexplib0.Sexp_grammar.t
      val typerep_of_float : float Typerep_lib.Std.Typerep.t
      val typename_of_float : float Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type int
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_int : Bin_prot.Shape.t
      val bin_size_int : int Bin_prot.Size.sizer
      val bin_size_int__local : int Bin_prot.Size.sizer_local
      val bin_write_int : int Bin_prot.Write.writer
      val bin_write_int__local : int Bin_prot.Write.writer_local
      val bin_writer_int : int Bin_prot.Type_class.writer
      val bin_read_int : int Bin_prot.Read.reader
      val __bin_read_int__ : (int -> int) Bin_prot.Read.reader
      val bin_reader_int : int Bin_prot.Type_class.reader
      val bin_int : int Bin_prot.Type_class.t
      val compare_int : int -> (int[@merlin.hide]) -> int
      val compare_int__local : int -> (int[@merlin.hide]) -> int
      val equal_int : int -> (int[@merlin.hide]) -> bool
      val equal_int__local : int -> (int[@merlin.hide]) -> bool
      val globalize_int : int -> int

      val hash_fold_int
        :  Ppx_hash_lib.Std.Hash.state
        -> int
        -> Ppx_hash_lib.Std.Hash.state

      val hash_int : int -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_int : int -> Sexplib0.Sexp.t
      val int_of_sexp : Sexplib0.Sexp.t -> int
      val int_sexp_grammar : int Sexplib0.Sexp_grammar.t
      val typerep_of_int : int Typerep_lib.Std.Typerep.t
      val typename_of_int : int Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type int32
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_int32 : Bin_prot.Shape.t
      val bin_size_int32 : int32 Bin_prot.Size.sizer
      val bin_size_int32__local : int32 Bin_prot.Size.sizer_local
      val bin_write_int32 : int32 Bin_prot.Write.writer
      val bin_write_int32__local : int32 Bin_prot.Write.writer_local
      val bin_writer_int32 : int32 Bin_prot.Type_class.writer
      val bin_read_int32 : int32 Bin_prot.Read.reader
      val __bin_read_int32__ : (int -> int32) Bin_prot.Read.reader
      val bin_reader_int32 : int32 Bin_prot.Type_class.reader
      val bin_int32 : int32 Bin_prot.Type_class.t
      val compare_int32 : int32 -> (int32[@merlin.hide]) -> int
      val compare_int32__local : int32 -> (int32[@merlin.hide]) -> int
      val equal_int32 : int32 -> (int32[@merlin.hide]) -> bool
      val equal_int32__local : int32 -> (int32[@merlin.hide]) -> bool
      val globalize_int32 : int32 -> int32

      val hash_fold_int32
        :  Ppx_hash_lib.Std.Hash.state
        -> int32
        -> Ppx_hash_lib.Std.Hash.state

      val hash_int32 : int32 -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_int32 : int32 -> Sexplib0.Sexp.t
      val int32_of_sexp : Sexplib0.Sexp.t -> int32
      val int32_sexp_grammar : int32 Sexplib0.Sexp_grammar.t
      val typerep_of_int32 : int32 Typerep_lib.Std.Typerep.t
      val typename_of_int32 : int32 Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type int64
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_int64 : Bin_prot.Shape.t
      val bin_size_int64 : int64 Bin_prot.Size.sizer
      val bin_size_int64__local : int64 Bin_prot.Size.sizer_local
      val bin_write_int64 : int64 Bin_prot.Write.writer
      val bin_write_int64__local : int64 Bin_prot.Write.writer_local
      val bin_writer_int64 : int64 Bin_prot.Type_class.writer
      val bin_read_int64 : int64 Bin_prot.Read.reader
      val __bin_read_int64__ : (int -> int64) Bin_prot.Read.reader
      val bin_reader_int64 : int64 Bin_prot.Type_class.reader
      val bin_int64 : int64 Bin_prot.Type_class.t
      val compare_int64 : int64 -> (int64[@merlin.hide]) -> int
      val compare_int64__local : int64 -> (int64[@merlin.hide]) -> int
      val equal_int64 : int64 -> (int64[@merlin.hide]) -> bool
      val equal_int64__local : int64 -> (int64[@merlin.hide]) -> bool
      val globalize_int64 : int64 -> int64

      val hash_fold_int64
        :  Ppx_hash_lib.Std.Hash.state
        -> int64
        -> Ppx_hash_lib.Std.Hash.state

      val hash_int64 : int64 -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_int64 : int64 -> Sexplib0.Sexp.t
      val int64_of_sexp : Sexplib0.Sexp.t -> int64
      val int64_sexp_grammar : int64 Sexplib0.Sexp_grammar.t
      val typerep_of_int64 : int64 Typerep_lib.Std.Typerep.t
      val typename_of_int64 : int64 Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a lazy_t
    [@@deriving bin_io ~localize, compare ~localize, hash, sexp, sexp_grammar, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_lazy_t : Bin_prot.Shape.t -> Bin_prot.Shape.t
      val bin_size_lazy_t : 'a Bin_prot.Size.sizer -> 'a lazy_t Bin_prot.Size.sizer

      val bin_size_lazy_t__local
        :  'a Bin_prot.Size.sizer_local
        -> 'a lazy_t Bin_prot.Size.sizer_local

      val bin_write_lazy_t : 'a Bin_prot.Write.writer -> 'a lazy_t Bin_prot.Write.writer

      val bin_write_lazy_t__local
        :  'a Bin_prot.Write.writer_local
        -> 'a lazy_t Bin_prot.Write.writer_local

      val bin_writer_lazy_t
        :  'a Bin_prot.Type_class.writer
        -> 'a lazy_t Bin_prot.Type_class.writer

      val bin_read_lazy_t : 'a Bin_prot.Read.reader -> 'a lazy_t Bin_prot.Read.reader

      val __bin_read_lazy_t__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a lazy_t) Bin_prot.Read.reader

      val bin_reader_lazy_t
        :  'a Bin_prot.Type_class.reader
        -> 'a lazy_t Bin_prot.Type_class.reader

      val bin_lazy_t : 'a Bin_prot.Type_class.t -> 'a lazy_t Bin_prot.Type_class.t

      val compare_lazy_t
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a lazy_t
        -> ('a lazy_t[@merlin.hide])
        -> int

      val compare_lazy_t__local
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a lazy_t
        -> ('a lazy_t[@merlin.hide])
        -> int

      val hash_fold_lazy_t
        :  (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a lazy_t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_lazy_t : ('a -> Sexplib0.Sexp.t) -> 'a lazy_t -> Sexplib0.Sexp.t
      val lazy_t_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a lazy_t

      val lazy_t_sexp_grammar
        :  'a Sexplib0.Sexp_grammar.t
        -> 'a lazy_t Sexplib0.Sexp_grammar.t

      val typerep_of_lazy_t
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a lazy_t Typerep_lib.Std.Typerep.t

      val typename_of_lazy_t
        :  'a Typerep_lib.Std.Typename.t
        -> 'a lazy_t Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a list
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_list : Bin_prot.Shape.t -> Bin_prot.Shape.t
      val bin_size_list : 'a Bin_prot.Size.sizer -> 'a list Bin_prot.Size.sizer

      val bin_size_list__local
        :  'a Bin_prot.Size.sizer_local
        -> 'a list Bin_prot.Size.sizer_local

      val bin_write_list : 'a Bin_prot.Write.writer -> 'a list Bin_prot.Write.writer

      val bin_write_list__local
        :  'a Bin_prot.Write.writer_local
        -> 'a list Bin_prot.Write.writer_local

      val bin_writer_list
        :  'a Bin_prot.Type_class.writer
        -> 'a list Bin_prot.Type_class.writer

      val bin_read_list : 'a Bin_prot.Read.reader -> 'a list Bin_prot.Read.reader

      val __bin_read_list__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a list) Bin_prot.Read.reader

      val bin_reader_list
        :  'a Bin_prot.Type_class.reader
        -> 'a list Bin_prot.Type_class.reader

      val bin_list : 'a Bin_prot.Type_class.t -> 'a list Bin_prot.Type_class.t

      val compare_list
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a list
        -> ('a list[@merlin.hide])
        -> int

      val compare_list__local
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a list
        -> ('a list[@merlin.hide])
        -> int

      val equal_list
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a list
        -> ('a list[@merlin.hide])
        -> bool

      val equal_list__local
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a list
        -> ('a list[@merlin.hide])
        -> bool

      val globalize_list : ('a -> 'a) -> 'a list -> 'a list

      val hash_fold_list
        :  (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a list
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_list : ('a -> Sexplib0.Sexp.t) -> 'a list -> Sexplib0.Sexp.t
      val list_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a list

      val list_sexp_grammar
        :  'a Sexplib0.Sexp_grammar.t
        -> 'a list Sexplib0.Sexp_grammar.t

      val typerep_of_list
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a list Typerep_lib.Std.Typerep.t

      val typename_of_list
        :  'a Typerep_lib.Std.Typename.t
        -> 'a list Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nativeint
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_nativeint : Bin_prot.Shape.t
      val bin_size_nativeint : nativeint Bin_prot.Size.sizer
      val bin_size_nativeint__local : nativeint Bin_prot.Size.sizer_local
      val bin_write_nativeint : nativeint Bin_prot.Write.writer
      val bin_write_nativeint__local : nativeint Bin_prot.Write.writer_local
      val bin_writer_nativeint : nativeint Bin_prot.Type_class.writer
      val bin_read_nativeint : nativeint Bin_prot.Read.reader
      val __bin_read_nativeint__ : (int -> nativeint) Bin_prot.Read.reader
      val bin_reader_nativeint : nativeint Bin_prot.Type_class.reader
      val bin_nativeint : nativeint Bin_prot.Type_class.t
      val compare_nativeint : nativeint -> (nativeint[@merlin.hide]) -> int
      val compare_nativeint__local : nativeint -> (nativeint[@merlin.hide]) -> int
      val equal_nativeint : nativeint -> (nativeint[@merlin.hide]) -> bool
      val equal_nativeint__local : nativeint -> (nativeint[@merlin.hide]) -> bool
      val globalize_nativeint : nativeint -> nativeint

      val hash_fold_nativeint
        :  Ppx_hash_lib.Std.Hash.state
        -> nativeint
        -> Ppx_hash_lib.Std.Hash.state

      val hash_nativeint : nativeint -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_nativeint : nativeint -> Sexplib0.Sexp.t
      val nativeint_of_sexp : Sexplib0.Sexp.t -> nativeint
      val nativeint_sexp_grammar : nativeint Sexplib0.Sexp_grammar.t
      val typerep_of_nativeint : nativeint Typerep_lib.Std.Typerep.t
      val typename_of_nativeint : nativeint Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a option
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_option : Bin_prot.Shape.t -> Bin_prot.Shape.t
      val bin_size_option : 'a Bin_prot.Size.sizer -> 'a option Bin_prot.Size.sizer

      val bin_size_option__local
        :  'a Bin_prot.Size.sizer_local
        -> 'a option Bin_prot.Size.sizer_local

      val bin_write_option : 'a Bin_prot.Write.writer -> 'a option Bin_prot.Write.writer

      val bin_write_option__local
        :  'a Bin_prot.Write.writer_local
        -> 'a option Bin_prot.Write.writer_local

      val bin_writer_option
        :  'a Bin_prot.Type_class.writer
        -> 'a option Bin_prot.Type_class.writer

      val bin_read_option : 'a Bin_prot.Read.reader -> 'a option Bin_prot.Read.reader

      val __bin_read_option__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a option) Bin_prot.Read.reader

      val bin_reader_option
        :  'a Bin_prot.Type_class.reader
        -> 'a option Bin_prot.Type_class.reader

      val bin_option : 'a Bin_prot.Type_class.t -> 'a option Bin_prot.Type_class.t

      val compare_option
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a option
        -> ('a option[@merlin.hide])
        -> int

      val compare_option__local
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a option
        -> ('a option[@merlin.hide])
        -> int

      val equal_option
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a option
        -> ('a option[@merlin.hide])
        -> bool

      val equal_option__local
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a option
        -> ('a option[@merlin.hide])
        -> bool

      val globalize_option : ('a -> 'a) -> 'a option -> 'a option

      val hash_fold_option
        :  (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a option
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_option : ('a -> Sexplib0.Sexp.t) -> 'a option -> Sexplib0.Sexp.t
      val option_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a option

      val option_sexp_grammar
        :  'a Sexplib0.Sexp_grammar.t
        -> 'a option Sexplib0.Sexp_grammar.t

      val typerep_of_option
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a option Typerep_lib.Std.Typerep.t

      val typename_of_option
        :  'a Typerep_lib.Std.Typename.t
        -> 'a option Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type ('ok, 'err) result
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_result : Bin_prot.Shape.t -> Bin_prot.Shape.t -> Bin_prot.Shape.t

      val bin_size_result
        :  'ok Bin_prot.Size.sizer
        -> 'err Bin_prot.Size.sizer
        -> ('ok, 'err) result Bin_prot.Size.sizer

      val bin_size_result__local
        :  'ok Bin_prot.Size.sizer_local
        -> 'err Bin_prot.Size.sizer_local
        -> ('ok, 'err) result Bin_prot.Size.sizer_local

      val bin_write_result
        :  'ok Bin_prot.Write.writer
        -> 'err Bin_prot.Write.writer
        -> ('ok, 'err) result Bin_prot.Write.writer

      val bin_write_result__local
        :  'ok Bin_prot.Write.writer_local
        -> 'err Bin_prot.Write.writer_local
        -> ('ok, 'err) result Bin_prot.Write.writer_local

      val bin_writer_result
        :  'ok Bin_prot.Type_class.writer
        -> 'err Bin_prot.Type_class.writer
        -> ('ok, 'err) result Bin_prot.Type_class.writer

      val bin_read_result
        :  'ok Bin_prot.Read.reader
        -> 'err Bin_prot.Read.reader
        -> ('ok, 'err) result Bin_prot.Read.reader

      val __bin_read_result__
        :  'ok Bin_prot.Read.reader
        -> 'err Bin_prot.Read.reader
        -> (int -> ('ok, 'err) result) Bin_prot.Read.reader

      val bin_reader_result
        :  'ok Bin_prot.Type_class.reader
        -> 'err Bin_prot.Type_class.reader
        -> ('ok, 'err) result Bin_prot.Type_class.reader

      val bin_result
        :  'ok Bin_prot.Type_class.t
        -> 'err Bin_prot.Type_class.t
        -> ('ok, 'err) result Bin_prot.Type_class.t

      val compare_result
        :  ('ok -> ('ok[@merlin.hide]) -> int)
        -> ('err -> ('err[@merlin.hide]) -> int)
        -> ('ok, 'err) result
        -> (('ok, 'err) result[@merlin.hide])
        -> int

      val compare_result__local
        :  ('ok -> ('ok[@merlin.hide]) -> int)
        -> ('err -> ('err[@merlin.hide]) -> int)
        -> ('ok, 'err) result
        -> (('ok, 'err) result[@merlin.hide])
        -> int

      val equal_result
        :  ('ok -> ('ok[@merlin.hide]) -> bool)
        -> ('err -> ('err[@merlin.hide]) -> bool)
        -> ('ok, 'err) result
        -> (('ok, 'err) result[@merlin.hide])
        -> bool

      val equal_result__local
        :  ('ok -> ('ok[@merlin.hide]) -> bool)
        -> ('err -> ('err[@merlin.hide]) -> bool)
        -> ('ok, 'err) result
        -> (('ok, 'err) result[@merlin.hide])
        -> bool

      val globalize_result
        :  ('ok -> 'ok)
        -> ('err -> 'err)
        -> ('ok, 'err) result
        -> ('ok, 'err) result

      val hash_fold_result
        :  (Ppx_hash_lib.Std.Hash.state -> 'ok -> Ppx_hash_lib.Std.Hash.state)
        -> (Ppx_hash_lib.Std.Hash.state -> 'err -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> ('ok, 'err) result
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_result
        :  ('ok -> Sexplib0.Sexp.t)
        -> ('err -> Sexplib0.Sexp.t)
        -> ('ok, 'err) result
        -> Sexplib0.Sexp.t

      val result_of_sexp
        :  (Sexplib0.Sexp.t -> 'ok)
        -> (Sexplib0.Sexp.t -> 'err)
        -> Sexplib0.Sexp.t
        -> ('ok, 'err) result

      val result_sexp_grammar
        :  'ok Sexplib0.Sexp_grammar.t
        -> 'err Sexplib0.Sexp_grammar.t
        -> ('ok, 'err) result Sexplib0.Sexp_grammar.t

      val typerep_of_result
        :  'ok Typerep_lib.Std.Typerep.t
        -> 'err Typerep_lib.Std.Typerep.t
        -> ('ok, 'err) result Typerep_lib.Std.Typerep.t

      val typename_of_result
        :  'ok Typerep_lib.Std.Typename.t
        -> 'err Typerep_lib.Std.Typename.t
        -> ('ok, 'err) result Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type string
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_string : Bin_prot.Shape.t
      val bin_size_string : string Bin_prot.Size.sizer
      val bin_size_string__local : string Bin_prot.Size.sizer_local
      val bin_write_string : string Bin_prot.Write.writer
      val bin_write_string__local : string Bin_prot.Write.writer_local
      val bin_writer_string : string Bin_prot.Type_class.writer
      val bin_read_string : string Bin_prot.Read.reader
      val __bin_read_string__ : (int -> string) Bin_prot.Read.reader
      val bin_reader_string : string Bin_prot.Type_class.reader
      val bin_string : string Bin_prot.Type_class.t
      val compare_string : string -> (string[@merlin.hide]) -> int
      val compare_string__local : string -> (string[@merlin.hide]) -> int
      val equal_string : string -> (string[@merlin.hide]) -> bool
      val equal_string__local : string -> (string[@merlin.hide]) -> bool
      val globalize_string : string -> string

      val hash_fold_string
        :  Ppx_hash_lib.Std.Hash.state
        -> string
        -> Ppx_hash_lib.Std.Hash.state

      val hash_string : string -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_string : string -> Sexplib0.Sexp.t
      val string_of_sexp : Sexplib0.Sexp.t -> string
      val string_sexp_grammar : string Sexplib0.Sexp_grammar.t
      val typerep_of_string : string Typerep_lib.Std.Typerep.t
      val typename_of_string : string Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type bytes
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_bytes : Bin_prot.Shape.t
      val bin_size_bytes : bytes Bin_prot.Size.sizer
      val bin_size_bytes__local : bytes Bin_prot.Size.sizer_local
      val bin_write_bytes : bytes Bin_prot.Write.writer
      val bin_write_bytes__local : bytes Bin_prot.Write.writer_local
      val bin_writer_bytes : bytes Bin_prot.Type_class.writer
      val bin_read_bytes : bytes Bin_prot.Read.reader
      val __bin_read_bytes__ : (int -> bytes) Bin_prot.Read.reader
      val bin_reader_bytes : bytes Bin_prot.Type_class.reader
      val bin_bytes : bytes Bin_prot.Type_class.t
      val compare_bytes : bytes -> (bytes[@merlin.hide]) -> int
      val compare_bytes__local : bytes -> (bytes[@merlin.hide]) -> int
      val equal_bytes : bytes -> (bytes[@merlin.hide]) -> bool
      val equal_bytes__local : bytes -> (bytes[@merlin.hide]) -> bool
      val globalize_bytes : bytes -> bytes
      val sexp_of_bytes : bytes -> Sexplib0.Sexp.t
      val bytes_of_sexp : Sexplib0.Sexp.t -> bytes
      val bytes_sexp_grammar : bytes Sexplib0.Sexp_grammar.t
      val typerep_of_bytes : bytes Typerep_lib.Std.Typerep.t
      val typename_of_bytes : bytes Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type 'a ref
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_ref : Bin_prot.Shape.t -> Bin_prot.Shape.t
      val bin_size_ref : 'a Bin_prot.Size.sizer -> 'a ref Bin_prot.Size.sizer

      val bin_size_ref__local
        :  'a Bin_prot.Size.sizer_local
        -> 'a ref Bin_prot.Size.sizer_local

      val bin_write_ref : 'a Bin_prot.Write.writer -> 'a ref Bin_prot.Write.writer

      val bin_write_ref__local
        :  'a Bin_prot.Write.writer_local
        -> 'a ref Bin_prot.Write.writer_local

      val bin_writer_ref
        :  'a Bin_prot.Type_class.writer
        -> 'a ref Bin_prot.Type_class.writer

      val bin_read_ref : 'a Bin_prot.Read.reader -> 'a ref Bin_prot.Read.reader

      val __bin_read_ref__
        :  'a Bin_prot.Read.reader
        -> (int -> 'a ref) Bin_prot.Read.reader

      val bin_reader_ref
        :  'a Bin_prot.Type_class.reader
        -> 'a ref Bin_prot.Type_class.reader

      val bin_ref : 'a Bin_prot.Type_class.t -> 'a ref Bin_prot.Type_class.t

      val compare_ref
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a ref
        -> ('a ref[@merlin.hide])
        -> int

      val compare_ref__local
        :  ('a -> ('a[@merlin.hide]) -> int)
        -> 'a ref
        -> ('a ref[@merlin.hide])
        -> int

      val equal_ref
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a ref
        -> ('a ref[@merlin.hide])
        -> bool

      val equal_ref__local
        :  ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a ref
        -> ('a ref[@merlin.hide])
        -> bool

      val globalize_ref : ('a -> 'a) -> 'a ref -> 'a ref
      val sexp_of_ref : ('a -> Sexplib0.Sexp.t) -> 'a ref -> Sexplib0.Sexp.t
      val ref_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a ref
      val ref_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a ref Sexplib0.Sexp_grammar.t

      val typerep_of_ref
        :  'a Typerep_lib.Std.Typerep.t
        -> 'a ref Typerep_lib.Std.Typerep.t

      val typename_of_ref
        :  'a Typerep_lib.Std.Typename.t
        -> 'a ref Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type unit
    [@@deriving
      bin_io ~localize
    , compare ~localize
    , equal ~localize
    , globalize
    , hash
    , sexp
    , sexp_grammar
    , typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_unit : Bin_prot.Shape.t
      val bin_size_unit : unit Bin_prot.Size.sizer
      val bin_size_unit__local : unit Bin_prot.Size.sizer_local
      val bin_write_unit : unit Bin_prot.Write.writer
      val bin_write_unit__local : unit Bin_prot.Write.writer_local
      val bin_writer_unit : unit Bin_prot.Type_class.writer
      val bin_read_unit : unit Bin_prot.Read.reader
      val __bin_read_unit__ : (int -> unit) Bin_prot.Read.reader
      val bin_reader_unit : unit Bin_prot.Type_class.reader
      val bin_unit : unit Bin_prot.Type_class.t
      val compare_unit : unit -> (unit[@merlin.hide]) -> int
      val compare_unit__local : unit -> (unit[@merlin.hide]) -> int
      val equal_unit : unit -> (unit[@merlin.hide]) -> bool
      val equal_unit__local : unit -> (unit[@merlin.hide]) -> bool
      val globalize_unit : unit -> unit

      val hash_fold_unit
        :  Ppx_hash_lib.Std.Hash.state
        -> unit
        -> Ppx_hash_lib.Std.Hash.state

      val hash_unit : unit -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_unit : unit -> Sexplib0.Sexp.t
      val unit_of_sexp : Sexplib0.Sexp.t -> unit
      val unit_sexp_grammar : unit Sexplib0.Sexp_grammar.t
      val typerep_of_unit : unit Typerep_lib.Std.Typerep.t
      val typename_of_unit : unit Typerep_lib.Std.Typename.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  with type 'a array := 'a array
  with type bool := bool
  with type char := char
  with type float := float
  with type int := int
  with type int32 := int32
  with type int64 := int64
  with type 'a list := 'a list
  with type nativeint := nativeint
  with type 'a option := 'a option
  with type ('ok, 'err) result := ('ok, 'err) result
  with type string := string
  with type bytes := bytes
  with type 'a lazy_t := 'a lazy_t
  with type 'a ref := 'a ref
  with type unit := unit)

let sexp_of_exn = Exn.sexp_of_t
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
