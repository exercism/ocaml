open OUnit2
open Isbn_verifier

let ae exp got _test_ctxt = assert_equal ~printer:string_of_bool exp got

let tests = [
  "valid isbn" >::
  ae true (isValid "3-598-21508-8");
  "invalid isbn check digit" >::
  ae false (isValid "3-598-21508-9");
  "valid isbn with a check digit of 10" >::
  ae true (isValid "3-598-21507-X");
  "check digit is a character other than X" >::
  ae false (isValid "3-598-21507-A");
  "invalid check digit in isbn is not treated as zero" >::
  ae false (isValid "4-598-21507-B");
  "invalid character in isbn is not treated as zero" >::
  ae false (isValid "3-598-P1581-X");
  "X is only valid as a check digit" >::
  ae false (isValid "3-598-2X507-9");
  "valid isbn without separating dashes" >::
  ae true (isValid "3598215088");
  "isbn without separating dashes and X as check digit" >::
  ae true (isValid "359821507X");
  "isbn without check digit and dashes" >::
  ae false (isValid "359821507");
  "too long isbn and no dashes" >::
  ae false (isValid "3598215078X");
  "too short isbn" >::
  ae false (isValid "00");
  "isbn without check digit" >::
  ae false (isValid "3-598-21507");
  "check digit of X should not be used for 0" >::
  ae false (isValid "3-598-21515-X");
  "empty isbn" >::
  ae false (isValid "");
  "input is 9 characters" >::
  ae false (isValid "134456729");
  "invalid characters are not ignored after checking length" >::
  ae false (isValid "3132P34035");
  "invalid characters are not ignored before checking length" >::
  ae false (isValid "3598P215088");
  "input is too long but contains a valid isbn" >::
  ae false (isValid "98245726788");
]

let () =
  run_test_tt_main ("isbn-verifier tests" >::: tests)
