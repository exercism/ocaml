open OUnit2
open Binary_search

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string string_of_int) exp got

let tests = [
  "finds a value in an array with one element" >::
    ae (Some 0) (find [|6|] 6);
  "finds a value in the middle of an array" >::
    ae (Some 3) (find [|1; 3; 4; 6; 8; 9; 11|] 6);
  "finds a value at the beginning of an array" >::
    ae (Some 0) (find [|1; 3; 4; 6; 8; 9; 11|] 1);
  "finds a value at the end of an array" >::
    ae (Some 6) (find [|1; 3; 4; 6; 8; 9; 11|] 11);
  "finds a value in an array of odd length" >::
    ae (Some 9) (find [|1; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377; 634|] 144);
  "finds a value in an array of even length" >::
    ae (Some 5) (find [|1; 3; 5; 8; 13; 21; 34; 55; 89; 144; 233; 377|] 21);
  "identifies that a value is not included in the array" >::
    ae None (find [|1; 3; 4; 6; 8; 9; 11|] 7);
  "a value smaller than the array's smallest value is not included" >::
    ae None (find [|1; 3; 4; 6; 8; 9; 11|] 0);
  "a value larger than the array's largest value is not included" >::
    ae None (find [|1; 3; 4; 6; 8; 9; 11|] 13);
  "nothing is included in an empty array" >::
    ae None (find [||] 1);
]

let () =
  run_test_tt_main ("binary-search tests" >::: tests)
