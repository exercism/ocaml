open Core.Std
open OUnit2
open Etl


let ae exp got _test_ctxt =
  let sexpr_of l = List.sexp_of_t (Tuple2.sexp_of_t Char.sexp_of_t Int.sexp_of_t) l in
  let printer l = Sexp.to_string (sexpr_of l) in
  assert_equal exp got ~printer

let tests =
  ["transform one character">::
   ae [('A', 1)] (transform [(1,['A'])]);
   "transform multiple characters">::
   ae [('A', 1);('E', 1);('I', 1);('O', 1);('U', 1)] (transform [(1, ['A';'E';'I';'O';'U'])]);
   "transform multiple values">::
   ae [('A',1);('D',2);('E',1);('G',2);('I',1);('O',1);('U',1)] (transform [(1, ['A';'E';'I';'O';'U']);
                                                                            (2, ['D';'G'])]);
   "transform full dataset">::
   ae [('A',1);('B',3);('C',3);('D',2);('E',1);
       ('F',4);('G',2);('H',4);('I',1);('J',8);
       ('K',5);('L',1);('M',3);('N',1);('O',1);
       ('P',3);('Q',10);('R',1);('S',1);('T',1);
       ('U',1);('V',4);('W',4);('X',8);('Y',4);
       ('Z',10)] (transform [(1,['A';'E';'I';'O';'U';'L';'N';'R';'S';'T']);
                            (2,['D';'G']);
                            (3,['B';'C';'M';'P']);
                            (4,['F';'H';'V';'W';'Y']);
                            (5,['K']);
                            (8,['J';'X']);
                            (10,['Q';'Z'])]);
  ]

let () =
  run_test_tt_main ("etl tests" >::: tests)
