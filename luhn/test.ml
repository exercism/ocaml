open Core.Std
open OUnit2
open Luhn

let ae exp got _test_ctxt = assert_equal exp got

let tests = ["invalid number 1111"  >:: ae false (valid "1111");
             "invalid number 738"   >:: ae false (valid "738");
             "valid number 8739567" >:: ae true (valid "8739567");
             "valid number 8763"    >:: ae true (valid "8763");
             "valid number long"    >:: ae true (valid "2323200577663554");
            ]

let () =
  run_test_tt_main ("luhn tests" >::: tests)
