open Core.Std
open OUnit2
open Atbash_cipher

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests =
  ["encode yes">::
   ae "bvh" (encode "yes");
   "encode no">::
   ae "ml" (encode "no");
   "encode OMG">::
   ae "lnt" (encode "OMG");
   "encode spaces">::
   ae "lnt" (encode "O M G");
   "encode mindblowingly">::
   ae "nrmwy oldrm tob" (encode "mindblowingly");
   "encode numbers">::
   ae "gvhgr mt123 gvhgr mt" (encode "Testing,1 2 3, testing.");
   "encode deep thought">::
   ae "gifgs rhurx grlm" (encode "Truth is fiction.");
   "encode all the letters">::
   ae "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt" (encode "The quick brown fox jumps over the lazy dog.");
   "encode ignores non ascii">::
   ae "mlmzh xrrrt mlivw" (encode "non ascii éignored");
   "encode mindblowingly with a different block size">::
   ae "n r m w y o l d r m t o b" (encode ~block_size:1 "mindblowingly");
   "decode exercism">::
   ae "exercism" (decode "vcvix rhn");
   "decode a sentence">::
   ae "anobstacleisoftenasteppingstone" (decode "zmlyh gzxov rhlug vmzhg vkkrm thglm v");
   "decode all the letters">::
   ae "thequickbrownfoxjumpsoverthelazydog" (decode "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt");
  ]

let () =
  run_test_tt_main ("atbash cipher" >::: tests)
