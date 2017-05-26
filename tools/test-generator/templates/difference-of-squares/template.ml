open Core
open OUnit2
open Difference_of_squares

let ae exp got _test_ctxt = assert_equal exp got

let (* SUITE square_the_sum_of_the_numbers_up_to_the_given_number *)square_of_sum_tests = [
(* TEST
   "$description" >::
     ae $expected (square_of_sum $number);
   END TEST *)
]
(* END SUITE *)
let (* SUITE sum_the_squares_of_the_numbers_up_to_the_given_number *)sum_of_squares_tests = [
(* TEST
   "$description" >::
     ae $expected (sum_of_squares $number);
   END TEST *)
]
(* END SUITE *)
let (* SUITE subtract_sum_of_squares_from_square_of_sums *)difference_of_squares_tests = [
(* TEST
   "$description" >::
     ae $expected (difference_of_squares $number);
   END TEST *)
]
(* END SUITE *)

let () =
  run_test_tt_main (
    "difference of squares tests" >:::
      List.concat [square_of_sum_tests; sum_of_squares_tests; difference_of_squares_tests]
  )
