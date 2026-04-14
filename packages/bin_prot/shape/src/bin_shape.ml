open! Base

module Location : sig
  include Identifiable.S
end = struct
  include String
end

module Uuid : sig
  include Identifiable.S
end = struct
  include String
end

let eval_fail loc fmt =
  Printf.ksprintf
    (fun s ->
       failwith
         (Printf.sprintf
            ((Format
                ( Custom
                    ( Custom_succ Custom_zero
                    , (fun () _custom_printf__001_ ->
                        Location.to_string _custom_printf__001_)
                    , String_literal (": ", String (No_padding, End_of_format)) )
                , "%{Location}: %s" )
             : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
             [@merlin.hide])
            loc
            s))
    fmt
;;

let equal_option equal a b =
  match a, b with
  | Some _, None | None, Some _ -> false
  | None, None -> true
  | Some x, Some y -> equal x y
;;

module Sorted_table : sig
  type 'a t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : Location.t -> eq:('a -> 'a -> bool) -> (string * 'a) list -> 'a t
  val expose : 'a t -> (string * 'a) list
  val map : 'a t -> f:('a -> 'b) -> 'b t
end = struct
  type 'a t = { sorted : (string * 'a) list } [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__002_ b__003_ ->
      if Stdlib.( == ) a__002_ b__003_
      then 0
      else
        compare_list
          (fun a__004_ (b__005_ [@merlin.hide]) ->
             ((let t__006_, t__007_ = a__004_ in
               let t__008_, t__009_ = b__005_ in
               match compare_string t__006_ t__008_ with
               | 0 -> _cmp__a t__007_ t__009_
               | n -> n)
             [@merlin.hide]))
          a__002_.sorted
          b__003_.sorted
    ;;

    let _ = compare

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      let error_source__012_ = "bin_shape.ml.before-ppx.Sorted_table.t" in
      fun _of_a__010_ x__018_ ->
        Sexplib0.Sexp_conv_record.record_of_sexp
          ~caller:error_source__012_
          ~fields:
            (Field
               { name = "sorted"
               ; kind = Required
               ; conv =
                   list_of_sexp (function
                     | Sexplib0.Sexp.List [ arg0__013_; arg1__014_ ] ->
                       let res0__015_ = string_of_sexp arg0__013_
                       and res1__016_ = _of_a__010_ arg1__014_ in
                       res0__015_, res1__016_
                     | sexp__017_ ->
                       Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                         error_source__012_
                         2
                         sexp__017_)
               ; rest = Empty
               })
          ~index_of_field:(function
            | "sorted" -> 0
            | _ -> -1)
          ~allow_extra_fields:false
          ~create:(fun (sorted, ()) -> ({ sorted } : _ t))
          x__018_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__019_ { sorted = sorted__021_ } ->
      let bnds__020_ = ([] : _ Stdlib.List.t) in
      let bnds__020_ =
        let arg__022_ =
          sexp_of_list
            (fun (arg0__023_, arg1__024_) ->
               let res0__025_ = sexp_of_string arg0__023_
               and res1__026_ = _of_a__019_ arg1__024_ in
               Sexplib0.Sexp.List [ res0__025_; res1__026_ ])
            sorted__021_
        in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sorted"; arg__022_ ] :: bnds__020_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__020_
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let merge_check_adjacent_dups
    :  eq:('a -> 'a -> bool)
    -> (string * 'a) list
    -> [ `Ok of (string * 'a) list | `Mismatch of string ]
    =
    fun ~eq ->
    let rec loop acc ~last_key ~last_value = function
      | [] -> `Ok (List.rev acc)
      | (key, value) :: xs ->
        if
          let open String in
          last_key = key
        then
          if eq last_value value then loop acc ~last_key ~last_value xs else `Mismatch key
        else loop ((key, value) :: acc) ~last_key:key ~last_value:value xs
    in
    function
    | [] -> `Ok []
    | (key, value) :: xs -> loop [ key, value ] ~last_key:key ~last_value:value xs
  ;;

  let create loc ~eq xs =
    let sorted = List.sort ~compare:(fun (s1, _) (s2, _) -> String.compare s1 s2) xs in
    match merge_check_adjacent_dups ~eq sorted with
    | `Ok sorted -> { sorted }
    | `Mismatch s ->
      eval_fail loc "Different shapes for duplicated polymorphic constructor: `%s" s ()
  ;;

  let expose t = t.sorted
  let map t ~f = { sorted = List.map t.sorted ~f:(fun (k, v) -> k, f v) }
end

module Digest : sig
  type t = Md5_lib.t [@@deriving compare, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val to_md5 : t -> Md5_lib.t
  val of_md5 : Md5_lib.t -> t
  val to_hex : t -> string
  val constructor : string -> t list -> t
  val list : t list -> t
  val pair : t -> t -> t
  val string : string -> t
  val uuid : Uuid.t -> t
  val int : int -> t
  val option : t option -> t
end = struct
  include Md5_lib

  let to_md5 t = t
  let of_md5 t = t
  let sexp_of_t t = t |> to_hex |> sexp_of_string
  let t_of_sexp s = s |> string_of_sexp |> of_hex_exn
  let uuid u = string (Uuid.to_string u)
  let int x = string (Int.to_string x)
  let pair x y = string (to_binary x ^ to_binary y)
  let list l = string (String.concat ~sep:"" (List.map ~f:to_binary l))
  let constructor s l = string (s ^ to_binary (list l))

  let option = function
    | None -> constructor "none" []
    | Some x -> constructor "some" [ x ]
  ;;
end

module Canonical_exp_constructor = struct
  type 'a t =
    | Annotate of Uuid.t * 'a
    | Base of Uuid.t * 'a list
    | Tuple of 'a list
    | Record of (string * 'a) list
    | Variant of (string * 'a list) list
    | Poly_variant of 'a option Sorted_table.t
    | Application of 'a * 'a list
    | Rec_app of int * 'a list
    | Var of int
  [@@deriving sexp, compare]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun (type a__095_) ->
      (let error_source__030_ = "bin_shape.ml.before-ppx.Canonical_exp_constructor.t" in
       fun _of_a__027_ -> function
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("annotate" | "Annotate") as _tag__033_)
             :: sexp_args__034_) as _sexp__032_ ->
           (match sexp_args__034_ with
            | [ arg0__035_; arg1__036_ ] ->
              let res0__037_ = Uuid.t_of_sexp arg0__035_
              and res1__038_ = _of_a__027_ arg1__036_ in
              Annotate (res0__037_, res1__038_)
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__033_
                _sexp__032_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("base" | "Base") as _tag__040_) :: sexp_args__041_) as
           _sexp__039_ ->
           (match sexp_args__041_ with
            | [ arg0__042_; arg1__043_ ] ->
              let res0__044_ = Uuid.t_of_sexp arg0__042_
              and res1__045_ = list_of_sexp _of_a__027_ arg1__043_ in
              Base (res0__044_, res1__045_)
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__040_
                _sexp__039_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("tuple" | "Tuple") as _tag__047_) :: sexp_args__048_)
           as _sexp__046_ ->
           (match sexp_args__048_ with
            | arg0__049_ :: [] ->
              let res0__050_ = list_of_sexp _of_a__027_ arg0__049_ in
              Tuple res0__050_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__047_
                _sexp__046_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("record" | "Record") as _tag__052_) :: sexp_args__053_)
           as _sexp__051_ ->
           (match sexp_args__053_ with
            | arg0__059_ :: [] ->
              let res0__060_ =
                list_of_sexp
                  (function
                    | Sexplib0.Sexp.List [ arg0__054_; arg1__055_ ] ->
                      let res0__056_ = string_of_sexp arg0__054_
                      and res1__057_ = _of_a__027_ arg1__055_ in
                      res0__056_, res1__057_
                    | sexp__058_ ->
                      Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                        error_source__030_
                        2
                        sexp__058_)
                  arg0__059_
              in
              Record res0__060_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__052_
                _sexp__051_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("variant" | "Variant") as _tag__062_)
             :: sexp_args__063_) as _sexp__061_ ->
           (match sexp_args__063_ with
            | arg0__069_ :: [] ->
              let res0__070_ =
                list_of_sexp
                  (function
                    | Sexplib0.Sexp.List [ arg0__064_; arg1__065_ ] ->
                      let res0__066_ = string_of_sexp arg0__064_
                      and res1__067_ = list_of_sexp _of_a__027_ arg1__065_ in
                      res0__066_, res1__067_
                    | sexp__068_ ->
                      Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                        error_source__030_
                        2
                        sexp__068_)
                  arg0__069_
              in
              Variant res0__070_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__062_
                _sexp__061_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("poly_variant" | "Poly_variant") as _tag__072_)
             :: sexp_args__073_) as _sexp__071_ ->
           (match sexp_args__073_ with
            | arg0__074_ :: [] ->
              let res0__075_ =
                Sorted_table.t_of_sexp (option_of_sexp _of_a__027_) arg0__074_
              in
              Poly_variant res0__075_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__072_
                _sexp__071_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("application" | "Application") as _tag__077_)
             :: sexp_args__078_) as _sexp__076_ ->
           (match sexp_args__078_ with
            | [ arg0__079_; arg1__080_ ] ->
              let res0__081_ = _of_a__027_ arg0__079_
              and res1__082_ = list_of_sexp _of_a__027_ arg1__080_ in
              Application (res0__081_, res1__082_)
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__077_
                _sexp__076_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("rec_app" | "Rec_app") as _tag__084_)
             :: sexp_args__085_) as _sexp__083_ ->
           (match sexp_args__085_ with
            | [ arg0__086_; arg1__087_ ] ->
              let res0__088_ = int_of_sexp arg0__086_
              and res1__089_ = list_of_sexp _of_a__027_ arg1__087_ in
              Rec_app (res0__088_, res1__089_)
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__084_
                _sexp__083_)
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("var" | "Var") as _tag__091_) :: sexp_args__092_) as
           _sexp__090_ ->
           (match sexp_args__092_ with
            | arg0__093_ :: [] ->
              let res0__094_ = int_of_sexp arg0__093_ in
              Var res0__094_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__030_
                _tag__091_
                _sexp__090_)
         | Sexplib0.Sexp.Atom ("annotate" | "Annotate") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("base" | "Base") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("tuple" | "Tuple") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("record" | "Record") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("variant" | "Variant") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("poly_variant" | "Poly_variant") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("application" | "Application") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("rec_app" | "Rec_app") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.Atom ("var" | "Var") as sexp__031_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__030_ sexp__031_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__029_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__030_ sexp__029_
         | Sexplib0.Sexp.List [] as sexp__029_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__030_ sexp__029_
         | sexp__029_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__030_ sexp__029_
       : (Sexplib0.Sexp.t -> a__095_) -> Sexplib0.Sexp.t -> a__095_ t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun (type a__131_) ->
      (fun _of_a__096_ -> function
         | Annotate (arg0__097_, arg1__098_) ->
           let res0__099_ = Uuid.sexp_of_t arg0__097_
           and res1__100_ = _of_a__096_ arg1__098_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Annotate"; res0__099_; res1__100_ ]
         | Base (arg0__101_, arg1__102_) ->
           let res0__103_ = Uuid.sexp_of_t arg0__101_
           and res1__104_ = sexp_of_list _of_a__096_ arg1__102_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__103_; res1__104_ ]
         | Tuple arg0__105_ ->
           let res0__106_ = sexp_of_list _of_a__096_ arg0__105_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Tuple"; res0__106_ ]
         | Record arg0__111_ ->
           let res0__112_ =
             sexp_of_list
               (fun (arg0__107_, arg1__108_) ->
                  let res0__109_ = sexp_of_string arg0__107_
                  and res1__110_ = _of_a__096_ arg1__108_ in
                  Sexplib0.Sexp.List [ res0__109_; res1__110_ ])
               arg0__111_
           in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Record"; res0__112_ ]
         | Variant arg0__117_ ->
           let res0__118_ =
             sexp_of_list
               (fun (arg0__113_, arg1__114_) ->
                  let res0__115_ = sexp_of_string arg0__113_
                  and res1__116_ = sexp_of_list _of_a__096_ arg1__114_ in
                  Sexplib0.Sexp.List [ res0__115_; res1__116_ ])
               arg0__117_
           in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Variant"; res0__118_ ]
         | Poly_variant arg0__119_ ->
           let res0__120_ =
             Sorted_table.sexp_of_t (sexp_of_option _of_a__096_) arg0__119_
           in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Poly_variant"; res0__120_ ]
         | Application (arg0__121_, arg1__122_) ->
           let res0__123_ = _of_a__096_ arg0__121_
           and res1__124_ = sexp_of_list _of_a__096_ arg1__122_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Application"; res0__123_; res1__124_ ]
         | Rec_app (arg0__125_, arg1__126_) ->
           let res0__127_ = sexp_of_int arg0__125_
           and res1__128_ = sexp_of_list _of_a__096_ arg1__126_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Rec_app"; res0__127_; res1__128_ ]
         | Var arg0__129_ ->
           let res0__130_ = sexp_of_int arg0__129_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Var"; res0__130_ ]
       : (a__131_ -> Sexplib0.Sexp.t) -> a__131_ t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__132_ b__133_ ->
      if Stdlib.( == ) a__132_ b__133_
      then 0
      else (
        match a__132_, b__133_ with
        | Annotate (_a__134_, _a__136_), Annotate (_b__135_, _b__137_) ->
          (match Uuid.compare _a__134_ _b__135_ with
           | 0 -> _cmp__a _a__136_ _b__137_
           | n -> n)
        | Annotate _, _ -> -1
        | _, Annotate _ -> 1
        | Base (_a__138_, _a__140_), Base (_b__139_, _b__141_) ->
          (match Uuid.compare _a__138_ _b__139_ with
           | 0 ->
             compare_list
               (fun a__142_ (b__143_ [@merlin.hide]) ->
                  (_cmp__a a__142_ b__143_ [@merlin.hide]))
               _a__140_
               _b__141_
           | n -> n)
        | Base _, _ -> -1
        | _, Base _ -> 1
        | Tuple _a__144_, Tuple _b__145_ ->
          compare_list
            (fun a__146_ (b__147_ [@merlin.hide]) ->
               (_cmp__a a__146_ b__147_ [@merlin.hide]))
            _a__144_
            _b__145_
        | Tuple _, _ -> -1
        | _, Tuple _ -> 1
        | Record _a__148_, Record _b__149_ ->
          compare_list
            (fun a__150_ (b__151_ [@merlin.hide]) ->
               ((let t__152_, t__153_ = a__150_ in
                 let t__154_, t__155_ = b__151_ in
                 match compare_string t__152_ t__154_ with
                 | 0 -> _cmp__a t__153_ t__155_
                 | n -> n)
               [@merlin.hide]))
            _a__148_
            _b__149_
        | Record _, _ -> -1
        | _, Record _ -> 1
        | Variant _a__156_, Variant _b__157_ ->
          compare_list
            (fun a__158_ (b__159_ [@merlin.hide]) ->
               ((let t__160_, t__161_ = a__158_ in
                 let t__162_, t__163_ = b__159_ in
                 match compare_string t__160_ t__162_ with
                 | 0 ->
                   compare_list
                     (fun a__164_ (b__165_ [@merlin.hide]) ->
                        (_cmp__a a__164_ b__165_ [@merlin.hide]))
                     t__161_
                     t__163_
                 | n -> n)
               [@merlin.hide]))
            _a__156_
            _b__157_
        | Variant _, _ -> -1
        | _, Variant _ -> 1
        | Poly_variant _a__166_, Poly_variant _b__167_ ->
          Sorted_table.compare
            (fun a__168_ (b__169_ [@merlin.hide]) ->
               (compare_option
                  (fun a__170_ (b__171_ [@merlin.hide]) ->
                     (_cmp__a a__170_ b__171_ [@merlin.hide]))
                  a__168_
                  b__169_ [@merlin.hide]))
            _a__166_
            _b__167_
        | Poly_variant _, _ -> -1
        | _, Poly_variant _ -> 1
        | Application (_a__172_, _a__174_), Application (_b__173_, _b__175_) ->
          (match _cmp__a _a__172_ _b__173_ with
           | 0 ->
             compare_list
               (fun a__176_ (b__177_ [@merlin.hide]) ->
                  (_cmp__a a__176_ b__177_ [@merlin.hide]))
               _a__174_
               _b__175_
           | n -> n)
        | Application _, _ -> -1
        | _, Application _ -> 1
        | Rec_app (_a__178_, _a__180_), Rec_app (_b__179_, _b__181_) ->
          (match compare_int _a__178_ _b__179_ with
           | 0 ->
             compare_list
               (fun a__182_ (b__183_ [@merlin.hide]) ->
                  (_cmp__a a__182_ b__183_ [@merlin.hide]))
               _a__180_
               _b__181_
           | n -> n)
        | Rec_app _, _ -> -1
        | _, Rec_app _ -> 1
        | Var _a__184_, Var _b__185_ -> compare_int _a__184_ _b__185_)
    ;;

    let _ = compare
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let map x ~f =
    match x with
    | Annotate (u, x) -> Annotate (u, f x)
    | Base (s, xs) -> Base (s, List.map ~f xs)
    | Tuple xs -> Tuple (List.map ~f xs)
    | Record l -> Record (List.map l ~f:(fun (s, x) -> s, f x))
    | Variant l -> Variant (List.map l ~f:(fun (s, xs) -> s, List.map ~f xs))
    | Poly_variant t -> Poly_variant (Sorted_table.map t ~f:(Option.map ~f))
    | Application (x, l) -> Application (f x, List.map ~f l)
    | Rec_app (t, l) -> Rec_app (t, List.map ~f l)
    | Var v -> Var v
  ;;

  let to_string t = Sexp.to_string (sexp_of_t (fun _ -> Atom "...") t)
