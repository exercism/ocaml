open Core.Std
open OUnit2
open Beer_song

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let (* SUITE *)$(suite_name)_tests = [
(* TEST
   "$description" >::
     ae $expected ($suite-name $number);
   END TEST *)
]
(* END SUITE *)

let () =
  run_test_tt_main (
    "beer song tests" >:::
      List.concat [(* suite-all-names *)]
  )
