let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"unix_error.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "unix_error.ml.before-ppx"
;;

open! Core
open! Import

type error = Unix.error =
  | E2BIG
  | EACCES
  | EAGAIN
  | EBADF
  | EBUSY
  | ECHILD
  | EDEADLK
  | EDOM
  | EEXIST
  | EFAULT
  | EFBIG
  | EINTR
  | EINVAL
  | EIO
  | EISDIR
  | EMFILE
  | EMLINK
  | ENAMETOOLONG
  | ENFILE
  | ENODEV
  | ENOENT
  | ENOEXEC
  | ENOLCK
  | ENOMEM
  | ENOSPC
  | ENOSYS
  | ENOTDIR
  | ENOTEMPTY
  | ENOTTY
  | ENXIO
  | EPERM
  | EPIPE
  | ERANGE
  | EROFS
  | ESPIPE
  | ESRCH
  | EXDEV
  | EWOULDBLOCK
  | EINPROGRESS
  | EALREADY
  | ENOTSOCK
  | EDESTADDRREQ
  | EMSGSIZE
  | EPROTOTYPE
  | ENOPROTOOPT
  | EPROTONOSUPPORT
  | ESOCKTNOSUPPORT
  | EOPNOTSUPP
  | EPFNOSUPPORT
  | EAFNOSUPPORT
  | EADDRINUSE
  | EADDRNOTAVAIL
  | ENETDOWN
  | ENETUNREACH
  | ENETRESET
  | ECONNABORTED
  | ECONNRESET
  | ENOBUFS
  | EISCONN
  | ENOTCONN
  | ESHUTDOWN
  | ETOOMANYREFS
  | ETIMEDOUT
  | ECONNREFUSED
  | EHOSTDOWN
  | EHOSTUNREACH
  | ELOOP
  | EOVERFLOW
  | EUNKNOWNERR of int
[@@ocaml.doc " @deprecated in favor of [t], below. "] [@@deriving sexp, compare]

