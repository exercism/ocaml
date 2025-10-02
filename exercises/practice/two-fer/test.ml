open OUnit2
open Two_fer

let ae exp got _test_ctxt =
  assert_equal exp got

let tests = [
  "no name given" >::
  ae "One for you, one for me." (two_fer None);
  "a name given" >::
  ae "One for Alice, one for me." (two_fer (Some "Alice"));
  "another name given" >::
  ae "One for Bob, one for me." (two_fer (Some "Bob"));
]

let () =
  run_test_tt_main ("Two-fer tests" >::: tests)
