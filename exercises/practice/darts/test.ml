open Base
open OUnit2
open Darts

let ae exp got _test_ctxt =
  let printer = Int.to_string in
  assert_equal exp got ~printer

let tests = [
  "Missed target" >::
    ae 0 (score (-9.0) (9.0));
  
  "On the outer circle" >::
    ae 1 (score (0.0) (10.0));
  
  "On the middle circle" >::
    ae 5 (score (-5.0) (0.0));
  
  "On the inner circle" >::
    ae 10 (score (0.0) (-1.0));
  
  "Exactly on center" >::
    ae 10 (score (0.0) (0.0));
  
  "Near the center" >::
    ae 10 (score (-0.1) (-0.1));
  
  "Just within the inner circle" >::
    ae 10 (score (0.7) (0.7));
  
  "Just outside the inner circle" >::
    ae 5 (score (0.8) (-0.8));
  
  "Just within the middle circle" >::
    ae 5 (score (-3.5) (3.5));
  
  "Just outside the middle circle" >::
    ae 1 (score (-3.6) (-3.6));
  
  "Just within the outer circle" >::
    ae 1 (score (-7.0) (7.0));
  
  "Just outside the outer circle" >::
    ae 0 (score  (7.1) (-7.1));
  
  "Asymmetric position between the inner and middle circles" >::
    ae 5 (score (0.5) (-4.0));
]

let () =
  run_test_tt_main ("darts tests" >::: tests)