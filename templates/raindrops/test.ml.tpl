open OUnit2
open Raindrops

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let tests = [
{{#cases}}
   "{{description}}" >::
      ae {{#input}}{{expected}} (raindrop {{number}}){{/input}};
   {{/cases}}
]

let () =
  run_test_tt_main ("raindrops tests" >::: tests)
