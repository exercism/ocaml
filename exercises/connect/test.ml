open OUnit2
open Connect

let show_player = function
  | Some X -> "X"
  | Some O -> "O"
  | None -> "None"

let ae exp got = assert_equal ~printer:show_player exp got

let tests = [
  "an empty board has no winner" >::(fun _ctxt ->
      let board = [
        ". . . . .";
        " . . . . .";
        "  . . . . .";
        "   . . . . .";
        "    . . . . .";
      ] 
      in
      ae None (connect board)
    );
  "X can win on a 1x1 board" >::(fun _ctxt ->
      let board = ["X"] 
      in
      ae (Some X) (connect board)
    );
  "O can win on a 1x1 board" >::(fun _ctxt ->
      let board = ["O"] 
      in
      ae (Some O) (connect board)
    );
  "only edges does not make a winner" >::(fun _ctxt ->
      let board = [
        "O O O X";
        " X . . X";
        "  X . . X";
        "   X O O O";
      ] 
      in
      ae None (connect board)
    );
  "illegal diagonal does not make a winner" >::(fun _ctxt ->
      let board = [
        "X O . .";
        " O X X X";
        "  O X O .";
        "   . O X .";
        "    X X O O";
      ] 
      in
      ae None (connect board)
    );
  "nobody wins crossing adjacent angles" >::(fun _ctxt ->
      let board = [
        "X . . .";
        " . X O .";
        "  O . X O";
        "   . O . X";
        "    . . O .";
      ] 
      in
      ae None (connect board)
    );
  "X wins crossing from left to right" >::(fun _ctxt ->
      let board = [
        ". O . .";
        " O X X X";
        "  O X O .";
        "   X X O X";
        "    . O X .";
      ] 
      in
      ae (Some X) (connect board)
    );
  "O wins crossing from top to bottom" >::(fun _ctxt ->
      let board = [
        ". O . .";
        " O X X X";
        "  O O O .";
        "   X X O X";
        "    . O X .";
      ] 
      in
      ae (Some O) (connect board)
    );
  "X wins using a convoluted path" >::(fun _ctxt ->
      let board = [
        ". X X . .";
        " X . X . X";
        "  . X . X .";
        "   . X X . .";
        "    O O O O O";
      ] 
      in
      ae (Some X) (connect board)
    );
  "X wins using a spiral path" >::(fun _ctxt ->
      let board = [
        "O X X X X X X X X";
        " O X O O O O O O O";
        "  O X O X X X X X O";
        "   O X O X O O O X O";
        "    O X O X X X O X O";
        "     O X O O O X O X O";
        "      O X X X X X O X O";
        "       O O O O O O O X O";
        "        X X X X X X X X O";
      ] 
      in
      ae (Some X) (connect board)
    );
]

let () =
  run_test_tt_main ("connect tests" >::: tests)
