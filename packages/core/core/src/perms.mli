[@@@ocaml.text
  " These types are intended to be used as phantom types encoding the permissions on a\n\
  \    given type.\n\n\
  \    {2 Basic Usage}\n\n\
  \    Here's a hypothetical interface to an on-off switch which uses them:\n\n\
  \    {[\n\
  \      open Perms.Export\n\n\
  \      module Switch : sig\n\
  \        type -'permissions t\n\n\
  \        val create : unit -> [< _ perms] t\n\
  \        val read  : [> read] t  -> [`On | `Off]\n\
  \        val write : [> write] t -> [`On | `Off] -> unit\n\
  \      end\n\
  \    ]}\n\n\
  \    Note that the permissions parameter must be contravariant -- you are allowed to \
   forget\n\
  \    that you have any particular permissions, but not give yourself new permissions.\n\n\
  \    You can now create different \"views\" of a switch. For example, in:\n\n\
  \    {[\n\
  \      let read_write_s1 : read_write Switch.t = Switch.create ()\n\
  \      let read_only_s1 = (read_write_s1 :> read t)\n\
  \    ]}\n\n\
  \    [read_write_s1] and [read_only_s1] are physically equal, but calling\n\
  \    [Switch.write read_only_s1] is a type error, while [Switch.write read_write_s1] is\n\
  \    allowed.\n\n\
  \    Also note that this is a type error:\n\n\
  \    {[\n\
  \      let s1 = Switch.create ()\n\
  \      let read_write_s1 = (s1 :> read_write t)\n\
  \      let immutable_s1  = (s1 :> immutable  t)\n\
  \    ]}\n\n\
  \    which is good, since it would be incorrect if it were allowed.  This is enforced \
   by:\n\n\
  \    1. Having the permissions parameter be contravariant and the only way to create a \
   [t]\n\
  \    be a function call.  This causes the compiler to require that created [t]s have a\n\
  \    concrete type (due to the value restriction).\n\n\
  \    2. Ensuring that there is no type that has both [read_write] and [immutable] as\n\
  \    subtypes.  This is why the variants are [`Who_can_write of Me.t] and \
   [`Who_can_write\n\
  \    of Nobody.t] rather than [`I_can_write] and [`Nobody_can_write].\n\n\
  \    Note that, as a consequence of 1, exposing a global switch as in:\n\n\
  \    {[\n\
  \      module Switch : sig\n\
  \        ...\n\
  \        val global : [< _ perms] t\n\
  \      end\n\
  \    ]}\n\n\
  \    would be a mistake, since one library could annotate [Switch.global] as an\n\
  \    [immutable Switch.t], while another library writes to it.\n\n\
  \    {2 More Usage Patterns}\n\n\
  \    The standard usage pattern is as above:\n\n\
  \    {ul\n\
  \    {- The permissions type parameter is contravariant with no constraints.}\n\
  \    {- The result of creation functions is a [t] with [[< _ perms]] permissions.}\n\
  \    {- Functions which take a [t] and access it in some way represent that access in \
   the\n\
  \    type. }\n\
  \    }\n\n\
  \    The reason for having creation functions return a [t] with [[< _ perms]] \
   permissions\n\
  \    is to help give early warning if you create a [t] with a nonsensical permission \
   type\n\
  \    that you wouldn't be able to use with the other functions in the module.\n\n\
  \    Ideally, this would be done with a constraint on the type in a usage pattern like\n\
  \    this:\n\n\
  \    {ul\n\
  \    {- The permissions type parameter is contravariant with constraint [[< _ perms]].}\n\
  \    {- The result of creation functions is a [t] with no constraint on the \
   permissions.}\n\
  \    {- Functions which take a [t] and access it in some way represent that access in \
   the\n\
  \    type. }\n\
  \    }\n\n\
  \    Unfortunately, that doesn't work for us due to some quirks in the way constraints \
   of\n\
  \    this form are handled:  In particular, they don't work well with [[@@deriving \
   sexp]]\n\
  \    and they don't work well with included signatures.  But you could try this usage\n\
  \    pattern if you don't do either of those things.\n\n\
  \    For some types you may expect to always have read permissions, and it may \
   therefore by\n\
  \    annoying to keep rewriting [[> read]].  In that case you may want to try this usage\n\
  \    pattern:\n\n\
  \    {ul\n\
  \    {- The permissions type parameter is contravariant with constraint [[> read]].}\n\
  \    {- The result of creation functions is a [t] with [[< _ perms]] permissions.}\n\
  \    {- Functions which take a [t] and access it in some way represent that access in \
   the\n\
  \    type, except that you don't have to specify read permissions. }\n\
  \    }\n\n\
  \    However, the standard usage pattern is again preferred to this one: [constraint] \
   has\n\
  \    lots of sharp edges, and putting [[> read]] instead of [_] in the types provides\n\
  \    explicitness.\n"]

