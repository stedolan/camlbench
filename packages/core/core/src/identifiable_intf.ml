[@@@ocaml.text " Signatures and functors for making types that are used as identifiers. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"identifiable_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "identifiable_intf.ml.before-ppx"
;;

open! Import

module type S_common = sig
  type t [@@deriving compare, hash, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Stringable.S with type t := t
  include Pretty_printer.S with type t := t
end

module type S_plain = sig
  include S_common
  include Comparable.S_plain with type t := t
  include Hashable.S_plain with type t := t
end

module type S_not_binable = sig
  type t [@@deriving hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S_common with type t := t
  include Comparable.S with type t := t
  include Hashable.S with type t := t
end

module type S = sig
  type t [@@deriving bin_io, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S_common with type t := t
  include Comparable.S_binable with type t := t
  include Hashable.S_binable with type t := t
end

module type S_sexp_grammar = sig
  type t [@@deriving sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include S with type t := t
end

module type Identifiable = sig
  module type S_common = S_common
  module type S_plain = S_plain
  module type S_not_binable = S_not_binable
  module type S = S
  module type S_sexp_grammar = S_sexp_grammar

  module Make_plain : functor
      (M : sig
         type t [@@deriving compare, hash, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Stringable.S with type t := t

         val module_name : string [@@ocaml.doc " for registering the pretty printer "]
       end)
      -> S_plain with type t := M.t

  module Make : functor
      (M : sig
         type t [@@deriving bin_io, compare, hash, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Stringable.S with type t := t

         val module_name : string [@@ocaml.doc " for registering the pretty printer "]
       end)
      -> S with type t := M.t
  [@@ocaml.doc
    " Used for making an Identifiable module. Here's an example:\n\n\
    \      {[\n\
    \        module Id = struct\n\
    \          module T = struct\n\
    \            type t = A | B [@@deriving bin_io, compare, hash, sexp]\n\
    \            include Sexpable.To_stringable (struct type nonrec t = t [@@deriving \
     sexp] end)\n\
    \            let module_name = \"My_library.Id\"\n\
    \          end\n\
    \          include T\n\
    \          include Identifiable.Make (T)\n\
    \        end\n\
    \      ]}\n\
    \  "]

  module Make_with_sexp_grammar : functor
      (M : sig
         type t [@@deriving bin_io, compare, hash, sexp, sexp_grammar]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t

           val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Stringable.S with type t := t

         val module_name : string [@@ocaml.doc " for registering the pretty printer "]
       end)
      -> S_sexp_grammar with type t := M.t

  module Make_and_derive_hash_fold_t : functor
      (M : sig
         type t [@@deriving bin_io, compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Stringable.S with type t := t

         val hash : t -> int

         val module_name : string [@@ocaml.doc " for registering the pretty printer "]
       end)
      -> S with type t := M.t

  module Make_using_comparator : functor
      (M : sig
         type t [@@deriving bin_io, compare, hash, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
         include Stringable.S with type t := t

         val module_name : string
       end)
      -> S with type t := M.t with type comparator_witness := M.comparator_witness

  module Make_plain_using_comparator : functor
      (M : sig
         type t [@@deriving compare, hash, sexp_of]

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
           include Ppx_hash_lib.Hashable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
         include Stringable.S with type t := t

         val module_name : string [@@ocaml.doc " for registering the pretty printer "]
       end)
      -> S_plain with type t := M.t with type comparator_witness := M.comparator_witness

  module Make_using_comparator_and_derive_hash_fold_t : functor
      (M : sig
         type t [@@deriving bin_io, compare, sexp]

         include sig
           [@@@ocaml.warning "-32"]

           include Bin_prot.Binable.S with type t := t
           include Ppx_compare_lib.Comparable.S with type t := t
           include Sexplib0.Sexpable.S with type t := t
         end
         [@@ocaml.doc "@inline"] [@@merlin.hide]

         include Comparator.S with type t := t
         include Stringable.S with type t := t

         val hash : t -> int
         val module_name : string
       end)
      -> S with type t := M.t with type comparator_witness := M.comparator_witness

  module Extend : functor
      (M : Base.Identifiable.S)
      -> functor
      (B : Binable0.S with type t = M.t)
      -> S with type t := M.t with type comparator_witness := M.comparator_witness
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
