open Core.Std
open OUnit2
open Hello_world

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests = [
  (* TEST
     "$description" >:: ae "$expected" (greet $name);
     END TEST *)
]

let () =
  run_test_tt_main ("Hello World tests" >::: tests)
