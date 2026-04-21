let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"iobuf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "iobuf.ml.before-ppx"
;;

open! Core
module IR = Int_repr
open! Iobuf_intf

let unsafe_is_safe = true

module type Accessors_common = Accessors_common
module type Accessors_read = Accessors_read
module type Accessors_write = Accessors_write
module type Consuming_blit = Consuming_blit

type nonrec ('src, 'dst) consuming_blito = ('src, 'dst) consuming_blito

let arch_sixtyfour = Sys.word_size_in_bits = 64

module T = struct
  type t =
    { mutable buf : (Bigstring.t[@sexp.opaque])
    ; mutable lo_min : int
    ; mutable lo : int
    ; mutable hi : int
    ; mutable hi_max : int
    }
  [@@deriving
    fields ~getters ~direct_iterators:(iter, set_all_mutable_fields), globalize, sexp_of]

  include struct
    [@@@ocaml.warning "-60"]

    let _ = fun (_ : t) -> ()
    let hi_max _r__ = _r__.hi_max
    let _ = hi_max
    let set_hi_max _r__ v__ = _r__.hi_max <- v__
    let _ = set_hi_max
    let hi _r__ = _r__.hi
    let _ = hi
    let set_hi _r__ v__ = _r__.hi <- v__
    let _ = set_hi
    let lo _r__ = _r__.lo
    let _ = lo
    let set_lo _r__ v__ = _r__.lo <- v__
    let _ = set_lo
    let lo_min _r__ = _r__.lo_min
    let _ = lo_min
    let set_lo_min _r__ v__ = _r__.lo_min <- v__
    let _ = set_lo_min
    let buf _r__ = _r__.buf
    let _ = buf
    let set_buf _r__ v__ = _r__.buf <- v__
    let _ = set_buf

    module Fields = struct
      let hi_max =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "hi_max"
           ; getter = hi_max
           ; setter = Some set_hi_max
           ; fset = (fun _r__ v__ -> { _r__ with hi_max = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = hi_max

      let hi =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "hi"
           ; getter = hi
           ; setter = Some set_hi
           ; fset = (fun _r__ v__ -> { _r__ with hi = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = hi

      let lo =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "lo"
           ; getter = lo
           ; setter = Some set_lo
           ; fset = (fun _r__ v__ -> { _r__ with lo = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = lo

      let lo_min =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "lo_min"
           ; getter = lo_min
           ; setter = Some set_lo_min
           ; fset = (fun _r__ v__ -> { _r__ with lo_min = v__ })
           }
         : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
      ;;

      let _ = lo_min

      let buf =
        (Fieldslib.Field.Field
           { Fieldslib.Field.For_generated_code.force_variance =
               (fun (_ : [< `Read | `Set_and_create ]) -> ())
           ; name = "buf"
           ; getter = buf
           ; setter = Some set_buf
           ; fset = (fun _r__ v__ -> { _r__ with buf = v__ })
           }
         : ( [< `Read | `Set_and_create ]
             , _
             , (Bigstring.t[@sexp.opaque]) )
             Fieldslib.Field.t_with_perm)
      ;;

      let _ = buf

      module Direct = struct
        let iter
              record__
              ~buf:buf_fun__
              ~lo_min:lo_min_fun__
              ~lo:lo_fun__
              ~hi:hi_fun__
              ~hi_max:hi_max_fun__
          =
          buf_fun__ buf record__ record__.buf;
          lo_min_fun__ lo_min record__ record__.lo_min;
          lo_fun__ lo record__ record__.lo;
          hi_fun__ hi record__ record__.hi;
          hi_max_fun__ hi_max record__ record__.hi_max
        ;;

        let _ = iter

        let set_all_mutable_fields _record__ ~buf ~lo_min ~lo ~hi ~hi_max =
          let _record__ = Fieldslib.Field.For_generated_code.opaque_identity _record__ in
          _record__.buf <- buf;
          _record__.lo_min <- lo_min;
          _record__.lo <- lo;
          _record__.hi <- hi;
          _record__.hi_max <- hi_max
        [@@inline always]
        ;;

        let _ = set_all_mutable_fields
      end
    end

    let globalize : t -> t =
      (fun x__001_ ->
         let { buf = buf__006_
             ; lo_min = lo_min__005_
             ; lo = lo__004_
             ; hi = hi__003_
             ; hi_max = hi_max__002_
             }
           =
           x__001_
         in
         { buf = buf__006_
         ; lo_min = lo_min__005_
         ; lo = lo__004_
         ; hi = hi__003_
         ; hi_max = hi_max__002_
         }
       : t -> t)
    ;;

    let _ = globalize

    let sexp_of_t =
      (fun { buf = buf__008_
           ; lo_min = lo_min__010_
           ; lo = lo__012_
           ; hi = hi__014_
           ; hi_max = hi_max__016_
           } ->
         let bnds__007_ = ([] : _ Stdlib.List.t) in
         let bnds__007_ =
           let arg__017_ = sexp_of_int hi_max__016_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hi_max"; arg__017_ ] :: bnds__007_
            : _ Stdlib.List.t)
         in
         let bnds__007_ =
           let arg__015_ = sexp_of_int hi__014_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "hi"; arg__015_ ] :: bnds__007_
            : _ Stdlib.List.t)
         in
         let bnds__007_ =
           let arg__013_ = sexp_of_int lo__012_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "lo"; arg__013_ ] :: bnds__007_
            : _ Stdlib.List.t)
         in
         let bnds__007_ =
           let arg__011_ = sexp_of_int lo_min__010_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "lo_min"; arg__011_ ] :: bnds__007_
            : _ Stdlib.List.t)
         in
         let bnds__007_ =
           let arg__009_ = Sexplib0.Sexp_conv.sexp_of_opaque buf__008_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buf"; arg__009_ ] :: bnds__007_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List bnds__007_
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

open T

type t_repr = T.t [@@deriving globalize]

include struct
  let _ = fun (_ : t_repr) -> ()
  let globalize_t_repr : t_repr -> t_repr = (T.globalize : t_repr -> t_repr)
  let _ = globalize_t_repr
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type (-'read_write, +'seek) t = T.t [@@deriving sexp_of]