end

module Create_digest : sig
  val digest_layer : Digest.t Canonical_exp_constructor.t -> Digest.t
end = struct
  let digest_layer = function
    | Canonical_exp_constructor.Annotate (u, x) ->
      Digest.constructor "annotate" [ Digest.uuid u; x ]
    | Base (u, l) -> Digest.constructor "base" [ Digest.uuid u; Digest.list l ]
    | Tuple l -> Digest.constructor "tuple" [ Digest.list l ]
    | Record l ->
      Digest.constructor
        "record"
        [ Digest.list (List.map l ~f:(fun (s, t) -> Digest.pair (Digest.string s) t)) ]
    | Variant l ->
      Digest.constructor
        "variant"
        [ Digest.list
            (List.map l ~f:(fun (s, l) -> Digest.pair (Digest.string s) (Digest.list l)))
        ]
    | Poly_variant table ->
      Digest.constructor
        "poly_variant"
        [ Digest.list
            (List.map (Sorted_table.expose table) ~f:(fun (x, y) ->
               Digest.pair (Digest.string x) (Digest.option y)))
        ]
    | Application (x, l) -> Digest.constructor "application" [ x; Digest.list l ]
    | Rec_app (n, l) -> Digest.constructor "rec_app" [ Digest.int n; Digest.list l ]
    | Var n -> Digest.constructor "var" [ Digest.int n ]
  ;;
