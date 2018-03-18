open OUnit2
open Pangram

let ae exp got _test_ctxt = assert_equal ~printer:string_of_bool exp got

let tests = [
(* TEST
   "$description" >::
      ae $expected (is_pangram $sentence);
   END TEST *)
]

let () =
  run_test_tt_main ("pangram tests" >::: tests)
