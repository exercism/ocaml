open Base
open OUnit2
open Collatz_conjecture

let ae expected actual _ctx = assert_equal expected actual

let tests = [
  {{#cases}}
    "{{description}}" >::
      {{#input}}ae {{expected}} (collatz_conjecture {{n}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("collatz_conjecture tests" >::: tests)