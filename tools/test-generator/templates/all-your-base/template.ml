open Core.Std
open OUnit2
open All_your_bases

let ae exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let tests = [
  (* TEST
     "$description" >::
      ae $expected (convert_bases $input_base $input_digits $output_base);
     END TEST *)
]

let () =
  run_test_tt_main ("all-your-bases tests" >::: tests)
