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
    ae (Some "1234567890") (number "(123) 456-7890");
  "cleans numbers with dots" >::
    ae (Some "1234567890") (number "123.456.7890");
  "cleans numbers with multiple spaces" >::
    ae (Some "1234567890") (number "123 456   7890   ");
  "invalid when 9 digits" >::
    ae None (number "123456789");
  "invalid when 11 digits" >::
    ae None (number "21234567890");
  "valid when 11 digits and starting with 1" >::
    ae (Some "1234567890") (number "11234567890");
  "invalid when 12 digits" >::
    ae None (number "321234567890");
  "invalid with letters" >::
    ae None (number "123-abc-7890");
  "invalid with punctuations" >::
    ae None (number "123-@:!-7890");
  "invalid with right number of digits but letters mixed in" >::
    ae None (number "1a2b3c4d5e6f7g8h9i0j");
]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)