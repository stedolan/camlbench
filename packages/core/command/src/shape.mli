[@@@ocaml.text
  " A [Command_shape] allows limited introspection of a [Command], including subcommands,\n\
  \    arguments, and doc strings. Think of it as machine-readable help. "]

open! Base

module Anons : sig
  module Grammar : sig
    type t =
      | Zero
      | One of string
      | Many of t
      | Maybe of t
      | Concat of t list
      | Ad_hoc of string
    [@@deriving compare, sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Invariant.S with type t := t

    val usage : t -> string
  end

  type t =
    | Usage of string
    [@ocaml.doc
      " When exec'ing an older binary whose help sexp doesn't expose the grammar. "]
    | Grammar of Grammar.t
  [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Num_occurrences : sig
  type t =
    { at_least_once : bool
    ; at_most_once : bool
    }
  [@@deriving compare, enumerate, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_enumerate_lib.Enumerable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_help_string : t -> flag_name:string -> string
end

module Flag_info : sig
  type t =
    { name : string [@ocaml.doc " See [flag_name] below. "]
    ; doc : string
    ; aliases : string list
    }
  [@@deriving compare, fields ~getters, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val aliases : t -> string list
    val doc : t -> string
    val name : t -> string
    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val flag_name : t -> string Or_error.t
  [@@ocaml.doc
    " [flag_name] infers the string which one would pass on the command line. It is not\n\
    \      the same as the raw [name] field, which additionally encodes \
     [num_occurrences] and\n\
    \      [requires_arg] (sort of). "]

  val num_occurrences : t -> Num_occurrences.t Or_error.t

  val requires_arg : t -> bool Or_error.t
  [@@ocaml.doc
    " [requires_arg] gives undefined behavior on [escape] flags. This is a limitation of\n\
    \      the underlying shape representation. "]

  val t_of_sexp : Sexp.t -> t
  [@@deprecated "[since 2020-04] Use [Command.Stable.Shape.Flag_info]."]
end

module Flag_help_display : sig
  type t = Flag_info.t list

  val sort : t -> t
  val to_string : t -> string
end

module Base_info : sig
  type t =
    { summary : string
    ; readme : string option
    ; anons : Anons.t
    ; flags : Flag_info.t list
    }
  [@@deriving compare, fields ~getters, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val flags : t -> Flag_info.t list
    val anons : t -> Anons.t
    val readme : t -> string option
    val summary : t -> string
    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val find_flag : t -> string -> Flag_info.t Or_error.t
  [@@ocaml.doc
    " [find_flag t prefix] looks up the flag, if any, to which [prefix] refers.\n\n\
    \      It raises if [prefix] does not begin with [-] as all flags should.\n\n\
    \      [find_flag] does not consider [aliases_excluded_from_help], and it assumes that\n\
    \      all flags can be passed by prefix. These are limitations in the underlying \
     shape\n\
    \      representation. "]

  val get_usage : t -> string

  val t_of_sexp : Sexp.t -> t
  [@@deprecated "[since 2020-04] Use [Command.Stable.Shape.Base_info]."]
end

module Group_info : sig
  type 'a t =
    { summary : string
    ; readme : string option
    ; subcommands : (string, 'a) List.Assoc.t Lazy.t
    }
  [@@deriving compare, fields ~getters, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

    val subcommands : 'a t -> (string, 'a) List.Assoc.t Lazy.t
    val readme : 'a t -> string option
    val summary : 'a t -> string
    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val find_subcommand : 'a t -> string -> 'a Or_error.t
  val map : 'a t -> f:('a -> 'b) -> 'b t

  val t_of_sexp : (Sexp.t -> 'a) -> Sexp.t -> 'a t
  [@@deprecated "[since 2020-04] Use [Command.Stable.Shape.Group_info]."]
end

module Exec_info : sig
  type t =
    { summary : string
    ; readme : string option
    ; working_dir : string
    ; path_to_exe : string
    ; child_subcommand : string list
    }
  [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val t_of_sexp : Sexp.t -> t
  [@@deprecated "[since 2020-04] Use [Command.Stable.Shape.Exec_info]."]
end

module Fully_forced : sig
  type t =
    | Basic of Base_info.t
    | Group of t Group_info.t
    | Exec of Exec_info.t * t
  [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val expanded_subcommands : t -> string list list

  val t_of_sexp : Sexp.t -> t
  [@@deprecated "[since 2020-04] Use [Command.Stable.Shape.Fully_forced]."]
end
[@@ocaml.doc " Fully forced shapes are comparable and serializable. "]

type t =
  | Basic of Base_info.t
  | Group of t Group_info.t
  | Exec of Exec_info.t * (unit -> t)
  | Lazy of t Lazy.t

val fully_forced : t -> Fully_forced.t
val get_summary : t -> string

module Sexpable : sig
  type t =
    | Base of Base_info.t
    | Group of t Group_info.t
    | Exec of Exec_info.t
    | Lazy of t Lazy.t
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val extraction_var : string
  val supported_versions : Set.M(Int).t

  module Versioned : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  val of_versioned : Versioned.t -> t
  val to_versioned : t -> version_to_use:int -> Versioned.t
end

val help_text : [ `Use_Command_unix ] [@@deprecated "[since 2021-03] Use [Command_unix]"]

module Stable : sig
  module Anons : sig
    module Grammar : sig
      module V1 : sig
        type t = Anons.Grammar.t =
          | Zero
          | One of string
          | Many of t
          | Maybe of t
          | Concat of t list
          | Ad_hoc of string
        [@@deriving compare, sexp, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_compare_lib.Comparable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end
    end

    module V2 : sig
      type t = Anons.t =
        | Usage of string
        | Grammar of Grammar.V1.t
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  module Flag_info : sig
    module V1 : sig
      type t = Flag_info.t =
        { name : string
        ; doc : string
        ; aliases : string list
        }
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  module Base_info : sig
    module V2 : sig
      type t = Base_info.t =
        { summary : string
        ; readme : string option
        ; anons : Anons.V2.t
        ; flags : Flag_info.V1.t list
        }
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module V1 : sig
      type t =
        { summary : string
        ; readme : string option
        ; usage : string
        ; flags : Flag_info.V1.t list
        }
      [@@deriving sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_latest : t -> V2.t
      val of_latest : V2.t -> t
    end
  end

  module Group_info : sig
    module V2 : sig
      type 'a t = 'a Group_info.t =
        { summary : string
        ; readme : string option
        ; subcommands : (string * 'a) list Lazy.t
        }
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t

        val stable_witness
          :  'a Ppx_stable_witness_runtime.Stable_witness.t
          -> 'a t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val map : 'a t -> f:('a -> 'b) -> 'b t
    end
  end

  module Exec_info : sig
    module V3 : sig
      type t = Exec_info.t =
        { summary : string
        ; readme : string option
        ; working_dir : string
        ; path_to_exe : string
        ; child_subcommand : string list
        }
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    module Model = V3

    module V2 : sig
      type t =
        { summary : string
        ; readme : string option
        ; working_dir : string
        ; path_to_exe : string
        }
      [@@deriving sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_latest : t -> Model.t
      val of_latest : Model.t -> t
    end

    module V1 : sig
      type t =
        { summary : string
        ; readme : string option
        ; path_to_exe : string
        }
      [@@deriving sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_latest : t -> Model.t
      val of_latest : Model.t -> t
    end
  end

  module Fully_forced : sig
    module V1 : sig
      type t = Fully_forced.t =
        | Basic of Base_info.V2.t
        | Group of t Group_info.V2.t
        | Exec of Exec_info.V3.t * t
      [@@deriving compare, sexp, stable_witness]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end
end

module Private : sig
  module Key_type : sig
    type t =
      | Subcommand
      | Flag

    val to_string : t -> string
  end

  val abs_path : dir:string -> string -> string
  val help_screen_compare : string -> string -> int

  val lookup_expand
    :  (string * ('a * [ `Full_match_required | `Prefix ])) list
    -> string
    -> Key_type.t
    -> (string * 'a, string) Result.t

  val word_wrap : string -> int -> string list
end
