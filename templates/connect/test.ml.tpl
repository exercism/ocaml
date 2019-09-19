open OUnit2
open Connect

let show_player = function
| Some X -> "X"
| Some O -> "O"
| None -> "None"

let ae exp got = assert_equal ~printer:show_player exp got

let tests = [
{{#cases}}
  "{{description}}" >::(fun _ctxt ->
    {{#input}}let board = {{board}} 
    in
    ae {{expected}} (connect board){{/input}}
  );
{{/cases}}]

let () =
  run_test_tt_main ("connect tests" >::: tests)
