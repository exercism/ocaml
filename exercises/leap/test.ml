open Core.Std
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got

let tests = [
  "leap year in twentieth century" >::
    ae true (leap_year 1996);
  "odd standard year in twentieth century" >::
    ae false (leap_year 1997);
  "even standard year in twentieth century" >::
    ae false (leap_year 1998);
  "standard year in nineteenth century" >::
    ae false (leap_year 1900);
  "standard year in eighteenth century" >::
    ae false (leap_year 1800);
  "leap year twenty four hundred" >::
    ae true (leap_year 2400);
  "leap year two thousand" >::
    ae true (leap_year 2000);
]

let () =
  run_test_tt_main ("leap tests" >::: tests)