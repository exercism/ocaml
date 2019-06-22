open Base
open OUnit2
open Minesweeper

let format_board strings =
  let width = match strings with
    | [] -> 0
    | (s::_) -> String.length s in
  let border_line = "+" ^ String.make width '-' ^ "+\n" in
  let line s = "|" ^ s ^ "|\n" in
  "\n" ^ border_line ^ String.concat (List.map strings ~f:line) ^ border_line

(* Assert Equals *)
let ae exp got = assert_equal exp got ~printer:format_board

let tests = [
  "no rows" >:: (fun _ ->
      let b = [] in
      let expected = [] in
      ae expected (annotate b)
    );
  "no columns" >:: (fun _ ->
      let b = [""] in
      let expected = [""] in
      ae expected (annotate b)
    );
  "no mines" >:: (fun _ ->
      let b = ["   ";
               "   ";
               "   "] in
      let expected = ["   ";
                      "   ";
                      "   "] in
      ae expected (annotate b)
    );
  "minefield with only mines" >:: (fun _ ->
      let b = ["***";
               "***";
               "***"] in
      let expected = ["***";
                      "***";
                      "***"] in
      ae expected (annotate b)
    );
  "mine surrounded by spaces" >:: (fun _ ->
      let b = ["   ";
               " * ";
               "   "] in
      let expected = ["111";
                      "1*1";
                      "111"] in
      ae expected (annotate b)
    );
  "space surrounded by mines" >:: (fun _ ->
      let b = ["***";
               "* *";
               "***"] in
      let expected = ["***";
                      "*8*";
                      "***"] in
      ae expected (annotate b)
    );
  "horizontal line" >:: (fun _ ->
      let b = [" * * "] in
      let expected = ["1*2*1"] in
      ae expected (annotate b)
    );
  "horizontal line, mines at edges" >:: (fun _ ->
      let b = ["*   *"] in
      let expected = ["*1 1*"] in
      ae expected (annotate b)
    );
  "vertical line" >:: (fun _ ->
      let b = [" ";
               "*";
               " ";
               "*";
               " "] in
      let expected = ["1";
                      "*";
                      "2";
                      "*";
                      "1"] in
      ae expected (annotate b)
    );
  "vertical line, mines at edges" >:: (fun _ ->
      let b = ["*";
               " ";
               " ";
               " ";
               "*"] in
      let expected = ["*";
                      "1";
                      " ";
                      "1";
                      "*"] in
      ae expected (annotate b)
    );
  "cross" >:: (fun _ ->
      let b = ["  *  ";
               "  *  ";
               "*****";
               "  *  ";
               "  *  "] in
      let expected = [" 2*2 ";
                      "25*52";
                      "*****";
                      "25*52";
                      " 2*2 "] in
      ae expected (annotate b)
    );
  "large minefield" >:: (fun _ ->
      let b = [" *  * ";
               "  *   ";
               "    * ";
               "   * *";
               " *  * ";
               "      "] in
      let expected = ["1*22*1";
                      "12*322";
                      " 123*2";
                      "112*4*";
                      "1*22*2";
                      "111111"] in
      ae expected (annotate b)
    );
]

let () =
  run_test_tt_main ("minesweeper tests" >::: tests)