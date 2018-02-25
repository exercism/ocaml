open Core
open OUnit2
open Rectangles

let ae exp got _test_ctxt = assert_equal exp got ~printer:Int.to_string

let tests = [
(* TEST
   "$description" >::
      ae $expected (count_rectangles $strings);
   END TEST *)
]

let () =
  run_test_tt_main ("rectangles tests" >::: tests)
