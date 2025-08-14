open OUnit2
open Nth_prime

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok m -> Printf.sprintf "Ok \"%d\"" m

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  {{#cases}}
    "{{description}}" >::
      ae {{#input}}{{{expected}}} (nth_prime ({{number}})){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("nth-prime tests" >::: tests)