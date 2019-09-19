open Base
open OUnit2
open Model_test
open Special_cases_test

let () =
  run_test_tt_main ("tests" >:::List.concat [model_tests; special_cases_test;])
