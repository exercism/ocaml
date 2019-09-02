open Base
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let (* SUITE equilateral_triangle *)equilateral_tests = [
(* TEST
   "$description" >::
     ae $expected (is_equilateral $sides);
   END TEST *)
]
(* END SUITE *)
let (* SUITE isosceles_triangle *)isosceles_tests = [
(* TEST
   "$description" >::
     ae $expected (is_isosceles $sides);
   END TEST *)
]
(* END SUITE *)
let (* SUITE scalene_triangle *)scalene_tests = [
(* TEST
   "$description" >::
     ae $expected (is_scalene $sides);
   END TEST *)
]
(* END SUITE *)

let () =
  run_test_tt_main (
    "triangle tests" >:::
      List.concat [equilateral_tests; isosceles_tests; scalene_tests]
  )
