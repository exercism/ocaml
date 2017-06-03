open Core
open OUnit2
open Bracket_push

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let tests = [
(* TEST
  "$description" >::
    ae $expected (are_balanced $input);
END TEST *)
]

let () =
  run_test_tt_main ("bracket-push tests" >::: tests)
