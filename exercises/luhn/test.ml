open Base
open OUnit2
open Luhn

let assert_valid expected input _test_ctxt = 
  assert_equal ~printer:Bool.to_string expected (valid input)

let tests = [
  "single digit strings can not be valid" >::
  assert_valid false "1";
  "a single zero is invalid" >::
  assert_valid false "0";
  "a simple valid SIN that remains valid if reversed" >::
  assert_valid true "059";
  "a simple valid SIN that becomes invalid if reversed" >::
  assert_valid true "59";
  "a valid Canadian SIN" >::
  assert_valid true "055 444 285";
  "invalid Canadian SIN" >::
  assert_valid false "055 444 286";
  "invalid credit card" >::
  assert_valid false "8273 1232 7352 0569";
  "valid number with an even number of digits" >::
  assert_valid true "095 245 88";
  "valid number with an odd number of spaces" >::
  assert_valid true "234 567 891 234";
  "valid strings with a non-digit added at the end become invalid" >::
  assert_valid false "059a";
  "valid strings with punctuation included become invalid" >::
  assert_valid false "055-444-285";
  "valid strings with symbols included become invalid" >::
  assert_valid false "055# 444$ 285";
  "single zero with space is invalid" >::
  assert_valid false " 0";
  "more than a single zero is valid" >::
  assert_valid true "0000 0";
  "input digit 9 is correctly converted to output digit 9" >::
  assert_valid true "091";
  "using ascii value for non-doubled non-digit isn't allowed" >::
  assert_valid false "055b 444 285";
  "using ascii value for doubled non-digit isn't allowed" >::
  assert_valid false ":9";
]

let () =
  run_test_tt_main ("luhn tests" >::: tests)