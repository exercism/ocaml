open OUnit2
open Isbn_verifier

let ae exp got _test_ctxt = assert_equal ~printer:string_of_bool exp got

let tests = [
  {{#cases}}
    "{{description}}" >::
      ae {{#input}}{{expected}} (isValid {{isbn}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("isbn-verifier tests" >::: tests)