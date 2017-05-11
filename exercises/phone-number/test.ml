open Core.Std
open OUnit2
open Phone_number

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string String.to_string) exp got

let tests = [
  "cleans the number" >::
    ae (Some "2234567890") (number "(223) 456-7890");
  "cleans numbers with dots" >::
    ae (Some "2234567890") (number "223.456.7890");
  "cleans numbers with multiple spaces" >::
    ae (Some "2234567890") (number "223 456   7890   ");
  "invalid when 9 digits" >::
    ae None (number "123456789");
  "invalid when 11 digits does not start with a 1" >::
    ae None (number "22234567890");
  "valid when 11 digits and starting with 1" >::
    ae (Some "2234567890") (number "12234567890");
  "valid when 11 digits and starting with 1 even with punctuation" >::
    ae (Some "2234567890") (number "+1 (223) 456-7890");
  "invalid when more than 11 digits" >::
    ae None (number "321234567890");
  "invalid with letters" >::
    ae None (number "123-abc-7890");
  "invalid with punctuations" >::
    ae None (number "123-@:!-7890");
  "invalid if area code does not start with 2-9" >::
    ae None (number "(123) 456-7890");
  "invalid if exchange code does not start with 2-9" >::
    ae None (number "(223) 056-7890");
]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)