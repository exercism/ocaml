open OUnit2
open Rectangles

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_int

let tests = [
{{#cases}}
   "{{description}}" >::
      ae {{#input}}{{expected}} (count_rectangles {{strings}}){{/input}};
   {{/cases}}
]

let () =
  run_test_tt_main ("rectangles tests" >::: tests)
