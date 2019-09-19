open Base
open OUnit2
open Matching_brackets

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let tests = [
  {{#cases}}
    "{{description}}" >::
    ae {{#input}}{{expected}} (are_balanced {{value}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("{{name}} tests" >::: tests)
