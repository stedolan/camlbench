let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"byte_units0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "byte_units0.ml.before-ppx"
;;

open! Import
open Std_internal
module Repr = Int63

module T : sig
  type t [@@deriving compare, hash, sexp_of, typerep] [@@immediate64]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_string : t -> string
  val to_string_hum : t -> string
  val of_repr : Repr.t -> t
  val to_repr : t -> Repr.t
end = struct
  type t = Repr.t [@@deriving compare, hash, typerep]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__001_ b__002_ -> Repr.compare a__001_ b__002_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Repr.hash_fold_t hsv arg

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
      let func = Repr.hash in
      fun x -> func x
    ;;

    let _ = hash_fold_t
    and _ = hash

    module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
        type nonrec t = t

        let name = "byte_units0.ml.before-ppx.T.t"
        let _ = name
      end)

    let typename_of_t = Typename_of_t.typename_of_t
    let _ = typename_of_t

    let typerep_of_t =
      let name_of_t = Typename_of_t.named in
      Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Repr.typerep_of_t))
    ;;

    let _ = typerep_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let of_repr = Fn.id
  let to_repr = Fn.id

  let to_string n =
    let open Repr in
    let kib = of_int 1024 in
    let mib = kib * kib in
    let gib = kib * mib in
    let n_abs = abs n in
    if n_abs < kib
    then sprintf "%dB" (to_int_exn n)
    else if n_abs < mib
    then sprintf "%.7gK" (to_float n /. to_float kib)
    else if n_abs < gib
    then sprintf "%.10gM" (to_float n /. to_float mib)
    else sprintf "%.13gG" (to_float n /. to_float gib)
  ;;

  let to_string_hum n =
    let open Repr in
    let kib = of_int 1024 in
    let mib = kib * kib in
    let gib = kib * mib in
    let tib = kib * gib in
    let pib = kib * tib in
    let n_abs = abs n in
    let f ~suffix ~size n =
      let f = to_float n /. to_float size in
      if Float.( >= ) f 999.5
      then sprintf "%.0f%s" f suffix
      else sprintf "%.3g%s" f suffix
    in
    if n_abs < kib
    then sprintf "%dB" (to_int_exn n)
    else if n_abs < mib
    then f ~suffix:"K" ~size:kib n
    else if n_abs < gib
    then f ~suffix:"M" ~size:mib n
    else if n_abs < tib
    then f ~suffix:"G" ~size:gib n
    else if n_abs < pib
    then f ~suffix:"T" ~size:tib n
    else f ~suffix:"P" ~size:pib n
  ;;

  let sexp_of_t n = Sexp.Atom (to_string n)
end

include T

let bytes_int_exn t = Repr.to_int_exn (to_repr t)
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
