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
  {{#cases}}
    "{{description}}" >:: (fun _ ->
        {{#input}}
        let rolls = {{previousRolls}} in
        assert_{{property}} rolls {{expected}} {{roll}}
        {{/input}}
    );
  {{/cases}}
]

let () =
  run_test_tt_main ("bowling tests" >::: tests)
