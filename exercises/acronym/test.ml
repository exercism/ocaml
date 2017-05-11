open Core.Std
open OUnit2
open Acronym

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Fn.id

let tests = [
  "basic" >::
    ae "PNG" (acronym "Portable Network Graphics");
  "lowercase words" >::
    ae "ROR" (acronym "Ruby on Rails");
  "camelcase" >::
    ae "HTML" (acronym "HyperText Markup Language");
  "punctuation" >::
    ae "FIFO" (acronym "First In, First Out");
  "all caps words" >::
    ae "PHP" (acronym "PHP: Hypertext Preprocessor");
  "non-acronym all caps word" >::
    ae "GIMP" (acronym "GNU Image Manipulation Program");
  "hyphenated" >::
    ae "CMOS" (acronym "Complementary metal-oxide semiconductor");
]

let () =
  run_test_tt_main ("acronym tests" >::: tests)