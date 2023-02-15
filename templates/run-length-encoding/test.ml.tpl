open Base
open OUnit2
open Run_length_encoding

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

{{#cases}}
let {{slug}}_tests = [
  {{#cases}}
   "{{description}}" >::
     ae {{#input}}{{expected}} ({{string}} |> {{property}}){{/input}};
   {{/cases}}
]
{{/cases}}


let () =
  run_test_tt_main (
    "run length encoding tests" >:::
      List.concat [
        {{#cases}}
          {{slug}}_tests;
        {{/cases}}
      ]
  )
