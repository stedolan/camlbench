open! Base

external nanoseconds_since_unix_epoch_or_zero
  :  unit
  -> Int63.t
  = "time_now_nanoseconds_since_unix_epoch_or_zero"
  [@@noalloc]

external nanosecond_counter_for_timing
  :  unit
  -> Int63.t
  = "time_now_nanosecond_counter_for_timing"
  [@@noalloc]

let[@inline never] gettime_failed () = failwith "clock_gettime(CLOCK_REALTIME) failed"

let nanoseconds_since_unix_epoch () =
  let t = nanoseconds_since_unix_epoch_or_zero () in
  if Int63.( <> ) t Int63.zero then t else gettime_failed ()
;;
