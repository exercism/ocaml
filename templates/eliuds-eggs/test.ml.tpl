open OUnit2
open Eliuds_eggs

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:string_of_int

let tests = [
{{#cases}}
  "{{description}}" >::
    ae {{#input}}{{expected}} (egg_count {{number}}){{/input}};
{{/cases}}
]

let () =
  run_test_tt_main ("eliuds-eggs tests" >::: tests)
