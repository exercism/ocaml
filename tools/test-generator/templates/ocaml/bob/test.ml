open OUnit2
open Bob

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let tests = [
(* TEST
   "$description" >::
      ae $expected (response_for $heyBob);
   END TEST *)
]

let () =
  run_test_tt_main ("bob tests" >::: tests)
