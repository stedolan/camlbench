[@@@ocaml.text
  " A module for representing absolute points in time, independent of time zone.\n\n\
  \    Note that on 32bit architecture, most functions will raise when used on time\n\
  \    outside the range [1901-12-13 20:45:52 - 2038-01-19 03:14:07].\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_functor_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_functor_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  module Time0 : Time_float.S_kernel_without_zone
  module Time : Time_float.S_kernel with module Time := Time0

  module Span : sig
    include module type of Time.Span

    val arg_type : t Core.Command.Arg_type.t
  end

  module Zone : sig
    include module type of struct
      include Time.Zone
    end [@ocaml.remove_aliases]

    include Timezone.Extend_zone with type t := t

    val arg_type : t Core.Command.Arg_type.t
  end

  module Ofday : sig
    include module type of struct
      include Time.Ofday
    end [@ocaml.remove_aliases]

    val arg_type : t Core.Command.Arg_type.t

    module Zoned : sig
      type t
      [@@ocaml.doc
        " Sexps look like \"(12:01 nyc)\"\n\n\
        \          Two [t]'s may or may not correspond to the same times depending on \
         which date\n\
        \          they're evaluated. "]
      [@@deriving bin_io, sexp, hash]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Pretty_printer.S with type t := t

      include
        Stringable with type t := t
      [@@ocaml.doc " Strings look like \"12:01 nyc\" "]

      val to_string_trimmed : t -> string
      [@@ocaml.doc
        " Like [to_string] but uses [Time_float.Ofday.to_string_trimmed] to format the\n\
        \          ofday "]

      val arg_type : t Core.Command.Arg_type.t
      val create : Time.Ofday.t -> Zone.t -> t
      val create_local : Time.Ofday.t -> t
      val ofday : t -> Time.Ofday.t
      val zone : t -> Zone.t
      val to_time : t -> Date.t -> Time.t

      module With_nonchronological_compare : sig
        type nonrec t = t
        [@@ocaml.doc
          " It is possible to consistently compare [t]'s, but due to the complexities of\n\
          \            time zones and daylight savings, the resulting ordering is not \
           chronological.\n\
          \            That is, [compare t1 t2 > 0] does not imply [t2] occurs after \
           [t1] every day,\n\
          \            or any day. "]
        [@@deriving bin_io, sexp, compare, equal, hash]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t
          include Ppx_compare_lib.Comparable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]
      end
    end

    val now : zone:Zone.t -> t
  end

  type t = Time.t
  [@@ocaml.doc " A fully qualified point in time, independent of timezone. "]
  [@@deriving bin_io, compare, hash, sexp, sexp_grammar, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_compare_lib.Comparable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include
    module type of Time
    with type t := t
     and module Zone := Time.Zone
     and module Ofday := Time.Ofday
     and module Span := Time.Span

  val arg_type : t Core.Command.Arg_type.t

  include
    Identifiable.S
    with type t := t
     and type comparator_witness := comparator_witness
     and module Replace_polymorphic_compare := Replace_polymorphic_compare
  [@@ocaml.doc
    " String conversions use the local timezone by default. Sexp conversions use\n\
    \      [get_sexp_zone ()] by default, which can be overridden by calling \
     [set_sexp_zone].\n\
    \      These default time zones are used when writing a time, and when reading a \
     time with\n\
    \      no explicit zone or UTC offset.\n\n\
    \      Sexps and strings display the date, ofday, and UTC offset of [t] relative to \
     the\n\
    \      appropriate time zone. "]

  val get_sexp_zone : unit -> Zone.t
  val set_sexp_zone : Zone.t -> unit

  include Robustly_comparable with type t := t

  val of_tm : Unix.tm -> zone:Zone.t -> t
  [@@ocaml.doc
    " [of_tm] converts a [Unix.tm] (mirroring a [struct tm] from the C stdlib) into a\n\
    \      [Time.t].  Note that the [tm_wday], [tm_yday], and [tm_isdst] fields are \
     ignored. "]

  val of_date_ofday_zoned : Date.t -> Ofday.Zoned.t -> t
  [@@ocaml.doc
    " Conversion functions that involved Ofday.Zoned.t, exactly analogous to the\n\
    \      conversion functions that involve Ofday.t "]

  val to_date_ofday_zoned : t -> zone:Time.Zone.t -> Date.t * Ofday.Zoned.t
  val to_ofday_zoned : t -> zone:Time.Zone.t -> Ofday.Zoned.t
  val to_string_fix_proto : [ `Utc | `Local ] -> t -> string
  val of_string_fix_proto : [ `Utc | `Local ] -> string -> t

  val of_string_abs : string -> t
  [@@ocaml.doc
    " This is like [of_string] except that if the string doesn't specify the zone then it\n\
    \      raises rather than assume the local timezone. "]

  val of_string_gen
    :  if_no_timezone:[ `Fail | `Local | `Use_this_one of Zone.t ]
    -> string
    -> t
  [@@ocaml.doc
    " [of_string_gen ~if_no_timezone s] attempts to parse [s] to a [t].  If [s] doesn't\n\
    \      supply a time zone [if_no_timezone] is consulted. "]

  val t_of_sexp_abs : Sexp.t -> t
  [@@ocaml.doc
    " [t_of_sexp_abs sexp] as [t_of_sexp], but demands that [sexp] indicate the timezone\n\
    \      the time is expressed in. "]

  val sexp_of_t_abs : t -> zone:Zone.t -> Sexp.t

  [@@@ocaml.text " {6 Miscellaneous} "]

  val pause : Span.t -> unit [@@ocaml.doc " [pause span] sleeps for span time. "]

  val interruptible_pause : Span.t -> [ `Ok | `Remaining of Span.t ]
  [@@ocaml.doc
    " [interruptible_pause span] sleeps for span time unless interrupted (e.g. by delivery\n\
    \      of a signal), in which case the remaining unslept portion of time is \
     returned. "]

  val pause_forever : unit -> never_returns
  [@@ocaml.doc " [pause_forever] sleeps indefinitely. "]

  val format : t -> string -> zone:Zone.t -> string
  [@@ocaml.doc
    " [format t fmt] formats the given time according to fmt, which follows the formatting\n\
    \      rules given in 'man strftime'.  The time is output in the given timezone. \
     Here are\n\
    \      some commonly used control codes:\n\n\
    \      {v\n\
    \      %Y - year (4 digits)\n\
    \      %y - year (2 digits)\n\
    \      %m - month\n\
    \      %d - day\n\
    \      %H - hour\n\
    \      %M - minute\n\
    \      %S - second\n\
    \    v}\n\n\
    \      a common choice would be: %Y-%m-%d %H:%M:%S\n\n\
    \      Although %Z and %z are interpreted as format strings, neither are correct in \
     the\n\
    \      current implementation. %Z always refers to the local machine timezone, and \
     does not\n\
    \      correctly detect whether DST is active. The effective local timezone can be\n\
    \      controlled by setting the \"TZ\" environment variable before calling \
     [format]. %z\n\
    \      behaves unreliably and should be avoided.\n\n\
    \      Not all strftime control codes are standard; the supported subset will depend \
     on the\n\
    \      C libraries linked into a given executable.\n\
    \  "]

  val parse
    :  ?allow_trailing_input:(bool[@ocaml.doc " default = false "])
    -> string
    -> fmt:string
    -> zone:Zone.t
    -> t
  [@@ocaml.doc
    " [parse string ~fmt ~zone] parses [string], according to [fmt], which follows the\n\
    \      formatting rules given in 'man strptime'.  The time is assumed to be in the \
     given\n\
    \      timezone.\n\n\
    \      {v\n\
    \      %Y - year (4 digits)\n\
    \      %y - year (2 digits)\n\
    \      %m - month\n\
    \      %d - day\n\
    \      %H - hour\n\
    \      %M - minute\n\
    \      %S - second\n\
    \    v}\n\n\
    \      Raise if [allow_trailing_input] is false and [fmt] does not consume all of the\n\
    \      input. "]

  module Exposed_for_tests : sig
    val ensure_colon_in_offset : string -> string
  end
end

module type Time_functor = sig
  module type S = S

  module Make : functor
      (Time0 : Time_float.S_kernel_without_zone)
      -> functor
      (Time : Time_float.S_kernel with module Time := Time0)
      -> S with module Time0 := Time0 and module Time := Time
end

[@@@ocaml.text
  " {1 Notes on time}\n\n\
  \    This library replicates and extends the functionality of the standard Unix time\n\
  \    handling functions (currently exposed in the Unix module, and indirectly through \
   the\n\
  \    Time module).\n\n\
  \    Things you should know before delving into the mess of time...\n\n\
  \    {2 Some general resources (summarized information also appears below) }\n\n\
  \    {v\n\
  \    general overview   - http://www.twinsun.com/tz/tz-link.htm\n\
  \    zone abbreviations - \
   http://blogs.msdn.com/oldnewthing/archive/2008/03/07/8080060.aspx\n\
  \    leap seconds       - http://en.wikipedia.org/wiki/Leap_second\n\
  \    epoch time         - http://en.wikipedia.org/wiki/Unix_time\n\
  \    UTC/GMT time       - http://www.apparent-wind.com/gmt-explained.html\n\
  \    TAI time           - http://en.wikipedia.org/wiki/International_Atomic_Time\n\
  \    Almost every possible time measurement -\n\
  \      http://www.ucolick.org/~sla/leapsecs/timescales.html\n\
  \  v}\n\n\
  \    {2 Standards for measuring time }\n\n\
  \    - Epoch time/Unix time/Posix time: Defined as the number of seconds that have \
   passed\n\
  \      since midnight, January 1st, 1970 GMT.  However, under epoch time, a day is \
   always\n\
  \      86,400 seconds long, and a minute never contains more than 60 total seconds.  \
   In other\n\
  \      words, epoch time does not take leap seconds into account properly.  What a POSIX\n\
  \      compliant system does during a leap second depends on the way in which its \
   clock is\n\
  \      managed.  It either ignores it, replays the second, or causes a second to last \
   longer\n\
  \      than a second (retards the second).  The important thing to remember is that \
   however\n\
  \      the transition is managed, all days start on an evenly divisible multiple of \
   86,400.\n\
  \    - GMT/Greenwich Mean Time/Greenwich Civil Time: The time based on the movement of \
   the\n\
  \      sun relative to the meridian through the Old Greenwich Observatory (0 \
   degrees).  The\n\
  \      movement of the sun in this case is a \"mean\" movement of the sun to adjust \
   for slight\n\
  \      eccentricities in the rotation of the earth, as well as for the effect of the \
   tilt of\n\
  \      the earth on the visible speed of the sun across the sky at different times of \
   the\n\
  \      year.  GMT is often used synonymously with the term UTC (see below), but may \
   also be\n\
  \      used to refer to the time system described here, which differs from UTC (as of \
   2009)\n\
  \      by ~1 second.\n\
  \    - Standard Time: The time based on the adjusted (as in GMT) movement of the sun \
   over a\n\
  \      point on the earth that is not Greenwich.  Colloquially, the time in a time zone\n\
  \      without accounting for any form of daylight savings time.\n\
  \    - Wall Clock Time: The time as it appears on a clock on the wall in a given time \
   zone.\n\
  \      Essentially this is standard time with DST adjustments.\n\
  \    - TAI: International atomic time.  The time based on a weighted average of the \
   time kept\n\
  \      by roughly 300 atomic clocks worldwide.  TAI is written using the same format as\n\
  \      normal solar (also called civil) times, but is not based on, or adjusted for the\n\
  \      apparent solar time.  Thus, as of 2009 TAI appears to be ahead of most other time\n\
  \      systems by ~34 seconds when written out in date/time form (2004-09-17T00:00:32 \
   TAI is\n\
  \      2004-09-17T00:00:00 UTC)\n\
  \    - UTC/Universal Coordinated Time: Often taken as just another term for GMT, UTC is\n\
  \      actually TAI adjusted with leap seconds to keep it in line with apparent solar \
   time.\n\
  \      Each UTC day is not an exact number of seconds long (unlike TAI or epoch time), \
   and\n\
  \      every second is exactly one real second long (unlike GMT, which is based \
   entirely on\n\
  \      the apparent motion of the sun, meaning that seconds under GMT slowly get \
   longer as\n\
  \      the earth's rotation slows down).  Leap seconds are determined by the rotation of\n\
  \      the earth, which is carefully measured by the International Earth Rotation \
   Service\n\
  \      in Paris, France using a combination of satellite and lunar laser ranging, very\n\
  \      long baseline interferometry, and Navstar Global Positioning System (GPS) \
   stations.\n\
  \      This isn't important for using UTC, but is very cool.  UTC is not well defined \
   before\n\
  \      about 1960.\n\
  \    - Windows File Time: The number of 100-nanosecond intervals that have elapsed since\n\
  \      12:00 A.M. January 1, 1601, UTC.  This is great because UTC has no meaning in \
   1601\n\
  \      (being based on atomic timekeeping technologies that didn't exist then), and also\n\
  \      because 1601 predates the development of even reasonably accurate clocks of any \
   sort.\n\
  \      The reasoning behind the Windows epoch time choice is that \"The Gregorian \
   calendar\n\
  \      operates on a 400-year cycle, and 1601 is the first year of the cycle that was\n\
  \      active at the time Windows NT was being designed. In other words, it was chosen \
   to\n\
  \      make the math come out nicely.\"\n\
  \      (http://blogs.msdn.com/oldnewthing/archive/2009/03/06/9461176.aspx)\n\
  \    - VBScript (this is my favorite):\n\
  \      \
   http://blogs.msdn.com/ericlippert/archive/2003/09/16/eric-s-complete-guide-to-vt-date.aspx\n\n\
  \    All of these systems start to exhibit problems as you go further back in time, \
   partly\n\
  \    because truly accurate timekeeping didn't make an appearance until roughly 1958, \
   and\n\
  \    partly because different parts of the world didn't actually have well defined \
   time zones\n\
  \    for a long time.  If you go back far enough, you run into the switch between the \
   Julian\n\
  \    (old) and the Gregorian calendar, which happened at different times in history in\n\
  \    different places in the world.\n\n\
  \    {2 How does a system determine what time zone it is in? }\n\n\
  \    + Check to see if the TZ environment variable is set.  If it is, it can be set to \
   one\n\
  \    of three forms, two of which are rarely, if ever used see:\n\n\
  \    http://www.opengroup.org/onlinepubs/000095399/basedefs/xbd_chap08.html\n\n\
  \    for more information on the obscure forms.  The common form represents a relative \
   path\n\
  \    from the base /usr/share/zoneinfo/posix, and is generally in the form of a \
   continent\n\
  \    or country name paired with a city name (Europe/London, America/New_York).  This is\n\
  \    used to load the specified file from disk, which contains a time zone database in \
   zic\n\
  \    format (man tzfile).\n\n\
  \    + If TZ is not set, the system will try to read the file located at /etc/localtime,\n\
  \    which must be a zic timezone database (and which is often just a symlink into\n\
  \    /usr/share/zoneinfo/posix).\n\
  \    + If /etc/localtime cannot be found, then the system is assumed to be in GMT.\n\n\
  \    It's worth noting that under this system there is no place on the system to go to \
   get\n\
  \    the name of the file you are using (/etc/localtime may not be a link, and may \
   just be a\n\
  \    copy, or its own database not represented in /usr/share/zoneinfo).  Additionally, \
   the\n\
  \    names of the files in the system zoneinfo database follow an internal standard, and\n\
  \    there is no established standard for naming timezones.  So even if you were using \
   one of\n\
  \    these files, and you did know its name, you cannot assume that that name matches \
   any\n\
  \    timezone specified by any other system or description.\n\n\
  \    One common misconception about time zones is that the standard time zone \
   abbreviations\n\
  \    can be used.  For instance, EST surely refers to Eastern Standard Time.  This is\n\
  \    unfortunately not true - CST can refer to China Central Time, Central Standard \
   Time, or\n\
  \    Cuba Summer Time for instance - and time zone libraries that appear to correctly \
   parse\n\
  \    times that use time zone abbreviations do so by using a heuristic that usually \
   assumes\n\
  \    you mean a time in the US or Europe, in that order.  Time zones also sometimes \
   use two\n\
  \    different abbreviations depending on whether the time in question is in standard \
   time,\n\
  \    or daylight savings time.  These abbreviations are kept in the timezone \
   databases, which\n\
  \    is how programs like date manage to output meaningful abbreviations. The only \
   poorly\n\
  \    specified operation is reading in times with abbreviations.\n\n\
  \    This library contains a function that attempts to make an accurate determination \
   of the\n\
  \    machine timezone by testing the md5 sum of the currently referenced timezone file\n\
  \    against all of the possible candidates in the system database.  It additionally \
   makes\n\
  \    some adjustments to return the more common timezone names since some files in the\n\
  \    database are duplicated under several names.  It returns an option because of the\n\
  \    problems mentioned above.\n\n\
  \    {2 The problems with string time conversions }\n\n\
  \    There are two cases where string time conversions are problematic, both related to\n\
  \    daylight savings time.\n\n\
  \    In the case where time jumps forward one hour, there are possible representations \
   of\n\
  \    times that never happened 2006-04-02T02:30:00 in the eastern U.S. never happened \
   for\n\
  \    instance, because the clock jumped forward one hour directly from 2 to 3.  Unix \
   time\n\
  \    zone libraries asked to convert one of these times will generally produce the \
   epoch time\n\
  \    that represents the time 1/2 hour after 2 am, which when converted back to a string\n\
  \    representation will be T03:30:00.\n\n\
  \    The second case is when the clocks are set back one hour, which causes one hour \
   of time\n\
  \    to happen twice.  Converting a string in this range without further specification \
   into\n\
  \    an epoch time is indeterminate since it could be referring to either of two \
   times.  Unix\n\
  \    libraries handle this by either allowing you to pass in a dst flag to the \
   conversion\n\
  \    function to specify which time you mean, or by using a heuristic to guess which \
   time you\n\
  \    meant.\n\n\
  \    The existence of both cases make a strong argument for serializing all times in \
   UTC,\n\
  \    which doesn't suffer from these issues.\n"]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
