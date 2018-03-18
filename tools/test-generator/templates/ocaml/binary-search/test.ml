open OUnit2
open Binary_search

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string string_of_int) exp got

let tests = [
(* TEST
  "$description" >::
    ae $expected (find $array $value);
END TEST *)
]

let () =
  run_test_tt_main ("binary-search tests" >::: tests)
