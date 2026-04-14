let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"binable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "binable_intf.ml.before-ppx"
;;

open! Import
open Bin_prot.Binable
open Bigarray

module type Conv_without_uuid = sig
  type binable
  type t

  val to_binable : t -> binable
  val of_binable : binable -> t
end

module type Conv1_without_uuid = sig
  type 'a binable
  type 'a t

  val to_binable : 'a t -> 'a binable
  val of_binable : 'a binable -> 'a t
end

module type Conv2_without_uuid = sig
  type ('a, 'b) binable
  type ('a, 'b) t

  val to_binable : ('a, 'b) t -> ('a, 'b) binable
  val of_binable : ('a, 'b) binable -> ('a, 'b) t
end

module type Conv3_without_uuid = sig
  type ('a, 'b, 'c) binable
  type ('a, 'b, 'c) t

  val to_binable : ('a, 'b, 'c) t -> ('a, 'b, 'c) binable
  val of_binable : ('a, 'b, 'c) binable -> ('a, 'b, 'c) t
end

module type Conv = sig
  include Conv_without_uuid

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Conv1 = sig
  include Conv1_without_uuid

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Conv2 = sig
  include Conv2_without_uuid

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Conv3 = sig
  include Conv3_without_uuid

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Conv_sexpable = sig
  include Sexpable.S

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Conv_stringable = sig
  include Stringable.S

  val caller_identity : Bin_prot.Shape.Uuid.t
end

module type Binable0 = sig
  type bigstring = (char, int8_unsigned_elt, c_layout) Array1.t
  [@@ocaml.doc
    " We copy the definition of the bigstring type here, because we cannot depend on\n\
    \      bigstring.ml "]

  module type S = S
  [@@ocaml.doc
    " New code should use [@@deriving bin_io]. These module types ([S], [S1], and [S2])\n\
    \      are exported only for backwards compatibility. "]

  module type S_local = S_local
  module type S_only_functions = S_only_functions
  module type S1 = S1
  module type S2 = S2
  module type S3 = S3

  module Minimal : sig
    module type S = Minimal.S
    module type S1 = Minimal.S1
    module type S2 = Minimal.S2
    module type S3 = Minimal.S3
  end

  module type Conv = Conv
  module type Conv1 = Conv1
  module type Conv2 = Conv2
  module type Conv3 = Conv3
  module type Conv_sexpable = Conv_sexpable
  module type Conv_stringable = Conv_stringable
  module type Conv_without_uuid = Conv_without_uuid
  module type Conv1_without_uuid = Conv1_without_uuid
  module type Conv2_without_uuid = Conv2_without_uuid
  module type Conv3_without_uuid = Conv3_without_uuid

  [@@@ocaml.text
    " [Of_binable*] functors are for when you want the binary representation of one type\n\
    \      to be the same as that for some other isomorphic type. "]

  module Of_binable_with_uuid : functor
      (Binable : Minimal.S)
      -> functor
      (M : Conv with type binable := Binable.t)
      -> S with type t := M.t

  module Of_binable1_with_uuid : functor
      (Binable : Minimal.S1)
      -> functor
      (M : Conv1 with type 'a binable := 'a Binable.t)
      -> S1 with type 'a t := 'a M.t

  module Of_binable2_with_uuid : functor
      (Binable : Minimal.S2)
      -> functor
      (M : Conv2 with type ('a, 'b) binable := ('a, 'b) Binable.t)
      -> S2 with type ('a, 'b) t := ('a, 'b) M.t

  module Of_binable3_with_uuid : functor
      (Binable : Minimal.S3)
      -> functor
      (M : Conv3 with type ('a, 'b, 'c) binable := ('a, 'b, 'c) Binable.t)
      -> S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) M.t

  module Of_binable_without_uuid : functor
      (Binable : Minimal.S)
      -> functor
      (M : Conv_without_uuid with type binable := Binable.t)
      -> S with type t := M.t
  [@@alert legacy "Use [Of_binable_with_uuid] if possible."]

  module Of_binable1_without_uuid : functor
      (Binable : Minimal.S1)
      -> functor
      (M : Conv1_without_uuid with type 'a binable := 'a Binable.t)
      -> S1 with type 'a t := 'a M.t
  [@@alert legacy "Use [Of_binable1_with_uuid] if possible."]

  module Of_binable2_without_uuid : functor
      (Binable : Minimal.S2)
      -> functor
      (M : Conv2_without_uuid with type ('a, 'b) binable := ('a, 'b) Binable.t)
      -> S2 with type ('a, 'b) t := ('a, 'b) M.t
  [@@alert legacy "Use [Of_binable2_with_uuid] if possible."]

  module Of_binable3_without_uuid : functor
      (Binable : Minimal.S3)
      -> functor
      (M : Conv3_without_uuid with type ('a, 'b, 'c) binable := ('a, 'b, 'c) Binable.t)
      -> S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) M.t
  [@@alert legacy "Use [Of_binable3_with_uuid] if possible."]

  [@@@ocaml.text
    " [Of_sexpable_with_uuid] serializes a value using the bin-io of the sexp\n\
    \      serialization of the value. This is not as efficient as using [@@deriving \
     bin_io].\n\
    \      However, it is useful when performance isn't important and there are \
     obstacles to\n\
    \      using [@@deriving bin_io], e.g., some type missing [@@deriving bin_io].\n\
    \      [Of_sexpable_with_uuid] is also useful when one wants to be forgiving about \
     format\n\
    \      changes, due to the sexp serialization being more robust to changes like \
     adding or\n\
    \      removing a constructor. "]

  module Of_sexpable_with_uuid : functor (M : Conv_sexpable) -> S with type t := M.t
  module Of_stringable_with_uuid : functor (M : Conv_stringable) -> S with type t := M.t

  module Of_sexpable_without_uuid : functor (M : Sexpable.S) -> S with type t := M.t
  [@@alert legacy "Use [Of_sexpable_with_uuid] if possible."]

  module Of_stringable_without_uuid : functor (M : Stringable.S) -> S with type t := M.t
  [@@alert legacy "Use [Of_stringable_with_uuid] if possible."]

  type 'a m = (module S with type t = 'a)

  val of_bigstring : 'a m -> bigstring -> 'a

  val to_bigstring
    :  ?prefix_with_length:(bool[@ocaml.doc " defaults to false "])
    -> 'a m
    -> 'a
    -> bigstring

  [@@@ocaml.text
    " The following functors preserve stability: if applied to stable types with stable\n\
    \      (de)serializations, they will produce stable types with stable \
     (de)serializations.\n\n\
    \      Note: In all cases, stability of the input (and therefore the output) depends \
     on the\n\
    \      semantics of all conversion functions (e.g. [to_string], [to_sexpable]) not \
     changing\n\
    \      in the future.\n\
    \  "]

  module Stable : sig
    module Of_binable : sig
      module V1 : (module type of Of_binable_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_binable_with_uuid
    end

    module Of_binable1 : sig
      module V1 : (module type of Of_binable1_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_binable1_with_uuid
    end

    module Of_binable2 : sig
      module V1 : (module type of Of_binable2_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_binable2_with_uuid
    end

    module Of_binable3 : sig
      module V1 : (module type of Of_binable3_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_binable3_with_uuid
    end

    module Of_sexpable : sig
      module V1 : (module type of Of_sexpable_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_sexpable_with_uuid
    end

    module Of_stringable : sig
      module V1 : (module type of Of_stringable_without_uuid) [@alert "-legacy"]
      [@@alert legacy "Use [V2] instead."]

      module V2 : module type of Of_stringable_with_uuid
    end
  end
end
[@@ocaml.doc
  " Module types and utilities for dealing with types that support the bin-io binary\n\
  \    encoding. "]

module type Binable = sig
  include Binable0

  val of_string : 'a m -> string -> 'a
  val to_string : 'a m -> 'a -> string
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
