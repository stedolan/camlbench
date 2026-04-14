let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "test_binary_searchable.ml.before-ppx"
;;

open! Base
open! Binary_searchable
include Test_binary_searchable_intf

module type S_gen = sig
  open Binary_searchable

  type 'a t
  type 'a elt

  val binary_search : ('a t, 'a elt, 'a elt) binary_search
  val binary_search_segmented : ('a t, 'a elt) binary_search_segmented
end

module type Indexable_gen_and_for_test = sig
  include S_gen

  module For_test : sig
    val compare : bool elt -> bool elt -> int
    val small : bool elt
    val big : bool elt
    val of_array : bool elt array -> bool t
  end
end

module Test_gen (M : Indexable_gen_and_for_test) = struct
  open M

  let () =
    Ppx_inline_test_lib.test_module
      ~config:(module Inline_test_config)
      ~descr:(lazy "test_binary_searchable")
      ~tags:[]
      ~filename:"test_binary_searchable.ml.before-ppx"
      ~line_number:29
      ~start_pos:2
      ~end_pos:10062
      (fun () ->
         let module M = struct
           let compare = For_test.compare
           let elt_compare = For_test.compare
           let s = For_test.small
           let b = For_test.big

           let binary_search ?pos ?len ~compare t how v =
             binary_search ?pos ?len ~compare (For_test.of_array t) how v
           ;;

           let ( = ) = Poly.equal

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [||] `First_equal_to [...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:41
               ~start_pos:6
               ~end_pos:71
               (fun () -> binary_search ~compare [||] `First_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `First_equal_to[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:42
               ~start_pos:6
               ~end_pos:76
               (fun () -> binary_search ~compare [| s |] `First_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `First_equal_to[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:43
               ~start_pos:6
               ~end_pos:74
               (fun () -> binary_search ~compare [| s |] `First_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b|] `First_equal_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:44
               ~start_pos:6
               ~end_pos:79
               (fun () -> binary_search ~compare [| s; b |] `First_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b|] `First_equal_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:45
               ~start_pos:6
               ~end_pos:79
               (fun () -> binary_search ~compare [| s; b |] `First_equal_to b = Some 1)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b;b|] `First_equal_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:46
               ~start_pos:6
               ~end_pos:77
               (fun () -> binary_search ~compare [| b; b |] `First_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;s|] `First_equal_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:47
               ~start_pos:6
               ~end_pos:77
               (fun () -> binary_search ~compare [| s; s |] `First_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b;b|] `First_equa[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:48
               ~start_pos:6
               ~end_pos:82
               (fun () -> binary_search ~compare [| s; b; b |] `First_equal_to b = Some 1)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;s;b|] `First_equa[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:49
               ~start_pos:6
               ~end_pos:82
               (fun () -> binary_search ~compare [| s; s; b |] `First_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b;b;b|] `First_equa[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:50
               ~start_pos:6
               ~end_pos:80
               (fun () -> binary_search ~compare [| b; b; b |] `First_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [||] `Last_equal_to s[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:51
               ~start_pos:6
               ~end_pos:70
               (fun () -> binary_search ~compare [||] `Last_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `Last_equal_to [...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:52
               ~start_pos:6
               ~end_pos:75
               (fun () -> binary_search ~compare [| s |] `Last_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `Last_equal_to [...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:53
               ~start_pos:6
               ~end_pos:73
               (fun () -> binary_search ~compare [| s |] `Last_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b|] `Last_equal_t[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:54
               ~start_pos:6
               ~end_pos:78
               (fun () -> binary_search ~compare [| s; b |] `Last_equal_to b = Some 1)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b|] `Last_equal_t[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:55
               ~start_pos:6
               ~end_pos:78
               (fun () -> binary_search ~compare [| s; b |] `Last_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b;b|] `Last_equal_t[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:56
               ~start_pos:6
               ~end_pos:76
               (fun () -> binary_search ~compare [| b; b |] `Last_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;s|] `Last_equal_t[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:57
               ~start_pos:6
               ~end_pos:76
               (fun () -> binary_search ~compare [| s; s |] `Last_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;b;b|] `Last_equal[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:58
               ~start_pos:6
               ~end_pos:81
               (fun () -> binary_search ~compare [| s; b; b |] `Last_equal_to b = Some 2)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s;s;b|] `Last_equal[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:59
               ~start_pos:6
               ~end_pos:81
               (fun () -> binary_search ~compare [| s; s; b |] `Last_equal_to s = Some 1)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b;b;b|] `Last_equal[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:60
               ~start_pos:6
               ~end_pos:79
               (fun () -> binary_search ~compare [| b; b; b |] `Last_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [||] `First_greater_t[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:61
               ~start_pos:6
               ~end_pos:87
               (fun () ->
                  binary_search ~compare [||] `First_greater_than_or_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b|] `First_greater_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:63
               ~start_pos:6
               ~end_pos:100
               (fun () ->
                  binary_search ~compare [| b |] `First_greater_than_or_equal_to s
                  = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `First_greater_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:67
               ~start_pos:6
               ~end_pos:100
               (fun () ->
                  binary_search ~compare [| s |] `First_greater_than_or_equal_to s
                  = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `First_strictly[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:71
               ~start_pos:6
               ~end_pos:87
               (fun () ->
                  binary_search ~compare [| s |] `First_strictly_greater_than s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [||] `Last_less_than_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:72
               ~start_pos:6
               ~end_pos:83
               (fun () ->
                  binary_search ~compare [||] `Last_less_than_or_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|b|] `Last_less_than[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:73
               ~start_pos:6
               ~end_pos:86
               (fun () ->
                  binary_search ~compare [| b |] `Last_less_than_or_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `Last_less_than[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:74
               ~start_pos:6
               ~end_pos:88
               (fun () ->
                  binary_search ~compare [| s |] `Last_less_than_or_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search ~compare [|s|] `Last_strictly_[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:75
               ~start_pos:6
               ~end_pos:83
               (fun () ->
                  binary_search ~compare [| s |] `Last_strictly_less_than s = None)
           ;;

           let create_test_case (num_s, num_b) =
             let arr = Array.create b ~len:(num_s + num_b) in
             for i = 0 to num_s - 1 do
               arr.(i) <- s
             done;
             arr
           ;;

           let only_small = 10_000, 0
           let only_big = 0, 10_000
           let both = 2531, 4717

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<match binary_search (create_test_case only_sm[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:89
               ~start_pos:6
               ~end_pos:157
               (fun () ->
                  match
                    binary_search (create_test_case only_small) ~compare `First_equal_to s
                  with
                  | None -> false
                  | Some _ -> true)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<match binary_search arr ~compare `First_equal[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:95
               ~start_pos:6
               ~end_pos:178
               (fun () ->
                  let arr = create_test_case both in
                  match binary_search arr ~compare `First_equal_to b with
                  | None -> false
                  | Some v -> v = 2531)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_equal_to b[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:102
               ~start_pos:6
               ~end_pos:127
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `First_equal_to b = None)
           ;;

           let create_deterministic_test () =
             Array.init 100_000 ~f:(fun i -> if i > 50_000 then b else s)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_equal_to s[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:111
               ~start_pos:6
               ~end_pos:130
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_equal_to s)[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:116
               ~start_pos:6
               ~end_pos:134
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_equal_to s = Some 50_000)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_greater_th[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:121
               ~start_pos:6
               ~end_pos:146
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_greater_than_or_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_less_than_o[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:126
               ~start_pos:6
               ~end_pos:147
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_less_than_or_equal_to s = Some 50_000)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_strictly_g[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:131
               ~start_pos:6
               ~end_pos:148
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_strictly_greater_than s = Some 50_001)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_strictly_le[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:136
               ~start_pos:6
               ~end_pos:144
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_strictly_less_than b = Some 50_000)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_equal_to b[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:142
               ~start_pos:6
               ~end_pos:135
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_equal_to b = Some 50_001)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_equal_to b)[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:147
               ~start_pos:6
               ~end_pos:134
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_equal_to b = Some 99_999)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_greater_th[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:152
               ~start_pos:6
               ~end_pos:151
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_greater_than_or_equal_to b
                  = Some 50_001)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_less_than_o[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:157
               ~start_pos:6
               ~end_pos:147
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_less_than_or_equal_to b = Some 99_999)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_strictly_g[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:162
               ~start_pos:6
               ~end_pos:141
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `First_strictly_greater_than b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_strictly_le[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:167
               ~start_pos:6
               ~end_pos:144
               (fun () ->
                  let arr = create_deterministic_test () in
                  binary_search arr ~compare `Last_strictly_less_than b = Some 50_000)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_equal_to s[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:174
               ~start_pos:6
               ~end_pos:125
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `First_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_equal_to s)[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:179
               ~start_pos:6
               ~end_pos:124
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `Last_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_greater_th[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:184
               ~start_pos:6
               ~end_pos:143
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `First_greater_than_or_equal_to s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_less_than_o[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:189
               ~start_pos:6
               ~end_pos:137
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `Last_less_than_or_equal_to s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_strictly_g[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:194
               ~start_pos:6
               ~end_pos:140
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `First_strictly_greater_than s = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_strictly_le[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:199
               ~start_pos:6
               ~end_pos:134
               (fun () ->
                  let arr = create_test_case only_big in
                  binary_search arr ~compare `Last_strictly_less_than b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_equal_to b[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:206
               ~start_pos:6
               ~end_pos:127
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `First_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_equal_to b)[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:211
               ~start_pos:6
               ~end_pos:126
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `Last_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_greater_th[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:216
               ~start_pos:6
               ~end_pos:143
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `First_greater_than_or_equal_to b = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_less_than_o[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:221
               ~start_pos:6
               ~end_pos:145
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `Last_less_than_or_equal_to b = Some 9_999)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `First_strictly_g[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:226
               ~start_pos:6
               ~end_pos:140
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `First_strictly_greater_than s = None)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<(binary_search arr ~compare `Last_strictly_le[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:231
               ~start_pos:6
               ~end_pos:142
               (fun () ->
                  let arr = create_test_case only_small in
                  binary_search arr ~compare `Last_strictly_less_than b = Some 9_999)
           ;;

           let () =
             Ppx_inline_test_lib.test_unit
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<for length = 0 to 5 do   for num_s = 0 to len[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:236
               ~start_pos:6
               ~end_pos:1834
               (fun () ->
                  for length = 0 to 5 do
                    for num_s = 0 to length do
                      let arr =
                        Array.init length ~f:(fun i -> if i < num_s then s else b)
                      in
                      for pos = -1 to length do
                        for len = -1 to length + 1 do
                          let should_raise =
                            Exn.does_raise (fun () ->
                              Ordered_collection_common.check_pos_len_exn
                                ~pos
                                ~len
                                ~total_length:length)
                          in
                          let result =
                            Result.try_with (fun () ->
                              binary_search
                                arr
                                ~pos
                                ~len
                                ~compare:elt_compare
                                `Last_equal_to
                                s)
                          in
                          match should_raise, result with
                          | true, Error _ -> ()
                          | true, Ok _ -> failwith "expected it to raise but it didn't"
                          | false, Error _ ->
                            failwith "expected it to not raise, but it raised"
                          | false, Ok result ->
                            let searched = num_s - 1 in
                            let correct_result =
                              if searched < pos
                              then None
                              else if len = 0
                              then None
                              else if searched >= pos + len
                              then Some (pos + len - 1)
                              else Some searched
                            in
                            if not (correct_result = result) then failwith "Wrong result"
                        done
                      done
                    done
                  done;
                  ())
           ;;

           let binary_search_segmented a = binary_search_segmented (For_test.of_array a)

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<((binary_search_segmented arr ~segment_of `La[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:284
               ~start_pos:6
               ~end_pos:287
               (fun () ->
                  let arr = create_deterministic_test () in
                  let segment_of x = if x = b then `Right else `Left in
                  binary_search_segmented arr ~segment_of `Last_on_left = Some 50_000
                  && binary_search_segmented arr ~segment_of `First_on_right = Some 50_001)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<((binary_search_segmented arr ~segment_of `La[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:291
               ~start_pos:6
               ~end_pos:250
               (fun () ->
                  let arr = create_deterministic_test () in
                  let segment_of _ = `Right in
                  binary_search_segmented arr ~segment_of `Last_on_left = None
                  && binary_search_segmented arr ~segment_of `First_on_right = Some 0)
           ;;

           let () =
             Ppx_inline_test_lib.test
               ~config:(module Inline_test_config)
               ~descr:(lazy "<<((binary_search_segmented arr ~segment_of `La[...]>>")
               ~tags:[]
               ~filename:"test_binary_searchable.ml.before-ppx"
               ~line_number:298
               ~start_pos:6
               ~end_pos:254
               (fun () ->
                  let arr = create_deterministic_test () in
                  let segment_of _ = `Left in
                  binary_search_segmented arr ~segment_of `Last_on_left = Some 99_999
                  && binary_search_segmented arr ~segment_of `First_on_right = None)
           ;;
         end
         in
         ())
  ;;
end

module Test (M : Binary_searchable_and_for_test) = Test_gen (struct
    type 'a t = M.t
    type 'a elt = M.elt

    let binary_search = M.binary_search
    let binary_search_segmented = M.binary_search_segmented

    module For_test = M.For_test
  end)

module Test1 (M : Binary_searchable1_and_for_test) = Test_gen (struct
    type 'a t = 'a M.t
    type 'a elt = 'a

    let binary_search = M.binary_search
    let binary_search_segmented = M.binary_search_segmented

    module For_test = struct
      let of_array = M.For_test.of_array
      let compare = Bool.compare
      let small = false
      let big = true
    end
  end)

module Make_and_test (M : Indexable_and_for_test) = struct
  module B = Binary_searchable.Make (M)
  include B

  include Test (struct
      type t = M.t
      type elt = M.elt

      include B
      module For_test = M.For_test
    end)
end

module Make1_and_test (M : Indexable1_and_for_test) = struct
  module B = Binary_searchable.Make1 (M)
  include B

  include Test1 (struct
      type 'a t = 'a M.t

      include B
      module For_test = M.For_test
    end)
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
