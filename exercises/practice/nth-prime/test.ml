open OUnit2
open Nth_prime

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok m -> Printf.sprintf "Ok \"%s\"" m

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  "first prime" >::
  ae (Ok 2) (nth_prime (1));
  "second prime" >::
  ae (Ok 3) (nth_prime (2));
  "sixth prime" >::
  ae (Ok 13) (nth_prime (6));
  "big prime" >::
  ae (Ok 104743) (nth_prime (10001));
  "there is no zeroth prime" >::
  ae (Error "there is no zeroth prime") (nth_prime (0));
]

let () =
  run_test_tt_main ("nth-prime tests" >::: tests)
