let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timezone.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timezone.ml.before-ppx"
;;

open Core
include Timezone_intf
include Core_private.Time_zone

module type Extend_zone = Timezone_intf.Extend_zone

module Zone_cache = struct
  type z =
    { mutable full : bool
    ; basedir : string
    ; table : t String.Table.t
    }

  let the_one_and_only =
    { full = false
    ; basedir = Option.value (Sys.getenv "TZDIR") ~default:"/usr/share/zoneinfo/"
    ; table = String.Table.create ()
    }
  ;;

  let find zone = Hashtbl.find the_one_and_only.table zone

  let find_or_load zonename =
    match find zonename with
    | Some z -> Some z
    | None ->
      if the_one_and_only.full
      then None
      else (
        try
          let filename = the_one_and_only.basedir ^ "/" ^ zonename in
          let zone = input_tz_file ~zonename ~filename in
          Hashtbl.set the_one_and_only.table ~key:zonename ~data:zone;
          Some zone
        with
        | _ -> None)
  ;;

  let traverse basedir ~f =
    let skip_prefixes = [ "Etc/GMT"; "right/"; "posix/" ] in
    let maxdepth = 10 in
    let basedir_len = String.length basedir + 1 in
    let rec dfs dir depth =
      if depth < 1
      then ()
      else
        Array.iter (Stdlib.Sys.readdir dir) ~f:(fun fn ->
          let fn = dir ^ "/" ^ fn in
          let relative_fn = String.drop_prefix fn basedir_len in
          match Stdlib.Sys.is_directory fn with
          | true ->
            if
              not
                (List.exists skip_prefixes ~f:(fun prefix ->
                   String.is_prefix ~prefix relative_fn))
            then dfs fn (depth - 1)
          | false -> f relative_fn)
    in
    dfs basedir maxdepth
  ;;

  let init () =
    if not the_one_and_only.full
    then (
      traverse the_one_and_only.basedir ~f:(fun zone_name ->
        ignore (find_or_load zone_name : t option));
      the_one_and_only.full <- true)
  ;;

  let to_alist () = Hashtbl.to_alist the_one_and_only.table

  let initialized_zones () =
    List.sort ~compare:(fun a b -> String.ascending (fst a) (fst b)) (to_alist ())
  ;;

  let find_or_load_matching t1 =
    let file_size filename =
      let c = Stdio.In_channel.create filename in
      let l = Stdio.In_channel.length c in
      Stdio.In_channel.close c;
      l
    in
    let t1_file_size = Option.map (original_filename t1) ~f:file_size in
    with_return (fun r ->
      let return_if_matches zone_name =
        let filename = String.concat ~sep:"/" [ the_one_and_only.basedir; zone_name ] in
        let matches =
          try
            (fun (_x__001_ : int64 option) _x__002_ ->
               (match
                  (fun (a__003_ : int64 option)
                    ((b__004_ : int64 option) [@merlin.hide]) ->
                     (compare_option
                        (fun a__005_ (b__006_ [@merlin.hide]) ->
                           (compare_int64 a__005_ b__006_ [@merlin.hide]))
                        a__003_
                        b__004_ [@merlin.hide]))
                    _x__001_
                    _x__002_
                with
                | 0 -> true
                | _ -> false)
               [@merlin.hide])
              t1_file_size
              (Some (file_size filename))
            && (fun (_x__007_ : Md5.t option) _x__008_ ->
                  (match
                     (fun (a__009_ : Md5.t option)
                       ((b__010_ : Md5.t option) [@merlin.hide]) ->
                        (compare_option
                           (fun a__011_ (b__012_ [@merlin.hide]) ->
                              (Md5.compare a__011_ b__012_ [@merlin.hide]))
                           a__009_
                           b__010_ [@merlin.hide]))
                       _x__007_
                       _x__008_
                   with
                   | 0 -> true
                   | _ -> false)
                  [@merlin.hide])
                 (digest t1)
                 (let open Option in
                  join (map (find_or_load zone_name) ~f:digest))
          with
          | _ -> false
        in
        if matches then r.return (find_or_load zone_name) else ()
      in
      List.iter !likely_machine_zones ~f:return_if_matches;
      traverse the_one_and_only.basedir ~f:return_if_matches;
      None)
  ;;
end

let init = Zone_cache.init
let initialized_zones = Zone_cache.initialized_zones

