open! Base

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

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_color : color -> Sexplib0.Sexp.t
  val color_of_sexp : Sexplib0.Sexp.t -> color
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_threshold = Atom_threshold of int
[@@ocaml.doc " Datatypes of various thresholds "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_atom_threshold : atom_threshold -> Sexplib0.Sexp.t
  val atom_threshold_of_sexp : Sexplib0.Sexp.t -> atom_threshold
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type char_threshold = Character_threshold of int [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_char_threshold : char_threshold -> Sexplib0.Sexp.t
  val char_threshold_of_sexp : Sexplib0.Sexp.t -> char_threshold
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type depth_threshold = Depth_threshold of int
[@@ocaml.doc
  " Depth is the depth of an atom. For example, in (a (b (c) d)), the depth of a is 1, the\n\
  \    depth of b and d is 2, and depth of c is 3.\n\
  \    Depth_threshold usually refers to the maximum depth of any atom in a list for it \
   to be\n\
  \    considered for certain heuristic, e.g. data alignment.\n"]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_depth_threshold : depth_threshold -> Sexplib0.Sexp.t
  val depth_threshold_of_sexp : Sexplib0.Sexp.t -> depth_threshold
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type aligned_parens = Parens_alignment of bool
[@@ocaml.doc " Whether or not should closing parentheses be aligned. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_aligned_parens : aligned_parens -> Sexplib0.Sexp.t
  val aligned_parens_of_sexp : Sexplib0.Sexp.t -> aligned_parens
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type data_alignment =
  | Data_not_aligned
  | Data_aligned of aligned_parens * atom_threshold * char_threshold * depth_threshold
  [@ocaml.doc
    " Character threshold is excluding spaces and parentheses, the maximum depth can't \
     exceed\n\
    \      the depth threshold.\n\
    \  "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_data_alignment : data_alignment -> Sexplib0.Sexp.t
  val data_alignment_of_sexp : Sexplib0.Sexp.t -> data_alignment
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_coloring =
  | Color_first of int
  [@ocaml.doc
    " Color the first one, only if the number of atoms that follow it at most the value of\n\
    \      the constructor's argument.\n\
    \  "]
  | Color_all
  | Color_none
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_atom_coloring : atom_coloring -> Sexplib0.Sexp.t
  val atom_coloring_of_sexp : Sexplib0.Sexp.t -> atom_coloring
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type comment_indent =
  | Auto_indent_comment
  | Indent_comment of int
[@@ocaml.doc
  " This currently relates only to block comments. [Auto_indent] tries to infer the\n\
  \    indentation from the original formatting, [Indent_comment n] indents new lines in a\n\
  \    block comment by n spaces.\n"]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_comment_indent : comment_indent -> Sexplib0.Sexp.t
  val comment_indent_of_sexp : Sexplib0.Sexp.t -> comment_indent
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type comment_print_style =
  | Pretty_print [@ocaml.doc " Auto aligns multi-line block comments. "]
  | Conservative_print
  [@ocaml.doc " Leaves block comments as they are, only adjusts indentation. "]
[@@deriving enumerate, sexp]

include sig
  [@@@ocaml.warning "-32"]

  val all_of_comment_print_style : comment_print_style list
  val sexp_of_comment_print_style : comment_print_style -> Sexplib0.Sexp.t
  val comment_print_style_of_sexp : Sexplib0.Sexp.t -> comment_print_style
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type comments =
  | Drop
  | Print of comment_indent * color option * comment_print_style
[@@ocaml.doc " Comment treatment. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_comments : comments -> Sexplib0.Sexp.t
  val comments_of_sexp : Sexplib0.Sexp.t -> comments
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type atom_printing =
  | Escaped
  [@ocaml.doc " Can be parsed again. Atoms are printed out as loaded, with escaping. "]
  | Minimal_escaping
  [@ocaml.doc " As [Escaped], but applies escaping to fewer characters. "]
  | Interpreted [@ocaml.doc " Try to interpret atoms as sexps. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_atom_printing : atom_printing -> Sexplib0.Sexp.t
  val atom_printing_of_sexp : Sexplib0.Sexp.t -> atom_printing
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type singleton_limit = Singleton_limit of atom_threshold * char_threshold
[@@ocaml.doc
  " Singleton_lists are lists of the following format\n\n\
  \    (ATOM_1 .. ATOM_N (....))\n\n\
  \    and are printed in the following way if they are too big to fit on a line/force a\n\
  \    breakline for other reasons:\n\n\
  \    (ATOM_1 .. ATOM_N (\n\
  \    ....\n\
  \    ))\n\n\
  \    Thresholds correspond to what's an acceptable number/size of the leading atoms \
   ATOM_1\n\
  \    through ATOM_N.\n\n\
  \    Character threshold is excluding spaces.\n\n"]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_singleton_limit : singleton_limit -> Sexplib0.Sexp.t
  val singleton_limit_of_sexp : Sexplib0.Sexp.t -> singleton_limit
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type paren_coloring = bool
[@@ocaml.doc " Should parentheses be colored? "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_paren_coloring : paren_coloring -> Sexplib0.Sexp.t
  val paren_coloring_of_sexp : Sexplib0.Sexp.t -> paren_coloring
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type separator =
  | No_separator
  | Empty_line
[@@ocaml.doc " Separator between individual sexps. "] [@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_separator : separator -> Sexplib0.Sexp.t
  val separator_of_sexp : Sexplib0.Sexp.t -> separator
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type parens =
  | Same_line
  | New_line
[@@ocaml.doc
  " Should closing parentheses be on the same line as the last sexp in the list (modulo\n\
  \    comments), or should they be on new lines?\n\
  \    Should opening parentheses always be on the same line as what follows them, or \
   should\n\
  \    they sometimes (when the first item in the list is a list followed by some other \
   sexp)\n\
  \    be on a separate line?\n"]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_parens : parens -> Sexplib0.Sexp.t
  val parens_of_sexp : Sexplib0.Sexp.t -> parens
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type sticky_comments =
  | Before
  | Same_line
  | After
[@@ocaml.doc " Where to put line comments relative to an associated sexp. "]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_sticky_comments : sticky_comments -> Sexplib0.Sexp.t
  val sticky_comments_of_sexp : Sexplib0.Sexp.t -> sticky_comments
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type t =
  { indent : int
  ; data_alignment : data_alignment
  ; color_scheme : color array
  ; atom_coloring : atom_coloring
  ; atom_printing : atom_printing
  ; paren_coloring : paren_coloring
  ; opening_parens : parens
  ; closing_parens : parens
  ; comments : comments
  ; singleton_limit : singleton_limit
  ; leading_threshold : atom_threshold * char_threshold
  ; separator : separator
  ; sticky_comments : sticky_comments
  }
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val default : t

val create
  :  ?color:bool
  -> ?interpret_atom_as_sexp:bool
  -> ?drop_comments:bool
  -> ?new_line_separator:bool
  -> ?custom_data_alignment:data_alignment
  -> unit
  -> t

val update
  :  ?color:bool
  -> ?interpret_atom_as_sexp:bool
  -> ?drop_comments:bool
  -> ?new_line_separator:bool
  -> ?custom_data_alignment:data_alignment
  -> t
  -> t
