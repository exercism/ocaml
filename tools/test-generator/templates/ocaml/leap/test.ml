open Core
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let tests = [
(* TEST
  "$description" >::
    ae $expected (leap_year $year);
END TEST *)
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
