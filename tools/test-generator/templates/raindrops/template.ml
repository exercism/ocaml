open Core.Std
open OUnit2
open Raindrops

let ae exp got _test_ctxt = assert_equal ~printer:Fn.id exp got

let tests = [
(* TEST
   "$description" >::
      ae "$expected" (raindrop $number);
   END TEST *)
]

let () =
  run_test_tt_main ("raindrops tests" >::: tests)
