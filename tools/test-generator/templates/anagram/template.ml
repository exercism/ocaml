open Core.Std
open OUnit2
open Anagram

let ae exp got _test_ctxt =
  let printer = List.to_string ~f:String.to_string in
  assert_equal exp got ~cmp:(List.equal ~equal:String.equal) ~printer

let tests = [
(* TEST
  "$description" >::
    ae $expected (anagrams "$subject" $candidates);
   END TEST *)
]

let () =
  run_test_tt_main ("anagrams tests" >::: tests)