include struct
  let _ = fun (_ : error) -> ()

  let error_of_sexp =
    (let error_source__003_ = "unix_error.ml.before-ppx.error" in
     function
     | Sexplib0.Sexp.Atom ("e2BIG" | "E2BIG") -> E2BIG
     | Sexplib0.Sexp.Atom ("eACCES" | "EACCES") -> EACCES
     | Sexplib0.Sexp.Atom ("eAGAIN" | "EAGAIN") -> EAGAIN
     | Sexplib0.Sexp.Atom ("eBADF" | "EBADF") -> EBADF
     | Sexplib0.Sexp.Atom ("eBUSY" | "EBUSY") -> EBUSY
     | Sexplib0.Sexp.Atom ("eCHILD" | "ECHILD") -> ECHILD
     | Sexplib0.Sexp.Atom ("eDEADLK" | "EDEADLK") -> EDEADLK
     | Sexplib0.Sexp.Atom ("eDOM" | "EDOM") -> EDOM
     | Sexplib0.Sexp.Atom ("eEXIST" | "EEXIST") -> EEXIST
     | Sexplib0.Sexp.Atom ("eFAULT" | "EFAULT") -> EFAULT
     | Sexplib0.Sexp.Atom ("eFBIG" | "EFBIG") -> EFBIG
     | Sexplib0.Sexp.Atom ("eINTR" | "EINTR") -> EINTR
     | Sexplib0.Sexp.Atom ("eINVAL" | "EINVAL") -> EINVAL
     | Sexplib0.Sexp.Atom ("eIO" | "EIO") -> EIO
     | Sexplib0.Sexp.Atom ("eISDIR" | "EISDIR") -> EISDIR
     | Sexplib0.Sexp.Atom ("eMFILE" | "EMFILE") -> EMFILE
     | Sexplib0.Sexp.Atom ("eMLINK" | "EMLINK") -> EMLINK
     | Sexplib0.Sexp.Atom ("eNAMETOOLONG" | "ENAMETOOLONG") -> ENAMETOOLONG
     | Sexplib0.Sexp.Atom ("eNFILE" | "ENFILE") -> ENFILE
     | Sexplib0.Sexp.Atom ("eNODEV" | "ENODEV") -> ENODEV
     | Sexplib0.Sexp.Atom ("eNOENT" | "ENOENT") -> ENOENT
     | Sexplib0.Sexp.Atom ("eNOEXEC" | "ENOEXEC") -> ENOEXEC
     | Sexplib0.Sexp.Atom ("eNOLCK" | "ENOLCK") -> ENOLCK
     | Sexplib0.Sexp.Atom ("eNOMEM" | "ENOMEM") -> ENOMEM
     | Sexplib0.Sexp.Atom ("eNOSPC" | "ENOSPC") -> ENOSPC
     | Sexplib0.Sexp.Atom ("eNOSYS" | "ENOSYS") -> ENOSYS
     | Sexplib0.Sexp.Atom ("eNOTDIR" | "ENOTDIR") -> ENOTDIR
     | Sexplib0.Sexp.Atom ("eNOTEMPTY" | "ENOTEMPTY") -> ENOTEMPTY
     | Sexplib0.Sexp.Atom ("eNOTTY" | "ENOTTY") -> ENOTTY
     | Sexplib0.Sexp.Atom ("eNXIO" | "ENXIO") -> ENXIO
     | Sexplib0.Sexp.Atom ("ePERM" | "EPERM") -> EPERM
     | Sexplib0.Sexp.Atom ("ePIPE" | "EPIPE") -> EPIPE
     | Sexplib0.Sexp.Atom ("eRANGE" | "ERANGE") -> ERANGE
     | Sexplib0.Sexp.Atom ("eROFS" | "EROFS") -> EROFS
     | Sexplib0.Sexp.Atom ("eSPIPE" | "ESPIPE") -> ESPIPE
     | Sexplib0.Sexp.Atom ("eSRCH" | "ESRCH") -> ESRCH
     | Sexplib0.Sexp.Atom ("eXDEV" | "EXDEV") -> EXDEV
     | Sexplib0.Sexp.Atom ("eWOULDBLOCK" | "EWOULDBLOCK") -> EWOULDBLOCK
     | Sexplib0.Sexp.Atom ("eINPROGRESS" | "EINPROGRESS") -> EINPROGRESS
     | Sexplib0.Sexp.Atom ("eALREADY" | "EALREADY") -> EALREADY
     | Sexplib0.Sexp.Atom ("eNOTSOCK" | "ENOTSOCK") -> ENOTSOCK
     | Sexplib0.Sexp.Atom ("eDESTADDRREQ" | "EDESTADDRREQ") -> EDESTADDRREQ
     | Sexplib0.Sexp.Atom ("eMSGSIZE" | "EMSGSIZE") -> EMSGSIZE
     | Sexplib0.Sexp.Atom ("ePROTOTYPE" | "EPROTOTYPE") -> EPROTOTYPE
     | Sexplib0.Sexp.Atom ("eNOPROTOOPT" | "ENOPROTOOPT") -> ENOPROTOOPT
     | Sexplib0.Sexp.Atom ("ePROTONOSUPPORT" | "EPROTONOSUPPORT") -> EPROTONOSUPPORT
     | Sexplib0.Sexp.Atom ("eSOCKTNOSUPPORT" | "ESOCKTNOSUPPORT") -> ESOCKTNOSUPPORT
     | Sexplib0.Sexp.Atom ("eOPNOTSUPP" | "EOPNOTSUPP") -> EOPNOTSUPP
     | Sexplib0.Sexp.Atom ("ePFNOSUPPORT" | "EPFNOSUPPORT") -> EPFNOSUPPORT
     | Sexplib0.Sexp.Atom ("eAFNOSUPPORT" | "EAFNOSUPPORT") -> EAFNOSUPPORT
     | Sexplib0.Sexp.Atom ("eADDRINUSE" | "EADDRINUSE") -> EADDRINUSE
     | Sexplib0.Sexp.Atom ("eADDRNOTAVAIL" | "EADDRNOTAVAIL") -> EADDRNOTAVAIL
     | Sexplib0.Sexp.Atom ("eNETDOWN" | "ENETDOWN") -> ENETDOWN
     | Sexplib0.Sexp.Atom ("eNETUNREACH" | "ENETUNREACH") -> ENETUNREACH
     | Sexplib0.Sexp.Atom ("eNETRESET" | "ENETRESET") -> ENETRESET
     | Sexplib0.Sexp.Atom ("eCONNABORTED" | "ECONNABORTED") -> ECONNABORTED
     | Sexplib0.Sexp.Atom ("eCONNRESET" | "ECONNRESET") -> ECONNRESET
     | Sexplib0.Sexp.Atom ("eNOBUFS" | "ENOBUFS") -> ENOBUFS
     | Sexplib0.Sexp.Atom ("eISCONN" | "EISCONN") -> EISCONN
     | Sexplib0.Sexp.Atom ("eNOTCONN" | "ENOTCONN") -> ENOTCONN
     | Sexplib0.Sexp.Atom ("eSHUTDOWN" | "ESHUTDOWN") -> ESHUTDOWN
     | Sexplib0.Sexp.Atom ("eTOOMANYREFS" | "ETOOMANYREFS") -> ETOOMANYREFS
     | Sexplib0.Sexp.Atom ("eTIMEDOUT" | "ETIMEDOUT") -> ETIMEDOUT
     | Sexplib0.Sexp.Atom ("eCONNREFUSED" | "ECONNREFUSED") -> ECONNREFUSED
     | Sexplib0.Sexp.Atom ("eHOSTDOWN" | "EHOSTDOWN") -> EHOSTDOWN
     | Sexplib0.Sexp.Atom ("eHOSTUNREACH" | "EHOSTUNREACH") -> EHOSTUNREACH
     | Sexplib0.Sexp.Atom ("eLOOP" | "ELOOP") -> ELOOP
     | Sexplib0.Sexp.Atom ("eOVERFLOW" | "EOVERFLOW") -> EOVERFLOW
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom (("eUNKNOWNERR" | "EUNKNOWNERR") as _tag__006_)
         :: sexp_args__007_) as _sexp__005_ ->
       (match sexp_args__007_ with
        | arg0__008_ :: [] ->
          let res0__009_ = int_of_sexp arg0__008_ in
          EUNKNOWNERR res0__009_
        | _ ->
          Sexplib0.Sexp_conv_error.stag_incorrect_n_args
            error_source__003_
            _tag__006_
            _sexp__005_)
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("e2BIG" | "E2BIG") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eACCES" | "EACCES") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eAGAIN" | "EAGAIN") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eBADF" | "EBADF") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eBUSY" | "EBUSY") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCHILD" | "ECHILD") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDEADLK" | "EDEADLK") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDOM" | "EDOM") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eEXIST" | "EEXIST") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eFAULT" | "EFAULT") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eFBIG" | "EFBIG") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINTR" | "EINTR") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINVAL" | "EINVAL") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eIO" | "EIO") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eISDIR" | "EISDIR") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMFILE" | "EMFILE") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMLINK" | "EMLINK") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNAMETOOLONG" | "ENAMETOOLONG") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNFILE" | "ENFILE") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNODEV" | "ENODEV") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOENT" | "ENOENT") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOEXEC" | "ENOEXEC") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOLCK" | "ENOLCK") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOMEM" | "ENOMEM") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOSPC" | "ENOSPC") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOSYS" | "ENOSYS") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTDIR" | "ENOTDIR") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTEMPTY" | "ENOTEMPTY") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTTY" | "ENOTTY") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNXIO" | "ENXIO") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePERM" | "EPERM") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePIPE" | "EPIPE") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eRANGE" | "ERANGE") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eROFS" | "EROFS") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSPIPE" | "ESPIPE") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSRCH" | "ESRCH") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eXDEV" | "EXDEV") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eWOULDBLOCK" | "EWOULDBLOCK") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eINPROGRESS" | "EINPROGRESS") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eALREADY" | "EALREADY") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTSOCK" | "ENOTSOCK") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eDESTADDRREQ" | "EDESTADDRREQ") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eMSGSIZE" | "EMSGSIZE") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePROTOTYPE" | "EPROTOTYPE") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOPROTOOPT" | "ENOPROTOOPT") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePROTONOSUPPORT" | "EPROTONOSUPPORT") :: _)
       as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSOCKTNOSUPPORT" | "ESOCKTNOSUPPORT") :: _)
       as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eOPNOTSUPP" | "EOPNOTSUPP") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ePFNOSUPPORT" | "EPFNOSUPPORT") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eAFNOSUPPORT" | "EAFNOSUPPORT") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eADDRINUSE" | "EADDRINUSE") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eADDRNOTAVAIL" | "EADDRNOTAVAIL") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETDOWN" | "ENETDOWN") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETUNREACH" | "ENETUNREACH") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNETRESET" | "ENETRESET") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNABORTED" | "ECONNABORTED") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNRESET" | "ECONNRESET") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOBUFS" | "ENOBUFS") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eISCONN" | "EISCONN") :: _) as sexp__004_
       -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eNOTCONN" | "ENOTCONN") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eSHUTDOWN" | "ESHUTDOWN") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eTOOMANYREFS" | "ETOOMANYREFS") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eTIMEDOUT" | "ETIMEDOUT") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eCONNREFUSED" | "ECONNREFUSED") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eHOSTDOWN" | "EHOSTDOWN") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eHOSTUNREACH" | "EHOSTUNREACH") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eLOOP" | "ELOOP") :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("eOVERFLOW" | "EOVERFLOW") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.Atom ("eUNKNOWNERR" | "EUNKNOWNERR") as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_takes_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
     | Sexplib0.Sexp.List [] as sexp__002_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
     | sexp__002_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__003_ sexp__002_
     : Sexplib0.Sexp.t -> error)
  ;;

  let _ = error_of_sexp

  let sexp_of_error =
    (function
     | E2BIG -> Sexplib0.Sexp.Atom "E2BIG"
     | EACCES -> Sexplib0.Sexp.Atom "EACCES"
     | EAGAIN -> Sexplib0.Sexp.Atom "EAGAIN"
     | EBADF -> Sexplib0.Sexp.Atom "EBADF"
     | EBUSY -> Sexplib0.Sexp.Atom "EBUSY"
     | ECHILD -> Sexplib0.Sexp.Atom "ECHILD"
     | EDEADLK -> Sexplib0.Sexp.Atom "EDEADLK"
     | EDOM -> Sexplib0.Sexp.Atom "EDOM"
     | EEXIST -> Sexplib0.Sexp.Atom "EEXIST"
     | EFAULT -> Sexplib0.Sexp.Atom "EFAULT"
     | EFBIG -> Sexplib0.Sexp.Atom "EFBIG"
     | EINTR -> Sexplib0.Sexp.Atom "EINTR"
     | EINVAL -> Sexplib0.Sexp.Atom "EINVAL"
     | EIO -> Sexplib0.Sexp.Atom "EIO"
     | EISDIR -> Sexplib0.Sexp.Atom "EISDIR"
     | EMFILE -> Sexplib0.Sexp.Atom "EMFILE"
     | EMLINK -> Sexplib0.Sexp.Atom "EMLINK"
     | ENAMETOOLONG -> Sexplib0.Sexp.Atom "ENAMETOOLONG"
     | ENFILE -> Sexplib0.Sexp.Atom "ENFILE"
     | ENODEV -> Sexplib0.Sexp.Atom "ENODEV"
     | ENOENT -> Sexplib0.Sexp.Atom "ENOENT"
     | ENOEXEC -> Sexplib0.Sexp.Atom "ENOEXEC"
     | ENOLCK -> Sexplib0.Sexp.Atom "ENOLCK"
     | ENOMEM -> Sexplib0.Sexp.Atom "ENOMEM"
     | ENOSPC -> Sexplib0.Sexp.Atom "ENOSPC"
     | ENOSYS -> Sexplib0.Sexp.Atom "ENOSYS"
     | ENOTDIR -> Sexplib0.Sexp.Atom "ENOTDIR"
     | ENOTEMPTY -> Sexplib0.Sexp.Atom "ENOTEMPTY"
     | ENOTTY -> Sexplib0.Sexp.Atom "ENOTTY"
     | ENXIO -> Sexplib0.Sexp.Atom "ENXIO"
     | EPERM -> Sexplib0.Sexp.Atom "EPERM"
     | EPIPE -> Sexplib0.Sexp.Atom "EPIPE"
     | ERANGE -> Sexplib0.Sexp.Atom "ERANGE"
     | EROFS -> Sexplib0.Sexp.Atom "EROFS"
     | ESPIPE -> Sexplib0.Sexp.Atom "ESPIPE"
     | ESRCH -> Sexplib0.Sexp.Atom "ESRCH"
     | EXDEV -> Sexplib0.Sexp.Atom "EXDEV"
     | EWOULDBLOCK -> Sexplib0.Sexp.Atom "EWOULDBLOCK"
     | EINPROGRESS -> Sexplib0.Sexp.Atom "EINPROGRESS"
     | EALREADY -> Sexplib0.Sexp.Atom "EALREADY"
     | ENOTSOCK -> Sexplib0.Sexp.Atom "ENOTSOCK"
     | EDESTADDRREQ -> Sexplib0.Sexp.Atom "EDESTADDRREQ"
     | EMSGSIZE -> Sexplib0.Sexp.Atom "EMSGSIZE"
     | EPROTOTYPE -> Sexplib0.Sexp.Atom "EPROTOTYPE"
     | ENOPROTOOPT -> Sexplib0.Sexp.Atom "ENOPROTOOPT"
     | EPROTONOSUPPORT -> Sexplib0.Sexp.Atom "EPROTONOSUPPORT"
     | ESOCKTNOSUPPORT -> Sexplib0.Sexp.Atom "ESOCKTNOSUPPORT"
     | EOPNOTSUPP -> Sexplib0.Sexp.Atom "EOPNOTSUPP"
     | EPFNOSUPPORT -> Sexplib0.Sexp.Atom "EPFNOSUPPORT"
     | EAFNOSUPPORT -> Sexplib0.Sexp.Atom "EAFNOSUPPORT"
     | EADDRINUSE -> Sexplib0.Sexp.Atom "EADDRINUSE"
     | EADDRNOTAVAIL -> Sexplib0.Sexp.Atom "EADDRNOTAVAIL"
     | ENETDOWN -> Sexplib0.Sexp.Atom "ENETDOWN"
     | ENETUNREACH -> Sexplib0.Sexp.Atom "ENETUNREACH"
     | ENETRESET -> Sexplib0.Sexp.Atom "ENETRESET"
     | ECONNABORTED -> Sexplib0.Sexp.Atom "ECONNABORTED"
     | ECONNRESET -> Sexplib0.Sexp.Atom "ECONNRESET"
     | ENOBUFS -> Sexplib0.Sexp.Atom "ENOBUFS"
     | EISCONN -> Sexplib0.Sexp.Atom "EISCONN"
     | ENOTCONN -> Sexplib0.Sexp.Atom "ENOTCONN"
     | ESHUTDOWN -> Sexplib0.Sexp.Atom "ESHUTDOWN"
     | ETOOMANYREFS -> Sexplib0.Sexp.Atom "ETOOMANYREFS"
     | ETIMEDOUT -> Sexplib0.Sexp.Atom "ETIMEDOUT"
     | ECONNREFUSED -> Sexplib0.Sexp.Atom "ECONNREFUSED"
     | EHOSTDOWN -> Sexplib0.Sexp.Atom "EHOSTDOWN"
     | EHOSTUNREACH -> Sexplib0.Sexp.Atom "EHOSTUNREACH"
     | ELOOP -> Sexplib0.Sexp.Atom "ELOOP"
     | EOVERFLOW -> Sexplib0.Sexp.Atom "EOVERFLOW"
     | EUNKNOWNERR arg0__010_ ->
       let res0__011_ = sexp_of_int arg0__010_ in
       Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "EUNKNOWNERR"; res0__011_ ]
     : error -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_error

  let compare_error =
    (fun a__012_ b__013_ ->
       if Stdlib.( == ) a__012_ b__013_
       then 0
       else (
         match a__012_, b__013_ with
         | E2BIG, E2BIG -> 0
         | E2BIG, _ -> -1
         | _, E2BIG -> 1
         | EACCES, EACCES -> 0
         | EACCES, _ -> -1
         | _, EACCES -> 1
         | EAGAIN, EAGAIN -> 0
         | EAGAIN, _ -> -1
         | _, EAGAIN -> 1
         | EBADF, EBADF -> 0
         | EBADF, _ -> -1
         | _, EBADF -> 1
         | EBUSY, EBUSY -> 0
         | EBUSY, _ -> -1
         | _, EBUSY -> 1
         | ECHILD, ECHILD -> 0
         | ECHILD, _ -> -1
         | _, ECHILD -> 1
         | EDEADLK, EDEADLK -> 0
         | EDEADLK, _ -> -1
         | _, EDEADLK -> 1
         | EDOM, EDOM -> 0
         | EDOM, _ -> -1
         | _, EDOM -> 1
         | EEXIST, EEXIST -> 0
         | EEXIST, _ -> -1
         | _, EEXIST -> 1
         | EFAULT, EFAULT -> 0
         | EFAULT, _ -> -1
         | _, EFAULT -> 1
         | EFBIG, EFBIG -> 0
         | EFBIG, _ -> -1
         | _, EFBIG -> 1
         | EINTR, EINTR -> 0
         | EINTR, _ -> -1
         | _, EINTR -> 1
         | EINVAL, EINVAL -> 0
         | EINVAL, _ -> -1
         | _, EINVAL -> 1
         | EIO, EIO -> 0
         | EIO, _ -> -1
         | _, EIO -> 1
         | EISDIR, EISDIR -> 0
         | EISDIR, _ -> -1
         | _, EISDIR -> 1
         | EMFILE, EMFILE -> 0
         | EMFILE, _ -> -1
         | _, EMFILE -> 1
         | EMLINK, EMLINK -> 0
         | EMLINK, _ -> -1
         | _, EMLINK -> 1
         | ENAMETOOLONG, ENAMETOOLONG -> 0
         | ENAMETOOLONG, _ -> -1
         | _, ENAMETOOLONG -> 1
         | ENFILE, ENFILE -> 0
         | ENFILE, _ -> -1
         | _, ENFILE -> 1
         | ENODEV, ENODEV -> 0
         | ENODEV, _ -> -1
         | _, ENODEV -> 1
         | ENOENT, ENOENT -> 0
         | ENOENT, _ -> -1
         | _, ENOENT -> 1
         | ENOEXEC, ENOEXEC -> 0
         | ENOEXEC, _ -> -1
         | _, ENOEXEC -> 1
         | ENOLCK, ENOLCK -> 0
         | ENOLCK, _ -> -1
         | _, ENOLCK -> 1
         | ENOMEM, ENOMEM -> 0
         | ENOMEM, _ -> -1
         | _, ENOMEM -> 1
         | ENOSPC, ENOSPC -> 0
         | ENOSPC, _ -> -1
         | _, ENOSPC -> 1
         | ENOSYS, ENOSYS -> 0
         | ENOSYS, _ -> -1
         | _, ENOSYS -> 1
         | ENOTDIR, ENOTDIR -> 0
         | ENOTDIR, _ -> -1
         | _, ENOTDIR -> 1
         | ENOTEMPTY, ENOTEMPTY -> 0
         | ENOTEMPTY, _ -> -1
         | _, ENOTEMPTY -> 1
         | ENOTTY, ENOTTY -> 0
         | ENOTTY, _ -> -1
         | _, ENOTTY -> 1
         | ENXIO, ENXIO -> 0
         | ENXIO, _ -> -1
         | _, ENXIO -> 1
         | EPERM, EPERM -> 0
         | EPERM, _ -> -1
         | _, EPERM -> 1
         | EPIPE, EPIPE -> 0
         | EPIPE, _ -> -1
         | _, EPIPE -> 1
         | ERANGE, ERANGE -> 0
         | ERANGE, _ -> -1
         | _, ERANGE -> 1
         | EROFS, EROFS -> 0
         | EROFS, _ -> -1
         | _, EROFS -> 1
         | ESPIPE, ESPIPE -> 0
         | ESPIPE, _ -> -1
         | _, ESPIPE -> 1
         | ESRCH, ESRCH -> 0
         | ESRCH, _ -> -1
         | _, ESRCH -> 1
         | EXDEV, EXDEV -> 0
         | EXDEV, _ -> -1
         | _, EXDEV -> 1
         | EWOULDBLOCK, EWOULDBLOCK -> 0
         | EWOULDBLOCK, _ -> -1
         | _, EWOULDBLOCK -> 1
         | EINPROGRESS, EINPROGRESS -> 0
         | EINPROGRESS, _ -> -1
         | _, EINPROGRESS -> 1
         | EALREADY, EALREADY -> 0
         | EALREADY, _ -> -1
         | _, EALREADY -> 1
         | ENOTSOCK, ENOTSOCK -> 0
         | ENOTSOCK, _ -> -1
         | _, ENOTSOCK -> 1
         | EDESTADDRREQ, EDESTADDRREQ -> 0
         | EDESTADDRREQ, _ -> -1
         | _, EDESTADDRREQ -> 1
         | EMSGSIZE, EMSGSIZE -> 0
         | EMSGSIZE, _ -> -1
         | _, EMSGSIZE -> 1
         | EPROTOTYPE, EPROTOTYPE -> 0
         | EPROTOTYPE, _ -> -1
         | _, EPROTOTYPE -> 1
         | ENOPROTOOPT, ENOPROTOOPT -> 0
         | ENOPROTOOPT, _ -> -1
         | _, ENOPROTOOPT -> 1
         | EPROTONOSUPPORT, EPROTONOSUPPORT -> 0
         | EPROTONOSUPPORT, _ -> -1
         | _, EPROTONOSUPPORT -> 1
         | ESOCKTNOSUPPORT, ESOCKTNOSUPPORT -> 0
         | ESOCKTNOSUPPORT, _ -> -1
         | _, ESOCKTNOSUPPORT -> 1
         | EOPNOTSUPP, EOPNOTSUPP -> 0
         | EOPNOTSUPP, _ -> -1
         | _, EOPNOTSUPP -> 1
         | EPFNOSUPPORT, EPFNOSUPPORT -> 0
         | EPFNOSUPPORT, _ -> -1
         | _, EPFNOSUPPORT -> 1
         | EAFNOSUPPORT, EAFNOSUPPORT -> 0
         | EAFNOSUPPORT, _ -> -1
         | _, EAFNOSUPPORT -> 1
         | EADDRINUSE, EADDRINUSE -> 0
         | EADDRINUSE, _ -> -1
         | _, EADDRINUSE -> 1
         | EADDRNOTAVAIL, EADDRNOTAVAIL -> 0
         | EADDRNOTAVAIL, _ -> -1
         | _, EADDRNOTAVAIL -> 1
         | ENETDOWN, ENETDOWN -> 0
         | ENETDOWN, _ -> -1
         | _, ENETDOWN -> 1
         | ENETUNREACH, ENETUNREACH -> 0
         | ENETUNREACH, _ -> -1
         | _, ENETUNREACH -> 1
         | ENETRESET, ENETRESET -> 0
         | ENETRESET, _ -> -1
         | _, ENETRESET -> 1
         | ECONNABORTED, ECONNABORTED -> 0
         | ECONNABORTED, _ -> -1
         | _, ECONNABORTED -> 1
         | ECONNRESET, ECONNRESET -> 0
         | ECONNRESET, _ -> -1
         | _, ECONNRESET -> 1
         | ENOBUFS, ENOBUFS -> 0
         | ENOBUFS, _ -> -1
         | _, ENOBUFS -> 1
         | EISCONN, EISCONN -> 0
         | EISCONN, _ -> -1
         | _, EISCONN -> 1
         | ENOTCONN, ENOTCONN -> 0
         | ENOTCONN, _ -> -1
         | _, ENOTCONN -> 1
         | ESHUTDOWN, ESHUTDOWN -> 0
         | ESHUTDOWN, _ -> -1
         | _, ESHUTDOWN -> 1
         | ETOOMANYREFS, ETOOMANYREFS -> 0
         | ETOOMANYREFS, _ -> -1
         | _, ETOOMANYREFS -> 1
         | ETIMEDOUT, ETIMEDOUT -> 0
         | ETIMEDOUT, _ -> -1
         | _, ETIMEDOUT -> 1
         | ECONNREFUSED, ECONNREFUSED -> 0
         | ECONNREFUSED, _ -> -1
         | _, ECONNREFUSED -> 1
         | EHOSTDOWN, EHOSTDOWN -> 0
         | EHOSTDOWN, _ -> -1
         | _, EHOSTDOWN -> 1
         | EHOSTUNREACH, EHOSTUNREACH -> 0
         | EHOSTUNREACH, _ -> -1
         | _, EHOSTUNREACH -> 1
         | ELOOP, ELOOP -> 0
         | ELOOP, _ -> -1
         | _, ELOOP -> 1
         | EOVERFLOW, EOVERFLOW -> 0
         | EOVERFLOW, _ -> -1
         | _, EOVERFLOW -> 1
         | EUNKNOWNERR _a__014_, EUNKNOWNERR _b__015_ -> compare_int _a__014_ _b__015_)
     : error -> (error[@merlin.hide]) -> int)
  ;;

  let _ = compare_error
end [@@ocaml.doc "@inline"] [@@merlin.hide]

type t = error [@@deriving sexp, compare]

include struct
  let _ = fun (_ : t) -> ()
  let t_of_sexp = (error_of_sexp : Sexplib0.Sexp.t -> t)
  let _ = t_of_sexp
  let sexp_of_t = (sexp_of_error : t -> Sexplib0.Sexp.t)
  let _ = sexp_of_t

  let compare =
    (fun a__017_ b__018_ -> compare_error a__017_ b__018_ : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare
end [@@ocaml.doc "@inline"] [@@merlin.hide]

external of_errno : int -> t = "core_unix_error_of_code"
external to_errno : t -> int = "core_code_of_unix_error"

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
