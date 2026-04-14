open! Base

val am_recording : bool
[@@ocaml.doc
  " If true, ppx_module_timer records module startup times and reports them on stdout at\n\
  \    process exit. Controlled by [am_recording_environment_variable]. "]

val am_recording_environment_variable : string
[@@ocaml.doc
  " If this environment variable is set (to anything) when this module starts up,\n\
  \    [am_recording] is set to true.\n\n\
  \    Equal to \"PPX_MODULE_TIMER\".\n\n\
  \    If this is set to a valid duration string (see [Duration.format] below), that \
   duration\n\
  \    is used to override recorded times for each module. This is used to make test \
   output\n\
  \    deterministic.\n\n\
  \    If this is set to \"FAKE_MODULES\", the entire set of recorded data is overridden \
   with\n\
  \    fake values. This is used to make test output both deterministic and stable, so \
   that\n\
  \    changes in external library dependencies do not affect it. The fake data is not\n\
  \    particularly sensible, for example we are not careful to make the times for\n\
  \    definitions add up to the time for the enclosing module. "]

module Duration : sig
  type t

  val to_nanoseconds : t -> Int63.t
  val of_nanoseconds : Int63.t -> t

  module type Format = sig
    val of_string : string -> t
    val to_string_with_same_unit : t list -> string list
  end

  val format : (module Format) ref
  [@@ocaml.doc
    " Determines the format of durations when reading [am_recording_environment_variable]\n\
    \      and when printing results. Defaults to integer nanoseconds with a \"ns\" \
     suffix.\n\n\
    \      [Core.Time_ns] overrides this to use [Time_ns.Span.to_string] on input and\n\
    \      [Time_ns.Span.to_string_hum] on output. "]
end

[@@@ocaml.text "/*"]

[@@@ocaml.text
  " {2 For Rewritten Code}\n\n    These definitions are not meant to be called manually. "]

val record_start : string -> unit
[@@ocaml.doc
  " If [am_recording], records when the specified module begins its startup effects.\n\
  \    Raises if a previous module started and has not finished. "]

val record_until : string -> unit
[@@ocaml.doc
  " If [am_recording], records when the specified module finishes its startup effects.\n\
  \    Raises if there is no corresponding start time. "]

val record_definition_start : string -> unit
[@@ocaml.doc
  " If [am_recording], records when the specified definition begins its startup effects.\n\
  \    Raises if a previous definition started and has not finished, or if it is not \
   called\n\
  \    during startup of an enclosing module. "]

val record_definition_until : string -> unit
[@@ocaml.doc
  " If [am_recording], records when the specified definition finishes its startup effects.\n\
  \    Raises if there is no corresponding start time, or if it is not called during \
   startup\n\
  \    of an enclosing module. "]

external __MODULE__ : string = "%loc_MODULE"
[@@ocaml.doc " Duplicate of [Pervasives.__MODULE__]. "]
