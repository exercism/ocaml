open Base
open OUnit2
open Bowling

type game = Bowling.t

let to_ok = function
  | Ok x -> x
  | Error e -> failwith @@ "should be OK but got Error " ^ e

let set_previous_frames (frames : int list): game =
  List.fold frames ~init:new_game ~f:(fun g f -> roll f g |> to_ok)

let score_printer = function
  | Ok n -> Int.to_string n
  | Error e -> e

let roll_printer = function
  | Ok _ -> "Ok <some game>"
  | Error e -> e

let assert_score frames exp = 
  assert_equal ~printer:score_printer exp (score (set_previous_frames frames))

let assert_roll frames exp frame = 
  assert_equal ~printer:roll_printer exp (roll frame (set_previous_frames frames))

let tests = [
  "should be able to score a game with all zeros" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 0) 
    );
  "should be able to score a game with no strikes or spares" >:: (fun _ ->
      let rolls = [3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6] in
      assert_score rolls (Ok 90) 
    );
  "a spare followed by zeros is worth ten points" >:: (fun _ ->
      let rolls = [6; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 10) 
    );
  "points scored in the roll after a spare are counted twice" >:: (fun _ ->
      let rolls = [6; 4; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 16) 
    );
  "consecutive spares each get a one roll bonus" >:: (fun _ ->
      let rolls = [5; 5; 3; 7; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 31) 
    );
  "a spare in the last frame gets a one roll bonus that is counted once" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 7] in
      assert_score rolls (Ok 17) 
    );
  "a strike earns ten points in a frame with a single roll" >:: (fun _ ->
      let rolls = [10; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 10) 
    );
  "points scored in the two rolls after a strike are counted twice as a bonus" >:: (fun _ ->
      let rolls = [10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 26) 
    );
  "consecutive strikes each get the two roll bonus" >:: (fun _ ->
      let rolls = [10; 10; 10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_score rolls (Ok 81) 
    );
  "a strike in the last frame gets a two roll bonus that is counted once" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 1] in
      assert_score rolls (Ok 18) 
    );
  "rolling a spare with the two roll bonus does not get a bonus roll" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 3] in
      assert_score rolls (Ok 20) 
    );
  "strikes with the two roll bonus do not get bonus rolls" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10; 10] in
      assert_score rolls (Ok 30) 
    );
  "a strike with the one roll bonus after a spare in the last frame does not get a bonus" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 10] in
      assert_score rolls (Ok 20) 
    );
  "all strikes is a perfect game" >:: (fun _ ->
      let rolls = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10] in
      assert_score rolls (Ok 300) 
    );
  "rolls cannot score negative points" >:: (fun _ ->
      let rolls = [] in
      assert_roll rolls (Error "Negative roll is invalid") (-1)
    );
  "a roll cannot score more than 10 points" >:: (fun _ ->
      let rolls = [] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 11
    );
  "two rolls in a frame cannot score more than 10 points" >:: (fun _ ->
      let rolls = [5] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 6
    );
  "bonus roll after a strike in the last frame cannot score more than 10 points" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 11
    );
  "two bonus rolls after a strike in the last frame cannot score more than 10 points" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 5] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 6
    );
  "two bonus rolls after a strike in the last frame can score more than 10 points if one is a strike" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10; 6] in
      assert_score rolls (Ok 26) 
    );
  "the second bonus rolls after a strike in the last frame cannot be a strike if the first one is not a strike" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 6] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 10
    );
  "second bonus roll after a strike in the last frame cannot score more than 10 points" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10] in
      assert_roll rolls (Error "Pin count exceeds pins on the lane") 11
    );
  "an unstarted game cannot be scored" >:: (fun _ ->
      let rolls = [] in
      assert_score rolls (Error "Score cannot be taken until the end of the game") 
    );
  "an incomplete game cannot be scored" >:: (fun _ ->
      let rolls = [0; 0] in
      assert_score rolls (Error "Score cannot be taken until the end of the game") 
    );
  "cannot roll if game already has ten frames" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] in
      assert_roll rolls (Error "Cannot roll after game is over") 0
    );
  "bonus rolls for a strike in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10] in
      assert_score rolls (Error "Score cannot be taken until the end of the game") 
    );
  "both bonus rolls for a strike in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10] in
      assert_score rolls (Error "Score cannot be taken until the end of the game") 
    );
  "bonus roll for a spare in the last frame must be rolled before score can be calculated" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3] in
      assert_score rolls (Error "Score cannot be taken until the end of the game") 
    );
  "cannot roll after bonus roll for spare" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 2] in
      assert_roll rolls (Error "Cannot roll after game is over") 2
    );
  "cannot roll after bonus rolls for strike" >:: (fun _ ->
      let rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 3; 2] in
      assert_roll rolls (Error "Cannot roll after game is over") 2
    );
]

let () =
  run_test_tt_main ("bowling tests" >::: tests)