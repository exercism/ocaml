open Core
open OUnit2
open Forth

let print_int_list_option (xs: int list option) = match xs with
| None -> "None"
| Some xs -> "Some [" ^ String.concat ~sep:";" (List.map ~f:Int.to_string xs) ^ "]"
let ae exp got _test_ctxt = assert_equal ~printer:print_int_list_option exp got

let (* SUITE parsing_and_numbers *)parsing_and_numbers_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE addition *)addition_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE subtraction *)subtraction_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE multiplication *)multiplication_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE division *)division_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE combined_arithmetic *)combined_arithmetic_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE dup *)dup_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE drop *)drop_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE swap *)swap_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE over *)over_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

let (* SUITE user-defined_words *)user_defined_words_tests = [
(* TEST
   "$description" >::
     ae $expected (evaluate $input);
   END TEST *)
]
(* END SUITE *)

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