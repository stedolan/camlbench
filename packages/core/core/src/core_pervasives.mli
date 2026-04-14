[@@@ocaml.text
  " This module has exactly the same interface and implementation as INRIA's Pervasives,\n\
  \    except that some things are deprecated in favor of Core equivalents.\n\n\
  \    Functions here are in one of four states:\n\
  \    1. Deprecated using [@@deprecated].\n\
  \    2. Accepted as part of Core for the forseeable future.\n\
  \    3. We haven't yet decided whether to deprecate, as indicated by a CR.\n\
  \    4. We plan to deprecate eventually, but haven't yet, as indicated by a CR.\n\n\
  \    Eventually, this module will be removed, and it will be recommended to compile with\n\
  \    -nopervasives when using Core.\n"]

[@@@ocaml.text " {6 Exceptions} "]

external raise : exn -> 'a = "%reraise" [@@ocaml.doc " Raise the given exception value "]

external raise_notrace : exn -> 'a = "%raise_notrace"
[@@ocaml.doc
  " A faster version [raise] which does not record the backtrace.\n    @since 4.02.0\n"]

val invalid_arg : string -> 'a
[@@ocaml.doc " Raise exception [Invalid_argument] with the given string. "]

val failwith : string -> 'a
[@@ocaml.doc " Raise exception [Failure] with the given string. "]

exception
  Exit
      [@ocaml.doc
        " The [Exit] exception is not raised by any library function.  It is\n\
        \    provided for use in your programs. "]

[@@@ocaml.text " {6 Comparisons} "]

external ( = ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%equal"
[@@ocaml.doc
  " [e1 = e2] tests for structural equality of [e1] and [e2].\n\
  \    Mutable structures (e.g. references and arrays) are equal\n\
  \    if and only if their current contents are structurally equal,\n\
  \    even if the two mutable objects are not the same physical object.\n\
  \    Equality between functional values raises [Invalid_argument].\n\
  \    Equality between cyclic data structures may not terminate. "]

external ( <> ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%notequal"
[@@ocaml.doc " Negation of {!Poly.( = )}. "]

external ( < ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%lessthan"
[@@ocaml.doc " See {!Poly.( >= )}. "]

external ( > ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%greaterthan"
[@@ocaml.doc " See {!Poly.( >= )}. "]

external ( <= ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%lessequal"
[@@ocaml.doc " See {!Poly.( >= )}. "]

external ( >= ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%greaterequal"
[@@ocaml.doc
  " Structural ordering functions. These functions coincide with\n\
  \    the usual orderings over integers, characters, strings, byte sequences\n\
  \    and floating-point numbers, and extend them to a\n\
  \    total ordering over all types.\n\
  \    The ordering is compatible with [( = )]. As in the case\n\
  \    of [( = )], mutable structures are compared by contents.\n\
  \    Comparison between functional values raises [Invalid_argument].\n\
  \    Comparison between cyclic structures may not terminate. "]

external compare : ('a[@local_opt]) -> ('a[@local_opt]) -> int = "%compare"
[@@ocaml.doc
  " [compare x y] returns [0] if [x] is equal to [y],\n\
  \    a negative integer if [x] is less than [y], and a positive integer\n\
  \    if [x] is greater than [y].  The ordering implemented by [compare]\n\
  \    is compatible with the comparison predicates [=], [<] and [>]\n\
  \    defined above,  with one difference on the treatment of the float value\n\
  \    {!Caml.nan}.  Namely, the comparison predicates treat [nan]\n\
  \    as different from any other float value, including itself;\n\
  \    while [compare] treats [nan] as equal to itself and less than any\n\
  \    other float value.  This treatment of [nan] ensures that [compare]\n\
  \    defines a total ordering relation.\n\n\
  \    [compare] applied to functional values may raise [Invalid_argument].\n\
  \    [compare] applied to cyclic structures may not terminate.\n\n\
  \    The [compare] function can be used as the comparison function\n\
  \    required by the {!Set.Make} and {!Map.Make} functors, as well as\n\
  \    the {!List.sort} and {!Array.sort} functions. "]

val min : 'a -> 'a -> 'a
[@@ocaml.doc
  " Return the smaller of the two arguments.\n\
  \    The result is unspecified if one of the arguments contains\n\
  \    the float value [nan]. "]

val max : 'a -> 'a -> 'a
[@@ocaml.doc
  " Return the greater of the two arguments.\n\
  \    The result is unspecified if one of the arguments contains\n\
  \    the float value [nan]. "]

external ( == ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%eq"
[@@ocaml.doc
  " [e1 == e2] tests for physical equality of [e1] and [e2].\n\
  \    On mutable types such as references, arrays, byte sequences, records with\n\
  \    mutable fields and objects with mutable instance variables,\n\
  \    [e1 == e2] is true if and only if physical modification of [e1]\n\
  \    also affects [e2].\n\
  \    On non-mutable types, the behavior of [( == )] is\n\
  \    implementation-dependent; however, it is guaranteed that\n\
  \    [e1 == e2] implies [compare e1 e2 = 0]. "]
[@@deprecated "[since 2014-10] Use [phys_equal]"]

external ( != ) : ('a[@local_opt]) -> ('a[@local_opt]) -> bool = "%noteq"
[@@ocaml.doc " Negation of {!( == )}. "] [@@deprecated "[since 2014-10] Use [phys_equal]"]

[@@@ocaml.text " {6 Boolean operations} "]

external not : (bool[@local_opt]) -> bool = "%boolnot"
[@@ocaml.doc " The boolean negation. "]

external ( && ) : (bool[@local_opt]) -> (bool[@local_opt]) -> bool = "%sequand"
[@@ocaml.doc
  " The boolean 'and'. Evaluation is sequential, left-to-right:\n\
  \    in [e1 && e2], [e1] is evaluated first, and if it returns [false],\n\
  \    [e2] is not evaluated at all. "]

external ( || ) : (bool[@local_opt]) -> (bool[@local_opt]) -> bool = "%sequor"
[@@ocaml.doc
  " The boolean 'or'. Evaluation is sequential, left-to-right:\n\
  \    in [e1 || e2], [e1] is evaluated first, and if it returns [true],\n\
  \    [e2] is not evaluated at all. "]

[@@@ocaml.text " {6 Debugging} "]

external __LOC__ : string = "%loc_LOC"
[@@ocaml.doc
  " [__LOC__] returns the location at which this expression appears in\n\
  \    the file currently being parsed by the compiler, with the standard\n\
  \    error format of OCaml: \"File %S, line %d, characters %d-%d\" "]

external __FILE__ : string = "%loc_FILE"
[@@ocaml.doc
  " [__FILE__] returns the name of the file currently being\n    parsed by the compiler. "]

external __LINE__ : int = "%loc_LINE"
[@@ocaml.doc
  " [__LINE__] returns the line number at which this expression\n\
  \    appears in the file currently being parsed by the compiler. "]

external __MODULE__ : string = "%loc_MODULE"
[@@ocaml.doc
  " [__MODULE__] returns the module name of the file being\n    parsed by the compiler. "]

external __POS__ : string * int * int * int = "%loc_POS"
[@@ocaml.doc
  " [__POS__] returns a tuple [(file,lnum,cnum,enum)], corresponding\n\
  \    to the location at which this expression appears in the file\n\
  \    currently being parsed by the compiler. [file] is the current\n\
  \    filename, [lnum] the line number, [cnum] the character position in\n\
  \    the line and [enum] the last character position in the line. "]

[%%if ocaml_version >= (4, 12, 0)]

external __FUNCTION__ : string = "%loc_FUNCTION"
[@@ocaml.doc
  " [__FUNCTION__] returns the name of the current function or method, including\n\
  \    any enclosing modules or classes. "]

[%%else]

val __FUNCTION__ : string

[%%endif]

external __LOC_OF__ : ('a[@local_opt]) -> (string * 'a[@local_opt]) = "%loc_LOC"
[@@ocaml.doc
  " [__LOC_OF__ expr] returns a pair [(loc, expr)] where [loc] is the\n\
  \    location of [expr] in the file currently being parsed by the\n\
  \    compiler, with the standard error format of OCaml: \"File %S, line\n\
  \    %d, characters %d-%d\" "]

external __LINE_OF__ : ('a[@local_opt]) -> (int * 'a[@local_opt]) = "%loc_LINE"
[@@ocaml.doc
  " [__LINE_OF__ expr] returns a pair [(line, expr)], where [line] is the\n\
  \    line number at which the expression [expr] appears in the file\n\
  \    currently being parsed by the compiler. "]

external __POS_OF__
  :  ('a[@local_opt])
  -> ((string * int * int * int) * 'a[@local_opt])
  = "%loc_POS"
[@@ocaml.doc
  " [__POS_OF__ expr] returns a pair [(expr,loc)], where [loc] is a\n\
  \    tuple [(file,lnum,cnum,enum)] corresponding to the location at\n\
  \    which the expression [expr] appears in the file currently being\n\
  \    parsed by the compiler. [file] is the current filename, [lnum] the\n\
  \    line number, [cnum] the character position in the line and [enum]\n\
  \    the last character position in the line. "]

[@@@ocaml.text " {6 Composition operators} "]

external ( |> ) : 'a -> (('a -> 'b)[@local_opt]) -> 'b = "%revapply"
[@@ocaml.doc
  " Reverse-application operator: [x |> f |> g] is exactly equivalent\n\
  \    to [g (f (x))].\n\
  \    @since 4.01\n"]

external ( @@ ) : (('a -> 'b)[@local_opt]) -> 'a -> 'b = "%apply"
[@@ocaml.doc
  " Application operator: [g @@ f @@ x] is exactly equivalent to\n\
  \    [g (f (x))].\n\
  \    @since 4.01\n"]

[@@@ocaml.text " {6 Integer arithmetic} "]

[@@@ocaml.text
  " Integers are 31 bits wide (or 63 bits on 64-bit processors).\n\
  \    All operations are taken modulo 2{^31} (or 2{^63}).\n\
  \    They do not fail on overflow. "]

external ( ~- ) : (int[@local_opt]) -> int = "%negint"
[@@ocaml.doc " Unary negation. You can also write [- e] instead of [~- e]. "]

external ( ~+ ) : (int[@local_opt]) -> int = "%identity"
[@@ocaml.doc
  " Unary addition. You can also write [+ e] instead of [~+ e].\n    @since 3.12.0\n"]

external succ : (int[@local_opt]) -> int = "%succint"
[@@ocaml.doc " [succ x] is [x + 1]. "]

external pred : (int[@local_opt]) -> int = "%predint"
[@@ocaml.doc " [pred x] is [x - 1]. "]

external ( + ) : (int[@local_opt]) -> (int[@local_opt]) -> int = "%addint"
[@@ocaml.doc " Integer addition. "]

external ( - ) : (int[@local_opt]) -> (int[@local_opt]) -> int = "%subint"
[@@ocaml.doc " Integer subtraction. "]

external ( * ) : (int[@local_opt]) -> (int[@local_opt]) -> int = "%mulint"
[@@ocaml.doc " Integer multiplication. "]

external ( / ) : (int[@local_opt]) -> (int[@local_opt]) -> int = "%divint"
[@@ocaml.doc
  " Integer division.\n\
  \    Raise [Division_by_zero] if the second argument is 0.\n\
  \    Integer division rounds the real quotient of its arguments towards zero.\n\
  \    More precisely, if [x >= 0] and [y > 0], [x / y] is the greatest integer\n\
  \    less than or equal to the real quotient of [x] by [y].  Moreover,\n\
  \    [(- x) / y = x / (- y) = - (x / y)].  "]

external \#mod : (int[@local_opt]) -> (int[@local_opt]) -> int = "%modint"
[@@ocaml.doc
  " Integer remainder.  If [y] is not zero, the result\n\
  \    of [x mod y] satisfies the following properties:\n\
  \    [x = (x / y) * y + x mod y] and\n\
  \    [abs(x mod y) <= abs(y) - 1].\n\
  \    If [y = 0], [x mod y] raises [Division_by_zero].\n\
  \    Note that [x mod y] is negative only if [x < 0].\n\
  \    Raise [Division_by_zero] if [y] is zero. "]

val abs : int -> int
[@@ocaml.doc
  " Return the absolute value of the argument.  Note that this may be\n\
  \    negative if the argument is [min_int]. "]

val max_int : int
[@@ocaml.doc " The greatest representable integer. "]
[@@deprecated "[since 2014-10] Use [Int.max_value]"]

val min_int : int
[@@ocaml.doc " The smallest representable integer. "]
[@@deprecated "[since 2014-10] Use [Int.min_value]"]

[@@@ocaml.text " {7 Bitwise operations} "]

external \#land : (int[@local_opt]) -> (int[@local_opt]) -> int = "%andint"
[@@ocaml.doc " Bitwise logical and. "]

external \#lor : (int[@local_opt]) -> (int[@local_opt]) -> int = "%orint"
[@@ocaml.doc " Bitwise logical or. "]

external \#lxor : (int[@local_opt]) -> (int[@local_opt]) -> int = "%xorint"
[@@ocaml.doc " Bitwise logical exclusive or. "]

val lnot : int -> int [@@ocaml.doc " Bitwise logical negation. "]

external \#lsl : (int[@local_opt]) -> (int[@local_opt]) -> int = "%lslint"
[@@ocaml.doc
  " [n lsl m] shifts [n] to the left by [m] bits.\n\
  \    The result is unspecified if [m < 0] or [m >= bitsize],\n\
  \    where [bitsize] is [32] on a 32-bit platform and\n\
  \    [64] on a 64-bit platform. "]

external \#lsr : (int[@local_opt]) -> (int[@local_opt]) -> int = "%lsrint"
[@@ocaml.doc
  " [n lsr m] shifts [n] to the right by [m] bits.\n\
  \    This is a logical shift: zeroes are inserted regardless of\n\
  \    the sign of [n].\n\
  \    The result is unspecified if [m < 0] or [m >= bitsize]. "]

external \#asr : (int[@local_opt]) -> (int[@local_opt]) -> int = "%asrint"
[@@ocaml.doc
  " [n asr m] shifts [n] to the right by [m] bits.\n\
  \    This is an arithmetic shift: the sign bit of [n] is replicated.\n\
  \    The result is unspecified if [m < 0] or [m >= bitsize]. "]

[@@@ocaml.text
  " {6 Floating-point arithmetic}\n\n\
  \    OCaml's floating-point numbers follow the\n\
  \    IEEE 754 standard, using double precision (64 bits) numbers.\n\
  \    Floating-point operations never raise an exception on overflow,\n\
  \    underflow, division by zero, etc.  Instead, special IEEE numbers\n\
  \    are returned as appropriate, such as [infinity] for [1.0 /. 0.0],\n\
  \    [neg_infinity] for [-1.0 /. 0.0], and [nan] ('not a number')\n\
  \    for [0.0 /. 0.0].  These special numbers then propagate through\n\
  \    floating-point computations as expected: for instance,\n\
  \    [1.0 /. infinity] is [0.0], and any arithmetic operation with [nan]\n\
  \    as argument returns [nan] as result.\n"]

external ( ~-. ) : (float[@local_opt]) -> (float[@local_opt]) = "%negfloat"
[@@ocaml.doc " Unary negation. You can also write [-. e] instead of [~-. e]. "]

external ( ~+. ) : (float[@local_opt]) -> (float[@local_opt]) = "%identity"
[@@ocaml.doc
  " Unary addition. You can also write [+. e] instead of [~+. e].\n    @since 3.12.0\n"]

external ( +. )
  :  (float[@local_opt])
  -> (float[@local_opt])
  -> (float[@local_opt])
  = "%addfloat"
[@@ocaml.doc " Floating-point addition "]

external ( -. )
  :  (float[@local_opt])
  -> (float[@local_opt])
  -> (float[@local_opt])
  = "%subfloat"
[@@ocaml.doc " Floating-point subtraction "]

external ( *. )
  :  (float[@local_opt])
  -> (float[@local_opt])
  -> (float[@local_opt])
  = "%mulfloat"
[@@ocaml.doc " Floating-point multiplication "]

external ( /. )
  :  (float[@local_opt])
  -> (float[@local_opt])
  -> (float[@local_opt])
  = "%divfloat"
[@@ocaml.doc " Floating-point division. "]

external ( ** ) : float -> float -> float = "caml_power_float" "pow"
[@@ocaml.doc " Exponentiation. "] [@@unboxed] [@@noalloc]

external sqrt : float -> float = "caml_sqrt_float" "sqrt"
[@@ocaml.doc " Square root. "] [@@unboxed] [@@noalloc]

external exp : float -> float = "caml_exp_float" "exp"
[@@ocaml.doc " Exponential. "] [@@unboxed] [@@noalloc]

external log : float -> float = "caml_log_float" "log"
[@@ocaml.doc " Natural logarithm. "] [@@unboxed] [@@noalloc]

external log10 : float -> float = "caml_log10_float" "log10"
[@@ocaml.doc " Base 10 logarithm. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.log10]"]

external expm1 : float -> float = "caml_expm1_float" "caml_expm1"
[@@ocaml.doc
  " [expm1 x] computes [exp x -. 1.0], giving numerically-accurate results\n\
  \    even if [x] is close to [0.0].\n\
  \    @since 3.12.0\n"]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.expm1]"]

external log1p : float -> float = "caml_log1p_float" "caml_log1p"
[@@ocaml.doc
  " [log1p x] computes [log(1.0 +. x)] (natural logarithm),\n\
  \    giving numerically-accurate results even if [x] is close to [0.0].\n\
  \    @since 3.12.0\n"]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.log1p]"]

external cos : float -> float = "caml_cos_float" "cos"
[@@ocaml.doc " Cosine.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.cos]"]

external sin : float -> float = "caml_sin_float" "sin"
[@@ocaml.doc " Sine.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.sin]"]

external tan : float -> float = "caml_tan_float" "tan"
[@@ocaml.doc " Tangent.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.tan]"]

external acos : float -> float = "caml_acos_float" "acos"
[@@ocaml.doc
  " Arc cosine.  The argument must fall within the range [[-1.0, 1.0]].\n\
  \    Result is in radians and is between [0.0] and [pi]. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.acos]"]

external asin : float -> float = "caml_asin_float" "asin"
[@@ocaml.doc
  " Arc sine.  The argument must fall within the range [[-1.0, 1.0]].\n\
  \    Result is in radians and is between [-pi/2] and [pi/2]. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.asin]"]

external atan : float -> float = "caml_atan_float" "atan"
[@@ocaml.doc
  " Arc tangent.\n    Result is in radians and is between [-pi/2] and [pi/2]. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.atan]"]

external atan2 : float -> float -> float = "caml_atan2_float" "atan2"
[@@ocaml.doc
  " [atan2 y x] returns the arc tangent of [y /. x].  The signs of [x]\n\
  \    and [y] are used to determine the quadrant of the result.\n\
  \    Result is in radians and is between [-pi] and [pi]. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.atan2]"]

external hypot : float -> float -> float = "caml_hypot_float" "caml_hypot"
[@@ocaml.doc
  " [hypot x y] returns [sqrt(x *. x + y *. y)], that is, the length\n\
  \    of the hypotenuse of a right-angled triangle with sides of length\n\
  \    [x] and [y], or, equivalently, the distance of the point [(x,y)]\n\
  \    to origin.\n\
  \    @since 4.00.0  "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.hypot]"]

external cosh : float -> float = "caml_cosh_float" "cosh"
[@@ocaml.doc " Hyperbolic cosine.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.cosh]"]

external sinh : float -> float = "caml_sinh_float" "sinh"
[@@ocaml.doc " Hyperbolic sine.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.sinh]"]

external tanh : float -> float = "caml_tanh_float" "tanh"
[@@ocaml.doc " Hyperbolic tangent.  Argument is in radians. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.tanh]"]

external acosh : float -> float = "caml_acosh_float" "caml_acosh"
[@@ocaml.doc
  " Hyperbolic arc cosine.  The argument must fall within the range\n\
  \    [[1.0, inf]].\n\
  \    Result is in radians and is between [0.0] and [inf].\n\n\
  \    @since 4.13.0\n"]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2022-11] Use [Float.acosh]"]

external asinh : float -> float = "caml_asinh_float" "caml_asinh"
[@@ocaml.doc
  " Hyperbolic arc sine.  The argument and result range over the entire\n\
  \    real line.\n\
  \    Result is in radians.\n\n\
  \    @since 4.13.0\n"]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2022-11] Use [Float.asinh]"]

external atanh : float -> float = "caml_atanh_float" "caml_atanh"
[@@ocaml.doc
  " Hyperbolic arc tangent.  The argument must fall within the range\n\
  \    [[-1.0, 1.0]].\n\
  \    Result is in radians and ranges over the entire real line.\n\n\
  \    @since 4.13.0\n"]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2022-11] Use [Float.atanh]"]

external ceil : float -> float = "caml_ceil_float" "ceil"
[@@ocaml.doc
  " Round above to an integer value.\n\
  \    [ceil f] returns the least integer value greater than or equal to [f].\n\
  \    The result is returned as a float. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2014-10] Use [Float.round_up]"]

external floor : float -> float = "caml_floor_float" "floor"
[@@ocaml.doc
  " Round below to an integer value.\n\
  \    [floor f] returns the greatest integer value less than or\n\
  \    equal to [f].\n\
  \    The result is returned as a float. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2014-10] Use [Float.round_down]"]

external abs_float : float -> float = "%absfloat"
[@@ocaml.doc " [abs_float f] returns the absolute value of [f]. "]
[@@deprecated "[since 2014-10] Use [Float.abs]"]

external copysign : float -> float -> float = "caml_copysign_float" "caml_copysign"
[@@ocaml.doc
  " [copysign x y] returns a float whose absolute value is that of [x]\n\
  \    and whose sign is that of [y].  If [x] is [nan], returns [nan].\n\
  \    If [y] is [nan], returns either [x] or [-. x], but it is not\n\
  \    specified which.\n\
  \    @since 4.00.0  "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2016-07] Use [Float.copysign]"]

external mod_float : float -> float -> float = "caml_fmod_float" "fmod"
[@@ocaml.doc
  " [mod_float a b] returns the remainder of [a] with respect to\n\
  \    [b].  The returned value is [a -. n *. b], where [n]\n\
  \    is the quotient [a /. b] rounded towards zero to an integer. "]
[@@unboxed]
[@@noalloc]
[@@deprecated "[since 2014-10] Use [Float.mod_float]"]

external frexp : float -> float * int = "caml_frexp_float"
[@@ocaml.doc
  " [frexp f] returns the pair of the significant\n\
  \    and the exponent of [f].  When [f] is zero, the\n\
  \    significant [x] and the exponent [n] of [f] are equal to\n\
  \    zero.  When [f] is non-zero, they are defined by\n\
  \    [f = x *. 2 ** n] and [0.5 <= x < 1.0]. "]
[@@deprecated "[since 2014-10] Use [Float.frexp]"]

external ldexp
  :  (float[@unboxed])
  -> (int[@untagged])
  -> (float[@unboxed])
  = "caml_ldexp_float" "caml_ldexp_float_unboxed"
[@@ocaml.doc " [ldexp x n] returns [x *. 2 ** n]. "]
[@@noalloc]
[@@deprecated "[since 2014-10] Use [Float.ldexp]"]

external modf : float -> float * float = "caml_modf_float"
[@@ocaml.doc
  " [modf f] returns the pair of the fractional and integral\n    part of [f]. "]
[@@deprecated "[since 2014-10] Use [Float.modf]"]

external float : (int[@local_opt]) -> (float[@local_opt]) = "%floatofint"
[@@ocaml.doc " Same as {!Caml.float_of_int}. "]

external float_of_int : (int[@local_opt]) -> (float[@local_opt]) = "%floatofint"
[@@ocaml.doc " Convert an integer to floating-point. "]

external truncate : (float[@local_opt]) -> int = "%intoffloat"
[@@ocaml.doc " Same as {!Caml.int_of_float}. "]
[@@deprecated "[since 2014-10] Use [Float.iround_towards_zero_exn]"]

external int_of_float : (float[@local_opt]) -> int = "%intoffloat"
[@@ocaml.doc
  " Truncate the given floating-point number to an integer.\n\
  \    The result is unspecified if the argument is [nan] or falls outside the\n\
  \    range of representable integers. "]

val infinity : float
[@@ocaml.doc " Positive infinity. "] [@@deprecated "[since 2014-10] Use [Float.infinity]"]

val neg_infinity : float
[@@ocaml.doc " Negative infinity. "]
[@@deprecated "[since 2014-10] Use [Float.neg_infinity]"]

val nan : float
[@@ocaml.doc
  " A special floating-point value denoting the result of an\n\
  \    undefined operation such as [0.0 /. 0.0].  Stands for\n\
  \    'not a number'.  Any floating-point operation with [nan] as\n\
  \    argument returns [nan] as result.  As for floating-point comparisons,\n\
  \    [=], [<], [<=], [>] and [>=] return [false] and [<>] returns [true]\n\
  \    if one or both of their arguments is [nan]. "]
[@@deprecated "[since 2014-10] Use [Float.nan]"]

val max_float : float
[@@ocaml.doc " The largest positive finite value of type [float]. "]
[@@deprecated "[since 2014-10] Use [Float.max_value]"]

val min_float : float
[@@ocaml.doc " The smallest positive, non-zero, non-denormalized value of type [float]. "]
[@@deprecated "[since 2014-10] Use [Float.min_value]"]

val epsilon_float : float
[@@ocaml.doc
  " The difference between [1.0] and the smallest exactly representable\n\
  \    floating-point number greater than [1.0]. "]
[@@deprecated "[since 2014-10] Use [Float.epsilon_float]"]

type fpclass = Stdlib.fpclass =
  | FP_normal [@ocaml.doc " Normal number, none of the below "]
  | FP_subnormal [@ocaml.doc " Number very close to 0.0, has reduced precision "]
  | FP_zero [@ocaml.doc " Number is 0.0 or -0.0 "]
  | FP_infinite [@ocaml.doc " Number is positive or negative infinity "]
  | FP_nan [@ocaml.doc " Not a number: result of an undefined operation "]
[@@ocaml.doc
  " The five classes of floating-point numbers, as determined by\n\
  \    the {!Caml.classify_float} function. "]

external classify_float
  :  (float[@unboxed])
  -> fpclass
  = "caml_classify_float" "caml_classify_float_unboxed"
[@@ocaml.doc
  " Return the class of the given floating-point number:\n\
  \    normal, subnormal, zero, infinite, or not a number. "]
[@@noalloc]
[@@deprecated "[since 2014-10] Use [Float.classify]"]

[@@@ocaml.text
  " {6 String operations}\n\n\
  \    More string operations are provided in module {!String}.\n"]

val ( ^ ) : string -> string -> string [@@ocaml.doc " String concatenation. "]

[@@@ocaml.text
  " {6 Character operations}\n\n\
  \    More character operations are provided in module {!Char}.\n"]

external int_of_char : (char[@local_opt]) -> int = "%identity"
[@@ocaml.doc " Return the ASCII code of the argument. "]

val char_of_int : int -> char
[@@ocaml.doc
  " Return the character with the given ASCII code.\n\
  \    Raise [Invalid_argument \"char_of_int\"] if the argument is\n\
  \    outside the range 0--255. "]

[@@@ocaml.text " {6 Unit operations} "]

external ignore : ('a[@local_opt]) -> unit = "%ignore"
[@@ocaml.doc
  " Discard the value of its argument and return [()].\n\
  \    For instance, [ignore(f x)] discards the result of\n\
  \    the side-effecting function [f].  It is equivalent to\n\
  \    [f x; ()], except that the latter may generate a\n\
  \    compiler warning; writing [ignore(f x)] instead\n\
  \    avoids the warning. "]

[@@@ocaml.text " {6 String conversion functions} "]

val string_of_bool : bool -> string
[@@ocaml.doc
  " Return the string representation of a boolean. As the returned values\n\
  \    may be shared, the user should not modify them directly.\n"]

val bool_of_string : string -> bool
[@@ocaml.doc
  " Convert the given string to a boolean.\n\
  \    Raise [Invalid_argument \"bool_of_string\"] if the string is not\n\
  \    [\"true\"] or [\"false\"]. "]

val string_of_int : int -> string
[@@ocaml.doc " Return the string representation of an integer, in decimal. "]

external int_of_string : string -> int = "caml_int_of_string"
[@@ocaml.doc
  " Convert the given string to an integer.\n\
  \    The string is read in decimal (by default) or in hexadecimal (if it\n\
  \    begins with [0x] or [0X]), octal (if it begins with [0o] or [0O]),\n\
  \    or binary (if it begins with [0b] or [0B]).\n\
  \    Raise [Failure \"int_of_string\"] if the given string is not\n\
  \    a valid representation of an integer, or if the integer represented\n\
  \    exceeds the range of integers representable in type [int]. "]

val string_of_float : float -> string
[@@ocaml.doc " Return the string representation of a floating-point number. "]

external float_of_string : string -> float = "caml_float_of_string"
[@@ocaml.doc
  " Convert the given string to a float.  Raise [Failure \"float_of_string\"]\n\
  \    if the given string is not a valid representation of a float. "]

[@@@ocaml.text " {6 Pair operations} "]

[%%if flambda_backend]

external fst : ('a * 'b[@local_opt]) -> ('a[@local_opt]) = "%field0_immut"
[@@ocaml.doc " Return the first component of a pair. "]

external snd : ('a * 'b[@local_opt]) -> ('b[@local_opt]) = "%field1_immut"
[@@ocaml.doc " Return the second component of a pair. "]

[%%else]

external fst : ('a * 'b[@local_opt]) -> ('a[@local_opt]) = "%field0"
[@@ocaml.doc " Return the first component of a pair. "]

external snd : ('a * 'b[@local_opt]) -> ('b[@local_opt]) = "%field1"
[@@ocaml.doc " Return the second component of a pair. "]

[%%endif]

[@@@ocaml.text
  " {6 List operations}\n\n    More list operations are provided in module {!List}.\n"]

val ( @ ) : 'a list -> 'a list -> 'a list
[@@ocaml.doc " List concatenation. "] [@@deprecated "[since 2014-10] Use [List.Infix]"]

[@@@ocaml.text
  " {6 Input/output}\n\
  \    Note: all input/output functions can raise [Sys_error] when the system\n\
  \    calls they invoke fail. "]

type in_channel = Stdlib.in_channel
[@@ocaml.doc " The type of input channel. "]
[@@deprecated "[since 2016-04] Use [In_channel.t]"]

type out_channel = Stdlib.out_channel
[@@ocaml.doc " The type of output channel. "]
[@@deprecated "[since 2016-04] Use [Out_channel.t]"]

val stdin : Stdlib.in_channel
[@@ocaml.doc " The standard input for the process. "]
[@@deprecated "[since 2016-04] Use [In_channel.stdin]"]

val stdout : Stdlib.out_channel [@@ocaml.doc " The standard output for the process. "]

val stderr : Stdlib.out_channel
[@@ocaml.doc " The standard error output for the process. "]

[@@@ocaml.text " {7 Output functions on standard output} "]

val print_char : char -> unit
[@@ocaml.doc " Print a character on standard output. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_char stdout]"]

val print_string : string -> unit [@@ocaml.doc " Print a string on standard output. "]

val print_bytes : bytes -> unit
[@@ocaml.doc " Print a byte sequence on standard output. "]
[@@deprecated "[since 2016-04] Core doesn't support [bytes] yet."]

val print_int : int -> unit
[@@ocaml.doc " Print an integer, in decimal, on standard output. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string stdout]"]

val print_float : float -> unit
[@@ocaml.doc " Print a floating-point number, in decimal, on standard output. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string stdout]"]

val print_endline : string -> unit
[@@ocaml.doc
  " Print a string, followed by a newline character, on\n\
  \    standard output and flush standard output. "]

val print_newline : unit -> unit
[@@ocaml.doc
  " Print a newline character on standard output, and flush\n\
  \    standard output. This can be used to simulate line\n\
  \    buffering of standard output. "]
[@@deprecated "[since 2016-04] Use [Out_channel.newline stdout]"]

[@@@ocaml.text " {7 Output functions on standard error} "]

val prerr_char : char -> unit
[@@ocaml.doc " Print a character on standard error. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_char stderr]"]

val prerr_string : string -> unit
[@@ocaml.doc " Print a string on standard error. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string stderr]"]

val prerr_bytes : bytes -> unit
[@@ocaml.doc " Print a byte sequence on standard error. "]
[@@deprecated "[since 2016-04] Core doesn't support [bytes] yet"]

val prerr_int : int -> unit
[@@ocaml.doc " Print an integer, in decimal, on standard error. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string stderr]"]

val prerr_float : float -> unit
[@@ocaml.doc " Print a floating-point number, in decimal, on standard error. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string stderr]"]

val prerr_endline : string -> unit
[@@ocaml.doc
  " Print a string, followed by a newline character on standard\n\
  \    error and flush standard error. "]

val prerr_newline : unit -> unit
[@@ocaml.doc
  " Print a newline character on standard error, and flush\n    standard error. "]
[@@deprecated "[since 2016-04] Use [Out_channel.newline stderr]"]

[@@@ocaml.text " {7 Input functions on standard input} "]

val read_line : unit -> string
[@@ocaml.doc
  " Flush standard output, then read characters from standard input\n\
  \    until a newline character is encountered. Return the string of\n\
  \    all characters read, without the newline character at the end. "]
[@@deprecated
  "[since 2016-04] Use\n[Out_channel.(flush stdout); In_channel.(input_line_exn stdin)]"]

val read_int : unit -> int
[@@ocaml.doc
  " Flush standard output, then read one line from standard input\n\
  \    and convert it to an integer. Raise [Failure \"int_of_string\"]\n\
  \    if the line read is not a valid representation of an integer. "]
[@@deprecated
  "[since 2016-04] Use\n\
   [Out_channel.(flush stdout); Int.of_string In_channel.(input_line_exn stdin)]"]

val read_float : unit -> float
[@@ocaml.doc
  " Flush standard output, then read one line from standard input\n\
  \    and convert it to a floating-point number.\n\
  \    The result is unspecified if the line read is not a valid\n\
  \    representation of a floating-point number. "]
[@@deprecated
  "[since 2016-04] Use\n\
   [Out_channel.(flush stdout); Float.of_string In_channel.(input_line_exn stdin)]"]

[@@@ocaml.text " {7 General output functions} "]

type open_flag = Stdlib.open_flag =
  | Open_rdonly [@ocaml.doc " open for reading. "]
  | Open_wronly [@ocaml.doc " open for writing. "]
  | Open_append [@ocaml.doc " open for appending: always write at end of file. "]
  | Open_creat [@ocaml.doc " create the file if it does not exist. "]
  | Open_trunc [@ocaml.doc " empty the file if it already exists. "]
  | Open_excl [@ocaml.doc " fail if Open_creat and the file already exists. "]
  | Open_binary [@ocaml.doc " open in binary mode (no conversion). "]
  | Open_text [@ocaml.doc " open in text mode (may perform conversions). "]
  | Open_nonblock [@ocaml.doc " open in non-blocking mode. "]
[@@ocaml.doc " Opening modes for {!Caml.open_out_gen} and\n    {!Caml.open_in_gen}. "]
[@@deprecated "[since 2016-04] Use [In_channel.create] and [Out_channel.create]"]

val open_out : string -> Stdlib.out_channel
[@@ocaml.doc
  " Open the named file for writing, and return a new output channel\n\
  \    on that file, positionned at the beginning of the file. The\n\
  \    file is truncated to zero length if it already exists. It\n\
  \    is created if it does not already exists. "]
[@@deprecated "[since 2016-04] Use [Out_channel.create]"]

val open_out_bin : string -> Stdlib.out_channel
[@@ocaml.doc
  " Same as {!Caml.open_out}, but the file is opened in binary mode,\n\
  \    so that no translation takes place during writes. On operating\n\
  \    systems that do not distinguish between text mode and binary\n\
  \    mode, this function behaves like {!Caml.open_out}. "]
[@@deprecated "[since 2016-04] Use [Out_channel.create]"]

val open_out_gen : Stdlib.open_flag list -> int -> string -> Stdlib.out_channel
[@@ocaml.doc
  " [open_out_gen mode perm filename] opens the named file for writing,\n\
  \    as described above. The extra argument [mode]\n\
  \    specify the opening mode. The extra argument [perm] specifies\n\
  \    the file permissions, in case the file must be created.\n\
  \    {!Caml.open_out} and {!Caml.open_out_bin} are special\n\
  \    cases of this function. "]
[@@deprecated "[since 2016-04] Use [Out_channel.create]"]

val flush : Stdlib.out_channel -> unit
[@@ocaml.doc
  " Flush the buffer associated with the given output channel,\n\
  \    performing all pending writes on that channel.\n\
  \    Interactive programs must be careful about flushing standard\n\
  \    output and standard error at the right time. "]
[@@deprecated "[since 2016-04] Use [Out_channel.flush]"]

val flush_all : unit -> unit
[@@ocaml.doc " Flush all open output channels; ignore errors. "]
[@@deprecated "[since 2016-04]"]

val output_char : Stdlib.out_channel -> char -> unit
[@@ocaml.doc " Write the character on the given output channel. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_char]"]

val output_string : Stdlib.out_channel -> string -> unit
[@@ocaml.doc " Write the string on the given output channel. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_string]"]

val output_bytes : Stdlib.out_channel -> bytes -> unit
[@@ocaml.doc " Write the byte sequence on the given output channel. "]
[@@deprecated "[since 2016-04] Core doesn't yet support bytes."]

val output : Stdlib.out_channel -> bytes -> int -> int -> unit
[@@ocaml.doc
  " [output oc buf pos len] writes [len] characters from byte sequence [buf],\n\
  \    starting at offset [pos], to the given output channel [oc].\n\
  \    Raise [Invalid_argument \"output\"] if [pos] and [len] do not\n\
  \    designate a valid range of [buf]. "]
[@@deprecated "[since 2016-04] Core doesn't yet support bytes."]

val output_substring : Stdlib.out_channel -> string -> int -> int -> unit
[@@ocaml.doc
  " Same as [output] but take a string as argument instead of\n    a byte sequence. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output]"]

val output_byte : Stdlib.out_channel -> int -> unit
[@@ocaml.doc
  " Write one 8-bit integer (as the single character with that code)\n\
  \    on the given output channel. The given integer is taken modulo\n\
  \    256. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_byte]"]

val output_binary_int : Stdlib.out_channel -> int -> unit
[@@ocaml.doc
  " Write one integer in binary format (4 bytes, big-endian)\n\
  \    on the given output channel.\n\
  \    The given integer is taken modulo 2{^32}.\n\
  \    The only reliable way to read it back is through the\n\
  \    {!Caml.input_binary_int} function. The format is compatible across\n\
  \    all machines for a given version of OCaml. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_binary_int]"]

val output_value : Stdlib.out_channel -> 'a -> unit
[@@ocaml.doc
  " Write the representation of a structured value of any type\n\
  \    to a channel. Circularities and sharing inside the value\n\
  \    are detected and preserved. The object can be read back,\n\
  \    by the function {!Caml.input_value}. See the description of module\n\
  \    {!Marshal} for more information. {!Caml.output_value} is equivalent\n\
  \    to {!Marshal.to_channel} with an empty list of flags. "]
[@@deprecated "[since 2016-04] Use [Out_channel.output_value]"]

val seek_out : Stdlib.out_channel -> int -> unit
[@@ocaml.doc
  " [seek_out chan pos] sets the current writing position to [pos]\n\
  \    for channel [chan]. This works only for regular files. On\n\
  \    files of other kinds (such as terminals, pipes and sockets),\n\
  \    the behavior is unspecified. "]
[@@deprecated "[since 2014-10] Use [Out_channel.seek]"]

val pos_out : Stdlib.out_channel -> int
[@@ocaml.doc
  " Return the current writing position for the given channel.  Does\n\
  \    not work on channels opened with the [Open_append] flag (returns\n\
  \    unspecified results). "]
[@@deprecated "[since 2014-10] Use [Out_channel.pos]"]

val out_channel_length : Stdlib.out_channel -> int
[@@ocaml.doc
  " Return the size (number of characters) of the regular file\n\
  \    on which the given channel is opened.  If the channel is opened\n\
  \    on a file that is not a regular file, the result is meaningless. "]
[@@deprecated "[since 2014-10] Use [Out_channel.length]"]

val close_out : Stdlib.out_channel -> unit
[@@ocaml.doc
  " Close the given channel, flushing all buffered write operations.\n\
  \    Output functions raise a [Sys_error] exception when they are\n\
  \    applied to a closed output channel, except [close_out] and [flush],\n\
  \    which do nothing when applied to an already closed channel.\n\
  \    Note that [close_out] may raise [Sys_error] if the operating\n\
  \    system signals an error when flushing or closing. "]
[@@deprecated "[since 2014-10] Use [Out_channel.close]"]

val close_out_noerr : Stdlib.out_channel -> unit
[@@ocaml.doc " Same as [close_out], but ignore all errors. "]
[@@deprecated "[since 2016-04] Use [Out_channel.close] and catch exceptions"]

val set_binary_mode_out : Stdlib.out_channel -> bool -> unit
[@@ocaml.doc
  " [set_binary_mode_out oc true] sets the channel [oc] to binary\n\
  \    mode: no translations take place during output.\n\
  \    [set_binary_mode_out oc false] sets the channel [oc] to text\n\
  \    mode: depending on the operating system, some translations\n\
  \    may take place during output.  For instance, under Windows,\n\
  \    end-of-lines will be translated from [\\n] to [\\r\\n].\n\
  \    This function has no effect under operating systems that\n\
  \    do not distinguish between text mode and binary mode. "]
[@@deprecated "[since 2016-04] Use [Out_channel.set_binary_mode]"]

[@@@ocaml.text " {7 General input functions} "]

val open_in : string -> Stdlib.in_channel
[@@ocaml.doc
  " Open the named file for reading, and return a new input channel\n\
  \    on that file, positionned at the beginning of the file. "]
[@@deprecated "[since 2016-04] Use [In_channel.create]"]

val open_in_bin : string -> Stdlib.in_channel
[@@ocaml.doc
  " Same as {!Caml.open_in}, but the file is opened in binary mode,\n\
  \    so that no translation takes place during reads. On operating\n\
  \    systems that do not distinguish between text mode and binary\n\
  \    mode, this function behaves like {!Caml.open_in}. "]
[@@deprecated "[since 2016-04] Use [In_channel.create]"]

val open_in_gen : Stdlib.open_flag list -> int -> string -> Stdlib.in_channel
[@@ocaml.doc
  " [open_in_gen mode perm filename] opens the named file for reading,\n\
  \    as described above. The extra arguments\n\
  \    [mode] and [perm] specify the opening mode and file permissions.\n\
  \    {!Caml.open_in} and {!Caml.open_in_bin} are special\n\
  \    cases of this function. "]
[@@deprecated "[since 2016-04] Use [In_channel.create]"]

val input_char : Stdlib.in_channel -> char
[@@ocaml.doc
  " Read one character from the given input channel.\n\
  \    Raise [End_of_file] if there are no more characters to read. "]
[@@deprecated "[since 2016-04] Use [In_channel.input_char]"]

val input_line : Stdlib.in_channel -> string
[@@ocaml.doc
  " Read characters from the given input channel, until a\n\
  \    newline character is encountered. Return the string of\n\
  \    all characters read, without the newline character at the end.\n\
  \    Raise [End_of_file] if the end of the file is reached\n\
  \    at the beginning of line. "]
[@@deprecated "[since 2016-04] Use [In_channel.input_line]"]

val input : Stdlib.in_channel -> bytes -> int -> int -> int
[@@ocaml.doc
  " [input ic buf pos len] reads up to [len] characters from\n\
  \    the given channel [ic], storing them in byte sequence [buf], starting at\n\
  \    character number [pos].\n\
  \    It returns the actual number of characters read, between 0 and\n\
  \    [len] (inclusive).\n\
  \    A return value of 0 means that the end of file was reached.\n\
  \    A return value between 0 and [len] exclusive means that\n\
  \    not all requested [len] characters were read, either because\n\
  \    no more characters were available at that time, or because\n\
  \    the implementation found it convenient to do a partial read;\n\
  \    [input] must be called again to read the remaining characters,\n\
  \    if desired.  (See also {!Caml.really_input} for reading\n\
  \    exactly [len] characters.)\n\
  \    Exception [Invalid_argument \"input\"] is raised if [pos] and [len]\n\
  \    do not designate a valid range of [buf]. "]
[@@deprecated "[since 2016-04] Core doesn't yet support bytes."]

val really_input : Stdlib.in_channel -> bytes -> int -> int -> unit
[@@ocaml.doc
  " [really_input ic buf pos len] reads [len] characters from channel [ic],\n\
  \    storing them in byte sequence [buf], starting at character number [pos].\n\
  \    Raise [End_of_file] if the end of file is reached before [len]\n\
  \    characters have been read.\n\
  \    Raise [Invalid_argument \"really_input\"] if\n\
  \    [pos] and [len] do not designate a valid range of [buf]. "]
[@@deprecated "[since 2016-04] Core doesn't yet support bytes."]

val really_input_string : Stdlib.in_channel -> int -> string
[@@ocaml.doc
  " [really_input_string ic len] reads [len] characters from channel [ic]\n\
  \    and returns them in a new string.\n\
  \    Raise [End_of_file] if the end of file is reached before [len]\n\
  \    characters have been read. "]
[@@deprecated "[since 2016-04] Use [In_channel.really_input_exn ~pos:0]"]

val input_byte : Stdlib.in_channel -> int
[@@ocaml.doc
  " Same as {!Caml.input_char}, but return the 8-bit integer representing\n\
  \    the character.\n\
  \    Raise [End_of_file] if an end of file was reached. "]
[@@deprecated "[since 2016-04] Use [In_channel.input_byte]"]

val input_binary_int : Stdlib.in_channel -> int
[@@ocaml.doc
  " Read an integer encoded in binary format (4 bytes, big-endian)\n\
  \    from the given input channel. See {!Caml.output_binary_int}.\n\
  \    Raise [End_of_file] if an end of file was reached while reading the\n\
  \    integer. "]
[@@deprecated "[since 2016-04] Use [In_channel.input_binary_int]"]

val input_value : Stdlib.in_channel -> 'a
[@@ocaml.doc
  " Read the representation of a structured value, as produced\n\
  \    by {!Caml.output_value}, and return the corresponding value.\n\
  \    This function is identical to {!Marshal.from_channel};\n\
  \    see the description of module {!Marshal} for more information,\n\
  \    in particular concerning the lack of type safety. "]
[@@deprecated "[since 2016-04] Use [In_channel.unsafe_input_value]"]

val seek_in : Stdlib.in_channel -> int -> unit
[@@ocaml.doc
  " [seek_in chan pos] sets the current reading position to [pos]\n\
  \    for channel [chan]. This works only for regular files. On\n\
  \    files of other kinds, the behavior is unspecified. "]
[@@deprecated "[since 2014-10] Use [In_channel.seek]"]

val pos_in : Stdlib.in_channel -> int
[@@ocaml.doc " Return the current reading position for the given channel. "]
[@@deprecated "[since 2014-10] Use [In_channel.pos]"]

val in_channel_length : Stdlib.in_channel -> int
[@@ocaml.doc
  " Return the size (number of characters) of the regular file\n\
  \    on which the given channel is opened.  If the channel is opened\n\
  \    on a file that is not a regular file, the result is meaningless.\n\
  \    The returned size does not take into account the end-of-line\n\
  \    translations that can be performed when reading from a channel\n\
  \    opened in text mode. "]
[@@deprecated "[since 2014-10] Use [In_channel.length]"]

val close_in : Stdlib.in_channel -> unit
[@@ocaml.doc
  " Close the given channel.  Input functions raise a [Sys_error]\n\
  \    exception when they are applied to a closed input channel,\n\
  \    except [close_in], which does nothing when applied to an already\n\
  \    closed channel. "]
[@@deprecated "[since 2014-10] Use [In_channel.close]"]

val close_in_noerr : Stdlib.in_channel -> unit
[@@ocaml.doc " Same as [close_in], but ignore all errors. "]
[@@deprecated "[since 2016-04] Use [In_channel.close] and catch exceptions"]

val set_binary_mode_in : Stdlib.in_channel -> bool -> unit
[@@ocaml.doc
  " [set_binary_mode_in ic true] sets the channel [ic] to binary\n\
  \    mode: no translations take place during input.\n\
  \    [set_binary_mode_out ic false] sets the channel [ic] to text\n\
  \    mode: depending on the operating system, some translations\n\
  \    may take place during input.  For instance, under Windows,\n\
  \    end-of-lines will be translated from [\\r\\n] to [\\n].\n\
  \    This function has no effect under operating systems that\n\
  \    do not distinguish between text mode and binary mode. "]
[@@deprecated "[since 2016-04] Use [In_channel.set_binary_mode]"]

[@@@ocaml.text " {7 Operations on large files} "]

module LargeFile : sig
  val seek_out : Stdlib.out_channel -> int64 -> unit
  val pos_out : Stdlib.out_channel -> int64
  val out_channel_length : Stdlib.out_channel -> int64
  val seek_in : Stdlib.in_channel -> int64 -> unit
  val pos_in : Stdlib.in_channel -> int64
  val in_channel_length : Stdlib.in_channel -> int64
end
[@@ocaml.doc
  " Operations on large files.\n\
  \    This sub-module provides 64-bit variants of the channel functions\n\
  \    that manipulate file positions and file sizes.  By representing\n\
  \    positions and sizes by 64-bit integers (type [int64]) instead of\n\
  \    regular integers (type [int]), these alternate functions allow\n\
  \    operating on files whose sizes are greater than [max_int]. "]
[@@deprecated "[since 2016-04] Use [In_channel] and [Out_channel]"]

[@@@ocaml.text " {6 References} "]

type 'a ref = 'a Stdlib.ref = { mutable contents : 'a }
[@@ocaml.doc
  " The type of references (mutable indirection cells) containing\n\
  \    a value of type ['a]. "]

external ref : 'a -> ('a ref[@local_opt]) = "%makemutable"
[@@ocaml.doc " Return a fresh reference containing the given value. "]

external ( ! ) : ('a ref[@local_opt]) -> 'a = "%field0"
[@@ocaml.doc
  " [!r] returns the current contents of reference [r].\n\
  \    Equivalent to [fun r -> r.contents]. "]

external ( := ) : ('a ref[@local_opt]) -> 'a -> unit = "%setfield0"
[@@ocaml.doc
  " [r := a] stores the value of [a] in reference [r].\n\
  \    Equivalent to [fun r v -> r.contents <- v]. "]

external incr : (int ref[@local_opt]) -> unit = "%incr"
[@@ocaml.doc
  " Increment the integer contained in the given reference.\n\
  \    Equivalent to [fun r -> r := succ !r]. "]

external decr : (int ref[@local_opt]) -> unit = "%decr"
[@@ocaml.doc
  " Decrement the integer contained in the given reference.\n\
  \    Equivalent to [fun r -> r := pred !r]. "]

[@@@ocaml.text " Result type "]

type ('a, 'b) result = ('a, 'b) Stdlib.result =
  | Ok of 'a
  | Error of 'b

[@@@ocaml.text " {6 Operations on format strings} "]

[@@@ocaml.text
  " Format strings are character strings with special lexical conventions\n\
  \    that defines the functionality of formatted input/output functions. Format\n\
  \    strings are used to read data with formatted input functions from module\n\
  \    {!Scanf} and to print data with formatted output functions from modules\n\
  \    {!Printf} and {!Format}.\n\n\
  \    Format strings are made of three kinds of entities:\n\
  \    - {e conversions specifications}, introduced by the special character ['%']\n\
  \      followed by one or more characters specifying what kind of argument to\n\
  \      read or print,\n\
  \    - {e formatting indications}, introduced by the special character ['@']\n\
  \      followed by one or more characters specifying how to read or print the\n\
  \      argument,\n\
  \    - {e plain characters} that are regular characters with usual lexical\n\
  \      conventions. Plain characters specify string literals to be read in the\n\
  \      input or printed in the output.\n\n\
  \    There is an additional lexical rule to escape the special characters ['%']\n\
  \    and ['@'] in format strings: if a special character follows a ['%']\n\
  \    character, it is treated as a plain character. In other words, [\"%%\"] is\n\
  \    considered as a plain ['%'] and [\"%@\"] as a plain ['@'].\n\n\
  \    For more information about conversion specifications and formatting\n\
  \    indications available, read the documentation of modules {!Scanf},\n\
  \    {!Printf} and {!Format}.\n"]

type ('a, 'b, 'c, 'd, 'e, 'f) format6 =
  ('a, 'b, 'c, 'd, 'e, 'f) CamlinternalFormatBasics.format6
[@@ocaml.doc
  " Format strings have a general and highly polymorphic type\n\
  \    [('a, 'b, 'c, 'd, 'e, 'f) format6].\n\
  \    The two simplified types, [format] and [format4] below are\n\
  \    included for backward compatibility with earlier releases of\n\
  \    OCaml.\n\n\
  \    The meaning of format string type parameters is as follows:\n\n\
  \    - ['a] is the type of the parameters of the format for formatted output\n\
  \      functions ([printf]-style functions);\n\
  \      ['a] is the type of the values read by the format for formatted input\n\
  \      functions ([scanf]-style functions).\n\n\
  \    - ['b] is the type of input source for formatted input functions and the\n\
  \      type of output target for formatted output functions.\n\
  \      For [printf]-style functions from module [Printf], ['b] is typically\n\
  \      [out_channel];\n\
  \      for [printf]-style functions from module [Format], ['b] is typically\n\
  \      [Format.formatter];\n\
  \      for [scanf]-style functions from module [Scanf], ['b] is typically\n\
  \      [Scanf.Scanning.in_channel].\n\n\
  \    Type argument ['b] is also the type of the first argument given to\n\
  \    user's defined printing functions for [%a] and [%t] conversions,\n\
  \    and user's defined reading functions for [%r] conversion.\n\n\
  \    - ['c] is the type of the result of the [%a] and [%t] printing\n\
  \      functions, and also the type of the argument transmitted to the\n\
  \      first argument of [kprintf]-style functions or to the\n\
  \      [kscanf]-style functions.\n\n\
  \    - ['d] is the type of parameters for the [scanf]-style functions.\n\n\
  \    - ['e] is the type of the receiver function for the [scanf]-style functions.\n\n\
  \    - ['f] is the final result type of a formatted input/output function\n\
  \      invocation: for the [printf]-style functions, it is typically [unit];\n\
  \      for the [scanf]-style functions, it is typically the result type of the\n\
  \      receiver function.\n"]

type ('a, 'b, 'c, 'd) format4 = ('a, 'b, 'c, 'c, 'c, 'd) format6
type ('a, 'b, 'c) format = ('a, 'b, 'c, 'c) format4

val string_of_format : ('a, 'b, 'c, 'd, 'e, 'f) format6 -> string
[@@ocaml.doc " Converts a format string into a string. "]

external format_of_string
  :  (('a, 'b, 'c, 'd, 'e, 'f) format6[@local_opt])
  -> (('a, 'b, 'c, 'd, 'e, 'f) format6[@local_opt])
  = "%identity"
[@@ocaml.doc
  " [format_of_string s] returns a format string read from the string\n\
  \    literal [s].\n\
  \    Note: [format_of_string] can not convert a string argument that is not a\n\
  \    literal. If you need this functionality, use the more general\n\
  \    {!Scanf.format_from_string} function.\n"]

val ( ^^ )
  :  ('a, 'b, 'c, 'd, 'e, 'f) format6
  -> ('f, 'b, 'c, 'e, 'g, 'h) format6
  -> ('a, 'b, 'c, 'd, 'g, 'h) format6
[@@ocaml.doc
  " [f1 ^^ f2] catenates format strings [f1] and [f2]. The result is a\n\
  \    format string that behaves as the concatenation of format strings [f1] and\n\
  \    [f2]: in case of formatted output, it accepts arguments from [f1], then\n\
  \    arguments from [f2]; in case of formatted input, it returns results from\n\
  \    [f1], then results from [f2].\n"]

[@@@ocaml.text " {6 Program termination} "]

val exit : int -> 'a
[@@ocaml.doc
  " Terminate the process, returning the given status code\n\
  \    to the operating system: usually 0 to indicate no errors,\n\
  \    and a small positive integer to indicate failure.\n\
  \    All open output channels are flushed with [flush_all].\n\
  \    An implicit [exit 0] is performed each time a program\n\
  \    terminates normally.  An implicit [exit 2] is performed if the program\n\
  \    terminates early because of an uncaught exception. "]

val at_exit : (unit -> unit) -> unit
[@@ocaml.doc
  " Register the given function to be called at program\n\
  \    termination time. The functions registered with [at_exit]\n\
  \    will be called when the program executes {!Caml.exit},\n\
  \    or terminates, either normally or because of an uncaught exception.\n\
  \    The functions are called in 'last in, first out' order:\n\
  \    the function most recently added with [at_exit] is called first. "]

[@@@ocaml.text "/*"]

[@@@ocaml.text " The following is for system use only. Do not call directly. "]

val valid_float_lexem : string -> string [@@deprecated "[since 2015-11] Do not use."]

val unsafe_really_input : Stdlib.in_channel -> bytes -> int -> int -> unit
[@@deprecated "[since 2015-11] Do not use."]

val do_at_exit : unit -> unit [@@deprecated "[since 2015-11] Do not use."]