open! Import

type nobody
[@@ocaml.doc
  " Every type in this module besides the following two represent permission sets; these\n\
  \    two represent who is allowed to write in the [Write.t] and [Immutable.t] types. "]
[@@deriving bin_io, compare, equal, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val bin_shape_nobody : Bin_prot.Shape.t
  val bin_size_nobody : nobody Bin_prot.Size.sizer
  val bin_write_nobody : nobody Bin_prot.Write.writer
  val bin_writer_nobody : nobody Bin_prot.Type_class.writer
  val bin_read_nobody : nobody Bin_prot.Read.reader
  val __bin_read_nobody__ : (int -> nobody) Bin_prot.Read.reader
  val bin_reader_nobody : nobody Bin_prot.Type_class.reader
  val bin_nobody : nobody Bin_prot.Type_class.t
  val compare_nobody : nobody -> (nobody[@merlin.hide]) -> int
  val equal_nobody : nobody -> (nobody[@merlin.hide]) -> bool

  val hash_fold_nobody
    :  Ppx_hash_lib.Std.Hash.state
    -> nobody
    -> Ppx_hash_lib.Std.Hash.state

  val hash_nobody : nobody -> Ppx_hash_lib.Std.Hash.hash_value
  val sexp_of_nobody : nobody -> Sexplib0.Sexp.t
  val nobody_of_sexp : Sexplib0.Sexp.t -> nobody
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type me [@@deriving bin_io, compare, equal, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val bin_shape_me : Bin_prot.Shape.t
  val bin_size_me : me Bin_prot.Size.sizer
  val bin_write_me : me Bin_prot.Write.writer
  val bin_writer_me : me Bin_prot.Type_class.writer
  val bin_read_me : me Bin_prot.Read.reader
  val __bin_read_me__ : (int -> me) Bin_prot.Read.reader
  val bin_reader_me : me Bin_prot.Type_class.reader
  val bin_me : me Bin_prot.Type_class.t
  val compare_me : me -> (me[@merlin.hide]) -> int
  val equal_me : me -> (me[@merlin.hide]) -> bool
  val hash_fold_me : Ppx_hash_lib.Std.Hash.state -> me -> Ppx_hash_lib.Std.Hash.state
  val hash_me : me -> Ppx_hash_lib.Std.Hash.hash_value
  val sexp_of_me : me -> Sexplib0.Sexp.t
  val me_of_sexp : Sexplib0.Sexp.t -> me
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Read : sig
  type t = [ `Read ] [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val compare : t -> (t[@merlin.hide]) -> int
    val equal : t -> (t[@merlin.hide]) -> bool

    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Write : sig
  type t = [ `Who_can_write of me ] [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val compare : t -> (t[@merlin.hide]) -> int
    val equal : t -> (t[@merlin.hide]) -> bool

    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Immutable : sig
  type t =
    [ Read.t
    | `Who_can_write of nobody
    ]
  [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val compare : t -> (t[@merlin.hide]) -> int
    val equal : t -> (t[@merlin.hide]) -> bool

    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Read_write : sig
  type t =
    [ Read.t
    | Write.t
    ]
  [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t

    val compare : t -> (t[@merlin.hide]) -> int
    val equal : t -> (t[@merlin.hide]) -> bool

    include Ppx_hash_lib.Hashable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
    val t_of_sexp : Sexplib0.Sexp.t -> t
    val __t_of_sexp__ : Sexplib0.Sexp.t -> t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Upper_bound : sig
  type 'a t =
    [ Read.t
    | `Who_can_write of 'a
    ]
  [@@deriving bin_io, compare, equal, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S1 with type 'a t := 'a t

    val compare : ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
    val equal : ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

    include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    val t_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
    val __t_of_sexp__ : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Export : sig
  type read = Read.t
  [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness, equal]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_read : Bin_prot.Shape.t
    val bin_size_read : read Bin_prot.Size.sizer
    val bin_write_read : read Bin_prot.Write.writer
    val bin_writer_read : read Bin_prot.Type_class.writer
    val bin_read_read : read Bin_prot.Read.reader
    val __bin_read_read__ : (int -> read) Bin_prot.Read.reader
    val bin_reader_read : read Bin_prot.Type_class.reader
    val bin_read : read Bin_prot.Type_class.t
    val compare_read : read -> (read[@merlin.hide]) -> int
    val equal_read : read -> (read[@merlin.hide]) -> bool
    val globalize_read : read -> read

    val hash_fold_read
      :  Ppx_hash_lib.Std.Hash.state
      -> read
      -> Ppx_hash_lib.Std.Hash.state

    val hash_read : read -> Ppx_hash_lib.Std.Hash.hash_value
    val sexp_of_read : read -> Sexplib0.Sexp.t
    val read_of_sexp : Sexplib0.Sexp.t -> read
    val stable_witness_read : read Ppx_stable_witness_runtime.Stable_witness.t
    val equal_read : read -> (read[@merlin.hide]) -> bool
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type write = Write.t
  [@@ocaml.doc
    " We don't expose [bin_io] for [write] due to a naming conflict with the functions\n\
    \      exported by [bin_io] for [read_write].  If you want [bin_io] for [write], use\n\
    \      [Write.t]. "]
  [@@deriving compare, equal, hash, globalize, sexp, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    val compare_write : write -> (write[@merlin.hide]) -> int
    val equal_write : write -> (write[@merlin.hide]) -> bool

    val hash_fold_write
      :  Ppx_hash_lib.Std.Hash.state
      -> write
      -> Ppx_hash_lib.Std.Hash.state

    val hash_write : write -> Ppx_hash_lib.Std.Hash.hash_value
    val globalize_write : write -> write
    val sexp_of_write : write -> Sexplib0.Sexp.t
    val write_of_sexp : Sexplib0.Sexp.t -> write
    val stable_witness_write : write Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type immutable = Immutable.t
  [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_immutable : Bin_prot.Shape.t
    val bin_size_immutable : immutable Bin_prot.Size.sizer
    val bin_write_immutable : immutable Bin_prot.Write.writer
    val bin_writer_immutable : immutable Bin_prot.Type_class.writer
    val bin_read_immutable : immutable Bin_prot.Read.reader
    val __bin_read_immutable__ : (int -> immutable) Bin_prot.Read.reader
    val bin_reader_immutable : immutable Bin_prot.Type_class.reader
    val bin_immutable : immutable Bin_prot.Type_class.t
    val compare_immutable : immutable -> (immutable[@merlin.hide]) -> int
    val equal_immutable : immutable -> (immutable[@merlin.hide]) -> bool
    val globalize_immutable : immutable -> immutable

    val hash_fold_immutable
      :  Ppx_hash_lib.Std.Hash.state
      -> immutable
      -> Ppx_hash_lib.Std.Hash.state

    val hash_immutable : immutable -> Ppx_hash_lib.Std.Hash.hash_value
    val sexp_of_immutable : immutable -> Sexplib0.Sexp.t
    val immutable_of_sexp : Sexplib0.Sexp.t -> immutable
    val stable_witness_immutable : immutable Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type read_write = Read_write.t
  [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_read_write : Bin_prot.Shape.t
    val bin_size_read_write : read_write Bin_prot.Size.sizer
    val bin_write_read_write : read_write Bin_prot.Write.writer
    val bin_writer_read_write : read_write Bin_prot.Type_class.writer
    val bin_read_read_write : read_write Bin_prot.Read.reader
    val __bin_read_read_write__ : (int -> read_write) Bin_prot.Read.reader
    val bin_reader_read_write : read_write Bin_prot.Type_class.reader
    val bin_read_write : read_write Bin_prot.Type_class.t
    val compare_read_write : read_write -> (read_write[@merlin.hide]) -> int
    val equal_read_write : read_write -> (read_write[@merlin.hide]) -> bool
    val globalize_read_write : read_write -> read_write

    val hash_fold_read_write
      :  Ppx_hash_lib.Std.Hash.state
      -> read_write
      -> Ppx_hash_lib.Std.Hash.state

    val hash_read_write : read_write -> Ppx_hash_lib.Std.Hash.hash_value
    val sexp_of_read_write : read_write -> Sexplib0.Sexp.t
    val read_write_of_sexp : Sexplib0.Sexp.t -> read_write
    val stable_witness_read_write : read_write Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a perms = 'a Upper_bound.t
  [@@deriving bin_io, compare, equal, globalize, hash, sexp, stable_witness]

  include sig
    [@@@ocaml.warning "-32"]

    val bin_shape_perms : Bin_prot.Shape.t -> Bin_prot.Shape.t
    val bin_size_perms : 'a Bin_prot.Size.sizer -> 'a perms Bin_prot.Size.sizer
    val bin_write_perms : 'a Bin_prot.Write.writer -> 'a perms Bin_prot.Write.writer

    val bin_writer_perms
      :  'a Bin_prot.Type_class.writer
      -> 'a perms Bin_prot.Type_class.writer

    val bin_read_perms : 'a Bin_prot.Read.reader -> 'a perms Bin_prot.Read.reader

    val __bin_read_perms__
      :  'a Bin_prot.Read.reader
      -> (int -> 'a perms) Bin_prot.Read.reader

    val bin_reader_perms
      :  'a Bin_prot.Type_class.reader
      -> 'a perms Bin_prot.Type_class.reader

    val bin_perms : 'a Bin_prot.Type_class.t -> 'a perms Bin_prot.Type_class.t

    val compare_perms
      :  ('a -> ('a[@merlin.hide]) -> int)
      -> 'a perms
      -> ('a perms[@merlin.hide])
      -> int

    val equal_perms
      :  ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a perms
      -> ('a perms[@merlin.hide])
      -> bool

    val globalize_perms : ('a -> 'a) -> 'a perms -> 'a perms

    val hash_fold_perms
      :  (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a perms
      -> Ppx_hash_lib.Std.Hash.state

    val sexp_of_perms : ('a -> Sexplib0.Sexp.t) -> 'a perms -> Sexplib0.Sexp.t
    val perms_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a perms

    val stable_witness_perms
      :  'a Ppx_stable_witness_runtime.Stable_witness.t
      -> 'a perms Ppx_stable_witness_runtime.Stable_witness.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Stable : sig
  module V1 : sig
    type nonrec nobody = nobody
    [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_nobody : Bin_prot.Shape.t
      val bin_size_nobody : nobody Bin_prot.Size.sizer
      val bin_write_nobody : nobody Bin_prot.Write.writer
      val bin_writer_nobody : nobody Bin_prot.Type_class.writer
      val bin_read_nobody : nobody Bin_prot.Read.reader
      val __bin_read_nobody__ : (int -> nobody) Bin_prot.Read.reader
      val bin_reader_nobody : nobody Bin_prot.Type_class.reader
      val bin_nobody : nobody Bin_prot.Type_class.t
      val compare_nobody : nobody -> (nobody[@merlin.hide]) -> int
      val equal_nobody : nobody -> (nobody[@merlin.hide]) -> bool

      val hash_fold_nobody
        :  Ppx_hash_lib.Std.Hash.state
        -> nobody
        -> Ppx_hash_lib.Std.Hash.state

      val hash_nobody : nobody -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_nobody : nobody -> Sexplib0.Sexp.t
      val nobody_of_sexp : Sexplib0.Sexp.t -> nobody
      val stable_witness_nobody : nobody Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nonrec me = me [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      val bin_shape_me : Bin_prot.Shape.t
      val bin_size_me : me Bin_prot.Size.sizer
      val bin_write_me : me Bin_prot.Write.writer
      val bin_writer_me : me Bin_prot.Type_class.writer
      val bin_read_me : me Bin_prot.Read.reader
      val __bin_read_me__ : (int -> me) Bin_prot.Read.reader
      val bin_reader_me : me Bin_prot.Type_class.reader
      val bin_me : me Bin_prot.Type_class.t
      val compare_me : me -> (me[@merlin.hide]) -> int
      val equal_me : me -> (me[@merlin.hide]) -> bool
      val hash_fold_me : Ppx_hash_lib.Std.Hash.state -> me -> Ppx_hash_lib.Std.Hash.state
      val hash_me : me -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_me : me -> Sexplib0.Sexp.t
      val me_of_sexp : Sexplib0.Sexp.t -> me
      val stable_witness_me : me Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    module Read : sig
      type t = Read.t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Write : sig
      type t = Write.t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Immutable : sig
      type t = Immutable.t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Read_write : sig
      type t = Read_write.t
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Upper_bound : sig
      type 'a t = 'a Upper_bound.t
      [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
        include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t

        val stable_witness
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  module Export : module type of Export
end
