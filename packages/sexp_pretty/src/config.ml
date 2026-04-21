open! Base

let of_sexp_error = Sexplib.Conv.of_sexp_error

type color =
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White
  | BrightBlack
  | BrightRed
  | BrightGreen
  | BrightYellow
  | BrightBlue
  | BrightMagenta
  | BrightCyan
  | BrightWhite
  | Default
[@@deriving sexp]

include struct
  let _ = fun (_ : color) -> ()

  let color_of_sexp =
    (let error_source__003_ = "config.ml.before-ppx.color" in
     function
     | Sexplib0.Sexp.Atom ("black" | "Black") -> Black
     | Sexplib0.Sexp.Atom ("red" | "Red") -> Red
     | Sexplib0.Sexp.Atom ("green" | "Green") -> Green
     | Sexplib0.Sexp.Atom ("yellow" | "Yellow") -> Yellow
     | Sexplib0.Sexp.Atom ("blue" | "Blue") -> Blue
     | Sexplib0.Sexp.Atom ("magenta" | "Magenta") -> Magenta
     | Sexplib0.Sexp.Atom ("cyan" | "Cyan") -> Cyan
     | Sexplib0.Sexp.Atom ("white" | "White") -> White
     | Sexplib0.Sexp.Atom ("brightBlack" | "BrightBlack") -> BrightBlack
     | Sexplib0.Sexp.Atom ("brightRed" | "BrightRed") -> BrightRed
     | Sexplib0.Sexp.Atom ("brightGreen" | "BrightGreen") -> BrightGreen
     | Sexplib0.Sexp.Atom ("brightYellow" | "BrightYellow") -> BrightYellow
     | Sexplib0.Sexp.Atom ("brightBlue" | "BrightBlue") -> BrightBlue
     | Sexplib0.Sexp.Atom ("brightMagenta" | "BrightMagenta") -> BrightMagenta
     | Sexplib0.Sexp.Atom ("brightCyan" | "BrightCyan") -> BrightCyan
     | Sexplib0.Sexp.Atom ("brightWhite" | "BrightWhite") -> BrightWhite
     | Sexplib0.Sexp.Atom ("default" | "Default") -> Default
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("black" | "Black") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("red" | "Red") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("green" | "Green") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("yellow" | "Yellow") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("blue" | "Blue") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("magenta" | "Magenta") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("cyan" | "Cyan") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("white" | "White") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightBlack" | "BrightBlack") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightRed" | "BrightRed") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightGreen" | "BrightGreen") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightYellow" | "BrightYellow") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightBlue" | "BrightBlue") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightMagenta" | "BrightMagenta") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightCyan" | "BrightCyan") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("brightWhite" | "BrightWhite") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("default" | "Default") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
     | Sexplib0.Sexp.List [] as sexp__002_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
     | sexp__002_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
     : Sexplib0.Sexp.t -> color)
  ;;

  let _ = color_of_sexp

  let sexp_of_color =
    (function
     | Black -> Sexplib0.Sexp.Atom "Black"
     | Red -> Sexplib0.Sexp.Atom "Red"
     | Green -> Sexplib0.Sexp.Atom "Green"
     | Yellow -> Sexplib0.Sexp.Atom "Yellow"
     | Blue -> Sexplib0.Sexp.Atom "Blue"
     | Magenta -> Sexplib0.Sexp.Atom "Magenta"
     | Cyan -> Sexplib0.Sexp.Atom "Cyan"
     | White -> Sexplib0.Sexp.Atom "White"
     | BrightBlack -> Sexplib0.Sexp.Atom "BrightBlack"
     | BrightRed -> Sexplib0.Sexp.Atom "BrightRed"
     | BrightGreen -> Sexplib0.Sexp.Atom "BrightGreen"
     | BrightYellow -> Sexplib0.Sexp.Atom "BrightYellow"
     | BrightBlue -> Sexplib0.Sexp.Atom "BrightBlue"
     | BrightMagenta -> Sexplib0.Sexp.Atom "BrightMagenta"
     | BrightCyan -> Sexplib0.Sexp.Atom "BrightCyan"
     | BrightWhite -> Sexplib0.Sexp.Atom "BrightWhite"
     | Default -> Sexplib0.Sexp.Atom "Default"
     : color -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_color
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_threshold = Atom_threshold of int [@@deriving sexp]

include struct
  let _ = fun (_ : atom_threshold) -> ()

  let atom_threshold_of_sexp =
    (let error_source__007_ = "config.ml.before-ppx.atom_threshold" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("atom_threshold" | "Atom_threshold") as _tag__010_)
         :: sexp_args__011_) as _sexp__009_ ->
       (match sexp_args__011_ with
        | arg0__012_ :: [] ->
          let res0__013_ = int_of_sexp arg0__012_ in
          Atom_threshold res0__013_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__007_
            _tag__010_
            _sexp__009_)
     | Sexplib0.Sexp.Atom ("atom_threshold" | "Atom_threshold") as sexp__008_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__007_ sexp__008_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__007_ sexp__006_
     | Sexplib0.Sexp.List [] as sexp__006_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__007_ sexp__006_
     | sexp__006_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__007_ sexp__006_
     : Sexplib0.Sexp.t -> atom_threshold)
  ;;

  let _ = atom_threshold_of_sexp

  let sexp_of_atom_threshold =
    (fun (Atom_threshold arg0__014_) ->
       let res0__015_ = sexp_of_int arg0__014_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Atom_threshold"; res0__015_ ]
     : atom_threshold -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_atom_threshold
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let atom_threshold_of_sexp sexp =
  match atom_threshold_of_sexp sexp with
  | Atom_threshold n when n < 0 ->
    of_sexp_error "Atom threshold must be non_negative." sexp
  | threshold -> threshold
;;

type char_threshold = Character_threshold of int [@@deriving sexp]

include struct
  let _ = fun (_ : char_threshold) -> ()

  let char_threshold_of_sexp =
    (let error_source__018_ = "config.ml.before-ppx.char_threshold" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom
            (("character_threshold" | "Character_threshold") as _tag__021_)
         :: sexp_args__022_) as _sexp__020_ ->
       (match sexp_args__022_ with
        | arg0__023_ :: [] ->
          let res0__024_ = int_of_sexp arg0__023_ in
          Character_threshold res0__024_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__018_
            _tag__021_
            _sexp__020_)
     | Sexplib0.Sexp.Atom ("character_threshold" | "Character_threshold") as sexp__019_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__018_ sexp__019_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__017_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__018_ sexp__017_
     | Sexplib0.Sexp.List [] as sexp__017_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__018_ sexp__017_
     | sexp__017_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__018_ sexp__017_
     : Sexplib0.Sexp.t -> char_threshold)
  ;;

  let _ = char_threshold_of_sexp

  let sexp_of_char_threshold =
    (fun (Character_threshold arg0__025_) ->
       let res0__026_ = sexp_of_int arg0__025_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Character_threshold"; res0__026_ ]
     : char_threshold -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_char_threshold
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let char_threshold_of_sexp sexp =
  match char_threshold_of_sexp sexp with
  | Character_threshold n when n < 0 ->
    of_sexp_error "Character threshold must be non_negative." sexp
  | threshold -> threshold
;;

type depth_threshold = Depth_threshold of int [@@deriving sexp]

include struct
  let _ = fun (_ : depth_threshold) -> ()

  let depth_threshold_of_sexp =
    (let error_source__029_ = "config.ml.before-ppx.depth_threshold" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("depth_threshold" | "Depth_threshold") as _tag__032_)
         :: sexp_args__033_) as _sexp__031_ ->
       (match sexp_args__033_ with
        | arg0__034_ :: [] ->
          let res0__035_ = int_of_sexp arg0__034_ in
          Depth_threshold res0__035_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__029_
            _tag__032_
            _sexp__031_)
     | Sexplib0.Sexp.Atom ("depth_threshold" | "Depth_threshold") as sexp__030_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__029_ sexp__030_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__028_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__029_ sexp__028_
     | Sexplib0.Sexp.List [] as sexp__028_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__029_ sexp__028_
     | sexp__028_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__029_ sexp__028_
     : Sexplib0.Sexp.t -> depth_threshold)
  ;;

  let _ = depth_threshold_of_sexp

  let sexp_of_depth_threshold =
    (fun (Depth_threshold arg0__036_) ->
       let res0__037_ = sexp_of_int arg0__036_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Depth_threshold"; res0__037_ ]
     : depth_threshold -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_depth_threshold
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let depth_threshold_of_sexp sexp =
  match depth_threshold_of_sexp sexp with
  | Depth_threshold n when n < 1 ->
    of_sexp_error "Depth threshold must be greater than 0." sexp
  | threshold -> threshold
;;

type aligned_parens = Parens_alignment of bool [@@deriving sexp]

include struct
  let _ = fun (_ : aligned_parens) -> ()

  let aligned_parens_of_sexp =
    (let error_source__040_ = "config.ml.before-ppx.aligned_parens" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("parens_alignment" | "Parens_alignment") as _tag__043_)
         :: sexp_args__044_) as _sexp__042_ ->
       (match sexp_args__044_ with
        | arg0__045_ :: [] ->
          let res0__046_ = bool_of_sexp arg0__045_ in
          Parens_alignment res0__046_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__040_
            _tag__043_
            _sexp__042_)
     | Sexplib0.Sexp.Atom ("parens_alignment" | "Parens_alignment") as sexp__041_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__040_ sexp__041_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__039_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__040_ sexp__039_
     | Sexplib0.Sexp.List [] as sexp__039_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__040_ sexp__039_
     | sexp__039_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__040_ sexp__039_
     : Sexplib0.Sexp.t -> aligned_parens)
  ;;

  let _ = aligned_parens_of_sexp

  let sexp_of_aligned_parens =
    (fun (Parens_alignment arg0__047_) ->
       let res0__048_ = sexp_of_bool arg0__047_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Parens_alignment"; res0__048_ ]
     : aligned_parens -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_aligned_parens
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type data_alignment =
  | Data_not_aligned
  | Data_aligned of aligned_parens * atom_threshold * char_threshold * depth_threshold
[@@deriving sexp]

include struct
  let _ = fun (_ : data_alignment) -> ()

  let data_alignment_of_sexp =
    (let error_source__051_ = "config.ml.before-ppx.data_alignment" in
     function
     | Sexplib0.Sexp.Atom ("data_not_aligned" | "Data_not_aligned") -> Data_not_aligned
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("data_aligned" | "Data_aligned") as _tag__054_)
         :: sexp_args__055_) as _sexp__053_ ->
       (match sexp_args__055_ with
        | [ arg0__056_; arg1__057_; arg2__058_; arg3__059_ ] ->
          let res0__060_ = aligned_parens_of_sexp arg0__056_
          and res1__061_ = atom_threshold_of_sexp arg1__057_
          and res2__062_ = char_threshold_of_sexp arg2__058_
          and res3__063_ = depth_threshold_of_sexp arg3__059_ in
          Data_aligned (res0__060_, res1__061_, res2__062_, res3__063_)
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__051_
            _tag__054_
            _sexp__053_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("data_not_aligned" | "Data_not_aligned") :: _) as sexp__052_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__051_ sexp__052_
     | Sexplib0.Sexp.Atom ("data_aligned" | "Data_aligned") as sexp__052_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__051_ sexp__052_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__050_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__051_ sexp__050_
     | Sexplib0.Sexp.List [] as sexp__050_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__051_ sexp__050_
     | sexp__050_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__051_ sexp__050_
     : Sexplib0.Sexp.t -> data_alignment)
  ;;

  let _ = data_alignment_of_sexp

  let sexp_of_data_alignment =
    (function
     | Data_not_aligned -> Sexplib0.Sexp.Atom "Data_not_aligned"
     | Data_aligned (arg0__064_, arg1__065_, arg2__066_, arg3__067_) ->
       let res0__068_ = sexp_of_aligned_parens arg0__064_
       and res1__069_ = sexp_of_atom_threshold arg1__065_
       and res2__070_ = sexp_of_char_threshold arg2__066_
       and res3__071_ = sexp_of_depth_threshold arg3__067_ in
       Sexplib0.Sexp.List
         [ Sexplib0.Sexp.Atom "Data_aligned"
         ; res0__068_
         ; res1__069_
         ; res2__070_
         ; res3__071_
         ]
     : data_alignment -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_data_alignment
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_coloring =
  | Color_first of int
  | Color_all
  | Color_none
[@@deriving sexp]

include struct
  let _ = fun (_ : atom_coloring) -> ()

  let atom_coloring_of_sexp =
    (let error_source__074_ = "config.ml.before-ppx.atom_coloring" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("color_first" | "Color_first") as _tag__077_)
         :: sexp_args__078_) as _sexp__076_ ->
       (match sexp_args__078_ with
        | arg0__079_ :: [] ->
          let res0__080_ = int_of_sexp arg0__079_ in
          Color_first res0__080_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__074_
            _tag__077_
            _sexp__076_)
     | Sexplib0.Sexp.Atom ("color_all" | "Color_all") -> Color_all
     | Sexplib0.Sexp.Atom ("color_none" | "Color_none") -> Color_none
     | Sexplib0.Sexp.Atom ("color_first" | "Color_first") as sexp__075_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__074_ sexp__075_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("color_all" | "Color_all") :: _) as
       sexp__075_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__074_ sexp__075_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("color_none" | "Color_none") :: _) as
       sexp__075_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__074_ sexp__075_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__073_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__074_ sexp__073_
     | Sexplib0.Sexp.List [] as sexp__073_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__074_ sexp__073_
     | sexp__073_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__074_ sexp__073_
     : Sexplib0.Sexp.t -> atom_coloring)
  ;;

  let _ = atom_coloring_of_sexp

  let sexp_of_atom_coloring =
    (function
     | Color_first arg0__081_ ->
       let res0__082_ = sexp_of_int arg0__081_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Color_first"; res0__082_ ]
     | Color_all -> Sexplib0.Sexp.Atom "Color_all"
     | Color_none -> Sexplib0.Sexp.Atom "Color_none"
     : atom_coloring -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_atom_coloring
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let atom_coloring_of_sexp sexp =
  match atom_coloring_of_sexp sexp with
  | Color_first n when n < 0 ->
    of_sexp_error "The limit to color atoms must be non-negative." sexp
  | coloring -> coloring
;;

type comment_indent =
  | Auto_indent_comment
  | Indent_comment of int
[@@deriving sexp]

include struct
  let _ = fun (_ : comment_indent) -> ()

  let comment_indent_of_sexp =
    (let error_source__085_ = "config.ml.before-ppx.comment_indent" in
     function
     | Sexplib0.Sexp.Atom ("auto_indent_comment" | "Auto_indent_comment") ->
       Auto_indent_comment
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("indent_comment" | "Indent_comment") as _tag__088_)
         :: sexp_args__089_) as _sexp__087_ ->
       (match sexp_args__089_ with
        | arg0__090_ :: [] ->
          let res0__091_ = int_of_sexp arg0__090_ in
          Indent_comment res0__091_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__085_
            _tag__088_
            _sexp__087_)
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("auto_indent_comment" | "Auto_indent_comment") :: _) as
       sexp__086_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__085_ sexp__086_
     | Sexplib0.Sexp.Atom ("indent_comment" | "Indent_comment") as sexp__086_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__085_ sexp__086_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__084_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__085_ sexp__084_
     | Sexplib0.Sexp.List [] as sexp__084_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__085_ sexp__084_
     | sexp__084_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__085_ sexp__084_
     : Sexplib0.Sexp.t -> comment_indent)
  ;;

  let _ = comment_indent_of_sexp

  let sexp_of_comment_indent =
    (function
     | Auto_indent_comment -> Sexplib0.Sexp.Atom "Auto_indent_comment"
     | Indent_comment arg0__092_ ->
       let res0__093_ = sexp_of_int arg0__092_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Indent_comment"; res0__093_ ]
     : comment_indent -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_comment_indent
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let comment_indent_of_sexp sexp =
  match comment_indent_of_sexp sexp with
  | Indent_comment n when n < 0 -> of_sexp_error "Indentation must be non-negative." sexp
  | indent -> indent
;;

type comment_print_style =
  | Pretty_print
  | Conservative_print
[@@deriving enumerate, sexp]

include struct
  let _ = fun (_ : comment_print_style) -> ()

  let all_of_comment_print_style =
    ([ Pretty_print; Conservative_print ] : comment_print_style list)
  ;;

  let _ = all_of_comment_print_style

  let comment_print_style_of_sexp =
    (let error_source__096_ = "config.ml.before-ppx.comment_print_style" in
     function
     | Sexplib0.Sexp.Atom ("pretty_print" | "Pretty_print") -> Pretty_print
     | Sexplib0.Sexp.Atom ("conservative_print" | "Conservative_print") ->
       Conservative_print
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("pretty_print" | "Pretty_print") :: _) as
       sexp__097_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__096_ sexp__097_
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("conservative_print" | "Conservative_print") :: _) as
       sexp__097_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__096_ sexp__097_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__095_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__096_ sexp__095_
     | Sexplib0.Sexp.List [] as sexp__095_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__096_ sexp__095_
     | sexp__095_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__096_ sexp__095_
     : Sexplib0.Sexp.t -> comment_print_style)
  ;;

  let _ = comment_print_style_of_sexp

  let sexp_of_comment_print_style =
    (function
     | Pretty_print -> Sexplib0.Sexp.Atom "Pretty_print"
     | Conservative_print -> Sexplib0.Sexp.Atom "Conservative_print"
     : comment_print_style -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_comment_print_style
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type comments =
  | Drop
  | Print of comment_indent * color option * comment_print_style
[@@deriving sexp]

include struct
  let _ = fun (_ : comments) -> ()

  let comments_of_sexp =
    (let error_source__100_ = "config.ml.before-ppx.comments" in
     function
     | Sexplib0.Sexp.Atom ("drop" | "Drop") -> Drop
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("print" | "Print") as _tag__103_) :: sexp_args__104_) as
       _sexp__102_ ->
       (match sexp_args__104_ with
        | [ arg0__105_; arg1__106_; arg2__107_ ] ->
          let res0__108_ = comment_indent_of_sexp arg0__105_
          and res1__109_ = option_of_sexp color_of_sexp arg1__106_
          and res2__110_ = comment_print_style_of_sexp arg2__107_ in
          Print (res0__108_, res1__109_, res2__110_)
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__100_
            _tag__103_
            _sexp__102_)
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("drop" | "Drop") :: _) as sexp__101_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__100_ sexp__101_
     | Sexplib0.Sexp.Atom ("print" | "Print") as sexp__101_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__100_ sexp__101_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__099_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__100_ sexp__099_
     | Sexplib0.Sexp.List [] as sexp__099_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__100_ sexp__099_
     | sexp__099_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__100_ sexp__099_
     : Sexplib0.Sexp.t -> comments)
  ;;

  let _ = comments_of_sexp

  let sexp_of_comments =
    (function
     | Drop -> Sexplib0.Sexp.Atom "Drop"
     | Print (arg0__111_, arg1__112_, arg2__113_) ->
       let res0__114_ = sexp_of_comment_indent arg0__111_
       and res1__115_ = sexp_of_option sexp_of_color arg1__112_
       and res2__116_ = sexp_of_comment_print_style arg2__113_ in
       Sexplib0.Sexp.List
         [ Sexplib0.Sexp.Atom "Print"; res0__114_; res1__115_; res2__116_ ]
     : comments -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_comments
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_printing =
  | Escaped
  | Minimal_escaping
  | Interpreted
[@@deriving sexp]

include struct
  let _ = fun (_ : atom_printing) -> ()

  let atom_printing_of_sexp =
    (let error_source__119_ = "config.ml.before-ppx.atom_printing" in
     function
     | Sexplib0.Sexp.Atom ("escaped" | "Escaped") -> Escaped
     | Sexplib0.Sexp.Atom ("minimal_escaping" | "Minimal_escaping") -> Minimal_escaping
     | Sexplib0.Sexp.Atom ("interpreted" | "Interpreted") -> Interpreted
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("escaped" | "Escaped") :: _) as sexp__120_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__119_ sexp__120_
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("minimal_escaping" | "Minimal_escaping") :: _) as sexp__120_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__119_ sexp__120_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("interpreted" | "Interpreted") :: _) as
       sexp__120_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__119_ sexp__120_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__118_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__119_ sexp__118_
     | Sexplib0.Sexp.List [] as sexp__118_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__119_ sexp__118_
     | sexp__118_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__119_ sexp__118_
     : Sexplib0.Sexp.t -> atom_printing)
  ;;

  let _ = atom_printing_of_sexp

  let sexp_of_atom_printing =
    (function
     | Escaped -> Sexplib0.Sexp.Atom "Escaped"
     | Minimal_escaping -> Sexplib0.Sexp.Atom "Minimal_escaping"
     | Interpreted -> Sexplib0.Sexp.Atom "Interpreted"
     : atom_printing -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_atom_printing
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type singleton_limit = Singleton_limit of atom_threshold * char_threshold
[@@deriving sexp]

include struct
  let _ = fun (_ : singleton_limit) -> ()

  let singleton_limit_of_sexp =
    (let error_source__123_ = "config.ml.before-ppx.singleton_limit" in
     function
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("singleton_limit" | "Singleton_limit") as _tag__126_)
         :: sexp_args__127_) as _sexp__125_ ->
       (match sexp_args__127_ with
        | [ arg0__128_; arg1__129_ ] ->
          let res0__130_ = atom_threshold_of_sexp arg0__128_
          and res1__131_ = char_threshold_of_sexp arg1__129_ in
          Singleton_limit (res0__130_, res1__131_)
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__123_
            _tag__126_
            _sexp__125_)
     | Sexplib0.Sexp.Atom ("singleton_limit" | "Singleton_limit") as sexp__124_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__123_ sexp__124_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__122_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__123_ sexp__122_
     | Sexplib0.Sexp.List [] as sexp__122_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__123_ sexp__122_
     | sexp__122_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__123_ sexp__122_
     : Sexplib0.Sexp.t -> singleton_limit)
  ;;

  let _ = singleton_limit_of_sexp

  let sexp_of_singleton_limit =
    (fun (Singleton_limit (arg0__132_, arg1__133_)) ->
       let res0__134_ = sexp_of_atom_threshold arg0__132_
       and res1__135_ = sexp_of_char_threshold arg1__133_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Singleton_limit"; res0__134_; res1__135_ ]
     : singleton_limit -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_singleton_limit
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type paren_coloring = bool [@@deriving sexp]

include struct
  let _ = fun (_ : paren_coloring) -> ()
  let paren_coloring_of_sexp = (bool_of_sexp : Sexplib0.Sexp.t -> paren_coloring)
  let _ = paren_coloring_of_sexp
  let sexp_of_paren_coloring = (sexp_of_bool : paren_coloring -> Sexplib0.Sexp.t)
  let _ = sexp_of_paren_coloring
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type separator =
  | No_separator
  | Empty_line
[@@deriving sexp]

include struct
  let _ = fun (_ : separator) -> ()

  let separator_of_sexp =
    (let error_source__139_ = "config.ml.before-ppx.separator" in
     function
     | Sexplib0.Sexp.Atom ("no_separator" | "No_separator") -> No_separator
     | Sexplib0.Sexp.Atom ("empty_line" | "Empty_line") -> Empty_line
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("no_separator" | "No_separator") :: _) as
       sexp__140_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__139_ sexp__140_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("empty_line" | "Empty_line") :: _) as
       sexp__140_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__139_ sexp__140_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__138_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__139_ sexp__138_
     | Sexplib0.Sexp.List [] as sexp__138_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__139_ sexp__138_
     | sexp__138_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__139_ sexp__138_
     : Sexplib0.Sexp.t -> separator)
  ;;

  let _ = separator_of_sexp

  let sexp_of_separator =
    (function
     | No_separator -> Sexplib0.Sexp.Atom "No_separator"
     | Empty_line -> Sexplib0.Sexp.Atom "Empty_line"
     : separator -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_separator
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type parens =
  | Same_line
  | New_line
[@@deriving sexp]

include struct
  let _ = fun (_ : parens) -> ()

  let parens_of_sexp =
    (let error_source__143_ = "config.ml.before-ppx.parens" in
     function
     | Sexplib0.Sexp.Atom ("same_line" | "Same_line") -> Same_line
     | Sexplib0.Sexp.Atom ("new_line" | "New_line") -> New_line
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("same_line" | "Same_line") :: _) as
       sexp__144_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__143_ sexp__144_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("new_line" | "New_line") :: _) as
       sexp__144_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__143_ sexp__144_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__142_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__143_ sexp__142_
     | Sexplib0.Sexp.List [] as sexp__142_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__143_ sexp__142_
     | sexp__142_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__143_ sexp__142_
     : Sexplib0.Sexp.t -> parens)
  ;;

  let _ = parens_of_sexp

  let sexp_of_parens =
    (function
     | Same_line -> Sexplib0.Sexp.Atom "Same_line"
     | New_line -> Sexplib0.Sexp.Atom "New_line"
     : parens -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_parens
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type sticky_comments =
  | Before
  | Same_line
  | After
[@@deriving sexp]

include struct
  let _ = fun (_ : sticky_comments) -> ()

  let sticky_comments_of_sexp =
    (let error_source__147_ = "config.ml.before-ppx.sticky_comments" in
     function
     | Sexplib0.Sexp.Atom ("before" | "Before") -> Before
     | Sexplib0.Sexp.Atom ("same_line" | "Same_line") -> Same_line
     | Sexplib0.Sexp.Atom ("after" | "After") -> After
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("before" | "Before") :: _) as sexp__148_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__147_ sexp__148_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("same_line" | "Same_line") :: _) as
       sexp__148_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__147_ sexp__148_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("after" | "After") :: _) as sexp__148_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__147_ sexp__148_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__146_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__147_ sexp__146_
     | Sexplib0.Sexp.List [] as sexp__146_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__147_ sexp__146_
     | sexp__146_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__147_ sexp__146_
     : Sexplib0.Sexp.t -> sticky_comments)
  ;;

  let _ = sticky_comments_of_sexp

  let sexp_of_sticky_comments =
    (function
     | Before -> Sexplib0.Sexp.Atom "Before"
     | Same_line -> Sexplib0.Sexp.Atom "Same_line"
     | After -> Sexplib0.Sexp.Atom "After"
     : sticky_comments -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_sticky_comments
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type t =
  { indent : int [@default 2]
  ; data_alignment : data_alignment
        [@default
          Data_aligned
            ( Parens_alignment false
            , Atom_threshold 6
            , Character_threshold 60
            , Depth_threshold 3 )]
  ; color_scheme : color array
  ; atom_coloring : atom_coloring [@default Color_first 3]
  ; atom_printing : atom_printing [@default Escaped]
  ; paren_coloring : paren_coloring [@default true]
  ; opening_parens : parens [@default Same_line]
  ; closing_parens : parens [@default Same_line]
  ; comments : comments [@default Print (Indent_comment 3, Some Green, Pretty_print)]
  ; singleton_limit : singleton_limit
        [@default Singleton_limit (Atom_threshold 3, Character_threshold 15)]
  ; leading_threshold : atom_threshold * char_threshold
        [@default Atom_threshold 3, Character_threshold 20]
  ; separator : separator [@default Empty_line]
  ; sticky_comments : sticky_comments [@default After]
  }
[@@deriving sexp]

include struct
  let _ = fun (_ : t) -> ()

  let t_of_sexp =
    (let default__151_ : sticky_comments = After
     and default__152_ : separator = Empty_line
     and default__153_ : atom_threshold * char_threshold =
       Atom_threshold 3, Character_threshold 20
     and default__159_ : singleton_limit =
       Singleton_limit (Atom_threshold 3, Character_threshold 15)
     and default__160_ : comments = Print (Indent_comment 3, Some Green, Pretty_print)
     and default__161_ : parens = Same_line
     and default__162_ : parens = Same_line
     and default__163_ : paren_coloring = true
     and default__164_ : atom_printing = Escaped
     and default__165_ : atom_coloring = Color_first 3
     and default__166_ : data_alignment =
       Data_aligned
         ( Parens_alignment false
         , Atom_threshold 6
         , Character_threshold 60
         , Depth_threshold 3 )
     and default__167_ : int = 2 in
     let error_source__150_ = "config.ml.before-ppx.t" in
     fun x__168_ ->
       Sexplib0.Sexp_conv_record.record_of_sexp
         ~caller:error_source__150_
         ~fields:
           (Field
              { name = "indent"
              ; kind = Default (fun () -> default__167_)
              ; conv = int_of_sexp
              ; rest =
                  Field
                    { name = "data_alignment"
                    ; kind = Default (fun () -> default__166_)
                    ; conv = data_alignment_of_sexp
                    ; rest =
                        Field
                          { name = "color_scheme"
                          ; kind = Required
                          ; conv = array_of_sexp color_of_sexp
                          ; rest =
                              Field
                                { name = "atom_coloring"
                                ; kind = Default (fun () -> default__165_)
                                ; conv = atom_coloring_of_sexp
                                ; rest =
                                    Field
                                      { name = "atom_printing"
                                      ; kind = Default (fun () -> default__164_)
                                      ; conv = atom_printing_of_sexp
                                      ; rest =
                                          Field
                                            { name = "paren_coloring"
                                            ; kind = Default (fun () -> default__163_)
                                            ; conv = paren_coloring_of_sexp
                                            ; rest =
                                                Field
                                                  { name = "opening_parens"
                                                  ; kind =
                                                      Default (fun () -> default__162_)
                                                  ; conv = parens_of_sexp
                                                  ; rest =
                                                      Field
                                                        { name = "closing_parens"
                                                        ; kind =
                                                            Default
                                                              (fun () -> default__161_)
                                                        ; conv = parens_of_sexp
                                                        ; rest =
                                                            Field
                                                              { name = "comments"
                                                              ; kind =
                                                                  Default
                                                                    (fun () ->
                                                                      default__160_)
                                                              ; conv = comments_of_sexp
                                                              ; rest =
                                                                  Field
                                                                    { name =
                                                                        "singleton_limit"
                                                                    ; kind =
                                                                        Default
                                                                          (fun () ->
                                                                            default__159_)
                                                                    ; conv =
                                                                        singleton_limit_of_sexp
                                                                    ; rest =
                                                                        Field
                                                                          { name =
                                                                              "leading_threshold"
                                                                          ; kind =
                                                                              Default
                                                                                (fun () ->
                                                                                  default__153_)
                                                                          ; conv =
                                                                              (function
                                                                                | Sexplib0
                                                                                  .Sexp
                                                                                  .List
                                                                                    [ arg0__154_
                                                                                    ; arg1__155_
                                                                                    ] ->
                                                                                  let res0__156_
                                                                                    =
                                                                                    atom_threshold_of_sexp
                                                                                      arg0__154_
                                                                                  and res1__157_
                                                                                    =
                                                                                    char_threshold_of_sexp
                                                                                      arg1__155_
                                                                                  in
                                                                                  ( res0__156_
                                                                                  , res1__157_
                                                                                  )
                                                                                | sexp__158_
                                                                                  ->
                                                                                  Sexplib0
                                                                                  .Sexp_conv_error
                                                                                  .tuple_of_size_n_expected
                                                                                    error_source__150_
                                                                                    2
                                                                                    sexp__158_)
                                                                          ; rest =
                                                                              Field
                                                                                { name =
                                                                                    "separator"
                                                                                ; kind =
                                                                                    Default
                                                                                      (fun 
                                                                                        () ->
                                                                                        default__152_)
                                                                                ; conv =
                                                                                    separator_of_sexp
                                                                                ; rest =
                                                                                    Field
                                                                                      { name =
                                                                                          "sticky_comments"
                                                                                      ; kind =
                                                                                          Default
                                                                                          (fun 
                                                                                          () ->
                                                                                          default__151_)
                                                                                      ; conv =
                                                                                          sticky_comments_of_sexp
                                                                                      ; rest =
                                                                                          Empty
                                                                                      }
                                                                                }
                                                                          }
                                                                    }
                                                              }
                                                        }
                                                  }
                                            }
                                      }
                                }
                          }
                    }
              })
         ~index_of_field:(function
           | "indent" -> 0
           | "data_alignment" -> 1
           | "color_scheme" -> 2
           | "atom_coloring" -> 3
           | "atom_printing" -> 4
           | "paren_coloring" -> 5
           | "opening_parens" -> 6
           | "closing_parens" -> 7
           | "comments" -> 8
           | "singleton_limit" -> 9
           | "leading_threshold" -> 10
           | "separator" -> 11
           | "sticky_comments" -> 12
           | _ -> -1)
         ~allow_extra_fields:false
         ~create:
           (fun
             ( indent
             , ( data_alignment
               , ( color_scheme
                 , ( atom_coloring
                   , ( atom_printing
                     , ( paren_coloring
                       , ( opening_parens
                         , ( closing_parens
                           , ( comments
                             , ( singleton_limit
                               , (leading_threshold, (separator, (sticky_comments, ())))
                               ) ) ) ) ) ) ) ) ) ) ->
           ({ indent
            ; data_alignment
            ; color_scheme
            ; atom_coloring
            ; atom_printing
            ; paren_coloring
            ; opening_parens
            ; closing_parens
            ; comments
            ; singleton_limit
            ; leading_threshold
            ; separator
            ; sticky_comments
            }
            : t))
         x__168_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (fun { indent = indent__170_
         ; data_alignment = data_alignment__172_
         ; color_scheme = color_scheme__174_
         ; atom_coloring = atom_coloring__176_
         ; atom_printing = atom_printing__178_
         ; paren_coloring = paren_coloring__180_
         ; opening_parens = opening_parens__182_
         ; closing_parens = closing_parens__184_
         ; comments = comments__186_
         ; singleton_limit = singleton_limit__188_
         ; leading_threshold = leading_threshold__190_
         ; separator = separator__196_
         ; sticky_comments = sticky_comments__198_
         } ->
       let bnds__169_ = ([] : _ Stdlib.List.t) in
       let bnds__169_ =
         let arg__199_ = sexp_of_sticky_comments sticky_comments__198_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "sticky_comments"; arg__199_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__197_ = sexp_of_separator separator__196_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "separator"; arg__197_ ] :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__191_ =
           let arg0__192_, arg1__193_ = leading_threshold__190_ in
           let res0__194_ = sexp_of_atom_threshold arg0__192_
           and res1__195_ = sexp_of_char_threshold arg1__193_ in
           Sexplib0.Sexp.List [ res0__194_; res1__195_ ]
         in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "leading_threshold"; arg__191_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__189_ = sexp_of_singleton_limit singleton_limit__188_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "singleton_limit"; arg__189_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__187_ = sexp_of_comments comments__186_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "comments"; arg__187_ ] :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__185_ = sexp_of_parens closing_parens__184_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "closing_parens"; arg__185_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__183_ = sexp_of_parens opening_parens__182_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "opening_parens"; arg__183_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__181_ = sexp_of_paren_coloring paren_coloring__180_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "paren_coloring"; arg__181_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__179_ = sexp_of_atom_printing atom_printing__178_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "atom_printing"; arg__179_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__177_ = sexp_of_atom_coloring atom_coloring__176_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "atom_coloring"; arg__177_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__175_ = sexp_of_array sexp_of_color color_scheme__174_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "color_scheme"; arg__175_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__173_ = sexp_of_data_alignment data_alignment__172_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "data_alignment"; arg__173_ ]
          :: bnds__169_
          : _ Stdlib.List.t)
       in
       let bnds__169_ =
         let arg__171_ = sexp_of_int indent__170_ in
         (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "indent"; arg__171_ ] :: bnds__169_
          : _ Stdlib.List.t)
       in
       Sexplib0.Sexp.List bnds__169_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let t_of_sexp sexp =
  let t = t_of_sexp sexp in
  if t.indent < 0 then of_sexp_error "Indentation must be non-negative." sexp else t
