open Core.Std
open OUnit2
open Atbash_cipher

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let (* SUITE encode *)encode_tests = [
(* TEST
   "$description" >::
     ae $expected (encode $phrase);
   END TEST *)
]
(* END SUITE *)

let (* SUITE decode *)decode_tests = [
(* TEST
   "$description" >::
     ae $expected (decode $phrase);
   END TEST *)
]
(* END SUITE *)

let different_block_size_test = [
  "encode mindblowingly with a different block size" >::
    ae "n r m w y o l d r m t o b" (encode ~block_size:1 "mindblowingly");
]

let () =
  run_test_tt_main (
    "atbash-cipher tests" >:::
      List.concat [encode_tests; decode_tests; different_block_size_test]
  )
