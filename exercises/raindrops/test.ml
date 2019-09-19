(* raindrops - 1.1.0 *)
open OUnit2
open Raindrops

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let tests = [
  "the sound for 1 is 1" >::
  ae "1" (raindrop 1);
  "the sound for 3 is Pling" >::
  ae "Pling" (raindrop 3);
  "the sound for 5 is Plang" >::
  ae "Plang" (raindrop 5);
  "the sound for 7 is Plong" >::
  ae "Plong" (raindrop 7);
  "the sound for 6 is Pling as it has a factor 3" >::
  ae "Pling" (raindrop 6);
  "2 to the power 3 does not make a raindrop sound as 3 is the exponent not the base" >::
  ae "8" (raindrop 8);
  "the sound for 9 is Pling as it has a factor 3" >::
  ae "Pling" (raindrop 9);
  "the sound for 10 is Plang as it has a factor 5" >::
  ae "Plang" (raindrop 10);
  "the sound for 14 is Plong as it has a factor of 7" >::
  ae "Plong" (raindrop 14);
  "the sound for 15 is PlingPlang as it has factors 3 and 5" >::
  ae "PlingPlang" (raindrop 15);
  "the sound for 21 is PlingPlong as it has factors 3 and 7" >::
  ae "PlingPlong" (raindrop 21);
  "the sound for 25 is Plang as it has a factor 5" >::
  ae "Plang" (raindrop 25);
  "the sound for 27 is Pling as it has a factor 3" >::
  ae "Pling" (raindrop 27);
  "the sound for 35 is PlangPlong as it has factors 5 and 7" >::
  ae "PlangPlong" (raindrop 35);
  "the sound for 49 is Plong as it has a factor 7" >::
  ae "Plong" (raindrop 49);
  "the sound for 52 is 52" >::
  ae "52" (raindrop 52);
  "the sound for 105 is PlingPlangPlong as it has factors 3, 5 and 7" >::
  ae "PlingPlangPlong" (raindrop 105);
  "the sound for 3125 is Plang as it has a factor 5" >::
  ae "Plang" (raindrop 3125);
]

let () =
  run_test_tt_main ("raindrops tests" >::: tests)
