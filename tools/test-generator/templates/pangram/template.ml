open Core.Std
open OUnit2
open Pangram

let ae exp got _test_ctxt = assert_equal ~printer:Bool.to_string exp got

let tests = [
(* TEST
   "$description" >::
      ae $expected (is_pangram $input);
   END TEST *)
]

let () =
  run_test_tt_main ("pangram tests" >::: tests)
