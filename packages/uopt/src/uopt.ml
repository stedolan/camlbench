let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"uopt.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "uopt.ml.before-ppx"
;;

open Base
module Obj = Stdlib.Obj
module Obj_local = Base.Exported_for_specific_uses.Obj_local

type +'a t

let none : _ t = Obj.magic "Uopt.none"

let some (x : 'a) =
  let r : 'a t = Obj.magic x in
  if phys_equal r none then failwith "Uopt.some Uopt.none";
  r
[@@inline]
;;

let some_local (type a) (x : a) : a t =
  let r : a t = Obj_local.magic x in
  if phys_equal r none then failwith "Uopt.Local.some Uopt.none";
  r
[@@inline]
;;

let unsafe_value : 'a t -> 'a = Obj.magic
let unsafe_value_local : 'a t -> 'a = Obj_local.magic
let is_none t = phys_equal t none [@@inline]
let is_some t = not (is_none t) [@@inline]
let invariant invariant_a t = if is_some t then invariant_a (unsafe_value t) [@@inline]

let value_exn t = if is_none t then failwith "Uopt.value_exn" else unsafe_value t
[@@inline]
;;

let value t ~default = Bool.select (is_none t) default (unsafe_value t) [@@inline]

let value_local t ~default = Bool.select (is_none t) default (unsafe_value_local t)
[@@inline]
;;

let some_if cond x = Bool.select cond (some x) none [@@inline]
let some_if_local cond x = Bool.select cond (some_local x) none [@@inline]
let to_option t = if is_none t then None else Some (unsafe_value t) [@@inline]

let to_option_local t = Bool.select (is_none t) None (Some (unsafe_value_local t))
[@@inline]
;;

let of_option_local opt =
  match opt with
  | None -> none
  | Some x -> some_local x
[@@inline]
;;

let of_option opt =
  match opt with
  | None -> none
  | Some a -> some a
[@@inline]
;;

include
  Sexpable.Of_sexpable1
    (Option)
    (struct
      type nonrec 'a t = 'a t

      let to_sexpable = to_option
      let of_sexpable = of_option
    end)

module Optional_syntax = struct
  module Optional_syntax = struct
    let is_none = is_none
    let unsafe_value = unsafe_value
  end
end

module Local = struct
  let some = some_local
  let unsafe_value = unsafe_value_local
  let value = value_local
  let some_if = some_if_local
  let to_option = to_option_local
  let of_option = of_option_local

  module Optional_syntax = struct
    module Optional_syntax = struct
      let is_none = is_none
      let unsafe_value = unsafe_value_local
    end
  end
end

let globalize globalize_a t =
  let __ppx_optional_e_0 = t in
  if false
  then (
    (match
       if Local.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0
       then None
       else Some (Local.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0)
     with
     | None -> none
     | Some x -> some (globalize_a x))
    [@merlin.focus])
  else (
    (match Local.Optional_syntax.Optional_syntax.is_none __ppx_optional_e_0 with
     | (true [@merlin.hide]) -> none
     | (false [@merlin.hide]) ->
       let x : _ =
         Local.Optional_syntax.Optional_syntax.unsafe_value __ppx_optional_e_0
       in
       some (globalize_a x))
    [@merlin.hide] [@ocaml.warning "-a"])
;;

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"uopt.ml.before-ppx"
    ~line_number:100
    ~start_pos:0
    ~end_pos:253
    (fun () ->
       let module M = struct
         let () =
           Ppx_inline_test_lib.test_unit
             ~config:(module Inline_test_config)
             ~descr:(lazy "using the same sentinel value")
             ~tags:[ "no-js" ]
             ~filename:"uopt.ml.before-ppx"
             ~line_number:102
             ~start_pos:4
             ~end_pos:203
             (fun () ->
                (match some "Uopt.none" with
                 | (_ : string t) -> failwith "should not have gotten to this point"
                 | exception _ -> ());
                ())
         ;;
       end
       in
       ())
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
