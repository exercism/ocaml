open Core.Std
open OUnit2
open Etl

let ae exp got _test_ctxt = assert_equal exp got

let tests =
  ["transform one character">::
   ae [('A', 1)] (transform [(1,['A'])]);
   "transform multiple characters">::
   ae [('A', 1);('E', 1);('I', 1);('O', 1);('U', 1)] (transform [(1, ['A';'E';'I';'O';'U'])]);
   "transform multiple values">::
   ae [('A',1);('D',2);('E',1);('G',2);('I',1);('O',1);('U',1)] (transform [(1, ['A';'E';'I';'O';'U']);
                                                                            (2, ['D';'G'])])

  ]

let () =
  run_test_tt_main ("etl tests" >::: tests)
