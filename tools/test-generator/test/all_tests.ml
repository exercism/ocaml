open Core.Std
open OUnit2
open Codegen_test
open Parser_test
open Test_generator_test
open Utils_test

let () =
  run_test_tt_main ("tests" >:::List.concat [codegen_tests; parser_tests; test_generator_tests; utils_tests])
