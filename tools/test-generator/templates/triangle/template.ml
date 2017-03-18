open Core.Std
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let (* SUITE returns_true_if_the_triangle_is_equilateral *)equilateral_tests = [
(* TEST
   "$description" >::
     ae $expected (is_equilateral $sides);
   END TEST *)
]
(* END SUITE *)
let (* SUITE returns_true_if_the_triangle_is_isosceles *)isoceles_tests = [
(* TEST
   "$description" >::
     ae $expected (is_isoceles $sides);
   END TEST *)
]
(* END SUITE *)
let (* SUITE returns_true_if_the_triangle_is_scalene *)scalene_tests = [
(* TEST
   "$description" >::
     ae $expected (is_scalene $sides);
   END TEST *)
]
(* END SUITE *)

let () =
  run_test_tt_main (
    "triangle tests" >:::
      List.concat [equilateral_tests; isoceles_tests; scalene_tests]
  )
