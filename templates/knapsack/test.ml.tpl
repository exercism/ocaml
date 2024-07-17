open Base
open Knapsack
open OUnit2

let ae exp got _test_ctxt = assert_equal exp got ~printer:(Int.to_string) 

let tests = [
{{#cases}}
    "{{description}}" >::
    ae {{#input}}{{expected}} (Knapsack.maximum_value {{items}} {{maximumWeight}}{{/input}});
{{/cases}}
]

let () =
  run_test_tt_main ("knapsack tests" >::: tests)
