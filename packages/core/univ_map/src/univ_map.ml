let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"univ_map.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "univ_map.ml.before-ppx"
;;

open! Base
include Univ_map_intf
module Uid = Type_equal.Id.Uid

module Make1
    (Key : Key)
    (Data : sig
       type ('s, 'a) t [@@deriving sexp_of]

       include sig
         [@@@ocaml.warning "-32"]

         val sexp_of_t
           :  ('s -> Sexplib0.Sexp.t)
           -> ('a -> Sexplib0.Sexp.t)
           -> ('s, 'a) t
           -> Sexplib0.Sexp.t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end) =
struct
  module Key = struct
    type 'a t = 'a Key.t [@@deriving sexp_of]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__001_ x__002_ -> Key.sexp_of_t _of_a__001_ x__002_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let sexp_of_type_id type_id =
      Ppx_sexp_conv_lib.Sexp.List
        [ Ppx_sexp_conv_lib.Sexp.List
            [ Ppx_sexp_conv_lib.Sexp.Atom "name"
            ; (sexp_of_string [@merlin.hide]) (Type_equal.Id.name type_id)
            ]
        ; Ppx_sexp_conv_lib.Sexp.List
            [ Ppx_sexp_conv_lib.Sexp.Atom "uid"
            ; (Sexp.sexp_of_t [@merlin.hide])
                (if Ppx_inline_test_lib.am_running
                 then Sexp.Atom "<uid>"
                 else Type_equal.Id.Uid.sexp_of_t (Type_equal.Id.uid type_id))
            ]
        ]
    ;;

    let type_id key =
      let type_id1 = Key.type_id key in
      let type_id2 = Key.type_id key in
      if Type_equal.Id.same type_id1 type_id2
      then type_id1
      else
        raise_s
          (let ppx_sexp_message () =
             Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                   "[Key.type_id] must not provide different type ids when called on the \
                    same input"
               ; Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Sexp.Atom "key"
                   ; ((fun x__003_ ->
                        Key.sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__003_)
                        [@merlin.hide])
                       key
                   ]
               ; Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Sexp.Atom "type_id1"
                   ; (sexp_of_type_id [@merlin.hide]) type_id1
                   ]
               ; Ppx_sexp_conv_lib.Sexp.List
                   [ Ppx_sexp_conv_lib.Sexp.Atom "type_id2"
                   ; (sexp_of_type_id [@merlin.hide]) type_id2
                   ]
               ]
               [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
           in
           (ppx_sexp_message () [@nontail]))
    ;;
  end

  type ('s, 'a) data = ('s, 'a) Data.t

  let name_of_key key = Type_equal.Id.name (Key.type_id key)
  let uid_of_key key = Type_equal.Id.uid (Key.type_id key)

  module Packed = struct
    type 's t = T : 'a Key.t * ('s, 'a) Data.t -> 's t

    let sexp_of_t sexp_of_a (T (key, data)) =
      Data.sexp_of_t sexp_of_a (Type_equal.Id.to_sexp (Key.type_id key)) data
    ;;

    let type_id_name (T (key, _)) = name_of_key key
    let type_id_uid (T (key, _)) = uid_of_key key

    let compare t1 t2 =
      let c = String.compare (type_id_name t1) (type_id_name t2) in
      if c <> 0 then c else Uid.compare (type_id_uid t1) (type_id_uid t2)
    ;;
  end

  type 's t = 's Packed.t Map.M(Uid).t

  let to_alist t = List.sort ~compare:Packed.compare (Map.data t)

  let sexp_of_t sexp_of_a t =
    ((fun x__008_ ->
       sexp_of_list
         (fun (arg0__004_, arg1__005_) ->
            let res0__006_ = sexp_of_string arg0__004_
            and res1__007_ = Packed.sexp_of_t sexp_of_a arg1__005_ in
            Sexplib0.Sexp.List [ res0__006_; res1__007_ ])
         x__008_) [@merlin.hide])
      (List.map ~f:(fun packed -> Packed.type_id_name packed, packed) (to_alist t))
  ;;

  let invariant (t : _ t) =
    Invariant.invariant
      { Ppx_here_lib.pos_fname = "univ_map.ml.before-ppx"
      ; pos_lnum = 81
      ; pos_cnum = 2455
      ; pos_bol = 2431
      }
      t
      ((fun x__009_ -> sexp_of_t (fun _ -> Sexplib0.Sexp.Atom "_") x__009_)
         [@merlin.hide])
      (fun () ->
         Map.iteri t ~f:(fun ~key ~data ->
           assert (Uid.equal key (Packed.type_id_uid data))))
  ;;

  let set t ~key ~data = Map.set t ~key:(uid_of_key key) ~data:(Packed.T (key, data))
  let mem_by_id t id = Map.mem t id
  let mem t key = mem_by_id t (uid_of_key key)
  let remove_by_id t id = Map.remove t id
  let remove t key = remove_by_id t (uid_of_key key)
  let empty = Map.empty (module Uid)

  let singleton key data =
    Map.singleton (module Uid) (uid_of_key key) (Packed.T (key, data))
  ;;

  let is_empty = Map.is_empty

  let find (type b) t (key : b Key.t) =
    match Map.find t (uid_of_key key) with
    | None -> None
    | Some (Packed.T (key', value)) ->
      let Type_equal.T =
        Type_equal.Id.same_witness_exn (Key.type_id key) (Key.type_id key')
      in
      Some (value : (_, b) Data.t)
  ;;

  let find_exn t key =
    match find t key with
    | Some data -> data
    | None -> Printf.failwithf "Univ_map.find_exn on unknown key %s" (name_of_key key) ()
  ;;

  let add t ~key ~data = if mem t key then `Duplicate else `Ok (set t ~key ~data)

  let add_exn t ~key ~data =
    match add t ~key ~data with
    | `Ok t -> t
    | `Duplicate ->
      Printf.failwithf "Univ_map.add_exn on existing key %s" (name_of_key key) ()
  ;;

  let change_exn t key ~f:update =
    match find t key with
    | Some data -> set t ~key ~data:(update data)
    | None ->
      Printf.failwithf "Univ_map.change_exn on unknown key %s" (name_of_key key) ()
  ;;

  let change t key ~f:update =
    let orig = find t key in
    let next = update orig in
    match next with
    | Some data -> set t ~key ~data
    | None -> if Option.is_none orig then t else remove t key
  ;;

  let update t key ~f = change t key ~f:(fun data -> Some (f data))
  let key_id_set t = Set.of_list (module Uid) (Map.keys t)

  let of_alist_exn t =
    Map.of_alist_exn (module Uid) (List.map t ~f:(fun p -> Packed.type_id_uid p, p))
  ;;

  let find_packed_by_id = Map.find
  let find_packed_by_id_exn = Map.find_exn
  let type_equal : ('s t, 's Packed.t Map.M(Type_equal.Id.Uid).t) Type_equal.t = T
end

module Make
    (Key : Key)
    (Data : sig
       type 'a t [@@deriving sexp_of]

       include sig
         [@@@ocaml.warning "-32"]

         val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
       end
       [@@ocaml.doc "@inline"] [@@merlin.hide]
     end) =
struct
  module M =
    Make1
      (Key)
      (struct
        type (_, 'a) t = 'a Data.t [@@deriving sexp_of]

        include struct
          let _ = fun (_ : (_, 'a) t) -> ()

          let sexp_of_t
            :  'a__010_ 'a.
               ('a__010_ -> Sexplib0.Sexp.t)
            -> ('a -> Sexplib0.Sexp.t)
            -> ('a__010_, 'a) t
            -> Sexplib0.Sexp.t
            =
            fun _of_a__011_ _of_a__012_ x__013_ -> Data.sexp_of_t _of_a__012_ x__013_
          ;;

          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)

  type t = unit M.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun x__014_ -> M.sexp_of_t sexp_of_unit x__014_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Key = Key

  type 'a data = 'a Data.t

  let invariant = M.invariant
  let empty = M.empty
  let singleton = M.singleton
  let is_empty = M.is_empty
  let set = M.set
  let mem = M.mem
  let mem_by_id = M.mem_by_id
  let find = M.find
  let find_exn = M.find_exn
  let add = M.add
  let add_exn = M.add_exn
  let change = M.change
  let change_exn = M.change_exn
  let update = M.update
  let remove = M.remove
  let remove_by_id = M.remove_by_id

  module Packed = struct
    type 's t1 = 's M.Packed.t = T : 'a Key.t * 'a Data.t -> 's t1
    type t = unit t1
  end

  let key_id_set = M.key_id_set
  let to_alist = M.to_alist
  let of_alist_exn = M.of_alist_exn
  let find_packed_by_id = M.find_packed_by_id
  let find_packed_by_id_exn = M.find_packed_by_id_exn
  let type_equal : (t, Packed.t Map.M(Type_equal.Id.Uid).t) Type_equal.t = T
end

module Merge (Key : Key) (Input1_data : Data) (Input2_data : Data) (Output_data : Data) =
struct
  type f =
    { f :
        'a.
        key:'a Key.t
        -> [ `Left of 'a Input1_data.t
           | `Right of 'a Input2_data.t
           | `Both of 'a Input1_data.t * 'a Input2_data.t
           ]
        -> 'a Output_data.t option
    }

  module Output = Make (Key) (Output_data)

  let merge (t1 : Make(Key)(Input1_data).t) (t2 : Make(Key)(Input2_data).t) ~f:{ f }
    : Make(Key)(Output_data).t
    =
    let f ~key merge_result =
      Option.map (f ~key merge_result) ~f:(fun data -> Output.M.Packed.T (key, data))
    in
    Map.merge t1 t2 ~f:(fun ~key:_ -> function
      | `Left (T (key, data)) -> f ~key (`Left data)
      | `Right (T (key, data)) -> f ~key (`Right data)
      | `Both (T (left_key, left_data), T (right_key, right_data)) ->
        let Type_equal.T =
          Type_equal.Id.same_witness_exn (Key.type_id left_key) (Key.type_id right_key)
        in
        f ~key:left_key (`Both (left_data, right_data)))
  ;;
end

module Merge1
    (Key : Key)
    (Input1_data : Data1)
    (Input2_data : Data1)
    (Output_data : Data1) =
struct
  type ('s1, 's2, 's3) f =
    { f :
        'a.
        key:'a Key.t
        -> [ `Left of ('s1, 'a) Input1_data.t
           | `Right of ('s2, 'a) Input2_data.t
           | `Both of ('s1, 'a) Input1_data.t * ('s2, 'a) Input2_data.t
           ]
        -> ('s3, 'a) Output_data.t option
    }

  module Output = Make1 (Key) (Output_data)

  let merge
        (type s1)
        (type s2)
        (t1 : s1 Make1(Key)(Input1_data).t)
        (t2 : s2 Make1(Key)(Input2_data).t)
        ~f:{ f }
    =
    let f ~key merge_result =
      Option.map (f ~key merge_result) ~f:(fun data -> Output.Packed.T (key, data))
    in
    Map.merge t1 t2 ~f:(fun ~key:_ -> function
      | `Left (T (key, data)) -> f ~key (`Left data)
      | `Right (T (key, data)) -> f ~key (`Right data)
      | `Both (T (left_key, left_data), T (right_key, right_data)) ->
        let Type_equal.T =
          Type_equal.Id.same_witness_exn (Key.type_id left_key) (Key.type_id right_key)
        in
        f ~key:left_key (`Both (left_data, right_data)))
  ;;
end

module Type_id_key = struct
  type 'a t = 'a Type_equal.Id.t [@@deriving sexp_of]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__015_ x__016_ -> Type_equal.Id.sexp_of_t _of_a__015_ x__016_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let type_id = Fn.id
end

include (
  Make
    (Type_id_key)
    (struct
      type 'a t = 'a [@@deriving sexp_of]

      include struct
        let _ = fun (_ : 'a t) -> ()

        let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
          fun _of_a__017_ -> _of_a__017_
        ;;

        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end) :
      S with type 'a data = 'a and module Key := Type_id_key)

module Key = Type_equal.Id

module With_default = struct
  module Key = struct
    type 'a t =
      { key : 'a Type_equal.Id.t
      ; default : 'a
      }

    let create ~default ~name sexp_of =
      { default; key = Type_equal.Id.create ~name sexp_of }
    ;;

    let id t = t.key
  end

  let find t { Key.key; default } = Option.value ~default (find t key)
  let set t ~key:{ Key.key; default = _ } ~data = set t ~key ~data
  let change t key ~f:update = set t ~key ~data:(update (find t key))
end

module With_fold = struct
  module Key = struct
    type ('a, 'b) t =
      { key : 'b With_default.Key.t
      ; f : 'b -> 'a -> 'b
      }

    let create ~init ~f ~name sexp_of =
      { f; key = With_default.Key.create ~default:init ~name sexp_of }
    ;;

    let id t = With_default.Key.id t.key
  end

  let find t { Key.key; f = _ } = With_default.find t key
  let set t ~key:{ Key.key; f = _ } ~data = With_default.set t ~key ~data
  let change t { Key.key; f = _ } ~f:update = With_default.change t key ~f:update

  let add t ~key:{ Key.key; f } ~data =
    With_default.change t key ~f:(fun acc -> f acc data)
  ;;
end

module Multi = struct
  open With_fold

  module Key = struct
    type 'a t = ('a, 'a list) Key.t

    let create ~name sexp_of =
      Key.create ~init:[] ~f:(fun xs x -> x :: xs) ~name (List.sexp_of_t sexp_of)
    ;;

    let id = With_fold.Key.id
  end

  let set = set
  let find = find
  let add = add
  let change = change
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
