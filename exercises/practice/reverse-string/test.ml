open Base
open OUnit2
open Reverse_string

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let tests = [
  "an empty string" >::
  ae "" (reverse_string "");
  "a word" >::
  ae "tobor" (reverse_string "robot");
  "a capitalized word" >::
  ae "nemaR" (reverse_string "Ramen");
  "a sentence with punctuation" >::
  ae "!yrgnuh m'I" (reverse_string "I'm hungry!");
  "a palindrome" >::
  ae "racecar" (reverse_string "racecar");
  "an even-sized word" >::
  ae "reward" (reverse_string "drawer");
]

let () =
  run_test_tt_main ("reverse-string tests" >::: tests)
