(* atbash-cipher - 1.2.0 *)
open OUnit2
open Atbash_cipher

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

let encode_tests = [
  "encode yes" >::
  ae "bvh" (encode "yes");
  "encode no" >::
  ae "ml" (encode "no");
  "encode OMG" >::
  ae "lnt" (encode "OMG");
  "encode spaces" >::
  ae "lnt" (encode "O M G");
  "encode mindblowingly" >::
  ae "nrmwy oldrm tob" (encode "mindblowingly");
  "encode numbers" >::
  ae "gvhgr mt123 gvhgr mt" (encode "Testing,1 2 3, testing.");
  "encode deep thought" >::
  ae "gifgs rhurx grlm" (encode "Truth is fiction.");
  "encode all the letters" >::
  ae "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt" (encode "The quick brown fox jumps over the lazy dog.");
]


let decode_tests = [
  "decode exercism" >::
  ae "exercism" (decode "vcvix rhn");
  "decode a sentence" >::
  ae "anobstacleisoftenasteppingstone" (decode "zmlyh gzxov rhlug vmzhg vkkrm thglm v");
  "decode numbers" >::
  ae "testing123testing" (decode "gvhgr mt123 gvhgr mt");
  "decode all the letters" >::
  ae "thequickbrownfoxjumpsoverthelazydog" (decode "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt");
  "decode with too many spaces" >::
  ae "exercism" (decode "vc vix    r hn");
  "decode with no spaces" >::
  ae "anobstacleisoftenasteppingstone" (decode "zmlyhgzxovrhlugvmzhgvkkrmthglmv");
]



let different_block_size_test = [
  "encode mindblowingly with a different block size" >::
  ae "n r m w y o l d r m t o b" (encode ~block_size:1 "mindblowingly");
]

let () =
  run_test_tt_main (
    "atbash-cipher tests" >:::
    List.concat [encode_tests; decode_tests; different_block_size_test]
  )
