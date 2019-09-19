(* {{name}} - {{version}} *)
open Base
open OUnit2
open Triangle

let ae exp got _test_ctxt = assert_equal exp got ~printer:Bool.to_string

{{#cases}}
  let {{slug}}_tests = [
    {{#cases}}
    "{{description}}" >::
      ae {{#input}}{{expected}} (is_{{property}} {{sides}}){{/input}};
    {{/cases}}
  ]
{{/cases}}

let () =
  run_test_tt_main (
    "triangle tests" >:::
      List.concat [
        {{#cases}}
          {{slug}}_tests;
        {{/cases}}
      ]
  )
