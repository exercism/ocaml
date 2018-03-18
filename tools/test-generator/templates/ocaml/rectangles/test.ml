open OUnit2
open Rectangles

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_int

let tests = [
(* TEST
   "$description" >::
      ae $expected (count_rectangles $strings);
   END TEST *)
]

let () =
  run_test_tt_main ("rectangles tests" >::: tests)
