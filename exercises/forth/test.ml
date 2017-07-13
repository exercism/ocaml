(* Test/exercise version: "1.2.0" *)

open Core
open OUnit2
open Forth

let print_int_list_option (xs: int list option) = match xs with
| None -> "None"
| Some xs -> "Some [" ^ String.concat ~sep:";" (List.map ~f:Int.to_string xs) ^ "]"
let ae exp got _test_ctxt = assert_equal ~printer:print_int_list_option exp got

let parsing_and_numbers_tests = [
   "empty input results in empty stack" >::
     ae (Some []) (evaluate []);
   "numbers just get pushed onto the stack" >::
     ae (Some [1; 2; 3; 4; 5]) (evaluate ["1 2 3 4 5"]);
]


let addition_tests = [
   "can add two numbers" >::
     ae (Some [3]) (evaluate ["1 2 +"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["+"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 +"]);
]


let subtraction_tests = [
   "can subtract two numbers" >::
     ae (Some [-1]) (evaluate ["3 4 -"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["-"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 -"]);
]


let multiplication_tests = [
   "can multiply two numbers" >::
     ae (Some [8]) (evaluate ["2 4 *"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["*"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 *"]);
]


let division_tests = [
   "can divide two numbers" >::
     ae (Some [4]) (evaluate ["12 3 /"]);
   "performs integer division" >::
     ae (Some [2]) (evaluate ["8 3 /"]);
   "errors if dividing by zero" >::
     ae None (evaluate ["4 0 /"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["/"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 /"]);
]


let combined_arithmetic_tests = [
   "addition and subtraction" >::
     ae (Some [-1]) (evaluate ["1 2 + 4 -"]);
   "multiplication and division" >::
     ae (Some [2]) (evaluate ["2 4 * 3 /"]);
]


let dup_tests = [
   "copies the top value on the stack" >::
     ae (Some [1; 1]) (evaluate ["1 DUP"]);
   "is case-insensitive" >::
     ae (Some [1; 2; 2]) (evaluate ["1 2 Dup"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["dup"]);
]


let drop_tests = [
   "removes the top value on the stack if it is the only one" >::
     ae (Some []) (evaluate ["1 drop"]);
   "removes the top value on the stack if it is not the only one" >::
     ae (Some [1]) (evaluate ["1 2 drop"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["drop"]);
]


let swap_tests = [
   "swaps the top two values on the stack if they are the only ones" >::
     ae (Some [2; 1]) (evaluate ["1 2 swap"]);
   "swaps the top two values on the stack if they are not the only ones" >::
     ae (Some [1; 3; 2]) (evaluate ["1 2 3 swap"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["swap"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 swap"]);
]


let over_tests = [
   "copies the second element if there are only two" >::
     ae (Some [1; 2; 1]) (evaluate ["1 2 over"]);
   "copies the second element if there are more than two" >::
     ae (Some [1; 2; 3; 2]) (evaluate ["1 2 3 over"]);
   "errors if there is nothing on the stack" >::
     ae None (evaluate ["over"]);
   "errors if there is only one value on the stack" >::
     ae None (evaluate ["1 over"]);
]


let user_defined_words_tests = [
   "can consist of built-in words" >::
     ae (Some [1; 1; 1]) (evaluate [": dup-twice dup dup ;"; "1 dup-twice"]);
   "execute in the right order" >::
     ae (Some [1; 2; 3]) (evaluate [": countup 1 2 3 ;"; "countup"]);
   "can override other user-defined words" >::
     ae (Some [1; 1; 1]) (evaluate [": foo dup ;"; ": foo dup dup ;"; "1 foo"]);
   "can override built-in words" >::
     ae (Some [1; 1]) (evaluate [": swap dup ;"; "1 swap"]);
   "can override built-in operators" >::
     ae (Some [12]) (evaluate [": + * ;"; "3 4 +"]);
   "cannot redefine numbers" >::
     ae None (evaluate [": 1 2 ;"]);
   "errors if executing a non-existent word" >::
     ae None (evaluate ["foo"]);
]

let () =
  run_test_tt_main (
    "forth tests" >:::
      List.concat [
        parsing_and_numbers_tests; 
        addition_tests; 
        subtraction_tests; 
        multiplication_tests; 
        division_tests;
        combined_arithmetic_tests; 
        dup_tests; 
        drop_tests;
        swap_tests; 
        over_tests; 
        user_defined_words_tests
        ]
  )