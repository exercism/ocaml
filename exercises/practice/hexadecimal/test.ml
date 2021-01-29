open OUnit2
open Hexadecimal

let ae exp got _test_ctxt = assert_equal exp got

let tests = ["1 to 1"    >:: ae 1 (to_int "1");
             "c to 12"   >:: ae 12 (to_int "c");
             "10 to 16"  >:: ae 16 (to_int "10");
             "af to 175" >:: ae 175 (to_int "af");
             "100 to 256" >:: ae 256 (to_int "100");
             "19ace to 105166" >:: ae 105166 (to_int "19ace");
             "carrot to 0" >:: ae 0 (to_int "carrot");
             "000000 to 0" >:: ae 0 (to_int "000000");
             "ffffff to 16777215" >:: ae 16777215 (to_int "ffffff");
             "ffff00 to 16776960" >:: ae 16776960 (to_int "ffff00");
            ]

let () =
  run_test_tt_main ("hexidecimal tests" >::: tests)
