[@@@ocaml.text
  " This is a port of Bram Cohen's patience diff algorithm, as found in the Bazaar 1.14.1\n\
  \    source code, available at http://bazaar-vcs.org.\n\n\
  \    This copyright notice was included:\n\n\
  \    # Copyright (C) 2005 Bram Cohen, Copyright (C) 2005, 2006 Canonical Ltd\n\
  \    #\n\
  \    # This program is free software; you can redistribute it and/or modify\n\
  \    # it under the terms of the GNU General Public License as published by\n\
  \    # the Free Software Foundation; either version 2 of the License, or\n\
  \    # (at your option) any later version.\n\
  \    #\n\
  \    # This program is distributed in the hope that it will be useful,\n\
  \    # but WITHOUT ANY WARRANTY; without even the implied warranty of\n\
  \    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n\
  \    # GNU General Public License for more details.\n\
  \    #\n\
  \    # You should have received a copy of the GNU General Public License\n\
  \    # along with this program; if not, write to the Free Software\n\
  \    # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA\n"]

[@@@ocaml.text
  " Bram Cohen's comment from the original Python code (with syntax changed to OCaml):\n\n\
  \    [get_matching_blocks a b] returns a list of triples describing matching\n\
  \    subsequences.\n\n\
  \    Each triple is of the form (i, j, n), and means that\n\
  \    a <|> (i,i+n) = b <|> (j,j+n).  The triples are monotonically increasing in\n\
  \    i and in j.\n\n\
  \    The last triple is a dummy, (Array.length a, Array.length b, 0), and is the only\n\
  \    triple with n=0.\n\n\
  \    Example:\n\
  \    get_matching_blocks [|\"a\";\"b\";\"x\";\"c\";\"d\"|] [|\"a\";\"b\";\"c\";\"d\"|]\n\
  \    returns\n\
  \    [(0, 0, 2), (3, 2, 2), (5, 4, 0)]\n"]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patience_diff_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patience_diff_intf.ml.before-ppx"
;;

open! Core
module Hunk = Hunk
module Hunks = Hunks
module Matching_block = Matching_block
module Range = Range
module Move_id = Move_id

module type S = sig
  type elt

  val get_matching_blocks
    :  transform:('a -> elt)
    -> ?big_enough:int
    -> ?max_slide:int
    -> ?score:([ `left | `right ] -> 'a -> 'a -> int)
    -> prev:'a array
    -> next:'a array
    -> unit
    -> Matching_block.t list
  [@@ocaml.doc
    " Get_matching_blocks not only aggregates the data from [matches a b] but also\n\
    \      attempts to remove random, semantically meaningless matches (\"semantic \
     cleanup\").\n\
    \      The value of [big_enough] governs how aggressively we do so.  See [get_hunks]\n\
    \      below for more details. "]

  val matches : elt array -> elt array -> (int * int) list
  [@@ocaml.doc
    " [matches a b] returns a list of pairs (i,j) such that a.(i) = b.(j) and such that\n\
    \      the list is strictly increasing in both its first and second coordinates.  \
     This is\n\
    \      essentially a \"unfolded\" version of what [get_matching_blocks] returns. \
     Instead of\n\
    \      grouping the consecutive matching block using [length] this function would \
     return\n\
    \      all the pairs (prev_start * next_start). "]

  val match_ratio : elt array -> elt array -> float
  [@@ocaml.doc
    " [match_ratio a b] computes the ratio defined as:\n\n\
    \      {[\n\
    \        2 * len (matches a b) / (len a + len b)\n\
    \      ]}\n\n\
    \      It is an indication of how much alike a and b are.  A ratio closer to 1.0 will\n\
    \      indicate a number of matches close to the number of elements that can \
     potentially\n\
    \      match, thus is a sign that a and b are very much alike.  On the next hand, a \
     low\n\
    \      ratio means very little match. "]

  val get_hunks
    :  transform:('a -> elt)
    -> context:int
    -> ?big_enough:int
    -> ?max_slide:int
    -> ?score:([ `left | `right ] -> 'a -> 'a -> int)
    -> prev:'a array
    -> next:'a array
    -> unit
    -> 'a Hunk.t list
  [@@ocaml.doc
    " [get_hunks ~transform ~context ~prev ~next] will compare the arrays [prev] and\n\
    \      [next] and produce a list of hunks. (The hunks will contain Same ranges of at \
     most\n\
    \      [context] elements.)  Negative [context] is equivalent to infinity (producing a\n\
    \      singleton hunk list).  The value of [big_enough] governs how aggressively we \
     try to\n\
    \      clean up spurious matches, by restricting our attention to only matches of \
     length\n\
    \      less than [big_enough].  Thus, setting [big_enough] to a higher value results \
     in\n\
    \      more aggressive cleanup, and the default value of 1 results in no cleanup at \
     all.\n\
    \      When this function is called by [Patdiff_core], the value of [big_enough] is \
     3 at\n\
    \      the line level, and 7 at the word level.\n\n\
    \      The value of [max_slide] controls how far we are willing to shift a diff \
     (which is\n\
    \      immediately preceded/followed by the same lines as it ends/starts with). We \
     choose\n\
    \      between equivalent positions by maximising the sum of the [score] function \
     applied\n\
    \      to the two boundaries of the diff. By default, [max_slide] is 0. The arguments\n\
    \      passed to [score] are firstly whether the boundary is at the start or end of \
     the\n\
    \      diff and then the values on either side of the boundary (if a boundary is \
     considered\n\
    \      at the start or end of the input, it gets a score of 100). "]

  type 'a segment =
    | Same of 'a array
    | Different of 'a array array

  type 'a merged_array = 'a segment list

  val merge : elt array array -> elt merged_array
end

module type Patience_diff = sig
  module Hunk = Hunk
  module Hunks = Hunks
  module Matching_block = Matching_block
  module Range = Range
  module Move_id = Move_id
  module Make : functor (Elt : Hashtbl.Key) -> S with type elt = Elt.t
  module String : S with type elt = string

  module Stable : sig
    module Hunk = Hunk.Stable
    module Hunks = Hunks.Stable
    module Matching_block = Matching_block.Stable
    module Range = Range.Stable
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
