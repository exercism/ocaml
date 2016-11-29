open Core.Std
open OUnit2
open Bracket_push

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let tests = [
  "empty_string" >:: ae true (are_balanced "");
]

let () =
  run_test_tt_main ("bracket-push tests" >::: tests)
