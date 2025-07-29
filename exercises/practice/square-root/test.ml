open OUnit2
open Square_root

let ae expected actual _test_ctxt =
  assert_equal expected actual ~printer:string_of_int

let tests = [
  "root of 1" >::
  ae 1 (square_root (1));
  "root of 4" >::
  ae 2 (square_root (4));
  "root of 25" >::
  ae 5 (square_root (25));
  "root of 81" >::
  ae 9 (square_root (81));
  "root of 196" >::
  ae 14 (square_root (196));
  "root of 65025" >::
  ae 255 (square_root (65025));
]

let () =
  run_test_tt_main ("square-root tests" >::: tests)
