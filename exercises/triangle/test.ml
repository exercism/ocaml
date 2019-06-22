open Base
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

let equilateral_tests = [
  "all sides are equal" >::
  ae true (is_equilateral 2.0 2.0 2.0);
  "any side is unequal" >::
  ae false (is_equilateral 2.0 3.0 2.0);
  "no sides are equal" >::
  ae false (is_equilateral 5.0 4.0 6.0);
  "all zero sides is not a triangle" >::
  ae false (is_equilateral 0.0 0.0 0.0);
  "sides may be floats" >::
  ae true (is_equilateral 0.5 0.5 0.5);
]


let isosceles_tests = [
  "last two sides are equal" >::
  ae true (is_isosceles 3.0 4.0 4.0);
  "first two sides are equal" >::
  ae true (is_isosceles 4.0 4.0 3.0);
  "first and last sides are equal" >::
  ae true (is_isosceles 4.0 3.0 4.0);
  "equilateral triangles are also isosceles" >::
  ae true (is_isosceles 4.0 4.0 4.0);
  "no sides are equal" >::
  ae false (is_isosceles 2.0 3.0 4.0);
  "first triangle inequality violation" >::
  ae false (is_isosceles 1.0 1.0 3.0);
  "second triangle inequality violation" >::
  ae false (is_isosceles 1.0 3.0 1.0);
  "third triangle inequality violation" >::
  ae false (is_isosceles 3.0 1.0 1.0);
  "sides may be floats" >::
  ae true (is_isosceles 0.5 0.4 0.5);
]


let scalene_tests = [
  "no sides are equal" >::
  ae true (is_scalene 5.0 4.0 6.0);
  "all sides are equal" >::
  ae false (is_scalene 4.0 4.0 4.0);
  "two sides are equal" >::
  ae false (is_scalene 4.0 4.0 3.0);
  "may not violate triangle inequality" >::
  ae false (is_scalene 7.0 3.0 2.0);
  "sides may be floats" >::
  ae true (is_scalene 0.5 0.4 0.6);
]

let () =
  run_test_tt_main (
    "triangle tests" >:::
    List.concat [equilateral_tests; isosceles_tests; scalene_tests]
  )