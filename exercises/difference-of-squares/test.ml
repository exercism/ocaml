open Core.Std
open OUnit2
open Difference_of_squares

let ae exp got _test_ctxt = assert_equal exp got

let square_of_sum_tests = [
   "square of sum 5" >::
     ae 225 (square_of_sum 5);
   "square of sum 10" >::
     ae 3025 (square_of_sum 10);
   "square of sum 100" >::
     ae 25502500 (square_of_sum 100);
]

let sum_of_squares_tests = [
   "sum of squares 5" >::
     ae 55 (sum_of_squares 5);
   "sum of squares 10" >::
     ae 385 (sum_of_squares 10);
   "sum of squares 100" >::
     ae 338350 (sum_of_squares 100);
]

let difference_of_squares_tests = [
   "difference of squares 0" >::
     ae 0 (difference_of_squares 0);
   "difference of squares 5" >::
     ae 170 (difference_of_squares 5);
   "difference of squares 10" >::
     ae 2640 (difference_of_squares 10);
   "difference of squares 100" >::
     ae 25164150 (difference_of_squares 100);
]

let () =
  run_test_tt_main (
    "difference of squares tests" >:::
      List.concat [square_of_sum_tests; sum_of_squares_tests; difference_of_squares_tests]
  )