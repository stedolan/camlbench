let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"plain_diff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "plain_diff.ml.before-ppx"
;;

open Base

module Partition = struct
  type t =
    { xmid : int
    ; ymid : int
    ; lo_minimal : bool
    ; hi_minimal : bool
    }
end

let diag ~fd ~bd ~sh ~xv ~yv ~xoff ~xlim ~yoff ~ylim ~too_expensive ~find_minimal
  : Partition.t
  =
  let dmin = xoff - ylim in
  let dmax = xlim - yoff in
  let fmid = xoff - yoff in
  let bmid = xlim - ylim in
  let odd = (fmid - bmid) land 1 <> 0 in
  fd.(sh + fmid) <- xoff;
  bd.(sh + bmid) <- xlim;
  With_return.with_return (fun ({ return } : Partition.t With_return.return) ->
    let rec loop ~c ~fmin ~fmax ~bmin ~bmax =
      let fmin =
        if fmin > dmin
        then (
          fd.(sh + fmin - 2) <- -1;
          fmin - 1)
        else fmin + 1
      in
      let fmax =
        if fmax < dmax
        then (
          fd.(sh + fmax + 2) <- -1;
          fmax + 1)
        else fmax - 1
      in
      (let rec loop d =
         if d < fmin
         then ()
         else (
           let tlo = fd.(sh + d - 1) in
           let thi = fd.(sh + d + 1) in
           let x = if tlo >= thi then tlo + 1 else thi in
           let x, y =
             let rec loop ~xv ~yv ~xlim ~ylim ~x ~y =
               if x < xlim && y < ylim && phys_equal (xv x) (yv y)
               then loop ~xv ~yv ~xlim ~ylim ~x:(x + 1) ~y:(y + 1)
               else x, y
             in
             loop ~xv ~yv ~xlim ~ylim ~x ~y:(x - d)
           in
           fd.(sh + d) <- x;
           if odd && bmin <= d && d <= bmax && bd.(sh + d) <= fd.(sh + d)
           then return { xmid = x; ymid = y; lo_minimal = true; hi_minimal = true }
           else loop (d - 2))
       in
       loop fmax);
      let bmin =
        if bmin > dmin
        then (
          bd.(sh + bmin - 2) <- Int.max_value;
          bmin - 1)
        else bmin + 1
      in
      let bmax =
        if bmax < dmax
        then (
          bd.(sh + bmax + 2) <- Int.max_value;
          bmax + 1)
        else bmax - 1
      in
      (let rec loop d =
         if d < bmin
         then ()
         else (
           let tlo = bd.(sh + d - 1) in
           let thi = bd.(sh + d + 1) in
           let x = if tlo < thi then tlo else thi - 1 in
           let x, y =
             let rec loop ~xv ~yv ~xoff ~yoff ~x ~y =
               if x > xoff && y > yoff && phys_equal (xv (x - 1)) (yv (y - 1))
               then loop ~xv ~yv ~xoff ~yoff ~x:(x - 1) ~y:(y - 1)
               else x, y
             in
             loop ~xv ~yv ~xoff ~yoff ~x ~y:(x - d)
           in
           bd.(sh + d) <- x;
           if (not odd) && fmin <= d && d <= fmax && bd.(sh + d) <= fd.(sh + d)
           then return { xmid = x; ymid = y; lo_minimal = true; hi_minimal = true }
           else loop (d - 2))
       in
       loop bmax);
      if (not find_minimal) && c >= too_expensive
      then (
        let fxybest, fxbest =
          let rec loop ~d ~fxybest ~fxbest =
            if d < fmin
            then fxybest, fxbest
            else (
              let x = Int.min fd.(sh + d) xlim in
              let y = x - d in
              let x, y = if ylim < y then ylim + d, ylim else x, y in
              let fxybest, fxbest =
                if fxybest < x + y then x + y, x else fxybest, fxbest
              in
              loop ~d:(d - 2) ~fxybest ~fxbest)
          in
          loop ~d:fmax ~fxybest:(-1) ~fxbest:fmax
        in
        let bxybest, bxbest =
          let rec loop ~d ~bxybest ~bxbest =
            if d < bmin
            then bxybest, bxbest
            else (
              let x = Int.max xoff bd.(sh + d) in
              let y = x - d in
              let x, y = if y < yoff then yoff + d, yoff else x, y in
              let bxybest, bxbest =
                if x + y < bxybest then x + y, x else bxybest, bxbest
              in
              loop ~d:(d - 2) ~bxybest ~bxbest)
          in
          loop ~d:bmax ~bxybest:Int.max_value ~bxbest:bmax
        in
        if xlim + ylim - bxybest < fxybest - (xoff + yoff)
        then
          return
            { xmid = fxbest
            ; ymid = fxybest - fxbest
            ; lo_minimal = true
            ; hi_minimal = false
            }
        else
          return
            { xmid = bxbest
            ; ymid = bxybest - bxbest
            ; lo_minimal = false
            ; hi_minimal = true
            })
      else loop ~c:(c + 1) ~fmin ~fmax ~bmin ~bmax
    in
    loop ~c:1 ~fmin:fmid ~fmax:fmid ~bmin:bmid ~bmax:bmid)