let find zone =
  let zone =
    match zone with
    | "utc" -> "UTC"
    | "gmt" -> "GMT"
    | "chi" -> "America/Chicago"
    | "nyc" -> "America/New_York"
    | "hkg" -> "Asia/Hong_Kong"
    | "lon" | "ldn" -> "Europe/London"
    | "tyo" -> "Asia/Tokyo"
    | _ -> zone
  in
  Zone_cache.find_or_load zone
;;

let find_exn zone =
  match find zone with
  | None ->
    Error.raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string "unknown zone"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "zone"
               ; (sexp_of_string [@merlin.hide]) zone
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]))
  | Some z -> z
;;

let local =
  let local_zone_name = Sys.getenv "TZ" in
  let load () =
    match local_zone_name with
    | Some zone_name -> find_exn zone_name
    | None ->
      let localtime_t =
        input_tz_file ~zonename:"/etc/localtime" ~filename:"/etc/localtime"
      in
      (match Zone_cache.find_or_load_matching localtime_t with
       | Some t -> t
       | None -> localtime_t)
  in
  Lazy.from_fun load
;;

module Stable = struct
  include Core_private.Time_zone.Stable

  module V1 = struct
    type nonrec t = t

    let t_of_sexp sexp =
      match sexp with
      | Sexp.Atom "Local" -> Lazy.force local
      | Sexp.Atom name ->
        (try
           if String.equal name "UTC" || String.equal name "GMT"
           then of_utc_offset_explicit_name ~name ~hours:0
           else if
             String.is_prefix name ~prefix:"GMT-"
             || String.is_prefix name ~prefix:"GMT+"
             || String.is_prefix name ~prefix:"UTC-"
             || String.is_prefix name ~prefix:"UTC+"
           then (
             let offset =
               let base =
                 Int.of_string (String.sub name ~pos:4 ~len:(String.length name - 4))
               in
               match name.[3] with
               | '-' -> -1 * base
               | '+' -> base
               | _ -> assert false
             in
             of_utc_offset_explicit_name ~name ~hours:offset)
           else find_exn name
         with
         | exc ->
           of_sexp_error (sprintf "Timezone.t_of_sexp: %s" (Exn.to_string exc)) sexp)
      | _ -> of_sexp_error "Timezone.t_of_sexp: expected atom" sexp
    ;;

    let sexp_of_t t =
      let name = name t in
      if String.equal name "/etc/localtime"
      then failwith "the local time zone cannot be serialized";
      Sexp.Atom name
    ;;

    let t_sexp_grammar : t Sexplib.Sexp_grammar.t =
      { untyped =
          Tagged
            { key = Sexplib.Sexp_grammar.type_name_tag
            ; value = Atom "Timezone.t"
            ; grammar = String
            }
      }
    ;;

    include Sexpable.Stable.To_stringable.V1 (struct
        type nonrec t = t [@@deriving sexp]

        include struct
          let _ = fun (_ : t) -> ()
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)

    let compare t1 t2 = String.compare (to_string t1) (to_string t2)
    let equal t1 t2 = String.equal (to_string t1) (to_string t2)
    let hash_fold_t state t = String.hash_fold_t state (to_string t)
    let hash = Ppx_hash_lib.Std.Hash.of_fold hash_fold_t

    let to_binable t =
      let name = name t in
      if String.equal name "/etc/localtime"
      then failwith "the local time zone cannot be serialized";
      name
    ;;

    let of_binable s = t_of_sexp (Sexp.Atom s)

    include (
      Binable.Stable.Of_binable.V1 [@alert "-legacy"]
        (String)
        (struct
          type nonrec t = t

          let to_binable = to_binable
          let of_binable = of_binable
        end) :
          Binable.S with type t := t)

    let stable_witness =
      Stable_witness.of_serializable String.Stable.V1.stable_witness of_binable to_binable
    ;;

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving sexp, bin_io, equal]

        include struct
          let _ = fun (_ : t) -> ()
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "timezone.ml.before-ppx:245:6")
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

          let equal =
            (fun a__015_ b__016_ -> equal a__015_ b__016_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)
  end

  module Current = V1
end

include Identifiable.Make (struct
    let module_name = "Timezone"

    include Stable.Current

    let of_string = of_string
    let to_string = to_string
  end)

include Stable.Current

module Private = struct
  module Zone_cache = Zone_cache
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
