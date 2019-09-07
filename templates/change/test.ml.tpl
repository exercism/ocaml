open Base
open OUnit2
open Change

let printer = function
  | Ok l -> l |> List.map ~f:Int.to_string |> String.concat ~sep:";" |> Printf.sprintf "Ok [%s]"
  | Error m -> Printf.sprintf "Error \"[%s]\"" m

let ae exp got _test_ctxt = assert_equal ~printer exp got

let tests = [
{{#cases}}
   "{{description}}" >::
     {{#input}}ae {{expected}} 
       (make_change ~target:{{target}} ~coins:{{coins}}){{/input}};
{{/cases}}
]

let () =
  run_test_tt_main ("{{name}} tests" >::: tests)
