open Core.Std
open OUnit2
open Run_length_encoding

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let (* SUITE *)$(suite_name)_tests = [
(* TEST
   "$description" >::
     ae $expected ($suite-name $input);
   END TEST *)
]
(* END SUITE *)

let () =
  run_test_tt_main (
    "run length encoding tests" >:::
      List.concat [(* suite-all-names *)]
  )
