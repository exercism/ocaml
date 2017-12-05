open OUnit2
open Bob

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests = [
(* TEST
   "$description" >::
      ae $expected (response_for $input);
   END TEST *)
]

let () =
  run_test_tt_main ("bob tests" >::: tests)