include struct
  let _ = fun (_ : ('read_write, 'seek) t) -> ()

  let sexp_of_t
    :  'read_write 'seek.
       ('read_write -> Sexplib0.Sexp.t)
    -> ('seek -> Sexplib0.Sexp.t)
    -> ('read_write, 'seek) t
    -> Sexplib0.Sexp.t
    =
    fun _of_read_write__019_ _of_seek__020_ -> T.sexp_of_t
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type (_, _) t_with_shallow_sexp = T.t [@@deriving sexp_of]

include struct
  let _ = fun (_ : (_, _) t_with_shallow_sexp) -> ()

  let sexp_of_t_with_shallow_sexp
    :  'a__021_ 'b__022_.
       ('a__021_ -> Sexplib0.Sexp.t)
    -> ('b__022_ -> Sexplib0.Sexp.t)
    -> ('a__021_, 'b__022_) t_with_shallow_sexp
    -> Sexplib0.Sexp.t
    =
    fun _of_a__023_ _of_b__024_ -> T.sexp_of_t
  ;;

  let _ = sexp_of_t_with_shallow_sexp
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type seek = Iobuf_intf.seek [@@deriving sexp_of]

include struct
  let _ = fun (_ : seek) -> ()
  let sexp_of_seek = (Iobuf_intf.sexp_of_seek : seek -> Sexplib0.Sexp.t)
  let _ = sexp_of_seek
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type no_seek = Iobuf_intf.no_seek [@@deriving sexp_of]

include struct
  let _ = fun (_ : no_seek) -> ()
  let sexp_of_no_seek = (Iobuf_intf.sexp_of_no_seek : no_seek -> Sexplib0.Sexp.t)
  let _ = sexp_of_no_seek
end [@@ocaml.doc "@inline"] [@@merlin.hide]

module type Bound = Iobuf_intf.Bound with type ('d, 'w) iobuf := ('d, 'w) t

let globalize _ _ t = globalize_t_repr t
let read_only t = t
let read_only_local t = t
let no_seek t = t
let no_seek_local t = t

let fail t message a sexp_of_a =
  Error.raise
    (Error.create
       message
       ( a
       , ((fun x__026_ ->
            sexp_of_t
              (fun _ -> Sexplib0.Sexp.Atom "_")
              (fun _ -> Sexplib0.Sexp.Atom "_")
              x__026_) [@merlin.hide])
           (globalize_t_repr t) )
       (Tuple.T2.sexp_of_t sexp_of_a Fn.id))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

module Lo_bound = struct
  let stale t iobuf =
    fail iobuf "Iobuf.Lo_bound.restore got stale snapshot" t (sexp_of_int [@merlin.hide])
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  type t = int [@@deriving compare, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__028_ b__029_ -> compare_int a__028_ b__029_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let window t = t.lo

  let restore t iobuf =
    if t < iobuf.lo_min || t > iobuf.hi then stale t iobuf;
    iobuf.lo <- t
  ;;

  let limit t = t.lo_min
end

module Hi_bound = struct
  let stale t iobuf =
    fail iobuf "Iobuf.Hi_bound.restore got stale snapshot" t (sexp_of_int [@merlin.hide])
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  type t = int [@@deriving compare, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__030_ b__031_ -> compare_int a__030_ b__031_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let window t = t.hi

  let restore t iobuf =
    if t > iobuf.hi_max || t < iobuf.lo then stale t iobuf;
    iobuf.hi <- t
  ;;

  let limit t = t.hi_max
end

let length t = t.hi - t.lo
let length_lo t = t.lo - t.lo_min
let length_hi t = t.hi_max - t.hi
let is_empty t = length t = 0
let rewind t = t.lo <- t.lo_min

let reset t =
  t.lo <- t.lo_min;
  t.hi <- t.hi_max
;;

let flip_lo t =
  t.hi <- t.lo;
  t.lo <- t.lo_min
;;

let bounded_flip_lo_stale t lo_min =
  fail
    t
    "Iobuf.bounded_flip_lo got stale snapshot"
    lo_min
    (Lo_bound.sexp_of_t [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let bounded_flip_lo t lo_min =
  if lo_min < t.lo_min || lo_min > t.lo
  then bounded_flip_lo_stale t lo_min
  else (
    t.hi <- t.lo;
    t.lo <- lo_min)
;;

let flip_hi t =
  t.lo <- t.hi;
  t.hi <- t.hi_max
;;

let bounded_flip_hi_stale t hi_max =
  fail
    t
    "Iobuf.bounded_flip_hi got stale snapshot"
    hi_max
    (Hi_bound.sexp_of_t [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let bounded_flip_hi t hi_max =
  if hi_max > t.hi_max || hi_max < t.hi
  then bounded_flip_hi_stale t hi_max
  else (
    t.lo <- t.hi;
    t.hi <- hi_max)
;;

let capacity t = t.hi_max - t.lo_min

let invariant _ _ t =
  try
    Fields.Direct.iter
      t
      ~buf:(fun _ _ _ -> ())
      ~lo_min:(fun _ _ lo_min ->
        assert (lo_min >= 0);
        assert (lo_min = t.hi_max - capacity t))
      ~hi_max:(fun _ _ hi_max ->
        assert (hi_max >= t.lo);
        assert (hi_max = t.lo_min + capacity t))
      ~lo:(fun _ _ lo ->
        assert (lo >= t.lo_min);
        assert (lo <= t.hi))
      ~hi:(fun _ _ hi ->
        assert (hi >= t.lo);
        assert (hi <= t.hi_max))
  with
  | e -> fail t "Iobuf.invariant failed" e (sexp_of_exn [@merlin.hide])
;;

let bad_range ~pos ~len t =
  fail
    t
    "Iobuf got invalid range"
    (`pos pos, `len len)
    ((fun (arg0__034_, arg1__035_) ->
       let res0__036_ =
         let (`pos v__032_) = arg0__034_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pos"; sexp_of_int v__032_ ]
       and res1__037_ =
         let (`len v__033_) = arg1__035_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "len"; sexp_of_int v__033_ ]
       in
       Sexplib0.Sexp.List [ res0__036_; res1__037_ ]) [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let bad_range_bstr ~pos ~len ~str_len =
  raise_s
    (let ppx_sexp_message () =
       Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "bad range relative to bigstring"
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "str_len"
             ; (sexp_of_int [@merlin.hide]) str_len
             ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "pos"; (sexp_of_int [@merlin.hide]) pos ]
         ; Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Sexp.Atom "len"; (sexp_of_int [@merlin.hide]) len ]
         ]
         [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
     in
     (ppx_sexp_message () [@nontail]))
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let check_range t ~pos ~len =
  if pos < 0 || len < 0 || len > length t - pos then bad_range ~pos ~len t
[@@inline always]
;;

let unsafe_bigstring_view ~pos ~len buf =
  let lo = pos in
  let hi = pos + len in
  { buf; lo_min = lo; lo; hi; hi_max = hi }
[@@inline always]
;;

let check_bigstring ~bstr ~pos ~len =
  let str_len = Bigstring.length bstr in
  if
    pos < 0
    || pos > str_len
    ||
    let max_len = str_len - pos in
    len < 0 || len > max_len
  then bad_range_bstr ~str_len ~pos ~len
[@@inline always]
;;

let bigstring_view ~pos ~len bstr =
  check_bigstring ~bstr ~pos ~len;
  unsafe_bigstring_view ~pos ~len bstr
;;

let of_bigstring_local ?pos ?len buf =
  let str_len = Bigstring.length buf in
  let pos =
    match pos with
    | None -> 0
    | Some pos ->
      if pos < 0 || pos > str_len
      then
        raise_s
          (Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Iobuf.of_bigstring got invalid pos"
             ; (sexp_of_int [@merlin.hide]) pos
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "str_len"
                 ; (sexp_of_int [@merlin.hide]) str_len
                 ]
             ]);
      pos
  in
  let len =
    match len with
    | None -> str_len - pos
    | Some len ->
      let max_len = str_len - pos in
      if len < 0 || len > max_len
      then
        raise_s
          (Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Iobuf.of_bigstring got invalid pos"
             ; (sexp_of_int [@merlin.hide]) len
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "max_len"
                 ; (sexp_of_int [@merlin.hide]) max_len
                 ]
             ]);
      len
  in
  unsafe_bigstring_view ~pos ~len buf
;;

let unsafe_bigstring_view =
  if unsafe_is_safe then bigstring_view else unsafe_bigstring_view
;;

let of_bigstring ?pos ?len buf =
  globalize_t_repr (of_bigstring_local ?pos ?len buf) [@nontail]
;;

let sub_shared_local ?(pos = 0) ?len t =
  let len =
    match len with
    | None -> length t - pos
    | Some len -> len
  in
  check_range t ~pos ~len;
  let lo = t.lo + pos in
  let hi = lo + len in
  { buf = t.buf; lo_min = lo; lo; hi; hi_max = hi }
;;

let sub_shared ?pos ?len t = globalize_t_repr (sub_shared_local ?pos ?len t) [@nontail]
let copy t = of_bigstring (Bigstring.sub t.buf ~pos:t.lo ~len:(length t))

let clone { buf; lo_min; lo; hi; hi_max } =
  { buf = Bigstring.copy buf; lo_min; lo; hi; hi_max }
;;

let set_bounds_and_buffer_sub ~pos ~len ~src ~dst =
  check_range src ~pos ~len;
  let lo = src.lo + pos in
  let hi = lo + len in
  dst.lo_min <- lo;
  dst.lo <- lo;
  dst.hi <- hi;
  dst.hi_max <- hi;
  if not (phys_equal dst.buf src.buf) then dst.buf <- src.buf
[@@inline]
;;

let set_bounds_and_buffer ~src ~dst =
  dst.lo_min <- src.lo_min;
  dst.lo <- src.lo;
  dst.hi <- src.hi;
  dst.hi_max <- src.hi_max;
  if not (phys_equal dst.buf src.buf) then dst.buf <- src.buf
;;

let narrow_lo t = t.lo_min <- t.lo
let narrow_hi t = t.hi_max <- t.hi

let narrow t =
  narrow_lo t;
  narrow_hi t
;;

let unsafe_resize t ~len = t.hi <- t.lo + len

let resize t ~len =
  if len < 0 then bad_range t ~len ~pos:0;
  let hi = t.lo + len in
  if hi > t.hi_max then bad_range t ~len ~pos:0;
  t.hi <- hi
[@@inline always]
;;

let unsafe_resize = if unsafe_is_safe then resize else unsafe_resize

let protect_window_bounds_and_buffer t ~f =
  let lo = t.lo in
  let hi = t.hi in
  let lo_min = t.lo_min in
  let hi_max = t.hi_max in
  let buf = t.buf in
  try
    t.lo_min <- lo;
    t.hi_max <- hi;
    let result = f t in
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    result
  with
  | exn ->
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    raise exn
;;

let protect_window_bounds_and_buffer_local t ~f =
  let lo = t.lo in
  let hi = t.hi in
  let lo_min = t.lo_min in
  let hi_max = t.hi_max in
  let buf = t.buf in
  try
    t.lo_min <- lo;
    t.hi_max <- hi;
    let result = f t in
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    result
  with
  | exn ->
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    raise exn
;;

let protect_window_bounds_and_buffer_1 t x ~f =
  let lo = t.lo in
  let hi = t.hi in
  let lo_min = t.lo_min in
  let hi_max = t.hi_max in
  let buf = t.buf in
  try
    t.lo_min <- lo;
    t.hi_max <- hi;
    let result = f t x in
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    result
  with
  | exn ->
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    raise exn
;;

let protect_window_bounds_and_buffer_2 t x y ~f =
  let lo = t.lo in
  let hi = t.hi in
  let lo_min = t.lo_min in
  let hi_max = t.hi_max in
  let buf = t.buf in
  try
    t.lo_min <- lo;
    t.hi_max <- hi;
    let result = f t x y in
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    result
  with
  | exn ->
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    raise exn
;;

let protect_window_bounds_and_buffer_3 t x y z ~f =
  let lo = t.lo in
  let hi = t.hi in
  let lo_min = t.lo_min in
  let hi_max = t.hi_max in
  let buf = t.buf in
  try
    t.lo_min <- lo;
    t.hi_max <- hi;
    let result = f t x y z in
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    result
  with
  | exn ->
    t.lo <- lo;
    t.hi <- hi;
    t.lo_min <- lo_min;
    t.hi_max <- hi_max;
    if not (phys_equal buf t.buf) then t.buf <- buf;
    raise exn
;;

let create ~len =
  if len < 0
  then
    raise_s
      (Ppx_sexp_conv_lib.Sexp.List
         [ Ppx_sexp_conv_lib.Conv.sexp_of_string "Iobuf.create got negative len"
         ; (sexp_of_int [@merlin.hide]) len
         ]);
  of_bigstring (Bigstring.create len)
;;

let empty = create ~len:0
let of_string s = of_bigstring (Bigstring.of_string s)
let of_bytes s = of_bigstring (Bigstring.of_bytes s)

let to_stringlike ~(convert : ?pos:int -> ?len:int -> Bigstring.t -> 'a) =
  stage (fun ?len t : 'a ->
    let len =
      match len with
      | Some len ->
        check_range t ~pos:0 ~len;
        len
      | None -> length t
    in
    convert t.buf ~pos:t.lo ~len)
;;

let to_string = unstage (to_stringlike ~convert:Bigstring.to_string)
let to_bytes = unstage (to_stringlike ~convert:Bigstring.to_bytes)
let unsafe_buf_pos t ~pos ~len:_ = t.lo + pos [@@inline always]

let buf_pos_exn t ~pos ~len =
  check_range t ~pos ~len;
  unsafe_buf_pos t ~pos ~len
[@@inline]
;;

let unsafe_buf_pos = if unsafe_is_safe then buf_pos_exn else unsafe_buf_pos
let unsafe_advance t n = t.lo <- t.lo + n

let advance t len =
  check_range t ~len ~pos:0;
  unsafe_advance t len
[@@inline always]
;;

let unsafe_advance = if unsafe_is_safe then advance else unsafe_advance

module Char_elt = struct
  include Char

  let of_bool = function
    | true -> '0'
    | false -> '1'
  ;;
end

let get_char t pos = Bigstring.unsafe_get t.buf (buf_pos_exn t ~len:1 ~pos) [@@inline]
let set_char t pos c = Bigstring.unsafe_set t.buf (buf_pos_exn t ~len:1 ~pos) c [@@inline]

module T_src = struct
  type t = T.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()
    let sexp_of_t = (T.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let create = create
  let length = length
  let get t pos = get_char t pos
  let set t pos c = set_char t pos c
end

module Bytes_dst = struct
  include Bytes

  let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
    let blit =
      if unsafe_is_safe then Bigstring.To_bytes.blit else Bigstring.To_bytes.unsafe_blit
    in
    blit ~src:src.buf ~src_pos:(unsafe_buf_pos src ~pos:src_pos ~len) ~dst ~dst_pos ~len
  ;;

  let create ~len = create len
end

module String_dst = struct
  let sub src ~pos ~len =
    Bigstring.To_string.sub src.buf ~pos:(buf_pos_exn src ~pos ~len) ~len
  ;;

  let subo ?(pos = 0) ?len src =
    let len =
      match len with
      | None -> length src - pos
      | Some len -> len
    in
    Bigstring.To_string.subo src.buf ~pos:(buf_pos_exn src ~pos ~len) ~len
  ;;
end

module Bigstring_dst = struct
  include Bigstring

  let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
    let blit = if unsafe_is_safe then Bigstring.blit else Bigstring.unsafe_blit in
    blit ~src:src.buf ~src_pos:(unsafe_buf_pos src ~pos:src_pos ~len) ~dst ~dst_pos ~len
  ;;

  let create ~len = create len
end

let compact t =
  let len = t.hi - t.lo in
  Bigstring.blit ~src:t.buf ~src_pos:t.lo ~len ~dst:t.buf ~dst_pos:t.lo_min;
  t.lo <- t.lo_min + len;
  t.hi <- t.hi_max
;;

let bounded_compact_stale t lo_min hi_max =
  fail
    t
    "Iobuf.bounded_compact got stale snapshot"
    (lo_min, hi_max)
    ((fun (arg0__040_, arg1__041_) ->
       let res0__042_ = Lo_bound.sexp_of_t arg0__040_
       and res1__043_ = Hi_bound.sexp_of_t arg1__041_ in
       Sexplib0.Sexp.List [ res0__042_; res1__043_ ]) [@merlin.hide])
[@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
;;

let bounded_compact t lo_min hi_max =
  let len = t.hi - t.lo in
  if hi_max > t.hi_max || hi_max < lo_min + len || lo_min < t.lo_min
  then bounded_compact_stale t lo_min hi_max
  else (
    Bigstring.blit ~src:t.buf ~src_pos:t.lo ~len ~dst:t.buf ~dst_pos:lo_min;
    t.lo <- lo_min + len;
    t.hi <- hi_max)
;;

let read_bin_prot reader t ~pos =
  let buf_pos = unsafe_buf_pos t ~pos ~len:0 in
  let pos_ref = ref buf_pos in
  let a = reader.Bin_prot.Type_class.read t.buf ~pos_ref in
  let len = !pos_ref - buf_pos in
  check_range t ~pos ~len;
  a, len
;;

module Consume = struct
  type src = (read, seek) t

  module To (Dst : sig
      type t [@@deriving sexp_of]

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val create : len:int -> t
      val length : t -> int
      val get : t -> int -> char
      val set : t -> int -> char -> unit
      val unsafe_blit : (T.t, t) Blit.blit
    end) =
  struct
    include Base_for_tests.Test_blit.Make_distinct_and_test (Char_elt) (T_src) (Dst)

    let unsafe_blit ~src ~dst ~dst_pos ~len =
      let blit = if unsafe_is_safe then blit else unsafe_blit in
      blit ~src ~src_pos:0 ~dst ~dst_pos ~len;
      unsafe_advance src len
    ;;

    let blit ~src ~dst ~dst_pos ~len =
      blit ~src ~src_pos:0 ~dst ~dst_pos ~len;
      unsafe_advance src len
    ;;

    let blito ~src ?(src_len = length src) ~dst ?dst_pos () =
      blito ~src ~src_pos:0 ~src_len ~dst ?dst_pos ();
      unsafe_advance src src_len
    ;;

    let sub src ~len =
      let dst = sub src ~pos:0 ~len in
      unsafe_advance src len;
      dst
    ;;

    let subo ?len src =
      let len =
        match len with
        | None -> length src
        | Some len -> len
      in
      let dst = subo ~pos:0 ~len src in
      unsafe_advance src len;
      dst
    ;;
  end

  module To_bytes = To (Bytes_dst)
  module To_bigstring = To (Bigstring_dst)

  module To_string = struct
    let sub src ~len =
      let dst = String_dst.sub src ~len ~pos:0 in
      unsafe_advance src len;
      dst
    ;;

    let subo ?len src =
      let len =
        match len with
        | None -> length src
        | Some len -> len
      in
      let dst = String_dst.subo ~pos:0 ~len src in
      unsafe_advance src len;
      dst
    ;;
  end

  type nonrec ('a, 'd, 'w) t_local = ('d, seek) t -> 'a constraint 'd = [> read ]
  type nonrec ('a, 'd, 'w) t = ('d, seek) t -> 'a constraint 'd = [> read ]

  let uadv t n x =
    unsafe_advance t n;
    x
  [@@inline always]
  ;;

  let uadv_local t n x =
    unsafe_advance t n;
    x
  [@@inline always]
  ;;

  let pos t len = buf_pos_exn t ~pos:0 ~len

  let tail_padded_fixed_string ~padding ~len t =
    uadv
      t
      len
      (Bigstring.get_tail_padded_fixed_string t.buf ~pos:(pos t len) ~padding ~len ())
  ;;

  let head_padded_fixed_string ~padding ~len t =
    uadv
      t
      len
      (Bigstring.get_head_padded_fixed_string t.buf ~pos:(pos t len) ~padding ~len ())
  ;;

  let bytes ~str_pos ~len t =
    let dst = Bytes.create (len + str_pos) in
    To_bytes.blit ~src:t ~dst ~len ~dst_pos:str_pos;
    dst
  ;;

  let string ~str_pos ~len t =
    Bytes.unsafe_to_string ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t)
  ;;

  let bigstring ~str_pos ~len t =
    let dst = Bigstring.create (len + str_pos) in
    To_bigstring.blit ~src:t ~dst ~len ~dst_pos:str_pos;
    dst
  ;;

  let byteso ?(str_pos = 0) ?len t =
    bytes
      t
      ~str_pos
      ~len:
        (match len with
         | None -> length t
         | Some len -> len)
  ;;

  let stringo ?(str_pos = 0) ?len t =
    string
      t
      ~str_pos
      ~len:
        (match len with
         | None -> length t
         | Some len -> len)
  ;;

  let bigstringo ?(str_pos = 0) ?len t =
    bigstring
      t
      ~str_pos
      ~len:
        (match len with
         | None -> length t
         | Some len -> len)
  ;;

  let bin_prot reader t =
    let a, len = read_bin_prot reader t ~pos:0 in
    uadv t len a
  ;;

  module Local = struct
    let tail_padded_fixed_string ~padding ~len t =
      uadv_local
        t
        len
        (Bigstring.get_tail_padded_fixed_string_local
           t.buf
           ~pos:(pos t len)
           ~padding
           ~len
           ())
    ;;

    let head_padded_fixed_string ~padding ~len t =
      uadv_local
        t
        len
        (Bigstring.get_head_padded_fixed_string_local
           t.buf
           ~pos:(pos t len)
           ~padding
           ~len
           ())
    ;;

    let bytes ~str_pos ~len t =
      let dst = Bytes.create_local (len + str_pos) in
      To_bytes.blit ~src:t ~dst ~len ~dst_pos:str_pos;
      dst
    ;;

    let string ~str_pos ~len t =
      Bytes.unsafe_to_string ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t)
    ;;

    let byteso ?(str_pos = 0) ?len t =
      bytes
        t
        ~str_pos
        ~len:
          (match len with
           | None -> length t
           | Some len -> len)
    ;;

    let stringo ?(str_pos = 0) ?len t =
      string
        t
        ~str_pos
        ~len:
          (match len with
           | None -> length t
           | Some len -> len)
    ;;

    open Bigstring

    let len = 8

    let int64_t_be t =
      uadv_local t len (Local.unsafe_get_int64_t_be t.buf ~pos:(pos t len)) [@nontail]
    [@@inline always]
    ;;

    let int64_t_le t =
      uadv_local t len (Local.unsafe_get_int64_t_le t.buf ~pos:(pos t len)) [@nontail]
    [@@inline always]
    ;;
  end

  open Bigstring

  let len = 1
  let char t = uadv t len (Bigstring.unsafe_get t.buf (pos t len)) [@@inline always]
  let uint8 t = uadv t len (unsafe_get_uint8 t.buf ~pos:(pos t len)) [@@inline always]
  let int8 t = uadv t len (unsafe_get_int8 t.buf ~pos:(pos t len)) [@@inline always]
  let len = 2

  let int16_be t = uadv t len (unsafe_get_int16_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int16_le t = uadv t len (unsafe_get_int16_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint16_be t = uadv t len (unsafe_get_uint16_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint16_le t = uadv t len (unsafe_get_uint16_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let len = 4

  let int32_be t = uadv t len (unsafe_get_int32_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int32_t_be t = uadv t len (unsafe_get_int32_t_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int32_le t = uadv t len (unsafe_get_int32_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int32_t_le t = uadv t len (unsafe_get_int32_t_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint32_be t = uadv t len (unsafe_get_uint32_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint32_le t = uadv t len (unsafe_get_uint32_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let len = 8

  let int64_be_exn t = uadv t len (unsafe_get_int64_be_exn t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int64_le_exn t = uadv t len (unsafe_get_int64_le_exn t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint64_be_exn t = uadv t len (unsafe_get_uint64_be_exn t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let uint64_le_exn t = uadv t len (unsafe_get_uint64_le_exn t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int64_t_be t = uadv t len (unsafe_get_int64_t_be t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int64_t_le t = uadv t len (unsafe_get_int64_t_le t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int64_be_trunc t = uadv t len (unsafe_get_int64_be_trunc t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  let int64_le_trunc t = uadv t len (unsafe_get_int64_le_trunc t.buf ~pos:(pos t len))
  [@@inline always]
  ;;

  module Int_repr = struct
    let uint8 t = IR.Uint8.of_base_int_trunc (uint8 t) [@@inline always]
    let uint16_be t = IR.Uint16.of_base_int_trunc (uint16_be t) [@@inline always]
    let uint16_le t = IR.Uint16.of_base_int_trunc (uint16_le t) [@@inline always]
    let uint32_be t = IR.Uint32.of_base_int32_trunc (int32_t_be t) [@@inline always]
    let uint32_le t = IR.Uint32.of_base_int32_trunc (int32_t_le t) [@@inline always]
    let uint64_be t = IR.Uint64.of_base_int64_trunc (int64_t_be t) [@@inline always]
    let uint64_le t = IR.Uint64.of_base_int64_trunc (int64_t_le t) [@@inline always]
    let int8 t = IR.Int8.of_base_int_trunc (int8 t) [@@inline always]
    let int16_be t = IR.Int16.of_base_int_trunc (int16_be t) [@@inline always]
    let int16_le t = IR.Int16.of_base_int_trunc (int16_le t) [@@inline always]
    let int32_be t = IR.Int32.of_base_int32 (int32_t_be t) [@@inline always]
    let int32_le t = IR.Int32.of_base_int32 (int32_t_le t) [@@inline always]
    let int64_be t = int64_t_be t [@@inline always]
    let int64_le t = int64_t_le t [@@inline always]
  end
end

let write_bin_prot writer t ~pos a =
  let len = writer.Bin_prot.Type_class.size a in
  let buf_pos = buf_pos_exn t ~pos ~len in
  let stop_pos = writer.Bin_prot.Type_class.write t.buf ~pos:buf_pos a in
  if stop_pos - buf_pos = len
  then len
  else
    fail
      t
      "Iobuf.write_bin_prot got unexpected number of bytes written (Bin_prot bug: \
       Type_class.write disagrees with .size)"
      (`size_len len, `buf_pos buf_pos, `write_stop_pos stop_pos)
      ((fun (arg0__047_, arg1__048_, arg2__049_) ->
         let res0__050_ =
           let (`size_len v__044_) = arg0__047_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "size_len"; sexp_of_int v__044_ ]
         and res1__051_ =
           let (`buf_pos v__045_) = arg1__048_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buf_pos"; sexp_of_int v__045_ ]
         and res2__052_ =
           let (`write_stop_pos v__046_) = arg2__049_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "write_stop_pos"; sexp_of_int v__046_ ]
         in
         Sexplib0.Sexp.List [ res0__050_; res1__051_; res2__052_ ]) [@merlin.hide])
;;

let write_bin_prot_local sizer writer t ~pos a =
  let len = sizer a in
  let buf_pos = buf_pos_exn t ~pos ~len in
  let stop_pos = writer t.buf ~pos:buf_pos a in
  if stop_pos - buf_pos = len
  then len
  else
    fail
      t
      "Iobuf.write_bin_prot_local got unexpected number of bytes written (Bin_prot bug: \
       writer disagrees with sizer)"
      (`size_len len, `buf_pos buf_pos, `write_stop_pos stop_pos)
      ((fun (arg0__056_, arg1__057_, arg2__058_) ->
         let res0__059_ =
           let (`size_len v__053_) = arg0__056_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "size_len"; sexp_of_int v__053_ ]
         and res1__060_ =
           let (`buf_pos v__054_) = arg1__057_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "buf_pos"; sexp_of_int v__054_ ]
         and res2__061_ =
           let (`write_stop_pos v__055_) = arg2__058_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "write_stop_pos"; sexp_of_int v__055_ ]
         in
         Sexplib0.Sexp.List [ res0__059_; res1__060_; res2__061_ ]) [@merlin.hide])
;;

module Itoa = struct
  let num_digits_neg x =
    if x > -10
    then 1
    else if x > -100
    then 2
    else if x > -1000
    then 3
    else if x > -10000
    then 4
    else if x > -100000
    then 5
    else if x > -1000000
    then 6
    else if x > -10000000
    then 7
    else if x > -100000000
    then 8
    else if x > -1000000000
    then 9
    else if arch_sixtyfour
    then
      if x > -1000000000 * 10
      then 10
      else if x > -1000000000 * 100
      then 11
      else if x > -1000000000 * 1000
      then 12
      else if x > -1000000000 * 10000
      then 13
      else if x > -1000000000 * 100000
      then 14
      else if x > -1000000000 * 1000000
      then 15
      else if x > -1000000000 * 10000000
      then 16
      else if x > -1000000000 * 100000000
      then 17
      else if x > -1000000000 * 1000000000
      then 18
      else 19
    else 10
  ;;

  let num_digits x = if x < 0 then num_digits_neg x else num_digits_neg (-x)
  let min_len x = Bool.to_int (x < 0) + num_digits x
  let () = assert (String.length (Int.to_string Int.min_value) <= 19 + 1)

  let unsafe_poke_negative_decimal_without_sign buf ~pos ~len int =
    let int = ref int in
    for pos = pos + len - 1 downto pos do
      let x = !int in
      int := !int / 10;
      Bigstring.unsafe_set buf pos (Char.unsafe_of_int (48 + (-x + (!int * 10))))
    done
  ;;

  let unsafe_poke_negative_decimal buf ~pos ~len int =
    Bigstring.unsafe_set buf pos '-';
    unsafe_poke_negative_decimal_without_sign buf ~pos:(pos + 1) ~len:(len - 1) int
  ;;

  let gen_poke_padded_decimal_trunc ~buf_pos t ~pos ~len int =
    let pos = (buf_pos [@inlined hint]) t ~pos ~len in
    if int < 0
    then unsafe_poke_negative_decimal t.buf ~pos ~len int
    else unsafe_poke_negative_decimal_without_sign t.buf ~pos ~len (-int)
  [@@inline]
  ;;

  let poke_padded_decimal_trunc t ~pos ~len int =
    (gen_poke_padded_decimal_trunc [@inlined hint]) ~buf_pos:buf_pos_exn t ~pos ~len int
  ;;

  let unsafe_poke_padded_decimal_trunc t ~pos ~len int =
    (gen_poke_padded_decimal_trunc [@inlined hint])
      ~buf_pos:unsafe_buf_pos
      t
      ~pos
      ~len
      int
  ;;

  let gen_poke_padded_decimal ~poke_padded_decimal_trunc t ~pos ~len int =
    let len = max len (min_len int) in
    (poke_padded_decimal_trunc [@inlined hint]) t ~pos ~len int;
    len
  [@@inline]
  ;;

  let poke_padded_decimal t ~pos ~len int =
    (gen_poke_padded_decimal [@inlined hint]) ~poke_padded_decimal_trunc t ~pos ~len int
  ;;

  let unsafe_poke_padded_decimal t ~pos ~len int =
    (gen_poke_padded_decimal [@inlined hint])
      ~poke_padded_decimal_trunc:unsafe_poke_padded_decimal_trunc
      t
      ~pos
      ~len
      int
  ;;

  let gen_poke_decimal ~poke_padded_decimal_trunc t ~pos int =
    let len = min_len int in
    (poke_padded_decimal_trunc [@inlined hint]) t ~pos ~len int;
    len
  [@@inline]
  ;;

  let poke_decimal t ~pos int =
    (gen_poke_decimal [@inlined hint]) ~poke_padded_decimal_trunc t ~pos int
  ;;

  let unsafe_poke_decimal t ~pos int =
    (gen_poke_decimal [@inlined hint])
      ~poke_padded_decimal_trunc:unsafe_poke_padded_decimal_trunc
      t
      ~pos
      int
  ;;
end

module Date_string = struct
  let len_iso8601_extended = 10

  let gen_poke_iso8601_extended ~buf_pos t ~pos date =
    let pos = (buf_pos [@inlined hint]) t ~pos ~len:len_iso8601_extended in
    Itoa.unsafe_poke_negative_decimal_without_sign t.buf ~pos ~len:4 (-Date.year date);
    let pos = pos + 4 in
    Itoa.unsafe_poke_negative_decimal t.buf ~pos ~len:3 (-Month.to_int (Date.month date));
    let pos = pos + 3 in
    Itoa.unsafe_poke_negative_decimal t.buf ~pos ~len:3 (-Date.day date)
  [@@inline]
  ;;

  let poke_iso8601_extended t ~pos date =
    (gen_poke_iso8601_extended [@inlined hint]) ~buf_pos:buf_pos_exn t ~pos date
  ;;

  let unsafe_poke_iso8601_extended t ~pos date =
    (gen_poke_iso8601_extended [@inlined hint]) ~buf_pos:unsafe_buf_pos t ~pos date
  ;;
end

module Fill = struct
  type nonrec ('a, 'd, 'w) t_local = (read_write, seek) t -> 'a -> unit
    constraint 'd = [> read ]

  type nonrec ('a, 'd, 'w) t = (read_write, seek) t -> 'a -> unit
    constraint 'd = [> read ]

  let pos t len = buf_pos_exn t ~pos:0 ~len [@@inline]
  let uadv = unsafe_advance

  let tail_padded_fixed_string ~padding ~len t src =
    Bigstring.set_tail_padded_fixed_string ~padding ~len t.buf ~pos:(pos t len) src;
    uadv t len
  ;;

  let head_padded_fixed_string ~padding ~len t src =
    Bigstring.set_head_padded_fixed_string ~padding ~len t.buf ~pos:(pos t len) src;
    uadv t len
  ;;

  let bytes ~str_pos ~len t src =
    Bigstring.From_bytes.blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(pos t len);
    uadv t len
  ;;

  let string ~str_pos ~len t src =
    Bigstring.From_string.blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(pos t len);
    uadv t len
  ;;

  let bigstring ~str_pos ~len t src =
    Bigstring.blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(pos t len);
    uadv t len
  ;;

  let byteso ?(str_pos = 0) ?len t src =
    bytes
      t
      src
      ~str_pos
      ~len:
        (match len with
         | None -> Bytes.length src - str_pos
         | Some len -> len)
  ;;

  let stringo ?(str_pos = 0) ?len t src =
    string
      t
      src
      ~str_pos
      ~len:
        (match len with
         | None -> String.length src - str_pos
         | Some len -> len)
  ;;

  let bigstringo ?(str_pos = 0) ?len t src =
    bigstring
      t
      src
      ~str_pos
      ~len:
        (match len with
         | None -> Bigstring.length src - str_pos
         | Some len -> len)
  ;;

  let bin_prot writer t a = uadv t (write_bin_prot writer t ~pos:0 a)

  let bin_prot_local sizer writer t a =
    uadv t (write_bin_prot_local sizer writer t ~pos:0 a)
  ;;

  open Bigstring

  let len = 1

  let char t c =
    Bigstring.unsafe_set t.buf (pos t len) c;
    uadv t len
  [@@inline always]
  ;;

  let uint8_trunc t i =
    unsafe_set_uint8 t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int8_trunc t i =
    unsafe_set_int8 t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let len = 2

  let int16_be_trunc t i =
    unsafe_set_int16_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int16_le_trunc t i =
    unsafe_set_int16_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint16_be_trunc t i =
    unsafe_set_uint16_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint16_le_trunc t i =
    unsafe_set_uint16_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let len = 4

  let int32_be_trunc t i =
    unsafe_set_int32_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int32_t_be t i =
    unsafe_set_int32_t_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int32_le_trunc t i =
    unsafe_set_int32_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int32_t_le t i =
    unsafe_set_int32_t_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint32_be_trunc t i =
    unsafe_set_uint32_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint32_le_trunc t i =
    unsafe_set_uint32_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let len = 8

  let int64_be t i =
    unsafe_set_int64_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int64_le t i =
    unsafe_set_int64_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint64_be_trunc t i =
    unsafe_set_uint64_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let uint64_le_trunc t i =
    unsafe_set_uint64_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int64_t_be t i =
    unsafe_set_int64_t_be t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let int64_t_le t i =
    unsafe_set_int64_t_le t.buf i ~pos:(pos t len);
    uadv t len
  [@@inline always]
  ;;

  let decimal t i = uadv t (Itoa.poke_decimal t ~pos:0 i)
  let padded_decimal ~len t i = uadv t (Itoa.poke_padded_decimal t ~pos:0 ~len i)

  let date_string_iso8601_extended t date =
    Date_string.poke_iso8601_extended t ~pos:0 date;
    uadv t Date_string.len_iso8601_extended
  ;;

  module Int_repr = struct
    let uint8 t i = uint8_trunc t (IR.Uint8.to_base_int i) [@@inline always]
    let uint16_be t i = uint16_be_trunc t (IR.Uint16.to_base_int i) [@@inline always]
    let uint16_le t i = uint16_le_trunc t (IR.Uint16.to_base_int i) [@@inline always]
    let uint32_be t i = int32_t_be t (IR.Uint32.to_base_int32_trunc i) [@@inline always]
    let uint32_le t i = int32_t_le t (IR.Uint32.to_base_int32_trunc i) [@@inline always]
    let uint64_be t i = int64_t_be t (IR.Uint64.to_base_int64_trunc i) [@@inline always]
    let uint64_le t i = int64_t_le t (IR.Uint64.to_base_int64_trunc i) [@@inline always]
    let int8 t i = int8_trunc t (IR.Int8.to_base_int i) [@@inline always]
    let int16_be t i = int16_be_trunc t (IR.Int16.to_base_int i) [@@inline always]
    let int16_le t i = int16_le_trunc t (IR.Int16.to_base_int i) [@@inline always]
    let int32_be t i = int32_t_be t (IR.Int32.to_base_int32 i) [@@inline always]
    let int32_le t i = int32_t_le t (IR.Int32.to_base_int32 i) [@@inline always]
    let int64_be t i = int64_t_be t i [@@inline always]
    let int64_le t i = int64_t_le t i [@@inline always]
  end
end

module Peek = struct
  type 'seek src = (read, 'seek) t

  module To_bytes =
    Base_for_tests.Test_blit.Make_distinct_and_test (Char_elt) (T_src) (Bytes_dst)

  module To_bigstring =
    Base_for_tests.Test_blit.Make_distinct_and_test (Char_elt) (T_src) (Bigstring_dst)

  module To_string = String_dst

  type nonrec ('a, 'd, 'w) t_local = ('d, 'w) t -> pos:int -> 'a constraint 'd = [> read ]
  type nonrec ('a, 'd, 'w) t = ('d, 'w) t -> pos:int -> 'a constraint 'd = [> read ]

  let spos = buf_pos_exn

  let tail_padded_fixed_string ~padding ~len t ~pos =
    Bigstring.get_tail_padded_fixed_string t.buf ~padding ~len ~pos:(spos t ~len ~pos) ()
  ;;

  let head_padded_fixed_string ~padding ~len t ~pos =
    Bigstring.get_head_padded_fixed_string t.buf ~padding ~len ~pos:(spos t ~len ~pos) ()
  ;;

  let bytes ~str_pos ~len t ~pos =
    let dst = Bytes.create (len + str_pos) in
    Bigstring.To_bytes.blit
      ~src:t.buf
      ~src_pos:(spos t ~len ~pos)
      ~len
      ~dst
      ~dst_pos:str_pos;
    dst
  ;;

  let string ~str_pos ~len t ~pos =
    Bytes.unsafe_to_string
      ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t ~pos)
  ;;

  let bigstring ~str_pos ~len t ~pos =
    let dst = Bigstring.create (len + str_pos) in
    Bigstring.blit ~src:t.buf ~src_pos:(spos t ~len ~pos) ~len ~dst ~dst_pos:str_pos;
    dst
  ;;

  let byteso ?(str_pos = 0) ?len t ~pos =
    bytes
      t
      ~pos
      ~str_pos
      ~len:
        (match len with
         | None -> length t - pos
         | Some len -> len)
  ;;

  let stringo ?(str_pos = 0) ?len t ~pos =
    string
      t
      ~pos
      ~str_pos
      ~len:
        (match len with
         | None -> length t - pos
         | Some len -> len)
  ;;

  let bigstringo ?(str_pos = 0) ?len t ~pos =
    bigstring
      t
      ~pos
      ~str_pos
      ~len:
        (match len with
         | None -> length t - pos
         | Some len -> len)
  ;;

  let bin_prot reader t ~pos = fst (read_bin_prot reader t ~pos)

  let index t ?(pos = 0) ?(len = length t - pos) c =
    let pos = spos t ~len ~pos in
    (Option.map (Bigstring.find ~pos ~len c t.buf) ~f:(fun x -> x - t.lo) [@nontail])
  ;;

  module Local = struct
    let tail_padded_fixed_string ~padding ~len t ~pos =
      Bigstring.get_tail_padded_fixed_string_local
        t.buf
        ~padding
        ~len
        ~pos:(spos t ~len ~pos)
        ()
    ;;

    let head_padded_fixed_string ~padding ~len t ~pos =
      Bigstring.get_head_padded_fixed_string_local
        t.buf
        ~padding
        ~len
        ~pos:(spos t ~len ~pos)
        ()
    ;;

    let bytes ~str_pos ~len t ~pos =
      let dst = Bytes.create_local (len + str_pos) in
      Bigstring.To_bytes.blit
        ~src:t.buf
        ~src_pos:(spos t ~len ~pos)
        ~len
        ~dst
        ~dst_pos:str_pos;
      dst
    ;;

    let string ~str_pos ~len t ~pos =
      Bytes.unsafe_to_string
        ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t ~pos)
    ;;

    let byteso ?(str_pos = 0) ?len t ~pos =
      bytes
        t
        ~pos
        ~str_pos
        ~len:
          (match len with
           | None -> length t - pos
           | Some len -> len)
    ;;

    let stringo ?(str_pos = 0) ?len t ~pos =
      string
        t
        ~pos
        ~str_pos
        ~len:
          (match len with
           | None -> length t - pos
           | Some len -> len)
    ;;

    open Bigstring

    let len = 8

    let int64_t_be t ~pos =
      Local.unsafe_get_int64_t_be t.buf ~pos:(spos t ~len ~pos) [@nontail]
    [@@inline always]
    ;;

    let int64_t_le t ~pos =
      Local.unsafe_get_int64_t_le t.buf ~pos:(spos t ~len ~pos) [@nontail]
    [@@inline always]
    ;;
  end

  open Bigstring

  let char t ~pos = get_char t pos [@@inline always]
  let len = 1
  let uint8 t ~pos = unsafe_get_uint8 t.buf ~pos:(spos t ~len ~pos) [@@inline always]
  let int8 t ~pos = unsafe_get_int8 t.buf ~pos:(spos t ~len ~pos) [@@inline always]
  let len = 2

  let int16_be t ~pos = unsafe_get_int16_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int16_le t ~pos = unsafe_get_int16_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint16_be t ~pos = unsafe_get_uint16_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint16_le t ~pos = unsafe_get_uint16_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let len = 4

  let int32_be t ~pos = unsafe_get_int32_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int32_t_be t ~pos = unsafe_get_int32_t_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int32_le t ~pos = unsafe_get_int32_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int32_t_le t ~pos = unsafe_get_int32_t_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint32_be t ~pos = unsafe_get_uint32_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint32_le t ~pos = unsafe_get_uint32_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let len = 8

  let int64_be_exn t ~pos = unsafe_get_int64_be_exn t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int64_le_exn t ~pos = unsafe_get_int64_le_exn t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint64_be_exn t ~pos = unsafe_get_uint64_be_exn t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let uint64_le_exn t ~pos = unsafe_get_uint64_le_exn t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int64_t_be t ~pos = unsafe_get_int64_t_be t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int64_t_le t ~pos = unsafe_get_int64_t_le t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int64_be_trunc t ~pos = unsafe_get_int64_be_trunc t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  let int64_le_trunc t ~pos = unsafe_get_int64_le_trunc t.buf ~pos:(spos t ~len ~pos)
  [@@inline always]
  ;;

  module Int_repr = struct
    let uint8 t ~pos = IR.Uint8.of_base_int_trunc (uint8 t ~pos) [@@inline always]

    let uint16_be t ~pos = IR.Uint16.of_base_int_trunc (uint16_be t ~pos)
    [@@inline always]
    ;;

    let uint16_le t ~pos = IR.Uint16.of_base_int_trunc (uint16_le t ~pos)
    [@@inline always]
    ;;

    let uint32_be t ~pos = IR.Uint32.of_base_int32_trunc (int32_t_be t ~pos)
    [@@inline always]
    ;;

    let uint32_le t ~pos = IR.Uint32.of_base_int32_trunc (int32_t_le t ~pos)
    [@@inline always]
    ;;

    let uint64_be t ~pos = IR.Uint64.of_base_int64_trunc (int64_t_be t ~pos)
    [@@inline always]
    ;;

    let uint64_le t ~pos = IR.Uint64.of_base_int64_trunc (int64_t_le t ~pos)
    [@@inline always]
    ;;

    let int8 t ~pos = IR.Int8.of_base_int_trunc (int8 t ~pos) [@@inline always]
    let int16_be t ~pos = IR.Int16.of_base_int_trunc (int16_be t ~pos) [@@inline always]
    let int16_le t ~pos = IR.Int16.of_base_int_trunc (int16_le t ~pos) [@@inline always]
    let int32_be t ~pos = IR.Int32.of_base_int32 (int32_t_be t ~pos) [@@inline always]
    let int32_le t ~pos = IR.Int32.of_base_int32 (int32_t_le t ~pos) [@@inline always]
    let int64_be t ~pos = int64_t_be t ~pos [@@inline always]
    let int64_le t ~pos = int64_t_le t ~pos [@@inline always]
  end
end

module Poke = struct
  type nonrec ('a, 'd, 'w) t_local = (read_write, 'w) t -> pos:int -> 'a -> unit
    constraint 'd = [> read ]

  type nonrec ('a, 'd, 'w) t = (read_write, 'w) t -> pos:int -> 'a -> unit
    constraint 'd = [> read ]

  let spos = buf_pos_exn

  let tail_padded_fixed_string ~padding ~len t ~pos src =
    Bigstring.set_tail_padded_fixed_string ~padding ~len t.buf ~pos:(spos t ~len ~pos) src
  ;;

  let head_padded_fixed_string ~padding ~len t ~pos src =
    Bigstring.set_head_padded_fixed_string ~padding ~len t.buf ~pos:(spos t ~len ~pos) src
  ;;

  let bytes ~str_pos ~len t ~pos src =
    Bigstring.From_bytes.blit
      ~src
      ~src_pos:str_pos
      ~len
      ~dst:t.buf
      ~dst_pos:(spos t ~len ~pos)
  ;;

  let string ~str_pos ~len t ~pos src =
    Bigstring.From_string.blit
      ~src
      ~src_pos:str_pos
      ~len
      ~dst:t.buf
      ~dst_pos:(spos t ~len ~pos)
  ;;

  let bigstring ~str_pos ~len t ~pos src =
    Bigstring.blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(spos t ~len ~pos)
  ;;

  let byteso ?(str_pos = 0) ?len t ~pos src =
    bytes
      t
      ~str_pos
      ~pos
      src
      ~len:
        (match len with
         | None -> Bytes.length src - str_pos
         | Some len -> len)
  ;;

  let stringo ?(str_pos = 0) ?len t ~pos src =
    string
      t
      ~str_pos
      ~pos
      src
      ~len:
        (match len with
         | None -> String.length src - str_pos
         | Some len -> len)
  ;;

  let bigstringo ?(str_pos = 0) ?len t ~pos src =
    bigstring
      t
      ~str_pos
      ~pos
      src
      ~len:
        (match len with
         | None -> Bigstring.length src - str_pos
         | Some len -> len)
  ;;

  let bin_prot_size = write_bin_prot
  let bin_prot writer t ~pos a = ignore (bin_prot_size writer t ~pos a : int)

  open Bigstring

  let len = 1
  let char t ~pos c = set_char t pos c [@@inline always]

  let uint8_trunc t ~pos i = unsafe_set_uint8 t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int8_trunc t ~pos i = unsafe_set_int8 t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let len = 2

  let int16_be_trunc t ~pos i = unsafe_set_int16_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int16_le_trunc t ~pos i = unsafe_set_int16_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint16_be_trunc t ~pos i = unsafe_set_uint16_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint16_le_trunc t ~pos i = unsafe_set_uint16_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let len = 4

  let int32_be_trunc t ~pos i = unsafe_set_int32_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int32_t_be t ~pos i = unsafe_set_int32_t_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int32_le_trunc t ~pos i = unsafe_set_int32_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int32_t_le t ~pos i = unsafe_set_int32_t_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint32_be_trunc t ~pos i = unsafe_set_uint32_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint32_le_trunc t ~pos i = unsafe_set_uint32_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let len = 8

  let int64_be t ~pos i = unsafe_set_int64_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int64_le t ~pos i = unsafe_set_int64_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint64_be_trunc t ~pos i = unsafe_set_uint64_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let uint64_le_trunc t ~pos i = unsafe_set_uint64_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int64_t_be t ~pos i = unsafe_set_int64_t_be t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let int64_t_le t ~pos i = unsafe_set_int64_t_le t.buf ~pos:(spos t ~len ~pos) i
  [@@inline always]
  ;;

  let decimal = Itoa.poke_decimal
  let padded_decimal = Itoa.poke_padded_decimal
  let date_string_iso8601_extended = Date_string.poke_iso8601_extended

  module Int_repr = struct
    let uint8 t ~pos i = uint8_trunc t ~pos (IR.Uint8.to_base_int i) [@@inline always]

    let uint16_be t ~pos i = uint16_be_trunc t ~pos (IR.Uint16.to_base_int i)
    [@@inline always]
    ;;

    let uint16_le t ~pos i = uint16_le_trunc t ~pos (IR.Uint16.to_base_int i)
    [@@inline always]
    ;;

    let uint32_be t ~pos i = int32_t_be t ~pos (IR.Uint32.to_base_int32_trunc i)
    [@@inline always]
    ;;

    let uint32_le t ~pos i = int32_t_le t ~pos (IR.Uint32.to_base_int32_trunc i)
    [@@inline always]
    ;;

    let uint64_be t ~pos i = int64_t_be t ~pos (IR.Uint64.to_base_int64_trunc i)
    [@@inline always]
    ;;

    let uint64_le t ~pos i = int64_t_le t ~pos (IR.Uint64.to_base_int64_trunc i)
    [@@inline always]
    ;;

    let int8 t ~pos i = int8_trunc t ~pos (IR.Int8.to_base_int i) [@@inline always]

    let int16_be t ~pos i = int16_be_trunc t ~pos (IR.Int16.to_base_int i)
    [@@inline always]
    ;;

    let int16_le t ~pos i = int16_le_trunc t ~pos (IR.Int16.to_base_int i)
    [@@inline always]
    ;;

    let int32_be t ~pos i = int32_t_be t ~pos (IR.Int32.to_base_int32 i) [@@inline always]
    let int32_le t ~pos i = int32_t_le t ~pos (IR.Int32.to_base_int32 i) [@@inline always]
    let int64_be t ~pos i = int64_t_be t ~pos i [@@inline always]
    let int64_le t ~pos i = int64_t_le t ~pos i [@@inline always]
  end
end

module Blit = struct
  module T_dst = struct
    include T_src

    let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
      Bigstring.unsafe_blit
        ~len
        ~src:src.buf
        ~src_pos:(unsafe_buf_pos src ~pos:src_pos ~len)
        ~dst:dst.buf
        ~dst_pos:(unsafe_buf_pos dst ~pos:dst_pos ~len)
    ;;
  end

  include Base_for_tests.Test_blit.Make_and_test (Char_elt) (T_dst)

  let unsafe_blit = T_dst.unsafe_blit

  let blit_maximal ~src ?(src_pos = 0) ~dst ?(dst_pos = 0) () =
    let len = min (length src - src_pos) (length dst - dst_pos) in
    blit ~src ~src_pos ~dst ~dst_pos ~len;
    len
  ;;
end

module Blit_consume = struct
  let unsafe_blit ~src ~dst ~dst_pos ~len =
    Blit.unsafe_blit ~src ~src_pos:0 ~dst ~dst_pos ~len;
    unsafe_advance src len
  ;;

  let blit ~src ~dst ~dst_pos ~len =
    Blit.blit ~src ~src_pos:0 ~dst ~dst_pos ~len;
    unsafe_advance src len
  ;;

  let blito ~src ?(src_len = length src) ~dst ?(dst_pos = 0) () =
    blit ~src ~dst ~dst_pos ~len:src_len
  ;;

  let sub src ~len =
    let dst = Blit.sub src ~pos:0 ~len in
    unsafe_advance src len;
    dst
  ;;

  let subo ?len src =
    let len =
      match len with
      | None -> length src
      | Some len -> len
    in
    sub src ~len
  ;;

  let blit_maximal ~src ~dst ?(dst_pos = 0) () =
    let len = min (length src) (length dst - dst_pos) in
    blit ~src ~dst ~dst_pos ~len;
    len
  ;;
end

module Blit_fill = struct
  let unsafe_blit ~src ~src_pos ~dst ~len =
    Blit.unsafe_blit ~src ~src_pos ~dst ~dst_pos:0 ~len;
    unsafe_advance dst len
  ;;

  let blit ~src ~src_pos ~dst ~len =
    Blit.blit ~src ~src_pos ~dst ~dst_pos:0 ~len;
    unsafe_advance dst len
  ;;

  let blito ~src ?(src_pos = 0) ?(src_len = length src - src_pos) ~dst () =
    blit ~src ~src_pos ~dst ~len:src_len
  ;;

  let blit_maximal ~src ?(src_pos = 0) ~dst () =
    let len = min (length src - src_pos) (length dst) in
    blit ~src ~src_pos ~dst ~len;
    len
  ;;
end

module Blit_consume_and_fill = struct
  let unsafe_blit ~src ~dst ~len =
    if phys_equal src dst
    then advance src len
    else (
      Blit.unsafe_blit ~src ~src_pos:0 ~dst ~dst_pos:0 ~len;
      unsafe_advance src len;
      unsafe_advance dst len)
  ;;

  let blit ~src ~dst ~len =
    if phys_equal src dst
    then advance src len
    else (
      Blit.blit ~src ~src_pos:0 ~dst ~dst_pos:0 ~len;
      unsafe_advance src len;
      unsafe_advance dst len)
  ;;

  let blito ~src ?(src_len = length src) ~dst () = blit ~src ~dst ~len:src_len

  let blit_maximal ~src ~dst =
    let len = min (length src) (length dst) in
    unsafe_blit ~src ~dst ~len;
    len
  ;;
end

let transfer ~src ~dst =
  reset dst;
  Blit_fill.blito ~src ~dst ();
  flip_lo dst
;;

let bin_prot_length_prefix_bytes = 4

let consume_bin_prot t bin_prot_reader =
  let result =
    if length t < bin_prot_length_prefix_bytes
    then
      error
        "Iobuf.consume_bin_prot not enough data to read length"
        (globalize_t_repr t)
        ((fun x__063_ ->
           sexp_of_t
             (fun _ -> Sexplib0.Sexp.Atom "_")
             (fun _ -> Sexplib0.Sexp.Atom "_")
             x__063_) [@merlin.hide])
    else (
      let mark = t.lo in
      let v_len = Consume.int32_be t in
      if v_len > length t
      then (
        t.lo <- mark;
        error
          "Iobuf.consume_bin_prot not enough data to read value"
          (v_len, globalize_t_repr t)
          ((fun (arg0__065_, arg1__066_) ->
             let res0__067_ = sexp_of_int arg0__065_
             and res1__068_ =
               sexp_of_t
                 (fun _ -> Sexplib0.Sexp.Atom "_")
                 (fun _ -> Sexplib0.Sexp.Atom "_")
                 arg1__066_
             in
             Sexplib0.Sexp.List [ res0__067_; res1__068_ ]) [@merlin.hide]))
      else Ok (Consume.bin_prot bin_prot_reader t))
  in
  result
;;

let fill_bin_prot t writer v =
  let v_len = writer.Bin_prot.Type_class.size v in
  let need = v_len + bin_prot_length_prefix_bytes in
  let result =
    if need > length t
    then
      error
        "Iobuf.fill_bin_prot not enough space"
        (need, globalize_t_repr t)
        ((fun (arg0__070_, arg1__071_) ->
           let res0__072_ = sexp_of_int arg0__070_
           and res1__073_ =
             sexp_of_t
               (fun _ -> Sexplib0.Sexp.Atom "_")
               (fun _ -> Sexplib0.Sexp.Atom "_")
               arg1__071_
           in
           Sexplib0.Sexp.List [ res0__072_; res1__073_ ]) [@merlin.hide])
    else (
      Fill.int32_be_trunc t v_len;
      Fill.bin_prot writer t v;
      Ok ())
  in
  result
;;

let fill_bin_prot_local t sizer writer v =
  let v_len = sizer v in
  let need = v_len + bin_prot_length_prefix_bytes in
  let result =
    if need > length t
    then
      error
        "Iobuf.fill_bin_prot_local not enough space"
        (need, globalize_t_repr t)
        ((fun (arg0__075_, arg1__076_) ->
           let res0__077_ = sexp_of_int arg0__075_
           and res1__078_ =
             sexp_of_t
               (fun _ -> Sexplib0.Sexp.Atom "_")
               (fun _ -> Sexplib0.Sexp.Atom "_")
               arg1__076_
           in
           Sexplib0.Sexp.List [ res0__077_; res1__078_ ]) [@merlin.hide])
    else (
      Fill.int32_be_trunc t v_len;
      Fill.bin_prot_local sizer writer t v;
      Ok ())
  in
  result
;;

module Expert = struct
  let buf t = t.buf
  let hi_max t = t.hi_max
  let hi t = t.hi
  let lo t = t.lo
  let lo_min t = t.lo_min
  let set_buf t buf = t.buf <- buf
  let set_hi_max t hi_max = t.hi_max <- hi_max
  let set_hi t hi = t.hi <- hi
  let set_lo t lo = t.lo <- lo
  let set_lo_min t lo_min = t.lo_min <- lo_min
  let buf_pos_exn = buf_pos_exn
  let unsafe_buf_pos = unsafe_buf_pos

  let to_bigstring_shared ?pos ?len t =
    let pos, len =
      Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
    in
    Bigstring.sub_shared t.buf ~pos:(t.lo + pos) ~len
  ;;

  let unsafe_reinitialize t ~lo_min ~lo ~hi ~hi_max buf =
    if not (phys_equal t.buf buf) then t.buf <- buf;
    t.lo_min <- lo_min;
    t.lo <- lo;
    t.hi <- hi;
    t.hi_max <- hi_max
  ;;

  let reinitialize t ~lo_min ~lo ~hi ~hi_max buf =
    if
      not
        (0 <= lo_min
         && lo_min <= lo
         && lo <= hi
         && hi <= hi_max
         && hi_max <= Bigstring.length buf)
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Expert.reinitialize got invalid bounds"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lo_min"
                 ; (sexp_of_int [@merlin.hide]) lo_min
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "lo"; (sexp_of_int [@merlin.hide]) lo ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hi"; (sexp_of_int [@merlin.hide]) hi ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "hi_max"
                 ; (sexp_of_int [@merlin.hide]) hi_max
                 ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "Bigstring.length buf"
                 ; (sexp_of_int [@merlin.hide]) (Bigstring.length buf)
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    unsafe_reinitialize t ~lo_min ~lo ~hi ~hi_max buf
  ;;

  let unsafe_reinitialize = if unsafe_is_safe then reinitialize else unsafe_reinitialize

  let _remember_to_update_unsafe_reinitialize
    : (_, _) t -> buf:Bigstring.t -> lo_min:int -> lo:int -> hi:int -> hi_max:int -> unit
    =
    Fields.Direct.set_all_mutable_fields
  ;;

  let reinitialize_of_bigstring t ~pos ~len buf =
    let str_len = Bigstring.length buf in
    if pos < 0 || pos > str_len
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Expert.reinitialize_of_bigstring got invalid pos"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "pos"; (sexp_of_int [@merlin.hide]) pos ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "str_len"
                 ; (sexp_of_int [@merlin.hide]) str_len
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    let max_len = str_len - pos in
    if len < 0 || len > max_len
    then
      raise_s
        (let ppx_sexp_message () =
           Ppx_sexp_conv_lib.Sexp.List
             [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                 "Expert.reinitialize_of_bigstring got invalid len"
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "len"; (sexp_of_int [@merlin.hide]) len ]
             ; Ppx_sexp_conv_lib.Sexp.List
                 [ Ppx_sexp_conv_lib.Sexp.Atom "max_len"
                 ; (sexp_of_int [@merlin.hide]) max_len
                 ]
             ]
             [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
         in
         (ppx_sexp_message () [@nontail]));
    let lo = pos in
    let hi = pos + len in
    unsafe_reinitialize t ~lo_min:lo ~lo ~hi ~hi_max:hi buf
  ;;

  let set_bounds_and_buffer = set_bounds_and_buffer
  let set_bounds_and_buffer_sub = set_bounds_and_buffer_sub

  let protect_window t ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_global_deprecated t ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_1 t x ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t x in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_2 t x y ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t x y in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_1_global_deprecated t x ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t x in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_2_global_deprecated t x y ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t x y in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;

  let protect_window_local t ~f =
    let lo = t.lo in
    let hi = t.hi in
    try
      let result = f t in
      t.lo <- lo;
      t.hi <- hi;
      result
    with
    | exn ->
      t.lo <- lo;
      t.hi <- hi;
      raise exn
  ;;
end

module Unsafe = struct
  module Consume = struct
    type src = Consume.src

    module To_bytes = struct
      include Consume.To_bytes

      let blit = unsafe_blit
    end

    module To_bigstring = struct
      include Consume.To_bigstring

      let blit = unsafe_blit
    end

    module To_string = Consume.To_string

    type ('a, 'd, 'w) t = ('a, 'd, 'w) Consume.t
    type ('a, 'd, 'w) t_local = ('a, 'd, 'w) Consume.t_local

    let uadv t n x =
      unsafe_advance t n;
      x
    [@@inline always]
    ;;

    let uadv_local t n x =
      unsafe_advance t n;
      x
    [@@inline always]
    ;;

    let upos t len = unsafe_buf_pos t ~pos:0 ~len

    let tail_padded_fixed_string ~padding ~len t =
      uadv
        t
        len
        (Bigstring.get_tail_padded_fixed_string t.buf ~pos:(upos t len) ~padding ~len ())
    ;;

    let head_padded_fixed_string ~padding ~len t =
      uadv
        t
        len
        (Bigstring.get_head_padded_fixed_string t.buf ~pos:(upos t len) ~padding ~len ())
    ;;

    let bytes = Consume.bytes
    let string = Consume.string
    let bigstring = Consume.bigstring
    let byteso = Consume.byteso
    let stringo = Consume.stringo
    let bigstringo = Consume.bigstringo
    let bin_prot = Consume.bin_prot

    module Local = struct
      let tail_padded_fixed_string ~padding ~len t =
        uadv_local
          t
          len
          (Bigstring.get_tail_padded_fixed_string_local
             t.buf
             ~pos:(upos t len)
             ~padding
             ~len
             ())
      ;;

      let head_padded_fixed_string ~padding ~len t =
        uadv_local
          t
          len
          (Bigstring.get_head_padded_fixed_string_local
             t.buf
             ~pos:(upos t len)
             ~padding
             ~len
             ())
      ;;

      let bytes = Consume.Local.bytes
      let string = Consume.Local.string
      let byteso = Consume.Local.byteso
      let stringo = Consume.Local.stringo

      open Bigstring

      let len = 8

      let int64_t_be t =
        uadv_local t len (Local.unsafe_get_int64_t_be t.buf ~pos:(upos t len)) [@nontail]
      [@@inline always]
      ;;

      let int64_t_le t =
        uadv_local t len (Local.unsafe_get_int64_t_le t.buf ~pos:(upos t len)) [@nontail]
      [@@inline always]
      ;;
    end

    open Bigstring

    let len = 1
    let char t = uadv t len (Bigstring.unsafe_get t.buf (upos t len)) [@@inline always]
    let uint8 t = uadv t len (unsafe_get_uint8 t.buf ~pos:(upos t len)) [@@inline always]
    let int8 t = uadv t len (unsafe_get_int8 t.buf ~pos:(upos t len)) [@@inline always]
    let len = 2

    let int16_be t = uadv t len (unsafe_get_int16_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int16_le t = uadv t len (unsafe_get_int16_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint16_be t = uadv t len (unsafe_get_uint16_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint16_le t = uadv t len (unsafe_get_uint16_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let len = 4

    let int32_be t = uadv t len (unsafe_get_int32_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int32_t_be t = uadv t len (unsafe_get_int32_t_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int32_le t = uadv t len (unsafe_get_int32_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int32_t_le t = uadv t len (unsafe_get_int32_t_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint32_be t = uadv t len (unsafe_get_uint32_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint32_le t = uadv t len (unsafe_get_uint32_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let len = 8

    let int64_be_exn t = uadv t len (unsafe_get_int64_be_exn t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int64_le_exn t = uadv t len (unsafe_get_int64_le_exn t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint64_be_exn t = uadv t len (unsafe_get_uint64_be_exn t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let uint64_le_exn t = uadv t len (unsafe_get_uint64_le_exn t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int64_t_be t = uadv t len (unsafe_get_int64_t_be t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int64_t_le t = uadv t len (unsafe_get_int64_t_le t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int64_be_trunc t = uadv t len (unsafe_get_int64_be_trunc t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    let int64_le_trunc t = uadv t len (unsafe_get_int64_le_trunc t.buf ~pos:(upos t len))
    [@@inline always]
    ;;

    module Int_repr = struct
      let uint8 t = IR.Uint8.of_base_int_trunc (uint8 t) [@@inline always]
      let uint16_be t = IR.Uint16.of_base_int_trunc (uint16_be t) [@@inline always]
      let uint16_le t = IR.Uint16.of_base_int_trunc (uint16_le t) [@@inline always]
      let uint32_be t = IR.Uint32.of_base_int32_trunc (int32_t_be t) [@@inline always]
      let uint32_le t = IR.Uint32.of_base_int32_trunc (int32_t_le t) [@@inline always]
      let uint64_be t = IR.Uint64.of_base_int64_trunc (int64_t_be t) [@@inline always]
      let uint64_le t = IR.Uint64.of_base_int64_trunc (int64_t_le t) [@@inline always]
      let int8 t = IR.Int8.of_base_int_trunc (int8 t) [@@inline always]
      let int16_be t = IR.Int16.of_base_int_trunc (int16_be t) [@@inline always]
      let int16_le t = IR.Int16.of_base_int_trunc (int16_le t) [@@inline always]
      let int32_be t = IR.Int32.of_base_int32 (int32_t_be t) [@@inline always]
      let int32_le t = IR.Int32.of_base_int32 (int32_t_le t) [@@inline always]
      let int64_be t = int64_t_be t [@@inline always]
      let int64_le t = int64_t_le t [@@inline always]
    end
  end

  module Fill = struct
    type ('a, 'd, 'w) t = ('a, 'd, 'w) Fill.t
    type ('a, 'd, 'w) t_local = ('a, 'd, 'w) Fill.t_local

    let upos t len = unsafe_buf_pos t ~pos:0 ~len
    let uadv t n = unsafe_advance t n

    let tail_padded_fixed_string ~padding ~len t src =
      Bigstring.set_tail_padded_fixed_string ~padding ~len t.buf ~pos:(upos t len) src;
      uadv t len
    ;;

    let head_padded_fixed_string ~padding ~len t src =
      Bigstring.set_head_padded_fixed_string ~padding ~len t.buf ~pos:(upos t len) src;
      uadv t len
    ;;

    let bytes ~str_pos ~len t src =
      Bigstring.From_bytes.blit
        ~src
        ~src_pos:str_pos
        ~len
        ~dst:t.buf
        ~dst_pos:(upos t len);
      uadv t len
    ;;

    let string ~str_pos ~len t src =
      Bigstring.From_string.blit
        ~src
        ~src_pos:str_pos
        ~len
        ~dst:t.buf
        ~dst_pos:(upos t len);
      uadv t len
    ;;

    let bigstring ~str_pos ~len t src =
      Bigstring.blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(upos t len);
      uadv t len
    ;;

    let byteso ?(str_pos = 0) ?len t src =
      bytes
        t
        src
        ~str_pos
        ~len:
          (match len with
           | None -> Bytes.length src - str_pos
           | Some len -> len)
    ;;

    let stringo ?(str_pos = 0) ?len t src =
      string
        t
        src
        ~str_pos
        ~len:
          (match len with
           | None -> String.length src - str_pos
           | Some len -> len)
    ;;

    let bigstringo ?(str_pos = 0) ?len t src =
      bigstring
        t
        src
        ~str_pos
        ~len:
          (match len with
           | None -> Bigstring.length src - str_pos
           | Some len -> len)
    ;;

    let bin_prot = Fill.bin_prot

    open Bigstring

    let len = 1

    let char t c =
      Bigstring.unsafe_set t.buf (upos t len) c;
      uadv t len
    [@@inline always]
    ;;

    let len = 2

    let int16_be_trunc t i =
      unsafe_set_int16_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int16_le_trunc t i =
      unsafe_set_int16_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint16_be_trunc t i =
      unsafe_set_uint16_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint16_le_trunc t i =
      unsafe_set_uint16_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let len = 4

    let int32_be_trunc t i =
      unsafe_set_int32_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int32_t_be t i =
      unsafe_set_int32_t_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int32_le_trunc t i =
      unsafe_set_int32_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int32_t_le t i =
      unsafe_set_int32_t_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint32_be_trunc t i =
      unsafe_set_uint32_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint32_le_trunc t i =
      unsafe_set_uint32_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let len = 8

    let int64_be t i =
      unsafe_set_int64_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int64_le t i =
      unsafe_set_int64_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint64_be_trunc t i =
      unsafe_set_uint64_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint64_le_trunc t i =
      unsafe_set_uint64_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int64_t_be t i =
      unsafe_set_int64_t_be t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let int64_t_le t i =
      unsafe_set_int64_t_le t.buf i ~pos:(upos t len);
      uadv t len
    [@@inline always]
    ;;

    let uint8_trunc t i = char t (Char.unsafe_of_int i) [@@inline always]
    let int8_trunc t i = char t (Char.unsafe_of_int i) [@@inline always]
    let decimal t i = uadv t (Itoa.unsafe_poke_decimal t ~pos:0 i)
    let padded_decimal ~len t i = uadv t (Itoa.unsafe_poke_padded_decimal t ~pos:0 ~len i)

    let date_string_iso8601_extended t date =
      Date_string.unsafe_poke_iso8601_extended t ~pos:0 date;
      uadv t Date_string.len_iso8601_extended
    ;;

    module Int_repr = struct
      let uint8 t i = char t (Char.unsafe_of_int (IR.Uint8.to_base_int i))
      [@@inline always]
      ;;

      let uint16_be t i = uint16_be_trunc t (IR.Uint16.to_base_int i) [@@inline always]
      let uint16_le t i = uint16_le_trunc t (IR.Uint16.to_base_int i) [@@inline always]
      let uint32_be t i = int32_t_be t (IR.Uint32.to_base_int32_trunc i) [@@inline always]
      let uint32_le t i = int32_t_le t (IR.Uint32.to_base_int32_trunc i) [@@inline always]
      let uint64_be t i = int64_t_be t (IR.Uint64.to_base_int64_trunc i) [@@inline always]
      let uint64_le t i = int64_t_le t (IR.Uint64.to_base_int64_trunc i) [@@inline always]
      let int8 t i = char t (Char.unsafe_of_int (IR.Int8.to_base_int i)) [@@inline always]
      let int16_be t i = int16_be_trunc t (IR.Int16.to_base_int i) [@@inline always]
      let int16_le t i = int16_le_trunc t (IR.Int16.to_base_int i) [@@inline always]
      let int32_be t i = int32_t_be t (IR.Int32.to_base_int32 i) [@@inline always]
      let int32_le t i = int32_t_le t (IR.Int32.to_base_int32 i) [@@inline always]
      let int64_be t i = int64_t_be t i [@@inline always]
      let int64_le t i = int64_t_le t i [@@inline always]
    end
  end

  module Peek = struct
    type 'seek src = 'seek Peek.src

    module To_bytes = struct
      include Peek.To_bytes

      let blit = unsafe_blit
    end

    module To_bigstring = struct
      include Peek.To_bigstring

      let blit = unsafe_blit
    end

    module To_string = Peek.To_string

    type ('a, 'd, 'w) t = ('a, 'd, 'w) Peek.t
    type ('a, 'd, 'w) t_local = ('a, 'd, 'w) Peek.t_local

    let upos = unsafe_buf_pos

    let tail_padded_fixed_string ~padding ~len t ~pos =
      Bigstring.get_tail_padded_fixed_string
        t.buf
        ~padding
        ~len
        ~pos:(upos t ~len ~pos)
        ()
    ;;

    let head_padded_fixed_string ~padding ~len t ~pos =
      Bigstring.get_head_padded_fixed_string
        t.buf
        ~padding
        ~len
        ~pos:(upos t ~len ~pos)
        ()
    ;;

    let bytes ~str_pos ~len t ~pos =
      let dst = Bytes.create (len + str_pos) in
      Bigstring.To_bytes.unsafe_blit
        ~src:t.buf
        ~src_pos:(upos t ~len ~pos)
        ~len
        ~dst
        ~dst_pos:str_pos;
      dst
    ;;

    let string ~str_pos ~len t ~pos =
      Bytes.unsafe_to_string
        ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t ~pos)
    ;;

    let bigstring ~str_pos ~len t ~pos =
      let dst = Bigstring.create (len + str_pos) in
      Bigstring.unsafe_blit
        ~src:t.buf
        ~src_pos:(upos t ~len ~pos)
        ~len
        ~dst
        ~dst_pos:str_pos;
      dst
    ;;

    let byteso ?(str_pos = 0) ?len t ~pos =
      bytes
        t
        ~pos
        ~str_pos
        ~len:
          (match len with
           | None -> length t - pos
           | Some len -> len)
    ;;

    let stringo ?(str_pos = 0) ?len t ~pos =
      string
        t
        ~pos
        ~str_pos
        ~len:
          (match len with
           | None -> length t - pos
           | Some len -> len)
    ;;

    let bigstringo ?(str_pos = 0) ?len t ~pos =
      bigstring
        t
        ~pos
        ~str_pos
        ~len:
          (match len with
           | None -> length t - pos
           | Some len -> len)
    ;;

    let bin_prot = Peek.bin_prot

    let index_or_neg t ~pos ~len c =
      let pos = unsafe_buf_pos t ~pos ~len in
      let idx = Bigstring.unsafe_find ~pos ~len t.buf c in
      if idx < 0 then -1 else idx - t.lo
    ;;

    module Local = struct
      let tail_padded_fixed_string ~padding ~len t ~pos =
        Bigstring.get_tail_padded_fixed_string_local
          t.buf
          ~padding
          ~len
          ~pos:(upos t ~len ~pos)
          ()
      ;;

      let head_padded_fixed_string ~padding ~len t ~pos =
        Bigstring.get_head_padded_fixed_string_local
          t.buf
          ~padding
          ~len
          ~pos:(upos t ~len ~pos)
          ()
      ;;

      let bytes ~str_pos ~len t ~pos =
        let dst = Bytes.create_local (len + str_pos) in
        Bigstring.To_bytes.unsafe_blit
          ~src:t.buf
          ~src_pos:(upos t ~len ~pos)
          ~len
          ~dst
          ~dst_pos:str_pos;
        dst
      ;;

      let string ~str_pos ~len t ~pos =
        Bytes.unsafe_to_string
          ~no_mutation_while_string_reachable:(bytes ~str_pos ~len t ~pos)
      ;;

      let byteso ?(str_pos = 0) ?len t ~pos =
        bytes
          t
          ~pos
          ~str_pos
          ~len:
            (match len with
             | None -> length t - pos
             | Some len -> len)
      ;;

      let stringo ?(str_pos = 0) ?len t ~pos =
        string
          t
          ~pos
          ~str_pos
          ~len:
            (match len with
             | None -> length t - pos
             | Some len -> len)
      ;;

      open Bigstring

      let len = 8

      let int64_t_be t ~pos =
        Local.unsafe_get_int64_t_be t.buf ~pos:(upos t ~len ~pos) [@nontail]
      [@@inline always]
      ;;

      let int64_t_le t ~pos =
        Local.unsafe_get_int64_t_le t.buf ~pos:(upos t ~len ~pos) [@nontail]
      [@@inline always]
      ;;
    end

    open Bigstring

    let len = 1
    let char t ~pos = Bigstring.unsafe_get t.buf (upos t ~len ~pos) [@@inline always]
    let uint8 t ~pos = unsafe_get_uint8 t.buf ~pos:(upos t ~len ~pos) [@@inline always]
    let int8 t ~pos = unsafe_get_int8 t.buf ~pos:(upos t ~len ~pos) [@@inline always]
    let len = 2

    let int16_be t ~pos = unsafe_get_int16_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int16_le t ~pos = unsafe_get_int16_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint16_be t ~pos = unsafe_get_uint16_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint16_le t ~pos = unsafe_get_uint16_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let len = 4

    let int32_be t ~pos = unsafe_get_int32_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int32_t_be t ~pos = unsafe_get_int32_t_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int32_le t ~pos = unsafe_get_int32_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int32_t_le t ~pos = unsafe_get_int32_t_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint32_be t ~pos = unsafe_get_uint32_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint32_le t ~pos = unsafe_get_uint32_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let len = 8

    let int64_be_exn t ~pos = unsafe_get_int64_be_exn t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int64_le_exn t ~pos = unsafe_get_int64_le_exn t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint64_be_exn t ~pos = unsafe_get_uint64_be_exn t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let uint64_le_exn t ~pos = unsafe_get_uint64_le_exn t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int64_t_be t ~pos = unsafe_get_int64_t_be t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int64_t_le t ~pos = unsafe_get_int64_t_le t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int64_be_trunc t ~pos = unsafe_get_int64_be_trunc t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    let int64_le_trunc t ~pos = unsafe_get_int64_le_trunc t.buf ~pos:(upos t ~len ~pos)
    [@@inline always]
    ;;

    module Int_repr = struct
      let uint8 t ~pos = IR.Uint8.of_base_int_trunc (uint8 t ~pos) [@@inline always]

      let uint16_be t ~pos = IR.Uint16.of_base_int_trunc (uint16_be t ~pos)
      [@@inline always]
      ;;

      let uint16_le t ~pos = IR.Uint16.of_base_int_trunc (uint16_le t ~pos)
      [@@inline always]
      ;;

      let uint32_be t ~pos = IR.Uint32.of_base_int32_trunc (int32_t_be t ~pos)
      [@@inline always]
      ;;

      let uint32_le t ~pos = IR.Uint32.of_base_int32_trunc (int32_t_le t ~pos)
      [@@inline always]
      ;;

      let uint64_be t ~pos = IR.Uint64.of_base_int64_trunc (int64_t_be t ~pos)
      [@@inline always]
      ;;

      let uint64_le t ~pos = IR.Uint64.of_base_int64_trunc (int64_t_le t ~pos)
      [@@inline always]
      ;;

      let int8 t ~pos = IR.Int8.of_base_int_trunc (int8 t ~pos) [@@inline always]
      let int16_be t ~pos = IR.Int16.of_base_int_trunc (int16_be t ~pos) [@@inline always]
      let int16_le t ~pos = IR.Int16.of_base_int_trunc (int16_le t ~pos) [@@inline always]
      let int32_be t ~pos = IR.Int32.of_base_int32 (int32_t_be t ~pos) [@@inline always]
      let int32_le t ~pos = IR.Int32.of_base_int32 (int32_t_le t ~pos) [@@inline always]
      let int64_be t ~pos = int64_t_be t ~pos [@@inline always]
      let int64_le t ~pos = int64_t_le t ~pos [@@inline always]
    end
  end

  module Poke = struct
    type ('a, 'd, 'w) t = ('a, 'd, 'w) Poke.t
    type ('a, 'd, 'w) t_local = ('a, 'd, 'w) Poke.t_local

    let upos = unsafe_buf_pos

    let tail_padded_fixed_string ~padding ~len t ~pos src =
      Bigstring.set_tail_padded_fixed_string
        ~padding
        ~len
        t.buf
        ~pos:(upos t ~len ~pos)
        src
    ;;

    let head_padded_fixed_string ~padding ~len t ~pos src =
      Bigstring.set_head_padded_fixed_string
        ~padding
        ~len
        t.buf
        ~pos:(upos t ~len ~pos)
        src
    ;;

    let bytes ~str_pos ~len t ~pos src =
      let blit =
        if unsafe_is_safe
        then Bigstring.From_bytes.blit
        else Bigstring.From_bytes.unsafe_blit
      in
      blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(upos t ~len ~pos)
    ;;

    let string ~str_pos ~len t ~pos src =
      let blit =
        if unsafe_is_safe
        then Bigstring.From_string.blit
        else Bigstring.From_string.unsafe_blit
      in
      blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(upos t ~len ~pos)
    ;;

    let bigstring ~str_pos ~len t ~pos src =
      let blit = if unsafe_is_safe then Bigstring.blit else Bigstring.unsafe_blit in
      blit ~src ~src_pos:str_pos ~len ~dst:t.buf ~dst_pos:(upos t ~len ~pos)
    ;;

    let byteso ?(str_pos = 0) ?len t ~pos src =
      bytes
        t
        ~str_pos
        ~pos
        src
        ~len:
          (match len with
           | None -> Bytes.length src - str_pos
           | Some len -> len)
    ;;

    let stringo ?(str_pos = 0) ?len t ~pos src =
      string
        t
        ~str_pos
        ~pos
        src
        ~len:
          (match len with
           | None -> String.length src - str_pos
           | Some len -> len)
    ;;

    let bigstringo ?(str_pos = 0) ?len t ~pos src =
      bigstring
        t
        ~str_pos
        ~pos
        src
        ~len:
          (match len with
           | None -> Bigstring.length src - str_pos
           | Some len -> len)
    ;;

    let bin_prot = Poke.bin_prot
    let bin_prot_size = Poke.bin_prot_size

    let bin_prot_with_known_size writer t ~pos ~size a =
      ignore (writer.Bin_prot.Type_class.write t.buf ~pos:(upos t ~pos ~len:size) a : int)
    ;;

    open Bigstring

    let len = 1
    let char t ~pos c = Bigstring.unsafe_set t.buf (upos t ~len ~pos) c [@@inline always]

    let uint8_trunc t ~pos i = unsafe_set_uint8 t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int8_trunc t ~pos i = unsafe_set_int8 t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let len = 2

    let int16_be_trunc t ~pos i = unsafe_set_int16_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int16_le_trunc t ~pos i = unsafe_set_int16_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint16_be_trunc t ~pos i = unsafe_set_uint16_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint16_le_trunc t ~pos i = unsafe_set_uint16_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let len = 4

    let int32_be_trunc t ~pos i = unsafe_set_int32_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int32_t_be t ~pos i = unsafe_set_int32_t_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int32_le_trunc t ~pos i = unsafe_set_int32_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int32_t_le t ~pos i = unsafe_set_int32_t_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint32_be_trunc t ~pos i = unsafe_set_uint32_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint32_le_trunc t ~pos i = unsafe_set_uint32_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let len = 8

    let int64_be t ~pos i = unsafe_set_int64_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int64_le t ~pos i = unsafe_set_int64_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint64_be_trunc t ~pos i = unsafe_set_uint64_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let uint64_le_trunc t ~pos i = unsafe_set_uint64_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int64_t_be t ~pos i = unsafe_set_int64_t_be t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let int64_t_le t ~pos i = unsafe_set_int64_t_le t.buf ~pos:(upos t ~len ~pos) i
    [@@inline always]
    ;;

    let decimal = Itoa.unsafe_poke_decimal
    let padded_decimal = Itoa.unsafe_poke_padded_decimal
    let date_string_iso8601_extended = Date_string.unsafe_poke_iso8601_extended

    module Int_repr = struct
      let uint8 t ~pos i = uint8_trunc t ~pos (IR.Uint8.to_base_int i) [@@inline always]

      let uint16_be t ~pos i = int16_be_trunc t ~pos (IR.Uint16.to_base_int i)
      [@@inline always]
      ;;

      let uint16_le t ~pos i = int16_le_trunc t ~pos (IR.Uint16.to_base_int i)
      [@@inline always]
      ;;

      let uint32_be t ~pos i = int32_t_be t ~pos (IR.Uint32.to_base_int32_trunc i)
      [@@inline always]
      ;;

      let uint32_le t ~pos i = int32_t_le t ~pos (IR.Uint32.to_base_int32_trunc i)
      [@@inline always]
      ;;

      let uint64_be t ~pos i = int64_t_be t ~pos (IR.Uint64.to_base_int64_trunc i)
      [@@inline always]
      ;;

      let uint64_le t ~pos i = int64_t_le t ~pos (IR.Uint64.to_base_int64_trunc i)
      [@@inline always]
      ;;

      let int8 t ~pos i = int8_trunc t ~pos (IR.Int8.to_base_int i) [@@inline always]

      let int16_be t ~pos i = int16_be_trunc t ~pos (IR.Int16.to_base_int i)
      [@@inline always]
      ;;

      let int16_le t ~pos i = int16_le_trunc t ~pos (IR.Int16.to_base_int i)
      [@@inline always]
      ;;

      let int32_be t ~pos i = int32_t_be t ~pos (IR.Int32.to_base_int32 i)
      [@@inline always]
      ;;

      let int32_le t ~pos i = int32_t_le t ~pos (IR.Int32.to_base_int32 i)
      [@@inline always]
      ;;

      let int64_be t ~pos i = int64_t_be t ~pos i [@@inline always]
      let int64_le t ~pos i = int64_t_le t ~pos i [@@inline always]
    end
  end
end

module For_hexdump = struct
  module T2 = struct
    type nonrec ('rw, 'seek) t = ('rw, 'seek) t
  end

  module Window_indexable = struct
    include T2

    let length t = length t
    let get t pos = Peek.char t ~pos
  end

  module Limits_indexable = struct
    include T2

    let length t = t.hi_max - t.lo_min
    let get t pos = Bigstring.get t.buf (t.lo_min + pos)
  end

  module Buffer_indexable = struct
    include T2

    let length t = Bigstring.length t.buf
    let get t pos = Bigstring.get t.buf pos
  end

  module Window = Hexdump.Of_indexable2 (Window_indexable)
  module Limits = Hexdump.Of_indexable2 (Limits_indexable)
  module Buffer = Hexdump.Of_indexable2 (Buffer_indexable)

  module type Relative_indexable = sig
    val name : string
    val lo : (_, _) t -> int
    val hi : (_, _) t -> int
  end

  module type Compound_indexable = sig
    include Hexdump.S2 with type ('rw, 'seek) t := ('rw, 'seek) t

    val parts : (module Relative_indexable) list
  end

  module Make_compound_hexdump (Compound : Compound_indexable) = struct
    module Hexdump = struct
      include T2

      let relative_sequence ?max_lines t ((module Relative) : (module Relative_indexable))
        =
        let lo = Relative.lo t in
        let hi = Relative.hi t in
        Compound.Hexdump.to_sequence ?max_lines ~pos:lo ~len:(hi - lo) t
      ;;

      let to_sequence ?max_lines t =
        Sequence.concat
          (Sequence.of_list
             (List.concat_map Compound.parts ~f:(fun (module Relative) ->
                [ Sequence.singleton (String.capitalize Relative.name)
                ; Sequence.map
                    ~f:(fun line -> "  " ^ line)
                    (relative_sequence ?max_lines t (module Relative))
                ])))
      ;;

      let to_string_hum ?max_lines t =
        let t = globalize () () t in
        String.concat ~sep:"\n" (Sequence.to_list (to_sequence ?max_lines t))
      ;;

      let sexp_of_t _ _ t =
        ((fun x__083_ ->
           sexp_of_list
             (fun (arg0__079_, arg1__080_) ->
                let res0__081_ = sexp_of_string arg0__079_
                and res1__082_ = sexp_of_list sexp_of_string arg1__080_ in
                Sexplib0.Sexp.List [ res0__081_; res1__082_ ])
             x__083_) [@merlin.hide])
          (List.map Compound.parts ~f:(fun (module Relative) ->
             Relative.name, Sequence.to_list (relative_sequence t (module Relative))))
      ;;
    end
  end

  module Window_within_limits = struct
    let name = "window"
    let lo t = t.lo - t.lo_min
    let hi t = t.hi - t.lo_min
  end

  module Limits_within_limits = struct
    let name = "limits"
    let lo _ = 0
    let hi t = t.hi_max - t.lo_min
  end

  module Window_within_buffer = struct
    let name = "window"
    let lo t = t.lo
    let hi t = t.hi
  end

  module Limits_within_buffer = struct
    let name = "limits"
    let lo t = t.lo_min
    let hi t = t.hi_max
  end

  module Buffer_within_buffer = struct
    let name = "buffer"
    let lo _ = 0
    let hi t = Bigstring.length t.buf
  end

  module Window_and_limits = Make_compound_hexdump (struct
      include Limits

      let parts =
        [ ((module Window_within_limits) : (module Relative_indexable))
        ; ((module Limits_within_limits) : (module Relative_indexable))
        ]
      ;;
    end)

  module Window_and_limits_and_buffer = Make_compound_hexdump (struct
      include Buffer

      let parts =
        [ ((module Window_within_buffer) : (module Relative_indexable))
        ; ((module Limits_within_buffer) : (module Relative_indexable))
        ; ((module Buffer_within_buffer) : (module Relative_indexable))
        ]
      ;;
    end)
end

module Window = For_hexdump.Window
module Limits = For_hexdump.Limits
module Debug = For_hexdump.Window_and_limits_and_buffer
include For_hexdump.Window_and_limits

let to_string_hum = Hexdump.to_string_hum

let memcmp a b =
  let len = length a in
  let c = Int.compare len (length b) in
  if c <> 0 then c else Bigstring.memcmp ~pos1:a.lo a.buf ~pos2:b.lo b.buf ~len
;;

let memset t ~pos ~len c = Bigstring.memset ~pos:(buf_pos_exn t ~pos ~len) ~len t.buf c
let zero t = memset t ~pos:0 ~len:(length t) '\000'

let concat bufs =
  let total_length = ref 0 in
  let n = Array.length bufs in
  for i = 0 to n - 1 do
    total_length := !total_length + length (Array.unsafe_get bufs i)
  done;
  let t = create ~len:!total_length in
  let pos = ref 0 in
  for i = 0 to n - 1 do
    let src = Array.unsafe_get bufs i in
    let len = length src in
    Blit.blit ~src ~dst:t ~src_pos:0 ~dst_pos:!pos ~len;
    pos := !pos + len
  done;
  t
;;

let contains t ~substring =
  Bigstring.unsafe_memmem
    ~haystack:(buf t)
    ~haystack_pos:t.lo
    ~haystack_len:(length t)
    ~needle:substring
    ~needle_pos:0
    ~needle_len:(Bigstring.length substring)
  >= 0
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
