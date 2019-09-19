(* {{name}} - {{version}} *)
open OUnit2
open Pangram

let ae exp got _test_ctxt = assert_equal ~printer:string_of_bool exp got

let tests = [
   {{#cases}}
      {{#cases}}
         "{{description}}" >::
            ae {{#input}}{{expected}} (is_pangram {{sentence}}){{/input}};
      {{/cases}}
   {{/cases}}
]

let () =
  run_test_tt_main ("pangram tests" >::: tests)
