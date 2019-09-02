open Base
open OUnit2
open Luhn

let assert_valid expected input _test_ctxt = 
  assert_equal ~printer:Bool.to_string expected (valid input)

let tests = [
(* TEST
  "$description" >::
    assert_valid $expected $value;
END TEST *)
]

let () =
  run_test_tt_main ("luhn tests" >::: tests)
