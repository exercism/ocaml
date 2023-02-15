open Base
open OUnit2
open Minesweeper

let format_board strings =
  let width = match strings with
    | [] -> 0
    | (s::_) -> String.length s in
  let border_line = "+" ^ String.make width '-' ^ "+\n" in
  let line s = "|" ^ s ^ "|\n" in
  "\n" ^ border_line ^ String.concat (List.map strings ~f:line) ^ border_line

(* Assert Equals *)
let ae exp got =
  assert_equal exp got ~printer:format_board

let tests = [
{{#cases}}
  "{{description}}" >:: (fun _ ->
    {{#input}}
    let b = {{minefield}} in
    let expected = {{expected}} in
    ae expected (annotate b)
    {{/input}}
  );
{{/cases}}
]

let () =
  run_test_tt_main ("minesweeper tests" >::: tests)
