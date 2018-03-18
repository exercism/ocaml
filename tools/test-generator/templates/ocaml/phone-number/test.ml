open Base
open OUnit2
open Phone_number

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string Fn.id) exp got

let tests = [
(* TEST
  "$description" >::
    ae $expected (number $phrase);
END TEST *)
]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)
