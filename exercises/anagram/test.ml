(* anagram - 1.4.1 *)
open Base
open OUnit2
open Anagram

let ae exp got _test_ctxt =
  let printer = String.concat ~sep:";" in
  assert_equal exp got ~printer

let tests = [
  "no matches" >::
  ae [] (anagrams "diaper" ["hello"; "world"; "zombies"; "pants"]);
  "detects two anagrams" >::
  ae ["stream"; "maters"] (anagrams "master" ["stream"; "pigeon"; "maters"]);
  "does not detect anagram subsets" >::
  ae [] (anagrams "good" ["dog"; "goody"]);
  "detects anagram" >::
  ae ["inlets"] (anagrams "listen" ["enlists"; "google"; "inlets"; "banana"]);
  "detects three anagrams" >::
  ae ["gallery"; "regally"; "largely"] (anagrams "allergy" ["gallery"; "ballerina"; "regally"; "clergy"; "largely"; "leading"]);
  "does not detect non-anagrams with identical checksum" >::
  ae [] (anagrams "mass" ["last"]);
  "detects anagrams case-insensitively" >::
  ae ["Carthorse"] (anagrams "Orchestra" ["cashregister"; "Carthorse"; "radishes"]);
  "detects anagrams using case-insensitive subject" >::
  ae ["carthorse"] (anagrams "Orchestra" ["cashregister"; "carthorse"; "radishes"]);
  "detects anagrams using case-insensitive possible matches" >::
  ae ["Carthorse"] (anagrams "orchestra" ["cashregister"; "Carthorse"; "radishes"]);
  "does not detect an anagram if the original word is repeated" >::
  ae [] (anagrams "go" ["go Go GO"]);
  "anagrams must use all letters exactly once" >::
  ae [] (anagrams "tapper" ["patter"]);
  "words are not anagrams of themselves (case-insensitive)" >::
  ae [] (anagrams "BANANA" ["BANANA"; "Banana"; "banana"]);
]

let () =
  run_test_tt_main ("anagrams tests" >::: tests)
