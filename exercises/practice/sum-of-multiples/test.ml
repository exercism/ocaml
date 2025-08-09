open OUnit2
open Sum_of_multiples

let ae expected actual _test_ctxt =
  assert_equal expected actual ~printer:string_of_int

let tests = [
  "no multiples within limit" >::
  ae 0 (sum_of_multiples ([3; 5]) (1));
  "one factor has multiples within limit" >::
  ae 3 (sum_of_multiples ([3; 5]) (4));
  "more than one multiple within limit" >::
  ae 9 (sum_of_multiples ([3]) (7));
  "more than one factor with multiples within limit" >::
  ae 23 (sum_of_multiples ([3; 5]) (10));
  "each multiple is only counted once" >::
  ae 2318 (sum_of_multiples ([3; 5]) (100));
  "a much larger limit" >::
  ae 233168 (sum_of_multiples ([3; 5]) (1000));
  "three factors" >::
  ae 51 (sum_of_multiples ([7; 13; 17]) (20));
  "factors not relatively prime" >::
  ae 30 (sum_of_multiples ([4; 6]) (15));
  "some pairs of factors relatively prime and some not" >::
  ae 4419 (sum_of_multiples ([5; 6; 8]) (150));
  "one factor is a multiple of another" >::
  ae 275 (sum_of_multiples ([5; 25]) (51));
  "much larger factors" >::
  ae 2203160 (sum_of_multiples ([43; 47]) (10000));
  "all numbers are multiples of 1" >::
  ae 4950 (sum_of_multiples ([1]) (100));
  "no factors means an empty sum" >::
  ae 0 (sum_of_multiples ([]) (10000));
  "the only multiple of 0 is 0" >::
  ae 0 (sum_of_multiples ([0]) (1));
  "the factor 0 does not affect the sum of multiples of other factors" >::
  ae 3 (sum_of_multiples ([3; 0]) (4));
  "solutions using include-exclude must extend to cardinality greater than 3" >::
  ae 39614537 (sum_of_multiples ([2; 3; 5; 7; 11]) (10000));
]

let () =
  run_test_tt_main ("sum-of-multiples tests" >::: tests)
