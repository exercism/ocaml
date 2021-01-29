open OUnit2
open React
open Hangman

(* Assert Equals Int *)
let aei exp got =
  assert_equal exp got ~printer:string_of_int

(* Assert Equals String *)
let aes exp got =
  assert_equal exp got ~printer:(fun s -> s)

(* Assert Equals Progress *)
let aep exp got =
  let string_of_progress = function
    | Win -> "Win"
    | Lose -> "Lose"
    | Busy n -> "Busy " ^ string_of_int n in
  assert_equal exp got ~printer:string_of_progress

let tests = [
  "initially 9 failures are allowed">::(fun _ ->
      let hm = create "foo" in
      aep (Busy 9) (S.value (progress hm))
    );
  "initially no letters are guessed">::(fun _ ->
      let hm = create "foo" in
      aes "___" (S.value (masked_word hm))
    );
  "after 10 failures the game is over">::(fun _ ->
      let hm = create "foo" in
      begin
        for i = 1 to 9 do
          feed 'x' hm;
          aep (Busy (9-i)) (S.value (progress hm))
        done;
        feed 'x' hm;
        aep Lose (S.value (progress hm))
      end;
    );
  "feeding a correct letter removes underscores">::(fun _ ->
      let hm = create "foobar" in
      begin
        feed 'b' hm;
        aep (Busy 9) (S.value (progress hm));
        aes "___b__" (S.value (masked_word hm));
        feed 'o' hm;
        aep (Busy 9) (S.value (progress hm));
        aes "_oob__" (S.value (masked_word hm));
      end;
    );
  "feeding a correct letter twice counts as a failure">::(fun _ ->
      let hm = create "foobar" in
      begin
        feed 'b' hm;
        aep (Busy 9) (S.value (progress hm));
        aes "___b__" (S.value (masked_word hm));
        feed 'b' hm;
        aep (Busy 8) (S.value (progress hm));
        aes "___b__" (S.value (masked_word hm));
      end;
    );
  "getting all the letters right makes for a win">::(fun _ ->
      let hm = create "hello" in
      begin
        feed 'b' hm;
        aep (Busy 8) (S.value (progress hm));
        aes "_____" (S.value (masked_word hm));
        feed 'e' hm;
        aep (Busy 8) (S.value (progress hm));
        aes "_e___" (S.value (masked_word hm));
        feed 'l' hm;
        aep (Busy 8) (S.value (progress hm));
        aes "_ell_" (S.value (masked_word hm));
        feed 'o' hm;
        aep (Busy 8) (S.value (progress hm));
        aes "_ello" (S.value (masked_word hm));
        feed 'h' hm;
        aep Win (S.value (progress hm));
        aes "hello" (S.value (masked_word hm));
      end;
    );
]

let () =
  run_test_tt_main ("hangman tests" >::: tests)
