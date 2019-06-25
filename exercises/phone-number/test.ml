open Base
open OUnit2
open Phone_number

let result_to_string f = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok x -> f x |> Printf.sprintf "Ok %s"

let ae exp got _test_ctxt =
  assert_equal ~printer:(result_to_string Fn.id) exp got

let tests = [
  "cleans the number" >::
    ae (Ok "2234567890") (number "(223) 456-7890");
  "cleans numbers with dots" >::
    ae (Ok "2234567890") (number "223.456.7890");
  "cleans numbers with multiple spaces" >::
    ae (Ok "2234567890") (number "223 456   7890   ");
  "invalid when 9 digits" >::
    ae (Error "incorrect number of digits") (number "123456789");
  "invalid when 11 digits does not start with a 1" >::
    ae (Error "11 digits must start with 1") (number "22234567890");
  "valid when 11 digits and starting with 1" >::
    ae (Ok "2234567890") (number "12234567890");
  "valid when 11 digits and starting with 1 even with punctuation" >::
    ae (Ok "2234567890") (number "+1 (223) 456-7890");
  "invalid when more than 11 digits" >::
    ae (Error "more than 11 digits") (number "321234567890");
  "invalid with letters" >::
    ae (Error "letters not permitted") (number "123-abc-7890");
  "invalid with punctuations" >::
    ae (Error "punctuations not permitted") (number "123-@:!-7890");
  "invalid if area code starts with 0" >::
    ae (Error "area code cannot start with zero") (number "(023) 456-7890");
  "invalid if area code starts with 1" >::
    ae (Error "area code cannot start with one") (number "(123) 456-7890");
  "invalid if exchange code starts with 0" >::
    ae (Error "exchange code cannot start with zero") (number "(223) 056-7890");
  "invalid if exchange code starts with 1" >::
    ae (Error "exchange code cannot start with one") (number "(223) 156-7890");
  "invalid if area code starts with 0 on valid 11-digit number" >::
    ae (Error "area code cannot start with zero") (number "1 (023) 456-7890");
  "invalid if area code starts with 1 on valid 11-digit number" >::
    ae (Error "area code cannot start with one") (number "1 (123) 456-7890");
  "invalid if exchange code starts with 0 on valid 11-digit number" >::
    ae (Error "exchange code cannot start with zero") (number "1 (223) 056-7890");
  "invalid if exchange code starts with 1 on valid 11-digit number" >::
    ae (Error "exchange code cannot start with one") (number "1 (223) 156-7890");
]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)