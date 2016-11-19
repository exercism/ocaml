open Core.Std
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got

let tests = [
  "leap year" >::
    ae true (leap_year 1996);
  "standard and odd year" >::
    ae false (leap_year 1997);
  "standard even year" >::
    ae false (leap_year 1998);
  "standard nineteenth century" >::
    ae false (leap_year 1900);
  "standard eighteenth century" >::
    ae false (leap_year 1800);
  "leap twenty fourth century" >::
    ae true (leap_year 2400);
  "leap y2k" >::
    ae true (leap_year 2000);
]

let () =
  run_test_tt_main ("leap tests" >::: tests)