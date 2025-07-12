open Base
open OUnit2
open Darts

let ae exp got _test_ctxt =
  let printer = Int.to_string in
  assert_equal exp got ~printer

let tests = [
{{#cases}}
    "{{description}}" >::
    ae {{#input}}{{expected}} ({{property}} ({{x}}) ({{y}})){{/input}};
{{/cases}}
]

let () =
  run_test_tt_main ("darts tests" >::: tests)