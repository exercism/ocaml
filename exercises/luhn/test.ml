open Core.Std
open OUnit2
open Luhn

let ae exp got _test_ctxt = assert_equal exp got

let tests = [
  "checksum of 4913"          >:: ae 22 (checksum "4913");
  "checksum of 201773"        >:: ae 21 (checksum "201773");
  "invalid number 1111"       >:: ae false (valid "1111");
  "invalid number 738"        >:: ae false (valid "738");
  "valid number 8739567"      >:: ae true (valid "8739567");
  "valid number 8763"         >:: ae true (valid "8763");
  "valid number long"         >:: ae true (valid "2323200577663554");
  "create valid number"       >:: ae "1230" (add_check_digit "123");
  "create large valid number" >:: ae "8739567" (add_check_digit "873956");
  "even larger valid number"  >:: ae "8372637564" (add_check_digit "837263756");
]

let () =
  run_test_tt_main ("luhn tests" >::: tests)
