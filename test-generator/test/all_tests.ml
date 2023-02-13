open! Core
open OUnit2
open Model_test
open Special_cases_test

let () =
  run_test_tt_main ("tests" >::: [
      "model_tests" >::: model_tests;
      "special_cases_test" >::: special_cases_test;
    ])
