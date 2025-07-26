open OUnit2
open Collatz_conjecture

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok n -> Printf.sprintf "Ok %d" n

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  {{#cases}}
    "{{description}}" >::
      ae {{#input}}{{expected}} (collatz_conjecture ({{number}})){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("collatz-conjecture tests" >::: tests)