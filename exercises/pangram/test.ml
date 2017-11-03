(* Test/exercise version: "1.3.0" *)

open Core
open OUnit2
open Pangram

let ae exp got _test_ctxt = assert_equal ~printer:Bool.to_string exp got

let tests = [
   "sentence empty" >::
      ae false (is_pangram "");
   "recognizes a perfect lower case pangram" >::
      ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
   "pangram with only lower case" >::
      ae true (is_pangram "the quick brown fox jumps over the lazy dog");
   "missing character 'x'" >::
      ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
   "another missing character, e.g. 'h'" >::
      ae false (is_pangram "five boxing wizards jump quickly at it");
   "pangram with underscores" >::
      ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
   "pangram with numbers" >::
      ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
   "missing letters replaced by numbers" >::
      ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
   "pangram with mixed case and punctuation" >::
      ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
   "upper and lower case versions of the same character should not be counted separately" >::
      ae false (is_pangram "the quick brown fox jumps over with lazy FX");
]

let () =
  run_test_tt_main ("pangram tests" >::: tests)