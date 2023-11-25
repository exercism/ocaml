(* roman-numerals - 1.0 *)
open OUnit2
open Roman_numerals

let ae expected actual _ctx = assert_equal ~printer:(fun x -> x) expected actual

let tests = [
  "1 is I" >::
  ae "I" (to_roman 1);
  "2 is II" >::
  ae "II" (to_roman 2);
  "3 is III" >::
  ae "III" (to_roman 3);
  "4 is IV" >::
  ae "IV" (to_roman 4);
  "5 is V" >::
  ae "V" (to_roman 5);
  "6 is VI" >::
  ae "VI" (to_roman 6);
  "9 is IX" >::
  ae "IX" (to_roman 9);
  "16 is XVI" >::
  ae "XVI" (to_roman 16);
  "27 is XXVII" >::
  ae "XXVII" (to_roman 27);
  "48 is XLVIII" >::
  ae "XLVIII" (to_roman 48);
  "49 is XLIX" >::
  ae "XLIX" (to_roman 49);
  "59 is LIX" >::
  ae "LIX" (to_roman 59);
  "66 is LXVI" >::
  ae "LXVI" (to_roman 66);
  "93 is XCIII" >::
  ae "XCIII" (to_roman 93);
  "141 is CXLI" >::
  ae "CXLI" (to_roman 141);
  "163 is CLXIII" >::
  ae "CLXIII" (to_roman 163);
  "166 is CLXVI" >::
  ae "CLXVI" (to_roman 166);
  "402 is CDII" >::
  ae "CDII" (to_roman 402);
  "575 is DLXXV" >::
  ae "DLXXV" (to_roman 575);
  "666 is DCLXVI" >::
  ae "DCLXVI" (to_roman 666);
  "911 is CMXI" >::
  ae "CMXI" (to_roman 911);
  "1024 is MXXIV" >::
  ae "MXXIV" (to_roman 1024);
  "1666 is MDCLXVI" >::
  ae "MDCLXVI" (to_roman 1666);
  "3000 is MMM" >::
  ae "MMM" (to_roman 3000);
  "3001 is MMMI" >::
  ae "MMMI" (to_roman 3001);
  "3999 is MMMCMXCIX" >::
  ae "MMMCMXCIX" (to_roman 3999);
]

let () =
  run_test_tt_main ("roman-numerals test" >::: tests)
