open Core.Std
open OUnit2
open Luhn

let assert_valid expected input _test_ctxt = 
  assert_equal ~printer:Bool.to_string expected (valid input)

let tests = [
  "single digit strings can not be valid" >::
    assert_valid false "1";
  "A single zero is invalid" >::
    assert_valid false "0";
  "simple valid sin" >::
    assert_valid true " 5 9 ";
  "valid Canadian SIN" >::
    assert_valid true "046 454 286";
  "invalid Canadian SIN" >::
    assert_valid false "046 454 287";
  "invalid credit card" >::
    assert_valid false "8273 1232 7352 0569";
  "valid strings with a non-digit added become invalid" >::
    assert_valid false "046a 454 286";
  "punctuation is not allowed" >::
    assert_valid false "055-444-285";
  "symbols are not allowed" >::
    assert_valid false "055\194\163 444$ 285";
  "single zero with space is invalid" >::
    assert_valid false " 0";
  "lots of zeros are valid" >::
    assert_valid true " 00000";
  "another valid sin" >::
    assert_valid true "055 444 285";
  "nine doubled is nine" >::
    assert_valid true "091";
]

let () =
  run_test_tt_main ("luhn tests" >::: tests)