let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"binable0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "binable0.ml.before-ppx"
;;

open! Import
include Binable_intf
include Bin_prot.Binable
module Shape = Bin_prot.Shape

module Stable = struct
  module Of_binable = struct
    module V1
        (Binable : Minimal.S)
        (M : Conv_without_uuid with type binable := Binable.t) : S with type t := M.t =
    Bin_prot.Utils.Make_binable_without_uuid (struct
        module Binable = Binable
        include M
      end)
    [@@alert "-legacy"]

    module V2 (Binable : Minimal.S) (M : Conv with type binable := Binable.t) :
      S with type t := M.t = Bin_prot.Utils.Make_binable_with_uuid (struct
        module Binable = Binable
        include M
      end)
  end

  module Of_binable1 = struct
    module V1
        (Binable : Minimal.S1)
        (M : Conv1_without_uuid with type 'a binable := 'a Binable.t) :
      S1 with type 'a t := 'a M.t = Bin_prot.Utils.Make_binable1_without_uuid (struct
        module Binable = Binable
        include M
      end)
    [@@alert "-legacy"]

    module V2 (Binable : Minimal.S1) (M : Conv1 with type 'a binable := 'a Binable.t) :
      S1 with type 'a t := 'a M.t = Bin_prot.Utils.Make_binable1_with_uuid (struct
        module Binable = Binable
        include M
      end)
  end

  module Of_binable2 = struct
    module V1
        (Binable : Minimal.S2)
        (M : Conv2_without_uuid with type ('a, 'b) binable := ('a, 'b) Binable.t) :
      S2 with type ('a, 'b) t := ('a, 'b) M.t =
    Bin_prot.Utils.Make_binable2_without_uuid (struct
        module Binable = Binable
        include M
      end)
    [@@alert "-legacy"]

    module V2
        (Binable : Minimal.S2)
        (M : Conv2 with type ('a, 'b) binable := ('a, 'b) Binable.t) :
      S2 with type ('a, 'b) t := ('a, 'b) M.t =
    Bin_prot.Utils.Make_binable2_with_uuid (struct
        module Binable = Binable
        include M
      end)
  end

  module Of_binable3 = struct
    module V1
        (Binable : Minimal.S3)
        (M : Conv3_without_uuid with type ('a, 'b, 'c) binable := ('a, 'b, 'c) Binable.t) :
      S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) M.t =
    Bin_prot.Utils.Make_binable3_without_uuid (struct
        module Binable = Binable
        include M
      end)
    [@@alert "-legacy"]

    module V2
        (Binable : Minimal.S3)
        (M : Conv3 with type ('a, 'b, 'c) binable := ('a, 'b, 'c) Binable.t) :
      S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) M.t =
    Bin_prot.Utils.Make_binable3_with_uuid (struct
        module Binable = Binable
        include M
      end)
  end

  module Of_sexpable = struct
    module V1 (M : Sexpable.S) =
      Of_binable.V1
        (struct
          type t = Base.Sexp.t =
            | Atom of string
            | List of t list
          [@@deriving bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "binable0.ml.before-ppx:85:10")
                  [ ( Bin_prot.Shape.Tid.of_string "t"
                    , []
                    , Bin_prot.Shape.variant
                        [ "Atom", [ bin_shape_string ]
                        ; ( "List"
                          , [ bin_shape_list
                                ((Bin_prot.Shape.rec_app
                                    (Bin_prot.Shape.Tid.of_string "t"))
                                   [])
                            ] )
                        ] )
                  ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t

            let rec bin_size_t : t Bin_prot.Size.sizer = function
              | Atom v1 ->
                let size = 1 in
                Bin_prot.Common.( + ) size (bin_size_string v1)
              | List v1 ->
                let size = 1 in
                Bin_prot.Common.( + ) size (bin_size_list bin_size_t v1)
            ;;

            let _ = bin_size_t

            let rec bin_write_t : t Bin_prot.Write.writer =
              fun buf ~pos -> function
              | Atom v1 ->
                let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
                bin_write_string buf ~pos v1
              | List v1 ->
                let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
                bin_write_list bin_write_t buf ~pos v1
            ;;

            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t

            let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
              fun _buf ~pos_ref _vint ->
              Bin_prot.Common.raise_variant_wrong_type
                "binable0.ml.before-ppx.Stable.Of_sexpable.V1.t"
                !pos_ref

            and bin_read_t : t Bin_prot.Read.reader =
              fun buf ~pos_ref ->
              match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
              | 0 ->
                let arg_1 = bin_read_string buf ~pos_ref in
                Atom arg_1
              | 1 ->
                let arg_1 = (bin_read_list bin_read_t) buf ~pos_ref in
                List arg_1
              | _ ->
                Bin_prot.Common.raise_read_error
                  (Bin_prot.Common.ReadError.Sum_tag
                     "binable0.ml.before-ppx.Stable.Of_sexpable.V1.t")
                  !pos_ref
            ;;

            let _ = __bin_read_t__
            and _ = bin_read_t

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
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
        (struct
          type t = M.t

          let to_binable = M.sexp_of_t
          let of_binable = M.t_of_sexp
        end)

    module V2 (M : Conv_sexpable) =
      Of_binable.V2
        (struct
          type t = Base.Sexp.t =
            | Atom of string
            | List of t list
          [@@deriving bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "binable0.ml.before-ppx:100:10")
                  [ ( Bin_prot.Shape.Tid.of_string "t"
                    , []
                    , Bin_prot.Shape.variant
                        [ "Atom", [ bin_shape_string ]
                        ; ( "List"
                          , [ bin_shape_list
                                ((Bin_prot.Shape.rec_app
                                    (Bin_prot.Shape.Tid.of_string "t"))
                                   [])
                            ] )
                        ] )
                  ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t

            let rec bin_size_t : t Bin_prot.Size.sizer = function
              | Atom v1 ->
                let size = 1 in
                Bin_prot.Common.( + ) size (bin_size_string v1)
              | List v1 ->
                let size = 1 in
                Bin_prot.Common.( + ) size (bin_size_list bin_size_t v1)
            ;;

            let _ = bin_size_t

            let rec bin_write_t : t Bin_prot.Write.writer =
              fun buf ~pos -> function
              | Atom v1 ->
                let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 0 in
                bin_write_string buf ~pos v1
              | List v1 ->
                let pos = Bin_prot.Write.bin_write_int_8bit buf ~pos 1 in
                bin_write_list bin_write_t buf ~pos v1
            ;;

            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t

            let rec __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
              fun _buf ~pos_ref _vint ->
              Bin_prot.Common.raise_variant_wrong_type
                "binable0.ml.before-ppx.Stable.Of_sexpable.V2.t"
                !pos_ref

            and bin_read_t : t Bin_prot.Read.reader =
              fun buf ~pos_ref ->
              match Bin_prot.Read.bin_read_int_8bit buf ~pos_ref with
              | 0 ->
                let arg_1 = bin_read_string buf ~pos_ref in
                Atom arg_1
              | 1 ->
                let arg_1 = (bin_read_list bin_read_t) buf ~pos_ref in
                List arg_1
              | _ ->
                Bin_prot.Common.raise_read_error
                  (Bin_prot.Common.ReadError.Sum_tag
                     "binable0.ml.before-ppx.Stable.Of_sexpable.V2.t")
                  !pos_ref
            ;;

            let _ = __bin_read_t__
            and _ = bin_read_t

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
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
        (struct
          type t = M.t

          let to_binable = M.sexp_of_t
          let of_binable = M.t_of_sexp
          let caller_identity = M.caller_identity
        end)
  end

  module Of_stringable = struct
    module V1 (M : Stringable.S) = Bin_prot.Utils.Make_binable_without_uuid (struct
        module Binable = struct
          type t = string [@@deriving bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "binable0.ml.before-ppx:117:8")
                  [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t
            let bin_size_t : t Bin_prot.Size.sizer = bin_size_string
            let _ = bin_size_t
            let bin_write_t : t Bin_prot.Write.writer = bin_write_string
            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t
            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_string__
            let _ = __bin_read_t__
            let bin_read_t : t Bin_prot.Read.reader = bin_read_string
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
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        type t = M.t

        let to_binable = M.to_string

        exception Of_binable of string * exn [@@deriving sexp]

        include struct
          let () =
            Sexplib0.Sexp_conv.Exn_converter.add
              [%extension_constructor Of_binable]
              (function
              | Of_binable (arg0__001_, arg1__002_) ->
                let res0__003_ = sexp_of_string arg0__001_
                and res1__004_ = sexp_of_exn arg1__002_ in
                Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom
                      "binable0.ml.before-ppx.Stable.Of_stringable.V1.Of_binable"
                  ; res0__003_
                  ; res1__004_
                  ]
              | _ -> assert false)
          ;;
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let of_binable s =
          try M.of_string s with
          | x -> raise (Of_binable (s, x))
        ;;
      end)
    [@@alert "-legacy"]

    module V2 (M : Conv_stringable) = Bin_prot.Utils.Make_binable_with_uuid (struct
        module Binable = struct
          type t = string [@@deriving bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "binable0.ml.before-ppx:136:8")
                  [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_string ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t
            let bin_size_t : t Bin_prot.Size.sizer = bin_size_string
            let _ = bin_size_t
            let bin_write_t : t Bin_prot.Write.writer = bin_write_string
            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t
            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_string__
            let _ = __bin_read_t__
            let bin_read_t : t Bin_prot.Read.reader = bin_read_string
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
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        type t = M.t

        let to_binable = M.to_string

        exception Of_binable of string * exn [@@deriving sexp]

        include struct
          let () =
            Sexplib0.Sexp_conv.Exn_converter.add
              [%extension_constructor Of_binable]
              (function
              | Of_binable (arg0__005_, arg1__006_) ->
                let res0__007_ = sexp_of_string arg0__005_
                and res1__008_ = sexp_of_exn arg1__006_ in
                Sexplib0.Sexp.List
                  [ Sexplib0.Sexp.Atom
                      "binable0.ml.before-ppx.Stable.Of_stringable.V2.Of_binable"
                  ; res0__007_
                  ; res1__008_
                  ]
              | _ -> assert false)
          ;;
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let of_binable s =
          try M.of_string s with
          | x -> raise (Of_binable (s, x))
        ;;

        let caller_identity = M.caller_identity
      end)
  end
end

open Bigarray

type bigstring = (char, int8_unsigned_elt, c_layout) Array1.t
type 'a m = (module S with type t = 'a)

let of_bigstring (type a) m bigstring =
  let module M = (val (m : (module S with type t = a))) in
  let pos_ref = ref 0 in
  let t = M.bin_read_t bigstring ~pos_ref in
  let bigstring_length = Array1.dim bigstring in
  (match !pos_ref = bigstring_length with
   | true -> ()
   | false ->
     raise_s
       (let ppx_sexp_message () =
          Ppx_sexp_conv_lib.Sexp.List
            [ Ppx_sexp_conv_lib.Conv.sexp_of_string
                "bin_read_t did not consume the entire buffer"
            ; Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Sexp.Atom "consumed"
                ; (sexp_of_int [@merlin.hide]) !pos_ref
                ]
            ; Ppx_sexp_conv_lib.Sexp.List
                [ Ppx_sexp_conv_lib.Sexp.Atom "bigstring_length"
                ; (sexp_of_int [@merlin.hide]) bigstring_length
                ]
            ]
            [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
        in
        (ppx_sexp_message () [@nontail])));
  t
;;

let create_bigstring size = Array1.create Bigarray.char Bigarray.c_layout size

let to_bigstring ?(prefix_with_length = false) (type a) m t =
  let module M = (val (m : (module S with type t = a))) in
  let t_length = M.bin_size_t t in
  let bigstring_length = if prefix_with_length then t_length + 8 else t_length in
  let bigstring = create_bigstring bigstring_length in
  let pos =
    if prefix_with_length
    then Bin_prot.Write.bin_write_int_64bit bigstring ~pos:0 t_length
    else 0
  in
  let pos = M.bin_write_t bigstring ~pos t in
  assert (pos = bigstring_length);
  bigstring
;;

module Of_binable_with_uuid = Stable.Of_binable.V2
module Of_binable1_with_uuid = Stable.Of_binable1.V2
module Of_binable2_with_uuid = Stable.Of_binable2.V2
module Of_binable3_with_uuid = Stable.Of_binable3.V2
module Of_sexpable_with_uuid = Stable.Of_sexpable.V2
module Of_stringable_with_uuid = Stable.Of_stringable.V2
module Of_binable_without_uuid = Stable.Of_binable.V1
module Of_binable1_without_uuid = Stable.Of_binable1.V1
module Of_binable2_without_uuid = Stable.Of_binable2.V1
module Of_binable3_without_uuid = Stable.Of_binable3.V1
module Of_sexpable_without_uuid = Stable.Of_sexpable.V1
module Of_stringable_without_uuid = Stable.Of_stringable.V1

let () =
  Ppx_inline_test_lib.test_module
    ~config:(module Inline_test_config)
    ~descr:(lazy "")
    ~tags:[]
    ~filename:"binable0.ml.before-ppx"
    ~line_number:210
    ~start_pos:0
    ~end_pos:425
    (fun () ->
       let module M = struct
         module type S_only_functions_and_shape = sig
           include S_only_functions

           val bin_shape_t : Shape.t
         end

         module _ (X : S_only_functions_and_shape) : S = struct
           type t = X.t [@@deriving bin_io]

           include struct
             let _ = fun (_ : t) -> ()

             let bin_shape_t =
               let _group =
                 Bin_prot.Shape.group
                   (Bin_prot.Shape.Location.of_string "binable0.ml.before-ppx:221:6")
                   [ Bin_prot.Shape.Tid.of_string "t", [], X.bin_shape_t ]
               in
               (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
             ;;

             let _ = bin_shape_t
             let bin_size_t : t Bin_prot.Size.sizer = X.bin_size_t
             let _ = bin_size_t
             let bin_write_t : t Bin_prot.Write.writer = X.bin_write_t
             let _ = bin_write_t

             let bin_writer_t =
               ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
             ;;

             let _ = bin_writer_t
             let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = X.__bin_read_t__
             let _ = __bin_read_t__
             let bin_read_t : t Bin_prot.Read.reader = X.bin_read_t
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
           end [@@ocaml.doc "@inline"] [@@merlin.hide]
         end
       end
       in
       ())
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
