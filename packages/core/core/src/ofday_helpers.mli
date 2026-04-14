[@@@ocaml.text
  " This module is only used in the implementation of ofday.ml, and isn't exposed as\n\
  \    a submodule of [Core]. "]

open! Import

val parse
  :  string
  -> f:(string -> hr:int -> min:int -> sec:int -> subsec_pos:int -> subsec_len:int -> 'a)
  -> 'a
[@@ocaml.doc
  " Parses a given time-of-day string. If the string is invalid, raises. If the string is\n\
  \    valid, calls [f] with the string, the parsed numbers of hours, minutes, and \
   seconds,\n\
  \    and the position and length of the substring representing subseconds, which can be\n\
  \    parsed with the appropriate precision for a given representation.\n\n\
  \    The substring [String.sub string ~pos:subsec_pos ~len:subsec_len] will be either \
   the\n\
  \    empty string (representing zero) or a decimal point ('.') and one or more digits\n\
  \    and/or underscores (representing a fractional number of seconds in decimal \
   notation).\n\n\
  \    Illegal hours, minutes, or seconds values are rejected by [parse], as are times \
   with\n\
  \    the hour of 24 and non-zero minutes or seconds. The time \"24:00:00\" itself is\n\
  \    accepted. If seconds is 60 (a leap second), the client will be passed \
   [~subsec_len:0]\n\
  \    regardless of the subsecond part. "]

val parse_iso8601_extended
  :  ?pos:int
  -> ?len:int
  -> string
  -> f:(string -> hr:int -> min:int -> sec:int -> subsec_pos:int -> subsec_len:int -> 'a)
  -> 'a
[@@ocaml.doc
  " As [parse], for strings in ISO 8601 extended format. Allows substring parsing via\n\
  \    [~pos] and [~len] arguments. "]

val invalid_string : string -> reason:string -> _
[@@ocaml.doc
  " Raises ofday-parsing errors for the given string, annotated with the given reason.\n\
  \    Useful inside the [~f] argument to [parse] in order to generate error messages that\n\
  \    are consistent with what [parse] raises. "]

val am_suffixes : string list Lazy.t
[@@ocaml.doc " Allowed AM/PM suffixes; useful for testing. "]

val pm_suffixes : string list Lazy.t
