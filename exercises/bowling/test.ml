(* Test/exercise version: "1.0.0" *)

open! Core
open OUnit2
open Bowling

type game = Bowling.t

let to_ok (r: (t, string) Result.t): t = match r with
| Ok g -> g
| Error e -> failwith ("should be OK but got Error " ^ e)

let set_previous_frames (frames : int list): game =
  List.fold frames ~init:new_game ~f:(fun g f -> roll f g |> to_ok)

let score_printer = function
| Ok n -> Int.to_string n
| Error e -> e
let assert_score exp game = assert_equal ~printer:score_printer exp (score game)

let roll_printer = function
| Ok _ -> "Ok <some game>"
| Error e -> e
let assert_roll (exp: (t, string) Result.t) (frame: int) (game: game) = 
  assert_equal ~printer:roll_printer exp (roll frame game)

let tests = [
   "should be able to score a game with all zeros" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 0) g
   );
   "should be able to score a game with no strikes or spares" >:: (fun _ ->
      let g = set_previous_frames [3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6] in
      assert_score (Ok 90) g
   );
   "a spare followed by zeros is worth ten points" >:: (fun _ ->
      let g = set_previous_frames [6; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 10) g
   );
   "points scored in the roll after a spare are counted twice" >:: (fun _ ->
      let g = set_previous_frames [6; 4; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 16) g
   );
   "consecutive spares each get a one roll bonus" >:: (fun _ ->
      let g = set_previous_frames [5; 5; 3; 7; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 31) g
   );
   "a spare in the last frame gets a one roll bonus that is counted once" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 7] in
      assert_score (Ok 17) g
   );
   "a strike earns ten points in a frame with a single roll" >:: (fun _ ->
      let g = set_previous_frames [10; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 10) g
   );
   "points scored in the two rolls after a strike are counted twice as a bonus" >:: (fun _ ->
      let g = set_previous_frames [10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 26) g
   );
   "consecutive strikes each get the two roll bonus" >:: (fun _ ->
      let g = set_previous_frames [10; 10; 10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score (Ok 81) g
   );
   "a strike in the last frame gets a two roll bonus that is counted once" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 1] in
      assert_score (Ok 18) g
   );
   "rolling a spare with the two roll bonus does not get a bonus roll" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 3] in
      assert_score (Ok 20) g
   );
   "strikes with the two roll bonus do not get bonus rolls" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10; 10] in
      assert_score (Ok 30) g
   );
   "a strike with the one roll bonus after a spare in the last frame does not get a bonus" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 10] in
      assert_score (Ok 20) g
   );
   "all strikes is a perfect game" >:: (fun _ ->
      let g = set_previous_frames [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10] in
      assert_score (Ok 300) g
   );
   "rolls can not score negative points" >:: (fun _ ->
      let g = set_previous_frames [] in
      assert_roll (Error "Negative roll is invalid") (-1) g
   );
   "a roll can not score more than 10 points" >:: (fun _ ->
      let g = set_previous_frames [] in
      assert_roll (Error "Pin count exceeds pins on the lane") 11 g
   );
   "two rolls in a frame can not score more than 10 points" >:: (fun _ ->
      let g = set_previous_frames [5] in
      assert_roll (Error "Pin count exceeds pins on the lane") 6 g
   );
   "bonus roll after a strike in the last frame can not score more than 10 points" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10] in
      assert_roll (Error "Pin count exceeds pins on the lane") 11 g
   );
   "two bonus rolls after a strike in the last frame can not score more than 10 points" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 5] in
      assert_roll (Error "Pin count exceeds pins on the lane") 6 g
   );
   "two bonus rolls after a strike in the last frame can score more than 10 points if one is a strike" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10; 6] in
      assert_score (Ok 26) g
   );
   "the second bonus rolls after a strike in the last frame can not be a strike if the first one is not a strike" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 6] in
      assert_roll (Error "Pin count exceeds pins on the lane") 10 g
   );
   "second bonus roll after a strike in the last frame can not score than 10 points" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10] in
      assert_roll (Error "Pin count exceeds pins on the lane") 11 g
   );
   "an unstarted game can not be scored" >:: (fun _ ->
      let g = set_previous_frames [] in
      assert_score (Error "Score cannot be taken until the end of the game") g
   );
   "an incomplete game can not be scored" >:: (fun _ ->
      let g = set_previous_frames [0; 0] in
      assert_score (Error "Score cannot be taken until the end of the game") g
   );
   "cannot roll if game already has ten frames" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_roll (Error "Cannot roll after game is over") 0 g
   );
   "bonus rolls for a strike in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10] in
      assert_score (Error "Score cannot be taken until the end of the game") g
   );
   "both bonus rolls for a strike in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10] in
      assert_score (Error "Score cannot be taken until the end of the game") g
   );
   "bonus roll for a spare in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let g = set_previous_frames [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3] in
      assert_score (Error "Score cannot be taken until the end of the game") g
   );
]

let () =
  run_test_tt_main ("bowling tests" >::: tests)