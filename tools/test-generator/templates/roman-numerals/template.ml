open Core
open OUnit2
open Roman_numerals

let ae expected actual _ctx = assert_equal ~printer:Fn.id expected actual

let tests = [
(* TEST
   "$description" >::
      ae $expected (to_roman $number);
   END TEST *)
]

let () =
    run_test_tt_main ("roman-numerals test" >::: tests) 
