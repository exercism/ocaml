open Core.Std
open OUnit2
open Run_length_encoding

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let encode_tests = [
   "empty string" >::
     ae "" (encode "");
   "single characters only are encoded without count" >::
     ae "XYZ" (encode "XYZ");
   "string with no single characters" >::
     ae "2A3B4C" (encode "AABBBCCCC");
   "single characters mixed with repeated characters" >::
     ae "12WB12W3B24WB" (encode "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");
]

let decode_tests = [
   "empty string" >::
     ae "" (decode "");
   "single characters only" >::
     ae "XYZ" (decode "XYZ");
   "string with no single characters" >::
     ae "AABBBCCCC" (decode "2A3B4C");
   "single characters with repeated characters" >::
     ae "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB" (decode "12WB12W3B24WB");
]

let consistency_tests = [
   "encode followed by decode gives original string" >::
     ae "zzz ZZ  zZ" (decode (encode "zzz ZZ  zZ"));
]

let () =
  run_test_tt_main (
    "run length encoding tests" >:::
      List.concat [encode_tests; decode_tests; consistency_tests]
  )