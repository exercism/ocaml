open Core.Std
open OUnit2
open Hello_world

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests = [
     "no name" >:: ae "Hello, World!" (greet None);
     "sample name" >:: ae "Hello, Alice!" (greet (Some "Alice"));
     "other sample name" >:: ae "Hello, Bob!" (greet (Some "Bob"));
]

let () =
  run_test_tt_main ("Hello World tests" >::: tests)