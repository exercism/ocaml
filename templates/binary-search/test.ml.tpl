open OUnit2
open Binary_search

let result_to_string f = function
  | Error m -> Printf.sprintf "Error \"%s\"" m
  | Ok x -> f x |> Printf.sprintf "Some %s"

let ae exp got _test_ctxt =
  assert_equal ~printer:(result_to_string string_of_int) exp got

let tests = [
  {{#cases}}
  "{{description}}" >::
    ae {{#input}}{{expected}} (find {{array}} {{value}}){{/input}};
  {{/cases}}
]

let () =
  run_test_tt_main ("binary-search tests" >::: tests)
