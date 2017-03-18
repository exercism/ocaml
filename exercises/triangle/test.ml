open Core.Std
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let equilateral_tests = [
   "true if all sides are equal" >::
     ae true (is_equilateral [2; 2; 2]);
   "false if any side is unequal" >::
     ae false (is_equilateral [2; 3; 2]);
   "false if no sides are equal" >::
     ae false (is_equilateral [5; 4; 6]);
   "All zero sides are illegal, so the triangle is not equilateral" >::
     ae false (is_equilateral [0; 0; 0]);
]

let isoceles_tests = [
   "true if last two sides are equal" >::
     ae true (is_isoceles [3; 4; 4]);
   "true if first two sides are equal" >::
     ae true (is_isoceles [4; 4; 3]);
   "true if first and last sides are equal" >::
     ae true (is_isoceles [4; 3; 4]);
   "equilateral triangles are also isosceles" >::
     ae true (is_isoceles [4; 4; 4]);
   "false if no sides are equal" >::
     ae false (is_isoceles [2; 3; 4]);
   "Sides that violate triangle inequality are not isosceles, even if two are equal" >::
     ae false (is_isoceles [1; 1; 3]);
]

let scalene_tests = [
   "true if no sides are equal" >::
     ae true (is_scalene [5; 4; 6]);
   "false if all sides are equal" >::
     ae false (is_scalene [4; 4; 4]);
   "false if two sides are equal" >::
     ae false (is_scalene [4; 4; 3]);
   "Sides that violate triangle inequality are not scalene, even if they are all different" >::
     ae false (is_scalene [7; 3; 2]);
]

let () =
  run_test_tt_main (
    "triangle tests" >:::
      List.concat [equilateral_tests; isoceles_tests; scalene_tests]
  )