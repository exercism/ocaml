open OUnit2
open Two_fer

let ae exp got _test_ctxt =
  assert_equal exp got

let tests = [
  {{#cases}}
    "{{description}}" >::
    ae {{#input}}{{expected}} (two_fer {{name}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("Two-fer tests" >::: tests)
