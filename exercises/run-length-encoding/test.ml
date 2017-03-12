open Core.Std
open OUnit2
open Run_length_encoding

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let run_length_encode_a_string_tests = [
   "empty string" >::
     ae "" (encode "");
   "single characters only are encoded without count" >::
     ae "XYZ" (encode "XYZ");
   "string with no single characters" >::
     ae "2A3B4C" (encode "AABBBCCCC");
   "single characters mixed with repeated characters" >::
     ae "12WB12W3B24WB" (encode "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");
   "multiple whitespace mixed in string" >::
     ae "2 hs2q q2w2 " (encode "  hsqq qww  ");
   "lowercase characters" >::
     ae "2a3b4c" (encode "aabbbcccc");
]

let run_length_decode_a_string_tests = [
   "empty string" >::
     ae "" (decode "");
   "single characters only" >::
     ae "XYZ" (decode "XYZ");
   "string with no single characters" >::
     ae "AABBBCCCC" (decode "2A3B4C");
   "single characters with repeated characters" >::
     ae "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB" (decode "12WB12W3B24WB");
   "multiple whitespace mixed in string" >::
     ae "  hsqq qww  " (decode "2 hs2q q2w2 ");
   "lower case string" >::
     ae "aabbbcccc" (decode "2a3b4c");
]

let encode_and_then_decode_tests = [
   "encode followed by decode gives original string" >::
     ae "zzz ZZ  zZ" (decode @@ encode "zzz ZZ  zZ");
]

let () =
  run_test_tt_main (
    "run length encoding tests" >:::
      List.concat [run_length_encode_a_string_tests; run_length_decode_a_string_tests; encode_and_then_decode_tests]
  )