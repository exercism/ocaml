(* run-length-encoding - 1.1.0 *)
open Base
open OUnit2
open Run_length_encoding

let ae exp got _test_ctxt = assert_equal exp got ~printer:Fn.id

let encode_tests = [
  "empty string" >::
  ae "" ("" |> encode);
  "single characters only are encoded without count" >::
  ae "XYZ" ("XYZ" |> encode);
  "string with no single characters" >::
  ae "2A3B4C" ("AABBBCCCC" |> encode);
  "single characters mixed with repeated characters" >::
  ae "12WB12W3B24WB" ("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB" |> encode);
  "multiple whitespace mixed in string" >::
  ae "2 hs2q q2w2 " ("  hsqq qww  " |> encode);
  "lowercase characters" >::
  ae "2a3b4c" ("aabbbcccc" |> encode);
]
let decode_tests = [
  "empty string" >::
  ae "" ("" |> decode);
  "single characters only" >::
  ae "XYZ" ("XYZ" |> decode);
  "string with no single characters" >::
  ae "AABBBCCCC" ("2A3B4C" |> decode);
  "single characters with repeated characters" >::
  ae "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB" ("12WB12W3B24WB" |> decode);
  "multiple whitespace mixed in string" >::
  ae "  hsqq qww  " ("2 hs2q q2w2 " |> decode);
  "lower case string" >::
  ae "aabbbcccc" ("2a3b4c" |> decode);
]
let encode_and_then_decode_tests = [
  "encode followed by decode gives original string" >::
  ae "zzz ZZ  zZ" ("zzz ZZ  zZ" |> encode |> decode);
]


let () =
  run_test_tt_main (
    "run length encoding tests" >:::
    List.concat [
      encode_tests;
      decode_tests;
      encode_and_then_decode_tests;
    ]
  )
