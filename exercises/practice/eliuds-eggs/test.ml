open OUnit2
open Eliuds_eggs

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:string_of_int

let tests = [
  "0 eggs" >::
  ae 0 (egg_count 0);
  "1 egg" >::
  ae 1 (egg_count 16);
  "4 eggs" >::
  ae 4 (egg_count 89);
  "13 eggs" >::
  ae 13 (egg_count 2000000000);
]

let () =
  run_test_tt_main ("eliuds-eggs tests" >::: tests)
