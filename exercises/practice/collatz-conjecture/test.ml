open OUnit2
open Collatz_conjecture

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok n -> Printf.sprintf "Ok %d" n

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  "zero steps for one" >::
  ae (Ok 0) (collatz_conjecture (1));
  "divide if even" >::
  ae (Ok 4) (collatz_conjecture (16));
  "even and odd steps" >::
  ae (Ok 9) (collatz_conjecture (12));
  "large number of even and odd steps" >::
  ae (Ok 152) (collatz_conjecture (1000000));
  "zero is an error" >::
  ae (Error "Only positive integers are allowed") (collatz_conjecture (0));
  "negative value is an error" >::
  ae (Error "Only positive integers are allowed") (collatz_conjecture (-15));
]

let () =
  run_test_tt_main ("collatz-conjecture tests" >::: tests)
