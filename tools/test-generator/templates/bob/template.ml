open Core.Std
open OUnit2
open Bob

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests = [
(* GENERATED-CODE
   "$name" >::
      ae "$expected" (response_for "$input");
   END GENERATED-CODE *)
]

let () =
  run_test_tt_main ("bob tests" >::: tests)
