open OUnit2
open Binary_search

let result_to_string f = function
  | Error m -> Printf.sprintf "Error \"%s\"" m
  | Ok x -> f x |> Printf.sprintf "Some %s"

let ae exp got _test_ctxt =
  assert_equal ~printer:(result_to_string string_of_int) exp got

let tests = [
  "finds a value in an array with one element" >::
  ae (Ok 0) (find [|6|] 6);
  "finds a value in the middle of an array" >::
  ae (Ok 3) (find [|1; 3; 4; 6; 8; 9; 11|] 6);
  "finds a value at the beginning of an array" >::
  ae (Ok 0) (find [|1; 3; 4; 6; 8; 9; 11|] 1);
  "finds a value at the end of an array" >::
  ae (Ok 6) (find [|1; 3; 4; 6; 8; 9; 11|] 11);
  "finds a value in an array of odd length" >::
  ae (Ok 9) (find [|1; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 634|] 144);
  "finds a value in an array of even length" >::
  ae (Ok 5) (find [|1; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377|] 21);
  "identifies that a value is not included in the array" >::
  ae (Error "value not in array") (find [|1; 3; 4; 6; 8; 9; 11|] 7);
  "a value smaller than the array's smallest value is not found" >::
  ae (Error "value not in array") (find [|1; 3; 4; 6; 8; 9; 11|] 0);
  "a value larger than the array's largest value is not found" >::
  ae (Error "value not in array") (find [|1; 3; 4; 6; 8; 9; 11|] 13);
  "nothing is found in an empty array" >::
  ae (Error "value not in array") (find [||] 1);
  "nothing is found when the left and right bounds cross" >::
  ae (Error "value not in array") (find [|1; 2|] 0);
]

let () =
  run_test_tt_main ("binary-search tests" >::: tests)
