(* {{name}} - {{version}} *)
open OUnit2
open Hello_world

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let tests = [
  {{#cases}}
    "{{description}}" >:: ae {{#input}}{{expected}}{{/input}} {{property}};
  {{/cases}}
]

let () =
  run_test_tt_main ("Hello World tests" >::: tests)
