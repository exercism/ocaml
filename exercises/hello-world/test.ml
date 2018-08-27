open OUnit2
open Hello_world

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let tests = [
     "Say Hi!" >:: ae "Hello, World!" hello;
]

let () =
  run_test_tt_main ("Hello World tests" >::: tests)
