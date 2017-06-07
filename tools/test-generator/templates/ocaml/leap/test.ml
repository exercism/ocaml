open Core
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got

let tests = [
(* TEST
  "$description" >::
    ae $expected (leap_year $input);
END TEST *)
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
