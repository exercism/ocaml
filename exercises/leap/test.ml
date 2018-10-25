open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_bool

let tests = [
  "year not divisible by 4: common year" >::
    ae false (leap_year 2015);
  "year divisible by 4, not divisible by 100: leap year" >::
    ae true (leap_year 1996);
  "year divisible by 100, not divisible by 400: common year" >::
    ae false (leap_year 2100);
  "year divisible by 400: leap year" >::
    ae true (leap_year 2000);
  "year divisible by 200, not divisible by 400: common year" >::
    ae false (leap_year 1800);
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
