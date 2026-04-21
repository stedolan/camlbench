let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"tuple_pool.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "tuple_pool.ml.before-ppx"
;;

open! Core
open! Import
open Tuple_pool_intf
module Tuple_type = Tuple_type

let failwiths = Error.failwiths
let phys_equal = Stdlib.( == )
let arch_sixtyfour = Sys.word_size_in_bits = 64

module Int = struct
  let num_bits = Int.num_bits
  let max_value = Stdlib.max_int
  let to_string = string_of_int
end

let sprintf = Printf.sprintf
let concat l = Base.String.concat ~sep:"" l

module type S = S

module Pool = struct
  let grow_capacity ~capacity ~old_capacity =
    match capacity with
    | None -> if old_capacity = 0 then 1 else old_capacity * 2
    | Some capacity ->
      if capacity <= old_capacity
      then
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
            ; pos_lnum = 29
            ; pos_cnum = 658
            ; pos_bol = 642
            }
          "Pool.grow got too small capacity"
          (`capacity capacity, `old_capacity old_capacity)
          ((fun (arg0__003_, arg1__004_) ->
             let res0__005_ =
               let (`capacity v__001_) = arg0__003_ in
               Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "capacity"; sexp_of_int v__001_ ]
             and res1__006_ =
               let (`old_capacity v__002_) = arg1__004_ in
               Sexplib0.Sexp.List
                 [ Sexplib0.Sexp.Atom "old_capacity"; sexp_of_int v__002_ ]
             in
             Sexplib0.Sexp.List [ res0__005_; res1__006_ ]) [@merlin.hide]);
      capacity
  ;;

  module Slots = Tuple_type.Slots

  let max_slot = 14

  module Slot = struct
    type ('slots, 'a) t = int [@@deriving sexp_of]

    include struct
      let _ = fun (_ : ('slots, 'a) t) -> ()

      let sexp_of_t
        :  'slots 'a.
           ('slots -> Sexplib0.Sexp.t)
        -> ('a -> Sexplib0.Sexp.t)
        -> ('slots, 'a) t
        -> Sexplib0.Sexp.t
        =
        fun _of_slots__007_ _of_a__008_ -> sexp_of_int
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let equal (t1 : (_, _) t) t2 = t1 = t2
    let t0 = 1
    let t1 = 2
    let t2 = 3
    let t3 = 4
    let t4 = 5
    let t5 = 6
    let t6 = 7
    let t7 = 8
    let t8 = 9
    let t9 = 10
    let t10 = 11
    let t11 = 12
    let t12 = 13
    let t13 = 14

    let () =
      Ppx_inline_test_lib.test
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<t13 = max_slot>>")
        ~tags:[]
        ~filename:"tuple_pool.ml.before-ppx"
        ~line_number:86
        ~start_pos:4
        ~end_pos:31
        (fun () -> t13 = max_slot)
    ;;
  end

  let array_index_num_bits =
    if arch_sixtyfour
    then (
      assert (Int.num_bits = 63);
      30)
    else (
      assert (Int.num_bits = 31 || Int.num_bits = 32);
      22)
  ;;

  let masked_tuple_id_num_bits = Int.num_bits - array_index_num_bits

  let () =
    Ppx_inline_test_lib.test
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<array_index_num_bits > 0>>")
      ~tags:[]
      ~filename:"tuple_pool.ml.before-ppx"
      ~line_number:111
      ~start_pos:2
      ~end_pos:39
      (fun () -> array_index_num_bits > 0)
  ;;

  let () =
    Ppx_inline_test_lib.test
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<masked_tuple_id_num_bits > 0>>")
      ~tags:[]
      ~filename:"tuple_pool.ml.before-ppx"
      ~line_number:112
      ~start_pos:2
      ~end_pos:43
      (fun () -> masked_tuple_id_num_bits > 0)
  ;;

  let () =
    Ppx_inline_test_lib.test
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<(array_index_num_bits + masked_tuple_id_num_b[...]>>")
      ~tags:[]
      ~filename:"tuple_pool.ml.before-ppx"
      ~line_number:113
      ~start_pos:2
      ~end_pos:78
      (fun () -> array_index_num_bits + masked_tuple_id_num_bits <= Int.num_bits)
  ;;

  let max_array_length = 1 lsl array_index_num_bits

  module Tuple_id : sig
    type t = private int [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Invariant.S with type t := t

    val to_string : t -> string
    val equal : t -> t -> bool
    val init : t
    val next : t -> t
    val of_int : int -> t
    val to_int : t -> int
    val examples : t list
  end = struct
    type t = int [@@deriving sexp_of]

    include struct
      let _ = fun (_ : t) -> ()
      let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let invariant t = assert (t >= 0)
    let to_string = Int.to_string
    let equal (t1 : t) t2 = t1 = t2
    let init = 0
    let next t = if arch_sixtyfour then t + 1 else if t = Int.max_value then 0 else t + 1
    let to_int t = t

    let of_int i =
      if i < 0
      then
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
            ; pos_lnum = 142
            ; pos_cnum = 4449
            ; pos_bol = 4422
            }
          "Tuple_id.of_int got negative int"
          i
          (sexp_of_int [@merlin.hide]);
      i
    ;;

    let examples = [ 0; 1; 0x1FFF_FFFF; Int.max_value ]
  end

  let tuple_id_mask = (1 lsl masked_tuple_id_num_bits) - 1

  module Pointer : sig
    type 'slots t = private int [@@deriving sexp_of, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t

      include Typerep_lib.Typerepable.S1 with type 'slots t := 'slots t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Invariant.S1 with type 'a t := 'a t

    val phys_compare : 'a t -> 'a t -> int
    val phys_equal : 'a t -> 'a t -> bool
    val null : unit -> _ t
    val is_null : _ t -> bool
    val create : header_index:int -> Tuple_id.t -> _ t
    val header_index : _ t -> int
    val masked_tuple_id : _ t -> int
    val slot_index : _ t -> (_, _) Slot.t -> int
    val first_slot_index : _ t -> int

    module Id : sig
      type t [@@deriving bin_io, sexp]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      val to_int63 : t -> Int63.t
      val of_int63 : Int63.t -> t
    end

    val to_id : _ t -> Id.t
    val of_id_exn : Id.t -> _ t
  end = struct
    type 'slots t = int [@@deriving typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'slots t) -> ()

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
          type nonrec 'slots t = 'slots t

          let name = "tuple_pool.ml.before-ppx.Pool.Pointer.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        : 'slots. 'slots Typerep_lib.Std.Typerep.t -> 'slots t Typerep_lib.Std.Typerep.t
        =
        fun (type slots) ->
        fun (_of_slots : slots Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_slots in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy typerep_of_int))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let sexp_of_t _ t = Sexp.Atom (sprintf "<Pool.Pointer.t: 0x%08x>" t)
    let phys_equal (t1 : _ t) t2 = phys_equal t1 t2
    let phys_compare = compare
    let null () = -max_slot - 1
    let is_null t = phys_equal t (null ())

    let () =
      Ppx_inline_test_lib.test
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<((null ()) + max_slot) < 0>>")
        ~tags:[]
        ~filename:"tuple_pool.ml.before-ppx"
        ~line_number:206
        ~start_pos:4
        ~end_pos:39
        (fun () -> null () + max_slot < 0)
    ;;

    let create ~header_index (tuple_id : Tuple_id.t) =
      header_index
      lor ((Tuple_id.to_int tuple_id land tuple_id_mask) lsl array_index_num_bits)
    ;;

    let header_index_mask = (1 lsl array_index_num_bits) - 1
    let masked_tuple_id t = t lsr array_index_num_bits
    let header_index t = t land header_index_mask
    let invariant _ t = if not (is_null t) then assert (header_index t > 0)

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<invariant ignore (null ())>>")
        ~tags:[]
        ~filename:"tuple_pool.ml.before-ppx"
        ~line_number:217
        ~start_pos:4
        ~end_pos:48
        (fun () ->
           invariant ignore (null ());
           ())
    ;;

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<List.iter Tuple_id.examples   ~f:(fun tuple_i[...]>>")
        ~tags:[]
        ~filename:"tuple_pool.ml.before-ppx"
        ~line_number:219
        ~start_pos:4
        ~end_pos:135
        (fun () ->
           List.iter Tuple_id.examples ~f:(fun tuple_id ->
             invariant ignore (create ~header_index:1 tuple_id));
           ())
    ;;

    let slot_index t slot = header_index t + slot
    let first_slot_index t = slot_index t Slot.t0

    module Id = struct
      include Int63

      let to_int63 t = t
      let of_int63 i = i
    end

    let to_id t = Id.of_int t

    let of_id_exn id =
      try
        let t = Id.to_int_exn id in
        if is_null t
        then t
        else (
          let should_equal =
            create ~header_index:(header_index t) (Tuple_id.of_int (masked_tuple_id t))
          in
          if phys_equal t should_equal
          then t
          else
            failwiths
              ~here:
                { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
                ; pos_lnum = 247
                ; pos_cnum = 7731
                ; pos_bol = 7700
                }
              "should equal"
              should_equal
              ((fun x__009_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__009_)
                 [@merlin.hide]))
      with
      | exn ->
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
            ; pos_lnum = 251
            ; pos_cnum = 7844
            ; pos_bol = 7828
            }
          "Pointer.of_id_exn got strange id"
          (id, exn)
          ((fun (arg0__010_, arg1__011_) ->
             let res0__012_ = Id.sexp_of_t arg0__010_
             and res1__013_ = sexp_of_exn arg1__011_ in
             Sexplib0.Sexp.List [ res0__012_; res1__013_ ]) [@merlin.hide])
    ;;
  end

  module Header : sig
    type t = private int [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val null : t
    val is_null : t -> bool
    val free : next_free_header_index:int -> t
    val is_free : t -> bool
    val next_free_header_index : t -> int
    val used : Tuple_id.t -> t
    val is_used : t -> bool
    val tuple_id : t -> Tuple_id.t
  end = struct
    type t = int

    let null = 0
    let is_null t = t = 0
    let free ~next_free_header_index = next_free_header_index
    let is_free t = t > 0
    let next_free_header_index t = t
    let used (tuple_id : Tuple_id.t) = -1 - (tuple_id :> int)
    let is_used t = t < 0
    let tuple_id t = Tuple_id.of_int (-(t + 1))

    let () =
      Ppx_inline_test_lib.test_unit
        ~config:(module Inline_test_config)
        ~descr:(lazy "<<List.iter Tuple_id.examples   ~f:(fun id ->  [...]>>")
        ~tags:[]
        ~filename:"tuple_pool.ml.before-ppx"
        ~line_number:300
        ~start_pos:4
        ~end_pos:173
        (fun () ->
           List.iter Tuple_id.examples ~f:(fun id ->
             let t = used id in
             assert (is_used t);
             assert (Tuple_id.equal (tuple_id t) id));
           ())
    ;;

    let sexp_of_t t =
      if is_null t
      then Sexp.Atom "null"
      else if is_free t
      then
        let open Sexp in
        List [ Atom "Free"; Atom (Int.to_string (next_free_header_index t)) ]
      else
        let open Sexp in
        List [ Atom "Used"; Atom (Tuple_id.to_string (tuple_id t)) ]
    ;;
  end

  let metadata_index = 0
  let start_of_tuples_index = 1

  let max_capacity ~slots_per_tuple =
    (max_array_length - start_of_tuples_index) / (1 + slots_per_tuple)
  ;;

  let () =
    Ppx_inline_test_lib.test_unit
      ~config:(module Inline_test_config)
      ~descr:(lazy "<<for slots_per_tuple = 1 to max_slot do   asse[...]>>")
      ~tags:[]
      ~filename:"tuple_pool.ml.before-ppx"
      ~line_number:323
      ~start_pos:2
      ~end_pos:203
      (fun () ->
         for slots_per_tuple = 1 to max_slot do
           assert (
             start_of_tuples_index
             + ((1 + slots_per_tuple) * max_capacity ~slots_per_tuple)
             <= max_array_length)
         done;
         ())
  ;;

  module Metadata = struct
    type 'slots t =
      { slots_per_tuple : int
      ; capacity : int
      ; mutable length : int
      ; mutable next_id : Tuple_id.t
      ; mutable first_free : Header.t
      ; dummy : (Obj.t Uniform_array.t[@sexp.opaque]) option
      }
    [@@deriving fields ~iterators:iter, sexp_of]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'slots t) -> ()
      let dummy _r__ = _r__.dummy
      let _ = dummy
      let first_free _r__ = _r__.first_free
      let _ = first_free
      let set_first_free _r__ v__ = _r__.first_free <- v__
      let _ = set_first_free
      let next_id _r__ = _r__.next_id
      let _ = next_id
      let set_next_id _r__ v__ = _r__.next_id <- v__
      let _ = set_next_id
      let length _r__ = _r__.length
      let _ = length
      let set_length _r__ v__ = _r__.length <- v__
      let _ = set_length
      let capacity _r__ = _r__.capacity
      let _ = capacity
      let slots_per_tuple _r__ = _r__.slots_per_tuple
      let _ = slots_per_tuple

      module Fields = struct
        let dummy =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "dummy"
             ; getter = dummy
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with dummy = v__ })
             }
           : ( [< `Read | `Set_and_create ]
               , _
               , (Obj.t Uniform_array.t[@sexp.opaque]) option )
               Fieldslib.Field.t_with_perm)
        ;;

        let _ = dummy

        let first_free =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "first_free"
             ; getter = first_free
             ; setter = Some set_first_free
             ; fset = (fun _r__ v__ -> { _r__ with first_free = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Header.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = first_free

        let next_id =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "next_id"
             ; getter = next_id
             ; setter = Some set_next_id
             ; fset = (fun _r__ v__ -> { _r__ with next_id = v__ })
             }
           : ([< `Read | `Set_and_create ], _, Tuple_id.t) Fieldslib.Field.t_with_perm)
        ;;

        let _ = next_id

        let length =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "length"
             ; getter = length
             ; setter = Some set_length
             ; fset = (fun _r__ v__ -> { _r__ with length = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = length

        let capacity =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "capacity"
             ; getter = capacity
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with capacity = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = capacity

        let slots_per_tuple =
          (Fieldslib.Field.Field
             { Fieldslib.Field.For_generated_code.force_variance =
                 (fun (_ : [< `Read | `Set_and_create ]) -> ())
             ; name = "slots_per_tuple"
             ; getter = slots_per_tuple
             ; setter = None
             ; fset = (fun _r__ v__ -> { _r__ with slots_per_tuple = v__ })
             }
           : ([< `Read | `Set_and_create ], _, int) Fieldslib.Field.t_with_perm)
        ;;

        let _ = slots_per_tuple

        let iter
              ~slots_per_tuple:slots_per_tuple_fun__
              ~capacity:capacity_fun__
              ~length:length_fun__
              ~next_id:next_id_fun__
              ~first_free:first_free_fun__
              ~dummy:dummy_fun__
          =
          (slots_per_tuple_fun__ slots_per_tuple : unit);
          (capacity_fun__ capacity : unit);
          (length_fun__ length : unit);
          (next_id_fun__ next_id : unit);
          (first_free_fun__ first_free : unit);
          (dummy_fun__ dummy : unit)
        ;;

        let _ = iter
      end

      let sexp_of_t : 'slots. ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t =
        fun _of_slots__014_
          { slots_per_tuple = slots_per_tuple__016_
          ; capacity = capacity__018_
          ; length = length__020_
          ; next_id = next_id__022_
          ; first_free = first_free__024_
          ; dummy = dummy__026_
          } ->
        let bnds__015_ = ([] : _ Stdlib.List.t) in
        let bnds__015_ =
          let arg__027_ = sexp_of_option Sexplib0.Sexp_conv.sexp_of_opaque dummy__026_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "dummy"; arg__027_ ] :: bnds__015_
           : _ Stdlib.List.t)
        in
        let bnds__015_ =
          let arg__025_ = Header.sexp_of_t first_free__024_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "first_free"; arg__025_ ] :: bnds__015_
           : _ Stdlib.List.t)
        in
        let bnds__015_ =
          let arg__023_ = Tuple_id.sexp_of_t next_id__022_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "next_id"; arg__023_ ] :: bnds__015_
           : _ Stdlib.List.t)
        in
        let bnds__015_ =
          let arg__021_ = sexp_of_int length__020_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "length"; arg__021_ ] :: bnds__015_
           : _ Stdlib.List.t)
        in
        let bnds__015_ =
          let arg__019_ = sexp_of_int capacity__018_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "capacity"; arg__019_ ] :: bnds__015_
           : _ Stdlib.List.t)
        in
        let bnds__015_ =
          let arg__017_ = sexp_of_int slots_per_tuple__016_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "slots_per_tuple"; arg__017_ ]
           :: bnds__015_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__015_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let array_indices_per_tuple t = 1 + t.slots_per_tuple
    let array_length t = start_of_tuples_index + (t.capacity * array_indices_per_tuple t)

    let header_index_to_tuple_num t ~header_index =
      (header_index - start_of_tuples_index) / array_indices_per_tuple t
    ;;

    let tuple_num_to_header_index t tuple_num =
      start_of_tuples_index + (tuple_num * array_indices_per_tuple t)
    ;;

    let tuple_num_to_first_slot_index t tuple_num =
      tuple_num_to_header_index t tuple_num + 1
    ;;

    let is_full t = t.length = t.capacity
  end

  open Metadata

  type 'slots t = Obj.t Uniform_array.t

  let metadata (type slots) (t : slots t) =
    (Obj.obj : _ -> slots Metadata.t) (Uniform_array.unsafe_get t metadata_index)
  ;;

  let length t = (metadata t).length
  let sexp_of_t sexp_of_ty t = Metadata.sexp_of_t sexp_of_ty (metadata t)

  let unsafe_header t ~header_index =
    (Obj.obj : _ -> Header.t) (Uniform_array.unsafe_get t header_index)
  ;;

  let unsafe_set_header t ~header_index (header : Header.t) =
    Uniform_array.unsafe_set_int_assuming_currently_int t header_index (header :> int)
  ;;

  let header_index_is_in_bounds t ~header_index =
    header_index >= start_of_tuples_index && header_index < Uniform_array.length t
  ;;

  let unsafe_pointer_is_live t pointer =
    let header_index = Pointer.header_index pointer in
    let header = unsafe_header t ~header_index in
    Header.is_used header
    && Tuple_id.to_int (Header.tuple_id header) land tuple_id_mask
       = Pointer.masked_tuple_id pointer
  ;;

  let pointer_is_valid t pointer =
    header_index_is_in_bounds t ~header_index:(Pointer.header_index pointer)
    && unsafe_pointer_is_live t pointer
  ;;

  let id_of_pointer _t pointer = Pointer.to_id pointer

  let is_valid_header_index t ~header_index =
    let metadata = metadata t in
    header_index_is_in_bounds t ~header_index
    && 0
       = (header_index - start_of_tuples_index)
         mod Metadata.array_indices_per_tuple metadata
  ;;

  let pointer_of_id_exn t id =
    try
      let pointer = Pointer.of_id_exn id in
      if not (Pointer.is_null pointer)
      then (
        let header_index = Pointer.header_index pointer in
        if not (is_valid_header_index t ~header_index)
        then
          failwiths
            ~here:
              { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
              ; pos_lnum = 429
              ; pos_cnum = 13902
              ; pos_bol = 13873
              }
            "invalid header index"
            header_index
            (sexp_of_int [@merlin.hide]);
        if not (unsafe_pointer_is_live t pointer) then failwith "pointer not live");
      pointer
    with
    | exn ->
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 435
          ; pos_cnum = 14114
          ; pos_bol = 14100
          }
        "Pool.pointer_of_id_exn got invalid id"
        (id, t, exn)
        ((fun (arg0__028_, arg1__029_, arg2__030_) ->
           let res0__031_ = Pointer.Id.sexp_of_t arg0__028_
           and res1__032_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__029_
           and res2__033_ = sexp_of_exn arg2__030_ in
           Sexplib0.Sexp.List [ res0__031_; res1__032_; res2__033_ ]) [@merlin.hide])
  ;;

  let invariant _invariant_a t : unit =
    try
      let metadata = metadata t in
      let check f field = f (Field.get field metadata) in
      Metadata.Fields.iter
        ~slots_per_tuple:(check (fun slots_per_tuple -> assert (slots_per_tuple > 0)))
        ~capacity:
          (check (fun capacity ->
             assert (capacity >= 0);
             assert (Uniform_array.length t = Metadata.array_length metadata)))
        ~length:
          (check (fun length ->
             assert (length >= 0);
             assert (length <= metadata.capacity)))
        ~next_id:(check Tuple_id.invariant)
        ~first_free:
          (check (fun first_free ->
             let free = Array.create ~len:metadata.capacity false in
             let r = ref first_free in
             while not (Header.is_null !r) do
               let header = !r in
               assert (Header.is_free header);
               let header_index = Header.next_free_header_index header in
               assert (is_valid_header_index t ~header_index);
               let tuple_num = header_index_to_tuple_num metadata ~header_index in
               if free.(tuple_num)
               then
                 failwiths
                   ~here:
                     { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
                     ; pos_lnum = 467
                     ; pos_cnum = 15430
                     ; pos_bol = 15394
                     }
                   "cycle in free list"
                   tuple_num
                   (sexp_of_int [@merlin.hide]);
               free.(tuple_num) <- true;
               r := unsafe_header t ~header_index
             done))
        ~dummy:
          (check (function
             | Some dummy ->
               assert (Uniform_array.length dummy = metadata.slots_per_tuple)
             | None ->
               for tuple_num = 0 to metadata.capacity - 1 do
                 let header_index = tuple_num_to_header_index metadata tuple_num in
                 let header = unsafe_header t ~header_index in
                 if Header.is_free header
                 then (
                   let first_slot = tuple_num_to_first_slot_index metadata tuple_num in
                   for slot = 0 to metadata.slots_per_tuple - 1 do
                     assert (Obj.is_int (Uniform_array.get t (first_slot + slot)))
                   done)
               done))
    with
    | exn ->
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 487
          ; pos_cnum = 16346
          ; pos_bol = 16324
          }
        "Pool.invariant failed"
        (exn, t)
        ((fun (arg0__034_, arg1__035_) ->
           let res0__036_ = sexp_of_exn arg0__034_
           and res1__037_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__035_ in
           Sexplib0.Sexp.List [ res0__036_; res1__037_ ]) [@merlin.hide])
  ;;

  let capacity t = (metadata t).capacity
  let is_full t = Metadata.is_full (metadata t)

  let unsafe_add_to_free_list t metadata ~header_index =
    unsafe_set_header t ~header_index metadata.first_free;
    metadata.first_free <- Header.free ~next_free_header_index:header_index
  ;;

  let set_metadata (type slots) (t : slots t) metadata =
    Uniform_array.set t metadata_index (Obj.repr (metadata : slots Metadata.t))
  ;;

  let create_array (type slots) (metadata : slots Metadata.t) : slots t =
    let t = Uniform_array.create_obj_array ~len:(Metadata.array_length metadata) in
    set_metadata t metadata;
    t
  ;;

  let unsafe_init_range t metadata ~lo ~hi =
    (match metadata.dummy with
     | None -> ()
     | Some dummy ->
       for tuple_num = lo to hi - 1 do
         Uniform_array.blit
           ~src:dummy
           ~src_pos:0
           ~dst:t
           ~dst_pos:(tuple_num_to_first_slot_index metadata tuple_num)
           ~len:metadata.slots_per_tuple
       done);
    for tuple_num = hi - 1 downto lo do
      unsafe_add_to_free_list
        t
        metadata
        ~header_index:(tuple_num_to_header_index metadata tuple_num)
    done
  ;;

  let create_with_dummy slots ~capacity ~dummy =
    if capacity < 0
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 534
          ; pos_cnum = 17885
          ; pos_bol = 17863
          }
        "Pool.create got invalid capacity"
        capacity
        (sexp_of_int [@merlin.hide]);
    let slots_per_tuple = Slots.slots_per_tuple slots in
    let max_capacity = max_capacity ~slots_per_tuple in
    if capacity > max_capacity
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 540
          ; pos_cnum = 18137
          ; pos_bol = 18123
          }
        "Pool.create got too large capacity"
        (capacity, `max max_capacity)
        ((fun (arg0__039_, arg1__040_) ->
           let res0__041_ = sexp_of_int arg0__039_
           and res1__042_ =
             let (`max v__038_) = arg1__040_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "max"; sexp_of_int v__038_ ]
           in
           Sexplib0.Sexp.List [ res0__041_; res1__042_ ]) [@merlin.hide]);
    let metadata =
      { Metadata.slots_per_tuple
      ; capacity
      ; length = 0
      ; next_id = Tuple_id.init
      ; first_free = Header.null
      ; dummy
      }
    in
    let t = create_array metadata in
    unsafe_init_range t metadata ~lo:0 ~hi:capacity;
    t
  ;;

  let create (type tuple) (slots : (tuple, _) Slots.t) ~capacity ~dummy =
    let dummy =
      if Slots.slots_per_tuple slots = 1
      then Uniform_array.singleton (Obj.repr (dummy : tuple))
      else (Obj.magic (dummy : tuple) : Obj.t Uniform_array.t)
    in
    create_with_dummy slots ~capacity ~dummy:(Some dummy)
  ;;

  let destroy t =
    let metadata = metadata t in
    (match metadata.dummy with
     | None ->
       for i = start_of_tuples_index to Uniform_array.length t - 1 do
         Uniform_array.unsafe_set t i (Obj.repr 0)
       done
     | Some dummy ->
       for tuple_num = 0 to metadata.capacity - 1 do
         let header_index = tuple_num_to_header_index metadata tuple_num in
         unsafe_set_header t ~header_index Header.null;
         Uniform_array.blit
           ~src:dummy
           ~src_pos:0
           ~dst:t
           ~dst_pos:(header_index + 1)
           ~len:metadata.slots_per_tuple
       done);
    let metadata =
      { Metadata.slots_per_tuple = metadata.slots_per_tuple
      ; capacity = 0
      ; length = 0
      ; next_id = metadata.next_id
      ; first_free = Header.null
      ; dummy = metadata.dummy
      }
    in
    set_metadata t metadata
  ;;

  let grow ?capacity t =
    let { Metadata.slots_per_tuple
        ; capacity = old_capacity
        ; length
        ; next_id
        ; first_free = _
        ; dummy
        }
      =
      metadata t
    in
    let capacity =
      min (max_capacity ~slots_per_tuple) (grow_capacity ~capacity ~old_capacity)
    in
    if capacity = old_capacity
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 619
          ; pos_cnum = 20510
          ; pos_bol = 20496
          }
        "Pool.grow cannot grow pool; capacity already at maximum"
        capacity
        (sexp_of_int [@merlin.hide]);
    let metadata =
      { Metadata.slots_per_tuple
      ; capacity
      ; length
      ; next_id
      ; first_free = Header.null
      ; dummy
      }
    in
    let t' = create_array metadata in
    Uniform_array.blit
      ~src:t
      ~src_pos:start_of_tuples_index
      ~dst:t'
      ~dst_pos:start_of_tuples_index
      ~len:(old_capacity * Metadata.array_indices_per_tuple metadata);
    destroy t;
    unsafe_init_range t' metadata ~lo:old_capacity ~hi:capacity;
    for tuple_num = old_capacity - 1 downto 0 do
      let header_index = tuple_num_to_header_index metadata tuple_num in
      let header = unsafe_header t' ~header_index in
      if not (Header.is_used header)
      then unsafe_add_to_free_list t' metadata ~header_index
    done;
    t'
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let raise_malloc_full t =
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
        ; pos_lnum = 651
        ; pos_cnum = 21452
        ; pos_bol = 21432
        }
      "Pool.malloc of full pool"
      t
      ((fun x__043_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__043_)
         [@merlin.hide])
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let malloc (type slots) (t : slots t) : slots Pointer.t =
    let metadata = metadata t in
    let first_free = metadata.first_free in
    if Header.is_null first_free then raise_malloc_full t;
    let header_index = Header.next_free_header_index first_free in
    metadata.first_free <- unsafe_header t ~header_index;
    metadata.length <- metadata.length + 1;
    let tuple_id = metadata.next_id in
    unsafe_set_header t ~header_index (Header.used tuple_id);
    metadata.next_id <- Tuple_id.next tuple_id;
    Pointer.create ~header_index tuple_id
  ;;

  let unsafe_free (type slots) (t : slots t) (pointer : slots Pointer.t) =
    let metadata = metadata t in
    metadata.length <- metadata.length - 1;
    unsafe_add_to_free_list t metadata ~header_index:(Pointer.header_index pointer);
    match metadata.dummy with
    | None ->
      let pos = Pointer.first_slot_index pointer in
      for i = 0 to metadata.slots_per_tuple - 1 do
        Uniform_array.unsafe_clear_if_pointer t (pos + i)
      done
    | Some dummy ->
      Uniform_array.unsafe_blit
        ~src:dummy
        ~src_pos:0
        ~len:metadata.slots_per_tuple
        ~dst:t
        ~dst_pos:(Pointer.first_slot_index pointer)
  ;;

  let free (type slots) (t : slots t) (pointer : slots Pointer.t) =
    if not (pointer_is_valid t pointer)
    then
      failwiths
        ~here:
          { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
          ; pos_lnum = 694
          ; pos_cnum = 23079
          ; pos_bol = 23065
          }
        "Pool.free of invalid pointer"
        (pointer, t)
        ((fun (arg0__044_, arg1__045_) ->
           let res0__046_ = Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg0__044_
           and res1__047_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__045_ in
           Sexplib0.Sexp.List [ res0__046_; res1__047_ ]) [@merlin.hide]);
    unsafe_free t pointer
  ;;

  let new1 t a0 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    pointer
  ;;

  let new2 t a0 a1 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    pointer
  ;;

  let new3 t a0 a1 a2 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    pointer
  ;;

  let new4 t a0 a1 a2 a3 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    pointer
  ;;

  let new5 t a0 a1 a2 a3 a4 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    pointer
  ;;

  let new6 t a0 a1 a2 a3 a4 a5 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    pointer
  ;;

  let new7 t a0 a1 a2 a3 a4 a5 a6 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    pointer
  ;;

  let new8 t a0 a1 a2 a3 a4 a5 a6 a7 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    pointer
  ;;

  let new9 t a0 a1 a2 a3 a4 a5 a6 a7 a8 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    pointer
  ;;

  let new10 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    Uniform_array.unsafe_set t (offset + 10) (Obj.repr a9);
    pointer
  ;;

  let new11 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    Uniform_array.unsafe_set t (offset + 10) (Obj.repr a9);
    Uniform_array.unsafe_set t (offset + 11) (Obj.repr a10);
    pointer
  ;;

  let new12 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    Uniform_array.unsafe_set t (offset + 10) (Obj.repr a9);
    Uniform_array.unsafe_set t (offset + 11) (Obj.repr a10);
    Uniform_array.unsafe_set t (offset + 12) (Obj.repr a11);
    pointer
  ;;

  let new13 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    Uniform_array.unsafe_set t (offset + 10) (Obj.repr a9);
    Uniform_array.unsafe_set t (offset + 11) (Obj.repr a10);
    Uniform_array.unsafe_set t (offset + 12) (Obj.repr a11);
    Uniform_array.unsafe_set t (offset + 13) (Obj.repr a12);
    pointer
  ;;

  let new14 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 =
    let pointer = malloc t in
    let offset = Pointer.header_index pointer in
    Uniform_array.unsafe_set t (offset + 1) (Obj.repr a0);
    Uniform_array.unsafe_set t (offset + 2) (Obj.repr a1);
    Uniform_array.unsafe_set t (offset + 3) (Obj.repr a2);
    Uniform_array.unsafe_set t (offset + 4) (Obj.repr a3);
    Uniform_array.unsafe_set t (offset + 5) (Obj.repr a4);
    Uniform_array.unsafe_set t (offset + 6) (Obj.repr a5);
    Uniform_array.unsafe_set t (offset + 7) (Obj.repr a6);
    Uniform_array.unsafe_set t (offset + 8) (Obj.repr a7);
    Uniform_array.unsafe_set t (offset + 9) (Obj.repr a8);
    Uniform_array.unsafe_set t (offset + 10) (Obj.repr a9);
    Uniform_array.unsafe_set t (offset + 11) (Obj.repr a10);
    Uniform_array.unsafe_set t (offset + 12) (Obj.repr a11);
    Uniform_array.unsafe_set t (offset + 13) (Obj.repr a12);
    Uniform_array.unsafe_set t (offset + 14) (Obj.repr a13);
    pointer
  ;;

  let get t p slot = Obj.obj (Uniform_array.get t (Pointer.slot_index p slot))

  let unsafe_get t p slot =
    Obj.obj (Uniform_array.unsafe_get t (Pointer.slot_index p slot))
  ;;

  let set t p slot x = Uniform_array.set t (Pointer.slot_index p slot) (Obj.repr x)

  let unsafe_set t p slot x =
    Uniform_array.unsafe_set t (Pointer.slot_index p slot) (Obj.repr x)
  ;;

  let get_tuple (type tuple) (t : (tuple, _) Slots.t t) pointer =
    let metadata = metadata t in
    let len = metadata.slots_per_tuple in
    if len = 1
    then get t pointer Slot.t0
    else
      (Obj.magic
         (Uniform_array.sub t ~pos:(Pointer.first_slot_index pointer) ~len
          : Obj.t Uniform_array.t)
       : tuple)
  ;;
