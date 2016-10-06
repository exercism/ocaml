open Core.Std
open OUnit2
open Raindrops

let ae exp got _test_ctxt = assert_equal exp got

let tests =
  [
    "raindrop 1">::
    ae "1" (raindrop 1);
    "raindrop 3">::
    ae "Pling" (raindrop 3);
    "raindrop 5">::
    ae "Plang" (raindrop 5);
    "raindrop 7">::
    ae "Plong" (raindrop 7);
    "raindrop 6">::
    ae "Pling" (raindrop 6);
    "raindrop 8">::
    ae "8" (raindrop 8);
    "raindrop 9">::
    ae "Pling" (raindrop 9);
    "raindrop 10">::
    ae "Plang" (raindrop 10);
    "raindrop 14">::
    ae "Plong" (raindrop 14);
    "raindrop 15">::
    ae "PlingPlang" (raindrop 15);
    "raindrop 21">::
    ae "PlingPlong" (raindrop 21);
    "raindrop 25">::
    ae "Plang" (raindrop 25);
    "raindrop 27">::
    ae "Pling" (raindrop 27);
    "raindrop 35">::
    ae "PlangPlong" (raindrop 35);
    "raindrop 49">::
    ae "Plong" (raindrop 49);
    "raindrop 52">::
    ae "52" (raindrop 52);
    "raindrop 105">::
    ae "PlingPlangPlong" (raindrop 105);
    "raindrop 3125">::
    ae "Plang" (raindrop 3125);
]

let () =
  run_test_tt_main ("raindrops tests" >::: tests)
