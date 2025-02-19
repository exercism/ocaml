open OUnit2
open Acronym

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:(fun x -> x )

let tests = [
  {{#cases}}
    "{{description}}" >::
      {{#input}}ae {{expected}} (acronym {{phrase}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("acronym tests" >::: tests)
