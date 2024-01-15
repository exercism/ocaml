open Base
open OUnit2
open Reverse_string

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let tests = [
{{#cases}}
   "{{description}}" >::
      ae {{#input}}{{expected}} (reverse_string {{value}}){{/input}};
   {{/cases}}
]

let () =
  run_test_tt_main ("reverse-string tests" >::: tests)