end

include Pool

module Unsafe = struct
  include Pool

  let create slots ~capacity = create_with_dummy slots ~capacity ~dummy:None
end

module Debug (Pool : S) = struct
  open Pool

  let check_invariant = ref true
  let show_messages = ref true

  let debug name ts arg sexp_of_arg sexp_of_result f =
    let prefix = "Pool." in
    if !check_invariant then List.iter ts ~f:(invariant ignore);
    if !show_messages then Debug.eprints (concat [ prefix; name ]) arg sexp_of_arg;
    let result_or_exn = Result.try_with f in
    if !show_messages
    then
      Debug.eprints
        (concat [ prefix; name; " result" ])
        result_or_exn
        ((fun x__048_ -> Result.sexp_of_t sexp_of_result sexp_of_exn x__048_)
           [@merlin.hide]);
    Result.ok_exn result_or_exn
  ;;

  module Slots = Slots
  module Slot = Slot

  module Pointer = struct
    open Pointer

    type nonrec 'slots t = 'slots t [@@deriving sexp_of, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'slots t) -> ()

      let sexp_of_t : 'slots. ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t =
        fun _of_slots__049_ x__050_ -> sexp_of_t _of_slots__049_ x__050_
      ;;

      let _ = sexp_of_t

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
          type nonrec 'slots t = 'slots t

          let name = "tuple_pool.ml.before-ppx.Debug.Pointer.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        : 'slots. 'slots Typerep_lib.Std.Typerep.t -> 'slots t Typerep_lib.Std.Typerep.t
        =
        fun (type slots) ->
        fun (_of_slots : slots Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_slots in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy (typerep_of_t _of_slots)))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let phys_compare t1 t2 =
      debug
        "Pointer.phys_compare"
        []
        (t1, t2)
        ((fun (arg0__051_, arg1__052_) ->
           let res0__053_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg0__051_
           and res1__054_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__052_ in
           Sexplib0.Sexp.List [ res0__053_; res1__054_ ]) [@merlin.hide])
        (sexp_of_int [@merlin.hide])
        (fun () -> phys_compare t1 t2)
    ;;

    let phys_equal t1 t2 =
      debug
        "Pointer.phys_equal"
        []
        (t1, t2)
        ((fun (arg0__055_, arg1__056_) ->
           let res0__057_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg0__055_
           and res1__058_ = sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") arg1__056_ in
           Sexplib0.Sexp.List [ res0__057_; res1__058_ ]) [@merlin.hide])
        (sexp_of_bool [@merlin.hide])
        (fun () -> phys_equal t1 t2)
    ;;

    let is_null t =
      debug
        "Pointer.is_null"
        []
        t
        ((fun x__059_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__059_)
           [@merlin.hide])
        (sexp_of_bool [@merlin.hide])
        (fun () -> is_null t)
    ;;

    let null = null

    module Id = struct
      open Id

      type nonrec t = t [@@deriving bin_io, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "tuple_pool.ml.before-ppx:980:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let of_int63 i =
        debug
          "Pointer.Id.of_int63"
          []
          i
          (Int63.sexp_of_t [@merlin.hide])
          (sexp_of_t [@merlin.hide])
          (fun () -> of_int63 i)
      ;;

      let to_int63 t =
        debug
          "Pointer.Id.to_int63"
          []
          t
          (sexp_of_t [@merlin.hide])
          (Int63.sexp_of_t [@merlin.hide])
          (fun () -> to_int63 t)
      ;;
    end
  end

  type nonrec 'slots t = 'slots t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'slots t) -> ()

    let sexp_of_t : 'slots. ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t =
      fun _of_slots__061_ x__062_ -> sexp_of_t _of_slots__061_ x__062_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let invariant = invariant
  let length = length

  let id_of_pointer t pointer =
    debug
      "id_of_pointer"
      [ t ]
      pointer
      ((fun x__063_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__063_)
         [@merlin.hide])
      (Pointer.Id.sexp_of_t [@merlin.hide])
      (fun () -> id_of_pointer t pointer)
  ;;

  let pointer_of_id_exn t id =
    debug
      "pointer_of_id_exn"
      [ t ]
      id
      (Pointer.Id.sexp_of_t [@merlin.hide])
      ((fun x__064_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__064_)
         [@merlin.hide])
      (fun () -> pointer_of_id_exn t id)
  ;;

  let pointer_is_valid t pointer =
    debug
      "pointer_is_valid"
      [ t ]
      pointer
      ((fun x__065_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__065_)
         [@merlin.hide])
      (sexp_of_bool [@merlin.hide])
      (fun () -> pointer_is_valid t pointer)
  ;;

  let create slots ~capacity ~dummy =
    debug
      "create"
      []
      capacity
      (sexp_of_int [@merlin.hide])
      ((fun x__066_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__066_)
         [@merlin.hide])
      (fun () -> create slots ~capacity ~dummy)
  ;;

  let max_capacity ~slots_per_tuple =
    debug
      "max_capacity"
      []
      slots_per_tuple
      (sexp_of_int [@merlin.hide])
      (sexp_of_int [@merlin.hide])
      (fun () -> max_capacity ~slots_per_tuple)
  ;;

  let capacity t =
    debug
      "capacity"
      [ t ]
      t
      ((fun x__067_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__067_)
         [@merlin.hide])
      (sexp_of_int [@merlin.hide])
      (fun () -> capacity t)
  ;;

  let grow ?capacity t =
    debug
      "grow"
      [ t ]
      (`capacity capacity)
      ((fun (`capacity v__068_) ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "capacity"; sexp_of_option sexp_of_int v__068_ ])
         [@merlin.hide])
      ((fun x__069_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__069_)
         [@merlin.hide])
      (fun () -> grow ?capacity t)
  ;;

  let is_full t =
    debug
      "is_full"
      [ t ]
      t
      ((fun x__070_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__070_)
         [@merlin.hide])
      (sexp_of_bool [@merlin.hide])
      (fun () -> is_full t)
  ;;

  let unsafe_free t p =
    debug
      "unsafe_free"
      [ t ]
      p
      ((fun x__071_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__071_)
         [@merlin.hide])
      (sexp_of_unit [@merlin.hide])
      (fun () -> unsafe_free t p)
  ;;

  let free t p =
    debug
      "free"
      [ t ]
      p
      ((fun x__072_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__072_)
         [@merlin.hide])
      (sexp_of_unit [@merlin.hide])
      (fun () -> free t p)
  ;;

  let debug_new t f =
    debug
      "new"
      [ t ]
      ()
      (sexp_of_unit [@merlin.hide])
      ((fun x__073_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__073_)
         [@merlin.hide])
      f
  ;;

  let new1 t a0 = debug_new t (fun () -> new1 t a0)
  let new2 t a0 a1 = debug_new t (fun () -> new2 t a0 a1)
  let new3 t a0 a1 a2 = debug_new t (fun () -> new3 t a0 a1 a2)
  let new4 t a0 a1 a2 a3 = debug_new t (fun () -> new4 t a0 a1 a2 a3)
  let new5 t a0 a1 a2 a3 a4 = debug_new t (fun () -> new5 t a0 a1 a2 a3 a4)
  let new6 t a0 a1 a2 a3 a4 a5 = debug_new t (fun () -> new6 t a0 a1 a2 a3 a4 a5)
  let new7 t a0 a1 a2 a3 a4 a5 a6 = debug_new t (fun () -> new7 t a0 a1 a2 a3 a4 a5 a6)

  let new8 t a0 a1 a2 a3 a4 a5 a6 a7 =
    debug_new t (fun () -> new8 t a0 a1 a2 a3 a4 a5 a6 a7)
  ;;

  let new9 t a0 a1 a2 a3 a4 a5 a6 a7 a8 =
    debug_new t (fun () -> new9 t a0 a1 a2 a3 a4 a5 a6 a7 a8)
  ;;

  let new10 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 =
    debug_new t (fun () -> new10 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9)
  ;;

  let new11 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 =
    debug_new t (fun () -> new11 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10)
  ;;

  let new12 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 =
    debug_new t (fun () -> new12 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11)
  ;;

  let new13 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 =
    debug_new t (fun () -> new13 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
  ;;

  let new14 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 =
    debug_new t (fun () -> new14 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13)
  ;;

  let get_tuple t pointer =
    debug
      "get_tuple"
      [ t ]
      pointer
      ((fun x__074_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__074_)
         [@merlin.hide])
      ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      (fun () -> get_tuple t pointer)
  ;;

  let debug_get name f t pointer =
    debug
      name
      [ t ]
      pointer
      ((fun x__075_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__075_)
         [@merlin.hide])
      ((fun _ -> Sexplib0.Sexp.Atom "_") [@merlin.hide])
      (fun () -> f t pointer)
  ;;

  let get t pointer slot = debug_get "get" get t pointer slot
  let unsafe_get t pointer slot = debug_get "unsafe_get" unsafe_get t pointer slot

  let debug_set name f t pointer slot a =
    debug
      name
      [ t ]
      pointer
      ((fun x__076_ -> Pointer.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__076_)
         [@merlin.hide])
      (sexp_of_unit [@merlin.hide])
      (fun () -> f t pointer slot a)
  ;;

  let set t pointer slot a = debug_set "set" set t pointer slot a
  let unsafe_set t pointer slot a = debug_set "unsafe_set" unsafe_set t pointer slot a
end

module Error_check (Pool : S) = struct
  open Pool
  module Slots = Slots
  module Slot = Slot

  module Pointer = struct
    type 'slots t =
      { mutable is_valid : bool
      ; pointer : 'slots Pointer.t
      }
    [@@deriving sexp_of, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : 'slots t) -> ()

      let sexp_of_t : 'slots. ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t =
        fun _of_slots__077_ { is_valid = is_valid__079_; pointer = pointer__081_ } ->
        let bnds__078_ = ([] : _ Stdlib.List.t) in
        let bnds__078_ =
          let arg__082_ = Pointer.sexp_of_t _of_slots__077_ pointer__081_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "pointer"; arg__082_ ] :: bnds__078_
           : _ Stdlib.List.t)
        in
        let bnds__078_ =
          let arg__080_ = sexp_of_bool is_valid__079_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "is_valid"; arg__080_ ] :: bnds__078_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__078_
      ;;

      let _ = sexp_of_t

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make1 (struct
          type nonrec 'slots t = 'slots t

          let name = "tuple_pool.ml.before-ppx.Error_check.Pointer.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t
        : 'slots. 'slots Typerep_lib.Std.Typerep.t -> 'slots t Typerep_lib.Std.Typerep.t
        =
        fun (type slots) ->
        fun (_of_slots : slots Typerep_lib.Std.Typerep.t) ->
        let name_of_t = Typename_of_t.named _of_slots in
        Typerep_lib.Std.Typerep.Named
          ( name_of_t
          , Some
              (lazy
                (let field0 =
                   Typerep_lib.Std.Typerep.Field.internal_use_only
                     { Typerep_lib.Std.Typerep.Field_internal.label = "is_valid"
                     ; index = 0
                     ; is_mutable = true
                     ; rep = typerep_of_bool
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; get = (fun t -> t.is_valid)
                     }
                 in
                 let field1 =
                   Typerep_lib.Std.Typerep.Field.internal_use_only
                     { Typerep_lib.Std.Typerep.Field_internal.label = "pointer"
                     ; index = 1
                     ; is_mutable = false
                     ; rep = Pointer.typerep_of_t _of_slots
                     ; tyid = Typerep_lib.Std.Typename.create ()
                     ; get = (fun t -> t.pointer)
                     }
                 in
                 let typename = Typerep_lib.Std.Typerep.Named.typename_of_t name_of_t in
                 let has_double_array_tag =
                   Typerep_lib.Std.Typerep_obj.has_double_array_tag
                     { is_valid = Typerep_lib.Std.Typerep_obj.double_array_value ()
                     ; pointer = Typerep_lib.Std.Typerep_obj.double_array_value ()
                     }
                 in
                 let fields =
                   [| Typerep_lib.Std.Typerep.Record_internal.Field field0
                    ; Typerep_lib.Std.Typerep.Record_internal.Field field1
                   |]
                 in
                 let create { Typerep_lib.Std.Typerep.Record_internal.get } =
                   let is_valid = get field0
                   and pointer = get field1 in
                   { is_valid; pointer }
                 in
                 Typerep_lib.Std.Typerep.Record
                   (Typerep_lib.Std.Typerep.Record.internal_use_only
                      { Typerep_lib.Std.Typerep.Record_internal.typename
                      ; Typerep_lib.Std.Typerep.Record_internal.has_double_array_tag
                      ; Typerep_lib.Std.Typerep.Record_internal.fields
                      ; Typerep_lib.Std.Typerep.Record_internal.create
                      }))) )
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create pointer = { is_valid = true; pointer }
    let null () = { is_valid = false; pointer = Pointer.null () }
    let phys_compare t1 t2 = Pointer.phys_compare t1.pointer t2.pointer
    let phys_equal t1 t2 = Pointer.phys_equal t1.pointer t2.pointer
    let is_null t = Pointer.is_null t.pointer

    let follow t =
      if not t.is_valid
      then
        failwiths
          ~here:
            { Ppx_here_lib.pos_fname = "tuple_pool.ml.before-ppx"
            ; pos_lnum = 1144
            ; pos_cnum = 38374
            ; pos_bol = 38347
            }
          "attempt to use invalid pointer"
          t
          ((fun x__083_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__083_)
             [@merlin.hide]);
      t.pointer
    ;;

    let invalidate t = t.is_valid <- false

    module Id = Pointer.Id
  end

  type 'slots t = 'slots Pool.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'slots t) -> ()

    let sexp_of_t : 'slots. ('slots -> Sexplib0.Sexp.t) -> 'slots t -> Sexplib0.Sexp.t =
      fun _of_slots__084_ x__085_ -> Pool.sexp_of_t _of_slots__084_ x__085_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let invariant = invariant
  let length = length

  let pointer_is_valid t { Pointer.is_valid; pointer } =
    is_valid && pointer_is_valid t pointer
  ;;

  let id_of_pointer t pointer = id_of_pointer t pointer.Pointer.pointer

  let pointer_of_id_exn t id =
    let pointer = pointer_of_id_exn t id in
    let is_valid = Pool.pointer_is_valid t pointer in
    { Pointer.is_valid; pointer }
  ;;

  let create = create
  let capacity = capacity
  let max_capacity = max_capacity
  let grow = grow
  let is_full = is_full
  let get_tuple t p = get_tuple t (Pointer.follow p)
  let get t p = get t (Pointer.follow p)
  let unsafe_get t p = unsafe_get t (Pointer.follow p)
  let set t p slot v = set t (Pointer.follow p) slot v
  let unsafe_set t p slot v = unsafe_set t (Pointer.follow p) slot v

  let unsafe_free t p =
    unsafe_free t (Pointer.follow p);
    Pointer.invalidate p
  ;;

  let free t p =
    free t (Pointer.follow p);
    Pointer.invalidate p
  ;;

  let new1 t a0 = Pointer.create (Pool.new1 t a0)
  let new2 t a0 a1 = Pointer.create (Pool.new2 t a0 a1)
  let new3 t a0 a1 a2 = Pointer.create (Pool.new3 t a0 a1 a2)
  let new4 t a0 a1 a2 a3 = Pointer.create (Pool.new4 t a0 a1 a2 a3)
  let new5 t a0 a1 a2 a3 a4 = Pointer.create (Pool.new5 t a0 a1 a2 a3 a4)
  let new6 t a0 a1 a2 a3 a4 a5 = Pointer.create (Pool.new6 t a0 a1 a2 a3 a4 a5)
  let new7 t a0 a1 a2 a3 a4 a5 a6 = Pointer.create (Pool.new7 t a0 a1 a2 a3 a4 a5 a6)

  let new8 t a0 a1 a2 a3 a4 a5 a6 a7 =
    Pointer.create (Pool.new8 t a0 a1 a2 a3 a4 a5 a6 a7)
  ;;

  let new9 t a0 a1 a2 a3 a4 a5 a6 a7 a8 =
    Pointer.create (Pool.new9 t a0 a1 a2 a3 a4 a5 a6 a7 a8)
  ;;

  let new10 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 =
    Pointer.create (Pool.new10 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9)
  ;;

  let new11 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 =
    Pointer.create (Pool.new11 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10)
  ;;

  let new12 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 =
    Pointer.create (Pool.new12 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11)
  ;;

  let new13 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 =
    Pointer.create (Pool.new13 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
  ;;

  let new14 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 =
    Pointer.create (Pool.new14 t a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13)
  ;;
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
