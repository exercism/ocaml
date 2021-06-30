(* acronym - 1.7.0 *)
open OUnit2
open Acronym

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:(fun x -> x )

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
  "very long abbreviation" >::
  ae "ROTFLSHTMDCOALM" (acronym "Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me");
  "consecutive delimiters" >::
  ae "SIMUFTA" (acronym "Something - I made up from thin air");
  "apostrophes" >::
  ae "HC" (acronym "Halley's Comet");
  "underscore emphasis" >::
  ae "TRNT" (acronym "The Road _Not_ Taken");
]

let () =
  run_test_tt_main ("acronym tests" >::: tests)
