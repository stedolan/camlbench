let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"int_repr.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "int_repr.ml.before-ppx"
;;

module type T = sig
  type t [@@deriving compare, equal, hash, quickcheck, sexp, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Ppx_quickcheck_runtime.Quickcheckable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val signed : bool
  val num_bits : int
  val num_bytes : int
  val zero : t
  val min_value : t
  val max_value : t

  include Ppx_hash_lib.Hashable.S with type t := t
  include Base.Comparisons.S with type t := t

  module O : sig
    include Base.Comparisons.Infix with type t := t

    module Wrap : sig
      val ( + ) : t -> t -> t
      val ( - ) : t -> t -> t
      val ( * ) : t -> t -> t
      val ( / ) : t -> t -> t
    end
  end
end

let raise_cannot_repr ~mod_name ~to_string x =
  Base.raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string
             (mod_name ^ ": value cannot be represented")
         ; Ppx_sexp_conv_lib.Conv.sexp_of_string (to_string x)
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let trunc_unsigned : type a b. conv:(a -> b) -> logand:(a -> a -> a) -> mask:a -> a -> b =
  fun ~conv ~logand ~mask x -> conv (logand x mask)
[@@inline always]
;;

let exn_unsigned
  : type a b.
    conv:(a -> b)
    -> logand:(a -> a -> a)
    -> mask:a
    -> equal:(a -> a -> bool)
    -> mod_name:string
    -> to_string:(a -> string)
    -> a
    -> b
  =
  fun ~conv ~logand ~mask ~equal ~mod_name ~to_string x ->
  let y = trunc_unsigned ~conv:Fun.id ~logand ~mask x in
  if equal x y then conv y else raise_cannot_repr ~mod_name ~to_string x
[@@inline always]
;;

let trunc_signed
  : type a.
    shift_left:(a -> int -> a) -> shift_right:(a -> int -> a) -> shift:int -> a -> a
  =
  fun ~shift_left ~shift_right ~shift x -> shift_right (shift_left x shift) shift
[@@inline always]
;;

let exn_signed
  : type a.
    shift_left:(a -> int -> a)
    -> shift_right:(a -> int -> a)
    -> shift:int
    -> equal:(a -> a -> bool)
    -> mod_name:string
    -> to_string:(a -> string)
    -> a
    -> a
  =
  fun ~shift_left ~shift_right ~shift ~equal ~mod_name ~to_string x ->
  let y = trunc_signed ~shift_left ~shift_right ~shift x in
  if equal x y then y else raise_cannot_repr ~mod_name ~to_string x
;;

let identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x =
  if greater_equal x zero then x else raise_cannot_repr ~mod_name ~to_string x
[@@inline always]
;;

let of_sexp_error what sexp =
  raise (Sexplib0.Sexp_conv.Of_sexp_error (Failure what, sexp))
;;

module Repr32 = struct
  include Stdlib.Sys.Immediate64.Make (Base.Int) (Base.Int32)

  let to_int32 (x : t) : Base.Int32.t =
    match repr with
    | Immediate -> Base.Int32.of_int_trunc x
    | Non_immediate -> x
  ;;

  let to_int64 (x : t) : Base.Int64.t =
    match repr with
    | Immediate -> Base.Int64.of_int x
    | Non_immediate -> Base.Int64.of_int32 x
  ;;
end

type int8 = int
type uint8 = int
type int16 = int
type uint16 = int
type int32 = Repr32.t
type uint32 = Repr32.t
type int63 = Base.Int63.t
type uint63 = Base.Int63.t
type int64 = Base.Int64.t
type uint64 = Base.Int64.t

module Int8 = struct
  type t = Base.Int.t [@@immediate] [@@deriving compare, equal, globalize, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ -> Base.Int.compare a__001_ b__002_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__003_ b__004_ -> Base.Int.equal a__003_ b__004_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let typerep_of_t = Typerep_lib.Std.typerep_of_int
  let typename_of_t = Typerep_lib.Std.typename_of_int
  let zero = Base.Int.zero
  let min_value = -128
  let max_value = 127
  let signed = true
  let num_bits = 8
  let num_bytes = 1
  let shift_left = Base.Int.shift_left
  let shift_right = Base.Int.shift_right
  let shift = Base.Int.num_bits - num_bits
  let mod_name = "Int8"
  let to_string = Base.Int.to_string
  let trunc x = trunc_signed ~shift_left ~shift_right ~shift x [@@inline always]

  let exn x = exn_signed ~shift_left ~shift_right ~shift ~equal ~mod_name ~to_string x
  [@@inline always]
  ;;

  let of_base_int_trunc x = trunc x [@@inline always]
  let of_base_int_exn x = exn x [@@inline always]
  let to_base_int x = x [@@inline always]
  let of_int16_trunc x = trunc x [@@inline always]
  let of_int16_exn x = exn x [@@inline always]

  let of_int32_trunc x = trunc (Base.Int32.to_int_trunc (Repr32.to_int32 x))
  [@@inline always]
  ;;

  let of_int32_exn x = exn (Base.Int32.to_int_exn (Repr32.to_int32 x)) [@@inline always]
  let of_int63_trunc x = trunc (Base.Int63.to_int_trunc x) [@@inline always]
  let of_int63_exn x = exn (Base.Int63.to_int_exn x) [@@inline always]
  let of_int64_trunc x = trunc (Base.Int64.to_int_trunc x) [@@inline always]
  let of_int64_exn x = exn (Base.Int64.to_int_exn x) [@@inline always]
  let of_uint8_wrap x = trunc x [@@inline always]
  let of_uint8_exn x = exn x [@@inline always]
  let quickcheck_generator = Base_quickcheck.Generator.int_inclusive min_value max_value

  let quickcheck_observer =
    Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
  ;;

  let quickcheck_shrinker =
    Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
      equal x (trunc x))
  ;;

  module O = struct
    let ( >= ) = Base.Int.( >= )
    let ( <= ) = Base.Int.( <= )
    let ( = ) = Base.Int.( = )
    let ( > ) = Base.Int.( > )
    let ( < ) = Base.Int.( < )
    let ( <> ) = Base.Int.( <> )

    module Wrap = struct
      let ( + ) x y = trunc (Base.Int.( + ) x y)
      let ( - ) x y = trunc (Base.Int.( - ) x y)
      let ( * ) x y = trunc (Base.Int.( * ) x y)
      let ( / ) x y = trunc (Base.Int.( / ) x y)
    end
  end
end

module Uint8 = struct
  type t = Base.Int.t [@@immediate] [@@deriving compare, equal, globalize, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__007_ b__008_ -> Base.Int.compare a__007_ b__008_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__009_ b__010_ -> Base.Int.equal a__009_ b__010_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let typerep_of_t = Typerep_lib.Std.typerep_of_int
  let typename_of_t = Typerep_lib.Std.typename_of_int
  let zero = Base.Int.zero
  let min_value = Base.Int.zero
  let max_value = 255
  let signed = false
  let num_bits = 8
  let num_bytes = 1
  let conv = Base.Int64.to_int_trunc
  let logand = Base.Int.( land )
  let logand64 = Base.Int64.( land )
  let mask = 0xFF
  let mask64 = Base.Int64.of_int mask
  let equal = Base.Int.equal
  let equal64 = Base.Int64.equal
  let mod_name = "Uint8"
  let to_string = Base.Int.to_string
  let to_string64 = Base.Int64.to_string
  let trunc x = trunc_unsigned ~conv:Fun.id ~logand ~mask x [@@inline always]

  let exn x = exn_unsigned ~conv:Fun.id ~logand ~mask ~equal ~mod_name ~to_string x
  [@@inline always]
  ;;

  let trunc64 x = trunc_unsigned ~conv ~logand:logand64 ~mask:mask64 x [@@inline always]

  let exn64 x =
    exn_unsigned
      ~conv
      ~logand:logand64
      ~mask:mask64
      ~equal:equal64
      ~mod_name
      ~to_string:to_string64
      x
  [@@inline always]
  ;;

  let of_base_int_trunc x = trunc x [@@inline always]
  let of_base_int_exn x = exn x [@@inline always]
  let to_base_int x = x [@@inline always]
  let of_uint16_trunc x = trunc x [@@inline always]
  let of_uint16_exn x = exn x [@@inline always]
  let of_uint32_trunc x = trunc64 (Repr32.to_int64 x) [@@inline always]
  let of_uint32_exn x = exn64 (Repr32.to_int64 x) [@@inline always]
  let of_uint63_trunc x = trunc64 (Base.Int63.to_int64 x) [@@inline always]
  let of_uint63_exn x = exn64 (Base.Int63.to_int64 x) [@@inline always]
  let of_uint64_trunc x = trunc64 x [@@inline always]
  let of_uint64_exn x = exn64 x [@@inline always]
  let of_int8_wrap x = trunc x [@@inline always]
  let of_int8_exn x = exn x [@@inline always]
  let quickcheck_generator = Base_quickcheck.Generator.int_inclusive min_value max_value

  let quickcheck_observer =
    Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
  ;;

  let quickcheck_shrinker =
    Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
      equal x (trunc x))
  ;;

  module O = struct
    let ( >= ) = Base.Int.( >= )
    let ( <= ) = Base.Int.( <= )
    let ( = ) = Base.Int.( = )
    let ( > ) = Base.Int.( > )
    let ( < ) = Base.Int.( < )
    let ( <> ) = Base.Int.( <> )

    module Wrap = struct
      let ( + ) x y = trunc (Base.Int.( + ) x y)
      let ( - ) x y = trunc (Base.Int.( - ) x y)
      let ( * ) x y = trunc (Base.Int.( * ) x y)
      let ( / ) x y = trunc (Base.Int.( / ) x y)
    end
  end
end

module Int16 = struct
  type t = Base.Int.t [@@immediate] [@@deriving compare, equal, globalize, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__013_ b__014_ -> Base.Int.compare a__013_ b__014_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__015_ b__016_ -> Base.Int.equal a__015_ b__016_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let typerep_of_t = Typerep_lib.Std.typerep_of_int
  let typename_of_t = Typerep_lib.Std.typename_of_int
  let zero = Base.Int.zero
  let min_value = -32768
  let max_value = 32767
  let signed = true
  let num_bits = 16
  let num_bytes = 2
  let shift_left = Base.Int.shift_left
  let shift_right = Base.Int.shift_right
  let shift = Base.Int.num_bits - num_bits
  let mod_name = "Int16"
  let to_string = Base.Int.to_string
  let trunc x = trunc_signed ~shift_left ~shift_right ~shift x [@@inline always]

  let exn x = exn_signed ~shift_left ~shift_right ~shift ~equal ~mod_name ~to_string x
  [@@inline always]
  ;;

  let of_base_int_trunc x = trunc x [@@inline always]
  let of_base_int_exn x = exn x [@@inline always]
  let to_base_int x = x [@@inline always]
  let of_int8 x = x [@@inline always]

  let of_int32_trunc x = trunc (Base.Int32.to_int_trunc (Repr32.to_int32 x))
  [@@inline always]
  ;;

  let of_int32_exn x = exn (Base.Int32.to_int_exn (Repr32.to_int32 x)) [@@inline always]
  let of_int63_trunc x = trunc (Base.Int63.to_int_trunc x) [@@inline always]
  let of_int63_exn x = exn (Base.Int63.to_int_exn x) [@@inline always]
  let of_int64_trunc x = trunc (Base.Int64.to_int_trunc x) [@@inline always]
  let of_int64_exn x = exn (Base.Int64.to_int_exn x) [@@inline always]
  let of_uint16_wrap x = trunc x [@@inline always]
  let of_uint16_exn x = exn x [@@inline always]
  let quickcheck_generator = Base_quickcheck.Generator.int_inclusive min_value max_value

  let quickcheck_observer =
    Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
  ;;

  let quickcheck_shrinker =
    Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
      equal x (trunc x))
  ;;

  module O = struct
    let ( >= ) = Base.Int.( >= )
    let ( <= ) = Base.Int.( <= )
    let ( = ) = Base.Int.( = )
    let ( > ) = Base.Int.( > )
    let ( < ) = Base.Int.( < )
    let ( <> ) = Base.Int.( <> )

    module Wrap = struct
      let ( + ) x y = trunc (Base.Int.( + ) x y)
      let ( - ) x y = trunc (Base.Int.( - ) x y)
      let ( * ) x y = trunc (Base.Int.( * ) x y)
      let ( / ) x y = trunc (Base.Int.( / ) x y)
    end
  end
end

module Uint16 = struct
  type t = Base.Int.t [@@immediate] [@@deriving compare, equal, globalize, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__019_ b__020_ -> Base.Int.compare a__019_ b__020_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__021_ b__022_ -> Base.Int.equal a__021_ b__022_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let typerep_of_t = Typerep_lib.Std.typerep_of_int
  let typename_of_t = Typerep_lib.Std.typename_of_int
  let zero = Base.Int.zero
  let min_value = Base.Int.zero
  let max_value = 65535
  let signed = false
  let num_bits = 16
  let num_bytes = 2
  let conv = Base.Int64.to_int_trunc
  let logand = Base.Int.( land )
  let logand64 = Base.Int64.( land )
  let mask = 0xFFFF
  let mask64 = Base.Int64.of_int mask
  let equal = Base.Int.equal
  let equal64 = Base.Int64.equal
  let mod_name = "Uint16"
  let to_string = Base.Int.to_string
  let to_string64 = Base.Int64.to_string
  let trunc x = trunc_unsigned ~conv:Fun.id ~logand ~mask x [@@inline always]

  let exn x = exn_unsigned ~conv:Fun.id ~logand ~mask ~equal ~mod_name ~to_string x
  [@@inline always]
  ;;

  let trunc64 x = trunc_unsigned ~conv ~logand:logand64 ~mask:mask64 x [@@inline always]

  let exn64 x =
    exn_unsigned
      ~conv
      ~logand:logand64
      ~mask:mask64
      ~equal:equal64
      ~mod_name
      ~to_string:to_string64
      x
  [@@inline always]
  ;;

  let of_base_int_trunc x = trunc x [@@inline always]
  let of_base_int_exn x = exn x [@@inline always]
  let to_base_int x = x [@@inline always]
  let of_uint8 x = x [@@inline always]
  let of_uint32_trunc x = trunc64 (Repr32.to_int64 x) [@@inline always]
  let of_uint32_exn x = exn64 (Repr32.to_int64 x) [@@inline always]
  let of_uint63_trunc x = trunc64 (Base.Int63.to_int64 x) [@@inline always]
  let of_uint63_exn x = exn64 (Base.Int63.to_int64 x) [@@inline always]
  let of_uint64_trunc x = trunc64 x [@@inline always]
  let of_uint64_exn x = exn64 x [@@inline always]
  let of_int16_wrap x = trunc x [@@inline always]
  let of_int16_exn x = exn x [@@inline always]
  let quickcheck_generator = Base_quickcheck.Generator.int_inclusive min_value max_value

  let quickcheck_observer =
    Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
  ;;

  let quickcheck_shrinker =
    Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
      equal x (trunc x))
  ;;

  module O = struct
    let ( >= ) = Base.Int.( >= )
    let ( <= ) = Base.Int.( <= )
    let ( = ) = Base.Int.( = )
    let ( > ) = Base.Int.( > )
    let ( < ) = Base.Int.( < )
    let ( <> ) = Base.Int.( <> )

    module Wrap = struct
      let ( + ) x y = trunc (Base.Int.( + ) x y)
      let ( - ) x y = trunc (Base.Int.( - ) x y)
      let ( * ) x y = trunc (Base.Int.( * ) x y)
      let ( / ) x y = trunc (Base.Int.( / ) x y)
    end
  end
end

module type Backend32_S = sig
  module Signed : sig
    type t = Repr32.t

    include T with type t := t

    val of_base_int32 : Base.Int32.t -> t
    val to_base_int32 : t -> Base.Int32.t
    val of_int8 : int8 -> t
    val of_int16 : int16 -> t
    val of_int63_trunc : int63 -> t
    val of_int63_exn : int63 -> t
    val of_int64_trunc : int64 -> t
    val of_int64_exn : int64 -> t
    val of_uint32_wrap : uint32 -> t
    val of_uint32_exn : uint32 -> t
  end

  module Unsigned : sig
    type t = Repr32.t

    include T with type t := t

    val of_base_int32_trunc : Base.Int32.t -> t
    val of_base_int32_exn : Base.Int32.t -> t
    val to_base_int32_trunc : t -> Base.Int32.t
    val to_base_int32_exn : t -> Base.Int32.t
    val of_base_int64_trunc : Base.Int64.t -> t
    val of_base_int64_exn : Base.Int64.t -> t
    val to_base_int64 : t -> Base.Int64.t
    val of_base_int_exn : Base.Int.t -> t
    val to_base_int_exn : t -> Base.Int.t
    val of_uint8 : uint8 -> t
    val of_uint16 : uint16 -> t
    val of_uint63_trunc : uint63 -> t
    val of_uint63_exn : uint63 -> t
    val of_uint64_trunc : uint64 -> t
    val of_uint64_exn : uint64 -> t
    val of_int32_wrap : int32 -> t
    val of_int32_exn : int32 -> t
  end
end

module Backend32 : sig
  val impl : (module Backend32_S)
end = struct
  module I = struct
    module Signed = struct
      type t = Base.Int.t [@@immediate] [@@deriving compare, equal, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__025_ b__026_ -> Base.Int.compare a__025_ b__026_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__027_ b__028_ -> Base.Int.equal a__027_ b__028_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Int.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Int.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Base.Comparable.Make [@inlined] (struct
          type nonrec t = t

          let compare = compare
          let sexp_of_t = sexp_of_t
        end)

      let typerep_of_t = Typerep_lib.Std.typerep_of_int
      let typename_of_t = Typerep_lib.Std.typename_of_int
      let zero = Base.Int.zero
      let min_value = Base.Int32.to_int_trunc Base.Int32.min_value
      let max_value = Base.Int32.to_int_trunc Base.Int32.max_value
      let signed = true
      let num_bits = 32
      let num_bytes = 4
      let shift_left = Base.Int.shift_left
      let shift_right = Base.Int.shift_right
      let shift = Base.Int.num_bits - num_bits
      let mod_name = "Int32"
      let to_string = Base.Int.to_string
      let trunc x = trunc_signed ~shift_left ~shift_right ~shift x [@@inline always]

      let exn x = exn_signed ~shift_left ~shift_right ~shift ~equal ~mod_name ~to_string x
      [@@inline always]
      ;;

      let of_base_int32 x = Base.Int32.to_int_trunc x [@@inline always]
      let to_base_int32 x = Base.Int32.of_int_trunc x [@@inline always]
      let of_int8 x = (x : Int8.t :> int) [@@inline always]
      let of_int16 x = (x : Int16.t :> int) [@@inline always]
      let of_int63_trunc x = trunc (Base.Int63.to_int_trunc x) [@@inline always]
      let of_int63_exn x = exn (Base.Int63.to_int_exn x) [@@inline always]
      let of_int64_trunc x = trunc (Base.Int64.to_int_trunc x) [@@inline always]
      let of_int64_exn x = exn (Base.Int64.to_int_exn x) [@@inline always]
      let of_uint32_wrap x = trunc x
      let of_uint32_exn x = exn x

      let quickcheck_generator =
        Base_quickcheck.Generator.int_inclusive min_value max_value
      ;;

      let quickcheck_observer =
        Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
      ;;

      let quickcheck_shrinker =
        Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
          equal x (trunc x))
      ;;

      module O = struct
        let ( >= ) = Base.Int.( >= )
        let ( <= ) = Base.Int.( <= )
        let ( = ) = Base.Int.( = )
        let ( > ) = Base.Int.( > )
        let ( < ) = Base.Int.( < )
        let ( <> ) = Base.Int.( <> )

        module Wrap = struct
          let ( + ) x y = trunc (Base.Int.( + ) x y)
          let ( - ) x y = trunc (Base.Int.( - ) x y)
          let ( * ) x y = trunc (Base.Int.( * ) x y)
          let ( / ) x y = trunc (Base.Int.( / ) x y)
        end
      end
    end

    module Unsigned = struct
      type t = Base.Int.t [@@immediate] [@@deriving compare, equal, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__030_ b__031_ -> Base.Int.compare a__030_ b__031_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__032_ b__033_ -> Base.Int.equal a__032_ b__033_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Int.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Int.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (Base.Int.t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (Base.Int.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Base.Comparable.Make [@inlined] (struct
          type nonrec t = t

          let compare = compare
          let sexp_of_t = sexp_of_t
        end)

      let typerep_of_t = Typerep_lib.Std.typerep_of_int
      let typename_of_t = Typerep_lib.Std.typename_of_int
      let zero = Base.Int.zero
      let min_value = Base.Int.zero
      let max_value = Base.Int.of_int64_trunc 4294967295L
      let signed = false
      let num_bits = 32
      let num_bytes = 4
      let conv = Base.Int64.to_int_trunc
      let logand = Base.Int.( land )
      let logand64 = Base.Int64.( land )
      let mask = Base.Int64.to_int_trunc 0xFFFFFFFFL
      let mask64 = Base.Int64.of_int mask
      let equal = Base.Int.equal
      let equal64 = Base.Int64.equal
      let mod_name = "Uint32"
      let to_string = Base.Int.to_string
      let to_string64 = Base.Int64.to_string
      let trunc x = trunc_unsigned ~conv:Fun.id ~logand ~mask x [@@inline always]

      let exn x = exn_unsigned ~conv:Fun.id ~logand ~mask ~equal ~mod_name ~to_string x
      [@@inline always]
      ;;

      let trunc64 x = trunc_unsigned ~conv ~logand:logand64 ~mask:mask64 x
      [@@inline always]
      ;;

      let exn64 x =
        exn_unsigned
          ~conv
          ~logand:logand64
          ~mask:mask64
          ~equal:equal64
          ~mod_name
          ~to_string:to_string64
          x
      [@@inline always]
      ;;

      let of_base_int32_trunc x =
        Base.Int64.to_int_trunc (logand64 (Base.Int64.of_int32 x) mask64)
      [@@inline always]
      ;;

      let of_base_int32_exn x = exn (Base.Int32.to_int_trunc x) [@@inline always]
      let to_base_int32_trunc x = Base.Int.to_int32_trunc x [@@inline always]

      let to_base_int32_exn x =
        if Base.Int.( <= ) x (Base.Int.of_int64_trunc 2147483647L)
        then Base.Int32.of_int_trunc x
        else raise_cannot_repr ~mod_name ~to_string:Base.Int.to_string x
      [@@inline always]
      ;;

      let of_base_int64_trunc x = trunc64 x [@@inline always]
      let of_base_int64_exn x = exn64 x [@@inline always]
      let to_base_int64 x = Base.Int.to_int64 x [@@inline always]
      let of_base_int_exn x = exn x [@@inline always]
      let to_base_int_exn x = x [@@inline always]
      let of_uint8 x = (x : Uint8.t :> int) [@@inline always]
      let of_uint16 x = (x : Uint16.t :> int) [@@inline always]
      let of_uint63_trunc x = trunc64 (Base.Int63.to_int64 x) [@@inline always]
      let of_uint63_exn x = exn64 (Base.Int63.to_int64 x) [@@inline always]
      let of_uint64_trunc x = trunc64 x [@@inline always]
      let of_uint64_exn x = exn64 x [@@inline always]
      let of_int32_wrap x = trunc x [@@inline always]
      let of_int32_exn x = exn x [@@inline always]

      let quickcheck_generator =
        Base_quickcheck.Generator.int_inclusive min_value max_value
      ;;

      let quickcheck_observer =
        Base_quickcheck.Observer.unmap Base_quickcheck.Observer.int ~f:trunc
      ;;

      let quickcheck_shrinker =
        Base_quickcheck.Shrinker.filter Base_quickcheck.Shrinker.int ~f:(fun x ->
          equal x (trunc x))
      ;;

      module O = struct
        let ( >= ) = Base.Int.( >= )
        let ( <= ) = Base.Int.( <= )
        let ( = ) = Base.Int.( = )
        let ( > ) = Base.Int.( > )
        let ( < ) = Base.Int.( < )
        let ( <> ) = Base.Int.( <> )

        module Wrap = struct
          let ( + ) x y = trunc (Base.Int.( + ) x y)
          let ( - ) x y = trunc (Base.Int.( - ) x y)
          let ( * ) x y = trunc (Base.Int.( * ) x y)
          let ( / ) x y = trunc (Base.Int.( / ) x y)
        end
      end
    end
  end

  module N = struct
    module Signed = struct
      type t = Base.Int32.t [@@deriving compare, equal, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__035_ b__036_ -> Base.Int32.compare a__035_ b__036_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__037_ b__038_ -> Base.Int32.equal a__037_ b__038_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Int32.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Int32.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (Base.Int32.t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (Base.Int32.sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Base.Comparable.Make [@inlined] (struct
          type nonrec t = t

          let compare = compare
          let sexp_of_t = sexp_of_t
        end)

      let quickcheck_generator = Base_quickcheck.quickcheck_generator_int32
      let quickcheck_observer = Base_quickcheck.quickcheck_observer_int32
      let quickcheck_shrinker = Base_quickcheck.quickcheck_shrinker_int32
      let typerep_of_t = Typerep_lib.Std.typerep_of_int32
      let typename_of_t = Typerep_lib.Std.typename_of_int32
      let zero = Base.Int32.zero
      let min_value = Base.Int32.min_value
      let max_value = Base.Int32.max_value
      let signed = true
      let num_bits = 32
      let num_bytes = 4
      let mod_name = "Int32"
      let greater_equal = Base.Int32.( >= )
      let to_string = Base.Int32.to_string
      let of_base_int32 x = x [@@inline always]
      let to_base_int32 x = x [@@inline always]
      let of_int8 x = Base.Int32.of_int_trunc (x : Int8.t :> int) [@@inline always]
      let of_int16 x = Base.Int32.of_int_trunc (x : Int16.t :> int) [@@inline always]
      let of_int63_trunc x = Base.Int63.to_int32_trunc x [@@inline always]
      let of_int63_exn x = Base.Int63.to_int32_exn x [@@inline always]
      let of_int64_trunc x = Base.Int64.to_int32_trunc x [@@inline always]
      let of_int64_exn x = Base.Int64.to_int32_exn x [@@inline always]
      let of_uint32_wrap x = x [@@inline always]

      let of_uint32_exn x : t =
        identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
      [@@inline always]
      ;;

      module O = struct
        let ( >= ) = Base.Int32.( >= )
        let ( <= ) = Base.Int32.( <= )
        let ( = ) = Base.Int32.( = )
        let ( > ) = Base.Int32.( > )
        let ( < ) = Base.Int32.( < )
        let ( <> ) = Base.Int32.( <> )

        module Wrap = struct
          let ( + ) = Base.Int32.( + )
          let ( - ) = Base.Int32.( - )
          let ( * ) = Base.Int32.( * )
          let ( / ) = Base.Int32.( / )
        end
      end
    end

    module Unsigned = struct
      type t = Base.Int32.t [@@deriving equal, hash]

      include struct
        let _ = fun (_ : t) -> ()

        let equal =
          (fun a__040_ b__041_ -> Base.Int32.equal a__040_ b__041_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> Base.Int32.hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = Base.Int32.hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let quickcheck_generator = Base_quickcheck.quickcheck_generator_int32
      let quickcheck_observer = Base_quickcheck.quickcheck_observer_int32
      let quickcheck_shrinker = Base_quickcheck.quickcheck_shrinker_int32
      let compare x y = Stdlib.Int32.unsigned_compare x y [@@inline always]
      let typerep_of_t = Typerep_lib.Std.typerep_of_int32
      let typename_of_t = Typerep_lib.Std.typename_of_int32
      let zero = Base.Int32.zero
      let min_value = Base.Int32.zero
      let max_value = -1l
      let signed = false
      let num_bits = 32
      let num_bytes = 4
      let mod_name = "Uint32"
      let greater_equal = Base.Int32.( >= )
      let to_string = Base.Int32.to_string
      let of_base_int32_trunc x = x [@@inline always]

      let of_base_int32_exn x =
        identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
      [@@inline always]
      ;;

      let to_base_int32_trunc x = x [@@inline always]

      let to_base_int32_exn x =
        identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
      [@@inline always]
      ;;

      let of_base_int64_trunc x = Base.Int32.of_int64_trunc x [@@inline always]

      let of_base_int64_exn x =
        if Base.Int64.( >= ) x 0L && Base.Int64.( <= ) x 4294967295L
        then Base.Int64.to_int32_trunc x
        else raise_cannot_repr ~mod_name ~to_string:Base.Int64.to_string x
      [@@inline always]
      ;;

      let to_base_int64 x = Base.Int64.( land ) (Base.Int32.to_int64 x) 0xFFFFFFFFL
      [@@inline always]
      ;;

      let of_base_int_exn x =
        identity_if_positive
          ~greater_equal
          ~zero
          ~mod_name
          ~to_string
          (Base.Int32.of_int_exn x)
      [@@inline always]
      ;;

      let to_base_int_exn x =
        Base.Int32.to_int_exn
          (identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x)
      [@@inline always]
      ;;

      let of_uint8 x = Base.Int32.of_int_trunc (x : Uint8.t :> int) [@@inline always]
      let of_uint16 x = Base.Int32.of_int_trunc (x : Uint16.t :> int) [@@inline always]

      let of_uint63_trunc x = of_base_int64_trunc (Base.Int63.to_int64 x)
      [@@inline always]
      ;;

      let of_uint63_exn x = of_base_int64_exn (Base.Int63.to_int64 x) [@@inline always]
      let of_uint64_trunc x = of_base_int64_trunc x [@@inline always]
      let of_uint64_exn x = of_base_int64_exn x [@@inline always]
      let of_int32_wrap x = x [@@inline always]

      let of_int32_exn x =
        identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
      [@@inline always]
      ;;

      let sexp_of_t x = Base.Sexp.Atom (Stdlib.Printf.sprintf "%lu" x)

      let t_of_sexp sexp =
        match sexp with
        | Base.Sexp.List _ -> of_sexp_error "Int_repr.Uint32.t_of_sexp: atom needed" sexp
        | Base.Sexp.Atom s ->
          (try Stdlib.Scanf.sscanf s "%lu" Fun.id with
           | _ -> of_sexp_error "Int_repr.Uint32.t_of_sexp: integer atom needed" sexp)
      ;;

      module O = struct
        let ( >= ) x y = compare x y >= 0
        let ( <= ) x y = compare x y <= 0
        let ( = ) x y = compare x y = 0
        let ( > ) x y = compare x y > 0
        let ( < ) x y = compare x y < 0
        let ( <> ) x y = compare x y <> 0

        module Wrap = struct
          let ( + ) = Base.Int32.( + )
          let ( - ) = Base.Int32.( - )
          let ( * ) = Base.Int32.( * )
          let ( / ) = Stdlib.Int32.unsigned_div
        end
      end

      include Base.Comparable.Make [@inlined] (struct
          type nonrec t = t

          let compare = compare
          let sexp_of_t = sexp_of_t
        end)
    end
  end

  let impl : (module Backend32_S) =
    match Repr32.repr with
    | Immediate -> ((module I) : (module Backend32_S))
    | Non_immediate -> ((module N) : (module Backend32_S))
  ;;
end

module Int32 = struct
  module M = (val (Backend32.impl : (module Backend32_S)))
  include M.Signed
end

module Uint32 = struct
  module M = (val (Backend32.impl : (module Backend32_S)))
  include M.Unsigned
end

module Int63 = struct
  type t = Base.Int63.t [@@immediate64] [@@deriving compare, equal, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__042_ b__043_ -> Base.Int63.compare a__042_ b__043_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__044_ b__045_ -> Base.Int63.equal a__044_ b__045_
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let quickcheck_generator = Base_quickcheck.Generator.int63_uniform
  let quickcheck_observer = Base_quickcheck.Observer.int63
  let quickcheck_shrinker = Base_quickcheck.Shrinker.int63
  let typerep_of_t = Typerep_lib.Std.typerep_of_int63
  let typename_of_t = Typerep_lib.Std.typename_of_int63
  let zero = Base.Int63.zero
  let min_value = Base.Int63.min_value
  let max_value = Base.Int63.max_value
  let signed = true
  let num_bits = 63
  let num_bytes = 8
  let mod_name = "Int63"
  let greater_equal = Base.Int63.( >= )
  let to_string = Base.Int63.to_string
  let of_int8 x = Base.Int63.of_int x [@@inline always]
  let of_int16 x = Base.Int63.of_int x [@@inline always]
  let of_int32 x = Base.Int63.of_int32 (Int32.to_base_int32 x) [@@inline always]
  let of_int64_trunc x = Base.Int63.of_int64_trunc x [@@inline always]
  let of_int64_exn x = Base.Int63.of_int64_exn x [@@inline always]
  let of_uint63_wrap x = x [@@inline always]

  let of_uint63_exn x = identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
  [@@inline always]
  ;;

  module O = struct
    let ( >= ) = Base.Int63.( >= )
    let ( <= ) = Base.Int63.( <= )
    let ( = ) = Base.Int63.( = )
    let ( > ) = Base.Int63.( > )
    let ( < ) = Base.Int63.( < )
    let ( <> ) = Base.Int63.( <> )

    module Wrap = struct
      let ( + ) = Base.Int63.( + )
      let ( - ) = Base.Int63.( - )
      let ( * ) = Base.Int63.( * )
      let ( / ) = Base.Int63.( / )
    end
  end
end

module Uint63 = struct
  type t = Base.Int63.t [@@deriving equal, hash]

  include struct
    let _ = fun (_ : t) -> ()

    let equal =
      (fun a__047_ b__048_ -> Base.Int63.equal a__047_ b__048_
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
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let quickcheck_generator = Base_quickcheck.Generator.int63_uniform
  let quickcheck_observer = Base_quickcheck.Observer.int63
  let quickcheck_shrinker = Base_quickcheck.Shrinker.int63

  let compare x y =
    Stdlib.Int64.unsigned_compare (Base.Int63.to_int64 x) (Base.Int63.to_int64 y)
  ;;

  let typerep_of_t = Typerep_lib.Std.typerep_of_int63
  let typename_of_t = Typerep_lib.Std.typename_of_int63
  let zero = Base.Int63.zero
  let min_value = Base.Int63.zero
  let max_value = Base.Int63.of_int64_trunc 9223372036854775807L
  let signed = false
  let num_bits = 63
  let num_bytes = 8
  let greater_equal = Base.Int63.( >= )
  let mod_name = "Uint63"
  let to_string = Base.Int63.to_string

  let exn x = identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
  [@@inline always]
  ;;

  let of_base_int64_trunc x = Base.Int63.of_int64_trunc x [@@inline always]

  let of_base_int64_exn x =
    if Base.Int64.( >= ) x 0L
    then Base.Int63.of_int64_trunc x
    else raise_cannot_repr ~mod_name ~to_string:Base.Int64.to_string x
  [@@inline always]
  ;;

  let to_base_int64 x = Base.Int64.( land ) (Base.Int63.to_int64 x) 0x7FFFFFFFFFFFFFFFL
  [@@inline always]
  ;;

  let of_uint8 x = Base.Int63.of_int x [@@inline always]
  let of_uint16 x = Base.Int63.of_int x [@@inline always]
  let of_uint32 x = Base.Int63.of_int64_trunc (Uint32.to_base_int64 x) [@@inline always]
  let of_uint64_trunc x = Base.Int63.of_int64_trunc x [@@inline always]

  let of_uint64_exn (x : uint64) : t =
    if Base.Int64.( >= ) x 0L
    then Base.Int63.of_int64_trunc x
    else raise_cannot_repr ~mod_name ~to_string:Base.Int64.to_string x
  [@@inline always]
  ;;

  let of_int63_wrap x = x [@@inline always]
  let of_int63_exn x = exn x [@@inline always]
  let sexp_of_t x = Base.Sexp.Atom (Stdlib.Printf.sprintf "%Lu" (to_base_int64 x))

  let t_of_sexp sexp =
    match sexp with
    | Base.Sexp.List _ -> of_sexp_error "Int_repr.Uint63.t_of_sexp: atom needed" sexp
    | Base.Sexp.Atom s ->
      (try Stdlib.Scanf.sscanf s "%Lu" of_base_int64_exn with
       | _ -> of_sexp_error "Int_repr.Uint63.t_of_sexp: integer atom needed" sexp)
  ;;

  module O = struct
    let ( >= ) x y = compare x y >= 0
    let ( <= ) x y = compare x y <= 0
    let ( = ) x y = compare x y = 0
    let ( > ) x y = compare x y > 0
    let ( < ) x y = compare x y < 0
    let ( <> ) x y = compare x y <> 0

    module Wrap = struct
      let ( + ) = Base.Int63.( + )
      let ( - ) = Base.Int63.( - )
      let ( * ) = Base.Int63.( * )

      let ( / ) x y =
        of_base_int64_trunc (Base.Int64.( / ) (to_base_int64 x) (to_base_int64 y))
      ;;
    end
  end

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)
end

module Int64 = struct
  type t = Base.Int64.t [@@deriving compare, equal, globalize, hash, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__049_ b__050_ -> Base.Int64.compare a__049_ b__050_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__051_ b__052_ -> Base.Int64.equal a__051_ b__052_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int64.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int64.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int64.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (Base.Int64.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Base.Int64.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)

  let quickcheck_generator = Base_quickcheck.quickcheck_generator_int64
  let quickcheck_observer = Base_quickcheck.quickcheck_observer_int64
  let quickcheck_shrinker = Base_quickcheck.quickcheck_shrinker_int64
  let typerep_of_t = Typerep_lib.Std.typerep_of_int64
  let typename_of_t = Typerep_lib.Std.typename_of_int64
  let zero = Base.Int64.zero
  let min_value = Base.Int64.min_value
  let max_value = Base.Int64.max_value
  let signed = true
  let num_bits = 64
  let num_bytes = 8
  let mod_name = "Int64"
  let greater_equal = Base.Int64.( >= )
  let to_string = Base.Int64.to_string
  let of_int8 x = Base.Int64.of_int x [@@inline always]
  let of_int16 x = Base.Int64.of_int x [@@inline always]
  let of_int32 x = Base.Int64.of_int32 (Int32.to_base_int32 x) [@@inline always]
  let of_int63 x = Base.Int63.to_int64 x [@@inline always]
  let of_uint64_wrap x = x [@@inline always]

  let of_uint64_exn x = identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
  [@@inline always]
  ;;

  module O = struct
    let ( >= ) = Base.Int64.( >= )
    let ( <= ) = Base.Int64.( <= )
    let ( = ) = Base.Int64.( = )
    let ( > ) = Base.Int64.( > )
    let ( < ) = Base.Int64.( < )
    let ( <> ) = Base.Int64.( <> )

    module Wrap = struct
      let ( + ) = Base.Int64.( + )
      let ( - ) = Base.Int64.( - )
      let ( * ) = Base.Int64.( * )
      let ( / ) = Base.Int64.( / )
    end
  end
end

module Uint64 = struct
  type t = Base.Int64.t [@@deriving equal, globalize, hash]

  include struct
    let _ = fun (_ : t) -> ()

    let equal =
      (fun a__055_ b__056_ -> Base.Int64.equal a__055_ b__056_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let globalize : t -> t = (Base.Int64.globalize : t -> t)
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Base.Int64.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Base.Int64.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let quickcheck_generator = Base_quickcheck.quickcheck_generator_int64
  let quickcheck_observer = Base_quickcheck.quickcheck_observer_int64
  let quickcheck_shrinker = Base_quickcheck.quickcheck_shrinker_int64
  let compare = Stdlib.Int64.unsigned_compare
  let typerep_of_t = Typerep_lib.Std.typerep_of_int64
  let typename_of_t = Typerep_lib.Std.typename_of_int64
  let zero = Base.Int64.zero
  let min_value = Base.Int64.zero
  let max_value = -1L
  let signed = false
  let num_bits = 64
  let num_bytes = 8
  let greater_equal = Base.Int64.( >= )
  let mod_name = "Uint64"
  let to_string = Base.Int64.to_string

  let exn x = identity_if_positive ~greater_equal ~zero ~mod_name ~to_string x
  [@@inline always]
  ;;

  let of_base_int64_trunc x = x [@@inline always]
  let of_base_int64_exn x = exn x [@@inline always]
  let to_base_int64_trunc x = x [@@inline always]
  let to_base_int64_exn x = exn x [@@inline always]
  let of_uint8 x = Base.Int64.of_int x [@@inline always]
  let of_uint16 x = Base.Int64.of_int x [@@inline always]
  let of_uint32 x = Uint32.to_base_int64 x [@@inline always]

  let of_uint63 (x : uint63) : int64 =
    Base.Int64.( land ) (Base.Int63.to_int64 x) 0x7FFFFFFFFFFFFFFFL
  [@@inline always]
  ;;

  let of_int64_wrap x = x [@@inline always]
  let of_int64_exn x = exn x [@@inline always]
  let sexp_of_t x = Base.Sexp.Atom (Stdlib.Printf.sprintf "%Lu" x)

  let t_of_sexp sexp =
    match sexp with
    | Base.Sexp.List _ -> of_sexp_error "Int_repr.Uint64.t_of_sexp: atom needed" sexp
    | Base.Sexp.Atom s ->
      (try Stdlib.Scanf.sscanf s "%Lu" Fun.id with
       | _ -> of_sexp_error "Int_repr.Uint64.t_of_sexp: integer atom needed" sexp)
  ;;

  module O = struct
    let ( >= ) x y = compare x y >= 0
    let ( <= ) x y = compare x y <= 0
    let ( = ) x y = compare x y = 0
    let ( > ) x y = compare x y > 0
    let ( < ) x y = compare x y < 0
    let ( <> ) x y = compare x y <> 0

    module Wrap = struct
      let ( + ) = Base.Int64.( + )
      let ( - ) = Base.Int64.( - )
      let ( * ) = Base.Int64.( * )
      let ( / ) = Stdlib.Int64.unsigned_div
    end
  end

  include Base.Comparable.Make [@inlined] (struct
      type nonrec t = t

      let compare = compare
      let sexp_of_t = sexp_of_t
    end)
end

module type Get = sig
  type t

  val get_int8 : t -> pos:int -> int8
  val get_uint8 : t -> pos:int -> uint8
  val get_int16_le : t -> pos:int -> int16
  val get_int16_be : t -> pos:int -> int16
  val get_uint16_le : t -> pos:int -> uint16
  val get_uint16_be : t -> pos:int -> uint16
  val get_int32_le : t -> pos:int -> int32
  val get_int32_be : t -> pos:int -> int32
  val get_uint32_le : t -> pos:int -> uint32
  val get_uint32_be : t -> pos:int -> uint32
  val get_int64_le : t -> pos:int -> int64
  val get_int64_be : t -> pos:int -> int64
  val get_uint64_le : t -> pos:int -> uint64
  val get_uint64_be : t -> pos:int -> uint64

  module Local : sig
    val get_int64_le : t -> pos:int -> int64
    val get_int64_be : t -> pos:int -> int64
    val get_uint64_le : t -> pos:int -> uint64
    val get_uint64_be : t -> pos:int -> uint64
  end
end

module type Set = sig
  type t

  val set_int8 : t -> pos:int -> int8 -> unit
  val set_uint8 : t -> pos:int -> uint8 -> unit
  val set_int16_le : t -> pos:int -> int16 -> unit
  val set_int16_be : t -> pos:int -> int16 -> unit
  val set_uint16_le : t -> pos:int -> uint16 -> unit
  val set_uint16_be : t -> pos:int -> uint16 -> unit
  val set_int32_le : t -> pos:int -> int32 -> unit
  val set_int32_be : t -> pos:int -> int32 -> unit
  val set_uint32_le : t -> pos:int -> uint32 -> unit
  val set_uint32_be : t -> pos:int -> uint32 -> unit
  val set_int64_le : t -> pos:int -> int64 -> unit
  val set_int64_be : t -> pos:int -> int64 -> unit
  val set_uint64_le : t -> pos:int -> uint64 -> unit
  val set_uint64_be : t -> pos:int -> uint64 -> unit
end

module type Get_functions = sig
  type t

  val get_uint8 : t -> int -> Base.Int.t
  val get_uint16_ne : t -> int -> Base.Int.t
  val get_int32_ne : t -> int -> Base.Int32.t
  val get_int64_ne : t -> int -> Base.Int64.t

  module Local : sig
    val get_int64_ne : t -> int -> Base.Int64.t
  end
end

module type Set_functions = sig
  type t

  val set_uint8 : t -> int -> Base.Int.t -> unit
  val set_uint16_ne : t -> int -> Base.Int.t -> unit
  val set_int32_ne : t -> int -> Base.Int32.t -> unit
  val set_int64_ne : t -> int -> Base.Int64.t -> unit
end

external swap16 : int -> int = "%bswap16"
external swap32 : Stdlib.Int32.t -> Stdlib.Int32.t = "%bswap_int32"

external swap64
  :  (Stdlib.Int64.t[@local_opt])
  -> (Stdlib.Int64.t[@local_opt])
  = "%bswap_int64"

external int64_to_uint64 : (int64[@local_opt]) -> (Uint64.t[@local_opt]) = "%identity"
external uint64_to_int64 : (Uint64.t[@local_opt]) -> (int64[@local_opt]) = "%identity"

module Make_get (F : Get_functions) : Get with type t := F.t = struct
  let get_int8 t ~pos = Int8.of_base_int_trunc (F.get_uint8 t pos)
  let get_uint8 t ~pos = Uint8.of_base_int_trunc (F.get_uint8 t pos)

  let get_int16_le t ~pos =
    let x = F.get_uint16_ne t pos in
    Int16.of_base_int_trunc (if Sys.big_endian then swap16 x else x)
  ;;

  let get_int16_be t ~pos =
    let x = F.get_uint16_ne t pos in
    Int16.of_base_int_trunc (if Sys.big_endian then x else swap16 x)
  ;;

  let get_uint16_le t ~pos =
    let x = F.get_uint16_ne t pos in
    Uint16.of_base_int_trunc (if Sys.big_endian then swap16 x else x)
  ;;

  let get_uint16_be t ~pos =
    let x = F.get_uint16_ne t pos in
    Uint16.of_base_int_trunc (if Sys.big_endian then x else swap16 x)
  ;;

  let get_int32_le t ~pos =
    let x = F.get_int32_ne t pos in
    Int32.of_base_int32 (if Sys.big_endian then swap32 x else x)
  ;;

  let get_int32_be t ~pos =
    let x = F.get_int32_ne t pos in
    Int32.of_base_int32 (if Sys.big_endian then x else swap32 x)
  ;;

  let get_uint32_le t ~pos =
    let x = F.get_int32_ne t pos in
    Uint32.of_base_int32_trunc (if Sys.big_endian then swap32 x else x)
  ;;

  let get_uint32_be t ~pos =
    let x = F.get_int32_ne t pos in
    Uint32.of_base_int32_trunc (if Sys.big_endian then x else swap32 x)
  ;;

  let get_int64_le t ~pos =
    let x = F.get_int64_ne t pos in
    if Sys.big_endian then swap64 x else x
  ;;

  let get_int64_be t ~pos =
    let x = F.get_int64_ne t pos in
    if Sys.big_endian then x else swap64 x
  ;;

  let get_uint64_le t ~pos =
    let x = F.get_int64_ne t pos in
    Uint64.of_base_int64_trunc (if Sys.big_endian then swap64 x else x)
  ;;

  let get_uint64_be t ~pos =
    let x = F.get_int64_ne t pos in
    Uint64.of_base_int64_trunc (if Sys.big_endian then x else swap64 x)
  ;;

  module Local = struct
    let get_int64_le t ~pos =
      let x = F.Local.get_int64_ne t pos in
      if Sys.big_endian then swap64 x else x
    ;;

    let get_int64_be t ~pos =
      let x = F.Local.get_int64_ne t pos in
      if Sys.big_endian then x else swap64 x
    ;;

    let get_uint64_le t ~pos =
      let x = F.Local.get_int64_ne t pos in
      int64_to_uint64 (if Sys.big_endian then swap64 x else x)
    ;;

    let get_uint64_be t ~pos =
      let x = F.Local.get_int64_ne t pos in
      int64_to_uint64 (if Sys.big_endian then x else swap64 x)
    ;;
  end
end
[@@inline always]

module Make_set (F : Set_functions) : Set with type t := F.t = struct
  let set_uint8 t ~pos x = F.set_uint8 t pos x
  let set_int8 t ~pos x = set_uint8 t ~pos (Uint8.of_int8_wrap x)

  let set_uint16_le t ~pos x =
    let x = if Sys.big_endian then swap16 x else x in
    F.set_uint16_ne t pos x
  ;;

  let set_uint16_be t ~pos x =
    let x = if Sys.big_endian then x else swap16 x in
    F.set_uint16_ne t pos x
  ;;

  let set_int16_le t ~pos x = set_uint16_le t ~pos (Uint16.of_int16_wrap x)
  let set_int16_be t ~pos x = set_uint16_be t ~pos (Uint16.of_int16_wrap x)

  let set_int32_le t ~pos x =
    let x = Int32.to_base_int32 x in
    let x = if Sys.big_endian then swap32 x else x in
    F.set_int32_ne t pos x
  ;;

  let set_int32_be t ~pos x =
    let x = Int32.to_base_int32 x in
    let x = if Sys.big_endian then x else swap32 x in
    F.set_int32_ne t pos x
  ;;

  let set_uint32_le t ~pos x = set_int32_le t ~pos (Int32.of_uint32_wrap x)
  let set_uint32_be t ~pos x = set_int32_be t ~pos (Int32.of_uint32_wrap x)

  let set_int64_le t ~pos x =
    let x = if Sys.big_endian then swap64 x else x in
    (F.set_int64_ne t pos x [@nontail])
  ;;

  let set_int64_be t ~pos x =
    let x = if Sys.big_endian then x else swap64 x in
    (F.set_int64_ne t pos x [@nontail])
  ;;

  let set_uint64_le t ~pos x = set_int64_le t ~pos (uint64_to_int64 x) [@nontail]
  let set_uint64_be t ~pos x = set_int64_be t ~pos (uint64_to_int64 x) [@nontail]
end
[@@inline always]

module Bytes0Unsafe = struct
  type t = Bytes.t

  external get_uint8 : Bytes.t -> int -> int = "%bytes_unsafe_get"
  external get_uint16_ne : Bytes.t -> int -> int = "%caml_bytes_get16u"
  external get_int32_ne : Bytes.t -> int -> Stdlib.Int32.t = "%caml_bytes_get32u"
  external get_int64_ne : Bytes.t -> int -> Stdlib.Int64.t = "%caml_bytes_get64u"
  external set_uint8 : Bytes.t -> int -> int -> unit = "%bytes_unsafe_set"
  external set_uint16_ne : Bytes.t -> int -> int -> unit = "%caml_bytes_set16u"
  external set_int32_ne : Bytes.t -> int -> Stdlib.Int32.t -> unit = "%caml_bytes_set32u"

  external set_int64_ne
    :  Bytes.t
    -> int
    -> (Stdlib.Int64.t[@local_opt])
    -> unit
    = "%caml_bytes_set64u"

  module Local = struct
    external get_int64_ne : Bytes.t -> int -> Stdlib.Int64.t = "%caml_bytes_get64u"
  end
end

module Bytes = struct
  module Bytes = struct
    include Bytes

    external set_int64_ne
      :  Bytes.t
      -> int
      -> (Stdlib.Int64.t[@local_opt])
      -> unit
      = "%caml_bytes_set64"

    module Local = struct
      external get_int64_ne : Bytes.t -> int -> Stdlib.Int64.t = "%caml_bytes_get64"
    end
  end

  include Make_get (Bytes)
  include Make_set (Bytes)

  module Unsafe = struct
    include Make_get (Bytes0Unsafe)
    include Make_set (Bytes0Unsafe)
  end
end

module String0 = struct
  include String

  external get_uint8 : String.t -> int -> int = "%string_safe_get"
  external get_uint16_ne : String.t -> int -> int = "%caml_string_get16"
  external get_int32_ne : String.t -> int -> Stdlib.Int32.t = "%caml_string_get32"
  external get_int64_ne : String.t -> int -> Stdlib.Int64.t = "%caml_string_get64"

  module Local = struct
    external get_int64_ne : String.t -> int -> Stdlib.Int64.t = "%caml_string_get64"
  end
end

module String0Unsafe = struct
  type t = String.t

  external get_uint8 : String.t -> int -> int = "%string_unsafe_get"
  external get_uint16_ne : String.t -> int -> int = "%caml_string_get16u"
  external get_int32_ne : String.t -> int -> Stdlib.Int32.t = "%caml_string_get32u"
  external get_int64_ne : String.t -> int -> Stdlib.Int64.t = "%caml_string_get64u"

  module Local = struct
    external get_int64_ne : String.t -> int -> Stdlib.Int64.t = "%caml_string_get64u"
  end
end

module String = struct
  include Make_get (String0)

  module Unsafe = struct
    include Make_get (String0Unsafe)
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
