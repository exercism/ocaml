(* leap - 1.5.1 *)
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_bool

let tests = [
  "year not divisible by 4 in common year" >::
  ae false (leap_year 2015);
  "year divisible by 2, not divisible by 4 in common year" >::
  ae false (leap_year 1970);
  "year divisible by 4, not divisible by 100 in leap year" >::
  ae true (leap_year 1996);
  "year divisible by 100, not divisible by 400 in common year" >::
  ae false (leap_year 2100);
  "year divisible by 400 in leap year" >::
  ae true (leap_year 2000);
  "year divisible by 200, not divisible by 400 in common year" >::
  ae false (leap_year 1800);
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