end

module Visibility = struct
  type visible = Visible
  type opaque = Opaque

  let _ = Visible
  let _ = Opaque
end

module type Canonical = sig
  type t

  val to_digest : t -> Digest.t

  module Exp1 : sig
    type _ t

    val var : int -> _ t
    val recurse : int -> _ t list -> _ t
    val apply : 'a t -> 'a t list -> _ t
    val opaque : _ t -> Visibility.opaque t

    val get_poly_variant
      :  Visibility.visible t
      -> (Visibility.opaque t option Sorted_table.t, string) Result.t
  end

  module Def : sig
    type t = Visibility.visible Exp1.t
  end

  module Create : sig
    val annotate : Uuid.t -> _ Exp1.t -> _ Exp1.t
    val basetype : Uuid.t -> _ Exp1.t list -> _ Exp1.t
    val tuple : _ Exp1.t list -> _ Exp1.t
    val poly_variant : Location.t -> (string * _ Exp1.t option) list -> _ Exp1.t
    val define : Visibility.visible Exp1.t -> Def.t
    val record : (string * _ Exp1.t) list -> _ Exp1.t
    val variant : (string * _ Exp1.t list) list -> _ Exp1.t
    val create : _ Exp1.t -> t
  end
end

module Canonical_digest : Canonical = struct
  type t = Canonical of Digest.t

  let to_digest (Canonical x) = x

  module CD = Create_digest

  module Exp1 = struct
    type opaque = Digest.t

    type 'a t =
      | Poly_variant of opaque option Sorted_table.t
      | Non_poly_variant of (string * opaque)
      | Opaque : opaque -> Visibility.opaque t

    let to_digest (type a) (x : a t) =
      match x with
      | Opaque x -> x
      | Non_poly_variant (_, x) -> x
      | Poly_variant x -> CD.digest_layer (Poly_variant x)
    ;;

    let equal (type a) (x : a t) (y : a t) =
      Digest.compare (to_digest x) (to_digest y) = 0
    ;;

    let opaque x = Opaque (to_digest x)

    let create x =
      let x = Canonical_exp_constructor.map ~f:to_digest x in
      let desc = Canonical_exp_constructor.to_string x in
      match x with
      | Canonical_exp_constructor.Poly_variant l -> Poly_variant l
      | Base _ -> Non_poly_variant (desc, CD.digest_layer x)
      | Annotate _ -> Non_poly_variant (desc, CD.digest_layer x)
      | Application _ -> Non_poly_variant (desc, CD.digest_layer x)
      | Rec_app _ -> Non_poly_variant (desc, CD.digest_layer x)
      | Var _ | Tuple _ | Record _ | Variant _ ->
        Non_poly_variant (desc, CD.digest_layer x)
    ;;

    let var x = create (Var x)
    let apply def l = create (Application (def, l))
    let recurse tid l = create (Rec_app (tid, l))

    let get_poly_variant (x : Visibility.visible t) =
      match x with
      | Non_poly_variant (desc, _) -> Error desc
      | Poly_variant l -> Ok (Sorted_table.map ~f:(Option.map ~f:(fun x -> Opaque x)) l)
    ;;
  end

  module Def = struct
    type t = Visibility.visible Exp1.t
  end

  module Create = struct
    let annotate u x = Exp1.create (Annotate (u, x))
    let basetype u l = Exp1.create (Base (u, l))
    let tuple l = Exp1.create (Tuple l)

    let poly_variant loc l =
      Exp1.create (Poly_variant (Sorted_table.create loc ~eq:(equal_option Exp1.equal) l))
    ;;

    let define x = x
    let record l = Exp1.create (Record l)
    let variant l = Exp1.create (Variant l)
    let create e = Canonical (Exp1.to_digest e)
  end
end

