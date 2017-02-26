open Core.Std
open OUnit2
open Connect

let show_player = function
| Some X -> "X"
| Some O -> "O"
| None -> "None"

let ae exp got = assert_equal ~printer:show_player exp got

let tests = [
(* TEST
  "$description" >::(fun _ctxt ->
    let board = $board 
    in
    ae $expected (connect board)
  );
END TEST *)
]

let () =
  run_test_tt_main ("connect tests" >::: tests)
