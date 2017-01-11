open Core.Std
open OUnit2
open Luhn

let assert_valid expected input _test_ctxt = 
  assert_equal ~printer:Bool.to_string expected (valid input)

let tests = [
  "single digit strings are not valid" >::
    assert_valid false "1";
  "A single zero is invalid" >::
    assert_valid false "0";
  "valid Canadian SIN" >::
    assert_valid true "046 454 286";
  "invalid Canadian SIN" >::
    assert_valid false "046 454 287";
  "invalid credit card" >::
    assert_valid false "8273 1232 7352 0569";
  "strings that contain non-digits are not valid" >::
    assert_valid false "827a 1232 7352 0569";
]

let () =
  run_test_tt_main ("luhn tests" >::: tests)