open OUnit2
open Dnd_character

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:string_of_int

let ae_bool exp got _test_ctxt =
  assert_equal exp got ~printer:string_of_bool

let tests = [
  "ability modifier for score 3 is -4" >::
  ae (-4) (modifier ~score:3);

  "ability modifier for score 4 is -3" >::
  ae (-3) (modifier ~score:4);

  "ability modifier for score 5 is -3" >::
  ae (-3) (modifier ~score: 5);

  "ability modifier for score 6 is -2" >::
  ae (-2) (modifier ~score: 6);

  "ability modifier for score 7 is -2" >::
  ae (-2) (modifier ~score: 7);

  "ability modifier for score 8 is -1" >::
  ae (-1) (modifier ~score: 8);

  "ability modifier for score 9 is -1" >::
  ae (-1) (modifier ~score: 9);

  "ability modifier for score 10 is 0" >::
  ae (0) (modifier ~score: 10);

  "ability modifier for score 11 is 0" >::
  ae (0) (modifier ~score: 11);

  "ability modifier for score 12 is +1" >::
  ae (1) (modifier ~score: 12);

  "ability modifier for score 13 is +1" >::
  ae (1) (modifier ~score: 13);

  "ability modifier for score 14 is +2" >::
  ae (2) (modifier ~score: 14);

  "ability modifier for score 15 is +2" >::
  ae (2) (modifier ~score: 15);

  "ability modifier for score 16 is +3" >::
  ae (3) (modifier ~score: 16);

  "ability modifier for score 17 is +3" >::
  ae (3) (modifier ~score: 17);

  "ability modifier for score 18 is +4" >::
  ae (4) (modifier ~score: 18);

  "random ability is within range" >:: (fun _test_ctxt ->
      let value = ability () in
      ae_bool true (value >= 3 && value <= 18) _test_ctxt;
    );

  "random character is valid" >:: (fun _test_ctxt ->
      let c = generate_character () in
      Printf.printf "Generated character: str=%d, dex=%d, con=%d, int=%d, wis=%d, cha=%d, hp=%d\n"
        c.strength c.dexterity c.constitution c.intelligence c.wisdom c.charisma c.hitpoints;
      ae_bool true (c.strength >= 3 && c.strength <= 18) _test_ctxt;
      ae_bool true (c.dexterity >= 3 && c.dexterity <= 18) _test_ctxt;
      ae_bool true (c.constitution >= 3 && c.constitution <= 18) _test_ctxt;
      ae_bool true (c.intelligence >= 3 && c.intelligence <= 18) _test_ctxt;
      ae_bool true (c.wisdom >= 3 && c.wisdom <= 18) _test_ctxt;
      ae_bool true (c.charisma >= 3 && c.charisma <= 18) _test_ctxt;
      ae_bool true (c.hitpoints == 10 + (modifier ~score:c.constitution) ) _test_ctxt;
    );

  "each ability is only calculated once" >:: (fun _test_ctxt ->
      let c = generate_character () in
      let strength1 = c.strength in
      let strength2 = c.strength in
      ae (strength1) (strength2) _test_ctxt;

      let dexterity1 = c.dexterity in
      let dexterity2 = c.dexterity in
      ae (dexterity1) (dexterity2) _test_ctxt;

      let constitution1 = c.constitution in
      let constitution2 = c.constitution in
      ae (constitution1) (constitution2) _test_ctxt;

      let intelligence1 = c.intelligence in
      let intelligence2 = c.intelligence in
      ae (intelligence1) (intelligence2) _test_ctxt;

      let wisdom1 = c.wisdom in
      let wisdom2 = c.wisdom in
      ae (wisdom1) (wisdom2) _test_ctxt;

      let charisma1 = c.charisma in
      let charisma2 = c.charisma in
      ae (charisma1) (charisma2) _test_ctxt;

      let hitpoints1 = c.hitpoints in
      let hitpoints2 = c.hitpoints in
      ae (hitpoints1) (hitpoints2) _test_ctxt;
    );
]

let () =
  run_test_tt_main  ("D&D tests" >::: tests)
