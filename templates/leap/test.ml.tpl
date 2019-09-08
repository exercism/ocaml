(* {{name}} - {{version}} *)
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_bool

let tests = [
{{#cases}}
  "{{description}}" >::
    ae {{#input}}{{expected}} (leap_year {{year}}){{/input}};
{{/cases}}
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
