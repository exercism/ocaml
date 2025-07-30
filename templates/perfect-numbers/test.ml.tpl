open OUnit2
open Perfect_numbers

let option_printer = function
  | Error m  -> Printf.sprintf "Error \"%s\"" m
  | Ok m -> Printf.sprintf "Ok \"%s\"" m

let ae exp got _test_ctxt = assert_equal ~printer:option_printer exp got

let tests = [
  {{#cases}}
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{{expected}}} (classify {{{number}}}){{/input}};
    {{/cases}}
  {{/cases}}
]

let () =
  run_test_tt_main ("perfect-numbers tests" >::: tests)