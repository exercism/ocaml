open Core
open OUnit2
open All_your_base

let option_printer = function
  | None -> "None"
  | Some xs -> "Some [" ^ String.concat ~sep:";" (List.map xs ~f:Int.to_string) ^ "]"

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:option_printer

let tests = [
(* TEST
  "$description" >::
    ae $expected (convert_bases ~from:$inputBase ~digits:$digits ~target:$outputBase);
END TEST *)
]

let () =
  run_test_tt_main ("all-your-bases tests" >::: tests)
