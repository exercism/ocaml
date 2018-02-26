(* Test/exercise version: "1.3.0" *)

open Core
open OUnit2
open Acronym

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Fn.id

let tests = [
  "basic" >::
    ae "PNG" (acronym "Portable Network Graphics");
  "lowercase words" >::
    ae "ROR" (acronym "Ruby on Rails");
  "punctuation" >::
    ae "FIFO" (acronym "First In, First Out");
  "all caps word" >::
    ae "GIMP" (acronym "GNU Image Manipulation Program");
  "punctuation without whitespace" >::
    ae "CMOS" (acronym "Complementary metal-oxide semiconductor");
]

let () =
  run_test_tt_main ("acronym tests" >::: tests)