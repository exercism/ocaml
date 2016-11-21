open Core.Std
open OUnit2
open Leap

let ae exp got _test_ctxt = assert_equal exp got

let tests = [
(* GENERATED-CODE
  "$name" >::
    ae $expected (leap_year $input);
END GENERATED-CODE *)
]

let () =
  run_test_tt_main ("leap tests" >::: tests)
