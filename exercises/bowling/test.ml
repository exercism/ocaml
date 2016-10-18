open Core.Std
open OUnit2
module B = Bowling

let assert_score e g _test_context =
  assert_equal ~printer:Int.to_string e (B.new_game |> g |> B.score)

let roll = B.roll
let roll_many scores game = List.fold ~init:game ~f:(Fn.flip roll) (List.rev scores)

type case = {
 description: string;
  rolls: int list;
  expected: int;
}

let make_test (c: case) =
  c.description >::
  assert_score c.expected (roll_many c.rolls)

let tests = List.map ~f:make_test [
    {
      description = "should be able to score a game with all zeros";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 0
    }; {
      description = "should be able to score a game with no strikes or spares";
      rolls = [3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6; 3; 6];
      expected = 90
    }; {
      description = "a spare followed by zeros is worth ten points";
      rolls = [6; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 10
    }; {
      description = "points scored in the roll after a spare are counted twice";
      rolls = [6; 4; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 16
    }; {
      description = "consecutive spares each get a one roll bonus";
      rolls = [5; 5; 3; 7; 4; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 31
    }; {
      description = "a spare in the last frame gets a one roll bonus that is counted once";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 7];
      expected = 17
    }; {
      description = "a strike earns ten points in frame with a single roll";
      rolls = [10; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 10
    }; {
      description = "points scored in the two rolls after a strike are counted twice as a bonus";
      rolls = [10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 26
    }; {
      description = "consecutive strikes each get the two roll bonus";
      rolls = [10; 10; 10; 5; 3; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = 81
    }; {
      description = "a strike in the last frame gets a two roll bonus that is counted once";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 1];
      expected = 18
    }; {
      description = "rolling a spare with the two roll bonus does not get a bonus roll";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 7; 3];
      expected = 20
    }; {
      description = "strikes with the two roll bonus do not get bonus rolls";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10; 10];
      expected = 30
    }; {
      description = "a strike with the one roll bonus after a spare in the last frame does not get a bonus";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3; 10];
      expected = 20
    }; {
      description = "all strikes is a perfect game";
      rolls = [10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10];
      expected = 300
    }; {
      description = "Rolls can not score negative points";
      rolls = [-1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = -1
    }; {
      description = "A roll can not score more than 10 points";
      rolls = [11; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = -1
    }; {
      description = "Two rolls in a frame can not score more than 10 points";
      rolls = [5; 6; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = -1
    }; {
      description = "Two bonus rolls after a strike in the last frame can not score more than 10 points";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 5; 6];
      expected = -1
    }; {
      description = "An unstarted game can not be scored";
      rolls = [];
      expected = -1
    }; {
      description = "An incomplete game can not be scored";
      rolls = [0; 0];
      expected = -1
    }; {
      description = "A game with more than ten frames can not be scored";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
      expected = -1
    }; {
      description = "bonus rolls for a strike in the last frame must be rolled before score can be calculated";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10];
      expected = -1
    }; {
      description = "both bonus rolls for a strike in the last frame must be rolled before score can be calculated";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 10; 10];
      expected = -1
    }; {
      description = "bonus roll for a spare in the last frame must be rolled before score can be calculated";
      rolls = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 7; 3];
      expected = -1
}]

let () =
  run_test_tt_main ("bowling tests" >::: tests)
