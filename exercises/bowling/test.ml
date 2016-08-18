open Core.Std
open OUnit2
module B = Bowling

let (>>) = Fn.compose

let assert_score e g _test_context =
  assert_equal ~printer:Int.to_string e (B.new_game |> g |> B.score)

let replicate count n =
  let rec go acc count =
    if count = 0 then acc
    else go (n :: acc) (count - 1) in
  go [] count
let roll = B.roll
let roll_many scores game = List.fold ~init:game ~f:(Fn.flip roll) (List.rev scores)
let roll_spare = roll_many [5;5]
let roll_strike = roll 10
let roll_repeatedly (count: int) (score: int) (game: B.t): B.t =
  roll_many (replicate count score) game

let tests = [
  "gutter every frame gives a score of 0" >::
    assert_score 0 (roll_repeatedly 20 0);
  "1 pin every frame gives a score of 20" >::
    assert_score 20 (roll_repeatedly 20 1);
  "frame score for a spare is 10 plus the number of pins knocked down in the next throw" >::
    assert_score 16 (roll_spare >> roll 3 >> roll_repeatedly 17 0);
  "frame score for a strike is 10 plus the number of pins knocked down in the next 2 throws" >::
    assert_score 24 (roll_strike >> roll_many [3;4] >> roll_repeatedly 16 0);
  "perfect game" >::
    assert_score 300 (roll_repeatedly 12 10);
]

let () =
  run_test_tt_main ("bowling tests" >::: tests)
