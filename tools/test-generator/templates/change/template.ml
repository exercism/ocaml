open Core
open OUnit2
open Change

let printer = Option.value_map ~default:"None" ~f:(List.to_string ~f:Int.to_string)
let ae exp got _test_ctxt = assert_equal ~printer exp got

let tests = [
(* TEST
   "$description" >::
     ae $expected 
       (make_change ~target:$target ~coins:$coins);
   END TEST *)
]

let () =
  run_test_tt_main ("change tests" >::: tests)
