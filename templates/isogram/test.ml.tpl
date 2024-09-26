open Base
open Isogram
open OUnit2

let ae exp got _test_ctxt = assert_equal exp got ~printer:(Bool.to_string) 

let tests = [
{{#cases}}
    "{{description}}" >::
    ae {{#input}}{{expected}} (is_isogram {{phrase}}{{/input}});

{{/cases}}
]

let () =
    run_test_tt_main ("isogram tests" >::: tests)
