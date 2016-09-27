open Core.Std
open OUnit2
open Roman_numerals

let checks exp inp _ctx = assert_equal ~printer:Fn.id  exp (to_roman inp)

let tests =   
    [ "1 to I"         >:: checks "I"   1
    ; "2 to II"        >:: checks "II"  2
    ; "3 to III"       >:: checks "III" 3
    ; "4 to IV"        >:: checks "IV"  4
    ; "5 to V"         >:: checks "V"   5
    ; "6 to VI"        >:: checks "VI"  6
    ; "9 to IX"        >:: checks "IX"  9
    ; "27 to XXVII"    >:: checks "XXVII"  27
    ; "48 to XLVIII"   >:: checks "XLVIII" 48
    ; "59 to LIX"      >:: checks "LIX"    59
    ; "93 to XCIII"    >:: checks "XCIII"  93
    ; "141 to CXLI"    >:: checks "CXLI"   141
    ; "163 to CLXIII"  >:: checks "CLXIII" 163
    ; "402 to CDII"    >:: checks "CDII"   402
    ; "575 to DLXXV"   >:: checks "DLXXV"  575
    ; "911 to CMXI"    >:: checks "CMXI"   911
    ; "1024 to MXXIV"  >:: checks "MXXIV"  1024
    ; "3000 to MMM"    >:: checks "MMM"    3000
    ]

let () =
    run_test_tt_main ("roman-numerals test" >::: tests) 
