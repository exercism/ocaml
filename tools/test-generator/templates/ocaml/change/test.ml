open Base
open OUnit2
open Change

let printer = Option.value_map ~default:"None" ~f:(fun xs -> String.concat ~sep:";" (List.map ~f:Int.to_string xs))
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
