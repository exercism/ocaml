open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_bool

let tests = [
(* TEST
  "$description" >::
    ae $expected (leap_year $year);
END TEST *)
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
