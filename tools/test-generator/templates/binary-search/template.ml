open OUnit2
open Binary_search
open Core

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string Int.to_string) exp got

let tests = [
(* TEST
  "$description" >::
    ae $expected (find $array $value);
END TEST *)
]

let () =
  run_test_tt_main ("binary-search tests" >::: tests)
