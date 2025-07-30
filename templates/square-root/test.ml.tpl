open OUnit2
open Square_root

let ae expected actual _test_ctxt =
  assert_equal expected actual ~printer:string_of_int

let tests = [
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{expected}} (square_root ({{radicand}})){{/input}};
    {{/cases}}
]

let () =
  run_test_tt_main ("square-root tests" >::: tests)