;;

let default_color_scheme = [| Magenta; Yellow; Cyan; White |]

let default =
  { indent = 2
  ; data_alignment =
      Data_aligned
        ( Parens_alignment false
        , Atom_threshold 6
        , Character_threshold 50
        , Depth_threshold 3 )
  ; color_scheme = default_color_scheme
  ; atom_coloring = Color_first 3
  ; atom_printing = Escaped
  ; paren_coloring = true
  ; closing_parens = Same_line
  ; opening_parens = Same_line
  ; comments = Print (Indent_comment 3, Some Green, Pretty_print)
  ; singleton_limit = Singleton_limit (Atom_threshold 3, Character_threshold 40)
  ; leading_threshold = Atom_threshold 3, Character_threshold 40
  ; separator = Empty_line
  ; sticky_comments = After
  }
;;

let update
      ?color
      ?interpret_atom_as_sexp
      ?drop_comments
      ?new_line_separator
      ?custom_data_alignment
      conf
  =
  let conf =
    match color with
    | None -> conf
    | Some color ->
      if color
      then conf
      else (
        match conf.comments with
        | Print (indent, Some _, style) ->
          { conf with
            atom_coloring = Color_none
          ; paren_coloring = false
          ; comments = Print (indent, None, style)
          }
        | _ -> { conf with atom_coloring = Color_none; paren_coloring = false })
  in
  let conf =
    match interpret_atom_as_sexp with
    | None -> conf
    | Some interpret_atom_as_sexp ->
      if interpret_atom_as_sexp then { conf with atom_printing = Interpreted } else conf
  in
  let conf =
    match drop_comments with
    | None -> conf
    | Some drop_comments -> if drop_comments then { conf with comments = Drop } else conf
  in
  let conf =
    match new_line_separator with
    | None -> conf
    | Some true -> { conf with separator = Empty_line }
    | Some false -> { conf with separator = No_separator }
  in
  let conf =
    match custom_data_alignment with
    | None -> conf
    | Some data_alignment -> { conf with data_alignment }
  in
  conf
;;

let create
      ?(color = false)
      ?(interpret_atom_as_sexp = false)
      ?(drop_comments = false)
      ?(new_line_separator = false)
      ?custom_data_alignment
      ()
  =
  update
    ~color
    ~interpret_atom_as_sexp
    ~drop_comments
    ~new_line_separator
    ?custom_data_alignment
    default
;;
