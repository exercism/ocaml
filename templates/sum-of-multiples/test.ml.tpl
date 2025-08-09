open OUnit2
open Sum_of_multiples

let ae expected actual _test_ctxt =
  assert_equal expected actual ~printer:string_of_int

let tests = [
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{expected}} (sum_of_multiples ({{factors}}) ({{limit}})){{/input}};
    {{/cases}}
]

let () =
  run_test_tt_main ("sum-of-multiples tests" >::: tests)
