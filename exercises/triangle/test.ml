open Base
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let equilateral_tests = [
   "all sides are equal" >::
     ae true (is_equilateral 2 2 2);
   "any side is unequal" >::
     ae false (is_equilateral 2 3 2);
   "no sides are equal" >::
     ae false (is_equilateral 5 4 6);
   "all zero sides is not a triangle" >::
     ae false (is_equilateral 0 0 0);
]


let isosceles_tests = [
   "last two sides are equal" >::
     ae true (is_isosceles 3 4 4);
   "first two sides are equal" >::
     ae true (is_isosceles 4 4 3);
   "first and last sides are equal" >::
     ae true (is_isosceles 4 3 4);
   "equilateral triangles are also isosceles" >::
     ae true (is_isosceles 4 4 4);
   "no sides are equal" >::
     ae false (is_isosceles 2 3 4);
   "first triangle inequality violation" >::
     ae false (is_isosceles 1 1 3);
   "second triangle inequality violation" >::
     ae false (is_isosceles 1 3 1);
   "third triangle inequality violation" >::
     ae false (is_isosceles 3 1 1);
]


let scalene_tests = [
   "no sides are equal" >::
     ae true (is_scalene 5 4 6);
   "all sides are equal" >::
     ae false (is_scalene 4 4 4);
   "two sides are equal" >::
     ae false (is_scalene 4 4 3);
   "may not violate triangle inequality" >::
     ae false (is_scalene 7 3 2);
]

let () =
  run_test_tt_main (
    "triangle tests" >:::
      List.concat [equilateral_tests; isosceles_tests; scalene_tests]
  )