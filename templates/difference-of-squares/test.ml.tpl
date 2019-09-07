open OUnit2
open Difference_of_squares

let ae exp got _test_ctxt = assert_equal exp got

{{#cases}}
  let {{slug}}_tests = [
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{expected}} ({{property}} {{number}}){{/input}};
    {{/cases}}
  ]
{{/cases}}

let () =
  run_test_tt_main (
    "difference of squares tests" >:::
      List.concat [
        {{#cases}}
          {{slug}}_tests;
        {{/cases}}
      ]
  )
