let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"expect_test_helpers_core_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "expect_test_helpers_core_intf.ml.before-ppx"
;;

open! Core

module Allocation_limit = struct
  type t =
    | Major_words of int
    | Minor_words of int
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | Major_words arg0__001_ ->
         let res0__002_ = sexp_of_int arg0__001_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Major_words"; res0__002_ ]
       | Minor_words arg0__003_ ->
         let res0__004_ = sexp_of_int arg0__003_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Minor_words"; res0__004_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type With_comparable = sig
  type t [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type key := t

  include Comparator.S with type t := t

  module Set : sig
    type t = (key, comparator_witness) Set.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Map : sig
    type 'a t = (key, 'a, comparator_witness) Map.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Comparable_satisfies_with_comparable (M : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t
  end) : With_comparable =
  M

module type With_hashable = sig
  type t [@@deriving compare, hash, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type key := t

  module Hash_set : sig
    type t = key Hash_set.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module Table : sig
    type 'a t = (key, 'a) Hashtbl.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end

module Hashable_satisfies_with_hashable (M : sig
    type t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Hashable.S with type t := t
  end) : With_hashable =
  M

module type With_containers = sig
  type t

  include With_comparable with type t := t
  include With_hashable with type t := t
end

module type Expect_test_helpers_core = sig
  [@@@ocaml.text
    " Helpers for producing output inside [let%expect_test]. Designed for code using\n\
    \      [Core]. See also [Expect_test_helpers_base] and [Expect_test_helpers_async]. "]

  include module type of struct
    include Expect_test_helpers_base
  end

  module type With_containers = With_containers
  module type With_comparable = With_comparable
  module type With_hashable = With_hashable

  [@@@ocaml.text " {3 Serialization tests} "]

  val print_and_check_stable_type
    :  ?cr:(CR.t[@ocaml.doc " default is [CR] "])
    -> ?hide_positions:
         (bool[@ocaml.doc " default is [false] when [cr=CR], [true] otherwise "])
    -> ?max_binable_length:(int[@ocaml.doc " default is [Int.max_value] "])
    -> Source_code_position.t
    -> (module Stable_without_comparator with type t = 'a)
    -> 'a list
    -> unit
  [@@ocaml.doc
    " [print_and_check_stable_type] prints the bin-io digest for the given type, and the\n\
    \      bin-io and sexp serializations of the given values.  Prints an error message \
     for any\n\
    \      serializations that fail to round-trip, and for any bin-io serializations that\n\
    \      exceed [max_binable_length]. "]

  val print_and_check_stable_int63able_type
    :  ?cr:(CR.t[@ocaml.doc " default is [CR] "])
    -> ?hide_positions:
         (bool[@ocaml.doc " default is [false] when [cr=CR], [true] otherwise "])
    -> ?max_binable_length:(int[@ocaml.doc " default is [Int.max_value] "])
    -> Source_code_position.t
    -> (module Stable_int63able with type t = 'a)
    -> 'a list
    -> unit
  [@@ocaml.doc
    " [print_and_check_stable_int63able_type] works like [print_and_check_stable_type],\n\
    \      and includes [Int63.t] serializations. "]

  val print_and_check_container_sexps
    :  ?cr:(CR.t[@ocaml.doc " default is [CR] "])
    -> ?hide_positions:
         (bool[@ocaml.doc " default is [false] when [cr=CR], [true] otherwise "])
    -> Source_code_position.t
    -> (module With_containers with type t = 'a)
    -> 'a list
    -> unit
  [@@ocaml.doc
    " [print_and_check_container_sexps] prints the sexp representation of maps, sets, hash\n\
    \      tables, and hash sets based on the given values.  For sets and hash sets, \
     prints a\n\
    \      CR if the sexp does not correspond to a list of elements.  For maps and hash \
     tables,\n\
    \      prints a CR if the sexp does not correspond to an association list keyed on\n\
    \      elements. "]

  val print_and_check_comparable_sexps
    :  ?cr:(CR.t[@ocaml.doc " default is [CR] "])
    -> ?hide_positions:
         (bool[@ocaml.doc " default is [false] when [cr=CR], [true] otherwise "])
    -> Source_code_position.t
    -> (module With_comparable with type t = 'a)
    -> 'a list
    -> unit
  [@@ocaml.doc
    " [print_and_check_comparable_sexps] is like [print_and_check_container_sexps] for\n\
    \      maps and sets only. "]

  val print_and_check_hashable_sexps
    :  ?cr:(CR.t[@ocaml.doc " default is [CR] "])
    -> ?hide_positions:
         (bool[@ocaml.doc " default is [false] when [cr=CR], [true] otherwise "])
    -> Source_code_position.t
    -> (module With_hashable with type t = 'a)
    -> 'a list
    -> unit
  [@@ocaml.doc
    " [print_and_check_hashable_sexps] is like [print_and_check_container_sexps] for hash\n\
    \      tables and hash sets only. "]

  val remove_time_spans : string -> string
  [@@ocaml.doc " Removes strings that look like time spans; see [Time.Span]. "]

  [@@@ocaml.text " {3 Allocation tests} "]

  module Allocation_limit : module type of struct
    include Allocation_limit
  end

  val require_allocation_does_not_exceed
    :  ?print_limit:(int[@ocaml.doc " default is [1_000] "])
    -> ?hide_positions:(bool[@ocaml.doc " default is [false] "])
    -> Allocation_limit.t
    -> Source_code_position.t
    -> (unit -> 'a)
    -> 'a
  [@@ocaml.doc
    " [require_allocation_does_not_exceed] is a specialized form of [require] that only\n\
    \      produces output when [f ()] allocates more than the given limits.  The output \
     will\n\
    \      include the actual number of major and minor words allocated.  We do NOT \
     include\n\
    \      these numbers in the successful case because those numbers are not stable with\n\
    \      respect to compiler versions and build flags.\n\n\
    \      If [f] returns a value that should be ignored, use this idiom:\n\n\
    \      {[\n\
    \        ignore (require_allocation_does_not_exceed ... f : t)\n\
    \      ]}\n\n\
    \      rather than this idiom:\n\n\
    \      {[\n\
    \        require_allocation_does_not_exceed ... (fun () -> ignore (f () : t))\n\
    \      ]}\n\n\
    \      With the latter idiom, the compiler may optimize the computation of [f ()] \
     taking\n\
    \      advantage of the fact that the result is ignored, and eliminate allocation \
     that is\n\
    \      intended to be measured.  With the former idiom, the compiler cannot do such\n\
    \      optimization and must compute the result of [f ()].\n\n\
    \      Also prints up to [print_limit] allocation locations.\n\n\
    \      See documentation above about CRs and workflows for failing allocation tests. "]

  val require_no_allocation
    :  ?print_limit:int
    -> ?hide_positions:(bool[@ocaml.doc " default is [false] "])
    -> Source_code_position.t
    -> (unit -> 'a)
    -> 'a
  [@@ocaml.doc
    " [require_no_allocation here f] is equivalent to [require_allocation_does_not_exceed\n\
    \      (Minor_words 0) here f].\n\n\
    \      See documentation above about CRs and workflows for failing allocation tests. "]

  [@@@ocaml.text "/*"]

  module Expect_test_helpers_core_private : sig
    val require_allocation_does_not_exceed
      :  ?cr:CR.t
      -> ?hide_positions:bool
      -> ?print_limit:int
      -> Allocation_limit.t
      -> Source_code_position.t
      -> (unit -> 'a)
      -> 'a
  end
  [@@ocaml.doc
    " This module is called [Expect_test_helpers_core_private] rather than [Private]\n\
    \      because [include Expect_test_helpers_core] is a common idiom, and we don't \
     want to\n\
    \      interfere with other [Private] modules or create problems due to multiple\n\
    \      definitions of [Private]. "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
