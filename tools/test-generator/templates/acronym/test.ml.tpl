open OUnit2
open Acronym

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:(fun x -> x )

let tests = [
(* TEST
  "$description" >::
    ae $expected (acronym $phrase);
   END TEST *)
]

let () =
  run_test_tt_main ("acronym tests" >::: tests)
