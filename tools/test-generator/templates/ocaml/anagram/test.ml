open Base
open OUnit2
open Anagram

let ae exp got _test_ctxt =
  let printer = String.concat ~sep:";" in
  assert_equal exp got ~printer

let tests = [
(* TEST
  "$description" >::
    ae $expected (anagrams $subject $candidates);
   END TEST *)
]

let () =
  run_test_tt_main ("anagrams tests" >::: tests)
