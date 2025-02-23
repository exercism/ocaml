open Base
open Isogram
open OUnit2

let ae exp got _test_ctxt = assert_equal exp got ~printer:(Bool.to_string)

let tests = [
  "empty string" >::
  ae true (is_isogram "");

  "isogram with only lower case characters" >::
  ae true (is_isogram "isogram");

  "word with one duplicated character" >::
  ae false (is_isogram "eleven");

  "word with one duplicated character from the end of the alphabet" >::
  ae false (is_isogram "zzyzx");

  "longest reported english isogram" >::
  ae true (is_isogram "subdermatoglyphic");

  "word with duplicated character in mixed case" >::
  ae false (is_isogram "Alphabet");

  "word with duplicated character in mixed case, lowercase first" >::
  ae false (is_isogram "alphAbet");

  "hypothetical isogrammic word with hyphen" >::
  ae true (is_isogram "thumbscrew-japingly");

  "hypothetical word with duplicated character following hyphen" >::
  ae false (is_isogram "thumbscrew-jappingly");

  "isogram with duplicated hyphen" >::
  ae true (is_isogram "six-year-old");

  "made-up name that is an isogram" >::
  ae true (is_isogram "Emily Jung Schwartzkopf");

  "duplicated character in the middle" >::
  ae false (is_isogram "accentor");

  "same first and last characters" >::
  ae false (is_isogram "angola");

  "word with duplicated character and with two hyphens" >::
  ae false (is_isogram "up-to-date");

]

let () =
  run_test_tt_main ("isogram tests" >::: tests)
