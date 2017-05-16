(* Test/exercise version: "1.0.0" *)

open Core.Std
open OUnit2
open Bob

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests = [
   "stating something" >::
      ae "Whatever." (response_for "Tom-ay-to, tom-aaaah-to.");
   "shouting" >::
      ae "Whoa, chill out!" (response_for "WATCH OUT!");
   "shouting gibberish" >::
      ae "Whoa, chill out!" (response_for "FCECDFCAAB");
   "asking a question" >::
      ae "Sure." (response_for "Does this cryogenic chamber make me look fat?");
   "asking a numeric question" >::
      ae "Sure." (response_for "You are, what, like 15?");
   "asking gibberish" >::
      ae "Sure." (response_for "fffbbcbeab?");
   "talking forcefully" >::
      ae "Whatever." (response_for "Let's go make out behind the gym!");
   "using acronyms in regular speech" >::
      ae "Whatever." (response_for "It's OK if you don't want to go to the DMV.");
   "forceful question" >::
      ae "Whoa, chill out!" (response_for "WHAT THE HELL WERE YOU THINKING?");
   "shouting numbers" >::
      ae "Whoa, chill out!" (response_for "1, 2, 3 GO!");
   "only numbers" >::
      ae "Whatever." (response_for "1, 2, 3");
   "question with only numbers" >::
      ae "Sure." (response_for "4?");
   "shouting with special characters" >::
      ae "Whoa, chill out!" (response_for "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!");
   "shouting with no exclamation mark" >::
      ae "Whoa, chill out!" (response_for "I HATE YOU");
   "statement containing question mark" >::
      ae "Whatever." (response_for "Ending with ? means a question.");
   "non-letters with question" >::
      ae "Sure." (response_for ":) ?");
   "prattling on" >::
      ae "Sure." (response_for "Wait! Hang on. Are you going to be OK?");
   "silence" >::
      ae "Fine. Be that way!" (response_for "");
   "prolonged silence" >::
      ae "Fine. Be that way!" (response_for "          ");
   "alternate silence" >::
      ae "Fine. Be that way!" (response_for "\t\t\t\t\t\t\t\t\t\t");
   "multiple line question" >::
      ae "Whatever." (response_for "\nDoes this cryogenic chamber make me look fat?\nno");
   "starting with whitespace" >::
      ae "Whatever." (response_for "         hmmmmmmm...");
   "ending with whitespace" >::
      ae "Sure." (response_for "Okay if like my  spacebar  quite a bit?   ");
   "other whitespace" >::
      ae "Fine. Be that way!" (response_for "\n\r \t");
   "non-question ending with whitespace" >::
      ae "Whatever." (response_for "This is a statement ending with whitespace      ");
]

let () =
  run_test_tt_main ("bob tests" >::: tests)