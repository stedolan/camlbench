open! Base

type 'a t

val none : _ t
val return : 'a -> 'a t
val map : 'a t -> f:('a -> 'b) -> 'b t
val bind : 'a t -> f:('a -> 'b t) -> 'b t
val both : [ `both_would_allocate__use_bind_instead ]
val ( >>| ) : 'a t -> ('a -> 'b) -> 'b t
val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
val is_none : 'a t -> bool
val unsafe_value : 'a t -> 'a
val to_option : 'a t -> 'a option

module Optional_syntax : sig
  module Optional_syntax : sig
    val is_none : 'a t -> bool
    val unsafe_value : 'a t -> 'a
  end
end

module Let_syntax : sig
  val return : 'a -> 'a t

  module Let_syntax : sig
    val return : 'a -> 'a t
    val map : 'a t -> f:('a -> 'b) -> 'b t
    val bind : 'a t -> f:('a -> 'b t) -> 'b t
    val both : [ `both_would_allocate__use_bind_instead ]

    module Open_on_rhs : sig end
  end
end
