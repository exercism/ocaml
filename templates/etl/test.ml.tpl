open OUnit2
open Etl

let ae exp got _test_ctxt =
  let printer xs = String.concat ";" (List.map (fun (ch, n) -> Printf.sprintf "(%c,%d)" ch n) xs) in
  assert_equal exp got ~printer

let tests = [
{{#cases}}
  "{{description}}" >::
    ae {{#input}}{{expected}}
      ({{property}} {{input}});{{/input}}
{{/cases}}
]

let () =
  run_test_tt_main ("etl tests" >::: tests)
