open Base
open OUnit2
open Forth

let print_int_list_option (xs: int list option) = match xs with
| None -> "None"
| Some xs -> "Some [" ^ String.concat ~sep:";" (List.map ~f:Int.to_string xs) ^ "]"
let ae exp got _test_ctxt = assert_equal ~printer:print_int_list_option exp got

{{#cases}}
  let {{slug}}_tests = [
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{expected}} ({{property}} {{instructions}}){{/input}};
    {{/cases}}
  ]


{{/cases}}

let () =
  run_test_tt_main (
    "forth tests" >:::
      List.concat [
        {{#cases}}
          {{slug}}_tests; 
        {{/cases}}
      ]
  )
