open OUnit2
open Perfect_numbers

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok m -> Printf.sprintf "Ok \"%s\"" m

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  "Smallest perfect number is classified correctly" >::
  ae (Ok "perfect") (classify 6);
  "Medium perfect number is classified correctly" >::
  ae (Ok "perfect") (classify 28);
  "Large perfect number is classified correctly" >::
  ae (Ok "perfect") (classify 33550336);
  "Smallest abundant number is classified correctly" >::
  ae (Ok "abundant") (classify 12);
  "Medium abundant number is classified correctly" >::
  ae (Ok "abundant") (classify 30);
  "Large abundant number is classified correctly" >::
  ae (Ok "abundant") (classify 33550335);
  "Smallest prime deficient number is classified correctly" >::
  ae (Ok "deficient") (classify 2);
  "Smallest non-prime deficient number is classified correctly" >::
  ae (Ok "deficient") (classify 4);
  "Medium deficient number is classified correctly" >::
  ae (Ok "deficient") (classify 32);
  "Large deficient number is classified correctly" >::
  ae (Ok "deficient") (classify 33550337);
  "Edge case (no factors other than itself) is classified correctly" >::
  ae (Ok "deficient") (classify 1);
  "Zero is rejected (as it is not a positive integer)" >::
  ae (Error "Classification is only possible for positive integers.") (classify 0);
  "Negative integer is rejected (as it is not a positive integer)" >::
  ae (Error "Classification is only possible for positive integers.") (classify -1);
]

let () =
  run_test_tt_main ("perfect-numbers tests" >::: tests)