;;

let diff_loop ~cutoff a ai b bi n m =
  let fd = Array.create ~len:(n + m + 3) 0 in
  let bd = Array.create ~len:(n + m + 3) 0 in
  let sh = m + 1 in
  let too_expensive =
    match cutoff with
    | Some c -> c
    | None ->
      let diags = n + m + 3 in
      let rec loop diags too_expensive =
        if diags = 0 then too_expensive else loop (diags asr 2) (too_expensive lsl 1)
      in
      Int.max 4096 (loop diags 1)
  in
  let xvec i = a.(ai.(i)) in
  let yvec j = b.(bi.(j)) in
  let chng1 = Array.create ~len:(Array.length a) true in
  let chng2 = Array.create ~len:(Array.length b) true in
  for i = 0 to n - 1 do
    chng1.(ai.(i)) <- false
  done;
  for j = 0 to m - 1 do
    chng2.(bi.(j)) <- false
  done;
  let rec loop ~xoff ~xlim ~yoff ~ylim ~find_minimal =
    let xoff, yoff =
      let rec loop ~xoff ~yoff =
        if xoff < xlim && yoff < ylim && phys_equal (xvec xoff) (yvec yoff)
        then loop ~xoff:(xoff + 1) ~yoff:(yoff + 1)
        else xoff, yoff
      in
      loop ~xoff ~yoff
    in
    let xlim, ylim =
      let rec loop ~xlim ~ylim =
        if xlim > xoff && ylim > yoff && phys_equal (xvec (xlim - 1)) (yvec (ylim - 1))
        then loop ~xlim:(xlim - 1) ~ylim:(ylim - 1)
        else xlim, ylim
      in
      loop ~xlim ~ylim
    in
    if xoff = xlim
    then
      for y = yoff to ylim - 1 do
        chng2.(bi.(y)) <- true
      done
    else if yoff = ylim
    then
      for x = xoff to xlim - 1 do
        chng1.(ai.(x)) <- true
      done
    else (
      let { Partition.xmid; ymid; lo_minimal; hi_minimal } =
        diag
          ~fd
          ~bd
          ~sh
          ~xv:xvec
          ~yv:yvec
          ~xoff
          ~xlim
          ~yoff
          ~ylim
          ~too_expensive
          ~find_minimal
      in
      loop ~xoff ~xlim:xmid ~yoff ~ylim:ymid ~find_minimal:lo_minimal;
      loop ~xoff:xmid ~xlim ~yoff:ymid ~ylim ~find_minimal:hi_minimal)
  in
  loop ~xoff:0 ~xlim:n ~yoff:0 ~ylim:m ~find_minimal:false;
  chng1, chng2
;;

let make_indexer hashable a b =
  let n = Array.length a in
  let htb = Hashtbl.create hashable ~size:(10 * Array.length b) in
  Array.iteri
    ~f:(fun i e ->
      match Hashtbl.find htb e with
      | Some v -> b.(i) <- v
      | None -> Hashtbl.add_exn htb ~key:e ~data:e)
    b;
  let ai = Array.create ~len:n 0 in
  let k =
    let rec loop i k =
      if i = n
      then k
      else (
        let k =
          match Hashtbl.find htb a.(i) with
          | Some v ->
            a.(i) <- v;
            ai.(k) <- i;
            k + 1
          | None -> k
        in
        loop (i + 1) k)
    in
    loop 0 0
  in
  Array.sub ai ~pos:0 ~len:k
;;

let f ~cutoff ~hashable a b =
  let ai = make_indexer hashable a b in
  let bi = make_indexer hashable b a in
  let n = Array.length ai in
  let m = Array.length bi in
  diff_loop ~cutoff a ai b bi n m
;;

let iter_matches ?cutoff ~f:ff ~hashable a b =
  let d1, d2 = f ~cutoff ~hashable a b in
  let rec aux i1 i2 =
    if i1 >= Array.length d1 || i2 >= Array.length d2
    then ()
    else if not d1.(i1)
    then
      if not d2.(i2)
      then (
        ff (i1, i2);
        aux (i1 + 1) (i2 + 1))
      else aux i1 (i2 + 1)
    else if not d2.(i2)
    then aux (i1 + 1) i2
    else aux (i1 + 1) (i2 + 1)
  in
  aux 0 0
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