module Canonical_full = struct
  module CD = Create_digest

  module Exp1 = struct
    type t0 = Exp of t0 Canonical_exp_constructor.t [@@deriving compare, sexp]

    include struct
      let _ = fun (_ : t0) -> ()

      let rec compare_t0 =
        (fun a__186_ b__187_ ->
           if Stdlib.( == ) a__186_ b__187_
           then 0
           else (
             match a__186_, b__187_ with
             | Exp _a__188_, Exp _b__189_ ->
               Canonical_exp_constructor.compare
                 (fun a__190_ (b__191_ [@merlin.hide]) ->
                    (compare_t0 a__190_ b__191_ [@merlin.hide]))
                 _a__188_
                 _b__189_)
         : t0 -> (t0[@merlin.hide]) -> int)
      ;;

      let _ = compare_t0

      let rec t0_of_sexp =
        (let error_source__194_ = "bin_shape.ml.before-ppx.Canonical_full.Exp1.t0" in
         function
         | Sexplib0.Sexp.List
             (Sexplib0.Sexp.Atom (("exp" | "Exp") as _tag__197_) :: sexp_args__198_) as
           _sexp__196_ ->
           (match sexp_args__198_ with
            | arg0__199_ :: [] ->
              let res0__200_ =
                Canonical_exp_constructor.t_of_sexp t0_of_sexp arg0__199_
              in
              Exp res0__200_
            | _ ->
              Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                error_source__194_
                _tag__197_
                _sexp__196_)
         | Sexplib0.Sexp.Atom ("exp" | "Exp") as sexp__195_ ->
           Sexplib0.Sexp_conv_error.stag_takes_args error_source__194_ sexp__195_
         | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__193_ ->
           Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__194_ sexp__193_
         | Sexplib0.Sexp.List [] as sexp__193_ ->
           Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__194_ sexp__193_
         | sexp__193_ ->
           Sexplib0.Sexp_conv_error.unexpected_stag error_source__194_ sexp__193_
         : Sexplib0.Sexp.t -> t0)
      ;;

      let _ = t0_of_sexp

      let rec sexp_of_t0 =
        (fun (Exp arg0__201_) ->
           let res0__202_ = Canonical_exp_constructor.sexp_of_t sexp_of_t0 arg0__201_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exp"; res0__202_ ]
         : t0 -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t0
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let equal_t0 x y = compare_t0 x y = 0

    type 'a t = t0 [@@deriving compare, sexp]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__203_ b__204_ -> compare_t0 a__203_ b__204_
      ;;

      let _ = compare

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        fun _of_a__205_ -> t0_of_sexp
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__207_ -> sexp_of_t0
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let var x = Exp (Canonical_exp_constructor.Var x)
    let apply d xs = Exp (Canonical_exp_constructor.Application (d, xs))
    let recurse r xs = Exp (Canonical_exp_constructor.Rec_app (r, xs))

    let poly_variant loc xs =
      Exp
        (Canonical_exp_constructor.Poly_variant
           (Sorted_table.create loc ~eq:(equal_option equal_t0) xs))
    ;;

    let get_poly_variant = function
      | Exp (Poly_variant tab) -> Ok tab
      | Exp cc -> Error (Canonical_exp_constructor.to_string cc)
    ;;

    let opaque t = t

    let rec to_digest = function
      | Exp e -> CD.digest_layer (Canonical_exp_constructor.map ~f:to_digest e)
    ;;
  end

  module Def = struct
    type t = Exp1.t0 [@@deriving compare, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let compare =
        (fun a__208_ b__209_ -> Exp1.compare_t0 a__208_ b__209_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare
      let t_of_sexp = (Exp1.t0_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (Exp1.sexp_of_t0 : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  type t = Exp1.t0 [@@deriving compare, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__211_ b__212_ -> Exp1.compare_t0 a__211_ b__212_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare
    let t_of_sexp = (Exp1.t0_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (Exp1.sexp_of_t0 : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let to_digest e = Exp1.to_digest e

  module Create = struct
    let annotate u x = Exp1.Exp (Annotate (u, x))
    let basetype u xs = Exp1.Exp (Base (u, xs))
    let tuple xs = Exp1.Exp (Tuple xs)
    let poly_variant loc xs = Exp1.poly_variant loc xs
    let var n = Exp1.Exp (Var n)
    let recurse r xs = Exp1.recurse r xs
    let apply d xs = Exp1.apply d xs
    let define x = x
    let record xs = Exp1.Exp (Record xs)
    let variant xs = Exp1.Exp (Variant xs)
    let create exp = exp
  end

  let to_string_hum t = Sexp.to_string_hum (sexp_of_t t)
end

module Tid : sig
  include Identifiable.S
end = struct
  include String
end

module Vid : sig
  include Identifiable.S
end = struct
  include String
end

module Gid : sig
  type t [@@deriving compare, equal, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_compare_lib.Equal.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create : unit -> t
end = struct
  type t = int [@@deriving compare, equal, sexp]

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__214_ b__215_ -> compare_int a__214_ b__215_ : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__216_ b__217_ -> equal_int a__216_ b__217_ : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let t_of_sexp = (int_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (sexp_of_int : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let r = ref 0

  let create () =
    let u = !r in
    r := 1 + u;
    u
  ;;
end

module Expression = struct
  type 't poly_constr =
    [ `Constr of string * 't option
    | `Inherit of Location.t * 't
    ]
  [@@deriving compare, equal, sexp]

  include struct
    let _ = fun (_ : 't poly_constr) -> ()

    let compare_poly_constr
      :  't.
         ('t -> ('t[@merlin.hide]) -> int)
      -> 't poly_constr
      -> ('t poly_constr[@merlin.hide])
      -> int
      =
      fun _cmp__t a__219_ b__220_ ->
      if Stdlib.( == ) a__219_ b__220_
      then 0
      else (
        match a__219_, b__220_ with
        | `Constr _left__221_, `Constr _right__222_ ->
          let t__223_, t__224_ = _left__221_ in
          let t__225_, t__226_ = _right__222_ in
          (match compare_string t__223_ t__225_ with
           | 0 ->
             compare_option
               (fun a__227_ (b__228_ [@merlin.hide]) ->
                  (_cmp__t a__227_ b__228_ [@merlin.hide]))
               t__224_
               t__226_
           | n -> n)
        | `Inherit _left__229_, `Inherit _right__230_ ->
          let t__231_, t__232_ = _left__229_ in
          let t__233_, t__234_ = _right__230_ in
          (match Location.compare t__231_ t__233_ with
           | 0 -> _cmp__t t__232_ t__234_
           | n -> n)
        | x, y -> Stdlib.compare x y)
    ;;

    let _ = compare_poly_constr

    let equal_poly_constr
      :  't.
         ('t -> ('t[@merlin.hide]) -> bool)
      -> 't poly_constr
      -> ('t poly_constr[@merlin.hide])
      -> bool
      =
      fun _cmp__t a__235_ b__236_ ->
      if Stdlib.( == ) a__235_ b__236_
      then true
      else (
        match a__235_, b__236_ with
        | `Constr _left__237_, `Constr _right__238_ ->
          let t__239_, t__240_ = _left__237_ in
          let t__241_, t__242_ = _right__238_ in
          Stdlib.( && )
            (equal_string t__239_ t__241_)
            (equal_option
               (fun a__243_ (b__244_ [@merlin.hide]) ->
                  (_cmp__t a__243_ b__244_ [@merlin.hide]))
               t__240_
               t__242_)
        | `Inherit _left__245_, `Inherit _right__246_ ->
          let t__247_, t__248_ = _left__245_ in
          let t__249_, t__250_ = _right__246_ in
          Stdlib.( && ) (Location.equal t__247_ t__249_) (_cmp__t t__248_ t__250_)
        | x, y -> Stdlib.( = ) x y)
    ;;

    let _ = equal_poly_constr

    let __poly_constr_of_sexp__
      : 't. (Sexplib0.Sexp.t -> 't) -> Sexplib0.Sexp.t -> 't poly_constr
      =
      let error_source__263_ = "bin_shape.ml.before-ppx.Expression.poly_constr" in
      fun _of_t__251_ -> function
        | Sexplib0.Sexp.Atom atom__253_ as _sexp__255_ ->
          (match atom__253_ with
           | "Constr" ->
             Sexplib0.Sexp_conv_error.ptag_takes_args error_source__263_ _sexp__255_
           | "Inherit" ->
             Sexplib0.Sexp_conv_error.ptag_takes_args error_source__263_ _sexp__255_
           | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
        | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__253_ :: sexp_args__256_) as
          _sexp__255_ ->
          (match atom__253_ with
           | "Constr" as _tag__266_ ->
             (match sexp_args__256_ with
              | arg0__272_ :: [] ->
                let res0__273_ =
                  match arg0__272_ with
                  | Sexplib0.Sexp.List [ arg0__267_; arg1__268_ ] ->
                    let res0__269_ = string_of_sexp arg0__267_
                    and res1__270_ = option_of_sexp _of_t__251_ arg1__268_ in
                    res0__269_, res1__270_
                  | sexp__271_ ->
                    Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                      error_source__263_
                      2
                      sexp__271_
                in
                `Constr res0__273_
              | _ ->
                Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                  error_source__263_
                  _tag__266_
                  _sexp__255_)
           | "Inherit" as _tag__257_ ->
             (match sexp_args__256_ with
              | arg0__264_ :: [] ->
                let res0__265_ =
                  match arg0__264_ with
                  | Sexplib0.Sexp.List [ arg0__258_; arg1__259_ ] ->
                    let res0__260_ = Location.t_of_sexp arg0__258_
                    and res1__261_ = _of_t__251_ arg1__259_ in
                    res0__260_, res1__261_
                  | sexp__262_ ->
                    Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                      error_source__263_
                      2
                      sexp__262_
                in
                `Inherit res0__265_
              | _ ->
                Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                  error_source__263_
                  _tag__257_
                  _sexp__255_)
           | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
        | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__254_ ->
          Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
            error_source__263_
            sexp__254_
        | Sexplib0.Sexp.List [] as sexp__254_ ->
          Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
            error_source__263_
            sexp__254_
    ;;

    let _ = __poly_constr_of_sexp__

    let poly_constr_of_sexp
      : 't. (Sexplib0.Sexp.t -> 't) -> Sexplib0.Sexp.t -> 't poly_constr
      =
      let error_source__275_ = "bin_shape.ml.before-ppx.Expression.poly_constr" in
      fun _of_t__251_ sexp__274_ ->
        try __poly_constr_of_sexp__ _of_t__251_ sexp__274_ with
        | Sexplib0.Sexp_conv_error.No_variant_match ->
          Sexplib0.Sexp_conv_error.no_matching_variant_found error_source__275_ sexp__274_
    ;;

    let _ = poly_constr_of_sexp

    let sexp_of_poly_constr
      : 't. ('t -> Sexplib0.Sexp.t) -> 't poly_constr -> Sexplib0.Sexp.t
      =
      fun _of_t__276_ -> function
      | `Constr v__277_ ->
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "Constr"
          ; (let arg0__278_, arg1__279_ = v__277_ in
             let res0__280_ = sexp_of_string arg0__278_
             and res1__281_ = sexp_of_option _of_t__276_ arg1__279_ in
             Sexplib0.Sexp.List [ res0__280_; res1__281_ ])
          ]
      | `Inherit v__282_ ->
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "Inherit"
          ; (let arg0__283_, arg1__284_ = v__282_ in
             let res0__285_ = Location.sexp_of_t arg0__283_
             and res1__286_ = _of_t__276_ arg1__284_ in
             Sexplib0.Sexp.List [ res0__285_; res1__286_ ])
          ]
    ;;

    let _ = sexp_of_poly_constr
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Group : sig
    type 'a t [@@deriving compare, equal, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create : Location.t -> (Tid.t * Vid.t list * 'a) list -> 'a t
    val id : 'a t -> Gid.t
    val lookup : 'a t -> Tid.t -> Vid.t list * 'a
  end = struct
    type 'a t =
      { gid : Gid.t
      ; loc : Location.t
      ; members : (Tid.t * (Vid.t list * 'a)) list
      }
    [@@deriving compare, equal, sexp]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__287_ b__288_ ->
        if Stdlib.( == ) a__287_ b__288_
        then 0
        else (
          match Gid.compare a__287_.gid b__288_.gid with
          | 0 ->
            (match Location.compare a__287_.loc b__288_.loc with
             | 0 ->
               compare_list
                 (fun a__289_ (b__290_ [@merlin.hide]) ->
                    ((let t__291_, t__292_ = a__289_ in
                      let t__293_, t__294_ = b__290_ in
                      match Tid.compare t__291_ t__293_ with
                      | 0 ->
                        let t__295_, t__296_ = t__292_ in
                        let t__297_, t__298_ = t__294_ in
                        (match
                           compare_list
                             (fun a__299_ (b__300_ [@merlin.hide]) ->
                                (Vid.compare a__299_ b__300_ [@merlin.hide]))
                             t__295_
                             t__297_
                         with
                         | 0 -> _cmp__a t__296_ t__298_
                         | n -> n)
                      | n -> n)
                    [@merlin.hide]))
                 a__287_.members
                 b__288_.members
             | n -> n)
          | n -> n)
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__301_ b__302_ ->
        if Stdlib.( == ) a__301_ b__302_
        then true
        else
          Stdlib.( && )
            (Gid.equal a__301_.gid b__302_.gid)
            (Stdlib.( && )
               (Location.equal a__301_.loc b__302_.loc)
               (equal_list
                  (fun a__303_ (b__304_ [@merlin.hide]) ->
                     ((let t__305_, t__306_ = a__303_ in
                       let t__307_, t__308_ = b__304_ in
                       Stdlib.( && )
                         (Tid.equal t__305_ t__307_)
                         (let t__309_, t__310_ = t__306_ in
                          let t__311_, t__312_ = t__308_ in
                          Stdlib.( && )
                            (equal_list
                               (fun a__313_ (b__314_ [@merlin.hide]) ->
                                  (Vid.equal a__313_ b__314_ [@merlin.hide]))
                               t__309_
                               t__311_)
                            (_cmp__a t__310_ t__312_)))
                     [@merlin.hide]))
                  a__301_.members
                  b__302_.members))
      ;;

      let _ = equal

      let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
        let error_source__317_ = "bin_shape.ml.before-ppx.Expression.Group.t" in
        fun _of_a__315_ x__328_ ->
          Sexplib0.Sexp_conv_record.record_of_sexp
            ~caller:error_source__317_
            ~fields:
              (Field
                 { name = "gid"
                 ; kind = Required
                 ; conv = Gid.t_of_sexp
                 ; rest =
                     Field
                       { name = "loc"
                       ; kind = Required
                       ; conv = Location.t_of_sexp
                       ; rest =
                           Field
                             { name = "members"
                             ; kind = Required
                             ; conv =
                                 list_of_sexp (function
                                   | Sexplib0.Sexp.List [ arg0__323_; arg1__324_ ] ->
                                     let res0__325_ = Tid.t_of_sexp arg0__323_
                                     and res1__326_ =
                                       match arg1__324_ with
                                       | Sexplib0.Sexp.List [ arg0__318_; arg1__319_ ] ->
                                         let res0__320_ =
                                           list_of_sexp Vid.t_of_sexp arg0__318_
                                         and res1__321_ = _of_a__315_ arg1__319_ in
                                         res0__320_, res1__321_
                                       | sexp__322_ ->
                                         Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                                           error_source__317_
                                           2
                                           sexp__322_
                                     in
                                     res0__325_, res1__326_
                                   | sexp__327_ ->
                                     Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                                       error_source__317_
                                       2
                                       sexp__327_)
                             ; rest = Empty
                             }
                       }
                 })
            ~index_of_field:(function
              | "gid" -> 0
              | "loc" -> 1
              | "members" -> 2
              | _ -> -1)
            ~allow_extra_fields:false
            ~create:(fun (gid, (loc, (members, ()))) -> ({ gid; loc; members } : _ t))
            x__328_
      ;;

      let _ = t_of_sexp

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__329_ { gid = gid__331_; loc = loc__333_; members = members__335_ } ->
        let bnds__330_ = ([] : _ Stdlib.List.t) in
        let bnds__330_ =
          let arg__336_ =
            sexp_of_list
              (fun (arg0__341_, arg1__342_) ->
                 let res0__343_ = Tid.sexp_of_t arg0__341_
                 and res1__344_ =
                   let arg0__337_, arg1__338_ = arg1__342_ in
                   let res0__339_ = sexp_of_list Vid.sexp_of_t arg0__337_
                   and res1__340_ = _of_a__329_ arg1__338_ in
                   Sexplib0.Sexp.List [ res0__339_; res1__340_ ]
                 in
                 Sexplib0.Sexp.List [ res0__343_; res1__344_ ])
              members__335_
          in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "members"; arg__336_ ] :: bnds__330_
           : _ Stdlib.List.t)
        in
        let bnds__330_ =
          let arg__334_ = Location.sexp_of_t loc__333_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "loc"; arg__334_ ] :: bnds__330_
           : _ Stdlib.List.t)
        in
        let bnds__330_ =
          let arg__332_ = Gid.sexp_of_t gid__331_ in
          (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "gid"; arg__332_ ] :: bnds__330_
           : _ Stdlib.List.t)
        in
        Sexplib0.Sexp.List bnds__330_
      ;;

      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let create loc trips =
      let gid = Gid.create () in
      let members = List.map trips ~f:(fun (x, vs, t) -> x, (vs, t)) in
      { gid; loc; members }
    ;;

    let id g = g.gid

    let lookup g tid =
      match List.Assoc.find g.members ~equal:Tid.( = ) tid with
      | Some scheme -> scheme
      | None ->
        eval_fail
          g.loc
          ((Format
              ( String_literal
                  ( "impossible: lookup_group, unbound type-identifier: "
                  , Custom
                      ( Custom_succ Custom_zero
                      , (fun () _custom_printf__345_ ->
                          Tid.to_string _custom_printf__345_)
                      , End_of_format ) )
              , "impossible: lookup_group, unbound type-identifier: %{Tid}" )
           : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
           [@merlin.hide])
          tid
          ()
    ;;
  end

  module Stable = struct
    module V1 = struct
      type t =
        | Annotate of Uuid.t * t
        | Base of Uuid.t * t list
        | Record of (string * t) list
        | Variant of (string * t list) list
        | Tuple of t list
        | Poly_variant of (Location.t * t poly_constr list)
        | Var of (Location.t * Vid.t)
        | Rec_app of Tid.t * t list
        | Top_app of t Group.t * Tid.t * t list
      [@@deriving equal, sexp, variants]

      include struct
        [@@@ocaml.warning "-60"]

        let _ = fun (_ : t) -> ()

        let rec equal =
          (fun a__346_ b__347_ ->
             if Stdlib.( == ) a__346_ b__347_
             then true
             else (
               match a__346_, b__347_ with
               | Annotate (_a__348_, _a__350_), Annotate (_b__349_, _b__351_) ->
                 Stdlib.( && ) (Uuid.equal _a__348_ _b__349_) (equal _a__350_ _b__351_)
               | Annotate _, _ -> false
               | _, Annotate _ -> false
               | Base (_a__352_, _a__354_), Base (_b__353_, _b__355_) ->
                 Stdlib.( && )
                   (Uuid.equal _a__352_ _b__353_)
                   (equal_list
                      (fun a__356_ (b__357_ [@merlin.hide]) ->
                         (equal a__356_ b__357_ [@merlin.hide]))
                      _a__354_
                      _b__355_)
               | Base _, _ -> false
               | _, Base _ -> false
               | Record _a__358_, Record _b__359_ ->
                 equal_list
                   (fun a__360_ (b__361_ [@merlin.hide]) ->
                      ((let t__362_, t__363_ = a__360_ in
                        let t__364_, t__365_ = b__361_ in
                        Stdlib.( && )
                          (equal_string t__362_ t__364_)
                          (equal t__363_ t__365_))
                      [@merlin.hide]))
                   _a__358_
                   _b__359_
               | Record _, _ -> false
               | _, Record _ -> false
               | Variant _a__366_, Variant _b__367_ ->
                 equal_list
                   (fun a__368_ (b__369_ [@merlin.hide]) ->
                      ((let t__370_, t__371_ = a__368_ in
                        let t__372_, t__373_ = b__369_ in
                        Stdlib.( && )
                          (equal_string t__370_ t__372_)
                          (equal_list
                             (fun a__374_ (b__375_ [@merlin.hide]) ->
                                (equal a__374_ b__375_ [@merlin.hide]))
                             t__371_
                             t__373_))
                      [@merlin.hide]))
                   _a__366_
                   _b__367_
               | Variant _, _ -> false
               | _, Variant _ -> false
               | Tuple _a__376_, Tuple _b__377_ ->
                 equal_list
                   (fun a__378_ (b__379_ [@merlin.hide]) ->
                      (equal a__378_ b__379_ [@merlin.hide]))
                   _a__376_
                   _b__377_
               | Tuple _, _ -> false
               | _, Tuple _ -> false
               | Poly_variant _a__380_, Poly_variant _b__381_ ->
                 let t__382_, t__383_ = _a__380_ in
                 let t__384_, t__385_ = _b__381_ in
                 Stdlib.( && )
                   (Location.equal t__382_ t__384_)
                   (equal_list
                      (fun a__386_ (b__387_ [@merlin.hide]) ->
                         (equal_poly_constr
                            (fun a__388_ (b__389_ [@merlin.hide]) ->
                               (equal a__388_ b__389_ [@merlin.hide]))
                            a__386_
                            b__387_ [@merlin.hide]))
                      t__383_
                      t__385_)
               | Poly_variant _, _ -> false
               | _, Poly_variant _ -> false
               | Var _a__390_, Var _b__391_ ->
                 let t__392_, t__393_ = _a__390_ in
                 let t__394_, t__395_ = _b__391_ in
                 Stdlib.( && )
                   (Location.equal t__392_ t__394_)
                   (Vid.equal t__393_ t__395_)
               | Var _, _ -> false
               | _, Var _ -> false
               | Rec_app (_a__396_, _a__398_), Rec_app (_b__397_, _b__399_) ->
                 Stdlib.( && )
                   (Tid.equal _a__396_ _b__397_)
                   (equal_list
                      (fun a__400_ (b__401_ [@merlin.hide]) ->
                         (equal a__400_ b__401_ [@merlin.hide]))
                      _a__398_
                      _b__399_)
               | Rec_app _, _ -> false
               | _, Rec_app _ -> false
               | ( Top_app (_a__402_, _a__404_, _a__406_)
                 , Top_app (_b__403_, _b__405_, _b__407_) ) ->
                 Stdlib.( && )
                   (Group.equal
                      (fun a__408_ (b__409_ [@merlin.hide]) ->
                         (equal a__408_ b__409_ [@merlin.hide]))
                      _a__402_
                      _b__403_)
                   (Stdlib.( && )
                      (Tid.equal _a__404_ _b__405_)
                      (equal_list
                         (fun a__410_ (b__411_ [@merlin.hide]) ->
                            (equal a__410_ b__411_ [@merlin.hide]))
                         _a__406_
                         _b__407_)))
           : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let rec t_of_sexp =
          (let error_source__414_ = "bin_shape.ml.before-ppx.Expression.Stable.V1.t" in
           function
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("annotate" | "Annotate") as _tag__417_)
               :: sexp_args__418_) as _sexp__416_ ->
             (match sexp_args__418_ with
              | [ arg0__419_; arg1__420_ ] ->
                let res0__421_ = Uuid.t_of_sexp arg0__419_
                and res1__422_ = t_of_sexp arg1__420_ in
                Annotate (res0__421_, res1__422_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__417_
                  _sexp__416_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("base" | "Base") as _tag__424_) :: sexp_args__425_)
             as _sexp__423_ ->
             (match sexp_args__425_ with
              | [ arg0__426_; arg1__427_ ] ->
                let res0__428_ = Uuid.t_of_sexp arg0__426_
                and res1__429_ = list_of_sexp t_of_sexp arg1__427_ in
                Base (res0__428_, res1__429_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__424_
                  _sexp__423_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("record" | "Record") as _tag__431_)
               :: sexp_args__432_) as _sexp__430_ ->
             (match sexp_args__432_ with
              | arg0__438_ :: [] ->
                let res0__439_ =
                  list_of_sexp
                    (function
                      | Sexplib0.Sexp.List [ arg0__433_; arg1__434_ ] ->
                        let res0__435_ = string_of_sexp arg0__433_
                        and res1__436_ = t_of_sexp arg1__434_ in
                        res0__435_, res1__436_
                      | sexp__437_ ->
                        Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                          error_source__414_
                          2
                          sexp__437_)
                    arg0__438_
                in
                Record res0__439_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__431_
                  _sexp__430_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("variant" | "Variant") as _tag__441_)
               :: sexp_args__442_) as _sexp__440_ ->
             (match sexp_args__442_ with
              | arg0__448_ :: [] ->
                let res0__449_ =
                  list_of_sexp
                    (function
                      | Sexplib0.Sexp.List [ arg0__443_; arg1__444_ ] ->
                        let res0__445_ = string_of_sexp arg0__443_
                        and res1__446_ = list_of_sexp t_of_sexp arg1__444_ in
                        res0__445_, res1__446_
                      | sexp__447_ ->
                        Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                          error_source__414_
                          2
                          sexp__447_)
                    arg0__448_
                in
                Variant res0__449_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__441_
                  _sexp__440_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("tuple" | "Tuple") as _tag__451_) :: sexp_args__452_)
             as _sexp__450_ ->
             (match sexp_args__452_ with
              | arg0__453_ :: [] ->
                let res0__454_ = list_of_sexp t_of_sexp arg0__453_ in
                Tuple res0__454_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__451_
                  _sexp__450_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("poly_variant" | "Poly_variant") as _tag__456_)
               :: sexp_args__457_) as _sexp__455_ ->
             (match sexp_args__457_ with
              | arg0__463_ :: [] ->
                let res0__464_ =
                  match arg0__463_ with
                  | Sexplib0.Sexp.List [ arg0__458_; arg1__459_ ] ->
                    let res0__460_ = Location.t_of_sexp arg0__458_
                    and res1__461_ =
                      list_of_sexp (poly_constr_of_sexp t_of_sexp) arg1__459_
                    in
                    res0__460_, res1__461_
                  | sexp__462_ ->
                    Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                      error_source__414_
                      2
                      sexp__462_
                in
                Poly_variant res0__464_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__456_
                  _sexp__455_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("var" | "Var") as _tag__466_) :: sexp_args__467_) as
             _sexp__465_ ->
             (match sexp_args__467_ with
              | arg0__473_ :: [] ->
                let res0__474_ =
                  match arg0__473_ with
                  | Sexplib0.Sexp.List [ arg0__468_; arg1__469_ ] ->
                    let res0__470_ = Location.t_of_sexp arg0__468_
                    and res1__471_ = Vid.t_of_sexp arg1__469_ in
                    res0__470_, res1__471_
                  | sexp__472_ ->
                    Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                      error_source__414_
                      2
                      sexp__472_
                in
                Var res0__474_
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__466_
                  _sexp__465_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("rec_app" | "Rec_app") as _tag__476_)
               :: sexp_args__477_) as _sexp__475_ ->
             (match sexp_args__477_ with
              | [ arg0__478_; arg1__479_ ] ->
                let res0__480_ = Tid.t_of_sexp arg0__478_
                and res1__481_ = list_of_sexp t_of_sexp arg1__479_ in
                Rec_app (res0__480_, res1__481_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__476_
                  _sexp__475_)
           | Sexplib0.Sexp.List
               (Sexplib0.Sexp.Atom (("top_app" | "Top_app") as _tag__483_)
               :: sexp_args__484_) as _sexp__482_ ->
             (match sexp_args__484_ with
              | [ arg0__485_; arg1__486_; arg2__487_ ] ->
                let res0__488_ = Group.t_of_sexp t_of_sexp arg0__485_
                and res1__489_ = Tid.t_of_sexp arg1__486_
                and res2__490_ = list_of_sexp t_of_sexp arg2__487_ in
                Top_app (res0__488_, res1__489_, res2__490_)
              | _ ->
                Sexplib0.Sexp_conv_error.stag_incorrect_n_args
                  error_source__414_
                  _tag__483_
                  _sexp__482_)
           | Sexplib0.Sexp.Atom ("annotate" | "Annotate") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("base" | "Base") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("record" | "Record") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("variant" | "Variant") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("tuple" | "Tuple") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("poly_variant" | "Poly_variant") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("var" | "Var") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("rec_app" | "Rec_app") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.Atom ("top_app" | "Top_app") as sexp__415_ ->
             Sexplib0.Sexp_conv_error.stag_takes_args error_source__414_ sexp__415_
           | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__413_ ->
             Sexplib0.Sexp_conv_error.nested_list_invalid_sum
               error_source__414_
               sexp__413_
           | Sexplib0.Sexp.List [] as sexp__413_ ->
             Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__414_ sexp__413_
           | sexp__413_ ->
             Sexplib0.Sexp_conv_error.unexpected_stag error_source__414_ sexp__413_
           : Sexplib0.Sexp.t -> t)
        ;;

        let _ = t_of_sexp

        let rec sexp_of_t =
          (function
           | Annotate (arg0__491_, arg1__492_) ->
             let res0__493_ = Uuid.sexp_of_t arg0__491_
             and res1__494_ = sexp_of_t arg1__492_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Annotate"; res0__493_; res1__494_ ]
           | Base (arg0__495_, arg1__496_) ->
             let res0__497_ = Uuid.sexp_of_t arg0__495_
             and res1__498_ = sexp_of_list sexp_of_t arg1__496_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Base"; res0__497_; res1__498_ ]
           | Record arg0__503_ ->
             let res0__504_ =
               sexp_of_list
                 (fun (arg0__499_, arg1__500_) ->
                    let res0__501_ = sexp_of_string arg0__499_
                    and res1__502_ = sexp_of_t arg1__500_ in
                    Sexplib0.Sexp.List [ res0__501_; res1__502_ ])
                 arg0__503_
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Record"; res0__504_ ]
           | Variant arg0__509_ ->
             let res0__510_ =
               sexp_of_list
                 (fun (arg0__505_, arg1__506_) ->
                    let res0__507_ = sexp_of_string arg0__505_
                    and res1__508_ = sexp_of_list sexp_of_t arg1__506_ in
                    Sexplib0.Sexp.List [ res0__507_; res1__508_ ])
                 arg0__509_
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Variant"; res0__510_ ]
           | Tuple arg0__511_ ->
             let res0__512_ = sexp_of_list sexp_of_t arg0__511_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Tuple"; res0__512_ ]
           | Poly_variant arg0__517_ ->
             let res0__518_ =
               let arg0__513_, arg1__514_ = arg0__517_ in
               let res0__515_ = Location.sexp_of_t arg0__513_
               and res1__516_ = sexp_of_list (sexp_of_poly_constr sexp_of_t) arg1__514_ in
               Sexplib0.Sexp.List [ res0__515_; res1__516_ ]
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Poly_variant"; res0__518_ ]
           | Var arg0__523_ ->
             let res0__524_ =
               let arg0__519_, arg1__520_ = arg0__523_ in
               let res0__521_ = Location.sexp_of_t arg0__519_
               and res1__522_ = Vid.sexp_of_t arg1__520_ in
               Sexplib0.Sexp.List [ res0__521_; res1__522_ ]
             in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Var"; res0__524_ ]
           | Rec_app (arg0__525_, arg1__526_) ->
             let res0__527_ = Tid.sexp_of_t arg0__525_
             and res1__528_ = sexp_of_list sexp_of_t arg1__526_ in
             Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Rec_app"; res0__527_; res1__528_ ]
           | Top_app (arg0__529_, arg1__530_, arg2__531_) ->
             let res0__532_ = Group.sexp_of_t sexp_of_t arg0__529_
             and res1__533_ = Tid.sexp_of_t arg1__530_
             and res2__534_ = sexp_of_list sexp_of_t arg2__531_ in
             Sexplib0.Sexp.List
               [ Sexplib0.Sexp.Atom "Top_app"; res0__532_; res1__533_; res2__534_ ]
           : t -> Sexplib0.Sexp.t)
        ;;

        let _ = sexp_of_t
        let annotate v0 v1 = Annotate (v0, v1)
        let _ = annotate
        let base v0 v1 = Base (v0, v1)
        let _ = base
        let record v0 = Record v0
        let _ = record
        let variant v0 = Variant v0
        let _ = variant
        let tuple v0 = Tuple v0
        let _ = tuple
        let poly_variant v0 = Poly_variant v0
        let _ = poly_variant
        let var v0 = Var v0
        let _ = var
        let rec_app v0 v1 = Rec_app (v0, v1)
        let _ = rec_app
        let top_app v0 v1 v2 = Top_app (v0, v1, v2)
        let _ = top_app

        let is_annotate = function
          | Annotate _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_annotate

        let is_base = function
          | Base _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_base

        let is_record = function
          | Record _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_record

        let is_variant = function
          | Variant _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_variant

        let is_tuple = function
          | Tuple _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_tuple

        let is_poly_variant = function
          | Poly_variant _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_poly_variant

        let is_var = function
          | Var _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_var

        let is_rec_app = function
          | Rec_app _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_rec_app

        let is_top_app = function
          | Top_app _ -> true
          | _ -> false
        [@@warning "-4"]
        ;;

        let _ = is_top_app

        let annotate_val = function
          | Annotate (v0, v1) -> Stdlib.Option.Some (v0, v1)
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = annotate_val

        let base_val = function
          | Base (v0, v1) -> Stdlib.Option.Some (v0, v1)
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = base_val

        let record_val = function
          | Record v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = record_val

        let variant_val = function
          | Variant v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = variant_val

        let tuple_val = function
          | Tuple v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = tuple_val

        let poly_variant_val = function
          | Poly_variant v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = poly_variant_val

        let var_val = function
          | Var v0 -> Stdlib.Option.Some v0
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = var_val

        let rec_app_val = function
          | Rec_app (v0, v1) -> Stdlib.Option.Some (v0, v1)
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = rec_app_val

        let top_app_val = function
          | Top_app (v0, v1, v2) -> Stdlib.Option.Some (v0, v1, v2)
          | _ -> Stdlib.Option.None
        [@@warning "-4"]
        ;;

        let _ = top_app_val

        module Variants = struct
          let annotate =
            { Variantslib.Variant.name = "Annotate"; rank = 0; constructor = annotate }
          ;;

          let _ = annotate
          let base = { Variantslib.Variant.name = "Base"; rank = 1; constructor = base }
          let _ = base

          let record =
            { Variantslib.Variant.name = "Record"; rank = 2; constructor = record }
          ;;

          let _ = record

          let variant =
            { Variantslib.Variant.name = "Variant"; rank = 3; constructor = variant }
          ;;

          let _ = variant

          let tuple =
            { Variantslib.Variant.name = "Tuple"; rank = 4; constructor = tuple }
          ;;

          let _ = tuple

          let poly_variant =
            { Variantslib.Variant.name = "Poly_variant"
            ; rank = 5
            ; constructor = poly_variant
            }
          ;;

          let _ = poly_variant
          let var = { Variantslib.Variant.name = "Var"; rank = 6; constructor = var }
          let _ = var

          let rec_app =
            { Variantslib.Variant.name = "Rec_app"; rank = 7; constructor = rec_app }
          ;;

          let _ = rec_app

          let top_app =
            { Variantslib.Variant.name = "Top_app"; rank = 8; constructor = top_app }
          ;;

          let _ = top_app

          let fold
                ~init:init__
                ~annotate:annotate_fun__
                ~base:base_fun__
                ~record:record_fun__
                ~variant:variant_fun__
                ~tuple:tuple_fun__
                ~poly_variant:poly_variant_fun__
                ~var:var_fun__
                ~rec_app:rec_app_fun__
                ~top_app:top_app_fun__
            =
            top_app_fun__
              (rec_app_fun__
                 (var_fun__
                    (poly_variant_fun__
                       (tuple_fun__
                          (variant_fun__
                             (record_fun__
                                (base_fun__ (annotate_fun__ init__ annotate) base)
                                record)
                             variant)
                          tuple)
                       poly_variant)
                    var)
                 rec_app)
              top_app
          ;;

          let _ = fold

          let iter
                ~annotate:annotate_fun__
                ~base:base_fun__
                ~record:record_fun__
                ~variant:variant_fun__
                ~tuple:tuple_fun__
                ~poly_variant:poly_variant_fun__
                ~var:var_fun__
                ~rec_app:rec_app_fun__
                ~top_app:top_app_fun__
            =
            (annotate_fun__ annotate : unit);
            (base_fun__ base : unit);
            (record_fun__ record : unit);
            (variant_fun__ variant : unit);
            (tuple_fun__ tuple : unit);
            (poly_variant_fun__ poly_variant : unit);
            (var_fun__ var : unit);
            (rec_app_fun__ rec_app : unit);
            (top_app_fun__ top_app : unit)
          ;;

          let _ = iter

          let map
                t__
                ~annotate:annotate_fun__
                ~base:base_fun__
                ~record:record_fun__
                ~variant:variant_fun__
                ~tuple:tuple_fun__
                ~poly_variant:poly_variant_fun__
                ~var:var_fun__
                ~rec_app:rec_app_fun__
                ~top_app:top_app_fun__
            =
            match t__ with
            | Annotate (v0, v1) -> annotate_fun__ annotate v0 v1
            | Base (v0, v1) -> base_fun__ base v0 v1
            | Record v0 -> record_fun__ record v0
            | Variant v0 -> variant_fun__ variant v0
            | Tuple v0 -> tuple_fun__ tuple v0
            | Poly_variant v0 -> poly_variant_fun__ poly_variant v0
            | Var v0 -> var_fun__ var v0
            | Rec_app (v0, v1) -> rec_app_fun__ rec_app v0 v1
            | Top_app (v0, v1, v2) -> top_app_fun__ top_app v0 v1 v2
          ;;

          let _ = map

          let make_matcher
                ~annotate:annotate_fun__
                ~base:base_fun__
                ~record:record_fun__
                ~variant:variant_fun__
                ~tuple:tuple_fun__
                ~poly_variant:poly_variant_fun__
                ~var:var_fun__
                ~rec_app:rec_app_fun__
                ~top_app:top_app_fun__
                compile_acc__
            =
            let annotate_gen__, compile_acc__ = annotate_fun__ annotate compile_acc__ in
            let base_gen__, compile_acc__ = base_fun__ base compile_acc__ in
            let record_gen__, compile_acc__ = record_fun__ record compile_acc__ in
            let variant_gen__, compile_acc__ = variant_fun__ variant compile_acc__ in
            let tuple_gen__, compile_acc__ = tuple_fun__ tuple compile_acc__ in
            let poly_variant_gen__, compile_acc__ =
              poly_variant_fun__ poly_variant compile_acc__
            in
            let var_gen__, compile_acc__ = var_fun__ var compile_acc__ in
            let rec_app_gen__, compile_acc__ = rec_app_fun__ rec_app compile_acc__ in
            let top_app_gen__, compile_acc__ = top_app_fun__ top_app compile_acc__ in
            ( map
                ~annotate:(fun _ -> annotate_gen__)
                ~base:(fun _ -> base_gen__)
                ~record:(fun _ -> record_gen__)
                ~variant:(fun _ -> variant_gen__)
                ~tuple:(fun _ -> tuple_gen__)
                ~poly_variant:(fun _ -> poly_variant_gen__)
                ~var:(fun _ -> var_gen__)
                ~rec_app:(fun _ -> rec_app_gen__)
                ~top_app:(fun _ -> top_app_gen__)
            , compile_acc__ )
          ;;

          let _ = make_matcher

          let to_rank = function
            | Annotate _ -> 0
            | Base _ -> 1
            | Record _ -> 2
            | Variant _ -> 3
            | Tuple _ -> 4
            | Poly_variant _ -> 5
            | Var _ -> 6
            | Rec_app _ -> 7
            | Top_app _ -> 8
          ;;

          let _ = to_rank

          let to_name = function
            | Annotate _ -> "Annotate"
            | Base _ -> "Base"
            | Record _ -> "Record"
            | Variant _ -> "Variant"
            | Tuple _ -> "Tuple"
            | Poly_variant _ -> "Poly_variant"
            | Var _ -> "Var"
            | Rec_app _ -> "Rec_app"
            | Top_app _ -> "Top_app"
          ;;

          let _ = to_name

          let descriptions =
            [ "Annotate", 2
            ; "Base", 2
            ; "Record", 1
            ; "Variant", 1
            ; "Tuple", 1
            ; "Poly_variant", 1
            ; "Var", 1
            ; "Rec_app", 2
            ; "Top_app", 3
            ]
          ;;

          let _ = descriptions
        end
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end
  end

  include Stable.V1

  type group = t Group.t

  let group = Group.create

  type poly_variant_row = t poly_constr

  let constr s t = `Constr (s, t)
  let inherit_ loc t = `Inherit (loc, t)
  let var loc t = Var (loc, t)
  let poly_variant loc xs = Poly_variant (loc, xs)
  let basetype = base

  let is_cyclic_0 ~(via_VR : bool) : group -> Tid.t -> bool =
    fun group tid ->
    let set = ref [] in
    let visited tid = List.mem !set tid ~equal:Tid.equal in
    let add tid = set := tid :: !set in
    let rec trav = function
      | Annotate (_, t) -> trav t
      | Base (_, ts) | Tuple ts | Top_app (_, _, ts) -> List.iter ts ~f:trav
      | Poly_variant (_, cs) ->
        List.iter cs ~f:(function
          | `Constr (_, None) -> ()
          | `Constr (_, Some t) -> trav t
          | `Inherit (_loc, t) -> trav t)
      | Record xs -> if via_VR then List.iter xs ~f:(fun (_, t) -> trav t) else ()
      | Variant xs ->
        if via_VR then List.iter xs ~f:(fun (_, ts) -> List.iter ~f:trav ts) else ()
      | Var _ -> ()
      | Rec_app (tid, ts) ->
        if visited tid
        then ()
        else (
          add tid;
          trav_tid tid);
        List.iter ts ~f:trav
    and trav_tid tid =
      let _, body = Group.lookup group tid in
      trav body
    in
    trav_tid tid;
    let res = visited tid in
    res
  ;;

  let is_cyclic = is_cyclic_0 ~via_VR:true
  let is_cyclic_with_no_intervening_VR = is_cyclic_0 ~via_VR:false
end

include Expression

module Evaluation (Canonical : Canonical) = struct
  module Venv : sig
    type t

    val lookup : t -> Vid.t -> Visibility.visible Canonical.Exp1.t option
    val create : (Vid.t * Visibility.visible Canonical.Exp1.t) list -> t
  end = struct
    type t = Visibility.visible Canonical.Exp1.t Map.M(Vid).t

    let create =
      List.fold
        ~init:(Map.empty (module Vid))
        ~f:(fun t (k, v) -> Map.set ~key:k ~data:v t)
    ;;

    let lookup t k = Map.find t k
  end

  module Applicand = struct
    type t =
      | Recursion_level of int
      | Definition of Canonical.Def.t
  end

  module Tenv : sig
    type key = Gid.t * Tid.t
    type t

    val find : t -> key -> [ `Recursion_level of int ] option
    val empty : t
    val extend : t -> key -> [ `Recursion_level of int ] -> t
  end = struct
    module Key = struct
      module T = struct
        type t = Gid.t * Tid.t [@@deriving compare, sexp_of]

        include struct
          let _ = fun (_ : t) -> ()

          let compare =
            (fun a__535_ b__536_ ->
               let t__537_, t__538_ = a__535_ in
               let t__539_, t__540_ = b__536_ in
               match Gid.compare t__537_ t__539_ with
               | 0 -> Tid.compare t__538_ t__540_
               | n -> n
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let sexp_of_t =
            (fun (arg0__541_, arg1__542_) ->
               let res0__543_ = Gid.sexp_of_t arg0__541_
               and res1__544_ = Tid.sexp_of_t arg1__542_ in
               Sexplib0.Sexp.List [ res0__543_; res1__544_ ]
             : t -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end

      include T
      include Comparator.Make (T)
    end

    type key = Key.t
    type t = [ `Recursion_level of int ] Map.M(Key).t

    let find t k = Map.find t k
    let empty = Map.empty (module Key)
    let extend t k v = Map.set ~key:k ~data:v t
  end

  module Defining : sig
    type 'a t

    val return : 'a -> 'a t
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val look_env : Tenv.key -> Applicand.t option t
    val extend_new_tid : Tenv.key -> Canonical.Def.t t -> Applicand.t t
    val exec : 'a t -> 'a
  end = struct
    type 'a t = depth:int -> Tenv.t -> 'a

    let return x ~depth:_ _tenv = x

    let bind t f ~depth tenv =
      let x = t ~depth tenv in
      (f x) ~depth tenv
    ;;

    let look_env key ~depth:_ tenv =
      let result = Tenv.find tenv key in
      Option.map ~f:(fun (`Recursion_level x) -> Applicand.Recursion_level x) result
    ;;

    let extend_new_tid key def_t ~depth tenv =
      Applicand.Definition
        (let value = `Recursion_level depth in
         let tenv = Tenv.extend tenv key value in
         def_t ~depth:(depth + 1) tenv)
    ;;

    let exec t = t ~depth:0 Tenv.empty
  end

  type 'a defining = 'a Defining.t

  let ( >>= ) = Defining.bind
  let return = Defining.return

  let sequence_defining : 'a list -> f:('a -> 'b defining) -> 'b list defining =
    fun xs ~f ->
    let rec loop acc_ys = function
      | [] -> return (List.rev acc_ys)
      | x :: xs -> f x >>= fun y -> loop (y :: acc_ys) xs
    in
    loop [] xs
  ;;

  let rec eval : group -> Venv.t -> t -> Visibility.visible Canonical.Exp1.t defining =
    fun group venv t ->
    match t with
    | Record binds ->
      sequence_defining binds ~f:(fun (s, x) ->
        eval group venv x >>= fun y -> return (s, y))
      >>= fun binds -> return (Canonical.Create.record binds)
    | Variant alts ->
      sequence_defining alts ~f:(fun (s, xs) ->
        eval_list group venv xs >>= fun ys -> return (s, ys))
      >>= fun alts -> return (Canonical.Create.variant alts)
    | Var (loc, vid) ->
      (match Venv.lookup venv vid with
       | Some x -> return x
       | None ->
         eval_fail
           loc
           ((Format
               ( String_literal
                   ( "Free type variable: '"
                   , Custom
                       ( Custom_succ Custom_zero
                       , (fun () _custom_printf__545_ ->
                           Vid.to_string _custom_printf__545_)
                       , End_of_format ) )
               , "Free type variable: '%{Vid}" )
            : (_, _, _, _, _, _) CamlinternalFormatBasics.format6)
            [@merlin.hide])
           vid
           ())
    | Annotate (s, t) ->
      eval group venv t >>= fun v -> return (Canonical.Create.annotate s v)
    | Base (s, ts) ->
      eval_list group venv ts >>= fun vs -> return (Canonical.Create.basetype s vs)
    | Tuple ts -> eval_list group venv ts >>= fun vs -> return (Canonical.Create.tuple vs)
    | Top_app (in_group, tid, args) ->
      eval_list group venv args >>= fun args -> eval_app in_group tid args
    | Rec_app (tid, args) ->
      eval_list group venv args >>= fun args -> eval_app group tid args
    | Poly_variant (loc, cs) ->
      sequence_defining ~f:(eval_poly_constr group venv) cs
      >>= fun xss -> return (Canonical.Create.poly_variant loc (List.concat xss))

  and eval_list : group -> Venv.t -> t list -> _ Canonical.Exp1.t list defining =
    fun group venv ts -> sequence_defining ts ~f:(eval group venv)

  and eval_poly_constr
    :  group
    -> Venv.t
    -> t poly_constr
    -> (string * Visibility.opaque Canonical.Exp1.t option) list defining
    =
    fun group venv c ->
    match c with
    | `Constr (s, None) -> return [ s, None ]
    | `Constr (s, Some t) ->
      eval group venv t >>= fun v -> return [ s, Some (Canonical.Exp1.opaque v) ]
    | `Inherit (loc, t) ->
      eval group venv t
      >>= fun v ->
      (match Canonical.Exp1.get_poly_variant v with
       | Ok tab -> return (Sorted_table.expose tab)
       | Error desc ->
         eval_fail
           loc
           "The shape for an inherited type is not described as a polymorphic-variant: %s"
           desc
           ())

  and eval_definition : group -> Vid.t list -> t -> Canonical.Def.t defining =
    fun group formals body ->
    let venv = Venv.create (List.mapi formals ~f:(fun i x -> x, Canonical.Exp1.var i)) in
    eval group venv body >>= fun v -> return (Canonical.Create.define v)

  and eval_app : group -> Tid.t -> _ Canonical.Exp1.t list -> _ Canonical.Exp1.t defining =
    fun group tid args ->
    let gid = Group.id group in
    let formals, body = Group.lookup group tid in
    let record_or_normal_variant =
      match body with
      | Record _ | Variant _ -> true
      | Tuple _ | Annotate _ | Base _ | Poly_variant _ | Var _ | Rec_app _ | Top_app _ ->
        false
    in
    let cyclic = is_cyclic group tid in
    let cyclic_no_VR = is_cyclic_with_no_intervening_VR group tid in
    if (record_or_normal_variant && cyclic) || cyclic_no_VR
    then
      Defining.look_env (gid, tid)
      >>= (function
       | Some recurse -> return recurse
       | None -> Defining.extend_new_tid (gid, tid) (eval_definition group formals body))
      >>= function
      | Recursion_level r -> return (Canonical.Exp1.recurse r args)
      | Definition def -> return (Canonical.Exp1.apply def args)
    else (
      let venv =
        match List.zip formals args with
        | Ok x -> Venv.create x
        | Unequal_lengths -> failwith "apply, incorrect type application arity"
      in
      eval group venv body)
  ;;

  let eval : t -> Canonical.t =
    fun t ->
    let group = group (Location.of_string "top-level") [] in
    let venv = Venv.create [] in
    let v = Defining.exec (eval group venv t) in
    Canonical.Create.create v
  ;;
end

module Canonical = struct
  include Canonical_full

  module Exp = struct
    type t = Visibility.visible Exp1.t
  end
end

include Evaluation (Canonical_full)
module Canonical_selected = Canonical_digest
module Evaluation_to_digest = Evaluation (Canonical_selected)

let eval_to_digest exp = Canonical_selected.to_digest (Evaluation_to_digest.eval exp)
let eval_to_digest_string exp = Digest.to_hex (eval_to_digest exp)

module For_typerep = struct
  exception Not_a_tuple of t [@@deriving sexp_of]

  include struct
    let () =
      Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Not_a_tuple] (function
        | Not_a_tuple arg0__546_ ->
          let res0__547_ = sexp_of_t arg0__546_ in
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "bin_shape.ml.before-ppx.For_typerep.Not_a_tuple"
            ; res0__547_
            ]
        | _ -> assert false)
    ;;
  end [@@ocaml.doc "@inline"] [@@merlin.hide]

  let deconstruct_tuple_exn t =
    match t with
    | Tuple ts -> ts
    | _ -> raise (Not_a_tuple t)
  ;;
end

module Expert = struct
  module Sorted_table = Sorted_table
  module Canonical_exp_constructor = Canonical_exp_constructor
  module Canonical = Canonical
end
