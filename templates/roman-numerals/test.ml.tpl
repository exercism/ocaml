(* {{name}} - {{version}} *)
open OUnit2
open Roman_numerals

let ae expected actual _ctx = assert_equal ~printer:(fun x -> x) expected actual

let tests = [
{{#cases}}
   "{{description}}" >::
      ae {{#input}}{{expected}} (to_roman {{number}}){{/input}};
   {{/cases}}
]

let () =
    run_test_tt_main ("roman-numerals test" >::: tests) 
