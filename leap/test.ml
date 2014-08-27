open Core.Std
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got

let tests = ["leap year"       >:: ae true (leap_year 1996);
             "not leap year"   >:: ae false (leap_year 1997);
             "century"         >:: ae false (leap_year 1900);
             "fourth century"  >:: ae true (leap_year 2400);
            ]

let () =
  run_test_tt_main ("leap tests" >::: tests)
