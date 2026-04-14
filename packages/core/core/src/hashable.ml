[@@@ocaml.text " Functors and interfaces used to make modules hashable. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"hashable.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "hashable.ml.before-ppx"
;;

open! Import
include Hashable_intf

module Make_plain (T : sig
    type t [@@deriving hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Hashtbl.Key_plain with type t := t
  end) : S_plain with type t := T.t = struct
  include T
  module Table = Hashtbl.Make_plain (T)
  module Hash_set = Hash_set.Make_plain (T)
  module Hash_queue = Hash_queue.Make (T)

  let hashable = Table.hashable
end

module Make_plain_and_derive_hash_fold_t (T : Hashtbl.Key_plain) :
  S_plain with type t := T.t = Make_plain (struct
    include T

    let hash_fold_t state t = hash_fold_int state (hash t)
  end)

module Make (T : sig
    type t [@@deriving hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Hashtbl.Key with type t := t
  end) : S with type t := T.t = struct
  include T
  module Table = Hashtbl.Make (T)
  module Hash_set = Hash_set.Make (T)
  module Hash_queue = Hash_queue.Make (T)

  let hashable = Table.hashable
end

module Make_and_derive_hash_fold_t (T : Hashtbl.Key) : S with type t := T.t = Make (struct
    include T

    let hash_fold_t state t = hash_fold_int state (hash t)
  end)

module Make_binable (T : sig
    type t [@@deriving hash]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Hashtbl.Key_binable with type t := t
  end) : S_binable with type t := T.t = struct
  module Table = Hashtbl.Make_binable (T)
  module Hash_set = Hash_set.Make_binable (T)
  module Hash_queue = Hash_queue.Make (T)
  include T

  let hashable = Table.hashable
end

module Make_plain_with_hashable (T : sig
    module Key : sig
      type t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Hashtbl.Key_plain with type t := t
    end

    val hashable : Key.t Hashtbl_intf.Hashable.t
  end) : S_plain with type t := T.Key.t = struct
  include T.Key
  module Table = Hashtbl.Make_plain_with_hashable (T)

  module Hash_set = Hash_set.Make_plain_with_hashable (struct
      module Elt = T.Key

      let hashable = T.hashable
    end)

  module Hash_queue = Hash_queue.Make_with_hashable (T)

  let hashable = T.hashable
end

module Make_with_hashable (T : sig
    module Key : sig
      type t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Hashtbl.Key with type t := t
    end

    val hashable : Key.t Hashtbl_intf.Hashable.t
  end) : S with type t := T.Key.t = struct
  include T.Key
  module Table = Hashtbl.Make_with_hashable (T)

  module Hash_set = Hash_set.Make_with_hashable (struct
      module Elt = T.Key

      let hashable = T.hashable
    end)

  module Hash_queue = Hash_queue.Make_with_hashable (T)

  let hashable = T.hashable
end

module Make_binable_with_hashable (T : sig
    module Key : sig
      type t [@@deriving hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Hashtbl.Key_binable with type t := t
    end

    val hashable : Key.t Hashtbl_intf.Hashable.t
  end) : S_binable with type t := T.Key.t = struct
  module Table = Hashtbl.Make_binable_with_hashable (T)

  module Hash_set = Hash_set.Make_binable_with_hashable (struct
      module Elt = T.Key

      let hashable = T.hashable
    end)

  module Hash_queue = Hash_queue.Make_with_hashable (T)
  include T.Key

  let hashable = T.hashable
end

module Make_binable_and_derive_hash_fold_t (T : Hashtbl.Key_binable) :
  S_binable with type t := T.t = Make_binable (struct
    include T

    let hash_fold_t state t = hash_fold_int state (hash t)
  end)

module Stable = struct
  module V1 = struct
    module type S = sig
      type key

      module Table : sig
        type 'a t = (key, 'a) Hashtbl.t [@@deriving sexp, bin_io]

        include sig
          [@@@ocaml.warning "-32"]

          include Sexplib0.Sexpable.S1 with type 'a t := 'a t
          include Bin_prot.Binable.S1 with type 'a t := 'a t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      module Hash_set : sig
        type t = key Hash_set.t [@@deriving sexp, bin_io]

        include sig
          [@@@ocaml.warning "-32"]

          include Sexplib0.Sexpable.S with type t := t
          include Bin_prot.Binable.S with type t := t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      val hashable : key Hashtbl.Hashable.t
    end

    module Make (Key : Hashtbl.Key_binable) : S with type key := Key.t = struct
      module Table = Hashtbl.Make_binable (Key)
      module Hash_set = Hash_set.Make_binable (Key)

      let hashable = Table.hashable
    end

    module Make_with_hashable (T : sig
        module Key : Hashtbl.Key_binable

        val hashable : Key.t Hashtbl_intf.Hashable.t
      end) : S with type key := T.Key.t = struct
      module Table = Hashtbl.Make_binable_with_hashable (T)

      module Hash_set = Hash_set.Make_binable_with_hashable (struct
          module Elt = T.Key

          let hashable = T.hashable
        end)

      let hashable = T.hashable
    end

    module With_stable_witness = struct
      module type S = sig
        type key

        module Table : sig
          type 'a t = (key, 'a) Hashtbl.t [@@deriving sexp, bin_io, stable_witness]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S1 with type 'a t := 'a t
            include Bin_prot.Binable.S1 with type 'a t := 'a t

            val stable_witness
              :  'a Ppx_stable_witness_runtime.Stable_witness.t
              -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        module Hash_set : sig
          type t = key Hash_set.t [@@deriving sexp, bin_io, stable_witness]

          include sig
            [@@@ocaml.warning "-32"]

            include Sexplib0.Sexpable.S with type t := t
            include Bin_prot.Binable.S with type t := t

            val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        val hashable : key Hashtbl.Hashable.t
      end

      module Make (Key : Hashtbl.Key_stable) : S with type key := Key.t = struct
        module Table = Hashtbl.Make_stable (Key)
        module Hash_set = Hash_set.Make_stable (Key)

        let hashable = Table.hashable
      end

      module Make_with_hashable (T : sig
          module Key : Hashtbl.Key_stable

          val hashable : Key.t Hashtbl_intf.Hashable.t
        end) : S with type key := T.Key.t = struct
        module Table = Hashtbl.Make_stable_with_hashable (T)

        module Hash_set = Hash_set.Make_stable_with_hashable (struct
            module Elt = T.Key

            let hashable = T.hashable
          end)

        let hashable = T.hashable
      end
    end
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
