let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"md5.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "md5.ml.before-ppx"
;;

module T = struct
  include Bin_prot.Md5

  let equal (_x__001_ : t) _x__002_ =
    (match
       (fun (a__003_ : t) ((b__004_ : t) [@merlin.hide]) ->
          (compare a__003_ b__004_ [@merlin.hide]))
         _x__001_
         _x__002_
     with
     | 0 -> true
     | _ -> false)
    [@merlin.hide]
  ;;

  let sexp_of_t t = String.sexp_of_t (to_hex t)
  let t_of_sexp s = of_hex_exn (String.t_of_sexp s)
  let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar
end

let hash_fold_t accum t = String.hash_fold_t accum (T.to_binary t)
let hash t = String.hash (T.to_binary t)

module As_binary_string = struct
  module Stable = struct
    module V1 = struct
      type t = T.t [@@deriving compare, equal]

      include struct
        let _ = fun (_ : t) -> ()

        let compare =
          (fun a__005_ b__006_ -> T.compare a__005_ b__006_
           : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__007_ b__008_ -> T.equal a__007_ b__008_
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let hash_fold_t = hash_fold_t
      let hash = hash
      let sexp_of_t x = String.sexp_of_t (T.to_binary x)
      let t_of_sexp x = T.of_binary_exn (String.t_of_sexp x)
      let t_sexp_grammar = Sexplib.Sexp_grammar.coerce String.t_sexp_grammar
      let to_binable = T.to_binary
      let of_binable = T.of_binary_exn

      include Bin_prot.Utils.Make_binable_without_uuid [@alert "-legacy"] (struct
          module Binable = String.Stable.V1

          type t = Bin_prot.Md5.t

          let to_binable = to_binable
          let of_binable = of_binable
        end)

      let stable_witness : t Stable_witness.t =
        Stable_witness.of_serializable
          String.Stable.V1.stable_witness
          of_binable
          to_binable
      ;;
    end
  end

  include Stable.V1
  include Comparable.Make (Stable.V1)
  include Hashable.Make (Stable.V1)
end

module Stable = struct
  module V1 = struct
    type t = T.t [@@deriving compare, equal, sexp, sexp_grammar]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__009_ b__010_ -> T.compare a__009_ b__010_ : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__011_ b__012_ -> T.equal a__011_ b__012_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let t_of_sexp = (T.t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (T.sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
      let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = T.t_sexp_grammar
      let _ = t_sexp_grammar
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let hash_fold_t = hash_fold_t
    let hash = hash
    let to_binable = Fn.id
    let of_binable = Fn.id

    include Bin_prot.Utils.Make_binable_without_uuid [@alert "-legacy"] (struct
        module Binable = Bin_prot.Md5.Stable.V1

        type t = Bin_prot.Md5.t

        let to_binable = to_binable
        let of_binable = of_binable
      end)

    let stable_witness : t Stable_witness.t =
      Stable_witness.of_serializable
        Bin_prot.Md5.Stable.V1.stable_witness
        of_binable
        to_binable
    ;;
  end

  let digest_string s = Md5_lib.string s
end

include Stable.V1
include Comparable.Make (Stable.V1)
include Hashable.Make (Stable.V1)

let digest_num_bytes = 16
let to_hex = T.to_hex
let from_hex = T.of_hex_exn
let of_hex_exn = T.of_hex_exn
let of_binary_exn = T.of_binary_exn
let to_binary = T.to_binary
let digest_string = Stable.digest_string
let digest_bytes = Md5_lib.bytes

external caml_sys_open
  :  string
  -> Stdlib.open_flag list
  -> perm:int
  -> int
  = "caml_sys_open"

external caml_sys_close : int -> unit = "caml_sys_close"
external digest_fd_blocking : int -> string = "core_md5_fd"

let digest_file_blocking path =
  of_binary_exn
    (Base.Exn.protectx
       (caml_sys_open path [ Open_rdonly; Open_binary ] ~perm:0o000)
       ~f:digest_fd_blocking
       ~finally:caml_sys_close)
;;

let file = digest_file_blocking

let digest_channel_blocking_without_releasing_runtime_lock channel ~len =
  of_binary_exn (Stdlib.Digest.channel channel len)
;;

let channel channel len =
  digest_channel_blocking_without_releasing_runtime_lock channel ~len
;;

let output_blocking t oc = Stdlib.Digest.output oc (to_binary t)
let output oc t = output_blocking t oc
let input_blocking ic = of_binary_exn (Stdlib.Digest.input ic)
let input = input_blocking
let digest_subbytes = Md5_lib.subbytes
let string = digest_string
let bytes = digest_bytes
let subbytes s pos len = digest_subbytes s ~pos ~len

let digest_bin_prot writer value =
  digest_string (Core_bin_prot.Writer.to_string writer value)
;;

external c_digest_subbigstring
  :  Bigstring.t
  -> pos:int
  -> len:int
  -> res:Bytes.t
  -> unit
  = "core_md5_digest_subbigstring"

let unsafe_digest_subbigstring buf ~pos ~len =
  let res = Bytes.create 16 in
  c_digest_subbigstring buf ~pos ~len ~res;
  Md5_lib.unsafe_of_binary
    (Bytes.unsafe_to_string ~no_mutation_while_string_reachable:res)
;;

let digest_subbigstring buf ~pos ~len =
  Ordered_collection_common.check_pos_len_exn
    ~pos
    ~len
    ~total_length:(Bigstring.length buf);
  unsafe_digest_subbigstring buf ~pos ~len
;;

let digest_bigstring buf =
  unsafe_digest_subbigstring buf ~pos:0 ~len:(Bigstring.length buf)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
