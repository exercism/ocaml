open Core.Std
open OUnit2
open Difference_of_squares

let ae exp got _test_ctxt = assert_equal exp got

let (* SUITE *)suite_name(* END SUITE *) = [
(* TEST
   "$description" >::
     ae $expected ($suite-name $number);
   END TEST *)
]

let () =
  run_test_tt_main ("difference of squares tests" >::: List.concat [(* suite-all-names *)])
