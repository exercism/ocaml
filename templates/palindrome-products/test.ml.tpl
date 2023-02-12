(* {{name}} - {{version}} *)
open OUnit2
open Palindrome_products

let show_result printer = function
| Error e -> "Error " ^ e
| Ok a -> "Ok " ^ printer a

let eq_results eq x y = match (x, y) with
| (Error e1, Error e2) -> String.equal e1 e2
| (Ok x, Ok y) -> eq x y
| _ -> false

let ae exp got _test_ctxt = 
  assert_equal ~printer:(show_result show_palindrome_products) ~cmp:(eq_results equal_palindrome_products) exp got

let tests = [
{{#cases}}
   "{{description}}" >::
      ae ({{#input}}{{expected}})
         ({{property}} ~min:{{min}} ~max:{{max}}){{/input}};
   {{/cases}}
]

let () =
  ignore @@ run_test_tt_main ("palindrome product tests" >::: tests)
