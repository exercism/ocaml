open Base
open OUnit2
open Matching_brackets

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let tests = [
  "paired square brackets" >::
    ae true (are_balanced "[]");
  "empty string" >::
    ae true (are_balanced "");
  "unpaired brackets" >::
    ae false (are_balanced "[[");
  "wrong ordered brackets" >::
    ae false (are_balanced "}{");
  "wrong closing bracket" >::
    ae false (are_balanced "{]");
  "paired with whitespace" >::
    ae true (are_balanced "{ }");
  "partially paired brackets" >::
    ae false (are_balanced "{[])");
  "simple nested brackets" >::
    ae true (are_balanced "{[]}");
  "several paired brackets" >::
    ae true (are_balanced "{}[]");
  "paired and nested brackets" >::
    ae true (are_balanced "([{}({}[])])");
  "unopened closing brackets" >::
    ae false (are_balanced "{[)][]}");
  "unpaired and nested brackets" >::
    ae false (are_balanced "([{])");
  "paired and wrong nested brackets" >::
    ae false (are_balanced "[({]})");
  "math expression" >::
    ae true (are_balanced "(((185 + 223.85) * 15) - 543)/2");
  "complex latex expression" >::
    ae true (are_balanced "\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)");
]

let () =
  run_test_tt_main ("matching-brackets tests" >::: tests)
