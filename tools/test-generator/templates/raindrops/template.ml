open Core.Std
open OUnit2
open Raindrops

let ae exp got _test_ctxt = assert_equal ~printer:Fn.id exp got

let tests = [
(* GENERATED-CODE
   "$description" >::
      ae "$expected" (raindrop $number);
   END GENERATED-CODE *)
]

let () =
  run_test_tt_main ("raindrops tests" >::: tests)
